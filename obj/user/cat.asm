
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 3b 01 00 00       	call   80016c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
  80003d:	8b 75 08             	mov    0x8(%ebp),%esi
  800040:	8b 7d 0c             	mov    0xc(%ebp),%edi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800043:	eb 40                	jmp    800085 <cat+0x51>
		if ((r = write(1, buf, n)) != n)
  800045:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800049:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  800050:	00 
  800051:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800058:	e8 a1 14 00 00       	call   8014fe <write>
  80005d:	39 d8                	cmp    %ebx,%eax
  80005f:	74 24                	je     800085 <cat+0x51>
			panic("write error copying %s: %e", s, r);
  800061:	89 44 24 10          	mov    %eax,0x10(%esp)
  800065:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800069:	c7 44 24 08 00 24 80 	movl   $0x802400,0x8(%esp)
  800070:	00 
  800071:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800078:	00 
  800079:	c7 04 24 1b 24 80 00 	movl   $0x80241b,(%esp)
  800080:	e8 53 01 00 00       	call   8001d8 <_panic>
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800085:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  800094:	00 
  800095:	89 34 24             	mov    %esi,(%esp)
  800098:	e8 81 13 00 00       	call   80141e <read>
  80009d:	89 c3                	mov    %eax,%ebx
  80009f:	85 c0                	test   %eax,%eax
  8000a1:	7f a2                	jg     800045 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000a3:	85 c0                	test   %eax,%eax
  8000a5:	79 24                	jns    8000cb <cat+0x97>
		panic("error reading %s: %e", s, n);
  8000a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000af:	c7 44 24 08 26 24 80 	movl   $0x802426,0x8(%esp)
  8000b6:	00 
  8000b7:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000be:	00 
  8000bf:	c7 04 24 1b 24 80 00 	movl   $0x80241b,(%esp)
  8000c6:	e8 0d 01 00 00       	call   8001d8 <_panic>
}
  8000cb:	83 c4 2c             	add    $0x2c,%esp
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5f                   	pop    %edi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <umain>:

void
umain(int argc, char **argv)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 1c             	sub    $0x1c,%esp
  8000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	int f, i;

	binaryname = "cat";
  8000df:	c7 05 00 30 80 00 3b 	movl   $0x80243b,0x803000
  8000e6:	24 80 00 
	if (argc == 1)
  8000e9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ed:	74 0d                	je     8000fc <umain+0x29>
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000ef:	bb 01 00 00 00       	mov    $0x1,%ebx
  8000f4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000f8:	7f 18                	jg     800112 <umain+0x3f>
  8000fa:	eb 67                	jmp    800163 <umain+0x90>
{
	int f, i;

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
  8000fc:	c7 44 24 04 3f 24 80 	movl   $0x80243f,0x4(%esp)
  800103:	00 
  800104:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80010b:	e8 24 ff ff ff       	call   800034 <cat>
  800110:	eb 51                	jmp    800163 <umain+0x90>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800112:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800119:	00 
  80011a:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  80011d:	89 04 24             	mov    %eax,(%esp)
  800120:	e8 67 17 00 00       	call   80188c <open>
  800125:	89 c7                	mov    %eax,%edi
			if (f < 0)
  800127:	85 c0                	test   %eax,%eax
  800129:	79 19                	jns    800144 <umain+0x71>
				printf("can't open %s: %e\n", argv[i], f);
  80012b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80012f:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800132:	89 44 24 04          	mov    %eax,0x4(%esp)
  800136:	c7 04 24 47 24 80 00 	movl   $0x802447,(%esp)
  80013d:	e8 e7 18 00 00       	call   801a29 <printf>
  800142:	eb 17                	jmp    80015b <umain+0x88>
			else {
				cat(f, argv[i]);
  800144:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800147:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014b:	89 3c 24             	mov    %edi,(%esp)
  80014e:	e8 e1 fe ff ff       	call   800034 <cat>
				close(f);
  800153:	89 3c 24             	mov    %edi,(%esp)
  800156:	e8 52 11 00 00       	call   8012ad <close>

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80015b:	83 c3 01             	add    $0x1,%ebx
  80015e:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800161:	75 af                	jne    800112 <umain+0x3f>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800163:	83 c4 1c             	add    $0x1c,%esp
  800166:	5b                   	pop    %ebx
  800167:	5e                   	pop    %esi
  800168:	5f                   	pop    %edi
  800169:	5d                   	pop    %ebp
  80016a:	c3                   	ret    
	...

0080016c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
  800172:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800175:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800178:	8b 75 08             	mov    0x8(%ebp),%esi
  80017b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80017e:	e8 09 0c 00 00       	call   800d8c <sys_getenvid>
  800183:	25 ff 03 00 00       	and    $0x3ff,%eax
  800188:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80018b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800190:	a3 20 60 80 00       	mov    %eax,0x806020
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800195:	85 f6                	test   %esi,%esi
  800197:	7e 07                	jle    8001a0 <libmain+0x34>
		binaryname = argv[0];
  800199:	8b 03                	mov    (%ebx),%eax
  80019b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001a4:	89 34 24             	mov    %esi,(%esp)
  8001a7:	e8 27 ff ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  8001ac:	e8 0b 00 00 00       	call   8001bc <exit>
}
  8001b1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001b4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001b7:	89 ec                	mov    %ebp,%esp
  8001b9:	5d                   	pop    %ebp
  8001ba:	c3                   	ret    
	...

008001bc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001c2:	e8 17 11 00 00       	call   8012de <close_all>
	sys_env_destroy(0);
  8001c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001ce:	e8 5c 0b 00 00       	call   800d2f <sys_env_destroy>
}
  8001d3:	c9                   	leave  
  8001d4:	c3                   	ret    
  8001d5:	00 00                	add    %al,(%eax)
	...

008001d8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001e0:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001e3:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8001e9:	e8 9e 0b 00 00       	call   800d8c <sys_getenvid>
  8001ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800200:	89 44 24 04          	mov    %eax,0x4(%esp)
  800204:	c7 04 24 64 24 80 00 	movl   $0x802464,(%esp)
  80020b:	e8 c3 00 00 00       	call   8002d3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800210:	89 74 24 04          	mov    %esi,0x4(%esp)
  800214:	8b 45 10             	mov    0x10(%ebp),%eax
  800217:	89 04 24             	mov    %eax,(%esp)
  80021a:	e8 53 00 00 00       	call   800272 <vcprintf>
	cprintf("\n");
  80021f:	c7 04 24 87 28 80 00 	movl   $0x802887,(%esp)
  800226:	e8 a8 00 00 00       	call   8002d3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80022b:	cc                   	int3   
  80022c:	eb fd                	jmp    80022b <_panic+0x53>
	...

00800230 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	53                   	push   %ebx
  800234:	83 ec 14             	sub    $0x14,%esp
  800237:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80023a:	8b 03                	mov    (%ebx),%eax
  80023c:	8b 55 08             	mov    0x8(%ebp),%edx
  80023f:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800243:	83 c0 01             	add    $0x1,%eax
  800246:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800248:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024d:	75 19                	jne    800268 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80024f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800256:	00 
  800257:	8d 43 08             	lea    0x8(%ebx),%eax
  80025a:	89 04 24             	mov    %eax,(%esp)
  80025d:	e8 6e 0a 00 00       	call   800cd0 <sys_cputs>
		b->idx = 0;
  800262:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800268:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80026c:	83 c4 14             	add    $0x14,%esp
  80026f:	5b                   	pop    %ebx
  800270:	5d                   	pop    %ebp
  800271:	c3                   	ret    

00800272 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80027b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800282:	00 00 00 
	b.cnt = 0;
  800285:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80028c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80028f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800292:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800296:	8b 45 08             	mov    0x8(%ebp),%eax
  800299:	89 44 24 08          	mov    %eax,0x8(%esp)
  80029d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a7:	c7 04 24 30 02 80 00 	movl   $0x800230,(%esp)
  8002ae:	e8 97 01 00 00       	call   80044a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002b3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002c3:	89 04 24             	mov    %eax,(%esp)
  8002c6:	e8 05 0a 00 00       	call   800cd0 <sys_cputs>

	return b.cnt;
}
  8002cb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002d1:	c9                   	leave  
  8002d2:	c3                   	ret    

008002d3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e3:	89 04 24             	mov    %eax,(%esp)
  8002e6:	e8 87 ff ff ff       	call   800272 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002eb:	c9                   	leave  
  8002ec:	c3                   	ret    
  8002ed:	00 00                	add    %al,(%eax)
	...

008002f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
  8002f6:	83 ec 3c             	sub    $0x3c,%esp
  8002f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002fc:	89 d7                	mov    %edx,%edi
  8002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800301:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800304:	8b 45 0c             	mov    0xc(%ebp),%eax
  800307:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80030a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80030d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800310:	b8 00 00 00 00       	mov    $0x0,%eax
  800315:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800318:	72 11                	jb     80032b <printnum+0x3b>
  80031a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80031d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800320:	76 09                	jbe    80032b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800322:	83 eb 01             	sub    $0x1,%ebx
  800325:	85 db                	test   %ebx,%ebx
  800327:	7f 51                	jg     80037a <printnum+0x8a>
  800329:	eb 5e                	jmp    800389 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80032b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80032f:	83 eb 01             	sub    $0x1,%ebx
  800332:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800336:	8b 45 10             	mov    0x10(%ebp),%eax
  800339:	89 44 24 08          	mov    %eax,0x8(%esp)
  80033d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800341:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800345:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80034c:	00 
  80034d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800350:	89 04 24             	mov    %eax,(%esp)
  800353:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800356:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035a:	e8 e1 1d 00 00       	call   802140 <__udivdi3>
  80035f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800363:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800367:	89 04 24             	mov    %eax,(%esp)
  80036a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80036e:	89 fa                	mov    %edi,%edx
  800370:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800373:	e8 78 ff ff ff       	call   8002f0 <printnum>
  800378:	eb 0f                	jmp    800389 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80037a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80037e:	89 34 24             	mov    %esi,(%esp)
  800381:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800384:	83 eb 01             	sub    $0x1,%ebx
  800387:	75 f1                	jne    80037a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800389:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80038d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800391:	8b 45 10             	mov    0x10(%ebp),%eax
  800394:	89 44 24 08          	mov    %eax,0x8(%esp)
  800398:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80039f:	00 
  8003a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a3:	89 04 24             	mov    %eax,(%esp)
  8003a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ad:	e8 be 1e 00 00       	call   802270 <__umoddi3>
  8003b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003b6:	0f be 80 87 24 80 00 	movsbl 0x802487(%eax),%eax
  8003bd:	89 04 24             	mov    %eax,(%esp)
  8003c0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003c3:	83 c4 3c             	add    $0x3c,%esp
  8003c6:	5b                   	pop    %ebx
  8003c7:	5e                   	pop    %esi
  8003c8:	5f                   	pop    %edi
  8003c9:	5d                   	pop    %ebp
  8003ca:	c3                   	ret    

008003cb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003ce:	83 fa 01             	cmp    $0x1,%edx
  8003d1:	7e 0e                	jle    8003e1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003d3:	8b 10                	mov    (%eax),%edx
  8003d5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003d8:	89 08                	mov    %ecx,(%eax)
  8003da:	8b 02                	mov    (%edx),%eax
  8003dc:	8b 52 04             	mov    0x4(%edx),%edx
  8003df:	eb 22                	jmp    800403 <getuint+0x38>
	else if (lflag)
  8003e1:	85 d2                	test   %edx,%edx
  8003e3:	74 10                	je     8003f5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003e5:	8b 10                	mov    (%eax),%edx
  8003e7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ea:	89 08                	mov    %ecx,(%eax)
  8003ec:	8b 02                	mov    (%edx),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	eb 0e                	jmp    800403 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003f5:	8b 10                	mov    (%eax),%edx
  8003f7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003fa:	89 08                	mov    %ecx,(%eax)
  8003fc:	8b 02                	mov    (%edx),%eax
  8003fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800403:	5d                   	pop    %ebp
  800404:	c3                   	ret    

00800405 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80040b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80040f:	8b 10                	mov    (%eax),%edx
  800411:	3b 50 04             	cmp    0x4(%eax),%edx
  800414:	73 0a                	jae    800420 <sprintputch+0x1b>
		*b->buf++ = ch;
  800416:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800419:	88 0a                	mov    %cl,(%edx)
  80041b:	83 c2 01             	add    $0x1,%edx
  80041e:	89 10                	mov    %edx,(%eax)
}
  800420:	5d                   	pop    %ebp
  800421:	c3                   	ret    

00800422 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800428:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80042b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80042f:	8b 45 10             	mov    0x10(%ebp),%eax
  800432:	89 44 24 08          	mov    %eax,0x8(%esp)
  800436:	8b 45 0c             	mov    0xc(%ebp),%eax
  800439:	89 44 24 04          	mov    %eax,0x4(%esp)
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	89 04 24             	mov    %eax,(%esp)
  800443:	e8 02 00 00 00       	call   80044a <vprintfmt>
	va_end(ap);
}
  800448:	c9                   	leave  
  800449:	c3                   	ret    

0080044a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
  80044d:	57                   	push   %edi
  80044e:	56                   	push   %esi
  80044f:	53                   	push   %ebx
  800450:	83 ec 4c             	sub    $0x4c,%esp
  800453:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800456:	8b 75 10             	mov    0x10(%ebp),%esi
  800459:	eb 12                	jmp    80046d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80045b:	85 c0                	test   %eax,%eax
  80045d:	0f 84 a9 03 00 00    	je     80080c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800463:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800467:	89 04 24             	mov    %eax,(%esp)
  80046a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80046d:	0f b6 06             	movzbl (%esi),%eax
  800470:	83 c6 01             	add    $0x1,%esi
  800473:	83 f8 25             	cmp    $0x25,%eax
  800476:	75 e3                	jne    80045b <vprintfmt+0x11>
  800478:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80047c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800483:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800488:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80048f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800494:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800497:	eb 2b                	jmp    8004c4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800499:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80049c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8004a0:	eb 22                	jmp    8004c4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a2:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004a5:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8004a9:	eb 19                	jmp    8004c4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8004ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8004b5:	eb 0d                	jmp    8004c4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004bd:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c4:	0f b6 06             	movzbl (%esi),%eax
  8004c7:	0f b6 d0             	movzbl %al,%edx
  8004ca:	8d 7e 01             	lea    0x1(%esi),%edi
  8004cd:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8004d0:	83 e8 23             	sub    $0x23,%eax
  8004d3:	3c 55                	cmp    $0x55,%al
  8004d5:	0f 87 0b 03 00 00    	ja     8007e6 <vprintfmt+0x39c>
  8004db:	0f b6 c0             	movzbl %al,%eax
  8004de:	ff 24 85 c0 25 80 00 	jmp    *0x8025c0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004e5:	83 ea 30             	sub    $0x30,%edx
  8004e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8004eb:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8004ef:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8004f5:	83 fa 09             	cmp    $0x9,%edx
  8004f8:	77 4a                	ja     800544 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004fd:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800500:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800503:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800507:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80050a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80050d:	83 fa 09             	cmp    $0x9,%edx
  800510:	76 eb                	jbe    8004fd <vprintfmt+0xb3>
  800512:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800515:	eb 2d                	jmp    800544 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8d 50 04             	lea    0x4(%eax),%edx
  80051d:	89 55 14             	mov    %edx,0x14(%ebp)
  800520:	8b 00                	mov    (%eax),%eax
  800522:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800525:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800528:	eb 1a                	jmp    800544 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80052d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800531:	79 91                	jns    8004c4 <vprintfmt+0x7a>
  800533:	e9 73 ff ff ff       	jmp    8004ab <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800538:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80053b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800542:	eb 80                	jmp    8004c4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800544:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800548:	0f 89 76 ff ff ff    	jns    8004c4 <vprintfmt+0x7a>
  80054e:	e9 64 ff ff ff       	jmp    8004b7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800553:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800556:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800559:	e9 66 ff ff ff       	jmp    8004c4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8d 50 04             	lea    0x4(%eax),%edx
  800564:	89 55 14             	mov    %edx,0x14(%ebp)
  800567:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 04 24             	mov    %eax,(%esp)
  800570:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800573:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800576:	e9 f2 fe ff ff       	jmp    80046d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8d 50 04             	lea    0x4(%eax),%edx
  800581:	89 55 14             	mov    %edx,0x14(%ebp)
  800584:	8b 00                	mov    (%eax),%eax
  800586:	89 c2                	mov    %eax,%edx
  800588:	c1 fa 1f             	sar    $0x1f,%edx
  80058b:	31 d0                	xor    %edx,%eax
  80058d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80058f:	83 f8 0f             	cmp    $0xf,%eax
  800592:	7f 0b                	jg     80059f <vprintfmt+0x155>
  800594:	8b 14 85 20 27 80 00 	mov    0x802720(,%eax,4),%edx
  80059b:	85 d2                	test   %edx,%edx
  80059d:	75 23                	jne    8005c2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80059f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005a3:	c7 44 24 08 9f 24 80 	movl   $0x80249f,0x8(%esp)
  8005aa:	00 
  8005ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005af:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005b2:	89 3c 24             	mov    %edi,(%esp)
  8005b5:	e8 68 fe ff ff       	call   800422 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ba:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8005bd:	e9 ab fe ff ff       	jmp    80046d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  8005c2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005c6:	c7 44 24 08 55 28 80 	movl   $0x802855,0x8(%esp)
  8005cd:	00 
  8005ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005d5:	89 3c 24             	mov    %edi,(%esp)
  8005d8:	e8 45 fe ff ff       	call   800422 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005dd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8005e0:	e9 88 fe ff ff       	jmp    80046d <vprintfmt+0x23>
  8005e5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8d 50 04             	lea    0x4(%eax),%edx
  8005f4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005f9:	85 f6                	test   %esi,%esi
  8005fb:	ba 98 24 80 00       	mov    $0x802498,%edx
  800600:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800603:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800607:	7e 06                	jle    80060f <vprintfmt+0x1c5>
  800609:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80060d:	75 10                	jne    80061f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80060f:	0f be 06             	movsbl (%esi),%eax
  800612:	83 c6 01             	add    $0x1,%esi
  800615:	85 c0                	test   %eax,%eax
  800617:	0f 85 86 00 00 00    	jne    8006a3 <vprintfmt+0x259>
  80061d:	eb 76                	jmp    800695 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80061f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800623:	89 34 24             	mov    %esi,(%esp)
  800626:	e8 90 02 00 00       	call   8008bb <strnlen>
  80062b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80062e:	29 c2                	sub    %eax,%edx
  800630:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800633:	85 d2                	test   %edx,%edx
  800635:	7e d8                	jle    80060f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800637:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80063b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80063e:	89 d6                	mov    %edx,%esi
  800640:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800643:	89 c7                	mov    %eax,%edi
  800645:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800649:	89 3c 24             	mov    %edi,(%esp)
  80064c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80064f:	83 ee 01             	sub    $0x1,%esi
  800652:	75 f1                	jne    800645 <vprintfmt+0x1fb>
  800654:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800657:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80065a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80065d:	eb b0                	jmp    80060f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80065f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800663:	74 18                	je     80067d <vprintfmt+0x233>
  800665:	8d 50 e0             	lea    -0x20(%eax),%edx
  800668:	83 fa 5e             	cmp    $0x5e,%edx
  80066b:	76 10                	jbe    80067d <vprintfmt+0x233>
					putch('?', putdat);
  80066d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800671:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800678:	ff 55 08             	call   *0x8(%ebp)
  80067b:	eb 0a                	jmp    800687 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80067d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800681:	89 04 24             	mov    %eax,(%esp)
  800684:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800687:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80068b:	0f be 06             	movsbl (%esi),%eax
  80068e:	83 c6 01             	add    $0x1,%esi
  800691:	85 c0                	test   %eax,%eax
  800693:	75 0e                	jne    8006a3 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800695:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800698:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069c:	7f 16                	jg     8006b4 <vprintfmt+0x26a>
  80069e:	e9 ca fd ff ff       	jmp    80046d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a3:	85 ff                	test   %edi,%edi
  8006a5:	78 b8                	js     80065f <vprintfmt+0x215>
  8006a7:	83 ef 01             	sub    $0x1,%edi
  8006aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8006b0:	79 ad                	jns    80065f <vprintfmt+0x215>
  8006b2:	eb e1                	jmp    800695 <vprintfmt+0x24b>
  8006b4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8006b7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006c5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006c7:	83 ee 01             	sub    $0x1,%esi
  8006ca:	75 ee                	jne    8006ba <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006cc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8006cf:	e9 99 fd ff ff       	jmp    80046d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006d4:	83 f9 01             	cmp    $0x1,%ecx
  8006d7:	7e 10                	jle    8006e9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8d 50 08             	lea    0x8(%eax),%edx
  8006df:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e2:	8b 30                	mov    (%eax),%esi
  8006e4:	8b 78 04             	mov    0x4(%eax),%edi
  8006e7:	eb 26                	jmp    80070f <vprintfmt+0x2c5>
	else if (lflag)
  8006e9:	85 c9                	test   %ecx,%ecx
  8006eb:	74 12                	je     8006ff <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f6:	8b 30                	mov    (%eax),%esi
  8006f8:	89 f7                	mov    %esi,%edi
  8006fa:	c1 ff 1f             	sar    $0x1f,%edi
  8006fd:	eb 10                	jmp    80070f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 50 04             	lea    0x4(%eax),%edx
  800705:	89 55 14             	mov    %edx,0x14(%ebp)
  800708:	8b 30                	mov    (%eax),%esi
  80070a:	89 f7                	mov    %esi,%edi
  80070c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80070f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800714:	85 ff                	test   %edi,%edi
  800716:	0f 89 8c 00 00 00    	jns    8007a8 <vprintfmt+0x35e>
				putch('-', putdat);
  80071c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800720:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800727:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80072a:	f7 de                	neg    %esi
  80072c:	83 d7 00             	adc    $0x0,%edi
  80072f:	f7 df                	neg    %edi
			}
			base = 10;
  800731:	b8 0a 00 00 00       	mov    $0xa,%eax
  800736:	eb 70                	jmp    8007a8 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800738:	89 ca                	mov    %ecx,%edx
  80073a:	8d 45 14             	lea    0x14(%ebp),%eax
  80073d:	e8 89 fc ff ff       	call   8003cb <getuint>
  800742:	89 c6                	mov    %eax,%esi
  800744:	89 d7                	mov    %edx,%edi
			base = 10;
  800746:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80074b:	eb 5b                	jmp    8007a8 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80074d:	89 ca                	mov    %ecx,%edx
  80074f:	8d 45 14             	lea    0x14(%ebp),%eax
  800752:	e8 74 fc ff ff       	call   8003cb <getuint>
  800757:	89 c6                	mov    %eax,%esi
  800759:	89 d7                	mov    %edx,%edi
			base = 8;
  80075b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800760:	eb 46                	jmp    8007a8 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800762:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800766:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80076d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800770:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800774:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80077b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8d 50 04             	lea    0x4(%eax),%edx
  800784:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800787:	8b 30                	mov    (%eax),%esi
  800789:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80078e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800793:	eb 13                	jmp    8007a8 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800795:	89 ca                	mov    %ecx,%edx
  800797:	8d 45 14             	lea    0x14(%ebp),%eax
  80079a:	e8 2c fc ff ff       	call   8003cb <getuint>
  80079f:	89 c6                	mov    %eax,%esi
  8007a1:	89 d7                	mov    %edx,%edi
			base = 16;
  8007a3:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a8:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  8007ac:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007bb:	89 34 24             	mov    %esi,(%esp)
  8007be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c2:	89 da                	mov    %ebx,%edx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	e8 24 fb ff ff       	call   8002f0 <printnum>
			break;
  8007cc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8007cf:	e9 99 fc ff ff       	jmp    80046d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007d8:	89 14 24             	mov    %edx,(%esp)
  8007db:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007de:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8007e1:	e9 87 fc ff ff       	jmp    80046d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007f1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8007f8:	0f 84 6f fc ff ff    	je     80046d <vprintfmt+0x23>
  8007fe:	83 ee 01             	sub    $0x1,%esi
  800801:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800805:	75 f7                	jne    8007fe <vprintfmt+0x3b4>
  800807:	e9 61 fc ff ff       	jmp    80046d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80080c:	83 c4 4c             	add    $0x4c,%esp
  80080f:	5b                   	pop    %ebx
  800810:	5e                   	pop    %esi
  800811:	5f                   	pop    %edi
  800812:	5d                   	pop    %ebp
  800813:	c3                   	ret    

00800814 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	83 ec 28             	sub    $0x28,%esp
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800820:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800823:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800827:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80082a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800831:	85 c0                	test   %eax,%eax
  800833:	74 30                	je     800865 <vsnprintf+0x51>
  800835:	85 d2                	test   %edx,%edx
  800837:	7e 2c                	jle    800865 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800840:	8b 45 10             	mov    0x10(%ebp),%eax
  800843:	89 44 24 08          	mov    %eax,0x8(%esp)
  800847:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80084a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084e:	c7 04 24 05 04 80 00 	movl   $0x800405,(%esp)
  800855:	e8 f0 fb ff ff       	call   80044a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80085a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800863:	eb 05                	jmp    80086a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800865:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80086a:	c9                   	leave  
  80086b:	c3                   	ret    

0080086c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800872:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800875:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800879:	8b 45 10             	mov    0x10(%ebp),%eax
  80087c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800880:	8b 45 0c             	mov    0xc(%ebp),%eax
  800883:	89 44 24 04          	mov    %eax,0x4(%esp)
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	89 04 24             	mov    %eax,(%esp)
  80088d:	e8 82 ff ff ff       	call   800814 <vsnprintf>
	va_end(ap);

	return rc;
}
  800892:	c9                   	leave  
  800893:	c3                   	ret    
	...

008008a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ab:	80 3a 00             	cmpb   $0x0,(%edx)
  8008ae:	74 09                	je     8008b9 <strlen+0x19>
		n++;
  8008b0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b7:	75 f7                	jne    8008b0 <strlen+0x10>
		n++;
	return n;
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ca:	85 c9                	test   %ecx,%ecx
  8008cc:	74 1a                	je     8008e8 <strnlen+0x2d>
  8008ce:	80 3b 00             	cmpb   $0x0,(%ebx)
  8008d1:	74 15                	je     8008e8 <strnlen+0x2d>
  8008d3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8008d8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008da:	39 ca                	cmp    %ecx,%edx
  8008dc:	74 0a                	je     8008e8 <strnlen+0x2d>
  8008de:	83 c2 01             	add    $0x1,%edx
  8008e1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8008e6:	75 f0                	jne    8008d8 <strnlen+0x1d>
		n++;
	return n;
}
  8008e8:	5b                   	pop    %ebx
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	53                   	push   %ebx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fa:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008fe:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800901:	83 c2 01             	add    $0x1,%edx
  800904:	84 c9                	test   %cl,%cl
  800906:	75 f2                	jne    8008fa <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800908:	5b                   	pop    %ebx
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	53                   	push   %ebx
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800915:	89 1c 24             	mov    %ebx,(%esp)
  800918:	e8 83 ff ff ff       	call   8008a0 <strlen>
	strcpy(dst + len, src);
  80091d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800920:	89 54 24 04          	mov    %edx,0x4(%esp)
  800924:	01 d8                	add    %ebx,%eax
  800926:	89 04 24             	mov    %eax,(%esp)
  800929:	e8 bd ff ff ff       	call   8008eb <strcpy>
	return dst;
}
  80092e:	89 d8                	mov    %ebx,%eax
  800930:	83 c4 08             	add    $0x8,%esp
  800933:	5b                   	pop    %ebx
  800934:	5d                   	pop    %ebp
  800935:	c3                   	ret    

00800936 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	56                   	push   %esi
  80093a:	53                   	push   %ebx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800941:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800944:	85 f6                	test   %esi,%esi
  800946:	74 18                	je     800960 <strncpy+0x2a>
  800948:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  80094d:	0f b6 1a             	movzbl (%edx),%ebx
  800950:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800953:	80 3a 01             	cmpb   $0x1,(%edx)
  800956:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800959:	83 c1 01             	add    $0x1,%ecx
  80095c:	39 f1                	cmp    %esi,%ecx
  80095e:	75 ed                	jne    80094d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800960:	5b                   	pop    %ebx
  800961:	5e                   	pop    %esi
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	57                   	push   %edi
  800968:	56                   	push   %esi
  800969:	53                   	push   %ebx
  80096a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80096d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800970:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800973:	89 f8                	mov    %edi,%eax
  800975:	85 f6                	test   %esi,%esi
  800977:	74 2b                	je     8009a4 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800979:	83 fe 01             	cmp    $0x1,%esi
  80097c:	74 23                	je     8009a1 <strlcpy+0x3d>
  80097e:	0f b6 0b             	movzbl (%ebx),%ecx
  800981:	84 c9                	test   %cl,%cl
  800983:	74 1c                	je     8009a1 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800985:	83 ee 02             	sub    $0x2,%esi
  800988:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80098d:	88 08                	mov    %cl,(%eax)
  80098f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800992:	39 f2                	cmp    %esi,%edx
  800994:	74 0b                	je     8009a1 <strlcpy+0x3d>
  800996:	83 c2 01             	add    $0x1,%edx
  800999:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80099d:	84 c9                	test   %cl,%cl
  80099f:	75 ec                	jne    80098d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  8009a1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009a4:	29 f8                	sub    %edi,%eax
}
  8009a6:	5b                   	pop    %ebx
  8009a7:	5e                   	pop    %esi
  8009a8:	5f                   	pop    %edi
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009b4:	0f b6 01             	movzbl (%ecx),%eax
  8009b7:	84 c0                	test   %al,%al
  8009b9:	74 16                	je     8009d1 <strcmp+0x26>
  8009bb:	3a 02                	cmp    (%edx),%al
  8009bd:	75 12                	jne    8009d1 <strcmp+0x26>
		p++, q++;
  8009bf:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009c2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  8009c6:	84 c0                	test   %al,%al
  8009c8:	74 07                	je     8009d1 <strcmp+0x26>
  8009ca:	83 c1 01             	add    $0x1,%ecx
  8009cd:	3a 02                	cmp    (%edx),%al
  8009cf:	74 ee                	je     8009bf <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d1:	0f b6 c0             	movzbl %al,%eax
  8009d4:	0f b6 12             	movzbl (%edx),%edx
  8009d7:	29 d0                	sub    %edx,%eax
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	53                   	push   %ebx
  8009df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009e5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009e8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009ed:	85 d2                	test   %edx,%edx
  8009ef:	74 28                	je     800a19 <strncmp+0x3e>
  8009f1:	0f b6 01             	movzbl (%ecx),%eax
  8009f4:	84 c0                	test   %al,%al
  8009f6:	74 24                	je     800a1c <strncmp+0x41>
  8009f8:	3a 03                	cmp    (%ebx),%al
  8009fa:	75 20                	jne    800a1c <strncmp+0x41>
  8009fc:	83 ea 01             	sub    $0x1,%edx
  8009ff:	74 13                	je     800a14 <strncmp+0x39>
		n--, p++, q++;
  800a01:	83 c1 01             	add    $0x1,%ecx
  800a04:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a07:	0f b6 01             	movzbl (%ecx),%eax
  800a0a:	84 c0                	test   %al,%al
  800a0c:	74 0e                	je     800a1c <strncmp+0x41>
  800a0e:	3a 03                	cmp    (%ebx),%al
  800a10:	74 ea                	je     8009fc <strncmp+0x21>
  800a12:	eb 08                	jmp    800a1c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a19:	5b                   	pop    %ebx
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1c:	0f b6 01             	movzbl (%ecx),%eax
  800a1f:	0f b6 13             	movzbl (%ebx),%edx
  800a22:	29 d0                	sub    %edx,%eax
  800a24:	eb f3                	jmp    800a19 <strncmp+0x3e>

00800a26 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a30:	0f b6 10             	movzbl (%eax),%edx
  800a33:	84 d2                	test   %dl,%dl
  800a35:	74 1c                	je     800a53 <strchr+0x2d>
		if (*s == c)
  800a37:	38 ca                	cmp    %cl,%dl
  800a39:	75 09                	jne    800a44 <strchr+0x1e>
  800a3b:	eb 1b                	jmp    800a58 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a3d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800a40:	38 ca                	cmp    %cl,%dl
  800a42:	74 14                	je     800a58 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a44:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800a48:	84 d2                	test   %dl,%dl
  800a4a:	75 f1                	jne    800a3d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a51:	eb 05                	jmp    800a58 <strchr+0x32>
  800a53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a64:	0f b6 10             	movzbl (%eax),%edx
  800a67:	84 d2                	test   %dl,%dl
  800a69:	74 14                	je     800a7f <strfind+0x25>
		if (*s == c)
  800a6b:	38 ca                	cmp    %cl,%dl
  800a6d:	75 06                	jne    800a75 <strfind+0x1b>
  800a6f:	eb 0e                	jmp    800a7f <strfind+0x25>
  800a71:	38 ca                	cmp    %cl,%dl
  800a73:	74 0a                	je     800a7f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	0f b6 10             	movzbl (%eax),%edx
  800a7b:	84 d2                	test   %dl,%dl
  800a7d:	75 f2                	jne    800a71 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 0c             	sub    $0xc,%esp
  800a87:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800a8a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a8d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a90:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a96:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a99:	85 c9                	test   %ecx,%ecx
  800a9b:	74 30                	je     800acd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a9d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aa3:	75 25                	jne    800aca <memset+0x49>
  800aa5:	f6 c1 03             	test   $0x3,%cl
  800aa8:	75 20                	jne    800aca <memset+0x49>
		c &= 0xFF;
  800aaa:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aad:	89 d3                	mov    %edx,%ebx
  800aaf:	c1 e3 08             	shl    $0x8,%ebx
  800ab2:	89 d6                	mov    %edx,%esi
  800ab4:	c1 e6 18             	shl    $0x18,%esi
  800ab7:	89 d0                	mov    %edx,%eax
  800ab9:	c1 e0 10             	shl    $0x10,%eax
  800abc:	09 f0                	or     %esi,%eax
  800abe:	09 d0                	or     %edx,%eax
  800ac0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ac5:	fc                   	cld    
  800ac6:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac8:	eb 03                	jmp    800acd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aca:	fc                   	cld    
  800acb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800acd:	89 f8                	mov    %edi,%eax
  800acf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ad2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ad5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ad8:	89 ec                	mov    %ebp,%esp
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ae5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af1:	39 c6                	cmp    %eax,%esi
  800af3:	73 36                	jae    800b2b <memmove+0x4f>
  800af5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af8:	39 d0                	cmp    %edx,%eax
  800afa:	73 2f                	jae    800b2b <memmove+0x4f>
		s += n;
		d += n;
  800afc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aff:	f6 c2 03             	test   $0x3,%dl
  800b02:	75 1b                	jne    800b1f <memmove+0x43>
  800b04:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b0a:	75 13                	jne    800b1f <memmove+0x43>
  800b0c:	f6 c1 03             	test   $0x3,%cl
  800b0f:	75 0e                	jne    800b1f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b11:	83 ef 04             	sub    $0x4,%edi
  800b14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b17:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b1a:	fd                   	std    
  800b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1d:	eb 09                	jmp    800b28 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b1f:	83 ef 01             	sub    $0x1,%edi
  800b22:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b25:	fd                   	std    
  800b26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b28:	fc                   	cld    
  800b29:	eb 20                	jmp    800b4b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b31:	75 13                	jne    800b46 <memmove+0x6a>
  800b33:	a8 03                	test   $0x3,%al
  800b35:	75 0f                	jne    800b46 <memmove+0x6a>
  800b37:	f6 c1 03             	test   $0x3,%cl
  800b3a:	75 0a                	jne    800b46 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b3c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b3f:	89 c7                	mov    %eax,%edi
  800b41:	fc                   	cld    
  800b42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b44:	eb 05                	jmp    800b4b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b46:	89 c7                	mov    %eax,%edi
  800b48:	fc                   	cld    
  800b49:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b4b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b4e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b51:	89 ec                	mov    %ebp,%esp
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	89 04 24             	mov    %eax,(%esp)
  800b6f:	e8 68 ff ff ff       	call   800adc <memmove>
}
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	57                   	push   %edi
  800b7a:	56                   	push   %esi
  800b7b:	53                   	push   %ebx
  800b7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b82:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b8a:	85 ff                	test   %edi,%edi
  800b8c:	74 37                	je     800bc5 <memcmp+0x4f>
		if (*s1 != *s2)
  800b8e:	0f b6 03             	movzbl (%ebx),%eax
  800b91:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b94:	83 ef 01             	sub    $0x1,%edi
  800b97:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b9c:	38 c8                	cmp    %cl,%al
  800b9e:	74 1c                	je     800bbc <memcmp+0x46>
  800ba0:	eb 10                	jmp    800bb2 <memcmp+0x3c>
  800ba2:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800ba7:	83 c2 01             	add    $0x1,%edx
  800baa:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800bae:	38 c8                	cmp    %cl,%al
  800bb0:	74 0a                	je     800bbc <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800bb2:	0f b6 c0             	movzbl %al,%eax
  800bb5:	0f b6 c9             	movzbl %cl,%ecx
  800bb8:	29 c8                	sub    %ecx,%eax
  800bba:	eb 09                	jmp    800bc5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bbc:	39 fa                	cmp    %edi,%edx
  800bbe:	75 e2                	jne    800ba2 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc5:	5b                   	pop    %ebx
  800bc6:	5e                   	pop    %esi
  800bc7:	5f                   	pop    %edi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800bd0:	89 c2                	mov    %eax,%edx
  800bd2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd5:	39 d0                	cmp    %edx,%eax
  800bd7:	73 19                	jae    800bf2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bd9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800bdd:	38 08                	cmp    %cl,(%eax)
  800bdf:	75 06                	jne    800be7 <memfind+0x1d>
  800be1:	eb 0f                	jmp    800bf2 <memfind+0x28>
  800be3:	38 08                	cmp    %cl,(%eax)
  800be5:	74 0b                	je     800bf2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800be7:	83 c0 01             	add    $0x1,%eax
  800bea:	39 d0                	cmp    %edx,%eax
  800bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800bf0:	75 f1                	jne    800be3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	57                   	push   %edi
  800bf8:	56                   	push   %esi
  800bf9:	53                   	push   %ebx
  800bfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c00:	0f b6 02             	movzbl (%edx),%eax
  800c03:	3c 20                	cmp    $0x20,%al
  800c05:	74 04                	je     800c0b <strtol+0x17>
  800c07:	3c 09                	cmp    $0x9,%al
  800c09:	75 0e                	jne    800c19 <strtol+0x25>
		s++;
  800c0b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c0e:	0f b6 02             	movzbl (%edx),%eax
  800c11:	3c 20                	cmp    $0x20,%al
  800c13:	74 f6                	je     800c0b <strtol+0x17>
  800c15:	3c 09                	cmp    $0x9,%al
  800c17:	74 f2                	je     800c0b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c19:	3c 2b                	cmp    $0x2b,%al
  800c1b:	75 0a                	jne    800c27 <strtol+0x33>
		s++;
  800c1d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c20:	bf 00 00 00 00       	mov    $0x0,%edi
  800c25:	eb 10                	jmp    800c37 <strtol+0x43>
  800c27:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c2c:	3c 2d                	cmp    $0x2d,%al
  800c2e:	75 07                	jne    800c37 <strtol+0x43>
		s++, neg = 1;
  800c30:	83 c2 01             	add    $0x1,%edx
  800c33:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c37:	85 db                	test   %ebx,%ebx
  800c39:	0f 94 c0             	sete   %al
  800c3c:	74 05                	je     800c43 <strtol+0x4f>
  800c3e:	83 fb 10             	cmp    $0x10,%ebx
  800c41:	75 15                	jne    800c58 <strtol+0x64>
  800c43:	80 3a 30             	cmpb   $0x30,(%edx)
  800c46:	75 10                	jne    800c58 <strtol+0x64>
  800c48:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c4c:	75 0a                	jne    800c58 <strtol+0x64>
		s += 2, base = 16;
  800c4e:	83 c2 02             	add    $0x2,%edx
  800c51:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c56:	eb 13                	jmp    800c6b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800c58:	84 c0                	test   %al,%al
  800c5a:	74 0f                	je     800c6b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c5c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c61:	80 3a 30             	cmpb   $0x30,(%edx)
  800c64:	75 05                	jne    800c6b <strtol+0x77>
		s++, base = 8;
  800c66:	83 c2 01             	add    $0x1,%edx
  800c69:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c70:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c72:	0f b6 0a             	movzbl (%edx),%ecx
  800c75:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c78:	80 fb 09             	cmp    $0x9,%bl
  800c7b:	77 08                	ja     800c85 <strtol+0x91>
			dig = *s - '0';
  800c7d:	0f be c9             	movsbl %cl,%ecx
  800c80:	83 e9 30             	sub    $0x30,%ecx
  800c83:	eb 1e                	jmp    800ca3 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800c85:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800c88:	80 fb 19             	cmp    $0x19,%bl
  800c8b:	77 08                	ja     800c95 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800c8d:	0f be c9             	movsbl %cl,%ecx
  800c90:	83 e9 57             	sub    $0x57,%ecx
  800c93:	eb 0e                	jmp    800ca3 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c95:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c98:	80 fb 19             	cmp    $0x19,%bl
  800c9b:	77 14                	ja     800cb1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800c9d:	0f be c9             	movsbl %cl,%ecx
  800ca0:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ca3:	39 f1                	cmp    %esi,%ecx
  800ca5:	7d 0e                	jge    800cb5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ca7:	83 c2 01             	add    $0x1,%edx
  800caa:	0f af c6             	imul   %esi,%eax
  800cad:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800caf:	eb c1                	jmp    800c72 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800cb1:	89 c1                	mov    %eax,%ecx
  800cb3:	eb 02                	jmp    800cb7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cb5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cbb:	74 05                	je     800cc2 <strtol+0xce>
		*endptr = (char *) s;
  800cbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cc0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800cc2:	89 ca                	mov    %ecx,%edx
  800cc4:	f7 da                	neg    %edx
  800cc6:	85 ff                	test   %edi,%edi
  800cc8:	0f 45 c2             	cmovne %edx,%eax
}
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 0c             	sub    $0xc,%esp
  800cd6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cd9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cdc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cea:	89 c3                	mov    %eax,%ebx
  800cec:	89 c7                	mov    %eax,%edi
  800cee:	89 c6                	mov    %eax,%esi
  800cf0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cf2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cf5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cf8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cfb:	89 ec                	mov    %ebp,%esp
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    

00800cff <sys_cgetc>:

int
sys_cgetc(void)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	83 ec 0c             	sub    $0xc,%esp
  800d05:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d08:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d0b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d13:	b8 01 00 00 00       	mov    $0x1,%eax
  800d18:	89 d1                	mov    %edx,%ecx
  800d1a:	89 d3                	mov    %edx,%ebx
  800d1c:	89 d7                	mov    %edx,%edi
  800d1e:	89 d6                	mov    %edx,%esi
  800d20:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d22:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d25:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d28:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d2b:	89 ec                	mov    %ebp,%esp
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	83 ec 38             	sub    $0x38,%esp
  800d35:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d38:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d3b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d43:	b8 03 00 00 00       	mov    $0x3,%eax
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	89 cb                	mov    %ecx,%ebx
  800d4d:	89 cf                	mov    %ecx,%edi
  800d4f:	89 ce                	mov    %ecx,%esi
  800d51:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d53:	85 c0                	test   %eax,%eax
  800d55:	7e 28                	jle    800d7f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d57:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d5b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d62:	00 
  800d63:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  800d6a:	00 
  800d6b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d72:	00 
  800d73:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  800d7a:	e8 59 f4 ff ff       	call   8001d8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d82:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d88:	89 ec                	mov    %ebp,%esp
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d95:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d98:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800da0:	b8 02 00 00 00       	mov    $0x2,%eax
  800da5:	89 d1                	mov    %edx,%ecx
  800da7:	89 d3                	mov    %edx,%ebx
  800da9:	89 d7                	mov    %edx,%edi
  800dab:	89 d6                	mov    %edx,%esi
  800dad:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800daf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800db2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800db5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800db8:	89 ec                	mov    %ebp,%esp
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <sys_yield>:

void
sys_yield(void)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dc5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dc8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dd5:	89 d1                	mov    %edx,%ecx
  800dd7:	89 d3                	mov    %edx,%ebx
  800dd9:	89 d7                	mov    %edx,%edi
  800ddb:	89 d6                	mov    %edx,%esi
  800ddd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ddf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800de2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800de5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800de8:	89 ec                	mov    %ebp,%esp
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    

00800dec <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 38             	sub    $0x38,%esp
  800df2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800df5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800df8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfb:	be 00 00 00 00       	mov    $0x0,%esi
  800e00:	b8 04 00 00 00       	mov    $0x4,%eax
  800e05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	89 f7                	mov    %esi,%edi
  800e10:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e12:	85 c0                	test   %eax,%eax
  800e14:	7e 28                	jle    800e3e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e16:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e21:	00 
  800e22:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  800e29:	00 
  800e2a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e31:	00 
  800e32:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  800e39:	e8 9a f3 ff ff       	call   8001d8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e3e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e41:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e44:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e47:	89 ec                	mov    %ebp,%esp
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 38             	sub    $0x38,%esp
  800e51:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e54:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e57:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5a:	b8 05 00 00 00       	mov    $0x5,%eax
  800e5f:	8b 75 18             	mov    0x18(%ebp),%esi
  800e62:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	7e 28                	jle    800e9c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e74:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e78:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e7f:	00 
  800e80:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  800e87:	00 
  800e88:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8f:	00 
  800e90:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  800e97:	e8 3c f3 ff ff       	call   8001d8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e9c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e9f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ea2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ea5:	89 ec                	mov    %ebp,%esp
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    

00800ea9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	83 ec 38             	sub    $0x38,%esp
  800eaf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eb2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eb5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebd:	b8 06 00 00 00       	mov    $0x6,%eax
  800ec2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec8:	89 df                	mov    %ebx,%edi
  800eca:	89 de                	mov    %ebx,%esi
  800ecc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	7e 28                	jle    800efa <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800edd:	00 
  800ede:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  800ee5:	00 
  800ee6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eed:	00 
  800eee:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  800ef5:	e8 de f2 ff ff       	call   8001d8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800efa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800efd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f00:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f03:	89 ec                	mov    %ebp,%esp
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 38             	sub    $0x38,%esp
  800f0d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f10:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f13:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1b:	b8 08 00 00 00       	mov    $0x8,%eax
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
  800f26:	89 df                	mov    %ebx,%edi
  800f28:	89 de                	mov    %ebx,%esi
  800f2a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	7e 28                	jle    800f58 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f30:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f34:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f3b:	00 
  800f3c:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  800f43:	00 
  800f44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4b:	00 
  800f4c:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  800f53:	e8 80 f2 ff ff       	call   8001d8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f58:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f5b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f5e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f61:	89 ec                	mov    %ebp,%esp
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 38             	sub    $0x38,%esp
  800f6b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f6e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f71:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f79:	b8 09 00 00 00       	mov    $0x9,%eax
  800f7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	89 df                	mov    %ebx,%edi
  800f86:	89 de                	mov    %ebx,%esi
  800f88:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	7e 28                	jle    800fb6 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f92:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f99:	00 
  800f9a:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  800fa1:	00 
  800fa2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa9:	00 
  800faa:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  800fb1:	e8 22 f2 ff ff       	call   8001d8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fb6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fbc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fbf:	89 ec                	mov    %ebp,%esp
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	83 ec 38             	sub    $0x38,%esp
  800fc9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fcc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fcf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	89 df                	mov    %ebx,%edi
  800fe4:	89 de                	mov    %ebx,%esi
  800fe6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	7e 28                	jle    801014 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fec:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ff7:	00 
  800ff8:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  800fff:	00 
  801000:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801007:	00 
  801008:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  80100f:	e8 c4 f1 ff ff       	call   8001d8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801014:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801017:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80101a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80101d:	89 ec                	mov    %ebp,%esp
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 0c             	sub    $0xc,%esp
  801027:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80102a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80102d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801030:	be 00 00 00 00       	mov    $0x0,%esi
  801035:	b8 0c 00 00 00       	mov    $0xc,%eax
  80103a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80103d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801040:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801043:	8b 55 08             	mov    0x8(%ebp),%edx
  801046:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801048:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80104b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80104e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801051:	89 ec                	mov    %ebp,%esp
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	83 ec 38             	sub    $0x38,%esp
  80105b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80105e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801061:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801064:	b9 00 00 00 00       	mov    $0x0,%ecx
  801069:	b8 0d 00 00 00       	mov    $0xd,%eax
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	89 cb                	mov    %ecx,%ebx
  801073:	89 cf                	mov    %ecx,%edi
  801075:	89 ce                	mov    %ecx,%esi
  801077:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801079:	85 c0                	test   %eax,%eax
  80107b:	7e 28                	jle    8010a5 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80107d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801081:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801088:	00 
  801089:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  801090:	00 
  801091:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801098:	00 
  801099:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  8010a0:	e8 33 f1 ff ff       	call   8001d8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010a5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ab:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ae:	89 ec                	mov    %ebp,%esp
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
	...

008010c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	89 04 24             	mov    %eax,(%esp)
  8010dc:	e8 df ff ff ff       	call   8010c0 <fd2num>
  8010e1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8010e6:	c1 e0 0c             	shl    $0xc,%eax
}
  8010e9:	c9                   	leave  
  8010ea:	c3                   	ret    

008010eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	53                   	push   %ebx
  8010ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010f2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8010f7:	a8 01                	test   $0x1,%al
  8010f9:	74 34                	je     80112f <fd_alloc+0x44>
  8010fb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801100:	a8 01                	test   $0x1,%al
  801102:	74 32                	je     801136 <fd_alloc+0x4b>
  801104:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801109:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80110b:	89 c2                	mov    %eax,%edx
  80110d:	c1 ea 16             	shr    $0x16,%edx
  801110:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801117:	f6 c2 01             	test   $0x1,%dl
  80111a:	74 1f                	je     80113b <fd_alloc+0x50>
  80111c:	89 c2                	mov    %eax,%edx
  80111e:	c1 ea 0c             	shr    $0xc,%edx
  801121:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801128:	f6 c2 01             	test   $0x1,%dl
  80112b:	75 17                	jne    801144 <fd_alloc+0x59>
  80112d:	eb 0c                	jmp    80113b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80112f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801134:	eb 05                	jmp    80113b <fd_alloc+0x50>
  801136:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80113b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80113d:	b8 00 00 00 00       	mov    $0x0,%eax
  801142:	eb 17                	jmp    80115b <fd_alloc+0x70>
  801144:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801149:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80114e:	75 b9                	jne    801109 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801150:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801156:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80115b:	5b                   	pop    %ebx
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801164:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801169:	83 fa 1f             	cmp    $0x1f,%edx
  80116c:	77 3f                	ja     8011ad <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80116e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801174:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801177:	89 d0                	mov    %edx,%eax
  801179:	c1 e8 16             	shr    $0x16,%eax
  80117c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801183:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801188:	f6 c1 01             	test   $0x1,%cl
  80118b:	74 20                	je     8011ad <fd_lookup+0x4f>
  80118d:	89 d0                	mov    %edx,%eax
  80118f:	c1 e8 0c             	shr    $0xc,%eax
  801192:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801199:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80119e:	f6 c1 01             	test   $0x1,%cl
  8011a1:	74 0a                	je     8011ad <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	89 10                	mov    %edx,(%eax)
	return 0;
  8011a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ad:	5d                   	pop    %ebp
  8011ae:	c3                   	ret    

008011af <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	53                   	push   %ebx
  8011b3:	83 ec 14             	sub    $0x14,%esp
  8011b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8011bc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011c1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8011c7:	75 17                	jne    8011e0 <dev_lookup+0x31>
  8011c9:	eb 07                	jmp    8011d2 <dev_lookup+0x23>
  8011cb:	39 0a                	cmp    %ecx,(%edx)
  8011cd:	75 11                	jne    8011e0 <dev_lookup+0x31>
  8011cf:	90                   	nop
  8011d0:	eb 05                	jmp    8011d7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011d2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8011d7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8011d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011de:	eb 35                	jmp    801215 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011e0:	83 c0 01             	add    $0x1,%eax
  8011e3:	8b 14 85 2c 28 80 00 	mov    0x80282c(,%eax,4),%edx
  8011ea:	85 d2                	test   %edx,%edx
  8011ec:	75 dd                	jne    8011cb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011ee:	a1 20 60 80 00       	mov    0x806020,%eax
  8011f3:	8b 40 48             	mov    0x48(%eax),%eax
  8011f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011fe:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  801205:	e8 c9 f0 ff ff       	call   8002d3 <cprintf>
	*dev = 0;
  80120a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801210:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801215:	83 c4 14             	add    $0x14,%esp
  801218:	5b                   	pop    %ebx
  801219:	5d                   	pop    %ebp
  80121a:	c3                   	ret    

0080121b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 38             	sub    $0x38,%esp
  801221:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801224:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801227:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80122a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80122d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801231:	89 3c 24             	mov    %edi,(%esp)
  801234:	e8 87 fe ff ff       	call   8010c0 <fd2num>
  801239:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80123c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801240:	89 04 24             	mov    %eax,(%esp)
  801243:	e8 16 ff ff ff       	call   80115e <fd_lookup>
  801248:	89 c3                	mov    %eax,%ebx
  80124a:	85 c0                	test   %eax,%eax
  80124c:	78 05                	js     801253 <fd_close+0x38>
	    || fd != fd2)
  80124e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801251:	74 0e                	je     801261 <fd_close+0x46>
		return (must_exist ? r : 0);
  801253:	89 f0                	mov    %esi,%eax
  801255:	84 c0                	test   %al,%al
  801257:	b8 00 00 00 00       	mov    $0x0,%eax
  80125c:	0f 44 d8             	cmove  %eax,%ebx
  80125f:	eb 3d                	jmp    80129e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801261:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801264:	89 44 24 04          	mov    %eax,0x4(%esp)
  801268:	8b 07                	mov    (%edi),%eax
  80126a:	89 04 24             	mov    %eax,(%esp)
  80126d:	e8 3d ff ff ff       	call   8011af <dev_lookup>
  801272:	89 c3                	mov    %eax,%ebx
  801274:	85 c0                	test   %eax,%eax
  801276:	78 16                	js     80128e <fd_close+0x73>
		if (dev->dev_close)
  801278:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80127b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80127e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801283:	85 c0                	test   %eax,%eax
  801285:	74 07                	je     80128e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801287:	89 3c 24             	mov    %edi,(%esp)
  80128a:	ff d0                	call   *%eax
  80128c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80128e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801292:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801299:	e8 0b fc ff ff       	call   800ea9 <sys_page_unmap>
	return r;
}
  80129e:	89 d8                	mov    %ebx,%eax
  8012a0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012a3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012a6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012a9:	89 ec                	mov    %ebp,%esp
  8012ab:	5d                   	pop    %ebp
  8012ac:	c3                   	ret    

008012ad <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	89 04 24             	mov    %eax,(%esp)
  8012c0:	e8 99 fe ff ff       	call   80115e <fd_lookup>
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	78 13                	js     8012dc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8012c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012d0:	00 
  8012d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d4:	89 04 24             	mov    %eax,(%esp)
  8012d7:	e8 3f ff ff ff       	call   80121b <fd_close>
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <close_all>:

void
close_all(void)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	53                   	push   %ebx
  8012e2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012ea:	89 1c 24             	mov    %ebx,(%esp)
  8012ed:	e8 bb ff ff ff       	call   8012ad <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012f2:	83 c3 01             	add    $0x1,%ebx
  8012f5:	83 fb 20             	cmp    $0x20,%ebx
  8012f8:	75 f0                	jne    8012ea <close_all+0xc>
		close(i);
}
  8012fa:	83 c4 14             	add    $0x14,%esp
  8012fd:	5b                   	pop    %ebx
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    

00801300 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 58             	sub    $0x58,%esp
  801306:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801309:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80130c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80130f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801312:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801315:	89 44 24 04          	mov    %eax,0x4(%esp)
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	89 04 24             	mov    %eax,(%esp)
  80131f:	e8 3a fe ff ff       	call   80115e <fd_lookup>
  801324:	89 c3                	mov    %eax,%ebx
  801326:	85 c0                	test   %eax,%eax
  801328:	0f 88 e1 00 00 00    	js     80140f <dup+0x10f>
		return r;
	close(newfdnum);
  80132e:	89 3c 24             	mov    %edi,(%esp)
  801331:	e8 77 ff ff ff       	call   8012ad <close>

	newfd = INDEX2FD(newfdnum);
  801336:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80133c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80133f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801342:	89 04 24             	mov    %eax,(%esp)
  801345:	e8 86 fd ff ff       	call   8010d0 <fd2data>
  80134a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80134c:	89 34 24             	mov    %esi,(%esp)
  80134f:	e8 7c fd ff ff       	call   8010d0 <fd2data>
  801354:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801357:	89 d8                	mov    %ebx,%eax
  801359:	c1 e8 16             	shr    $0x16,%eax
  80135c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801363:	a8 01                	test   $0x1,%al
  801365:	74 46                	je     8013ad <dup+0xad>
  801367:	89 d8                	mov    %ebx,%eax
  801369:	c1 e8 0c             	shr    $0xc,%eax
  80136c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801373:	f6 c2 01             	test   $0x1,%dl
  801376:	74 35                	je     8013ad <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801378:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80137f:	25 07 0e 00 00       	and    $0xe07,%eax
  801384:	89 44 24 10          	mov    %eax,0x10(%esp)
  801388:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80138b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80138f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801396:	00 
  801397:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80139b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a2:	e8 a4 fa ff ff       	call   800e4b <sys_page_map>
  8013a7:	89 c3                	mov    %eax,%ebx
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	78 3b                	js     8013e8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b0:	89 c2                	mov    %eax,%edx
  8013b2:	c1 ea 0c             	shr    $0xc,%edx
  8013b5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013bc:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013c2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013c6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013d1:	00 
  8013d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013dd:	e8 69 fa ff ff       	call   800e4b <sys_page_map>
  8013e2:	89 c3                	mov    %eax,%ebx
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	79 25                	jns    80140d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013f3:	e8 b1 fa ff ff       	call   800ea9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801406:	e8 9e fa ff ff       	call   800ea9 <sys_page_unmap>
	return r;
  80140b:	eb 02                	jmp    80140f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80140d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80140f:	89 d8                	mov    %ebx,%eax
  801411:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801414:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801417:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80141a:	89 ec                	mov    %ebp,%esp
  80141c:	5d                   	pop    %ebp
  80141d:	c3                   	ret    

0080141e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	53                   	push   %ebx
  801422:	83 ec 24             	sub    $0x24,%esp
  801425:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801428:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142f:	89 1c 24             	mov    %ebx,(%esp)
  801432:	e8 27 fd ff ff       	call   80115e <fd_lookup>
  801437:	85 c0                	test   %eax,%eax
  801439:	78 6d                	js     8014a8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801445:	8b 00                	mov    (%eax),%eax
  801447:	89 04 24             	mov    %eax,(%esp)
  80144a:	e8 60 fd ff ff       	call   8011af <dev_lookup>
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 55                	js     8014a8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801456:	8b 50 08             	mov    0x8(%eax),%edx
  801459:	83 e2 03             	and    $0x3,%edx
  80145c:	83 fa 01             	cmp    $0x1,%edx
  80145f:	75 23                	jne    801484 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801461:	a1 20 60 80 00       	mov    0x806020,%eax
  801466:	8b 40 48             	mov    0x48(%eax),%eax
  801469:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80146d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801471:	c7 04 24 f0 27 80 00 	movl   $0x8027f0,(%esp)
  801478:	e8 56 ee ff ff       	call   8002d3 <cprintf>
		return -E_INVAL;
  80147d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801482:	eb 24                	jmp    8014a8 <read+0x8a>
	}
	if (!dev->dev_read)
  801484:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801487:	8b 52 08             	mov    0x8(%edx),%edx
  80148a:	85 d2                	test   %edx,%edx
  80148c:	74 15                	je     8014a3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80148e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801491:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801495:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801498:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80149c:	89 04 24             	mov    %eax,(%esp)
  80149f:	ff d2                	call   *%edx
  8014a1:	eb 05                	jmp    8014a8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014a8:	83 c4 24             	add    $0x24,%esp
  8014ab:	5b                   	pop    %ebx
  8014ac:	5d                   	pop    %ebp
  8014ad:	c3                   	ret    

008014ae <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	57                   	push   %edi
  8014b2:	56                   	push   %esi
  8014b3:	53                   	push   %ebx
  8014b4:	83 ec 1c             	sub    $0x1c,%esp
  8014b7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014ba:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c2:	85 f6                	test   %esi,%esi
  8014c4:	74 30                	je     8014f6 <readn+0x48>
  8014c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014cb:	89 f2                	mov    %esi,%edx
  8014cd:	29 c2                	sub    %eax,%edx
  8014cf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014d3:	03 45 0c             	add    0xc(%ebp),%eax
  8014d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014da:	89 3c 24             	mov    %edi,(%esp)
  8014dd:	e8 3c ff ff ff       	call   80141e <read>
		if (m < 0)
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	78 10                	js     8014f6 <readn+0x48>
			return m;
		if (m == 0)
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	74 0a                	je     8014f4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014ea:	01 c3                	add    %eax,%ebx
  8014ec:	89 d8                	mov    %ebx,%eax
  8014ee:	39 f3                	cmp    %esi,%ebx
  8014f0:	72 d9                	jb     8014cb <readn+0x1d>
  8014f2:	eb 02                	jmp    8014f6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8014f4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8014f6:	83 c4 1c             	add    $0x1c,%esp
  8014f9:	5b                   	pop    %ebx
  8014fa:	5e                   	pop    %esi
  8014fb:	5f                   	pop    %edi
  8014fc:	5d                   	pop    %ebp
  8014fd:	c3                   	ret    

008014fe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	53                   	push   %ebx
  801502:	83 ec 24             	sub    $0x24,%esp
  801505:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801508:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150f:	89 1c 24             	mov    %ebx,(%esp)
  801512:	e8 47 fc ff ff       	call   80115e <fd_lookup>
  801517:	85 c0                	test   %eax,%eax
  801519:	78 68                	js     801583 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801525:	8b 00                	mov    (%eax),%eax
  801527:	89 04 24             	mov    %eax,(%esp)
  80152a:	e8 80 fc ff ff       	call   8011af <dev_lookup>
  80152f:	85 c0                	test   %eax,%eax
  801531:	78 50                	js     801583 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801536:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80153a:	75 23                	jne    80155f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80153c:	a1 20 60 80 00       	mov    0x806020,%eax
  801541:	8b 40 48             	mov    0x48(%eax),%eax
  801544:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801548:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154c:	c7 04 24 0c 28 80 00 	movl   $0x80280c,(%esp)
  801553:	e8 7b ed ff ff       	call   8002d3 <cprintf>
		return -E_INVAL;
  801558:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80155d:	eb 24                	jmp    801583 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80155f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801562:	8b 52 0c             	mov    0xc(%edx),%edx
  801565:	85 d2                	test   %edx,%edx
  801567:	74 15                	je     80157e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801569:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80156c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801570:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801573:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801577:	89 04 24             	mov    %eax,(%esp)
  80157a:	ff d2                	call   *%edx
  80157c:	eb 05                	jmp    801583 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80157e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801583:	83 c4 24             	add    $0x24,%esp
  801586:	5b                   	pop    %ebx
  801587:	5d                   	pop    %ebp
  801588:	c3                   	ret    

00801589 <seek>:

int
seek(int fdnum, off_t offset)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801592:	89 44 24 04          	mov    %eax,0x4(%esp)
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	89 04 24             	mov    %eax,(%esp)
  80159c:	e8 bd fb ff ff       	call   80115e <fd_lookup>
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	78 0e                	js     8015b3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ab:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	53                   	push   %ebx
  8015b9:	83 ec 24             	sub    $0x24,%esp
  8015bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c6:	89 1c 24             	mov    %ebx,(%esp)
  8015c9:	e8 90 fb ff ff       	call   80115e <fd_lookup>
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	78 61                	js     801633 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dc:	8b 00                	mov    (%eax),%eax
  8015de:	89 04 24             	mov    %eax,(%esp)
  8015e1:	e8 c9 fb ff ff       	call   8011af <dev_lookup>
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	78 49                	js     801633 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015f1:	75 23                	jne    801616 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015f3:	a1 20 60 80 00       	mov    0x806020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015f8:	8b 40 48             	mov    0x48(%eax),%eax
  8015fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801603:	c7 04 24 cc 27 80 00 	movl   $0x8027cc,(%esp)
  80160a:	e8 c4 ec ff ff       	call   8002d3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80160f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801614:	eb 1d                	jmp    801633 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801616:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801619:	8b 52 18             	mov    0x18(%edx),%edx
  80161c:	85 d2                	test   %edx,%edx
  80161e:	74 0e                	je     80162e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801620:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801623:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801627:	89 04 24             	mov    %eax,(%esp)
  80162a:	ff d2                	call   *%edx
  80162c:	eb 05                	jmp    801633 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80162e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801633:	83 c4 24             	add    $0x24,%esp
  801636:	5b                   	pop    %ebx
  801637:	5d                   	pop    %ebp
  801638:	c3                   	ret    

00801639 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	53                   	push   %ebx
  80163d:	83 ec 24             	sub    $0x24,%esp
  801640:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801643:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801646:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	89 04 24             	mov    %eax,(%esp)
  801650:	e8 09 fb ff ff       	call   80115e <fd_lookup>
  801655:	85 c0                	test   %eax,%eax
  801657:	78 52                	js     8016ab <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801659:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801663:	8b 00                	mov    (%eax),%eax
  801665:	89 04 24             	mov    %eax,(%esp)
  801668:	e8 42 fb ff ff       	call   8011af <dev_lookup>
  80166d:	85 c0                	test   %eax,%eax
  80166f:	78 3a                	js     8016ab <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801674:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801678:	74 2c                	je     8016a6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80167a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80167d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801684:	00 00 00 
	stat->st_isdir = 0;
  801687:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80168e:	00 00 00 
	stat->st_dev = dev;
  801691:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801697:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80169b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80169e:	89 14 24             	mov    %edx,(%esp)
  8016a1:	ff 50 14             	call   *0x14(%eax)
  8016a4:	eb 05                	jmp    8016ab <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016ab:	83 c4 24             	add    $0x24,%esp
  8016ae:	5b                   	pop    %ebx
  8016af:	5d                   	pop    %ebp
  8016b0:	c3                   	ret    

008016b1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 18             	sub    $0x18,%esp
  8016b7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016ba:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016c4:	00 
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	89 04 24             	mov    %eax,(%esp)
  8016cb:	e8 bc 01 00 00       	call   80188c <open>
  8016d0:	89 c3                	mov    %eax,%ebx
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	78 1b                	js     8016f1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8016d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016dd:	89 1c 24             	mov    %ebx,(%esp)
  8016e0:	e8 54 ff ff ff       	call   801639 <fstat>
  8016e5:	89 c6                	mov    %eax,%esi
	close(fd);
  8016e7:	89 1c 24             	mov    %ebx,(%esp)
  8016ea:	e8 be fb ff ff       	call   8012ad <close>
	return r;
  8016ef:	89 f3                	mov    %esi,%ebx
}
  8016f1:	89 d8                	mov    %ebx,%eax
  8016f3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8016f6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8016f9:	89 ec                	mov    %ebp,%esp
  8016fb:	5d                   	pop    %ebp
  8016fc:	c3                   	ret    
  8016fd:	00 00                	add    %al,(%eax)
	...

00801700 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 18             	sub    $0x18,%esp
  801706:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801709:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80170c:	89 c3                	mov    %eax,%ebx
  80170e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801710:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801717:	75 11                	jne    80172a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801719:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801720:	e8 91 09 00 00       	call   8020b6 <ipc_find_env>
  801725:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80172a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801731:	00 
  801732:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801739:	00 
  80173a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80173e:	a1 00 40 80 00       	mov    0x804000,%eax
  801743:	89 04 24             	mov    %eax,(%esp)
  801746:	e8 e7 08 00 00       	call   802032 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80174b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801752:	00 
  801753:	89 74 24 04          	mov    %esi,0x4(%esp)
  801757:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80175e:	e8 7d 08 00 00       	call   801fe0 <ipc_recv>
}
  801763:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801766:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801769:	89 ec                	mov    %ebp,%esp
  80176b:	5d                   	pop    %ebp
  80176c:	c3                   	ret    

0080176d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	53                   	push   %ebx
  801771:	83 ec 14             	sub    $0x14,%esp
  801774:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	8b 40 0c             	mov    0xc(%eax),%eax
  80177d:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801782:	ba 00 00 00 00       	mov    $0x0,%edx
  801787:	b8 05 00 00 00       	mov    $0x5,%eax
  80178c:	e8 6f ff ff ff       	call   801700 <fsipc>
  801791:	85 c0                	test   %eax,%eax
  801793:	78 2b                	js     8017c0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801795:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80179c:	00 
  80179d:	89 1c 24             	mov    %ebx,(%esp)
  8017a0:	e8 46 f1 ff ff       	call   8008eb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017a5:	a1 80 70 80 00       	mov    0x807080,%eax
  8017aa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017b0:	a1 84 70 80 00       	mov    0x807084,%eax
  8017b5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c0:	83 c4 14             	add    $0x14,%esp
  8017c3:	5b                   	pop    %ebx
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    

008017c6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d2:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8017d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017dc:	b8 06 00 00 00       	mov    $0x6,%eax
  8017e1:	e8 1a ff ff ff       	call   801700 <fsipc>
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	56                   	push   %esi
  8017ec:	53                   	push   %ebx
  8017ed:	83 ec 10             	sub    $0x10,%esp
  8017f0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f9:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8017fe:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801804:	ba 00 00 00 00       	mov    $0x0,%edx
  801809:	b8 03 00 00 00       	mov    $0x3,%eax
  80180e:	e8 ed fe ff ff       	call   801700 <fsipc>
  801813:	89 c3                	mov    %eax,%ebx
  801815:	85 c0                	test   %eax,%eax
  801817:	78 6a                	js     801883 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801819:	39 c6                	cmp    %eax,%esi
  80181b:	73 24                	jae    801841 <devfile_read+0x59>
  80181d:	c7 44 24 0c 3c 28 80 	movl   $0x80283c,0xc(%esp)
  801824:	00 
  801825:	c7 44 24 08 43 28 80 	movl   $0x802843,0x8(%esp)
  80182c:	00 
  80182d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801834:	00 
  801835:	c7 04 24 58 28 80 00 	movl   $0x802858,(%esp)
  80183c:	e8 97 e9 ff ff       	call   8001d8 <_panic>
	assert(r <= PGSIZE);
  801841:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801846:	7e 24                	jle    80186c <devfile_read+0x84>
  801848:	c7 44 24 0c 63 28 80 	movl   $0x802863,0xc(%esp)
  80184f:	00 
  801850:	c7 44 24 08 43 28 80 	movl   $0x802843,0x8(%esp)
  801857:	00 
  801858:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80185f:	00 
  801860:	c7 04 24 58 28 80 00 	movl   $0x802858,(%esp)
  801867:	e8 6c e9 ff ff       	call   8001d8 <_panic>
	memmove(buf, &fsipcbuf, r);
  80186c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801870:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801877:	00 
  801878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187b:	89 04 24             	mov    %eax,(%esp)
  80187e:	e8 59 f2 ff ff       	call   800adc <memmove>
	return r;
}
  801883:	89 d8                	mov    %ebx,%eax
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	5b                   	pop    %ebx
  801889:	5e                   	pop    %esi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
  801891:	83 ec 20             	sub    $0x20,%esp
  801894:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801897:	89 34 24             	mov    %esi,(%esp)
  80189a:	e8 01 f0 ff ff       	call   8008a0 <strlen>
		return -E_BAD_PATH;
  80189f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018a4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018a9:	7f 5e                	jg     801909 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ae:	89 04 24             	mov    %eax,(%esp)
  8018b1:	e8 35 f8 ff ff       	call   8010eb <fd_alloc>
  8018b6:	89 c3                	mov    %eax,%ebx
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	78 4d                	js     801909 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018c0:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  8018c7:	e8 1f f0 ff ff       	call   8008eb <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cf:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8018dc:	e8 1f fe ff ff       	call   801700 <fsipc>
  8018e1:	89 c3                	mov    %eax,%ebx
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	79 15                	jns    8018fc <open+0x70>
		fd_close(fd, 0);
  8018e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018ee:	00 
  8018ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f2:	89 04 24             	mov    %eax,(%esp)
  8018f5:	e8 21 f9 ff ff       	call   80121b <fd_close>
		return r;
  8018fa:	eb 0d                	jmp    801909 <open+0x7d>
	}

	return fd2num(fd);
  8018fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ff:	89 04 24             	mov    %eax,(%esp)
  801902:	e8 b9 f7 ff ff       	call   8010c0 <fd2num>
  801907:	89 c3                	mov    %eax,%ebx
}
  801909:	89 d8                	mov    %ebx,%eax
  80190b:	83 c4 20             	add    $0x20,%esp
  80190e:	5b                   	pop    %ebx
  80190f:	5e                   	pop    %esi
  801910:	5d                   	pop    %ebp
  801911:	c3                   	ret    
	...

00801914 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	53                   	push   %ebx
  801918:	83 ec 14             	sub    $0x14,%esp
  80191b:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  80191d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801921:	7e 31                	jle    801954 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801923:	8b 40 04             	mov    0x4(%eax),%eax
  801926:	89 44 24 08          	mov    %eax,0x8(%esp)
  80192a:	8d 43 10             	lea    0x10(%ebx),%eax
  80192d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801931:	8b 03                	mov    (%ebx),%eax
  801933:	89 04 24             	mov    %eax,(%esp)
  801936:	e8 c3 fb ff ff       	call   8014fe <write>
		if (result > 0)
  80193b:	85 c0                	test   %eax,%eax
  80193d:	7e 03                	jle    801942 <writebuf+0x2e>
			b->result += result;
  80193f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801942:	39 43 04             	cmp    %eax,0x4(%ebx)
  801945:	74 0d                	je     801954 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801947:	85 c0                	test   %eax,%eax
  801949:	ba 00 00 00 00       	mov    $0x0,%edx
  80194e:	0f 4f c2             	cmovg  %edx,%eax
  801951:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801954:	83 c4 14             	add    $0x14,%esp
  801957:	5b                   	pop    %ebx
  801958:	5d                   	pop    %ebp
  801959:	c3                   	ret    

0080195a <putch>:

static void
putch(int ch, void *thunk)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	53                   	push   %ebx
  80195e:	83 ec 04             	sub    $0x4,%esp
  801961:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801964:	8b 43 04             	mov    0x4(%ebx),%eax
  801967:	8b 55 08             	mov    0x8(%ebp),%edx
  80196a:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  80196e:	83 c0 01             	add    $0x1,%eax
  801971:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801974:	3d 00 01 00 00       	cmp    $0x100,%eax
  801979:	75 0e                	jne    801989 <putch+0x2f>
		writebuf(b);
  80197b:	89 d8                	mov    %ebx,%eax
  80197d:	e8 92 ff ff ff       	call   801914 <writebuf>
		b->idx = 0;
  801982:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801989:	83 c4 04             	add    $0x4,%esp
  80198c:	5b                   	pop    %ebx
  80198d:	5d                   	pop    %ebp
  80198e:	c3                   	ret    

0080198f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019a1:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019a8:	00 00 00 
	b.result = 0;
  8019ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019b2:	00 00 00 
	b.error = 1;
  8019b5:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8019bc:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8019bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019cd:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d7:	c7 04 24 5a 19 80 00 	movl   $0x80195a,(%esp)
  8019de:	e8 67 ea ff ff       	call   80044a <vprintfmt>
	if (b.idx > 0)
  8019e3:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8019ea:	7e 0b                	jle    8019f7 <vfprintf+0x68>
		writebuf(&b);
  8019ec:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019f2:	e8 1d ff ff ff       	call   801914 <writebuf>

	return (b.result ? b.result : b.error);
  8019f7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a0e:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a11:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	89 04 24             	mov    %eax,(%esp)
  801a22:	e8 68 ff ff ff       	call   80198f <vfprintf>
	va_end(ap);

	return cnt;
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <printf>:

int
printf(const char *fmt, ...)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a2f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a32:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a44:	e8 46 ff ff ff       	call   80198f <vfprintf>
	va_end(ap);

	return cnt;
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    
  801a4b:	00 00                	add    %al,(%eax)
  801a4d:	00 00                	add    %al,(%eax)
	...

00801a50 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 18             	sub    $0x18,%esp
  801a56:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a59:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	89 04 24             	mov    %eax,(%esp)
  801a65:	e8 66 f6 ff ff       	call   8010d0 <fd2data>
  801a6a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801a6c:	c7 44 24 04 6f 28 80 	movl   $0x80286f,0x4(%esp)
  801a73:	00 
  801a74:	89 34 24             	mov    %esi,(%esp)
  801a77:	e8 6f ee ff ff       	call   8008eb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a7c:	8b 43 04             	mov    0x4(%ebx),%eax
  801a7f:	2b 03                	sub    (%ebx),%eax
  801a81:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801a87:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801a8e:	00 00 00 
	stat->st_dev = &devpipe;
  801a91:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801a98:	30 80 00 
	return 0;
}
  801a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801aa3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801aa6:	89 ec                	mov    %ebp,%esp
  801aa8:	5d                   	pop    %ebp
  801aa9:	c3                   	ret    

00801aaa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	53                   	push   %ebx
  801aae:	83 ec 14             	sub    $0x14,%esp
  801ab1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ab4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ab8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801abf:	e8 e5 f3 ff ff       	call   800ea9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ac4:	89 1c 24             	mov    %ebx,(%esp)
  801ac7:	e8 04 f6 ff ff       	call   8010d0 <fd2data>
  801acc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad7:	e8 cd f3 ff ff       	call   800ea9 <sys_page_unmap>
}
  801adc:	83 c4 14             	add    $0x14,%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5d                   	pop    %ebp
  801ae1:	c3                   	ret    

00801ae2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	57                   	push   %edi
  801ae6:	56                   	push   %esi
  801ae7:	53                   	push   %ebx
  801ae8:	83 ec 2c             	sub    $0x2c,%esp
  801aeb:	89 c7                	mov    %eax,%edi
  801aed:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801af0:	a1 20 60 80 00       	mov    0x806020,%eax
  801af5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801af8:	89 3c 24             	mov    %edi,(%esp)
  801afb:	e8 00 06 00 00       	call   802100 <pageref>
  801b00:	89 c6                	mov    %eax,%esi
  801b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b05:	89 04 24             	mov    %eax,(%esp)
  801b08:	e8 f3 05 00 00       	call   802100 <pageref>
  801b0d:	39 c6                	cmp    %eax,%esi
  801b0f:	0f 94 c0             	sete   %al
  801b12:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801b15:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801b1b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b1e:	39 cb                	cmp    %ecx,%ebx
  801b20:	75 08                	jne    801b2a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801b22:	83 c4 2c             	add    $0x2c,%esp
  801b25:	5b                   	pop    %ebx
  801b26:	5e                   	pop    %esi
  801b27:	5f                   	pop    %edi
  801b28:	5d                   	pop    %ebp
  801b29:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801b2a:	83 f8 01             	cmp    $0x1,%eax
  801b2d:	75 c1                	jne    801af0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b2f:	8b 52 58             	mov    0x58(%edx),%edx
  801b32:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b36:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b3a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b3e:	c7 04 24 76 28 80 00 	movl   $0x802876,(%esp)
  801b45:	e8 89 e7 ff ff       	call   8002d3 <cprintf>
  801b4a:	eb a4                	jmp    801af0 <_pipeisclosed+0xe>

00801b4c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	57                   	push   %edi
  801b50:	56                   	push   %esi
  801b51:	53                   	push   %ebx
  801b52:	83 ec 2c             	sub    $0x2c,%esp
  801b55:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801b58:	89 34 24             	mov    %esi,(%esp)
  801b5b:	e8 70 f5 ff ff       	call   8010d0 <fd2data>
  801b60:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b62:	bf 00 00 00 00       	mov    $0x0,%edi
  801b67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b6b:	75 50                	jne    801bbd <devpipe_write+0x71>
  801b6d:	eb 5c                	jmp    801bcb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801b6f:	89 da                	mov    %ebx,%edx
  801b71:	89 f0                	mov    %esi,%eax
  801b73:	e8 6a ff ff ff       	call   801ae2 <_pipeisclosed>
  801b78:	85 c0                	test   %eax,%eax
  801b7a:	75 53                	jne    801bcf <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801b7c:	e8 3b f2 ff ff       	call   800dbc <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b81:	8b 43 04             	mov    0x4(%ebx),%eax
  801b84:	8b 13                	mov    (%ebx),%edx
  801b86:	83 c2 20             	add    $0x20,%edx
  801b89:	39 d0                	cmp    %edx,%eax
  801b8b:	73 e2                	jae    801b6f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b90:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801b94:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801b97:	89 c2                	mov    %eax,%edx
  801b99:	c1 fa 1f             	sar    $0x1f,%edx
  801b9c:	c1 ea 1b             	shr    $0x1b,%edx
  801b9f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ba2:	83 e1 1f             	and    $0x1f,%ecx
  801ba5:	29 d1                	sub    %edx,%ecx
  801ba7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801bab:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801baf:	83 c0 01             	add    $0x1,%eax
  801bb2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bb5:	83 c7 01             	add    $0x1,%edi
  801bb8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bbb:	74 0e                	je     801bcb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bbd:	8b 43 04             	mov    0x4(%ebx),%eax
  801bc0:	8b 13                	mov    (%ebx),%edx
  801bc2:	83 c2 20             	add    $0x20,%edx
  801bc5:	39 d0                	cmp    %edx,%eax
  801bc7:	73 a6                	jae    801b6f <devpipe_write+0x23>
  801bc9:	eb c2                	jmp    801b8d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801bcb:	89 f8                	mov    %edi,%eax
  801bcd:	eb 05                	jmp    801bd4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801bd4:	83 c4 2c             	add    $0x2c,%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5f                   	pop    %edi
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    

00801bdc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 28             	sub    $0x28,%esp
  801be2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801be5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801be8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801beb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801bee:	89 3c 24             	mov    %edi,(%esp)
  801bf1:	e8 da f4 ff ff       	call   8010d0 <fd2data>
  801bf6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bf8:	be 00 00 00 00       	mov    $0x0,%esi
  801bfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c01:	75 47                	jne    801c4a <devpipe_read+0x6e>
  801c03:	eb 52                	jmp    801c57 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801c05:	89 f0                	mov    %esi,%eax
  801c07:	eb 5e                	jmp    801c67 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801c09:	89 da                	mov    %ebx,%edx
  801c0b:	89 f8                	mov    %edi,%eax
  801c0d:	8d 76 00             	lea    0x0(%esi),%esi
  801c10:	e8 cd fe ff ff       	call   801ae2 <_pipeisclosed>
  801c15:	85 c0                	test   %eax,%eax
  801c17:	75 49                	jne    801c62 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801c19:	e8 9e f1 ff ff       	call   800dbc <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801c1e:	8b 03                	mov    (%ebx),%eax
  801c20:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c23:	74 e4                	je     801c09 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c25:	89 c2                	mov    %eax,%edx
  801c27:	c1 fa 1f             	sar    $0x1f,%edx
  801c2a:	c1 ea 1b             	shr    $0x1b,%edx
  801c2d:	01 d0                	add    %edx,%eax
  801c2f:	83 e0 1f             	and    $0x1f,%eax
  801c32:	29 d0                	sub    %edx,%eax
  801c34:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801c3f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c42:	83 c6 01             	add    $0x1,%esi
  801c45:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c48:	74 0d                	je     801c57 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801c4a:	8b 03                	mov    (%ebx),%eax
  801c4c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c4f:	75 d4                	jne    801c25 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801c51:	85 f6                	test   %esi,%esi
  801c53:	75 b0                	jne    801c05 <devpipe_read+0x29>
  801c55:	eb b2                	jmp    801c09 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801c57:	89 f0                	mov    %esi,%eax
  801c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c60:	eb 05                	jmp    801c67 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c62:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801c67:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c6a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c6d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c70:	89 ec                	mov    %ebp,%esp
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    

00801c74 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	83 ec 48             	sub    $0x48,%esp
  801c7a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801c7d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801c80:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801c83:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c86:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801c89:	89 04 24             	mov    %eax,(%esp)
  801c8c:	e8 5a f4 ff ff       	call   8010eb <fd_alloc>
  801c91:	89 c3                	mov    %eax,%ebx
  801c93:	85 c0                	test   %eax,%eax
  801c95:	0f 88 45 01 00 00    	js     801de0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c9b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ca2:	00 
  801ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801caa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb1:	e8 36 f1 ff ff       	call   800dec <sys_page_alloc>
  801cb6:	89 c3                	mov    %eax,%ebx
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	0f 88 20 01 00 00    	js     801de0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801cc0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801cc3:	89 04 24             	mov    %eax,(%esp)
  801cc6:	e8 20 f4 ff ff       	call   8010eb <fd_alloc>
  801ccb:	89 c3                	mov    %eax,%ebx
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	0f 88 f8 00 00 00    	js     801dcd <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801cdc:	00 
  801cdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ceb:	e8 fc f0 ff ff       	call   800dec <sys_page_alloc>
  801cf0:	89 c3                	mov    %eax,%ebx
  801cf2:	85 c0                	test   %eax,%eax
  801cf4:	0f 88 d3 00 00 00    	js     801dcd <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801cfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cfd:	89 04 24             	mov    %eax,(%esp)
  801d00:	e8 cb f3 ff ff       	call   8010d0 <fd2data>
  801d05:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d07:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d0e:	00 
  801d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d1a:	e8 cd f0 ff ff       	call   800dec <sys_page_alloc>
  801d1f:	89 c3                	mov    %eax,%ebx
  801d21:	85 c0                	test   %eax,%eax
  801d23:	0f 88 91 00 00 00    	js     801dba <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d2c:	89 04 24             	mov    %eax,(%esp)
  801d2f:	e8 9c f3 ff ff       	call   8010d0 <fd2data>
  801d34:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801d3b:	00 
  801d3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d40:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d47:	00 
  801d48:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d53:	e8 f3 f0 ff ff       	call   800e4b <sys_page_map>
  801d58:	89 c3                	mov    %eax,%ebx
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	78 4c                	js     801daa <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d5e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d67:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d6c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d73:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d7c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d81:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d8b:	89 04 24             	mov    %eax,(%esp)
  801d8e:	e8 2d f3 ff ff       	call   8010c0 <fd2num>
  801d93:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801d95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d98:	89 04 24             	mov    %eax,(%esp)
  801d9b:	e8 20 f3 ff ff       	call   8010c0 <fd2num>
  801da0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801da3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801da8:	eb 36                	jmp    801de0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801daa:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db5:	e8 ef f0 ff ff       	call   800ea9 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801dba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dc8:	e8 dc f0 ff ff       	call   800ea9 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ddb:	e8 c9 f0 ff ff       	call   800ea9 <sys_page_unmap>
    err:
	return r;
}
  801de0:	89 d8                	mov    %ebx,%eax
  801de2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801de5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801de8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801deb:	89 ec                	mov    %ebp,%esp
  801ded:	5d                   	pop    %ebp
  801dee:	c3                   	ret    

00801def <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801df5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	89 04 24             	mov    %eax,(%esp)
  801e02:	e8 57 f3 ff ff       	call   80115e <fd_lookup>
  801e07:	85 c0                	test   %eax,%eax
  801e09:	78 15                	js     801e20 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0e:	89 04 24             	mov    %eax,(%esp)
  801e11:	e8 ba f2 ff ff       	call   8010d0 <fd2data>
	return _pipeisclosed(fd, p);
  801e16:	89 c2                	mov    %eax,%edx
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	e8 c2 fc ff ff       	call   801ae2 <_pipeisclosed>
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    
	...

00801e30 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e33:	b8 00 00 00 00       	mov    $0x0,%eax
  801e38:	5d                   	pop    %ebp
  801e39:	c3                   	ret    

00801e3a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801e40:	c7 44 24 04 8e 28 80 	movl   $0x80288e,0x4(%esp)
  801e47:	00 
  801e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4b:	89 04 24             	mov    %eax,(%esp)
  801e4e:	e8 98 ea ff ff       	call   8008eb <strcpy>
	return 0;
}
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	57                   	push   %edi
  801e5e:	56                   	push   %esi
  801e5f:	53                   	push   %ebx
  801e60:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e66:	be 00 00 00 00       	mov    $0x0,%esi
  801e6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e6f:	74 43                	je     801eb4 <devcons_write+0x5a>
  801e71:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e76:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e7f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801e81:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e84:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801e89:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e8c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e90:	03 45 0c             	add    0xc(%ebp),%eax
  801e93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e97:	89 3c 24             	mov    %edi,(%esp)
  801e9a:	e8 3d ec ff ff       	call   800adc <memmove>
		sys_cputs(buf, m);
  801e9f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ea3:	89 3c 24             	mov    %edi,(%esp)
  801ea6:	e8 25 ee ff ff       	call   800cd0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801eab:	01 de                	add    %ebx,%esi
  801ead:	89 f0                	mov    %esi,%eax
  801eaf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eb2:	72 c8                	jb     801e7c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801eb4:	89 f0                	mov    %esi,%eax
  801eb6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801ebc:	5b                   	pop    %ebx
  801ebd:	5e                   	pop    %esi
  801ebe:	5f                   	pop    %edi
  801ebf:	5d                   	pop    %ebp
  801ec0:	c3                   	ret    

00801ec1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801ecc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed0:	75 07                	jne    801ed9 <devcons_read+0x18>
  801ed2:	eb 31                	jmp    801f05 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801ed4:	e8 e3 ee ff ff       	call   800dbc <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ee0:	e8 1a ee ff ff       	call   800cff <sys_cgetc>
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	74 eb                	je     801ed4 <devcons_read+0x13>
  801ee9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801eeb:	85 c0                	test   %eax,%eax
  801eed:	78 16                	js     801f05 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801eef:	83 f8 04             	cmp    $0x4,%eax
  801ef2:	74 0c                	je     801f00 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef7:	88 10                	mov    %dl,(%eax)
	return 1;
  801ef9:	b8 01 00 00 00       	mov    $0x1,%eax
  801efe:	eb 05                	jmp    801f05 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f13:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f1a:	00 
  801f1b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f1e:	89 04 24             	mov    %eax,(%esp)
  801f21:	e8 aa ed ff ff       	call   800cd0 <sys_cputs>
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <getchar>:

int
getchar(void)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f2e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801f35:	00 
  801f36:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f44:	e8 d5 f4 ff ff       	call   80141e <read>
	if (r < 0)
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	78 0f                	js     801f5c <getchar+0x34>
		return r;
	if (r < 1)
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	7e 06                	jle    801f57 <getchar+0x2f>
		return -E_EOF;
	return c;
  801f51:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801f55:	eb 05                	jmp    801f5c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801f57:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	89 04 24             	mov    %eax,(%esp)
  801f71:	e8 e8 f1 ff ff       	call   80115e <fd_lookup>
  801f76:	85 c0                	test   %eax,%eax
  801f78:	78 11                	js     801f8b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f83:	39 10                	cmp    %edx,(%eax)
  801f85:	0f 94 c0             	sete   %al
  801f88:	0f b6 c0             	movzbl %al,%eax
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <opencons>:

int
opencons(void)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f96:	89 04 24             	mov    %eax,(%esp)
  801f99:	e8 4d f1 ff ff       	call   8010eb <fd_alloc>
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	78 3c                	js     801fde <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fa2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fa9:	00 
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb8:	e8 2f ee ff ff       	call   800dec <sys_page_alloc>
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	78 1d                	js     801fde <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801fc1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fd6:	89 04 24             	mov    %eax,(%esp)
  801fd9:	e8 e2 f0 ff ff       	call   8010c0 <fd2num>
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	56                   	push   %esi
  801fe4:	53                   	push   %ebx
  801fe5:	83 ec 10             	sub    $0x10,%esp
  801fe8:	8b 75 08             	mov    0x8(%ebp),%esi
  801feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801ff1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801ff3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ff8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801ffb:	89 04 24             	mov    %eax,(%esp)
  801ffe:	e8 52 f0 ff ff       	call   801055 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802003:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802008:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80200d:	85 c0                	test   %eax,%eax
  80200f:	78 0e                	js     80201f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  802011:	a1 20 60 80 00       	mov    0x806020,%eax
  802016:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  802019:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80201c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80201f:	85 f6                	test   %esi,%esi
  802021:	74 02                	je     802025 <ipc_recv+0x45>
		*from_env_store = sender;
  802023:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  802025:	85 db                	test   %ebx,%ebx
  802027:	74 02                	je     80202b <ipc_recv+0x4b>
		*perm_store = perm;
  802029:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80202b:	83 c4 10             	add    $0x10,%esp
  80202e:	5b                   	pop    %ebx
  80202f:	5e                   	pop    %esi
  802030:	5d                   	pop    %ebp
  802031:	c3                   	ret    

00802032 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	57                   	push   %edi
  802036:	56                   	push   %esi
  802037:	53                   	push   %ebx
  802038:	83 ec 1c             	sub    $0x1c,%esp
  80203b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80203e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802041:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  802044:	85 db                	test   %ebx,%ebx
  802046:	75 04                	jne    80204c <ipc_send+0x1a>
  802048:	85 f6                	test   %esi,%esi
  80204a:	75 15                	jne    802061 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80204c:	85 db                	test   %ebx,%ebx
  80204e:	74 16                	je     802066 <ipc_send+0x34>
  802050:	85 f6                	test   %esi,%esi
  802052:	0f 94 c0             	sete   %al
      pg = 0;
  802055:	84 c0                	test   %al,%al
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
  80205c:	0f 45 d8             	cmovne %eax,%ebx
  80205f:	eb 05                	jmp    802066 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802061:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802066:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80206a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80206e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	89 04 24             	mov    %eax,(%esp)
  802078:	e8 a4 ef ff ff       	call   801021 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80207d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802080:	75 07                	jne    802089 <ipc_send+0x57>
           sys_yield();
  802082:	e8 35 ed ff ff       	call   800dbc <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  802087:	eb dd                	jmp    802066 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  802089:	85 c0                	test   %eax,%eax
  80208b:	90                   	nop
  80208c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802090:	74 1c                	je     8020ae <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802092:	c7 44 24 08 9a 28 80 	movl   $0x80289a,0x8(%esp)
  802099:	00 
  80209a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8020a1:	00 
  8020a2:	c7 04 24 a4 28 80 00 	movl   $0x8028a4,(%esp)
  8020a9:	e8 2a e1 ff ff       	call   8001d8 <_panic>
		}
    }
}
  8020ae:	83 c4 1c             	add    $0x1c,%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    

008020b6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8020bc:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8020c1:	39 c8                	cmp    %ecx,%eax
  8020c3:	74 17                	je     8020dc <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8020c5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8020ca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020cd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020d3:	8b 52 50             	mov    0x50(%edx),%edx
  8020d6:	39 ca                	cmp    %ecx,%edx
  8020d8:	75 14                	jne    8020ee <ipc_find_env+0x38>
  8020da:	eb 05                	jmp    8020e1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8020dc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8020e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020e4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8020e9:	8b 40 40             	mov    0x40(%eax),%eax
  8020ec:	eb 0e                	jmp    8020fc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8020ee:	83 c0 01             	add    $0x1,%eax
  8020f1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020f6:	75 d2                	jne    8020ca <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8020f8:	66 b8 00 00          	mov    $0x0,%ax
}
  8020fc:	5d                   	pop    %ebp
  8020fd:	c3                   	ret    
	...

00802100 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802106:	89 d0                	mov    %edx,%eax
  802108:	c1 e8 16             	shr    $0x16,%eax
  80210b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802112:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802117:	f6 c1 01             	test   $0x1,%cl
  80211a:	74 1d                	je     802139 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80211c:	c1 ea 0c             	shr    $0xc,%edx
  80211f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802126:	f6 c2 01             	test   $0x1,%dl
  802129:	74 0e                	je     802139 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80212b:	c1 ea 0c             	shr    $0xc,%edx
  80212e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802135:	ef 
  802136:	0f b7 c0             	movzwl %ax,%eax
}
  802139:	5d                   	pop    %ebp
  80213a:	c3                   	ret    
  80213b:	00 00                	add    %al,(%eax)
  80213d:	00 00                	add    %al,(%eax)
	...

00802140 <__udivdi3>:
  802140:	83 ec 1c             	sub    $0x1c,%esp
  802143:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802147:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80214b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80214f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802153:	89 74 24 10          	mov    %esi,0x10(%esp)
  802157:	8b 74 24 24          	mov    0x24(%esp),%esi
  80215b:	85 ff                	test   %edi,%edi
  80215d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802161:	89 44 24 08          	mov    %eax,0x8(%esp)
  802165:	89 cd                	mov    %ecx,%ebp
  802167:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216b:	75 33                	jne    8021a0 <__udivdi3+0x60>
  80216d:	39 f1                	cmp    %esi,%ecx
  80216f:	77 57                	ja     8021c8 <__udivdi3+0x88>
  802171:	85 c9                	test   %ecx,%ecx
  802173:	75 0b                	jne    802180 <__udivdi3+0x40>
  802175:	b8 01 00 00 00       	mov    $0x1,%eax
  80217a:	31 d2                	xor    %edx,%edx
  80217c:	f7 f1                	div    %ecx
  80217e:	89 c1                	mov    %eax,%ecx
  802180:	89 f0                	mov    %esi,%eax
  802182:	31 d2                	xor    %edx,%edx
  802184:	f7 f1                	div    %ecx
  802186:	89 c6                	mov    %eax,%esi
  802188:	8b 44 24 04          	mov    0x4(%esp),%eax
  80218c:	f7 f1                	div    %ecx
  80218e:	89 f2                	mov    %esi,%edx
  802190:	8b 74 24 10          	mov    0x10(%esp),%esi
  802194:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802198:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80219c:	83 c4 1c             	add    $0x1c,%esp
  80219f:	c3                   	ret    
  8021a0:	31 d2                	xor    %edx,%edx
  8021a2:	31 c0                	xor    %eax,%eax
  8021a4:	39 f7                	cmp    %esi,%edi
  8021a6:	77 e8                	ja     802190 <__udivdi3+0x50>
  8021a8:	0f bd cf             	bsr    %edi,%ecx
  8021ab:	83 f1 1f             	xor    $0x1f,%ecx
  8021ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021b2:	75 2c                	jne    8021e0 <__udivdi3+0xa0>
  8021b4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  8021b8:	76 04                	jbe    8021be <__udivdi3+0x7e>
  8021ba:	39 f7                	cmp    %esi,%edi
  8021bc:	73 d2                	jae    802190 <__udivdi3+0x50>
  8021be:	31 d2                	xor    %edx,%edx
  8021c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c5:	eb c9                	jmp    802190 <__udivdi3+0x50>
  8021c7:	90                   	nop
  8021c8:	89 f2                	mov    %esi,%edx
  8021ca:	f7 f1                	div    %ecx
  8021cc:	31 d2                	xor    %edx,%edx
  8021ce:	8b 74 24 10          	mov    0x10(%esp),%esi
  8021d2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8021d6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8021da:	83 c4 1c             	add    $0x1c,%esp
  8021dd:	c3                   	ret    
  8021de:	66 90                	xchg   %ax,%ax
  8021e0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021e5:	b8 20 00 00 00       	mov    $0x20,%eax
  8021ea:	89 ea                	mov    %ebp,%edx
  8021ec:	2b 44 24 04          	sub    0x4(%esp),%eax
  8021f0:	d3 e7                	shl    %cl,%edi
  8021f2:	89 c1                	mov    %eax,%ecx
  8021f4:	d3 ea                	shr    %cl,%edx
  8021f6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021fb:	09 fa                	or     %edi,%edx
  8021fd:	89 f7                	mov    %esi,%edi
  8021ff:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802203:	89 f2                	mov    %esi,%edx
  802205:	8b 74 24 08          	mov    0x8(%esp),%esi
  802209:	d3 e5                	shl    %cl,%ebp
  80220b:	89 c1                	mov    %eax,%ecx
  80220d:	d3 ef                	shr    %cl,%edi
  80220f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802214:	d3 e2                	shl    %cl,%edx
  802216:	89 c1                	mov    %eax,%ecx
  802218:	d3 ee                	shr    %cl,%esi
  80221a:	09 d6                	or     %edx,%esi
  80221c:	89 fa                	mov    %edi,%edx
  80221e:	89 f0                	mov    %esi,%eax
  802220:	f7 74 24 0c          	divl   0xc(%esp)
  802224:	89 d7                	mov    %edx,%edi
  802226:	89 c6                	mov    %eax,%esi
  802228:	f7 e5                	mul    %ebp
  80222a:	39 d7                	cmp    %edx,%edi
  80222c:	72 22                	jb     802250 <__udivdi3+0x110>
  80222e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802232:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802237:	d3 e5                	shl    %cl,%ebp
  802239:	39 c5                	cmp    %eax,%ebp
  80223b:	73 04                	jae    802241 <__udivdi3+0x101>
  80223d:	39 d7                	cmp    %edx,%edi
  80223f:	74 0f                	je     802250 <__udivdi3+0x110>
  802241:	89 f0                	mov    %esi,%eax
  802243:	31 d2                	xor    %edx,%edx
  802245:	e9 46 ff ff ff       	jmp    802190 <__udivdi3+0x50>
  80224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802250:	8d 46 ff             	lea    -0x1(%esi),%eax
  802253:	31 d2                	xor    %edx,%edx
  802255:	8b 74 24 10          	mov    0x10(%esp),%esi
  802259:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80225d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802261:	83 c4 1c             	add    $0x1c,%esp
  802264:	c3                   	ret    
	...

00802270 <__umoddi3>:
  802270:	83 ec 1c             	sub    $0x1c,%esp
  802273:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802277:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80227b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80227f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802283:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802287:	8b 74 24 24          	mov    0x24(%esp),%esi
  80228b:	85 ed                	test   %ebp,%ebp
  80228d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802291:	89 44 24 08          	mov    %eax,0x8(%esp)
  802295:	89 cf                	mov    %ecx,%edi
  802297:	89 04 24             	mov    %eax,(%esp)
  80229a:	89 f2                	mov    %esi,%edx
  80229c:	75 1a                	jne    8022b8 <__umoddi3+0x48>
  80229e:	39 f1                	cmp    %esi,%ecx
  8022a0:	76 4e                	jbe    8022f0 <__umoddi3+0x80>
  8022a2:	f7 f1                	div    %ecx
  8022a4:	89 d0                	mov    %edx,%eax
  8022a6:	31 d2                	xor    %edx,%edx
  8022a8:	8b 74 24 10          	mov    0x10(%esp),%esi
  8022ac:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8022b0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8022b4:	83 c4 1c             	add    $0x1c,%esp
  8022b7:	c3                   	ret    
  8022b8:	39 f5                	cmp    %esi,%ebp
  8022ba:	77 54                	ja     802310 <__umoddi3+0xa0>
  8022bc:	0f bd c5             	bsr    %ebp,%eax
  8022bf:	83 f0 1f             	xor    $0x1f,%eax
  8022c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c6:	75 60                	jne    802328 <__umoddi3+0xb8>
  8022c8:	3b 0c 24             	cmp    (%esp),%ecx
  8022cb:	0f 87 07 01 00 00    	ja     8023d8 <__umoddi3+0x168>
  8022d1:	89 f2                	mov    %esi,%edx
  8022d3:	8b 34 24             	mov    (%esp),%esi
  8022d6:	29 ce                	sub    %ecx,%esi
  8022d8:	19 ea                	sbb    %ebp,%edx
  8022da:	89 34 24             	mov    %esi,(%esp)
  8022dd:	8b 04 24             	mov    (%esp),%eax
  8022e0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8022e4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8022e8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8022ec:	83 c4 1c             	add    $0x1c,%esp
  8022ef:	c3                   	ret    
  8022f0:	85 c9                	test   %ecx,%ecx
  8022f2:	75 0b                	jne    8022ff <__umoddi3+0x8f>
  8022f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f9:	31 d2                	xor    %edx,%edx
  8022fb:	f7 f1                	div    %ecx
  8022fd:	89 c1                	mov    %eax,%ecx
  8022ff:	89 f0                	mov    %esi,%eax
  802301:	31 d2                	xor    %edx,%edx
  802303:	f7 f1                	div    %ecx
  802305:	8b 04 24             	mov    (%esp),%eax
  802308:	f7 f1                	div    %ecx
  80230a:	eb 98                	jmp    8022a4 <__umoddi3+0x34>
  80230c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802310:	89 f2                	mov    %esi,%edx
  802312:	8b 74 24 10          	mov    0x10(%esp),%esi
  802316:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80231a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80231e:	83 c4 1c             	add    $0x1c,%esp
  802321:	c3                   	ret    
  802322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802328:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80232d:	89 e8                	mov    %ebp,%eax
  80232f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802334:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802338:	89 fa                	mov    %edi,%edx
  80233a:	d3 e0                	shl    %cl,%eax
  80233c:	89 e9                	mov    %ebp,%ecx
  80233e:	d3 ea                	shr    %cl,%edx
  802340:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802345:	09 c2                	or     %eax,%edx
  802347:	8b 44 24 08          	mov    0x8(%esp),%eax
  80234b:	89 14 24             	mov    %edx,(%esp)
  80234e:	89 f2                	mov    %esi,%edx
  802350:	d3 e7                	shl    %cl,%edi
  802352:	89 e9                	mov    %ebp,%ecx
  802354:	d3 ea                	shr    %cl,%edx
  802356:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80235b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80235f:	d3 e6                	shl    %cl,%esi
  802361:	89 e9                	mov    %ebp,%ecx
  802363:	d3 e8                	shr    %cl,%eax
  802365:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80236a:	09 f0                	or     %esi,%eax
  80236c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802370:	f7 34 24             	divl   (%esp)
  802373:	d3 e6                	shl    %cl,%esi
  802375:	89 74 24 08          	mov    %esi,0x8(%esp)
  802379:	89 d6                	mov    %edx,%esi
  80237b:	f7 e7                	mul    %edi
  80237d:	39 d6                	cmp    %edx,%esi
  80237f:	89 c1                	mov    %eax,%ecx
  802381:	89 d7                	mov    %edx,%edi
  802383:	72 3f                	jb     8023c4 <__umoddi3+0x154>
  802385:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802389:	72 35                	jb     8023c0 <__umoddi3+0x150>
  80238b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80238f:	29 c8                	sub    %ecx,%eax
  802391:	19 fe                	sbb    %edi,%esi
  802393:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802398:	89 f2                	mov    %esi,%edx
  80239a:	d3 e8                	shr    %cl,%eax
  80239c:	89 e9                	mov    %ebp,%ecx
  80239e:	d3 e2                	shl    %cl,%edx
  8023a0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023a5:	09 d0                	or     %edx,%eax
  8023a7:	89 f2                	mov    %esi,%edx
  8023a9:	d3 ea                	shr    %cl,%edx
  8023ab:	8b 74 24 10          	mov    0x10(%esp),%esi
  8023af:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8023b3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8023b7:	83 c4 1c             	add    $0x1c,%esp
  8023ba:	c3                   	ret    
  8023bb:	90                   	nop
  8023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023c0:	39 d6                	cmp    %edx,%esi
  8023c2:	75 c7                	jne    80238b <__umoddi3+0x11b>
  8023c4:	89 d7                	mov    %edx,%edi
  8023c6:	89 c1                	mov    %eax,%ecx
  8023c8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8023cc:	1b 3c 24             	sbb    (%esp),%edi
  8023cf:	eb ba                	jmp    80238b <__umoddi3+0x11b>
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	39 f5                	cmp    %esi,%ebp
  8023da:	0f 82 f1 fe ff ff    	jb     8022d1 <__umoddi3+0x61>
  8023e0:	e9 f8 fe ff ff       	jmp    8022dd <__umoddi3+0x6d>
