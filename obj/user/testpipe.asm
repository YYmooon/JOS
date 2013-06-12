
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 e7 02 00 00       	call   800318 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 c4 80             	add    $0xffffff80,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003c:	c7 05 04 40 80 00 20 	movl   $0x802920,0x804004
  800043:	29 80 00 

	if ((i = pipe(p)) < 0)
  800046:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 43 20 00 00       	call   802094 <pipe>
  800051:	89 c6                	mov    %eax,%esi
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x43>
		panic("pipe: %e", i);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 2c 29 80 	movl   $0x80292c,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 35 29 80 00 	movl   $0x802935,(%esp)
  800072:	e8 0d 03 00 00       	call   800384 <_panic>

	if ((pid = fork()) < 0)
  800077:	e8 e7 12 00 00       	call   801363 <fork>
  80007c:	89 c3                	mov    %eax,%ebx
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6e>
		panic("fork: %e", i);
  800082:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800086:	c7 44 24 08 35 2f 80 	movl   $0x802f35,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 35 29 80 00 	movl   $0x802935,(%esp)
  80009d:	e8 e2 02 00 00       	call   800384 <_panic>

	if (pid == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	0f 85 d5 00 00 00    	jne    80017f <umain+0x14b>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  8000aa:	a1 04 50 80 00       	mov    0x805004,%eax
  8000af:	8b 40 48             	mov    0x48(%eax),%eax
  8000b2:	8b 55 90             	mov    -0x70(%ebp),%edx
  8000b5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bd:	c7 04 24 45 29 80 00 	movl   $0x802945,(%esp)
  8000c4:	e8 b6 03 00 00       	call   80047f <cprintf>
		close(p[1]);
  8000c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000cc:	89 04 24             	mov    %eax,(%esp)
  8000cf:	e8 29 17 00 00       	call   8017fd <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  8000d4:	a1 04 50 80 00       	mov    0x805004,%eax
  8000d9:	8b 40 48             	mov    0x48(%eax),%eax
  8000dc:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8000df:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e7:	c7 04 24 62 29 80 00 	movl   $0x802962,(%esp)
  8000ee:	e8 8c 03 00 00       	call   80047f <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000f3:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000fa:	00 
  8000fb:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800102:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800105:	89 04 24             	mov    %eax,(%esp)
  800108:	e8 f1 18 00 00       	call   8019fe <readn>
  80010d:	89 c6                	mov    %eax,%esi
		if (i < 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	79 20                	jns    800133 <umain+0xff>
			panic("read: %e", i);
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 35 29 80 00 	movl   $0x802935,(%esp)
  80012e:	e8 51 02 00 00       	call   800384 <_panic>
		buf[i] = 0;
  800133:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  800138:	a1 00 40 80 00       	mov    0x804000,%eax
  80013d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800141:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800144:	89 04 24             	mov    %eax,(%esp)
  800147:	e8 0f 0a 00 00       	call   800b5b <strcmp>
  80014c:	85 c0                	test   %eax,%eax
  80014e:	75 0e                	jne    80015e <umain+0x12a>
			cprintf("\npipe read closed properly\n");
  800150:	c7 04 24 88 29 80 00 	movl   $0x802988,(%esp)
  800157:	e8 23 03 00 00       	call   80047f <cprintf>
  80015c:	eb 17                	jmp    800175 <umain+0x141>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  80015e:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800161:	89 44 24 08          	mov    %eax,0x8(%esp)
  800165:	89 74 24 04          	mov    %esi,0x4(%esp)
  800169:	c7 04 24 a4 29 80 00 	movl   $0x8029a4,(%esp)
  800170:	e8 0a 03 00 00       	call   80047f <cprintf>
		exit();
  800175:	e8 ee 01 00 00       	call   800368 <exit>
  80017a:	e9 ac 00 00 00       	jmp    80022b <umain+0x1f7>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80017f:	a1 04 50 80 00       	mov    0x805004,%eax
  800184:	8b 40 48             	mov    0x48(%eax),%eax
  800187:	8b 55 8c             	mov    -0x74(%ebp),%edx
  80018a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80018e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800192:	c7 04 24 45 29 80 00 	movl   $0x802945,(%esp)
  800199:	e8 e1 02 00 00       	call   80047f <cprintf>
		close(p[0]);
  80019e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8001a1:	89 04 24             	mov    %eax,(%esp)
  8001a4:	e8 54 16 00 00       	call   8017fd <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001a9:	a1 04 50 80 00       	mov    0x805004,%eax
  8001ae:	8b 40 48             	mov    0x48(%eax),%eax
  8001b1:	8b 55 90             	mov    -0x70(%ebp),%edx
  8001b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bc:	c7 04 24 b7 29 80 00 	movl   $0x8029b7,(%esp)
  8001c3:	e8 b7 02 00 00       	call   80047f <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8001c8:	a1 00 40 80 00       	mov    0x804000,%eax
  8001cd:	89 04 24             	mov    %eax,(%esp)
  8001d0:	e8 7b 08 00 00       	call   800a50 <strlen>
  8001d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d9:	a1 00 40 80 00       	mov    0x804000,%eax
  8001de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001e5:	89 04 24             	mov    %eax,(%esp)
  8001e8:	e8 61 18 00 00       	call   801a4e <write>
  8001ed:	89 c6                	mov    %eax,%esi
  8001ef:	a1 00 40 80 00       	mov    0x804000,%eax
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 54 08 00 00       	call   800a50 <strlen>
  8001fc:	39 c6                	cmp    %eax,%esi
  8001fe:	74 20                	je     800220 <umain+0x1ec>
			panic("write: %e", i);
  800200:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800204:	c7 44 24 08 d4 29 80 	movl   $0x8029d4,0x8(%esp)
  80020b:	00 
  80020c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800213:	00 
  800214:	c7 04 24 35 29 80 00 	movl   $0x802935,(%esp)
  80021b:	e8 64 01 00 00       	call   800384 <_panic>
		close(p[1]);
  800220:	8b 45 90             	mov    -0x70(%ebp),%eax
  800223:	89 04 24             	mov    %eax,(%esp)
  800226:	e8 d2 15 00 00       	call   8017fd <close>
	}
	wait(pid);
  80022b:	89 1c 24             	mov    %ebx,(%esp)
  80022e:	e8 11 20 00 00       	call   802244 <wait>

	binaryname = "pipewriteeof";
  800233:	c7 05 04 40 80 00 de 	movl   $0x8029de,0x804004
  80023a:	29 80 00 
	if ((i = pipe(p)) < 0)
  80023d:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800240:	89 04 24             	mov    %eax,(%esp)
  800243:	e8 4c 1e 00 00       	call   802094 <pipe>
  800248:	89 c6                	mov    %eax,%esi
  80024a:	85 c0                	test   %eax,%eax
  80024c:	79 20                	jns    80026e <umain+0x23a>
		panic("pipe: %e", i);
  80024e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800252:	c7 44 24 08 2c 29 80 	movl   $0x80292c,0x8(%esp)
  800259:	00 
  80025a:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  800261:	00 
  800262:	c7 04 24 35 29 80 00 	movl   $0x802935,(%esp)
  800269:	e8 16 01 00 00       	call   800384 <_panic>

	if ((pid = fork()) < 0)
  80026e:	e8 f0 10 00 00       	call   801363 <fork>
  800273:	89 c3                	mov    %eax,%ebx
  800275:	85 c0                	test   %eax,%eax
  800277:	79 20                	jns    800299 <umain+0x265>
		panic("fork: %e", i);
  800279:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80027d:	c7 44 24 08 35 2f 80 	movl   $0x802f35,0x8(%esp)
  800284:	00 
  800285:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  80028c:	00 
  80028d:	c7 04 24 35 29 80 00 	movl   $0x802935,(%esp)
  800294:	e8 eb 00 00 00       	call   800384 <_panic>

	if (pid == 0) {
  800299:	85 c0                	test   %eax,%eax
  80029b:	75 48                	jne    8002e5 <umain+0x2b1>
		close(p[0]);
  80029d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002a0:	89 04 24             	mov    %eax,(%esp)
  8002a3:	e8 55 15 00 00       	call   8017fd <close>
		while (1) {
			cprintf(".");
  8002a8:	c7 04 24 eb 29 80 00 	movl   $0x8029eb,(%esp)
  8002af:	e8 cb 01 00 00       	call   80047f <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002bb:	00 
  8002bc:	c7 44 24 04 ed 29 80 	movl   $0x8029ed,0x4(%esp)
  8002c3:	00 
  8002c4:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002c7:	89 04 24             	mov    %eax,(%esp)
  8002ca:	e8 7f 17 00 00       	call   801a4e <write>
  8002cf:	83 f8 01             	cmp    $0x1,%eax
  8002d2:	74 d4                	je     8002a8 <umain+0x274>
				break;
		}
		cprintf("\npipe write closed properly\n");
  8002d4:	c7 04 24 ef 29 80 00 	movl   $0x8029ef,(%esp)
  8002db:	e8 9f 01 00 00       	call   80047f <cprintf>
		exit();
  8002e0:	e8 83 00 00 00       	call   800368 <exit>
	}
	close(p[0]);
  8002e5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002e8:	89 04 24             	mov    %eax,(%esp)
  8002eb:	e8 0d 15 00 00       	call   8017fd <close>
	close(p[1]);
  8002f0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002f3:	89 04 24             	mov    %eax,(%esp)
  8002f6:	e8 02 15 00 00       	call   8017fd <close>
	wait(pid);
  8002fb:	89 1c 24             	mov    %ebx,(%esp)
  8002fe:	e8 41 1f 00 00       	call   802244 <wait>

	cprintf("pipe tests passed\n");
  800303:	c7 04 24 0c 2a 80 00 	movl   $0x802a0c,(%esp)
  80030a:	e8 70 01 00 00       	call   80047f <cprintf>
}
  80030f:	83 ec 80             	sub    $0xffffff80,%esp
  800312:	5b                   	pop    %ebx
  800313:	5e                   	pop    %esi
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    
	...

00800318 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 18             	sub    $0x18,%esp
  80031e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800321:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800324:	8b 75 08             	mov    0x8(%ebp),%esi
  800327:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80032a:	e8 0d 0c 00 00       	call   800f3c <sys_getenvid>
  80032f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800334:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800337:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80033c:	a3 04 50 80 00       	mov    %eax,0x805004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800341:	85 f6                	test   %esi,%esi
  800343:	7e 07                	jle    80034c <libmain+0x34>
		binaryname = argv[0];
  800345:	8b 03                	mov    (%ebx),%eax
  800347:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  80034c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800350:	89 34 24             	mov    %esi,(%esp)
  800353:	e8 dc fc ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800358:	e8 0b 00 00 00       	call   800368 <exit>
}
  80035d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800360:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800363:	89 ec                	mov    %ebp,%esp
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    
	...

00800368 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80036e:	e8 bb 14 00 00       	call   80182e <close_all>
	sys_env_destroy(0);
  800373:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80037a:	e8 60 0b 00 00       	call   800edf <sys_env_destroy>
}
  80037f:	c9                   	leave  
  800380:	c3                   	ret    
  800381:	00 00                	add    %al,(%eax)
	...

00800384 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	56                   	push   %esi
  800388:	53                   	push   %ebx
  800389:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80038c:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80038f:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
  800395:	e8 a2 0b 00 00       	call   800f3c <sys_getenvid>
  80039a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039d:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b0:	c7 04 24 70 2a 80 00 	movl   $0x802a70,(%esp)
  8003b7:	e8 c3 00 00 00       	call   80047f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c3:	89 04 24             	mov    %eax,(%esp)
  8003c6:	e8 53 00 00 00       	call   80041e <vcprintf>
	cprintf("\n");
  8003cb:	c7 04 24 60 29 80 00 	movl   $0x802960,(%esp)
  8003d2:	e8 a8 00 00 00       	call   80047f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003d7:	cc                   	int3   
  8003d8:	eb fd                	jmp    8003d7 <_panic+0x53>
	...

008003dc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	53                   	push   %ebx
  8003e0:	83 ec 14             	sub    $0x14,%esp
  8003e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003e6:	8b 03                	mov    (%ebx),%eax
  8003e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8003eb:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8003ef:	83 c0 01             	add    $0x1,%eax
  8003f2:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8003f4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003f9:	75 19                	jne    800414 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003fb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800402:	00 
  800403:	8d 43 08             	lea    0x8(%ebx),%eax
  800406:	89 04 24             	mov    %eax,(%esp)
  800409:	e8 72 0a 00 00       	call   800e80 <sys_cputs>
		b->idx = 0;
  80040e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800414:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800418:	83 c4 14             	add    $0x14,%esp
  80041b:	5b                   	pop    %ebx
  80041c:	5d                   	pop    %ebp
  80041d:	c3                   	ret    

0080041e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800427:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80042e:	00 00 00 
	b.cnt = 0;
  800431:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800438:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80043b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	89 44 24 08          	mov    %eax,0x8(%esp)
  800449:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80044f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800453:	c7 04 24 dc 03 80 00 	movl   $0x8003dc,(%esp)
  80045a:	e8 9b 01 00 00       	call   8005fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80045f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800465:	89 44 24 04          	mov    %eax,0x4(%esp)
  800469:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80046f:	89 04 24             	mov    %eax,(%esp)
  800472:	e8 09 0a 00 00       	call   800e80 <sys_cputs>

	return b.cnt;
}
  800477:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80047d:	c9                   	leave  
  80047e:	c3                   	ret    

0080047f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800485:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800488:	89 44 24 04          	mov    %eax,0x4(%esp)
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	89 04 24             	mov    %eax,(%esp)
  800492:	e8 87 ff ff ff       	call   80041e <vcprintf>
	va_end(ap);

	return cnt;
}
  800497:	c9                   	leave  
  800498:	c3                   	ret    
  800499:	00 00                	add    %al,(%eax)
  80049b:	00 00                	add    %al,(%eax)
  80049d:	00 00                	add    %al,(%eax)
	...

008004a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	57                   	push   %edi
  8004a4:	56                   	push   %esi
  8004a5:	53                   	push   %ebx
  8004a6:	83 ec 3c             	sub    $0x3c,%esp
  8004a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ac:	89 d7                	mov    %edx,%edi
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004bd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004c8:	72 11                	jb     8004db <printnum+0x3b>
  8004ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004cd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8004d0:	76 09                	jbe    8004db <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004d2:	83 eb 01             	sub    $0x1,%ebx
  8004d5:	85 db                	test   %ebx,%ebx
  8004d7:	7f 51                	jg     80052a <printnum+0x8a>
  8004d9:	eb 5e                	jmp    800539 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004db:	89 74 24 10          	mov    %esi,0x10(%esp)
  8004df:	83 eb 01             	sub    $0x1,%ebx
  8004e2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004ed:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8004f1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8004f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004fc:	00 
  8004fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800500:	89 04 24             	mov    %eax,(%esp)
  800503:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800506:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050a:	e8 51 21 00 00       	call   802660 <__udivdi3>
  80050f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800513:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800517:	89 04 24             	mov    %eax,(%esp)
  80051a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80051e:	89 fa                	mov    %edi,%edx
  800520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800523:	e8 78 ff ff ff       	call   8004a0 <printnum>
  800528:	eb 0f                	jmp    800539 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80052a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052e:	89 34 24             	mov    %esi,(%esp)
  800531:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800534:	83 eb 01             	sub    $0x1,%ebx
  800537:	75 f1                	jne    80052a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800539:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800541:	8b 45 10             	mov    0x10(%ebp),%eax
  800544:	89 44 24 08          	mov    %eax,0x8(%esp)
  800548:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80054f:	00 
  800550:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800553:	89 04 24             	mov    %eax,(%esp)
  800556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800559:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055d:	e8 2e 22 00 00       	call   802790 <__umoddi3>
  800562:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800566:	0f be 80 93 2a 80 00 	movsbl 0x802a93(%eax),%eax
  80056d:	89 04 24             	mov    %eax,(%esp)
  800570:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800573:	83 c4 3c             	add    $0x3c,%esp
  800576:	5b                   	pop    %ebx
  800577:	5e                   	pop    %esi
  800578:	5f                   	pop    %edi
  800579:	5d                   	pop    %ebp
  80057a:	c3                   	ret    

0080057b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057b:	55                   	push   %ebp
  80057c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80057e:	83 fa 01             	cmp    $0x1,%edx
  800581:	7e 0e                	jle    800591 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800583:	8b 10                	mov    (%eax),%edx
  800585:	8d 4a 08             	lea    0x8(%edx),%ecx
  800588:	89 08                	mov    %ecx,(%eax)
  80058a:	8b 02                	mov    (%edx),%eax
  80058c:	8b 52 04             	mov    0x4(%edx),%edx
  80058f:	eb 22                	jmp    8005b3 <getuint+0x38>
	else if (lflag)
  800591:	85 d2                	test   %edx,%edx
  800593:	74 10                	je     8005a5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800595:	8b 10                	mov    (%eax),%edx
  800597:	8d 4a 04             	lea    0x4(%edx),%ecx
  80059a:	89 08                	mov    %ecx,(%eax)
  80059c:	8b 02                	mov    (%edx),%eax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	eb 0e                	jmp    8005b3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005a5:	8b 10                	mov    (%eax),%edx
  8005a7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005aa:	89 08                	mov    %ecx,(%eax)
  8005ac:	8b 02                	mov    (%edx),%eax
  8005ae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005b3:	5d                   	pop    %ebp
  8005b4:	c3                   	ret    

008005b5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005bb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005bf:	8b 10                	mov    (%eax),%edx
  8005c1:	3b 50 04             	cmp    0x4(%eax),%edx
  8005c4:	73 0a                	jae    8005d0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005c9:	88 0a                	mov    %cl,(%edx)
  8005cb:	83 c2 01             	add    $0x1,%edx
  8005ce:	89 10                	mov    %edx,(%eax)
}
  8005d0:	5d                   	pop    %ebp
  8005d1:	c3                   	ret    

008005d2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005d2:	55                   	push   %ebp
  8005d3:	89 e5                	mov    %esp,%ebp
  8005d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005d8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005df:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	89 04 24             	mov    %eax,(%esp)
  8005f3:	e8 02 00 00 00       	call   8005fa <vprintfmt>
	va_end(ap);
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	57                   	push   %edi
  8005fe:	56                   	push   %esi
  8005ff:	53                   	push   %ebx
  800600:	83 ec 4c             	sub    $0x4c,%esp
  800603:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800606:	8b 75 10             	mov    0x10(%ebp),%esi
  800609:	eb 12                	jmp    80061d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80060b:	85 c0                	test   %eax,%eax
  80060d:	0f 84 a9 03 00 00    	je     8009bc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800613:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800617:	89 04 24             	mov    %eax,(%esp)
  80061a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80061d:	0f b6 06             	movzbl (%esi),%eax
  800620:	83 c6 01             	add    $0x1,%esi
  800623:	83 f8 25             	cmp    $0x25,%eax
  800626:	75 e3                	jne    80060b <vprintfmt+0x11>
  800628:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80062c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800633:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800638:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80063f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800644:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800647:	eb 2b                	jmp    800674 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800649:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80064c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800650:	eb 22                	jmp    800674 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800652:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800655:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800659:	eb 19                	jmp    800674 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80065e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800665:	eb 0d                	jmp    800674 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800667:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80066a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80066d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800674:	0f b6 06             	movzbl (%esi),%eax
  800677:	0f b6 d0             	movzbl %al,%edx
  80067a:	8d 7e 01             	lea    0x1(%esi),%edi
  80067d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800680:	83 e8 23             	sub    $0x23,%eax
  800683:	3c 55                	cmp    $0x55,%al
  800685:	0f 87 0b 03 00 00    	ja     800996 <vprintfmt+0x39c>
  80068b:	0f b6 c0             	movzbl %al,%eax
  80068e:	ff 24 85 e0 2b 80 00 	jmp    *0x802be0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800695:	83 ea 30             	sub    $0x30,%edx
  800698:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80069b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80069f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8006a5:	83 fa 09             	cmp    $0x9,%edx
  8006a8:	77 4a                	ja     8006f4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006aa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ad:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8006b0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8006b3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8006b7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006ba:	8d 50 d0             	lea    -0x30(%eax),%edx
  8006bd:	83 fa 09             	cmp    $0x9,%edx
  8006c0:	76 eb                	jbe    8006ad <vprintfmt+0xb3>
  8006c2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006c5:	eb 2d                	jmp    8006f4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006d8:	eb 1a                	jmp    8006f4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8006dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e1:	79 91                	jns    800674 <vprintfmt+0x7a>
  8006e3:	e9 73 ff ff ff       	jmp    80065b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006e8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8006eb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006f2:	eb 80                	jmp    800674 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8006f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f8:	0f 89 76 ff ff ff    	jns    800674 <vprintfmt+0x7a>
  8006fe:	e9 64 ff ff ff       	jmp    800667 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800703:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800706:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800709:	e9 66 ff ff ff       	jmp    800674 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	89 55 14             	mov    %edx,0x14(%ebp)
  800717:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	89 04 24             	mov    %eax,(%esp)
  800720:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800723:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800726:	e9 f2 fe ff ff       	jmp    80061d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8d 50 04             	lea    0x4(%eax),%edx
  800731:	89 55 14             	mov    %edx,0x14(%ebp)
  800734:	8b 00                	mov    (%eax),%eax
  800736:	89 c2                	mov    %eax,%edx
  800738:	c1 fa 1f             	sar    $0x1f,%edx
  80073b:	31 d0                	xor    %edx,%eax
  80073d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80073f:	83 f8 0f             	cmp    $0xf,%eax
  800742:	7f 0b                	jg     80074f <vprintfmt+0x155>
  800744:	8b 14 85 40 2d 80 00 	mov    0x802d40(,%eax,4),%edx
  80074b:	85 d2                	test   %edx,%edx
  80074d:	75 23                	jne    800772 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80074f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800753:	c7 44 24 08 ab 2a 80 	movl   $0x802aab,0x8(%esp)
  80075a:	00 
  80075b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80075f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800762:	89 3c 24             	mov    %edi,(%esp)
  800765:	e8 68 fe ff ff       	call   8005d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80076d:	e9 ab fe ff ff       	jmp    80061d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800772:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800776:	c7 44 24 08 15 30 80 	movl   $0x803015,0x8(%esp)
  80077d:	00 
  80077e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800782:	8b 7d 08             	mov    0x8(%ebp),%edi
  800785:	89 3c 24             	mov    %edi,(%esp)
  800788:	e8 45 fe ff ff       	call   8005d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800790:	e9 88 fe ff ff       	jmp    80061d <vprintfmt+0x23>
  800795:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80079b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 50 04             	lea    0x4(%eax),%edx
  8007a4:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8007a9:	85 f6                	test   %esi,%esi
  8007ab:	ba a4 2a 80 00       	mov    $0x802aa4,%edx
  8007b0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8007b3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007b7:	7e 06                	jle    8007bf <vprintfmt+0x1c5>
  8007b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8007bd:	75 10                	jne    8007cf <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007bf:	0f be 06             	movsbl (%esi),%eax
  8007c2:	83 c6 01             	add    $0x1,%esi
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	0f 85 86 00 00 00    	jne    800853 <vprintfmt+0x259>
  8007cd:	eb 76                	jmp    800845 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007cf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d3:	89 34 24             	mov    %esi,(%esp)
  8007d6:	e8 90 02 00 00       	call   800a6b <strnlen>
  8007db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007de:	29 c2                	sub    %eax,%edx
  8007e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007e3:	85 d2                	test   %edx,%edx
  8007e5:	7e d8                	jle    8007bf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007e7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8007eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8007ee:	89 d6                	mov    %edx,%esi
  8007f0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8007f3:	89 c7                	mov    %eax,%edi
  8007f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007f9:	89 3c 24             	mov    %edi,(%esp)
  8007fc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ff:	83 ee 01             	sub    $0x1,%esi
  800802:	75 f1                	jne    8007f5 <vprintfmt+0x1fb>
  800804:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800807:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80080a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80080d:	eb b0                	jmp    8007bf <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80080f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800813:	74 18                	je     80082d <vprintfmt+0x233>
  800815:	8d 50 e0             	lea    -0x20(%eax),%edx
  800818:	83 fa 5e             	cmp    $0x5e,%edx
  80081b:	76 10                	jbe    80082d <vprintfmt+0x233>
					putch('?', putdat);
  80081d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800821:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800828:	ff 55 08             	call   *0x8(%ebp)
  80082b:	eb 0a                	jmp    800837 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80082d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800831:	89 04 24             	mov    %eax,(%esp)
  800834:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800837:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80083b:	0f be 06             	movsbl (%esi),%eax
  80083e:	83 c6 01             	add    $0x1,%esi
  800841:	85 c0                	test   %eax,%eax
  800843:	75 0e                	jne    800853 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800845:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800848:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084c:	7f 16                	jg     800864 <vprintfmt+0x26a>
  80084e:	e9 ca fd ff ff       	jmp    80061d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800853:	85 ff                	test   %edi,%edi
  800855:	78 b8                	js     80080f <vprintfmt+0x215>
  800857:	83 ef 01             	sub    $0x1,%edi
  80085a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800860:	79 ad                	jns    80080f <vprintfmt+0x215>
  800862:	eb e1                	jmp    800845 <vprintfmt+0x24b>
  800864:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800867:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80086a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80086e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800875:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800877:	83 ee 01             	sub    $0x1,%esi
  80087a:	75 ee                	jne    80086a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80087f:	e9 99 fd ff ff       	jmp    80061d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800884:	83 f9 01             	cmp    $0x1,%ecx
  800887:	7e 10                	jle    800899 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8d 50 08             	lea    0x8(%eax),%edx
  80088f:	89 55 14             	mov    %edx,0x14(%ebp)
  800892:	8b 30                	mov    (%eax),%esi
  800894:	8b 78 04             	mov    0x4(%eax),%edi
  800897:	eb 26                	jmp    8008bf <vprintfmt+0x2c5>
	else if (lflag)
  800899:	85 c9                	test   %ecx,%ecx
  80089b:	74 12                	je     8008af <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8d 50 04             	lea    0x4(%eax),%edx
  8008a3:	89 55 14             	mov    %edx,0x14(%ebp)
  8008a6:	8b 30                	mov    (%eax),%esi
  8008a8:	89 f7                	mov    %esi,%edi
  8008aa:	c1 ff 1f             	sar    $0x1f,%edi
  8008ad:	eb 10                	jmp    8008bf <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8008af:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b2:	8d 50 04             	lea    0x4(%eax),%edx
  8008b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008b8:	8b 30                	mov    (%eax),%esi
  8008ba:	89 f7                	mov    %esi,%edi
  8008bc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008bf:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008c4:	85 ff                	test   %edi,%edi
  8008c6:	0f 89 8c 00 00 00    	jns    800958 <vprintfmt+0x35e>
				putch('-', putdat);
  8008cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008d0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008d7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008da:	f7 de                	neg    %esi
  8008dc:	83 d7 00             	adc    $0x0,%edi
  8008df:	f7 df                	neg    %edi
			}
			base = 10;
  8008e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e6:	eb 70                	jmp    800958 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e8:	89 ca                	mov    %ecx,%edx
  8008ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ed:	e8 89 fc ff ff       	call   80057b <getuint>
  8008f2:	89 c6                	mov    %eax,%esi
  8008f4:	89 d7                	mov    %edx,%edi
			base = 10;
  8008f6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8008fb:	eb 5b                	jmp    800958 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8008fd:	89 ca                	mov    %ecx,%edx
  8008ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800902:	e8 74 fc ff ff       	call   80057b <getuint>
  800907:	89 c6                	mov    %eax,%esi
  800909:	89 d7                	mov    %edx,%edi
			base = 8;
  80090b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800910:	eb 46                	jmp    800958 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800912:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800916:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80091d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800920:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800924:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80092b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80092e:	8b 45 14             	mov    0x14(%ebp),%eax
  800931:	8d 50 04             	lea    0x4(%eax),%edx
  800934:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800937:	8b 30                	mov    (%eax),%esi
  800939:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80093e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800943:	eb 13                	jmp    800958 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800945:	89 ca                	mov    %ecx,%edx
  800947:	8d 45 14             	lea    0x14(%ebp),%eax
  80094a:	e8 2c fc ff ff       	call   80057b <getuint>
  80094f:	89 c6                	mov    %eax,%esi
  800951:	89 d7                	mov    %edx,%edi
			base = 16;
  800953:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800958:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80095c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800960:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800963:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800967:	89 44 24 08          	mov    %eax,0x8(%esp)
  80096b:	89 34 24             	mov    %esi,(%esp)
  80096e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800972:	89 da                	mov    %ebx,%edx
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	e8 24 fb ff ff       	call   8004a0 <printnum>
			break;
  80097c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80097f:	e9 99 fc ff ff       	jmp    80061d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800984:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800988:	89 14 24             	mov    %edx,(%esp)
  80098b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80098e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800991:	e9 87 fc ff ff       	jmp    80061d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800996:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80099a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009a1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8009a8:	0f 84 6f fc ff ff    	je     80061d <vprintfmt+0x23>
  8009ae:	83 ee 01             	sub    $0x1,%esi
  8009b1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8009b5:	75 f7                	jne    8009ae <vprintfmt+0x3b4>
  8009b7:	e9 61 fc ff ff       	jmp    80061d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8009bc:	83 c4 4c             	add    $0x4c,%esp
  8009bf:	5b                   	pop    %ebx
  8009c0:	5e                   	pop    %esi
  8009c1:	5f                   	pop    %edi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	83 ec 28             	sub    $0x28,%esp
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009d7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009e1:	85 c0                	test   %eax,%eax
  8009e3:	74 30                	je     800a15 <vsnprintf+0x51>
  8009e5:	85 d2                	test   %edx,%edx
  8009e7:	7e 2c                	jle    800a15 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009f7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009fe:	c7 04 24 b5 05 80 00 	movl   $0x8005b5,(%esp)
  800a05:	e8 f0 fb ff ff       	call   8005fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a0d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a13:	eb 05                	jmp    800a1a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a1a:	c9                   	leave  
  800a1b:	c3                   	ret    

00800a1c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a22:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a25:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a29:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	89 04 24             	mov    %eax,(%esp)
  800a3d:	e8 82 ff ff ff       	call   8009c4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    
	...

00800a50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5b:	80 3a 00             	cmpb   $0x0,(%edx)
  800a5e:	74 09                	je     800a69 <strlen+0x19>
		n++;
  800a60:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a67:	75 f7                	jne    800a60 <strlen+0x10>
		n++;
	return n;
}
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	53                   	push   %ebx
  800a6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a75:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7a:	85 c9                	test   %ecx,%ecx
  800a7c:	74 1a                	je     800a98 <strnlen+0x2d>
  800a7e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800a81:	74 15                	je     800a98 <strnlen+0x2d>
  800a83:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800a88:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8a:	39 ca                	cmp    %ecx,%edx
  800a8c:	74 0a                	je     800a98 <strnlen+0x2d>
  800a8e:	83 c2 01             	add    $0x1,%edx
  800a91:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800a96:	75 f0                	jne    800a88 <strnlen+0x1d>
		n++;
	return n;
}
  800a98:	5b                   	pop    %ebx
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	53                   	push   %ebx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aa5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aaa:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aae:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ab1:	83 c2 01             	add    $0x1,%edx
  800ab4:	84 c9                	test   %cl,%cl
  800ab6:	75 f2                	jne    800aaa <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ab8:	5b                   	pop    %ebx
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	53                   	push   %ebx
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ac5:	89 1c 24             	mov    %ebx,(%esp)
  800ac8:	e8 83 ff ff ff       	call   800a50 <strlen>
	strcpy(dst + len, src);
  800acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad0:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ad4:	01 d8                	add    %ebx,%eax
  800ad6:	89 04 24             	mov    %eax,(%esp)
  800ad9:	e8 bd ff ff ff       	call   800a9b <strcpy>
	return dst;
}
  800ade:	89 d8                	mov    %ebx,%eax
  800ae0:	83 c4 08             	add    $0x8,%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	56                   	push   %esi
  800aea:	53                   	push   %ebx
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800af4:	85 f6                	test   %esi,%esi
  800af6:	74 18                	je     800b10 <strncpy+0x2a>
  800af8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800afd:	0f b6 1a             	movzbl (%edx),%ebx
  800b00:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b03:	80 3a 01             	cmpb   $0x1,(%edx)
  800b06:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b09:	83 c1 01             	add    $0x1,%ecx
  800b0c:	39 f1                	cmp    %esi,%ecx
  800b0e:	75 ed                	jne    800afd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	57                   	push   %edi
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
  800b1a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b20:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b23:	89 f8                	mov    %edi,%eax
  800b25:	85 f6                	test   %esi,%esi
  800b27:	74 2b                	je     800b54 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800b29:	83 fe 01             	cmp    $0x1,%esi
  800b2c:	74 23                	je     800b51 <strlcpy+0x3d>
  800b2e:	0f b6 0b             	movzbl (%ebx),%ecx
  800b31:	84 c9                	test   %cl,%cl
  800b33:	74 1c                	je     800b51 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800b35:	83 ee 02             	sub    $0x2,%esi
  800b38:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b3d:	88 08                	mov    %cl,(%eax)
  800b3f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b42:	39 f2                	cmp    %esi,%edx
  800b44:	74 0b                	je     800b51 <strlcpy+0x3d>
  800b46:	83 c2 01             	add    $0x1,%edx
  800b49:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b4d:	84 c9                	test   %cl,%cl
  800b4f:	75 ec                	jne    800b3d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800b51:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b54:	29 f8                	sub    %edi,%eax
}
  800b56:	5b                   	pop    %ebx
  800b57:	5e                   	pop    %esi
  800b58:	5f                   	pop    %edi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b61:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b64:	0f b6 01             	movzbl (%ecx),%eax
  800b67:	84 c0                	test   %al,%al
  800b69:	74 16                	je     800b81 <strcmp+0x26>
  800b6b:	3a 02                	cmp    (%edx),%al
  800b6d:	75 12                	jne    800b81 <strcmp+0x26>
		p++, q++;
  800b6f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b72:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800b76:	84 c0                	test   %al,%al
  800b78:	74 07                	je     800b81 <strcmp+0x26>
  800b7a:	83 c1 01             	add    $0x1,%ecx
  800b7d:	3a 02                	cmp    (%edx),%al
  800b7f:	74 ee                	je     800b6f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b81:	0f b6 c0             	movzbl %al,%eax
  800b84:	0f b6 12             	movzbl (%edx),%edx
  800b87:	29 d0                	sub    %edx,%eax
}
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    

00800b8b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	53                   	push   %ebx
  800b8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b95:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b98:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b9d:	85 d2                	test   %edx,%edx
  800b9f:	74 28                	je     800bc9 <strncmp+0x3e>
  800ba1:	0f b6 01             	movzbl (%ecx),%eax
  800ba4:	84 c0                	test   %al,%al
  800ba6:	74 24                	je     800bcc <strncmp+0x41>
  800ba8:	3a 03                	cmp    (%ebx),%al
  800baa:	75 20                	jne    800bcc <strncmp+0x41>
  800bac:	83 ea 01             	sub    $0x1,%edx
  800baf:	74 13                	je     800bc4 <strncmp+0x39>
		n--, p++, q++;
  800bb1:	83 c1 01             	add    $0x1,%ecx
  800bb4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800bb7:	0f b6 01             	movzbl (%ecx),%eax
  800bba:	84 c0                	test   %al,%al
  800bbc:	74 0e                	je     800bcc <strncmp+0x41>
  800bbe:	3a 03                	cmp    (%ebx),%al
  800bc0:	74 ea                	je     800bac <strncmp+0x21>
  800bc2:	eb 08                	jmp    800bcc <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800bc4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800bc9:	5b                   	pop    %ebx
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bcc:	0f b6 01             	movzbl (%ecx),%eax
  800bcf:	0f b6 13             	movzbl (%ebx),%edx
  800bd2:	29 d0                	sub    %edx,%eax
  800bd4:	eb f3                	jmp    800bc9 <strncmp+0x3e>

00800bd6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800be0:	0f b6 10             	movzbl (%eax),%edx
  800be3:	84 d2                	test   %dl,%dl
  800be5:	74 1c                	je     800c03 <strchr+0x2d>
		if (*s == c)
  800be7:	38 ca                	cmp    %cl,%dl
  800be9:	75 09                	jne    800bf4 <strchr+0x1e>
  800beb:	eb 1b                	jmp    800c08 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bed:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800bf0:	38 ca                	cmp    %cl,%dl
  800bf2:	74 14                	je     800c08 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bf4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800bf8:	84 d2                	test   %dl,%dl
  800bfa:	75 f1                	jne    800bed <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800c01:	eb 05                	jmp    800c08 <strchr+0x32>
  800c03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c14:	0f b6 10             	movzbl (%eax),%edx
  800c17:	84 d2                	test   %dl,%dl
  800c19:	74 14                	je     800c2f <strfind+0x25>
		if (*s == c)
  800c1b:	38 ca                	cmp    %cl,%dl
  800c1d:	75 06                	jne    800c25 <strfind+0x1b>
  800c1f:	eb 0e                	jmp    800c2f <strfind+0x25>
  800c21:	38 ca                	cmp    %cl,%dl
  800c23:	74 0a                	je     800c2f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c25:	83 c0 01             	add    $0x1,%eax
  800c28:	0f b6 10             	movzbl (%eax),%edx
  800c2b:	84 d2                	test   %dl,%dl
  800c2d:	75 f2                	jne    800c21 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	83 ec 0c             	sub    $0xc,%esp
  800c37:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c3a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c3d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800c40:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c46:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c49:	85 c9                	test   %ecx,%ecx
  800c4b:	74 30                	je     800c7d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c4d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c53:	75 25                	jne    800c7a <memset+0x49>
  800c55:	f6 c1 03             	test   $0x3,%cl
  800c58:	75 20                	jne    800c7a <memset+0x49>
		c &= 0xFF;
  800c5a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c5d:	89 d3                	mov    %edx,%ebx
  800c5f:	c1 e3 08             	shl    $0x8,%ebx
  800c62:	89 d6                	mov    %edx,%esi
  800c64:	c1 e6 18             	shl    $0x18,%esi
  800c67:	89 d0                	mov    %edx,%eax
  800c69:	c1 e0 10             	shl    $0x10,%eax
  800c6c:	09 f0                	or     %esi,%eax
  800c6e:	09 d0                	or     %edx,%eax
  800c70:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c72:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c75:	fc                   	cld    
  800c76:	f3 ab                	rep stos %eax,%es:(%edi)
  800c78:	eb 03                	jmp    800c7d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c7a:	fc                   	cld    
  800c7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c7d:	89 f8                	mov    %edi,%eax
  800c7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c82:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c88:	89 ec                	mov    %ebp,%esp
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c95:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca1:	39 c6                	cmp    %eax,%esi
  800ca3:	73 36                	jae    800cdb <memmove+0x4f>
  800ca5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ca8:	39 d0                	cmp    %edx,%eax
  800caa:	73 2f                	jae    800cdb <memmove+0x4f>
		s += n;
		d += n;
  800cac:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800caf:	f6 c2 03             	test   $0x3,%dl
  800cb2:	75 1b                	jne    800ccf <memmove+0x43>
  800cb4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cba:	75 13                	jne    800ccf <memmove+0x43>
  800cbc:	f6 c1 03             	test   $0x3,%cl
  800cbf:	75 0e                	jne    800ccf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cc1:	83 ef 04             	sub    $0x4,%edi
  800cc4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cc7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800cca:	fd                   	std    
  800ccb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ccd:	eb 09                	jmp    800cd8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ccf:	83 ef 01             	sub    $0x1,%edi
  800cd2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800cd5:	fd                   	std    
  800cd6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cd8:	fc                   	cld    
  800cd9:	eb 20                	jmp    800cfb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cdb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ce1:	75 13                	jne    800cf6 <memmove+0x6a>
  800ce3:	a8 03                	test   $0x3,%al
  800ce5:	75 0f                	jne    800cf6 <memmove+0x6a>
  800ce7:	f6 c1 03             	test   $0x3,%cl
  800cea:	75 0a                	jne    800cf6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cec:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800cef:	89 c7                	mov    %eax,%edi
  800cf1:	fc                   	cld    
  800cf2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf4:	eb 05                	jmp    800cfb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cf6:	89 c7                	mov    %eax,%edi
  800cf8:	fc                   	cld    
  800cf9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cfb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cfe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d01:	89 ec                	mov    %ebp,%esp
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 04 24             	mov    %eax,(%esp)
  800d1f:	e8 68 ff ff ff       	call   800c8c <memmove>
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
  800d2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d32:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d3a:	85 ff                	test   %edi,%edi
  800d3c:	74 37                	je     800d75 <memcmp+0x4f>
		if (*s1 != *s2)
  800d3e:	0f b6 03             	movzbl (%ebx),%eax
  800d41:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d44:	83 ef 01             	sub    $0x1,%edi
  800d47:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800d4c:	38 c8                	cmp    %cl,%al
  800d4e:	74 1c                	je     800d6c <memcmp+0x46>
  800d50:	eb 10                	jmp    800d62 <memcmp+0x3c>
  800d52:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800d57:	83 c2 01             	add    $0x1,%edx
  800d5a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800d5e:	38 c8                	cmp    %cl,%al
  800d60:	74 0a                	je     800d6c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800d62:	0f b6 c0             	movzbl %al,%eax
  800d65:	0f b6 c9             	movzbl %cl,%ecx
  800d68:	29 c8                	sub    %ecx,%eax
  800d6a:	eb 09                	jmp    800d75 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d6c:	39 fa                	cmp    %edi,%edx
  800d6e:	75 e2                	jne    800d52 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d75:	5b                   	pop    %ebx
  800d76:	5e                   	pop    %esi
  800d77:	5f                   	pop    %edi
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800d80:	89 c2                	mov    %eax,%edx
  800d82:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d85:	39 d0                	cmp    %edx,%eax
  800d87:	73 19                	jae    800da2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d89:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800d8d:	38 08                	cmp    %cl,(%eax)
  800d8f:	75 06                	jne    800d97 <memfind+0x1d>
  800d91:	eb 0f                	jmp    800da2 <memfind+0x28>
  800d93:	38 08                	cmp    %cl,(%eax)
  800d95:	74 0b                	je     800da2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d97:	83 c0 01             	add    $0x1,%eax
  800d9a:	39 d0                	cmp    %edx,%eax
  800d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800da0:	75 f1                	jne    800d93 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
  800daa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800db0:	0f b6 02             	movzbl (%edx),%eax
  800db3:	3c 20                	cmp    $0x20,%al
  800db5:	74 04                	je     800dbb <strtol+0x17>
  800db7:	3c 09                	cmp    $0x9,%al
  800db9:	75 0e                	jne    800dc9 <strtol+0x25>
		s++;
  800dbb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dbe:	0f b6 02             	movzbl (%edx),%eax
  800dc1:	3c 20                	cmp    $0x20,%al
  800dc3:	74 f6                	je     800dbb <strtol+0x17>
  800dc5:	3c 09                	cmp    $0x9,%al
  800dc7:	74 f2                	je     800dbb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dc9:	3c 2b                	cmp    $0x2b,%al
  800dcb:	75 0a                	jne    800dd7 <strtol+0x33>
		s++;
  800dcd:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800dd0:	bf 00 00 00 00       	mov    $0x0,%edi
  800dd5:	eb 10                	jmp    800de7 <strtol+0x43>
  800dd7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ddc:	3c 2d                	cmp    $0x2d,%al
  800dde:	75 07                	jne    800de7 <strtol+0x43>
		s++, neg = 1;
  800de0:	83 c2 01             	add    $0x1,%edx
  800de3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800de7:	85 db                	test   %ebx,%ebx
  800de9:	0f 94 c0             	sete   %al
  800dec:	74 05                	je     800df3 <strtol+0x4f>
  800dee:	83 fb 10             	cmp    $0x10,%ebx
  800df1:	75 15                	jne    800e08 <strtol+0x64>
  800df3:	80 3a 30             	cmpb   $0x30,(%edx)
  800df6:	75 10                	jne    800e08 <strtol+0x64>
  800df8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800dfc:	75 0a                	jne    800e08 <strtol+0x64>
		s += 2, base = 16;
  800dfe:	83 c2 02             	add    $0x2,%edx
  800e01:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e06:	eb 13                	jmp    800e1b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800e08:	84 c0                	test   %al,%al
  800e0a:	74 0f                	je     800e1b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e0c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e11:	80 3a 30             	cmpb   $0x30,(%edx)
  800e14:	75 05                	jne    800e1b <strtol+0x77>
		s++, base = 8;
  800e16:	83 c2 01             	add    $0x1,%edx
  800e19:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e20:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e22:	0f b6 0a             	movzbl (%edx),%ecx
  800e25:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800e28:	80 fb 09             	cmp    $0x9,%bl
  800e2b:	77 08                	ja     800e35 <strtol+0x91>
			dig = *s - '0';
  800e2d:	0f be c9             	movsbl %cl,%ecx
  800e30:	83 e9 30             	sub    $0x30,%ecx
  800e33:	eb 1e                	jmp    800e53 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800e35:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800e38:	80 fb 19             	cmp    $0x19,%bl
  800e3b:	77 08                	ja     800e45 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800e3d:	0f be c9             	movsbl %cl,%ecx
  800e40:	83 e9 57             	sub    $0x57,%ecx
  800e43:	eb 0e                	jmp    800e53 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800e45:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800e48:	80 fb 19             	cmp    $0x19,%bl
  800e4b:	77 14                	ja     800e61 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800e4d:	0f be c9             	movsbl %cl,%ecx
  800e50:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e53:	39 f1                	cmp    %esi,%ecx
  800e55:	7d 0e                	jge    800e65 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e57:	83 c2 01             	add    $0x1,%edx
  800e5a:	0f af c6             	imul   %esi,%eax
  800e5d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800e5f:	eb c1                	jmp    800e22 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800e61:	89 c1                	mov    %eax,%ecx
  800e63:	eb 02                	jmp    800e67 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e65:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6b:	74 05                	je     800e72 <strtol+0xce>
		*endptr = (char *) s;
  800e6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e70:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800e72:	89 ca                	mov    %ecx,%edx
  800e74:	f7 da                	neg    %edx
  800e76:	85 ff                	test   %edi,%edi
  800e78:	0f 45 c2             	cmovne %edx,%eax
}
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5f                   	pop    %edi
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 0c             	sub    $0xc,%esp
  800e86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e89:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e8c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e97:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9a:	89 c3                	mov    %eax,%ebx
  800e9c:	89 c7                	mov    %eax,%edi
  800e9e:	89 c6                	mov    %eax,%esi
  800ea0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ea2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ea5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ea8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eab:	89 ec                	mov    %ebp,%esp
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    

00800eaf <sys_cgetc>:

int
sys_cgetc(void)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eb8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ebb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebe:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec3:	b8 01 00 00 00       	mov    $0x1,%eax
  800ec8:	89 d1                	mov    %edx,%ecx
  800eca:	89 d3                	mov    %edx,%ebx
  800ecc:	89 d7                	mov    %edx,%edi
  800ece:	89 d6                	mov    %edx,%esi
  800ed0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ed2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ed5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ed8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800edb:	89 ec                	mov    %ebp,%esp
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    

00800edf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	83 ec 38             	sub    $0x38,%esp
  800ee5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ee8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eeb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  800efb:	89 cb                	mov    %ecx,%ebx
  800efd:	89 cf                	mov    %ecx,%edi
  800eff:	89 ce                	mov    %ecx,%esi
  800f01:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f03:	85 c0                	test   %eax,%eax
  800f05:	7e 28                	jle    800f2f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f0b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f12:	00 
  800f13:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800f1a:	00 
  800f1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f22:	00 
  800f23:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800f2a:	e8 55 f4 ff ff       	call   800384 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f38:	89 ec                	mov    %ebp,%esp
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    

00800f3c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f45:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f48:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f50:	b8 02 00 00 00       	mov    $0x2,%eax
  800f55:	89 d1                	mov    %edx,%ecx
  800f57:	89 d3                	mov    %edx,%ebx
  800f59:	89 d7                	mov    %edx,%edi
  800f5b:	89 d6                	mov    %edx,%esi
  800f5d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f62:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f65:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f68:	89 ec                	mov    %ebp,%esp
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <sys_yield>:

void
sys_yield(void)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 0c             	sub    $0xc,%esp
  800f72:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f75:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f78:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f80:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f85:	89 d1                	mov    %edx,%ecx
  800f87:	89 d3                	mov    %edx,%ebx
  800f89:	89 d7                	mov    %edx,%edi
  800f8b:	89 d6                	mov    %edx,%esi
  800f8d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f8f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f92:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f95:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f98:	89 ec                	mov    %ebp,%esp
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 38             	sub    $0x38,%esp
  800fa2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fa5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fab:	be 00 00 00 00       	mov    $0x0,%esi
  800fb0:	b8 04 00 00 00       	mov    $0x4,%eax
  800fb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbe:	89 f7                	mov    %esi,%edi
  800fc0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	7e 28                	jle    800fee <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fca:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800fd1:	00 
  800fd2:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800fd9:	00 
  800fda:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe1:	00 
  800fe2:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800fe9:	e8 96 f3 ff ff       	call   800384 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ff1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ff4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ff7:	89 ec                	mov    %ebp,%esp
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 38             	sub    $0x38,%esp
  801001:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801004:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801007:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100a:	b8 05 00 00 00       	mov    $0x5,%eax
  80100f:	8b 75 18             	mov    0x18(%ebp),%esi
  801012:	8b 7d 14             	mov    0x14(%ebp),%edi
  801015:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801018:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101b:	8b 55 08             	mov    0x8(%ebp),%edx
  80101e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801020:	85 c0                	test   %eax,%eax
  801022:	7e 28                	jle    80104c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801024:	89 44 24 10          	mov    %eax,0x10(%esp)
  801028:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80102f:	00 
  801030:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  801037:	00 
  801038:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80103f:	00 
  801040:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  801047:	e8 38 f3 ff ff       	call   800384 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80104c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80104f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801052:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801055:	89 ec                	mov    %ebp,%esp
  801057:	5d                   	pop    %ebp
  801058:	c3                   	ret    

00801059 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 38             	sub    $0x38,%esp
  80105f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801062:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801065:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801068:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106d:	b8 06 00 00 00       	mov    $0x6,%eax
  801072:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801075:	8b 55 08             	mov    0x8(%ebp),%edx
  801078:	89 df                	mov    %ebx,%edi
  80107a:	89 de                	mov    %ebx,%esi
  80107c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80107e:	85 c0                	test   %eax,%eax
  801080:	7e 28                	jle    8010aa <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801082:	89 44 24 10          	mov    %eax,0x10(%esp)
  801086:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80108d:	00 
  80108e:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  801095:	00 
  801096:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80109d:	00 
  80109e:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  8010a5:	e8 da f2 ff ff       	call   800384 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010aa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010ad:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010b0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010b3:	89 ec                	mov    %ebp,%esp
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	83 ec 38             	sub    $0x38,%esp
  8010bd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010c0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010c3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010cb:	b8 08 00 00 00       	mov    $0x8,%eax
  8010d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d6:	89 df                	mov    %ebx,%edi
  8010d8:	89 de                	mov    %ebx,%esi
  8010da:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	7e 28                	jle    801108 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010eb:	00 
  8010ec:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  8010f3:	00 
  8010f4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010fb:	00 
  8010fc:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  801103:	e8 7c f2 ff ff       	call   800384 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801108:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80110b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80110e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801111:	89 ec                	mov    %ebp,%esp
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  801124:	bb 00 00 00 00       	mov    $0x0,%ebx
  801129:	b8 09 00 00 00       	mov    $0x9,%eax
  80112e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801131:	8b 55 08             	mov    0x8(%ebp),%edx
  801134:	89 df                	mov    %ebx,%edi
  801136:	89 de                	mov    %ebx,%esi
  801138:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80113a:	85 c0                	test   %eax,%eax
  80113c:	7e 28                	jle    801166 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80113e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801142:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801149:	00 
  80114a:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  801151:	00 
  801152:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801159:	00 
  80115a:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  801161:	e8 1e f2 ff ff       	call   800384 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801166:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801169:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80116c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80116f:	89 ec                	mov    %ebp,%esp
  801171:	5d                   	pop    %ebp
  801172:	c3                   	ret    

00801173 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	83 ec 38             	sub    $0x38,%esp
  801179:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80117c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80117f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801182:	bb 00 00 00 00       	mov    $0x0,%ebx
  801187:	b8 0a 00 00 00       	mov    $0xa,%eax
  80118c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118f:	8b 55 08             	mov    0x8(%ebp),%edx
  801192:	89 df                	mov    %ebx,%edi
  801194:	89 de                	mov    %ebx,%esi
  801196:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801198:	85 c0                	test   %eax,%eax
  80119a:	7e 28                	jle    8011c4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80119c:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011a0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8011a7:	00 
  8011a8:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  8011af:	00 
  8011b0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011b7:	00 
  8011b8:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  8011bf:	e8 c0 f1 ff ff       	call   800384 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011c4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011c7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011ca:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011cd:	89 ec                	mov    %ebp,%esp
  8011cf:	5d                   	pop    %ebp
  8011d0:	c3                   	ret    

008011d1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011da:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011dd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e0:	be 00 00 00 00       	mov    $0x0,%esi
  8011e5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011ea:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011f8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011fb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011fe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801201:	89 ec                	mov    %ebp,%esp
  801203:	5d                   	pop    %ebp
  801204:	c3                   	ret    

00801205 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 38             	sub    $0x38,%esp
  80120b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80120e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801211:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801214:	b9 00 00 00 00       	mov    $0x0,%ecx
  801219:	b8 0d 00 00 00       	mov    $0xd,%eax
  80121e:	8b 55 08             	mov    0x8(%ebp),%edx
  801221:	89 cb                	mov    %ecx,%ebx
  801223:	89 cf                	mov    %ecx,%edi
  801225:	89 ce                	mov    %ecx,%esi
  801227:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801229:	85 c0                	test   %eax,%eax
  80122b:	7e 28                	jle    801255 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80122d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801231:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801238:	00 
  801239:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  801240:	00 
  801241:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801248:	00 
  801249:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  801250:	e8 2f f1 ff ff       	call   800384 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801255:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801258:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80125b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80125e:	89 ec                	mov    %ebp,%esp
  801260:	5d                   	pop    %ebp
  801261:	c3                   	ret    
	...

00801264 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	53                   	push   %ebx
  801268:	83 ec 24             	sub    $0x24,%esp
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80126e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  801270:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801274:	74 21                	je     801297 <pgfault+0x33>
  801276:	89 d8                	mov    %ebx,%eax
  801278:	c1 e8 16             	shr    $0x16,%eax
  80127b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801282:	a8 01                	test   $0x1,%al
  801284:	74 11                	je     801297 <pgfault+0x33>
  801286:	89 d8                	mov    %ebx,%eax
  801288:	c1 e8 0c             	shr    $0xc,%eax
  80128b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801292:	f6 c4 08             	test   $0x8,%ah
  801295:	75 1c                	jne    8012b3 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  801297:	c7 44 24 08 cc 2d 80 	movl   $0x802dcc,0x8(%esp)
  80129e:	00 
  80129f:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8012a6:	00 
  8012a7:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  8012ae:	e8 d1 f0 ff ff       	call   800384 <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  8012b3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012ba:	00 
  8012bb:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012c2:	00 
  8012c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ca:	e8 cd fc ff ff       	call   800f9c <sys_page_alloc>
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	79 20                	jns    8012f3 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  8012d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012d7:	c7 44 24 08 08 2e 80 	movl   $0x802e08,0x8(%esp)
  8012de:	00 
  8012df:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  8012e6:	00 
  8012e7:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  8012ee:	e8 91 f0 ff ff       	call   800384 <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  8012f3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  8012f9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801300:	00 
  801301:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801305:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80130c:	e8 7b f9 ff ff       	call   800c8c <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  801311:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801318:	00 
  801319:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80131d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801324:	00 
  801325:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80132c:	00 
  80132d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801334:	e8 c2 fc ff ff       	call   800ffb <sys_page_map>
  801339:	85 c0                	test   %eax,%eax
  80133b:	79 20                	jns    80135d <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  80133d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801341:	c7 44 24 08 30 2e 80 	movl   $0x802e30,0x8(%esp)
  801348:	00 
  801349:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  801350:	00 
  801351:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  801358:	e8 27 f0 ff ff       	call   800384 <_panic>
	//panic("pgfault not implemented");
}
  80135d:	83 c4 24             	add    $0x24,%esp
  801360:	5b                   	pop    %ebx
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    

00801363 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	57                   	push   %edi
  801367:	56                   	push   %esi
  801368:	53                   	push   %ebx
  801369:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  80136c:	c7 04 24 64 12 80 00 	movl   $0x801264,(%esp)
  801373:	e8 e8 10 00 00       	call   802460 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801378:	ba 07 00 00 00       	mov    $0x7,%edx
  80137d:	89 d0                	mov    %edx,%eax
  80137f:	cd 30                	int    $0x30
  801381:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801384:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  801386:	85 c0                	test   %eax,%eax
  801388:	79 20                	jns    8013aa <fork+0x47>
		panic("sys_exofork: %e", envid);
  80138a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80138e:	c7 44 24 08 2e 2f 80 	movl   $0x802f2e,0x8(%esp)
  801395:	00 
  801396:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  80139d:	00 
  80139e:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  8013a5:	e8 da ef ff ff       	call   800384 <_panic>
	if (envid == 0) {
  8013aa:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8013af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013b3:	75 1c                	jne    8013d1 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013b5:	e8 82 fb ff ff       	call   800f3c <sys_getenvid>
  8013ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013bf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013c7:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  8013cc:	e9 06 02 00 00       	jmp    8015d7 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  8013d1:	89 d8                	mov    %ebx,%eax
  8013d3:	c1 e8 16             	shr    $0x16,%eax
  8013d6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013dd:	a8 01                	test   $0x1,%al
  8013df:	0f 84 57 01 00 00    	je     80153c <fork+0x1d9>
  8013e5:	89 de                	mov    %ebx,%esi
  8013e7:	c1 ee 0c             	shr    $0xc,%esi
  8013ea:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8013f1:	a8 01                	test   $0x1,%al
  8013f3:	0f 84 43 01 00 00    	je     80153c <fork+0x1d9>
  8013f9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801400:	a8 04                	test   $0x4,%al
  801402:	0f 84 34 01 00 00    	je     80153c <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  801408:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  80140b:	89 f0                	mov    %esi,%eax
  80140d:	c1 e8 0c             	shr    $0xc,%eax
  801410:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  801417:	f6 c4 04             	test   $0x4,%ah
  80141a:	74 45                	je     801461 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  80141c:	25 07 0e 00 00       	and    $0xe07,%eax
  801421:	89 44 24 10          	mov    %eax,0x10(%esp)
  801425:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801429:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80142d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801431:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801438:	e8 be fb ff ff       	call   800ffb <sys_page_map>
  80143d:	85 c0                	test   %eax,%eax
  80143f:	0f 89 f7 00 00 00    	jns    80153c <fork+0x1d9>
			panic ("duppage: error at lab5");
  801445:	c7 44 24 08 3e 2f 80 	movl   $0x802f3e,0x8(%esp)
  80144c:	00 
  80144d:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  801454:	00 
  801455:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  80145c:	e8 23 ef ff ff       	call   800384 <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  801461:	a9 02 08 00 00       	test   $0x802,%eax
  801466:	0f 84 8c 00 00 00    	je     8014f8 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  80146c:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801473:	00 
  801474:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801478:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80147c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801480:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801487:	e8 6f fb ff ff       	call   800ffb <sys_page_map>
  80148c:	85 c0                	test   %eax,%eax
  80148e:	79 20                	jns    8014b0 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  801490:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801494:	c7 44 24 08 54 2e 80 	movl   $0x802e54,0x8(%esp)
  80149b:	00 
  80149c:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8014a3:	00 
  8014a4:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  8014ab:	e8 d4 ee ff ff       	call   800384 <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8014b0:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8014b7:	00 
  8014b8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014c3:	00 
  8014c4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014cf:	e8 27 fb ff ff       	call   800ffb <sys_page_map>
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	79 64                	jns    80153c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  8014d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014dc:	c7 44 24 08 80 2e 80 	movl   $0x802e80,0x8(%esp)
  8014e3:	00 
  8014e4:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  8014eb:	00 
  8014ec:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  8014f3:	e8 8c ee ff ff       	call   800384 <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  8014f8:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8014ff:	00 
  801500:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801504:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801508:	89 74 24 04          	mov    %esi,0x4(%esp)
  80150c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801513:	e8 e3 fa ff ff       	call   800ffb <sys_page_map>
  801518:	85 c0                	test   %eax,%eax
  80151a:	79 20                	jns    80153c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  80151c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801520:	c7 44 24 08 ac 2e 80 	movl   $0x802eac,0x8(%esp)
  801527:	00 
  801528:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80152f:	00 
  801530:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  801537:	e8 48 ee ff ff       	call   800384 <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  80153c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801542:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801548:	0f 85 83 fe ff ff    	jne    8013d1 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  80154e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801555:	00 
  801556:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80155d:	ee 
  80155e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801561:	89 04 24             	mov    %eax,(%esp)
  801564:	e8 33 fa ff ff       	call   800f9c <sys_page_alloc>
  801569:	85 c0                	test   %eax,%eax
  80156b:	79 20                	jns    80158d <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  80156d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801571:	c7 44 24 08 d8 2e 80 	movl   $0x802ed8,0x8(%esp)
  801578:	00 
  801579:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801580:	00 
  801581:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  801588:	e8 f7 ed ff ff       	call   800384 <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  80158d:	c7 44 24 04 d0 24 80 	movl   $0x8024d0,0x4(%esp)
  801594:	00 
  801595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801598:	89 04 24             	mov    %eax,(%esp)
  80159b:	e8 d3 fb ff ff       	call   801173 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8015a0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8015a7:	00 
  8015a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ab:	89 04 24             	mov    %eax,(%esp)
  8015ae:	e8 04 fb ff ff       	call   8010b7 <sys_env_set_status>
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	79 20                	jns    8015d7 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  8015b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015bb:	c7 44 24 08 fc 2e 80 	movl   $0x802efc,0x8(%esp)
  8015c2:	00 
  8015c3:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  8015ca:	00 
  8015cb:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  8015d2:	e8 ad ed ff ff       	call   800384 <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  8015d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015da:	83 c4 3c             	add    $0x3c,%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5e                   	pop    %esi
  8015df:	5f                   	pop    %edi
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    

008015e2 <sfork>:

// Challenge!
int
sfork(void)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8015e8:	c7 44 24 08 55 2f 80 	movl   $0x802f55,0x8(%esp)
  8015ef:	00 
  8015f0:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  8015f7:	00 
  8015f8:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  8015ff:	e8 80 ed ff ff       	call   800384 <_panic>
	...

00801610 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	05 00 00 00 30       	add    $0x30000000,%eax
  80161b:	c1 e8 0c             	shr    $0xc,%eax
}
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    

00801620 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	89 04 24             	mov    %eax,(%esp)
  80162c:	e8 df ff ff ff       	call   801610 <fd2num>
  801631:	05 20 00 0d 00       	add    $0xd0020,%eax
  801636:	c1 e0 0c             	shl    $0xc,%eax
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	53                   	push   %ebx
  80163f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801642:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801647:	a8 01                	test   $0x1,%al
  801649:	74 34                	je     80167f <fd_alloc+0x44>
  80164b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801650:	a8 01                	test   $0x1,%al
  801652:	74 32                	je     801686 <fd_alloc+0x4b>
  801654:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801659:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80165b:	89 c2                	mov    %eax,%edx
  80165d:	c1 ea 16             	shr    $0x16,%edx
  801660:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801667:	f6 c2 01             	test   $0x1,%dl
  80166a:	74 1f                	je     80168b <fd_alloc+0x50>
  80166c:	89 c2                	mov    %eax,%edx
  80166e:	c1 ea 0c             	shr    $0xc,%edx
  801671:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801678:	f6 c2 01             	test   $0x1,%dl
  80167b:	75 17                	jne    801694 <fd_alloc+0x59>
  80167d:	eb 0c                	jmp    80168b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80167f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801684:	eb 05                	jmp    80168b <fd_alloc+0x50>
  801686:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80168b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80168d:	b8 00 00 00 00       	mov    $0x0,%eax
  801692:	eb 17                	jmp    8016ab <fd_alloc+0x70>
  801694:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801699:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80169e:	75 b9                	jne    801659 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  8016a6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8016ab:	5b                   	pop    %ebx
  8016ac:	5d                   	pop    %ebp
  8016ad:	c3                   	ret    

008016ae <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016b9:	83 fa 1f             	cmp    $0x1f,%edx
  8016bc:	77 3f                	ja     8016fd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016be:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  8016c4:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016c7:	89 d0                	mov    %edx,%eax
  8016c9:	c1 e8 16             	shr    $0x16,%eax
  8016cc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016d8:	f6 c1 01             	test   $0x1,%cl
  8016db:	74 20                	je     8016fd <fd_lookup+0x4f>
  8016dd:	89 d0                	mov    %edx,%eax
  8016df:	c1 e8 0c             	shr    $0xc,%eax
  8016e2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016ee:	f6 c1 01             	test   $0x1,%cl
  8016f1:	74 0a                	je     8016fd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f6:	89 10                	mov    %edx,(%eax)
	return 0;
  8016f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fd:	5d                   	pop    %ebp
  8016fe:	c3                   	ret    

008016ff <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	53                   	push   %ebx
  801703:	83 ec 14             	sub    $0x14,%esp
  801706:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801709:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801711:	39 0d 08 40 80 00    	cmp    %ecx,0x804008
  801717:	75 17                	jne    801730 <dev_lookup+0x31>
  801719:	eb 07                	jmp    801722 <dev_lookup+0x23>
  80171b:	39 0a                	cmp    %ecx,(%edx)
  80171d:	75 11                	jne    801730 <dev_lookup+0x31>
  80171f:	90                   	nop
  801720:	eb 05                	jmp    801727 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801722:	ba 08 40 80 00       	mov    $0x804008,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801727:	89 13                	mov    %edx,(%ebx)
			return 0;
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
  80172e:	eb 35                	jmp    801765 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801730:	83 c0 01             	add    $0x1,%eax
  801733:	8b 14 85 ec 2f 80 00 	mov    0x802fec(,%eax,4),%edx
  80173a:	85 d2                	test   %edx,%edx
  80173c:	75 dd                	jne    80171b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80173e:	a1 04 50 80 00       	mov    0x805004,%eax
  801743:	8b 40 48             	mov    0x48(%eax),%eax
  801746:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80174a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80174e:	c7 04 24 6c 2f 80 00 	movl   $0x802f6c,(%esp)
  801755:	e8 25 ed ff ff       	call   80047f <cprintf>
	*dev = 0;
  80175a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801760:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801765:	83 c4 14             	add    $0x14,%esp
  801768:	5b                   	pop    %ebx
  801769:	5d                   	pop    %ebp
  80176a:	c3                   	ret    

0080176b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 38             	sub    $0x38,%esp
  801771:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801774:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801777:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80177a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80177d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801781:	89 3c 24             	mov    %edi,(%esp)
  801784:	e8 87 fe ff ff       	call   801610 <fd2num>
  801789:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80178c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801790:	89 04 24             	mov    %eax,(%esp)
  801793:	e8 16 ff ff ff       	call   8016ae <fd_lookup>
  801798:	89 c3                	mov    %eax,%ebx
  80179a:	85 c0                	test   %eax,%eax
  80179c:	78 05                	js     8017a3 <fd_close+0x38>
	    || fd != fd2)
  80179e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8017a1:	74 0e                	je     8017b1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017a3:	89 f0                	mov    %esi,%eax
  8017a5:	84 c0                	test   %al,%al
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ac:	0f 44 d8             	cmove  %eax,%ebx
  8017af:	eb 3d                	jmp    8017ee <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b8:	8b 07                	mov    (%edi),%eax
  8017ba:	89 04 24             	mov    %eax,(%esp)
  8017bd:	e8 3d ff ff ff       	call   8016ff <dev_lookup>
  8017c2:	89 c3                	mov    %eax,%ebx
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 16                	js     8017de <fd_close+0x73>
		if (dev->dev_close)
  8017c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8017ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	74 07                	je     8017de <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8017d7:	89 3c 24             	mov    %edi,(%esp)
  8017da:	ff d0                	call   *%eax
  8017dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8017de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e9:	e8 6b f8 ff ff       	call   801059 <sys_page_unmap>
	return r;
}
  8017ee:	89 d8                	mov    %ebx,%eax
  8017f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017f3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8017f6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017f9:	89 ec                	mov    %ebp,%esp
  8017fb:	5d                   	pop    %ebp
  8017fc:	c3                   	ret    

008017fd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801803:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801806:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	89 04 24             	mov    %eax,(%esp)
  801810:	e8 99 fe ff ff       	call   8016ae <fd_lookup>
  801815:	85 c0                	test   %eax,%eax
  801817:	78 13                	js     80182c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801819:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801820:	00 
  801821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801824:	89 04 24             	mov    %eax,(%esp)
  801827:	e8 3f ff ff ff       	call   80176b <fd_close>
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <close_all>:

void
close_all(void)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	53                   	push   %ebx
  801832:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801835:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80183a:	89 1c 24             	mov    %ebx,(%esp)
  80183d:	e8 bb ff ff ff       	call   8017fd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801842:	83 c3 01             	add    $0x1,%ebx
  801845:	83 fb 20             	cmp    $0x20,%ebx
  801848:	75 f0                	jne    80183a <close_all+0xc>
		close(i);
}
  80184a:	83 c4 14             	add    $0x14,%esp
  80184d:	5b                   	pop    %ebx
  80184e:	5d                   	pop    %ebp
  80184f:	c3                   	ret    

00801850 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 58             	sub    $0x58,%esp
  801856:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801859:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80185c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80185f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801862:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801865:	89 44 24 04          	mov    %eax,0x4(%esp)
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	89 04 24             	mov    %eax,(%esp)
  80186f:	e8 3a fe ff ff       	call   8016ae <fd_lookup>
  801874:	89 c3                	mov    %eax,%ebx
  801876:	85 c0                	test   %eax,%eax
  801878:	0f 88 e1 00 00 00    	js     80195f <dup+0x10f>
		return r;
	close(newfdnum);
  80187e:	89 3c 24             	mov    %edi,(%esp)
  801881:	e8 77 ff ff ff       	call   8017fd <close>

	newfd = INDEX2FD(newfdnum);
  801886:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80188c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80188f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801892:	89 04 24             	mov    %eax,(%esp)
  801895:	e8 86 fd ff ff       	call   801620 <fd2data>
  80189a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80189c:	89 34 24             	mov    %esi,(%esp)
  80189f:	e8 7c fd ff ff       	call   801620 <fd2data>
  8018a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018a7:	89 d8                	mov    %ebx,%eax
  8018a9:	c1 e8 16             	shr    $0x16,%eax
  8018ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018b3:	a8 01                	test   $0x1,%al
  8018b5:	74 46                	je     8018fd <dup+0xad>
  8018b7:	89 d8                	mov    %ebx,%eax
  8018b9:	c1 e8 0c             	shr    $0xc,%eax
  8018bc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018c3:	f6 c2 01             	test   $0x1,%dl
  8018c6:	74 35                	je     8018fd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018c8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018cf:	25 07 0e 00 00       	and    $0xe07,%eax
  8018d4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018e6:	00 
  8018e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018f2:	e8 04 f7 ff ff       	call   800ffb <sys_page_map>
  8018f7:	89 c3                	mov    %eax,%ebx
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	78 3b                	js     801938 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801900:	89 c2                	mov    %eax,%edx
  801902:	c1 ea 0c             	shr    $0xc,%edx
  801905:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80190c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801912:	89 54 24 10          	mov    %edx,0x10(%esp)
  801916:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80191a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801921:	00 
  801922:	89 44 24 04          	mov    %eax,0x4(%esp)
  801926:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80192d:	e8 c9 f6 ff ff       	call   800ffb <sys_page_map>
  801932:	89 c3                	mov    %eax,%ebx
  801934:	85 c0                	test   %eax,%eax
  801936:	79 25                	jns    80195d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801938:	89 74 24 04          	mov    %esi,0x4(%esp)
  80193c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801943:	e8 11 f7 ff ff       	call   801059 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801948:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80194b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801956:	e8 fe f6 ff ff       	call   801059 <sys_page_unmap>
	return r;
  80195b:	eb 02                	jmp    80195f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80195d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80195f:	89 d8                	mov    %ebx,%eax
  801961:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801964:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801967:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80196a:	89 ec                	mov    %ebp,%esp
  80196c:	5d                   	pop    %ebp
  80196d:	c3                   	ret    

0080196e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	53                   	push   %ebx
  801972:	83 ec 24             	sub    $0x24,%esp
  801975:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801978:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80197b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197f:	89 1c 24             	mov    %ebx,(%esp)
  801982:	e8 27 fd ff ff       	call   8016ae <fd_lookup>
  801987:	85 c0                	test   %eax,%eax
  801989:	78 6d                	js     8019f8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801995:	8b 00                	mov    (%eax),%eax
  801997:	89 04 24             	mov    %eax,(%esp)
  80199a:	e8 60 fd ff ff       	call   8016ff <dev_lookup>
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	78 55                	js     8019f8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a6:	8b 50 08             	mov    0x8(%eax),%edx
  8019a9:	83 e2 03             	and    $0x3,%edx
  8019ac:	83 fa 01             	cmp    $0x1,%edx
  8019af:	75 23                	jne    8019d4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019b1:	a1 04 50 80 00       	mov    0x805004,%eax
  8019b6:	8b 40 48             	mov    0x48(%eax),%eax
  8019b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c1:	c7 04 24 b0 2f 80 00 	movl   $0x802fb0,(%esp)
  8019c8:	e8 b2 ea ff ff       	call   80047f <cprintf>
		return -E_INVAL;
  8019cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d2:	eb 24                	jmp    8019f8 <read+0x8a>
	}
	if (!dev->dev_read)
  8019d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d7:	8b 52 08             	mov    0x8(%edx),%edx
  8019da:	85 d2                	test   %edx,%edx
  8019dc:	74 15                	je     8019f3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019e8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019ec:	89 04 24             	mov    %eax,(%esp)
  8019ef:	ff d2                	call   *%edx
  8019f1:	eb 05                	jmp    8019f8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8019f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8019f8:	83 c4 24             	add    $0x24,%esp
  8019fb:	5b                   	pop    %ebx
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    

008019fe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	57                   	push   %edi
  801a02:	56                   	push   %esi
  801a03:	53                   	push   %ebx
  801a04:	83 ec 1c             	sub    $0x1c,%esp
  801a07:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a0a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a12:	85 f6                	test   %esi,%esi
  801a14:	74 30                	je     801a46 <readn+0x48>
  801a16:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a1b:	89 f2                	mov    %esi,%edx
  801a1d:	29 c2                	sub    %eax,%edx
  801a1f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a23:	03 45 0c             	add    0xc(%ebp),%eax
  801a26:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2a:	89 3c 24             	mov    %edi,(%esp)
  801a2d:	e8 3c ff ff ff       	call   80196e <read>
		if (m < 0)
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 10                	js     801a46 <readn+0x48>
			return m;
		if (m == 0)
  801a36:	85 c0                	test   %eax,%eax
  801a38:	74 0a                	je     801a44 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a3a:	01 c3                	add    %eax,%ebx
  801a3c:	89 d8                	mov    %ebx,%eax
  801a3e:	39 f3                	cmp    %esi,%ebx
  801a40:	72 d9                	jb     801a1b <readn+0x1d>
  801a42:	eb 02                	jmp    801a46 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801a44:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801a46:	83 c4 1c             	add    $0x1c,%esp
  801a49:	5b                   	pop    %ebx
  801a4a:	5e                   	pop    %esi
  801a4b:	5f                   	pop    %edi
  801a4c:	5d                   	pop    %ebp
  801a4d:	c3                   	ret    

00801a4e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	53                   	push   %ebx
  801a52:	83 ec 24             	sub    $0x24,%esp
  801a55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a58:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5f:	89 1c 24             	mov    %ebx,(%esp)
  801a62:	e8 47 fc ff ff       	call   8016ae <fd_lookup>
  801a67:	85 c0                	test   %eax,%eax
  801a69:	78 68                	js     801ad3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a75:	8b 00                	mov    (%eax),%eax
  801a77:	89 04 24             	mov    %eax,(%esp)
  801a7a:	e8 80 fc ff ff       	call   8016ff <dev_lookup>
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 50                	js     801ad3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a86:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a8a:	75 23                	jne    801aaf <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a8c:	a1 04 50 80 00       	mov    0x805004,%eax
  801a91:	8b 40 48             	mov    0x48(%eax),%eax
  801a94:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9c:	c7 04 24 cc 2f 80 00 	movl   $0x802fcc,(%esp)
  801aa3:	e8 d7 e9 ff ff       	call   80047f <cprintf>
		return -E_INVAL;
  801aa8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aad:	eb 24                	jmp    801ad3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab2:	8b 52 0c             	mov    0xc(%edx),%edx
  801ab5:	85 d2                	test   %edx,%edx
  801ab7:	74 15                	je     801ace <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ab9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801abc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ac0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ac3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ac7:	89 04 24             	mov    %eax,(%esp)
  801aca:	ff d2                	call   *%edx
  801acc:	eb 05                	jmp    801ad3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801ace:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801ad3:	83 c4 24             	add    $0x24,%esp
  801ad6:	5b                   	pop    %ebx
  801ad7:	5d                   	pop    %ebp
  801ad8:	c3                   	ret    

00801ad9 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801adf:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	89 04 24             	mov    %eax,(%esp)
  801aec:	e8 bd fb ff ff       	call   8016ae <fd_lookup>
  801af1:	85 c0                	test   %eax,%eax
  801af3:	78 0e                	js     801b03 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801af5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801af8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	53                   	push   %ebx
  801b09:	83 ec 24             	sub    $0x24,%esp
  801b0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b0f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b16:	89 1c 24             	mov    %ebx,(%esp)
  801b19:	e8 90 fb ff ff       	call   8016ae <fd_lookup>
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	78 61                	js     801b83 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2c:	8b 00                	mov    (%eax),%eax
  801b2e:	89 04 24             	mov    %eax,(%esp)
  801b31:	e8 c9 fb ff ff       	call   8016ff <dev_lookup>
  801b36:	85 c0                	test   %eax,%eax
  801b38:	78 49                	js     801b83 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b41:	75 23                	jne    801b66 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801b43:	a1 04 50 80 00       	mov    0x805004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b48:	8b 40 48             	mov    0x48(%eax),%eax
  801b4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b53:	c7 04 24 8c 2f 80 00 	movl   $0x802f8c,(%esp)
  801b5a:	e8 20 e9 ff ff       	call   80047f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801b5f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b64:	eb 1d                	jmp    801b83 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801b66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b69:	8b 52 18             	mov    0x18(%edx),%edx
  801b6c:	85 d2                	test   %edx,%edx
  801b6e:	74 0e                	je     801b7e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b77:	89 04 24             	mov    %eax,(%esp)
  801b7a:	ff d2                	call   *%edx
  801b7c:	eb 05                	jmp    801b83 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801b7e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801b83:	83 c4 24             	add    $0x24,%esp
  801b86:	5b                   	pop    %ebx
  801b87:	5d                   	pop    %ebp
  801b88:	c3                   	ret    

00801b89 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	53                   	push   %ebx
  801b8d:	83 ec 24             	sub    $0x24,%esp
  801b90:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b93:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	89 04 24             	mov    %eax,(%esp)
  801ba0:	e8 09 fb ff ff       	call   8016ae <fd_lookup>
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	78 52                	js     801bfb <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ba9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb3:	8b 00                	mov    (%eax),%eax
  801bb5:	89 04 24             	mov    %eax,(%esp)
  801bb8:	e8 42 fb ff ff       	call   8016ff <dev_lookup>
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	78 3a                	js     801bfb <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bc8:	74 2c                	je     801bf6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bca:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bcd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bd4:	00 00 00 
	stat->st_isdir = 0;
  801bd7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bde:	00 00 00 
	stat->st_dev = dev;
  801be1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801be7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801beb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bee:	89 14 24             	mov    %edx,(%esp)
  801bf1:	ff 50 14             	call   *0x14(%eax)
  801bf4:	eb 05                	jmp    801bfb <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801bf6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801bfb:	83 c4 24             	add    $0x24,%esp
  801bfe:	5b                   	pop    %ebx
  801bff:	5d                   	pop    %ebp
  801c00:	c3                   	ret    

00801c01 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	83 ec 18             	sub    $0x18,%esp
  801c07:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c0a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c0d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c14:	00 
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	89 04 24             	mov    %eax,(%esp)
  801c1b:	e8 bc 01 00 00       	call   801ddc <open>
  801c20:	89 c3                	mov    %eax,%ebx
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 1b                	js     801c41 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2d:	89 1c 24             	mov    %ebx,(%esp)
  801c30:	e8 54 ff ff ff       	call   801b89 <fstat>
  801c35:	89 c6                	mov    %eax,%esi
	close(fd);
  801c37:	89 1c 24             	mov    %ebx,(%esp)
  801c3a:	e8 be fb ff ff       	call   8017fd <close>
	return r;
  801c3f:	89 f3                	mov    %esi,%ebx
}
  801c41:	89 d8                	mov    %ebx,%eax
  801c43:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801c46:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801c49:	89 ec                	mov    %ebp,%esp
  801c4b:	5d                   	pop    %ebp
  801c4c:	c3                   	ret    
  801c4d:	00 00                	add    %al,(%eax)
	...

00801c50 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 18             	sub    $0x18,%esp
  801c56:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c59:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801c5c:	89 c3                	mov    %eax,%ebx
  801c5e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801c60:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c67:	75 11                	jne    801c7a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c70:	e8 61 09 00 00       	call   8025d6 <ipc_find_env>
  801c75:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c7a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c81:	00 
  801c82:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c89:	00 
  801c8a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c8e:	a1 00 50 80 00       	mov    0x805000,%eax
  801c93:	89 04 24             	mov    %eax,(%esp)
  801c96:	e8 b7 08 00 00       	call   802552 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ca2:	00 
  801ca3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ca7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cae:	e8 4d 08 00 00       	call   802500 <ipc_recv>
}
  801cb3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801cb6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801cb9:	89 ec                	mov    %ebp,%esp
  801cbb:	5d                   	pop    %ebp
  801cbc:	c3                   	ret    

00801cbd <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	53                   	push   %ebx
  801cc1:	83 ec 14             	sub    $0x14,%esp
  801cc4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	8b 40 0c             	mov    0xc(%eax),%eax
  801ccd:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd7:	b8 05 00 00 00       	mov    $0x5,%eax
  801cdc:	e8 6f ff ff ff       	call   801c50 <fsipc>
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	78 2b                	js     801d10 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ce5:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cec:	00 
  801ced:	89 1c 24             	mov    %ebx,(%esp)
  801cf0:	e8 a6 ed ff ff       	call   800a9b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cf5:	a1 80 60 80 00       	mov    0x806080,%eax
  801cfa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d00:	a1 84 60 80 00       	mov    0x806084,%eax
  801d05:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d10:	83 c4 14             	add    $0x14,%esp
  801d13:	5b                   	pop    %ebx
  801d14:	5d                   	pop    %ebp
  801d15:	c3                   	ret    

00801d16 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d22:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d27:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2c:	b8 06 00 00 00       	mov    $0x6,%eax
  801d31:	e8 1a ff ff ff       	call   801c50 <fsipc>
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	56                   	push   %esi
  801d3c:	53                   	push   %ebx
  801d3d:	83 ec 10             	sub    $0x10,%esp
  801d40:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	8b 40 0c             	mov    0xc(%eax),%eax
  801d49:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d4e:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d54:	ba 00 00 00 00       	mov    $0x0,%edx
  801d59:	b8 03 00 00 00       	mov    $0x3,%eax
  801d5e:	e8 ed fe ff ff       	call   801c50 <fsipc>
  801d63:	89 c3                	mov    %eax,%ebx
  801d65:	85 c0                	test   %eax,%eax
  801d67:	78 6a                	js     801dd3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d69:	39 c6                	cmp    %eax,%esi
  801d6b:	73 24                	jae    801d91 <devfile_read+0x59>
  801d6d:	c7 44 24 0c fc 2f 80 	movl   $0x802ffc,0xc(%esp)
  801d74:	00 
  801d75:	c7 44 24 08 03 30 80 	movl   $0x803003,0x8(%esp)
  801d7c:	00 
  801d7d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801d84:	00 
  801d85:	c7 04 24 18 30 80 00 	movl   $0x803018,(%esp)
  801d8c:	e8 f3 e5 ff ff       	call   800384 <_panic>
	assert(r <= PGSIZE);
  801d91:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d96:	7e 24                	jle    801dbc <devfile_read+0x84>
  801d98:	c7 44 24 0c 23 30 80 	movl   $0x803023,0xc(%esp)
  801d9f:	00 
  801da0:	c7 44 24 08 03 30 80 	movl   $0x803003,0x8(%esp)
  801da7:	00 
  801da8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801daf:	00 
  801db0:	c7 04 24 18 30 80 00 	movl   $0x803018,(%esp)
  801db7:	e8 c8 e5 ff ff       	call   800384 <_panic>
	memmove(buf, &fsipcbuf, r);
  801dbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dc0:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801dc7:	00 
  801dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcb:	89 04 24             	mov    %eax,(%esp)
  801dce:	e8 b9 ee ff ff       	call   800c8c <memmove>
	return r;
}
  801dd3:	89 d8                	mov    %ebx,%eax
  801dd5:	83 c4 10             	add    $0x10,%esp
  801dd8:	5b                   	pop    %ebx
  801dd9:	5e                   	pop    %esi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    

00801ddc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	56                   	push   %esi
  801de0:	53                   	push   %ebx
  801de1:	83 ec 20             	sub    $0x20,%esp
  801de4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801de7:	89 34 24             	mov    %esi,(%esp)
  801dea:	e8 61 ec ff ff       	call   800a50 <strlen>
		return -E_BAD_PATH;
  801def:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801df4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801df9:	7f 5e                	jg     801e59 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801dfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfe:	89 04 24             	mov    %eax,(%esp)
  801e01:	e8 35 f8 ff ff       	call   80163b <fd_alloc>
  801e06:	89 c3                	mov    %eax,%ebx
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	78 4d                	js     801e59 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e10:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e17:	e8 7f ec ff ff       	call   800a9b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1f:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e27:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2c:	e8 1f fe ff ff       	call   801c50 <fsipc>
  801e31:	89 c3                	mov    %eax,%ebx
  801e33:	85 c0                	test   %eax,%eax
  801e35:	79 15                	jns    801e4c <open+0x70>
		fd_close(fd, 0);
  801e37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e3e:	00 
  801e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e42:	89 04 24             	mov    %eax,(%esp)
  801e45:	e8 21 f9 ff ff       	call   80176b <fd_close>
		return r;
  801e4a:	eb 0d                	jmp    801e59 <open+0x7d>
	}

	return fd2num(fd);
  801e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4f:	89 04 24             	mov    %eax,(%esp)
  801e52:	e8 b9 f7 ff ff       	call   801610 <fd2num>
  801e57:	89 c3                	mov    %eax,%ebx
}
  801e59:	89 d8                	mov    %ebx,%eax
  801e5b:	83 c4 20             	add    $0x20,%esp
  801e5e:	5b                   	pop    %ebx
  801e5f:	5e                   	pop    %esi
  801e60:	5d                   	pop    %ebp
  801e61:	c3                   	ret    
	...

00801e70 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 18             	sub    $0x18,%esp
  801e76:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e79:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e7c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	89 04 24             	mov    %eax,(%esp)
  801e85:	e8 96 f7 ff ff       	call   801620 <fd2data>
  801e8a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801e8c:	c7 44 24 04 2f 30 80 	movl   $0x80302f,0x4(%esp)
  801e93:	00 
  801e94:	89 34 24             	mov    %esi,(%esp)
  801e97:	e8 ff eb ff ff       	call   800a9b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e9c:	8b 43 04             	mov    0x4(%ebx),%eax
  801e9f:	2b 03                	sub    (%ebx),%eax
  801ea1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801ea7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801eae:	00 00 00 
	stat->st_dev = &devpipe;
  801eb1:	c7 86 88 00 00 00 24 	movl   $0x804024,0x88(%esi)
  801eb8:	40 80 00 
	return 0;
}
  801ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ec3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ec6:	89 ec                	mov    %ebp,%esp
  801ec8:	5d                   	pop    %ebp
  801ec9:	c3                   	ret    

00801eca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	53                   	push   %ebx
  801ece:	83 ec 14             	sub    $0x14,%esp
  801ed1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ed4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ed8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801edf:	e8 75 f1 ff ff       	call   801059 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ee4:	89 1c 24             	mov    %ebx,(%esp)
  801ee7:	e8 34 f7 ff ff       	call   801620 <fd2data>
  801eec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef7:	e8 5d f1 ff ff       	call   801059 <sys_page_unmap>
}
  801efc:	83 c4 14             	add    $0x14,%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5d                   	pop    %ebp
  801f01:	c3                   	ret    

00801f02 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	57                   	push   %edi
  801f06:	56                   	push   %esi
  801f07:	53                   	push   %ebx
  801f08:	83 ec 2c             	sub    $0x2c,%esp
  801f0b:	89 c7                	mov    %eax,%edi
  801f0d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f10:	a1 04 50 80 00       	mov    0x805004,%eax
  801f15:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f18:	89 3c 24             	mov    %edi,(%esp)
  801f1b:	e8 00 07 00 00       	call   802620 <pageref>
  801f20:	89 c6                	mov    %eax,%esi
  801f22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f25:	89 04 24             	mov    %eax,(%esp)
  801f28:	e8 f3 06 00 00       	call   802620 <pageref>
  801f2d:	39 c6                	cmp    %eax,%esi
  801f2f:	0f 94 c0             	sete   %al
  801f32:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801f35:	8b 15 04 50 80 00    	mov    0x805004,%edx
  801f3b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f3e:	39 cb                	cmp    %ecx,%ebx
  801f40:	75 08                	jne    801f4a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801f42:	83 c4 2c             	add    $0x2c,%esp
  801f45:	5b                   	pop    %ebx
  801f46:	5e                   	pop    %esi
  801f47:	5f                   	pop    %edi
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801f4a:	83 f8 01             	cmp    $0x1,%eax
  801f4d:	75 c1                	jne    801f10 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f4f:	8b 52 58             	mov    0x58(%edx),%edx
  801f52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f56:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f5e:	c7 04 24 36 30 80 00 	movl   $0x803036,(%esp)
  801f65:	e8 15 e5 ff ff       	call   80047f <cprintf>
  801f6a:	eb a4                	jmp    801f10 <_pipeisclosed+0xe>

00801f6c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	57                   	push   %edi
  801f70:	56                   	push   %esi
  801f71:	53                   	push   %ebx
  801f72:	83 ec 2c             	sub    $0x2c,%esp
  801f75:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f78:	89 34 24             	mov    %esi,(%esp)
  801f7b:	e8 a0 f6 ff ff       	call   801620 <fd2data>
  801f80:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f82:	bf 00 00 00 00       	mov    $0x0,%edi
  801f87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f8b:	75 50                	jne    801fdd <devpipe_write+0x71>
  801f8d:	eb 5c                	jmp    801feb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f8f:	89 da                	mov    %ebx,%edx
  801f91:	89 f0                	mov    %esi,%eax
  801f93:	e8 6a ff ff ff       	call   801f02 <_pipeisclosed>
  801f98:	85 c0                	test   %eax,%eax
  801f9a:	75 53                	jne    801fef <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f9c:	e8 cb ef ff ff       	call   800f6c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fa1:	8b 43 04             	mov    0x4(%ebx),%eax
  801fa4:	8b 13                	mov    (%ebx),%edx
  801fa6:	83 c2 20             	add    $0x20,%edx
  801fa9:	39 d0                	cmp    %edx,%eax
  801fab:	73 e2                	jae    801f8f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801fb4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801fb7:	89 c2                	mov    %eax,%edx
  801fb9:	c1 fa 1f             	sar    $0x1f,%edx
  801fbc:	c1 ea 1b             	shr    $0x1b,%edx
  801fbf:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801fc2:	83 e1 1f             	and    $0x1f,%ecx
  801fc5:	29 d1                	sub    %edx,%ecx
  801fc7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801fcb:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801fcf:	83 c0 01             	add    $0x1,%eax
  801fd2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fd5:	83 c7 01             	add    $0x1,%edi
  801fd8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fdb:	74 0e                	je     801feb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fdd:	8b 43 04             	mov    0x4(%ebx),%eax
  801fe0:	8b 13                	mov    (%ebx),%edx
  801fe2:	83 c2 20             	add    $0x20,%edx
  801fe5:	39 d0                	cmp    %edx,%eax
  801fe7:	73 a6                	jae    801f8f <devpipe_write+0x23>
  801fe9:	eb c2                	jmp    801fad <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801feb:	89 f8                	mov    %edi,%eax
  801fed:	eb 05                	jmp    801ff4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fef:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ff4:	83 c4 2c             	add    $0x2c,%esp
  801ff7:	5b                   	pop    %ebx
  801ff8:	5e                   	pop    %esi
  801ff9:	5f                   	pop    %edi
  801ffa:	5d                   	pop    %ebp
  801ffb:	c3                   	ret    

00801ffc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 28             	sub    $0x28,%esp
  802002:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802005:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802008:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80200b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80200e:	89 3c 24             	mov    %edi,(%esp)
  802011:	e8 0a f6 ff ff       	call   801620 <fd2data>
  802016:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802018:	be 00 00 00 00       	mov    $0x0,%esi
  80201d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802021:	75 47                	jne    80206a <devpipe_read+0x6e>
  802023:	eb 52                	jmp    802077 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802025:	89 f0                	mov    %esi,%eax
  802027:	eb 5e                	jmp    802087 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802029:	89 da                	mov    %ebx,%edx
  80202b:	89 f8                	mov    %edi,%eax
  80202d:	8d 76 00             	lea    0x0(%esi),%esi
  802030:	e8 cd fe ff ff       	call   801f02 <_pipeisclosed>
  802035:	85 c0                	test   %eax,%eax
  802037:	75 49                	jne    802082 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802039:	e8 2e ef ff ff       	call   800f6c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80203e:	8b 03                	mov    (%ebx),%eax
  802040:	3b 43 04             	cmp    0x4(%ebx),%eax
  802043:	74 e4                	je     802029 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802045:	89 c2                	mov    %eax,%edx
  802047:	c1 fa 1f             	sar    $0x1f,%edx
  80204a:	c1 ea 1b             	shr    $0x1b,%edx
  80204d:	01 d0                	add    %edx,%eax
  80204f:	83 e0 1f             	and    $0x1f,%eax
  802052:	29 d0                	sub    %edx,%eax
  802054:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802059:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80205f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802062:	83 c6 01             	add    $0x1,%esi
  802065:	3b 75 10             	cmp    0x10(%ebp),%esi
  802068:	74 0d                	je     802077 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80206a:	8b 03                	mov    (%ebx),%eax
  80206c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80206f:	75 d4                	jne    802045 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802071:	85 f6                	test   %esi,%esi
  802073:	75 b0                	jne    802025 <devpipe_read+0x29>
  802075:	eb b2                	jmp    802029 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802077:	89 f0                	mov    %esi,%eax
  802079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802080:	eb 05                	jmp    802087 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802082:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802087:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80208a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80208d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802090:	89 ec                	mov    %ebp,%esp
  802092:	5d                   	pop    %ebp
  802093:	c3                   	ret    

00802094 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 48             	sub    $0x48,%esp
  80209a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80209d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8020a0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8020a3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8020a9:	89 04 24             	mov    %eax,(%esp)
  8020ac:	e8 8a f5 ff ff       	call   80163b <fd_alloc>
  8020b1:	89 c3                	mov    %eax,%ebx
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	0f 88 45 01 00 00    	js     802200 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020bb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020c2:	00 
  8020c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d1:	e8 c6 ee ff ff       	call   800f9c <sys_page_alloc>
  8020d6:	89 c3                	mov    %eax,%ebx
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	0f 88 20 01 00 00    	js     802200 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8020e0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8020e3:	89 04 24             	mov    %eax,(%esp)
  8020e6:	e8 50 f5 ff ff       	call   80163b <fd_alloc>
  8020eb:	89 c3                	mov    %eax,%ebx
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	0f 88 f8 00 00 00    	js     8021ed <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020f5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020fc:	00 
  8020fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802100:	89 44 24 04          	mov    %eax,0x4(%esp)
  802104:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80210b:	e8 8c ee ff ff       	call   800f9c <sys_page_alloc>
  802110:	89 c3                	mov    %eax,%ebx
  802112:	85 c0                	test   %eax,%eax
  802114:	0f 88 d3 00 00 00    	js     8021ed <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80211a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80211d:	89 04 24             	mov    %eax,(%esp)
  802120:	e8 fb f4 ff ff       	call   801620 <fd2data>
  802125:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802127:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80212e:	00 
  80212f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213a:	e8 5d ee ff ff       	call   800f9c <sys_page_alloc>
  80213f:	89 c3                	mov    %eax,%ebx
  802141:	85 c0                	test   %eax,%eax
  802143:	0f 88 91 00 00 00    	js     8021da <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802149:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80214c:	89 04 24             	mov    %eax,(%esp)
  80214f:	e8 cc f4 ff ff       	call   801620 <fd2data>
  802154:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80215b:	00 
  80215c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802160:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802167:	00 
  802168:	89 74 24 04          	mov    %esi,0x4(%esp)
  80216c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802173:	e8 83 ee ff ff       	call   800ffb <sys_page_map>
  802178:	89 c3                	mov    %eax,%ebx
  80217a:	85 c0                	test   %eax,%eax
  80217c:	78 4c                	js     8021ca <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80217e:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802187:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802189:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80218c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802193:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802199:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80219c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80219e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8021a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021ab:	89 04 24             	mov    %eax,(%esp)
  8021ae:	e8 5d f4 ff ff       	call   801610 <fd2num>
  8021b3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8021b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021b8:	89 04 24             	mov    %eax,(%esp)
  8021bb:	e8 50 f4 ff ff       	call   801610 <fd2num>
  8021c0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8021c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021c8:	eb 36                	jmp    802200 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  8021ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d5:	e8 7f ee ff ff       	call   801059 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8021da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e8:	e8 6c ee ff ff       	call   801059 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8021ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021fb:	e8 59 ee ff ff       	call   801059 <sys_page_unmap>
    err:
	return r;
}
  802200:	89 d8                	mov    %ebx,%eax
  802202:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802205:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802208:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80220b:	89 ec                	mov    %ebp,%esp
  80220d:	5d                   	pop    %ebp
  80220e:	c3                   	ret    

0080220f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
  802212:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802215:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802218:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	89 04 24             	mov    %eax,(%esp)
  802222:	e8 87 f4 ff ff       	call   8016ae <fd_lookup>
  802227:	85 c0                	test   %eax,%eax
  802229:	78 15                	js     802240 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222e:	89 04 24             	mov    %eax,(%esp)
  802231:	e8 ea f3 ff ff       	call   801620 <fd2data>
	return _pipeisclosed(fd, p);
  802236:	89 c2                	mov    %eax,%edx
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	e8 c2 fc ff ff       	call   801f02 <_pipeisclosed>
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    
	...

00802244 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	56                   	push   %esi
  802248:	53                   	push   %ebx
  802249:	83 ec 10             	sub    $0x10,%esp
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  80224f:	85 c0                	test   %eax,%eax
  802251:	75 24                	jne    802277 <wait+0x33>
  802253:	c7 44 24 0c 4e 30 80 	movl   $0x80304e,0xc(%esp)
  80225a:	00 
  80225b:	c7 44 24 08 03 30 80 	movl   $0x803003,0x8(%esp)
  802262:	00 
  802263:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  80226a:	00 
  80226b:	c7 04 24 59 30 80 00 	movl   $0x803059,(%esp)
  802272:	e8 0d e1 ff ff       	call   800384 <_panic>
	e = &envs[ENVX(envid)];
  802277:	89 c3                	mov    %eax,%ebx
  802279:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80227f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802282:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802288:	8b 73 48             	mov    0x48(%ebx),%esi
  80228b:	39 c6                	cmp    %eax,%esi
  80228d:	75 1a                	jne    8022a9 <wait+0x65>
  80228f:	8b 43 54             	mov    0x54(%ebx),%eax
  802292:	85 c0                	test   %eax,%eax
  802294:	74 13                	je     8022a9 <wait+0x65>
		sys_yield();
  802296:	e8 d1 ec ff ff       	call   800f6c <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80229b:	8b 43 48             	mov    0x48(%ebx),%eax
  80229e:	39 f0                	cmp    %esi,%eax
  8022a0:	75 07                	jne    8022a9 <wait+0x65>
  8022a2:	8b 43 54             	mov    0x54(%ebx),%eax
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	75 ed                	jne    802296 <wait+0x52>
		sys_yield();
}
  8022a9:	83 c4 10             	add    $0x10,%esp
  8022ac:	5b                   	pop    %ebx
  8022ad:	5e                   	pop    %esi
  8022ae:	5d                   	pop    %ebp
  8022af:	c3                   	ret    

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
  8022c0:	c7 44 24 04 64 30 80 	movl   $0x803064,0x4(%esp)
  8022c7:	00 
  8022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cb:	89 04 24             	mov    %eax,(%esp)
  8022ce:	e8 c8 e7 ff ff       	call   800a9b <strcpy>
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
  80231a:	e8 6d e9 ff ff       	call   800c8c <memmove>
		sys_cputs(buf, m);
  80231f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802323:	89 3c 24             	mov    %edi,(%esp)
  802326:	e8 55 eb ff ff       	call   800e80 <sys_cputs>
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
  802354:	e8 13 ec ff ff       	call   800f6c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802360:	e8 4a eb ff ff       	call   800eaf <sys_cgetc>
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
  8023a1:	e8 da ea ff ff       	call   800e80 <sys_cputs>
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
  8023c4:	e8 a5 f5 ff ff       	call   80196e <read>
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
  8023f1:	e8 b8 f2 ff ff       	call   8016ae <fd_lookup>
  8023f6:	85 c0                	test   %eax,%eax
  8023f8:	78 11                	js     80240b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 15 40 40 80 00    	mov    0x804040,%edx
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
  802419:	e8 1d f2 ff ff       	call   80163b <fd_alloc>
  80241e:	85 c0                	test   %eax,%eax
  802420:	78 3c                	js     80245e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802422:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802429:	00 
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802431:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802438:	e8 5f eb ff ff       	call   800f9c <sys_page_alloc>
  80243d:	85 c0                	test   %eax,%eax
  80243f:	78 1d                	js     80245e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802441:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802456:	89 04 24             	mov    %eax,(%esp)
  802459:	e8 b2 f1 ff ff       	call   801610 <fd2num>
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
  802466:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80246d:	75 54                	jne    8024c3 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  80246f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802476:	00 
  802477:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80247e:	ee 
  80247f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802486:	e8 11 eb ff ff       	call   800f9c <sys_page_alloc>
  80248b:	85 c0                	test   %eax,%eax
  80248d:	79 20                	jns    8024af <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  80248f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802493:	c7 44 24 08 70 30 80 	movl   $0x803070,0x8(%esp)
  80249a:	00 
  80249b:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8024a2:	00 
  8024a3:	c7 04 24 88 30 80 00 	movl   $0x803088,(%esp)
  8024aa:	e8 d5 de ff ff       	call   800384 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8024af:	c7 44 24 04 d0 24 80 	movl   $0x8024d0,0x4(%esp)
  8024b6:	00 
  8024b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024be:	e8 b0 ec ff ff       	call   801173 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	a3 00 70 80 00       	mov    %eax,0x807000
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
  8024d1:	a1 00 70 80 00       	mov    0x807000,%eax
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

00802500 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	56                   	push   %esi
  802504:	53                   	push   %ebx
  802505:	83 ec 10             	sub    $0x10,%esp
  802508:	8b 75 08             	mov    0x8(%ebp),%esi
  80250b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802511:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802513:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802518:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80251b:	89 04 24             	mov    %eax,(%esp)
  80251e:	e8 e2 ec ff ff       	call   801205 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802523:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802528:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80252d:	85 c0                	test   %eax,%eax
  80252f:	78 0e                	js     80253f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  802531:	a1 04 50 80 00       	mov    0x805004,%eax
  802536:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  802539:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80253c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80253f:	85 f6                	test   %esi,%esi
  802541:	74 02                	je     802545 <ipc_recv+0x45>
		*from_env_store = sender;
  802543:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  802545:	85 db                	test   %ebx,%ebx
  802547:	74 02                	je     80254b <ipc_recv+0x4b>
		*perm_store = perm;
  802549:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80254b:	83 c4 10             	add    $0x10,%esp
  80254e:	5b                   	pop    %ebx
  80254f:	5e                   	pop    %esi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    

00802552 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
  802555:	57                   	push   %edi
  802556:	56                   	push   %esi
  802557:	53                   	push   %ebx
  802558:	83 ec 1c             	sub    $0x1c,%esp
  80255b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80255e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802561:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  802564:	85 db                	test   %ebx,%ebx
  802566:	75 04                	jne    80256c <ipc_send+0x1a>
  802568:	85 f6                	test   %esi,%esi
  80256a:	75 15                	jne    802581 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80256c:	85 db                	test   %ebx,%ebx
  80256e:	74 16                	je     802586 <ipc_send+0x34>
  802570:	85 f6                	test   %esi,%esi
  802572:	0f 94 c0             	sete   %al
      pg = 0;
  802575:	84 c0                	test   %al,%al
  802577:	b8 00 00 00 00       	mov    $0x0,%eax
  80257c:	0f 45 d8             	cmovne %eax,%ebx
  80257f:	eb 05                	jmp    802586 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802581:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802586:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80258a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80258e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	89 04 24             	mov    %eax,(%esp)
  802598:	e8 34 ec ff ff       	call   8011d1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80259d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025a0:	75 07                	jne    8025a9 <ipc_send+0x57>
           sys_yield();
  8025a2:	e8 c5 e9 ff ff       	call   800f6c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  8025a7:	eb dd                	jmp    802586 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	90                   	nop
  8025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b0:	74 1c                	je     8025ce <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  8025b2:	c7 44 24 08 96 30 80 	movl   $0x803096,0x8(%esp)
  8025b9:	00 
  8025ba:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8025c1:	00 
  8025c2:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  8025c9:	e8 b6 dd ff ff       	call   800384 <_panic>
		}
    }
}
  8025ce:	83 c4 1c             	add    $0x1c,%esp
  8025d1:	5b                   	pop    %ebx
  8025d2:	5e                   	pop    %esi
  8025d3:	5f                   	pop    %edi
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    

008025d6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
  8025d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8025dc:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8025e1:	39 c8                	cmp    %ecx,%eax
  8025e3:	74 17                	je     8025fc <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8025e5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8025ea:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025ed:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025f3:	8b 52 50             	mov    0x50(%edx),%edx
  8025f6:	39 ca                	cmp    %ecx,%edx
  8025f8:	75 14                	jne    80260e <ipc_find_env+0x38>
  8025fa:	eb 05                	jmp    802601 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802601:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802604:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802609:	8b 40 40             	mov    0x40(%eax),%eax
  80260c:	eb 0e                	jmp    80261c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80260e:	83 c0 01             	add    $0x1,%eax
  802611:	3d 00 04 00 00       	cmp    $0x400,%eax
  802616:	75 d2                	jne    8025ea <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802618:	66 b8 00 00          	mov    $0x0,%ax
}
  80261c:	5d                   	pop    %ebp
  80261d:	c3                   	ret    
	...

00802620 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802626:	89 d0                	mov    %edx,%eax
  802628:	c1 e8 16             	shr    $0x16,%eax
  80262b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802637:	f6 c1 01             	test   $0x1,%cl
  80263a:	74 1d                	je     802659 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80263c:	c1 ea 0c             	shr    $0xc,%edx
  80263f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802646:	f6 c2 01             	test   $0x1,%dl
  802649:	74 0e                	je     802659 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80264b:	c1 ea 0c             	shr    $0xc,%edx
  80264e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802655:	ef 
  802656:	0f b7 c0             	movzwl %ax,%eax
}
  802659:	5d                   	pop    %ebp
  80265a:	c3                   	ret    
  80265b:	00 00                	add    %al,(%eax)
  80265d:	00 00                	add    %al,(%eax)
	...

00802660 <__udivdi3>:
  802660:	83 ec 1c             	sub    $0x1c,%esp
  802663:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802667:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80266b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80266f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802673:	89 74 24 10          	mov    %esi,0x10(%esp)
  802677:	8b 74 24 24          	mov    0x24(%esp),%esi
  80267b:	85 ff                	test   %edi,%edi
  80267d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802681:	89 44 24 08          	mov    %eax,0x8(%esp)
  802685:	89 cd                	mov    %ecx,%ebp
  802687:	89 44 24 04          	mov    %eax,0x4(%esp)
  80268b:	75 33                	jne    8026c0 <__udivdi3+0x60>
  80268d:	39 f1                	cmp    %esi,%ecx
  80268f:	77 57                	ja     8026e8 <__udivdi3+0x88>
  802691:	85 c9                	test   %ecx,%ecx
  802693:	75 0b                	jne    8026a0 <__udivdi3+0x40>
  802695:	b8 01 00 00 00       	mov    $0x1,%eax
  80269a:	31 d2                	xor    %edx,%edx
  80269c:	f7 f1                	div    %ecx
  80269e:	89 c1                	mov    %eax,%ecx
  8026a0:	89 f0                	mov    %esi,%eax
  8026a2:	31 d2                	xor    %edx,%edx
  8026a4:	f7 f1                	div    %ecx
  8026a6:	89 c6                	mov    %eax,%esi
  8026a8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026ac:	f7 f1                	div    %ecx
  8026ae:	89 f2                	mov    %esi,%edx
  8026b0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026b4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026b8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026bc:	83 c4 1c             	add    $0x1c,%esp
  8026bf:	c3                   	ret    
  8026c0:	31 d2                	xor    %edx,%edx
  8026c2:	31 c0                	xor    %eax,%eax
  8026c4:	39 f7                	cmp    %esi,%edi
  8026c6:	77 e8                	ja     8026b0 <__udivdi3+0x50>
  8026c8:	0f bd cf             	bsr    %edi,%ecx
  8026cb:	83 f1 1f             	xor    $0x1f,%ecx
  8026ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8026d2:	75 2c                	jne    802700 <__udivdi3+0xa0>
  8026d4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  8026d8:	76 04                	jbe    8026de <__udivdi3+0x7e>
  8026da:	39 f7                	cmp    %esi,%edi
  8026dc:	73 d2                	jae    8026b0 <__udivdi3+0x50>
  8026de:	31 d2                	xor    %edx,%edx
  8026e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8026e5:	eb c9                	jmp    8026b0 <__udivdi3+0x50>
  8026e7:	90                   	nop
  8026e8:	89 f2                	mov    %esi,%edx
  8026ea:	f7 f1                	div    %ecx
  8026ec:	31 d2                	xor    %edx,%edx
  8026ee:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026f2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026f6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026fa:	83 c4 1c             	add    $0x1c,%esp
  8026fd:	c3                   	ret    
  8026fe:	66 90                	xchg   %ax,%ax
  802700:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802705:	b8 20 00 00 00       	mov    $0x20,%eax
  80270a:	89 ea                	mov    %ebp,%edx
  80270c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802710:	d3 e7                	shl    %cl,%edi
  802712:	89 c1                	mov    %eax,%ecx
  802714:	d3 ea                	shr    %cl,%edx
  802716:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80271b:	09 fa                	or     %edi,%edx
  80271d:	89 f7                	mov    %esi,%edi
  80271f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802723:	89 f2                	mov    %esi,%edx
  802725:	8b 74 24 08          	mov    0x8(%esp),%esi
  802729:	d3 e5                	shl    %cl,%ebp
  80272b:	89 c1                	mov    %eax,%ecx
  80272d:	d3 ef                	shr    %cl,%edi
  80272f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802734:	d3 e2                	shl    %cl,%edx
  802736:	89 c1                	mov    %eax,%ecx
  802738:	d3 ee                	shr    %cl,%esi
  80273a:	09 d6                	or     %edx,%esi
  80273c:	89 fa                	mov    %edi,%edx
  80273e:	89 f0                	mov    %esi,%eax
  802740:	f7 74 24 0c          	divl   0xc(%esp)
  802744:	89 d7                	mov    %edx,%edi
  802746:	89 c6                	mov    %eax,%esi
  802748:	f7 e5                	mul    %ebp
  80274a:	39 d7                	cmp    %edx,%edi
  80274c:	72 22                	jb     802770 <__udivdi3+0x110>
  80274e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802752:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802757:	d3 e5                	shl    %cl,%ebp
  802759:	39 c5                	cmp    %eax,%ebp
  80275b:	73 04                	jae    802761 <__udivdi3+0x101>
  80275d:	39 d7                	cmp    %edx,%edi
  80275f:	74 0f                	je     802770 <__udivdi3+0x110>
  802761:	89 f0                	mov    %esi,%eax
  802763:	31 d2                	xor    %edx,%edx
  802765:	e9 46 ff ff ff       	jmp    8026b0 <__udivdi3+0x50>
  80276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802770:	8d 46 ff             	lea    -0x1(%esi),%eax
  802773:	31 d2                	xor    %edx,%edx
  802775:	8b 74 24 10          	mov    0x10(%esp),%esi
  802779:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80277d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802781:	83 c4 1c             	add    $0x1c,%esp
  802784:	c3                   	ret    
	...

00802790 <__umoddi3>:
  802790:	83 ec 1c             	sub    $0x1c,%esp
  802793:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802797:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80279b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80279f:	89 74 24 10          	mov    %esi,0x10(%esp)
  8027a3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8027a7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8027ab:	85 ed                	test   %ebp,%ebp
  8027ad:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8027b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027b5:	89 cf                	mov    %ecx,%edi
  8027b7:	89 04 24             	mov    %eax,(%esp)
  8027ba:	89 f2                	mov    %esi,%edx
  8027bc:	75 1a                	jne    8027d8 <__umoddi3+0x48>
  8027be:	39 f1                	cmp    %esi,%ecx
  8027c0:	76 4e                	jbe    802810 <__umoddi3+0x80>
  8027c2:	f7 f1                	div    %ecx
  8027c4:	89 d0                	mov    %edx,%eax
  8027c6:	31 d2                	xor    %edx,%edx
  8027c8:	8b 74 24 10          	mov    0x10(%esp),%esi
  8027cc:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8027d0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8027d4:	83 c4 1c             	add    $0x1c,%esp
  8027d7:	c3                   	ret    
  8027d8:	39 f5                	cmp    %esi,%ebp
  8027da:	77 54                	ja     802830 <__umoddi3+0xa0>
  8027dc:	0f bd c5             	bsr    %ebp,%eax
  8027df:	83 f0 1f             	xor    $0x1f,%eax
  8027e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e6:	75 60                	jne    802848 <__umoddi3+0xb8>
  8027e8:	3b 0c 24             	cmp    (%esp),%ecx
  8027eb:	0f 87 07 01 00 00    	ja     8028f8 <__umoddi3+0x168>
  8027f1:	89 f2                	mov    %esi,%edx
  8027f3:	8b 34 24             	mov    (%esp),%esi
  8027f6:	29 ce                	sub    %ecx,%esi
  8027f8:	19 ea                	sbb    %ebp,%edx
  8027fa:	89 34 24             	mov    %esi,(%esp)
  8027fd:	8b 04 24             	mov    (%esp),%eax
  802800:	8b 74 24 10          	mov    0x10(%esp),%esi
  802804:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802808:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80280c:	83 c4 1c             	add    $0x1c,%esp
  80280f:	c3                   	ret    
  802810:	85 c9                	test   %ecx,%ecx
  802812:	75 0b                	jne    80281f <__umoddi3+0x8f>
  802814:	b8 01 00 00 00       	mov    $0x1,%eax
  802819:	31 d2                	xor    %edx,%edx
  80281b:	f7 f1                	div    %ecx
  80281d:	89 c1                	mov    %eax,%ecx
  80281f:	89 f0                	mov    %esi,%eax
  802821:	31 d2                	xor    %edx,%edx
  802823:	f7 f1                	div    %ecx
  802825:	8b 04 24             	mov    (%esp),%eax
  802828:	f7 f1                	div    %ecx
  80282a:	eb 98                	jmp    8027c4 <__umoddi3+0x34>
  80282c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802830:	89 f2                	mov    %esi,%edx
  802832:	8b 74 24 10          	mov    0x10(%esp),%esi
  802836:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80283a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80283e:	83 c4 1c             	add    $0x1c,%esp
  802841:	c3                   	ret    
  802842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802848:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80284d:	89 e8                	mov    %ebp,%eax
  80284f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802854:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802858:	89 fa                	mov    %edi,%edx
  80285a:	d3 e0                	shl    %cl,%eax
  80285c:	89 e9                	mov    %ebp,%ecx
  80285e:	d3 ea                	shr    %cl,%edx
  802860:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802865:	09 c2                	or     %eax,%edx
  802867:	8b 44 24 08          	mov    0x8(%esp),%eax
  80286b:	89 14 24             	mov    %edx,(%esp)
  80286e:	89 f2                	mov    %esi,%edx
  802870:	d3 e7                	shl    %cl,%edi
  802872:	89 e9                	mov    %ebp,%ecx
  802874:	d3 ea                	shr    %cl,%edx
  802876:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80287b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80287f:	d3 e6                	shl    %cl,%esi
  802881:	89 e9                	mov    %ebp,%ecx
  802883:	d3 e8                	shr    %cl,%eax
  802885:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80288a:	09 f0                	or     %esi,%eax
  80288c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802890:	f7 34 24             	divl   (%esp)
  802893:	d3 e6                	shl    %cl,%esi
  802895:	89 74 24 08          	mov    %esi,0x8(%esp)
  802899:	89 d6                	mov    %edx,%esi
  80289b:	f7 e7                	mul    %edi
  80289d:	39 d6                	cmp    %edx,%esi
  80289f:	89 c1                	mov    %eax,%ecx
  8028a1:	89 d7                	mov    %edx,%edi
  8028a3:	72 3f                	jb     8028e4 <__umoddi3+0x154>
  8028a5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8028a9:	72 35                	jb     8028e0 <__umoddi3+0x150>
  8028ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028af:	29 c8                	sub    %ecx,%eax
  8028b1:	19 fe                	sbb    %edi,%esi
  8028b3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028b8:	89 f2                	mov    %esi,%edx
  8028ba:	d3 e8                	shr    %cl,%eax
  8028bc:	89 e9                	mov    %ebp,%ecx
  8028be:	d3 e2                	shl    %cl,%edx
  8028c0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028c5:	09 d0                	or     %edx,%eax
  8028c7:	89 f2                	mov    %esi,%edx
  8028c9:	d3 ea                	shr    %cl,%edx
  8028cb:	8b 74 24 10          	mov    0x10(%esp),%esi
  8028cf:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8028d3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8028d7:	83 c4 1c             	add    $0x1c,%esp
  8028da:	c3                   	ret    
  8028db:	90                   	nop
  8028dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028e0:	39 d6                	cmp    %edx,%esi
  8028e2:	75 c7                	jne    8028ab <__umoddi3+0x11b>
  8028e4:	89 d7                	mov    %edx,%edi
  8028e6:	89 c1                	mov    %eax,%ecx
  8028e8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8028ec:	1b 3c 24             	sbb    (%esp),%edi
  8028ef:	eb ba                	jmp    8028ab <__umoddi3+0x11b>
  8028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	39 f5                	cmp    %esi,%ebp
  8028fa:	0f 82 f1 fe ff ff    	jb     8027f1 <__umoddi3+0x61>
  802900:	e9 f8 fe ff ff       	jmp    8027fd <__umoddi3+0x6d>
