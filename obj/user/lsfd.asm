
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 0f 01 00 00       	call   800140 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: lsfd [-1]\n");
  800046:	c7 04 24 20 25 80 00 	movl   $0x802520,(%esp)
  80004d:	e8 fd 01 00 00       	call   80024f <cprintf>
	exit();
  800052:	e8 39 01 00 00       	call   800190 <exit>
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <umain>:

void
umain(int argc, char **argv)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	56                   	push   %esi
  80005e:	53                   	push   %ebx
  80005f:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800065:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80006b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800072:	89 44 24 04          	mov    %eax,0x4(%esp)
  800076:	8d 45 08             	lea    0x8(%ebp),%eax
  800079:	89 04 24             	mov    %eax,(%esp)
  80007c:	e8 b3 0f 00 00       	call   801034 <argstart>
}

void
umain(int argc, char **argv)
{
	int i, usefprint = 0;
  800081:	bf 00 00 00 00       	mov    $0x0,%edi
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800086:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
  80008c:	eb 11                	jmp    80009f <umain+0x46>
		if (i == '1')
  80008e:	83 f8 31             	cmp    $0x31,%eax
  800091:	74 07                	je     80009a <umain+0x41>
			usefprint = 1;
		else
			usage();
  800093:	e8 a8 ff ff ff       	call   800040 <usage>
  800098:	eb 05                	jmp    80009f <umain+0x46>
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
		if (i == '1')
			usefprint = 1;
  80009a:	bf 01 00 00 00       	mov    $0x1,%edi
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  80009f:	89 1c 24             	mov    %ebx,(%esp)
  8000a2:	e8 bd 0f 00 00       	call   801064 <argnext>
  8000a7:	85 c0                	test   %eax,%eax
  8000a9:	79 e3                	jns    80008e <umain+0x35>
  8000ab:	bb 00 00 00 00       	mov    $0x0,%ebx
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000b0:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
  8000b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000ba:	89 1c 24             	mov    %ebx,(%esp)
  8000bd:	e8 47 16 00 00       	call   801709 <fstat>
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	78 66                	js     80012c <umain+0xd3>
			if (usefprint)
  8000c6:	85 ff                	test   %edi,%edi
  8000c8:	74 36                	je     800100 <umain+0xa7>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  8000ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000cd:	8b 40 04             	mov    0x4(%eax),%eax
  8000d0:	89 44 24 18          	mov    %eax,0x18(%esp)
  8000d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d7:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000de:	89 44 24 10          	mov    %eax,0x10(%esp)
					i, st.st_name, st.st_isdir,
  8000e2:	89 74 24 0c          	mov    %esi,0xc(%esp)
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000e6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000ea:	c7 44 24 04 34 25 80 	movl   $0x802534,0x4(%esp)
  8000f1:	00 
  8000f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000f9:	e8 da 19 00 00       	call   801ad8 <fprintf>
  8000fe:	eb 2c                	jmp    80012c <umain+0xd3>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800103:	8b 40 04             	mov    0x4(%eax),%eax
  800106:	89 44 24 14          	mov    %eax,0x14(%esp)
  80010a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80010d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800111:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800114:	89 44 24 0c          	mov    %eax,0xc(%esp)
					i, st.st_name, st.st_isdir,
  800118:	89 74 24 08          	mov    %esi,0x8(%esp)
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  80011c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800120:	c7 04 24 34 25 80 00 	movl   $0x802534,(%esp)
  800127:	e8 23 01 00 00       	call   80024f <cprintf>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  80012c:	83 c3 01             	add    $0x1,%ebx
  80012f:	83 fb 20             	cmp    $0x20,%ebx
  800132:	75 82                	jne    8000b6 <umain+0x5d>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800134:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5f                   	pop    %edi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    
	...

00800140 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	83 ec 18             	sub    $0x18,%esp
  800146:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800149:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80014c:	8b 75 08             	mov    0x8(%ebp),%esi
  80014f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800152:	e8 b5 0b 00 00       	call   800d0c <sys_getenvid>
  800157:	25 ff 03 00 00       	and    $0x3ff,%eax
  80015c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80015f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800164:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800169:	85 f6                	test   %esi,%esi
  80016b:	7e 07                	jle    800174 <libmain+0x34>
		binaryname = argv[0];
  80016d:	8b 03                	mov    (%ebx),%eax
  80016f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800174:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800178:	89 34 24             	mov    %esi,(%esp)
  80017b:	e8 d9 fe ff ff       	call   800059 <umain>

	// exit gracefully
	exit();
  800180:	e8 0b 00 00 00       	call   800190 <exit>
}
  800185:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800188:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80018b:	89 ec                	mov    %ebp,%esp
  80018d:	5d                   	pop    %ebp
  80018e:	c3                   	ret    
	...

00800190 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800196:	e8 13 12 00 00       	call   8013ae <close_all>
	sys_env_destroy(0);
  80019b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a2:	e8 08 0b 00 00       	call   800caf <sys_env_destroy>
}
  8001a7:	c9                   	leave  
  8001a8:	c3                   	ret    
  8001a9:	00 00                	add    %al,(%eax)
	...

008001ac <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	53                   	push   %ebx
  8001b0:	83 ec 14             	sub    $0x14,%esp
  8001b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b6:	8b 03                	mov    (%ebx),%eax
  8001b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bb:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001bf:	83 c0 01             	add    $0x1,%eax
  8001c2:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001c4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c9:	75 19                	jne    8001e4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001cb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001d2:	00 
  8001d3:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d6:	89 04 24             	mov    %eax,(%esp)
  8001d9:	e8 72 0a 00 00       	call   800c50 <sys_cputs>
		b->idx = 0;
  8001de:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001e4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001e8:	83 c4 14             	add    $0x14,%esp
  8001eb:	5b                   	pop    %ebx
  8001ec:	5d                   	pop    %ebp
  8001ed:	c3                   	ret    

008001ee <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001f7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fe:	00 00 00 
	b.cnt = 0;
  800201:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800208:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80020b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800212:	8b 45 08             	mov    0x8(%ebp),%eax
  800215:	89 44 24 08          	mov    %eax,0x8(%esp)
  800219:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800223:	c7 04 24 ac 01 80 00 	movl   $0x8001ac,(%esp)
  80022a:	e8 9b 01 00 00       	call   8003ca <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80022f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800235:	89 44 24 04          	mov    %eax,0x4(%esp)
  800239:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023f:	89 04 24             	mov    %eax,(%esp)
  800242:	e8 09 0a 00 00       	call   800c50 <sys_cputs>

	return b.cnt;
}
  800247:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80024d:	c9                   	leave  
  80024e:	c3                   	ret    

0080024f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800255:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800258:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025c:	8b 45 08             	mov    0x8(%ebp),%eax
  80025f:	89 04 24             	mov    %eax,(%esp)
  800262:	e8 87 ff ff ff       	call   8001ee <vcprintf>
	va_end(ap);

	return cnt;
}
  800267:	c9                   	leave  
  800268:	c3                   	ret    
  800269:	00 00                	add    %al,(%eax)
  80026b:	00 00                	add    %al,(%eax)
  80026d:	00 00                	add    %al,(%eax)
	...

00800270 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	57                   	push   %edi
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
  800276:	83 ec 3c             	sub    $0x3c,%esp
  800279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027c:	89 d7                	mov    %edx,%edi
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80028a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80028d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800290:	b8 00 00 00 00       	mov    $0x0,%eax
  800295:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800298:	72 11                	jb     8002ab <printnum+0x3b>
  80029a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029d:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002a0:	76 09                	jbe    8002ab <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002a2:	83 eb 01             	sub    $0x1,%ebx
  8002a5:	85 db                	test   %ebx,%ebx
  8002a7:	7f 51                	jg     8002fa <printnum+0x8a>
  8002a9:	eb 5e                	jmp    800309 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ab:	89 74 24 10          	mov    %esi,0x10(%esp)
  8002af:	83 eb 01             	sub    $0x1,%ebx
  8002b2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002bd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8002c1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8002c5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002cc:	00 
  8002cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002d0:	89 04 24             	mov    %eax,(%esp)
  8002d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002da:	e8 91 1f 00 00       	call   802270 <__udivdi3>
  8002df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002e7:	89 04 24             	mov    %eax,(%esp)
  8002ea:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002ee:	89 fa                	mov    %edi,%edx
  8002f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002f3:	e8 78 ff ff ff       	call   800270 <printnum>
  8002f8:	eb 0f                	jmp    800309 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002fe:	89 34 24             	mov    %esi,(%esp)
  800301:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800304:	83 eb 01             	sub    $0x1,%ebx
  800307:	75 f1                	jne    8002fa <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800309:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80030d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800311:	8b 45 10             	mov    0x10(%ebp),%eax
  800314:	89 44 24 08          	mov    %eax,0x8(%esp)
  800318:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80031f:	00 
  800320:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800323:	89 04 24             	mov    %eax,(%esp)
  800326:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800329:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032d:	e8 6e 20 00 00       	call   8023a0 <__umoddi3>
  800332:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800336:	0f be 80 66 25 80 00 	movsbl 0x802566(%eax),%eax
  80033d:	89 04 24             	mov    %eax,(%esp)
  800340:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800343:	83 c4 3c             	add    $0x3c,%esp
  800346:	5b                   	pop    %ebx
  800347:	5e                   	pop    %esi
  800348:	5f                   	pop    %edi
  800349:	5d                   	pop    %ebp
  80034a:	c3                   	ret    

0080034b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80034e:	83 fa 01             	cmp    $0x1,%edx
  800351:	7e 0e                	jle    800361 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800353:	8b 10                	mov    (%eax),%edx
  800355:	8d 4a 08             	lea    0x8(%edx),%ecx
  800358:	89 08                	mov    %ecx,(%eax)
  80035a:	8b 02                	mov    (%edx),%eax
  80035c:	8b 52 04             	mov    0x4(%edx),%edx
  80035f:	eb 22                	jmp    800383 <getuint+0x38>
	else if (lflag)
  800361:	85 d2                	test   %edx,%edx
  800363:	74 10                	je     800375 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800365:	8b 10                	mov    (%eax),%edx
  800367:	8d 4a 04             	lea    0x4(%edx),%ecx
  80036a:	89 08                	mov    %ecx,(%eax)
  80036c:	8b 02                	mov    (%edx),%eax
  80036e:	ba 00 00 00 00       	mov    $0x0,%edx
  800373:	eb 0e                	jmp    800383 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800375:	8b 10                	mov    (%eax),%edx
  800377:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037a:	89 08                	mov    %ecx,(%eax)
  80037c:	8b 02                	mov    (%edx),%eax
  80037e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800383:	5d                   	pop    %ebp
  800384:	c3                   	ret    

00800385 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80038f:	8b 10                	mov    (%eax),%edx
  800391:	3b 50 04             	cmp    0x4(%eax),%edx
  800394:	73 0a                	jae    8003a0 <sprintputch+0x1b>
		*b->buf++ = ch;
  800396:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800399:	88 0a                	mov    %cl,(%edx)
  80039b:	83 c2 01             	add    $0x1,%edx
  80039e:	89 10                	mov    %edx,(%eax)
}
  8003a0:	5d                   	pop    %ebp
  8003a1:	c3                   	ret    

008003a2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003a2:	55                   	push   %ebp
  8003a3:	89 e5                	mov    %esp,%ebp
  8003a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003a8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003af:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	89 04 24             	mov    %eax,(%esp)
  8003c3:	e8 02 00 00 00       	call   8003ca <vprintfmt>
	va_end(ap);
}
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    

008003ca <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	57                   	push   %edi
  8003ce:	56                   	push   %esi
  8003cf:	53                   	push   %ebx
  8003d0:	83 ec 4c             	sub    $0x4c,%esp
  8003d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003d6:	8b 75 10             	mov    0x10(%ebp),%esi
  8003d9:	eb 12                	jmp    8003ed <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003db:	85 c0                	test   %eax,%eax
  8003dd:	0f 84 a9 03 00 00    	je     80078c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  8003e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003e7:	89 04 24             	mov    %eax,(%esp)
  8003ea:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ed:	0f b6 06             	movzbl (%esi),%eax
  8003f0:	83 c6 01             	add    $0x1,%esi
  8003f3:	83 f8 25             	cmp    $0x25,%eax
  8003f6:	75 e3                	jne    8003db <vprintfmt+0x11>
  8003f8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8003fc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800403:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800408:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80040f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800414:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800417:	eb 2b                	jmp    800444 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800419:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80041c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800420:	eb 22                	jmp    800444 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800422:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800425:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800429:	eb 19                	jmp    800444 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80042e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800435:	eb 0d                	jmp    800444 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800437:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80043d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800444:	0f b6 06             	movzbl (%esi),%eax
  800447:	0f b6 d0             	movzbl %al,%edx
  80044a:	8d 7e 01             	lea    0x1(%esi),%edi
  80044d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800450:	83 e8 23             	sub    $0x23,%eax
  800453:	3c 55                	cmp    $0x55,%al
  800455:	0f 87 0b 03 00 00    	ja     800766 <vprintfmt+0x39c>
  80045b:	0f b6 c0             	movzbl %al,%eax
  80045e:	ff 24 85 a0 26 80 00 	jmp    *0x8026a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800465:	83 ea 30             	sub    $0x30,%edx
  800468:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80046b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80046f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800472:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800475:	83 fa 09             	cmp    $0x9,%edx
  800478:	77 4a                	ja     8004c4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80047d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800480:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800483:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800487:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80048a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80048d:	83 fa 09             	cmp    $0x9,%edx
  800490:	76 eb                	jbe    80047d <vprintfmt+0xb3>
  800492:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800495:	eb 2d                	jmp    8004c4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8d 50 04             	lea    0x4(%eax),%edx
  80049d:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004a8:	eb 1a                	jmp    8004c4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004aa:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8004ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004b1:	79 91                	jns    800444 <vprintfmt+0x7a>
  8004b3:	e9 73 ff ff ff       	jmp    80042b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004bb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004c2:	eb 80                	jmp    800444 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8004c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004c8:	0f 89 76 ff ff ff    	jns    800444 <vprintfmt+0x7a>
  8004ce:	e9 64 ff ff ff       	jmp    800437 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004d3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004d9:	e9 66 ff ff ff       	jmp    800444 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004de:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e1:	8d 50 04             	lea    0x4(%eax),%edx
  8004e4:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	89 04 24             	mov    %eax,(%esp)
  8004f0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8004f6:	e9 f2 fe ff ff       	jmp    8003ed <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	8d 50 04             	lea    0x4(%eax),%edx
  800501:	89 55 14             	mov    %edx,0x14(%ebp)
  800504:	8b 00                	mov    (%eax),%eax
  800506:	89 c2                	mov    %eax,%edx
  800508:	c1 fa 1f             	sar    $0x1f,%edx
  80050b:	31 d0                	xor    %edx,%eax
  80050d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050f:	83 f8 0f             	cmp    $0xf,%eax
  800512:	7f 0b                	jg     80051f <vprintfmt+0x155>
  800514:	8b 14 85 00 28 80 00 	mov    0x802800(,%eax,4),%edx
  80051b:	85 d2                	test   %edx,%edx
  80051d:	75 23                	jne    800542 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80051f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800523:	c7 44 24 08 7e 25 80 	movl   $0x80257e,0x8(%esp)
  80052a:	00 
  80052b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80052f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800532:	89 3c 24             	mov    %edi,(%esp)
  800535:	e8 68 fe ff ff       	call   8003a2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80053d:	e9 ab fe ff ff       	jmp    8003ed <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800542:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800546:	c7 44 24 08 31 29 80 	movl   $0x802931,0x8(%esp)
  80054d:	00 
  80054e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800552:	8b 7d 08             	mov    0x8(%ebp),%edi
  800555:	89 3c 24             	mov    %edi,(%esp)
  800558:	e8 45 fe ff ff       	call   8003a2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800560:	e9 88 fe ff ff       	jmp    8003ed <vprintfmt+0x23>
  800565:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80056b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8d 50 04             	lea    0x4(%eax),%edx
  800574:	89 55 14             	mov    %edx,0x14(%ebp)
  800577:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800579:	85 f6                	test   %esi,%esi
  80057b:	ba 77 25 80 00       	mov    $0x802577,%edx
  800580:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800583:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800587:	7e 06                	jle    80058f <vprintfmt+0x1c5>
  800589:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80058d:	75 10                	jne    80059f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80058f:	0f be 06             	movsbl (%esi),%eax
  800592:	83 c6 01             	add    $0x1,%esi
  800595:	85 c0                	test   %eax,%eax
  800597:	0f 85 86 00 00 00    	jne    800623 <vprintfmt+0x259>
  80059d:	eb 76                	jmp    800615 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80059f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a3:	89 34 24             	mov    %esi,(%esp)
  8005a6:	e8 90 02 00 00       	call   80083b <strnlen>
  8005ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ae:	29 c2                	sub    %eax,%edx
  8005b0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005b3:	85 d2                	test   %edx,%edx
  8005b5:	7e d8                	jle    80058f <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005b7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005bb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8005be:	89 d6                	mov    %edx,%esi
  8005c0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8005c3:	89 c7                	mov    %eax,%edi
  8005c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005c9:	89 3c 24             	mov    %edi,(%esp)
  8005cc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cf:	83 ee 01             	sub    $0x1,%esi
  8005d2:	75 f1                	jne    8005c5 <vprintfmt+0x1fb>
  8005d4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005d7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8005da:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8005dd:	eb b0                	jmp    80058f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005e3:	74 18                	je     8005fd <vprintfmt+0x233>
  8005e5:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005e8:	83 fa 5e             	cmp    $0x5e,%edx
  8005eb:	76 10                	jbe    8005fd <vprintfmt+0x233>
					putch('?', putdat);
  8005ed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005f1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005f8:	ff 55 08             	call   *0x8(%ebp)
  8005fb:	eb 0a                	jmp    800607 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  8005fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800601:	89 04 24             	mov    %eax,(%esp)
  800604:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800607:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80060b:	0f be 06             	movsbl (%esi),%eax
  80060e:	83 c6 01             	add    $0x1,%esi
  800611:	85 c0                	test   %eax,%eax
  800613:	75 0e                	jne    800623 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800615:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800618:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061c:	7f 16                	jg     800634 <vprintfmt+0x26a>
  80061e:	e9 ca fd ff ff       	jmp    8003ed <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800623:	85 ff                	test   %edi,%edi
  800625:	78 b8                	js     8005df <vprintfmt+0x215>
  800627:	83 ef 01             	sub    $0x1,%edi
  80062a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800630:	79 ad                	jns    8005df <vprintfmt+0x215>
  800632:	eb e1                	jmp    800615 <vprintfmt+0x24b>
  800634:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800637:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80063a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80063e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800645:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800647:	83 ee 01             	sub    $0x1,%esi
  80064a:	75 ee                	jne    80063a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80064c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80064f:	e9 99 fd ff ff       	jmp    8003ed <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800654:	83 f9 01             	cmp    $0x1,%ecx
  800657:	7e 10                	jle    800669 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8d 50 08             	lea    0x8(%eax),%edx
  80065f:	89 55 14             	mov    %edx,0x14(%ebp)
  800662:	8b 30                	mov    (%eax),%esi
  800664:	8b 78 04             	mov    0x4(%eax),%edi
  800667:	eb 26                	jmp    80068f <vprintfmt+0x2c5>
	else if (lflag)
  800669:	85 c9                	test   %ecx,%ecx
  80066b:	74 12                	je     80067f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8d 50 04             	lea    0x4(%eax),%edx
  800673:	89 55 14             	mov    %edx,0x14(%ebp)
  800676:	8b 30                	mov    (%eax),%esi
  800678:	89 f7                	mov    %esi,%edi
  80067a:	c1 ff 1f             	sar    $0x1f,%edi
  80067d:	eb 10                	jmp    80068f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 50 04             	lea    0x4(%eax),%edx
  800685:	89 55 14             	mov    %edx,0x14(%ebp)
  800688:	8b 30                	mov    (%eax),%esi
  80068a:	89 f7                	mov    %esi,%edi
  80068c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80068f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800694:	85 ff                	test   %edi,%edi
  800696:	0f 89 8c 00 00 00    	jns    800728 <vprintfmt+0x35e>
				putch('-', putdat);
  80069c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006a0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006a7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006aa:	f7 de                	neg    %esi
  8006ac:	83 d7 00             	adc    $0x0,%edi
  8006af:	f7 df                	neg    %edi
			}
			base = 10;
  8006b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b6:	eb 70                	jmp    800728 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006b8:	89 ca                	mov    %ecx,%edx
  8006ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8006bd:	e8 89 fc ff ff       	call   80034b <getuint>
  8006c2:	89 c6                	mov    %eax,%esi
  8006c4:	89 d7                	mov    %edx,%edi
			base = 10;
  8006c6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8006cb:	eb 5b                	jmp    800728 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006cd:	89 ca                	mov    %ecx,%edx
  8006cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d2:	e8 74 fc ff ff       	call   80034b <getuint>
  8006d7:	89 c6                	mov    %eax,%esi
  8006d9:	89 d7                	mov    %edx,%edi
			base = 8;
  8006db:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8006e0:	eb 46                	jmp    800728 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  8006e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006e6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006ed:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006fb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 50 04             	lea    0x4(%eax),%edx
  800704:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800707:	8b 30                	mov    (%eax),%esi
  800709:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80070e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800713:	eb 13                	jmp    800728 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800715:	89 ca                	mov    %ecx,%edx
  800717:	8d 45 14             	lea    0x14(%ebp),%eax
  80071a:	e8 2c fc ff ff       	call   80034b <getuint>
  80071f:	89 c6                	mov    %eax,%esi
  800721:	89 d7                	mov    %edx,%edi
			base = 16;
  800723:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800728:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80072c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800730:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800733:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800737:	89 44 24 08          	mov    %eax,0x8(%esp)
  80073b:	89 34 24             	mov    %esi,(%esp)
  80073e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800742:	89 da                	mov    %ebx,%edx
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	e8 24 fb ff ff       	call   800270 <printnum>
			break;
  80074c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80074f:	e9 99 fc ff ff       	jmp    8003ed <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800754:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800758:	89 14 24             	mov    %edx,(%esp)
  80075b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800761:	e9 87 fc ff ff       	jmp    8003ed <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800766:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80076a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800771:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800774:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800778:	0f 84 6f fc ff ff    	je     8003ed <vprintfmt+0x23>
  80077e:	83 ee 01             	sub    $0x1,%esi
  800781:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800785:	75 f7                	jne    80077e <vprintfmt+0x3b4>
  800787:	e9 61 fc ff ff       	jmp    8003ed <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80078c:	83 c4 4c             	add    $0x4c,%esp
  80078f:	5b                   	pop    %ebx
  800790:	5e                   	pop    %esi
  800791:	5f                   	pop    %edi
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	83 ec 28             	sub    $0x28,%esp
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007b1:	85 c0                	test   %eax,%eax
  8007b3:	74 30                	je     8007e5 <vsnprintf+0x51>
  8007b5:	85 d2                	test   %edx,%edx
  8007b7:	7e 2c                	jle    8007e5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ce:	c7 04 24 85 03 80 00 	movl   $0x800385,(%esp)
  8007d5:	e8 f0 fb ff ff       	call   8003ca <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007dd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e3:	eb 05                	jmp    8007ea <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007ea:	c9                   	leave  
  8007eb:	c3                   	ret    

008007ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007f2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	89 44 24 04          	mov    %eax,0x4(%esp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	89 04 24             	mov    %eax,(%esp)
  80080d:	e8 82 ff ff ff       	call   800794 <vsnprintf>
	va_end(ap);

	return rc;
}
  800812:	c9                   	leave  
  800813:	c3                   	ret    
	...

00800820 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800826:	b8 00 00 00 00       	mov    $0x0,%eax
  80082b:	80 3a 00             	cmpb   $0x0,(%edx)
  80082e:	74 09                	je     800839 <strlen+0x19>
		n++;
  800830:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800833:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800837:	75 f7                	jne    800830 <strlen+0x10>
		n++;
	return n;
}
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    

0080083b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	53                   	push   %ebx
  80083f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800842:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800845:	b8 00 00 00 00       	mov    $0x0,%eax
  80084a:	85 c9                	test   %ecx,%ecx
  80084c:	74 1a                	je     800868 <strnlen+0x2d>
  80084e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800851:	74 15                	je     800868 <strnlen+0x2d>
  800853:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800858:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085a:	39 ca                	cmp    %ecx,%edx
  80085c:	74 0a                	je     800868 <strnlen+0x2d>
  80085e:	83 c2 01             	add    $0x1,%edx
  800861:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800866:	75 f0                	jne    800858 <strnlen+0x1d>
		n++;
	return n;
}
  800868:	5b                   	pop    %ebx
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	53                   	push   %ebx
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800875:	ba 00 00 00 00       	mov    $0x0,%edx
  80087a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80087e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800881:	83 c2 01             	add    $0x1,%edx
  800884:	84 c9                	test   %cl,%cl
  800886:	75 f2                	jne    80087a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800888:	5b                   	pop    %ebx
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	53                   	push   %ebx
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800895:	89 1c 24             	mov    %ebx,(%esp)
  800898:	e8 83 ff ff ff       	call   800820 <strlen>
	strcpy(dst + len, src);
  80089d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008a4:	01 d8                	add    %ebx,%eax
  8008a6:	89 04 24             	mov    %eax,(%esp)
  8008a9:	e8 bd ff ff ff       	call   80086b <strcpy>
	return dst;
}
  8008ae:	89 d8                	mov    %ebx,%eax
  8008b0:	83 c4 08             	add    $0x8,%esp
  8008b3:	5b                   	pop    %ebx
  8008b4:	5d                   	pop    %ebp
  8008b5:	c3                   	ret    

008008b6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	56                   	push   %esi
  8008ba:	53                   	push   %ebx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c4:	85 f6                	test   %esi,%esi
  8008c6:	74 18                	je     8008e0 <strncpy+0x2a>
  8008c8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8008cd:	0f b6 1a             	movzbl (%edx),%ebx
  8008d0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d3:	80 3a 01             	cmpb   $0x1,(%edx)
  8008d6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d9:	83 c1 01             	add    $0x1,%ecx
  8008dc:	39 f1                	cmp    %esi,%ecx
  8008de:	75 ed                	jne    8008cd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008e0:	5b                   	pop    %ebx
  8008e1:	5e                   	pop    %esi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	57                   	push   %edi
  8008e8:	56                   	push   %esi
  8008e9:	53                   	push   %ebx
  8008ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008f0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f3:	89 f8                	mov    %edi,%eax
  8008f5:	85 f6                	test   %esi,%esi
  8008f7:	74 2b                	je     800924 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  8008f9:	83 fe 01             	cmp    $0x1,%esi
  8008fc:	74 23                	je     800921 <strlcpy+0x3d>
  8008fe:	0f b6 0b             	movzbl (%ebx),%ecx
  800901:	84 c9                	test   %cl,%cl
  800903:	74 1c                	je     800921 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800905:	83 ee 02             	sub    $0x2,%esi
  800908:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80090d:	88 08                	mov    %cl,(%eax)
  80090f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800912:	39 f2                	cmp    %esi,%edx
  800914:	74 0b                	je     800921 <strlcpy+0x3d>
  800916:	83 c2 01             	add    $0x1,%edx
  800919:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80091d:	84 c9                	test   %cl,%cl
  80091f:	75 ec                	jne    80090d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800921:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800924:	29 f8                	sub    %edi,%eax
}
  800926:	5b                   	pop    %ebx
  800927:	5e                   	pop    %esi
  800928:	5f                   	pop    %edi
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800934:	0f b6 01             	movzbl (%ecx),%eax
  800937:	84 c0                	test   %al,%al
  800939:	74 16                	je     800951 <strcmp+0x26>
  80093b:	3a 02                	cmp    (%edx),%al
  80093d:	75 12                	jne    800951 <strcmp+0x26>
		p++, q++;
  80093f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800942:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800946:	84 c0                	test   %al,%al
  800948:	74 07                	je     800951 <strcmp+0x26>
  80094a:	83 c1 01             	add    $0x1,%ecx
  80094d:	3a 02                	cmp    (%edx),%al
  80094f:	74 ee                	je     80093f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800951:	0f b6 c0             	movzbl %al,%eax
  800954:	0f b6 12             	movzbl (%edx),%edx
  800957:	29 d0                	sub    %edx,%eax
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	53                   	push   %ebx
  80095f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800962:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800965:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800968:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80096d:	85 d2                	test   %edx,%edx
  80096f:	74 28                	je     800999 <strncmp+0x3e>
  800971:	0f b6 01             	movzbl (%ecx),%eax
  800974:	84 c0                	test   %al,%al
  800976:	74 24                	je     80099c <strncmp+0x41>
  800978:	3a 03                	cmp    (%ebx),%al
  80097a:	75 20                	jne    80099c <strncmp+0x41>
  80097c:	83 ea 01             	sub    $0x1,%edx
  80097f:	74 13                	je     800994 <strncmp+0x39>
		n--, p++, q++;
  800981:	83 c1 01             	add    $0x1,%ecx
  800984:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800987:	0f b6 01             	movzbl (%ecx),%eax
  80098a:	84 c0                	test   %al,%al
  80098c:	74 0e                	je     80099c <strncmp+0x41>
  80098e:	3a 03                	cmp    (%ebx),%al
  800990:	74 ea                	je     80097c <strncmp+0x21>
  800992:	eb 08                	jmp    80099c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800994:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800999:	5b                   	pop    %ebx
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80099c:	0f b6 01             	movzbl (%ecx),%eax
  80099f:	0f b6 13             	movzbl (%ebx),%edx
  8009a2:	29 d0                	sub    %edx,%eax
  8009a4:	eb f3                	jmp    800999 <strncmp+0x3e>

008009a6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b0:	0f b6 10             	movzbl (%eax),%edx
  8009b3:	84 d2                	test   %dl,%dl
  8009b5:	74 1c                	je     8009d3 <strchr+0x2d>
		if (*s == c)
  8009b7:	38 ca                	cmp    %cl,%dl
  8009b9:	75 09                	jne    8009c4 <strchr+0x1e>
  8009bb:	eb 1b                	jmp    8009d8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009bd:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  8009c0:	38 ca                	cmp    %cl,%dl
  8009c2:	74 14                	je     8009d8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009c4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  8009c8:	84 d2                	test   %dl,%dl
  8009ca:	75 f1                	jne    8009bd <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  8009cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d1:	eb 05                	jmp    8009d8 <strchr+0x32>
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e4:	0f b6 10             	movzbl (%eax),%edx
  8009e7:	84 d2                	test   %dl,%dl
  8009e9:	74 14                	je     8009ff <strfind+0x25>
		if (*s == c)
  8009eb:	38 ca                	cmp    %cl,%dl
  8009ed:	75 06                	jne    8009f5 <strfind+0x1b>
  8009ef:	eb 0e                	jmp    8009ff <strfind+0x25>
  8009f1:	38 ca                	cmp    %cl,%dl
  8009f3:	74 0a                	je     8009ff <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009f5:	83 c0 01             	add    $0x1,%eax
  8009f8:	0f b6 10             	movzbl (%eax),%edx
  8009fb:	84 d2                	test   %dl,%dl
  8009fd:	75 f2                	jne    8009f1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	83 ec 0c             	sub    $0xc,%esp
  800a07:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800a0a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a0d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a10:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a16:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a19:	85 c9                	test   %ecx,%ecx
  800a1b:	74 30                	je     800a4d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a1d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a23:	75 25                	jne    800a4a <memset+0x49>
  800a25:	f6 c1 03             	test   $0x3,%cl
  800a28:	75 20                	jne    800a4a <memset+0x49>
		c &= 0xFF;
  800a2a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a2d:	89 d3                	mov    %edx,%ebx
  800a2f:	c1 e3 08             	shl    $0x8,%ebx
  800a32:	89 d6                	mov    %edx,%esi
  800a34:	c1 e6 18             	shl    $0x18,%esi
  800a37:	89 d0                	mov    %edx,%eax
  800a39:	c1 e0 10             	shl    $0x10,%eax
  800a3c:	09 f0                	or     %esi,%eax
  800a3e:	09 d0                	or     %edx,%eax
  800a40:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a42:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a45:	fc                   	cld    
  800a46:	f3 ab                	rep stos %eax,%es:(%edi)
  800a48:	eb 03                	jmp    800a4d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a4a:	fc                   	cld    
  800a4b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a4d:	89 f8                	mov    %edi,%eax
  800a4f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a52:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a55:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a58:	89 ec                	mov    %ebp,%esp
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a65:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a71:	39 c6                	cmp    %eax,%esi
  800a73:	73 36                	jae    800aab <memmove+0x4f>
  800a75:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a78:	39 d0                	cmp    %edx,%eax
  800a7a:	73 2f                	jae    800aab <memmove+0x4f>
		s += n;
		d += n;
  800a7c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7f:	f6 c2 03             	test   $0x3,%dl
  800a82:	75 1b                	jne    800a9f <memmove+0x43>
  800a84:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a8a:	75 13                	jne    800a9f <memmove+0x43>
  800a8c:	f6 c1 03             	test   $0x3,%cl
  800a8f:	75 0e                	jne    800a9f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a91:	83 ef 04             	sub    $0x4,%edi
  800a94:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a97:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a9a:	fd                   	std    
  800a9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9d:	eb 09                	jmp    800aa8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a9f:	83 ef 01             	sub    $0x1,%edi
  800aa2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800aa5:	fd                   	std    
  800aa6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa8:	fc                   	cld    
  800aa9:	eb 20                	jmp    800acb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aab:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ab1:	75 13                	jne    800ac6 <memmove+0x6a>
  800ab3:	a8 03                	test   $0x3,%al
  800ab5:	75 0f                	jne    800ac6 <memmove+0x6a>
  800ab7:	f6 c1 03             	test   $0x3,%cl
  800aba:	75 0a                	jne    800ac6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800abc:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800abf:	89 c7                	mov    %eax,%edi
  800ac1:	fc                   	cld    
  800ac2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac4:	eb 05                	jmp    800acb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ac6:	89 c7                	mov    %eax,%edi
  800ac8:	fc                   	cld    
  800ac9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800acb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ace:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ad1:	89 ec                	mov    %ebp,%esp
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ade:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	89 04 24             	mov    %eax,(%esp)
  800aef:	e8 68 ff ff ff       	call   800a5c <memmove>
}
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	57                   	push   %edi
  800afa:	56                   	push   %esi
  800afb:	53                   	push   %ebx
  800afc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800aff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b02:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b05:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0a:	85 ff                	test   %edi,%edi
  800b0c:	74 37                	je     800b45 <memcmp+0x4f>
		if (*s1 != *s2)
  800b0e:	0f b6 03             	movzbl (%ebx),%eax
  800b11:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b14:	83 ef 01             	sub    $0x1,%edi
  800b17:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b1c:	38 c8                	cmp    %cl,%al
  800b1e:	74 1c                	je     800b3c <memcmp+0x46>
  800b20:	eb 10                	jmp    800b32 <memcmp+0x3c>
  800b22:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b27:	83 c2 01             	add    $0x1,%edx
  800b2a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b2e:	38 c8                	cmp    %cl,%al
  800b30:	74 0a                	je     800b3c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800b32:	0f b6 c0             	movzbl %al,%eax
  800b35:	0f b6 c9             	movzbl %cl,%ecx
  800b38:	29 c8                	sub    %ecx,%eax
  800b3a:	eb 09                	jmp    800b45 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3c:	39 fa                	cmp    %edi,%edx
  800b3e:	75 e2                	jne    800b22 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5f                   	pop    %edi
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b50:	89 c2                	mov    %eax,%edx
  800b52:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b55:	39 d0                	cmp    %edx,%eax
  800b57:	73 19                	jae    800b72 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b59:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b5d:	38 08                	cmp    %cl,(%eax)
  800b5f:	75 06                	jne    800b67 <memfind+0x1d>
  800b61:	eb 0f                	jmp    800b72 <memfind+0x28>
  800b63:	38 08                	cmp    %cl,(%eax)
  800b65:	74 0b                	je     800b72 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b67:	83 c0 01             	add    $0x1,%eax
  800b6a:	39 d0                	cmp    %edx,%eax
  800b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b70:	75 f1                	jne    800b63 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
  800b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b80:	0f b6 02             	movzbl (%edx),%eax
  800b83:	3c 20                	cmp    $0x20,%al
  800b85:	74 04                	je     800b8b <strtol+0x17>
  800b87:	3c 09                	cmp    $0x9,%al
  800b89:	75 0e                	jne    800b99 <strtol+0x25>
		s++;
  800b8b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8e:	0f b6 02             	movzbl (%edx),%eax
  800b91:	3c 20                	cmp    $0x20,%al
  800b93:	74 f6                	je     800b8b <strtol+0x17>
  800b95:	3c 09                	cmp    $0x9,%al
  800b97:	74 f2                	je     800b8b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b99:	3c 2b                	cmp    $0x2b,%al
  800b9b:	75 0a                	jne    800ba7 <strtol+0x33>
		s++;
  800b9d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ba0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba5:	eb 10                	jmp    800bb7 <strtol+0x43>
  800ba7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bac:	3c 2d                	cmp    $0x2d,%al
  800bae:	75 07                	jne    800bb7 <strtol+0x43>
		s++, neg = 1;
  800bb0:	83 c2 01             	add    $0x1,%edx
  800bb3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb7:	85 db                	test   %ebx,%ebx
  800bb9:	0f 94 c0             	sete   %al
  800bbc:	74 05                	je     800bc3 <strtol+0x4f>
  800bbe:	83 fb 10             	cmp    $0x10,%ebx
  800bc1:	75 15                	jne    800bd8 <strtol+0x64>
  800bc3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bc6:	75 10                	jne    800bd8 <strtol+0x64>
  800bc8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bcc:	75 0a                	jne    800bd8 <strtol+0x64>
		s += 2, base = 16;
  800bce:	83 c2 02             	add    $0x2,%edx
  800bd1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bd6:	eb 13                	jmp    800beb <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800bd8:	84 c0                	test   %al,%al
  800bda:	74 0f                	je     800beb <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bdc:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800be1:	80 3a 30             	cmpb   $0x30,(%edx)
  800be4:	75 05                	jne    800beb <strtol+0x77>
		s++, base = 8;
  800be6:	83 c2 01             	add    $0x1,%edx
  800be9:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800beb:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bf2:	0f b6 0a             	movzbl (%edx),%ecx
  800bf5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800bf8:	80 fb 09             	cmp    $0x9,%bl
  800bfb:	77 08                	ja     800c05 <strtol+0x91>
			dig = *s - '0';
  800bfd:	0f be c9             	movsbl %cl,%ecx
  800c00:	83 e9 30             	sub    $0x30,%ecx
  800c03:	eb 1e                	jmp    800c23 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800c05:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800c08:	80 fb 19             	cmp    $0x19,%bl
  800c0b:	77 08                	ja     800c15 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800c0d:	0f be c9             	movsbl %cl,%ecx
  800c10:	83 e9 57             	sub    $0x57,%ecx
  800c13:	eb 0e                	jmp    800c23 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c15:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c18:	80 fb 19             	cmp    $0x19,%bl
  800c1b:	77 14                	ja     800c31 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800c1d:	0f be c9             	movsbl %cl,%ecx
  800c20:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c23:	39 f1                	cmp    %esi,%ecx
  800c25:	7d 0e                	jge    800c35 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c27:	83 c2 01             	add    $0x1,%edx
  800c2a:	0f af c6             	imul   %esi,%eax
  800c2d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800c2f:	eb c1                	jmp    800bf2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800c31:	89 c1                	mov    %eax,%ecx
  800c33:	eb 02                	jmp    800c37 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c35:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800c37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3b:	74 05                	je     800c42 <strtol+0xce>
		*endptr = (char *) s;
  800c3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c40:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c42:	89 ca                	mov    %ecx,%edx
  800c44:	f7 da                	neg    %edx
  800c46:	85 ff                	test   %edi,%edi
  800c48:	0f 45 c2             	cmovne %edx,%eax
}
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5f                   	pop    %edi
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	83 ec 0c             	sub    $0xc,%esp
  800c56:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c59:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c5c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c67:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6a:	89 c3                	mov    %eax,%ebx
  800c6c:	89 c7                	mov    %eax,%edi
  800c6e:	89 c6                	mov    %eax,%esi
  800c70:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c72:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c75:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c78:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c7b:	89 ec                	mov    %ebp,%esp
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 0c             	sub    $0xc,%esp
  800c85:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c88:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c8b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c93:	b8 01 00 00 00       	mov    $0x1,%eax
  800c98:	89 d1                	mov    %edx,%ecx
  800c9a:	89 d3                	mov    %edx,%ebx
  800c9c:	89 d7                	mov    %edx,%edi
  800c9e:	89 d6                	mov    %edx,%esi
  800ca0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ca5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ca8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cab:	89 ec                	mov    %ebp,%esp
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    

00800caf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	83 ec 38             	sub    $0x38,%esp
  800cb5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cb8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cbb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccb:	89 cb                	mov    %ecx,%ebx
  800ccd:	89 cf                	mov    %ecx,%edi
  800ccf:	89 ce                	mov    %ecx,%esi
  800cd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	7e 28                	jle    800cff <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cdb:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ce2:	00 
  800ce3:	c7 44 24 08 5f 28 80 	movl   $0x80285f,0x8(%esp)
  800cea:	00 
  800ceb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf2:	00 
  800cf3:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  800cfa:	e8 b1 13 00 00       	call   8020b0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d02:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d05:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d08:	89 ec                	mov    %ebp,%esp
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    

00800d0c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d15:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d18:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d20:	b8 02 00 00 00       	mov    $0x2,%eax
  800d25:	89 d1                	mov    %edx,%ecx
  800d27:	89 d3                	mov    %edx,%ebx
  800d29:	89 d7                	mov    %edx,%edi
  800d2b:	89 d6                	mov    %edx,%esi
  800d2d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d38:	89 ec                	mov    %ebp,%esp
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <sys_yield>:

void
sys_yield(void)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 0c             	sub    $0xc,%esp
  800d42:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d45:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d48:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d50:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d55:	89 d1                	mov    %edx,%ecx
  800d57:	89 d3                	mov    %edx,%ebx
  800d59:	89 d7                	mov    %edx,%edi
  800d5b:	89 d6                	mov    %edx,%esi
  800d5d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d62:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d65:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d68:	89 ec                	mov    %ebp,%esp
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    

00800d6c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 38             	sub    $0x38,%esp
  800d72:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d75:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d78:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7b:	be 00 00 00 00       	mov    $0x0,%esi
  800d80:	b8 04 00 00 00       	mov    $0x4,%eax
  800d85:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	89 f7                	mov    %esi,%edi
  800d90:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d92:	85 c0                	test   %eax,%eax
  800d94:	7e 28                	jle    800dbe <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d96:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d9a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800da1:	00 
  800da2:	c7 44 24 08 5f 28 80 	movl   $0x80285f,0x8(%esp)
  800da9:	00 
  800daa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db1:	00 
  800db2:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  800db9:	e8 f2 12 00 00       	call   8020b0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dbe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dc1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dc4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dc7:	89 ec                	mov    %ebp,%esp
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 38             	sub    $0x38,%esp
  800dd1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dd4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dd7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dda:	b8 05 00 00 00       	mov    $0x5,%eax
  800ddf:	8b 75 18             	mov    0x18(%ebp),%esi
  800de2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800deb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dee:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800df0:	85 c0                	test   %eax,%eax
  800df2:	7e 28                	jle    800e1c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dff:	00 
  800e00:	c7 44 24 08 5f 28 80 	movl   $0x80285f,0x8(%esp)
  800e07:	00 
  800e08:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e0f:	00 
  800e10:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  800e17:	e8 94 12 00 00       	call   8020b0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e1c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e1f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e22:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e25:	89 ec                	mov    %ebp,%esp
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 38             	sub    $0x38,%esp
  800e2f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e32:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e35:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
  800e48:	89 df                	mov    %ebx,%edi
  800e4a:	89 de                	mov    %ebx,%esi
  800e4c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	7e 28                	jle    800e7a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e56:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e5d:	00 
  800e5e:	c7 44 24 08 5f 28 80 	movl   $0x80285f,0x8(%esp)
  800e65:	00 
  800e66:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e6d:	00 
  800e6e:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  800e75:	e8 36 12 00 00       	call   8020b0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e7a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e7d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e80:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e83:	89 ec                	mov    %ebp,%esp
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    

00800e87 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 38             	sub    $0x38,%esp
  800e8d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e90:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e93:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9b:	b8 08 00 00 00       	mov    $0x8,%eax
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea6:	89 df                	mov    %ebx,%edi
  800ea8:	89 de                	mov    %ebx,%esi
  800eaa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	7e 28                	jle    800ed8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eb4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ebb:	00 
  800ebc:	c7 44 24 08 5f 28 80 	movl   $0x80285f,0x8(%esp)
  800ec3:	00 
  800ec4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ecb:	00 
  800ecc:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  800ed3:	e8 d8 11 00 00       	call   8020b0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ed8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800edb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ede:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ee1:	89 ec                	mov    %ebp,%esp
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 38             	sub    $0x38,%esp
  800eeb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eee:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ef1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef9:	b8 09 00 00 00       	mov    $0x9,%eax
  800efe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f01:	8b 55 08             	mov    0x8(%ebp),%edx
  800f04:	89 df                	mov    %ebx,%edi
  800f06:	89 de                	mov    %ebx,%esi
  800f08:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	7e 28                	jle    800f36 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f12:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f19:	00 
  800f1a:	c7 44 24 08 5f 28 80 	movl   $0x80285f,0x8(%esp)
  800f21:	00 
  800f22:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f29:	00 
  800f2a:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  800f31:	e8 7a 11 00 00       	call   8020b0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f36:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f39:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f3c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f3f:	89 ec                	mov    %ebp,%esp
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 38             	sub    $0x38,%esp
  800f49:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f57:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	89 df                	mov    %ebx,%edi
  800f64:	89 de                	mov    %ebx,%esi
  800f66:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	7e 28                	jle    800f94 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f70:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f77:	00 
  800f78:	c7 44 24 08 5f 28 80 	movl   $0x80285f,0x8(%esp)
  800f7f:	00 
  800f80:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f87:	00 
  800f88:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  800f8f:	e8 1c 11 00 00       	call   8020b0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f94:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f97:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f9a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f9d:	89 ec                	mov    %ebp,%esp
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 0c             	sub    $0xc,%esp
  800fa7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800faa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fad:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb0:	be 00 00 00 00       	mov    $0x0,%esi
  800fb5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fba:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fc8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fcb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fce:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fd1:	89 ec                	mov    %ebp,%esp
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    

00800fd5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	83 ec 38             	sub    $0x38,%esp
  800fdb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fde:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fe1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff1:	89 cb                	mov    %ecx,%ebx
  800ff3:	89 cf                	mov    %ecx,%edi
  800ff5:	89 ce                	mov    %ecx,%esi
  800ff7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	7e 28                	jle    801025 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801001:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801008:	00 
  801009:	c7 44 24 08 5f 28 80 	movl   $0x80285f,0x8(%esp)
  801010:	00 
  801011:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801018:	00 
  801019:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  801020:	e8 8b 10 00 00       	call   8020b0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801025:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801028:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80102b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80102e:	89 ec                	mov    %ebp,%esp
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    
	...

00801034 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	8b 55 08             	mov    0x8(%ebp),%edx
  80103a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103d:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801040:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801042:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801045:	83 3a 01             	cmpl   $0x1,(%edx)
  801048:	7e 09                	jle    801053 <argstart+0x1f>
  80104a:	ba 31 25 80 00       	mov    $0x802531,%edx
  80104f:	85 c9                	test   %ecx,%ecx
  801051:	75 05                	jne    801058 <argstart+0x24>
  801053:	ba 00 00 00 00       	mov    $0x0,%edx
  801058:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  80105b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    

00801064 <argnext>:

int
argnext(struct Argstate *args)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	53                   	push   %ebx
  801068:	83 ec 14             	sub    $0x14,%esp
  80106b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  80106e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801075:	8b 43 08             	mov    0x8(%ebx),%eax
  801078:	85 c0                	test   %eax,%eax
  80107a:	74 71                	je     8010ed <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  80107c:	80 38 00             	cmpb   $0x0,(%eax)
  80107f:	75 50                	jne    8010d1 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801081:	8b 0b                	mov    (%ebx),%ecx
  801083:	83 39 01             	cmpl   $0x1,(%ecx)
  801086:	74 57                	je     8010df <argnext+0x7b>
		    || args->argv[1][0] != '-'
  801088:	8b 53 04             	mov    0x4(%ebx),%edx
  80108b:	8b 42 04             	mov    0x4(%edx),%eax
  80108e:	80 38 2d             	cmpb   $0x2d,(%eax)
  801091:	75 4c                	jne    8010df <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801093:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801097:	74 46                	je     8010df <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801099:	83 c0 01             	add    $0x1,%eax
  80109c:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80109f:	8b 01                	mov    (%ecx),%eax
  8010a1:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8010a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010ac:	8d 42 08             	lea    0x8(%edx),%eax
  8010af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010b3:	83 c2 04             	add    $0x4,%edx
  8010b6:	89 14 24             	mov    %edx,(%esp)
  8010b9:	e8 9e f9 ff ff       	call   800a5c <memmove>
		(*args->argc)--;
  8010be:	8b 03                	mov    (%ebx),%eax
  8010c0:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8010c3:	8b 43 08             	mov    0x8(%ebx),%eax
  8010c6:	80 38 2d             	cmpb   $0x2d,(%eax)
  8010c9:	75 06                	jne    8010d1 <argnext+0x6d>
  8010cb:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8010cf:	74 0e                	je     8010df <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8010d1:	8b 53 08             	mov    0x8(%ebx),%edx
  8010d4:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8010d7:	83 c2 01             	add    $0x1,%edx
  8010da:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  8010dd:	eb 13                	jmp    8010f2 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  8010df:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8010e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8010eb:	eb 05                	jmp    8010f2 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  8010ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8010f2:	83 c4 14             	add    $0x14,%esp
  8010f5:	5b                   	pop    %ebx
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	53                   	push   %ebx
  8010fc:	83 ec 14             	sub    $0x14,%esp
  8010ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801102:	8b 43 08             	mov    0x8(%ebx),%eax
  801105:	85 c0                	test   %eax,%eax
  801107:	74 5a                	je     801163 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  801109:	80 38 00             	cmpb   $0x0,(%eax)
  80110c:	74 0c                	je     80111a <argnextvalue+0x22>
		args->argvalue = args->curarg;
  80110e:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801111:	c7 43 08 31 25 80 00 	movl   $0x802531,0x8(%ebx)
  801118:	eb 44                	jmp    80115e <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  80111a:	8b 03                	mov    (%ebx),%eax
  80111c:	83 38 01             	cmpl   $0x1,(%eax)
  80111f:	7e 2f                	jle    801150 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  801121:	8b 53 04             	mov    0x4(%ebx),%edx
  801124:	8b 4a 04             	mov    0x4(%edx),%ecx
  801127:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80112a:	8b 00                	mov    (%eax),%eax
  80112c:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801133:	89 44 24 08          	mov    %eax,0x8(%esp)
  801137:	8d 42 08             	lea    0x8(%edx),%eax
  80113a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80113e:	83 c2 04             	add    $0x4,%edx
  801141:	89 14 24             	mov    %edx,(%esp)
  801144:	e8 13 f9 ff ff       	call   800a5c <memmove>
		(*args->argc)--;
  801149:	8b 03                	mov    (%ebx),%eax
  80114b:	83 28 01             	subl   $0x1,(%eax)
  80114e:	eb 0e                	jmp    80115e <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  801150:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801157:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  80115e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801161:	eb 05                	jmp    801168 <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801163:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  801168:	83 c4 14             	add    $0x14,%esp
  80116b:	5b                   	pop    %ebx
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 18             	sub    $0x18,%esp
  801174:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801177:	8b 42 0c             	mov    0xc(%edx),%eax
  80117a:	85 c0                	test   %eax,%eax
  80117c:	75 08                	jne    801186 <argvalue+0x18>
  80117e:	89 14 24             	mov    %edx,(%esp)
  801181:	e8 72 ff ff ff       	call   8010f8 <argnextvalue>
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    
	...

00801190 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	05 00 00 00 30       	add    $0x30000000,%eax
  80119b:	c1 e8 0c             	shr    $0xc,%eax
}
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	89 04 24             	mov    %eax,(%esp)
  8011ac:	e8 df ff ff ff       	call   801190 <fd2num>
  8011b1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8011b6:	c1 e0 0c             	shl    $0xc,%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	53                   	push   %ebx
  8011bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011c2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8011c7:	a8 01                	test   $0x1,%al
  8011c9:	74 34                	je     8011ff <fd_alloc+0x44>
  8011cb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8011d0:	a8 01                	test   $0x1,%al
  8011d2:	74 32                	je     801206 <fd_alloc+0x4b>
  8011d4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8011d9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	c1 ea 16             	shr    $0x16,%edx
  8011e0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011e7:	f6 c2 01             	test   $0x1,%dl
  8011ea:	74 1f                	je     80120b <fd_alloc+0x50>
  8011ec:	89 c2                	mov    %eax,%edx
  8011ee:	c1 ea 0c             	shr    $0xc,%edx
  8011f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f8:	f6 c2 01             	test   $0x1,%dl
  8011fb:	75 17                	jne    801214 <fd_alloc+0x59>
  8011fd:	eb 0c                	jmp    80120b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8011ff:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801204:	eb 05                	jmp    80120b <fd_alloc+0x50>
  801206:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80120b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80120d:	b8 00 00 00 00       	mov    $0x0,%eax
  801212:	eb 17                	jmp    80122b <fd_alloc+0x70>
  801214:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801219:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80121e:	75 b9                	jne    8011d9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801220:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801226:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80122b:	5b                   	pop    %ebx
  80122c:	5d                   	pop    %ebp
  80122d:	c3                   	ret    

0080122e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801234:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801239:	83 fa 1f             	cmp    $0x1f,%edx
  80123c:	77 3f                	ja     80127d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80123e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801244:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801247:	89 d0                	mov    %edx,%eax
  801249:	c1 e8 16             	shr    $0x16,%eax
  80124c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801253:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801258:	f6 c1 01             	test   $0x1,%cl
  80125b:	74 20                	je     80127d <fd_lookup+0x4f>
  80125d:	89 d0                	mov    %edx,%eax
  80125f:	c1 e8 0c             	shr    $0xc,%eax
  801262:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801269:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80126e:	f6 c1 01             	test   $0x1,%cl
  801271:	74 0a                	je     80127d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	89 10                	mov    %edx,(%eax)
	return 0;
  801278:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    

0080127f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	53                   	push   %ebx
  801283:	83 ec 14             	sub    $0x14,%esp
  801286:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801289:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801291:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801297:	75 17                	jne    8012b0 <dev_lookup+0x31>
  801299:	eb 07                	jmp    8012a2 <dev_lookup+0x23>
  80129b:	39 0a                	cmp    %ecx,(%edx)
  80129d:	75 11                	jne    8012b0 <dev_lookup+0x31>
  80129f:	90                   	nop
  8012a0:	eb 05                	jmp    8012a7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8012a2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8012a7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ae:	eb 35                	jmp    8012e5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8012b0:	83 c0 01             	add    $0x1,%eax
  8012b3:	8b 14 85 08 29 80 00 	mov    0x802908(,%eax,4),%edx
  8012ba:	85 d2                	test   %edx,%edx
  8012bc:	75 dd                	jne    80129b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012be:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c3:	8b 40 48             	mov    0x48(%eax),%eax
  8012c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ce:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  8012d5:	e8 75 ef ff ff       	call   80024f <cprintf>
	*dev = 0;
  8012da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8012e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012e5:	83 c4 14             	add    $0x14,%esp
  8012e8:	5b                   	pop    %ebx
  8012e9:	5d                   	pop    %ebp
  8012ea:	c3                   	ret    

008012eb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 38             	sub    $0x38,%esp
  8012f1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012f4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012f7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8012fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012fd:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801301:	89 3c 24             	mov    %edi,(%esp)
  801304:	e8 87 fe ff ff       	call   801190 <fd2num>
  801309:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80130c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801310:	89 04 24             	mov    %eax,(%esp)
  801313:	e8 16 ff ff ff       	call   80122e <fd_lookup>
  801318:	89 c3                	mov    %eax,%ebx
  80131a:	85 c0                	test   %eax,%eax
  80131c:	78 05                	js     801323 <fd_close+0x38>
	    || fd != fd2)
  80131e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801321:	74 0e                	je     801331 <fd_close+0x46>
		return (must_exist ? r : 0);
  801323:	89 f0                	mov    %esi,%eax
  801325:	84 c0                	test   %al,%al
  801327:	b8 00 00 00 00       	mov    $0x0,%eax
  80132c:	0f 44 d8             	cmove  %eax,%ebx
  80132f:	eb 3d                	jmp    80136e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801331:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801334:	89 44 24 04          	mov    %eax,0x4(%esp)
  801338:	8b 07                	mov    (%edi),%eax
  80133a:	89 04 24             	mov    %eax,(%esp)
  80133d:	e8 3d ff ff ff       	call   80127f <dev_lookup>
  801342:	89 c3                	mov    %eax,%ebx
  801344:	85 c0                	test   %eax,%eax
  801346:	78 16                	js     80135e <fd_close+0x73>
		if (dev->dev_close)
  801348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80134e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801353:	85 c0                	test   %eax,%eax
  801355:	74 07                	je     80135e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801357:	89 3c 24             	mov    %edi,(%esp)
  80135a:	ff d0                	call   *%eax
  80135c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80135e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801362:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801369:	e8 bb fa ff ff       	call   800e29 <sys_page_unmap>
	return r;
}
  80136e:	89 d8                	mov    %ebx,%eax
  801370:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801373:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801376:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801379:	89 ec                	mov    %ebp,%esp
  80137b:	5d                   	pop    %ebp
  80137c:	c3                   	ret    

0080137d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801383:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801386:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	89 04 24             	mov    %eax,(%esp)
  801390:	e8 99 fe ff ff       	call   80122e <fd_lookup>
  801395:	85 c0                	test   %eax,%eax
  801397:	78 13                	js     8013ac <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801399:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013a0:	00 
  8013a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a4:	89 04 24             	mov    %eax,(%esp)
  8013a7:	e8 3f ff ff ff       	call   8012eb <fd_close>
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <close_all>:

void
close_all(void)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	53                   	push   %ebx
  8013b2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013b5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013ba:	89 1c 24             	mov    %ebx,(%esp)
  8013bd:	e8 bb ff ff ff       	call   80137d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8013c2:	83 c3 01             	add    $0x1,%ebx
  8013c5:	83 fb 20             	cmp    $0x20,%ebx
  8013c8:	75 f0                	jne    8013ba <close_all+0xc>
		close(i);
}
  8013ca:	83 c4 14             	add    $0x14,%esp
  8013cd:	5b                   	pop    %ebx
  8013ce:	5d                   	pop    %ebp
  8013cf:	c3                   	ret    

008013d0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 58             	sub    $0x58,%esp
  8013d6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013d9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013dc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8013df:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	89 04 24             	mov    %eax,(%esp)
  8013ef:	e8 3a fe ff ff       	call   80122e <fd_lookup>
  8013f4:	89 c3                	mov    %eax,%ebx
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	0f 88 e1 00 00 00    	js     8014df <dup+0x10f>
		return r;
	close(newfdnum);
  8013fe:	89 3c 24             	mov    %edi,(%esp)
  801401:	e8 77 ff ff ff       	call   80137d <close>

	newfd = INDEX2FD(newfdnum);
  801406:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80140c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80140f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801412:	89 04 24             	mov    %eax,(%esp)
  801415:	e8 86 fd ff ff       	call   8011a0 <fd2data>
  80141a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80141c:	89 34 24             	mov    %esi,(%esp)
  80141f:	e8 7c fd ff ff       	call   8011a0 <fd2data>
  801424:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801427:	89 d8                	mov    %ebx,%eax
  801429:	c1 e8 16             	shr    $0x16,%eax
  80142c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801433:	a8 01                	test   $0x1,%al
  801435:	74 46                	je     80147d <dup+0xad>
  801437:	89 d8                	mov    %ebx,%eax
  801439:	c1 e8 0c             	shr    $0xc,%eax
  80143c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801443:	f6 c2 01             	test   $0x1,%dl
  801446:	74 35                	je     80147d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801448:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80144f:	25 07 0e 00 00       	and    $0xe07,%eax
  801454:	89 44 24 10          	mov    %eax,0x10(%esp)
  801458:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80145b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80145f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801466:	00 
  801467:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80146b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801472:	e8 54 f9 ff ff       	call   800dcb <sys_page_map>
  801477:	89 c3                	mov    %eax,%ebx
  801479:	85 c0                	test   %eax,%eax
  80147b:	78 3b                	js     8014b8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80147d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801480:	89 c2                	mov    %eax,%edx
  801482:	c1 ea 0c             	shr    $0xc,%edx
  801485:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80148c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801492:	89 54 24 10          	mov    %edx,0x10(%esp)
  801496:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80149a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014a1:	00 
  8014a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014ad:	e8 19 f9 ff ff       	call   800dcb <sys_page_map>
  8014b2:	89 c3                	mov    %eax,%ebx
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	79 25                	jns    8014dd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8014b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c3:	e8 61 f9 ff ff       	call   800e29 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014d6:	e8 4e f9 ff ff       	call   800e29 <sys_page_unmap>
	return r;
  8014db:	eb 02                	jmp    8014df <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8014dd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014df:	89 d8                	mov    %ebx,%eax
  8014e1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014e4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014e7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014ea:	89 ec                	mov    %ebp,%esp
  8014ec:	5d                   	pop    %ebp
  8014ed:	c3                   	ret    

008014ee <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
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
  801502:	e8 27 fd ff ff       	call   80122e <fd_lookup>
  801507:	85 c0                	test   %eax,%eax
  801509:	78 6d                	js     801578 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	89 04 24             	mov    %eax,(%esp)
  80151a:	e8 60 fd ff ff       	call   80127f <dev_lookup>
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 55                	js     801578 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	8b 50 08             	mov    0x8(%eax),%edx
  801529:	83 e2 03             	and    $0x3,%edx
  80152c:	83 fa 01             	cmp    $0x1,%edx
  80152f:	75 23                	jne    801554 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801531:	a1 04 40 80 00       	mov    0x804004,%eax
  801536:	8b 40 48             	mov    0x48(%eax),%eax
  801539:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80153d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801541:	c7 04 24 cd 28 80 00 	movl   $0x8028cd,(%esp)
  801548:	e8 02 ed ff ff       	call   80024f <cprintf>
		return -E_INVAL;
  80154d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801552:	eb 24                	jmp    801578 <read+0x8a>
	}
	if (!dev->dev_read)
  801554:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801557:	8b 52 08             	mov    0x8(%edx),%edx
  80155a:	85 d2                	test   %edx,%edx
  80155c:	74 15                	je     801573 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80155e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801561:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801565:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801568:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80156c:	89 04 24             	mov    %eax,(%esp)
  80156f:	ff d2                	call   *%edx
  801571:	eb 05                	jmp    801578 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801573:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801578:	83 c4 24             	add    $0x24,%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5d                   	pop    %ebp
  80157d:	c3                   	ret    

0080157e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	57                   	push   %edi
  801582:	56                   	push   %esi
  801583:	53                   	push   %ebx
  801584:	83 ec 1c             	sub    $0x1c,%esp
  801587:	8b 7d 08             	mov    0x8(%ebp),%edi
  80158a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80158d:	b8 00 00 00 00       	mov    $0x0,%eax
  801592:	85 f6                	test   %esi,%esi
  801594:	74 30                	je     8015c6 <readn+0x48>
  801596:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80159b:	89 f2                	mov    %esi,%edx
  80159d:	29 c2                	sub    %eax,%edx
  80159f:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015a3:	03 45 0c             	add    0xc(%ebp),%eax
  8015a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015aa:	89 3c 24             	mov    %edi,(%esp)
  8015ad:	e8 3c ff ff ff       	call   8014ee <read>
		if (m < 0)
  8015b2:	85 c0                	test   %eax,%eax
  8015b4:	78 10                	js     8015c6 <readn+0x48>
			return m;
		if (m == 0)
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	74 0a                	je     8015c4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015ba:	01 c3                	add    %eax,%ebx
  8015bc:	89 d8                	mov    %ebx,%eax
  8015be:	39 f3                	cmp    %esi,%ebx
  8015c0:	72 d9                	jb     80159b <readn+0x1d>
  8015c2:	eb 02                	jmp    8015c6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8015c4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8015c6:	83 c4 1c             	add    $0x1c,%esp
  8015c9:	5b                   	pop    %ebx
  8015ca:	5e                   	pop    %esi
  8015cb:	5f                   	pop    %edi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    

008015ce <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 24             	sub    $0x24,%esp
  8015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015df:	89 1c 24             	mov    %ebx,(%esp)
  8015e2:	e8 47 fc ff ff       	call   80122e <fd_lookup>
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 68                	js     801653 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f5:	8b 00                	mov    (%eax),%eax
  8015f7:	89 04 24             	mov    %eax,(%esp)
  8015fa:	e8 80 fc ff ff       	call   80127f <dev_lookup>
  8015ff:	85 c0                	test   %eax,%eax
  801601:	78 50                	js     801653 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801606:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80160a:	75 23                	jne    80162f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80160c:	a1 04 40 80 00       	mov    0x804004,%eax
  801611:	8b 40 48             	mov    0x48(%eax),%eax
  801614:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801618:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161c:	c7 04 24 e9 28 80 00 	movl   $0x8028e9,(%esp)
  801623:	e8 27 ec ff ff       	call   80024f <cprintf>
		return -E_INVAL;
  801628:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162d:	eb 24                	jmp    801653 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80162f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801632:	8b 52 0c             	mov    0xc(%edx),%edx
  801635:	85 d2                	test   %edx,%edx
  801637:	74 15                	je     80164e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801639:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801640:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801643:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801647:	89 04 24             	mov    %eax,(%esp)
  80164a:	ff d2                	call   *%edx
  80164c:	eb 05                	jmp    801653 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80164e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801653:	83 c4 24             	add    $0x24,%esp
  801656:	5b                   	pop    %ebx
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    

00801659 <seek>:

int
seek(int fdnum, off_t offset)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80165f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801662:	89 44 24 04          	mov    %eax,0x4(%esp)
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	89 04 24             	mov    %eax,(%esp)
  80166c:	e8 bd fb ff ff       	call   80122e <fd_lookup>
  801671:	85 c0                	test   %eax,%eax
  801673:	78 0e                	js     801683 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801675:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	53                   	push   %ebx
  801689:	83 ec 24             	sub    $0x24,%esp
  80168c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801692:	89 44 24 04          	mov    %eax,0x4(%esp)
  801696:	89 1c 24             	mov    %ebx,(%esp)
  801699:	e8 90 fb ff ff       	call   80122e <fd_lookup>
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	78 61                	js     801703 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ac:	8b 00                	mov    (%eax),%eax
  8016ae:	89 04 24             	mov    %eax,(%esp)
  8016b1:	e8 c9 fb ff ff       	call   80127f <dev_lookup>
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	78 49                	js     801703 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016c1:	75 23                	jne    8016e6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016c3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016c8:	8b 40 48             	mov    0x48(%eax),%eax
  8016cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d3:	c7 04 24 ac 28 80 00 	movl   $0x8028ac,(%esp)
  8016da:	e8 70 eb ff ff       	call   80024f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8016df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e4:	eb 1d                	jmp    801703 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8016e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e9:	8b 52 18             	mov    0x18(%edx),%edx
  8016ec:	85 d2                	test   %edx,%edx
  8016ee:	74 0e                	je     8016fe <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016f7:	89 04 24             	mov    %eax,(%esp)
  8016fa:	ff d2                	call   *%edx
  8016fc:	eb 05                	jmp    801703 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8016fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801703:	83 c4 24             	add    $0x24,%esp
  801706:	5b                   	pop    %ebx
  801707:	5d                   	pop    %ebp
  801708:	c3                   	ret    

00801709 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	53                   	push   %ebx
  80170d:	83 ec 24             	sub    $0x24,%esp
  801710:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801713:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801716:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	89 04 24             	mov    %eax,(%esp)
  801720:	e8 09 fb ff ff       	call   80122e <fd_lookup>
  801725:	85 c0                	test   %eax,%eax
  801727:	78 52                	js     80177b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801729:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	89 04 24             	mov    %eax,(%esp)
  801738:	e8 42 fb ff ff       	call   80127f <dev_lookup>
  80173d:	85 c0                	test   %eax,%eax
  80173f:	78 3a                	js     80177b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801744:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801748:	74 2c                	je     801776 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80174a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80174d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801754:	00 00 00 
	stat->st_isdir = 0;
  801757:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80175e:	00 00 00 
	stat->st_dev = dev;
  801761:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801767:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80176b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80176e:	89 14 24             	mov    %edx,(%esp)
  801771:	ff 50 14             	call   *0x14(%eax)
  801774:	eb 05                	jmp    80177b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801776:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80177b:	83 c4 24             	add    $0x24,%esp
  80177e:	5b                   	pop    %ebx
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    

00801781 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 18             	sub    $0x18,%esp
  801787:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80178a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80178d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801794:	00 
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	89 04 24             	mov    %eax,(%esp)
  80179b:	e8 bc 01 00 00       	call   80195c <open>
  8017a0:	89 c3                	mov    %eax,%ebx
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	78 1b                	js     8017c1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ad:	89 1c 24             	mov    %ebx,(%esp)
  8017b0:	e8 54 ff ff ff       	call   801709 <fstat>
  8017b5:	89 c6                	mov    %eax,%esi
	close(fd);
  8017b7:	89 1c 24             	mov    %ebx,(%esp)
  8017ba:	e8 be fb ff ff       	call   80137d <close>
	return r;
  8017bf:	89 f3                	mov    %esi,%ebx
}
  8017c1:	89 d8                	mov    %ebx,%eax
  8017c3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8017c6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8017c9:	89 ec                	mov    %ebp,%esp
  8017cb:	5d                   	pop    %ebp
  8017cc:	c3                   	ret    
  8017cd:	00 00                	add    %al,(%eax)
	...

008017d0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 18             	sub    $0x18,%esp
  8017d6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8017d9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8017dc:	89 c3                	mov    %eax,%ebx
  8017de:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8017e0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017e7:	75 11                	jne    8017fa <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8017f0:	e8 f1 09 00 00       	call   8021e6 <ipc_find_env>
  8017f5:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017fa:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801801:	00 
  801802:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801809:	00 
  80180a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80180e:	a1 00 40 80 00       	mov    0x804000,%eax
  801813:	89 04 24             	mov    %eax,(%esp)
  801816:	e8 47 09 00 00       	call   802162 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80181b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801822:	00 
  801823:	89 74 24 04          	mov    %esi,0x4(%esp)
  801827:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80182e:	e8 dd 08 00 00       	call   802110 <ipc_recv>
}
  801833:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801836:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801839:	89 ec                	mov    %ebp,%esp
  80183b:	5d                   	pop    %ebp
  80183c:	c3                   	ret    

0080183d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	53                   	push   %ebx
  801841:	83 ec 14             	sub    $0x14,%esp
  801844:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 40 0c             	mov    0xc(%eax),%eax
  80184d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801852:	ba 00 00 00 00       	mov    $0x0,%edx
  801857:	b8 05 00 00 00       	mov    $0x5,%eax
  80185c:	e8 6f ff ff ff       	call   8017d0 <fsipc>
  801861:	85 c0                	test   %eax,%eax
  801863:	78 2b                	js     801890 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801865:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80186c:	00 
  80186d:	89 1c 24             	mov    %ebx,(%esp)
  801870:	e8 f6 ef ff ff       	call   80086b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801875:	a1 80 50 80 00       	mov    0x805080,%eax
  80187a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801880:	a1 84 50 80 00       	mov    0x805084,%eax
  801885:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80188b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801890:	83 c4 14             	add    $0x14,%esp
  801893:	5b                   	pop    %ebx
  801894:	5d                   	pop    %ebp
  801895:	c3                   	ret    

00801896 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ac:	b8 06 00 00 00       	mov    $0x6,%eax
  8018b1:	e8 1a ff ff ff       	call   8017d0 <fsipc>
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	56                   	push   %esi
  8018bc:	53                   	push   %ebx
  8018bd:	83 ec 10             	sub    $0x10,%esp
  8018c0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018ce:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d9:	b8 03 00 00 00       	mov    $0x3,%eax
  8018de:	e8 ed fe ff ff       	call   8017d0 <fsipc>
  8018e3:	89 c3                	mov    %eax,%ebx
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	78 6a                	js     801953 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018e9:	39 c6                	cmp    %eax,%esi
  8018eb:	73 24                	jae    801911 <devfile_read+0x59>
  8018ed:	c7 44 24 0c 18 29 80 	movl   $0x802918,0xc(%esp)
  8018f4:	00 
  8018f5:	c7 44 24 08 1f 29 80 	movl   $0x80291f,0x8(%esp)
  8018fc:	00 
  8018fd:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801904:	00 
  801905:	c7 04 24 34 29 80 00 	movl   $0x802934,(%esp)
  80190c:	e8 9f 07 00 00       	call   8020b0 <_panic>
	assert(r <= PGSIZE);
  801911:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801916:	7e 24                	jle    80193c <devfile_read+0x84>
  801918:	c7 44 24 0c 3f 29 80 	movl   $0x80293f,0xc(%esp)
  80191f:	00 
  801920:	c7 44 24 08 1f 29 80 	movl   $0x80291f,0x8(%esp)
  801927:	00 
  801928:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80192f:	00 
  801930:	c7 04 24 34 29 80 00 	movl   $0x802934,(%esp)
  801937:	e8 74 07 00 00       	call   8020b0 <_panic>
	memmove(buf, &fsipcbuf, r);
  80193c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801940:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801947:	00 
  801948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194b:	89 04 24             	mov    %eax,(%esp)
  80194e:	e8 09 f1 ff ff       	call   800a5c <memmove>
	return r;
}
  801953:	89 d8                	mov    %ebx,%eax
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	5b                   	pop    %ebx
  801959:	5e                   	pop    %esi
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    

0080195c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	56                   	push   %esi
  801960:	53                   	push   %ebx
  801961:	83 ec 20             	sub    $0x20,%esp
  801964:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801967:	89 34 24             	mov    %esi,(%esp)
  80196a:	e8 b1 ee ff ff       	call   800820 <strlen>
		return -E_BAD_PATH;
  80196f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801974:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801979:	7f 5e                	jg     8019d9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80197b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197e:	89 04 24             	mov    %eax,(%esp)
  801981:	e8 35 f8 ff ff       	call   8011bb <fd_alloc>
  801986:	89 c3                	mov    %eax,%ebx
  801988:	85 c0                	test   %eax,%eax
  80198a:	78 4d                	js     8019d9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80198c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801990:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801997:	e8 cf ee ff ff       	call   80086b <strcpy>
	fsipcbuf.open.req_omode = mode;
  80199c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ac:	e8 1f fe ff ff       	call   8017d0 <fsipc>
  8019b1:	89 c3                	mov    %eax,%ebx
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	79 15                	jns    8019cc <open+0x70>
		fd_close(fd, 0);
  8019b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019be:	00 
  8019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c2:	89 04 24             	mov    %eax,(%esp)
  8019c5:	e8 21 f9 ff ff       	call   8012eb <fd_close>
		return r;
  8019ca:	eb 0d                	jmp    8019d9 <open+0x7d>
	}

	return fd2num(fd);
  8019cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cf:	89 04 24             	mov    %eax,(%esp)
  8019d2:	e8 b9 f7 ff ff       	call   801190 <fd2num>
  8019d7:	89 c3                	mov    %eax,%ebx
}
  8019d9:	89 d8                	mov    %ebx,%eax
  8019db:	83 c4 20             	add    $0x20,%esp
  8019de:	5b                   	pop    %ebx
  8019df:	5e                   	pop    %esi
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    
	...

008019e4 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	53                   	push   %ebx
  8019e8:	83 ec 14             	sub    $0x14,%esp
  8019eb:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8019ed:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019f1:	7e 31                	jle    801a24 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019f3:	8b 40 04             	mov    0x4(%eax),%eax
  8019f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019fa:	8d 43 10             	lea    0x10(%ebx),%eax
  8019fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a01:	8b 03                	mov    (%ebx),%eax
  801a03:	89 04 24             	mov    %eax,(%esp)
  801a06:	e8 c3 fb ff ff       	call   8015ce <write>
		if (result > 0)
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	7e 03                	jle    801a12 <writebuf+0x2e>
			b->result += result;
  801a0f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a12:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a15:	74 0d                	je     801a24 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801a17:	85 c0                	test   %eax,%eax
  801a19:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1e:	0f 4f c2             	cmovg  %edx,%eax
  801a21:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a24:	83 c4 14             	add    $0x14,%esp
  801a27:	5b                   	pop    %ebx
  801a28:	5d                   	pop    %ebp
  801a29:	c3                   	ret    

00801a2a <putch>:

static void
putch(int ch, void *thunk)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	53                   	push   %ebx
  801a2e:	83 ec 04             	sub    $0x4,%esp
  801a31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a34:	8b 43 04             	mov    0x4(%ebx),%eax
  801a37:	8b 55 08             	mov    0x8(%ebp),%edx
  801a3a:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801a3e:	83 c0 01             	add    $0x1,%eax
  801a41:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801a44:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a49:	75 0e                	jne    801a59 <putch+0x2f>
		writebuf(b);
  801a4b:	89 d8                	mov    %ebx,%eax
  801a4d:	e8 92 ff ff ff       	call   8019e4 <writebuf>
		b->idx = 0;
  801a52:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801a59:	83 c4 04             	add    $0x4,%esp
  801a5c:	5b                   	pop    %ebx
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a71:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a78:	00 00 00 
	b.result = 0;
  801a7b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a82:	00 00 00 
	b.error = 1;
  801a85:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a8c:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a99:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a9d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa7:	c7 04 24 2a 1a 80 00 	movl   $0x801a2a,(%esp)
  801aae:	e8 17 e9 ff ff       	call   8003ca <vprintfmt>
	if (b.idx > 0)
  801ab3:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801aba:	7e 0b                	jle    801ac7 <vfprintf+0x68>
		writebuf(&b);
  801abc:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ac2:	e8 1d ff ff ff       	call   8019e4 <writebuf>

	return (b.result ? b.result : b.error);
  801ac7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801acd:	85 c0                	test   %eax,%eax
  801acf:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ade:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801ae1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	89 04 24             	mov    %eax,(%esp)
  801af2:	e8 68 ff ff ff       	call   801a5f <vfprintf>
	va_end(ap);

	return cnt;
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <printf>:

int
printf(const char *fmt, ...)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801aff:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b02:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b14:	e8 46 ff ff ff       	call   801a5f <vfprintf>
	va_end(ap);

	return cnt;
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    
  801b1b:	00 00                	add    %al,(%eax)
  801b1d:	00 00                	add    %al,(%eax)
	...

00801b20 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 18             	sub    $0x18,%esp
  801b26:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b29:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801b2c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	89 04 24             	mov    %eax,(%esp)
  801b35:	e8 66 f6 ff ff       	call   8011a0 <fd2data>
  801b3a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801b3c:	c7 44 24 04 4b 29 80 	movl   $0x80294b,0x4(%esp)
  801b43:	00 
  801b44:	89 34 24             	mov    %esi,(%esp)
  801b47:	e8 1f ed ff ff       	call   80086b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b4c:	8b 43 04             	mov    0x4(%ebx),%eax
  801b4f:	2b 03                	sub    (%ebx),%eax
  801b51:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801b57:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801b5e:	00 00 00 
	stat->st_dev = &devpipe;
  801b61:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801b68:	30 80 00 
	return 0;
}
  801b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b70:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b73:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b76:	89 ec                	mov    %ebp,%esp
  801b78:	5d                   	pop    %ebp
  801b79:	c3                   	ret    

00801b7a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	53                   	push   %ebx
  801b7e:	83 ec 14             	sub    $0x14,%esp
  801b81:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b84:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b8f:	e8 95 f2 ff ff       	call   800e29 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b94:	89 1c 24             	mov    %ebx,(%esp)
  801b97:	e8 04 f6 ff ff       	call   8011a0 <fd2data>
  801b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ba7:	e8 7d f2 ff ff       	call   800e29 <sys_page_unmap>
}
  801bac:	83 c4 14             	add    $0x14,%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5d                   	pop    %ebp
  801bb1:	c3                   	ret    

00801bb2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	57                   	push   %edi
  801bb6:	56                   	push   %esi
  801bb7:	53                   	push   %ebx
  801bb8:	83 ec 2c             	sub    $0x2c,%esp
  801bbb:	89 c7                	mov    %eax,%edi
  801bbd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801bc0:	a1 04 40 80 00       	mov    0x804004,%eax
  801bc5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bc8:	89 3c 24             	mov    %edi,(%esp)
  801bcb:	e8 60 06 00 00       	call   802230 <pageref>
  801bd0:	89 c6                	mov    %eax,%esi
  801bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd5:	89 04 24             	mov    %eax,(%esp)
  801bd8:	e8 53 06 00 00       	call   802230 <pageref>
  801bdd:	39 c6                	cmp    %eax,%esi
  801bdf:	0f 94 c0             	sete   %al
  801be2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801be5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801beb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bee:	39 cb                	cmp    %ecx,%ebx
  801bf0:	75 08                	jne    801bfa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801bf2:	83 c4 2c             	add    $0x2c,%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5f                   	pop    %edi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801bfa:	83 f8 01             	cmp    $0x1,%eax
  801bfd:	75 c1                	jne    801bc0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bff:	8b 52 58             	mov    0x58(%edx),%edx
  801c02:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c06:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c0a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c0e:	c7 04 24 52 29 80 00 	movl   $0x802952,(%esp)
  801c15:	e8 35 e6 ff ff       	call   80024f <cprintf>
  801c1a:	eb a4                	jmp    801bc0 <_pipeisclosed+0xe>

00801c1c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	57                   	push   %edi
  801c20:	56                   	push   %esi
  801c21:	53                   	push   %ebx
  801c22:	83 ec 2c             	sub    $0x2c,%esp
  801c25:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801c28:	89 34 24             	mov    %esi,(%esp)
  801c2b:	e8 70 f5 ff ff       	call   8011a0 <fd2data>
  801c30:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c32:	bf 00 00 00 00       	mov    $0x0,%edi
  801c37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c3b:	75 50                	jne    801c8d <devpipe_write+0x71>
  801c3d:	eb 5c                	jmp    801c9b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801c3f:	89 da                	mov    %ebx,%edx
  801c41:	89 f0                	mov    %esi,%eax
  801c43:	e8 6a ff ff ff       	call   801bb2 <_pipeisclosed>
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	75 53                	jne    801c9f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801c4c:	e8 eb f0 ff ff       	call   800d3c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c51:	8b 43 04             	mov    0x4(%ebx),%eax
  801c54:	8b 13                	mov    (%ebx),%edx
  801c56:	83 c2 20             	add    $0x20,%edx
  801c59:	39 d0                	cmp    %edx,%eax
  801c5b:	73 e2                	jae    801c3f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c60:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801c64:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801c67:	89 c2                	mov    %eax,%edx
  801c69:	c1 fa 1f             	sar    $0x1f,%edx
  801c6c:	c1 ea 1b             	shr    $0x1b,%edx
  801c6f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801c72:	83 e1 1f             	and    $0x1f,%ecx
  801c75:	29 d1                	sub    %edx,%ecx
  801c77:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801c7b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801c7f:	83 c0 01             	add    $0x1,%eax
  801c82:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c85:	83 c7 01             	add    $0x1,%edi
  801c88:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c8b:	74 0e                	je     801c9b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c8d:	8b 43 04             	mov    0x4(%ebx),%eax
  801c90:	8b 13                	mov    (%ebx),%edx
  801c92:	83 c2 20             	add    $0x20,%edx
  801c95:	39 d0                	cmp    %edx,%eax
  801c97:	73 a6                	jae    801c3f <devpipe_write+0x23>
  801c99:	eb c2                	jmp    801c5d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801c9b:	89 f8                	mov    %edi,%eax
  801c9d:	eb 05                	jmp    801ca4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c9f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ca4:	83 c4 2c             	add    $0x2c,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5f                   	pop    %edi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    

00801cac <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 28             	sub    $0x28,%esp
  801cb2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801cb5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801cb8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801cbb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801cbe:	89 3c 24             	mov    %edi,(%esp)
  801cc1:	e8 da f4 ff ff       	call   8011a0 <fd2data>
  801cc6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cc8:	be 00 00 00 00       	mov    $0x0,%esi
  801ccd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cd1:	75 47                	jne    801d1a <devpipe_read+0x6e>
  801cd3:	eb 52                	jmp    801d27 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801cd5:	89 f0                	mov    %esi,%eax
  801cd7:	eb 5e                	jmp    801d37 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801cd9:	89 da                	mov    %ebx,%edx
  801cdb:	89 f8                	mov    %edi,%eax
  801cdd:	8d 76 00             	lea    0x0(%esi),%esi
  801ce0:	e8 cd fe ff ff       	call   801bb2 <_pipeisclosed>
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	75 49                	jne    801d32 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ce9:	e8 4e f0 ff ff       	call   800d3c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801cee:	8b 03                	mov    (%ebx),%eax
  801cf0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cf3:	74 e4                	je     801cd9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cf5:	89 c2                	mov    %eax,%edx
  801cf7:	c1 fa 1f             	sar    $0x1f,%edx
  801cfa:	c1 ea 1b             	shr    $0x1b,%edx
  801cfd:	01 d0                	add    %edx,%eax
  801cff:	83 e0 1f             	and    $0x1f,%eax
  801d02:	29 d0                	sub    %edx,%eax
  801d04:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801d0f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d12:	83 c6 01             	add    $0x1,%esi
  801d15:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d18:	74 0d                	je     801d27 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801d1a:	8b 03                	mov    (%ebx),%eax
  801d1c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d1f:	75 d4                	jne    801cf5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801d21:	85 f6                	test   %esi,%esi
  801d23:	75 b0                	jne    801cd5 <devpipe_read+0x29>
  801d25:	eb b2                	jmp    801cd9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801d27:	89 f0                	mov    %esi,%eax
  801d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d30:	eb 05                	jmp    801d37 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801d37:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d3a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801d3d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801d40:	89 ec                	mov    %ebp,%esp
  801d42:	5d                   	pop    %ebp
  801d43:	c3                   	ret    

00801d44 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 48             	sub    $0x48,%esp
  801d4a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801d4d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801d50:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801d53:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d56:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801d59:	89 04 24             	mov    %eax,(%esp)
  801d5c:	e8 5a f4 ff ff       	call   8011bb <fd_alloc>
  801d61:	89 c3                	mov    %eax,%ebx
  801d63:	85 c0                	test   %eax,%eax
  801d65:	0f 88 45 01 00 00    	js     801eb0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d6b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d72:	00 
  801d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d76:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d81:	e8 e6 ef ff ff       	call   800d6c <sys_page_alloc>
  801d86:	89 c3                	mov    %eax,%ebx
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	0f 88 20 01 00 00    	js     801eb0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801d90:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d93:	89 04 24             	mov    %eax,(%esp)
  801d96:	e8 20 f4 ff ff       	call   8011bb <fd_alloc>
  801d9b:	89 c3                	mov    %eax,%ebx
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	0f 88 f8 00 00 00    	js     801e9d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801da5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801dac:	00 
  801dad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dbb:	e8 ac ef ff ff       	call   800d6c <sys_page_alloc>
  801dc0:	89 c3                	mov    %eax,%ebx
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	0f 88 d3 00 00 00    	js     801e9d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dcd:	89 04 24             	mov    %eax,(%esp)
  801dd0:	e8 cb f3 ff ff       	call   8011a0 <fd2data>
  801dd5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801dde:	00 
  801ddf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dea:	e8 7d ef ff ff       	call   800d6c <sys_page_alloc>
  801def:	89 c3                	mov    %eax,%ebx
  801df1:	85 c0                	test   %eax,%eax
  801df3:	0f 88 91 00 00 00    	js     801e8a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dfc:	89 04 24             	mov    %eax,(%esp)
  801dff:	e8 9c f3 ff ff       	call   8011a0 <fd2data>
  801e04:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801e0b:	00 
  801e0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e10:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e17:	00 
  801e18:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e23:	e8 a3 ef ff ff       	call   800dcb <sys_page_map>
  801e28:	89 c3                	mov    %eax,%ebx
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	78 4c                	js     801e7a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801e2e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e37:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801e43:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e51:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e5b:	89 04 24             	mov    %eax,(%esp)
  801e5e:	e8 2d f3 ff ff       	call   801190 <fd2num>
  801e63:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801e65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e68:	89 04 24             	mov    %eax,(%esp)
  801e6b:	e8 20 f3 ff ff       	call   801190 <fd2num>
  801e70:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801e73:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e78:	eb 36                	jmp    801eb0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801e7a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e85:	e8 9f ef ff ff       	call   800e29 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801e8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e98:	e8 8c ef ff ff       	call   800e29 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801e9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ea0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eab:	e8 79 ef ff ff       	call   800e29 <sys_page_unmap>
    err:
	return r;
}
  801eb0:	89 d8                	mov    %ebx,%eax
  801eb2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801eb5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801eb8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ebb:	89 ec                	mov    %ebp,%esp
  801ebd:	5d                   	pop    %ebp
  801ebe:	c3                   	ret    

00801ebf <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ec5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	89 04 24             	mov    %eax,(%esp)
  801ed2:	e8 57 f3 ff ff       	call   80122e <fd_lookup>
  801ed7:	85 c0                	test   %eax,%eax
  801ed9:	78 15                	js     801ef0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ede:	89 04 24             	mov    %eax,(%esp)
  801ee1:	e8 ba f2 ff ff       	call   8011a0 <fd2data>
	return _pipeisclosed(fd, p);
  801ee6:	89 c2                	mov    %eax,%edx
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	e8 c2 fc ff ff       	call   801bb2 <_pipeisclosed>
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    
	...

00801f00 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    

00801f0a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801f10:	c7 44 24 04 6a 29 80 	movl   $0x80296a,0x4(%esp)
  801f17:	00 
  801f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1b:	89 04 24             	mov    %eax,(%esp)
  801f1e:	e8 48 e9 ff ff       	call   80086b <strcpy>
	return 0;
}
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	57                   	push   %edi
  801f2e:	56                   	push   %esi
  801f2f:	53                   	push   %ebx
  801f30:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f36:	be 00 00 00 00       	mov    $0x0,%esi
  801f3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f3f:	74 43                	je     801f84 <devcons_write+0x5a>
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801f46:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801f4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f4f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801f51:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801f54:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801f59:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801f5c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f60:	03 45 0c             	add    0xc(%ebp),%eax
  801f63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f67:	89 3c 24             	mov    %edi,(%esp)
  801f6a:	e8 ed ea ff ff       	call   800a5c <memmove>
		sys_cputs(buf, m);
  801f6f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f73:	89 3c 24             	mov    %edi,(%esp)
  801f76:	e8 d5 ec ff ff       	call   800c50 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f7b:	01 de                	add    %ebx,%esi
  801f7d:	89 f0                	mov    %esi,%eax
  801f7f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f82:	72 c8                	jb     801f4c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801f84:	89 f0                	mov    %esi,%eax
  801f86:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801f8c:	5b                   	pop    %ebx
  801f8d:	5e                   	pop    %esi
  801f8e:	5f                   	pop    %edi
  801f8f:	5d                   	pop    %ebp
  801f90:	c3                   	ret    

00801f91 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801f9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fa0:	75 07                	jne    801fa9 <devcons_read+0x18>
  801fa2:	eb 31                	jmp    801fd5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801fa4:	e8 93 ed ff ff       	call   800d3c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fb0:	e8 ca ec ff ff       	call   800c7f <sys_cgetc>
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	74 eb                	je     801fa4 <devcons_read+0x13>
  801fb9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	78 16                	js     801fd5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801fbf:	83 f8 04             	cmp    $0x4,%eax
  801fc2:	74 0c                	je     801fd0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc7:	88 10                	mov    %dl,(%eax)
	return 1;
  801fc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fce:	eb 05                	jmp    801fd5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801fe3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801fea:	00 
  801feb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fee:	89 04 24             	mov    %eax,(%esp)
  801ff1:	e8 5a ec ff ff       	call   800c50 <sys_cputs>
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <getchar>:

int
getchar(void)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
  801ffb:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801ffe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802005:	00 
  802006:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802009:	89 44 24 04          	mov    %eax,0x4(%esp)
  80200d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802014:	e8 d5 f4 ff ff       	call   8014ee <read>
	if (r < 0)
  802019:	85 c0                	test   %eax,%eax
  80201b:	78 0f                	js     80202c <getchar+0x34>
		return r;
	if (r < 1)
  80201d:	85 c0                	test   %eax,%eax
  80201f:	7e 06                	jle    802027 <getchar+0x2f>
		return -E_EOF;
	return c;
  802021:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802025:	eb 05                	jmp    80202c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802027:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802034:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802037:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 04 24             	mov    %eax,(%esp)
  802041:	e8 e8 f1 ff ff       	call   80122e <fd_lookup>
  802046:	85 c0                	test   %eax,%eax
  802048:	78 11                	js     80205b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802053:	39 10                	cmp    %edx,(%eax)
  802055:	0f 94 c0             	sete   %al
  802058:	0f b6 c0             	movzbl %al,%eax
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <opencons>:

int
opencons(void)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802063:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802066:	89 04 24             	mov    %eax,(%esp)
  802069:	e8 4d f1 ff ff       	call   8011bb <fd_alloc>
  80206e:	85 c0                	test   %eax,%eax
  802070:	78 3c                	js     8020ae <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802072:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802079:	00 
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802081:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802088:	e8 df ec ff ff       	call   800d6c <sys_page_alloc>
  80208d:	85 c0                	test   %eax,%eax
  80208f:	78 1d                	js     8020ae <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802091:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020a6:	89 04 24             	mov    %eax,(%esp)
  8020a9:	e8 e2 f0 ff ff       	call   801190 <fd2num>
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	56                   	push   %esi
  8020b4:	53                   	push   %ebx
  8020b5:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8020b8:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8020bb:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8020c1:	e8 46 ec ff ff       	call   800d0c <sys_getenvid>
  8020c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8020cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8020d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020dc:	c7 04 24 78 29 80 00 	movl   $0x802978,(%esp)
  8020e3:	e8 67 e1 ff ff       	call   80024f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8020e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ef:	89 04 24             	mov    %eax,(%esp)
  8020f2:	e8 f7 e0 ff ff       	call   8001ee <vcprintf>
	cprintf("\n");
  8020f7:	c7 04 24 30 25 80 00 	movl   $0x802530,(%esp)
  8020fe:	e8 4c e1 ff ff       	call   80024f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802103:	cc                   	int3   
  802104:	eb fd                	jmp    802103 <_panic+0x53>
	...

00802110 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	56                   	push   %esi
  802114:	53                   	push   %ebx
  802115:	83 ec 10             	sub    $0x10,%esp
  802118:	8b 75 08             	mov    0x8(%ebp),%esi
  80211b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802121:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802123:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802128:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80212b:	89 04 24             	mov    %eax,(%esp)
  80212e:	e8 a2 ee ff ff       	call   800fd5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802133:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802138:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80213d:	85 c0                	test   %eax,%eax
  80213f:	78 0e                	js     80214f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  802141:	a1 04 40 80 00       	mov    0x804004,%eax
  802146:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  802149:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80214c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80214f:	85 f6                	test   %esi,%esi
  802151:	74 02                	je     802155 <ipc_recv+0x45>
		*from_env_store = sender;
  802153:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  802155:	85 db                	test   %ebx,%ebx
  802157:	74 02                	je     80215b <ipc_recv+0x4b>
		*perm_store = perm;
  802159:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80215b:	83 c4 10             	add    $0x10,%esp
  80215e:	5b                   	pop    %ebx
  80215f:	5e                   	pop    %esi
  802160:	5d                   	pop    %ebp
  802161:	c3                   	ret    

00802162 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	57                   	push   %edi
  802166:	56                   	push   %esi
  802167:	53                   	push   %ebx
  802168:	83 ec 1c             	sub    $0x1c,%esp
  80216b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80216e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802171:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  802174:	85 db                	test   %ebx,%ebx
  802176:	75 04                	jne    80217c <ipc_send+0x1a>
  802178:	85 f6                	test   %esi,%esi
  80217a:	75 15                	jne    802191 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80217c:	85 db                	test   %ebx,%ebx
  80217e:	74 16                	je     802196 <ipc_send+0x34>
  802180:	85 f6                	test   %esi,%esi
  802182:	0f 94 c0             	sete   %al
      pg = 0;
  802185:	84 c0                	test   %al,%al
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	0f 45 d8             	cmovne %eax,%ebx
  80218f:	eb 05                	jmp    802196 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802191:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802196:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80219a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80219e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	89 04 24             	mov    %eax,(%esp)
  8021a8:	e8 f4 ed ff ff       	call   800fa1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  8021ad:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021b0:	75 07                	jne    8021b9 <ipc_send+0x57>
           sys_yield();
  8021b2:	e8 85 eb ff ff       	call   800d3c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  8021b7:	eb dd                	jmp    802196 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	90                   	nop
  8021bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021c0:	74 1c                	je     8021de <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  8021c2:	c7 44 24 08 9c 29 80 	movl   $0x80299c,0x8(%esp)
  8021c9:	00 
  8021ca:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8021d1:	00 
  8021d2:	c7 04 24 a6 29 80 00 	movl   $0x8029a6,(%esp)
  8021d9:	e8 d2 fe ff ff       	call   8020b0 <_panic>
		}
    }
}
  8021de:	83 c4 1c             	add    $0x1c,%esp
  8021e1:	5b                   	pop    %ebx
  8021e2:	5e                   	pop    %esi
  8021e3:	5f                   	pop    %edi
  8021e4:	5d                   	pop    %ebp
  8021e5:	c3                   	ret    

008021e6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8021ec:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8021f1:	39 c8                	cmp    %ecx,%eax
  8021f3:	74 17                	je     80220c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8021f5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8021fa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021fd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802203:	8b 52 50             	mov    0x50(%edx),%edx
  802206:	39 ca                	cmp    %ecx,%edx
  802208:	75 14                	jne    80221e <ipc_find_env+0x38>
  80220a:	eb 05                	jmp    802211 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80220c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802211:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802214:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802219:	8b 40 40             	mov    0x40(%eax),%eax
  80221c:	eb 0e                	jmp    80222c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80221e:	83 c0 01             	add    $0x1,%eax
  802221:	3d 00 04 00 00       	cmp    $0x400,%eax
  802226:	75 d2                	jne    8021fa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802228:	66 b8 00 00          	mov    $0x0,%ax
}
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    
	...

00802230 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802236:	89 d0                	mov    %edx,%eax
  802238:	c1 e8 16             	shr    $0x16,%eax
  80223b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802242:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802247:	f6 c1 01             	test   $0x1,%cl
  80224a:	74 1d                	je     802269 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80224c:	c1 ea 0c             	shr    $0xc,%edx
  80224f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802256:	f6 c2 01             	test   $0x1,%dl
  802259:	74 0e                	je     802269 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80225b:	c1 ea 0c             	shr    $0xc,%edx
  80225e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802265:	ef 
  802266:	0f b7 c0             	movzwl %ax,%eax
}
  802269:	5d                   	pop    %ebp
  80226a:	c3                   	ret    
  80226b:	00 00                	add    %al,(%eax)
  80226d:	00 00                	add    %al,(%eax)
	...

00802270 <__udivdi3>:
  802270:	83 ec 1c             	sub    $0x1c,%esp
  802273:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802277:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80227b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80227f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802283:	89 74 24 10          	mov    %esi,0x10(%esp)
  802287:	8b 74 24 24          	mov    0x24(%esp),%esi
  80228b:	85 ff                	test   %edi,%edi
  80228d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802291:	89 44 24 08          	mov    %eax,0x8(%esp)
  802295:	89 cd                	mov    %ecx,%ebp
  802297:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229b:	75 33                	jne    8022d0 <__udivdi3+0x60>
  80229d:	39 f1                	cmp    %esi,%ecx
  80229f:	77 57                	ja     8022f8 <__udivdi3+0x88>
  8022a1:	85 c9                	test   %ecx,%ecx
  8022a3:	75 0b                	jne    8022b0 <__udivdi3+0x40>
  8022a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8022aa:	31 d2                	xor    %edx,%edx
  8022ac:	f7 f1                	div    %ecx
  8022ae:	89 c1                	mov    %eax,%ecx
  8022b0:	89 f0                	mov    %esi,%eax
  8022b2:	31 d2                	xor    %edx,%edx
  8022b4:	f7 f1                	div    %ecx
  8022b6:	89 c6                	mov    %eax,%esi
  8022b8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022bc:	f7 f1                	div    %ecx
  8022be:	89 f2                	mov    %esi,%edx
  8022c0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8022c4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8022c8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8022cc:	83 c4 1c             	add    $0x1c,%esp
  8022cf:	c3                   	ret    
  8022d0:	31 d2                	xor    %edx,%edx
  8022d2:	31 c0                	xor    %eax,%eax
  8022d4:	39 f7                	cmp    %esi,%edi
  8022d6:	77 e8                	ja     8022c0 <__udivdi3+0x50>
  8022d8:	0f bd cf             	bsr    %edi,%ecx
  8022db:	83 f1 1f             	xor    $0x1f,%ecx
  8022de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022e2:	75 2c                	jne    802310 <__udivdi3+0xa0>
  8022e4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  8022e8:	76 04                	jbe    8022ee <__udivdi3+0x7e>
  8022ea:	39 f7                	cmp    %esi,%edi
  8022ec:	73 d2                	jae    8022c0 <__udivdi3+0x50>
  8022ee:	31 d2                	xor    %edx,%edx
  8022f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f5:	eb c9                	jmp    8022c0 <__udivdi3+0x50>
  8022f7:	90                   	nop
  8022f8:	89 f2                	mov    %esi,%edx
  8022fa:	f7 f1                	div    %ecx
  8022fc:	31 d2                	xor    %edx,%edx
  8022fe:	8b 74 24 10          	mov    0x10(%esp),%esi
  802302:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802306:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80230a:	83 c4 1c             	add    $0x1c,%esp
  80230d:	c3                   	ret    
  80230e:	66 90                	xchg   %ax,%ax
  802310:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802315:	b8 20 00 00 00       	mov    $0x20,%eax
  80231a:	89 ea                	mov    %ebp,%edx
  80231c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802320:	d3 e7                	shl    %cl,%edi
  802322:	89 c1                	mov    %eax,%ecx
  802324:	d3 ea                	shr    %cl,%edx
  802326:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80232b:	09 fa                	or     %edi,%edx
  80232d:	89 f7                	mov    %esi,%edi
  80232f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802333:	89 f2                	mov    %esi,%edx
  802335:	8b 74 24 08          	mov    0x8(%esp),%esi
  802339:	d3 e5                	shl    %cl,%ebp
  80233b:	89 c1                	mov    %eax,%ecx
  80233d:	d3 ef                	shr    %cl,%edi
  80233f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802344:	d3 e2                	shl    %cl,%edx
  802346:	89 c1                	mov    %eax,%ecx
  802348:	d3 ee                	shr    %cl,%esi
  80234a:	09 d6                	or     %edx,%esi
  80234c:	89 fa                	mov    %edi,%edx
  80234e:	89 f0                	mov    %esi,%eax
  802350:	f7 74 24 0c          	divl   0xc(%esp)
  802354:	89 d7                	mov    %edx,%edi
  802356:	89 c6                	mov    %eax,%esi
  802358:	f7 e5                	mul    %ebp
  80235a:	39 d7                	cmp    %edx,%edi
  80235c:	72 22                	jb     802380 <__udivdi3+0x110>
  80235e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802362:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802367:	d3 e5                	shl    %cl,%ebp
  802369:	39 c5                	cmp    %eax,%ebp
  80236b:	73 04                	jae    802371 <__udivdi3+0x101>
  80236d:	39 d7                	cmp    %edx,%edi
  80236f:	74 0f                	je     802380 <__udivdi3+0x110>
  802371:	89 f0                	mov    %esi,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	e9 46 ff ff ff       	jmp    8022c0 <__udivdi3+0x50>
  80237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802380:	8d 46 ff             	lea    -0x1(%esi),%eax
  802383:	31 d2                	xor    %edx,%edx
  802385:	8b 74 24 10          	mov    0x10(%esp),%esi
  802389:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80238d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802391:	83 c4 1c             	add    $0x1c,%esp
  802394:	c3                   	ret    
	...

008023a0 <__umoddi3>:
  8023a0:	83 ec 1c             	sub    $0x1c,%esp
  8023a3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8023a7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8023ab:	8b 44 24 20          	mov    0x20(%esp),%eax
  8023af:	89 74 24 10          	mov    %esi,0x10(%esp)
  8023b3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8023b7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8023bb:	85 ed                	test   %ebp,%ebp
  8023bd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8023c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023c5:	89 cf                	mov    %ecx,%edi
  8023c7:	89 04 24             	mov    %eax,(%esp)
  8023ca:	89 f2                	mov    %esi,%edx
  8023cc:	75 1a                	jne    8023e8 <__umoddi3+0x48>
  8023ce:	39 f1                	cmp    %esi,%ecx
  8023d0:	76 4e                	jbe    802420 <__umoddi3+0x80>
  8023d2:	f7 f1                	div    %ecx
  8023d4:	89 d0                	mov    %edx,%eax
  8023d6:	31 d2                	xor    %edx,%edx
  8023d8:	8b 74 24 10          	mov    0x10(%esp),%esi
  8023dc:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8023e0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8023e4:	83 c4 1c             	add    $0x1c,%esp
  8023e7:	c3                   	ret    
  8023e8:	39 f5                	cmp    %esi,%ebp
  8023ea:	77 54                	ja     802440 <__umoddi3+0xa0>
  8023ec:	0f bd c5             	bsr    %ebp,%eax
  8023ef:	83 f0 1f             	xor    $0x1f,%eax
  8023f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f6:	75 60                	jne    802458 <__umoddi3+0xb8>
  8023f8:	3b 0c 24             	cmp    (%esp),%ecx
  8023fb:	0f 87 07 01 00 00    	ja     802508 <__umoddi3+0x168>
  802401:	89 f2                	mov    %esi,%edx
  802403:	8b 34 24             	mov    (%esp),%esi
  802406:	29 ce                	sub    %ecx,%esi
  802408:	19 ea                	sbb    %ebp,%edx
  80240a:	89 34 24             	mov    %esi,(%esp)
  80240d:	8b 04 24             	mov    (%esp),%eax
  802410:	8b 74 24 10          	mov    0x10(%esp),%esi
  802414:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802418:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80241c:	83 c4 1c             	add    $0x1c,%esp
  80241f:	c3                   	ret    
  802420:	85 c9                	test   %ecx,%ecx
  802422:	75 0b                	jne    80242f <__umoddi3+0x8f>
  802424:	b8 01 00 00 00       	mov    $0x1,%eax
  802429:	31 d2                	xor    %edx,%edx
  80242b:	f7 f1                	div    %ecx
  80242d:	89 c1                	mov    %eax,%ecx
  80242f:	89 f0                	mov    %esi,%eax
  802431:	31 d2                	xor    %edx,%edx
  802433:	f7 f1                	div    %ecx
  802435:	8b 04 24             	mov    (%esp),%eax
  802438:	f7 f1                	div    %ecx
  80243a:	eb 98                	jmp    8023d4 <__umoddi3+0x34>
  80243c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802440:	89 f2                	mov    %esi,%edx
  802442:	8b 74 24 10          	mov    0x10(%esp),%esi
  802446:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80244a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	c3                   	ret    
  802452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802458:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80245d:	89 e8                	mov    %ebp,%eax
  80245f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802464:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802468:	89 fa                	mov    %edi,%edx
  80246a:	d3 e0                	shl    %cl,%eax
  80246c:	89 e9                	mov    %ebp,%ecx
  80246e:	d3 ea                	shr    %cl,%edx
  802470:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802475:	09 c2                	or     %eax,%edx
  802477:	8b 44 24 08          	mov    0x8(%esp),%eax
  80247b:	89 14 24             	mov    %edx,(%esp)
  80247e:	89 f2                	mov    %esi,%edx
  802480:	d3 e7                	shl    %cl,%edi
  802482:	89 e9                	mov    %ebp,%ecx
  802484:	d3 ea                	shr    %cl,%edx
  802486:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80248b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80248f:	d3 e6                	shl    %cl,%esi
  802491:	89 e9                	mov    %ebp,%ecx
  802493:	d3 e8                	shr    %cl,%eax
  802495:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80249a:	09 f0                	or     %esi,%eax
  80249c:	8b 74 24 08          	mov    0x8(%esp),%esi
  8024a0:	f7 34 24             	divl   (%esp)
  8024a3:	d3 e6                	shl    %cl,%esi
  8024a5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8024a9:	89 d6                	mov    %edx,%esi
  8024ab:	f7 e7                	mul    %edi
  8024ad:	39 d6                	cmp    %edx,%esi
  8024af:	89 c1                	mov    %eax,%ecx
  8024b1:	89 d7                	mov    %edx,%edi
  8024b3:	72 3f                	jb     8024f4 <__umoddi3+0x154>
  8024b5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8024b9:	72 35                	jb     8024f0 <__umoddi3+0x150>
  8024bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024bf:	29 c8                	sub    %ecx,%eax
  8024c1:	19 fe                	sbb    %edi,%esi
  8024c3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024c8:	89 f2                	mov    %esi,%edx
  8024ca:	d3 e8                	shr    %cl,%eax
  8024cc:	89 e9                	mov    %ebp,%ecx
  8024ce:	d3 e2                	shl    %cl,%edx
  8024d0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024d5:	09 d0                	or     %edx,%eax
  8024d7:	89 f2                	mov    %esi,%edx
  8024d9:	d3 ea                	shr    %cl,%edx
  8024db:	8b 74 24 10          	mov    0x10(%esp),%esi
  8024df:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8024e3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8024e7:	83 c4 1c             	add    $0x1c,%esp
  8024ea:	c3                   	ret    
  8024eb:	90                   	nop
  8024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024f0:	39 d6                	cmp    %edx,%esi
  8024f2:	75 c7                	jne    8024bb <__umoddi3+0x11b>
  8024f4:	89 d7                	mov    %edx,%edi
  8024f6:	89 c1                	mov    %eax,%ecx
  8024f8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8024fc:	1b 3c 24             	sbb    (%esp),%edi
  8024ff:	eb ba                	jmp    8024bb <__umoddi3+0x11b>
  802501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802508:	39 f5                	cmp    %esi,%ebp
  80250a:	0f 82 f1 fe ff ff    	jb     802401 <__umoddi3+0x61>
  802510:	e9 f8 fe ff ff       	jmp    80240d <__umoddi3+0x6d>
