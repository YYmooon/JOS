
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 9b 01 00 00       	call   8001cc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 3c             	sub    $0x3c,%esp
  80003d:	8b 75 08             	mov    0x8(%ebp),%esi
  800040:	8b 7d 0c             	mov    0xc(%ebp),%edi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800043:	8d 5d e7             	lea    -0x19(%ebp),%ebx
  800046:	e9 81 00 00 00       	jmp    8000cc <num+0x98>
		if (bol) {
  80004b:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  800052:	74 27                	je     80007b <num+0x47>
			printf("%5d ", ++line);
  800054:	a1 00 40 80 00       	mov    0x804000,%eax
  800059:	83 c0 01             	add    $0x1,%eax
  80005c:	a3 00 40 80 00       	mov    %eax,0x804000
  800061:	89 44 24 04          	mov    %eax,0x4(%esp)
  800065:	c7 04 24 60 24 80 00 	movl   $0x802460,(%esp)
  80006c:	e8 18 1a 00 00       	call   801a89 <printf>
			bol = 0;
  800071:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800078:	00 00 00 
		}
		if ((r = write(1, &c, 1)) != 1)
  80007b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800082:	00 
  800083:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80008e:	e8 cb 14 00 00       	call   80155e <write>
  800093:	83 f8 01             	cmp    $0x1,%eax
  800096:	74 24                	je     8000bc <num+0x88>
			panic("write error copying %s: %e", s, r);
  800098:	89 44 24 10          	mov    %eax,0x10(%esp)
  80009c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000a0:	c7 44 24 08 65 24 80 	movl   $0x802465,0x8(%esp)
  8000a7:	00 
  8000a8:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000af:	00 
  8000b0:	c7 04 24 80 24 80 00 	movl   $0x802480,(%esp)
  8000b7:	e8 7c 01 00 00       	call   800238 <_panic>
		if (c == '\n')
  8000bc:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8000c0:	75 0a                	jne    8000cc <num+0x98>
			bol = 1;
  8000c2:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c9:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d3:	00 
  8000d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d8:	89 34 24             	mov    %esi,(%esp)
  8000db:	e8 9e 13 00 00       	call   80147e <read>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	0f 8f 63 ff ff ff    	jg     80004b <num+0x17>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	79 24                	jns    800110 <num+0xdc>
		panic("error reading %s: %e", s, n);
  8000ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000f4:	c7 44 24 08 8b 24 80 	movl   $0x80248b,0x8(%esp)
  8000fb:	00 
  8000fc:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  800103:	00 
  800104:	c7 04 24 80 24 80 00 	movl   $0x802480,(%esp)
  80010b:	e8 28 01 00 00       	call   800238 <_panic>
}
  800110:	83 c4 3c             	add    $0x3c,%esp
  800113:	5b                   	pop    %ebx
  800114:	5e                   	pop    %esi
  800115:	5f                   	pop    %edi
  800116:	5d                   	pop    %ebp
  800117:	c3                   	ret    

00800118 <umain>:

void
umain(int argc, char **argv)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	83 ec 3c             	sub    $0x3c,%esp
	int f, i;

	binaryname = "num";
  800121:	c7 05 04 30 80 00 a0 	movl   $0x8024a0,0x803004
  800128:	24 80 00 
	if (argc == 1)
  80012b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80012f:	74 13                	je     800144 <umain+0x2c>
	if (n < 0)
		panic("error reading %s: %e", s, n);
}

void
umain(int argc, char **argv)
  800131:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800134:	83 c3 04             	add    $0x4,%ebx
  800137:	bf 01 00 00 00       	mov    $0x1,%edi

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80013c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800140:	7f 18                	jg     80015a <umain+0x42>
  800142:	eb 7b                	jmp    8001bf <umain+0xa7>
{
	int f, i;

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
  800144:	c7 44 24 04 a4 24 80 	movl   $0x8024a4,0x4(%esp)
  80014b:	00 
  80014c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800153:	e8 dc fe ff ff       	call   800034 <num>
  800158:	eb 65                	jmp    8001bf <umain+0xa7>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  80015a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80015d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800164:	00 
  800165:	8b 03                	mov    (%ebx),%eax
  800167:	89 04 24             	mov    %eax,(%esp)
  80016a:	e8 7d 17 00 00       	call   8018ec <open>
  80016f:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800171:	85 c0                	test   %eax,%eax
  800173:	79 29                	jns    80019e <umain+0x86>
				panic("can't open %s: %e", argv[i], f);
  800175:	89 44 24 10          	mov    %eax,0x10(%esp)
  800179:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80017c:	8b 02                	mov    (%edx),%eax
  80017e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800182:	c7 44 24 08 ac 24 80 	movl   $0x8024ac,0x8(%esp)
  800189:	00 
  80018a:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  800191:	00 
  800192:	c7 04 24 80 24 80 00 	movl   $0x802480,(%esp)
  800199:	e8 9a 00 00 00       	call   800238 <_panic>
			else {
				num(f, argv[i]);
  80019e:	8b 03                	mov    (%ebx),%eax
  8001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a4:	89 34 24             	mov    %esi,(%esp)
  8001a7:	e8 88 fe ff ff       	call   800034 <num>
				close(f);
  8001ac:	89 34 24             	mov    %esi,(%esp)
  8001af:	e8 59 11 00 00       	call   80130d <close>

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8001b4:	83 c7 01             	add    $0x1,%edi
  8001b7:	83 c3 04             	add    $0x4,%ebx
  8001ba:	3b 7d 08             	cmp    0x8(%ebp),%edi
  8001bd:	75 9b                	jne    80015a <umain+0x42>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8001bf:	e8 58 00 00 00       	call   80021c <exit>
}
  8001c4:	83 c4 3c             	add    $0x3c,%esp
  8001c7:	5b                   	pop    %ebx
  8001c8:	5e                   	pop    %esi
  8001c9:	5f                   	pop    %edi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    

008001cc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	83 ec 18             	sub    $0x18,%esp
  8001d2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001d5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8001db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8001de:	e8 09 0c 00 00       	call   800dec <sys_getenvid>
  8001e3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f0:	a3 08 40 80 00       	mov    %eax,0x804008
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f5:	85 f6                	test   %esi,%esi
  8001f7:	7e 07                	jle    800200 <libmain+0x34>
		binaryname = argv[0];
  8001f9:	8b 03                	mov    (%ebx),%eax
  8001fb:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800200:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800204:	89 34 24             	mov    %esi,(%esp)
  800207:	e8 0c ff ff ff       	call   800118 <umain>

	// exit gracefully
	exit();
  80020c:	e8 0b 00 00 00       	call   80021c <exit>
}
  800211:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800214:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800217:	89 ec                	mov    %ebp,%esp
  800219:	5d                   	pop    %ebp
  80021a:	c3                   	ret    
	...

0080021c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800222:	e8 17 11 00 00       	call   80133e <close_all>
	sys_env_destroy(0);
  800227:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80022e:	e8 5c 0b 00 00       	call   800d8f <sys_env_destroy>
}
  800233:	c9                   	leave  
  800234:	c3                   	ret    
  800235:	00 00                	add    %al,(%eax)
	...

00800238 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800240:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800243:	8b 1d 04 30 80 00    	mov    0x803004,%ebx
  800249:	e8 9e 0b 00 00       	call   800dec <sys_getenvid>
  80024e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800251:	89 54 24 10          	mov    %edx,0x10(%esp)
  800255:	8b 55 08             	mov    0x8(%ebp),%edx
  800258:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80025c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800260:	89 44 24 04          	mov    %eax,0x4(%esp)
  800264:	c7 04 24 c8 24 80 00 	movl   $0x8024c8,(%esp)
  80026b:	e8 c3 00 00 00       	call   800333 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800270:	89 74 24 04          	mov    %esi,0x4(%esp)
  800274:	8b 45 10             	mov    0x10(%ebp),%eax
  800277:	89 04 24             	mov    %eax,(%esp)
  80027a:	e8 53 00 00 00       	call   8002d2 <vcprintf>
	cprintf("\n");
  80027f:	c7 04 24 e7 28 80 00 	movl   $0x8028e7,(%esp)
  800286:	e8 a8 00 00 00       	call   800333 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80028b:	cc                   	int3   
  80028c:	eb fd                	jmp    80028b <_panic+0x53>
	...

00800290 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	53                   	push   %ebx
  800294:	83 ec 14             	sub    $0x14,%esp
  800297:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80029a:	8b 03                	mov    (%ebx),%eax
  80029c:	8b 55 08             	mov    0x8(%ebp),%edx
  80029f:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002a3:	83 c0 01             	add    $0x1,%eax
  8002a6:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002a8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ad:	75 19                	jne    8002c8 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002af:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002b6:	00 
  8002b7:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ba:	89 04 24             	mov    %eax,(%esp)
  8002bd:	e8 6e 0a 00 00       	call   800d30 <sys_cputs>
		b->idx = 0;
  8002c2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002c8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002cc:	83 c4 14             	add    $0x14,%esp
  8002cf:	5b                   	pop    %ebx
  8002d0:	5d                   	pop    %ebp
  8002d1:	c3                   	ret    

008002d2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e2:	00 00 00 
	b.cnt = 0;
  8002e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800303:	89 44 24 04          	mov    %eax,0x4(%esp)
  800307:	c7 04 24 90 02 80 00 	movl   $0x800290,(%esp)
  80030e:	e8 97 01 00 00       	call   8004aa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800313:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800319:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800323:	89 04 24             	mov    %eax,(%esp)
  800326:	e8 05 0a 00 00       	call   800d30 <sys_cputs>

	return b.cnt;
}
  80032b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800331:	c9                   	leave  
  800332:	c3                   	ret    

00800333 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800339:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80033c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800340:	8b 45 08             	mov    0x8(%ebp),%eax
  800343:	89 04 24             	mov    %eax,(%esp)
  800346:	e8 87 ff ff ff       	call   8002d2 <vcprintf>
	va_end(ap);

	return cnt;
}
  80034b:	c9                   	leave  
  80034c:	c3                   	ret    
  80034d:	00 00                	add    %al,(%eax)
	...

00800350 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	57                   	push   %edi
  800354:	56                   	push   %esi
  800355:	53                   	push   %ebx
  800356:	83 ec 3c             	sub    $0x3c,%esp
  800359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035c:	89 d7                	mov    %edx,%edi
  80035e:	8b 45 08             	mov    0x8(%ebp),%eax
  800361:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800364:	8b 45 0c             	mov    0xc(%ebp),%eax
  800367:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80036a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80036d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800370:	b8 00 00 00 00       	mov    $0x0,%eax
  800375:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800378:	72 11                	jb     80038b <printnum+0x3b>
  80037a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80037d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800380:	76 09                	jbe    80038b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800382:	83 eb 01             	sub    $0x1,%ebx
  800385:	85 db                	test   %ebx,%ebx
  800387:	7f 51                	jg     8003da <printnum+0x8a>
  800389:	eb 5e                	jmp    8003e9 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80038b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80038f:	83 eb 01             	sub    $0x1,%ebx
  800392:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800396:	8b 45 10             	mov    0x10(%ebp),%eax
  800399:	89 44 24 08          	mov    %eax,0x8(%esp)
  80039d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8003a1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8003a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003ac:	00 
  8003ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003b0:	89 04 24             	mov    %eax,(%esp)
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ba:	e8 e1 1d 00 00       	call   8021a0 <__udivdi3>
  8003bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003c3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003c7:	89 04 24             	mov    %eax,(%esp)
  8003ca:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003ce:	89 fa                	mov    %edi,%edx
  8003d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d3:	e8 78 ff ff ff       	call   800350 <printnum>
  8003d8:	eb 0f                	jmp    8003e9 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003de:	89 34 24             	mov    %esi,(%esp)
  8003e1:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e4:	83 eb 01             	sub    $0x1,%ebx
  8003e7:	75 f1                	jne    8003da <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ed:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003ff:	00 
  800400:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800403:	89 04 24             	mov    %eax,(%esp)
  800406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800409:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040d:	e8 be 1e 00 00       	call   8022d0 <__umoddi3>
  800412:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800416:	0f be 80 eb 24 80 00 	movsbl 0x8024eb(%eax),%eax
  80041d:	89 04 24             	mov    %eax,(%esp)
  800420:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800423:	83 c4 3c             	add    $0x3c,%esp
  800426:	5b                   	pop    %ebx
  800427:	5e                   	pop    %esi
  800428:	5f                   	pop    %edi
  800429:	5d                   	pop    %ebp
  80042a:	c3                   	ret    

0080042b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80042e:	83 fa 01             	cmp    $0x1,%edx
  800431:	7e 0e                	jle    800441 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800433:	8b 10                	mov    (%eax),%edx
  800435:	8d 4a 08             	lea    0x8(%edx),%ecx
  800438:	89 08                	mov    %ecx,(%eax)
  80043a:	8b 02                	mov    (%edx),%eax
  80043c:	8b 52 04             	mov    0x4(%edx),%edx
  80043f:	eb 22                	jmp    800463 <getuint+0x38>
	else if (lflag)
  800441:	85 d2                	test   %edx,%edx
  800443:	74 10                	je     800455 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800445:	8b 10                	mov    (%eax),%edx
  800447:	8d 4a 04             	lea    0x4(%edx),%ecx
  80044a:	89 08                	mov    %ecx,(%eax)
  80044c:	8b 02                	mov    (%edx),%eax
  80044e:	ba 00 00 00 00       	mov    $0x0,%edx
  800453:	eb 0e                	jmp    800463 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800455:	8b 10                	mov    (%eax),%edx
  800457:	8d 4a 04             	lea    0x4(%edx),%ecx
  80045a:	89 08                	mov    %ecx,(%eax)
  80045c:	8b 02                	mov    (%edx),%eax
  80045e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800463:	5d                   	pop    %ebp
  800464:	c3                   	ret    

00800465 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80046b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80046f:	8b 10                	mov    (%eax),%edx
  800471:	3b 50 04             	cmp    0x4(%eax),%edx
  800474:	73 0a                	jae    800480 <sprintputch+0x1b>
		*b->buf++ = ch;
  800476:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800479:	88 0a                	mov    %cl,(%edx)
  80047b:	83 c2 01             	add    $0x1,%edx
  80047e:	89 10                	mov    %edx,(%eax)
}
  800480:	5d                   	pop    %ebp
  800481:	c3                   	ret    

00800482 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800488:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80048b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80048f:	8b 45 10             	mov    0x10(%ebp),%eax
  800492:	89 44 24 08          	mov    %eax,0x8(%esp)
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
  800499:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	89 04 24             	mov    %eax,(%esp)
  8004a3:	e8 02 00 00 00       	call   8004aa <vprintfmt>
	va_end(ap);
}
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	57                   	push   %edi
  8004ae:	56                   	push   %esi
  8004af:	53                   	push   %ebx
  8004b0:	83 ec 4c             	sub    $0x4c,%esp
  8004b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004b6:	8b 75 10             	mov    0x10(%ebp),%esi
  8004b9:	eb 12                	jmp    8004cd <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	0f 84 a9 03 00 00    	je     80086c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  8004c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004c7:	89 04 24             	mov    %eax,(%esp)
  8004ca:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004cd:	0f b6 06             	movzbl (%esi),%eax
  8004d0:	83 c6 01             	add    $0x1,%esi
  8004d3:	83 f8 25             	cmp    $0x25,%eax
  8004d6:	75 e3                	jne    8004bb <vprintfmt+0x11>
  8004d8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004dc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004e3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  8004e8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004f4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004f7:	eb 2b                	jmp    800524 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f9:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004fc:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800500:	eb 22                	jmp    800524 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800502:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800505:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800509:	eb 19                	jmp    800524 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80050e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800515:	eb 0d                	jmp    800524 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800517:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80051a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80051d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800524:	0f b6 06             	movzbl (%esi),%eax
  800527:	0f b6 d0             	movzbl %al,%edx
  80052a:	8d 7e 01             	lea    0x1(%esi),%edi
  80052d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800530:	83 e8 23             	sub    $0x23,%eax
  800533:	3c 55                	cmp    $0x55,%al
  800535:	0f 87 0b 03 00 00    	ja     800846 <vprintfmt+0x39c>
  80053b:	0f b6 c0             	movzbl %al,%eax
  80053e:	ff 24 85 20 26 80 00 	jmp    *0x802620(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800545:	83 ea 30             	sub    $0x30,%edx
  800548:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80054b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80054f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800552:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800555:	83 fa 09             	cmp    $0x9,%edx
  800558:	77 4a                	ja     8005a4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80055d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800560:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800563:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800567:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80056a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80056d:	83 fa 09             	cmp    $0x9,%edx
  800570:	76 eb                	jbe    80055d <vprintfmt+0xb3>
  800572:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800575:	eb 2d                	jmp    8005a4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8d 50 04             	lea    0x4(%eax),%edx
  80057d:	89 55 14             	mov    %edx,0x14(%ebp)
  800580:	8b 00                	mov    (%eax),%eax
  800582:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800585:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800588:	eb 1a                	jmp    8005a4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80058d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800591:	79 91                	jns    800524 <vprintfmt+0x7a>
  800593:	e9 73 ff ff ff       	jmp    80050b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800598:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80059b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005a2:	eb 80                	jmp    800524 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8005a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a8:	0f 89 76 ff ff ff    	jns    800524 <vprintfmt+0x7a>
  8005ae:	e9 64 ff ff ff       	jmp    800517 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005b3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005b9:	e9 66 ff ff ff       	jmp    800524 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8d 50 04             	lea    0x4(%eax),%edx
  8005c4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005cb:	8b 00                	mov    (%eax),%eax
  8005cd:	89 04 24             	mov    %eax,(%esp)
  8005d0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8005d6:	e9 f2 fe ff ff       	jmp    8004cd <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8d 50 04             	lea    0x4(%eax),%edx
  8005e1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	89 c2                	mov    %eax,%edx
  8005e8:	c1 fa 1f             	sar    $0x1f,%edx
  8005eb:	31 d0                	xor    %edx,%eax
  8005ed:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005ef:	83 f8 0f             	cmp    $0xf,%eax
  8005f2:	7f 0b                	jg     8005ff <vprintfmt+0x155>
  8005f4:	8b 14 85 80 27 80 00 	mov    0x802780(,%eax,4),%edx
  8005fb:	85 d2                	test   %edx,%edx
  8005fd:	75 23                	jne    800622 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  8005ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800603:	c7 44 24 08 03 25 80 	movl   $0x802503,0x8(%esp)
  80060a:	00 
  80060b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80060f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800612:	89 3c 24             	mov    %edi,(%esp)
  800615:	e8 68 fe ff ff       	call   800482 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80061d:	e9 ab fe ff ff       	jmp    8004cd <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800622:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800626:	c7 44 24 08 b5 28 80 	movl   $0x8028b5,0x8(%esp)
  80062d:	00 
  80062e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800632:	8b 7d 08             	mov    0x8(%ebp),%edi
  800635:	89 3c 24             	mov    %edi,(%esp)
  800638:	e8 45 fe ff ff       	call   800482 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800640:	e9 88 fe ff ff       	jmp    8004cd <vprintfmt+0x23>
  800645:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800648:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80064b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8d 50 04             	lea    0x4(%eax),%edx
  800654:	89 55 14             	mov    %edx,0x14(%ebp)
  800657:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800659:	85 f6                	test   %esi,%esi
  80065b:	ba fc 24 80 00       	mov    $0x8024fc,%edx
  800660:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800663:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800667:	7e 06                	jle    80066f <vprintfmt+0x1c5>
  800669:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80066d:	75 10                	jne    80067f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066f:	0f be 06             	movsbl (%esi),%eax
  800672:	83 c6 01             	add    $0x1,%esi
  800675:	85 c0                	test   %eax,%eax
  800677:	0f 85 86 00 00 00    	jne    800703 <vprintfmt+0x259>
  80067d:	eb 76                	jmp    8006f5 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80067f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800683:	89 34 24             	mov    %esi,(%esp)
  800686:	e8 90 02 00 00       	call   80091b <strnlen>
  80068b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80068e:	29 c2                	sub    %eax,%edx
  800690:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800693:	85 d2                	test   %edx,%edx
  800695:	7e d8                	jle    80066f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800697:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80069b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80069e:	89 d6                	mov    %edx,%esi
  8006a0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8006a3:	89 c7                	mov    %eax,%edi
  8006a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006a9:	89 3c 24             	mov    %edi,(%esp)
  8006ac:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006af:	83 ee 01             	sub    $0x1,%esi
  8006b2:	75 f1                	jne    8006a5 <vprintfmt+0x1fb>
  8006b4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006b7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8006ba:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8006bd:	eb b0                	jmp    80066f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006c3:	74 18                	je     8006dd <vprintfmt+0x233>
  8006c5:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006c8:	83 fa 5e             	cmp    $0x5e,%edx
  8006cb:	76 10                	jbe    8006dd <vprintfmt+0x233>
					putch('?', putdat);
  8006cd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006d1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006d8:	ff 55 08             	call   *0x8(%ebp)
  8006db:	eb 0a                	jmp    8006e7 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  8006dd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006e1:	89 04 24             	mov    %eax,(%esp)
  8006e4:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e7:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006eb:	0f be 06             	movsbl (%esi),%eax
  8006ee:	83 c6 01             	add    $0x1,%esi
  8006f1:	85 c0                	test   %eax,%eax
  8006f3:	75 0e                	jne    800703 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fc:	7f 16                	jg     800714 <vprintfmt+0x26a>
  8006fe:	e9 ca fd ff ff       	jmp    8004cd <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800703:	85 ff                	test   %edi,%edi
  800705:	78 b8                	js     8006bf <vprintfmt+0x215>
  800707:	83 ef 01             	sub    $0x1,%edi
  80070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800710:	79 ad                	jns    8006bf <vprintfmt+0x215>
  800712:	eb e1                	jmp    8006f5 <vprintfmt+0x24b>
  800714:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800717:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80071a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80071e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800725:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800727:	83 ee 01             	sub    $0x1,%esi
  80072a:	75 ee                	jne    80071a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80072f:	e9 99 fd ff ff       	jmp    8004cd <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800734:	83 f9 01             	cmp    $0x1,%ecx
  800737:	7e 10                	jle    800749 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 50 08             	lea    0x8(%eax),%edx
  80073f:	89 55 14             	mov    %edx,0x14(%ebp)
  800742:	8b 30                	mov    (%eax),%esi
  800744:	8b 78 04             	mov    0x4(%eax),%edi
  800747:	eb 26                	jmp    80076f <vprintfmt+0x2c5>
	else if (lflag)
  800749:	85 c9                	test   %ecx,%ecx
  80074b:	74 12                	je     80075f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8d 50 04             	lea    0x4(%eax),%edx
  800753:	89 55 14             	mov    %edx,0x14(%ebp)
  800756:	8b 30                	mov    (%eax),%esi
  800758:	89 f7                	mov    %esi,%edi
  80075a:	c1 ff 1f             	sar    $0x1f,%edi
  80075d:	eb 10                	jmp    80076f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	89 55 14             	mov    %edx,0x14(%ebp)
  800768:	8b 30                	mov    (%eax),%esi
  80076a:	89 f7                	mov    %esi,%edi
  80076c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80076f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800774:	85 ff                	test   %edi,%edi
  800776:	0f 89 8c 00 00 00    	jns    800808 <vprintfmt+0x35e>
				putch('-', putdat);
  80077c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800780:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800787:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80078a:	f7 de                	neg    %esi
  80078c:	83 d7 00             	adc    $0x0,%edi
  80078f:	f7 df                	neg    %edi
			}
			base = 10;
  800791:	b8 0a 00 00 00       	mov    $0xa,%eax
  800796:	eb 70                	jmp    800808 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800798:	89 ca                	mov    %ecx,%edx
  80079a:	8d 45 14             	lea    0x14(%ebp),%eax
  80079d:	e8 89 fc ff ff       	call   80042b <getuint>
  8007a2:	89 c6                	mov    %eax,%esi
  8007a4:	89 d7                	mov    %edx,%edi
			base = 10;
  8007a6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8007ab:	eb 5b                	jmp    800808 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8007ad:	89 ca                	mov    %ecx,%edx
  8007af:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b2:	e8 74 fc ff ff       	call   80042b <getuint>
  8007b7:	89 c6                	mov    %eax,%esi
  8007b9:	89 d7                	mov    %edx,%edi
			base = 8;
  8007bb:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8007c0:	eb 46                	jmp    800808 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  8007c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007c6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007cd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007d4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007db:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8d 50 04             	lea    0x4(%eax),%edx
  8007e4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007e7:	8b 30                	mov    (%eax),%esi
  8007e9:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007ee:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8007f3:	eb 13                	jmp    800808 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007f5:	89 ca                	mov    %ecx,%edx
  8007f7:	8d 45 14             	lea    0x14(%ebp),%eax
  8007fa:	e8 2c fc ff ff       	call   80042b <getuint>
  8007ff:	89 c6                	mov    %eax,%esi
  800801:	89 d7                	mov    %edx,%edi
			base = 16;
  800803:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800808:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80080c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800810:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800813:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800817:	89 44 24 08          	mov    %eax,0x8(%esp)
  80081b:	89 34 24             	mov    %esi,(%esp)
  80081e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800822:	89 da                	mov    %ebx,%edx
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	e8 24 fb ff ff       	call   800350 <printnum>
			break;
  80082c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80082f:	e9 99 fc ff ff       	jmp    8004cd <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800834:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800838:	89 14 24             	mov    %edx,(%esp)
  80083b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80083e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800841:	e9 87 fc ff ff       	jmp    8004cd <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800846:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80084a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800851:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800854:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800858:	0f 84 6f fc ff ff    	je     8004cd <vprintfmt+0x23>
  80085e:	83 ee 01             	sub    $0x1,%esi
  800861:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800865:	75 f7                	jne    80085e <vprintfmt+0x3b4>
  800867:	e9 61 fc ff ff       	jmp    8004cd <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80086c:	83 c4 4c             	add    $0x4c,%esp
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5f                   	pop    %edi
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	83 ec 28             	sub    $0x28,%esp
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800880:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800883:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800887:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80088a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800891:	85 c0                	test   %eax,%eax
  800893:	74 30                	je     8008c5 <vsnprintf+0x51>
  800895:	85 d2                	test   %edx,%edx
  800897:	7e 2c                	jle    8008c5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ae:	c7 04 24 65 04 80 00 	movl   $0x800465,(%esp)
  8008b5:	e8 f0 fb ff ff       	call   8004aa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c3:	eb 05                	jmp    8008ca <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008ca:	c9                   	leave  
  8008cb:	c3                   	ret    

008008cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	89 04 24             	mov    %eax,(%esp)
  8008ed:	e8 82 ff ff ff       	call   800874 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f2:	c9                   	leave  
  8008f3:	c3                   	ret    
	...

00800900 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800906:	b8 00 00 00 00       	mov    $0x0,%eax
  80090b:	80 3a 00             	cmpb   $0x0,(%edx)
  80090e:	74 09                	je     800919 <strlen+0x19>
		n++;
  800910:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800913:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800917:	75 f7                	jne    800910 <strlen+0x10>
		n++;
	return n;
}
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	53                   	push   %ebx
  80091f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800922:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800925:	b8 00 00 00 00       	mov    $0x0,%eax
  80092a:	85 c9                	test   %ecx,%ecx
  80092c:	74 1a                	je     800948 <strnlen+0x2d>
  80092e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800931:	74 15                	je     800948 <strnlen+0x2d>
  800933:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800938:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093a:	39 ca                	cmp    %ecx,%edx
  80093c:	74 0a                	je     800948 <strnlen+0x2d>
  80093e:	83 c2 01             	add    $0x1,%edx
  800941:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800946:	75 f0                	jne    800938 <strnlen+0x1d>
		n++;
	return n;
}
  800948:	5b                   	pop    %ebx
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	53                   	push   %ebx
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800955:	ba 00 00 00 00       	mov    $0x0,%edx
  80095a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80095e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800961:	83 c2 01             	add    $0x1,%edx
  800964:	84 c9                	test   %cl,%cl
  800966:	75 f2                	jne    80095a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800968:	5b                   	pop    %ebx
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	53                   	push   %ebx
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800975:	89 1c 24             	mov    %ebx,(%esp)
  800978:	e8 83 ff ff ff       	call   800900 <strlen>
	strcpy(dst + len, src);
  80097d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800980:	89 54 24 04          	mov    %edx,0x4(%esp)
  800984:	01 d8                	add    %ebx,%eax
  800986:	89 04 24             	mov    %eax,(%esp)
  800989:	e8 bd ff ff ff       	call   80094b <strcpy>
	return dst;
}
  80098e:	89 d8                	mov    %ebx,%eax
  800990:	83 c4 08             	add    $0x8,%esp
  800993:	5b                   	pop    %ebx
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	56                   	push   %esi
  80099a:	53                   	push   %ebx
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a4:	85 f6                	test   %esi,%esi
  8009a6:	74 18                	je     8009c0 <strncpy+0x2a>
  8009a8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009ad:	0f b6 1a             	movzbl (%edx),%ebx
  8009b0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b3:	80 3a 01             	cmpb   $0x1,(%edx)
  8009b6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b9:	83 c1 01             	add    $0x1,%ecx
  8009bc:	39 f1                	cmp    %esi,%ecx
  8009be:	75 ed                	jne    8009ad <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009c0:	5b                   	pop    %ebx
  8009c1:	5e                   	pop    %esi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	57                   	push   %edi
  8009c8:	56                   	push   %esi
  8009c9:	53                   	push   %ebx
  8009ca:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009d0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d3:	89 f8                	mov    %edi,%eax
  8009d5:	85 f6                	test   %esi,%esi
  8009d7:	74 2b                	je     800a04 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  8009d9:	83 fe 01             	cmp    $0x1,%esi
  8009dc:	74 23                	je     800a01 <strlcpy+0x3d>
  8009de:	0f b6 0b             	movzbl (%ebx),%ecx
  8009e1:	84 c9                	test   %cl,%cl
  8009e3:	74 1c                	je     800a01 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  8009e5:	83 ee 02             	sub    $0x2,%esi
  8009e8:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009ed:	88 08                	mov    %cl,(%eax)
  8009ef:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009f2:	39 f2                	cmp    %esi,%edx
  8009f4:	74 0b                	je     800a01 <strlcpy+0x3d>
  8009f6:	83 c2 01             	add    $0x1,%edx
  8009f9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009fd:	84 c9                	test   %cl,%cl
  8009ff:	75 ec                	jne    8009ed <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800a01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a04:	29 f8                	sub    %edi,%eax
}
  800a06:	5b                   	pop    %ebx
  800a07:	5e                   	pop    %esi
  800a08:	5f                   	pop    %edi
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a11:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a14:	0f b6 01             	movzbl (%ecx),%eax
  800a17:	84 c0                	test   %al,%al
  800a19:	74 16                	je     800a31 <strcmp+0x26>
  800a1b:	3a 02                	cmp    (%edx),%al
  800a1d:	75 12                	jne    800a31 <strcmp+0x26>
		p++, q++;
  800a1f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a22:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800a26:	84 c0                	test   %al,%al
  800a28:	74 07                	je     800a31 <strcmp+0x26>
  800a2a:	83 c1 01             	add    $0x1,%ecx
  800a2d:	3a 02                	cmp    (%edx),%al
  800a2f:	74 ee                	je     800a1f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a31:	0f b6 c0             	movzbl %al,%eax
  800a34:	0f b6 12             	movzbl (%edx),%edx
  800a37:	29 d0                	sub    %edx,%eax
}
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	53                   	push   %ebx
  800a3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a45:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a48:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a4d:	85 d2                	test   %edx,%edx
  800a4f:	74 28                	je     800a79 <strncmp+0x3e>
  800a51:	0f b6 01             	movzbl (%ecx),%eax
  800a54:	84 c0                	test   %al,%al
  800a56:	74 24                	je     800a7c <strncmp+0x41>
  800a58:	3a 03                	cmp    (%ebx),%al
  800a5a:	75 20                	jne    800a7c <strncmp+0x41>
  800a5c:	83 ea 01             	sub    $0x1,%edx
  800a5f:	74 13                	je     800a74 <strncmp+0x39>
		n--, p++, q++;
  800a61:	83 c1 01             	add    $0x1,%ecx
  800a64:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a67:	0f b6 01             	movzbl (%ecx),%eax
  800a6a:	84 c0                	test   %al,%al
  800a6c:	74 0e                	je     800a7c <strncmp+0x41>
  800a6e:	3a 03                	cmp    (%ebx),%al
  800a70:	74 ea                	je     800a5c <strncmp+0x21>
  800a72:	eb 08                	jmp    800a7c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a79:	5b                   	pop    %ebx
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7c:	0f b6 01             	movzbl (%ecx),%eax
  800a7f:	0f b6 13             	movzbl (%ebx),%edx
  800a82:	29 d0                	sub    %edx,%eax
  800a84:	eb f3                	jmp    800a79 <strncmp+0x3e>

00800a86 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a90:	0f b6 10             	movzbl (%eax),%edx
  800a93:	84 d2                	test   %dl,%dl
  800a95:	74 1c                	je     800ab3 <strchr+0x2d>
		if (*s == c)
  800a97:	38 ca                	cmp    %cl,%dl
  800a99:	75 09                	jne    800aa4 <strchr+0x1e>
  800a9b:	eb 1b                	jmp    800ab8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a9d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800aa0:	38 ca                	cmp    %cl,%dl
  800aa2:	74 14                	je     800ab8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aa4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800aa8:	84 d2                	test   %dl,%dl
  800aaa:	75 f1                	jne    800a9d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800aac:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab1:	eb 05                	jmp    800ab8 <strchr+0x32>
  800ab3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac4:	0f b6 10             	movzbl (%eax),%edx
  800ac7:	84 d2                	test   %dl,%dl
  800ac9:	74 14                	je     800adf <strfind+0x25>
		if (*s == c)
  800acb:	38 ca                	cmp    %cl,%dl
  800acd:	75 06                	jne    800ad5 <strfind+0x1b>
  800acf:	eb 0e                	jmp    800adf <strfind+0x25>
  800ad1:	38 ca                	cmp    %cl,%dl
  800ad3:	74 0a                	je     800adf <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ad5:	83 c0 01             	add    $0x1,%eax
  800ad8:	0f b6 10             	movzbl (%eax),%edx
  800adb:	84 d2                	test   %dl,%dl
  800add:	75 f2                	jne    800ad1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800adf:	5d                   	pop    %ebp
  800ae0:	c3                   	ret    

00800ae1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 0c             	sub    $0xc,%esp
  800ae7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800aea:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800aed:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800af0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af9:	85 c9                	test   %ecx,%ecx
  800afb:	74 30                	je     800b2d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800afd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b03:	75 25                	jne    800b2a <memset+0x49>
  800b05:	f6 c1 03             	test   $0x3,%cl
  800b08:	75 20                	jne    800b2a <memset+0x49>
		c &= 0xFF;
  800b0a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b0d:	89 d3                	mov    %edx,%ebx
  800b0f:	c1 e3 08             	shl    $0x8,%ebx
  800b12:	89 d6                	mov    %edx,%esi
  800b14:	c1 e6 18             	shl    $0x18,%esi
  800b17:	89 d0                	mov    %edx,%eax
  800b19:	c1 e0 10             	shl    $0x10,%eax
  800b1c:	09 f0                	or     %esi,%eax
  800b1e:	09 d0                	or     %edx,%eax
  800b20:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b22:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b25:	fc                   	cld    
  800b26:	f3 ab                	rep stos %eax,%es:(%edi)
  800b28:	eb 03                	jmp    800b2d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b2a:	fc                   	cld    
  800b2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b2d:	89 f8                	mov    %edi,%eax
  800b2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800b32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b38:	89 ec                	mov    %ebp,%esp
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b45:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b51:	39 c6                	cmp    %eax,%esi
  800b53:	73 36                	jae    800b8b <memmove+0x4f>
  800b55:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b58:	39 d0                	cmp    %edx,%eax
  800b5a:	73 2f                	jae    800b8b <memmove+0x4f>
		s += n;
		d += n;
  800b5c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b5f:	f6 c2 03             	test   $0x3,%dl
  800b62:	75 1b                	jne    800b7f <memmove+0x43>
  800b64:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b6a:	75 13                	jne    800b7f <memmove+0x43>
  800b6c:	f6 c1 03             	test   $0x3,%cl
  800b6f:	75 0e                	jne    800b7f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b71:	83 ef 04             	sub    $0x4,%edi
  800b74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b7a:	fd                   	std    
  800b7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7d:	eb 09                	jmp    800b88 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b7f:	83 ef 01             	sub    $0x1,%edi
  800b82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b85:	fd                   	std    
  800b86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b88:	fc                   	cld    
  800b89:	eb 20                	jmp    800bab <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b91:	75 13                	jne    800ba6 <memmove+0x6a>
  800b93:	a8 03                	test   $0x3,%al
  800b95:	75 0f                	jne    800ba6 <memmove+0x6a>
  800b97:	f6 c1 03             	test   $0x3,%cl
  800b9a:	75 0a                	jne    800ba6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b9c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b9f:	89 c7                	mov    %eax,%edi
  800ba1:	fc                   	cld    
  800ba2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba4:	eb 05                	jmp    800bab <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ba6:	89 c7                	mov    %eax,%edi
  800ba8:	fc                   	cld    
  800ba9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bb1:	89 ec                	mov    %ebp,%esp
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	89 04 24             	mov    %eax,(%esp)
  800bcf:	e8 68 ff ff ff       	call   800b3c <memmove>
}
  800bd4:	c9                   	leave  
  800bd5:	c3                   	ret    

00800bd6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	57                   	push   %edi
  800bda:	56                   	push   %esi
  800bdb:	53                   	push   %ebx
  800bdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bdf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be2:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bea:	85 ff                	test   %edi,%edi
  800bec:	74 37                	je     800c25 <memcmp+0x4f>
		if (*s1 != *s2)
  800bee:	0f b6 03             	movzbl (%ebx),%eax
  800bf1:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf4:	83 ef 01             	sub    $0x1,%edi
  800bf7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800bfc:	38 c8                	cmp    %cl,%al
  800bfe:	74 1c                	je     800c1c <memcmp+0x46>
  800c00:	eb 10                	jmp    800c12 <memcmp+0x3c>
  800c02:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800c07:	83 c2 01             	add    $0x1,%edx
  800c0a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800c0e:	38 c8                	cmp    %cl,%al
  800c10:	74 0a                	je     800c1c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800c12:	0f b6 c0             	movzbl %al,%eax
  800c15:	0f b6 c9             	movzbl %cl,%ecx
  800c18:	29 c8                	sub    %ecx,%eax
  800c1a:	eb 09                	jmp    800c25 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c1c:	39 fa                	cmp    %edi,%edx
  800c1e:	75 e2                	jne    800c02 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c30:	89 c2                	mov    %eax,%edx
  800c32:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c35:	39 d0                	cmp    %edx,%eax
  800c37:	73 19                	jae    800c52 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c39:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c3d:	38 08                	cmp    %cl,(%eax)
  800c3f:	75 06                	jne    800c47 <memfind+0x1d>
  800c41:	eb 0f                	jmp    800c52 <memfind+0x28>
  800c43:	38 08                	cmp    %cl,(%eax)
  800c45:	74 0b                	je     800c52 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c47:	83 c0 01             	add    $0x1,%eax
  800c4a:	39 d0                	cmp    %edx,%eax
  800c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c50:	75 f1                	jne    800c43 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
  800c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c60:	0f b6 02             	movzbl (%edx),%eax
  800c63:	3c 20                	cmp    $0x20,%al
  800c65:	74 04                	je     800c6b <strtol+0x17>
  800c67:	3c 09                	cmp    $0x9,%al
  800c69:	75 0e                	jne    800c79 <strtol+0x25>
		s++;
  800c6b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6e:	0f b6 02             	movzbl (%edx),%eax
  800c71:	3c 20                	cmp    $0x20,%al
  800c73:	74 f6                	je     800c6b <strtol+0x17>
  800c75:	3c 09                	cmp    $0x9,%al
  800c77:	74 f2                	je     800c6b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c79:	3c 2b                	cmp    $0x2b,%al
  800c7b:	75 0a                	jne    800c87 <strtol+0x33>
		s++;
  800c7d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c80:	bf 00 00 00 00       	mov    $0x0,%edi
  800c85:	eb 10                	jmp    800c97 <strtol+0x43>
  800c87:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c8c:	3c 2d                	cmp    $0x2d,%al
  800c8e:	75 07                	jne    800c97 <strtol+0x43>
		s++, neg = 1;
  800c90:	83 c2 01             	add    $0x1,%edx
  800c93:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c97:	85 db                	test   %ebx,%ebx
  800c99:	0f 94 c0             	sete   %al
  800c9c:	74 05                	je     800ca3 <strtol+0x4f>
  800c9e:	83 fb 10             	cmp    $0x10,%ebx
  800ca1:	75 15                	jne    800cb8 <strtol+0x64>
  800ca3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ca6:	75 10                	jne    800cb8 <strtol+0x64>
  800ca8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cac:	75 0a                	jne    800cb8 <strtol+0x64>
		s += 2, base = 16;
  800cae:	83 c2 02             	add    $0x2,%edx
  800cb1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cb6:	eb 13                	jmp    800ccb <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800cb8:	84 c0                	test   %al,%al
  800cba:	74 0f                	je     800ccb <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cbc:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cc1:	80 3a 30             	cmpb   $0x30,(%edx)
  800cc4:	75 05                	jne    800ccb <strtol+0x77>
		s++, base = 8;
  800cc6:	83 c2 01             	add    $0x1,%edx
  800cc9:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cd2:	0f b6 0a             	movzbl (%edx),%ecx
  800cd5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cd8:	80 fb 09             	cmp    $0x9,%bl
  800cdb:	77 08                	ja     800ce5 <strtol+0x91>
			dig = *s - '0';
  800cdd:	0f be c9             	movsbl %cl,%ecx
  800ce0:	83 e9 30             	sub    $0x30,%ecx
  800ce3:	eb 1e                	jmp    800d03 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800ce5:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800ce8:	80 fb 19             	cmp    $0x19,%bl
  800ceb:	77 08                	ja     800cf5 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800ced:	0f be c9             	movsbl %cl,%ecx
  800cf0:	83 e9 57             	sub    $0x57,%ecx
  800cf3:	eb 0e                	jmp    800d03 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800cf5:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800cf8:	80 fb 19             	cmp    $0x19,%bl
  800cfb:	77 14                	ja     800d11 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800cfd:	0f be c9             	movsbl %cl,%ecx
  800d00:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d03:	39 f1                	cmp    %esi,%ecx
  800d05:	7d 0e                	jge    800d15 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d07:	83 c2 01             	add    $0x1,%edx
  800d0a:	0f af c6             	imul   %esi,%eax
  800d0d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800d0f:	eb c1                	jmp    800cd2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800d11:	89 c1                	mov    %eax,%ecx
  800d13:	eb 02                	jmp    800d17 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d15:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d1b:	74 05                	je     800d22 <strtol+0xce>
		*endptr = (char *) s;
  800d1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d20:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d22:	89 ca                	mov    %ecx,%edx
  800d24:	f7 da                	neg    %edx
  800d26:	85 ff                	test   %edi,%edi
  800d28:	0f 45 c2             	cmovne %edx,%eax
}
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5f                   	pop    %edi
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 0c             	sub    $0xc,%esp
  800d36:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d39:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d3c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d47:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4a:	89 c3                	mov    %eax,%ebx
  800d4c:	89 c7                	mov    %eax,%edi
  800d4e:	89 c6                	mov    %eax,%esi
  800d50:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d52:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d55:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d58:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d5b:	89 ec                	mov    %ebp,%esp
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <sys_cgetc>:

int
sys_cgetc(void)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	83 ec 0c             	sub    $0xc,%esp
  800d65:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d68:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d6b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d73:	b8 01 00 00 00       	mov    $0x1,%eax
  800d78:	89 d1                	mov    %edx,%ecx
  800d7a:	89 d3                	mov    %edx,%ebx
  800d7c:	89 d7                	mov    %edx,%edi
  800d7e:	89 d6                	mov    %edx,%esi
  800d80:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d82:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d85:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d88:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d8b:	89 ec                	mov    %ebp,%esp
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 38             	sub    $0x38,%esp
  800d95:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d98:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d9b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da3:	b8 03 00 00 00       	mov    $0x3,%eax
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	89 cb                	mov    %ecx,%ebx
  800dad:	89 cf                	mov    %ecx,%edi
  800daf:	89 ce                	mov    %ecx,%esi
  800db1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db3:	85 c0                	test   %eax,%eax
  800db5:	7e 28                	jle    800ddf <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dbb:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800dc2:	00 
  800dc3:	c7 44 24 08 df 27 80 	movl   $0x8027df,0x8(%esp)
  800dca:	00 
  800dcb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd2:	00 
  800dd3:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  800dda:	e8 59 f4 ff ff       	call   800238 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ddf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800de2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800de5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800de8:	89 ec                	mov    %ebp,%esp
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    

00800dec <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800df5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800df8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800e00:	b8 02 00 00 00       	mov    $0x2,%eax
  800e05:	89 d1                	mov    %edx,%ecx
  800e07:	89 d3                	mov    %edx,%ebx
  800e09:	89 d7                	mov    %edx,%edi
  800e0b:	89 d6                	mov    %edx,%esi
  800e0d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e0f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e12:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e15:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e18:	89 ec                	mov    %ebp,%esp
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    

00800e1c <sys_yield>:

void
sys_yield(void)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	83 ec 0c             	sub    $0xc,%esp
  800e22:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e25:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e28:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e30:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e35:	89 d1                	mov    %edx,%ecx
  800e37:	89 d3                	mov    %edx,%ebx
  800e39:	89 d7                	mov    %edx,%edi
  800e3b:	89 d6                	mov    %edx,%esi
  800e3d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e3f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e42:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e45:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e48:	89 ec                	mov    %ebp,%esp
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 38             	sub    $0x38,%esp
  800e52:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e55:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e58:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5b:	be 00 00 00 00       	mov    $0x0,%esi
  800e60:	b8 04 00 00 00       	mov    $0x4,%eax
  800e65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	89 f7                	mov    %esi,%edi
  800e70:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e72:	85 c0                	test   %eax,%eax
  800e74:	7e 28                	jle    800e9e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e76:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e7a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e81:	00 
  800e82:	c7 44 24 08 df 27 80 	movl   $0x8027df,0x8(%esp)
  800e89:	00 
  800e8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e91:	00 
  800e92:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  800e99:	e8 9a f3 ff ff       	call   800238 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e9e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ea1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ea4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ea7:	89 ec                	mov    %ebp,%esp
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	83 ec 38             	sub    $0x38,%esp
  800eb1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eb4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eb7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eba:	b8 05 00 00 00       	mov    $0x5,%eax
  800ebf:	8b 75 18             	mov    0x18(%ebp),%esi
  800ec2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ece:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed0:	85 c0                	test   %eax,%eax
  800ed2:	7e 28                	jle    800efc <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800edf:	00 
  800ee0:	c7 44 24 08 df 27 80 	movl   $0x8027df,0x8(%esp)
  800ee7:	00 
  800ee8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eef:	00 
  800ef0:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  800ef7:	e8 3c f3 ff ff       	call   800238 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800efc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eff:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f02:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f05:	89 ec                	mov    %ebp,%esp
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	83 ec 38             	sub    $0x38,%esp
  800f0f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f12:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f15:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1d:	b8 06 00 00 00       	mov    $0x6,%eax
  800f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f25:	8b 55 08             	mov    0x8(%ebp),%edx
  800f28:	89 df                	mov    %ebx,%edi
  800f2a:	89 de                	mov    %ebx,%esi
  800f2c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	7e 28                	jle    800f5a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f32:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f36:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f3d:	00 
  800f3e:	c7 44 24 08 df 27 80 	movl   $0x8027df,0x8(%esp)
  800f45:	00 
  800f46:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4d:	00 
  800f4e:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  800f55:	e8 de f2 ff ff       	call   800238 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f5a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f5d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f60:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f63:	89 ec                	mov    %ebp,%esp
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 38             	sub    $0x38,%esp
  800f6d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f70:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f73:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7b:	b8 08 00 00 00       	mov    $0x8,%eax
  800f80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f83:	8b 55 08             	mov    0x8(%ebp),%edx
  800f86:	89 df                	mov    %ebx,%edi
  800f88:	89 de                	mov    %ebx,%esi
  800f8a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	7e 28                	jle    800fb8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f90:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f94:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f9b:	00 
  800f9c:	c7 44 24 08 df 27 80 	movl   $0x8027df,0x8(%esp)
  800fa3:	00 
  800fa4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fab:	00 
  800fac:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  800fb3:	e8 80 f2 ff ff       	call   800238 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fb8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fbb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fbe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fc1:	89 ec                	mov    %ebp,%esp
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	83 ec 38             	sub    $0x38,%esp
  800fcb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fce:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fd1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd9:	b8 09 00 00 00       	mov    $0x9,%eax
  800fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe4:	89 df                	mov    %ebx,%edi
  800fe6:	89 de                	mov    %ebx,%esi
  800fe8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fea:	85 c0                	test   %eax,%eax
  800fec:	7e 28                	jle    801016 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fee:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff2:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ff9:	00 
  800ffa:	c7 44 24 08 df 27 80 	movl   $0x8027df,0x8(%esp)
  801001:	00 
  801002:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801009:	00 
  80100a:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  801011:	e8 22 f2 ff ff       	call   800238 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801016:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801019:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80101c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80101f:	89 ec                	mov    %ebp,%esp
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    

00801023 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	83 ec 38             	sub    $0x38,%esp
  801029:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80102c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80102f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801032:	bb 00 00 00 00       	mov    $0x0,%ebx
  801037:	b8 0a 00 00 00       	mov    $0xa,%eax
  80103c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
  801042:	89 df                	mov    %ebx,%edi
  801044:	89 de                	mov    %ebx,%esi
  801046:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801048:	85 c0                	test   %eax,%eax
  80104a:	7e 28                	jle    801074 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80104c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801050:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801057:	00 
  801058:	c7 44 24 08 df 27 80 	movl   $0x8027df,0x8(%esp)
  80105f:	00 
  801060:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801067:	00 
  801068:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  80106f:	e8 c4 f1 ff ff       	call   800238 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801074:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801077:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80107a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80107d:	89 ec                	mov    %ebp,%esp
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 0c             	sub    $0xc,%esp
  801087:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80108a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80108d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801090:	be 00 00 00 00       	mov    $0x0,%esi
  801095:	b8 0c 00 00 00       	mov    $0xc,%eax
  80109a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80109d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010a8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010ab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010b1:	89 ec                	mov    %ebp,%esp
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    

008010b5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	83 ec 38             	sub    $0x38,%esp
  8010bb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010be:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010c1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010c9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d1:	89 cb                	mov    %ecx,%ebx
  8010d3:	89 cf                	mov    %ecx,%edi
  8010d5:	89 ce                	mov    %ecx,%esi
  8010d7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	7e 28                	jle    801105 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e1:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010e8:	00 
  8010e9:	c7 44 24 08 df 27 80 	movl   $0x8027df,0x8(%esp)
  8010f0:	00 
  8010f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f8:	00 
  8010f9:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  801100:	e8 33 f1 ff ff       	call   800238 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801105:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801108:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80110b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80110e:	89 ec                	mov    %ebp,%esp
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    
	...

00801120 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	05 00 00 00 30       	add    $0x30000000,%eax
  80112b:	c1 e8 0c             	shr    $0xc,%eax
}
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	89 04 24             	mov    %eax,(%esp)
  80113c:	e8 df ff ff ff       	call   801120 <fd2num>
  801141:	05 20 00 0d 00       	add    $0xd0020,%eax
  801146:	c1 e0 0c             	shl    $0xc,%eax
}
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	53                   	push   %ebx
  80114f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801152:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801157:	a8 01                	test   $0x1,%al
  801159:	74 34                	je     80118f <fd_alloc+0x44>
  80115b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801160:	a8 01                	test   $0x1,%al
  801162:	74 32                	je     801196 <fd_alloc+0x4b>
  801164:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801169:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80116b:	89 c2                	mov    %eax,%edx
  80116d:	c1 ea 16             	shr    $0x16,%edx
  801170:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801177:	f6 c2 01             	test   $0x1,%dl
  80117a:	74 1f                	je     80119b <fd_alloc+0x50>
  80117c:	89 c2                	mov    %eax,%edx
  80117e:	c1 ea 0c             	shr    $0xc,%edx
  801181:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801188:	f6 c2 01             	test   $0x1,%dl
  80118b:	75 17                	jne    8011a4 <fd_alloc+0x59>
  80118d:	eb 0c                	jmp    80119b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80118f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801194:	eb 05                	jmp    80119b <fd_alloc+0x50>
  801196:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80119b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80119d:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a2:	eb 17                	jmp    8011bb <fd_alloc+0x70>
  8011a4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011a9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011ae:	75 b9                	jne    801169 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  8011b6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8011bb:	5b                   	pop    %ebx
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    

008011be <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011c9:	83 fa 1f             	cmp    $0x1f,%edx
  8011cc:	77 3f                	ja     80120d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011ce:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  8011d4:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011d7:	89 d0                	mov    %edx,%eax
  8011d9:	c1 e8 16             	shr    $0x16,%eax
  8011dc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011e8:	f6 c1 01             	test   $0x1,%cl
  8011eb:	74 20                	je     80120d <fd_lookup+0x4f>
  8011ed:	89 d0                	mov    %edx,%eax
  8011ef:	c1 e8 0c             	shr    $0xc,%eax
  8011f2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011fe:	f6 c1 01             	test   $0x1,%cl
  801201:	74 0a                	je     80120d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801203:	8b 45 0c             	mov    0xc(%ebp),%eax
  801206:	89 10                	mov    %edx,(%eax)
	return 0;
  801208:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    

0080120f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	53                   	push   %ebx
  801213:	83 ec 14             	sub    $0x14,%esp
  801216:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801219:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80121c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801221:	39 0d 08 30 80 00    	cmp    %ecx,0x803008
  801227:	75 17                	jne    801240 <dev_lookup+0x31>
  801229:	eb 07                	jmp    801232 <dev_lookup+0x23>
  80122b:	39 0a                	cmp    %ecx,(%edx)
  80122d:	75 11                	jne    801240 <dev_lookup+0x31>
  80122f:	90                   	nop
  801230:	eb 05                	jmp    801237 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801232:	ba 08 30 80 00       	mov    $0x803008,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801237:	89 13                	mov    %edx,(%ebx)
			return 0;
  801239:	b8 00 00 00 00       	mov    $0x0,%eax
  80123e:	eb 35                	jmp    801275 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801240:	83 c0 01             	add    $0x1,%eax
  801243:	8b 14 85 8c 28 80 00 	mov    0x80288c(,%eax,4),%edx
  80124a:	85 d2                	test   %edx,%edx
  80124c:	75 dd                	jne    80122b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80124e:	a1 08 40 80 00       	mov    0x804008,%eax
  801253:	8b 40 48             	mov    0x48(%eax),%eax
  801256:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80125a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80125e:	c7 04 24 0c 28 80 00 	movl   $0x80280c,(%esp)
  801265:	e8 c9 f0 ff ff       	call   800333 <cprintf>
	*dev = 0;
  80126a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801270:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801275:	83 c4 14             	add    $0x14,%esp
  801278:	5b                   	pop    %ebx
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    

0080127b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	83 ec 38             	sub    $0x38,%esp
  801281:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801284:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801287:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80128a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80128d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801291:	89 3c 24             	mov    %edi,(%esp)
  801294:	e8 87 fe ff ff       	call   801120 <fd2num>
  801299:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80129c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012a0:	89 04 24             	mov    %eax,(%esp)
  8012a3:	e8 16 ff ff ff       	call   8011be <fd_lookup>
  8012a8:	89 c3                	mov    %eax,%ebx
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	78 05                	js     8012b3 <fd_close+0x38>
	    || fd != fd2)
  8012ae:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8012b1:	74 0e                	je     8012c1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012b3:	89 f0                	mov    %esi,%eax
  8012b5:	84 c0                	test   %al,%al
  8012b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bc:	0f 44 d8             	cmove  %eax,%ebx
  8012bf:	eb 3d                	jmp    8012fe <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012c1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c8:	8b 07                	mov    (%edi),%eax
  8012ca:	89 04 24             	mov    %eax,(%esp)
  8012cd:	e8 3d ff ff ff       	call   80120f <dev_lookup>
  8012d2:	89 c3                	mov    %eax,%ebx
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	78 16                	js     8012ee <fd_close+0x73>
		if (dev->dev_close)
  8012d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8012de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	74 07                	je     8012ee <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8012e7:	89 3c 24             	mov    %edi,(%esp)
  8012ea:	ff d0                	call   *%eax
  8012ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012f9:	e8 0b fc ff ff       	call   800f09 <sys_page_unmap>
	return r;
}
  8012fe:	89 d8                	mov    %ebx,%eax
  801300:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801303:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801306:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801309:	89 ec                	mov    %ebp,%esp
  80130b:	5d                   	pop    %ebp
  80130c:	c3                   	ret    

0080130d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801313:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801316:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	89 04 24             	mov    %eax,(%esp)
  801320:	e8 99 fe ff ff       	call   8011be <fd_lookup>
  801325:	85 c0                	test   %eax,%eax
  801327:	78 13                	js     80133c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801329:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801330:	00 
  801331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801334:	89 04 24             	mov    %eax,(%esp)
  801337:	e8 3f ff ff ff       	call   80127b <fd_close>
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <close_all>:

void
close_all(void)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	53                   	push   %ebx
  801342:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801345:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80134a:	89 1c 24             	mov    %ebx,(%esp)
  80134d:	e8 bb ff ff ff       	call   80130d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801352:	83 c3 01             	add    $0x1,%ebx
  801355:	83 fb 20             	cmp    $0x20,%ebx
  801358:	75 f0                	jne    80134a <close_all+0xc>
		close(i);
}
  80135a:	83 c4 14             	add    $0x14,%esp
  80135d:	5b                   	pop    %ebx
  80135e:	5d                   	pop    %ebp
  80135f:	c3                   	ret    

00801360 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	83 ec 58             	sub    $0x58,%esp
  801366:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801369:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80136c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80136f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801372:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801375:	89 44 24 04          	mov    %eax,0x4(%esp)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	89 04 24             	mov    %eax,(%esp)
  80137f:	e8 3a fe ff ff       	call   8011be <fd_lookup>
  801384:	89 c3                	mov    %eax,%ebx
  801386:	85 c0                	test   %eax,%eax
  801388:	0f 88 e1 00 00 00    	js     80146f <dup+0x10f>
		return r;
	close(newfdnum);
  80138e:	89 3c 24             	mov    %edi,(%esp)
  801391:	e8 77 ff ff ff       	call   80130d <close>

	newfd = INDEX2FD(newfdnum);
  801396:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80139c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80139f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a2:	89 04 24             	mov    %eax,(%esp)
  8013a5:	e8 86 fd ff ff       	call   801130 <fd2data>
  8013aa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013ac:	89 34 24             	mov    %esi,(%esp)
  8013af:	e8 7c fd ff ff       	call   801130 <fd2data>
  8013b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013b7:	89 d8                	mov    %ebx,%eax
  8013b9:	c1 e8 16             	shr    $0x16,%eax
  8013bc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013c3:	a8 01                	test   $0x1,%al
  8013c5:	74 46                	je     80140d <dup+0xad>
  8013c7:	89 d8                	mov    %ebx,%eax
  8013c9:	c1 e8 0c             	shr    $0xc,%eax
  8013cc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013d3:	f6 c2 01             	test   $0x1,%dl
  8013d6:	74 35                	je     80140d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013df:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013f6:	00 
  8013f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801402:	e8 a4 fa ff ff       	call   800eab <sys_page_map>
  801407:	89 c3                	mov    %eax,%ebx
  801409:	85 c0                	test   %eax,%eax
  80140b:	78 3b                	js     801448 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80140d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801410:	89 c2                	mov    %eax,%edx
  801412:	c1 ea 0c             	shr    $0xc,%edx
  801415:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80141c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801422:	89 54 24 10          	mov    %edx,0x10(%esp)
  801426:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80142a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801431:	00 
  801432:	89 44 24 04          	mov    %eax,0x4(%esp)
  801436:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80143d:	e8 69 fa ff ff       	call   800eab <sys_page_map>
  801442:	89 c3                	mov    %eax,%ebx
  801444:	85 c0                	test   %eax,%eax
  801446:	79 25                	jns    80146d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801448:	89 74 24 04          	mov    %esi,0x4(%esp)
  80144c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801453:	e8 b1 fa ff ff       	call   800f09 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801458:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80145b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801466:	e8 9e fa ff ff       	call   800f09 <sys_page_unmap>
	return r;
  80146b:	eb 02                	jmp    80146f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80146d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80146f:	89 d8                	mov    %ebx,%eax
  801471:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801474:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801477:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80147a:	89 ec                	mov    %ebp,%esp
  80147c:	5d                   	pop    %ebp
  80147d:	c3                   	ret    

0080147e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	53                   	push   %ebx
  801482:	83 ec 24             	sub    $0x24,%esp
  801485:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801488:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148f:	89 1c 24             	mov    %ebx,(%esp)
  801492:	e8 27 fd ff ff       	call   8011be <fd_lookup>
  801497:	85 c0                	test   %eax,%eax
  801499:	78 6d                	js     801508 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a5:	8b 00                	mov    (%eax),%eax
  8014a7:	89 04 24             	mov    %eax,(%esp)
  8014aa:	e8 60 fd ff ff       	call   80120f <dev_lookup>
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 55                	js     801508 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b6:	8b 50 08             	mov    0x8(%eax),%edx
  8014b9:	83 e2 03             	and    $0x3,%edx
  8014bc:	83 fa 01             	cmp    $0x1,%edx
  8014bf:	75 23                	jne    8014e4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c1:	a1 08 40 80 00       	mov    0x804008,%eax
  8014c6:	8b 40 48             	mov    0x48(%eax),%eax
  8014c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d1:	c7 04 24 50 28 80 00 	movl   $0x802850,(%esp)
  8014d8:	e8 56 ee ff ff       	call   800333 <cprintf>
		return -E_INVAL;
  8014dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e2:	eb 24                	jmp    801508 <read+0x8a>
	}
	if (!dev->dev_read)
  8014e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e7:	8b 52 08             	mov    0x8(%edx),%edx
  8014ea:	85 d2                	test   %edx,%edx
  8014ec:	74 15                	je     801503 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014f1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014fc:	89 04 24             	mov    %eax,(%esp)
  8014ff:	ff d2                	call   *%edx
  801501:	eb 05                	jmp    801508 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801503:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801508:	83 c4 24             	add    $0x24,%esp
  80150b:	5b                   	pop    %ebx
  80150c:	5d                   	pop    %ebp
  80150d:	c3                   	ret    

0080150e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	57                   	push   %edi
  801512:	56                   	push   %esi
  801513:	53                   	push   %ebx
  801514:	83 ec 1c             	sub    $0x1c,%esp
  801517:	8b 7d 08             	mov    0x8(%ebp),%edi
  80151a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
  801522:	85 f6                	test   %esi,%esi
  801524:	74 30                	je     801556 <readn+0x48>
  801526:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80152b:	89 f2                	mov    %esi,%edx
  80152d:	29 c2                	sub    %eax,%edx
  80152f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801533:	03 45 0c             	add    0xc(%ebp),%eax
  801536:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153a:	89 3c 24             	mov    %edi,(%esp)
  80153d:	e8 3c ff ff ff       	call   80147e <read>
		if (m < 0)
  801542:	85 c0                	test   %eax,%eax
  801544:	78 10                	js     801556 <readn+0x48>
			return m;
		if (m == 0)
  801546:	85 c0                	test   %eax,%eax
  801548:	74 0a                	je     801554 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80154a:	01 c3                	add    %eax,%ebx
  80154c:	89 d8                	mov    %ebx,%eax
  80154e:	39 f3                	cmp    %esi,%ebx
  801550:	72 d9                	jb     80152b <readn+0x1d>
  801552:	eb 02                	jmp    801556 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801554:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801556:	83 c4 1c             	add    $0x1c,%esp
  801559:	5b                   	pop    %ebx
  80155a:	5e                   	pop    %esi
  80155b:	5f                   	pop    %edi
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	53                   	push   %ebx
  801562:	83 ec 24             	sub    $0x24,%esp
  801565:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801568:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80156b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156f:	89 1c 24             	mov    %ebx,(%esp)
  801572:	e8 47 fc ff ff       	call   8011be <fd_lookup>
  801577:	85 c0                	test   %eax,%eax
  801579:	78 68                	js     8015e3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801585:	8b 00                	mov    (%eax),%eax
  801587:	89 04 24             	mov    %eax,(%esp)
  80158a:	e8 80 fc ff ff       	call   80120f <dev_lookup>
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 50                	js     8015e3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801596:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80159a:	75 23                	jne    8015bf <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80159c:	a1 08 40 80 00       	mov    0x804008,%eax
  8015a1:	8b 40 48             	mov    0x48(%eax),%eax
  8015a4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ac:	c7 04 24 6c 28 80 00 	movl   $0x80286c,(%esp)
  8015b3:	e8 7b ed ff ff       	call   800333 <cprintf>
		return -E_INVAL;
  8015b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015bd:	eb 24                	jmp    8015e3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8015c5:	85 d2                	test   %edx,%edx
  8015c7:	74 15                	je     8015de <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015cc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015d7:	89 04 24             	mov    %eax,(%esp)
  8015da:	ff d2                	call   *%edx
  8015dc:	eb 05                	jmp    8015e3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8015de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8015e3:	83 c4 24             	add    $0x24,%esp
  8015e6:	5b                   	pop    %ebx
  8015e7:	5d                   	pop    %ebp
  8015e8:	c3                   	ret    

008015e9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ef:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	89 04 24             	mov    %eax,(%esp)
  8015fc:	e8 bd fb ff ff       	call   8011be <fd_lookup>
  801601:	85 c0                	test   %eax,%eax
  801603:	78 0e                	js     801613 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801605:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80160e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	53                   	push   %ebx
  801619:	83 ec 24             	sub    $0x24,%esp
  80161c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80161f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801622:	89 44 24 04          	mov    %eax,0x4(%esp)
  801626:	89 1c 24             	mov    %ebx,(%esp)
  801629:	e8 90 fb ff ff       	call   8011be <fd_lookup>
  80162e:	85 c0                	test   %eax,%eax
  801630:	78 61                	js     801693 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801632:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801635:	89 44 24 04          	mov    %eax,0x4(%esp)
  801639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163c:	8b 00                	mov    (%eax),%eax
  80163e:	89 04 24             	mov    %eax,(%esp)
  801641:	e8 c9 fb ff ff       	call   80120f <dev_lookup>
  801646:	85 c0                	test   %eax,%eax
  801648:	78 49                	js     801693 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80164a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801651:	75 23                	jne    801676 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801653:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801658:	8b 40 48             	mov    0x48(%eax),%eax
  80165b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80165f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801663:	c7 04 24 2c 28 80 00 	movl   $0x80282c,(%esp)
  80166a:	e8 c4 ec ff ff       	call   800333 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80166f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801674:	eb 1d                	jmp    801693 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801676:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801679:	8b 52 18             	mov    0x18(%edx),%edx
  80167c:	85 d2                	test   %edx,%edx
  80167e:	74 0e                	je     80168e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801680:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801683:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801687:	89 04 24             	mov    %eax,(%esp)
  80168a:	ff d2                	call   *%edx
  80168c:	eb 05                	jmp    801693 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80168e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801693:	83 c4 24             	add    $0x24,%esp
  801696:	5b                   	pop    %ebx
  801697:	5d                   	pop    %ebp
  801698:	c3                   	ret    

00801699 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	53                   	push   %ebx
  80169d:	83 ec 24             	sub    $0x24,%esp
  8016a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	89 04 24             	mov    %eax,(%esp)
  8016b0:	e8 09 fb ff ff       	call   8011be <fd_lookup>
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 52                	js     80170b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c3:	8b 00                	mov    (%eax),%eax
  8016c5:	89 04 24             	mov    %eax,(%esp)
  8016c8:	e8 42 fb ff ff       	call   80120f <dev_lookup>
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 3a                	js     80170b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  8016d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016d8:	74 2c                	je     801706 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016da:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016dd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016e4:	00 00 00 
	stat->st_isdir = 0;
  8016e7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016ee:	00 00 00 
	stat->st_dev = dev;
  8016f1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016fe:	89 14 24             	mov    %edx,(%esp)
  801701:	ff 50 14             	call   *0x14(%eax)
  801704:	eb 05                	jmp    80170b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801706:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80170b:	83 c4 24             	add    $0x24,%esp
  80170e:	5b                   	pop    %ebx
  80170f:	5d                   	pop    %ebp
  801710:	c3                   	ret    

00801711 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 18             	sub    $0x18,%esp
  801717:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80171a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80171d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801724:	00 
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	89 04 24             	mov    %eax,(%esp)
  80172b:	e8 bc 01 00 00       	call   8018ec <open>
  801730:	89 c3                	mov    %eax,%ebx
  801732:	85 c0                	test   %eax,%eax
  801734:	78 1b                	js     801751 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801736:	8b 45 0c             	mov    0xc(%ebp),%eax
  801739:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173d:	89 1c 24             	mov    %ebx,(%esp)
  801740:	e8 54 ff ff ff       	call   801699 <fstat>
  801745:	89 c6                	mov    %eax,%esi
	close(fd);
  801747:	89 1c 24             	mov    %ebx,(%esp)
  80174a:	e8 be fb ff ff       	call   80130d <close>
	return r;
  80174f:	89 f3                	mov    %esi,%ebx
}
  801751:	89 d8                	mov    %ebx,%eax
  801753:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801756:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801759:	89 ec                	mov    %ebp,%esp
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    
  80175d:	00 00                	add    %al,(%eax)
	...

00801760 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 18             	sub    $0x18,%esp
  801766:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801769:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80176c:	89 c3                	mov    %eax,%ebx
  80176e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801770:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801777:	75 11                	jne    80178a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801779:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801780:	e8 91 09 00 00       	call   802116 <ipc_find_env>
  801785:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80178a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801791:	00 
  801792:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801799:	00 
  80179a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80179e:	a1 04 40 80 00       	mov    0x804004,%eax
  8017a3:	89 04 24             	mov    %eax,(%esp)
  8017a6:	e8 e7 08 00 00       	call   802092 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017b2:	00 
  8017b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017be:	e8 7d 08 00 00       	call   802040 <ipc_recv>
}
  8017c3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8017c6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8017c9:	89 ec                	mov    %ebp,%esp
  8017cb:	5d                   	pop    %ebp
  8017cc:	c3                   	ret    

008017cd <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	53                   	push   %ebx
  8017d1:	83 ec 14             	sub    $0x14,%esp
  8017d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	8b 40 0c             	mov    0xc(%eax),%eax
  8017dd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e7:	b8 05 00 00 00       	mov    $0x5,%eax
  8017ec:	e8 6f ff ff ff       	call   801760 <fsipc>
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	78 2b                	js     801820 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017f5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017fc:	00 
  8017fd:	89 1c 24             	mov    %ebx,(%esp)
  801800:	e8 46 f1 ff ff       	call   80094b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801805:	a1 80 50 80 00       	mov    0x805080,%eax
  80180a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801810:	a1 84 50 80 00       	mov    0x805084,%eax
  801815:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801820:	83 c4 14             	add    $0x14,%esp
  801823:	5b                   	pop    %ebx
  801824:	5d                   	pop    %ebp
  801825:	c3                   	ret    

00801826 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	8b 40 0c             	mov    0xc(%eax),%eax
  801832:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801837:	ba 00 00 00 00       	mov    $0x0,%edx
  80183c:	b8 06 00 00 00       	mov    $0x6,%eax
  801841:	e8 1a ff ff ff       	call   801760 <fsipc>
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	56                   	push   %esi
  80184c:	53                   	push   %ebx
  80184d:	83 ec 10             	sub    $0x10,%esp
  801850:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	8b 40 0c             	mov    0xc(%eax),%eax
  801859:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80185e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801864:	ba 00 00 00 00       	mov    $0x0,%edx
  801869:	b8 03 00 00 00       	mov    $0x3,%eax
  80186e:	e8 ed fe ff ff       	call   801760 <fsipc>
  801873:	89 c3                	mov    %eax,%ebx
  801875:	85 c0                	test   %eax,%eax
  801877:	78 6a                	js     8018e3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801879:	39 c6                	cmp    %eax,%esi
  80187b:	73 24                	jae    8018a1 <devfile_read+0x59>
  80187d:	c7 44 24 0c 9c 28 80 	movl   $0x80289c,0xc(%esp)
  801884:	00 
  801885:	c7 44 24 08 a3 28 80 	movl   $0x8028a3,0x8(%esp)
  80188c:	00 
  80188d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801894:	00 
  801895:	c7 04 24 b8 28 80 00 	movl   $0x8028b8,(%esp)
  80189c:	e8 97 e9 ff ff       	call   800238 <_panic>
	assert(r <= PGSIZE);
  8018a1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018a6:	7e 24                	jle    8018cc <devfile_read+0x84>
  8018a8:	c7 44 24 0c c3 28 80 	movl   $0x8028c3,0xc(%esp)
  8018af:	00 
  8018b0:	c7 44 24 08 a3 28 80 	movl   $0x8028a3,0x8(%esp)
  8018b7:	00 
  8018b8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8018bf:	00 
  8018c0:	c7 04 24 b8 28 80 00 	movl   $0x8028b8,(%esp)
  8018c7:	e8 6c e9 ff ff       	call   800238 <_panic>
	memmove(buf, &fsipcbuf, r);
  8018cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018d0:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8018d7:	00 
  8018d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018db:	89 04 24             	mov    %eax,(%esp)
  8018de:	e8 59 f2 ff ff       	call   800b3c <memmove>
	return r;
}
  8018e3:	89 d8                	mov    %ebx,%eax
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	5b                   	pop    %ebx
  8018e9:	5e                   	pop    %esi
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    

008018ec <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	56                   	push   %esi
  8018f0:	53                   	push   %ebx
  8018f1:	83 ec 20             	sub    $0x20,%esp
  8018f4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018f7:	89 34 24             	mov    %esi,(%esp)
  8018fa:	e8 01 f0 ff ff       	call   800900 <strlen>
		return -E_BAD_PATH;
  8018ff:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801904:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801909:	7f 5e                	jg     801969 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80190b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190e:	89 04 24             	mov    %eax,(%esp)
  801911:	e8 35 f8 ff ff       	call   80114b <fd_alloc>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 4d                	js     801969 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80191c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801920:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801927:	e8 1f f0 ff ff       	call   80094b <strcpy>
	fsipcbuf.open.req_omode = mode;
  80192c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801934:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801937:	b8 01 00 00 00       	mov    $0x1,%eax
  80193c:	e8 1f fe ff ff       	call   801760 <fsipc>
  801941:	89 c3                	mov    %eax,%ebx
  801943:	85 c0                	test   %eax,%eax
  801945:	79 15                	jns    80195c <open+0x70>
		fd_close(fd, 0);
  801947:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80194e:	00 
  80194f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801952:	89 04 24             	mov    %eax,(%esp)
  801955:	e8 21 f9 ff ff       	call   80127b <fd_close>
		return r;
  80195a:	eb 0d                	jmp    801969 <open+0x7d>
	}

	return fd2num(fd);
  80195c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195f:	89 04 24             	mov    %eax,(%esp)
  801962:	e8 b9 f7 ff ff       	call   801120 <fd2num>
  801967:	89 c3                	mov    %eax,%ebx
}
  801969:	89 d8                	mov    %ebx,%eax
  80196b:	83 c4 20             	add    $0x20,%esp
  80196e:	5b                   	pop    %ebx
  80196f:	5e                   	pop    %esi
  801970:	5d                   	pop    %ebp
  801971:	c3                   	ret    
	...

00801974 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	53                   	push   %ebx
  801978:	83 ec 14             	sub    $0x14,%esp
  80197b:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  80197d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801981:	7e 31                	jle    8019b4 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801983:	8b 40 04             	mov    0x4(%eax),%eax
  801986:	89 44 24 08          	mov    %eax,0x8(%esp)
  80198a:	8d 43 10             	lea    0x10(%ebx),%eax
  80198d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801991:	8b 03                	mov    (%ebx),%eax
  801993:	89 04 24             	mov    %eax,(%esp)
  801996:	e8 c3 fb ff ff       	call   80155e <write>
		if (result > 0)
  80199b:	85 c0                	test   %eax,%eax
  80199d:	7e 03                	jle    8019a2 <writebuf+0x2e>
			b->result += result;
  80199f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019a2:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019a5:	74 0d                	je     8019b4 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ae:	0f 4f c2             	cmovg  %edx,%eax
  8019b1:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019b4:	83 c4 14             	add    $0x14,%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5d                   	pop    %ebp
  8019b9:	c3                   	ret    

008019ba <putch>:

static void
putch(int ch, void *thunk)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	53                   	push   %ebx
  8019be:	83 ec 04             	sub    $0x4,%esp
  8019c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019c4:	8b 43 04             	mov    0x4(%ebx),%eax
  8019c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ca:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  8019ce:	83 c0 01             	add    $0x1,%eax
  8019d1:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  8019d4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019d9:	75 0e                	jne    8019e9 <putch+0x2f>
		writebuf(b);
  8019db:	89 d8                	mov    %ebx,%eax
  8019dd:	e8 92 ff ff ff       	call   801974 <writebuf>
		b->idx = 0;
  8019e2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  8019e9:	83 c4 04             	add    $0x4,%esp
  8019ec:	5b                   	pop    %ebx
  8019ed:	5d                   	pop    %ebp
  8019ee:	c3                   	ret    

008019ef <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a01:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a08:	00 00 00 
	b.result = 0;
  801a0b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a12:	00 00 00 
	b.error = 1;
  801a15:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a1c:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a22:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a29:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a2d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a37:	c7 04 24 ba 19 80 00 	movl   $0x8019ba,(%esp)
  801a3e:	e8 67 ea ff ff       	call   8004aa <vprintfmt>
	if (b.idx > 0)
  801a43:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a4a:	7e 0b                	jle    801a57 <vfprintf+0x68>
		writebuf(&b);
  801a4c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a52:	e8 1d ff ff ff       	call   801974 <writebuf>

	return (b.result ? b.result : b.error);
  801a57:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a6e:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a71:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	89 04 24             	mov    %eax,(%esp)
  801a82:	e8 68 ff ff ff       	call   8019ef <vfprintf>
	va_end(ap);

	return cnt;
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <printf>:

int
printf(const char *fmt, ...)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a8f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801aa4:	e8 46 ff ff ff       	call   8019ef <vfprintf>
	va_end(ap);

	return cnt;
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    
  801aab:	00 00                	add    %al,(%eax)
  801aad:	00 00                	add    %al,(%eax)
	...

00801ab0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 18             	sub    $0x18,%esp
  801ab6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ab9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801abc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	89 04 24             	mov    %eax,(%esp)
  801ac5:	e8 66 f6 ff ff       	call   801130 <fd2data>
  801aca:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801acc:	c7 44 24 04 cf 28 80 	movl   $0x8028cf,0x4(%esp)
  801ad3:	00 
  801ad4:	89 34 24             	mov    %esi,(%esp)
  801ad7:	e8 6f ee ff ff       	call   80094b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801adc:	8b 43 04             	mov    0x4(%ebx),%eax
  801adf:	2b 03                	sub    (%ebx),%eax
  801ae1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801ae7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801aee:	00 00 00 
	stat->st_dev = &devpipe;
  801af1:	c7 86 88 00 00 00 24 	movl   $0x803024,0x88(%esi)
  801af8:	30 80 00 
	return 0;
}
  801afb:	b8 00 00 00 00       	mov    $0x0,%eax
  801b00:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b03:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b06:	89 ec                	mov    %ebp,%esp
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	53                   	push   %ebx
  801b0e:	83 ec 14             	sub    $0x14,%esp
  801b11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b14:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b18:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1f:	e8 e5 f3 ff ff       	call   800f09 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b24:	89 1c 24             	mov    %ebx,(%esp)
  801b27:	e8 04 f6 ff ff       	call   801130 <fd2data>
  801b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b37:	e8 cd f3 ff ff       	call   800f09 <sys_page_unmap>
}
  801b3c:	83 c4 14             	add    $0x14,%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5d                   	pop    %ebp
  801b41:	c3                   	ret    

00801b42 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	57                   	push   %edi
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	83 ec 2c             	sub    $0x2c,%esp
  801b4b:	89 c7                	mov    %eax,%edi
  801b4d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801b50:	a1 08 40 80 00       	mov    0x804008,%eax
  801b55:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b58:	89 3c 24             	mov    %edi,(%esp)
  801b5b:	e8 00 06 00 00       	call   802160 <pageref>
  801b60:	89 c6                	mov    %eax,%esi
  801b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b65:	89 04 24             	mov    %eax,(%esp)
  801b68:	e8 f3 05 00 00       	call   802160 <pageref>
  801b6d:	39 c6                	cmp    %eax,%esi
  801b6f:	0f 94 c0             	sete   %al
  801b72:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801b75:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b7b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b7e:	39 cb                	cmp    %ecx,%ebx
  801b80:	75 08                	jne    801b8a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801b82:	83 c4 2c             	add    $0x2c,%esp
  801b85:	5b                   	pop    %ebx
  801b86:	5e                   	pop    %esi
  801b87:	5f                   	pop    %edi
  801b88:	5d                   	pop    %ebp
  801b89:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801b8a:	83 f8 01             	cmp    $0x1,%eax
  801b8d:	75 c1                	jne    801b50 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b8f:	8b 52 58             	mov    0x58(%edx),%edx
  801b92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b96:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b9a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b9e:	c7 04 24 d6 28 80 00 	movl   $0x8028d6,(%esp)
  801ba5:	e8 89 e7 ff ff       	call   800333 <cprintf>
  801baa:	eb a4                	jmp    801b50 <_pipeisclosed+0xe>

00801bac <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	57                   	push   %edi
  801bb0:	56                   	push   %esi
  801bb1:	53                   	push   %ebx
  801bb2:	83 ec 2c             	sub    $0x2c,%esp
  801bb5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801bb8:	89 34 24             	mov    %esi,(%esp)
  801bbb:	e8 70 f5 ff ff       	call   801130 <fd2data>
  801bc0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bc2:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bcb:	75 50                	jne    801c1d <devpipe_write+0x71>
  801bcd:	eb 5c                	jmp    801c2b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801bcf:	89 da                	mov    %ebx,%edx
  801bd1:	89 f0                	mov    %esi,%eax
  801bd3:	e8 6a ff ff ff       	call   801b42 <_pipeisclosed>
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	75 53                	jne    801c2f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801bdc:	e8 3b f2 ff ff       	call   800e1c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801be1:	8b 43 04             	mov    0x4(%ebx),%eax
  801be4:	8b 13                	mov    (%ebx),%edx
  801be6:	83 c2 20             	add    $0x20,%edx
  801be9:	39 d0                	cmp    %edx,%eax
  801beb:	73 e2                	jae    801bcf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801bf4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801bf7:	89 c2                	mov    %eax,%edx
  801bf9:	c1 fa 1f             	sar    $0x1f,%edx
  801bfc:	c1 ea 1b             	shr    $0x1b,%edx
  801bff:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801c02:	83 e1 1f             	and    $0x1f,%ecx
  801c05:	29 d1                	sub    %edx,%ecx
  801c07:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801c0b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801c0f:	83 c0 01             	add    $0x1,%eax
  801c12:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c15:	83 c7 01             	add    $0x1,%edi
  801c18:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c1b:	74 0e                	je     801c2b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c1d:	8b 43 04             	mov    0x4(%ebx),%eax
  801c20:	8b 13                	mov    (%ebx),%edx
  801c22:	83 c2 20             	add    $0x20,%edx
  801c25:	39 d0                	cmp    %edx,%eax
  801c27:	73 a6                	jae    801bcf <devpipe_write+0x23>
  801c29:	eb c2                	jmp    801bed <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801c2b:	89 f8                	mov    %edi,%eax
  801c2d:	eb 05                	jmp    801c34 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c2f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801c34:	83 c4 2c             	add    $0x2c,%esp
  801c37:	5b                   	pop    %ebx
  801c38:	5e                   	pop    %esi
  801c39:	5f                   	pop    %edi
  801c3a:	5d                   	pop    %ebp
  801c3b:	c3                   	ret    

00801c3c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	83 ec 28             	sub    $0x28,%esp
  801c42:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801c45:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801c48:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801c4b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801c4e:	89 3c 24             	mov    %edi,(%esp)
  801c51:	e8 da f4 ff ff       	call   801130 <fd2data>
  801c56:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c58:	be 00 00 00 00       	mov    $0x0,%esi
  801c5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c61:	75 47                	jne    801caa <devpipe_read+0x6e>
  801c63:	eb 52                	jmp    801cb7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801c65:	89 f0                	mov    %esi,%eax
  801c67:	eb 5e                	jmp    801cc7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801c69:	89 da                	mov    %ebx,%edx
  801c6b:	89 f8                	mov    %edi,%eax
  801c6d:	8d 76 00             	lea    0x0(%esi),%esi
  801c70:	e8 cd fe ff ff       	call   801b42 <_pipeisclosed>
  801c75:	85 c0                	test   %eax,%eax
  801c77:	75 49                	jne    801cc2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801c79:	e8 9e f1 ff ff       	call   800e1c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801c7e:	8b 03                	mov    (%ebx),%eax
  801c80:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c83:	74 e4                	je     801c69 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c85:	89 c2                	mov    %eax,%edx
  801c87:	c1 fa 1f             	sar    $0x1f,%edx
  801c8a:	c1 ea 1b             	shr    $0x1b,%edx
  801c8d:	01 d0                	add    %edx,%eax
  801c8f:	83 e0 1f             	and    $0x1f,%eax
  801c92:	29 d0                	sub    %edx,%eax
  801c94:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801c9f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ca2:	83 c6 01             	add    $0x1,%esi
  801ca5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ca8:	74 0d                	je     801cb7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801caa:	8b 03                	mov    (%ebx),%eax
  801cac:	3b 43 04             	cmp    0x4(%ebx),%eax
  801caf:	75 d4                	jne    801c85 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801cb1:	85 f6                	test   %esi,%esi
  801cb3:	75 b0                	jne    801c65 <devpipe_read+0x29>
  801cb5:	eb b2                	jmp    801c69 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801cb7:	89 f0                	mov    %esi,%eax
  801cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cc0:	eb 05                	jmp    801cc7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801cc2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801cc7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801cca:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ccd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801cd0:	89 ec                	mov    %ebp,%esp
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    

00801cd4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 48             	sub    $0x48,%esp
  801cda:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801cdd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ce0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ce3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ce6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ce9:	89 04 24             	mov    %eax,(%esp)
  801cec:	e8 5a f4 ff ff       	call   80114b <fd_alloc>
  801cf1:	89 c3                	mov    %eax,%ebx
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	0f 88 45 01 00 00    	js     801e40 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cfb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d02:	00 
  801d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d11:	e8 36 f1 ff ff       	call   800e4c <sys_page_alloc>
  801d16:	89 c3                	mov    %eax,%ebx
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	0f 88 20 01 00 00    	js     801e40 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801d20:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d23:	89 04 24             	mov    %eax,(%esp)
  801d26:	e8 20 f4 ff ff       	call   80114b <fd_alloc>
  801d2b:	89 c3                	mov    %eax,%ebx
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	0f 88 f8 00 00 00    	js     801e2d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d35:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d3c:	00 
  801d3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d4b:	e8 fc f0 ff ff       	call   800e4c <sys_page_alloc>
  801d50:	89 c3                	mov    %eax,%ebx
  801d52:	85 c0                	test   %eax,%eax
  801d54:	0f 88 d3 00 00 00    	js     801e2d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d5d:	89 04 24             	mov    %eax,(%esp)
  801d60:	e8 cb f3 ff ff       	call   801130 <fd2data>
  801d65:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d67:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d6e:	00 
  801d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d7a:	e8 cd f0 ff ff       	call   800e4c <sys_page_alloc>
  801d7f:	89 c3                	mov    %eax,%ebx
  801d81:	85 c0                	test   %eax,%eax
  801d83:	0f 88 91 00 00 00    	js     801e1a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d8c:	89 04 24             	mov    %eax,(%esp)
  801d8f:	e8 9c f3 ff ff       	call   801130 <fd2data>
  801d94:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801d9b:	00 
  801d9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801da0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801da7:	00 
  801da8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db3:	e8 f3 f0 ff ff       	call   800eab <sys_page_map>
  801db8:	89 c3                	mov    %eax,%ebx
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	78 4c                	js     801e0a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801dbe:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dc7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dcc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801dd3:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801dd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ddc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801dde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801deb:	89 04 24             	mov    %eax,(%esp)
  801dee:	e8 2d f3 ff ff       	call   801120 <fd2num>
  801df3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801df5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df8:	89 04 24             	mov    %eax,(%esp)
  801dfb:	e8 20 f3 ff ff       	call   801120 <fd2num>
  801e00:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801e03:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e08:	eb 36                	jmp    801e40 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801e0a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e0e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e15:	e8 ef f0 ff ff       	call   800f09 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e28:	e8 dc f0 ff ff       	call   800f09 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e3b:	e8 c9 f0 ff ff       	call   800f09 <sys_page_unmap>
    err:
	return r;
}
  801e40:	89 d8                	mov    %ebx,%eax
  801e42:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801e45:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801e48:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801e4b:	89 ec                	mov    %ebp,%esp
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    

00801e4f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	89 04 24             	mov    %eax,(%esp)
  801e62:	e8 57 f3 ff ff       	call   8011be <fd_lookup>
  801e67:	85 c0                	test   %eax,%eax
  801e69:	78 15                	js     801e80 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6e:	89 04 24             	mov    %eax,(%esp)
  801e71:	e8 ba f2 ff ff       	call   801130 <fd2data>
	return _pipeisclosed(fd, p);
  801e76:	89 c2                	mov    %eax,%edx
  801e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7b:	e8 c2 fc ff ff       	call   801b42 <_pipeisclosed>
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    
	...

00801e90 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
  801e98:	5d                   	pop    %ebp
  801e99:	c3                   	ret    

00801e9a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801ea0:	c7 44 24 04 ee 28 80 	movl   $0x8028ee,0x4(%esp)
  801ea7:	00 
  801ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eab:	89 04 24             	mov    %eax,(%esp)
  801eae:	e8 98 ea ff ff       	call   80094b <strcpy>
	return 0;
}
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	57                   	push   %edi
  801ebe:	56                   	push   %esi
  801ebf:	53                   	push   %ebx
  801ec0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ec6:	be 00 00 00 00       	mov    $0x0,%esi
  801ecb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ecf:	74 43                	je     801f14 <devcons_write+0x5a>
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ed6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801edc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801edf:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801ee1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801ee4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801ee9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801eec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ef0:	03 45 0c             	add    0xc(%ebp),%eax
  801ef3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef7:	89 3c 24             	mov    %edi,(%esp)
  801efa:	e8 3d ec ff ff       	call   800b3c <memmove>
		sys_cputs(buf, m);
  801eff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f03:	89 3c 24             	mov    %edi,(%esp)
  801f06:	e8 25 ee ff ff       	call   800d30 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f0b:	01 de                	add    %ebx,%esi
  801f0d:	89 f0                	mov    %esi,%eax
  801f0f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f12:	72 c8                	jb     801edc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801f14:	89 f0                	mov    %esi,%eax
  801f16:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801f1c:	5b                   	pop    %ebx
  801f1d:	5e                   	pop    %esi
  801f1e:	5f                   	pop    %edi
  801f1f:	5d                   	pop    %ebp
  801f20:	c3                   	ret    

00801f21 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801f2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f30:	75 07                	jne    801f39 <devcons_read+0x18>
  801f32:	eb 31                	jmp    801f65 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801f34:	e8 e3 ee ff ff       	call   800e1c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f40:	e8 1a ee ff ff       	call   800d5f <sys_cgetc>
  801f45:	85 c0                	test   %eax,%eax
  801f47:	74 eb                	je     801f34 <devcons_read+0x13>
  801f49:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	78 16                	js     801f65 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801f4f:	83 f8 04             	cmp    $0x4,%eax
  801f52:	74 0c                	je     801f60 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f57:	88 10                	mov    %dl,(%eax)
	return 1;
  801f59:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5e:	eb 05                	jmp    801f65 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801f60:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f73:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f7a:	00 
  801f7b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f7e:	89 04 24             	mov    %eax,(%esp)
  801f81:	e8 aa ed ff ff       	call   800d30 <sys_cputs>
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <getchar>:

int
getchar(void)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f8e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801f95:	00 
  801f96:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fa4:	e8 d5 f4 ff ff       	call   80147e <read>
	if (r < 0)
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	78 0f                	js     801fbc <getchar+0x34>
		return r;
	if (r < 1)
  801fad:	85 c0                	test   %eax,%eax
  801faf:	7e 06                	jle    801fb7 <getchar+0x2f>
		return -E_EOF;
	return c;
  801fb1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801fb5:	eb 05                	jmp    801fbc <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801fb7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	89 04 24             	mov    %eax,(%esp)
  801fd1:	e8 e8 f1 ff ff       	call   8011be <fd_lookup>
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	78 11                	js     801feb <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801fe3:	39 10                	cmp    %edx,(%eax)
  801fe5:	0f 94 c0             	sete   %al
  801fe8:	0f b6 c0             	movzbl %al,%eax
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <opencons>:

int
opencons(void)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ff3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff6:	89 04 24             	mov    %eax,(%esp)
  801ff9:	e8 4d f1 ff ff       	call   80114b <fd_alloc>
  801ffe:	85 c0                	test   %eax,%eax
  802000:	78 3c                	js     80203e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802002:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802009:	00 
  80200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802011:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802018:	e8 2f ee ff ff       	call   800e4c <sys_page_alloc>
  80201d:	85 c0                	test   %eax,%eax
  80201f:	78 1d                	js     80203e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802021:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802036:	89 04 24             	mov    %eax,(%esp)
  802039:	e8 e2 f0 ff ff       	call   801120 <fd2num>
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	56                   	push   %esi
  802044:	53                   	push   %ebx
  802045:	83 ec 10             	sub    $0x10,%esp
  802048:	8b 75 08             	mov    0x8(%ebp),%esi
  80204b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802051:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802053:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802058:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80205b:	89 04 24             	mov    %eax,(%esp)
  80205e:	e8 52 f0 ff ff       	call   8010b5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802063:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802068:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80206d:	85 c0                	test   %eax,%eax
  80206f:	78 0e                	js     80207f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  802071:	a1 08 40 80 00       	mov    0x804008,%eax
  802076:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  802079:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80207c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80207f:	85 f6                	test   %esi,%esi
  802081:	74 02                	je     802085 <ipc_recv+0x45>
		*from_env_store = sender;
  802083:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  802085:	85 db                	test   %ebx,%ebx
  802087:	74 02                	je     80208b <ipc_recv+0x4b>
		*perm_store = perm;
  802089:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	5b                   	pop    %ebx
  80208f:	5e                   	pop    %esi
  802090:	5d                   	pop    %ebp
  802091:	c3                   	ret    

00802092 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	57                   	push   %edi
  802096:	56                   	push   %esi
  802097:	53                   	push   %ebx
  802098:	83 ec 1c             	sub    $0x1c,%esp
  80209b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80209e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020a1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  8020a4:	85 db                	test   %ebx,%ebx
  8020a6:	75 04                	jne    8020ac <ipc_send+0x1a>
  8020a8:	85 f6                	test   %esi,%esi
  8020aa:	75 15                	jne    8020c1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  8020ac:	85 db                	test   %ebx,%ebx
  8020ae:	74 16                	je     8020c6 <ipc_send+0x34>
  8020b0:	85 f6                	test   %esi,%esi
  8020b2:	0f 94 c0             	sete   %al
      pg = 0;
  8020b5:	84 c0                	test   %al,%al
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bc:	0f 45 d8             	cmovne %eax,%ebx
  8020bf:	eb 05                	jmp    8020c6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  8020c1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  8020c6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8020ca:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	89 04 24             	mov    %eax,(%esp)
  8020d8:	e8 a4 ef ff ff       	call   801081 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  8020dd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020e0:	75 07                	jne    8020e9 <ipc_send+0x57>
           sys_yield();
  8020e2:	e8 35 ed ff ff       	call   800e1c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  8020e7:	eb dd                	jmp    8020c6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	90                   	nop
  8020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020f0:	74 1c                	je     80210e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  8020f2:	c7 44 24 08 fa 28 80 	movl   $0x8028fa,0x8(%esp)
  8020f9:	00 
  8020fa:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802101:	00 
  802102:	c7 04 24 04 29 80 00 	movl   $0x802904,(%esp)
  802109:	e8 2a e1 ff ff       	call   800238 <_panic>
		}
    }
}
  80210e:	83 c4 1c             	add    $0x1c,%esp
  802111:	5b                   	pop    %ebx
  802112:	5e                   	pop    %esi
  802113:	5f                   	pop    %edi
  802114:	5d                   	pop    %ebp
  802115:	c3                   	ret    

00802116 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80211c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802121:	39 c8                	cmp    %ecx,%eax
  802123:	74 17                	je     80213c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802125:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80212a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80212d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802133:	8b 52 50             	mov    0x50(%edx),%edx
  802136:	39 ca                	cmp    %ecx,%edx
  802138:	75 14                	jne    80214e <ipc_find_env+0x38>
  80213a:	eb 05                	jmp    802141 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802141:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802144:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802149:	8b 40 40             	mov    0x40(%eax),%eax
  80214c:	eb 0e                	jmp    80215c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80214e:	83 c0 01             	add    $0x1,%eax
  802151:	3d 00 04 00 00       	cmp    $0x400,%eax
  802156:	75 d2                	jne    80212a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802158:	66 b8 00 00          	mov    $0x0,%ax
}
  80215c:	5d                   	pop    %ebp
  80215d:	c3                   	ret    
	...

00802160 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802166:	89 d0                	mov    %edx,%eax
  802168:	c1 e8 16             	shr    $0x16,%eax
  80216b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802172:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802177:	f6 c1 01             	test   $0x1,%cl
  80217a:	74 1d                	je     802199 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80217c:	c1 ea 0c             	shr    $0xc,%edx
  80217f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802186:	f6 c2 01             	test   $0x1,%dl
  802189:	74 0e                	je     802199 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80218b:	c1 ea 0c             	shr    $0xc,%edx
  80218e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802195:	ef 
  802196:	0f b7 c0             	movzwl %ax,%eax
}
  802199:	5d                   	pop    %ebp
  80219a:	c3                   	ret    
  80219b:	00 00                	add    %al,(%eax)
  80219d:	00 00                	add    %al,(%eax)
	...

008021a0 <__udivdi3>:
  8021a0:	83 ec 1c             	sub    $0x1c,%esp
  8021a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8021a7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8021ab:	8b 44 24 20          	mov    0x20(%esp),%eax
  8021af:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8021b3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8021b7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8021bb:	85 ff                	test   %edi,%edi
  8021bd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8021c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c5:	89 cd                	mov    %ecx,%ebp
  8021c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cb:	75 33                	jne    802200 <__udivdi3+0x60>
  8021cd:	39 f1                	cmp    %esi,%ecx
  8021cf:	77 57                	ja     802228 <__udivdi3+0x88>
  8021d1:	85 c9                	test   %ecx,%ecx
  8021d3:	75 0b                	jne    8021e0 <__udivdi3+0x40>
  8021d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8021da:	31 d2                	xor    %edx,%edx
  8021dc:	f7 f1                	div    %ecx
  8021de:	89 c1                	mov    %eax,%ecx
  8021e0:	89 f0                	mov    %esi,%eax
  8021e2:	31 d2                	xor    %edx,%edx
  8021e4:	f7 f1                	div    %ecx
  8021e6:	89 c6                	mov    %eax,%esi
  8021e8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021ec:	f7 f1                	div    %ecx
  8021ee:	89 f2                	mov    %esi,%edx
  8021f0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8021f4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8021f8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8021fc:	83 c4 1c             	add    $0x1c,%esp
  8021ff:	c3                   	ret    
  802200:	31 d2                	xor    %edx,%edx
  802202:	31 c0                	xor    %eax,%eax
  802204:	39 f7                	cmp    %esi,%edi
  802206:	77 e8                	ja     8021f0 <__udivdi3+0x50>
  802208:	0f bd cf             	bsr    %edi,%ecx
  80220b:	83 f1 1f             	xor    $0x1f,%ecx
  80220e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802212:	75 2c                	jne    802240 <__udivdi3+0xa0>
  802214:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802218:	76 04                	jbe    80221e <__udivdi3+0x7e>
  80221a:	39 f7                	cmp    %esi,%edi
  80221c:	73 d2                	jae    8021f0 <__udivdi3+0x50>
  80221e:	31 d2                	xor    %edx,%edx
  802220:	b8 01 00 00 00       	mov    $0x1,%eax
  802225:	eb c9                	jmp    8021f0 <__udivdi3+0x50>
  802227:	90                   	nop
  802228:	89 f2                	mov    %esi,%edx
  80222a:	f7 f1                	div    %ecx
  80222c:	31 d2                	xor    %edx,%edx
  80222e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802232:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802236:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80223a:	83 c4 1c             	add    $0x1c,%esp
  80223d:	c3                   	ret    
  80223e:	66 90                	xchg   %ax,%ax
  802240:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802245:	b8 20 00 00 00       	mov    $0x20,%eax
  80224a:	89 ea                	mov    %ebp,%edx
  80224c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802250:	d3 e7                	shl    %cl,%edi
  802252:	89 c1                	mov    %eax,%ecx
  802254:	d3 ea                	shr    %cl,%edx
  802256:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80225b:	09 fa                	or     %edi,%edx
  80225d:	89 f7                	mov    %esi,%edi
  80225f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802263:	89 f2                	mov    %esi,%edx
  802265:	8b 74 24 08          	mov    0x8(%esp),%esi
  802269:	d3 e5                	shl    %cl,%ebp
  80226b:	89 c1                	mov    %eax,%ecx
  80226d:	d3 ef                	shr    %cl,%edi
  80226f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802274:	d3 e2                	shl    %cl,%edx
  802276:	89 c1                	mov    %eax,%ecx
  802278:	d3 ee                	shr    %cl,%esi
  80227a:	09 d6                	or     %edx,%esi
  80227c:	89 fa                	mov    %edi,%edx
  80227e:	89 f0                	mov    %esi,%eax
  802280:	f7 74 24 0c          	divl   0xc(%esp)
  802284:	89 d7                	mov    %edx,%edi
  802286:	89 c6                	mov    %eax,%esi
  802288:	f7 e5                	mul    %ebp
  80228a:	39 d7                	cmp    %edx,%edi
  80228c:	72 22                	jb     8022b0 <__udivdi3+0x110>
  80228e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802292:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802297:	d3 e5                	shl    %cl,%ebp
  802299:	39 c5                	cmp    %eax,%ebp
  80229b:	73 04                	jae    8022a1 <__udivdi3+0x101>
  80229d:	39 d7                	cmp    %edx,%edi
  80229f:	74 0f                	je     8022b0 <__udivdi3+0x110>
  8022a1:	89 f0                	mov    %esi,%eax
  8022a3:	31 d2                	xor    %edx,%edx
  8022a5:	e9 46 ff ff ff       	jmp    8021f0 <__udivdi3+0x50>
  8022aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022b0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8022b3:	31 d2                	xor    %edx,%edx
  8022b5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8022b9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8022bd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8022c1:	83 c4 1c             	add    $0x1c,%esp
  8022c4:	c3                   	ret    
	...

008022d0 <__umoddi3>:
  8022d0:	83 ec 1c             	sub    $0x1c,%esp
  8022d3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8022d7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8022db:	8b 44 24 20          	mov    0x20(%esp),%eax
  8022df:	89 74 24 10          	mov    %esi,0x10(%esp)
  8022e3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8022e7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8022eb:	85 ed                	test   %ebp,%ebp
  8022ed:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8022f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022f5:	89 cf                	mov    %ecx,%edi
  8022f7:	89 04 24             	mov    %eax,(%esp)
  8022fa:	89 f2                	mov    %esi,%edx
  8022fc:	75 1a                	jne    802318 <__umoddi3+0x48>
  8022fe:	39 f1                	cmp    %esi,%ecx
  802300:	76 4e                	jbe    802350 <__umoddi3+0x80>
  802302:	f7 f1                	div    %ecx
  802304:	89 d0                	mov    %edx,%eax
  802306:	31 d2                	xor    %edx,%edx
  802308:	8b 74 24 10          	mov    0x10(%esp),%esi
  80230c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802310:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802314:	83 c4 1c             	add    $0x1c,%esp
  802317:	c3                   	ret    
  802318:	39 f5                	cmp    %esi,%ebp
  80231a:	77 54                	ja     802370 <__umoddi3+0xa0>
  80231c:	0f bd c5             	bsr    %ebp,%eax
  80231f:	83 f0 1f             	xor    $0x1f,%eax
  802322:	89 44 24 04          	mov    %eax,0x4(%esp)
  802326:	75 60                	jne    802388 <__umoddi3+0xb8>
  802328:	3b 0c 24             	cmp    (%esp),%ecx
  80232b:	0f 87 07 01 00 00    	ja     802438 <__umoddi3+0x168>
  802331:	89 f2                	mov    %esi,%edx
  802333:	8b 34 24             	mov    (%esp),%esi
  802336:	29 ce                	sub    %ecx,%esi
  802338:	19 ea                	sbb    %ebp,%edx
  80233a:	89 34 24             	mov    %esi,(%esp)
  80233d:	8b 04 24             	mov    (%esp),%eax
  802340:	8b 74 24 10          	mov    0x10(%esp),%esi
  802344:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802348:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80234c:	83 c4 1c             	add    $0x1c,%esp
  80234f:	c3                   	ret    
  802350:	85 c9                	test   %ecx,%ecx
  802352:	75 0b                	jne    80235f <__umoddi3+0x8f>
  802354:	b8 01 00 00 00       	mov    $0x1,%eax
  802359:	31 d2                	xor    %edx,%edx
  80235b:	f7 f1                	div    %ecx
  80235d:	89 c1                	mov    %eax,%ecx
  80235f:	89 f0                	mov    %esi,%eax
  802361:	31 d2                	xor    %edx,%edx
  802363:	f7 f1                	div    %ecx
  802365:	8b 04 24             	mov    (%esp),%eax
  802368:	f7 f1                	div    %ecx
  80236a:	eb 98                	jmp    802304 <__umoddi3+0x34>
  80236c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802370:	89 f2                	mov    %esi,%edx
  802372:	8b 74 24 10          	mov    0x10(%esp),%esi
  802376:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80237a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	c3                   	ret    
  802382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802388:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80238d:	89 e8                	mov    %ebp,%eax
  80238f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802394:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802398:	89 fa                	mov    %edi,%edx
  80239a:	d3 e0                	shl    %cl,%eax
  80239c:	89 e9                	mov    %ebp,%ecx
  80239e:	d3 ea                	shr    %cl,%edx
  8023a0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023a5:	09 c2                	or     %eax,%edx
  8023a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023ab:	89 14 24             	mov    %edx,(%esp)
  8023ae:	89 f2                	mov    %esi,%edx
  8023b0:	d3 e7                	shl    %cl,%edi
  8023b2:	89 e9                	mov    %ebp,%ecx
  8023b4:	d3 ea                	shr    %cl,%edx
  8023b6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023bf:	d3 e6                	shl    %cl,%esi
  8023c1:	89 e9                	mov    %ebp,%ecx
  8023c3:	d3 e8                	shr    %cl,%eax
  8023c5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023ca:	09 f0                	or     %esi,%eax
  8023cc:	8b 74 24 08          	mov    0x8(%esp),%esi
  8023d0:	f7 34 24             	divl   (%esp)
  8023d3:	d3 e6                	shl    %cl,%esi
  8023d5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8023d9:	89 d6                	mov    %edx,%esi
  8023db:	f7 e7                	mul    %edi
  8023dd:	39 d6                	cmp    %edx,%esi
  8023df:	89 c1                	mov    %eax,%ecx
  8023e1:	89 d7                	mov    %edx,%edi
  8023e3:	72 3f                	jb     802424 <__umoddi3+0x154>
  8023e5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8023e9:	72 35                	jb     802420 <__umoddi3+0x150>
  8023eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023ef:	29 c8                	sub    %ecx,%eax
  8023f1:	19 fe                	sbb    %edi,%esi
  8023f3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023f8:	89 f2                	mov    %esi,%edx
  8023fa:	d3 e8                	shr    %cl,%eax
  8023fc:	89 e9                	mov    %ebp,%ecx
  8023fe:	d3 e2                	shl    %cl,%edx
  802400:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802405:	09 d0                	or     %edx,%eax
  802407:	89 f2                	mov    %esi,%edx
  802409:	d3 ea                	shr    %cl,%edx
  80240b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80240f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802413:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802417:	83 c4 1c             	add    $0x1c,%esp
  80241a:	c3                   	ret    
  80241b:	90                   	nop
  80241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802420:	39 d6                	cmp    %edx,%esi
  802422:	75 c7                	jne    8023eb <__umoddi3+0x11b>
  802424:	89 d7                	mov    %edx,%edi
  802426:	89 c1                	mov    %eax,%ecx
  802428:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80242c:	1b 3c 24             	sbb    (%esp),%edi
  80242f:	eb ba                	jmp    8023eb <__umoddi3+0x11b>
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	39 f5                	cmp    %esi,%ebp
  80243a:	0f 82 f1 fe ff ff    	jb     802331 <__umoddi3+0x61>
  802440:	e9 f8 fe ff ff       	jmp    80233d <__umoddi3+0x6d>
