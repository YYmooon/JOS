
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 1f 05 00 00       	call   800550 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  800040:	8b 7d 08             	mov    0x8(%ebp),%edi
  800043:	8b 75 0c             	mov    0xc(%ebp),%esi
  800046:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800049:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80004d:	89 3c 24             	mov    %edi,(%esp)
  800050:	e8 c4 1c 00 00       	call   801d19 <seek>
	seek(kfd, off);
  800055:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800059:	89 34 24             	mov    %esi,(%esp)
  80005c:	e8 b8 1c 00 00       	call   801d19 <seek>

	cprintf("shell produced incorrect output.\n");
  800061:	c7 04 24 40 30 80 00 	movl   $0x803040,(%esp)
  800068:	e8 4a 06 00 00       	call   8006b7 <cprintf>
	cprintf("expected:\n===\n");
  80006d:	c7 04 24 ab 30 80 00 	movl   $0x8030ab,(%esp)
  800074:	e8 3e 06 00 00       	call   8006b7 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800079:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007c:	eb 0c                	jmp    80008a <wrong+0x56>
		sys_cputs(buf, n);
  80007e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800082:	89 1c 24             	mov    %ebx,(%esp)
  800085:	e8 36 10 00 00       	call   8010c0 <sys_cputs>
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  80008a:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  800091:	00 
  800092:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800096:	89 34 24             	mov    %esi,(%esp)
  800099:	e8 10 1b 00 00       	call   801bae <read>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	7f dc                	jg     80007e <wrong+0x4a>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8000a2:	c7 04 24 ba 30 80 00 	movl   $0x8030ba,(%esp)
  8000a9:	e8 09 06 00 00       	call   8006b7 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ae:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b1:	eb 0c                	jmp    8000bf <wrong+0x8b>
		sys_cputs(buf, n);
  8000b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b7:	89 1c 24             	mov    %ebx,(%esp)
  8000ba:	e8 01 10 00 00       	call   8010c0 <sys_cputs>
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bf:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000c6:	00 
  8000c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000cb:	89 3c 24             	mov    %edi,(%esp)
  8000ce:	e8 db 1a 00 00       	call   801bae <read>
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	7f dc                	jg     8000b3 <wrong+0x7f>
		sys_cputs(buf, n);
	cprintf("===\n");
  8000d7:	c7 04 24 b5 30 80 00 	movl   $0x8030b5,(%esp)
  8000de:	e8 d4 05 00 00       	call   8006b7 <cprintf>
	exit();
  8000e3:	e8 b8 04 00 00       	call   8005a0 <exit>
}
  8000e8:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 3c             	sub    $0x3c,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  8000fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800103:	e8 35 19 00 00       	call   801a3d <close>
	close(1);
  800108:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010f:	e8 29 19 00 00       	call   801a3d <close>
	opencons();
  800114:	e8 e4 03 00 00       	call   8004fd <opencons>
	opencons();
  800119:	e8 df 03 00 00       	call   8004fd <opencons>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80011e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 c8 30 80 00 	movl   $0x8030c8,(%esp)
  80012d:	e8 ea 1e 00 00       	call   80201c <open>
  800132:	89 c3                	mov    %eax,%ebx
  800134:	85 c0                	test   %eax,%eax
  800136:	79 20                	jns    800158 <umain+0x65>
		panic("open testshell.sh: %e", rfd);
  800138:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013c:	c7 44 24 08 d5 30 80 	movl   $0x8030d5,0x8(%esp)
  800143:	00 
  800144:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80014b:	00 
  80014c:	c7 04 24 eb 30 80 00 	movl   $0x8030eb,(%esp)
  800153:	e8 64 04 00 00       	call   8005bc <_panic>
	if ((wfd = pipe(pfds)) < 0)
  800158:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80015b:	89 04 24             	mov    %eax,(%esp)
  80015e:	e8 01 28 00 00       	call   802964 <pipe>
  800163:	85 c0                	test   %eax,%eax
  800165:	79 20                	jns    800187 <umain+0x94>
		panic("pipe: %e", wfd);
  800167:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80016b:	c7 44 24 08 fc 30 80 	movl   $0x8030fc,0x8(%esp)
  800172:	00 
  800173:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  80017a:	00 
  80017b:	c7 04 24 eb 30 80 00 	movl   $0x8030eb,(%esp)
  800182:	e8 35 04 00 00       	call   8005bc <_panic>
	wfd = pfds[1];
  800187:	8b 75 e0             	mov    -0x20(%ebp),%esi

	cprintf("running sh -x < testshell.sh | cat\n");
  80018a:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  800191:	e8 21 05 00 00       	call   8006b7 <cprintf>
	if ((r = fork()) < 0)
  800196:	e8 08 14 00 00       	call   8015a3 <fork>
  80019b:	85 c0                	test   %eax,%eax
  80019d:	79 20                	jns    8001bf <umain+0xcc>
		panic("fork: %e", r);
  80019f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a3:	c7 44 24 08 35 36 80 	movl   $0x803635,0x8(%esp)
  8001aa:	00 
  8001ab:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8001b2:	00 
  8001b3:	c7 04 24 eb 30 80 00 	movl   $0x8030eb,(%esp)
  8001ba:	e8 fd 03 00 00       	call   8005bc <_panic>
	if (r == 0) {
  8001bf:	85 c0                	test   %eax,%eax
  8001c1:	0f 85 9f 00 00 00    	jne    800266 <umain+0x173>
		dup(rfd, 0);
  8001c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001ce:	00 
  8001cf:	89 1c 24             	mov    %ebx,(%esp)
  8001d2:	e8 b9 18 00 00       	call   801a90 <dup>
		dup(wfd, 1);
  8001d7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001de:	00 
  8001df:	89 34 24             	mov    %esi,(%esp)
  8001e2:	e8 a9 18 00 00       	call   801a90 <dup>
		close(rfd);
  8001e7:	89 1c 24             	mov    %ebx,(%esp)
  8001ea:	e8 4e 18 00 00       	call   801a3d <close>
		close(wfd);
  8001ef:	89 34 24             	mov    %esi,(%esp)
  8001f2:	e8 46 18 00 00       	call   801a3d <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  8001f7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001fe:	00 
  8001ff:	c7 44 24 08 05 31 80 	movl   $0x803105,0x8(%esp)
  800206:	00 
  800207:	c7 44 24 04 d2 30 80 	movl   $0x8030d2,0x4(%esp)
  80020e:	00 
  80020f:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  800216:	e8 92 24 00 00       	call   8026ad <spawnl>
  80021b:	89 c7                	mov    %eax,%edi
  80021d:	85 c0                	test   %eax,%eax
  80021f:	79 20                	jns    800241 <umain+0x14e>
			panic("spawn: %e", r);
  800221:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800225:	c7 44 24 08 0c 31 80 	movl   $0x80310c,0x8(%esp)
  80022c:	00 
  80022d:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800234:	00 
  800235:	c7 04 24 eb 30 80 00 	movl   $0x8030eb,(%esp)
  80023c:	e8 7b 03 00 00       	call   8005bc <_panic>
		close(0);
  800241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800248:	e8 f0 17 00 00       	call   801a3d <close>
		close(1);
  80024d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800254:	e8 e4 17 00 00       	call   801a3d <close>
		wait(r);
  800259:	89 3c 24             	mov    %edi,(%esp)
  80025c:	e8 b3 28 00 00       	call   802b14 <wait>
		exit();
  800261:	e8 3a 03 00 00       	call   8005a0 <exit>
	}
	close(rfd);
  800266:	89 1c 24             	mov    %ebx,(%esp)
  800269:	e8 cf 17 00 00       	call   801a3d <close>
	close(wfd);
  80026e:	89 34 24             	mov    %esi,(%esp)
  800271:	e8 c7 17 00 00       	call   801a3d <close>

	rfd = pfds[0];
  800276:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800279:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  80027c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800283:	00 
  800284:	c7 04 24 16 31 80 00 	movl   $0x803116,(%esp)
  80028b:	e8 8c 1d 00 00       	call   80201c <open>
  800290:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800293:	85 c0                	test   %eax,%eax
  800295:	79 20                	jns    8002b7 <umain+0x1c4>
		panic("open testshell.key for reading: %e", kfd);
  800297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029b:	c7 44 24 08 88 30 80 	movl   $0x803088,0x8(%esp)
  8002a2:	00 
  8002a3:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002aa:	00 
  8002ab:	c7 04 24 eb 30 80 00 	movl   $0x8030eb,(%esp)
  8002b2:	e8 05 03 00 00       	call   8005bc <_panic>
	}
	close(rfd);
	close(wfd);

	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002b7:	bf 01 00 00 00       	mov    $0x1,%edi
  8002bc:	be 00 00 00 00       	mov    $0x0,%esi
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
		n1 = read(rfd, &c1, 1);
  8002c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002c8:	00 
  8002c9:	8d 55 e7             	lea    -0x19(%ebp),%edx
  8002cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002d3:	89 04 24             	mov    %eax,(%esp)
  8002d6:	e8 d3 18 00 00       	call   801bae <read>
  8002db:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002dd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002e4:	00 
  8002e5:	8d 55 e6             	lea    -0x1a(%ebp),%edx
  8002e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ef:	89 04 24             	mov    %eax,(%esp)
  8002f2:	e8 b7 18 00 00       	call   801bae <read>
		if (n1 < 0)
  8002f7:	85 db                	test   %ebx,%ebx
  8002f9:	79 20                	jns    80031b <umain+0x228>
			panic("reading testshell.out: %e", n1);
  8002fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002ff:	c7 44 24 08 24 31 80 	movl   $0x803124,0x8(%esp)
  800306:	00 
  800307:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80030e:	00 
  80030f:	c7 04 24 eb 30 80 00 	movl   $0x8030eb,(%esp)
  800316:	e8 a1 02 00 00       	call   8005bc <_panic>
		if (n2 < 0)
  80031b:	85 c0                	test   %eax,%eax
  80031d:	79 20                	jns    80033f <umain+0x24c>
			panic("reading testshell.key: %e", n2);
  80031f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800323:	c7 44 24 08 3e 31 80 	movl   $0x80313e,0x8(%esp)
  80032a:	00 
  80032b:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  800332:	00 
  800333:	c7 04 24 eb 30 80 00 	movl   $0x8030eb,(%esp)
  80033a:	e8 7d 02 00 00       	call   8005bc <_panic>
		if (n1 == 0 && n2 == 0)
  80033f:	89 c2                	mov    %eax,%edx
  800341:	09 da                	or     %ebx,%edx
  800343:	74 38                	je     80037d <umain+0x28a>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  800345:	83 fb 01             	cmp    $0x1,%ebx
  800348:	75 0e                	jne    800358 <umain+0x265>
  80034a:	83 f8 01             	cmp    $0x1,%eax
  80034d:	75 09                	jne    800358 <umain+0x265>
  80034f:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  800353:	38 45 e7             	cmp    %al,-0x19(%ebp)
  800356:	74 16                	je     80036e <umain+0x27b>
			wrong(rfd, kfd, nloff);
  800358:	89 74 24 08          	mov    %esi,0x8(%esp)
  80035c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800363:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800366:	89 14 24             	mov    %edx,(%esp)
  800369:	e8 c6 fc ff ff       	call   800034 <wrong>
		if (c1 == '\n')
			nloff = off+1;
  80036e:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  800372:	0f 44 f7             	cmove  %edi,%esi
  800375:	83 c7 01             	add    $0x1,%edi
	}
  800378:	e9 44 ff ff ff       	jmp    8002c1 <umain+0x1ce>
	cprintf("shell ran correctly\n");
  80037d:	c7 04 24 58 31 80 00 	movl   $0x803158,(%esp)
  800384:	e8 2e 03 00 00       	call   8006b7 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800389:	cc                   	int3   

	breakpoint();
}
  80038a:	83 c4 3c             	add    $0x3c,%esp
  80038d:	5b                   	pop    %ebx
  80038e:	5e                   	pop    %esi
  80038f:	5f                   	pop    %edi
  800390:	5d                   	pop    %ebp
  800391:	c3                   	ret    
	...

008003a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8003a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8003b0:	c7 44 24 04 6d 31 80 	movl   $0x80316d,0x4(%esp)
  8003b7:	00 
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	89 04 24             	mov    %eax,(%esp)
  8003be:	e8 18 09 00 00       	call   800cdb <strcpy>
	return 0;
}
  8003c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    

008003ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	57                   	push   %edi
  8003ce:	56                   	push   %esi
  8003cf:	53                   	push   %ebx
  8003d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8003d6:	be 00 00 00 00       	mov    $0x0,%esi
  8003db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8003df:	74 43                	je     800424 <devcons_write+0x5a>
  8003e1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003e6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8003ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003ef:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8003f1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8003f4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8003f9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800400:	03 45 0c             	add    0xc(%ebp),%eax
  800403:	89 44 24 04          	mov    %eax,0x4(%esp)
  800407:	89 3c 24             	mov    %edi,(%esp)
  80040a:	e8 bd 0a 00 00       	call   800ecc <memmove>
		sys_cputs(buf, m);
  80040f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800413:	89 3c 24             	mov    %edi,(%esp)
  800416:	e8 a5 0c 00 00       	call   8010c0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80041b:	01 de                	add    %ebx,%esi
  80041d:	89 f0                	mov    %esi,%eax
  80041f:	3b 75 10             	cmp    0x10(%ebp),%esi
  800422:	72 c8                	jb     8003ec <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800424:	89 f0                	mov    %esi,%eax
  800426:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80042c:	5b                   	pop    %ebx
  80042d:	5e                   	pop    %esi
  80042e:	5f                   	pop    %edi
  80042f:	5d                   	pop    %ebp
  800430:	c3                   	ret    

00800431 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  800437:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80043c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800440:	75 07                	jne    800449 <devcons_read+0x18>
  800442:	eb 31                	jmp    800475 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800444:	e8 63 0d 00 00       	call   8011ac <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800450:	e8 9a 0c 00 00       	call   8010ef <sys_cgetc>
  800455:	85 c0                	test   %eax,%eax
  800457:	74 eb                	je     800444 <devcons_read+0x13>
  800459:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80045b:	85 c0                	test   %eax,%eax
  80045d:	78 16                	js     800475 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80045f:	83 f8 04             	cmp    $0x4,%eax
  800462:	74 0c                	je     800470 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	88 10                	mov    %dl,(%eax)
	return 1;
  800469:	b8 01 00 00 00       	mov    $0x1,%eax
  80046e:	eb 05                	jmp    800475 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800470:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800475:	c9                   	leave  
  800476:	c3                   	ret    

00800477 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800483:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80048a:	00 
  80048b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80048e:	89 04 24             	mov    %eax,(%esp)
  800491:	e8 2a 0c 00 00       	call   8010c0 <sys_cputs>
}
  800496:	c9                   	leave  
  800497:	c3                   	ret    

00800498 <getchar>:

int
getchar(void)
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80049e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8004a5:	00 
  8004a6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8004a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004b4:	e8 f5 16 00 00       	call   801bae <read>
	if (r < 0)
  8004b9:	85 c0                	test   %eax,%eax
  8004bb:	78 0f                	js     8004cc <getchar+0x34>
		return r;
	if (r < 1)
  8004bd:	85 c0                	test   %eax,%eax
  8004bf:	7e 06                	jle    8004c7 <getchar+0x2f>
		return -E_EOF;
	return c;
  8004c1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8004c5:	eb 05                	jmp    8004cc <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8004c7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	89 04 24             	mov    %eax,(%esp)
  8004e1:	e8 08 14 00 00       	call   8018ee <fd_lookup>
  8004e6:	85 c0                	test   %eax,%eax
  8004e8:	78 11                	js     8004fb <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8004f3:	39 10                	cmp    %edx,(%eax)
  8004f5:	0f 94 c0             	sete   %al
  8004f8:	0f b6 c0             	movzbl %al,%eax
}
  8004fb:	c9                   	leave  
  8004fc:	c3                   	ret    

008004fd <opencons>:

int
opencons(void)
{
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800503:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800506:	89 04 24             	mov    %eax,(%esp)
  800509:	e8 6d 13 00 00       	call   80187b <fd_alloc>
  80050e:	85 c0                	test   %eax,%eax
  800510:	78 3c                	js     80054e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800512:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800519:	00 
  80051a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800521:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800528:	e8 af 0c 00 00       	call   8011dc <sys_page_alloc>
  80052d:	85 c0                	test   %eax,%eax
  80052f:	78 1d                	js     80054e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800531:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80053a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80053c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80053f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800546:	89 04 24             	mov    %eax,(%esp)
  800549:	e8 02 13 00 00       	call   801850 <fd2num>
}
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	83 ec 18             	sub    $0x18,%esp
  800556:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800559:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80055c:	8b 75 08             	mov    0x8(%ebp),%esi
  80055f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800562:	e8 15 0c 00 00       	call   80117c <sys_getenvid>
  800567:	25 ff 03 00 00       	and    $0x3ff,%eax
  80056c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80056f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800574:	a3 04 50 80 00       	mov    %eax,0x805004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800579:	85 f6                	test   %esi,%esi
  80057b:	7e 07                	jle    800584 <libmain+0x34>
		binaryname = argv[0];
  80057d:	8b 03                	mov    (%ebx),%eax
  80057f:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800584:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800588:	89 34 24             	mov    %esi,(%esp)
  80058b:	e8 63 fb ff ff       	call   8000f3 <umain>

	// exit gracefully
	exit();
  800590:	e8 0b 00 00 00       	call   8005a0 <exit>
}
  800595:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800598:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80059b:	89 ec                	mov    %ebp,%esp
  80059d:	5d                   	pop    %ebp
  80059e:	c3                   	ret    
	...

008005a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8005a6:	e8 c3 14 00 00       	call   801a6e <close_all>
	sys_env_destroy(0);
  8005ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005b2:	e8 68 0b 00 00       	call   80111f <sys_env_destroy>
}
  8005b7:	c9                   	leave  
  8005b8:	c3                   	ret    
  8005b9:	00 00                	add    %al,(%eax)
	...

008005bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	56                   	push   %esi
  8005c0:	53                   	push   %ebx
  8005c1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8005c4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005c7:	8b 1d 1c 40 80 00    	mov    0x80401c,%ebx
  8005cd:	e8 aa 0b 00 00       	call   80117c <sys_getenvid>
  8005d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005d5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8005dc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005e0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e8:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  8005ef:	e8 c3 00 00 00       	call   8006b7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005f4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005fb:	89 04 24             	mov    %eax,(%esp)
  8005fe:	e8 53 00 00 00       	call   800656 <vcprintf>
	cprintf("\n");
  800603:	c7 04 24 b8 30 80 00 	movl   $0x8030b8,(%esp)
  80060a:	e8 a8 00 00 00       	call   8006b7 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80060f:	cc                   	int3   
  800610:	eb fd                	jmp    80060f <_panic+0x53>
	...

00800614 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	53                   	push   %ebx
  800618:	83 ec 14             	sub    $0x14,%esp
  80061b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80061e:	8b 03                	mov    (%ebx),%eax
  800620:	8b 55 08             	mov    0x8(%ebp),%edx
  800623:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800627:	83 c0 01             	add    $0x1,%eax
  80062a:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80062c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800631:	75 19                	jne    80064c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800633:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80063a:	00 
  80063b:	8d 43 08             	lea    0x8(%ebx),%eax
  80063e:	89 04 24             	mov    %eax,(%esp)
  800641:	e8 7a 0a 00 00       	call   8010c0 <sys_cputs>
		b->idx = 0;
  800646:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80064c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800650:	83 c4 14             	add    $0x14,%esp
  800653:	5b                   	pop    %ebx
  800654:	5d                   	pop    %ebp
  800655:	c3                   	ret    

00800656 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800656:	55                   	push   %ebp
  800657:	89 e5                	mov    %esp,%ebp
  800659:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80065f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800666:	00 00 00 
	b.cnt = 0;
  800669:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800670:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800673:	8b 45 0c             	mov    0xc(%ebp),%eax
  800676:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800681:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800687:	89 44 24 04          	mov    %eax,0x4(%esp)
  80068b:	c7 04 24 14 06 80 00 	movl   $0x800614,(%esp)
  800692:	e8 a3 01 00 00       	call   80083a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800697:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80069d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006a7:	89 04 24             	mov    %eax,(%esp)
  8006aa:	e8 11 0a 00 00       	call   8010c0 <sys_cputs>

	return b.cnt;
}
  8006af:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006b5:	c9                   	leave  
  8006b6:	c3                   	ret    

008006b7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
  8006ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006bd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	89 04 24             	mov    %eax,(%esp)
  8006ca:	e8 87 ff ff ff       	call   800656 <vcprintf>
	va_end(ap);

	return cnt;
}
  8006cf:	c9                   	leave  
  8006d0:	c3                   	ret    
	...

008006e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	57                   	push   %edi
  8006e4:	56                   	push   %esi
  8006e5:	53                   	push   %ebx
  8006e6:	83 ec 3c             	sub    $0x3c,%esp
  8006e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ec:	89 d7                	mov    %edx,%edi
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8006fd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800700:	b8 00 00 00 00       	mov    $0x0,%eax
  800705:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800708:	72 11                	jb     80071b <printnum+0x3b>
  80070a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80070d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800710:	76 09                	jbe    80071b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800712:	83 eb 01             	sub    $0x1,%ebx
  800715:	85 db                	test   %ebx,%ebx
  800717:	7f 51                	jg     80076a <printnum+0x8a>
  800719:	eb 5e                	jmp    800779 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80071b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80071f:	83 eb 01             	sub    $0x1,%ebx
  800722:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800726:	8b 45 10             	mov    0x10(%ebp),%eax
  800729:	89 44 24 08          	mov    %eax,0x8(%esp)
  80072d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800731:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800735:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80073c:	00 
  80073d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800740:	89 04 24             	mov    %eax,(%esp)
  800743:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800746:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074a:	e8 31 26 00 00       	call   802d80 <__udivdi3>
  80074f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800753:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800757:	89 04 24             	mov    %eax,(%esp)
  80075a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80075e:	89 fa                	mov    %edi,%edx
  800760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800763:	e8 78 ff ff ff       	call   8006e0 <printnum>
  800768:	eb 0f                	jmp    800779 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80076a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076e:	89 34 24             	mov    %esi,(%esp)
  800771:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800774:	83 eb 01             	sub    $0x1,%ebx
  800777:	75 f1                	jne    80076a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800779:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800781:	8b 45 10             	mov    0x10(%ebp),%eax
  800784:	89 44 24 08          	mov    %eax,0x8(%esp)
  800788:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80078f:	00 
  800790:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800793:	89 04 24             	mov    %eax,(%esp)
  800796:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800799:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079d:	e8 0e 27 00 00       	call   802eb0 <__umoddi3>
  8007a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a6:	0f be 80 a7 31 80 00 	movsbl 0x8031a7(%eax),%eax
  8007ad:	89 04 24             	mov    %eax,(%esp)
  8007b0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8007b3:	83 c4 3c             	add    $0x3c,%esp
  8007b6:	5b                   	pop    %ebx
  8007b7:	5e                   	pop    %esi
  8007b8:	5f                   	pop    %edi
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007be:	83 fa 01             	cmp    $0x1,%edx
  8007c1:	7e 0e                	jle    8007d1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8007c3:	8b 10                	mov    (%eax),%edx
  8007c5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8007c8:	89 08                	mov    %ecx,(%eax)
  8007ca:	8b 02                	mov    (%edx),%eax
  8007cc:	8b 52 04             	mov    0x4(%edx),%edx
  8007cf:	eb 22                	jmp    8007f3 <getuint+0x38>
	else if (lflag)
  8007d1:	85 d2                	test   %edx,%edx
  8007d3:	74 10                	je     8007e5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007d5:	8b 10                	mov    (%eax),%edx
  8007d7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007da:	89 08                	mov    %ecx,(%eax)
  8007dc:	8b 02                	mov    (%edx),%eax
  8007de:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e3:	eb 0e                	jmp    8007f3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007e5:	8b 10                	mov    (%eax),%edx
  8007e7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007ea:	89 08                	mov    %ecx,(%eax)
  8007ec:	8b 02                	mov    (%edx),%eax
  8007ee:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007f3:	5d                   	pop    %ebp
  8007f4:	c3                   	ret    

008007f5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007fb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007ff:	8b 10                	mov    (%eax),%edx
  800801:	3b 50 04             	cmp    0x4(%eax),%edx
  800804:	73 0a                	jae    800810 <sprintputch+0x1b>
		*b->buf++ = ch;
  800806:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800809:	88 0a                	mov    %cl,(%edx)
  80080b:	83 c2 01             	add    $0x1,%edx
  80080e:	89 10                	mov    %edx,(%eax)
}
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800818:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80081b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80081f:	8b 45 10             	mov    0x10(%ebp),%eax
  800822:	89 44 24 08          	mov    %eax,0x8(%esp)
  800826:	8b 45 0c             	mov    0xc(%ebp),%eax
  800829:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	89 04 24             	mov    %eax,(%esp)
  800833:	e8 02 00 00 00       	call   80083a <vprintfmt>
	va_end(ap);
}
  800838:	c9                   	leave  
  800839:	c3                   	ret    

0080083a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	57                   	push   %edi
  80083e:	56                   	push   %esi
  80083f:	53                   	push   %ebx
  800840:	83 ec 4c             	sub    $0x4c,%esp
  800843:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800846:	8b 75 10             	mov    0x10(%ebp),%esi
  800849:	eb 12                	jmp    80085d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80084b:	85 c0                	test   %eax,%eax
  80084d:	0f 84 a9 03 00 00    	je     800bfc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800853:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800857:	89 04 24             	mov    %eax,(%esp)
  80085a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085d:	0f b6 06             	movzbl (%esi),%eax
  800860:	83 c6 01             	add    $0x1,%esi
  800863:	83 f8 25             	cmp    $0x25,%eax
  800866:	75 e3                	jne    80084b <vprintfmt+0x11>
  800868:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80086c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800873:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800878:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80087f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800884:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800887:	eb 2b                	jmp    8008b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800889:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80088c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800890:	eb 22                	jmp    8008b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800892:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800895:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800899:	eb 19                	jmp    8008b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80089e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8008a5:	eb 0d                	jmp    8008b4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8008a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ad:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b4:	0f b6 06             	movzbl (%esi),%eax
  8008b7:	0f b6 d0             	movzbl %al,%edx
  8008ba:	8d 7e 01             	lea    0x1(%esi),%edi
  8008bd:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8008c0:	83 e8 23             	sub    $0x23,%eax
  8008c3:	3c 55                	cmp    $0x55,%al
  8008c5:	0f 87 0b 03 00 00    	ja     800bd6 <vprintfmt+0x39c>
  8008cb:	0f b6 c0             	movzbl %al,%eax
  8008ce:	ff 24 85 e0 32 80 00 	jmp    *0x8032e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8008d5:	83 ea 30             	sub    $0x30,%edx
  8008d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8008db:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8008df:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8008e5:	83 fa 09             	cmp    $0x9,%edx
  8008e8:	77 4a                	ja     800934 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ea:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ed:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8008f0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8008f3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8008f7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8008fa:	8d 50 d0             	lea    -0x30(%eax),%edx
  8008fd:	83 fa 09             	cmp    $0x9,%edx
  800900:	76 eb                	jbe    8008ed <vprintfmt+0xb3>
  800902:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800905:	eb 2d                	jmp    800934 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	8d 50 04             	lea    0x4(%eax),%edx
  80090d:	89 55 14             	mov    %edx,0x14(%ebp)
  800910:	8b 00                	mov    (%eax),%eax
  800912:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800915:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800918:	eb 1a                	jmp    800934 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80091a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	79 91                	jns    8008b4 <vprintfmt+0x7a>
  800923:	e9 73 ff ff ff       	jmp    80089b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800928:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80092b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800932:	eb 80                	jmp    8008b4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	0f 89 76 ff ff ff    	jns    8008b4 <vprintfmt+0x7a>
  80093e:	e9 64 ff ff ff       	jmp    8008a7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800943:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800946:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800949:	e9 66 ff ff ff       	jmp    8008b4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	89 55 14             	mov    %edx,0x14(%ebp)
  800957:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	89 04 24             	mov    %eax,(%esp)
  800960:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800963:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800966:	e9 f2 fe ff ff       	jmp    80085d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	8d 50 04             	lea    0x4(%eax),%edx
  800971:	89 55 14             	mov    %edx,0x14(%ebp)
  800974:	8b 00                	mov    (%eax),%eax
  800976:	89 c2                	mov    %eax,%edx
  800978:	c1 fa 1f             	sar    $0x1f,%edx
  80097b:	31 d0                	xor    %edx,%eax
  80097d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80097f:	83 f8 0f             	cmp    $0xf,%eax
  800982:	7f 0b                	jg     80098f <vprintfmt+0x155>
  800984:	8b 14 85 40 34 80 00 	mov    0x803440(,%eax,4),%edx
  80098b:	85 d2                	test   %edx,%edx
  80098d:	75 23                	jne    8009b2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80098f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800993:	c7 44 24 08 bf 31 80 	movl   $0x8031bf,0x8(%esp)
  80099a:	00 
  80099b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80099f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a2:	89 3c 24             	mov    %edi,(%esp)
  8009a5:	e8 68 fe ff ff       	call   800812 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009aa:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8009ad:	e9 ab fe ff ff       	jmp    80085d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  8009b2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009b6:	c7 44 24 08 11 37 80 	movl   $0x803711,0x8(%esp)
  8009bd:	00 
  8009be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c5:	89 3c 24             	mov    %edi,(%esp)
  8009c8:	e8 45 fe ff ff       	call   800812 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009cd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8009d0:	e9 88 fe ff ff       	jmp    80085d <vprintfmt+0x23>
  8009d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8009d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	8d 50 04             	lea    0x4(%eax),%edx
  8009e4:	89 55 14             	mov    %edx,0x14(%ebp)
  8009e7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8009e9:	85 f6                	test   %esi,%esi
  8009eb:	ba b8 31 80 00       	mov    $0x8031b8,%edx
  8009f0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8009f3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009f7:	7e 06                	jle    8009ff <vprintfmt+0x1c5>
  8009f9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8009fd:	75 10                	jne    800a0f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ff:	0f be 06             	movsbl (%esi),%eax
  800a02:	83 c6 01             	add    $0x1,%esi
  800a05:	85 c0                	test   %eax,%eax
  800a07:	0f 85 86 00 00 00    	jne    800a93 <vprintfmt+0x259>
  800a0d:	eb 76                	jmp    800a85 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a13:	89 34 24             	mov    %esi,(%esp)
  800a16:	e8 90 02 00 00       	call   800cab <strnlen>
  800a1b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a1e:	29 c2                	sub    %eax,%edx
  800a20:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a23:	85 d2                	test   %edx,%edx
  800a25:	7e d8                	jle    8009ff <vprintfmt+0x1c5>
					putch(padc, putdat);
  800a27:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800a2b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  800a2e:	89 d6                	mov    %edx,%esi
  800a30:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800a33:	89 c7                	mov    %eax,%edi
  800a35:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a39:	89 3c 24             	mov    %edi,(%esp)
  800a3c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3f:	83 ee 01             	sub    $0x1,%esi
  800a42:	75 f1                	jne    800a35 <vprintfmt+0x1fb>
  800a44:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800a47:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  800a4a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  800a4d:	eb b0                	jmp    8009ff <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a4f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a53:	74 18                	je     800a6d <vprintfmt+0x233>
  800a55:	8d 50 e0             	lea    -0x20(%eax),%edx
  800a58:	83 fa 5e             	cmp    $0x5e,%edx
  800a5b:	76 10                	jbe    800a6d <vprintfmt+0x233>
					putch('?', putdat);
  800a5d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a61:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a68:	ff 55 08             	call   *0x8(%ebp)
  800a6b:	eb 0a                	jmp    800a77 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  800a6d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a71:	89 04 24             	mov    %eax,(%esp)
  800a74:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a77:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a7b:	0f be 06             	movsbl (%esi),%eax
  800a7e:	83 c6 01             	add    $0x1,%esi
  800a81:	85 c0                	test   %eax,%eax
  800a83:	75 0e                	jne    800a93 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a85:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8c:	7f 16                	jg     800aa4 <vprintfmt+0x26a>
  800a8e:	e9 ca fd ff ff       	jmp    80085d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a93:	85 ff                	test   %edi,%edi
  800a95:	78 b8                	js     800a4f <vprintfmt+0x215>
  800a97:	83 ef 01             	sub    $0x1,%edi
  800a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800aa0:	79 ad                	jns    800a4f <vprintfmt+0x215>
  800aa2:	eb e1                	jmp    800a85 <vprintfmt+0x24b>
  800aa4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800aa7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800aaa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aae:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800ab5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab7:	83 ee 01             	sub    $0x1,%esi
  800aba:	75 ee                	jne    800aaa <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800abc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800abf:	e9 99 fd ff ff       	jmp    80085d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800ac4:	83 f9 01             	cmp    $0x1,%ecx
  800ac7:	7e 10                	jle    800ad9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800ac9:	8b 45 14             	mov    0x14(%ebp),%eax
  800acc:	8d 50 08             	lea    0x8(%eax),%edx
  800acf:	89 55 14             	mov    %edx,0x14(%ebp)
  800ad2:	8b 30                	mov    (%eax),%esi
  800ad4:	8b 78 04             	mov    0x4(%eax),%edi
  800ad7:	eb 26                	jmp    800aff <vprintfmt+0x2c5>
	else if (lflag)
  800ad9:	85 c9                	test   %ecx,%ecx
  800adb:	74 12                	je     800aef <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	8d 50 04             	lea    0x4(%eax),%edx
  800ae3:	89 55 14             	mov    %edx,0x14(%ebp)
  800ae6:	8b 30                	mov    (%eax),%esi
  800ae8:	89 f7                	mov    %esi,%edi
  800aea:	c1 ff 1f             	sar    $0x1f,%edi
  800aed:	eb 10                	jmp    800aff <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	8d 50 04             	lea    0x4(%eax),%edx
  800af5:	89 55 14             	mov    %edx,0x14(%ebp)
  800af8:	8b 30                	mov    (%eax),%esi
  800afa:	89 f7                	mov    %esi,%edi
  800afc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800aff:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b04:	85 ff                	test   %edi,%edi
  800b06:	0f 89 8c 00 00 00    	jns    800b98 <vprintfmt+0x35e>
				putch('-', putdat);
  800b0c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b10:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b17:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b1a:	f7 de                	neg    %esi
  800b1c:	83 d7 00             	adc    $0x0,%edi
  800b1f:	f7 df                	neg    %edi
			}
			base = 10;
  800b21:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b26:	eb 70                	jmp    800b98 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b28:	89 ca                	mov    %ecx,%edx
  800b2a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b2d:	e8 89 fc ff ff       	call   8007bb <getuint>
  800b32:	89 c6                	mov    %eax,%esi
  800b34:	89 d7                	mov    %edx,%edi
			base = 10;
  800b36:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800b3b:	eb 5b                	jmp    800b98 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800b3d:	89 ca                	mov    %ecx,%edx
  800b3f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b42:	e8 74 fc ff ff       	call   8007bb <getuint>
  800b47:	89 c6                	mov    %eax,%esi
  800b49:	89 d7                	mov    %edx,%edi
			base = 8;
  800b4b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800b50:	eb 46                	jmp    800b98 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800b52:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b56:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b5d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800b60:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b64:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b6b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b71:	8d 50 04             	lea    0x4(%eax),%edx
  800b74:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b77:	8b 30                	mov    (%eax),%esi
  800b79:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b7e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800b83:	eb 13                	jmp    800b98 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b85:	89 ca                	mov    %ecx,%edx
  800b87:	8d 45 14             	lea    0x14(%ebp),%eax
  800b8a:	e8 2c fc ff ff       	call   8007bb <getuint>
  800b8f:	89 c6                	mov    %eax,%esi
  800b91:	89 d7                	mov    %edx,%edi
			base = 16;
  800b93:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b98:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  800b9c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800ba0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ba3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ba7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bab:	89 34 24             	mov    %esi,(%esp)
  800bae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bb2:	89 da                	mov    %ebx,%edx
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	e8 24 fb ff ff       	call   8006e0 <printnum>
			break;
  800bbc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800bbf:	e9 99 fc ff ff       	jmp    80085d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bc4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bc8:	89 14 24             	mov    %edx,(%esp)
  800bcb:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bce:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800bd1:	e9 87 fc ff ff       	jmp    80085d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bda:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800be1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800be4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800be8:	0f 84 6f fc ff ff    	je     80085d <vprintfmt+0x23>
  800bee:	83 ee 01             	sub    $0x1,%esi
  800bf1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800bf5:	75 f7                	jne    800bee <vprintfmt+0x3b4>
  800bf7:	e9 61 fc ff ff       	jmp    80085d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  800bfc:	83 c4 4c             	add    $0x4c,%esp
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5f                   	pop    %edi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 28             	sub    $0x28,%esp
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c13:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c17:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c21:	85 c0                	test   %eax,%eax
  800c23:	74 30                	je     800c55 <vsnprintf+0x51>
  800c25:	85 d2                	test   %edx,%edx
  800c27:	7e 2c                	jle    800c55 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c29:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c30:	8b 45 10             	mov    0x10(%ebp),%eax
  800c33:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c37:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c3e:	c7 04 24 f5 07 80 00 	movl   $0x8007f5,(%esp)
  800c45:	e8 f0 fb ff ff       	call   80083a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c53:	eb 05                	jmp    800c5a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800c55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c62:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	89 04 24             	mov    %eax,(%esp)
  800c7d:	e8 82 ff ff ff       	call   800c04 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    
	...

00800c90 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c96:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9b:	80 3a 00             	cmpb   $0x0,(%edx)
  800c9e:	74 09                	je     800ca9 <strlen+0x19>
		n++;
  800ca0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ca7:	75 f7                	jne    800ca0 <strlen+0x10>
		n++;
	return n;
}
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	53                   	push   %ebx
  800caf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800cb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cba:	85 c9                	test   %ecx,%ecx
  800cbc:	74 1a                	je     800cd8 <strnlen+0x2d>
  800cbe:	80 3b 00             	cmpb   $0x0,(%ebx)
  800cc1:	74 15                	je     800cd8 <strnlen+0x2d>
  800cc3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800cc8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cca:	39 ca                	cmp    %ecx,%edx
  800ccc:	74 0a                	je     800cd8 <strnlen+0x2d>
  800cce:	83 c2 01             	add    $0x1,%edx
  800cd1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800cd6:	75 f0                	jne    800cc8 <strnlen+0x1d>
		n++;
	return n;
}
  800cd8:	5b                   	pop    %ebx
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	53                   	push   %ebx
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ce5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cea:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800cee:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800cf1:	83 c2 01             	add    $0x1,%edx
  800cf4:	84 c9                	test   %cl,%cl
  800cf6:	75 f2                	jne    800cea <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800cf8:	5b                   	pop    %ebx
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	53                   	push   %ebx
  800cff:	83 ec 08             	sub    $0x8,%esp
  800d02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d05:	89 1c 24             	mov    %ebx,(%esp)
  800d08:	e8 83 ff ff ff       	call   800c90 <strlen>
	strcpy(dst + len, src);
  800d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d10:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d14:	01 d8                	add    %ebx,%eax
  800d16:	89 04 24             	mov    %eax,(%esp)
  800d19:	e8 bd ff ff ff       	call   800cdb <strcpy>
	return dst;
}
  800d1e:	89 d8                	mov    %ebx,%eax
  800d20:	83 c4 08             	add    $0x8,%esp
  800d23:	5b                   	pop    %ebx
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d31:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d34:	85 f6                	test   %esi,%esi
  800d36:	74 18                	je     800d50 <strncpy+0x2a>
  800d38:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800d3d:	0f b6 1a             	movzbl (%edx),%ebx
  800d40:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d43:	80 3a 01             	cmpb   $0x1,(%edx)
  800d46:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d49:	83 c1 01             	add    $0x1,%ecx
  800d4c:	39 f1                	cmp    %esi,%ecx
  800d4e:	75 ed                	jne    800d3d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d60:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d63:	89 f8                	mov    %edi,%eax
  800d65:	85 f6                	test   %esi,%esi
  800d67:	74 2b                	je     800d94 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800d69:	83 fe 01             	cmp    $0x1,%esi
  800d6c:	74 23                	je     800d91 <strlcpy+0x3d>
  800d6e:	0f b6 0b             	movzbl (%ebx),%ecx
  800d71:	84 c9                	test   %cl,%cl
  800d73:	74 1c                	je     800d91 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800d75:	83 ee 02             	sub    $0x2,%esi
  800d78:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d7d:	88 08                	mov    %cl,(%eax)
  800d7f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d82:	39 f2                	cmp    %esi,%edx
  800d84:	74 0b                	je     800d91 <strlcpy+0x3d>
  800d86:	83 c2 01             	add    $0x1,%edx
  800d89:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d8d:	84 c9                	test   %cl,%cl
  800d8f:	75 ec                	jne    800d7d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800d91:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d94:	29 f8                	sub    %edi,%eax
}
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800da4:	0f b6 01             	movzbl (%ecx),%eax
  800da7:	84 c0                	test   %al,%al
  800da9:	74 16                	je     800dc1 <strcmp+0x26>
  800dab:	3a 02                	cmp    (%edx),%al
  800dad:	75 12                	jne    800dc1 <strcmp+0x26>
		p++, q++;
  800daf:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800db6:	84 c0                	test   %al,%al
  800db8:	74 07                	je     800dc1 <strcmp+0x26>
  800dba:	83 c1 01             	add    $0x1,%ecx
  800dbd:	3a 02                	cmp    (%edx),%al
  800dbf:	74 ee                	je     800daf <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc1:	0f b6 c0             	movzbl %al,%eax
  800dc4:	0f b6 12             	movzbl (%edx),%edx
  800dc7:	29 d0                	sub    %edx,%eax
}
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	53                   	push   %ebx
  800dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800dd5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800dd8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ddd:	85 d2                	test   %edx,%edx
  800ddf:	74 28                	je     800e09 <strncmp+0x3e>
  800de1:	0f b6 01             	movzbl (%ecx),%eax
  800de4:	84 c0                	test   %al,%al
  800de6:	74 24                	je     800e0c <strncmp+0x41>
  800de8:	3a 03                	cmp    (%ebx),%al
  800dea:	75 20                	jne    800e0c <strncmp+0x41>
  800dec:	83 ea 01             	sub    $0x1,%edx
  800def:	74 13                	je     800e04 <strncmp+0x39>
		n--, p++, q++;
  800df1:	83 c1 01             	add    $0x1,%ecx
  800df4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800df7:	0f b6 01             	movzbl (%ecx),%eax
  800dfa:	84 c0                	test   %al,%al
  800dfc:	74 0e                	je     800e0c <strncmp+0x41>
  800dfe:	3a 03                	cmp    (%ebx),%al
  800e00:	74 ea                	je     800dec <strncmp+0x21>
  800e02:	eb 08                	jmp    800e0c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800e09:	5b                   	pop    %ebx
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e0c:	0f b6 01             	movzbl (%ecx),%eax
  800e0f:	0f b6 13             	movzbl (%ebx),%edx
  800e12:	29 d0                	sub    %edx,%eax
  800e14:	eb f3                	jmp    800e09 <strncmp+0x3e>

00800e16 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e20:	0f b6 10             	movzbl (%eax),%edx
  800e23:	84 d2                	test   %dl,%dl
  800e25:	74 1c                	je     800e43 <strchr+0x2d>
		if (*s == c)
  800e27:	38 ca                	cmp    %cl,%dl
  800e29:	75 09                	jne    800e34 <strchr+0x1e>
  800e2b:	eb 1b                	jmp    800e48 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e2d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800e30:	38 ca                	cmp    %cl,%dl
  800e32:	74 14                	je     800e48 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e34:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800e38:	84 d2                	test   %dl,%dl
  800e3a:	75 f1                	jne    800e2d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e41:	eb 05                	jmp    800e48 <strchr+0x32>
  800e43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    

00800e4a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e54:	0f b6 10             	movzbl (%eax),%edx
  800e57:	84 d2                	test   %dl,%dl
  800e59:	74 14                	je     800e6f <strfind+0x25>
		if (*s == c)
  800e5b:	38 ca                	cmp    %cl,%dl
  800e5d:	75 06                	jne    800e65 <strfind+0x1b>
  800e5f:	eb 0e                	jmp    800e6f <strfind+0x25>
  800e61:	38 ca                	cmp    %cl,%dl
  800e63:	74 0a                	je     800e6f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e65:	83 c0 01             	add    $0x1,%eax
  800e68:	0f b6 10             	movzbl (%eax),%edx
  800e6b:	84 d2                	test   %dl,%dl
  800e6d:	75 f2                	jne    800e61 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    

00800e71 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e7a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e7d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800e80:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e86:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e89:	85 c9                	test   %ecx,%ecx
  800e8b:	74 30                	je     800ebd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e8d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e93:	75 25                	jne    800eba <memset+0x49>
  800e95:	f6 c1 03             	test   $0x3,%cl
  800e98:	75 20                	jne    800eba <memset+0x49>
		c &= 0xFF;
  800e9a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e9d:	89 d3                	mov    %edx,%ebx
  800e9f:	c1 e3 08             	shl    $0x8,%ebx
  800ea2:	89 d6                	mov    %edx,%esi
  800ea4:	c1 e6 18             	shl    $0x18,%esi
  800ea7:	89 d0                	mov    %edx,%eax
  800ea9:	c1 e0 10             	shl    $0x10,%eax
  800eac:	09 f0                	or     %esi,%eax
  800eae:	09 d0                	or     %edx,%eax
  800eb0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800eb2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800eb5:	fc                   	cld    
  800eb6:	f3 ab                	rep stos %eax,%es:(%edi)
  800eb8:	eb 03                	jmp    800ebd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800eba:	fc                   	cld    
  800ebb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ebd:	89 f8                	mov    %edi,%eax
  800ebf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ec5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ec8:	89 ec                	mov    %ebp,%esp
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 08             	sub    $0x8,%esp
  800ed2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ed5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ede:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ee1:	39 c6                	cmp    %eax,%esi
  800ee3:	73 36                	jae    800f1b <memmove+0x4f>
  800ee5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ee8:	39 d0                	cmp    %edx,%eax
  800eea:	73 2f                	jae    800f1b <memmove+0x4f>
		s += n;
		d += n;
  800eec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eef:	f6 c2 03             	test   $0x3,%dl
  800ef2:	75 1b                	jne    800f0f <memmove+0x43>
  800ef4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800efa:	75 13                	jne    800f0f <memmove+0x43>
  800efc:	f6 c1 03             	test   $0x3,%cl
  800eff:	75 0e                	jne    800f0f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f01:	83 ef 04             	sub    $0x4,%edi
  800f04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f07:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800f0a:	fd                   	std    
  800f0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f0d:	eb 09                	jmp    800f18 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f0f:	83 ef 01             	sub    $0x1,%edi
  800f12:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800f15:	fd                   	std    
  800f16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f18:	fc                   	cld    
  800f19:	eb 20                	jmp    800f3b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f1b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f21:	75 13                	jne    800f36 <memmove+0x6a>
  800f23:	a8 03                	test   $0x3,%al
  800f25:	75 0f                	jne    800f36 <memmove+0x6a>
  800f27:	f6 c1 03             	test   $0x3,%cl
  800f2a:	75 0a                	jne    800f36 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f2c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800f2f:	89 c7                	mov    %eax,%edi
  800f31:	fc                   	cld    
  800f32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f34:	eb 05                	jmp    800f3b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f36:	89 c7                	mov    %eax,%edi
  800f38:	fc                   	cld    
  800f39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f3b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f3e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f41:	89 ec                	mov    %ebp,%esp
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    

00800f45 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	89 04 24             	mov    %eax,(%esp)
  800f5f:	e8 68 ff ff ff       	call   800ecc <memmove>
}
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
  800f6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800f6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f72:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f75:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f7a:	85 ff                	test   %edi,%edi
  800f7c:	74 37                	je     800fb5 <memcmp+0x4f>
		if (*s1 != *s2)
  800f7e:	0f b6 03             	movzbl (%ebx),%eax
  800f81:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f84:	83 ef 01             	sub    $0x1,%edi
  800f87:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800f8c:	38 c8                	cmp    %cl,%al
  800f8e:	74 1c                	je     800fac <memcmp+0x46>
  800f90:	eb 10                	jmp    800fa2 <memcmp+0x3c>
  800f92:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800f97:	83 c2 01             	add    $0x1,%edx
  800f9a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800f9e:	38 c8                	cmp    %cl,%al
  800fa0:	74 0a                	je     800fac <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800fa2:	0f b6 c0             	movzbl %al,%eax
  800fa5:	0f b6 c9             	movzbl %cl,%ecx
  800fa8:	29 c8                	sub    %ecx,%eax
  800faa:	eb 09                	jmp    800fb5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fac:	39 fa                	cmp    %edi,%edx
  800fae:	75 e2                	jne    800f92 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb5:	5b                   	pop    %ebx
  800fb6:	5e                   	pop    %esi
  800fb7:	5f                   	pop    %edi
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800fc0:	89 c2                	mov    %eax,%edx
  800fc2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fc5:	39 d0                	cmp    %edx,%eax
  800fc7:	73 19                	jae    800fe2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fc9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800fcd:	38 08                	cmp    %cl,(%eax)
  800fcf:	75 06                	jne    800fd7 <memfind+0x1d>
  800fd1:	eb 0f                	jmp    800fe2 <memfind+0x28>
  800fd3:	38 08                	cmp    %cl,(%eax)
  800fd5:	74 0b                	je     800fe2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fd7:	83 c0 01             	add    $0x1,%eax
  800fda:	39 d0                	cmp    %edx,%eax
  800fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800fe0:	75 f1                	jne    800fd3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800fe2:	5d                   	pop    %ebp
  800fe3:	c3                   	ret    

00800fe4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
  800fea:	8b 55 08             	mov    0x8(%ebp),%edx
  800fed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ff0:	0f b6 02             	movzbl (%edx),%eax
  800ff3:	3c 20                	cmp    $0x20,%al
  800ff5:	74 04                	je     800ffb <strtol+0x17>
  800ff7:	3c 09                	cmp    $0x9,%al
  800ff9:	75 0e                	jne    801009 <strtol+0x25>
		s++;
  800ffb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ffe:	0f b6 02             	movzbl (%edx),%eax
  801001:	3c 20                	cmp    $0x20,%al
  801003:	74 f6                	je     800ffb <strtol+0x17>
  801005:	3c 09                	cmp    $0x9,%al
  801007:	74 f2                	je     800ffb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  801009:	3c 2b                	cmp    $0x2b,%al
  80100b:	75 0a                	jne    801017 <strtol+0x33>
		s++;
  80100d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801010:	bf 00 00 00 00       	mov    $0x0,%edi
  801015:	eb 10                	jmp    801027 <strtol+0x43>
  801017:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80101c:	3c 2d                	cmp    $0x2d,%al
  80101e:	75 07                	jne    801027 <strtol+0x43>
		s++, neg = 1;
  801020:	83 c2 01             	add    $0x1,%edx
  801023:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801027:	85 db                	test   %ebx,%ebx
  801029:	0f 94 c0             	sete   %al
  80102c:	74 05                	je     801033 <strtol+0x4f>
  80102e:	83 fb 10             	cmp    $0x10,%ebx
  801031:	75 15                	jne    801048 <strtol+0x64>
  801033:	80 3a 30             	cmpb   $0x30,(%edx)
  801036:	75 10                	jne    801048 <strtol+0x64>
  801038:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80103c:	75 0a                	jne    801048 <strtol+0x64>
		s += 2, base = 16;
  80103e:	83 c2 02             	add    $0x2,%edx
  801041:	bb 10 00 00 00       	mov    $0x10,%ebx
  801046:	eb 13                	jmp    80105b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  801048:	84 c0                	test   %al,%al
  80104a:	74 0f                	je     80105b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80104c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801051:	80 3a 30             	cmpb   $0x30,(%edx)
  801054:	75 05                	jne    80105b <strtol+0x77>
		s++, base = 8;
  801056:	83 c2 01             	add    $0x1,%edx
  801059:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  80105b:	b8 00 00 00 00       	mov    $0x0,%eax
  801060:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801062:	0f b6 0a             	movzbl (%edx),%ecx
  801065:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801068:	80 fb 09             	cmp    $0x9,%bl
  80106b:	77 08                	ja     801075 <strtol+0x91>
			dig = *s - '0';
  80106d:	0f be c9             	movsbl %cl,%ecx
  801070:	83 e9 30             	sub    $0x30,%ecx
  801073:	eb 1e                	jmp    801093 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  801075:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  801078:	80 fb 19             	cmp    $0x19,%bl
  80107b:	77 08                	ja     801085 <strtol+0xa1>
			dig = *s - 'a' + 10;
  80107d:	0f be c9             	movsbl %cl,%ecx
  801080:	83 e9 57             	sub    $0x57,%ecx
  801083:	eb 0e                	jmp    801093 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  801085:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  801088:	80 fb 19             	cmp    $0x19,%bl
  80108b:	77 14                	ja     8010a1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  80108d:	0f be c9             	movsbl %cl,%ecx
  801090:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801093:	39 f1                	cmp    %esi,%ecx
  801095:	7d 0e                	jge    8010a5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801097:	83 c2 01             	add    $0x1,%edx
  80109a:	0f af c6             	imul   %esi,%eax
  80109d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  80109f:	eb c1                	jmp    801062 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  8010a1:	89 c1                	mov    %eax,%ecx
  8010a3:	eb 02                	jmp    8010a7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010a5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ab:	74 05                	je     8010b2 <strtol+0xce>
		*endptr = (char *) s;
  8010ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8010b0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  8010b2:	89 ca                	mov    %ecx,%edx
  8010b4:	f7 da                	neg    %edx
  8010b6:	85 ff                	test   %edi,%edi
  8010b8:	0f 45 c2             	cmovne %edx,%eax
}
  8010bb:	5b                   	pop    %ebx
  8010bc:	5e                   	pop    %esi
  8010bd:	5f                   	pop    %edi
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    

008010c0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	83 ec 0c             	sub    $0xc,%esp
  8010c6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010c9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010cc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010da:	89 c3                	mov    %eax,%ebx
  8010dc:	89 c7                	mov    %eax,%edi
  8010de:	89 c6                	mov    %eax,%esi
  8010e0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010e2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010e5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010eb:	89 ec                	mov    %ebp,%esp
  8010ed:	5d                   	pop    %ebp
  8010ee:	c3                   	ret    

008010ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010f8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010fb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801103:	b8 01 00 00 00       	mov    $0x1,%eax
  801108:	89 d1                	mov    %edx,%ecx
  80110a:	89 d3                	mov    %edx,%ebx
  80110c:	89 d7                	mov    %edx,%edi
  80110e:	89 d6                	mov    %edx,%esi
  801110:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801112:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801115:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801118:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80111b:	89 ec                	mov    %ebp,%esp
  80111d:	5d                   	pop    %ebp
  80111e:	c3                   	ret    

0080111f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 38             	sub    $0x38,%esp
  801125:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801128:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80112b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80112e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801133:	b8 03 00 00 00       	mov    $0x3,%eax
  801138:	8b 55 08             	mov    0x8(%ebp),%edx
  80113b:	89 cb                	mov    %ecx,%ebx
  80113d:	89 cf                	mov    %ecx,%edi
  80113f:	89 ce                	mov    %ecx,%esi
  801141:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801143:	85 c0                	test   %eax,%eax
  801145:	7e 28                	jle    80116f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801147:	89 44 24 10          	mov    %eax,0x10(%esp)
  80114b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801152:	00 
  801153:	c7 44 24 08 9f 34 80 	movl   $0x80349f,0x8(%esp)
  80115a:	00 
  80115b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801162:	00 
  801163:	c7 04 24 bc 34 80 00 	movl   $0x8034bc,(%esp)
  80116a:	e8 4d f4 ff ff       	call   8005bc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80116f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801172:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801175:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801178:	89 ec                	mov    %ebp,%esp
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    

0080117c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	83 ec 0c             	sub    $0xc,%esp
  801182:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801185:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801188:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80118b:	ba 00 00 00 00       	mov    $0x0,%edx
  801190:	b8 02 00 00 00       	mov    $0x2,%eax
  801195:	89 d1                	mov    %edx,%ecx
  801197:	89 d3                	mov    %edx,%ebx
  801199:	89 d7                	mov    %edx,%edi
  80119b:	89 d6                	mov    %edx,%esi
  80119d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80119f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011a2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011a5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011a8:	89 ec                	mov    %ebp,%esp
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    

008011ac <sys_yield>:

void
sys_yield(void)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 0c             	sub    $0xc,%esp
  8011b2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011b5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011b8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011c5:	89 d1                	mov    %edx,%ecx
  8011c7:	89 d3                	mov    %edx,%ebx
  8011c9:	89 d7                	mov    %edx,%edi
  8011cb:	89 d6                	mov    %edx,%esi
  8011cd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011cf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011d2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011d5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011d8:	89 ec                	mov    %ebp,%esp
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    

008011dc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 38             	sub    $0x38,%esp
  8011e2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011e5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011e8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011eb:	be 00 00 00 00       	mov    $0x0,%esi
  8011f0:	b8 04 00 00 00       	mov    $0x4,%eax
  8011f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fe:	89 f7                	mov    %esi,%edi
  801200:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801202:	85 c0                	test   %eax,%eax
  801204:	7e 28                	jle    80122e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801206:	89 44 24 10          	mov    %eax,0x10(%esp)
  80120a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801211:	00 
  801212:	c7 44 24 08 9f 34 80 	movl   $0x80349f,0x8(%esp)
  801219:	00 
  80121a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801221:	00 
  801222:	c7 04 24 bc 34 80 00 	movl   $0x8034bc,(%esp)
  801229:	e8 8e f3 ff ff       	call   8005bc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80122e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801231:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801234:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801237:	89 ec                	mov    %ebp,%esp
  801239:	5d                   	pop    %ebp
  80123a:	c3                   	ret    

0080123b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 38             	sub    $0x38,%esp
  801241:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801244:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801247:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80124a:	b8 05 00 00 00       	mov    $0x5,%eax
  80124f:	8b 75 18             	mov    0x18(%ebp),%esi
  801252:	8b 7d 14             	mov    0x14(%ebp),%edi
  801255:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801258:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125b:	8b 55 08             	mov    0x8(%ebp),%edx
  80125e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801260:	85 c0                	test   %eax,%eax
  801262:	7e 28                	jle    80128c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801264:	89 44 24 10          	mov    %eax,0x10(%esp)
  801268:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80126f:	00 
  801270:	c7 44 24 08 9f 34 80 	movl   $0x80349f,0x8(%esp)
  801277:	00 
  801278:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80127f:	00 
  801280:	c7 04 24 bc 34 80 00 	movl   $0x8034bc,(%esp)
  801287:	e8 30 f3 ff ff       	call   8005bc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80128c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80128f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801292:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801295:	89 ec                	mov    %ebp,%esp
  801297:	5d                   	pop    %ebp
  801298:	c3                   	ret    

00801299 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 38             	sub    $0x38,%esp
  80129f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012a2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012a5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ad:	b8 06 00 00 00       	mov    $0x6,%eax
  8012b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b8:	89 df                	mov    %ebx,%edi
  8012ba:	89 de                	mov    %ebx,%esi
  8012bc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	7e 28                	jle    8012ea <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012c6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8012cd:	00 
  8012ce:	c7 44 24 08 9f 34 80 	movl   $0x80349f,0x8(%esp)
  8012d5:	00 
  8012d6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012dd:	00 
  8012de:	c7 04 24 bc 34 80 00 	movl   $0x8034bc,(%esp)
  8012e5:	e8 d2 f2 ff ff       	call   8005bc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012ea:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012ed:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012f0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012f3:	89 ec                	mov    %ebp,%esp
  8012f5:	5d                   	pop    %ebp
  8012f6:	c3                   	ret    

008012f7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	83 ec 38             	sub    $0x38,%esp
  8012fd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801300:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801303:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801306:	bb 00 00 00 00       	mov    $0x0,%ebx
  80130b:	b8 08 00 00 00       	mov    $0x8,%eax
  801310:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801313:	8b 55 08             	mov    0x8(%ebp),%edx
  801316:	89 df                	mov    %ebx,%edi
  801318:	89 de                	mov    %ebx,%esi
  80131a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80131c:	85 c0                	test   %eax,%eax
  80131e:	7e 28                	jle    801348 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801320:	89 44 24 10          	mov    %eax,0x10(%esp)
  801324:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80132b:	00 
  80132c:	c7 44 24 08 9f 34 80 	movl   $0x80349f,0x8(%esp)
  801333:	00 
  801334:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80133b:	00 
  80133c:	c7 04 24 bc 34 80 00 	movl   $0x8034bc,(%esp)
  801343:	e8 74 f2 ff ff       	call   8005bc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801348:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80134b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80134e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801351:	89 ec                	mov    %ebp,%esp
  801353:	5d                   	pop    %ebp
  801354:	c3                   	ret    

00801355 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 38             	sub    $0x38,%esp
  80135b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80135e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801361:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801364:	bb 00 00 00 00       	mov    $0x0,%ebx
  801369:	b8 09 00 00 00       	mov    $0x9,%eax
  80136e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801371:	8b 55 08             	mov    0x8(%ebp),%edx
  801374:	89 df                	mov    %ebx,%edi
  801376:	89 de                	mov    %ebx,%esi
  801378:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80137a:	85 c0                	test   %eax,%eax
  80137c:	7e 28                	jle    8013a6 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80137e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801382:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801389:	00 
  80138a:	c7 44 24 08 9f 34 80 	movl   $0x80349f,0x8(%esp)
  801391:	00 
  801392:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801399:	00 
  80139a:	c7 04 24 bc 34 80 00 	movl   $0x8034bc,(%esp)
  8013a1:	e8 16 f2 ff ff       	call   8005bc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8013a6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013a9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013ac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013af:	89 ec                	mov    %ebp,%esp
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    

008013b3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	83 ec 38             	sub    $0x38,%esp
  8013b9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013bc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013bf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d2:	89 df                	mov    %ebx,%edi
  8013d4:	89 de                	mov    %ebx,%esi
  8013d6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013d8:	85 c0                	test   %eax,%eax
  8013da:	7e 28                	jle    801404 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013e0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8013e7:	00 
  8013e8:	c7 44 24 08 9f 34 80 	movl   $0x80349f,0x8(%esp)
  8013ef:	00 
  8013f0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013f7:	00 
  8013f8:	c7 04 24 bc 34 80 00 	movl   $0x8034bc,(%esp)
  8013ff:	e8 b8 f1 ff ff       	call   8005bc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801404:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801407:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80140a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80140d:	89 ec                	mov    %ebp,%esp
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    

00801411 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	83 ec 0c             	sub    $0xc,%esp
  801417:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80141a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80141d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801420:	be 00 00 00 00       	mov    $0x0,%esi
  801425:	b8 0c 00 00 00       	mov    $0xc,%eax
  80142a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80142d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801433:	8b 55 08             	mov    0x8(%ebp),%edx
  801436:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801438:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80143b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80143e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801441:	89 ec                	mov    %ebp,%esp
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	83 ec 38             	sub    $0x38,%esp
  80144b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80144e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801451:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801454:	b9 00 00 00 00       	mov    $0x0,%ecx
  801459:	b8 0d 00 00 00       	mov    $0xd,%eax
  80145e:	8b 55 08             	mov    0x8(%ebp),%edx
  801461:	89 cb                	mov    %ecx,%ebx
  801463:	89 cf                	mov    %ecx,%edi
  801465:	89 ce                	mov    %ecx,%esi
  801467:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801469:	85 c0                	test   %eax,%eax
  80146b:	7e 28                	jle    801495 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80146d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801471:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801478:	00 
  801479:	c7 44 24 08 9f 34 80 	movl   $0x80349f,0x8(%esp)
  801480:	00 
  801481:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801488:	00 
  801489:	c7 04 24 bc 34 80 00 	movl   $0x8034bc,(%esp)
  801490:	e8 27 f1 ff ff       	call   8005bc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801495:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801498:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80149b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80149e:	89 ec                	mov    %ebp,%esp
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    
	...

008014a4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	53                   	push   %ebx
  8014a8:	83 ec 24             	sub    $0x24,%esp
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8014ae:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  8014b0:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8014b4:	74 21                	je     8014d7 <pgfault+0x33>
  8014b6:	89 d8                	mov    %ebx,%eax
  8014b8:	c1 e8 16             	shr    $0x16,%eax
  8014bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014c2:	a8 01                	test   $0x1,%al
  8014c4:	74 11                	je     8014d7 <pgfault+0x33>
  8014c6:	89 d8                	mov    %ebx,%eax
  8014c8:	c1 e8 0c             	shr    $0xc,%eax
  8014cb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014d2:	f6 c4 08             	test   $0x8,%ah
  8014d5:	75 1c                	jne    8014f3 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  8014d7:	c7 44 24 08 cc 34 80 	movl   $0x8034cc,0x8(%esp)
  8014de:	00 
  8014df:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8014e6:	00 
  8014e7:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  8014ee:	e8 c9 f0 ff ff       	call   8005bc <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  8014f3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014fa:	00 
  8014fb:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801502:	00 
  801503:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80150a:	e8 cd fc ff ff       	call   8011dc <sys_page_alloc>
  80150f:	85 c0                	test   %eax,%eax
  801511:	79 20                	jns    801533 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  801513:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801517:	c7 44 24 08 08 35 80 	movl   $0x803508,0x8(%esp)
  80151e:	00 
  80151f:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  801526:	00 
  801527:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  80152e:	e8 89 f0 ff ff       	call   8005bc <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  801533:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  801539:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801540:	00 
  801541:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801545:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80154c:	e8 7b f9 ff ff       	call   800ecc <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  801551:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801558:	00 
  801559:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80155d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801564:	00 
  801565:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80156c:	00 
  80156d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801574:	e8 c2 fc ff ff       	call   80123b <sys_page_map>
  801579:	85 c0                	test   %eax,%eax
  80157b:	79 20                	jns    80159d <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  80157d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801581:	c7 44 24 08 30 35 80 	movl   $0x803530,0x8(%esp)
  801588:	00 
  801589:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  801590:	00 
  801591:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  801598:	e8 1f f0 ff ff       	call   8005bc <_panic>
	//panic("pgfault not implemented");
}
  80159d:	83 c4 24             	add    $0x24,%esp
  8015a0:	5b                   	pop    %ebx
  8015a1:	5d                   	pop    %ebp
  8015a2:	c3                   	ret    

008015a3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	57                   	push   %edi
  8015a7:	56                   	push   %esi
  8015a8:	53                   	push   %ebx
  8015a9:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  8015ac:	c7 04 24 a4 14 80 00 	movl   $0x8014a4,(%esp)
  8015b3:	e8 c8 15 00 00       	call   802b80 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8015b8:	ba 07 00 00 00       	mov    $0x7,%edx
  8015bd:	89 d0                	mov    %edx,%eax
  8015bf:	cd 30                	int    $0x30
  8015c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015c4:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	79 20                	jns    8015ea <fork+0x47>
		panic("sys_exofork: %e", envid);
  8015ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015ce:	c7 44 24 08 2e 36 80 	movl   $0x80362e,0x8(%esp)
  8015d5:	00 
  8015d6:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  8015dd:	00 
  8015de:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  8015e5:	e8 d2 ef ff ff       	call   8005bc <_panic>
	if (envid == 0) {
  8015ea:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8015ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015f3:	75 1c                	jne    801611 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015f5:	e8 82 fb ff ff       	call   80117c <sys_getenvid>
  8015fa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015ff:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801602:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801607:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  80160c:	e9 06 02 00 00       	jmp    801817 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  801611:	89 d8                	mov    %ebx,%eax
  801613:	c1 e8 16             	shr    $0x16,%eax
  801616:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80161d:	a8 01                	test   $0x1,%al
  80161f:	0f 84 57 01 00 00    	je     80177c <fork+0x1d9>
  801625:	89 de                	mov    %ebx,%esi
  801627:	c1 ee 0c             	shr    $0xc,%esi
  80162a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801631:	a8 01                	test   $0x1,%al
  801633:	0f 84 43 01 00 00    	je     80177c <fork+0x1d9>
  801639:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801640:	a8 04                	test   $0x4,%al
  801642:	0f 84 34 01 00 00    	je     80177c <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  801648:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  80164b:	89 f0                	mov    %esi,%eax
  80164d:	c1 e8 0c             	shr    $0xc,%eax
  801650:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  801657:	f6 c4 04             	test   $0x4,%ah
  80165a:	74 45                	je     8016a1 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  80165c:	25 07 0e 00 00       	and    $0xe07,%eax
  801661:	89 44 24 10          	mov    %eax,0x10(%esp)
  801665:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801669:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80166d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801671:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801678:	e8 be fb ff ff       	call   80123b <sys_page_map>
  80167d:	85 c0                	test   %eax,%eax
  80167f:	0f 89 f7 00 00 00    	jns    80177c <fork+0x1d9>
			panic ("duppage: error at lab5");
  801685:	c7 44 24 08 3e 36 80 	movl   $0x80363e,0x8(%esp)
  80168c:	00 
  80168d:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  801694:	00 
  801695:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  80169c:	e8 1b ef ff ff       	call   8005bc <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  8016a1:	a9 02 08 00 00       	test   $0x802,%eax
  8016a6:	0f 84 8c 00 00 00    	je     801738 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8016ac:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8016b3:	00 
  8016b4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016b8:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8016bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016c7:	e8 6f fb ff ff       	call   80123b <sys_page_map>
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	79 20                	jns    8016f0 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  8016d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016d4:	c7 44 24 08 54 35 80 	movl   $0x803554,0x8(%esp)
  8016db:	00 
  8016dc:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8016e3:	00 
  8016e4:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  8016eb:	e8 cc ee ff ff       	call   8005bc <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8016f0:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8016f7:	00 
  8016f8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016fc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801703:	00 
  801704:	89 74 24 04          	mov    %esi,0x4(%esp)
  801708:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80170f:	e8 27 fb ff ff       	call   80123b <sys_page_map>
  801714:	85 c0                	test   %eax,%eax
  801716:	79 64                	jns    80177c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  801718:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80171c:	c7 44 24 08 80 35 80 	movl   $0x803580,0x8(%esp)
  801723:	00 
  801724:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  80172b:	00 
  80172c:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  801733:	e8 84 ee ff ff       	call   8005bc <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801738:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  80173f:	00 
  801740:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801744:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801748:	89 74 24 04          	mov    %esi,0x4(%esp)
  80174c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801753:	e8 e3 fa ff ff       	call   80123b <sys_page_map>
  801758:	85 c0                	test   %eax,%eax
  80175a:	79 20                	jns    80177c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  80175c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801760:	c7 44 24 08 ac 35 80 	movl   $0x8035ac,0x8(%esp)
  801767:	00 
  801768:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80176f:	00 
  801770:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  801777:	e8 40 ee ff ff       	call   8005bc <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  80177c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801782:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801788:	0f 85 83 fe ff ff    	jne    801611 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  80178e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801795:	00 
  801796:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80179d:	ee 
  80179e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a1:	89 04 24             	mov    %eax,(%esp)
  8017a4:	e8 33 fa ff ff       	call   8011dc <sys_page_alloc>
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	79 20                	jns    8017cd <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  8017ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017b1:	c7 44 24 08 d8 35 80 	movl   $0x8035d8,0x8(%esp)
  8017b8:	00 
  8017b9:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8017c0:	00 
  8017c1:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  8017c8:	e8 ef ed ff ff       	call   8005bc <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  8017cd:	c7 44 24 04 f0 2b 80 	movl   $0x802bf0,0x4(%esp)
  8017d4:	00 
  8017d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d8:	89 04 24             	mov    %eax,(%esp)
  8017db:	e8 d3 fb ff ff       	call   8013b3 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8017e0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8017e7:	00 
  8017e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017eb:	89 04 24             	mov    %eax,(%esp)
  8017ee:	e8 04 fb ff ff       	call   8012f7 <sys_env_set_status>
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	79 20                	jns    801817 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  8017f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017fb:	c7 44 24 08 fc 35 80 	movl   $0x8035fc,0x8(%esp)
  801802:	00 
  801803:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  80180a:	00 
  80180b:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  801812:	e8 a5 ed ff ff       	call   8005bc <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  801817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80181a:	83 c4 3c             	add    $0x3c,%esp
  80181d:	5b                   	pop    %ebx
  80181e:	5e                   	pop    %esi
  80181f:	5f                   	pop    %edi
  801820:	5d                   	pop    %ebp
  801821:	c3                   	ret    

00801822 <sfork>:

// Challenge!
int
sfork(void)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801828:	c7 44 24 08 55 36 80 	movl   $0x803655,0x8(%esp)
  80182f:	00 
  801830:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  801837:	00 
  801838:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  80183f:	e8 78 ed ff ff       	call   8005bc <_panic>
	...

00801850 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	05 00 00 00 30       	add    $0x30000000,%eax
  80185b:	c1 e8 0c             	shr    $0xc,%eax
}
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    

00801860 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	89 04 24             	mov    %eax,(%esp)
  80186c:	e8 df ff ff ff       	call   801850 <fd2num>
  801871:	05 20 00 0d 00       	add    $0xd0020,%eax
  801876:	c1 e0 0c             	shl    $0xc,%eax
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	53                   	push   %ebx
  80187f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801882:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801887:	a8 01                	test   $0x1,%al
  801889:	74 34                	je     8018bf <fd_alloc+0x44>
  80188b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801890:	a8 01                	test   $0x1,%al
  801892:	74 32                	je     8018c6 <fd_alloc+0x4b>
  801894:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801899:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80189b:	89 c2                	mov    %eax,%edx
  80189d:	c1 ea 16             	shr    $0x16,%edx
  8018a0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018a7:	f6 c2 01             	test   $0x1,%dl
  8018aa:	74 1f                	je     8018cb <fd_alloc+0x50>
  8018ac:	89 c2                	mov    %eax,%edx
  8018ae:	c1 ea 0c             	shr    $0xc,%edx
  8018b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018b8:	f6 c2 01             	test   $0x1,%dl
  8018bb:	75 17                	jne    8018d4 <fd_alloc+0x59>
  8018bd:	eb 0c                	jmp    8018cb <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8018bf:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8018c4:	eb 05                	jmp    8018cb <fd_alloc+0x50>
  8018c6:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8018cb:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  8018cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d2:	eb 17                	jmp    8018eb <fd_alloc+0x70>
  8018d4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8018d9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8018de:	75 b9                	jne    801899 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8018e0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  8018e6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8018eb:	5b                   	pop    %ebx
  8018ec:	5d                   	pop    %ebp
  8018ed:	c3                   	ret    

008018ee <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018f9:	83 fa 1f             	cmp    $0x1f,%edx
  8018fc:	77 3f                	ja     80193d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018fe:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801904:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801907:	89 d0                	mov    %edx,%eax
  801909:	c1 e8 16             	shr    $0x16,%eax
  80190c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801913:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801918:	f6 c1 01             	test   $0x1,%cl
  80191b:	74 20                	je     80193d <fd_lookup+0x4f>
  80191d:	89 d0                	mov    %edx,%eax
  80191f:	c1 e8 0c             	shr    $0xc,%eax
  801922:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801929:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80192e:	f6 c1 01             	test   $0x1,%cl
  801931:	74 0a                	je     80193d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801933:	8b 45 0c             	mov    0xc(%ebp),%eax
  801936:	89 10                	mov    %edx,(%eax)
	return 0;
  801938:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193d:	5d                   	pop    %ebp
  80193e:	c3                   	ret    

0080193f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	53                   	push   %ebx
  801943:	83 ec 14             	sub    $0x14,%esp
  801946:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801949:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80194c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801951:	39 0d 20 40 80 00    	cmp    %ecx,0x804020
  801957:	75 17                	jne    801970 <dev_lookup+0x31>
  801959:	eb 07                	jmp    801962 <dev_lookup+0x23>
  80195b:	39 0a                	cmp    %ecx,(%edx)
  80195d:	75 11                	jne    801970 <dev_lookup+0x31>
  80195f:	90                   	nop
  801960:	eb 05                	jmp    801967 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801962:	ba 20 40 80 00       	mov    $0x804020,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801967:	89 13                	mov    %edx,(%ebx)
			return 0;
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
  80196e:	eb 35                	jmp    8019a5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801970:	83 c0 01             	add    $0x1,%eax
  801973:	8b 14 85 e8 36 80 00 	mov    0x8036e8(,%eax,4),%edx
  80197a:	85 d2                	test   %edx,%edx
  80197c:	75 dd                	jne    80195b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80197e:	a1 04 50 80 00       	mov    0x805004,%eax
  801983:	8b 40 48             	mov    0x48(%eax),%eax
  801986:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80198a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198e:	c7 04 24 6c 36 80 00 	movl   $0x80366c,(%esp)
  801995:	e8 1d ed ff ff       	call   8006b7 <cprintf>
	*dev = 0;
  80199a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8019a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019a5:	83 c4 14             	add    $0x14,%esp
  8019a8:	5b                   	pop    %ebx
  8019a9:	5d                   	pop    %ebp
  8019aa:	c3                   	ret    

008019ab <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 38             	sub    $0x38,%esp
  8019b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8019ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019bd:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8019c1:	89 3c 24             	mov    %edi,(%esp)
  8019c4:	e8 87 fe ff ff       	call   801850 <fd2num>
  8019c9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8019cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019d0:	89 04 24             	mov    %eax,(%esp)
  8019d3:	e8 16 ff ff ff       	call   8018ee <fd_lookup>
  8019d8:	89 c3                	mov    %eax,%ebx
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 05                	js     8019e3 <fd_close+0x38>
	    || fd != fd2)
  8019de:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8019e1:	74 0e                	je     8019f1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8019e3:	89 f0                	mov    %esi,%eax
  8019e5:	84 c0                	test   %al,%al
  8019e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ec:	0f 44 d8             	cmove  %eax,%ebx
  8019ef:	eb 3d                	jmp    801a2e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f8:	8b 07                	mov    (%edi),%eax
  8019fa:	89 04 24             	mov    %eax,(%esp)
  8019fd:	e8 3d ff ff ff       	call   80193f <dev_lookup>
  801a02:	89 c3                	mov    %eax,%ebx
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 16                	js     801a1e <fd_close+0x73>
		if (dev->dev_close)
  801a08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a0b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801a0e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801a13:	85 c0                	test   %eax,%eax
  801a15:	74 07                	je     801a1e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801a17:	89 3c 24             	mov    %edi,(%esp)
  801a1a:	ff d0                	call   *%eax
  801a1c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801a1e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a29:	e8 6b f8 ff ff       	call   801299 <sys_page_unmap>
	return r;
}
  801a2e:	89 d8                	mov    %ebx,%eax
  801a30:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a33:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a36:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a39:	89 ec                	mov    %ebp,%esp
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    

00801a3d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	89 04 24             	mov    %eax,(%esp)
  801a50:	e8 99 fe ff ff       	call   8018ee <fd_lookup>
  801a55:	85 c0                	test   %eax,%eax
  801a57:	78 13                	js     801a6c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801a59:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a60:	00 
  801a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a64:	89 04 24             	mov    %eax,(%esp)
  801a67:	e8 3f ff ff ff       	call   8019ab <fd_close>
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <close_all>:

void
close_all(void)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	53                   	push   %ebx
  801a72:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a75:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a7a:	89 1c 24             	mov    %ebx,(%esp)
  801a7d:	e8 bb ff ff ff       	call   801a3d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801a82:	83 c3 01             	add    $0x1,%ebx
  801a85:	83 fb 20             	cmp    $0x20,%ebx
  801a88:	75 f0                	jne    801a7a <close_all+0xc>
		close(i);
}
  801a8a:	83 c4 14             	add    $0x14,%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    

00801a90 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	83 ec 58             	sub    $0x58,%esp
  801a96:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a99:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a9c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a9f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801aa2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	89 04 24             	mov    %eax,(%esp)
  801aaf:	e8 3a fe ff ff       	call   8018ee <fd_lookup>
  801ab4:	89 c3                	mov    %eax,%ebx
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	0f 88 e1 00 00 00    	js     801b9f <dup+0x10f>
		return r;
	close(newfdnum);
  801abe:	89 3c 24             	mov    %edi,(%esp)
  801ac1:	e8 77 ff ff ff       	call   801a3d <close>

	newfd = INDEX2FD(newfdnum);
  801ac6:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801acc:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801acf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ad2:	89 04 24             	mov    %eax,(%esp)
  801ad5:	e8 86 fd ff ff       	call   801860 <fd2data>
  801ada:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801adc:	89 34 24             	mov    %esi,(%esp)
  801adf:	e8 7c fd ff ff       	call   801860 <fd2data>
  801ae4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801ae7:	89 d8                	mov    %ebx,%eax
  801ae9:	c1 e8 16             	shr    $0x16,%eax
  801aec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801af3:	a8 01                	test   $0x1,%al
  801af5:	74 46                	je     801b3d <dup+0xad>
  801af7:	89 d8                	mov    %ebx,%eax
  801af9:	c1 e8 0c             	shr    $0xc,%eax
  801afc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b03:	f6 c2 01             	test   $0x1,%dl
  801b06:	74 35                	je     801b3d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b08:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b0f:	25 07 0e 00 00       	and    $0xe07,%eax
  801b14:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b26:	00 
  801b27:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b32:	e8 04 f7 ff ff       	call   80123b <sys_page_map>
  801b37:	89 c3                	mov    %eax,%ebx
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	78 3b                	js     801b78 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b40:	89 c2                	mov    %eax,%edx
  801b42:	c1 ea 0c             	shr    $0xc,%edx
  801b45:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b4c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801b52:	89 54 24 10          	mov    %edx,0x10(%esp)
  801b56:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801b5a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b61:	00 
  801b62:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b66:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b6d:	e8 c9 f6 ff ff       	call   80123b <sys_page_map>
  801b72:	89 c3                	mov    %eax,%ebx
  801b74:	85 c0                	test   %eax,%eax
  801b76:	79 25                	jns    801b9d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801b78:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b83:	e8 11 f7 ff ff       	call   801299 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b96:	e8 fe f6 ff ff       	call   801299 <sys_page_unmap>
	return r;
  801b9b:	eb 02                	jmp    801b9f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801b9d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801b9f:	89 d8                	mov    %ebx,%eax
  801ba1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ba4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ba7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801baa:	89 ec                	mov    %ebp,%esp
  801bac:	5d                   	pop    %ebp
  801bad:	c3                   	ret    

00801bae <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	53                   	push   %ebx
  801bb2:	83 ec 24             	sub    $0x24,%esp
  801bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bb8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbf:	89 1c 24             	mov    %ebx,(%esp)
  801bc2:	e8 27 fd ff ff       	call   8018ee <fd_lookup>
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	78 6d                	js     801c38 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bcb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd5:	8b 00                	mov    (%eax),%eax
  801bd7:	89 04 24             	mov    %eax,(%esp)
  801bda:	e8 60 fd ff ff       	call   80193f <dev_lookup>
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	78 55                	js     801c38 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be6:	8b 50 08             	mov    0x8(%eax),%edx
  801be9:	83 e2 03             	and    $0x3,%edx
  801bec:	83 fa 01             	cmp    $0x1,%edx
  801bef:	75 23                	jne    801c14 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801bf1:	a1 04 50 80 00       	mov    0x805004,%eax
  801bf6:	8b 40 48             	mov    0x48(%eax),%eax
  801bf9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c01:	c7 04 24 ad 36 80 00 	movl   $0x8036ad,(%esp)
  801c08:	e8 aa ea ff ff       	call   8006b7 <cprintf>
		return -E_INVAL;
  801c0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c12:	eb 24                	jmp    801c38 <read+0x8a>
	}
	if (!dev->dev_read)
  801c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c17:	8b 52 08             	mov    0x8(%edx),%edx
  801c1a:	85 d2                	test   %edx,%edx
  801c1c:	74 15                	je     801c33 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c21:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c28:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c2c:	89 04 24             	mov    %eax,(%esp)
  801c2f:	ff d2                	call   *%edx
  801c31:	eb 05                	jmp    801c38 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801c33:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801c38:	83 c4 24             	add    $0x24,%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5d                   	pop    %ebp
  801c3d:	c3                   	ret    

00801c3e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	57                   	push   %edi
  801c42:	56                   	push   %esi
  801c43:	53                   	push   %ebx
  801c44:	83 ec 1c             	sub    $0x1c,%esp
  801c47:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c4a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c52:	85 f6                	test   %esi,%esi
  801c54:	74 30                	je     801c86 <readn+0x48>
  801c56:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c5b:	89 f2                	mov    %esi,%edx
  801c5d:	29 c2                	sub    %eax,%edx
  801c5f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c63:	03 45 0c             	add    0xc(%ebp),%eax
  801c66:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6a:	89 3c 24             	mov    %edi,(%esp)
  801c6d:	e8 3c ff ff ff       	call   801bae <read>
		if (m < 0)
  801c72:	85 c0                	test   %eax,%eax
  801c74:	78 10                	js     801c86 <readn+0x48>
			return m;
		if (m == 0)
  801c76:	85 c0                	test   %eax,%eax
  801c78:	74 0a                	je     801c84 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c7a:	01 c3                	add    %eax,%ebx
  801c7c:	89 d8                	mov    %ebx,%eax
  801c7e:	39 f3                	cmp    %esi,%ebx
  801c80:	72 d9                	jb     801c5b <readn+0x1d>
  801c82:	eb 02                	jmp    801c86 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801c84:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801c86:	83 c4 1c             	add    $0x1c,%esp
  801c89:	5b                   	pop    %ebx
  801c8a:	5e                   	pop    %esi
  801c8b:	5f                   	pop    %edi
  801c8c:	5d                   	pop    %ebp
  801c8d:	c3                   	ret    

00801c8e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	53                   	push   %ebx
  801c92:	83 ec 24             	sub    $0x24,%esp
  801c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c98:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9f:	89 1c 24             	mov    %ebx,(%esp)
  801ca2:	e8 47 fc ff ff       	call   8018ee <fd_lookup>
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	78 68                	js     801d13 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb5:	8b 00                	mov    (%eax),%eax
  801cb7:	89 04 24             	mov    %eax,(%esp)
  801cba:	e8 80 fc ff ff       	call   80193f <dev_lookup>
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	78 50                	js     801d13 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cca:	75 23                	jne    801cef <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ccc:	a1 04 50 80 00       	mov    0x805004,%eax
  801cd1:	8b 40 48             	mov    0x48(%eax),%eax
  801cd4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdc:	c7 04 24 c9 36 80 00 	movl   $0x8036c9,(%esp)
  801ce3:	e8 cf e9 ff ff       	call   8006b7 <cprintf>
		return -E_INVAL;
  801ce8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ced:	eb 24                	jmp    801d13 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf2:	8b 52 0c             	mov    0xc(%edx),%edx
  801cf5:	85 d2                	test   %edx,%edx
  801cf7:	74 15                	je     801d0e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801cf9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cfc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d07:	89 04 24             	mov    %eax,(%esp)
  801d0a:	ff d2                	call   *%edx
  801d0c:	eb 05                	jmp    801d13 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801d0e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801d13:	83 c4 24             	add    $0x24,%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    

00801d19 <seek>:

int
seek(int fdnum, off_t offset)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d1f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801d22:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	89 04 24             	mov    %eax,(%esp)
  801d2c:	e8 bd fb ff ff       	call   8018ee <fd_lookup>
  801d31:	85 c0                	test   %eax,%eax
  801d33:	78 0e                	js     801d43 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	53                   	push   %ebx
  801d49:	83 ec 24             	sub    $0x24,%esp
  801d4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d56:	89 1c 24             	mov    %ebx,(%esp)
  801d59:	e8 90 fb ff ff       	call   8018ee <fd_lookup>
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 61                	js     801dc3 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	89 04 24             	mov    %eax,(%esp)
  801d71:	e8 c9 fb ff ff       	call   80193f <dev_lookup>
  801d76:	85 c0                	test   %eax,%eax
  801d78:	78 49                	js     801dc3 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d81:	75 23                	jne    801da6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801d83:	a1 04 50 80 00       	mov    0x805004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d88:	8b 40 48             	mov    0x48(%eax),%eax
  801d8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d93:	c7 04 24 8c 36 80 00 	movl   $0x80368c,(%esp)
  801d9a:	e8 18 e9 ff ff       	call   8006b7 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801d9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801da4:	eb 1d                	jmp    801dc3 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801da6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da9:	8b 52 18             	mov    0x18(%edx),%edx
  801dac:	85 d2                	test   %edx,%edx
  801dae:	74 0e                	je     801dbe <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801db7:	89 04 24             	mov    %eax,(%esp)
  801dba:	ff d2                	call   *%edx
  801dbc:	eb 05                	jmp    801dc3 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801dbe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801dc3:	83 c4 24             	add    $0x24,%esp
  801dc6:	5b                   	pop    %ebx
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    

00801dc9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	53                   	push   %ebx
  801dcd:	83 ec 24             	sub    $0x24,%esp
  801dd0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801dd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	89 04 24             	mov    %eax,(%esp)
  801de0:	e8 09 fb ff ff       	call   8018ee <fd_lookup>
  801de5:	85 c0                	test   %eax,%eax
  801de7:	78 52                	js     801e3b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801de9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df3:	8b 00                	mov    (%eax),%eax
  801df5:	89 04 24             	mov    %eax,(%esp)
  801df8:	e8 42 fb ff ff       	call   80193f <dev_lookup>
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	78 3a                	js     801e3b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e04:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e08:	74 2c                	je     801e36 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e0a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e0d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801e14:	00 00 00 
	stat->st_isdir = 0;
  801e17:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e1e:	00 00 00 
	stat->st_dev = dev;
  801e21:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e27:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e2e:	89 14 24             	mov    %edx,(%esp)
  801e31:	ff 50 14             	call   *0x14(%eax)
  801e34:	eb 05                	jmp    801e3b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801e36:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801e3b:	83 c4 24             	add    $0x24,%esp
  801e3e:	5b                   	pop    %ebx
  801e3f:	5d                   	pop    %ebp
  801e40:	c3                   	ret    

00801e41 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 18             	sub    $0x18,%esp
  801e47:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e4a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e4d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e54:	00 
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	89 04 24             	mov    %eax,(%esp)
  801e5b:	e8 bc 01 00 00       	call   80201c <open>
  801e60:	89 c3                	mov    %eax,%ebx
  801e62:	85 c0                	test   %eax,%eax
  801e64:	78 1b                	js     801e81 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6d:	89 1c 24             	mov    %ebx,(%esp)
  801e70:	e8 54 ff ff ff       	call   801dc9 <fstat>
  801e75:	89 c6                	mov    %eax,%esi
	close(fd);
  801e77:	89 1c 24             	mov    %ebx,(%esp)
  801e7a:	e8 be fb ff ff       	call   801a3d <close>
	return r;
  801e7f:	89 f3                	mov    %esi,%ebx
}
  801e81:	89 d8                	mov    %ebx,%eax
  801e83:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e86:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e89:	89 ec                	mov    %ebp,%esp
  801e8b:	5d                   	pop    %ebp
  801e8c:	c3                   	ret    
  801e8d:	00 00                	add    %al,(%eax)
	...

00801e90 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
  801e96:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e99:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e9c:	89 c3                	mov    %eax,%ebx
  801e9e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801ea0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ea7:	75 11                	jne    801eba <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ea9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801eb0:	e8 41 0e 00 00       	call   802cf6 <ipc_find_env>
  801eb5:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801eba:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ec1:	00 
  801ec2:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ec9:	00 
  801eca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ece:	a1 00 50 80 00       	mov    0x805000,%eax
  801ed3:	89 04 24             	mov    %eax,(%esp)
  801ed6:	e8 97 0d 00 00       	call   802c72 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801edb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ee2:	00 
  801ee3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ee7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eee:	e8 2d 0d 00 00       	call   802c20 <ipc_recv>
}
  801ef3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ef6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ef9:	89 ec                	mov    %ebp,%esp
  801efb:	5d                   	pop    %ebp
  801efc:	c3                   	ret    

00801efd <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	53                   	push   %ebx
  801f01:	83 ec 14             	sub    $0x14,%esp
  801f04:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f12:	ba 00 00 00 00       	mov    $0x0,%edx
  801f17:	b8 05 00 00 00       	mov    $0x5,%eax
  801f1c:	e8 6f ff ff ff       	call   801e90 <fsipc>
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 2b                	js     801f50 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f25:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f2c:	00 
  801f2d:	89 1c 24             	mov    %ebx,(%esp)
  801f30:	e8 a6 ed ff ff       	call   800cdb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801f35:	a1 80 60 80 00       	mov    0x806080,%eax
  801f3a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f40:	a1 84 60 80 00       	mov    0x806084,%eax
  801f45:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801f4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f50:	83 c4 14             	add    $0x14,%esp
  801f53:	5b                   	pop    %ebx
  801f54:	5d                   	pop    %ebp
  801f55:	c3                   	ret    

00801f56 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f62:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f67:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6c:	b8 06 00 00 00       	mov    $0x6,%eax
  801f71:	e8 1a ff ff ff       	call   801e90 <fsipc>
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	56                   	push   %esi
  801f7c:	53                   	push   %ebx
  801f7d:	83 ec 10             	sub    $0x10,%esp
  801f80:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	8b 40 0c             	mov    0xc(%eax),%eax
  801f89:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f8e:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f94:	ba 00 00 00 00       	mov    $0x0,%edx
  801f99:	b8 03 00 00 00       	mov    $0x3,%eax
  801f9e:	e8 ed fe ff ff       	call   801e90 <fsipc>
  801fa3:	89 c3                	mov    %eax,%ebx
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	78 6a                	js     802013 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801fa9:	39 c6                	cmp    %eax,%esi
  801fab:	73 24                	jae    801fd1 <devfile_read+0x59>
  801fad:	c7 44 24 0c f8 36 80 	movl   $0x8036f8,0xc(%esp)
  801fb4:	00 
  801fb5:	c7 44 24 08 ff 36 80 	movl   $0x8036ff,0x8(%esp)
  801fbc:	00 
  801fbd:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801fc4:	00 
  801fc5:	c7 04 24 14 37 80 00 	movl   $0x803714,(%esp)
  801fcc:	e8 eb e5 ff ff       	call   8005bc <_panic>
	assert(r <= PGSIZE);
  801fd1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fd6:	7e 24                	jle    801ffc <devfile_read+0x84>
  801fd8:	c7 44 24 0c 1f 37 80 	movl   $0x80371f,0xc(%esp)
  801fdf:	00 
  801fe0:	c7 44 24 08 ff 36 80 	movl   $0x8036ff,0x8(%esp)
  801fe7:	00 
  801fe8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801fef:	00 
  801ff0:	c7 04 24 14 37 80 00 	movl   $0x803714,(%esp)
  801ff7:	e8 c0 e5 ff ff       	call   8005bc <_panic>
	memmove(buf, &fsipcbuf, r);
  801ffc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802000:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802007:	00 
  802008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200b:	89 04 24             	mov    %eax,(%esp)
  80200e:	e8 b9 ee ff ff       	call   800ecc <memmove>
	return r;
}
  802013:	89 d8                	mov    %ebx,%eax
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	5b                   	pop    %ebx
  802019:	5e                   	pop    %esi
  80201a:	5d                   	pop    %ebp
  80201b:	c3                   	ret    

0080201c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	56                   	push   %esi
  802020:	53                   	push   %ebx
  802021:	83 ec 20             	sub    $0x20,%esp
  802024:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802027:	89 34 24             	mov    %esi,(%esp)
  80202a:	e8 61 ec ff ff       	call   800c90 <strlen>
		return -E_BAD_PATH;
  80202f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802034:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802039:	7f 5e                	jg     802099 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80203b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80203e:	89 04 24             	mov    %eax,(%esp)
  802041:	e8 35 f8 ff ff       	call   80187b <fd_alloc>
  802046:	89 c3                	mov    %eax,%ebx
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 4d                	js     802099 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80204c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802050:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802057:	e8 7f ec ff ff       	call   800cdb <strcpy>
	fsipcbuf.open.req_omode = mode;
  80205c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205f:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802067:	b8 01 00 00 00       	mov    $0x1,%eax
  80206c:	e8 1f fe ff ff       	call   801e90 <fsipc>
  802071:	89 c3                	mov    %eax,%ebx
  802073:	85 c0                	test   %eax,%eax
  802075:	79 15                	jns    80208c <open+0x70>
		fd_close(fd, 0);
  802077:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80207e:	00 
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	89 04 24             	mov    %eax,(%esp)
  802085:	e8 21 f9 ff ff       	call   8019ab <fd_close>
		return r;
  80208a:	eb 0d                	jmp    802099 <open+0x7d>
	}

	return fd2num(fd);
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	89 04 24             	mov    %eax,(%esp)
  802092:	e8 b9 f7 ff ff       	call   801850 <fd2num>
  802097:	89 c3                	mov    %eax,%ebx
}
  802099:	89 d8                	mov    %ebx,%eax
  80209b:	83 c4 20             	add    $0x20,%esp
  80209e:	5b                   	pop    %ebx
  80209f:	5e                   	pop    %esi
  8020a0:	5d                   	pop    %ebp
  8020a1:	c3                   	ret    
	...

008020a4 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	57                   	push   %edi
  8020a8:	56                   	push   %esi
  8020a9:	53                   	push   %ebx
  8020aa:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8020b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020b7:	00 
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	89 04 24             	mov    %eax,(%esp)
  8020be:	e8 59 ff ff ff       	call   80201c <open>
  8020c3:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  8020c9:	85 c0                	test   %eax,%eax
  8020cb:	0f 88 b2 05 00 00    	js     802683 <spawn+0x5df>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8020d1:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8020d8:	00 
  8020d9:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8020df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e3:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8020e9:	89 04 24             	mov    %eax,(%esp)
  8020ec:	e8 4d fb ff ff       	call   801c3e <readn>
  8020f1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8020f6:	75 0c                	jne    802104 <spawn+0x60>
	    || elf->e_magic != ELF_MAGIC) {
  8020f8:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8020ff:	45 4c 46 
  802102:	74 3b                	je     80213f <spawn+0x9b>
		close(fd);
  802104:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80210a:	89 04 24             	mov    %eax,(%esp)
  80210d:	e8 2b f9 ff ff       	call   801a3d <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802112:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802119:	46 
  80211a:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802120:	89 44 24 04          	mov    %eax,0x4(%esp)
  802124:	c7 04 24 2b 37 80 00 	movl   $0x80372b,(%esp)
  80212b:	e8 87 e5 ff ff       	call   8006b7 <cprintf>
		return -E_NOT_EXEC;
  802130:	c7 85 84 fd ff ff f2 	movl   $0xfffffff2,-0x27c(%ebp)
  802137:	ff ff ff 
  80213a:	e9 50 05 00 00       	jmp    80268f <spawn+0x5eb>
  80213f:	ba 07 00 00 00       	mov    $0x7,%edx
  802144:	89 d0                	mov    %edx,%eax
  802146:	cd 30                	int    $0x30
  802148:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80214e:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802154:	85 c0                	test   %eax,%eax
  802156:	0f 88 33 05 00 00    	js     80268f <spawn+0x5eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80215c:	89 c6                	mov    %eax,%esi
  80215e:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802164:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802167:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80216d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802173:	b9 11 00 00 00       	mov    $0x11,%ecx
  802178:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80217a:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802180:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802186:	8b 55 0c             	mov    0xc(%ebp),%edx
  802189:	8b 02                	mov    (%edx),%eax
  80218b:	85 c0                	test   %eax,%eax
  80218d:	74 5f                	je     8021ee <spawn+0x14a>
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80218f:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  802194:	be 00 00 00 00       	mov    $0x0,%esi
  802199:	89 d7                	mov    %edx,%edi
		string_size += strlen(argv[argc]) + 1;
  80219b:	89 04 24             	mov    %eax,(%esp)
  80219e:	e8 ed ea ff ff       	call   800c90 <strlen>
  8021a3:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8021a7:	83 c6 01             	add    $0x1,%esi
  8021aa:	89 f2                	mov    %esi,%edx
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  8021ac:	8d 0c b5 00 00 00 00 	lea    0x0(,%esi,4),%ecx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8021b3:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	75 e1                	jne    80219b <spawn+0xf7>
  8021ba:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  8021c0:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8021c6:	bf 00 10 40 00       	mov    $0x401000,%edi
  8021cb:	29 df                	sub    %ebx,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8021cd:	89 f8                	mov    %edi,%eax
  8021cf:	83 e0 fc             	and    $0xfffffffc,%eax
  8021d2:	f7 d2                	not    %edx
  8021d4:	8d 14 90             	lea    (%eax,%edx,4),%edx
  8021d7:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8021dd:	89 d0                	mov    %edx,%eax
  8021df:	83 e8 08             	sub    $0x8,%eax
  8021e2:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8021e7:	77 2d                	ja     802216 <spawn+0x172>
  8021e9:	e9 b2 04 00 00       	jmp    8026a0 <spawn+0x5fc>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8021ee:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8021f5:	00 00 00 
  8021f8:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  8021ff:	00 00 00 
  802202:	be 00 00 00 00       	mov    $0x0,%esi
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802207:	c7 85 94 fd ff ff fc 	movl   $0x400ffc,-0x26c(%ebp)
  80220e:	0f 40 00 
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802211:	bf 00 10 40 00       	mov    $0x401000,%edi
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802216:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80221d:	00 
  80221e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802225:	00 
  802226:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80222d:	e8 aa ef ff ff       	call   8011dc <sys_page_alloc>
  802232:	85 c0                	test   %eax,%eax
  802234:	0f 88 6b 04 00 00    	js     8026a5 <spawn+0x601>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80223a:	85 f6                	test   %esi,%esi
  80223c:	7e 46                	jle    802284 <spawn+0x1e0>
  80223e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802243:	89 b5 90 fd ff ff    	mov    %esi,-0x270(%ebp)
  802249:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  80224c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802252:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802258:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  80225b:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  80225e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802262:	89 3c 24             	mov    %edi,(%esp)
  802265:	e8 71 ea ff ff       	call   800cdb <strcpy>
		string_store += strlen(argv[i]) + 1;
  80226a:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  80226d:	89 04 24             	mov    %eax,(%esp)
  802270:	e8 1b ea ff ff       	call   800c90 <strlen>
  802275:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802279:	83 c3 01             	add    $0x1,%ebx
  80227c:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  802282:	75 c8                	jne    80224c <spawn+0x1a8>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802284:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  80228a:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802290:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802297:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80229d:	74 24                	je     8022c3 <spawn+0x21f>
  80229f:	c7 44 24 0c a0 37 80 	movl   $0x8037a0,0xc(%esp)
  8022a6:	00 
  8022a7:	c7 44 24 08 ff 36 80 	movl   $0x8036ff,0x8(%esp)
  8022ae:	00 
  8022af:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  8022b6:	00 
  8022b7:	c7 04 24 45 37 80 00 	movl   $0x803745,(%esp)
  8022be:	e8 f9 e2 ff ff       	call   8005bc <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8022c3:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8022c9:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8022ce:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8022d4:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  8022d7:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8022dd:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8022e0:	89 d0                	mov    %edx,%eax
  8022e2:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8022e7:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8022ed:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8022f4:	00 
  8022f5:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  8022fc:	ee 
  8022fd:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802303:	89 44 24 08          	mov    %eax,0x8(%esp)
  802307:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80230e:	00 
  80230f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802316:	e8 20 ef ff ff       	call   80123b <sys_page_map>
  80231b:	89 c3                	mov    %eax,%ebx
  80231d:	85 c0                	test   %eax,%eax
  80231f:	78 1a                	js     80233b <spawn+0x297>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802321:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802328:	00 
  802329:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802330:	e8 64 ef ff ff       	call   801299 <sys_page_unmap>
  802335:	89 c3                	mov    %eax,%ebx
  802337:	85 c0                	test   %eax,%eax
  802339:	79 1f                	jns    80235a <spawn+0x2b6>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80233b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802342:	00 
  802343:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80234a:	e8 4a ef ff ff       	call   801299 <sys_page_unmap>
	return r;
  80234f:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802355:	e9 35 03 00 00       	jmp    80268f <spawn+0x5eb>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80235a:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802360:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  802367:	00 
  802368:	0f 84 e2 01 00 00    	je     802550 <spawn+0x4ac>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80236e:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802375:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80237b:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802382:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  802385:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  80238b:	83 3a 01             	cmpl   $0x1,(%edx)
  80238e:	0f 85 9b 01 00 00    	jne    80252f <spawn+0x48b>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802394:	8b 42 18             	mov    0x18(%edx),%eax
  802397:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  80239a:	83 f8 01             	cmp    $0x1,%eax
  80239d:	19 c0                	sbb    %eax,%eax
  80239f:	83 e0 fe             	and    $0xfffffffe,%eax
  8023a2:	83 c0 07             	add    $0x7,%eax
  8023a5:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8023ab:	8b 52 04             	mov    0x4(%edx),%edx
  8023ae:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  8023b4:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8023ba:	8b 70 10             	mov    0x10(%eax),%esi
  8023bd:	8b 50 14             	mov    0x14(%eax),%edx
  8023c0:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  8023c6:	8b 40 08             	mov    0x8(%eax),%eax
  8023c9:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8023cf:	25 ff 0f 00 00       	and    $0xfff,%eax
  8023d4:	74 16                	je     8023ec <spawn+0x348>
		va -= i;
  8023d6:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  8023dc:	01 c2                	add    %eax,%edx
  8023de:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
		filesz += i;
  8023e4:	01 c6                	add    %eax,%esi
		fileoffset -= i;
  8023e6:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8023ec:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  8023f3:	0f 84 36 01 00 00    	je     80252f <spawn+0x48b>
  8023f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fe:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i >= filesz) {
  802403:	39 f7                	cmp    %esi,%edi
  802405:	72 31                	jb     802438 <spawn+0x394>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802407:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  80240d:	89 54 24 08          	mov    %edx,0x8(%esp)
  802411:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802417:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80241b:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802421:	89 04 24             	mov    %eax,(%esp)
  802424:	e8 b3 ed ff ff       	call   8011dc <sys_page_alloc>
  802429:	85 c0                	test   %eax,%eax
  80242b:	0f 89 ea 00 00 00    	jns    80251b <spawn+0x477>
  802431:	89 c6                	mov    %eax,%esi
  802433:	e9 27 02 00 00       	jmp    80265f <spawn+0x5bb>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802438:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80243f:	00 
  802440:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802447:	00 
  802448:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80244f:	e8 88 ed ff ff       	call   8011dc <sys_page_alloc>
  802454:	85 c0                	test   %eax,%eax
  802456:	0f 88 f9 01 00 00    	js     802655 <spawn+0x5b1>
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  80245c:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  802462:	01 d8                	add    %ebx,%eax
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802464:	89 44 24 04          	mov    %eax,0x4(%esp)
  802468:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80246e:	89 04 24             	mov    %eax,(%esp)
  802471:	e8 a3 f8 ff ff       	call   801d19 <seek>
  802476:	85 c0                	test   %eax,%eax
  802478:	0f 88 db 01 00 00    	js     802659 <spawn+0x5b5>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80247e:	89 f0                	mov    %esi,%eax
  802480:	29 f8                	sub    %edi,%eax
  802482:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802487:	ba 00 10 00 00       	mov    $0x1000,%edx
  80248c:	0f 47 c2             	cmova  %edx,%eax
  80248f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802493:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80249a:	00 
  80249b:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8024a1:	89 04 24             	mov    %eax,(%esp)
  8024a4:	e8 95 f7 ff ff       	call   801c3e <readn>
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	0f 88 ac 01 00 00    	js     80265d <spawn+0x5b9>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8024b1:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8024b7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8024bb:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  8024c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024c5:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8024cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024cf:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8024d6:	00 
  8024d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024de:	e8 58 ed ff ff       	call   80123b <sys_page_map>
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	79 20                	jns    802507 <spawn+0x463>
				panic("spawn: sys_page_map data: %e", r);
  8024e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024eb:	c7 44 24 08 51 37 80 	movl   $0x803751,0x8(%esp)
  8024f2:	00 
  8024f3:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  8024fa:	00 
  8024fb:	c7 04 24 45 37 80 00 	movl   $0x803745,(%esp)
  802502:	e8 b5 e0 ff ff       	call   8005bc <_panic>
			sys_page_unmap(0, UTEMP);
  802507:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80250e:	00 
  80250f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802516:	e8 7e ed ff ff       	call   801299 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80251b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802521:	89 df                	mov    %ebx,%edi
  802523:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  802529:	0f 82 d4 fe ff ff    	jb     802403 <spawn+0x35f>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80252f:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802536:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  80253d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802544:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  80254a:	0f 8f 35 fe ff ff    	jg     802385 <spawn+0x2e1>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802550:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802556:	89 04 24             	mov    %eax,(%esp)
  802559:	e8 df f4 ff ff       	call   801a3d <close>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  80255e:	be 00 00 00 00       	mov    $0x0,%esi
			if (((uvpd[PDX(PGADDR(0,pn,0))]&PTE_P) && (uvpd[PDX(PGADDR(0,pn,0))]&PTE_U)) 
  802563:	89 f2                	mov    %esi,%edx
  802565:	c1 e2 0c             	shl    $0xc,%edx
  802568:	89 d0                	mov    %edx,%eax
  80256a:	c1 e8 16             	shr    $0x16,%eax
  80256d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  802574:	f6 c1 01             	test   $0x1,%cl
  802577:	74 5b                	je     8025d4 <spawn+0x530>
  802579:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802580:	a8 04                	test   $0x4,%al
  802582:	74 50                	je     8025d4 <spawn+0x530>
				&& ((uvpt[pn]&PTE_P) && (uvpt[pn]&PTE_U) && (uvpt[pn]&PTE_SHARE))) {
  802584:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80258b:	a8 01                	test   $0x1,%al
  80258d:	74 45                	je     8025d4 <spawn+0x530>
  80258f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  802596:	a8 04                	test   $0x4,%al
  802598:	74 3a                	je     8025d4 <spawn+0x530>
  80259a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8025a1:	f6 c4 04             	test   $0x4,%ah
  8025a4:	74 2e                	je     8025d4 <spawn+0x530>
			sys_page_map(0, (void *)PGADDR(0,pn,0), child, (void *)PGADDR(0,pn,0), uvpt[pn]&PTE_SYSCALL);
  8025a6:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8025ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8025b2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8025b6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8025ba:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8025c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025c4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025cf:	e8 67 ec ff ff       	call   80123b <sys_page_map>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  8025d4:	83 c6 01             	add    $0x1,%esi
  8025d7:	81 fe fe eb 0e 00    	cmp    $0xeebfe,%esi
  8025dd:	75 84                	jne    802563 <spawn+0x4bf>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8025df:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8025e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e9:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8025ef:	89 04 24             	mov    %eax,(%esp)
  8025f2:	e8 5e ed ff ff       	call   801355 <sys_env_set_trapframe>
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	79 20                	jns    80261b <spawn+0x577>
		panic("sys_env_set_trapframe: %e", r);
  8025fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025ff:	c7 44 24 08 6e 37 80 	movl   $0x80376e,0x8(%esp)
  802606:	00 
  802607:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  80260e:	00 
  80260f:	c7 04 24 45 37 80 00 	movl   $0x803745,(%esp)
  802616:	e8 a1 df ff ff       	call   8005bc <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80261b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802622:	00 
  802623:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802629:	89 04 24             	mov    %eax,(%esp)
  80262c:	e8 c6 ec ff ff       	call   8012f7 <sys_env_set_status>
  802631:	85 c0                	test   %eax,%eax
  802633:	79 5a                	jns    80268f <spawn+0x5eb>
		panic("sys_env_set_status: %e", r);
  802635:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802639:	c7 44 24 08 88 37 80 	movl   $0x803788,0x8(%esp)
  802640:	00 
  802641:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  802648:	00 
  802649:	c7 04 24 45 37 80 00 	movl   $0x803745,(%esp)
  802650:	e8 67 df ff ff       	call   8005bc <_panic>
  802655:	89 c6                	mov    %eax,%esi
  802657:	eb 06                	jmp    80265f <spawn+0x5bb>
  802659:	89 c6                	mov    %eax,%esi
  80265b:	eb 02                	jmp    80265f <spawn+0x5bb>
  80265d:	89 c6                	mov    %eax,%esi

	return child;

error:
	sys_env_destroy(child);
  80265f:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802665:	89 04 24             	mov    %eax,(%esp)
  802668:	e8 b2 ea ff ff       	call   80111f <sys_env_destroy>
	close(fd);
  80266d:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802673:	89 04 24             	mov    %eax,(%esp)
  802676:	e8 c2 f3 ff ff       	call   801a3d <close>
	return r;
  80267b:	89 b5 84 fd ff ff    	mov    %esi,-0x27c(%ebp)
  802681:	eb 0c                	jmp    80268f <spawn+0x5eb>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  802683:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802689:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80268f:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802695:	81 c4 ac 02 00 00    	add    $0x2ac,%esp
  80269b:	5b                   	pop    %ebx
  80269c:	5e                   	pop    %esi
  80269d:	5f                   	pop    %edi
  80269e:	5d                   	pop    %ebp
  80269f:	c3                   	ret    
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8026a0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  8026a5:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  8026ab:	eb e2                	jmp    80268f <spawn+0x5eb>

008026ad <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	56                   	push   %esi
  8026b1:	53                   	push   %ebx
  8026b2:	83 ec 10             	sub    $0x10,%esp
  8026b5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8026b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8026bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026bf:	74 66                	je     802727 <spawnl+0x7a>
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8026c1:	b9 00 00 00 00       	mov    $0x0,%ecx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  8026c6:	83 c1 01             	add    $0x1,%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8026c9:	89 c2                	mov    %eax,%edx
  8026cb:	83 c0 04             	add    $0x4,%eax
  8026ce:	83 3a 00             	cmpl   $0x0,(%edx)
  8026d1:	75 f3                	jne    8026c6 <spawnl+0x19>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8026d3:	8d 04 8d 26 00 00 00 	lea    0x26(,%ecx,4),%eax
  8026da:	83 e0 f0             	and    $0xfffffff0,%eax
  8026dd:	29 c4                	sub    %eax,%esp
  8026df:	8d 44 24 17          	lea    0x17(%esp),%eax
  8026e3:	83 e0 f0             	and    $0xfffffff0,%eax
  8026e6:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  8026e8:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  8026ea:	c7 44 88 04 00 00 00 	movl   $0x0,0x4(%eax,%ecx,4)
  8026f1:	00 

	va_start(vl, arg0);
  8026f2:	8d 55 10             	lea    0x10(%ebp),%edx
	unsigned i;
	for(i=0;i<argc;i++)
  8026f5:	89 ce                	mov    %ecx,%esi
  8026f7:	85 c9                	test   %ecx,%ecx
  8026f9:	74 16                	je     802711 <spawnl+0x64>
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  802700:	83 c0 01             	add    $0x1,%eax
  802703:	89 d1                	mov    %edx,%ecx
  802705:	83 c2 04             	add    $0x4,%edx
  802708:	8b 09                	mov    (%ecx),%ecx
  80270a:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80270d:	39 f0                	cmp    %esi,%eax
  80270f:	75 ef                	jne    802700 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802711:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802715:	8b 45 08             	mov    0x8(%ebp),%eax
  802718:	89 04 24             	mov    %eax,(%esp)
  80271b:	e8 84 f9 ff ff       	call   8020a4 <spawn>
}
  802720:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802723:	5b                   	pop    %ebx
  802724:	5e                   	pop    %esi
  802725:	5d                   	pop    %ebp
  802726:	c3                   	ret    
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802727:	83 ec 20             	sub    $0x20,%esp
  80272a:	8d 44 24 17          	lea    0x17(%esp),%eax
  80272e:	83 e0 f0             	and    $0xfffffff0,%eax
  802731:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802733:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  802735:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273c:	eb d3                	jmp    802711 <spawnl+0x64>
	...

00802740 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802740:	55                   	push   %ebp
  802741:	89 e5                	mov    %esp,%ebp
  802743:	83 ec 18             	sub    $0x18,%esp
  802746:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802749:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80274c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80274f:	8b 45 08             	mov    0x8(%ebp),%eax
  802752:	89 04 24             	mov    %eax,(%esp)
  802755:	e8 06 f1 ff ff       	call   801860 <fd2data>
  80275a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80275c:	c7 44 24 04 c8 37 80 	movl   $0x8037c8,0x4(%esp)
  802763:	00 
  802764:	89 34 24             	mov    %esi,(%esp)
  802767:	e8 6f e5 ff ff       	call   800cdb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80276c:	8b 43 04             	mov    0x4(%ebx),%eax
  80276f:	2b 03                	sub    (%ebx),%eax
  802771:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802777:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80277e:	00 00 00 
	stat->st_dev = &devpipe;
  802781:	c7 86 88 00 00 00 3c 	movl   $0x80403c,0x88(%esi)
  802788:	40 80 00 
	return 0;
}
  80278b:	b8 00 00 00 00       	mov    $0x0,%eax
  802790:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802793:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802796:	89 ec                	mov    %ebp,%esp
  802798:	5d                   	pop    %ebp
  802799:	c3                   	ret    

0080279a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80279a:	55                   	push   %ebp
  80279b:	89 e5                	mov    %esp,%ebp
  80279d:	53                   	push   %ebx
  80279e:	83 ec 14             	sub    $0x14,%esp
  8027a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8027a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027af:	e8 e5 ea ff ff       	call   801299 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8027b4:	89 1c 24             	mov    %ebx,(%esp)
  8027b7:	e8 a4 f0 ff ff       	call   801860 <fd2data>
  8027bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027c7:	e8 cd ea ff ff       	call   801299 <sys_page_unmap>
}
  8027cc:	83 c4 14             	add    $0x14,%esp
  8027cf:	5b                   	pop    %ebx
  8027d0:	5d                   	pop    %ebp
  8027d1:	c3                   	ret    

008027d2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8027d2:	55                   	push   %ebp
  8027d3:	89 e5                	mov    %esp,%ebp
  8027d5:	57                   	push   %edi
  8027d6:	56                   	push   %esi
  8027d7:	53                   	push   %ebx
  8027d8:	83 ec 2c             	sub    $0x2c,%esp
  8027db:	89 c7                	mov    %eax,%edi
  8027dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8027e0:	a1 04 50 80 00       	mov    0x805004,%eax
  8027e5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8027e8:	89 3c 24             	mov    %edi,(%esp)
  8027eb:	e8 50 05 00 00       	call   802d40 <pageref>
  8027f0:	89 c6                	mov    %eax,%esi
  8027f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f5:	89 04 24             	mov    %eax,(%esp)
  8027f8:	e8 43 05 00 00       	call   802d40 <pageref>
  8027fd:	39 c6                	cmp    %eax,%esi
  8027ff:	0f 94 c0             	sete   %al
  802802:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802805:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80280b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80280e:	39 cb                	cmp    %ecx,%ebx
  802810:	75 08                	jne    80281a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  802812:	83 c4 2c             	add    $0x2c,%esp
  802815:	5b                   	pop    %ebx
  802816:	5e                   	pop    %esi
  802817:	5f                   	pop    %edi
  802818:	5d                   	pop    %ebp
  802819:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80281a:	83 f8 01             	cmp    $0x1,%eax
  80281d:	75 c1                	jne    8027e0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80281f:	8b 52 58             	mov    0x58(%edx),%edx
  802822:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802826:	89 54 24 08          	mov    %edx,0x8(%esp)
  80282a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80282e:	c7 04 24 cf 37 80 00 	movl   $0x8037cf,(%esp)
  802835:	e8 7d de ff ff       	call   8006b7 <cprintf>
  80283a:	eb a4                	jmp    8027e0 <_pipeisclosed+0xe>

0080283c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	57                   	push   %edi
  802840:	56                   	push   %esi
  802841:	53                   	push   %ebx
  802842:	83 ec 2c             	sub    $0x2c,%esp
  802845:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802848:	89 34 24             	mov    %esi,(%esp)
  80284b:	e8 10 f0 ff ff       	call   801860 <fd2data>
  802850:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802852:	bf 00 00 00 00       	mov    $0x0,%edi
  802857:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80285b:	75 50                	jne    8028ad <devpipe_write+0x71>
  80285d:	eb 5c                	jmp    8028bb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80285f:	89 da                	mov    %ebx,%edx
  802861:	89 f0                	mov    %esi,%eax
  802863:	e8 6a ff ff ff       	call   8027d2 <_pipeisclosed>
  802868:	85 c0                	test   %eax,%eax
  80286a:	75 53                	jne    8028bf <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80286c:	e8 3b e9 ff ff       	call   8011ac <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802871:	8b 43 04             	mov    0x4(%ebx),%eax
  802874:	8b 13                	mov    (%ebx),%edx
  802876:	83 c2 20             	add    $0x20,%edx
  802879:	39 d0                	cmp    %edx,%eax
  80287b:	73 e2                	jae    80285f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80287d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802880:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  802884:	88 55 e7             	mov    %dl,-0x19(%ebp)
  802887:	89 c2                	mov    %eax,%edx
  802889:	c1 fa 1f             	sar    $0x1f,%edx
  80288c:	c1 ea 1b             	shr    $0x1b,%edx
  80288f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802892:	83 e1 1f             	and    $0x1f,%ecx
  802895:	29 d1                	sub    %edx,%ecx
  802897:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80289b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  80289f:	83 c0 01             	add    $0x1,%eax
  8028a2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028a5:	83 c7 01             	add    $0x1,%edi
  8028a8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8028ab:	74 0e                	je     8028bb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8028ad:	8b 43 04             	mov    0x4(%ebx),%eax
  8028b0:	8b 13                	mov    (%ebx),%edx
  8028b2:	83 c2 20             	add    $0x20,%edx
  8028b5:	39 d0                	cmp    %edx,%eax
  8028b7:	73 a6                	jae    80285f <devpipe_write+0x23>
  8028b9:	eb c2                	jmp    80287d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8028bb:	89 f8                	mov    %edi,%eax
  8028bd:	eb 05                	jmp    8028c4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8028bf:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8028c4:	83 c4 2c             	add    $0x2c,%esp
  8028c7:	5b                   	pop    %ebx
  8028c8:	5e                   	pop    %esi
  8028c9:	5f                   	pop    %edi
  8028ca:	5d                   	pop    %ebp
  8028cb:	c3                   	ret    

008028cc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
  8028cf:	83 ec 28             	sub    $0x28,%esp
  8028d2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8028d5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8028d8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8028db:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8028de:	89 3c 24             	mov    %edi,(%esp)
  8028e1:	e8 7a ef ff ff       	call   801860 <fd2data>
  8028e6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028e8:	be 00 00 00 00       	mov    $0x0,%esi
  8028ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028f1:	75 47                	jne    80293a <devpipe_read+0x6e>
  8028f3:	eb 52                	jmp    802947 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8028f5:	89 f0                	mov    %esi,%eax
  8028f7:	eb 5e                	jmp    802957 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8028f9:	89 da                	mov    %ebx,%edx
  8028fb:	89 f8                	mov    %edi,%eax
  8028fd:	8d 76 00             	lea    0x0(%esi),%esi
  802900:	e8 cd fe ff ff       	call   8027d2 <_pipeisclosed>
  802905:	85 c0                	test   %eax,%eax
  802907:	75 49                	jne    802952 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802909:	e8 9e e8 ff ff       	call   8011ac <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80290e:	8b 03                	mov    (%ebx),%eax
  802910:	3b 43 04             	cmp    0x4(%ebx),%eax
  802913:	74 e4                	je     8028f9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802915:	89 c2                	mov    %eax,%edx
  802917:	c1 fa 1f             	sar    $0x1f,%edx
  80291a:	c1 ea 1b             	shr    $0x1b,%edx
  80291d:	01 d0                	add    %edx,%eax
  80291f:	83 e0 1f             	and    $0x1f,%eax
  802922:	29 d0                	sub    %edx,%eax
  802924:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802929:	8b 55 0c             	mov    0xc(%ebp),%edx
  80292c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80292f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802932:	83 c6 01             	add    $0x1,%esi
  802935:	3b 75 10             	cmp    0x10(%ebp),%esi
  802938:	74 0d                	je     802947 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80293a:	8b 03                	mov    (%ebx),%eax
  80293c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80293f:	75 d4                	jne    802915 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802941:	85 f6                	test   %esi,%esi
  802943:	75 b0                	jne    8028f5 <devpipe_read+0x29>
  802945:	eb b2                	jmp    8028f9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802947:	89 f0                	mov    %esi,%eax
  802949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802950:	eb 05                	jmp    802957 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802952:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802957:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80295a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80295d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802960:	89 ec                	mov    %ebp,%esp
  802962:	5d                   	pop    %ebp
  802963:	c3                   	ret    

00802964 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802964:	55                   	push   %ebp
  802965:	89 e5                	mov    %esp,%ebp
  802967:	83 ec 48             	sub    $0x48,%esp
  80296a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80296d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802970:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802973:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802976:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802979:	89 04 24             	mov    %eax,(%esp)
  80297c:	e8 fa ee ff ff       	call   80187b <fd_alloc>
  802981:	89 c3                	mov    %eax,%ebx
  802983:	85 c0                	test   %eax,%eax
  802985:	0f 88 45 01 00 00    	js     802ad0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80298b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802992:	00 
  802993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802996:	89 44 24 04          	mov    %eax,0x4(%esp)
  80299a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029a1:	e8 36 e8 ff ff       	call   8011dc <sys_page_alloc>
  8029a6:	89 c3                	mov    %eax,%ebx
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	0f 88 20 01 00 00    	js     802ad0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8029b0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8029b3:	89 04 24             	mov    %eax,(%esp)
  8029b6:	e8 c0 ee ff ff       	call   80187b <fd_alloc>
  8029bb:	89 c3                	mov    %eax,%ebx
  8029bd:	85 c0                	test   %eax,%eax
  8029bf:	0f 88 f8 00 00 00    	js     802abd <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029c5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029cc:	00 
  8029cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029db:	e8 fc e7 ff ff       	call   8011dc <sys_page_alloc>
  8029e0:	89 c3                	mov    %eax,%ebx
  8029e2:	85 c0                	test   %eax,%eax
  8029e4:	0f 88 d3 00 00 00    	js     802abd <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8029ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ed:	89 04 24             	mov    %eax,(%esp)
  8029f0:	e8 6b ee ff ff       	call   801860 <fd2data>
  8029f5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029f7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029fe:	00 
  8029ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a0a:	e8 cd e7 ff ff       	call   8011dc <sys_page_alloc>
  802a0f:	89 c3                	mov    %eax,%ebx
  802a11:	85 c0                	test   %eax,%eax
  802a13:	0f 88 91 00 00 00    	js     802aaa <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a1c:	89 04 24             	mov    %eax,(%esp)
  802a1f:	e8 3c ee ff ff       	call   801860 <fd2data>
  802a24:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802a2b:	00 
  802a2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a30:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802a37:	00 
  802a38:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a3c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a43:	e8 f3 e7 ff ff       	call   80123b <sys_page_map>
  802a48:	89 c3                	mov    %eax,%ebx
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	78 4c                	js     802a9a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802a4e:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802a54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a57:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802a59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802a63:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a6c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802a6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a71:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802a78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7b:	89 04 24             	mov    %eax,(%esp)
  802a7e:	e8 cd ed ff ff       	call   801850 <fd2num>
  802a83:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a88:	89 04 24             	mov    %eax,(%esp)
  802a8b:	e8 c0 ed ff ff       	call   801850 <fd2num>
  802a90:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802a93:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a98:	eb 36                	jmp    802ad0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  802a9a:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802aa5:	e8 ef e7 ff ff       	call   801299 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802aaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ab8:	e8 dc e7 ff ff       	call   801299 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802abd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ac4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802acb:	e8 c9 e7 ff ff       	call   801299 <sys_page_unmap>
    err:
	return r;
}
  802ad0:	89 d8                	mov    %ebx,%eax
  802ad2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802ad5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802ad8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802adb:	89 ec                	mov    %ebp,%esp
  802add:	5d                   	pop    %ebp
  802ade:	c3                   	ret    

00802adf <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802adf:	55                   	push   %ebp
  802ae0:	89 e5                	mov    %esp,%ebp
  802ae2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ae5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	89 04 24             	mov    %eax,(%esp)
  802af2:	e8 f7 ed ff ff       	call   8018ee <fd_lookup>
  802af7:	85 c0                	test   %eax,%eax
  802af9:	78 15                	js     802b10 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	89 04 24             	mov    %eax,(%esp)
  802b01:	e8 5a ed ff ff       	call   801860 <fd2data>
	return _pipeisclosed(fd, p);
  802b06:	89 c2                	mov    %eax,%edx
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	e8 c2 fc ff ff       	call   8027d2 <_pipeisclosed>
}
  802b10:	c9                   	leave  
  802b11:	c3                   	ret    
	...

00802b14 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802b14:	55                   	push   %ebp
  802b15:	89 e5                	mov    %esp,%ebp
  802b17:	56                   	push   %esi
  802b18:	53                   	push   %ebx
  802b19:	83 ec 10             	sub    $0x10,%esp
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  802b1f:	85 c0                	test   %eax,%eax
  802b21:	75 24                	jne    802b47 <wait+0x33>
  802b23:	c7 44 24 0c e7 37 80 	movl   $0x8037e7,0xc(%esp)
  802b2a:	00 
  802b2b:	c7 44 24 08 ff 36 80 	movl   $0x8036ff,0x8(%esp)
  802b32:	00 
  802b33:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802b3a:	00 
  802b3b:	c7 04 24 f2 37 80 00 	movl   $0x8037f2,(%esp)
  802b42:	e8 75 da ff ff       	call   8005bc <_panic>
	e = &envs[ENVX(envid)];
  802b47:	89 c3                	mov    %eax,%ebx
  802b49:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802b4f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802b52:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802b58:	8b 73 48             	mov    0x48(%ebx),%esi
  802b5b:	39 c6                	cmp    %eax,%esi
  802b5d:	75 1a                	jne    802b79 <wait+0x65>
  802b5f:	8b 43 54             	mov    0x54(%ebx),%eax
  802b62:	85 c0                	test   %eax,%eax
  802b64:	74 13                	je     802b79 <wait+0x65>
		sys_yield();
  802b66:	e8 41 e6 ff ff       	call   8011ac <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802b6b:	8b 43 48             	mov    0x48(%ebx),%eax
  802b6e:	39 f0                	cmp    %esi,%eax
  802b70:	75 07                	jne    802b79 <wait+0x65>
  802b72:	8b 43 54             	mov    0x54(%ebx),%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	75 ed                	jne    802b66 <wait+0x52>
		sys_yield();
}
  802b79:	83 c4 10             	add    $0x10,%esp
  802b7c:	5b                   	pop    %ebx
  802b7d:	5e                   	pop    %esi
  802b7e:	5d                   	pop    %ebp
  802b7f:	c3                   	ret    

00802b80 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b80:	55                   	push   %ebp
  802b81:	89 e5                	mov    %esp,%ebp
  802b83:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b86:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802b8d:	75 54                	jne    802be3 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  802b8f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802b96:	00 
  802b97:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802b9e:	ee 
  802b9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ba6:	e8 31 e6 ff ff       	call   8011dc <sys_page_alloc>
  802bab:	85 c0                	test   %eax,%eax
  802bad:	79 20                	jns    802bcf <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  802baf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bb3:	c7 44 24 08 fd 37 80 	movl   $0x8037fd,0x8(%esp)
  802bba:	00 
  802bbb:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  802bc2:	00 
  802bc3:	c7 04 24 15 38 80 00 	movl   $0x803815,(%esp)
  802bca:	e8 ed d9 ff ff       	call   8005bc <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802bcf:	c7 44 24 04 f0 2b 80 	movl   $0x802bf0,0x4(%esp)
  802bd6:	00 
  802bd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bde:	e8 d0 e7 ff ff       	call   8013b3 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802beb:	c9                   	leave  
  802bec:	c3                   	ret    
  802bed:	00 00                	add    %al,(%eax)
	...

00802bf0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802bf0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802bf1:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802bf6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802bf8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  802bfb:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  802bff:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  802c02:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  802c06:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802c0a:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802c0c:	83 c4 08             	add    $0x8,%esp
	popal
  802c0f:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802c10:	83 c4 04             	add    $0x4,%esp
	popfl
  802c13:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802c14:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802c15:	c3                   	ret    
	...

00802c20 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c20:	55                   	push   %ebp
  802c21:	89 e5                	mov    %esp,%ebp
  802c23:	56                   	push   %esi
  802c24:	53                   	push   %ebx
  802c25:	83 ec 10             	sub    $0x10,%esp
  802c28:	8b 75 08             	mov    0x8(%ebp),%esi
  802c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802c31:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802c33:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802c38:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  802c3b:	89 04 24             	mov    %eax,(%esp)
  802c3e:	e8 02 e8 ff ff       	call   801445 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802c43:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802c48:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	78 0e                	js     802c5f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  802c51:	a1 04 50 80 00       	mov    0x805004,%eax
  802c56:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  802c59:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  802c5c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  802c5f:	85 f6                	test   %esi,%esi
  802c61:	74 02                	je     802c65 <ipc_recv+0x45>
		*from_env_store = sender;
  802c63:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  802c65:	85 db                	test   %ebx,%ebx
  802c67:	74 02                	je     802c6b <ipc_recv+0x4b>
		*perm_store = perm;
  802c69:	89 13                	mov    %edx,(%ebx)
	return val;

}
  802c6b:	83 c4 10             	add    $0x10,%esp
  802c6e:	5b                   	pop    %ebx
  802c6f:	5e                   	pop    %esi
  802c70:	5d                   	pop    %ebp
  802c71:	c3                   	ret    

00802c72 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802c72:	55                   	push   %ebp
  802c73:	89 e5                	mov    %esp,%ebp
  802c75:	57                   	push   %edi
  802c76:	56                   	push   %esi
  802c77:	53                   	push   %ebx
  802c78:	83 ec 1c             	sub    $0x1c,%esp
  802c7b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802c7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802c81:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  802c84:	85 db                	test   %ebx,%ebx
  802c86:	75 04                	jne    802c8c <ipc_send+0x1a>
  802c88:	85 f6                	test   %esi,%esi
  802c8a:	75 15                	jne    802ca1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  802c8c:	85 db                	test   %ebx,%ebx
  802c8e:	74 16                	je     802ca6 <ipc_send+0x34>
  802c90:	85 f6                	test   %esi,%esi
  802c92:	0f 94 c0             	sete   %al
      pg = 0;
  802c95:	84 c0                	test   %al,%al
  802c97:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9c:	0f 45 d8             	cmovne %eax,%ebx
  802c9f:	eb 05                	jmp    802ca6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802ca1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802ca6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802caa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802cae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	89 04 24             	mov    %eax,(%esp)
  802cb8:	e8 54 e7 ff ff       	call   801411 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  802cbd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802cc0:	75 07                	jne    802cc9 <ipc_send+0x57>
           sys_yield();
  802cc2:	e8 e5 e4 ff ff       	call   8011ac <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  802cc7:	eb dd                	jmp    802ca6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	90                   	nop
  802ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cd0:	74 1c                	je     802cee <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802cd2:	c7 44 24 08 23 38 80 	movl   $0x803823,0x8(%esp)
  802cd9:	00 
  802cda:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802ce1:	00 
  802ce2:	c7 04 24 2d 38 80 00 	movl   $0x80382d,(%esp)
  802ce9:	e8 ce d8 ff ff       	call   8005bc <_panic>
		}
    }
}
  802cee:	83 c4 1c             	add    $0x1c,%esp
  802cf1:	5b                   	pop    %ebx
  802cf2:	5e                   	pop    %esi
  802cf3:	5f                   	pop    %edi
  802cf4:	5d                   	pop    %ebp
  802cf5:	c3                   	ret    

00802cf6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802cf6:	55                   	push   %ebp
  802cf7:	89 e5                	mov    %esp,%ebp
  802cf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802cfc:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802d01:	39 c8                	cmp    %ecx,%eax
  802d03:	74 17                	je     802d1c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802d05:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802d0a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802d0d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802d13:	8b 52 50             	mov    0x50(%edx),%edx
  802d16:	39 ca                	cmp    %ecx,%edx
  802d18:	75 14                	jne    802d2e <ipc_find_env+0x38>
  802d1a:	eb 05                	jmp    802d21 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802d1c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802d21:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802d24:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802d29:	8b 40 40             	mov    0x40(%eax),%eax
  802d2c:	eb 0e                	jmp    802d3c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802d2e:	83 c0 01             	add    $0x1,%eax
  802d31:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d36:	75 d2                	jne    802d0a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802d38:	66 b8 00 00          	mov    $0x0,%ax
}
  802d3c:	5d                   	pop    %ebp
  802d3d:	c3                   	ret    
	...

00802d40 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d40:	55                   	push   %ebp
  802d41:	89 e5                	mov    %esp,%ebp
  802d43:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d46:	89 d0                	mov    %edx,%eax
  802d48:	c1 e8 16             	shr    $0x16,%eax
  802d4b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802d52:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d57:	f6 c1 01             	test   $0x1,%cl
  802d5a:	74 1d                	je     802d79 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802d5c:	c1 ea 0c             	shr    $0xc,%edx
  802d5f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802d66:	f6 c2 01             	test   $0x1,%dl
  802d69:	74 0e                	je     802d79 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d6b:	c1 ea 0c             	shr    $0xc,%edx
  802d6e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802d75:	ef 
  802d76:	0f b7 c0             	movzwl %ax,%eax
}
  802d79:	5d                   	pop    %ebp
  802d7a:	c3                   	ret    
  802d7b:	00 00                	add    %al,(%eax)
  802d7d:	00 00                	add    %al,(%eax)
	...

00802d80 <__udivdi3>:
  802d80:	83 ec 1c             	sub    $0x1c,%esp
  802d83:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802d87:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  802d8b:	8b 44 24 20          	mov    0x20(%esp),%eax
  802d8f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802d93:	89 74 24 10          	mov    %esi,0x10(%esp)
  802d97:	8b 74 24 24          	mov    0x24(%esp),%esi
  802d9b:	85 ff                	test   %edi,%edi
  802d9d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802da1:	89 44 24 08          	mov    %eax,0x8(%esp)
  802da5:	89 cd                	mov    %ecx,%ebp
  802da7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dab:	75 33                	jne    802de0 <__udivdi3+0x60>
  802dad:	39 f1                	cmp    %esi,%ecx
  802daf:	77 57                	ja     802e08 <__udivdi3+0x88>
  802db1:	85 c9                	test   %ecx,%ecx
  802db3:	75 0b                	jne    802dc0 <__udivdi3+0x40>
  802db5:	b8 01 00 00 00       	mov    $0x1,%eax
  802dba:	31 d2                	xor    %edx,%edx
  802dbc:	f7 f1                	div    %ecx
  802dbe:	89 c1                	mov    %eax,%ecx
  802dc0:	89 f0                	mov    %esi,%eax
  802dc2:	31 d2                	xor    %edx,%edx
  802dc4:	f7 f1                	div    %ecx
  802dc6:	89 c6                	mov    %eax,%esi
  802dc8:	8b 44 24 04          	mov    0x4(%esp),%eax
  802dcc:	f7 f1                	div    %ecx
  802dce:	89 f2                	mov    %esi,%edx
  802dd0:	8b 74 24 10          	mov    0x10(%esp),%esi
  802dd4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802dd8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802ddc:	83 c4 1c             	add    $0x1c,%esp
  802ddf:	c3                   	ret    
  802de0:	31 d2                	xor    %edx,%edx
  802de2:	31 c0                	xor    %eax,%eax
  802de4:	39 f7                	cmp    %esi,%edi
  802de6:	77 e8                	ja     802dd0 <__udivdi3+0x50>
  802de8:	0f bd cf             	bsr    %edi,%ecx
  802deb:	83 f1 1f             	xor    $0x1f,%ecx
  802dee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802df2:	75 2c                	jne    802e20 <__udivdi3+0xa0>
  802df4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802df8:	76 04                	jbe    802dfe <__udivdi3+0x7e>
  802dfa:	39 f7                	cmp    %esi,%edi
  802dfc:	73 d2                	jae    802dd0 <__udivdi3+0x50>
  802dfe:	31 d2                	xor    %edx,%edx
  802e00:	b8 01 00 00 00       	mov    $0x1,%eax
  802e05:	eb c9                	jmp    802dd0 <__udivdi3+0x50>
  802e07:	90                   	nop
  802e08:	89 f2                	mov    %esi,%edx
  802e0a:	f7 f1                	div    %ecx
  802e0c:	31 d2                	xor    %edx,%edx
  802e0e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802e12:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802e16:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802e1a:	83 c4 1c             	add    $0x1c,%esp
  802e1d:	c3                   	ret    
  802e1e:	66 90                	xchg   %ax,%ax
  802e20:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e25:	b8 20 00 00 00       	mov    $0x20,%eax
  802e2a:	89 ea                	mov    %ebp,%edx
  802e2c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802e30:	d3 e7                	shl    %cl,%edi
  802e32:	89 c1                	mov    %eax,%ecx
  802e34:	d3 ea                	shr    %cl,%edx
  802e36:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e3b:	09 fa                	or     %edi,%edx
  802e3d:	89 f7                	mov    %esi,%edi
  802e3f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802e43:	89 f2                	mov    %esi,%edx
  802e45:	8b 74 24 08          	mov    0x8(%esp),%esi
  802e49:	d3 e5                	shl    %cl,%ebp
  802e4b:	89 c1                	mov    %eax,%ecx
  802e4d:	d3 ef                	shr    %cl,%edi
  802e4f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e54:	d3 e2                	shl    %cl,%edx
  802e56:	89 c1                	mov    %eax,%ecx
  802e58:	d3 ee                	shr    %cl,%esi
  802e5a:	09 d6                	or     %edx,%esi
  802e5c:	89 fa                	mov    %edi,%edx
  802e5e:	89 f0                	mov    %esi,%eax
  802e60:	f7 74 24 0c          	divl   0xc(%esp)
  802e64:	89 d7                	mov    %edx,%edi
  802e66:	89 c6                	mov    %eax,%esi
  802e68:	f7 e5                	mul    %ebp
  802e6a:	39 d7                	cmp    %edx,%edi
  802e6c:	72 22                	jb     802e90 <__udivdi3+0x110>
  802e6e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802e72:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e77:	d3 e5                	shl    %cl,%ebp
  802e79:	39 c5                	cmp    %eax,%ebp
  802e7b:	73 04                	jae    802e81 <__udivdi3+0x101>
  802e7d:	39 d7                	cmp    %edx,%edi
  802e7f:	74 0f                	je     802e90 <__udivdi3+0x110>
  802e81:	89 f0                	mov    %esi,%eax
  802e83:	31 d2                	xor    %edx,%edx
  802e85:	e9 46 ff ff ff       	jmp    802dd0 <__udivdi3+0x50>
  802e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e90:	8d 46 ff             	lea    -0x1(%esi),%eax
  802e93:	31 d2                	xor    %edx,%edx
  802e95:	8b 74 24 10          	mov    0x10(%esp),%esi
  802e99:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802e9d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802ea1:	83 c4 1c             	add    $0x1c,%esp
  802ea4:	c3                   	ret    
	...

00802eb0 <__umoddi3>:
  802eb0:	83 ec 1c             	sub    $0x1c,%esp
  802eb3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802eb7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  802ebb:	8b 44 24 20          	mov    0x20(%esp),%eax
  802ebf:	89 74 24 10          	mov    %esi,0x10(%esp)
  802ec3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802ec7:	8b 74 24 24          	mov    0x24(%esp),%esi
  802ecb:	85 ed                	test   %ebp,%ebp
  802ecd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802ed1:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ed5:	89 cf                	mov    %ecx,%edi
  802ed7:	89 04 24             	mov    %eax,(%esp)
  802eda:	89 f2                	mov    %esi,%edx
  802edc:	75 1a                	jne    802ef8 <__umoddi3+0x48>
  802ede:	39 f1                	cmp    %esi,%ecx
  802ee0:	76 4e                	jbe    802f30 <__umoddi3+0x80>
  802ee2:	f7 f1                	div    %ecx
  802ee4:	89 d0                	mov    %edx,%eax
  802ee6:	31 d2                	xor    %edx,%edx
  802ee8:	8b 74 24 10          	mov    0x10(%esp),%esi
  802eec:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802ef0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802ef4:	83 c4 1c             	add    $0x1c,%esp
  802ef7:	c3                   	ret    
  802ef8:	39 f5                	cmp    %esi,%ebp
  802efa:	77 54                	ja     802f50 <__umoddi3+0xa0>
  802efc:	0f bd c5             	bsr    %ebp,%eax
  802eff:	83 f0 1f             	xor    $0x1f,%eax
  802f02:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f06:	75 60                	jne    802f68 <__umoddi3+0xb8>
  802f08:	3b 0c 24             	cmp    (%esp),%ecx
  802f0b:	0f 87 07 01 00 00    	ja     803018 <__umoddi3+0x168>
  802f11:	89 f2                	mov    %esi,%edx
  802f13:	8b 34 24             	mov    (%esp),%esi
  802f16:	29 ce                	sub    %ecx,%esi
  802f18:	19 ea                	sbb    %ebp,%edx
  802f1a:	89 34 24             	mov    %esi,(%esp)
  802f1d:	8b 04 24             	mov    (%esp),%eax
  802f20:	8b 74 24 10          	mov    0x10(%esp),%esi
  802f24:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802f28:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802f2c:	83 c4 1c             	add    $0x1c,%esp
  802f2f:	c3                   	ret    
  802f30:	85 c9                	test   %ecx,%ecx
  802f32:	75 0b                	jne    802f3f <__umoddi3+0x8f>
  802f34:	b8 01 00 00 00       	mov    $0x1,%eax
  802f39:	31 d2                	xor    %edx,%edx
  802f3b:	f7 f1                	div    %ecx
  802f3d:	89 c1                	mov    %eax,%ecx
  802f3f:	89 f0                	mov    %esi,%eax
  802f41:	31 d2                	xor    %edx,%edx
  802f43:	f7 f1                	div    %ecx
  802f45:	8b 04 24             	mov    (%esp),%eax
  802f48:	f7 f1                	div    %ecx
  802f4a:	eb 98                	jmp    802ee4 <__umoddi3+0x34>
  802f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f50:	89 f2                	mov    %esi,%edx
  802f52:	8b 74 24 10          	mov    0x10(%esp),%esi
  802f56:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802f5a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802f5e:	83 c4 1c             	add    $0x1c,%esp
  802f61:	c3                   	ret    
  802f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802f68:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802f6d:	89 e8                	mov    %ebp,%eax
  802f6f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802f74:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802f78:	89 fa                	mov    %edi,%edx
  802f7a:	d3 e0                	shl    %cl,%eax
  802f7c:	89 e9                	mov    %ebp,%ecx
  802f7e:	d3 ea                	shr    %cl,%edx
  802f80:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802f85:	09 c2                	or     %eax,%edx
  802f87:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f8b:	89 14 24             	mov    %edx,(%esp)
  802f8e:	89 f2                	mov    %esi,%edx
  802f90:	d3 e7                	shl    %cl,%edi
  802f92:	89 e9                	mov    %ebp,%ecx
  802f94:	d3 ea                	shr    %cl,%edx
  802f96:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802f9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f9f:	d3 e6                	shl    %cl,%esi
  802fa1:	89 e9                	mov    %ebp,%ecx
  802fa3:	d3 e8                	shr    %cl,%eax
  802fa5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802faa:	09 f0                	or     %esi,%eax
  802fac:	8b 74 24 08          	mov    0x8(%esp),%esi
  802fb0:	f7 34 24             	divl   (%esp)
  802fb3:	d3 e6                	shl    %cl,%esi
  802fb5:	89 74 24 08          	mov    %esi,0x8(%esp)
  802fb9:	89 d6                	mov    %edx,%esi
  802fbb:	f7 e7                	mul    %edi
  802fbd:	39 d6                	cmp    %edx,%esi
  802fbf:	89 c1                	mov    %eax,%ecx
  802fc1:	89 d7                	mov    %edx,%edi
  802fc3:	72 3f                	jb     803004 <__umoddi3+0x154>
  802fc5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802fc9:	72 35                	jb     803000 <__umoddi3+0x150>
  802fcb:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fcf:	29 c8                	sub    %ecx,%eax
  802fd1:	19 fe                	sbb    %edi,%esi
  802fd3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802fd8:	89 f2                	mov    %esi,%edx
  802fda:	d3 e8                	shr    %cl,%eax
  802fdc:	89 e9                	mov    %ebp,%ecx
  802fde:	d3 e2                	shl    %cl,%edx
  802fe0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802fe5:	09 d0                	or     %edx,%eax
  802fe7:	89 f2                	mov    %esi,%edx
  802fe9:	d3 ea                	shr    %cl,%edx
  802feb:	8b 74 24 10          	mov    0x10(%esp),%esi
  802fef:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802ff3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802ff7:	83 c4 1c             	add    $0x1c,%esp
  802ffa:	c3                   	ret    
  802ffb:	90                   	nop
  802ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803000:	39 d6                	cmp    %edx,%esi
  803002:	75 c7                	jne    802fcb <__umoddi3+0x11b>
  803004:	89 d7                	mov    %edx,%edi
  803006:	89 c1                	mov    %eax,%ecx
  803008:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80300c:	1b 3c 24             	sbb    (%esp),%edi
  80300f:	eb ba                	jmp    802fcb <__umoddi3+0x11b>
  803011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803018:	39 f5                	cmp    %esi,%ebp
  80301a:	0f 82 f1 fe ff ff    	jb     802f11 <__umoddi3+0x61>
  803020:	e9 f8 fe ff ff       	jmp    802f1d <__umoddi3+0x6d>
