
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 df 03 00 00       	call   800410 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	8b 75 08             	mov    0x8(%ebp),%esi
  800048:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80004b:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800050:	85 db                	test   %ebx,%ebx
  800052:	7e 15                	jle    800069 <sum+0x29>
  800054:	ba 00 00 00 00       	mov    $0x0,%edx
		tot ^= i * s[i];
  800059:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80005d:	0f af ca             	imul   %edx,%ecx
  800060:	31 c8                	xor    %ecx,%eax

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800062:	83 c2 01             	add    $0x1,%edx
  800065:	39 da                	cmp    %ebx,%edx
  800067:	75 f0                	jne    800059 <sum+0x19>
		tot ^= i * s[i];
	return tot;
}
  800069:	5b                   	pop    %ebx
  80006a:	5e                   	pop    %esi
  80006b:	5d                   	pop    %ebp
  80006c:	c3                   	ret    

0080006d <umain>:

void
umain(int argc, char **argv)
{
  80006d:	55                   	push   %ebp
  80006e:	89 e5                	mov    %esp,%ebp
  800070:	57                   	push   %edi
  800071:	56                   	push   %esi
  800072:	53                   	push   %ebx
  800073:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  800079:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80007c:	c7 04 24 c0 2a 80 00 	movl   $0x802ac0,(%esp)
  800083:	e8 ef 04 00 00       	call   800577 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800088:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  80008f:	00 
  800090:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  800097:	e8 a4 ff ff ff       	call   800040 <sum>
  80009c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  8000a1:	74 1a                	je     8000bd <umain+0x50>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a3:	c7 44 24 08 9e 98 0f 	movl   $0xf989e,0x8(%esp)
  8000aa:	00 
  8000ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000af:	c7 04 24 88 2b 80 00 	movl   $0x802b88,(%esp)
  8000b6:	e8 bc 04 00 00       	call   800577 <cprintf>
  8000bb:	eb 0c                	jmp    8000c9 <umain+0x5c>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000bd:	c7 04 24 cf 2a 80 00 	movl   $0x802acf,(%esp)
  8000c4:	e8 ae 04 00 00       	call   800577 <cprintf>
	if ((x = sum(bss, sizeof bss)) != 0)
  8000c9:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  8000d0:	00 
  8000d1:	c7 04 24 20 60 80 00 	movl   $0x806020,(%esp)
  8000d8:	e8 63 ff ff ff       	call   800040 <sum>
  8000dd:	85 c0                	test   %eax,%eax
  8000df:	74 12                	je     8000f3 <umain+0x86>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e5:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  8000ec:	e8 86 04 00 00       	call   800577 <cprintf>
  8000f1:	eb 0c                	jmp    8000ff <umain+0x92>
	else
		cprintf("init: bss seems okay\n");
  8000f3:	c7 04 24 e6 2a 80 00 	movl   $0x802ae6,(%esp)
  8000fa:	e8 78 04 00 00       	call   800577 <cprintf>

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000ff:	c7 44 24 04 fc 2a 80 	movl   $0x802afc,0x4(%esp)
  800106:	00 
  800107:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80010d:	89 04 24             	mov    %eax,(%esp)
  800110:	e8 a6 0a 00 00       	call   800bbb <strcat>
	for (i = 0; i < argc; i++) {
  800115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800119:	7e 42                	jle    80015d <umain+0xf0>
  80011b:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  800120:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800126:	c7 44 24 04 08 2b 80 	movl   $0x802b08,0x4(%esp)
  80012d:	00 
  80012e:	89 34 24             	mov    %esi,(%esp)
  800131:	e8 85 0a 00 00       	call   800bbb <strcat>
		strcat(args, argv[i]);
  800136:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800139:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013d:	89 34 24             	mov    %esi,(%esp)
  800140:	e8 76 0a 00 00       	call   800bbb <strcat>
		strcat(args, "'");
  800145:	c7 44 24 04 09 2b 80 	movl   $0x802b09,0x4(%esp)
  80014c:	00 
  80014d:	89 34 24             	mov    %esi,(%esp)
  800150:	e8 66 0a 00 00       	call   800bbb <strcat>
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  800155:	83 c3 01             	add    $0x1,%ebx
  800158:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  80015b:	75 c9                	jne    800126 <umain+0xb9>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  80015d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800163:	89 44 24 04          	mov    %eax,0x4(%esp)
  800167:	c7 04 24 0b 2b 80 00 	movl   $0x802b0b,(%esp)
  80016e:	e8 04 04 00 00       	call   800577 <cprintf>

	cprintf("init: running sh\n");
  800173:	c7 04 24 0f 2b 80 00 	movl   $0x802b0f,(%esp)
  80017a:	e8 f8 03 00 00       	call   800577 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80017f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800186:	e8 d2 13 00 00       	call   80155d <close>
	if ((r = opencons()) < 0)
  80018b:	e8 2d 02 00 00       	call   8003bd <opencons>
  800190:	85 c0                	test   %eax,%eax
  800192:	79 20                	jns    8001b4 <umain+0x147>
		panic("opencons: %e", r);
  800194:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800198:	c7 44 24 08 21 2b 80 	movl   $0x802b21,0x8(%esp)
  80019f:	00 
  8001a0:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8001a7:	00 
  8001a8:	c7 04 24 2e 2b 80 00 	movl   $0x802b2e,(%esp)
  8001af:	e8 c8 02 00 00       	call   80047c <_panic>
	if (r != 0)
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	74 20                	je     8001d8 <umain+0x16b>
		panic("first opencons used fd %d", r);
  8001b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001bc:	c7 44 24 08 3a 2b 80 	movl   $0x802b3a,0x8(%esp)
  8001c3:	00 
  8001c4:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8001cb:	00 
  8001cc:	c7 04 24 2e 2b 80 00 	movl   $0x802b2e,(%esp)
  8001d3:	e8 a4 02 00 00       	call   80047c <_panic>
	if ((r = dup(0, 1)) < 0)
  8001d8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001df:	00 
  8001e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e7:	e8 c4 13 00 00       	call   8015b0 <dup>
  8001ec:	85 c0                	test   %eax,%eax
  8001ee:	79 20                	jns    800210 <umain+0x1a3>
		panic("dup: %e", r);
  8001f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f4:	c7 44 24 08 54 2b 80 	movl   $0x802b54,0x8(%esp)
  8001fb:	00 
  8001fc:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
  800203:	00 
  800204:	c7 04 24 2e 2b 80 00 	movl   $0x802b2e,(%esp)
  80020b:	e8 6c 02 00 00       	call   80047c <_panic>
	while (1) {
		cprintf("init: starting sh\n");
  800210:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800217:	e8 5b 03 00 00       	call   800577 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  80021c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800223:	00 
  800224:	c7 44 24 04 70 2b 80 	movl   $0x802b70,0x4(%esp)
  80022b:	00 
  80022c:	c7 04 24 6f 2b 80 00 	movl   $0x802b6f,(%esp)
  800233:	e8 95 1f 00 00       	call   8021cd <spawnl>
		if (r < 0) {
  800238:	85 c0                	test   %eax,%eax
  80023a:	79 12                	jns    80024e <umain+0x1e1>
			cprintf("init: spawn sh: %e\n", r);
  80023c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800240:	c7 04 24 73 2b 80 00 	movl   $0x802b73,(%esp)
  800247:	e8 2b 03 00 00       	call   800577 <cprintf>
			continue;
  80024c:	eb c2                	jmp    800210 <umain+0x1a3>
		}
		wait(r);
  80024e:	89 04 24             	mov    %eax,(%esp)
  800251:	e8 de 23 00 00       	call   802634 <wait>
  800256:	eb b8                	jmp    800210 <umain+0x1a3>
	...

00800260 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800263:	b8 00 00 00 00       	mov    $0x0,%eax
  800268:	5d                   	pop    %ebp
  800269:	c3                   	ret    

0080026a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800270:	c7 44 24 04 f3 2b 80 	movl   $0x802bf3,0x4(%esp)
  800277:	00 
  800278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027b:	89 04 24             	mov    %eax,(%esp)
  80027e:	e8 18 09 00 00       	call   800b9b <strcpy>
	return 0;
}
  800283:	b8 00 00 00 00       	mov    $0x0,%eax
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	57                   	push   %edi
  80028e:	56                   	push   %esi
  80028f:	53                   	push   %ebx
  800290:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800296:	be 00 00 00 00       	mov    $0x0,%esi
  80029b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80029f:	74 43                	je     8002e4 <devcons_write+0x5a>
  8002a1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8002a6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8002ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002af:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8002b1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8002b4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8002b9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8002bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002c0:	03 45 0c             	add    0xc(%ebp),%eax
  8002c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c7:	89 3c 24             	mov    %edi,(%esp)
  8002ca:	e8 bd 0a 00 00       	call   800d8c <memmove>
		sys_cputs(buf, m);
  8002cf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002d3:	89 3c 24             	mov    %edi,(%esp)
  8002d6:	e8 a5 0c 00 00       	call   800f80 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002db:	01 de                	add    %ebx,%esi
  8002dd:	89 f0                	mov    %esi,%eax
  8002df:	3b 75 10             	cmp    0x10(%ebp),%esi
  8002e2:	72 c8                	jb     8002ac <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8002e4:	89 f0                	mov    %esi,%eax
  8002e6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8002ec:	5b                   	pop    %ebx
  8002ed:	5e                   	pop    %esi
  8002ee:	5f                   	pop    %edi
  8002ef:	5d                   	pop    %ebp
  8002f0:	c3                   	ret    

008002f1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8002fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800300:	75 07                	jne    800309 <devcons_read+0x18>
  800302:	eb 31                	jmp    800335 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800304:	e8 63 0d 00 00       	call   80106c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800310:	e8 9a 0c 00 00       	call   800faf <sys_cgetc>
  800315:	85 c0                	test   %eax,%eax
  800317:	74 eb                	je     800304 <devcons_read+0x13>
  800319:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80031b:	85 c0                	test   %eax,%eax
  80031d:	78 16                	js     800335 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80031f:	83 f8 04             	cmp    $0x4,%eax
  800322:	74 0c                	je     800330 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  800324:	8b 45 0c             	mov    0xc(%ebp),%eax
  800327:	88 10                	mov    %dl,(%eax)
	return 1;
  800329:	b8 01 00 00 00       	mov    $0x1,%eax
  80032e:	eb 05                	jmp    800335 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800330:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800335:	c9                   	leave  
  800336:	c3                   	ret    

00800337 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80033d:	8b 45 08             	mov    0x8(%ebp),%eax
  800340:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800343:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80034a:	00 
  80034b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80034e:	89 04 24             	mov    %eax,(%esp)
  800351:	e8 2a 0c 00 00       	call   800f80 <sys_cputs>
}
  800356:	c9                   	leave  
  800357:	c3                   	ret    

00800358 <getchar>:

int
getchar(void)
{
  800358:	55                   	push   %ebp
  800359:	89 e5                	mov    %esp,%ebp
  80035b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80035e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800365:	00 
  800366:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800369:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800374:	e8 55 13 00 00       	call   8016ce <read>
	if (r < 0)
  800379:	85 c0                	test   %eax,%eax
  80037b:	78 0f                	js     80038c <getchar+0x34>
		return r;
	if (r < 1)
  80037d:	85 c0                	test   %eax,%eax
  80037f:	7e 06                	jle    800387 <getchar+0x2f>
		return -E_EOF;
	return c;
  800381:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800385:	eb 05                	jmp    80038c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800387:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    

0080038e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800394:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800397:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	89 04 24             	mov    %eax,(%esp)
  8003a1:	e8 68 10 00 00       	call   80140e <fd_lookup>
  8003a6:	85 c0                	test   %eax,%eax
  8003a8:	78 11                	js     8003bb <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8003aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ad:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003b3:	39 10                	cmp    %edx,(%eax)
  8003b5:	0f 94 c0             	sete   %al
  8003b8:	0f b6 c0             	movzbl %al,%eax
}
  8003bb:	c9                   	leave  
  8003bc:	c3                   	ret    

008003bd <opencons>:

int
opencons(void)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8003c6:	89 04 24             	mov    %eax,(%esp)
  8003c9:	e8 cd 0f 00 00       	call   80139b <fd_alloc>
  8003ce:	85 c0                	test   %eax,%eax
  8003d0:	78 3c                	js     80040e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8003d9:	00 
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003e8:	e8 af 0c 00 00       	call   80109c <sys_page_alloc>
  8003ed:	85 c0                	test   %eax,%eax
  8003ef:	78 1d                	js     80040e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8003f1:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003fa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800406:	89 04 24             	mov    %eax,(%esp)
  800409:	e8 62 0f 00 00       	call   801370 <fd2num>
}
  80040e:	c9                   	leave  
  80040f:	c3                   	ret    

00800410 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	83 ec 18             	sub    $0x18,%esp
  800416:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800419:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80041c:	8b 75 08             	mov    0x8(%ebp),%esi
  80041f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800422:	e8 15 0c 00 00       	call   80103c <sys_getenvid>
  800427:	25 ff 03 00 00       	and    $0x3ff,%eax
  80042c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80042f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800434:	a3 90 77 80 00       	mov    %eax,0x807790
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800439:	85 f6                	test   %esi,%esi
  80043b:	7e 07                	jle    800444 <libmain+0x34>
		binaryname = argv[0];
  80043d:	8b 03                	mov    (%ebx),%eax
  80043f:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  800444:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800448:	89 34 24             	mov    %esi,(%esp)
  80044b:	e8 1d fc ff ff       	call   80006d <umain>

	// exit gracefully
	exit();
  800450:	e8 0b 00 00 00       	call   800460 <exit>
}
  800455:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800458:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80045b:	89 ec                	mov    %ebp,%esp
  80045d:	5d                   	pop    %ebp
  80045e:	c3                   	ret    
	...

00800460 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800466:	e8 23 11 00 00       	call   80158e <close_all>
	sys_env_destroy(0);
  80046b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800472:	e8 68 0b 00 00       	call   800fdf <sys_env_destroy>
}
  800477:	c9                   	leave  
  800478:	c3                   	ret    
  800479:	00 00                	add    %al,(%eax)
	...

0080047c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80047c:	55                   	push   %ebp
  80047d:	89 e5                	mov    %esp,%ebp
  80047f:	56                   	push   %esi
  800480:	53                   	push   %ebx
  800481:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800484:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800487:	8b 1d 8c 57 80 00    	mov    0x80578c,%ebx
  80048d:	e8 aa 0b 00 00       	call   80103c <sys_getenvid>
  800492:	8b 55 0c             	mov    0xc(%ebp),%edx
  800495:	89 54 24 10          	mov    %edx,0x10(%esp)
  800499:	8b 55 08             	mov    0x8(%ebp),%edx
  80049c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004a0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8004a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a8:	c7 04 24 0c 2c 80 00 	movl   $0x802c0c,(%esp)
  8004af:	e8 c3 00 00 00       	call   800577 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004b4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bb:	89 04 24             	mov    %eax,(%esp)
  8004be:	e8 53 00 00 00       	call   800516 <vcprintf>
	cprintf("\n");
  8004c3:	c7 04 24 e0 30 80 00 	movl   $0x8030e0,(%esp)
  8004ca:	e8 a8 00 00 00       	call   800577 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004cf:	cc                   	int3   
  8004d0:	eb fd                	jmp    8004cf <_panic+0x53>
	...

008004d4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	53                   	push   %ebx
  8004d8:	83 ec 14             	sub    $0x14,%esp
  8004db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8004de:	8b 03                	mov    (%ebx),%eax
  8004e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e3:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8004e7:	83 c0 01             	add    $0x1,%eax
  8004ea:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8004ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f1:	75 19                	jne    80050c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8004f3:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8004fa:	00 
  8004fb:	8d 43 08             	lea    0x8(%ebx),%eax
  8004fe:	89 04 24             	mov    %eax,(%esp)
  800501:	e8 7a 0a 00 00       	call   800f80 <sys_cputs>
		b->idx = 0;
  800506:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80050c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800510:	83 c4 14             	add    $0x14,%esp
  800513:	5b                   	pop    %ebx
  800514:	5d                   	pop    %ebp
  800515:	c3                   	ret    

00800516 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800516:	55                   	push   %ebp
  800517:	89 e5                	mov    %esp,%ebp
  800519:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80051f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800526:	00 00 00 
	b.cnt = 0;
  800529:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800530:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800533:	8b 45 0c             	mov    0xc(%ebp),%eax
  800536:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80053a:	8b 45 08             	mov    0x8(%ebp),%eax
  80053d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800541:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800547:	89 44 24 04          	mov    %eax,0x4(%esp)
  80054b:	c7 04 24 d4 04 80 00 	movl   $0x8004d4,(%esp)
  800552:	e8 a3 01 00 00       	call   8006fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800557:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80055d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800561:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800567:	89 04 24             	mov    %eax,(%esp)
  80056a:	e8 11 0a 00 00       	call   800f80 <sys_cputs>

	return b.cnt;
}
  80056f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80057d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800580:	89 44 24 04          	mov    %eax,0x4(%esp)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	89 04 24             	mov    %eax,(%esp)
  80058a:	e8 87 ff ff ff       	call   800516 <vcprintf>
	va_end(ap);

	return cnt;
}
  80058f:	c9                   	leave  
  800590:	c3                   	ret    
	...

008005a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	57                   	push   %edi
  8005a4:	56                   	push   %esi
  8005a5:	53                   	push   %ebx
  8005a6:	83 ec 3c             	sub    $0x3c,%esp
  8005a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ac:	89 d7                	mov    %edx,%edi
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8005bd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005c8:	72 11                	jb     8005db <printnum+0x3b>
  8005ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005cd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8005d0:	76 09                	jbe    8005db <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d2:	83 eb 01             	sub    $0x1,%ebx
  8005d5:	85 db                	test   %ebx,%ebx
  8005d7:	7f 51                	jg     80062a <printnum+0x8a>
  8005d9:	eb 5e                	jmp    800639 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005db:	89 74 24 10          	mov    %esi,0x10(%esp)
  8005df:	83 eb 01             	sub    $0x1,%ebx
  8005e2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005ed:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8005f1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8005f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005fc:	00 
  8005fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800600:	89 04 24             	mov    %eax,(%esp)
  800603:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800606:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060a:	e8 f1 21 00 00       	call   802800 <__udivdi3>
  80060f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800613:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800617:	89 04 24             	mov    %eax,(%esp)
  80061a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80061e:	89 fa                	mov    %edi,%edx
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	e8 78 ff ff ff       	call   8005a0 <printnum>
  800628:	eb 0f                	jmp    800639 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80062e:	89 34 24             	mov    %esi,(%esp)
  800631:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800634:	83 eb 01             	sub    $0x1,%ebx
  800637:	75 f1                	jne    80062a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800639:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800641:	8b 45 10             	mov    0x10(%ebp),%eax
  800644:	89 44 24 08          	mov    %eax,0x8(%esp)
  800648:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80064f:	00 
  800650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800653:	89 04 24             	mov    %eax,(%esp)
  800656:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800659:	89 44 24 04          	mov    %eax,0x4(%esp)
  80065d:	e8 ce 22 00 00       	call   802930 <__umoddi3>
  800662:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800666:	0f be 80 2f 2c 80 00 	movsbl 0x802c2f(%eax),%eax
  80066d:	89 04 24             	mov    %eax,(%esp)
  800670:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800673:	83 c4 3c             	add    $0x3c,%esp
  800676:	5b                   	pop    %ebx
  800677:	5e                   	pop    %esi
  800678:	5f                   	pop    %edi
  800679:	5d                   	pop    %ebp
  80067a:	c3                   	ret    

0080067b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067e:	83 fa 01             	cmp    $0x1,%edx
  800681:	7e 0e                	jle    800691 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800683:	8b 10                	mov    (%eax),%edx
  800685:	8d 4a 08             	lea    0x8(%edx),%ecx
  800688:	89 08                	mov    %ecx,(%eax)
  80068a:	8b 02                	mov    (%edx),%eax
  80068c:	8b 52 04             	mov    0x4(%edx),%edx
  80068f:	eb 22                	jmp    8006b3 <getuint+0x38>
	else if (lflag)
  800691:	85 d2                	test   %edx,%edx
  800693:	74 10                	je     8006a5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800695:	8b 10                	mov    (%eax),%edx
  800697:	8d 4a 04             	lea    0x4(%edx),%ecx
  80069a:	89 08                	mov    %ecx,(%eax)
  80069c:	8b 02                	mov    (%edx),%eax
  80069e:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a3:	eb 0e                	jmp    8006b3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8006a5:	8b 10                	mov    (%eax),%edx
  8006a7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006aa:	89 08                	mov    %ecx,(%eax)
  8006ac:	8b 02                	mov    (%edx),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006b3:	5d                   	pop    %ebp
  8006b4:	c3                   	ret    

008006b5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006b5:	55                   	push   %ebp
  8006b6:	89 e5                	mov    %esp,%ebp
  8006b8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006bb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006bf:	8b 10                	mov    (%eax),%edx
  8006c1:	3b 50 04             	cmp    0x4(%eax),%edx
  8006c4:	73 0a                	jae    8006d0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8006c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006c9:	88 0a                	mov    %cl,(%edx)
  8006cb:	83 c2 01             	add    $0x1,%edx
  8006ce:	89 10                	mov    %edx,(%eax)
}
  8006d0:	5d                   	pop    %ebp
  8006d1:	c3                   	ret    

008006d2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8006d8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006df:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 04 24             	mov    %eax,(%esp)
  8006f3:	e8 02 00 00 00       	call   8006fa <vprintfmt>
	va_end(ap);
}
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	57                   	push   %edi
  8006fe:	56                   	push   %esi
  8006ff:	53                   	push   %ebx
  800700:	83 ec 4c             	sub    $0x4c,%esp
  800703:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800706:	8b 75 10             	mov    0x10(%ebp),%esi
  800709:	eb 12                	jmp    80071d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80070b:	85 c0                	test   %eax,%eax
  80070d:	0f 84 a9 03 00 00    	je     800abc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800713:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800717:	89 04 24             	mov    %eax,(%esp)
  80071a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071d:	0f b6 06             	movzbl (%esi),%eax
  800720:	83 c6 01             	add    $0x1,%esi
  800723:	83 f8 25             	cmp    $0x25,%eax
  800726:	75 e3                	jne    80070b <vprintfmt+0x11>
  800728:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80072c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800733:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800738:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80073f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800744:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800747:	eb 2b                	jmp    800774 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800749:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80074c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800750:	eb 22                	jmp    800774 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800752:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800755:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800759:	eb 19                	jmp    800774 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80075e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800765:	eb 0d                	jmp    800774 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80076a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80076d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800774:	0f b6 06             	movzbl (%esi),%eax
  800777:	0f b6 d0             	movzbl %al,%edx
  80077a:	8d 7e 01             	lea    0x1(%esi),%edi
  80077d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800780:	83 e8 23             	sub    $0x23,%eax
  800783:	3c 55                	cmp    $0x55,%al
  800785:	0f 87 0b 03 00 00    	ja     800a96 <vprintfmt+0x39c>
  80078b:	0f b6 c0             	movzbl %al,%eax
  80078e:	ff 24 85 80 2d 80 00 	jmp    *0x802d80(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800795:	83 ea 30             	sub    $0x30,%edx
  800798:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80079b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80079f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007a2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8007a5:	83 fa 09             	cmp    $0x9,%edx
  8007a8:	77 4a                	ja     8007f4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007aa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ad:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8007b0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8007b3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8007b7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8007ba:	8d 50 d0             	lea    -0x30(%eax),%edx
  8007bd:	83 fa 09             	cmp    $0x9,%edx
  8007c0:	76 eb                	jbe    8007ad <vprintfmt+0xb3>
  8007c2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8007c5:	eb 2d                	jmp    8007f4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8d 50 04             	lea    0x4(%eax),%edx
  8007cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007d5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8007d8:	eb 1a                	jmp    8007f4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007da:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8007dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e1:	79 91                	jns    800774 <vprintfmt+0x7a>
  8007e3:	e9 73 ff ff ff       	jmp    80075b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8007eb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f2:	eb 80                	jmp    800774 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8007f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f8:	0f 89 76 ff ff ff    	jns    800774 <vprintfmt+0x7a>
  8007fe:	e9 64 ff ff ff       	jmp    800767 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800803:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800806:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800809:	e9 66 ff ff ff       	jmp    800774 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	8d 50 04             	lea    0x4(%eax),%edx
  800814:	89 55 14             	mov    %edx,0x14(%ebp)
  800817:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	89 04 24             	mov    %eax,(%esp)
  800820:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800823:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800826:	e9 f2 fe ff ff       	jmp    80071d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8d 50 04             	lea    0x4(%eax),%edx
  800831:	89 55 14             	mov    %edx,0x14(%ebp)
  800834:	8b 00                	mov    (%eax),%eax
  800836:	89 c2                	mov    %eax,%edx
  800838:	c1 fa 1f             	sar    $0x1f,%edx
  80083b:	31 d0                	xor    %edx,%eax
  80083d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80083f:	83 f8 0f             	cmp    $0xf,%eax
  800842:	7f 0b                	jg     80084f <vprintfmt+0x155>
  800844:	8b 14 85 e0 2e 80 00 	mov    0x802ee0(,%eax,4),%edx
  80084b:	85 d2                	test   %edx,%edx
  80084d:	75 23                	jne    800872 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80084f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800853:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  80085a:	00 
  80085b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80085f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800862:	89 3c 24             	mov    %edi,(%esp)
  800865:	e8 68 fe ff ff       	call   8006d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80086a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80086d:	e9 ab fe ff ff       	jmp    80071d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800872:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800876:	c7 44 24 08 11 30 80 	movl   $0x803011,0x8(%esp)
  80087d:	00 
  80087e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800882:	8b 7d 08             	mov    0x8(%ebp),%edi
  800885:	89 3c 24             	mov    %edi,(%esp)
  800888:	e8 45 fe ff ff       	call   8006d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80088d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800890:	e9 88 fe ff ff       	jmp    80071d <vprintfmt+0x23>
  800895:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80089b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089e:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a1:	8d 50 04             	lea    0x4(%eax),%edx
  8008a4:	89 55 14             	mov    %edx,0x14(%ebp)
  8008a7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8008a9:	85 f6                	test   %esi,%esi
  8008ab:	ba 40 2c 80 00       	mov    $0x802c40,%edx
  8008b0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8008b3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008b7:	7e 06                	jle    8008bf <vprintfmt+0x1c5>
  8008b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8008bd:	75 10                	jne    8008cf <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008bf:	0f be 06             	movsbl (%esi),%eax
  8008c2:	83 c6 01             	add    $0x1,%esi
  8008c5:	85 c0                	test   %eax,%eax
  8008c7:	0f 85 86 00 00 00    	jne    800953 <vprintfmt+0x259>
  8008cd:	eb 76                	jmp    800945 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008cf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008d3:	89 34 24             	mov    %esi,(%esp)
  8008d6:	e8 90 02 00 00       	call   800b6b <strnlen>
  8008db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008de:	29 c2                	sub    %eax,%edx
  8008e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008e3:	85 d2                	test   %edx,%edx
  8008e5:	7e d8                	jle    8008bf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8008e7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8008eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8008ee:	89 d6                	mov    %edx,%esi
  8008f0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8008f3:	89 c7                	mov    %eax,%edi
  8008f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008f9:	89 3c 24             	mov    %edi,(%esp)
  8008fc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ff:	83 ee 01             	sub    $0x1,%esi
  800902:	75 f1                	jne    8008f5 <vprintfmt+0x1fb>
  800904:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800907:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80090a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80090d:	eb b0                	jmp    8008bf <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80090f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800913:	74 18                	je     80092d <vprintfmt+0x233>
  800915:	8d 50 e0             	lea    -0x20(%eax),%edx
  800918:	83 fa 5e             	cmp    $0x5e,%edx
  80091b:	76 10                	jbe    80092d <vprintfmt+0x233>
					putch('?', putdat);
  80091d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800921:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800928:	ff 55 08             	call   *0x8(%ebp)
  80092b:	eb 0a                	jmp    800937 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80092d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800931:	89 04 24             	mov    %eax,(%esp)
  800934:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800937:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80093b:	0f be 06             	movsbl (%esi),%eax
  80093e:	83 c6 01             	add    $0x1,%esi
  800941:	85 c0                	test   %eax,%eax
  800943:	75 0e                	jne    800953 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800945:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800948:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094c:	7f 16                	jg     800964 <vprintfmt+0x26a>
  80094e:	e9 ca fd ff ff       	jmp    80071d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800953:	85 ff                	test   %edi,%edi
  800955:	78 b8                	js     80090f <vprintfmt+0x215>
  800957:	83 ef 01             	sub    $0x1,%edi
  80095a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800960:	79 ad                	jns    80090f <vprintfmt+0x215>
  800962:	eb e1                	jmp    800945 <vprintfmt+0x24b>
  800964:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800967:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80096a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80096e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800975:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800977:	83 ee 01             	sub    $0x1,%esi
  80097a:	75 ee                	jne    80096a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80097f:	e9 99 fd ff ff       	jmp    80071d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800984:	83 f9 01             	cmp    $0x1,%ecx
  800987:	7e 10                	jle    800999 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800989:	8b 45 14             	mov    0x14(%ebp),%eax
  80098c:	8d 50 08             	lea    0x8(%eax),%edx
  80098f:	89 55 14             	mov    %edx,0x14(%ebp)
  800992:	8b 30                	mov    (%eax),%esi
  800994:	8b 78 04             	mov    0x4(%eax),%edi
  800997:	eb 26                	jmp    8009bf <vprintfmt+0x2c5>
	else if (lflag)
  800999:	85 c9                	test   %ecx,%ecx
  80099b:	74 12                	je     8009af <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80099d:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a0:	8d 50 04             	lea    0x4(%eax),%edx
  8009a3:	89 55 14             	mov    %edx,0x14(%ebp)
  8009a6:	8b 30                	mov    (%eax),%esi
  8009a8:	89 f7                	mov    %esi,%edi
  8009aa:	c1 ff 1f             	sar    $0x1f,%edi
  8009ad:	eb 10                	jmp    8009bf <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8d 50 04             	lea    0x4(%eax),%edx
  8009b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b8:	8b 30                	mov    (%eax),%esi
  8009ba:	89 f7                	mov    %esi,%edi
  8009bc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8009bf:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8009c4:	85 ff                	test   %edi,%edi
  8009c6:	0f 89 8c 00 00 00    	jns    800a58 <vprintfmt+0x35e>
				putch('-', putdat);
  8009cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009d0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009d7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8009da:	f7 de                	neg    %esi
  8009dc:	83 d7 00             	adc    $0x0,%edi
  8009df:	f7 df                	neg    %edi
			}
			base = 10;
  8009e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009e6:	eb 70                	jmp    800a58 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e8:	89 ca                	mov    %ecx,%edx
  8009ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ed:	e8 89 fc ff ff       	call   80067b <getuint>
  8009f2:	89 c6                	mov    %eax,%esi
  8009f4:	89 d7                	mov    %edx,%edi
			base = 10;
  8009f6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8009fb:	eb 5b                	jmp    800a58 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8009fd:	89 ca                	mov    %ecx,%edx
  8009ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800a02:	e8 74 fc ff ff       	call   80067b <getuint>
  800a07:	89 c6                	mov    %eax,%esi
  800a09:	89 d7                	mov    %edx,%edi
			base = 8;
  800a0b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800a10:	eb 46                	jmp    800a58 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800a12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a16:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a1d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800a20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a24:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a2b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	8d 50 04             	lea    0x4(%eax),%edx
  800a34:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a37:	8b 30                	mov    (%eax),%esi
  800a39:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800a3e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800a43:	eb 13                	jmp    800a58 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a45:	89 ca                	mov    %ecx,%edx
  800a47:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4a:	e8 2c fc ff ff       	call   80067b <getuint>
  800a4f:	89 c6                	mov    %eax,%esi
  800a51:	89 d7                	mov    %edx,%edi
			base = 16;
  800a53:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a58:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  800a5c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a63:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a67:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a6b:	89 34 24             	mov    %esi,(%esp)
  800a6e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a72:	89 da                	mov    %ebx,%edx
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	e8 24 fb ff ff       	call   8005a0 <printnum>
			break;
  800a7c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800a7f:	e9 99 fc ff ff       	jmp    80071d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a84:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a88:	89 14 24             	mov    %edx,(%esp)
  800a8b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a8e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800a91:	e9 87 fc ff ff       	jmp    80071d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a9a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800aa1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800aa8:	0f 84 6f fc ff ff    	je     80071d <vprintfmt+0x23>
  800aae:	83 ee 01             	sub    $0x1,%esi
  800ab1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800ab5:	75 f7                	jne    800aae <vprintfmt+0x3b4>
  800ab7:	e9 61 fc ff ff       	jmp    80071d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  800abc:	83 c4 4c             	add    $0x4c,%esp
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5f                   	pop    %edi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 28             	sub    $0x28,%esp
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ad0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ad3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ad7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ada:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ae1:	85 c0                	test   %eax,%eax
  800ae3:	74 30                	je     800b15 <vsnprintf+0x51>
  800ae5:	85 d2                	test   %edx,%edx
  800ae7:	7e 2c                	jle    800b15 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800af0:	8b 45 10             	mov    0x10(%ebp),%eax
  800af3:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800afa:	89 44 24 04          	mov    %eax,0x4(%esp)
  800afe:	c7 04 24 b5 06 80 00 	movl   $0x8006b5,(%esp)
  800b05:	e8 f0 fb ff ff       	call   8006fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b13:	eb 05                	jmp    800b1a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800b15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b22:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b25:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b29:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 04 24             	mov    %eax,(%esp)
  800b3d:	e8 82 ff ff ff       	call   800ac4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b42:	c9                   	leave  
  800b43:	c3                   	ret    
	...

00800b50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b56:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b5e:	74 09                	je     800b69 <strlen+0x19>
		n++;
  800b60:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b67:	75 f7                	jne    800b60 <strlen+0x10>
		n++;
	return n;
}
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	53                   	push   %ebx
  800b6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b75:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7a:	85 c9                	test   %ecx,%ecx
  800b7c:	74 1a                	je     800b98 <strnlen+0x2d>
  800b7e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800b81:	74 15                	je     800b98 <strnlen+0x2d>
  800b83:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800b88:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8a:	39 ca                	cmp    %ecx,%edx
  800b8c:	74 0a                	je     800b98 <strnlen+0x2d>
  800b8e:	83 c2 01             	add    $0x1,%edx
  800b91:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800b96:	75 f0                	jne    800b88 <strnlen+0x1d>
		n++;
	return n;
}
  800b98:	5b                   	pop    %ebx
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	53                   	push   %ebx
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  800baa:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bae:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bb1:	83 c2 01             	add    $0x1,%edx
  800bb4:	84 c9                	test   %cl,%cl
  800bb6:	75 f2                	jne    800baa <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bb8:	5b                   	pop    %ebx
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	53                   	push   %ebx
  800bbf:	83 ec 08             	sub    $0x8,%esp
  800bc2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bc5:	89 1c 24             	mov    %ebx,(%esp)
  800bc8:	e8 83 ff ff ff       	call   800b50 <strlen>
	strcpy(dst + len, src);
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd0:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bd4:	01 d8                	add    %ebx,%eax
  800bd6:	89 04 24             	mov    %eax,(%esp)
  800bd9:	e8 bd ff ff ff       	call   800b9b <strcpy>
	return dst;
}
  800bde:	89 d8                	mov    %ebx,%eax
  800be0:	83 c4 08             	add    $0x8,%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	56                   	push   %esi
  800bea:	53                   	push   %ebx
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf4:	85 f6                	test   %esi,%esi
  800bf6:	74 18                	je     800c10 <strncpy+0x2a>
  800bf8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800bfd:	0f b6 1a             	movzbl (%edx),%ebx
  800c00:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c03:	80 3a 01             	cmpb   $0x1,(%edx)
  800c06:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c09:	83 c1 01             	add    $0x1,%ecx
  800c0c:	39 f1                	cmp    %esi,%ecx
  800c0e:	75 ed                	jne    800bfd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	57                   	push   %edi
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
  800c1a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c20:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c23:	89 f8                	mov    %edi,%eax
  800c25:	85 f6                	test   %esi,%esi
  800c27:	74 2b                	je     800c54 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800c29:	83 fe 01             	cmp    $0x1,%esi
  800c2c:	74 23                	je     800c51 <strlcpy+0x3d>
  800c2e:	0f b6 0b             	movzbl (%ebx),%ecx
  800c31:	84 c9                	test   %cl,%cl
  800c33:	74 1c                	je     800c51 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800c35:	83 ee 02             	sub    $0x2,%esi
  800c38:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c3d:	88 08                	mov    %cl,(%eax)
  800c3f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c42:	39 f2                	cmp    %esi,%edx
  800c44:	74 0b                	je     800c51 <strlcpy+0x3d>
  800c46:	83 c2 01             	add    $0x1,%edx
  800c49:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c4d:	84 c9                	test   %cl,%cl
  800c4f:	75 ec                	jne    800c3d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800c51:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c54:	29 f8                	sub    %edi,%eax
}
  800c56:	5b                   	pop    %ebx
  800c57:	5e                   	pop    %esi
  800c58:	5f                   	pop    %edi
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c64:	0f b6 01             	movzbl (%ecx),%eax
  800c67:	84 c0                	test   %al,%al
  800c69:	74 16                	je     800c81 <strcmp+0x26>
  800c6b:	3a 02                	cmp    (%edx),%al
  800c6d:	75 12                	jne    800c81 <strcmp+0x26>
		p++, q++;
  800c6f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c72:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800c76:	84 c0                	test   %al,%al
  800c78:	74 07                	je     800c81 <strcmp+0x26>
  800c7a:	83 c1 01             	add    $0x1,%ecx
  800c7d:	3a 02                	cmp    (%edx),%al
  800c7f:	74 ee                	je     800c6f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c81:	0f b6 c0             	movzbl %al,%eax
  800c84:	0f b6 12             	movzbl (%edx),%edx
  800c87:	29 d0                	sub    %edx,%eax
}
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	53                   	push   %ebx
  800c8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c95:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c98:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c9d:	85 d2                	test   %edx,%edx
  800c9f:	74 28                	je     800cc9 <strncmp+0x3e>
  800ca1:	0f b6 01             	movzbl (%ecx),%eax
  800ca4:	84 c0                	test   %al,%al
  800ca6:	74 24                	je     800ccc <strncmp+0x41>
  800ca8:	3a 03                	cmp    (%ebx),%al
  800caa:	75 20                	jne    800ccc <strncmp+0x41>
  800cac:	83 ea 01             	sub    $0x1,%edx
  800caf:	74 13                	je     800cc4 <strncmp+0x39>
		n--, p++, q++;
  800cb1:	83 c1 01             	add    $0x1,%ecx
  800cb4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800cb7:	0f b6 01             	movzbl (%ecx),%eax
  800cba:	84 c0                	test   %al,%al
  800cbc:	74 0e                	je     800ccc <strncmp+0x41>
  800cbe:	3a 03                	cmp    (%ebx),%al
  800cc0:	74 ea                	je     800cac <strncmp+0x21>
  800cc2:	eb 08                	jmp    800ccc <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800cc4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800cc9:	5b                   	pop    %ebx
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ccc:	0f b6 01             	movzbl (%ecx),%eax
  800ccf:	0f b6 13             	movzbl (%ebx),%edx
  800cd2:	29 d0                	sub    %edx,%eax
  800cd4:	eb f3                	jmp    800cc9 <strncmp+0x3e>

00800cd6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ce0:	0f b6 10             	movzbl (%eax),%edx
  800ce3:	84 d2                	test   %dl,%dl
  800ce5:	74 1c                	je     800d03 <strchr+0x2d>
		if (*s == c)
  800ce7:	38 ca                	cmp    %cl,%dl
  800ce9:	75 09                	jne    800cf4 <strchr+0x1e>
  800ceb:	eb 1b                	jmp    800d08 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ced:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800cf0:	38 ca                	cmp    %cl,%dl
  800cf2:	74 14                	je     800d08 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cf4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800cf8:	84 d2                	test   %dl,%dl
  800cfa:	75 f1                	jne    800ced <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800d01:	eb 05                	jmp    800d08 <strchr+0x32>
  800d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d14:	0f b6 10             	movzbl (%eax),%edx
  800d17:	84 d2                	test   %dl,%dl
  800d19:	74 14                	je     800d2f <strfind+0x25>
		if (*s == c)
  800d1b:	38 ca                	cmp    %cl,%dl
  800d1d:	75 06                	jne    800d25 <strfind+0x1b>
  800d1f:	eb 0e                	jmp    800d2f <strfind+0x25>
  800d21:	38 ca                	cmp    %cl,%dl
  800d23:	74 0a                	je     800d2f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d25:	83 c0 01             	add    $0x1,%eax
  800d28:	0f b6 10             	movzbl (%eax),%edx
  800d2b:	84 d2                	test   %dl,%dl
  800d2d:	75 f2                	jne    800d21 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 0c             	sub    $0xc,%esp
  800d37:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d3a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d3d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800d40:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d46:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d49:	85 c9                	test   %ecx,%ecx
  800d4b:	74 30                	je     800d7d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d4d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d53:	75 25                	jne    800d7a <memset+0x49>
  800d55:	f6 c1 03             	test   $0x3,%cl
  800d58:	75 20                	jne    800d7a <memset+0x49>
		c &= 0xFF;
  800d5a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d5d:	89 d3                	mov    %edx,%ebx
  800d5f:	c1 e3 08             	shl    $0x8,%ebx
  800d62:	89 d6                	mov    %edx,%esi
  800d64:	c1 e6 18             	shl    $0x18,%esi
  800d67:	89 d0                	mov    %edx,%eax
  800d69:	c1 e0 10             	shl    $0x10,%eax
  800d6c:	09 f0                	or     %esi,%eax
  800d6e:	09 d0                	or     %edx,%eax
  800d70:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d72:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800d75:	fc                   	cld    
  800d76:	f3 ab                	rep stos %eax,%es:(%edi)
  800d78:	eb 03                	jmp    800d7d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d7a:	fc                   	cld    
  800d7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d7d:	89 f8                	mov    %edi,%eax
  800d7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d82:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d88:	89 ec                	mov    %ebp,%esp
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 08             	sub    $0x8,%esp
  800d92:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d95:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da1:	39 c6                	cmp    %eax,%esi
  800da3:	73 36                	jae    800ddb <memmove+0x4f>
  800da5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800da8:	39 d0                	cmp    %edx,%eax
  800daa:	73 2f                	jae    800ddb <memmove+0x4f>
		s += n;
		d += n;
  800dac:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800daf:	f6 c2 03             	test   $0x3,%dl
  800db2:	75 1b                	jne    800dcf <memmove+0x43>
  800db4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dba:	75 13                	jne    800dcf <memmove+0x43>
  800dbc:	f6 c1 03             	test   $0x3,%cl
  800dbf:	75 0e                	jne    800dcf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dc1:	83 ef 04             	sub    $0x4,%edi
  800dc4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800dc7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800dca:	fd                   	std    
  800dcb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dcd:	eb 09                	jmp    800dd8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dcf:	83 ef 01             	sub    $0x1,%edi
  800dd2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800dd5:	fd                   	std    
  800dd6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dd8:	fc                   	cld    
  800dd9:	eb 20                	jmp    800dfb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ddb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800de1:	75 13                	jne    800df6 <memmove+0x6a>
  800de3:	a8 03                	test   $0x3,%al
  800de5:	75 0f                	jne    800df6 <memmove+0x6a>
  800de7:	f6 c1 03             	test   $0x3,%cl
  800dea:	75 0a                	jne    800df6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dec:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800def:	89 c7                	mov    %eax,%edi
  800df1:	fc                   	cld    
  800df2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800df4:	eb 05                	jmp    800dfb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800df6:	89 c7                	mov    %eax,%edi
  800df8:	fc                   	cld    
  800df9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dfb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dfe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e01:	89 ec                	mov    %ebp,%esp
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	89 04 24             	mov    %eax,(%esp)
  800e1f:	e8 68 ff ff ff       	call   800d8c <memmove>
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	57                   	push   %edi
  800e2a:	56                   	push   %esi
  800e2b:	53                   	push   %ebx
  800e2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800e2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e32:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e35:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e3a:	85 ff                	test   %edi,%edi
  800e3c:	74 37                	je     800e75 <memcmp+0x4f>
		if (*s1 != *s2)
  800e3e:	0f b6 03             	movzbl (%ebx),%eax
  800e41:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e44:	83 ef 01             	sub    $0x1,%edi
  800e47:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800e4c:	38 c8                	cmp    %cl,%al
  800e4e:	74 1c                	je     800e6c <memcmp+0x46>
  800e50:	eb 10                	jmp    800e62 <memcmp+0x3c>
  800e52:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800e57:	83 c2 01             	add    $0x1,%edx
  800e5a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800e5e:	38 c8                	cmp    %cl,%al
  800e60:	74 0a                	je     800e6c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800e62:	0f b6 c0             	movzbl %al,%eax
  800e65:	0f b6 c9             	movzbl %cl,%ecx
  800e68:	29 c8                	sub    %ecx,%eax
  800e6a:	eb 09                	jmp    800e75 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e6c:	39 fa                	cmp    %edi,%edx
  800e6e:	75 e2                	jne    800e52 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800e80:	89 c2                	mov    %eax,%edx
  800e82:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e85:	39 d0                	cmp    %edx,%eax
  800e87:	73 19                	jae    800ea2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e89:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800e8d:	38 08                	cmp    %cl,(%eax)
  800e8f:	75 06                	jne    800e97 <memfind+0x1d>
  800e91:	eb 0f                	jmp    800ea2 <memfind+0x28>
  800e93:	38 08                	cmp    %cl,(%eax)
  800e95:	74 0b                	je     800ea2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e97:	83 c0 01             	add    $0x1,%eax
  800e9a:	39 d0                	cmp    %edx,%eax
  800e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ea0:	75 f1                	jne    800e93 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	57                   	push   %edi
  800ea8:	56                   	push   %esi
  800ea9:	53                   	push   %ebx
  800eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ead:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eb0:	0f b6 02             	movzbl (%edx),%eax
  800eb3:	3c 20                	cmp    $0x20,%al
  800eb5:	74 04                	je     800ebb <strtol+0x17>
  800eb7:	3c 09                	cmp    $0x9,%al
  800eb9:	75 0e                	jne    800ec9 <strtol+0x25>
		s++;
  800ebb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ebe:	0f b6 02             	movzbl (%edx),%eax
  800ec1:	3c 20                	cmp    $0x20,%al
  800ec3:	74 f6                	je     800ebb <strtol+0x17>
  800ec5:	3c 09                	cmp    $0x9,%al
  800ec7:	74 f2                	je     800ebb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ec9:	3c 2b                	cmp    $0x2b,%al
  800ecb:	75 0a                	jne    800ed7 <strtol+0x33>
		s++;
  800ecd:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ed0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed5:	eb 10                	jmp    800ee7 <strtol+0x43>
  800ed7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800edc:	3c 2d                	cmp    $0x2d,%al
  800ede:	75 07                	jne    800ee7 <strtol+0x43>
		s++, neg = 1;
  800ee0:	83 c2 01             	add    $0x1,%edx
  800ee3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee7:	85 db                	test   %ebx,%ebx
  800ee9:	0f 94 c0             	sete   %al
  800eec:	74 05                	je     800ef3 <strtol+0x4f>
  800eee:	83 fb 10             	cmp    $0x10,%ebx
  800ef1:	75 15                	jne    800f08 <strtol+0x64>
  800ef3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ef6:	75 10                	jne    800f08 <strtol+0x64>
  800ef8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800efc:	75 0a                	jne    800f08 <strtol+0x64>
		s += 2, base = 16;
  800efe:	83 c2 02             	add    $0x2,%edx
  800f01:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f06:	eb 13                	jmp    800f1b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800f08:	84 c0                	test   %al,%al
  800f0a:	74 0f                	je     800f1b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f0c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f11:	80 3a 30             	cmpb   $0x30,(%edx)
  800f14:	75 05                	jne    800f1b <strtol+0x77>
		s++, base = 8;
  800f16:	83 c2 01             	add    $0x1,%edx
  800f19:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f20:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f22:	0f b6 0a             	movzbl (%edx),%ecx
  800f25:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800f28:	80 fb 09             	cmp    $0x9,%bl
  800f2b:	77 08                	ja     800f35 <strtol+0x91>
			dig = *s - '0';
  800f2d:	0f be c9             	movsbl %cl,%ecx
  800f30:	83 e9 30             	sub    $0x30,%ecx
  800f33:	eb 1e                	jmp    800f53 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800f35:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800f38:	80 fb 19             	cmp    $0x19,%bl
  800f3b:	77 08                	ja     800f45 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800f3d:	0f be c9             	movsbl %cl,%ecx
  800f40:	83 e9 57             	sub    $0x57,%ecx
  800f43:	eb 0e                	jmp    800f53 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800f45:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800f48:	80 fb 19             	cmp    $0x19,%bl
  800f4b:	77 14                	ja     800f61 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800f4d:	0f be c9             	movsbl %cl,%ecx
  800f50:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f53:	39 f1                	cmp    %esi,%ecx
  800f55:	7d 0e                	jge    800f65 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f57:	83 c2 01             	add    $0x1,%edx
  800f5a:	0f af c6             	imul   %esi,%eax
  800f5d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800f5f:	eb c1                	jmp    800f22 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800f61:	89 c1                	mov    %eax,%ecx
  800f63:	eb 02                	jmp    800f67 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f65:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f6b:	74 05                	je     800f72 <strtol+0xce>
		*endptr = (char *) s;
  800f6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f70:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f72:	89 ca                	mov    %ecx,%edx
  800f74:	f7 da                	neg    %edx
  800f76:	85 ff                	test   %edi,%edi
  800f78:	0f 45 c2             	cmovne %edx,%eax
}
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5f                   	pop    %edi
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 0c             	sub    $0xc,%esp
  800f86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f89:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f8c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f97:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9a:	89 c3                	mov    %eax,%ebx
  800f9c:	89 c7                	mov    %eax,%edi
  800f9e:	89 c6                	mov    %eax,%esi
  800fa0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fa2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fa8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fab:	89 ec                	mov    %ebp,%esp
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    

00800faf <sys_cgetc>:

int
sys_cgetc(void)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 0c             	sub    $0xc,%esp
  800fb5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fb8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fbb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc3:	b8 01 00 00 00       	mov    $0x1,%eax
  800fc8:	89 d1                	mov    %edx,%ecx
  800fca:	89 d3                	mov    %edx,%ebx
  800fcc:	89 d7                	mov    %edx,%edi
  800fce:	89 d6                	mov    %edx,%esi
  800fd0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fd2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fd5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fd8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fdb:	89 ec                	mov    %ebp,%esp
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 38             	sub    $0x38,%esp
  800fe5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fe8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800feb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ff8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffb:	89 cb                	mov    %ecx,%ebx
  800ffd:	89 cf                	mov    %ecx,%edi
  800fff:	89 ce                	mov    %ecx,%esi
  801001:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801003:	85 c0                	test   %eax,%eax
  801005:	7e 28                	jle    80102f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801007:	89 44 24 10          	mov    %eax,0x10(%esp)
  80100b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801012:	00 
  801013:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  80101a:	00 
  80101b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801022:	00 
  801023:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  80102a:	e8 4d f4 ff ff       	call   80047c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80102f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801032:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801035:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801038:	89 ec                	mov    %ebp,%esp
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 0c             	sub    $0xc,%esp
  801042:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801045:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801048:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80104b:	ba 00 00 00 00       	mov    $0x0,%edx
  801050:	b8 02 00 00 00       	mov    $0x2,%eax
  801055:	89 d1                	mov    %edx,%ecx
  801057:	89 d3                	mov    %edx,%ebx
  801059:	89 d7                	mov    %edx,%edi
  80105b:	89 d6                	mov    %edx,%esi
  80105d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80105f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801062:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801065:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801068:	89 ec                	mov    %ebp,%esp
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    

0080106c <sys_yield>:

void
sys_yield(void)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 0c             	sub    $0xc,%esp
  801072:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801075:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801078:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107b:	ba 00 00 00 00       	mov    $0x0,%edx
  801080:	b8 0b 00 00 00       	mov    $0xb,%eax
  801085:	89 d1                	mov    %edx,%ecx
  801087:	89 d3                	mov    %edx,%ebx
  801089:	89 d7                	mov    %edx,%edi
  80108b:	89 d6                	mov    %edx,%esi
  80108d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80108f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801092:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801095:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801098:	89 ec                	mov    %ebp,%esp
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    

0080109c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	83 ec 38             	sub    $0x38,%esp
  8010a2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010a5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010a8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ab:	be 00 00 00 00       	mov    $0x0,%esi
  8010b0:	b8 04 00 00 00       	mov    $0x4,%eax
  8010b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010be:	89 f7                	mov    %esi,%edi
  8010c0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010c2:	85 c0                	test   %eax,%eax
  8010c4:	7e 28                	jle    8010ee <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ca:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010d1:	00 
  8010d2:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  8010d9:	00 
  8010da:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e1:	00 
  8010e2:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  8010e9:	e8 8e f3 ff ff       	call   80047c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010ee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010f1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010f4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010f7:	89 ec                	mov    %ebp,%esp
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    

008010fb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	83 ec 38             	sub    $0x38,%esp
  801101:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801104:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801107:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80110a:	b8 05 00 00 00       	mov    $0x5,%eax
  80110f:	8b 75 18             	mov    0x18(%ebp),%esi
  801112:	8b 7d 14             	mov    0x14(%ebp),%edi
  801115:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111b:	8b 55 08             	mov    0x8(%ebp),%edx
  80111e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801120:	85 c0                	test   %eax,%eax
  801122:	7e 28                	jle    80114c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801124:	89 44 24 10          	mov    %eax,0x10(%esp)
  801128:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80112f:	00 
  801130:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  801137:	00 
  801138:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80113f:	00 
  801140:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  801147:	e8 30 f3 ff ff       	call   80047c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80114c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80114f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801152:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801155:	89 ec                	mov    %ebp,%esp
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    

00801159 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	83 ec 38             	sub    $0x38,%esp
  80115f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801162:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801165:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801168:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116d:	b8 06 00 00 00       	mov    $0x6,%eax
  801172:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801175:	8b 55 08             	mov    0x8(%ebp),%edx
  801178:	89 df                	mov    %ebx,%edi
  80117a:	89 de                	mov    %ebx,%esi
  80117c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80117e:	85 c0                	test   %eax,%eax
  801180:	7e 28                	jle    8011aa <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801182:	89 44 24 10          	mov    %eax,0x10(%esp)
  801186:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80118d:	00 
  80118e:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  801195:	00 
  801196:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80119d:	00 
  80119e:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  8011a5:	e8 d2 f2 ff ff       	call   80047c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011aa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011ad:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011b0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011b3:	89 ec                	mov    %ebp,%esp
  8011b5:	5d                   	pop    %ebp
  8011b6:	c3                   	ret    

008011b7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	83 ec 38             	sub    $0x38,%esp
  8011bd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011c0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011c3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011cb:	b8 08 00 00 00       	mov    $0x8,%eax
  8011d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d6:	89 df                	mov    %ebx,%edi
  8011d8:	89 de                	mov    %ebx,%esi
  8011da:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	7e 28                	jle    801208 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011e4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8011eb:	00 
  8011ec:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  8011f3:	00 
  8011f4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011fb:	00 
  8011fc:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  801203:	e8 74 f2 ff ff       	call   80047c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801208:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80120b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80120e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801211:	89 ec                	mov    %ebp,%esp
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 38             	sub    $0x38,%esp
  80121b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80121e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801221:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801224:	bb 00 00 00 00       	mov    $0x0,%ebx
  801229:	b8 09 00 00 00       	mov    $0x9,%eax
  80122e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801231:	8b 55 08             	mov    0x8(%ebp),%edx
  801234:	89 df                	mov    %ebx,%edi
  801236:	89 de                	mov    %ebx,%esi
  801238:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80123a:	85 c0                	test   %eax,%eax
  80123c:	7e 28                	jle    801266 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80123e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801242:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801249:	00 
  80124a:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  801251:	00 
  801252:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801259:	00 
  80125a:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  801261:	e8 16 f2 ff ff       	call   80047c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801266:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801269:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80126c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80126f:	89 ec                	mov    %ebp,%esp
  801271:	5d                   	pop    %ebp
  801272:	c3                   	ret    

00801273 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	83 ec 38             	sub    $0x38,%esp
  801279:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80127c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80127f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801282:	bb 00 00 00 00       	mov    $0x0,%ebx
  801287:	b8 0a 00 00 00       	mov    $0xa,%eax
  80128c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128f:	8b 55 08             	mov    0x8(%ebp),%edx
  801292:	89 df                	mov    %ebx,%edi
  801294:	89 de                	mov    %ebx,%esi
  801296:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801298:	85 c0                	test   %eax,%eax
  80129a:	7e 28                	jle    8012c4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80129c:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8012a7:	00 
  8012a8:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  8012af:	00 
  8012b0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012b7:	00 
  8012b8:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  8012bf:	e8 b8 f1 ff ff       	call   80047c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012c4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012c7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012ca:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012cd:	89 ec                	mov    %ebp,%esp
  8012cf:	5d                   	pop    %ebp
  8012d0:	c3                   	ret    

008012d1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012da:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012dd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012e0:	be 00 00 00 00       	mov    $0x0,%esi
  8012e5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012ea:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012f8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012fb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012fe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801301:	89 ec                	mov    %ebp,%esp
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    

00801305 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	83 ec 38             	sub    $0x38,%esp
  80130b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80130e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801311:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801314:	b9 00 00 00 00       	mov    $0x0,%ecx
  801319:	b8 0d 00 00 00       	mov    $0xd,%eax
  80131e:	8b 55 08             	mov    0x8(%ebp),%edx
  801321:	89 cb                	mov    %ecx,%ebx
  801323:	89 cf                	mov    %ecx,%edi
  801325:	89 ce                	mov    %ecx,%esi
  801327:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801329:	85 c0                	test   %eax,%eax
  80132b:	7e 28                	jle    801355 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80132d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801331:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801338:	00 
  801339:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  801340:	00 
  801341:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801348:	00 
  801349:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  801350:	e8 27 f1 ff ff       	call   80047c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801355:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801358:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80135b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80135e:	89 ec                	mov    %ebp,%esp
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    
	...

00801370 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	05 00 00 00 30       	add    $0x30000000,%eax
  80137b:	c1 e8 0c             	shr    $0xc,%eax
}
  80137e:	5d                   	pop    %ebp
  80137f:	c3                   	ret    

00801380 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	89 04 24             	mov    %eax,(%esp)
  80138c:	e8 df ff ff ff       	call   801370 <fd2num>
  801391:	05 20 00 0d 00       	add    $0xd0020,%eax
  801396:	c1 e0 0c             	shl    $0xc,%eax
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	53                   	push   %ebx
  80139f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013a2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8013a7:	a8 01                	test   $0x1,%al
  8013a9:	74 34                	je     8013df <fd_alloc+0x44>
  8013ab:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8013b0:	a8 01                	test   $0x1,%al
  8013b2:	74 32                	je     8013e6 <fd_alloc+0x4b>
  8013b4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8013b9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013bb:	89 c2                	mov    %eax,%edx
  8013bd:	c1 ea 16             	shr    $0x16,%edx
  8013c0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013c7:	f6 c2 01             	test   $0x1,%dl
  8013ca:	74 1f                	je     8013eb <fd_alloc+0x50>
  8013cc:	89 c2                	mov    %eax,%edx
  8013ce:	c1 ea 0c             	shr    $0xc,%edx
  8013d1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013d8:	f6 c2 01             	test   $0x1,%dl
  8013db:	75 17                	jne    8013f4 <fd_alloc+0x59>
  8013dd:	eb 0c                	jmp    8013eb <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8013df:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8013e4:	eb 05                	jmp    8013eb <fd_alloc+0x50>
  8013e6:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8013eb:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  8013ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f2:	eb 17                	jmp    80140b <fd_alloc+0x70>
  8013f4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013f9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013fe:	75 b9                	jne    8013b9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801400:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801406:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80140b:	5b                   	pop    %ebx
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    

0080140e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801414:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801419:	83 fa 1f             	cmp    $0x1f,%edx
  80141c:	77 3f                	ja     80145d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80141e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801424:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801427:	89 d0                	mov    %edx,%eax
  801429:	c1 e8 16             	shr    $0x16,%eax
  80142c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801433:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801438:	f6 c1 01             	test   $0x1,%cl
  80143b:	74 20                	je     80145d <fd_lookup+0x4f>
  80143d:	89 d0                	mov    %edx,%eax
  80143f:	c1 e8 0c             	shr    $0xc,%eax
  801442:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801449:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80144e:	f6 c1 01             	test   $0x1,%cl
  801451:	74 0a                	je     80145d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	89 10                	mov    %edx,(%eax)
	return 0;
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	53                   	push   %ebx
  801463:	83 ec 14             	sub    $0x14,%esp
  801466:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801469:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80146c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801471:	39 0d 90 57 80 00    	cmp    %ecx,0x805790
  801477:	75 17                	jne    801490 <dev_lookup+0x31>
  801479:	eb 07                	jmp    801482 <dev_lookup+0x23>
  80147b:	39 0a                	cmp    %ecx,(%edx)
  80147d:	75 11                	jne    801490 <dev_lookup+0x31>
  80147f:	90                   	nop
  801480:	eb 05                	jmp    801487 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801482:	ba 90 57 80 00       	mov    $0x805790,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801487:	89 13                	mov    %edx,(%ebx)
			return 0;
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
  80148e:	eb 35                	jmp    8014c5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801490:	83 c0 01             	add    $0x1,%eax
  801493:	8b 14 85 e8 2f 80 00 	mov    0x802fe8(,%eax,4),%edx
  80149a:	85 d2                	test   %edx,%edx
  80149c:	75 dd                	jne    80147b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80149e:	a1 90 77 80 00       	mov    0x807790,%eax
  8014a3:	8b 40 48             	mov    0x48(%eax),%eax
  8014a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ae:	c7 04 24 6c 2f 80 00 	movl   $0x802f6c,(%esp)
  8014b5:	e8 bd f0 ff ff       	call   800577 <cprintf>
	*dev = 0;
  8014ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8014c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014c5:	83 c4 14             	add    $0x14,%esp
  8014c8:	5b                   	pop    %ebx
  8014c9:	5d                   	pop    %ebp
  8014ca:	c3                   	ret    

008014cb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 38             	sub    $0x38,%esp
  8014d1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014d4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014d7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8014da:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014dd:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014e1:	89 3c 24             	mov    %edi,(%esp)
  8014e4:	e8 87 fe ff ff       	call   801370 <fd2num>
  8014e9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8014ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014f0:	89 04 24             	mov    %eax,(%esp)
  8014f3:	e8 16 ff ff ff       	call   80140e <fd_lookup>
  8014f8:	89 c3                	mov    %eax,%ebx
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	78 05                	js     801503 <fd_close+0x38>
	    || fd != fd2)
  8014fe:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801501:	74 0e                	je     801511 <fd_close+0x46>
		return (must_exist ? r : 0);
  801503:	89 f0                	mov    %esi,%eax
  801505:	84 c0                	test   %al,%al
  801507:	b8 00 00 00 00       	mov    $0x0,%eax
  80150c:	0f 44 d8             	cmove  %eax,%ebx
  80150f:	eb 3d                	jmp    80154e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801511:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801514:	89 44 24 04          	mov    %eax,0x4(%esp)
  801518:	8b 07                	mov    (%edi),%eax
  80151a:	89 04 24             	mov    %eax,(%esp)
  80151d:	e8 3d ff ff ff       	call   80145f <dev_lookup>
  801522:	89 c3                	mov    %eax,%ebx
  801524:	85 c0                	test   %eax,%eax
  801526:	78 16                	js     80153e <fd_close+0x73>
		if (dev->dev_close)
  801528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80152e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801533:	85 c0                	test   %eax,%eax
  801535:	74 07                	je     80153e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801537:	89 3c 24             	mov    %edi,(%esp)
  80153a:	ff d0                	call   *%eax
  80153c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80153e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801542:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801549:	e8 0b fc ff ff       	call   801159 <sys_page_unmap>
	return r;
}
  80154e:	89 d8                	mov    %ebx,%eax
  801550:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801553:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801556:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801559:	89 ec                	mov    %ebp,%esp
  80155b:	5d                   	pop    %ebp
  80155c:	c3                   	ret    

0080155d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801563:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801566:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	89 04 24             	mov    %eax,(%esp)
  801570:	e8 99 fe ff ff       	call   80140e <fd_lookup>
  801575:	85 c0                	test   %eax,%eax
  801577:	78 13                	js     80158c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801579:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801580:	00 
  801581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801584:	89 04 24             	mov    %eax,(%esp)
  801587:	e8 3f ff ff ff       	call   8014cb <fd_close>
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <close_all>:

void
close_all(void)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	53                   	push   %ebx
  801592:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801595:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80159a:	89 1c 24             	mov    %ebx,(%esp)
  80159d:	e8 bb ff ff ff       	call   80155d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015a2:	83 c3 01             	add    $0x1,%ebx
  8015a5:	83 fb 20             	cmp    $0x20,%ebx
  8015a8:	75 f0                	jne    80159a <close_all+0xc>
		close(i);
}
  8015aa:	83 c4 14             	add    $0x14,%esp
  8015ad:	5b                   	pop    %ebx
  8015ae:	5d                   	pop    %ebp
  8015af:	c3                   	ret    

008015b0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 58             	sub    $0x58,%esp
  8015b6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015b9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015bc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8015bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	89 04 24             	mov    %eax,(%esp)
  8015cf:	e8 3a fe ff ff       	call   80140e <fd_lookup>
  8015d4:	89 c3                	mov    %eax,%ebx
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	0f 88 e1 00 00 00    	js     8016bf <dup+0x10f>
		return r;
	close(newfdnum);
  8015de:	89 3c 24             	mov    %edi,(%esp)
  8015e1:	e8 77 ff ff ff       	call   80155d <close>

	newfd = INDEX2FD(newfdnum);
  8015e6:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8015ec:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8015ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015f2:	89 04 24             	mov    %eax,(%esp)
  8015f5:	e8 86 fd ff ff       	call   801380 <fd2data>
  8015fa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015fc:	89 34 24             	mov    %esi,(%esp)
  8015ff:	e8 7c fd ff ff       	call   801380 <fd2data>
  801604:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801607:	89 d8                	mov    %ebx,%eax
  801609:	c1 e8 16             	shr    $0x16,%eax
  80160c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801613:	a8 01                	test   $0x1,%al
  801615:	74 46                	je     80165d <dup+0xad>
  801617:	89 d8                	mov    %ebx,%eax
  801619:	c1 e8 0c             	shr    $0xc,%eax
  80161c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801623:	f6 c2 01             	test   $0x1,%dl
  801626:	74 35                	je     80165d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801628:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80162f:	25 07 0e 00 00       	and    $0xe07,%eax
  801634:	89 44 24 10          	mov    %eax,0x10(%esp)
  801638:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80163b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80163f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801646:	00 
  801647:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80164b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801652:	e8 a4 fa ff ff       	call   8010fb <sys_page_map>
  801657:	89 c3                	mov    %eax,%ebx
  801659:	85 c0                	test   %eax,%eax
  80165b:	78 3b                	js     801698 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80165d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801660:	89 c2                	mov    %eax,%edx
  801662:	c1 ea 0c             	shr    $0xc,%edx
  801665:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80166c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801672:	89 54 24 10          	mov    %edx,0x10(%esp)
  801676:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80167a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801681:	00 
  801682:	89 44 24 04          	mov    %eax,0x4(%esp)
  801686:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168d:	e8 69 fa ff ff       	call   8010fb <sys_page_map>
  801692:	89 c3                	mov    %eax,%ebx
  801694:	85 c0                	test   %eax,%eax
  801696:	79 25                	jns    8016bd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801698:	89 74 24 04          	mov    %esi,0x4(%esp)
  80169c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a3:	e8 b1 fa ff ff       	call   801159 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b6:	e8 9e fa ff ff       	call   801159 <sys_page_unmap>
	return r;
  8016bb:	eb 02                	jmp    8016bf <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8016bd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016bf:	89 d8                	mov    %ebx,%eax
  8016c1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016c4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016c7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016ca:	89 ec                	mov    %ebp,%esp
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    

008016ce <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 24             	sub    $0x24,%esp
  8016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016df:	89 1c 24             	mov    %ebx,(%esp)
  8016e2:	e8 27 fd ff ff       	call   80140e <fd_lookup>
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 6d                	js     801758 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f5:	8b 00                	mov    (%eax),%eax
  8016f7:	89 04 24             	mov    %eax,(%esp)
  8016fa:	e8 60 fd ff ff       	call   80145f <dev_lookup>
  8016ff:	85 c0                	test   %eax,%eax
  801701:	78 55                	js     801758 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801706:	8b 50 08             	mov    0x8(%eax),%edx
  801709:	83 e2 03             	and    $0x3,%edx
  80170c:	83 fa 01             	cmp    $0x1,%edx
  80170f:	75 23                	jne    801734 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801711:	a1 90 77 80 00       	mov    0x807790,%eax
  801716:	8b 40 48             	mov    0x48(%eax),%eax
  801719:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80171d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801721:	c7 04 24 ad 2f 80 00 	movl   $0x802fad,(%esp)
  801728:	e8 4a ee ff ff       	call   800577 <cprintf>
		return -E_INVAL;
  80172d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801732:	eb 24                	jmp    801758 <read+0x8a>
	}
	if (!dev->dev_read)
  801734:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801737:	8b 52 08             	mov    0x8(%edx),%edx
  80173a:	85 d2                	test   %edx,%edx
  80173c:	74 15                	je     801753 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80173e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801741:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801745:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801748:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80174c:	89 04 24             	mov    %eax,(%esp)
  80174f:	ff d2                	call   *%edx
  801751:	eb 05                	jmp    801758 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801753:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801758:	83 c4 24             	add    $0x24,%esp
  80175b:	5b                   	pop    %ebx
  80175c:	5d                   	pop    %ebp
  80175d:	c3                   	ret    

0080175e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	57                   	push   %edi
  801762:	56                   	push   %esi
  801763:	53                   	push   %ebx
  801764:	83 ec 1c             	sub    $0x1c,%esp
  801767:	8b 7d 08             	mov    0x8(%ebp),%edi
  80176a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80176d:	b8 00 00 00 00       	mov    $0x0,%eax
  801772:	85 f6                	test   %esi,%esi
  801774:	74 30                	je     8017a6 <readn+0x48>
  801776:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80177b:	89 f2                	mov    %esi,%edx
  80177d:	29 c2                	sub    %eax,%edx
  80177f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801783:	03 45 0c             	add    0xc(%ebp),%eax
  801786:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178a:	89 3c 24             	mov    %edi,(%esp)
  80178d:	e8 3c ff ff ff       	call   8016ce <read>
		if (m < 0)
  801792:	85 c0                	test   %eax,%eax
  801794:	78 10                	js     8017a6 <readn+0x48>
			return m;
		if (m == 0)
  801796:	85 c0                	test   %eax,%eax
  801798:	74 0a                	je     8017a4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80179a:	01 c3                	add    %eax,%ebx
  80179c:	89 d8                	mov    %ebx,%eax
  80179e:	39 f3                	cmp    %esi,%ebx
  8017a0:	72 d9                	jb     80177b <readn+0x1d>
  8017a2:	eb 02                	jmp    8017a6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8017a4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8017a6:	83 c4 1c             	add    $0x1c,%esp
  8017a9:	5b                   	pop    %ebx
  8017aa:	5e                   	pop    %esi
  8017ab:	5f                   	pop    %edi
  8017ac:	5d                   	pop    %ebp
  8017ad:	c3                   	ret    

008017ae <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	53                   	push   %ebx
  8017b2:	83 ec 24             	sub    $0x24,%esp
  8017b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bf:	89 1c 24             	mov    %ebx,(%esp)
  8017c2:	e8 47 fc ff ff       	call   80140e <fd_lookup>
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 68                	js     801833 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d5:	8b 00                	mov    (%eax),%eax
  8017d7:	89 04 24             	mov    %eax,(%esp)
  8017da:	e8 80 fc ff ff       	call   80145f <dev_lookup>
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 50                	js     801833 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ea:	75 23                	jne    80180f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ec:	a1 90 77 80 00       	mov    0x807790,%eax
  8017f1:	8b 40 48             	mov    0x48(%eax),%eax
  8017f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fc:	c7 04 24 c9 2f 80 00 	movl   $0x802fc9,(%esp)
  801803:	e8 6f ed ff ff       	call   800577 <cprintf>
		return -E_INVAL;
  801808:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180d:	eb 24                	jmp    801833 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80180f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801812:	8b 52 0c             	mov    0xc(%edx),%edx
  801815:	85 d2                	test   %edx,%edx
  801817:	74 15                	je     80182e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801819:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801820:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801823:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801827:	89 04 24             	mov    %eax,(%esp)
  80182a:	ff d2                	call   *%edx
  80182c:	eb 05                	jmp    801833 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80182e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801833:	83 c4 24             	add    $0x24,%esp
  801836:	5b                   	pop    %ebx
  801837:	5d                   	pop    %ebp
  801838:	c3                   	ret    

00801839 <seek>:

int
seek(int fdnum, off_t offset)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80183f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801842:	89 44 24 04          	mov    %eax,0x4(%esp)
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	89 04 24             	mov    %eax,(%esp)
  80184c:	e8 bd fb ff ff       	call   80140e <fd_lookup>
  801851:	85 c0                	test   %eax,%eax
  801853:	78 0e                	js     801863 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801855:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801858:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80185e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	53                   	push   %ebx
  801869:	83 ec 24             	sub    $0x24,%esp
  80186c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80186f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801872:	89 44 24 04          	mov    %eax,0x4(%esp)
  801876:	89 1c 24             	mov    %ebx,(%esp)
  801879:	e8 90 fb ff ff       	call   80140e <fd_lookup>
  80187e:	85 c0                	test   %eax,%eax
  801880:	78 61                	js     8018e3 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801882:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801885:	89 44 24 04          	mov    %eax,0x4(%esp)
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188c:	8b 00                	mov    (%eax),%eax
  80188e:	89 04 24             	mov    %eax,(%esp)
  801891:	e8 c9 fb ff ff       	call   80145f <dev_lookup>
  801896:	85 c0                	test   %eax,%eax
  801898:	78 49                	js     8018e3 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018a1:	75 23                	jne    8018c6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018a3:	a1 90 77 80 00       	mov    0x807790,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018a8:	8b 40 48             	mov    0x48(%eax),%eax
  8018ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b3:	c7 04 24 8c 2f 80 00 	movl   $0x802f8c,(%esp)
  8018ba:	e8 b8 ec ff ff       	call   800577 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c4:	eb 1d                	jmp    8018e3 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8018c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c9:	8b 52 18             	mov    0x18(%edx),%edx
  8018cc:	85 d2                	test   %edx,%edx
  8018ce:	74 0e                	je     8018de <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018d7:	89 04 24             	mov    %eax,(%esp)
  8018da:	ff d2                	call   *%edx
  8018dc:	eb 05                	jmp    8018e3 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018e3:	83 c4 24             	add    $0x24,%esp
  8018e6:	5b                   	pop    %ebx
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    

008018e9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	53                   	push   %ebx
  8018ed:	83 ec 24             	sub    $0x24,%esp
  8018f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	89 04 24             	mov    %eax,(%esp)
  801900:	e8 09 fb ff ff       	call   80140e <fd_lookup>
  801905:	85 c0                	test   %eax,%eax
  801907:	78 52                	js     80195b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801909:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801913:	8b 00                	mov    (%eax),%eax
  801915:	89 04 24             	mov    %eax,(%esp)
  801918:	e8 42 fb ff ff       	call   80145f <dev_lookup>
  80191d:	85 c0                	test   %eax,%eax
  80191f:	78 3a                	js     80195b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801924:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801928:	74 2c                	je     801956 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80192a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80192d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801934:	00 00 00 
	stat->st_isdir = 0;
  801937:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80193e:	00 00 00 
	stat->st_dev = dev;
  801941:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801947:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80194b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80194e:	89 14 24             	mov    %edx,(%esp)
  801951:	ff 50 14             	call   *0x14(%eax)
  801954:	eb 05                	jmp    80195b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801956:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80195b:	83 c4 24             	add    $0x24,%esp
  80195e:	5b                   	pop    %ebx
  80195f:	5d                   	pop    %ebp
  801960:	c3                   	ret    

00801961 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	83 ec 18             	sub    $0x18,%esp
  801967:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80196a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80196d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801974:	00 
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	89 04 24             	mov    %eax,(%esp)
  80197b:	e8 bc 01 00 00       	call   801b3c <open>
  801980:	89 c3                	mov    %eax,%ebx
  801982:	85 c0                	test   %eax,%eax
  801984:	78 1b                	js     8019a1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801986:	8b 45 0c             	mov    0xc(%ebp),%eax
  801989:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198d:	89 1c 24             	mov    %ebx,(%esp)
  801990:	e8 54 ff ff ff       	call   8018e9 <fstat>
  801995:	89 c6                	mov    %eax,%esi
	close(fd);
  801997:	89 1c 24             	mov    %ebx,(%esp)
  80199a:	e8 be fb ff ff       	call   80155d <close>
	return r;
  80199f:	89 f3                	mov    %esi,%ebx
}
  8019a1:	89 d8                	mov    %ebx,%eax
  8019a3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8019a6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8019a9:	89 ec                	mov    %ebp,%esp
  8019ab:	5d                   	pop    %ebp
  8019ac:	c3                   	ret    
  8019ad:	00 00                	add    %al,(%eax)
	...

008019b0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 18             	sub    $0x18,%esp
  8019b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8019b9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8019bc:	89 c3                	mov    %eax,%ebx
  8019be:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8019c0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8019c7:	75 11                	jne    8019da <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019d0:	e8 a1 0d 00 00       	call   802776 <ipc_find_env>
  8019d5:	a3 00 60 80 00       	mov    %eax,0x806000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019da:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019e1:	00 
  8019e2:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8019e9:	00 
  8019ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ee:	a1 00 60 80 00       	mov    0x806000,%eax
  8019f3:	89 04 24             	mov    %eax,(%esp)
  8019f6:	e8 f7 0c 00 00       	call   8026f2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a02:	00 
  801a03:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a0e:	e8 8d 0c 00 00       	call   8026a0 <ipc_recv>
}
  801a13:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a16:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a19:	89 ec                	mov    %ebp,%esp
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    

00801a1d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	53                   	push   %ebx
  801a21:	83 ec 14             	sub    $0x14,%esp
  801a24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a2d:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a32:	ba 00 00 00 00       	mov    $0x0,%edx
  801a37:	b8 05 00 00 00       	mov    $0x5,%eax
  801a3c:	e8 6f ff ff ff       	call   8019b0 <fsipc>
  801a41:	85 c0                	test   %eax,%eax
  801a43:	78 2b                	js     801a70 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a45:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801a4c:	00 
  801a4d:	89 1c 24             	mov    %ebx,(%esp)
  801a50:	e8 46 f1 ff ff       	call   800b9b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a55:	a1 80 80 80 00       	mov    0x808080,%eax
  801a5a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a60:	a1 84 80 80 00       	mov    0x808084,%eax
  801a65:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a70:	83 c4 14             	add    $0x14,%esp
  801a73:	5b                   	pop    %ebx
  801a74:	5d                   	pop    %ebp
  801a75:	c3                   	ret    

00801a76 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a82:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  801a87:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8c:	b8 06 00 00 00       	mov    $0x6,%eax
  801a91:	e8 1a ff ff ff       	call   8019b0 <fsipc>
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	56                   	push   %esi
  801a9c:	53                   	push   %ebx
  801a9d:	83 ec 10             	sub    $0x10,%esp
  801aa0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa9:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801aae:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab9:	b8 03 00 00 00       	mov    $0x3,%eax
  801abe:	e8 ed fe ff ff       	call   8019b0 <fsipc>
  801ac3:	89 c3                	mov    %eax,%ebx
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	78 6a                	js     801b33 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ac9:	39 c6                	cmp    %eax,%esi
  801acb:	73 24                	jae    801af1 <devfile_read+0x59>
  801acd:	c7 44 24 0c f8 2f 80 	movl   $0x802ff8,0xc(%esp)
  801ad4:	00 
  801ad5:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  801adc:	00 
  801add:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801ae4:	00 
  801ae5:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801aec:	e8 8b e9 ff ff       	call   80047c <_panic>
	assert(r <= PGSIZE);
  801af1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801af6:	7e 24                	jle    801b1c <devfile_read+0x84>
  801af8:	c7 44 24 0c 1f 30 80 	movl   $0x80301f,0xc(%esp)
  801aff:	00 
  801b00:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  801b07:	00 
  801b08:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801b0f:	00 
  801b10:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801b17:	e8 60 e9 ff ff       	call   80047c <_panic>
	memmove(buf, &fsipcbuf, r);
  801b1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b20:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801b27:	00 
  801b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2b:	89 04 24             	mov    %eax,(%esp)
  801b2e:	e8 59 f2 ff ff       	call   800d8c <memmove>
	return r;
}
  801b33:	89 d8                	mov    %ebx,%eax
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5e                   	pop    %esi
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    

00801b3c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	56                   	push   %esi
  801b40:	53                   	push   %ebx
  801b41:	83 ec 20             	sub    $0x20,%esp
  801b44:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b47:	89 34 24             	mov    %esi,(%esp)
  801b4a:	e8 01 f0 ff ff       	call   800b50 <strlen>
		return -E_BAD_PATH;
  801b4f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b54:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b59:	7f 5e                	jg     801bb9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5e:	89 04 24             	mov    %eax,(%esp)
  801b61:	e8 35 f8 ff ff       	call   80139b <fd_alloc>
  801b66:	89 c3                	mov    %eax,%ebx
  801b68:	85 c0                	test   %eax,%eax
  801b6a:	78 4d                	js     801bb9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b70:	c7 04 24 00 80 80 00 	movl   $0x808000,(%esp)
  801b77:	e8 1f f0 ff ff       	call   800b9b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7f:	a3 00 84 80 00       	mov    %eax,0x808400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b87:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8c:	e8 1f fe ff ff       	call   8019b0 <fsipc>
  801b91:	89 c3                	mov    %eax,%ebx
  801b93:	85 c0                	test   %eax,%eax
  801b95:	79 15                	jns    801bac <open+0x70>
		fd_close(fd, 0);
  801b97:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b9e:	00 
  801b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba2:	89 04 24             	mov    %eax,(%esp)
  801ba5:	e8 21 f9 ff ff       	call   8014cb <fd_close>
		return r;
  801baa:	eb 0d                	jmp    801bb9 <open+0x7d>
	}

	return fd2num(fd);
  801bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baf:	89 04 24             	mov    %eax,(%esp)
  801bb2:	e8 b9 f7 ff ff       	call   801370 <fd2num>
  801bb7:	89 c3                	mov    %eax,%ebx
}
  801bb9:	89 d8                	mov    %ebx,%eax
  801bbb:	83 c4 20             	add    $0x20,%esp
  801bbe:	5b                   	pop    %ebx
  801bbf:	5e                   	pop    %esi
  801bc0:	5d                   	pop    %ebp
  801bc1:	c3                   	ret    
	...

00801bc4 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	57                   	push   %edi
  801bc8:	56                   	push   %esi
  801bc9:	53                   	push   %ebx
  801bca:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801bd0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bd7:	00 
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	89 04 24             	mov    %eax,(%esp)
  801bde:	e8 59 ff ff ff       	call   801b3c <open>
  801be3:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801be9:	85 c0                	test   %eax,%eax
  801beb:	0f 88 b2 05 00 00    	js     8021a3 <spawn+0x5df>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801bf1:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801bf8:	00 
  801bf9:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801bff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c03:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c09:	89 04 24             	mov    %eax,(%esp)
  801c0c:	e8 4d fb ff ff       	call   80175e <readn>
  801c11:	3d 00 02 00 00       	cmp    $0x200,%eax
  801c16:	75 0c                	jne    801c24 <spawn+0x60>
	    || elf->e_magic != ELF_MAGIC) {
  801c18:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801c1f:	45 4c 46 
  801c22:	74 3b                	je     801c5f <spawn+0x9b>
		close(fd);
  801c24:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c2a:	89 04 24             	mov    %eax,(%esp)
  801c2d:	e8 2b f9 ff ff       	call   80155d <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801c32:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801c39:	46 
  801c3a:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c44:	c7 04 24 2b 30 80 00 	movl   $0x80302b,(%esp)
  801c4b:	e8 27 e9 ff ff       	call   800577 <cprintf>
		return -E_NOT_EXEC;
  801c50:	c7 85 84 fd ff ff f2 	movl   $0xfffffff2,-0x27c(%ebp)
  801c57:	ff ff ff 
  801c5a:	e9 50 05 00 00       	jmp    8021af <spawn+0x5eb>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801c5f:	ba 07 00 00 00       	mov    $0x7,%edx
  801c64:	89 d0                	mov    %edx,%eax
  801c66:	cd 30                	int    $0x30
  801c68:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801c6e:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801c74:	85 c0                	test   %eax,%eax
  801c76:	0f 88 33 05 00 00    	js     8021af <spawn+0x5eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801c7c:	89 c6                	mov    %eax,%esi
  801c7e:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801c84:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801c87:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801c8d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801c93:	b9 11 00 00 00       	mov    $0x11,%ecx
  801c98:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801c9a:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801ca0:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca9:	8b 02                	mov    (%edx),%eax
  801cab:	85 c0                	test   %eax,%eax
  801cad:	74 5f                	je     801d0e <spawn+0x14a>
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801caf:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  801cb4:	be 00 00 00 00       	mov    $0x0,%esi
  801cb9:	89 d7                	mov    %edx,%edi
		string_size += strlen(argv[argc]) + 1;
  801cbb:	89 04 24             	mov    %eax,(%esp)
  801cbe:	e8 8d ee ff ff       	call   800b50 <strlen>
  801cc3:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801cc7:	83 c6 01             	add    $0x1,%esi
  801cca:	89 f2                	mov    %esi,%edx
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  801ccc:	8d 0c b5 00 00 00 00 	lea    0x0(,%esi,4),%ecx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801cd3:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	75 e1                	jne    801cbb <spawn+0xf7>
  801cda:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801ce0:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801ce6:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ceb:	29 df                	sub    %ebx,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ced:	89 f8                	mov    %edi,%eax
  801cef:	83 e0 fc             	and    $0xfffffffc,%eax
  801cf2:	f7 d2                	not    %edx
  801cf4:	8d 14 90             	lea    (%eax,%edx,4),%edx
  801cf7:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801cfd:	89 d0                	mov    %edx,%eax
  801cff:	83 e8 08             	sub    $0x8,%eax
  801d02:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801d07:	77 2d                	ja     801d36 <spawn+0x172>
  801d09:	e9 b2 04 00 00       	jmp    8021c0 <spawn+0x5fc>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d0e:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801d15:	00 00 00 
  801d18:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  801d1f:	00 00 00 
  801d22:	be 00 00 00 00       	mov    $0x0,%esi
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801d27:	c7 85 94 fd ff ff fc 	movl   $0x400ffc,-0x26c(%ebp)
  801d2e:	0f 40 00 
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801d31:	bf 00 10 40 00       	mov    $0x401000,%edi
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d36:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d3d:	00 
  801d3e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d45:	00 
  801d46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d4d:	e8 4a f3 ff ff       	call   80109c <sys_page_alloc>
  801d52:	85 c0                	test   %eax,%eax
  801d54:	0f 88 6b 04 00 00    	js     8021c5 <spawn+0x601>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801d5a:	85 f6                	test   %esi,%esi
  801d5c:	7e 46                	jle    801da4 <spawn+0x1e0>
  801d5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d63:	89 b5 90 fd ff ff    	mov    %esi,-0x270(%ebp)
  801d69:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  801d6c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801d72:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801d78:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  801d7b:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d82:	89 3c 24             	mov    %edi,(%esp)
  801d85:	e8 11 ee ff ff       	call   800b9b <strcpy>
		string_store += strlen(argv[i]) + 1;
  801d8a:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801d8d:	89 04 24             	mov    %eax,(%esp)
  801d90:	e8 bb ed ff ff       	call   800b50 <strlen>
  801d95:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801d99:	83 c3 01             	add    $0x1,%ebx
  801d9c:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  801da2:	75 c8                	jne    801d6c <spawn+0x1a8>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801da4:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801daa:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801db0:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801db7:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801dbd:	74 24                	je     801de3 <spawn+0x21f>
  801dbf:	c7 44 24 0c a0 30 80 	movl   $0x8030a0,0xc(%esp)
  801dc6:	00 
  801dc7:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  801dce:	00 
  801dcf:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  801dd6:	00 
  801dd7:	c7 04 24 45 30 80 00 	movl   $0x803045,(%esp)
  801dde:	e8 99 e6 ff ff       	call   80047c <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801de3:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801de9:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801dee:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801df4:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801df7:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801dfd:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801e00:	89 d0                	mov    %edx,%eax
  801e02:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801e07:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801e0d:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801e14:	00 
  801e15:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801e1c:	ee 
  801e1d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e23:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e27:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e2e:	00 
  801e2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e36:	e8 c0 f2 ff ff       	call   8010fb <sys_page_map>
  801e3b:	89 c3                	mov    %eax,%ebx
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	78 1a                	js     801e5b <spawn+0x297>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801e41:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e48:	00 
  801e49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e50:	e8 04 f3 ff ff       	call   801159 <sys_page_unmap>
  801e55:	89 c3                	mov    %eax,%ebx
  801e57:	85 c0                	test   %eax,%eax
  801e59:	79 1f                	jns    801e7a <spawn+0x2b6>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801e5b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e62:	00 
  801e63:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e6a:	e8 ea f2 ff ff       	call   801159 <sys_page_unmap>
	return r;
  801e6f:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801e75:	e9 35 03 00 00       	jmp    8021af <spawn+0x5eb>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801e7a:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801e80:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801e87:	00 
  801e88:	0f 84 e2 01 00 00    	je     802070 <spawn+0x4ac>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801e8e:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801e95:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801e9b:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801ea2:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  801ea5:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801eab:	83 3a 01             	cmpl   $0x1,(%edx)
  801eae:	0f 85 9b 01 00 00    	jne    80204f <spawn+0x48b>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801eb4:	8b 42 18             	mov    0x18(%edx),%eax
  801eb7:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801eba:	83 f8 01             	cmp    $0x1,%eax
  801ebd:	19 c0                	sbb    %eax,%eax
  801ebf:	83 e0 fe             	and    $0xfffffffe,%eax
  801ec2:	83 c0 07             	add    $0x7,%eax
  801ec5:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801ecb:	8b 52 04             	mov    0x4(%edx),%edx
  801ece:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  801ed4:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801eda:	8b 70 10             	mov    0x10(%eax),%esi
  801edd:	8b 50 14             	mov    0x14(%eax),%edx
  801ee0:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  801ee6:	8b 40 08             	mov    0x8(%eax),%eax
  801ee9:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801eef:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ef4:	74 16                	je     801f0c <spawn+0x348>
		va -= i;
  801ef6:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  801efc:	01 c2                	add    %eax,%edx
  801efe:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
		filesz += i;
  801f04:	01 c6                	add    %eax,%esi
		fileoffset -= i;
  801f06:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801f0c:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  801f13:	0f 84 36 01 00 00    	je     80204f <spawn+0x48b>
  801f19:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i >= filesz) {
  801f23:	39 f7                	cmp    %esi,%edi
  801f25:	72 31                	jb     801f58 <spawn+0x394>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801f27:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801f2d:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f31:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  801f37:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f3b:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801f41:	89 04 24             	mov    %eax,(%esp)
  801f44:	e8 53 f1 ff ff       	call   80109c <sys_page_alloc>
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	0f 89 ea 00 00 00    	jns    80203b <spawn+0x477>
  801f51:	89 c6                	mov    %eax,%esi
  801f53:	e9 27 02 00 00       	jmp    80217f <spawn+0x5bb>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f58:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f5f:	00 
  801f60:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f67:	00 
  801f68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f6f:	e8 28 f1 ff ff       	call   80109c <sys_page_alloc>
  801f74:	85 c0                	test   %eax,%eax
  801f76:	0f 88 f9 01 00 00    	js     802175 <spawn+0x5b1>
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  801f7c:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  801f82:	01 d8                	add    %ebx,%eax
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801f84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f88:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801f8e:	89 04 24             	mov    %eax,(%esp)
  801f91:	e8 a3 f8 ff ff       	call   801839 <seek>
  801f96:	85 c0                	test   %eax,%eax
  801f98:	0f 88 db 01 00 00    	js     802179 <spawn+0x5b5>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801f9e:	89 f0                	mov    %esi,%eax
  801fa0:	29 f8                	sub    %edi,%eax
  801fa2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fa7:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fac:	0f 47 c2             	cmova  %edx,%eax
  801faf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fb3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801fba:	00 
  801fbb:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801fc1:	89 04 24             	mov    %eax,(%esp)
  801fc4:	e8 95 f7 ff ff       	call   80175e <readn>
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	0f 88 ac 01 00 00    	js     80217d <spawn+0x5b9>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801fd1:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801fd7:	89 54 24 10          	mov    %edx,0x10(%esp)
  801fdb:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  801fe1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fe5:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801feb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fef:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ff6:	00 
  801ff7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ffe:	e8 f8 f0 ff ff       	call   8010fb <sys_page_map>
  802003:	85 c0                	test   %eax,%eax
  802005:	79 20                	jns    802027 <spawn+0x463>
				panic("spawn: sys_page_map data: %e", r);
  802007:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80200b:	c7 44 24 08 51 30 80 	movl   $0x803051,0x8(%esp)
  802012:	00 
  802013:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  80201a:	00 
  80201b:	c7 04 24 45 30 80 00 	movl   $0x803045,(%esp)
  802022:	e8 55 e4 ff ff       	call   80047c <_panic>
			sys_page_unmap(0, UTEMP);
  802027:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80202e:	00 
  80202f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802036:	e8 1e f1 ff ff       	call   801159 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80203b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802041:	89 df                	mov    %ebx,%edi
  802043:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  802049:	0f 82 d4 fe ff ff    	jb     801f23 <spawn+0x35f>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80204f:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802056:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  80205d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802064:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  80206a:	0f 8f 35 fe ff ff    	jg     801ea5 <spawn+0x2e1>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802070:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802076:	89 04 24             	mov    %eax,(%esp)
  802079:	e8 df f4 ff ff       	call   80155d <close>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  80207e:	be 00 00 00 00       	mov    $0x0,%esi
			if (((uvpd[PDX(PGADDR(0,pn,0))]&PTE_P) && (uvpd[PDX(PGADDR(0,pn,0))]&PTE_U)) 
  802083:	89 f2                	mov    %esi,%edx
  802085:	c1 e2 0c             	shl    $0xc,%edx
  802088:	89 d0                	mov    %edx,%eax
  80208a:	c1 e8 16             	shr    $0x16,%eax
  80208d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  802094:	f6 c1 01             	test   $0x1,%cl
  802097:	74 5b                	je     8020f4 <spawn+0x530>
  802099:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8020a0:	a8 04                	test   $0x4,%al
  8020a2:	74 50                	je     8020f4 <spawn+0x530>
				&& ((uvpt[pn]&PTE_P) && (uvpt[pn]&PTE_U) && (uvpt[pn]&PTE_SHARE))) {
  8020a4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8020ab:	a8 01                	test   $0x1,%al
  8020ad:	74 45                	je     8020f4 <spawn+0x530>
  8020af:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8020b6:	a8 04                	test   $0x4,%al
  8020b8:	74 3a                	je     8020f4 <spawn+0x530>
  8020ba:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8020c1:	f6 c4 04             	test   $0x4,%ah
  8020c4:	74 2e                	je     8020f4 <spawn+0x530>
			sys_page_map(0, (void *)PGADDR(0,pn,0), child, (void *)PGADDR(0,pn,0), uvpt[pn]&PTE_SYSCALL);
  8020c6:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8020cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8020d2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8020d6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8020da:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8020e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020e4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ef:	e8 07 f0 ff ff       	call   8010fb <sys_page_map>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  8020f4:	83 c6 01             	add    $0x1,%esi
  8020f7:	81 fe fe eb 0e 00    	cmp    $0xeebfe,%esi
  8020fd:	75 84                	jne    802083 <spawn+0x4bf>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8020ff:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802105:	89 44 24 04          	mov    %eax,0x4(%esp)
  802109:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80210f:	89 04 24             	mov    %eax,(%esp)
  802112:	e8 fe f0 ff ff       	call   801215 <sys_env_set_trapframe>
  802117:	85 c0                	test   %eax,%eax
  802119:	79 20                	jns    80213b <spawn+0x577>
		panic("sys_env_set_trapframe: %e", r);
  80211b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80211f:	c7 44 24 08 6e 30 80 	movl   $0x80306e,0x8(%esp)
  802126:	00 
  802127:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  80212e:	00 
  80212f:	c7 04 24 45 30 80 00 	movl   $0x803045,(%esp)
  802136:	e8 41 e3 ff ff       	call   80047c <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80213b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802142:	00 
  802143:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802149:	89 04 24             	mov    %eax,(%esp)
  80214c:	e8 66 f0 ff ff       	call   8011b7 <sys_env_set_status>
  802151:	85 c0                	test   %eax,%eax
  802153:	79 5a                	jns    8021af <spawn+0x5eb>
		panic("sys_env_set_status: %e", r);
  802155:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802159:	c7 44 24 08 88 30 80 	movl   $0x803088,0x8(%esp)
  802160:	00 
  802161:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  802168:	00 
  802169:	c7 04 24 45 30 80 00 	movl   $0x803045,(%esp)
  802170:	e8 07 e3 ff ff       	call   80047c <_panic>
  802175:	89 c6                	mov    %eax,%esi
  802177:	eb 06                	jmp    80217f <spawn+0x5bb>
  802179:	89 c6                	mov    %eax,%esi
  80217b:	eb 02                	jmp    80217f <spawn+0x5bb>
  80217d:	89 c6                	mov    %eax,%esi

	return child;

error:
	sys_env_destroy(child);
  80217f:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802185:	89 04 24             	mov    %eax,(%esp)
  802188:	e8 52 ee ff ff       	call   800fdf <sys_env_destroy>
	close(fd);
  80218d:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802193:	89 04 24             	mov    %eax,(%esp)
  802196:	e8 c2 f3 ff ff       	call   80155d <close>
	return r;
  80219b:	89 b5 84 fd ff ff    	mov    %esi,-0x27c(%ebp)
  8021a1:	eb 0c                	jmp    8021af <spawn+0x5eb>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  8021a3:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8021a9:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8021af:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8021b5:	81 c4 ac 02 00 00    	add    $0x2ac,%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5e                   	pop    %esi
  8021bd:	5f                   	pop    %edi
  8021be:	5d                   	pop    %ebp
  8021bf:	c3                   	ret    
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8021c0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  8021c5:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  8021cb:	eb e2                	jmp    8021af <spawn+0x5eb>

008021cd <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	83 ec 10             	sub    $0x10,%esp
  8021d5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8021d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8021db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021df:	74 66                	je     802247 <spawnl+0x7a>
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8021e1:	b9 00 00 00 00       	mov    $0x0,%ecx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  8021e6:	83 c1 01             	add    $0x1,%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8021e9:	89 c2                	mov    %eax,%edx
  8021eb:	83 c0 04             	add    $0x4,%eax
  8021ee:	83 3a 00             	cmpl   $0x0,(%edx)
  8021f1:	75 f3                	jne    8021e6 <spawnl+0x19>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8021f3:	8d 04 8d 26 00 00 00 	lea    0x26(,%ecx,4),%eax
  8021fa:	83 e0 f0             	and    $0xfffffff0,%eax
  8021fd:	29 c4                	sub    %eax,%esp
  8021ff:	8d 44 24 17          	lea    0x17(%esp),%eax
  802203:	83 e0 f0             	and    $0xfffffff0,%eax
  802206:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802208:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  80220a:	c7 44 88 04 00 00 00 	movl   $0x0,0x4(%eax,%ecx,4)
  802211:	00 

	va_start(vl, arg0);
  802212:	8d 55 10             	lea    0x10(%ebp),%edx
	unsigned i;
	for(i=0;i<argc;i++)
  802215:	89 ce                	mov    %ecx,%esi
  802217:	85 c9                	test   %ecx,%ecx
  802219:	74 16                	je     802231 <spawnl+0x64>
  80221b:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  802220:	83 c0 01             	add    $0x1,%eax
  802223:	89 d1                	mov    %edx,%ecx
  802225:	83 c2 04             	add    $0x4,%edx
  802228:	8b 09                	mov    (%ecx),%ecx
  80222a:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80222d:	39 f0                	cmp    %esi,%eax
  80222f:	75 ef                	jne    802220 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802231:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	89 04 24             	mov    %eax,(%esp)
  80223b:	e8 84 f9 ff ff       	call   801bc4 <spawn>
}
  802240:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802243:	5b                   	pop    %ebx
  802244:	5e                   	pop    %esi
  802245:	5d                   	pop    %ebp
  802246:	c3                   	ret    
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802247:	83 ec 20             	sub    $0x20,%esp
  80224a:	8d 44 24 17          	lea    0x17(%esp),%eax
  80224e:	83 e0 f0             	and    $0xfffffff0,%eax
  802251:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802253:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  802255:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80225c:	eb d3                	jmp    802231 <spawnl+0x64>
	...

00802260 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 18             	sub    $0x18,%esp
  802266:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802269:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80226c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	89 04 24             	mov    %eax,(%esp)
  802275:	e8 06 f1 ff ff       	call   801380 <fd2data>
  80227a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80227c:	c7 44 24 04 c8 30 80 	movl   $0x8030c8,0x4(%esp)
  802283:	00 
  802284:	89 34 24             	mov    %esi,(%esp)
  802287:	e8 0f e9 ff ff       	call   800b9b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80228c:	8b 43 04             	mov    0x4(%ebx),%eax
  80228f:	2b 03                	sub    (%ebx),%eax
  802291:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802297:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80229e:	00 00 00 
	stat->st_dev = &devpipe;
  8022a1:	c7 86 88 00 00 00 ac 	movl   $0x8057ac,0x88(%esi)
  8022a8:	57 80 00 
	return 0;
}
  8022ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8022b3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8022b6:	89 ec                	mov    %ebp,%esp
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    

008022ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	53                   	push   %ebx
  8022be:	83 ec 14             	sub    $0x14,%esp
  8022c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022cf:	e8 85 ee ff ff       	call   801159 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022d4:	89 1c 24             	mov    %ebx,(%esp)
  8022d7:	e8 a4 f0 ff ff       	call   801380 <fd2data>
  8022dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e7:	e8 6d ee ff ff       	call   801159 <sys_page_unmap>
}
  8022ec:	83 c4 14             	add    $0x14,%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5d                   	pop    %ebp
  8022f1:	c3                   	ret    

008022f2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	57                   	push   %edi
  8022f6:	56                   	push   %esi
  8022f7:	53                   	push   %ebx
  8022f8:	83 ec 2c             	sub    $0x2c,%esp
  8022fb:	89 c7                	mov    %eax,%edi
  8022fd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802300:	a1 90 77 80 00       	mov    0x807790,%eax
  802305:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802308:	89 3c 24             	mov    %edi,(%esp)
  80230b:	e8 b0 04 00 00       	call   8027c0 <pageref>
  802310:	89 c6                	mov    %eax,%esi
  802312:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802315:	89 04 24             	mov    %eax,(%esp)
  802318:	e8 a3 04 00 00       	call   8027c0 <pageref>
  80231d:	39 c6                	cmp    %eax,%esi
  80231f:	0f 94 c0             	sete   %al
  802322:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802325:	8b 15 90 77 80 00    	mov    0x807790,%edx
  80232b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80232e:	39 cb                	cmp    %ecx,%ebx
  802330:	75 08                	jne    80233a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  802332:	83 c4 2c             	add    $0x2c,%esp
  802335:	5b                   	pop    %ebx
  802336:	5e                   	pop    %esi
  802337:	5f                   	pop    %edi
  802338:	5d                   	pop    %ebp
  802339:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80233a:	83 f8 01             	cmp    $0x1,%eax
  80233d:	75 c1                	jne    802300 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80233f:	8b 52 58             	mov    0x58(%edx),%edx
  802342:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802346:	89 54 24 08          	mov    %edx,0x8(%esp)
  80234a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80234e:	c7 04 24 cf 30 80 00 	movl   $0x8030cf,(%esp)
  802355:	e8 1d e2 ff ff       	call   800577 <cprintf>
  80235a:	eb a4                	jmp    802300 <_pipeisclosed+0xe>

0080235c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	57                   	push   %edi
  802360:	56                   	push   %esi
  802361:	53                   	push   %ebx
  802362:	83 ec 2c             	sub    $0x2c,%esp
  802365:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802368:	89 34 24             	mov    %esi,(%esp)
  80236b:	e8 10 f0 ff ff       	call   801380 <fd2data>
  802370:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802372:	bf 00 00 00 00       	mov    $0x0,%edi
  802377:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80237b:	75 50                	jne    8023cd <devpipe_write+0x71>
  80237d:	eb 5c                	jmp    8023db <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80237f:	89 da                	mov    %ebx,%edx
  802381:	89 f0                	mov    %esi,%eax
  802383:	e8 6a ff ff ff       	call   8022f2 <_pipeisclosed>
  802388:	85 c0                	test   %eax,%eax
  80238a:	75 53                	jne    8023df <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80238c:	e8 db ec ff ff       	call   80106c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802391:	8b 43 04             	mov    0x4(%ebx),%eax
  802394:	8b 13                	mov    (%ebx),%edx
  802396:	83 c2 20             	add    $0x20,%edx
  802399:	39 d0                	cmp    %edx,%eax
  80239b:	73 e2                	jae    80237f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80239d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  8023a4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  8023a7:	89 c2                	mov    %eax,%edx
  8023a9:	c1 fa 1f             	sar    $0x1f,%edx
  8023ac:	c1 ea 1b             	shr    $0x1b,%edx
  8023af:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8023b2:	83 e1 1f             	and    $0x1f,%ecx
  8023b5:	29 d1                	sub    %edx,%ecx
  8023b7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8023bb:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8023bf:	83 c0 01             	add    $0x1,%eax
  8023c2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023c5:	83 c7 01             	add    $0x1,%edi
  8023c8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023cb:	74 0e                	je     8023db <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023cd:	8b 43 04             	mov    0x4(%ebx),%eax
  8023d0:	8b 13                	mov    (%ebx),%edx
  8023d2:	83 c2 20             	add    $0x20,%edx
  8023d5:	39 d0                	cmp    %edx,%eax
  8023d7:	73 a6                	jae    80237f <devpipe_write+0x23>
  8023d9:	eb c2                	jmp    80239d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8023db:	89 f8                	mov    %edi,%eax
  8023dd:	eb 05                	jmp    8023e4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8023e4:	83 c4 2c             	add    $0x2c,%esp
  8023e7:	5b                   	pop    %ebx
  8023e8:	5e                   	pop    %esi
  8023e9:	5f                   	pop    %edi
  8023ea:	5d                   	pop    %ebp
  8023eb:	c3                   	ret    

008023ec <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	83 ec 28             	sub    $0x28,%esp
  8023f2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8023f5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8023f8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8023fb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8023fe:	89 3c 24             	mov    %edi,(%esp)
  802401:	e8 7a ef ff ff       	call   801380 <fd2data>
  802406:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802408:	be 00 00 00 00       	mov    $0x0,%esi
  80240d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802411:	75 47                	jne    80245a <devpipe_read+0x6e>
  802413:	eb 52                	jmp    802467 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802415:	89 f0                	mov    %esi,%eax
  802417:	eb 5e                	jmp    802477 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802419:	89 da                	mov    %ebx,%edx
  80241b:	89 f8                	mov    %edi,%eax
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	e8 cd fe ff ff       	call   8022f2 <_pipeisclosed>
  802425:	85 c0                	test   %eax,%eax
  802427:	75 49                	jne    802472 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802429:	e8 3e ec ff ff       	call   80106c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80242e:	8b 03                	mov    (%ebx),%eax
  802430:	3b 43 04             	cmp    0x4(%ebx),%eax
  802433:	74 e4                	je     802419 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802435:	89 c2                	mov    %eax,%edx
  802437:	c1 fa 1f             	sar    $0x1f,%edx
  80243a:	c1 ea 1b             	shr    $0x1b,%edx
  80243d:	01 d0                	add    %edx,%eax
  80243f:	83 e0 1f             	and    $0x1f,%eax
  802442:	29 d0                	sub    %edx,%eax
  802444:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80244f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802452:	83 c6 01             	add    $0x1,%esi
  802455:	3b 75 10             	cmp    0x10(%ebp),%esi
  802458:	74 0d                	je     802467 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80245a:	8b 03                	mov    (%ebx),%eax
  80245c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80245f:	75 d4                	jne    802435 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802461:	85 f6                	test   %esi,%esi
  802463:	75 b0                	jne    802415 <devpipe_read+0x29>
  802465:	eb b2                	jmp    802419 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802467:	89 f0                	mov    %esi,%eax
  802469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802470:	eb 05                	jmp    802477 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802472:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802477:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80247a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80247d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802480:	89 ec                	mov    %ebp,%esp
  802482:	5d                   	pop    %ebp
  802483:	c3                   	ret    

00802484 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
  802487:	83 ec 48             	sub    $0x48,%esp
  80248a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80248d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802490:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802493:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802496:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802499:	89 04 24             	mov    %eax,(%esp)
  80249c:	e8 fa ee ff ff       	call   80139b <fd_alloc>
  8024a1:	89 c3                	mov    %eax,%ebx
  8024a3:	85 c0                	test   %eax,%eax
  8024a5:	0f 88 45 01 00 00    	js     8025f0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024ab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024b2:	00 
  8024b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c1:	e8 d6 eb ff ff       	call   80109c <sys_page_alloc>
  8024c6:	89 c3                	mov    %eax,%ebx
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	0f 88 20 01 00 00    	js     8025f0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8024d0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8024d3:	89 04 24             	mov    %eax,(%esp)
  8024d6:	e8 c0 ee ff ff       	call   80139b <fd_alloc>
  8024db:	89 c3                	mov    %eax,%ebx
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	0f 88 f8 00 00 00    	js     8025dd <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024e5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024ec:	00 
  8024ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024fb:	e8 9c eb ff ff       	call   80109c <sys_page_alloc>
  802500:	89 c3                	mov    %eax,%ebx
  802502:	85 c0                	test   %eax,%eax
  802504:	0f 88 d3 00 00 00    	js     8025dd <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80250a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250d:	89 04 24             	mov    %eax,(%esp)
  802510:	e8 6b ee ff ff       	call   801380 <fd2data>
  802515:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802517:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80251e:	00 
  80251f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802523:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80252a:	e8 6d eb ff ff       	call   80109c <sys_page_alloc>
  80252f:	89 c3                	mov    %eax,%ebx
  802531:	85 c0                	test   %eax,%eax
  802533:	0f 88 91 00 00 00    	js     8025ca <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802539:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80253c:	89 04 24             	mov    %eax,(%esp)
  80253f:	e8 3c ee ff ff       	call   801380 <fd2data>
  802544:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80254b:	00 
  80254c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802550:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802557:	00 
  802558:	89 74 24 04          	mov    %esi,0x4(%esp)
  80255c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802563:	e8 93 eb ff ff       	call   8010fb <sys_page_map>
  802568:	89 c3                	mov    %eax,%ebx
  80256a:	85 c0                	test   %eax,%eax
  80256c:	78 4c                	js     8025ba <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80256e:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  802574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802577:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802583:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  802589:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80258c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80258e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802591:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259b:	89 04 24             	mov    %eax,(%esp)
  80259e:	e8 cd ed ff ff       	call   801370 <fd2num>
  8025a3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8025a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a8:	89 04 24             	mov    %eax,(%esp)
  8025ab:	e8 c0 ed ff ff       	call   801370 <fd2num>
  8025b0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8025b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025b8:	eb 36                	jmp    8025f0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  8025ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c5:	e8 8f eb ff ff       	call   801159 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8025ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d8:	e8 7c eb ff ff       	call   801159 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8025dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025eb:	e8 69 eb ff ff       	call   801159 <sys_page_unmap>
    err:
	return r;
}
  8025f0:	89 d8                	mov    %ebx,%eax
  8025f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025f5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025fb:	89 ec                	mov    %ebp,%esp
  8025fd:	5d                   	pop    %ebp
  8025fe:	c3                   	ret    

008025ff <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
  802602:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802605:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	89 04 24             	mov    %eax,(%esp)
  802612:	e8 f7 ed ff ff       	call   80140e <fd_lookup>
  802617:	85 c0                	test   %eax,%eax
  802619:	78 15                	js     802630 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	89 04 24             	mov    %eax,(%esp)
  802621:	e8 5a ed ff ff       	call   801380 <fd2data>
	return _pipeisclosed(fd, p);
  802626:	89 c2                	mov    %eax,%edx
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	e8 c2 fc ff ff       	call   8022f2 <_pipeisclosed>
}
  802630:	c9                   	leave  
  802631:	c3                   	ret    
	...

00802634 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802634:	55                   	push   %ebp
  802635:	89 e5                	mov    %esp,%ebp
  802637:	56                   	push   %esi
  802638:	53                   	push   %ebx
  802639:	83 ec 10             	sub    $0x10,%esp
  80263c:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  80263f:	85 c0                	test   %eax,%eax
  802641:	75 24                	jne    802667 <wait+0x33>
  802643:	c7 44 24 0c e7 30 80 	movl   $0x8030e7,0xc(%esp)
  80264a:	00 
  80264b:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  802652:	00 
  802653:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  80265a:	00 
  80265b:	c7 04 24 f2 30 80 00 	movl   $0x8030f2,(%esp)
  802662:	e8 15 de ff ff       	call   80047c <_panic>
	e = &envs[ENVX(envid)];
  802667:	89 c3                	mov    %eax,%ebx
  802669:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80266f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802672:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802678:	8b 73 48             	mov    0x48(%ebx),%esi
  80267b:	39 c6                	cmp    %eax,%esi
  80267d:	75 1a                	jne    802699 <wait+0x65>
  80267f:	8b 43 54             	mov    0x54(%ebx),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 13                	je     802699 <wait+0x65>
		sys_yield();
  802686:	e8 e1 e9 ff ff       	call   80106c <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80268b:	8b 43 48             	mov    0x48(%ebx),%eax
  80268e:	39 f0                	cmp    %esi,%eax
  802690:	75 07                	jne    802699 <wait+0x65>
  802692:	8b 43 54             	mov    0x54(%ebx),%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	75 ed                	jne    802686 <wait+0x52>
		sys_yield();
}
  802699:	83 c4 10             	add    $0x10,%esp
  80269c:	5b                   	pop    %ebx
  80269d:	5e                   	pop    %esi
  80269e:	5d                   	pop    %ebp
  80269f:	c3                   	ret    

008026a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
  8026a3:	56                   	push   %esi
  8026a4:	53                   	push   %ebx
  8026a5:	83 ec 10             	sub    $0x10,%esp
  8026a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8026ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  8026b1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  8026b3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8026b8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  8026bb:	89 04 24             	mov    %eax,(%esp)
  8026be:	e8 42 ec ff ff       	call   801305 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  8026c3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  8026c8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	78 0e                	js     8026df <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  8026d1:	a1 90 77 80 00       	mov    0x807790,%eax
  8026d6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  8026d9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  8026dc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  8026df:	85 f6                	test   %esi,%esi
  8026e1:	74 02                	je     8026e5 <ipc_recv+0x45>
		*from_env_store = sender;
  8026e3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  8026e5:	85 db                	test   %ebx,%ebx
  8026e7:	74 02                	je     8026eb <ipc_recv+0x4b>
		*perm_store = perm;
  8026e9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  8026eb:	83 c4 10             	add    $0x10,%esp
  8026ee:	5b                   	pop    %ebx
  8026ef:	5e                   	pop    %esi
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    

008026f2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	57                   	push   %edi
  8026f6:	56                   	push   %esi
  8026f7:	53                   	push   %ebx
  8026f8:	83 ec 1c             	sub    $0x1c,%esp
  8026fb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8026fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802701:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  802704:	85 db                	test   %ebx,%ebx
  802706:	75 04                	jne    80270c <ipc_send+0x1a>
  802708:	85 f6                	test   %esi,%esi
  80270a:	75 15                	jne    802721 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80270c:	85 db                	test   %ebx,%ebx
  80270e:	74 16                	je     802726 <ipc_send+0x34>
  802710:	85 f6                	test   %esi,%esi
  802712:	0f 94 c0             	sete   %al
      pg = 0;
  802715:	84 c0                	test   %al,%al
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
  80271c:	0f 45 d8             	cmovne %eax,%ebx
  80271f:	eb 05                	jmp    802726 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802721:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802726:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80272a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80272e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	89 04 24             	mov    %eax,(%esp)
  802738:	e8 94 eb ff ff       	call   8012d1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80273d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802740:	75 07                	jne    802749 <ipc_send+0x57>
           sys_yield();
  802742:	e8 25 e9 ff ff       	call   80106c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  802747:	eb dd                	jmp    802726 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  802749:	85 c0                	test   %eax,%eax
  80274b:	90                   	nop
  80274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802750:	74 1c                	je     80276e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802752:	c7 44 24 08 fd 30 80 	movl   $0x8030fd,0x8(%esp)
  802759:	00 
  80275a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802761:	00 
  802762:	c7 04 24 07 31 80 00 	movl   $0x803107,(%esp)
  802769:	e8 0e dd ff ff       	call   80047c <_panic>
		}
    }
}
  80276e:	83 c4 1c             	add    $0x1c,%esp
  802771:	5b                   	pop    %ebx
  802772:	5e                   	pop    %esi
  802773:	5f                   	pop    %edi
  802774:	5d                   	pop    %ebp
  802775:	c3                   	ret    

00802776 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
  802779:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80277c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802781:	39 c8                	cmp    %ecx,%eax
  802783:	74 17                	je     80279c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802785:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80278a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80278d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802793:	8b 52 50             	mov    0x50(%edx),%edx
  802796:	39 ca                	cmp    %ecx,%edx
  802798:	75 14                	jne    8027ae <ipc_find_env+0x38>
  80279a:	eb 05                	jmp    8027a1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8027a1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8027a4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8027a9:	8b 40 40             	mov    0x40(%eax),%eax
  8027ac:	eb 0e                	jmp    8027bc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8027ae:	83 c0 01             	add    $0x1,%eax
  8027b1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027b6:	75 d2                	jne    80278a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8027b8:	66 b8 00 00          	mov    $0x0,%ax
}
  8027bc:	5d                   	pop    %ebp
  8027bd:	c3                   	ret    
	...

008027c0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027c6:	89 d0                	mov    %edx,%eax
  8027c8:	c1 e8 16             	shr    $0x16,%eax
  8027cb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027d2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027d7:	f6 c1 01             	test   $0x1,%cl
  8027da:	74 1d                	je     8027f9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8027dc:	c1 ea 0c             	shr    $0xc,%edx
  8027df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027e6:	f6 c2 01             	test   $0x1,%dl
  8027e9:	74 0e                	je     8027f9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027eb:	c1 ea 0c             	shr    $0xc,%edx
  8027ee:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027f5:	ef 
  8027f6:	0f b7 c0             	movzwl %ax,%eax
}
  8027f9:	5d                   	pop    %ebp
  8027fa:	c3                   	ret    
  8027fb:	00 00                	add    %al,(%eax)
  8027fd:	00 00                	add    %al,(%eax)
	...

00802800 <__udivdi3>:
  802800:	83 ec 1c             	sub    $0x1c,%esp
  802803:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802807:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80280b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80280f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802813:	89 74 24 10          	mov    %esi,0x10(%esp)
  802817:	8b 74 24 24          	mov    0x24(%esp),%esi
  80281b:	85 ff                	test   %edi,%edi
  80281d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802821:	89 44 24 08          	mov    %eax,0x8(%esp)
  802825:	89 cd                	mov    %ecx,%ebp
  802827:	89 44 24 04          	mov    %eax,0x4(%esp)
  80282b:	75 33                	jne    802860 <__udivdi3+0x60>
  80282d:	39 f1                	cmp    %esi,%ecx
  80282f:	77 57                	ja     802888 <__udivdi3+0x88>
  802831:	85 c9                	test   %ecx,%ecx
  802833:	75 0b                	jne    802840 <__udivdi3+0x40>
  802835:	b8 01 00 00 00       	mov    $0x1,%eax
  80283a:	31 d2                	xor    %edx,%edx
  80283c:	f7 f1                	div    %ecx
  80283e:	89 c1                	mov    %eax,%ecx
  802840:	89 f0                	mov    %esi,%eax
  802842:	31 d2                	xor    %edx,%edx
  802844:	f7 f1                	div    %ecx
  802846:	89 c6                	mov    %eax,%esi
  802848:	8b 44 24 04          	mov    0x4(%esp),%eax
  80284c:	f7 f1                	div    %ecx
  80284e:	89 f2                	mov    %esi,%edx
  802850:	8b 74 24 10          	mov    0x10(%esp),%esi
  802854:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802858:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80285c:	83 c4 1c             	add    $0x1c,%esp
  80285f:	c3                   	ret    
  802860:	31 d2                	xor    %edx,%edx
  802862:	31 c0                	xor    %eax,%eax
  802864:	39 f7                	cmp    %esi,%edi
  802866:	77 e8                	ja     802850 <__udivdi3+0x50>
  802868:	0f bd cf             	bsr    %edi,%ecx
  80286b:	83 f1 1f             	xor    $0x1f,%ecx
  80286e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802872:	75 2c                	jne    8028a0 <__udivdi3+0xa0>
  802874:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802878:	76 04                	jbe    80287e <__udivdi3+0x7e>
  80287a:	39 f7                	cmp    %esi,%edi
  80287c:	73 d2                	jae    802850 <__udivdi3+0x50>
  80287e:	31 d2                	xor    %edx,%edx
  802880:	b8 01 00 00 00       	mov    $0x1,%eax
  802885:	eb c9                	jmp    802850 <__udivdi3+0x50>
  802887:	90                   	nop
  802888:	89 f2                	mov    %esi,%edx
  80288a:	f7 f1                	div    %ecx
  80288c:	31 d2                	xor    %edx,%edx
  80288e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802892:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802896:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80289a:	83 c4 1c             	add    $0x1c,%esp
  80289d:	c3                   	ret    
  80289e:	66 90                	xchg   %ax,%ax
  8028a0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028a5:	b8 20 00 00 00       	mov    $0x20,%eax
  8028aa:	89 ea                	mov    %ebp,%edx
  8028ac:	2b 44 24 04          	sub    0x4(%esp),%eax
  8028b0:	d3 e7                	shl    %cl,%edi
  8028b2:	89 c1                	mov    %eax,%ecx
  8028b4:	d3 ea                	shr    %cl,%edx
  8028b6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028bb:	09 fa                	or     %edi,%edx
  8028bd:	89 f7                	mov    %esi,%edi
  8028bf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8028c3:	89 f2                	mov    %esi,%edx
  8028c5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8028c9:	d3 e5                	shl    %cl,%ebp
  8028cb:	89 c1                	mov    %eax,%ecx
  8028cd:	d3 ef                	shr    %cl,%edi
  8028cf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028d4:	d3 e2                	shl    %cl,%edx
  8028d6:	89 c1                	mov    %eax,%ecx
  8028d8:	d3 ee                	shr    %cl,%esi
  8028da:	09 d6                	or     %edx,%esi
  8028dc:	89 fa                	mov    %edi,%edx
  8028de:	89 f0                	mov    %esi,%eax
  8028e0:	f7 74 24 0c          	divl   0xc(%esp)
  8028e4:	89 d7                	mov    %edx,%edi
  8028e6:	89 c6                	mov    %eax,%esi
  8028e8:	f7 e5                	mul    %ebp
  8028ea:	39 d7                	cmp    %edx,%edi
  8028ec:	72 22                	jb     802910 <__udivdi3+0x110>
  8028ee:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8028f2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028f7:	d3 e5                	shl    %cl,%ebp
  8028f9:	39 c5                	cmp    %eax,%ebp
  8028fb:	73 04                	jae    802901 <__udivdi3+0x101>
  8028fd:	39 d7                	cmp    %edx,%edi
  8028ff:	74 0f                	je     802910 <__udivdi3+0x110>
  802901:	89 f0                	mov    %esi,%eax
  802903:	31 d2                	xor    %edx,%edx
  802905:	e9 46 ff ff ff       	jmp    802850 <__udivdi3+0x50>
  80290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802910:	8d 46 ff             	lea    -0x1(%esi),%eax
  802913:	31 d2                	xor    %edx,%edx
  802915:	8b 74 24 10          	mov    0x10(%esp),%esi
  802919:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80291d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802921:	83 c4 1c             	add    $0x1c,%esp
  802924:	c3                   	ret    
	...

00802930 <__umoddi3>:
  802930:	83 ec 1c             	sub    $0x1c,%esp
  802933:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802937:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80293b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80293f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802943:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802947:	8b 74 24 24          	mov    0x24(%esp),%esi
  80294b:	85 ed                	test   %ebp,%ebp
  80294d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802951:	89 44 24 08          	mov    %eax,0x8(%esp)
  802955:	89 cf                	mov    %ecx,%edi
  802957:	89 04 24             	mov    %eax,(%esp)
  80295a:	89 f2                	mov    %esi,%edx
  80295c:	75 1a                	jne    802978 <__umoddi3+0x48>
  80295e:	39 f1                	cmp    %esi,%ecx
  802960:	76 4e                	jbe    8029b0 <__umoddi3+0x80>
  802962:	f7 f1                	div    %ecx
  802964:	89 d0                	mov    %edx,%eax
  802966:	31 d2                	xor    %edx,%edx
  802968:	8b 74 24 10          	mov    0x10(%esp),%esi
  80296c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802970:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802974:	83 c4 1c             	add    $0x1c,%esp
  802977:	c3                   	ret    
  802978:	39 f5                	cmp    %esi,%ebp
  80297a:	77 54                	ja     8029d0 <__umoddi3+0xa0>
  80297c:	0f bd c5             	bsr    %ebp,%eax
  80297f:	83 f0 1f             	xor    $0x1f,%eax
  802982:	89 44 24 04          	mov    %eax,0x4(%esp)
  802986:	75 60                	jne    8029e8 <__umoddi3+0xb8>
  802988:	3b 0c 24             	cmp    (%esp),%ecx
  80298b:	0f 87 07 01 00 00    	ja     802a98 <__umoddi3+0x168>
  802991:	89 f2                	mov    %esi,%edx
  802993:	8b 34 24             	mov    (%esp),%esi
  802996:	29 ce                	sub    %ecx,%esi
  802998:	19 ea                	sbb    %ebp,%edx
  80299a:	89 34 24             	mov    %esi,(%esp)
  80299d:	8b 04 24             	mov    (%esp),%eax
  8029a0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8029a4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8029a8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8029ac:	83 c4 1c             	add    $0x1c,%esp
  8029af:	c3                   	ret    
  8029b0:	85 c9                	test   %ecx,%ecx
  8029b2:	75 0b                	jne    8029bf <__umoddi3+0x8f>
  8029b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8029b9:	31 d2                	xor    %edx,%edx
  8029bb:	f7 f1                	div    %ecx
  8029bd:	89 c1                	mov    %eax,%ecx
  8029bf:	89 f0                	mov    %esi,%eax
  8029c1:	31 d2                	xor    %edx,%edx
  8029c3:	f7 f1                	div    %ecx
  8029c5:	8b 04 24             	mov    (%esp),%eax
  8029c8:	f7 f1                	div    %ecx
  8029ca:	eb 98                	jmp    802964 <__umoddi3+0x34>
  8029cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029d0:	89 f2                	mov    %esi,%edx
  8029d2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8029d6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8029da:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8029de:	83 c4 1c             	add    $0x1c,%esp
  8029e1:	c3                   	ret    
  8029e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029e8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029ed:	89 e8                	mov    %ebp,%eax
  8029ef:	bd 20 00 00 00       	mov    $0x20,%ebp
  8029f4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8029f8:	89 fa                	mov    %edi,%edx
  8029fa:	d3 e0                	shl    %cl,%eax
  8029fc:	89 e9                	mov    %ebp,%ecx
  8029fe:	d3 ea                	shr    %cl,%edx
  802a00:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a05:	09 c2                	or     %eax,%edx
  802a07:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a0b:	89 14 24             	mov    %edx,(%esp)
  802a0e:	89 f2                	mov    %esi,%edx
  802a10:	d3 e7                	shl    %cl,%edi
  802a12:	89 e9                	mov    %ebp,%ecx
  802a14:	d3 ea                	shr    %cl,%edx
  802a16:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a1f:	d3 e6                	shl    %cl,%esi
  802a21:	89 e9                	mov    %ebp,%ecx
  802a23:	d3 e8                	shr    %cl,%eax
  802a25:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a2a:	09 f0                	or     %esi,%eax
  802a2c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802a30:	f7 34 24             	divl   (%esp)
  802a33:	d3 e6                	shl    %cl,%esi
  802a35:	89 74 24 08          	mov    %esi,0x8(%esp)
  802a39:	89 d6                	mov    %edx,%esi
  802a3b:	f7 e7                	mul    %edi
  802a3d:	39 d6                	cmp    %edx,%esi
  802a3f:	89 c1                	mov    %eax,%ecx
  802a41:	89 d7                	mov    %edx,%edi
  802a43:	72 3f                	jb     802a84 <__umoddi3+0x154>
  802a45:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802a49:	72 35                	jb     802a80 <__umoddi3+0x150>
  802a4b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a4f:	29 c8                	sub    %ecx,%eax
  802a51:	19 fe                	sbb    %edi,%esi
  802a53:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a58:	89 f2                	mov    %esi,%edx
  802a5a:	d3 e8                	shr    %cl,%eax
  802a5c:	89 e9                	mov    %ebp,%ecx
  802a5e:	d3 e2                	shl    %cl,%edx
  802a60:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a65:	09 d0                	or     %edx,%eax
  802a67:	89 f2                	mov    %esi,%edx
  802a69:	d3 ea                	shr    %cl,%edx
  802a6b:	8b 74 24 10          	mov    0x10(%esp),%esi
  802a6f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802a73:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802a77:	83 c4 1c             	add    $0x1c,%esp
  802a7a:	c3                   	ret    
  802a7b:	90                   	nop
  802a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a80:	39 d6                	cmp    %edx,%esi
  802a82:	75 c7                	jne    802a4b <__umoddi3+0x11b>
  802a84:	89 d7                	mov    %edx,%edi
  802a86:	89 c1                	mov    %eax,%ecx
  802a88:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  802a8c:	1b 3c 24             	sbb    (%esp),%edi
  802a8f:	eb ba                	jmp    802a4b <__umoddi3+0x11b>
  802a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a98:	39 f5                	cmp    %esi,%ebp
  802a9a:	0f 82 f1 fe ff ff    	jb     802991 <__umoddi3+0x61>
  802aa0:	e9 f8 fe ff ff       	jmp    80299d <__umoddi3+0x6d>
