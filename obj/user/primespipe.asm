
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 93 02 00 00       	call   8002c4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 3c             	sub    $0x3c,%esp
  80003d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800040:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800043:	8d 7d d8             	lea    -0x28(%ebp),%edi
{
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800046:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80004d:	00 
  80004e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800052:	89 1c 24             	mov    %ebx,(%esp)
  800055:	e8 54 19 00 00       	call   8019ae <readn>
  80005a:	83 f8 04             	cmp    $0x4,%eax
  80005d:	74 2e                	je     80008d <primeproc+0x59>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80005f:	85 c0                	test   %eax,%eax
  800061:	ba 00 00 00 00       	mov    $0x0,%edx
  800066:	0f 4e d0             	cmovle %eax,%edx
  800069:	89 54 24 10          	mov    %edx,0x10(%esp)
  80006d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800071:	c7 44 24 08 60 28 80 	movl   $0x802860,0x8(%esp)
  800078:	00 
  800079:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800080:	00 
  800081:	c7 04 24 8f 28 80 00 	movl   $0x80288f,(%esp)
  800088:	e8 a3 02 00 00       	call   800330 <_panic>

	cprintf("%d\n", p);
  80008d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800090:	89 44 24 04          	mov    %eax,0x4(%esp)
  800094:	c7 04 24 a1 28 80 00 	movl   $0x8028a1,(%esp)
  80009b:	e8 8b 03 00 00       	call   80042b <cprintf>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000a0:	89 3c 24             	mov    %edi,(%esp)
  8000a3:	e8 9c 1f 00 00       	call   802044 <pipe>
  8000a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000ab:	85 c0                	test   %eax,%eax
  8000ad:	79 20                	jns    8000cf <primeproc+0x9b>
		panic("pipe: %e", i);
  8000af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b3:	c7 44 24 08 a5 28 80 	movl   $0x8028a5,0x8(%esp)
  8000ba:	00 
  8000bb:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8000c2:	00 
  8000c3:	c7 04 24 8f 28 80 00 	movl   $0x80288f,(%esp)
  8000ca:	e8 61 02 00 00       	call   800330 <_panic>
	if ((id = fork()) < 0)
  8000cf:	e8 3f 12 00 00       	call   801313 <fork>
  8000d4:	85 c0                	test   %eax,%eax
  8000d6:	79 20                	jns    8000f8 <primeproc+0xc4>
		panic("fork: %e", id);
  8000d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000dc:	c7 44 24 08 d5 2d 80 	movl   $0x802dd5,0x8(%esp)
  8000e3:	00 
  8000e4:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8000eb:	00 
  8000ec:	c7 04 24 8f 28 80 00 	movl   $0x80288f,(%esp)
  8000f3:	e8 38 02 00 00       	call   800330 <_panic>
	if (id == 0) {
  8000f8:	85 c0                	test   %eax,%eax
  8000fa:	75 1b                	jne    800117 <primeproc+0xe3>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 a9 16 00 00       	call   8017ad <close>
		close(pfd[1]);
  800104:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800107:	89 04 24             	mov    %eax,(%esp)
  80010a:	e8 9e 16 00 00       	call   8017ad <close>
		fd = pfd[0];
  80010f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  800112:	e9 2f ff ff ff       	jmp    800046 <primeproc+0x12>
	}

	close(pfd[0]);
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	89 04 24             	mov    %eax,(%esp)
  80011d:	e8 8b 16 00 00       	call   8017ad <close>
	wfd = pfd[1];
  800122:	8b 7d dc             	mov    -0x24(%ebp),%edi

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  800125:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800128:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80012f:	00 
  800130:	89 74 24 04          	mov    %esi,0x4(%esp)
  800134:	89 1c 24             	mov    %ebx,(%esp)
  800137:	e8 72 18 00 00       	call   8019ae <readn>
  80013c:	83 f8 04             	cmp    $0x4,%eax
  80013f:	74 39                	je     80017a <primeproc+0x146>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800141:	85 c0                	test   %eax,%eax
  800143:	ba 00 00 00 00       	mov    $0x0,%edx
  800148:	0f 4e d0             	cmovle %eax,%edx
  80014b:	89 54 24 18          	mov    %edx,0x18(%esp)
  80014f:	89 44 24 14          	mov    %eax,0x14(%esp)
  800153:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800157:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015e:	c7 44 24 08 ae 28 80 	movl   $0x8028ae,0x8(%esp)
  800165:	00 
  800166:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  80016d:	00 
  80016e:	c7 04 24 8f 28 80 00 	movl   $0x80288f,(%esp)
  800175:	e8 b6 01 00 00       	call   800330 <_panic>
		if (i%p)
  80017a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017d:	89 c2                	mov    %eax,%edx
  80017f:	c1 fa 1f             	sar    $0x1f,%edx
  800182:	f7 7d e0             	idivl  -0x20(%ebp)
  800185:	85 d2                	test   %edx,%edx
  800187:	74 9f                	je     800128 <primeproc+0xf4>
			if ((r=write(wfd, &i, 4)) != 4)
  800189:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800190:	00 
  800191:	89 74 24 04          	mov    %esi,0x4(%esp)
  800195:	89 3c 24             	mov    %edi,(%esp)
  800198:	e8 61 18 00 00       	call   8019fe <write>
  80019d:	83 f8 04             	cmp    $0x4,%eax
  8001a0:	74 86                	je     800128 <primeproc+0xf4>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a9:	0f 4e d0             	cmovle %eax,%edx
  8001ac:	89 54 24 14          	mov    %edx,0x14(%esp)
  8001b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001bb:	c7 44 24 08 ca 28 80 	movl   $0x8028ca,0x8(%esp)
  8001c2:	00 
  8001c3:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8001ca:	00 
  8001cb:	c7 04 24 8f 28 80 00 	movl   $0x80288f,(%esp)
  8001d2:	e8 59 01 00 00       	call   800330 <_panic>

008001d7 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	53                   	push   %ebx
  8001db:	83 ec 34             	sub    $0x34,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  8001de:	c7 05 00 30 80 00 e4 	movl   $0x8028e4,0x803000
  8001e5:	28 80 00 

	if ((i=pipe(p)) < 0)
  8001e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001eb:	89 04 24             	mov    %eax,(%esp)
  8001ee:	e8 51 1e 00 00       	call   802044 <pipe>
  8001f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001f6:	85 c0                	test   %eax,%eax
  8001f8:	79 20                	jns    80021a <umain+0x43>
		panic("pipe: %e", i);
  8001fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001fe:	c7 44 24 08 a5 28 80 	movl   $0x8028a5,0x8(%esp)
  800205:	00 
  800206:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  80020d:	00 
  80020e:	c7 04 24 8f 28 80 00 	movl   $0x80288f,(%esp)
  800215:	e8 16 01 00 00       	call   800330 <_panic>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80021a:	e8 f4 10 00 00       	call   801313 <fork>
  80021f:	85 c0                	test   %eax,%eax
  800221:	79 20                	jns    800243 <umain+0x6c>
		panic("fork: %e", id);
  800223:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800227:	c7 44 24 08 d5 2d 80 	movl   $0x802dd5,0x8(%esp)
  80022e:	00 
  80022f:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  800236:	00 
  800237:	c7 04 24 8f 28 80 00 	movl   $0x80288f,(%esp)
  80023e:	e8 ed 00 00 00       	call   800330 <_panic>

	if (id == 0) {
  800243:	85 c0                	test   %eax,%eax
  800245:	75 16                	jne    80025d <umain+0x86>
		close(p[1]);
  800247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80024a:	89 04 24             	mov    %eax,(%esp)
  80024d:	e8 5b 15 00 00       	call   8017ad <close>
		primeproc(p[0]);
  800252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800255:	89 04 24             	mov    %eax,(%esp)
  800258:	e8 d7 fd ff ff       	call   800034 <primeproc>
	}

	close(p[0]);
  80025d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800260:	89 04 24             	mov    %eax,(%esp)
  800263:	e8 45 15 00 00       	call   8017ad <close>

	// feed all the integers through
	for (i=2;; i++)
  800268:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80026f:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  800272:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800279:	00 
  80027a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800281:	89 04 24             	mov    %eax,(%esp)
  800284:	e8 75 17 00 00       	call   8019fe <write>
  800289:	83 f8 04             	cmp    $0x4,%eax
  80028c:	74 2e                	je     8002bc <umain+0xe5>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  80028e:	85 c0                	test   %eax,%eax
  800290:	ba 00 00 00 00       	mov    $0x0,%edx
  800295:	0f 4e d0             	cmovle %eax,%edx
  800298:	89 54 24 10          	mov    %edx,0x10(%esp)
  80029c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a0:	c7 44 24 08 ef 28 80 	movl   $0x8028ef,0x8(%esp)
  8002a7:	00 
  8002a8:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8002af:	00 
  8002b0:	c7 04 24 8f 28 80 00 	movl   $0x80288f,(%esp)
  8002b7:	e8 74 00 00 00       	call   800330 <_panic>
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  8002bc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  8002c0:	eb b0                	jmp    800272 <umain+0x9b>
	...

008002c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 18             	sub    $0x18,%esp
  8002ca:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8002cd:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8002d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8002d6:	e8 11 0c 00 00       	call   800eec <sys_getenvid>
  8002db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002e0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e8:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ed:	85 f6                	test   %esi,%esi
  8002ef:	7e 07                	jle    8002f8 <libmain+0x34>
		binaryname = argv[0];
  8002f1:	8b 03                	mov    (%ebx),%eax
  8002f3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002fc:	89 34 24             	mov    %esi,(%esp)
  8002ff:	e8 d3 fe ff ff       	call   8001d7 <umain>

	// exit gracefully
	exit();
  800304:	e8 0b 00 00 00       	call   800314 <exit>
}
  800309:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80030c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80030f:	89 ec                	mov    %ebp,%esp
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    
	...

00800314 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80031a:	e8 bf 14 00 00       	call   8017de <close_all>
	sys_env_destroy(0);
  80031f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800326:	e8 64 0b 00 00       	call   800e8f <sys_env_destroy>
}
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    
  80032d:	00 00                	add    %al,(%eax)
	...

00800330 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	56                   	push   %esi
  800334:	53                   	push   %ebx
  800335:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800338:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80033b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800341:	e8 a6 0b 00 00       	call   800eec <sys_getenvid>
  800346:	8b 55 0c             	mov    0xc(%ebp),%edx
  800349:	89 54 24 10          	mov    %edx,0x10(%esp)
  80034d:	8b 55 08             	mov    0x8(%ebp),%edx
  800350:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800354:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800358:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035c:	c7 04 24 14 29 80 00 	movl   $0x802914,(%esp)
  800363:	e8 c3 00 00 00       	call   80042b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800368:	89 74 24 04          	mov    %esi,0x4(%esp)
  80036c:	8b 45 10             	mov    0x10(%ebp),%eax
  80036f:	89 04 24             	mov    %eax,(%esp)
  800372:	e8 53 00 00 00       	call   8003ca <vcprintf>
	cprintf("\n");
  800377:	c7 04 24 a3 28 80 00 	movl   $0x8028a3,(%esp)
  80037e:	e8 a8 00 00 00       	call   80042b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800383:	cc                   	int3   
  800384:	eb fd                	jmp    800383 <_panic+0x53>
	...

00800388 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	53                   	push   %ebx
  80038c:	83 ec 14             	sub    $0x14,%esp
  80038f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800392:	8b 03                	mov    (%ebx),%eax
  800394:	8b 55 08             	mov    0x8(%ebp),%edx
  800397:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80039b:	83 c0 01             	add    $0x1,%eax
  80039e:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8003a0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a5:	75 19                	jne    8003c0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003a7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003ae:	00 
  8003af:	8d 43 08             	lea    0x8(%ebx),%eax
  8003b2:	89 04 24             	mov    %eax,(%esp)
  8003b5:	e8 76 0a 00 00       	call   800e30 <sys_cputs>
		b->idx = 0;
  8003ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003c0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003c4:	83 c4 14             	add    $0x14,%esp
  8003c7:	5b                   	pop    %ebx
  8003c8:	5d                   	pop    %ebp
  8003c9:	c3                   	ret    

008003ca <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003da:	00 00 00 
	b.cnt = 0;
  8003dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003e4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ff:	c7 04 24 88 03 80 00 	movl   $0x800388,(%esp)
  800406:	e8 9f 01 00 00       	call   8005aa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80040b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800411:	89 44 24 04          	mov    %eax,0x4(%esp)
  800415:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80041b:	89 04 24             	mov    %eax,(%esp)
  80041e:	e8 0d 0a 00 00       	call   800e30 <sys_cputs>

	return b.cnt;
}
  800423:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800429:	c9                   	leave  
  80042a:	c3                   	ret    

0080042b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800431:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800434:	89 44 24 04          	mov    %eax,0x4(%esp)
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	89 04 24             	mov    %eax,(%esp)
  80043e:	e8 87 ff ff ff       	call   8003ca <vcprintf>
	va_end(ap);

	return cnt;
}
  800443:	c9                   	leave  
  800444:	c3                   	ret    
	...

00800450 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	57                   	push   %edi
  800454:	56                   	push   %esi
  800455:	53                   	push   %ebx
  800456:	83 ec 3c             	sub    $0x3c,%esp
  800459:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045c:	89 d7                	mov    %edx,%edi
  80045e:	8b 45 08             	mov    0x8(%ebp),%eax
  800461:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80046d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800470:	b8 00 00 00 00       	mov    $0x0,%eax
  800475:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800478:	72 11                	jb     80048b <printnum+0x3b>
  80047a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80047d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800480:	76 09                	jbe    80048b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800482:	83 eb 01             	sub    $0x1,%ebx
  800485:	85 db                	test   %ebx,%ebx
  800487:	7f 51                	jg     8004da <printnum+0x8a>
  800489:	eb 5e                	jmp    8004e9 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80048b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80048f:	83 eb 01             	sub    $0x1,%ebx
  800492:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800496:	8b 45 10             	mov    0x10(%ebp),%eax
  800499:	89 44 24 08          	mov    %eax,0x8(%esp)
  80049d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8004a1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8004a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004ac:	00 
  8004ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b0:	89 04 24             	mov    %eax,(%esp)
  8004b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ba:	e8 f1 20 00 00       	call   8025b0 <__udivdi3>
  8004bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8004c3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004c7:	89 04 24             	mov    %eax,(%esp)
  8004ca:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004ce:	89 fa                	mov    %edi,%edx
  8004d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d3:	e8 78 ff ff ff       	call   800450 <printnum>
  8004d8:	eb 0f                	jmp    8004e9 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004de:	89 34 24             	mov    %esi,(%esp)
  8004e1:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e4:	83 eb 01             	sub    $0x1,%ebx
  8004e7:	75 f1                	jne    8004da <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ed:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8004f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004ff:	00 
  800500:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800503:	89 04 24             	mov    %eax,(%esp)
  800506:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800509:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050d:	e8 ce 21 00 00       	call   8026e0 <__umoddi3>
  800512:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800516:	0f be 80 37 29 80 00 	movsbl 0x802937(%eax),%eax
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800523:	83 c4 3c             	add    $0x3c,%esp
  800526:	5b                   	pop    %ebx
  800527:	5e                   	pop    %esi
  800528:	5f                   	pop    %edi
  800529:	5d                   	pop    %ebp
  80052a:	c3                   	ret    

0080052b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80052e:	83 fa 01             	cmp    $0x1,%edx
  800531:	7e 0e                	jle    800541 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800533:	8b 10                	mov    (%eax),%edx
  800535:	8d 4a 08             	lea    0x8(%edx),%ecx
  800538:	89 08                	mov    %ecx,(%eax)
  80053a:	8b 02                	mov    (%edx),%eax
  80053c:	8b 52 04             	mov    0x4(%edx),%edx
  80053f:	eb 22                	jmp    800563 <getuint+0x38>
	else if (lflag)
  800541:	85 d2                	test   %edx,%edx
  800543:	74 10                	je     800555 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800545:	8b 10                	mov    (%eax),%edx
  800547:	8d 4a 04             	lea    0x4(%edx),%ecx
  80054a:	89 08                	mov    %ecx,(%eax)
  80054c:	8b 02                	mov    (%edx),%eax
  80054e:	ba 00 00 00 00       	mov    $0x0,%edx
  800553:	eb 0e                	jmp    800563 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800555:	8b 10                	mov    (%eax),%edx
  800557:	8d 4a 04             	lea    0x4(%edx),%ecx
  80055a:	89 08                	mov    %ecx,(%eax)
  80055c:	8b 02                	mov    (%edx),%eax
  80055e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800563:	5d                   	pop    %ebp
  800564:	c3                   	ret    

00800565 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80056b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80056f:	8b 10                	mov    (%eax),%edx
  800571:	3b 50 04             	cmp    0x4(%eax),%edx
  800574:	73 0a                	jae    800580 <sprintputch+0x1b>
		*b->buf++ = ch;
  800576:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800579:	88 0a                	mov    %cl,(%edx)
  80057b:	83 c2 01             	add    $0x1,%edx
  80057e:	89 10                	mov    %edx,(%eax)
}
  800580:	5d                   	pop    %ebp
  800581:	c3                   	ret    

00800582 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800588:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80058b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	89 44 24 08          	mov    %eax,0x8(%esp)
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	89 44 24 04          	mov    %eax,0x4(%esp)
  80059d:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a0:	89 04 24             	mov    %eax,(%esp)
  8005a3:	e8 02 00 00 00       	call   8005aa <vprintfmt>
	va_end(ap);
}
  8005a8:	c9                   	leave  
  8005a9:	c3                   	ret    

008005aa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005aa:	55                   	push   %ebp
  8005ab:	89 e5                	mov    %esp,%ebp
  8005ad:	57                   	push   %edi
  8005ae:	56                   	push   %esi
  8005af:	53                   	push   %ebx
  8005b0:	83 ec 4c             	sub    $0x4c,%esp
  8005b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005b6:	8b 75 10             	mov    0x10(%ebp),%esi
  8005b9:	eb 12                	jmp    8005cd <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005bb:	85 c0                	test   %eax,%eax
  8005bd:	0f 84 a9 03 00 00    	je     80096c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  8005c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005c7:	89 04 24             	mov    %eax,(%esp)
  8005ca:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005cd:	0f b6 06             	movzbl (%esi),%eax
  8005d0:	83 c6 01             	add    $0x1,%esi
  8005d3:	83 f8 25             	cmp    $0x25,%eax
  8005d6:	75 e3                	jne    8005bb <vprintfmt+0x11>
  8005d8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8005dc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005e3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  8005e8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8005ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005f7:	eb 2b                	jmp    800624 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f9:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8005fc:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800600:	eb 22                	jmp    800624 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800602:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800605:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800609:	eb 19                	jmp    800624 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80060e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800615:	eb 0d                	jmp    800624 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800617:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80061a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800624:	0f b6 06             	movzbl (%esi),%eax
  800627:	0f b6 d0             	movzbl %al,%edx
  80062a:	8d 7e 01             	lea    0x1(%esi),%edi
  80062d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800630:	83 e8 23             	sub    $0x23,%eax
  800633:	3c 55                	cmp    $0x55,%al
  800635:	0f 87 0b 03 00 00    	ja     800946 <vprintfmt+0x39c>
  80063b:	0f b6 c0             	movzbl %al,%eax
  80063e:	ff 24 85 80 2a 80 00 	jmp    *0x802a80(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800645:	83 ea 30             	sub    $0x30,%edx
  800648:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80064b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80064f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800652:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800655:	83 fa 09             	cmp    $0x9,%edx
  800658:	77 4a                	ja     8006a4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80065d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800660:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800663:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800667:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80066a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80066d:	83 fa 09             	cmp    $0x9,%edx
  800670:	76 eb                	jbe    80065d <vprintfmt+0xb3>
  800672:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800675:	eb 2d                	jmp    8006a4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8d 50 04             	lea    0x4(%eax),%edx
  80067d:	89 55 14             	mov    %edx,0x14(%ebp)
  800680:	8b 00                	mov    (%eax),%eax
  800682:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800685:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800688:	eb 1a                	jmp    8006a4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80068d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800691:	79 91                	jns    800624 <vprintfmt+0x7a>
  800693:	e9 73 ff ff ff       	jmp    80060b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800698:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80069b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006a2:	eb 80                	jmp    800624 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8006a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a8:	0f 89 76 ff ff ff    	jns    800624 <vprintfmt+0x7a>
  8006ae:	e9 64 ff ff ff       	jmp    800617 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006b3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006b9:	e9 66 ff ff ff       	jmp    800624 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8d 50 04             	lea    0x4(%eax),%edx
  8006c4:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	89 04 24             	mov    %eax,(%esp)
  8006d0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8006d6:	e9 f2 fe ff ff       	jmp    8005cd <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8d 50 04             	lea    0x4(%eax),%edx
  8006e1:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	89 c2                	mov    %eax,%edx
  8006e8:	c1 fa 1f             	sar    $0x1f,%edx
  8006eb:	31 d0                	xor    %edx,%eax
  8006ed:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006ef:	83 f8 0f             	cmp    $0xf,%eax
  8006f2:	7f 0b                	jg     8006ff <vprintfmt+0x155>
  8006f4:	8b 14 85 e0 2b 80 00 	mov    0x802be0(,%eax,4),%edx
  8006fb:	85 d2                	test   %edx,%edx
  8006fd:	75 23                	jne    800722 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  8006ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800703:	c7 44 24 08 4f 29 80 	movl   $0x80294f,0x8(%esp)
  80070a:	00 
  80070b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80070f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800712:	89 3c 24             	mov    %edi,(%esp)
  800715:	e8 68 fe ff ff       	call   800582 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80071d:	e9 ab fe ff ff       	jmp    8005cd <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800722:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800726:	c7 44 24 08 b5 2e 80 	movl   $0x802eb5,0x8(%esp)
  80072d:	00 
  80072e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800732:	8b 7d 08             	mov    0x8(%ebp),%edi
  800735:	89 3c 24             	mov    %edi,(%esp)
  800738:	e8 45 fe ff ff       	call   800582 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800740:	e9 88 fe ff ff       	jmp    8005cd <vprintfmt+0x23>
  800745:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80074b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8d 50 04             	lea    0x4(%eax),%edx
  800754:	89 55 14             	mov    %edx,0x14(%ebp)
  800757:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800759:	85 f6                	test   %esi,%esi
  80075b:	ba 48 29 80 00       	mov    $0x802948,%edx
  800760:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800763:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800767:	7e 06                	jle    80076f <vprintfmt+0x1c5>
  800769:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80076d:	75 10                	jne    80077f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076f:	0f be 06             	movsbl (%esi),%eax
  800772:	83 c6 01             	add    $0x1,%esi
  800775:	85 c0                	test   %eax,%eax
  800777:	0f 85 86 00 00 00    	jne    800803 <vprintfmt+0x259>
  80077d:	eb 76                	jmp    8007f5 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80077f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800783:	89 34 24             	mov    %esi,(%esp)
  800786:	e8 90 02 00 00       	call   800a1b <strnlen>
  80078b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80078e:	29 c2                	sub    %eax,%edx
  800790:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800793:	85 d2                	test   %edx,%edx
  800795:	7e d8                	jle    80076f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800797:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80079b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80079e:	89 d6                	mov    %edx,%esi
  8007a0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8007a3:	89 c7                	mov    %eax,%edi
  8007a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007a9:	89 3c 24             	mov    %edi,(%esp)
  8007ac:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007af:	83 ee 01             	sub    $0x1,%esi
  8007b2:	75 f1                	jne    8007a5 <vprintfmt+0x1fb>
  8007b4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8007b7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8007ba:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8007bd:	eb b0                	jmp    80076f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007c3:	74 18                	je     8007dd <vprintfmt+0x233>
  8007c5:	8d 50 e0             	lea    -0x20(%eax),%edx
  8007c8:	83 fa 5e             	cmp    $0x5e,%edx
  8007cb:	76 10                	jbe    8007dd <vprintfmt+0x233>
					putch('?', putdat);
  8007cd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007d1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007d8:	ff 55 08             	call   *0x8(%ebp)
  8007db:	eb 0a                	jmp    8007e7 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  8007dd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007e1:	89 04 24             	mov    %eax,(%esp)
  8007e4:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007e7:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8007eb:	0f be 06             	movsbl (%esi),%eax
  8007ee:	83 c6 01             	add    $0x1,%esi
  8007f1:	85 c0                	test   %eax,%eax
  8007f3:	75 0e                	jne    800803 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fc:	7f 16                	jg     800814 <vprintfmt+0x26a>
  8007fe:	e9 ca fd ff ff       	jmp    8005cd <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800803:	85 ff                	test   %edi,%edi
  800805:	78 b8                	js     8007bf <vprintfmt+0x215>
  800807:	83 ef 01             	sub    $0x1,%edi
  80080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800810:	79 ad                	jns    8007bf <vprintfmt+0x215>
  800812:	eb e1                	jmp    8007f5 <vprintfmt+0x24b>
  800814:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800817:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80081a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80081e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800825:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800827:	83 ee 01             	sub    $0x1,%esi
  80082a:	75 ee                	jne    80081a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80082c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80082f:	e9 99 fd ff ff       	jmp    8005cd <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800834:	83 f9 01             	cmp    $0x1,%ecx
  800837:	7e 10                	jle    800849 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	8d 50 08             	lea    0x8(%eax),%edx
  80083f:	89 55 14             	mov    %edx,0x14(%ebp)
  800842:	8b 30                	mov    (%eax),%esi
  800844:	8b 78 04             	mov    0x4(%eax),%edi
  800847:	eb 26                	jmp    80086f <vprintfmt+0x2c5>
	else if (lflag)
  800849:	85 c9                	test   %ecx,%ecx
  80084b:	74 12                	je     80085f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8d 50 04             	lea    0x4(%eax),%edx
  800853:	89 55 14             	mov    %edx,0x14(%ebp)
  800856:	8b 30                	mov    (%eax),%esi
  800858:	89 f7                	mov    %esi,%edi
  80085a:	c1 ff 1f             	sar    $0x1f,%edi
  80085d:	eb 10                	jmp    80086f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	8d 50 04             	lea    0x4(%eax),%edx
  800865:	89 55 14             	mov    %edx,0x14(%ebp)
  800868:	8b 30                	mov    (%eax),%esi
  80086a:	89 f7                	mov    %esi,%edi
  80086c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80086f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800874:	85 ff                	test   %edi,%edi
  800876:	0f 89 8c 00 00 00    	jns    800908 <vprintfmt+0x35e>
				putch('-', putdat);
  80087c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800880:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800887:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80088a:	f7 de                	neg    %esi
  80088c:	83 d7 00             	adc    $0x0,%edi
  80088f:	f7 df                	neg    %edi
			}
			base = 10;
  800891:	b8 0a 00 00 00       	mov    $0xa,%eax
  800896:	eb 70                	jmp    800908 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800898:	89 ca                	mov    %ecx,%edx
  80089a:	8d 45 14             	lea    0x14(%ebp),%eax
  80089d:	e8 89 fc ff ff       	call   80052b <getuint>
  8008a2:	89 c6                	mov    %eax,%esi
  8008a4:	89 d7                	mov    %edx,%edi
			base = 10;
  8008a6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8008ab:	eb 5b                	jmp    800908 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8008ad:	89 ca                	mov    %ecx,%edx
  8008af:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b2:	e8 74 fc ff ff       	call   80052b <getuint>
  8008b7:	89 c6                	mov    %eax,%esi
  8008b9:	89 d7                	mov    %edx,%edi
			base = 8;
  8008bb:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8008c0:	eb 46                	jmp    800908 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  8008c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008c6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008cd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8008d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008d4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8008db:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	8d 50 04             	lea    0x4(%eax),%edx
  8008e4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008e7:	8b 30                	mov    (%eax),%esi
  8008e9:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8008ee:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8008f3:	eb 13                	jmp    800908 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008f5:	89 ca                	mov    %ecx,%edx
  8008f7:	8d 45 14             	lea    0x14(%ebp),%eax
  8008fa:	e8 2c fc ff ff       	call   80052b <getuint>
  8008ff:	89 c6                	mov    %eax,%esi
  800901:	89 d7                	mov    %edx,%edi
			base = 16;
  800903:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800908:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80090c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800913:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800917:	89 44 24 08          	mov    %eax,0x8(%esp)
  80091b:	89 34 24             	mov    %esi,(%esp)
  80091e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800922:	89 da                	mov    %ebx,%edx
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	e8 24 fb ff ff       	call   800450 <printnum>
			break;
  80092c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80092f:	e9 99 fc ff ff       	jmp    8005cd <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800934:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800938:	89 14 24             	mov    %edx,(%esp)
  80093b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80093e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800941:	e9 87 fc ff ff       	jmp    8005cd <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800946:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80094a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800951:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800954:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800958:	0f 84 6f fc ff ff    	je     8005cd <vprintfmt+0x23>
  80095e:	83 ee 01             	sub    $0x1,%esi
  800961:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800965:	75 f7                	jne    80095e <vprintfmt+0x3b4>
  800967:	e9 61 fc ff ff       	jmp    8005cd <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80096c:	83 c4 4c             	add    $0x4c,%esp
  80096f:	5b                   	pop    %ebx
  800970:	5e                   	pop    %esi
  800971:	5f                   	pop    %edi
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	83 ec 28             	sub    $0x28,%esp
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800980:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800983:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800987:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80098a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800991:	85 c0                	test   %eax,%eax
  800993:	74 30                	je     8009c5 <vsnprintf+0x51>
  800995:	85 d2                	test   %edx,%edx
  800997:	7e 2c                	jle    8009c5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ae:	c7 04 24 65 05 80 00 	movl   $0x800565,(%esp)
  8009b5:	e8 f0 fb ff ff       	call   8005aa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009bd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c3:	eb 05                	jmp    8009ca <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8009c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8009ca:	c9                   	leave  
  8009cb:	c3                   	ret    

008009cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	89 04 24             	mov    %eax,(%esp)
  8009ed:	e8 82 ff ff ff       	call   800974 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f2:	c9                   	leave  
  8009f3:	c3                   	ret    
	...

00800a00 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a06:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0b:	80 3a 00             	cmpb   $0x0,(%edx)
  800a0e:	74 09                	je     800a19 <strlen+0x19>
		n++;
  800a10:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a17:	75 f7                	jne    800a10 <strlen+0x10>
		n++;
	return n;
}
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	53                   	push   %ebx
  800a1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a25:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2a:	85 c9                	test   %ecx,%ecx
  800a2c:	74 1a                	je     800a48 <strnlen+0x2d>
  800a2e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800a31:	74 15                	je     800a48 <strnlen+0x2d>
  800a33:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800a38:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3a:	39 ca                	cmp    %ecx,%edx
  800a3c:	74 0a                	je     800a48 <strnlen+0x2d>
  800a3e:	83 c2 01             	add    $0x1,%edx
  800a41:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800a46:	75 f0                	jne    800a38 <strnlen+0x1d>
		n++;
	return n;
}
  800a48:	5b                   	pop    %ebx
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	53                   	push   %ebx
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a55:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a5e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a61:	83 c2 01             	add    $0x1,%edx
  800a64:	84 c9                	test   %cl,%cl
  800a66:	75 f2                	jne    800a5a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a68:	5b                   	pop    %ebx
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	53                   	push   %ebx
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a75:	89 1c 24             	mov    %ebx,(%esp)
  800a78:	e8 83 ff ff ff       	call   800a00 <strlen>
	strcpy(dst + len, src);
  800a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a80:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a84:	01 d8                	add    %ebx,%eax
  800a86:	89 04 24             	mov    %eax,(%esp)
  800a89:	e8 bd ff ff ff       	call   800a4b <strcpy>
	return dst;
}
  800a8e:	89 d8                	mov    %ebx,%eax
  800a90:	83 c4 08             	add    $0x8,%esp
  800a93:	5b                   	pop    %ebx
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	56                   	push   %esi
  800a9a:	53                   	push   %ebx
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa4:	85 f6                	test   %esi,%esi
  800aa6:	74 18                	je     800ac0 <strncpy+0x2a>
  800aa8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800aad:	0f b6 1a             	movzbl (%edx),%ebx
  800ab0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ab3:	80 3a 01             	cmpb   $0x1,(%edx)
  800ab6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab9:	83 c1 01             	add    $0x1,%ecx
  800abc:	39 f1                	cmp    %esi,%ecx
  800abe:	75 ed                	jne    800aad <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	57                   	push   %edi
  800ac8:	56                   	push   %esi
  800ac9:	53                   	push   %ebx
  800aca:	8b 7d 08             	mov    0x8(%ebp),%edi
  800acd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ad0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ad3:	89 f8                	mov    %edi,%eax
  800ad5:	85 f6                	test   %esi,%esi
  800ad7:	74 2b                	je     800b04 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800ad9:	83 fe 01             	cmp    $0x1,%esi
  800adc:	74 23                	je     800b01 <strlcpy+0x3d>
  800ade:	0f b6 0b             	movzbl (%ebx),%ecx
  800ae1:	84 c9                	test   %cl,%cl
  800ae3:	74 1c                	je     800b01 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800ae5:	83 ee 02             	sub    $0x2,%esi
  800ae8:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800aed:	88 08                	mov    %cl,(%eax)
  800aef:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800af2:	39 f2                	cmp    %esi,%edx
  800af4:	74 0b                	je     800b01 <strlcpy+0x3d>
  800af6:	83 c2 01             	add    $0x1,%edx
  800af9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800afd:	84 c9                	test   %cl,%cl
  800aff:	75 ec                	jne    800aed <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800b01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b04:	29 f8                	sub    %edi,%eax
}
  800b06:	5b                   	pop    %ebx
  800b07:	5e                   	pop    %esi
  800b08:	5f                   	pop    %edi
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b11:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b14:	0f b6 01             	movzbl (%ecx),%eax
  800b17:	84 c0                	test   %al,%al
  800b19:	74 16                	je     800b31 <strcmp+0x26>
  800b1b:	3a 02                	cmp    (%edx),%al
  800b1d:	75 12                	jne    800b31 <strcmp+0x26>
		p++, q++;
  800b1f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b22:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800b26:	84 c0                	test   %al,%al
  800b28:	74 07                	je     800b31 <strcmp+0x26>
  800b2a:	83 c1 01             	add    $0x1,%ecx
  800b2d:	3a 02                	cmp    (%edx),%al
  800b2f:	74 ee                	je     800b1f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b31:	0f b6 c0             	movzbl %al,%eax
  800b34:	0f b6 12             	movzbl (%edx),%edx
  800b37:	29 d0                	sub    %edx,%eax
}
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	53                   	push   %ebx
  800b3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b45:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b4d:	85 d2                	test   %edx,%edx
  800b4f:	74 28                	je     800b79 <strncmp+0x3e>
  800b51:	0f b6 01             	movzbl (%ecx),%eax
  800b54:	84 c0                	test   %al,%al
  800b56:	74 24                	je     800b7c <strncmp+0x41>
  800b58:	3a 03                	cmp    (%ebx),%al
  800b5a:	75 20                	jne    800b7c <strncmp+0x41>
  800b5c:	83 ea 01             	sub    $0x1,%edx
  800b5f:	74 13                	je     800b74 <strncmp+0x39>
		n--, p++, q++;
  800b61:	83 c1 01             	add    $0x1,%ecx
  800b64:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b67:	0f b6 01             	movzbl (%ecx),%eax
  800b6a:	84 c0                	test   %al,%al
  800b6c:	74 0e                	je     800b7c <strncmp+0x41>
  800b6e:	3a 03                	cmp    (%ebx),%al
  800b70:	74 ea                	je     800b5c <strncmp+0x21>
  800b72:	eb 08                	jmp    800b7c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b74:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b79:	5b                   	pop    %ebx
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b7c:	0f b6 01             	movzbl (%ecx),%eax
  800b7f:	0f b6 13             	movzbl (%ebx),%edx
  800b82:	29 d0                	sub    %edx,%eax
  800b84:	eb f3                	jmp    800b79 <strncmp+0x3e>

00800b86 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b90:	0f b6 10             	movzbl (%eax),%edx
  800b93:	84 d2                	test   %dl,%dl
  800b95:	74 1c                	je     800bb3 <strchr+0x2d>
		if (*s == c)
  800b97:	38 ca                	cmp    %cl,%dl
  800b99:	75 09                	jne    800ba4 <strchr+0x1e>
  800b9b:	eb 1b                	jmp    800bb8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b9d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800ba0:	38 ca                	cmp    %cl,%dl
  800ba2:	74 14                	je     800bb8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ba4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800ba8:	84 d2                	test   %dl,%dl
  800baa:	75 f1                	jne    800b9d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800bac:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb1:	eb 05                	jmp    800bb8 <strchr+0x32>
  800bb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc4:	0f b6 10             	movzbl (%eax),%edx
  800bc7:	84 d2                	test   %dl,%dl
  800bc9:	74 14                	je     800bdf <strfind+0x25>
		if (*s == c)
  800bcb:	38 ca                	cmp    %cl,%dl
  800bcd:	75 06                	jne    800bd5 <strfind+0x1b>
  800bcf:	eb 0e                	jmp    800bdf <strfind+0x25>
  800bd1:	38 ca                	cmp    %cl,%dl
  800bd3:	74 0a                	je     800bdf <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd5:	83 c0 01             	add    $0x1,%eax
  800bd8:	0f b6 10             	movzbl (%eax),%edx
  800bdb:	84 d2                	test   %dl,%dl
  800bdd:	75 f2                	jne    800bd1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bea:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bed:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800bf0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bf9:	85 c9                	test   %ecx,%ecx
  800bfb:	74 30                	je     800c2d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bfd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c03:	75 25                	jne    800c2a <memset+0x49>
  800c05:	f6 c1 03             	test   $0x3,%cl
  800c08:	75 20                	jne    800c2a <memset+0x49>
		c &= 0xFF;
  800c0a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c0d:	89 d3                	mov    %edx,%ebx
  800c0f:	c1 e3 08             	shl    $0x8,%ebx
  800c12:	89 d6                	mov    %edx,%esi
  800c14:	c1 e6 18             	shl    $0x18,%esi
  800c17:	89 d0                	mov    %edx,%eax
  800c19:	c1 e0 10             	shl    $0x10,%eax
  800c1c:	09 f0                	or     %esi,%eax
  800c1e:	09 d0                	or     %edx,%eax
  800c20:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c22:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c25:	fc                   	cld    
  800c26:	f3 ab                	rep stos %eax,%es:(%edi)
  800c28:	eb 03                	jmp    800c2d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c2a:	fc                   	cld    
  800c2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c2d:	89 f8                	mov    %edi,%eax
  800c2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c38:	89 ec                	mov    %ebp,%esp
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c45:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c51:	39 c6                	cmp    %eax,%esi
  800c53:	73 36                	jae    800c8b <memmove+0x4f>
  800c55:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c58:	39 d0                	cmp    %edx,%eax
  800c5a:	73 2f                	jae    800c8b <memmove+0x4f>
		s += n;
		d += n;
  800c5c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c5f:	f6 c2 03             	test   $0x3,%dl
  800c62:	75 1b                	jne    800c7f <memmove+0x43>
  800c64:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c6a:	75 13                	jne    800c7f <memmove+0x43>
  800c6c:	f6 c1 03             	test   $0x3,%cl
  800c6f:	75 0e                	jne    800c7f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c71:	83 ef 04             	sub    $0x4,%edi
  800c74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c7a:	fd                   	std    
  800c7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c7d:	eb 09                	jmp    800c88 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c7f:	83 ef 01             	sub    $0x1,%edi
  800c82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c85:	fd                   	std    
  800c86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c88:	fc                   	cld    
  800c89:	eb 20                	jmp    800cab <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c91:	75 13                	jne    800ca6 <memmove+0x6a>
  800c93:	a8 03                	test   $0x3,%al
  800c95:	75 0f                	jne    800ca6 <memmove+0x6a>
  800c97:	f6 c1 03             	test   $0x3,%cl
  800c9a:	75 0a                	jne    800ca6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c9c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c9f:	89 c7                	mov    %eax,%edi
  800ca1:	fc                   	cld    
  800ca2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca4:	eb 05                	jmp    800cab <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ca6:	89 c7                	mov    %eax,%edi
  800ca8:	fc                   	cld    
  800ca9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cb1:	89 ec                	mov    %ebp,%esp
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	89 04 24             	mov    %eax,(%esp)
  800ccf:	e8 68 ff ff ff       	call   800c3c <memmove>
}
  800cd4:	c9                   	leave  
  800cd5:	c3                   	ret    

00800cd6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
  800cdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800cdf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce2:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ce5:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cea:	85 ff                	test   %edi,%edi
  800cec:	74 37                	je     800d25 <memcmp+0x4f>
		if (*s1 != *s2)
  800cee:	0f b6 03             	movzbl (%ebx),%eax
  800cf1:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cf4:	83 ef 01             	sub    $0x1,%edi
  800cf7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800cfc:	38 c8                	cmp    %cl,%al
  800cfe:	74 1c                	je     800d1c <memcmp+0x46>
  800d00:	eb 10                	jmp    800d12 <memcmp+0x3c>
  800d02:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800d07:	83 c2 01             	add    $0x1,%edx
  800d0a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800d0e:	38 c8                	cmp    %cl,%al
  800d10:	74 0a                	je     800d1c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800d12:	0f b6 c0             	movzbl %al,%eax
  800d15:	0f b6 c9             	movzbl %cl,%ecx
  800d18:	29 c8                	sub    %ecx,%eax
  800d1a:	eb 09                	jmp    800d25 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d1c:	39 fa                	cmp    %edi,%edx
  800d1e:	75 e2                	jne    800d02 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800d30:	89 c2                	mov    %eax,%edx
  800d32:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d35:	39 d0                	cmp    %edx,%eax
  800d37:	73 19                	jae    800d52 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d39:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800d3d:	38 08                	cmp    %cl,(%eax)
  800d3f:	75 06                	jne    800d47 <memfind+0x1d>
  800d41:	eb 0f                	jmp    800d52 <memfind+0x28>
  800d43:	38 08                	cmp    %cl,(%eax)
  800d45:	74 0b                	je     800d52 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d47:	83 c0 01             	add    $0x1,%eax
  800d4a:	39 d0                	cmp    %edx,%eax
  800d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d50:	75 f1                	jne    800d43 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d60:	0f b6 02             	movzbl (%edx),%eax
  800d63:	3c 20                	cmp    $0x20,%al
  800d65:	74 04                	je     800d6b <strtol+0x17>
  800d67:	3c 09                	cmp    $0x9,%al
  800d69:	75 0e                	jne    800d79 <strtol+0x25>
		s++;
  800d6b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d6e:	0f b6 02             	movzbl (%edx),%eax
  800d71:	3c 20                	cmp    $0x20,%al
  800d73:	74 f6                	je     800d6b <strtol+0x17>
  800d75:	3c 09                	cmp    $0x9,%al
  800d77:	74 f2                	je     800d6b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d79:	3c 2b                	cmp    $0x2b,%al
  800d7b:	75 0a                	jne    800d87 <strtol+0x33>
		s++;
  800d7d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d80:	bf 00 00 00 00       	mov    $0x0,%edi
  800d85:	eb 10                	jmp    800d97 <strtol+0x43>
  800d87:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d8c:	3c 2d                	cmp    $0x2d,%al
  800d8e:	75 07                	jne    800d97 <strtol+0x43>
		s++, neg = 1;
  800d90:	83 c2 01             	add    $0x1,%edx
  800d93:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d97:	85 db                	test   %ebx,%ebx
  800d99:	0f 94 c0             	sete   %al
  800d9c:	74 05                	je     800da3 <strtol+0x4f>
  800d9e:	83 fb 10             	cmp    $0x10,%ebx
  800da1:	75 15                	jne    800db8 <strtol+0x64>
  800da3:	80 3a 30             	cmpb   $0x30,(%edx)
  800da6:	75 10                	jne    800db8 <strtol+0x64>
  800da8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800dac:	75 0a                	jne    800db8 <strtol+0x64>
		s += 2, base = 16;
  800dae:	83 c2 02             	add    $0x2,%edx
  800db1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800db6:	eb 13                	jmp    800dcb <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800db8:	84 c0                	test   %al,%al
  800dba:	74 0f                	je     800dcb <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dbc:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800dc1:	80 3a 30             	cmpb   $0x30,(%edx)
  800dc4:	75 05                	jne    800dcb <strtol+0x77>
		s++, base = 8;
  800dc6:	83 c2 01             	add    $0x1,%edx
  800dc9:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dd2:	0f b6 0a             	movzbl (%edx),%ecx
  800dd5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800dd8:	80 fb 09             	cmp    $0x9,%bl
  800ddb:	77 08                	ja     800de5 <strtol+0x91>
			dig = *s - '0';
  800ddd:	0f be c9             	movsbl %cl,%ecx
  800de0:	83 e9 30             	sub    $0x30,%ecx
  800de3:	eb 1e                	jmp    800e03 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800de5:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800de8:	80 fb 19             	cmp    $0x19,%bl
  800deb:	77 08                	ja     800df5 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800ded:	0f be c9             	movsbl %cl,%ecx
  800df0:	83 e9 57             	sub    $0x57,%ecx
  800df3:	eb 0e                	jmp    800e03 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800df5:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800df8:	80 fb 19             	cmp    $0x19,%bl
  800dfb:	77 14                	ja     800e11 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800dfd:	0f be c9             	movsbl %cl,%ecx
  800e00:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e03:	39 f1                	cmp    %esi,%ecx
  800e05:	7d 0e                	jge    800e15 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e07:	83 c2 01             	add    $0x1,%edx
  800e0a:	0f af c6             	imul   %esi,%eax
  800e0d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800e0f:	eb c1                	jmp    800dd2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800e11:	89 c1                	mov    %eax,%ecx
  800e13:	eb 02                	jmp    800e17 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e15:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1b:	74 05                	je     800e22 <strtol+0xce>
		*endptr = (char *) s;
  800e1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e20:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800e22:	89 ca                	mov    %ecx,%edx
  800e24:	f7 da                	neg    %edx
  800e26:	85 ff                	test   %edi,%edi
  800e28:	0f 45 c2             	cmovne %edx,%eax
}
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e39:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e3c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e47:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4a:	89 c3                	mov    %eax,%ebx
  800e4c:	89 c7                	mov    %eax,%edi
  800e4e:	89 c6                	mov    %eax,%esi
  800e50:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e52:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e55:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e58:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e5b:	89 ec                	mov    %ebp,%esp
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    

00800e5f <sys_cgetc>:

int
sys_cgetc(void)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 0c             	sub    $0xc,%esp
  800e65:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e68:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e6b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e73:	b8 01 00 00 00       	mov    $0x1,%eax
  800e78:	89 d1                	mov    %edx,%ecx
  800e7a:	89 d3                	mov    %edx,%ebx
  800e7c:	89 d7                	mov    %edx,%edi
  800e7e:	89 d6                	mov    %edx,%esi
  800e80:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e82:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e85:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e88:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e8b:	89 ec                	mov    %ebp,%esp
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    

00800e8f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	83 ec 38             	sub    $0x38,%esp
  800e95:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e98:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e9b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eab:	89 cb                	mov    %ecx,%ebx
  800ead:	89 cf                	mov    %ecx,%edi
  800eaf:	89 ce                	mov    %ecx,%esi
  800eb1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	7e 28                	jle    800edf <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ebb:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ec2:	00 
  800ec3:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  800eca:	00 
  800ecb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed2:	00 
  800ed3:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800eda:	e8 51 f4 ff ff       	call   800330 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800edf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ee2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ee5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ee8:	89 ec                	mov    %ebp,%esp
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    

00800eec <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 0c             	sub    $0xc,%esp
  800ef2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ef5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ef8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efb:	ba 00 00 00 00       	mov    $0x0,%edx
  800f00:	b8 02 00 00 00       	mov    $0x2,%eax
  800f05:	89 d1                	mov    %edx,%ecx
  800f07:	89 d3                	mov    %edx,%ebx
  800f09:	89 d7                	mov    %edx,%edi
  800f0b:	89 d6                	mov    %edx,%esi
  800f0d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f0f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f12:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f15:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f18:	89 ec                	mov    %ebp,%esp
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <sys_yield>:

void
sys_yield(void)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 0c             	sub    $0xc,%esp
  800f22:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f25:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f28:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f30:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f35:	89 d1                	mov    %edx,%ecx
  800f37:	89 d3                	mov    %edx,%ebx
  800f39:	89 d7                	mov    %edx,%edi
  800f3b:	89 d6                	mov    %edx,%esi
  800f3d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f3f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f42:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f45:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f48:	89 ec                	mov    %ebp,%esp
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    

00800f4c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 38             	sub    $0x38,%esp
  800f52:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f55:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f58:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5b:	be 00 00 00 00       	mov    $0x0,%esi
  800f60:	b8 04 00 00 00       	mov    $0x4,%eax
  800f65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	89 f7                	mov    %esi,%edi
  800f70:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f72:	85 c0                	test   %eax,%eax
  800f74:	7e 28                	jle    800f9e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f76:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f7a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f81:	00 
  800f82:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  800f89:	00 
  800f8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f91:	00 
  800f92:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800f99:	e8 92 f3 ff ff       	call   800330 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f9e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fa4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fa7:	89 ec                	mov    %ebp,%esp
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    

00800fab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 38             	sub    $0x38,%esp
  800fb1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fb4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fb7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fba:	b8 05 00 00 00       	mov    $0x5,%eax
  800fbf:	8b 75 18             	mov    0x18(%ebp),%esi
  800fc2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fce:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	7e 28                	jle    800ffc <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fdf:	00 
  800fe0:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  800fe7:	00 
  800fe8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fef:	00 
  800ff0:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800ff7:	e8 34 f3 ff ff       	call   800330 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ffc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fff:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801002:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801005:	89 ec                	mov    %ebp,%esp
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 38             	sub    $0x38,%esp
  80100f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801012:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801015:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801018:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101d:	b8 06 00 00 00       	mov    $0x6,%eax
  801022:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801025:	8b 55 08             	mov    0x8(%ebp),%edx
  801028:	89 df                	mov    %ebx,%edi
  80102a:	89 de                	mov    %ebx,%esi
  80102c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80102e:	85 c0                	test   %eax,%eax
  801030:	7e 28                	jle    80105a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801032:	89 44 24 10          	mov    %eax,0x10(%esp)
  801036:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80103d:	00 
  80103e:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  801045:	00 
  801046:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104d:	00 
  80104e:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  801055:	e8 d6 f2 ff ff       	call   800330 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80105a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80105d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801060:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801063:	89 ec                	mov    %ebp,%esp
  801065:	5d                   	pop    %ebp
  801066:	c3                   	ret    

00801067 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 38             	sub    $0x38,%esp
  80106d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801070:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801073:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801076:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107b:	b8 08 00 00 00       	mov    $0x8,%eax
  801080:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801083:	8b 55 08             	mov    0x8(%ebp),%edx
  801086:	89 df                	mov    %ebx,%edi
  801088:	89 de                	mov    %ebx,%esi
  80108a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	7e 28                	jle    8010b8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801090:	89 44 24 10          	mov    %eax,0x10(%esp)
  801094:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80109b:	00 
  80109c:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  8010a3:	00 
  8010a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ab:	00 
  8010ac:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  8010b3:	e8 78 f2 ff ff       	call   800330 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010bb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010be:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010c1:	89 ec                	mov    %ebp,%esp
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    

008010c5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 38             	sub    $0x38,%esp
  8010cb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ce:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010d1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d9:	b8 09 00 00 00       	mov    $0x9,%eax
  8010de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e4:	89 df                	mov    %ebx,%edi
  8010e6:	89 de                	mov    %ebx,%esi
  8010e8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	7e 28                	jle    801116 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ee:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f2:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010f9:	00 
  8010fa:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  801101:	00 
  801102:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801109:	00 
  80110a:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  801111:	e8 1a f2 ff ff       	call   800330 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801116:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801119:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80111c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80111f:	89 ec                	mov    %ebp,%esp
  801121:	5d                   	pop    %ebp
  801122:	c3                   	ret    

00801123 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
  801126:	83 ec 38             	sub    $0x38,%esp
  801129:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80112c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80112f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801132:	bb 00 00 00 00       	mov    $0x0,%ebx
  801137:	b8 0a 00 00 00       	mov    $0xa,%eax
  80113c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113f:	8b 55 08             	mov    0x8(%ebp),%edx
  801142:	89 df                	mov    %ebx,%edi
  801144:	89 de                	mov    %ebx,%esi
  801146:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801148:	85 c0                	test   %eax,%eax
  80114a:	7e 28                	jle    801174 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80114c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801150:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801157:	00 
  801158:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  80115f:	00 
  801160:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801167:	00 
  801168:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  80116f:	e8 bc f1 ff ff       	call   800330 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801174:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801177:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80117a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80117d:	89 ec                	mov    %ebp,%esp
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    

00801181 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
  801184:	83 ec 0c             	sub    $0xc,%esp
  801187:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80118a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80118d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801190:	be 00 00 00 00       	mov    $0x0,%esi
  801195:	b8 0c 00 00 00       	mov    $0xc,%eax
  80119a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80119d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011a8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011ab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011ae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011b1:	89 ec                	mov    %ebp,%esp
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 38             	sub    $0x38,%esp
  8011bb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011be:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011c1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011c9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d1:	89 cb                	mov    %ecx,%ebx
  8011d3:	89 cf                	mov    %ecx,%edi
  8011d5:	89 ce                	mov    %ecx,%esi
  8011d7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	7e 28                	jle    801205 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011e1:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8011e8:	00 
  8011e9:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  8011f0:	00 
  8011f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011f8:	00 
  8011f9:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  801200:	e8 2b f1 ff ff       	call   800330 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801205:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801208:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80120b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80120e:	89 ec                	mov    %ebp,%esp
  801210:	5d                   	pop    %ebp
  801211:	c3                   	ret    
	...

00801214 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	53                   	push   %ebx
  801218:	83 ec 24             	sub    $0x24,%esp
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80121e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  801220:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801224:	74 21                	je     801247 <pgfault+0x33>
  801226:	89 d8                	mov    %ebx,%eax
  801228:	c1 e8 16             	shr    $0x16,%eax
  80122b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801232:	a8 01                	test   $0x1,%al
  801234:	74 11                	je     801247 <pgfault+0x33>
  801236:	89 d8                	mov    %ebx,%eax
  801238:	c1 e8 0c             	shr    $0xc,%eax
  80123b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801242:	f6 c4 08             	test   $0x8,%ah
  801245:	75 1c                	jne    801263 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  801247:	c7 44 24 08 6c 2c 80 	movl   $0x802c6c,0x8(%esp)
  80124e:	00 
  80124f:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  801256:	00 
  801257:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  80125e:	e8 cd f0 ff ff       	call   800330 <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  801263:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80126a:	00 
  80126b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801272:	00 
  801273:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80127a:	e8 cd fc ff ff       	call   800f4c <sys_page_alloc>
  80127f:	85 c0                	test   %eax,%eax
  801281:	79 20                	jns    8012a3 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  801283:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801287:	c7 44 24 08 a8 2c 80 	movl   $0x802ca8,0x8(%esp)
  80128e:	00 
  80128f:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  801296:	00 
  801297:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  80129e:	e8 8d f0 ff ff       	call   800330 <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  8012a3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  8012a9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8012b0:	00 
  8012b1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012b5:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8012bc:	e8 7b f9 ff ff       	call   800c3c <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  8012c1:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8012c8:	00 
  8012c9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012cd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012d4:	00 
  8012d5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012dc:	00 
  8012dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e4:	e8 c2 fc ff ff       	call   800fab <sys_page_map>
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	79 20                	jns    80130d <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  8012ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012f1:	c7 44 24 08 d0 2c 80 	movl   $0x802cd0,0x8(%esp)
  8012f8:	00 
  8012f9:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  801300:	00 
  801301:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  801308:	e8 23 f0 ff ff       	call   800330 <_panic>
	//panic("pgfault not implemented");
}
  80130d:	83 c4 24             	add    $0x24,%esp
  801310:	5b                   	pop    %ebx
  801311:	5d                   	pop    %ebp
  801312:	c3                   	ret    

00801313 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	57                   	push   %edi
  801317:	56                   	push   %esi
  801318:	53                   	push   %ebx
  801319:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  80131c:	c7 04 24 14 12 80 00 	movl   $0x801214,(%esp)
  801323:	e8 88 10 00 00       	call   8023b0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801328:	ba 07 00 00 00       	mov    $0x7,%edx
  80132d:	89 d0                	mov    %edx,%eax
  80132f:	cd 30                	int    $0x30
  801331:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801334:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  801336:	85 c0                	test   %eax,%eax
  801338:	79 20                	jns    80135a <fork+0x47>
		panic("sys_exofork: %e", envid);
  80133a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80133e:	c7 44 24 08 ce 2d 80 	movl   $0x802dce,0x8(%esp)
  801345:	00 
  801346:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  80134d:	00 
  80134e:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  801355:	e8 d6 ef ff ff       	call   800330 <_panic>
	if (envid == 0) {
  80135a:	bb 00 00 80 00       	mov    $0x800000,%ebx
  80135f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801363:	75 1c                	jne    801381 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801365:	e8 82 fb ff ff       	call   800eec <sys_getenvid>
  80136a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80136f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801372:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801377:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80137c:	e9 06 02 00 00       	jmp    801587 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  801381:	89 d8                	mov    %ebx,%eax
  801383:	c1 e8 16             	shr    $0x16,%eax
  801386:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80138d:	a8 01                	test   $0x1,%al
  80138f:	0f 84 57 01 00 00    	je     8014ec <fork+0x1d9>
  801395:	89 de                	mov    %ebx,%esi
  801397:	c1 ee 0c             	shr    $0xc,%esi
  80139a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8013a1:	a8 01                	test   $0x1,%al
  8013a3:	0f 84 43 01 00 00    	je     8014ec <fork+0x1d9>
  8013a9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8013b0:	a8 04                	test   $0x4,%al
  8013b2:	0f 84 34 01 00 00    	je     8014ec <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  8013b8:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  8013bb:	89 f0                	mov    %esi,%eax
  8013bd:	c1 e8 0c             	shr    $0xc,%eax
  8013c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  8013c7:	f6 c4 04             	test   $0x4,%ah
  8013ca:	74 45                	je     801411 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  8013cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8013d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013d5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013d9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013dd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e8:	e8 be fb ff ff       	call   800fab <sys_page_map>
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	0f 89 f7 00 00 00    	jns    8014ec <fork+0x1d9>
			panic ("duppage: error at lab5");
  8013f5:	c7 44 24 08 de 2d 80 	movl   $0x802dde,0x8(%esp)
  8013fc:	00 
  8013fd:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  801404:	00 
  801405:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  80140c:	e8 1f ef ff ff       	call   800330 <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  801411:	a9 02 08 00 00       	test   $0x802,%eax
  801416:	0f 84 8c 00 00 00    	je     8014a8 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  80141c:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801423:	00 
  801424:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801428:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80142c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801430:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801437:	e8 6f fb ff ff       	call   800fab <sys_page_map>
  80143c:	85 c0                	test   %eax,%eax
  80143e:	79 20                	jns    801460 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  801440:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801444:	c7 44 24 08 f4 2c 80 	movl   $0x802cf4,0x8(%esp)
  80144b:	00 
  80144c:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  801453:	00 
  801454:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  80145b:	e8 d0 ee ff ff       	call   800330 <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  801460:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801467:	00 
  801468:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80146c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801473:	00 
  801474:	89 74 24 04          	mov    %esi,0x4(%esp)
  801478:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80147f:	e8 27 fb ff ff       	call   800fab <sys_page_map>
  801484:	85 c0                	test   %eax,%eax
  801486:	79 64                	jns    8014ec <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  801488:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80148c:	c7 44 24 08 20 2d 80 	movl   $0x802d20,0x8(%esp)
  801493:	00 
  801494:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  80149b:	00 
  80149c:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  8014a3:	e8 88 ee ff ff       	call   800330 <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  8014a8:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8014af:	00 
  8014b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014b4:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c3:	e8 e3 fa ff ff       	call   800fab <sys_page_map>
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	79 20                	jns    8014ec <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  8014cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014d0:	c7 44 24 08 4c 2d 80 	movl   $0x802d4c,0x8(%esp)
  8014d7:	00 
  8014d8:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  8014df:	00 
  8014e0:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  8014e7:	e8 44 ee ff ff       	call   800330 <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  8014ec:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014f2:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8014f8:	0f 85 83 fe ff ff    	jne    801381 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  8014fe:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801505:	00 
  801506:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80150d:	ee 
  80150e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801511:	89 04 24             	mov    %eax,(%esp)
  801514:	e8 33 fa ff ff       	call   800f4c <sys_page_alloc>
  801519:	85 c0                	test   %eax,%eax
  80151b:	79 20                	jns    80153d <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  80151d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801521:	c7 44 24 08 78 2d 80 	movl   $0x802d78,0x8(%esp)
  801528:	00 
  801529:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801530:	00 
  801531:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  801538:	e8 f3 ed ff ff       	call   800330 <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  80153d:	c7 44 24 04 20 24 80 	movl   $0x802420,0x4(%esp)
  801544:	00 
  801545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801548:	89 04 24             	mov    %eax,(%esp)
  80154b:	e8 d3 fb ff ff       	call   801123 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801550:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801557:	00 
  801558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80155b:	89 04 24             	mov    %eax,(%esp)
  80155e:	e8 04 fb ff ff       	call   801067 <sys_env_set_status>
  801563:	85 c0                	test   %eax,%eax
  801565:	79 20                	jns    801587 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  801567:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80156b:	c7 44 24 08 9c 2d 80 	movl   $0x802d9c,0x8(%esp)
  801572:	00 
  801573:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  80157a:	00 
  80157b:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  801582:	e8 a9 ed ff ff       	call   800330 <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  801587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158a:	83 c4 3c             	add    $0x3c,%esp
  80158d:	5b                   	pop    %ebx
  80158e:	5e                   	pop    %esi
  80158f:	5f                   	pop    %edi
  801590:	5d                   	pop    %ebp
  801591:	c3                   	ret    

00801592 <sfork>:

// Challenge!
int
sfork(void)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801598:	c7 44 24 08 f5 2d 80 	movl   $0x802df5,0x8(%esp)
  80159f:	00 
  8015a0:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  8015a7:	00 
  8015a8:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  8015af:	e8 7c ed ff ff       	call   800330 <_panic>
	...

008015c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8015cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8015ce:	5d                   	pop    %ebp
  8015cf:	c3                   	ret    

008015d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	89 04 24             	mov    %eax,(%esp)
  8015dc:	e8 df ff ff ff       	call   8015c0 <fd2num>
  8015e1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8015e6:	c1 e0 0c             	shl    $0xc,%eax
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	53                   	push   %ebx
  8015ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015f2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8015f7:	a8 01                	test   $0x1,%al
  8015f9:	74 34                	je     80162f <fd_alloc+0x44>
  8015fb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801600:	a8 01                	test   $0x1,%al
  801602:	74 32                	je     801636 <fd_alloc+0x4b>
  801604:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801609:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80160b:	89 c2                	mov    %eax,%edx
  80160d:	c1 ea 16             	shr    $0x16,%edx
  801610:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801617:	f6 c2 01             	test   $0x1,%dl
  80161a:	74 1f                	je     80163b <fd_alloc+0x50>
  80161c:	89 c2                	mov    %eax,%edx
  80161e:	c1 ea 0c             	shr    $0xc,%edx
  801621:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801628:	f6 c2 01             	test   $0x1,%dl
  80162b:	75 17                	jne    801644 <fd_alloc+0x59>
  80162d:	eb 0c                	jmp    80163b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80162f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801634:	eb 05                	jmp    80163b <fd_alloc+0x50>
  801636:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80163b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80163d:	b8 00 00 00 00       	mov    $0x0,%eax
  801642:	eb 17                	jmp    80165b <fd_alloc+0x70>
  801644:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801649:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80164e:	75 b9                	jne    801609 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801650:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801656:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80165b:	5b                   	pop    %ebx
  80165c:	5d                   	pop    %ebp
  80165d:	c3                   	ret    

0080165e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801664:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801669:	83 fa 1f             	cmp    $0x1f,%edx
  80166c:	77 3f                	ja     8016ad <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80166e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801674:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801677:	89 d0                	mov    %edx,%eax
  801679:	c1 e8 16             	shr    $0x16,%eax
  80167c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801683:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801688:	f6 c1 01             	test   $0x1,%cl
  80168b:	74 20                	je     8016ad <fd_lookup+0x4f>
  80168d:	89 d0                	mov    %edx,%eax
  80168f:	c1 e8 0c             	shr    $0xc,%eax
  801692:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801699:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80169e:	f6 c1 01             	test   $0x1,%cl
  8016a1:	74 0a                	je     8016ad <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a6:	89 10                	mov    %edx,(%eax)
	return 0;
  8016a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ad:	5d                   	pop    %ebp
  8016ae:	c3                   	ret    

008016af <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	53                   	push   %ebx
  8016b3:	83 ec 14             	sub    $0x14,%esp
  8016b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016c1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8016c7:	75 17                	jne    8016e0 <dev_lookup+0x31>
  8016c9:	eb 07                	jmp    8016d2 <dev_lookup+0x23>
  8016cb:	39 0a                	cmp    %ecx,(%edx)
  8016cd:	75 11                	jne    8016e0 <dev_lookup+0x31>
  8016cf:	90                   	nop
  8016d0:	eb 05                	jmp    8016d7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016d2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8016d7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8016d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016de:	eb 35                	jmp    801715 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016e0:	83 c0 01             	add    $0x1,%eax
  8016e3:	8b 14 85 8c 2e 80 00 	mov    0x802e8c(,%eax,4),%edx
  8016ea:	85 d2                	test   %edx,%edx
  8016ec:	75 dd                	jne    8016cb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8016f3:	8b 40 48             	mov    0x48(%eax),%eax
  8016f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fe:	c7 04 24 0c 2e 80 00 	movl   $0x802e0c,(%esp)
  801705:	e8 21 ed ff ff       	call   80042b <cprintf>
	*dev = 0;
  80170a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801710:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801715:	83 c4 14             	add    $0x14,%esp
  801718:	5b                   	pop    %ebx
  801719:	5d                   	pop    %ebp
  80171a:	c3                   	ret    

0080171b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 38             	sub    $0x38,%esp
  801721:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801724:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801727:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80172a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80172d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801731:	89 3c 24             	mov    %edi,(%esp)
  801734:	e8 87 fe ff ff       	call   8015c0 <fd2num>
  801739:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80173c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801740:	89 04 24             	mov    %eax,(%esp)
  801743:	e8 16 ff ff ff       	call   80165e <fd_lookup>
  801748:	89 c3                	mov    %eax,%ebx
  80174a:	85 c0                	test   %eax,%eax
  80174c:	78 05                	js     801753 <fd_close+0x38>
	    || fd != fd2)
  80174e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801751:	74 0e                	je     801761 <fd_close+0x46>
		return (must_exist ? r : 0);
  801753:	89 f0                	mov    %esi,%eax
  801755:	84 c0                	test   %al,%al
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
  80175c:	0f 44 d8             	cmove  %eax,%ebx
  80175f:	eb 3d                	jmp    80179e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801761:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801764:	89 44 24 04          	mov    %eax,0x4(%esp)
  801768:	8b 07                	mov    (%edi),%eax
  80176a:	89 04 24             	mov    %eax,(%esp)
  80176d:	e8 3d ff ff ff       	call   8016af <dev_lookup>
  801772:	89 c3                	mov    %eax,%ebx
  801774:	85 c0                	test   %eax,%eax
  801776:	78 16                	js     80178e <fd_close+0x73>
		if (dev->dev_close)
  801778:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80177b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80177e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801783:	85 c0                	test   %eax,%eax
  801785:	74 07                	je     80178e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801787:	89 3c 24             	mov    %edi,(%esp)
  80178a:	ff d0                	call   *%eax
  80178c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80178e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801792:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801799:	e8 6b f8 ff ff       	call   801009 <sys_page_unmap>
	return r;
}
  80179e:	89 d8                	mov    %ebx,%eax
  8017a0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017a3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8017a6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017a9:	89 ec                	mov    %ebp,%esp
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    

008017ad <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	89 04 24             	mov    %eax,(%esp)
  8017c0:	e8 99 fe ff ff       	call   80165e <fd_lookup>
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	78 13                	js     8017dc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8017c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017d0:	00 
  8017d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d4:	89 04 24             	mov    %eax,(%esp)
  8017d7:	e8 3f ff ff ff       	call   80171b <fd_close>
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <close_all>:

void
close_all(void)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	53                   	push   %ebx
  8017e2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017ea:	89 1c 24             	mov    %ebx,(%esp)
  8017ed:	e8 bb ff ff ff       	call   8017ad <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017f2:	83 c3 01             	add    $0x1,%ebx
  8017f5:	83 fb 20             	cmp    $0x20,%ebx
  8017f8:	75 f0                	jne    8017ea <close_all+0xc>
		close(i);
}
  8017fa:	83 c4 14             	add    $0x14,%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 58             	sub    $0x58,%esp
  801806:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801809:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80180c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80180f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801812:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801815:	89 44 24 04          	mov    %eax,0x4(%esp)
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	89 04 24             	mov    %eax,(%esp)
  80181f:	e8 3a fe ff ff       	call   80165e <fd_lookup>
  801824:	89 c3                	mov    %eax,%ebx
  801826:	85 c0                	test   %eax,%eax
  801828:	0f 88 e1 00 00 00    	js     80190f <dup+0x10f>
		return r;
	close(newfdnum);
  80182e:	89 3c 24             	mov    %edi,(%esp)
  801831:	e8 77 ff ff ff       	call   8017ad <close>

	newfd = INDEX2FD(newfdnum);
  801836:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80183c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80183f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801842:	89 04 24             	mov    %eax,(%esp)
  801845:	e8 86 fd ff ff       	call   8015d0 <fd2data>
  80184a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80184c:	89 34 24             	mov    %esi,(%esp)
  80184f:	e8 7c fd ff ff       	call   8015d0 <fd2data>
  801854:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801857:	89 d8                	mov    %ebx,%eax
  801859:	c1 e8 16             	shr    $0x16,%eax
  80185c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801863:	a8 01                	test   $0x1,%al
  801865:	74 46                	je     8018ad <dup+0xad>
  801867:	89 d8                	mov    %ebx,%eax
  801869:	c1 e8 0c             	shr    $0xc,%eax
  80186c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801873:	f6 c2 01             	test   $0x1,%dl
  801876:	74 35                	je     8018ad <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801878:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80187f:	25 07 0e 00 00       	and    $0xe07,%eax
  801884:	89 44 24 10          	mov    %eax,0x10(%esp)
  801888:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80188b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80188f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801896:	00 
  801897:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80189b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a2:	e8 04 f7 ff ff       	call   800fab <sys_page_map>
  8018a7:	89 c3                	mov    %eax,%ebx
  8018a9:	85 c0                	test   %eax,%eax
  8018ab:	78 3b                	js     8018e8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018b0:	89 c2                	mov    %eax,%edx
  8018b2:	c1 ea 0c             	shr    $0xc,%edx
  8018b5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018bc:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8018c2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018c6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8018ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018d1:	00 
  8018d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018dd:	e8 c9 f6 ff ff       	call   800fab <sys_page_map>
  8018e2:	89 c3                	mov    %eax,%ebx
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	79 25                	jns    80190d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8018e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018f3:	e8 11 f7 ff ff       	call   801009 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801906:	e8 fe f6 ff ff       	call   801009 <sys_page_unmap>
	return r;
  80190b:	eb 02                	jmp    80190f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80190d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80190f:	89 d8                	mov    %ebx,%eax
  801911:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801914:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801917:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80191a:	89 ec                	mov    %ebp,%esp
  80191c:	5d                   	pop    %ebp
  80191d:	c3                   	ret    

0080191e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
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
  801932:	e8 27 fd ff ff       	call   80165e <fd_lookup>
  801937:	85 c0                	test   %eax,%eax
  801939:	78 6d                	js     8019a8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80193b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801945:	8b 00                	mov    (%eax),%eax
  801947:	89 04 24             	mov    %eax,(%esp)
  80194a:	e8 60 fd ff ff       	call   8016af <dev_lookup>
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 55                	js     8019a8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801956:	8b 50 08             	mov    0x8(%eax),%edx
  801959:	83 e2 03             	and    $0x3,%edx
  80195c:	83 fa 01             	cmp    $0x1,%edx
  80195f:	75 23                	jne    801984 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801961:	a1 04 40 80 00       	mov    0x804004,%eax
  801966:	8b 40 48             	mov    0x48(%eax),%eax
  801969:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80196d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801971:	c7 04 24 50 2e 80 00 	movl   $0x802e50,(%esp)
  801978:	e8 ae ea ff ff       	call   80042b <cprintf>
		return -E_INVAL;
  80197d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801982:	eb 24                	jmp    8019a8 <read+0x8a>
	}
	if (!dev->dev_read)
  801984:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801987:	8b 52 08             	mov    0x8(%edx),%edx
  80198a:	85 d2                	test   %edx,%edx
  80198c:	74 15                	je     8019a3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80198e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801991:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801995:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801998:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80199c:	89 04 24             	mov    %eax,(%esp)
  80199f:	ff d2                	call   *%edx
  8019a1:	eb 05                	jmp    8019a8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8019a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8019a8:	83 c4 24             	add    $0x24,%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5d                   	pop    %ebp
  8019ad:	c3                   	ret    

008019ae <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	57                   	push   %edi
  8019b2:	56                   	push   %esi
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 1c             	sub    $0x1c,%esp
  8019b7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019ba:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c2:	85 f6                	test   %esi,%esi
  8019c4:	74 30                	je     8019f6 <readn+0x48>
  8019c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019cb:	89 f2                	mov    %esi,%edx
  8019cd:	29 c2                	sub    %eax,%edx
  8019cf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019d3:	03 45 0c             	add    0xc(%ebp),%eax
  8019d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019da:	89 3c 24             	mov    %edi,(%esp)
  8019dd:	e8 3c ff ff ff       	call   80191e <read>
		if (m < 0)
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	78 10                	js     8019f6 <readn+0x48>
			return m;
		if (m == 0)
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	74 0a                	je     8019f4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019ea:	01 c3                	add    %eax,%ebx
  8019ec:	89 d8                	mov    %ebx,%eax
  8019ee:	39 f3                	cmp    %esi,%ebx
  8019f0:	72 d9                	jb     8019cb <readn+0x1d>
  8019f2:	eb 02                	jmp    8019f6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8019f4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8019f6:	83 c4 1c             	add    $0x1c,%esp
  8019f9:	5b                   	pop    %ebx
  8019fa:	5e                   	pop    %esi
  8019fb:	5f                   	pop    %edi
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    

008019fe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	53                   	push   %ebx
  801a02:	83 ec 24             	sub    $0x24,%esp
  801a05:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0f:	89 1c 24             	mov    %ebx,(%esp)
  801a12:	e8 47 fc ff ff       	call   80165e <fd_lookup>
  801a17:	85 c0                	test   %eax,%eax
  801a19:	78 68                	js     801a83 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a25:	8b 00                	mov    (%eax),%eax
  801a27:	89 04 24             	mov    %eax,(%esp)
  801a2a:	e8 80 fc ff ff       	call   8016af <dev_lookup>
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	78 50                	js     801a83 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a36:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a3a:	75 23                	jne    801a5f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a3c:	a1 04 40 80 00       	mov    0x804004,%eax
  801a41:	8b 40 48             	mov    0x48(%eax),%eax
  801a44:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4c:	c7 04 24 6c 2e 80 00 	movl   $0x802e6c,(%esp)
  801a53:	e8 d3 e9 ff ff       	call   80042b <cprintf>
		return -E_INVAL;
  801a58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5d:	eb 24                	jmp    801a83 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a62:	8b 52 0c             	mov    0xc(%edx),%edx
  801a65:	85 d2                	test   %edx,%edx
  801a67:	74 15                	je     801a7e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a77:	89 04 24             	mov    %eax,(%esp)
  801a7a:	ff d2                	call   *%edx
  801a7c:	eb 05                	jmp    801a83 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a7e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a83:	83 c4 24             	add    $0x24,%esp
  801a86:	5b                   	pop    %ebx
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    

00801a89 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a8f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	89 04 24             	mov    %eax,(%esp)
  801a9c:	e8 bd fb ff ff       	call   80165e <fd_lookup>
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	78 0e                	js     801ab3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801aa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aab:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801aae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	53                   	push   %ebx
  801ab9:	83 ec 24             	sub    $0x24,%esp
  801abc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801abf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac6:	89 1c 24             	mov    %ebx,(%esp)
  801ac9:	e8 90 fb ff ff       	call   80165e <fd_lookup>
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 61                	js     801b33 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ad2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801adc:	8b 00                	mov    (%eax),%eax
  801ade:	89 04 24             	mov    %eax,(%esp)
  801ae1:	e8 c9 fb ff ff       	call   8016af <dev_lookup>
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 49                	js     801b33 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801af1:	75 23                	jne    801b16 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801af3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801af8:	8b 40 48             	mov    0x48(%eax),%eax
  801afb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b03:	c7 04 24 2c 2e 80 00 	movl   $0x802e2c,(%esp)
  801b0a:	e8 1c e9 ff ff       	call   80042b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801b0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b14:	eb 1d                	jmp    801b33 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b19:	8b 52 18             	mov    0x18(%edx),%edx
  801b1c:	85 d2                	test   %edx,%edx
  801b1e:	74 0e                	je     801b2e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b27:	89 04 24             	mov    %eax,(%esp)
  801b2a:	ff d2                	call   *%edx
  801b2c:	eb 05                	jmp    801b33 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801b2e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801b33:	83 c4 24             	add    $0x24,%esp
  801b36:	5b                   	pop    %ebx
  801b37:	5d                   	pop    %ebp
  801b38:	c3                   	ret    

00801b39 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	53                   	push   %ebx
  801b3d:	83 ec 24             	sub    $0x24,%esp
  801b40:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b43:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	89 04 24             	mov    %eax,(%esp)
  801b50:	e8 09 fb ff ff       	call   80165e <fd_lookup>
  801b55:	85 c0                	test   %eax,%eax
  801b57:	78 52                	js     801bab <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b63:	8b 00                	mov    (%eax),%eax
  801b65:	89 04 24             	mov    %eax,(%esp)
  801b68:	e8 42 fb ff ff       	call   8016af <dev_lookup>
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	78 3a                	js     801bab <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b74:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b78:	74 2c                	je     801ba6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b7a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b7d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b84:	00 00 00 
	stat->st_isdir = 0;
  801b87:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b8e:	00 00 00 
	stat->st_dev = dev;
  801b91:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b97:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b9e:	89 14 24             	mov    %edx,(%esp)
  801ba1:	ff 50 14             	call   *0x14(%eax)
  801ba4:	eb 05                	jmp    801bab <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ba6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801bab:	83 c4 24             	add    $0x24,%esp
  801bae:	5b                   	pop    %ebx
  801baf:	5d                   	pop    %ebp
  801bb0:	c3                   	ret    

00801bb1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 18             	sub    $0x18,%esp
  801bb7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801bba:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bbd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bc4:	00 
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	89 04 24             	mov    %eax,(%esp)
  801bcb:	e8 bc 01 00 00       	call   801d8c <open>
  801bd0:	89 c3                	mov    %eax,%ebx
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	78 1b                	js     801bf1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdd:	89 1c 24             	mov    %ebx,(%esp)
  801be0:	e8 54 ff ff ff       	call   801b39 <fstat>
  801be5:	89 c6                	mov    %eax,%esi
	close(fd);
  801be7:	89 1c 24             	mov    %ebx,(%esp)
  801bea:	e8 be fb ff ff       	call   8017ad <close>
	return r;
  801bef:	89 f3                	mov    %esi,%ebx
}
  801bf1:	89 d8                	mov    %ebx,%eax
  801bf3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801bf6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801bf9:	89 ec                	mov    %ebp,%esp
  801bfb:	5d                   	pop    %ebp
  801bfc:	c3                   	ret    
  801bfd:	00 00                	add    %al,(%eax)
	...

00801c00 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 18             	sub    $0x18,%esp
  801c06:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c09:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801c0c:	89 c3                	mov    %eax,%ebx
  801c0e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801c10:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801c17:	75 11                	jne    801c2a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c20:	e8 01 09 00 00       	call   802526 <ipc_find_env>
  801c25:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c2a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c31:	00 
  801c32:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801c39:	00 
  801c3a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c3e:	a1 00 40 80 00       	mov    0x804000,%eax
  801c43:	89 04 24             	mov    %eax,(%esp)
  801c46:	e8 57 08 00 00       	call   8024a2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c52:	00 
  801c53:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c5e:	e8 ed 07 00 00       	call   802450 <ipc_recv>
}
  801c63:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801c66:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801c69:	89 ec                	mov    %ebp,%esp
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    

00801c6d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	53                   	push   %ebx
  801c71:	83 ec 14             	sub    $0x14,%esp
  801c74:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c82:	ba 00 00 00 00       	mov    $0x0,%edx
  801c87:	b8 05 00 00 00       	mov    $0x5,%eax
  801c8c:	e8 6f ff ff ff       	call   801c00 <fsipc>
  801c91:	85 c0                	test   %eax,%eax
  801c93:	78 2b                	js     801cc0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c95:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c9c:	00 
  801c9d:	89 1c 24             	mov    %ebx,(%esp)
  801ca0:	e8 a6 ed ff ff       	call   800a4b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ca5:	a1 80 50 80 00       	mov    0x805080,%eax
  801caa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cb0:	a1 84 50 80 00       	mov    0x805084,%eax
  801cb5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc0:	83 c4 14             	add    $0x14,%esp
  801cc3:	5b                   	pop    %ebx
  801cc4:	5d                   	pop    %ebp
  801cc5:	c3                   	ret    

00801cc6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801cd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cdc:	b8 06 00 00 00       	mov    $0x6,%eax
  801ce1:	e8 1a ff ff ff       	call   801c00 <fsipc>
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	56                   	push   %esi
  801cec:	53                   	push   %ebx
  801ced:	83 ec 10             	sub    $0x10,%esp
  801cf0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801cfe:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d04:	ba 00 00 00 00       	mov    $0x0,%edx
  801d09:	b8 03 00 00 00       	mov    $0x3,%eax
  801d0e:	e8 ed fe ff ff       	call   801c00 <fsipc>
  801d13:	89 c3                	mov    %eax,%ebx
  801d15:	85 c0                	test   %eax,%eax
  801d17:	78 6a                	js     801d83 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d19:	39 c6                	cmp    %eax,%esi
  801d1b:	73 24                	jae    801d41 <devfile_read+0x59>
  801d1d:	c7 44 24 0c 9c 2e 80 	movl   $0x802e9c,0xc(%esp)
  801d24:	00 
  801d25:	c7 44 24 08 a3 2e 80 	movl   $0x802ea3,0x8(%esp)
  801d2c:	00 
  801d2d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801d34:	00 
  801d35:	c7 04 24 b8 2e 80 00 	movl   $0x802eb8,(%esp)
  801d3c:	e8 ef e5 ff ff       	call   800330 <_panic>
	assert(r <= PGSIZE);
  801d41:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d46:	7e 24                	jle    801d6c <devfile_read+0x84>
  801d48:	c7 44 24 0c c3 2e 80 	movl   $0x802ec3,0xc(%esp)
  801d4f:	00 
  801d50:	c7 44 24 08 a3 2e 80 	movl   $0x802ea3,0x8(%esp)
  801d57:	00 
  801d58:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801d5f:	00 
  801d60:	c7 04 24 b8 2e 80 00 	movl   $0x802eb8,(%esp)
  801d67:	e8 c4 e5 ff ff       	call   800330 <_panic>
	memmove(buf, &fsipcbuf, r);
  801d6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d70:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801d77:	00 
  801d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7b:	89 04 24             	mov    %eax,(%esp)
  801d7e:	e8 b9 ee ff ff       	call   800c3c <memmove>
	return r;
}
  801d83:	89 d8                	mov    %ebx,%eax
  801d85:	83 c4 10             	add    $0x10,%esp
  801d88:	5b                   	pop    %ebx
  801d89:	5e                   	pop    %esi
  801d8a:	5d                   	pop    %ebp
  801d8b:	c3                   	ret    

00801d8c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	56                   	push   %esi
  801d90:	53                   	push   %ebx
  801d91:	83 ec 20             	sub    $0x20,%esp
  801d94:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d97:	89 34 24             	mov    %esi,(%esp)
  801d9a:	e8 61 ec ff ff       	call   800a00 <strlen>
		return -E_BAD_PATH;
  801d9f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801da4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801da9:	7f 5e                	jg     801e09 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801dab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dae:	89 04 24             	mov    %eax,(%esp)
  801db1:	e8 35 f8 ff ff       	call   8015eb <fd_alloc>
  801db6:	89 c3                	mov    %eax,%ebx
  801db8:	85 c0                	test   %eax,%eax
  801dba:	78 4d                	js     801e09 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801dbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dc0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801dc7:	e8 7f ec ff ff       	call   800a4b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcf:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801dd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddc:	e8 1f fe ff ff       	call   801c00 <fsipc>
  801de1:	89 c3                	mov    %eax,%ebx
  801de3:	85 c0                	test   %eax,%eax
  801de5:	79 15                	jns    801dfc <open+0x70>
		fd_close(fd, 0);
  801de7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dee:	00 
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	89 04 24             	mov    %eax,(%esp)
  801df5:	e8 21 f9 ff ff       	call   80171b <fd_close>
		return r;
  801dfa:	eb 0d                	jmp    801e09 <open+0x7d>
	}

	return fd2num(fd);
  801dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dff:	89 04 24             	mov    %eax,(%esp)
  801e02:	e8 b9 f7 ff ff       	call   8015c0 <fd2num>
  801e07:	89 c3                	mov    %eax,%ebx
}
  801e09:	89 d8                	mov    %ebx,%eax
  801e0b:	83 c4 20             	add    $0x20,%esp
  801e0e:	5b                   	pop    %ebx
  801e0f:	5e                   	pop    %esi
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    
	...

00801e20 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 18             	sub    $0x18,%esp
  801e26:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e29:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e2c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	89 04 24             	mov    %eax,(%esp)
  801e35:	e8 96 f7 ff ff       	call   8015d0 <fd2data>
  801e3a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801e3c:	c7 44 24 04 cf 2e 80 	movl   $0x802ecf,0x4(%esp)
  801e43:	00 
  801e44:	89 34 24             	mov    %esi,(%esp)
  801e47:	e8 ff eb ff ff       	call   800a4b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e4c:	8b 43 04             	mov    0x4(%ebx),%eax
  801e4f:	2b 03                	sub    (%ebx),%eax
  801e51:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801e57:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801e5e:	00 00 00 
	stat->st_dev = &devpipe;
  801e61:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801e68:	30 80 00 
	return 0;
}
  801e6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e70:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e73:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e76:	89 ec                	mov    %ebp,%esp
  801e78:	5d                   	pop    %ebp
  801e79:	c3                   	ret    

00801e7a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	53                   	push   %ebx
  801e7e:	83 ec 14             	sub    $0x14,%esp
  801e81:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e84:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e8f:	e8 75 f1 ff ff       	call   801009 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e94:	89 1c 24             	mov    %ebx,(%esp)
  801e97:	e8 34 f7 ff ff       	call   8015d0 <fd2data>
  801e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ea7:	e8 5d f1 ff ff       	call   801009 <sys_page_unmap>
}
  801eac:	83 c4 14             	add    $0x14,%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5d                   	pop    %ebp
  801eb1:	c3                   	ret    

00801eb2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	57                   	push   %edi
  801eb6:	56                   	push   %esi
  801eb7:	53                   	push   %ebx
  801eb8:	83 ec 2c             	sub    $0x2c,%esp
  801ebb:	89 c7                	mov    %eax,%edi
  801ebd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801ec0:	a1 04 40 80 00       	mov    0x804004,%eax
  801ec5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ec8:	89 3c 24             	mov    %edi,(%esp)
  801ecb:	e8 a0 06 00 00       	call   802570 <pageref>
  801ed0:	89 c6                	mov    %eax,%esi
  801ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ed5:	89 04 24             	mov    %eax,(%esp)
  801ed8:	e8 93 06 00 00       	call   802570 <pageref>
  801edd:	39 c6                	cmp    %eax,%esi
  801edf:	0f 94 c0             	sete   %al
  801ee2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801ee5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801eeb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801eee:	39 cb                	cmp    %ecx,%ebx
  801ef0:	75 08                	jne    801efa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801ef2:	83 c4 2c             	add    $0x2c,%esp
  801ef5:	5b                   	pop    %ebx
  801ef6:	5e                   	pop    %esi
  801ef7:	5f                   	pop    %edi
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801efa:	83 f8 01             	cmp    $0x1,%eax
  801efd:	75 c1                	jne    801ec0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801eff:	8b 52 58             	mov    0x58(%edx),%edx
  801f02:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f06:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f0a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f0e:	c7 04 24 d6 2e 80 00 	movl   $0x802ed6,(%esp)
  801f15:	e8 11 e5 ff ff       	call   80042b <cprintf>
  801f1a:	eb a4                	jmp    801ec0 <_pipeisclosed+0xe>

00801f1c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	57                   	push   %edi
  801f20:	56                   	push   %esi
  801f21:	53                   	push   %ebx
  801f22:	83 ec 2c             	sub    $0x2c,%esp
  801f25:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f28:	89 34 24             	mov    %esi,(%esp)
  801f2b:	e8 a0 f6 ff ff       	call   8015d0 <fd2data>
  801f30:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f32:	bf 00 00 00 00       	mov    $0x0,%edi
  801f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f3b:	75 50                	jne    801f8d <devpipe_write+0x71>
  801f3d:	eb 5c                	jmp    801f9b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f3f:	89 da                	mov    %ebx,%edx
  801f41:	89 f0                	mov    %esi,%eax
  801f43:	e8 6a ff ff ff       	call   801eb2 <_pipeisclosed>
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	75 53                	jne    801f9f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f4c:	e8 cb ef ff ff       	call   800f1c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f51:	8b 43 04             	mov    0x4(%ebx),%eax
  801f54:	8b 13                	mov    (%ebx),%edx
  801f56:	83 c2 20             	add    $0x20,%edx
  801f59:	39 d0                	cmp    %edx,%eax
  801f5b:	73 e2                	jae    801f3f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f60:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801f64:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801f67:	89 c2                	mov    %eax,%edx
  801f69:	c1 fa 1f             	sar    $0x1f,%edx
  801f6c:	c1 ea 1b             	shr    $0x1b,%edx
  801f6f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801f72:	83 e1 1f             	and    $0x1f,%ecx
  801f75:	29 d1                	sub    %edx,%ecx
  801f77:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801f7b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801f7f:	83 c0 01             	add    $0x1,%eax
  801f82:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f85:	83 c7 01             	add    $0x1,%edi
  801f88:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f8b:	74 0e                	je     801f9b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f8d:	8b 43 04             	mov    0x4(%ebx),%eax
  801f90:	8b 13                	mov    (%ebx),%edx
  801f92:	83 c2 20             	add    $0x20,%edx
  801f95:	39 d0                	cmp    %edx,%eax
  801f97:	73 a6                	jae    801f3f <devpipe_write+0x23>
  801f99:	eb c2                	jmp    801f5d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f9b:	89 f8                	mov    %edi,%eax
  801f9d:	eb 05                	jmp    801fa4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801fa4:	83 c4 2c             	add    $0x2c,%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5f                   	pop    %edi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    

00801fac <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 28             	sub    $0x28,%esp
  801fb2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801fb5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801fb8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801fbb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801fbe:	89 3c 24             	mov    %edi,(%esp)
  801fc1:	e8 0a f6 ff ff       	call   8015d0 <fd2data>
  801fc6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fc8:	be 00 00 00 00       	mov    $0x0,%esi
  801fcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fd1:	75 47                	jne    80201a <devpipe_read+0x6e>
  801fd3:	eb 52                	jmp    802027 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801fd5:	89 f0                	mov    %esi,%eax
  801fd7:	eb 5e                	jmp    802037 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801fd9:	89 da                	mov    %ebx,%edx
  801fdb:	89 f8                	mov    %edi,%eax
  801fdd:	8d 76 00             	lea    0x0(%esi),%esi
  801fe0:	e8 cd fe ff ff       	call   801eb2 <_pipeisclosed>
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	75 49                	jne    802032 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801fe9:	e8 2e ef ff ff       	call   800f1c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801fee:	8b 03                	mov    (%ebx),%eax
  801ff0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ff3:	74 e4                	je     801fd9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ff5:	89 c2                	mov    %eax,%edx
  801ff7:	c1 fa 1f             	sar    $0x1f,%edx
  801ffa:	c1 ea 1b             	shr    $0x1b,%edx
  801ffd:	01 d0                	add    %edx,%eax
  801fff:	83 e0 1f             	and    $0x1f,%eax
  802002:	29 d0                	sub    %edx,%eax
  802004:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802009:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80200f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802012:	83 c6 01             	add    $0x1,%esi
  802015:	3b 75 10             	cmp    0x10(%ebp),%esi
  802018:	74 0d                	je     802027 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80201a:	8b 03                	mov    (%ebx),%eax
  80201c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80201f:	75 d4                	jne    801ff5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802021:	85 f6                	test   %esi,%esi
  802023:	75 b0                	jne    801fd5 <devpipe_read+0x29>
  802025:	eb b2                	jmp    801fd9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802027:	89 f0                	mov    %esi,%eax
  802029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802030:	eb 05                	jmp    802037 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802032:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802037:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80203a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80203d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802040:	89 ec                	mov    %ebp,%esp
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    

00802044 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 48             	sub    $0x48,%esp
  80204a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80204d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802050:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802053:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802056:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802059:	89 04 24             	mov    %eax,(%esp)
  80205c:	e8 8a f5 ff ff       	call   8015eb <fd_alloc>
  802061:	89 c3                	mov    %eax,%ebx
  802063:	85 c0                	test   %eax,%eax
  802065:	0f 88 45 01 00 00    	js     8021b0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80206b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802072:	00 
  802073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802076:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802081:	e8 c6 ee ff ff       	call   800f4c <sys_page_alloc>
  802086:	89 c3                	mov    %eax,%ebx
  802088:	85 c0                	test   %eax,%eax
  80208a:	0f 88 20 01 00 00    	js     8021b0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802090:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802093:	89 04 24             	mov    %eax,(%esp)
  802096:	e8 50 f5 ff ff       	call   8015eb <fd_alloc>
  80209b:	89 c3                	mov    %eax,%ebx
  80209d:	85 c0                	test   %eax,%eax
  80209f:	0f 88 f8 00 00 00    	js     80219d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020ac:	00 
  8020ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020bb:	e8 8c ee ff ff       	call   800f4c <sys_page_alloc>
  8020c0:	89 c3                	mov    %eax,%ebx
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	0f 88 d3 00 00 00    	js     80219d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8020ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020cd:	89 04 24             	mov    %eax,(%esp)
  8020d0:	e8 fb f4 ff ff       	call   8015d0 <fd2data>
  8020d5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020d7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020de:	00 
  8020df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ea:	e8 5d ee ff ff       	call   800f4c <sys_page_alloc>
  8020ef:	89 c3                	mov    %eax,%ebx
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	0f 88 91 00 00 00    	js     80218a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020fc:	89 04 24             	mov    %eax,(%esp)
  8020ff:	e8 cc f4 ff ff       	call   8015d0 <fd2data>
  802104:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80210b:	00 
  80210c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802110:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802117:	00 
  802118:	89 74 24 04          	mov    %esi,0x4(%esp)
  80211c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802123:	e8 83 ee ff ff       	call   800fab <sys_page_map>
  802128:	89 c3                	mov    %eax,%ebx
  80212a:	85 c0                	test   %eax,%eax
  80212c:	78 4c                	js     80217a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80212e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802137:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80213c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802143:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802149:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80214c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80214e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802151:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802158:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80215b:	89 04 24             	mov    %eax,(%esp)
  80215e:	e8 5d f4 ff ff       	call   8015c0 <fd2num>
  802163:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802165:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802168:	89 04 24             	mov    %eax,(%esp)
  80216b:	e8 50 f4 ff ff       	call   8015c0 <fd2num>
  802170:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802173:	bb 00 00 00 00       	mov    $0x0,%ebx
  802178:	eb 36                	jmp    8021b0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80217a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80217e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802185:	e8 7f ee ff ff       	call   801009 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80218a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80218d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802191:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802198:	e8 6c ee ff ff       	call   801009 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80219d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ab:	e8 59 ee ff ff       	call   801009 <sys_page_unmap>
    err:
	return r;
}
  8021b0:	89 d8                	mov    %ebx,%eax
  8021b2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8021b5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8021b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8021bb:	89 ec                	mov    %ebp,%esp
  8021bd:	5d                   	pop    %ebp
  8021be:	c3                   	ret    

008021bf <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	89 04 24             	mov    %eax,(%esp)
  8021d2:	e8 87 f4 ff ff       	call   80165e <fd_lookup>
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	78 15                	js     8021f0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021de:	89 04 24             	mov    %eax,(%esp)
  8021e1:	e8 ea f3 ff ff       	call   8015d0 <fd2data>
	return _pipeisclosed(fd, p);
  8021e6:	89 c2                	mov    %eax,%edx
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	e8 c2 fc ff ff       	call   801eb2 <_pipeisclosed>
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    
	...

00802200 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    

0080220a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802210:	c7 44 24 04 e9 2e 80 	movl   $0x802ee9,0x4(%esp)
  802217:	00 
  802218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221b:	89 04 24             	mov    %eax,(%esp)
  80221e:	e8 28 e8 ff ff       	call   800a4b <strcpy>
	return 0;
}
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	57                   	push   %edi
  80222e:	56                   	push   %esi
  80222f:	53                   	push   %ebx
  802230:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802236:	be 00 00 00 00       	mov    $0x0,%esi
  80223b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80223f:	74 43                	je     802284 <devcons_write+0x5a>
  802241:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802246:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80224c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80224f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802251:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802254:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802259:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80225c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802260:	03 45 0c             	add    0xc(%ebp),%eax
  802263:	89 44 24 04          	mov    %eax,0x4(%esp)
  802267:	89 3c 24             	mov    %edi,(%esp)
  80226a:	e8 cd e9 ff ff       	call   800c3c <memmove>
		sys_cputs(buf, m);
  80226f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802273:	89 3c 24             	mov    %edi,(%esp)
  802276:	e8 b5 eb ff ff       	call   800e30 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80227b:	01 de                	add    %ebx,%esi
  80227d:	89 f0                	mov    %esi,%eax
  80227f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802282:	72 c8                	jb     80224c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802284:	89 f0                	mov    %esi,%eax
  802286:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80228c:	5b                   	pop    %ebx
  80228d:	5e                   	pop    %esi
  80228e:	5f                   	pop    %edi
  80228f:	5d                   	pop    %ebp
  802290:	c3                   	ret    

00802291 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80229c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022a0:	75 07                	jne    8022a9 <devcons_read+0x18>
  8022a2:	eb 31                	jmp    8022d5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8022a4:	e8 73 ec ff ff       	call   800f1c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b0:	e8 aa eb ff ff       	call   800e5f <sys_cgetc>
  8022b5:	85 c0                	test   %eax,%eax
  8022b7:	74 eb                	je     8022a4 <devcons_read+0x13>
  8022b9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	78 16                	js     8022d5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8022bf:	83 f8 04             	cmp    $0x4,%eax
  8022c2:	74 0c                	je     8022d0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  8022c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c7:	88 10                	mov    %dl,(%eax)
	return 1;
  8022c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ce:	eb 05                	jmp    8022d5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8022d0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022e3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022ea:	00 
  8022eb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022ee:	89 04 24             	mov    %eax,(%esp)
  8022f1:	e8 3a eb ff ff       	call   800e30 <sys_cputs>
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <getchar>:

int
getchar(void)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802305:	00 
  802306:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802309:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802314:	e8 05 f6 ff ff       	call   80191e <read>
	if (r < 0)
  802319:	85 c0                	test   %eax,%eax
  80231b:	78 0f                	js     80232c <getchar+0x34>
		return r;
	if (r < 1)
  80231d:	85 c0                	test   %eax,%eax
  80231f:	7e 06                	jle    802327 <getchar+0x2f>
		return -E_EOF;
	return c;
  802321:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802325:	eb 05                	jmp    80232c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802327:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802334:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802337:	89 44 24 04          	mov    %eax,0x4(%esp)
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	89 04 24             	mov    %eax,(%esp)
  802341:	e8 18 f3 ff ff       	call   80165e <fd_lookup>
  802346:	85 c0                	test   %eax,%eax
  802348:	78 11                	js     80235b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802353:	39 10                	cmp    %edx,(%eax)
  802355:	0f 94 c0             	sete   %al
  802358:	0f b6 c0             	movzbl %al,%eax
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <opencons>:

int
opencons(void)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802363:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802366:	89 04 24             	mov    %eax,(%esp)
  802369:	e8 7d f2 ff ff       	call   8015eb <fd_alloc>
  80236e:	85 c0                	test   %eax,%eax
  802370:	78 3c                	js     8023ae <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802372:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802379:	00 
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802381:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802388:	e8 bf eb ff ff       	call   800f4c <sys_page_alloc>
  80238d:	85 c0                	test   %eax,%eax
  80238f:	78 1d                	js     8023ae <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802391:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023a6:	89 04 24             	mov    %eax,(%esp)
  8023a9:	e8 12 f2 ff ff       	call   8015c0 <fd2num>
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8023b6:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8023bd:	75 54                	jne    802413 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  8023bf:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8023c6:	00 
  8023c7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8023ce:	ee 
  8023cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d6:	e8 71 eb ff ff       	call   800f4c <sys_page_alloc>
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	79 20                	jns    8023ff <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  8023df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023e3:	c7 44 24 08 f5 2e 80 	movl   $0x802ef5,0x8(%esp)
  8023ea:	00 
  8023eb:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8023f2:	00 
  8023f3:	c7 04 24 0d 2f 80 00 	movl   $0x802f0d,(%esp)
  8023fa:	e8 31 df ff ff       	call   800330 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8023ff:	c7 44 24 04 20 24 80 	movl   $0x802420,0x4(%esp)
  802406:	00 
  802407:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80240e:	e8 10 ed ff ff       	call   801123 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    
  80241d:	00 00                	add    %al,(%eax)
	...

00802420 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802420:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802421:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802426:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802428:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  80242b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  80242f:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  802432:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  802436:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  80243a:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  80243c:	83 c4 08             	add    $0x8,%esp
	popal
  80243f:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802440:	83 c4 04             	add    $0x4,%esp
	popfl
  802443:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802444:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802445:	c3                   	ret    
	...

00802450 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	56                   	push   %esi
  802454:	53                   	push   %ebx
  802455:	83 ec 10             	sub    $0x10,%esp
  802458:	8b 75 08             	mov    0x8(%ebp),%esi
  80245b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802461:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802463:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802468:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80246b:	89 04 24             	mov    %eax,(%esp)
  80246e:	e8 42 ed ff ff       	call   8011b5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802473:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802478:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80247d:	85 c0                	test   %eax,%eax
  80247f:	78 0e                	js     80248f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  802481:	a1 04 40 80 00       	mov    0x804004,%eax
  802486:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  802489:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80248c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80248f:	85 f6                	test   %esi,%esi
  802491:	74 02                	je     802495 <ipc_recv+0x45>
		*from_env_store = sender;
  802493:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  802495:	85 db                	test   %ebx,%ebx
  802497:	74 02                	je     80249b <ipc_recv+0x4b>
		*perm_store = perm;
  802499:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80249b:	83 c4 10             	add    $0x10,%esp
  80249e:	5b                   	pop    %ebx
  80249f:	5e                   	pop    %esi
  8024a0:	5d                   	pop    %ebp
  8024a1:	c3                   	ret    

008024a2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
  8024a5:	57                   	push   %edi
  8024a6:	56                   	push   %esi
  8024a7:	53                   	push   %ebx
  8024a8:	83 ec 1c             	sub    $0x1c,%esp
  8024ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8024ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024b1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  8024b4:	85 db                	test   %ebx,%ebx
  8024b6:	75 04                	jne    8024bc <ipc_send+0x1a>
  8024b8:	85 f6                	test   %esi,%esi
  8024ba:	75 15                	jne    8024d1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  8024bc:	85 db                	test   %ebx,%ebx
  8024be:	74 16                	je     8024d6 <ipc_send+0x34>
  8024c0:	85 f6                	test   %esi,%esi
  8024c2:	0f 94 c0             	sete   %al
      pg = 0;
  8024c5:	84 c0                	test   %al,%al
  8024c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cc:	0f 45 d8             	cmovne %eax,%ebx
  8024cf:	eb 05                	jmp    8024d6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  8024d1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  8024d6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8024da:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	89 04 24             	mov    %eax,(%esp)
  8024e8:	e8 94 ec ff ff       	call   801181 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  8024ed:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024f0:	75 07                	jne    8024f9 <ipc_send+0x57>
           sys_yield();
  8024f2:	e8 25 ea ff ff       	call   800f1c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  8024f7:	eb dd                	jmp    8024d6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	90                   	nop
  8024fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802500:	74 1c                	je     80251e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802502:	c7 44 24 08 1b 2f 80 	movl   $0x802f1b,0x8(%esp)
  802509:	00 
  80250a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802511:	00 
  802512:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  802519:	e8 12 de ff ff       	call   800330 <_panic>
		}
    }
}
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    

00802526 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80252c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802531:	39 c8                	cmp    %ecx,%eax
  802533:	74 17                	je     80254c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802535:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80253a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80253d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802543:	8b 52 50             	mov    0x50(%edx),%edx
  802546:	39 ca                	cmp    %ecx,%edx
  802548:	75 14                	jne    80255e <ipc_find_env+0x38>
  80254a:	eb 05                	jmp    802551 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802551:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802554:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802559:	8b 40 40             	mov    0x40(%eax),%eax
  80255c:	eb 0e                	jmp    80256c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80255e:	83 c0 01             	add    $0x1,%eax
  802561:	3d 00 04 00 00       	cmp    $0x400,%eax
  802566:	75 d2                	jne    80253a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802568:	66 b8 00 00          	mov    $0x0,%ax
}
  80256c:	5d                   	pop    %ebp
  80256d:	c3                   	ret    
	...

00802570 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802576:	89 d0                	mov    %edx,%eax
  802578:	c1 e8 16             	shr    $0x16,%eax
  80257b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802582:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802587:	f6 c1 01             	test   $0x1,%cl
  80258a:	74 1d                	je     8025a9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80258c:	c1 ea 0c             	shr    $0xc,%edx
  80258f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802596:	f6 c2 01             	test   $0x1,%dl
  802599:	74 0e                	je     8025a9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80259b:	c1 ea 0c             	shr    $0xc,%edx
  80259e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025a5:	ef 
  8025a6:	0f b7 c0             	movzwl %ax,%eax
}
  8025a9:	5d                   	pop    %ebp
  8025aa:	c3                   	ret    
  8025ab:	00 00                	add    %al,(%eax)
  8025ad:	00 00                	add    %al,(%eax)
	...

008025b0 <__udivdi3>:
  8025b0:	83 ec 1c             	sub    $0x1c,%esp
  8025b3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8025b7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8025bb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8025bf:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8025c3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8025c7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8025cb:	85 ff                	test   %edi,%edi
  8025cd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8025d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025d5:	89 cd                	mov    %ecx,%ebp
  8025d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025db:	75 33                	jne    802610 <__udivdi3+0x60>
  8025dd:	39 f1                	cmp    %esi,%ecx
  8025df:	77 57                	ja     802638 <__udivdi3+0x88>
  8025e1:	85 c9                	test   %ecx,%ecx
  8025e3:	75 0b                	jne    8025f0 <__udivdi3+0x40>
  8025e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ea:	31 d2                	xor    %edx,%edx
  8025ec:	f7 f1                	div    %ecx
  8025ee:	89 c1                	mov    %eax,%ecx
  8025f0:	89 f0                	mov    %esi,%eax
  8025f2:	31 d2                	xor    %edx,%edx
  8025f4:	f7 f1                	div    %ecx
  8025f6:	89 c6                	mov    %eax,%esi
  8025f8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025fc:	f7 f1                	div    %ecx
  8025fe:	89 f2                	mov    %esi,%edx
  802600:	8b 74 24 10          	mov    0x10(%esp),%esi
  802604:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802608:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80260c:	83 c4 1c             	add    $0x1c,%esp
  80260f:	c3                   	ret    
  802610:	31 d2                	xor    %edx,%edx
  802612:	31 c0                	xor    %eax,%eax
  802614:	39 f7                	cmp    %esi,%edi
  802616:	77 e8                	ja     802600 <__udivdi3+0x50>
  802618:	0f bd cf             	bsr    %edi,%ecx
  80261b:	83 f1 1f             	xor    $0x1f,%ecx
  80261e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802622:	75 2c                	jne    802650 <__udivdi3+0xa0>
  802624:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802628:	76 04                	jbe    80262e <__udivdi3+0x7e>
  80262a:	39 f7                	cmp    %esi,%edi
  80262c:	73 d2                	jae    802600 <__udivdi3+0x50>
  80262e:	31 d2                	xor    %edx,%edx
  802630:	b8 01 00 00 00       	mov    $0x1,%eax
  802635:	eb c9                	jmp    802600 <__udivdi3+0x50>
  802637:	90                   	nop
  802638:	89 f2                	mov    %esi,%edx
  80263a:	f7 f1                	div    %ecx
  80263c:	31 d2                	xor    %edx,%edx
  80263e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802642:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802646:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80264a:	83 c4 1c             	add    $0x1c,%esp
  80264d:	c3                   	ret    
  80264e:	66 90                	xchg   %ax,%ax
  802650:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802655:	b8 20 00 00 00       	mov    $0x20,%eax
  80265a:	89 ea                	mov    %ebp,%edx
  80265c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802660:	d3 e7                	shl    %cl,%edi
  802662:	89 c1                	mov    %eax,%ecx
  802664:	d3 ea                	shr    %cl,%edx
  802666:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80266b:	09 fa                	or     %edi,%edx
  80266d:	89 f7                	mov    %esi,%edi
  80266f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802673:	89 f2                	mov    %esi,%edx
  802675:	8b 74 24 08          	mov    0x8(%esp),%esi
  802679:	d3 e5                	shl    %cl,%ebp
  80267b:	89 c1                	mov    %eax,%ecx
  80267d:	d3 ef                	shr    %cl,%edi
  80267f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802684:	d3 e2                	shl    %cl,%edx
  802686:	89 c1                	mov    %eax,%ecx
  802688:	d3 ee                	shr    %cl,%esi
  80268a:	09 d6                	or     %edx,%esi
  80268c:	89 fa                	mov    %edi,%edx
  80268e:	89 f0                	mov    %esi,%eax
  802690:	f7 74 24 0c          	divl   0xc(%esp)
  802694:	89 d7                	mov    %edx,%edi
  802696:	89 c6                	mov    %eax,%esi
  802698:	f7 e5                	mul    %ebp
  80269a:	39 d7                	cmp    %edx,%edi
  80269c:	72 22                	jb     8026c0 <__udivdi3+0x110>
  80269e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8026a2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026a7:	d3 e5                	shl    %cl,%ebp
  8026a9:	39 c5                	cmp    %eax,%ebp
  8026ab:	73 04                	jae    8026b1 <__udivdi3+0x101>
  8026ad:	39 d7                	cmp    %edx,%edi
  8026af:	74 0f                	je     8026c0 <__udivdi3+0x110>
  8026b1:	89 f0                	mov    %esi,%eax
  8026b3:	31 d2                	xor    %edx,%edx
  8026b5:	e9 46 ff ff ff       	jmp    802600 <__udivdi3+0x50>
  8026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026c0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8026c3:	31 d2                	xor    %edx,%edx
  8026c5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026c9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026cd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026d1:	83 c4 1c             	add    $0x1c,%esp
  8026d4:	c3                   	ret    
	...

008026e0 <__umoddi3>:
  8026e0:	83 ec 1c             	sub    $0x1c,%esp
  8026e3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8026e7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8026eb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8026ef:	89 74 24 10          	mov    %esi,0x10(%esp)
  8026f3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8026f7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8026fb:	85 ed                	test   %ebp,%ebp
  8026fd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802701:	89 44 24 08          	mov    %eax,0x8(%esp)
  802705:	89 cf                	mov    %ecx,%edi
  802707:	89 04 24             	mov    %eax,(%esp)
  80270a:	89 f2                	mov    %esi,%edx
  80270c:	75 1a                	jne    802728 <__umoddi3+0x48>
  80270e:	39 f1                	cmp    %esi,%ecx
  802710:	76 4e                	jbe    802760 <__umoddi3+0x80>
  802712:	f7 f1                	div    %ecx
  802714:	89 d0                	mov    %edx,%eax
  802716:	31 d2                	xor    %edx,%edx
  802718:	8b 74 24 10          	mov    0x10(%esp),%esi
  80271c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802720:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802724:	83 c4 1c             	add    $0x1c,%esp
  802727:	c3                   	ret    
  802728:	39 f5                	cmp    %esi,%ebp
  80272a:	77 54                	ja     802780 <__umoddi3+0xa0>
  80272c:	0f bd c5             	bsr    %ebp,%eax
  80272f:	83 f0 1f             	xor    $0x1f,%eax
  802732:	89 44 24 04          	mov    %eax,0x4(%esp)
  802736:	75 60                	jne    802798 <__umoddi3+0xb8>
  802738:	3b 0c 24             	cmp    (%esp),%ecx
  80273b:	0f 87 07 01 00 00    	ja     802848 <__umoddi3+0x168>
  802741:	89 f2                	mov    %esi,%edx
  802743:	8b 34 24             	mov    (%esp),%esi
  802746:	29 ce                	sub    %ecx,%esi
  802748:	19 ea                	sbb    %ebp,%edx
  80274a:	89 34 24             	mov    %esi,(%esp)
  80274d:	8b 04 24             	mov    (%esp),%eax
  802750:	8b 74 24 10          	mov    0x10(%esp),%esi
  802754:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802758:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80275c:	83 c4 1c             	add    $0x1c,%esp
  80275f:	c3                   	ret    
  802760:	85 c9                	test   %ecx,%ecx
  802762:	75 0b                	jne    80276f <__umoddi3+0x8f>
  802764:	b8 01 00 00 00       	mov    $0x1,%eax
  802769:	31 d2                	xor    %edx,%edx
  80276b:	f7 f1                	div    %ecx
  80276d:	89 c1                	mov    %eax,%ecx
  80276f:	89 f0                	mov    %esi,%eax
  802771:	31 d2                	xor    %edx,%edx
  802773:	f7 f1                	div    %ecx
  802775:	8b 04 24             	mov    (%esp),%eax
  802778:	f7 f1                	div    %ecx
  80277a:	eb 98                	jmp    802714 <__umoddi3+0x34>
  80277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802780:	89 f2                	mov    %esi,%edx
  802782:	8b 74 24 10          	mov    0x10(%esp),%esi
  802786:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80278a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80278e:	83 c4 1c             	add    $0x1c,%esp
  802791:	c3                   	ret    
  802792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802798:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80279d:	89 e8                	mov    %ebp,%eax
  80279f:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027a4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8027a8:	89 fa                	mov    %edi,%edx
  8027aa:	d3 e0                	shl    %cl,%eax
  8027ac:	89 e9                	mov    %ebp,%ecx
  8027ae:	d3 ea                	shr    %cl,%edx
  8027b0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027b5:	09 c2                	or     %eax,%edx
  8027b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027bb:	89 14 24             	mov    %edx,(%esp)
  8027be:	89 f2                	mov    %esi,%edx
  8027c0:	d3 e7                	shl    %cl,%edi
  8027c2:	89 e9                	mov    %ebp,%ecx
  8027c4:	d3 ea                	shr    %cl,%edx
  8027c6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027cf:	d3 e6                	shl    %cl,%esi
  8027d1:	89 e9                	mov    %ebp,%ecx
  8027d3:	d3 e8                	shr    %cl,%eax
  8027d5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027da:	09 f0                	or     %esi,%eax
  8027dc:	8b 74 24 08          	mov    0x8(%esp),%esi
  8027e0:	f7 34 24             	divl   (%esp)
  8027e3:	d3 e6                	shl    %cl,%esi
  8027e5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027e9:	89 d6                	mov    %edx,%esi
  8027eb:	f7 e7                	mul    %edi
  8027ed:	39 d6                	cmp    %edx,%esi
  8027ef:	89 c1                	mov    %eax,%ecx
  8027f1:	89 d7                	mov    %edx,%edi
  8027f3:	72 3f                	jb     802834 <__umoddi3+0x154>
  8027f5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8027f9:	72 35                	jb     802830 <__umoddi3+0x150>
  8027fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027ff:	29 c8                	sub    %ecx,%eax
  802801:	19 fe                	sbb    %edi,%esi
  802803:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802808:	89 f2                	mov    %esi,%edx
  80280a:	d3 e8                	shr    %cl,%eax
  80280c:	89 e9                	mov    %ebp,%ecx
  80280e:	d3 e2                	shl    %cl,%edx
  802810:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802815:	09 d0                	or     %edx,%eax
  802817:	89 f2                	mov    %esi,%edx
  802819:	d3 ea                	shr    %cl,%edx
  80281b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80281f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802823:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802827:	83 c4 1c             	add    $0x1c,%esp
  80282a:	c3                   	ret    
  80282b:	90                   	nop
  80282c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802830:	39 d6                	cmp    %edx,%esi
  802832:	75 c7                	jne    8027fb <__umoddi3+0x11b>
  802834:	89 d7                	mov    %edx,%edi
  802836:	89 c1                	mov    %eax,%ecx
  802838:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80283c:	1b 3c 24             	sbb    (%esp),%edi
  80283f:	eb ba                	jmp    8027fb <__umoddi3+0x11b>
  802841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802848:	39 f5                	cmp    %esi,%ebp
  80284a:	0f 82 f1 fe ff ff    	jb     802741 <__umoddi3+0x61>
  802850:	e9 f8 fe ff ff       	jmp    80274d <__umoddi3+0x6d>
