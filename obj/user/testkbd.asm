
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 9f 02 00 00       	call   8002d0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	83 ec 14             	sub    $0x14,%esp
  80003b:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  800040:	e8 d7 0f 00 00       	call   80101c <sys_yield>
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800045:	83 eb 01             	sub    $0x1,%ebx
  800048:	75 f6                	jne    800040 <umain+0xc>
		sys_yield();

	close(0);
  80004a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800051:	e8 b7 14 00 00       	call   80150d <close>
	if ((r = opencons()) < 0)
  800056:	e8 22 02 00 00       	call   80027d <opencons>
  80005b:	85 c0                	test   %eax,%eax
  80005d:	79 20                	jns    80007f <umain+0x4b>
		panic("opencons: %e", r);
  80005f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800063:	c7 44 24 08 a0 24 80 	movl   $0x8024a0,0x8(%esp)
  80006a:	00 
  80006b:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800072:	00 
  800073:	c7 04 24 ad 24 80 00 	movl   $0x8024ad,(%esp)
  80007a:	e8 bd 02 00 00       	call   80033c <_panic>
	if (r != 0)
  80007f:	85 c0                	test   %eax,%eax
  800081:	74 20                	je     8000a3 <umain+0x6f>
		panic("first opencons used fd %d", r);
  800083:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800087:	c7 44 24 08 bc 24 80 	movl   $0x8024bc,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800096:	00 
  800097:	c7 04 24 ad 24 80 00 	movl   $0x8024ad,(%esp)
  80009e:	e8 99 02 00 00       	call   80033c <_panic>
	if ((r = dup(0, 1)) < 0)
  8000a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000aa:	00 
  8000ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b2:	e8 a9 14 00 00       	call   801560 <dup>
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	79 20                	jns    8000db <umain+0xa7>
		panic("dup: %e", r);
  8000bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000bf:	c7 44 24 08 d6 24 80 	movl   $0x8024d6,0x8(%esp)
  8000c6:	00 
  8000c7:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000ce:	00 
  8000cf:	c7 04 24 ad 24 80 00 	movl   $0x8024ad,(%esp)
  8000d6:	e8 61 02 00 00       	call   80033c <_panic>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  8000db:	c7 04 24 de 24 80 00 	movl   $0x8024de,(%esp)
  8000e2:	e8 29 09 00 00       	call   800a10 <readline>
		if (buf != NULL)
  8000e7:	85 c0                	test   %eax,%eax
  8000e9:	74 1a                	je     800105 <umain+0xd1>
			fprintf(1, "%s\n", buf);
  8000eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000ef:	c7 44 24 04 ec 24 80 	movl   $0x8024ec,0x4(%esp)
  8000f6:	00 
  8000f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000fe:	e8 65 1b 00 00       	call   801c68 <fprintf>
  800103:	eb d6                	jmp    8000db <umain+0xa7>
		else
			fprintf(1, "(end of file received)\n");
  800105:	c7 44 24 04 f0 24 80 	movl   $0x8024f0,0x4(%esp)
  80010c:	00 
  80010d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800114:	e8 4f 1b 00 00       	call   801c68 <fprintf>
  800119:	eb c0                	jmp    8000db <umain+0xa7>
  80011b:	00 00                	add    %al,(%eax)
  80011d:	00 00                	add    %al,(%eax)
	...

00800120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800123:	b8 00 00 00 00       	mov    $0x0,%eax
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800130:	c7 44 24 04 08 25 80 	movl   $0x802508,0x4(%esp)
  800137:	00 
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	89 04 24             	mov    %eax,(%esp)
  80013e:	e8 08 0a 00 00       	call   800b4b <strcpy>
	return 0;
}
  800143:	b8 00 00 00 00       	mov    $0x0,%eax
  800148:	c9                   	leave  
  800149:	c3                   	ret    

0080014a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800156:	be 00 00 00 00       	mov    $0x0,%esi
  80015b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80015f:	74 43                	je     8001a4 <devcons_write+0x5a>
  800161:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800166:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80016c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  800171:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800174:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800179:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80017c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800180:	03 45 0c             	add    0xc(%ebp),%eax
  800183:	89 44 24 04          	mov    %eax,0x4(%esp)
  800187:	89 3c 24             	mov    %edi,(%esp)
  80018a:	e8 ad 0b 00 00       	call   800d3c <memmove>
		sys_cputs(buf, m);
  80018f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800193:	89 3c 24             	mov    %edi,(%esp)
  800196:	e8 95 0d 00 00       	call   800f30 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80019b:	01 de                	add    %ebx,%esi
  80019d:	89 f0                	mov    %esi,%eax
  80019f:	3b 75 10             	cmp    0x10(%ebp),%esi
  8001a2:	72 c8                	jb     80016c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8001a4:	89 f0                	mov    %esi,%eax
  8001a6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8001ac:	5b                   	pop    %ebx
  8001ad:	5e                   	pop    %esi
  8001ae:	5f                   	pop    %edi
  8001af:	5d                   	pop    %ebp
  8001b0:	c3                   	ret    

008001b1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8001b7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8001bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8001c0:	75 07                	jne    8001c9 <devcons_read+0x18>
  8001c2:	eb 31                	jmp    8001f5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8001c4:	e8 53 0e 00 00       	call   80101c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8001c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8001d0:	e8 8a 0d 00 00       	call   800f5f <sys_cgetc>
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	74 eb                	je     8001c4 <devcons_read+0x13>
  8001d9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8001db:	85 c0                	test   %eax,%eax
  8001dd:	78 16                	js     8001f5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8001df:	83 f8 04             	cmp    $0x4,%eax
  8001e2:	74 0c                	je     8001f0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  8001e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e7:	88 10                	mov    %dl,(%eax)
	return 1;
  8001e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8001ee:	eb 05                	jmp    8001f5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8001f0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

008001f7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8001fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800200:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800203:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80020a:	00 
  80020b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80020e:	89 04 24             	mov    %eax,(%esp)
  800211:	e8 1a 0d 00 00       	call   800f30 <sys_cputs>
}
  800216:	c9                   	leave  
  800217:	c3                   	ret    

00800218 <getchar>:

int
getchar(void)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80021e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800225:	00 
  800226:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800229:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800234:	e8 45 14 00 00       	call   80167e <read>
	if (r < 0)
  800239:	85 c0                	test   %eax,%eax
  80023b:	78 0f                	js     80024c <getchar+0x34>
		return r;
	if (r < 1)
  80023d:	85 c0                	test   %eax,%eax
  80023f:	7e 06                	jle    800247 <getchar+0x2f>
		return -E_EOF;
	return c;
  800241:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800245:	eb 05                	jmp    80024c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800247:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80024c:	c9                   	leave  
  80024d:	c3                   	ret    

0080024e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025b:	8b 45 08             	mov    0x8(%ebp),%eax
  80025e:	89 04 24             	mov    %eax,(%esp)
  800261:	e8 58 11 00 00       	call   8013be <fd_lookup>
  800266:	85 c0                	test   %eax,%eax
  800268:	78 11                	js     80027b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80026a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026d:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800273:	39 10                	cmp    %edx,(%eax)
  800275:	0f 94 c0             	sete   %al
  800278:	0f b6 c0             	movzbl %al,%eax
}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <opencons>:

int
opencons(void)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800283:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800286:	89 04 24             	mov    %eax,(%esp)
  800289:	e8 bd 10 00 00       	call   80134b <fd_alloc>
  80028e:	85 c0                	test   %eax,%eax
  800290:	78 3c                	js     8002ce <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800292:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800299:	00 
  80029a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002a8:	e8 9f 0d 00 00       	call   80104c <sys_page_alloc>
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	78 1d                	js     8002ce <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8002b1:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002ba:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8002bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002bf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8002c6:	89 04 24             	mov    %eax,(%esp)
  8002c9:	e8 52 10 00 00       	call   801320 <fd2num>
}
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
  8002d6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8002d9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8002dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8002df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8002e2:	e8 05 0d 00 00       	call   800fec <sys_getenvid>
  8002e7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ec:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f4:	a3 04 44 80 00       	mov    %eax,0x804404
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f9:	85 f6                	test   %esi,%esi
  8002fb:	7e 07                	jle    800304 <libmain+0x34>
		binaryname = argv[0];
  8002fd:	8b 03                	mov    (%ebx),%eax
  8002ff:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  800304:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800308:	89 34 24             	mov    %esi,(%esp)
  80030b:	e8 24 fd ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800310:	e8 0b 00 00 00       	call   800320 <exit>
}
  800315:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800318:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80031b:	89 ec                	mov    %ebp,%esp
  80031d:	5d                   	pop    %ebp
  80031e:	c3                   	ret    
	...

00800320 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800326:	e8 13 12 00 00       	call   80153e <close_all>
	sys_env_destroy(0);
  80032b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800332:	e8 58 0c 00 00       	call   800f8f <sys_env_destroy>
}
  800337:	c9                   	leave  
  800338:	c3                   	ret    
  800339:	00 00                	add    %al,(%eax)
	...

0080033c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	56                   	push   %esi
  800340:	53                   	push   %ebx
  800341:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800344:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800347:	8b 1d 1c 30 80 00    	mov    0x80301c,%ebx
  80034d:	e8 9a 0c 00 00       	call   800fec <sys_getenvid>
  800352:	8b 55 0c             	mov    0xc(%ebp),%edx
  800355:	89 54 24 10          	mov    %edx,0x10(%esp)
  800359:	8b 55 08             	mov    0x8(%ebp),%edx
  80035c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800360:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800364:	89 44 24 04          	mov    %eax,0x4(%esp)
  800368:	c7 04 24 20 25 80 00 	movl   $0x802520,(%esp)
  80036f:	e8 c3 00 00 00       	call   800437 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800374:	89 74 24 04          	mov    %esi,0x4(%esp)
  800378:	8b 45 10             	mov    0x10(%ebp),%eax
  80037b:	89 04 24             	mov    %eax,(%esp)
  80037e:	e8 53 00 00 00       	call   8003d6 <vcprintf>
	cprintf("\n");
  800383:	c7 04 24 06 25 80 00 	movl   $0x802506,(%esp)
  80038a:	e8 a8 00 00 00       	call   800437 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80038f:	cc                   	int3   
  800390:	eb fd                	jmp    80038f <_panic+0x53>
	...

00800394 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	53                   	push   %ebx
  800398:	83 ec 14             	sub    $0x14,%esp
  80039b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80039e:	8b 03                	mov    (%ebx),%eax
  8003a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a3:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8003a7:	83 c0 01             	add    $0x1,%eax
  8003aa:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8003ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b1:	75 19                	jne    8003cc <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003b3:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003ba:	00 
  8003bb:	8d 43 08             	lea    0x8(%ebx),%eax
  8003be:	89 04 24             	mov    %eax,(%esp)
  8003c1:	e8 6a 0b 00 00       	call   800f30 <sys_cputs>
		b->idx = 0;
  8003c6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003cc:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003d0:	83 c4 14             	add    $0x14,%esp
  8003d3:	5b                   	pop    %ebx
  8003d4:	5d                   	pop    %ebp
  8003d5:	c3                   	ret    

008003d6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e6:	00 00 00 
	b.cnt = 0;
  8003e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  800401:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800407:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040b:	c7 04 24 94 03 80 00 	movl   $0x800394,(%esp)
  800412:	e8 a3 01 00 00       	call   8005ba <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800417:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80041d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800421:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800427:	89 04 24             	mov    %eax,(%esp)
  80042a:	e8 01 0b 00 00       	call   800f30 <sys_cputs>

	return b.cnt;
}
  80042f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800435:	c9                   	leave  
  800436:	c3                   	ret    

00800437 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800437:	55                   	push   %ebp
  800438:	89 e5                	mov    %esp,%ebp
  80043a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80043d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800440:	89 44 24 04          	mov    %eax,0x4(%esp)
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	89 04 24             	mov    %eax,(%esp)
  80044a:	e8 87 ff ff ff       	call   8003d6 <vcprintf>
	va_end(ap);

	return cnt;
}
  80044f:	c9                   	leave  
  800450:	c3                   	ret    
	...

00800460 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	57                   	push   %edi
  800464:	56                   	push   %esi
  800465:	53                   	push   %ebx
  800466:	83 ec 3c             	sub    $0x3c,%esp
  800469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046c:	89 d7                	mov    %edx,%edi
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800474:	8b 45 0c             	mov    0xc(%ebp),%eax
  800477:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80047a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80047d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800480:	b8 00 00 00 00       	mov    $0x0,%eax
  800485:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800488:	72 11                	jb     80049b <printnum+0x3b>
  80048a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80048d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800490:	76 09                	jbe    80049b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800492:	83 eb 01             	sub    $0x1,%ebx
  800495:	85 db                	test   %ebx,%ebx
  800497:	7f 51                	jg     8004ea <printnum+0x8a>
  800499:	eb 5e                	jmp    8004f9 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80049b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80049f:	83 eb 01             	sub    $0x1,%ebx
  8004a2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004ad:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8004b1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8004b5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004bc:	00 
  8004bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c0:	89 04 24             	mov    %eax,(%esp)
  8004c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ca:	e8 21 1d 00 00       	call   8021f0 <__udivdi3>
  8004cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8004d3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004d7:	89 04 24             	mov    %eax,(%esp)
  8004da:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004de:	89 fa                	mov    %edi,%edx
  8004e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004e3:	e8 78 ff ff ff       	call   800460 <printnum>
  8004e8:	eb 0f                	jmp    8004f9 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ee:	89 34 24             	mov    %esi,(%esp)
  8004f1:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004f4:	83 eb 01             	sub    $0x1,%ebx
  8004f7:	75 f1                	jne    8004ea <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fd:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800501:	8b 45 10             	mov    0x10(%ebp),%eax
  800504:	89 44 24 08          	mov    %eax,0x8(%esp)
  800508:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80050f:	00 
  800510:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800513:	89 04 24             	mov    %eax,(%esp)
  800516:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800519:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051d:	e8 fe 1d 00 00       	call   802320 <__umoddi3>
  800522:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800526:	0f be 80 43 25 80 00 	movsbl 0x802543(%eax),%eax
  80052d:	89 04 24             	mov    %eax,(%esp)
  800530:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800533:	83 c4 3c             	add    $0x3c,%esp
  800536:	5b                   	pop    %ebx
  800537:	5e                   	pop    %esi
  800538:	5f                   	pop    %edi
  800539:	5d                   	pop    %ebp
  80053a:	c3                   	ret    

0080053b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80053b:	55                   	push   %ebp
  80053c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80053e:	83 fa 01             	cmp    $0x1,%edx
  800541:	7e 0e                	jle    800551 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800543:	8b 10                	mov    (%eax),%edx
  800545:	8d 4a 08             	lea    0x8(%edx),%ecx
  800548:	89 08                	mov    %ecx,(%eax)
  80054a:	8b 02                	mov    (%edx),%eax
  80054c:	8b 52 04             	mov    0x4(%edx),%edx
  80054f:	eb 22                	jmp    800573 <getuint+0x38>
	else if (lflag)
  800551:	85 d2                	test   %edx,%edx
  800553:	74 10                	je     800565 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800555:	8b 10                	mov    (%eax),%edx
  800557:	8d 4a 04             	lea    0x4(%edx),%ecx
  80055a:	89 08                	mov    %ecx,(%eax)
  80055c:	8b 02                	mov    (%edx),%eax
  80055e:	ba 00 00 00 00       	mov    $0x0,%edx
  800563:	eb 0e                	jmp    800573 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800565:	8b 10                	mov    (%eax),%edx
  800567:	8d 4a 04             	lea    0x4(%edx),%ecx
  80056a:	89 08                	mov    %ecx,(%eax)
  80056c:	8b 02                	mov    (%edx),%eax
  80056e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800573:	5d                   	pop    %ebp
  800574:	c3                   	ret    

00800575 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80057b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80057f:	8b 10                	mov    (%eax),%edx
  800581:	3b 50 04             	cmp    0x4(%eax),%edx
  800584:	73 0a                	jae    800590 <sprintputch+0x1b>
		*b->buf++ = ch;
  800586:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800589:	88 0a                	mov    %cl,(%edx)
  80058b:	83 c2 01             	add    $0x1,%edx
  80058e:	89 10                	mov    %edx,(%eax)
}
  800590:	5d                   	pop    %ebp
  800591:	c3                   	ret    

00800592 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800598:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80059b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80059f:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b0:	89 04 24             	mov    %eax,(%esp)
  8005b3:	e8 02 00 00 00       	call   8005ba <vprintfmt>
	va_end(ap);
}
  8005b8:	c9                   	leave  
  8005b9:	c3                   	ret    

008005ba <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005ba:	55                   	push   %ebp
  8005bb:	89 e5                	mov    %esp,%ebp
  8005bd:	57                   	push   %edi
  8005be:	56                   	push   %esi
  8005bf:	53                   	push   %ebx
  8005c0:	83 ec 4c             	sub    $0x4c,%esp
  8005c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005c6:	8b 75 10             	mov    0x10(%ebp),%esi
  8005c9:	eb 12                	jmp    8005dd <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005cb:	85 c0                	test   %eax,%eax
  8005cd:	0f 84 a9 03 00 00    	je     80097c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  8005d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005d7:	89 04 24             	mov    %eax,(%esp)
  8005da:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005dd:	0f b6 06             	movzbl (%esi),%eax
  8005e0:	83 c6 01             	add    $0x1,%esi
  8005e3:	83 f8 25             	cmp    $0x25,%eax
  8005e6:	75 e3                	jne    8005cb <vprintfmt+0x11>
  8005e8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8005ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005f3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  8005f8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8005ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800604:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800607:	eb 2b                	jmp    800634 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800609:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80060c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800610:	eb 22                	jmp    800634 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800612:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800615:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800619:	eb 19                	jmp    800634 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80061e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800625:	eb 0d                	jmp    800634 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800627:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80062a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80062d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800634:	0f b6 06             	movzbl (%esi),%eax
  800637:	0f b6 d0             	movzbl %al,%edx
  80063a:	8d 7e 01             	lea    0x1(%esi),%edi
  80063d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800640:	83 e8 23             	sub    $0x23,%eax
  800643:	3c 55                	cmp    $0x55,%al
  800645:	0f 87 0b 03 00 00    	ja     800956 <vprintfmt+0x39c>
  80064b:	0f b6 c0             	movzbl %al,%eax
  80064e:	ff 24 85 80 26 80 00 	jmp    *0x802680(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800655:	83 ea 30             	sub    $0x30,%edx
  800658:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80065b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80065f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800662:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800665:	83 fa 09             	cmp    $0x9,%edx
  800668:	77 4a                	ja     8006b4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80066d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800670:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800673:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800677:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80067a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80067d:	83 fa 09             	cmp    $0x9,%edx
  800680:	76 eb                	jbe    80066d <vprintfmt+0xb3>
  800682:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800685:	eb 2d                	jmp    8006b4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 50 04             	lea    0x4(%eax),%edx
  80068d:	89 55 14             	mov    %edx,0x14(%ebp)
  800690:	8b 00                	mov    (%eax),%eax
  800692:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800695:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800698:	eb 1a                	jmp    8006b4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80069d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a1:	79 91                	jns    800634 <vprintfmt+0x7a>
  8006a3:	e9 73 ff ff ff       	jmp    80061b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8006ab:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006b2:	eb 80                	jmp    800634 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8006b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b8:	0f 89 76 ff ff ff    	jns    800634 <vprintfmt+0x7a>
  8006be:	e9 64 ff ff ff       	jmp    800627 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006c3:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c6:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006c9:	e9 66 ff ff ff       	jmp    800634 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8d 50 04             	lea    0x4(%eax),%edx
  8006d4:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	89 04 24             	mov    %eax,(%esp)
  8006e0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006e3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8006e6:	e9 f2 fe ff ff       	jmp    8005dd <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8d 50 04             	lea    0x4(%eax),%edx
  8006f1:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	89 c2                	mov    %eax,%edx
  8006f8:	c1 fa 1f             	sar    $0x1f,%edx
  8006fb:	31 d0                	xor    %edx,%eax
  8006fd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006ff:	83 f8 0f             	cmp    $0xf,%eax
  800702:	7f 0b                	jg     80070f <vprintfmt+0x155>
  800704:	8b 14 85 e0 27 80 00 	mov    0x8027e0(,%eax,4),%edx
  80070b:	85 d2                	test   %edx,%edx
  80070d:	75 23                	jne    800732 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80070f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800713:	c7 44 24 08 5b 25 80 	movl   $0x80255b,0x8(%esp)
  80071a:	00 
  80071b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80071f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800722:	89 3c 24             	mov    %edi,(%esp)
  800725:	e8 68 fe ff ff       	call   800592 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80072d:	e9 ab fe ff ff       	jmp    8005dd <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800732:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800736:	c7 44 24 08 25 29 80 	movl   $0x802925,0x8(%esp)
  80073d:	00 
  80073e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800742:	8b 7d 08             	mov    0x8(%ebp),%edi
  800745:	89 3c 24             	mov    %edi,(%esp)
  800748:	e8 45 fe ff ff       	call   800592 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800750:	e9 88 fe ff ff       	jmp    8005dd <vprintfmt+0x23>
  800755:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80075b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8d 50 04             	lea    0x4(%eax),%edx
  800764:	89 55 14             	mov    %edx,0x14(%ebp)
  800767:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800769:	85 f6                	test   %esi,%esi
  80076b:	ba 54 25 80 00       	mov    $0x802554,%edx
  800770:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800773:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800777:	7e 06                	jle    80077f <vprintfmt+0x1c5>
  800779:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80077d:	75 10                	jne    80078f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80077f:	0f be 06             	movsbl (%esi),%eax
  800782:	83 c6 01             	add    $0x1,%esi
  800785:	85 c0                	test   %eax,%eax
  800787:	0f 85 86 00 00 00    	jne    800813 <vprintfmt+0x259>
  80078d:	eb 76                	jmp    800805 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80078f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800793:	89 34 24             	mov    %esi,(%esp)
  800796:	e8 80 03 00 00       	call   800b1b <strnlen>
  80079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80079e:	29 c2                	sub    %eax,%edx
  8007a0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007a3:	85 d2                	test   %edx,%edx
  8007a5:	7e d8                	jle    80077f <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007a7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8007ab:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8007ae:	89 d6                	mov    %edx,%esi
  8007b0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8007b3:	89 c7                	mov    %eax,%edi
  8007b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007b9:	89 3c 24             	mov    %edi,(%esp)
  8007bc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007bf:	83 ee 01             	sub    $0x1,%esi
  8007c2:	75 f1                	jne    8007b5 <vprintfmt+0x1fb>
  8007c4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8007c7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8007ca:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8007cd:	eb b0                	jmp    80077f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007d3:	74 18                	je     8007ed <vprintfmt+0x233>
  8007d5:	8d 50 e0             	lea    -0x20(%eax),%edx
  8007d8:	83 fa 5e             	cmp    $0x5e,%edx
  8007db:	76 10                	jbe    8007ed <vprintfmt+0x233>
					putch('?', putdat);
  8007dd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007e1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007e8:	ff 55 08             	call   *0x8(%ebp)
  8007eb:	eb 0a                	jmp    8007f7 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  8007ed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007f1:	89 04 24             	mov    %eax,(%esp)
  8007f4:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f7:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8007fb:	0f be 06             	movsbl (%esi),%eax
  8007fe:	83 c6 01             	add    $0x1,%esi
  800801:	85 c0                	test   %eax,%eax
  800803:	75 0e                	jne    800813 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800805:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080c:	7f 16                	jg     800824 <vprintfmt+0x26a>
  80080e:	e9 ca fd ff ff       	jmp    8005dd <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800813:	85 ff                	test   %edi,%edi
  800815:	78 b8                	js     8007cf <vprintfmt+0x215>
  800817:	83 ef 01             	sub    $0x1,%edi
  80081a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800820:	79 ad                	jns    8007cf <vprintfmt+0x215>
  800822:	eb e1                	jmp    800805 <vprintfmt+0x24b>
  800824:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800827:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80082a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80082e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800835:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800837:	83 ee 01             	sub    $0x1,%esi
  80083a:	75 ee                	jne    80082a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80083c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80083f:	e9 99 fd ff ff       	jmp    8005dd <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800844:	83 f9 01             	cmp    $0x1,%ecx
  800847:	7e 10                	jle    800859 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8d 50 08             	lea    0x8(%eax),%edx
  80084f:	89 55 14             	mov    %edx,0x14(%ebp)
  800852:	8b 30                	mov    (%eax),%esi
  800854:	8b 78 04             	mov    0x4(%eax),%edi
  800857:	eb 26                	jmp    80087f <vprintfmt+0x2c5>
	else if (lflag)
  800859:	85 c9                	test   %ecx,%ecx
  80085b:	74 12                	je     80086f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	8d 50 04             	lea    0x4(%eax),%edx
  800863:	89 55 14             	mov    %edx,0x14(%ebp)
  800866:	8b 30                	mov    (%eax),%esi
  800868:	89 f7                	mov    %esi,%edi
  80086a:	c1 ff 1f             	sar    $0x1f,%edi
  80086d:	eb 10                	jmp    80087f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	8d 50 04             	lea    0x4(%eax),%edx
  800875:	89 55 14             	mov    %edx,0x14(%ebp)
  800878:	8b 30                	mov    (%eax),%esi
  80087a:	89 f7                	mov    %esi,%edi
  80087c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80087f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800884:	85 ff                	test   %edi,%edi
  800886:	0f 89 8c 00 00 00    	jns    800918 <vprintfmt+0x35e>
				putch('-', putdat);
  80088c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800890:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800897:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80089a:	f7 de                	neg    %esi
  80089c:	83 d7 00             	adc    $0x0,%edi
  80089f:	f7 df                	neg    %edi
			}
			base = 10;
  8008a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008a6:	eb 70                	jmp    800918 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008a8:	89 ca                	mov    %ecx,%edx
  8008aa:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ad:	e8 89 fc ff ff       	call   80053b <getuint>
  8008b2:	89 c6                	mov    %eax,%esi
  8008b4:	89 d7                	mov    %edx,%edi
			base = 10;
  8008b6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8008bb:	eb 5b                	jmp    800918 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8008bd:	89 ca                	mov    %ecx,%edx
  8008bf:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c2:	e8 74 fc ff ff       	call   80053b <getuint>
  8008c7:	89 c6                	mov    %eax,%esi
  8008c9:	89 d7                	mov    %edx,%edi
			base = 8;
  8008cb:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8008d0:	eb 46                	jmp    800918 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  8008d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008d6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008dd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8008e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008e4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8008eb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8008ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f1:	8d 50 04             	lea    0x4(%eax),%edx
  8008f4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008f7:	8b 30                	mov    (%eax),%esi
  8008f9:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8008fe:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800903:	eb 13                	jmp    800918 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800905:	89 ca                	mov    %ecx,%edx
  800907:	8d 45 14             	lea    0x14(%ebp),%eax
  80090a:	e8 2c fc ff ff       	call   80053b <getuint>
  80090f:	89 c6                	mov    %eax,%esi
  800911:	89 d7                	mov    %edx,%edi
			base = 16;
  800913:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800918:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80091c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800920:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800923:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800927:	89 44 24 08          	mov    %eax,0x8(%esp)
  80092b:	89 34 24             	mov    %esi,(%esp)
  80092e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800932:	89 da                	mov    %ebx,%edx
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	e8 24 fb ff ff       	call   800460 <printnum>
			break;
  80093c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80093f:	e9 99 fc ff ff       	jmp    8005dd <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800944:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800948:	89 14 24             	mov    %edx,(%esp)
  80094b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80094e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800951:	e9 87 fc ff ff       	jmp    8005dd <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800956:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80095a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800961:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800964:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800968:	0f 84 6f fc ff ff    	je     8005dd <vprintfmt+0x23>
  80096e:	83 ee 01             	sub    $0x1,%esi
  800971:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800975:	75 f7                	jne    80096e <vprintfmt+0x3b4>
  800977:	e9 61 fc ff ff       	jmp    8005dd <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80097c:	83 c4 4c             	add    $0x4c,%esp
  80097f:	5b                   	pop    %ebx
  800980:	5e                   	pop    %esi
  800981:	5f                   	pop    %edi
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	83 ec 28             	sub    $0x28,%esp
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800990:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800993:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800997:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80099a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a1:	85 c0                	test   %eax,%eax
  8009a3:	74 30                	je     8009d5 <vsnprintf+0x51>
  8009a5:	85 d2                	test   %edx,%edx
  8009a7:	7e 2c                	jle    8009d5 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009b7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009be:	c7 04 24 75 05 80 00 	movl   $0x800575,(%esp)
  8009c5:	e8 f0 fb ff ff       	call   8005ba <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009cd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d3:	eb 05                	jmp    8009da <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8009d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8009da:	c9                   	leave  
  8009db:	c3                   	ret    

008009dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	89 04 24             	mov    %eax,(%esp)
  8009fd:	e8 82 ff ff ff       	call   800984 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a02:	c9                   	leave  
  800a03:	c3                   	ret    
	...

00800a10 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	57                   	push   %edi
  800a14:	56                   	push   %esi
  800a15:	53                   	push   %ebx
  800a16:	83 ec 1c             	sub    $0x1c,%esp
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a1c:	85 c0                	test   %eax,%eax
  800a1e:	74 18                	je     800a38 <readline+0x28>
		fprintf(1, "%s", prompt);
  800a20:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a24:	c7 44 24 04 25 29 80 	movl   $0x802925,0x4(%esp)
  800a2b:	00 
  800a2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a33:	e8 30 12 00 00       	call   801c68 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  800a38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a3f:	e8 0a f8 ff ff       	call   80024e <iscons>
  800a44:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  800a46:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  800a4b:	e8 c8 f7 ff ff       	call   800218 <getchar>
  800a50:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800a52:	85 c0                	test   %eax,%eax
  800a54:	79 25                	jns    800a7b <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  800a5b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800a5e:	0f 84 88 00 00 00    	je     800aec <readline+0xdc>
				cprintf("read error: %e\n", c);
  800a64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a68:	c7 04 24 3f 28 80 00 	movl   $0x80283f,(%esp)
  800a6f:	e8 c3 f9 ff ff       	call   800437 <cprintf>
			return NULL;
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	eb 71                	jmp    800aec <readline+0xdc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800a7b:	83 f8 08             	cmp    $0x8,%eax
  800a7e:	74 05                	je     800a85 <readline+0x75>
  800a80:	83 f8 7f             	cmp    $0x7f,%eax
  800a83:	75 19                	jne    800a9e <readline+0x8e>
  800a85:	85 f6                	test   %esi,%esi
  800a87:	7e 15                	jle    800a9e <readline+0x8e>
			if (echoing)
  800a89:	85 ff                	test   %edi,%edi
  800a8b:	74 0c                	je     800a99 <readline+0x89>
				cputchar('\b');
  800a8d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800a94:	e8 5e f7 ff ff       	call   8001f7 <cputchar>
			i--;
  800a99:	83 ee 01             	sub    $0x1,%esi
  800a9c:	eb ad                	jmp    800a4b <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a9e:	83 fb 1f             	cmp    $0x1f,%ebx
  800aa1:	7e 1f                	jle    800ac2 <readline+0xb2>
  800aa3:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800aa9:	7f 17                	jg     800ac2 <readline+0xb2>
			if (echoing)
  800aab:	85 ff                	test   %edi,%edi
  800aad:	74 08                	je     800ab7 <readline+0xa7>
				cputchar(c);
  800aaf:	89 1c 24             	mov    %ebx,(%esp)
  800ab2:	e8 40 f7 ff ff       	call   8001f7 <cputchar>
			buf[i++] = c;
  800ab7:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800abd:	83 c6 01             	add    $0x1,%esi
  800ac0:	eb 89                	jmp    800a4b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  800ac2:	83 fb 0a             	cmp    $0xa,%ebx
  800ac5:	74 09                	je     800ad0 <readline+0xc0>
  800ac7:	83 fb 0d             	cmp    $0xd,%ebx
  800aca:	0f 85 7b ff ff ff    	jne    800a4b <readline+0x3b>
			if (echoing)
  800ad0:	85 ff                	test   %edi,%edi
  800ad2:	74 0c                	je     800ae0 <readline+0xd0>
				cputchar('\n');
  800ad4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800adb:	e8 17 f7 ff ff       	call   8001f7 <cputchar>
			buf[i] = 0;
  800ae0:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800ae7:	b8 00 40 80 00       	mov    $0x804000,%eax
		}
	}
}
  800aec:	83 c4 1c             	add    $0x1c,%esp
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    
	...

00800b00 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b06:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b0e:	74 09                	je     800b19 <strlen+0x19>
		n++;
  800b10:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b17:	75 f7                	jne    800b10 <strlen+0x10>
		n++;
	return n;
}
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	53                   	push   %ebx
  800b1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b25:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2a:	85 c9                	test   %ecx,%ecx
  800b2c:	74 1a                	je     800b48 <strnlen+0x2d>
  800b2e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800b31:	74 15                	je     800b48 <strnlen+0x2d>
  800b33:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800b38:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b3a:	39 ca                	cmp    %ecx,%edx
  800b3c:	74 0a                	je     800b48 <strnlen+0x2d>
  800b3e:	83 c2 01             	add    $0x1,%edx
  800b41:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800b46:	75 f0                	jne    800b38 <strnlen+0x1d>
		n++;
	return n;
}
  800b48:	5b                   	pop    %ebx
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	53                   	push   %ebx
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b55:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b5e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b61:	83 c2 01             	add    $0x1,%edx
  800b64:	84 c9                	test   %cl,%cl
  800b66:	75 f2                	jne    800b5a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b68:	5b                   	pop    %ebx
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	53                   	push   %ebx
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b75:	89 1c 24             	mov    %ebx,(%esp)
  800b78:	e8 83 ff ff ff       	call   800b00 <strlen>
	strcpy(dst + len, src);
  800b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b80:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b84:	01 d8                	add    %ebx,%eax
  800b86:	89 04 24             	mov    %eax,(%esp)
  800b89:	e8 bd ff ff ff       	call   800b4b <strcpy>
	return dst;
}
  800b8e:	89 d8                	mov    %ebx,%eax
  800b90:	83 c4 08             	add    $0x8,%esp
  800b93:	5b                   	pop    %ebx
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	56                   	push   %esi
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba4:	85 f6                	test   %esi,%esi
  800ba6:	74 18                	je     800bc0 <strncpy+0x2a>
  800ba8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800bad:	0f b6 1a             	movzbl (%edx),%ebx
  800bb0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bb3:	80 3a 01             	cmpb   $0x1,(%edx)
  800bb6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bb9:	83 c1 01             	add    $0x1,%ecx
  800bbc:	39 f1                	cmp    %esi,%ecx
  800bbe:	75 ed                	jne    800bad <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	57                   	push   %edi
  800bc8:	56                   	push   %esi
  800bc9:	53                   	push   %ebx
  800bca:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bcd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bd0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bd3:	89 f8                	mov    %edi,%eax
  800bd5:	85 f6                	test   %esi,%esi
  800bd7:	74 2b                	je     800c04 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800bd9:	83 fe 01             	cmp    $0x1,%esi
  800bdc:	74 23                	je     800c01 <strlcpy+0x3d>
  800bde:	0f b6 0b             	movzbl (%ebx),%ecx
  800be1:	84 c9                	test   %cl,%cl
  800be3:	74 1c                	je     800c01 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800be5:	83 ee 02             	sub    $0x2,%esi
  800be8:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800bed:	88 08                	mov    %cl,(%eax)
  800bef:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bf2:	39 f2                	cmp    %esi,%edx
  800bf4:	74 0b                	je     800c01 <strlcpy+0x3d>
  800bf6:	83 c2 01             	add    $0x1,%edx
  800bf9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bfd:	84 c9                	test   %cl,%cl
  800bff:	75 ec                	jne    800bed <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800c01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c04:	29 f8                	sub    %edi,%eax
}
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5f                   	pop    %edi
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c14:	0f b6 01             	movzbl (%ecx),%eax
  800c17:	84 c0                	test   %al,%al
  800c19:	74 16                	je     800c31 <strcmp+0x26>
  800c1b:	3a 02                	cmp    (%edx),%al
  800c1d:	75 12                	jne    800c31 <strcmp+0x26>
		p++, q++;
  800c1f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c22:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800c26:	84 c0                	test   %al,%al
  800c28:	74 07                	je     800c31 <strcmp+0x26>
  800c2a:	83 c1 01             	add    $0x1,%ecx
  800c2d:	3a 02                	cmp    (%edx),%al
  800c2f:	74 ee                	je     800c1f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c31:	0f b6 c0             	movzbl %al,%eax
  800c34:	0f b6 12             	movzbl (%edx),%edx
  800c37:	29 d0                	sub    %edx,%eax
}
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	53                   	push   %ebx
  800c3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c45:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c48:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c4d:	85 d2                	test   %edx,%edx
  800c4f:	74 28                	je     800c79 <strncmp+0x3e>
  800c51:	0f b6 01             	movzbl (%ecx),%eax
  800c54:	84 c0                	test   %al,%al
  800c56:	74 24                	je     800c7c <strncmp+0x41>
  800c58:	3a 03                	cmp    (%ebx),%al
  800c5a:	75 20                	jne    800c7c <strncmp+0x41>
  800c5c:	83 ea 01             	sub    $0x1,%edx
  800c5f:	74 13                	je     800c74 <strncmp+0x39>
		n--, p++, q++;
  800c61:	83 c1 01             	add    $0x1,%ecx
  800c64:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c67:	0f b6 01             	movzbl (%ecx),%eax
  800c6a:	84 c0                	test   %al,%al
  800c6c:	74 0e                	je     800c7c <strncmp+0x41>
  800c6e:	3a 03                	cmp    (%ebx),%al
  800c70:	74 ea                	je     800c5c <strncmp+0x21>
  800c72:	eb 08                	jmp    800c7c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c79:	5b                   	pop    %ebx
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c7c:	0f b6 01             	movzbl (%ecx),%eax
  800c7f:	0f b6 13             	movzbl (%ebx),%edx
  800c82:	29 d0                	sub    %edx,%eax
  800c84:	eb f3                	jmp    800c79 <strncmp+0x3e>

00800c86 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c90:	0f b6 10             	movzbl (%eax),%edx
  800c93:	84 d2                	test   %dl,%dl
  800c95:	74 1c                	je     800cb3 <strchr+0x2d>
		if (*s == c)
  800c97:	38 ca                	cmp    %cl,%dl
  800c99:	75 09                	jne    800ca4 <strchr+0x1e>
  800c9b:	eb 1b                	jmp    800cb8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c9d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800ca0:	38 ca                	cmp    %cl,%dl
  800ca2:	74 14                	je     800cb8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ca4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800ca8:	84 d2                	test   %dl,%dl
  800caa:	75 f1                	jne    800c9d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800cac:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb1:	eb 05                	jmp    800cb8 <strchr+0x32>
  800cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc4:	0f b6 10             	movzbl (%eax),%edx
  800cc7:	84 d2                	test   %dl,%dl
  800cc9:	74 14                	je     800cdf <strfind+0x25>
		if (*s == c)
  800ccb:	38 ca                	cmp    %cl,%dl
  800ccd:	75 06                	jne    800cd5 <strfind+0x1b>
  800ccf:	eb 0e                	jmp    800cdf <strfind+0x25>
  800cd1:	38 ca                	cmp    %cl,%dl
  800cd3:	74 0a                	je     800cdf <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd5:	83 c0 01             	add    $0x1,%eax
  800cd8:	0f b6 10             	movzbl (%eax),%edx
  800cdb:	84 d2                	test   %dl,%dl
  800cdd:	75 f2                	jne    800cd1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    

00800ce1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	83 ec 0c             	sub    $0xc,%esp
  800ce7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cea:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ced:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800cf0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cf9:	85 c9                	test   %ecx,%ecx
  800cfb:	74 30                	je     800d2d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cfd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d03:	75 25                	jne    800d2a <memset+0x49>
  800d05:	f6 c1 03             	test   $0x3,%cl
  800d08:	75 20                	jne    800d2a <memset+0x49>
		c &= 0xFF;
  800d0a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d0d:	89 d3                	mov    %edx,%ebx
  800d0f:	c1 e3 08             	shl    $0x8,%ebx
  800d12:	89 d6                	mov    %edx,%esi
  800d14:	c1 e6 18             	shl    $0x18,%esi
  800d17:	89 d0                	mov    %edx,%eax
  800d19:	c1 e0 10             	shl    $0x10,%eax
  800d1c:	09 f0                	or     %esi,%eax
  800d1e:	09 d0                	or     %edx,%eax
  800d20:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d22:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800d25:	fc                   	cld    
  800d26:	f3 ab                	rep stos %eax,%es:(%edi)
  800d28:	eb 03                	jmp    800d2d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d2a:	fc                   	cld    
  800d2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d2d:	89 f8                	mov    %edi,%eax
  800d2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d38:	89 ec                	mov    %ebp,%esp
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 08             	sub    $0x8,%esp
  800d42:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d45:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d51:	39 c6                	cmp    %eax,%esi
  800d53:	73 36                	jae    800d8b <memmove+0x4f>
  800d55:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d58:	39 d0                	cmp    %edx,%eax
  800d5a:	73 2f                	jae    800d8b <memmove+0x4f>
		s += n;
		d += n;
  800d5c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d5f:	f6 c2 03             	test   $0x3,%dl
  800d62:	75 1b                	jne    800d7f <memmove+0x43>
  800d64:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d6a:	75 13                	jne    800d7f <memmove+0x43>
  800d6c:	f6 c1 03             	test   $0x3,%cl
  800d6f:	75 0e                	jne    800d7f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d71:	83 ef 04             	sub    $0x4,%edi
  800d74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800d7a:	fd                   	std    
  800d7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d7d:	eb 09                	jmp    800d88 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d7f:	83 ef 01             	sub    $0x1,%edi
  800d82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d85:	fd                   	std    
  800d86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d88:	fc                   	cld    
  800d89:	eb 20                	jmp    800dab <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d8b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d91:	75 13                	jne    800da6 <memmove+0x6a>
  800d93:	a8 03                	test   $0x3,%al
  800d95:	75 0f                	jne    800da6 <memmove+0x6a>
  800d97:	f6 c1 03             	test   $0x3,%cl
  800d9a:	75 0a                	jne    800da6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d9c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800d9f:	89 c7                	mov    %eax,%edi
  800da1:	fc                   	cld    
  800da2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800da4:	eb 05                	jmp    800dab <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800da6:	89 c7                	mov    %eax,%edi
  800da8:	fc                   	cld    
  800da9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800db1:	89 ec                	mov    %ebp,%esp
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	89 04 24             	mov    %eax,(%esp)
  800dcf:	e8 68 ff ff ff       	call   800d3c <memmove>
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
  800ddc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ddf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800de2:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800de5:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dea:	85 ff                	test   %edi,%edi
  800dec:	74 37                	je     800e25 <memcmp+0x4f>
		if (*s1 != *s2)
  800dee:	0f b6 03             	movzbl (%ebx),%eax
  800df1:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800df4:	83 ef 01             	sub    $0x1,%edi
  800df7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800dfc:	38 c8                	cmp    %cl,%al
  800dfe:	74 1c                	je     800e1c <memcmp+0x46>
  800e00:	eb 10                	jmp    800e12 <memcmp+0x3c>
  800e02:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800e07:	83 c2 01             	add    $0x1,%edx
  800e0a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800e0e:	38 c8                	cmp    %cl,%al
  800e10:	74 0a                	je     800e1c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800e12:	0f b6 c0             	movzbl %al,%eax
  800e15:	0f b6 c9             	movzbl %cl,%ecx
  800e18:	29 c8                	sub    %ecx,%eax
  800e1a:	eb 09                	jmp    800e25 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e1c:	39 fa                	cmp    %edi,%edx
  800e1e:	75 e2                	jne    800e02 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800e30:	89 c2                	mov    %eax,%edx
  800e32:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e35:	39 d0                	cmp    %edx,%eax
  800e37:	73 19                	jae    800e52 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e39:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800e3d:	38 08                	cmp    %cl,(%eax)
  800e3f:	75 06                	jne    800e47 <memfind+0x1d>
  800e41:	eb 0f                	jmp    800e52 <memfind+0x28>
  800e43:	38 08                	cmp    %cl,(%eax)
  800e45:	74 0b                	je     800e52 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e47:	83 c0 01             	add    $0x1,%eax
  800e4a:	39 d0                	cmp    %edx,%eax
  800e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e50:	75 f1                	jne    800e43 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e60:	0f b6 02             	movzbl (%edx),%eax
  800e63:	3c 20                	cmp    $0x20,%al
  800e65:	74 04                	je     800e6b <strtol+0x17>
  800e67:	3c 09                	cmp    $0x9,%al
  800e69:	75 0e                	jne    800e79 <strtol+0x25>
		s++;
  800e6b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6e:	0f b6 02             	movzbl (%edx),%eax
  800e71:	3c 20                	cmp    $0x20,%al
  800e73:	74 f6                	je     800e6b <strtol+0x17>
  800e75:	3c 09                	cmp    $0x9,%al
  800e77:	74 f2                	je     800e6b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e79:	3c 2b                	cmp    $0x2b,%al
  800e7b:	75 0a                	jne    800e87 <strtol+0x33>
		s++;
  800e7d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800e80:	bf 00 00 00 00       	mov    $0x0,%edi
  800e85:	eb 10                	jmp    800e97 <strtol+0x43>
  800e87:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800e8c:	3c 2d                	cmp    $0x2d,%al
  800e8e:	75 07                	jne    800e97 <strtol+0x43>
		s++, neg = 1;
  800e90:	83 c2 01             	add    $0x1,%edx
  800e93:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e97:	85 db                	test   %ebx,%ebx
  800e99:	0f 94 c0             	sete   %al
  800e9c:	74 05                	je     800ea3 <strtol+0x4f>
  800e9e:	83 fb 10             	cmp    $0x10,%ebx
  800ea1:	75 15                	jne    800eb8 <strtol+0x64>
  800ea3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ea6:	75 10                	jne    800eb8 <strtol+0x64>
  800ea8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800eac:	75 0a                	jne    800eb8 <strtol+0x64>
		s += 2, base = 16;
  800eae:	83 c2 02             	add    $0x2,%edx
  800eb1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800eb6:	eb 13                	jmp    800ecb <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800eb8:	84 c0                	test   %al,%al
  800eba:	74 0f                	je     800ecb <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ebc:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ec1:	80 3a 30             	cmpb   $0x30,(%edx)
  800ec4:	75 05                	jne    800ecb <strtol+0x77>
		s++, base = 8;
  800ec6:	83 c2 01             	add    $0x1,%edx
  800ec9:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ed2:	0f b6 0a             	movzbl (%edx),%ecx
  800ed5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ed8:	80 fb 09             	cmp    $0x9,%bl
  800edb:	77 08                	ja     800ee5 <strtol+0x91>
			dig = *s - '0';
  800edd:	0f be c9             	movsbl %cl,%ecx
  800ee0:	83 e9 30             	sub    $0x30,%ecx
  800ee3:	eb 1e                	jmp    800f03 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800ee5:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800ee8:	80 fb 19             	cmp    $0x19,%bl
  800eeb:	77 08                	ja     800ef5 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800eed:	0f be c9             	movsbl %cl,%ecx
  800ef0:	83 e9 57             	sub    $0x57,%ecx
  800ef3:	eb 0e                	jmp    800f03 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800ef5:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800ef8:	80 fb 19             	cmp    $0x19,%bl
  800efb:	77 14                	ja     800f11 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800efd:	0f be c9             	movsbl %cl,%ecx
  800f00:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f03:	39 f1                	cmp    %esi,%ecx
  800f05:	7d 0e                	jge    800f15 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f07:	83 c2 01             	add    $0x1,%edx
  800f0a:	0f af c6             	imul   %esi,%eax
  800f0d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800f0f:	eb c1                	jmp    800ed2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800f11:	89 c1                	mov    %eax,%ecx
  800f13:	eb 02                	jmp    800f17 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f15:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f1b:	74 05                	je     800f22 <strtol+0xce>
		*endptr = (char *) s;
  800f1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f20:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f22:	89 ca                	mov    %ecx,%edx
  800f24:	f7 da                	neg    %edx
  800f26:	85 ff                	test   %edi,%edi
  800f28:	0f 45 c2             	cmovne %edx,%eax
}
  800f2b:	5b                   	pop    %ebx
  800f2c:	5e                   	pop    %esi
  800f2d:	5f                   	pop    %edi
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	83 ec 0c             	sub    $0xc,%esp
  800f36:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f39:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f3c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f47:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4a:	89 c3                	mov    %eax,%ebx
  800f4c:	89 c7                	mov    %eax,%edi
  800f4e:	89 c6                	mov    %eax,%esi
  800f50:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f52:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f55:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f58:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f5b:	89 ec                	mov    %ebp,%esp
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    

00800f5f <sys_cgetc>:

int
sys_cgetc(void)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 0c             	sub    $0xc,%esp
  800f65:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f68:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f73:	b8 01 00 00 00       	mov    $0x1,%eax
  800f78:	89 d1                	mov    %edx,%ecx
  800f7a:	89 d3                	mov    %edx,%ebx
  800f7c:	89 d7                	mov    %edx,%edi
  800f7e:	89 d6                	mov    %edx,%esi
  800f80:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f82:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f85:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f88:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f8b:	89 ec                	mov    %ebp,%esp
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	83 ec 38             	sub    $0x38,%esp
  800f95:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f98:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f9b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa3:	b8 03 00 00 00       	mov    $0x3,%eax
  800fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fab:	89 cb                	mov    %ecx,%ebx
  800fad:	89 cf                	mov    %ecx,%edi
  800faf:	89 ce                	mov    %ecx,%esi
  800fb1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	7e 28                	jle    800fdf <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fbb:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800fc2:	00 
  800fc3:	c7 44 24 08 4f 28 80 	movl   $0x80284f,0x8(%esp)
  800fca:	00 
  800fcb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd2:	00 
  800fd3:	c7 04 24 6c 28 80 00 	movl   $0x80286c,(%esp)
  800fda:	e8 5d f3 ff ff       	call   80033c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fdf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fe5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fe8:	89 ec                	mov    %ebp,%esp
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	83 ec 0c             	sub    $0xc,%esp
  800ff2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ff5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ff8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffb:	ba 00 00 00 00       	mov    $0x0,%edx
  801000:	b8 02 00 00 00       	mov    $0x2,%eax
  801005:	89 d1                	mov    %edx,%ecx
  801007:	89 d3                	mov    %edx,%ebx
  801009:	89 d7                	mov    %edx,%edi
  80100b:	89 d6                	mov    %edx,%esi
  80100d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80100f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801012:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801015:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801018:	89 ec                	mov    %ebp,%esp
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    

0080101c <sys_yield>:

void
sys_yield(void)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	83 ec 0c             	sub    $0xc,%esp
  801022:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801025:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801028:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102b:	ba 00 00 00 00       	mov    $0x0,%edx
  801030:	b8 0b 00 00 00       	mov    $0xb,%eax
  801035:	89 d1                	mov    %edx,%ecx
  801037:	89 d3                	mov    %edx,%ebx
  801039:	89 d7                	mov    %edx,%edi
  80103b:	89 d6                	mov    %edx,%esi
  80103d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80103f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801042:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801045:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801048:	89 ec                	mov    %ebp,%esp
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    

0080104c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	83 ec 38             	sub    $0x38,%esp
  801052:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801055:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801058:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105b:	be 00 00 00 00       	mov    $0x0,%esi
  801060:	b8 04 00 00 00       	mov    $0x4,%eax
  801065:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801068:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106b:	8b 55 08             	mov    0x8(%ebp),%edx
  80106e:	89 f7                	mov    %esi,%edi
  801070:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801072:	85 c0                	test   %eax,%eax
  801074:	7e 28                	jle    80109e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801076:	89 44 24 10          	mov    %eax,0x10(%esp)
  80107a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801081:	00 
  801082:	c7 44 24 08 4f 28 80 	movl   $0x80284f,0x8(%esp)
  801089:	00 
  80108a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801091:	00 
  801092:	c7 04 24 6c 28 80 00 	movl   $0x80286c,(%esp)
  801099:	e8 9e f2 ff ff       	call   80033c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80109e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010a7:	89 ec                	mov    %ebp,%esp
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    

008010ab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 38             	sub    $0x38,%esp
  8010b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ba:	b8 05 00 00 00       	mov    $0x5,%eax
  8010bf:	8b 75 18             	mov    0x18(%ebp),%esi
  8010c2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ce:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	7e 28                	jle    8010fc <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010df:	00 
  8010e0:	c7 44 24 08 4f 28 80 	movl   $0x80284f,0x8(%esp)
  8010e7:	00 
  8010e8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ef:	00 
  8010f0:	c7 04 24 6c 28 80 00 	movl   $0x80286c,(%esp)
  8010f7:	e8 40 f2 ff ff       	call   80033c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010fc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010ff:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801102:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801105:	89 ec                	mov    %ebp,%esp
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 38             	sub    $0x38,%esp
  80110f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801112:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801115:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801118:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111d:	b8 06 00 00 00       	mov    $0x6,%eax
  801122:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801125:	8b 55 08             	mov    0x8(%ebp),%edx
  801128:	89 df                	mov    %ebx,%edi
  80112a:	89 de                	mov    %ebx,%esi
  80112c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80112e:	85 c0                	test   %eax,%eax
  801130:	7e 28                	jle    80115a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801132:	89 44 24 10          	mov    %eax,0x10(%esp)
  801136:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80113d:	00 
  80113e:	c7 44 24 08 4f 28 80 	movl   $0x80284f,0x8(%esp)
  801145:	00 
  801146:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80114d:	00 
  80114e:	c7 04 24 6c 28 80 00 	movl   $0x80286c,(%esp)
  801155:	e8 e2 f1 ff ff       	call   80033c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80115a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80115d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801160:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801163:	89 ec                	mov    %ebp,%esp
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    

00801167 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	83 ec 38             	sub    $0x38,%esp
  80116d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801170:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801173:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801176:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117b:	b8 08 00 00 00       	mov    $0x8,%eax
  801180:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	89 df                	mov    %ebx,%edi
  801188:	89 de                	mov    %ebx,%esi
  80118a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80118c:	85 c0                	test   %eax,%eax
  80118e:	7e 28                	jle    8011b8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801190:	89 44 24 10          	mov    %eax,0x10(%esp)
  801194:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80119b:	00 
  80119c:	c7 44 24 08 4f 28 80 	movl   $0x80284f,0x8(%esp)
  8011a3:	00 
  8011a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ab:	00 
  8011ac:	c7 04 24 6c 28 80 00 	movl   $0x80286c,(%esp)
  8011b3:	e8 84 f1 ff ff       	call   80033c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011bb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011be:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011c1:	89 ec                	mov    %ebp,%esp
  8011c3:	5d                   	pop    %ebp
  8011c4:	c3                   	ret    

008011c5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 38             	sub    $0x38,%esp
  8011cb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011ce:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011d1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d9:	b8 09 00 00 00       	mov    $0x9,%eax
  8011de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e4:	89 df                	mov    %ebx,%edi
  8011e6:	89 de                	mov    %ebx,%esi
  8011e8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	7e 28                	jle    801216 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ee:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011f2:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8011f9:	00 
  8011fa:	c7 44 24 08 4f 28 80 	movl   $0x80284f,0x8(%esp)
  801201:	00 
  801202:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801209:	00 
  80120a:	c7 04 24 6c 28 80 00 	movl   $0x80286c,(%esp)
  801211:	e8 26 f1 ff ff       	call   80033c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801216:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801219:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80121c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80121f:	89 ec                	mov    %ebp,%esp
  801221:	5d                   	pop    %ebp
  801222:	c3                   	ret    

00801223 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 38             	sub    $0x38,%esp
  801229:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80122c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80122f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801232:	bb 00 00 00 00       	mov    $0x0,%ebx
  801237:	b8 0a 00 00 00       	mov    $0xa,%eax
  80123c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123f:	8b 55 08             	mov    0x8(%ebp),%edx
  801242:	89 df                	mov    %ebx,%edi
  801244:	89 de                	mov    %ebx,%esi
  801246:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801248:	85 c0                	test   %eax,%eax
  80124a:	7e 28                	jle    801274 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80124c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801250:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801257:	00 
  801258:	c7 44 24 08 4f 28 80 	movl   $0x80284f,0x8(%esp)
  80125f:	00 
  801260:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801267:	00 
  801268:	c7 04 24 6c 28 80 00 	movl   $0x80286c,(%esp)
  80126f:	e8 c8 f0 ff ff       	call   80033c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801274:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801277:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80127a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80127d:	89 ec                	mov    %ebp,%esp
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 0c             	sub    $0xc,%esp
  801287:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80128a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80128d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801290:	be 00 00 00 00       	mov    $0x0,%esi
  801295:	b8 0c 00 00 00       	mov    $0xc,%eax
  80129a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80129d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012a8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012ab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012ae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012b1:	89 ec                	mov    %ebp,%esp
  8012b3:	5d                   	pop    %ebp
  8012b4:	c3                   	ret    

008012b5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	83 ec 38             	sub    $0x38,%esp
  8012bb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012be:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012c1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012c9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d1:	89 cb                	mov    %ecx,%ebx
  8012d3:	89 cf                	mov    %ecx,%edi
  8012d5:	89 ce                	mov    %ecx,%esi
  8012d7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	7e 28                	jle    801305 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012e1:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8012e8:	00 
  8012e9:	c7 44 24 08 4f 28 80 	movl   $0x80284f,0x8(%esp)
  8012f0:	00 
  8012f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012f8:	00 
  8012f9:	c7 04 24 6c 28 80 00 	movl   $0x80286c,(%esp)
  801300:	e8 37 f0 ff ff       	call   80033c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801305:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801308:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80130b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80130e:	89 ec                	mov    %ebp,%esp
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    
	...

00801320 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	05 00 00 00 30       	add    $0x30000000,%eax
  80132b:	c1 e8 0c             	shr    $0xc,%eax
}
  80132e:	5d                   	pop    %ebp
  80132f:	c3                   	ret    

00801330 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	89 04 24             	mov    %eax,(%esp)
  80133c:	e8 df ff ff ff       	call   801320 <fd2num>
  801341:	05 20 00 0d 00       	add    $0xd0020,%eax
  801346:	c1 e0 0c             	shl    $0xc,%eax
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	53                   	push   %ebx
  80134f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801352:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801357:	a8 01                	test   $0x1,%al
  801359:	74 34                	je     80138f <fd_alloc+0x44>
  80135b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801360:	a8 01                	test   $0x1,%al
  801362:	74 32                	je     801396 <fd_alloc+0x4b>
  801364:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801369:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80136b:	89 c2                	mov    %eax,%edx
  80136d:	c1 ea 16             	shr    $0x16,%edx
  801370:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801377:	f6 c2 01             	test   $0x1,%dl
  80137a:	74 1f                	je     80139b <fd_alloc+0x50>
  80137c:	89 c2                	mov    %eax,%edx
  80137e:	c1 ea 0c             	shr    $0xc,%edx
  801381:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801388:	f6 c2 01             	test   $0x1,%dl
  80138b:	75 17                	jne    8013a4 <fd_alloc+0x59>
  80138d:	eb 0c                	jmp    80139b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80138f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801394:	eb 05                	jmp    80139b <fd_alloc+0x50>
  801396:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80139b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80139d:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a2:	eb 17                	jmp    8013bb <fd_alloc+0x70>
  8013a4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013a9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013ae:	75 b9                	jne    801369 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  8013b6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013bb:	5b                   	pop    %ebx
  8013bc:	5d                   	pop    %ebp
  8013bd:	c3                   	ret    

008013be <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013c9:	83 fa 1f             	cmp    $0x1f,%edx
  8013cc:	77 3f                	ja     80140d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013ce:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  8013d4:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013d7:	89 d0                	mov    %edx,%eax
  8013d9:	c1 e8 16             	shr    $0x16,%eax
  8013dc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013e8:	f6 c1 01             	test   $0x1,%cl
  8013eb:	74 20                	je     80140d <fd_lookup+0x4f>
  8013ed:	89 d0                	mov    %edx,%eax
  8013ef:	c1 e8 0c             	shr    $0xc,%eax
  8013f2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013fe:	f6 c1 01             	test   $0x1,%cl
  801401:	74 0a                	je     80140d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	89 10                	mov    %edx,(%eax)
	return 0;
  801408:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140d:	5d                   	pop    %ebp
  80140e:	c3                   	ret    

0080140f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	53                   	push   %ebx
  801413:	83 ec 14             	sub    $0x14,%esp
  801416:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801419:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80141c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801421:	39 0d 20 30 80 00    	cmp    %ecx,0x803020
  801427:	75 17                	jne    801440 <dev_lookup+0x31>
  801429:	eb 07                	jmp    801432 <dev_lookup+0x23>
  80142b:	39 0a                	cmp    %ecx,(%edx)
  80142d:	75 11                	jne    801440 <dev_lookup+0x31>
  80142f:	90                   	nop
  801430:	eb 05                	jmp    801437 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801432:	ba 20 30 80 00       	mov    $0x803020,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801437:	89 13                	mov    %edx,(%ebx)
			return 0;
  801439:	b8 00 00 00 00       	mov    $0x0,%eax
  80143e:	eb 35                	jmp    801475 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801440:	83 c0 01             	add    $0x1,%eax
  801443:	8b 14 85 fc 28 80 00 	mov    0x8028fc(,%eax,4),%edx
  80144a:	85 d2                	test   %edx,%edx
  80144c:	75 dd                	jne    80142b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80144e:	a1 04 44 80 00       	mov    0x804404,%eax
  801453:	8b 40 48             	mov    0x48(%eax),%eax
  801456:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80145a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145e:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  801465:	e8 cd ef ff ff       	call   800437 <cprintf>
	*dev = 0;
  80146a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801470:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801475:	83 c4 14             	add    $0x14,%esp
  801478:	5b                   	pop    %ebx
  801479:	5d                   	pop    %ebp
  80147a:	c3                   	ret    

0080147b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 38             	sub    $0x38,%esp
  801481:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801484:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801487:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80148a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80148d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801491:	89 3c 24             	mov    %edi,(%esp)
  801494:	e8 87 fe ff ff       	call   801320 <fd2num>
  801499:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80149c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014a0:	89 04 24             	mov    %eax,(%esp)
  8014a3:	e8 16 ff ff ff       	call   8013be <fd_lookup>
  8014a8:	89 c3                	mov    %eax,%ebx
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	78 05                	js     8014b3 <fd_close+0x38>
	    || fd != fd2)
  8014ae:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8014b1:	74 0e                	je     8014c1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8014b3:	89 f0                	mov    %esi,%eax
  8014b5:	84 c0                	test   %al,%al
  8014b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bc:	0f 44 d8             	cmove  %eax,%ebx
  8014bf:	eb 3d                	jmp    8014fe <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014c1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c8:	8b 07                	mov    (%edi),%eax
  8014ca:	89 04 24             	mov    %eax,(%esp)
  8014cd:	e8 3d ff ff ff       	call   80140f <dev_lookup>
  8014d2:	89 c3                	mov    %eax,%ebx
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 16                	js     8014ee <fd_close+0x73>
		if (dev->dev_close)
  8014d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	74 07                	je     8014ee <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8014e7:	89 3c 24             	mov    %edi,(%esp)
  8014ea:	ff d0                	call   *%eax
  8014ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014f9:	e8 0b fc ff ff       	call   801109 <sys_page_unmap>
	return r;
}
  8014fe:	89 d8                	mov    %ebx,%eax
  801500:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801503:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801506:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801509:	89 ec                	mov    %ebp,%esp
  80150b:	5d                   	pop    %ebp
  80150c:	c3                   	ret    

0080150d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801513:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801516:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	89 04 24             	mov    %eax,(%esp)
  801520:	e8 99 fe ff ff       	call   8013be <fd_lookup>
  801525:	85 c0                	test   %eax,%eax
  801527:	78 13                	js     80153c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801529:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801530:	00 
  801531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801534:	89 04 24             	mov    %eax,(%esp)
  801537:	e8 3f ff ff ff       	call   80147b <fd_close>
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <close_all>:

void
close_all(void)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	53                   	push   %ebx
  801542:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801545:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80154a:	89 1c 24             	mov    %ebx,(%esp)
  80154d:	e8 bb ff ff ff       	call   80150d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801552:	83 c3 01             	add    $0x1,%ebx
  801555:	83 fb 20             	cmp    $0x20,%ebx
  801558:	75 f0                	jne    80154a <close_all+0xc>
		close(i);
}
  80155a:	83 c4 14             	add    $0x14,%esp
  80155d:	5b                   	pop    %ebx
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 58             	sub    $0x58,%esp
  801566:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801569:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80156c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80156f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801572:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801575:	89 44 24 04          	mov    %eax,0x4(%esp)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	89 04 24             	mov    %eax,(%esp)
  80157f:	e8 3a fe ff ff       	call   8013be <fd_lookup>
  801584:	89 c3                	mov    %eax,%ebx
  801586:	85 c0                	test   %eax,%eax
  801588:	0f 88 e1 00 00 00    	js     80166f <dup+0x10f>
		return r;
	close(newfdnum);
  80158e:	89 3c 24             	mov    %edi,(%esp)
  801591:	e8 77 ff ff ff       	call   80150d <close>

	newfd = INDEX2FD(newfdnum);
  801596:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80159c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80159f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a2:	89 04 24             	mov    %eax,(%esp)
  8015a5:	e8 86 fd ff ff       	call   801330 <fd2data>
  8015aa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015ac:	89 34 24             	mov    %esi,(%esp)
  8015af:	e8 7c fd ff ff       	call   801330 <fd2data>
  8015b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015b7:	89 d8                	mov    %ebx,%eax
  8015b9:	c1 e8 16             	shr    $0x16,%eax
  8015bc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015c3:	a8 01                	test   $0x1,%al
  8015c5:	74 46                	je     80160d <dup+0xad>
  8015c7:	89 d8                	mov    %ebx,%eax
  8015c9:	c1 e8 0c             	shr    $0xc,%eax
  8015cc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015d3:	f6 c2 01             	test   $0x1,%dl
  8015d6:	74 35                	je     80160d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015df:	25 07 0e 00 00       	and    $0xe07,%eax
  8015e4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015f6:	00 
  8015f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801602:	e8 a4 fa ff ff       	call   8010ab <sys_page_map>
  801607:	89 c3                	mov    %eax,%ebx
  801609:	85 c0                	test   %eax,%eax
  80160b:	78 3b                	js     801648 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80160d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801610:	89 c2                	mov    %eax,%edx
  801612:	c1 ea 0c             	shr    $0xc,%edx
  801615:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80161c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801622:	89 54 24 10          	mov    %edx,0x10(%esp)
  801626:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80162a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801631:	00 
  801632:	89 44 24 04          	mov    %eax,0x4(%esp)
  801636:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80163d:	e8 69 fa ff ff       	call   8010ab <sys_page_map>
  801642:	89 c3                	mov    %eax,%ebx
  801644:	85 c0                	test   %eax,%eax
  801646:	79 25                	jns    80166d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801648:	89 74 24 04          	mov    %esi,0x4(%esp)
  80164c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801653:	e8 b1 fa ff ff       	call   801109 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801658:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80165b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801666:	e8 9e fa ff ff       	call   801109 <sys_page_unmap>
	return r;
  80166b:	eb 02                	jmp    80166f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80166d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80166f:	89 d8                	mov    %ebx,%eax
  801671:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801674:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801677:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80167a:	89 ec                	mov    %ebp,%esp
  80167c:	5d                   	pop    %ebp
  80167d:	c3                   	ret    

0080167e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	53                   	push   %ebx
  801682:	83 ec 24             	sub    $0x24,%esp
  801685:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801688:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168f:	89 1c 24             	mov    %ebx,(%esp)
  801692:	e8 27 fd ff ff       	call   8013be <fd_lookup>
  801697:	85 c0                	test   %eax,%eax
  801699:	78 6d                	js     801708 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a5:	8b 00                	mov    (%eax),%eax
  8016a7:	89 04 24             	mov    %eax,(%esp)
  8016aa:	e8 60 fd ff ff       	call   80140f <dev_lookup>
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	78 55                	js     801708 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b6:	8b 50 08             	mov    0x8(%eax),%edx
  8016b9:	83 e2 03             	and    $0x3,%edx
  8016bc:	83 fa 01             	cmp    $0x1,%edx
  8016bf:	75 23                	jne    8016e4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016c1:	a1 04 44 80 00       	mov    0x804404,%eax
  8016c6:	8b 40 48             	mov    0x48(%eax),%eax
  8016c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d1:	c7 04 24 c0 28 80 00 	movl   $0x8028c0,(%esp)
  8016d8:	e8 5a ed ff ff       	call   800437 <cprintf>
		return -E_INVAL;
  8016dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e2:	eb 24                	jmp    801708 <read+0x8a>
	}
	if (!dev->dev_read)
  8016e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e7:	8b 52 08             	mov    0x8(%edx),%edx
  8016ea:	85 d2                	test   %edx,%edx
  8016ec:	74 15                	je     801703 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016fc:	89 04 24             	mov    %eax,(%esp)
  8016ff:	ff d2                	call   *%edx
  801701:	eb 05                	jmp    801708 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801703:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801708:	83 c4 24             	add    $0x24,%esp
  80170b:	5b                   	pop    %ebx
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    

0080170e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	57                   	push   %edi
  801712:	56                   	push   %esi
  801713:	53                   	push   %ebx
  801714:	83 ec 1c             	sub    $0x1c,%esp
  801717:	8b 7d 08             	mov    0x8(%ebp),%edi
  80171a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80171d:	b8 00 00 00 00       	mov    $0x0,%eax
  801722:	85 f6                	test   %esi,%esi
  801724:	74 30                	je     801756 <readn+0x48>
  801726:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80172b:	89 f2                	mov    %esi,%edx
  80172d:	29 c2                	sub    %eax,%edx
  80172f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801733:	03 45 0c             	add    0xc(%ebp),%eax
  801736:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173a:	89 3c 24             	mov    %edi,(%esp)
  80173d:	e8 3c ff ff ff       	call   80167e <read>
		if (m < 0)
  801742:	85 c0                	test   %eax,%eax
  801744:	78 10                	js     801756 <readn+0x48>
			return m;
		if (m == 0)
  801746:	85 c0                	test   %eax,%eax
  801748:	74 0a                	je     801754 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80174a:	01 c3                	add    %eax,%ebx
  80174c:	89 d8                	mov    %ebx,%eax
  80174e:	39 f3                	cmp    %esi,%ebx
  801750:	72 d9                	jb     80172b <readn+0x1d>
  801752:	eb 02                	jmp    801756 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801754:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801756:	83 c4 1c             	add    $0x1c,%esp
  801759:	5b                   	pop    %ebx
  80175a:	5e                   	pop    %esi
  80175b:	5f                   	pop    %edi
  80175c:	5d                   	pop    %ebp
  80175d:	c3                   	ret    

0080175e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	53                   	push   %ebx
  801762:	83 ec 24             	sub    $0x24,%esp
  801765:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801768:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80176b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176f:	89 1c 24             	mov    %ebx,(%esp)
  801772:	e8 47 fc ff ff       	call   8013be <fd_lookup>
  801777:	85 c0                	test   %eax,%eax
  801779:	78 68                	js     8017e3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80177b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801785:	8b 00                	mov    (%eax),%eax
  801787:	89 04 24             	mov    %eax,(%esp)
  80178a:	e8 80 fc ff ff       	call   80140f <dev_lookup>
  80178f:	85 c0                	test   %eax,%eax
  801791:	78 50                	js     8017e3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801796:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80179a:	75 23                	jne    8017bf <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80179c:	a1 04 44 80 00       	mov    0x804404,%eax
  8017a1:	8b 40 48             	mov    0x48(%eax),%eax
  8017a4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ac:	c7 04 24 dc 28 80 00 	movl   $0x8028dc,(%esp)
  8017b3:	e8 7f ec ff ff       	call   800437 <cprintf>
		return -E_INVAL;
  8017b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017bd:	eb 24                	jmp    8017e3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8017c5:	85 d2                	test   %edx,%edx
  8017c7:	74 15                	je     8017de <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017cc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017d7:	89 04 24             	mov    %eax,(%esp)
  8017da:	ff d2                	call   *%edx
  8017dc:	eb 05                	jmp    8017e3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8017e3:	83 c4 24             	add    $0x24,%esp
  8017e6:	5b                   	pop    %ebx
  8017e7:	5d                   	pop    %ebp
  8017e8:	c3                   	ret    

008017e9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ef:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	89 04 24             	mov    %eax,(%esp)
  8017fc:	e8 bd fb ff ff       	call   8013be <fd_lookup>
  801801:	85 c0                	test   %eax,%eax
  801803:	78 0e                	js     801813 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801805:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80180e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	53                   	push   %ebx
  801819:	83 ec 24             	sub    $0x24,%esp
  80181c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801822:	89 44 24 04          	mov    %eax,0x4(%esp)
  801826:	89 1c 24             	mov    %ebx,(%esp)
  801829:	e8 90 fb ff ff       	call   8013be <fd_lookup>
  80182e:	85 c0                	test   %eax,%eax
  801830:	78 61                	js     801893 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801832:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801835:	89 44 24 04          	mov    %eax,0x4(%esp)
  801839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183c:	8b 00                	mov    (%eax),%eax
  80183e:	89 04 24             	mov    %eax,(%esp)
  801841:	e8 c9 fb ff ff       	call   80140f <dev_lookup>
  801846:	85 c0                	test   %eax,%eax
  801848:	78 49                	js     801893 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80184a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801851:	75 23                	jne    801876 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801853:	a1 04 44 80 00       	mov    0x804404,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801858:	8b 40 48             	mov    0x48(%eax),%eax
  80185b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80185f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801863:	c7 04 24 9c 28 80 00 	movl   $0x80289c,(%esp)
  80186a:	e8 c8 eb ff ff       	call   800437 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80186f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801874:	eb 1d                	jmp    801893 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801876:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801879:	8b 52 18             	mov    0x18(%edx),%edx
  80187c:	85 d2                	test   %edx,%edx
  80187e:	74 0e                	je     80188e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801880:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801883:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801887:	89 04 24             	mov    %eax,(%esp)
  80188a:	ff d2                	call   *%edx
  80188c:	eb 05                	jmp    801893 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80188e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801893:	83 c4 24             	add    $0x24,%esp
  801896:	5b                   	pop    %ebx
  801897:	5d                   	pop    %ebp
  801898:	c3                   	ret    

00801899 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	53                   	push   %ebx
  80189d:	83 ec 24             	sub    $0x24,%esp
  8018a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	89 04 24             	mov    %eax,(%esp)
  8018b0:	e8 09 fb ff ff       	call   8013be <fd_lookup>
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	78 52                	js     80190b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c3:	8b 00                	mov    (%eax),%eax
  8018c5:	89 04 24             	mov    %eax,(%esp)
  8018c8:	e8 42 fb ff ff       	call   80140f <dev_lookup>
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	78 3a                	js     80190b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  8018d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018d8:	74 2c                	je     801906 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018da:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018dd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018e4:	00 00 00 
	stat->st_isdir = 0;
  8018e7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018ee:	00 00 00 
	stat->st_dev = dev;
  8018f1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018fe:	89 14 24             	mov    %edx,(%esp)
  801901:	ff 50 14             	call   *0x14(%eax)
  801904:	eb 05                	jmp    80190b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801906:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80190b:	83 c4 24             	add    $0x24,%esp
  80190e:	5b                   	pop    %ebx
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    

00801911 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 18             	sub    $0x18,%esp
  801917:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80191a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80191d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801924:	00 
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	89 04 24             	mov    %eax,(%esp)
  80192b:	e8 bc 01 00 00       	call   801aec <open>
  801930:	89 c3                	mov    %eax,%ebx
  801932:	85 c0                	test   %eax,%eax
  801934:	78 1b                	js     801951 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801936:	8b 45 0c             	mov    0xc(%ebp),%eax
  801939:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193d:	89 1c 24             	mov    %ebx,(%esp)
  801940:	e8 54 ff ff ff       	call   801899 <fstat>
  801945:	89 c6                	mov    %eax,%esi
	close(fd);
  801947:	89 1c 24             	mov    %ebx,(%esp)
  80194a:	e8 be fb ff ff       	call   80150d <close>
	return r;
  80194f:	89 f3                	mov    %esi,%ebx
}
  801951:	89 d8                	mov    %ebx,%eax
  801953:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801956:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801959:	89 ec                	mov    %ebp,%esp
  80195b:	5d                   	pop    %ebp
  80195c:	c3                   	ret    
  80195d:	00 00                	add    %al,(%eax)
	...

00801960 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 18             	sub    $0x18,%esp
  801966:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801969:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80196c:	89 c3                	mov    %eax,%ebx
  80196e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801970:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801977:	75 11                	jne    80198a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801979:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801980:	e8 e1 07 00 00       	call   802166 <ipc_find_env>
  801985:	a3 00 44 80 00       	mov    %eax,0x804400
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80198a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801991:	00 
  801992:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801999:	00 
  80199a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80199e:	a1 00 44 80 00       	mov    0x804400,%eax
  8019a3:	89 04 24             	mov    %eax,(%esp)
  8019a6:	e8 37 07 00 00       	call   8020e2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019b2:	00 
  8019b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019be:	e8 cd 06 00 00       	call   802090 <ipc_recv>
}
  8019c3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8019c6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8019c9:	89 ec                	mov    %ebp,%esp
  8019cb:	5d                   	pop    %ebp
  8019cc:	c3                   	ret    

008019cd <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	53                   	push   %ebx
  8019d1:	83 ec 14             	sub    $0x14,%esp
  8019d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	8b 40 0c             	mov    0xc(%eax),%eax
  8019dd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e7:	b8 05 00 00 00       	mov    $0x5,%eax
  8019ec:	e8 6f ff ff ff       	call   801960 <fsipc>
  8019f1:	85 c0                	test   %eax,%eax
  8019f3:	78 2b                	js     801a20 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019f5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8019fc:	00 
  8019fd:	89 1c 24             	mov    %ebx,(%esp)
  801a00:	e8 46 f1 ff ff       	call   800b4b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a05:	a1 80 50 80 00       	mov    0x805080,%eax
  801a0a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a10:	a1 84 50 80 00       	mov    0x805084,%eax
  801a15:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a20:	83 c4 14             	add    $0x14,%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5d                   	pop    %ebp
  801a25:	c3                   	ret    

00801a26 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a32:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a37:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3c:	b8 06 00 00 00       	mov    $0x6,%eax
  801a41:	e8 1a ff ff ff       	call   801960 <fsipc>
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	83 ec 10             	sub    $0x10,%esp
  801a50:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	8b 40 0c             	mov    0xc(%eax),%eax
  801a59:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a5e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a64:	ba 00 00 00 00       	mov    $0x0,%edx
  801a69:	b8 03 00 00 00       	mov    $0x3,%eax
  801a6e:	e8 ed fe ff ff       	call   801960 <fsipc>
  801a73:	89 c3                	mov    %eax,%ebx
  801a75:	85 c0                	test   %eax,%eax
  801a77:	78 6a                	js     801ae3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801a79:	39 c6                	cmp    %eax,%esi
  801a7b:	73 24                	jae    801aa1 <devfile_read+0x59>
  801a7d:	c7 44 24 0c 0c 29 80 	movl   $0x80290c,0xc(%esp)
  801a84:	00 
  801a85:	c7 44 24 08 13 29 80 	movl   $0x802913,0x8(%esp)
  801a8c:	00 
  801a8d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801a94:	00 
  801a95:	c7 04 24 28 29 80 00 	movl   $0x802928,(%esp)
  801a9c:	e8 9b e8 ff ff       	call   80033c <_panic>
	assert(r <= PGSIZE);
  801aa1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aa6:	7e 24                	jle    801acc <devfile_read+0x84>
  801aa8:	c7 44 24 0c 33 29 80 	movl   $0x802933,0xc(%esp)
  801aaf:	00 
  801ab0:	c7 44 24 08 13 29 80 	movl   $0x802913,0x8(%esp)
  801ab7:	00 
  801ab8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801abf:	00 
  801ac0:	c7 04 24 28 29 80 00 	movl   $0x802928,(%esp)
  801ac7:	e8 70 e8 ff ff       	call   80033c <_panic>
	memmove(buf, &fsipcbuf, r);
  801acc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ad0:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801ad7:	00 
  801ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adb:	89 04 24             	mov    %eax,(%esp)
  801ade:	e8 59 f2 ff ff       	call   800d3c <memmove>
	return r;
}
  801ae3:	89 d8                	mov    %ebx,%eax
  801ae5:	83 c4 10             	add    $0x10,%esp
  801ae8:	5b                   	pop    %ebx
  801ae9:	5e                   	pop    %esi
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	56                   	push   %esi
  801af0:	53                   	push   %ebx
  801af1:	83 ec 20             	sub    $0x20,%esp
  801af4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801af7:	89 34 24             	mov    %esi,(%esp)
  801afa:	e8 01 f0 ff ff       	call   800b00 <strlen>
		return -E_BAD_PATH;
  801aff:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b04:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b09:	7f 5e                	jg     801b69 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0e:	89 04 24             	mov    %eax,(%esp)
  801b11:	e8 35 f8 ff ff       	call   80134b <fd_alloc>
  801b16:	89 c3                	mov    %eax,%ebx
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	78 4d                	js     801b69 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b20:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801b27:	e8 1f f0 ff ff       	call   800b4b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b37:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3c:	e8 1f fe ff ff       	call   801960 <fsipc>
  801b41:	89 c3                	mov    %eax,%ebx
  801b43:	85 c0                	test   %eax,%eax
  801b45:	79 15                	jns    801b5c <open+0x70>
		fd_close(fd, 0);
  801b47:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b4e:	00 
  801b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b52:	89 04 24             	mov    %eax,(%esp)
  801b55:	e8 21 f9 ff ff       	call   80147b <fd_close>
		return r;
  801b5a:	eb 0d                	jmp    801b69 <open+0x7d>
	}

	return fd2num(fd);
  801b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5f:	89 04 24             	mov    %eax,(%esp)
  801b62:	e8 b9 f7 ff ff       	call   801320 <fd2num>
  801b67:	89 c3                	mov    %eax,%ebx
}
  801b69:	89 d8                	mov    %ebx,%eax
  801b6b:	83 c4 20             	add    $0x20,%esp
  801b6e:	5b                   	pop    %ebx
  801b6f:	5e                   	pop    %esi
  801b70:	5d                   	pop    %ebp
  801b71:	c3                   	ret    
	...

00801b74 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	53                   	push   %ebx
  801b78:	83 ec 14             	sub    $0x14,%esp
  801b7b:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b7d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b81:	7e 31                	jle    801bb4 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b83:	8b 40 04             	mov    0x4(%eax),%eax
  801b86:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b8a:	8d 43 10             	lea    0x10(%ebx),%eax
  801b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b91:	8b 03                	mov    (%ebx),%eax
  801b93:	89 04 24             	mov    %eax,(%esp)
  801b96:	e8 c3 fb ff ff       	call   80175e <write>
		if (result > 0)
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	7e 03                	jle    801ba2 <writebuf+0x2e>
			b->result += result;
  801b9f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801ba2:	39 43 04             	cmp    %eax,0x4(%ebx)
  801ba5:	74 0d                	je     801bb4 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801ba7:	85 c0                	test   %eax,%eax
  801ba9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bae:	0f 4f c2             	cmovg  %edx,%eax
  801bb1:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801bb4:	83 c4 14             	add    $0x14,%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5d                   	pop    %ebp
  801bb9:	c3                   	ret    

00801bba <putch>:

static void
putch(int ch, void *thunk)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	53                   	push   %ebx
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801bc4:	8b 43 04             	mov    0x4(%ebx),%eax
  801bc7:	8b 55 08             	mov    0x8(%ebp),%edx
  801bca:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801bce:	83 c0 01             	add    $0x1,%eax
  801bd1:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801bd4:	3d 00 01 00 00       	cmp    $0x100,%eax
  801bd9:	75 0e                	jne    801be9 <putch+0x2f>
		writebuf(b);
  801bdb:	89 d8                	mov    %ebx,%eax
  801bdd:	e8 92 ff ff ff       	call   801b74 <writebuf>
		b->idx = 0;
  801be2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801be9:	83 c4 04             	add    $0x4,%esp
  801bec:	5b                   	pop    %ebx
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    

00801bef <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801c01:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801c08:	00 00 00 
	b.result = 0;
  801c0b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c12:	00 00 00 
	b.error = 1;
  801c15:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801c1c:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c22:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c29:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c2d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c37:	c7 04 24 ba 1b 80 00 	movl   $0x801bba,(%esp)
  801c3e:	e8 77 e9 ff ff       	call   8005ba <vprintfmt>
	if (b.idx > 0)
  801c43:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801c4a:	7e 0b                	jle    801c57 <vfprintf+0x68>
		writebuf(&b);
  801c4c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c52:	e8 1d ff ff ff       	call   801b74 <writebuf>

	return (b.result ? b.result : b.error);
  801c57:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c6e:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801c71:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	89 04 24             	mov    %eax,(%esp)
  801c82:	e8 68 ff ff ff       	call   801bef <vfprintf>
	va_end(ap);

	return cnt;
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <printf>:

int
printf(const char *fmt, ...)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c8f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801c92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801ca4:	e8 46 ff ff ff       	call   801bef <vfprintf>
	va_end(ap);

	return cnt;
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    
  801cab:	00 00                	add    %al,(%eax)
  801cad:	00 00                	add    %al,(%eax)
	...

00801cb0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 18             	sub    $0x18,%esp
  801cb6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801cb9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801cbc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	89 04 24             	mov    %eax,(%esp)
  801cc5:	e8 66 f6 ff ff       	call   801330 <fd2data>
  801cca:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801ccc:	c7 44 24 04 3f 29 80 	movl   $0x80293f,0x4(%esp)
  801cd3:	00 
  801cd4:	89 34 24             	mov    %esi,(%esp)
  801cd7:	e8 6f ee ff ff       	call   800b4b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cdc:	8b 43 04             	mov    0x4(%ebx),%eax
  801cdf:	2b 03                	sub    (%ebx),%eax
  801ce1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801ce7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801cee:	00 00 00 
	stat->st_dev = &devpipe;
  801cf1:	c7 86 88 00 00 00 3c 	movl   $0x80303c,0x88(%esi)
  801cf8:	30 80 00 
	return 0;
}
  801cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801d00:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d03:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d06:	89 ec                	mov    %ebp,%esp
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    

00801d0a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	53                   	push   %ebx
  801d0e:	83 ec 14             	sub    $0x14,%esp
  801d11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d14:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d18:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d1f:	e8 e5 f3 ff ff       	call   801109 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d24:	89 1c 24             	mov    %ebx,(%esp)
  801d27:	e8 04 f6 ff ff       	call   801330 <fd2data>
  801d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d37:	e8 cd f3 ff ff       	call   801109 <sys_page_unmap>
}
  801d3c:	83 c4 14             	add    $0x14,%esp
  801d3f:	5b                   	pop    %ebx
  801d40:	5d                   	pop    %ebp
  801d41:	c3                   	ret    

00801d42 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	57                   	push   %edi
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	83 ec 2c             	sub    $0x2c,%esp
  801d4b:	89 c7                	mov    %eax,%edi
  801d4d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d50:	a1 04 44 80 00       	mov    0x804404,%eax
  801d55:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d58:	89 3c 24             	mov    %edi,(%esp)
  801d5b:	e8 50 04 00 00       	call   8021b0 <pageref>
  801d60:	89 c6                	mov    %eax,%esi
  801d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d65:	89 04 24             	mov    %eax,(%esp)
  801d68:	e8 43 04 00 00       	call   8021b0 <pageref>
  801d6d:	39 c6                	cmp    %eax,%esi
  801d6f:	0f 94 c0             	sete   %al
  801d72:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801d75:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801d7b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d7e:	39 cb                	cmp    %ecx,%ebx
  801d80:	75 08                	jne    801d8a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801d82:	83 c4 2c             	add    $0x2c,%esp
  801d85:	5b                   	pop    %ebx
  801d86:	5e                   	pop    %esi
  801d87:	5f                   	pop    %edi
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801d8a:	83 f8 01             	cmp    $0x1,%eax
  801d8d:	75 c1                	jne    801d50 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d8f:	8b 52 58             	mov    0x58(%edx),%edx
  801d92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d96:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d9a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d9e:	c7 04 24 46 29 80 00 	movl   $0x802946,(%esp)
  801da5:	e8 8d e6 ff ff       	call   800437 <cprintf>
  801daa:	eb a4                	jmp    801d50 <_pipeisclosed+0xe>

00801dac <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	57                   	push   %edi
  801db0:	56                   	push   %esi
  801db1:	53                   	push   %ebx
  801db2:	83 ec 2c             	sub    $0x2c,%esp
  801db5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801db8:	89 34 24             	mov    %esi,(%esp)
  801dbb:	e8 70 f5 ff ff       	call   801330 <fd2data>
  801dc0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801dc2:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dcb:	75 50                	jne    801e1d <devpipe_write+0x71>
  801dcd:	eb 5c                	jmp    801e2b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801dcf:	89 da                	mov    %ebx,%edx
  801dd1:	89 f0                	mov    %esi,%eax
  801dd3:	e8 6a ff ff ff       	call   801d42 <_pipeisclosed>
  801dd8:	85 c0                	test   %eax,%eax
  801dda:	75 53                	jne    801e2f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801ddc:	e8 3b f2 ff ff       	call   80101c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801de1:	8b 43 04             	mov    0x4(%ebx),%eax
  801de4:	8b 13                	mov    (%ebx),%edx
  801de6:	83 c2 20             	add    $0x20,%edx
  801de9:	39 d0                	cmp    %edx,%eax
  801deb:	73 e2                	jae    801dcf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ded:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801df4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801df7:	89 c2                	mov    %eax,%edx
  801df9:	c1 fa 1f             	sar    $0x1f,%edx
  801dfc:	c1 ea 1b             	shr    $0x1b,%edx
  801dff:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e02:	83 e1 1f             	and    $0x1f,%ecx
  801e05:	29 d1                	sub    %edx,%ecx
  801e07:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801e0b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801e0f:	83 c0 01             	add    $0x1,%eax
  801e12:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e15:	83 c7 01             	add    $0x1,%edi
  801e18:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e1b:	74 0e                	je     801e2b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e1d:	8b 43 04             	mov    0x4(%ebx),%eax
  801e20:	8b 13                	mov    (%ebx),%edx
  801e22:	83 c2 20             	add    $0x20,%edx
  801e25:	39 d0                	cmp    %edx,%eax
  801e27:	73 a6                	jae    801dcf <devpipe_write+0x23>
  801e29:	eb c2                	jmp    801ded <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e2b:	89 f8                	mov    %edi,%eax
  801e2d:	eb 05                	jmp    801e34 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e34:	83 c4 2c             	add    $0x2c,%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5f                   	pop    %edi
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    

00801e3c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 28             	sub    $0x28,%esp
  801e42:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801e45:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801e48:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801e4b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801e4e:	89 3c 24             	mov    %edi,(%esp)
  801e51:	e8 da f4 ff ff       	call   801330 <fd2data>
  801e56:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e58:	be 00 00 00 00       	mov    $0x0,%esi
  801e5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e61:	75 47                	jne    801eaa <devpipe_read+0x6e>
  801e63:	eb 52                	jmp    801eb7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801e65:	89 f0                	mov    %esi,%eax
  801e67:	eb 5e                	jmp    801ec7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801e69:	89 da                	mov    %ebx,%edx
  801e6b:	89 f8                	mov    %edi,%eax
  801e6d:	8d 76 00             	lea    0x0(%esi),%esi
  801e70:	e8 cd fe ff ff       	call   801d42 <_pipeisclosed>
  801e75:	85 c0                	test   %eax,%eax
  801e77:	75 49                	jne    801ec2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801e79:	e8 9e f1 ff ff       	call   80101c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801e7e:	8b 03                	mov    (%ebx),%eax
  801e80:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e83:	74 e4                	je     801e69 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e85:	89 c2                	mov    %eax,%edx
  801e87:	c1 fa 1f             	sar    $0x1f,%edx
  801e8a:	c1 ea 1b             	shr    $0x1b,%edx
  801e8d:	01 d0                	add    %edx,%eax
  801e8f:	83 e0 1f             	and    $0x1f,%eax
  801e92:	29 d0                	sub    %edx,%eax
  801e94:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801e9f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ea2:	83 c6 01             	add    $0x1,%esi
  801ea5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ea8:	74 0d                	je     801eb7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801eaa:	8b 03                	mov    (%ebx),%eax
  801eac:	3b 43 04             	cmp    0x4(%ebx),%eax
  801eaf:	75 d4                	jne    801e85 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801eb1:	85 f6                	test   %esi,%esi
  801eb3:	75 b0                	jne    801e65 <devpipe_read+0x29>
  801eb5:	eb b2                	jmp    801e69 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801eb7:	89 f0                	mov    %esi,%eax
  801eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ec0:	eb 05                	jmp    801ec7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ec2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801ec7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801eca:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ecd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ed0:	89 ec                	mov    %ebp,%esp
  801ed2:	5d                   	pop    %ebp
  801ed3:	c3                   	ret    

00801ed4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	83 ec 48             	sub    $0x48,%esp
  801eda:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801edd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ee0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ee3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ee6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ee9:	89 04 24             	mov    %eax,(%esp)
  801eec:	e8 5a f4 ff ff       	call   80134b <fd_alloc>
  801ef1:	89 c3                	mov    %eax,%ebx
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	0f 88 45 01 00 00    	js     802040 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f02:	00 
  801f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f11:	e8 36 f1 ff ff       	call   80104c <sys_page_alloc>
  801f16:	89 c3                	mov    %eax,%ebx
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	0f 88 20 01 00 00    	js     802040 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f20:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801f23:	89 04 24             	mov    %eax,(%esp)
  801f26:	e8 20 f4 ff ff       	call   80134b <fd_alloc>
  801f2b:	89 c3                	mov    %eax,%ebx
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	0f 88 f8 00 00 00    	js     80202d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f35:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f3c:	00 
  801f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4b:	e8 fc f0 ff ff       	call   80104c <sys_page_alloc>
  801f50:	89 c3                	mov    %eax,%ebx
  801f52:	85 c0                	test   %eax,%eax
  801f54:	0f 88 d3 00 00 00    	js     80202d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f5d:	89 04 24             	mov    %eax,(%esp)
  801f60:	e8 cb f3 ff ff       	call   801330 <fd2data>
  801f65:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f67:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f6e:	00 
  801f6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f7a:	e8 cd f0 ff ff       	call   80104c <sys_page_alloc>
  801f7f:	89 c3                	mov    %eax,%ebx
  801f81:	85 c0                	test   %eax,%eax
  801f83:	0f 88 91 00 00 00    	js     80201a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f8c:	89 04 24             	mov    %eax,(%esp)
  801f8f:	e8 9c f3 ff ff       	call   801330 <fd2data>
  801f94:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801f9b:	00 
  801f9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fa0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fa7:	00 
  801fa8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb3:	e8 f3 f0 ff ff       	call   8010ab <sys_page_map>
  801fb8:	89 c3                	mov    %eax,%ebx
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	78 4c                	js     80200a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801fbe:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fcc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fd3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fdc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fe1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801feb:	89 04 24             	mov    %eax,(%esp)
  801fee:	e8 2d f3 ff ff       	call   801320 <fd2num>
  801ff3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801ff5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ff8:	89 04 24             	mov    %eax,(%esp)
  801ffb:	e8 20 f3 ff ff       	call   801320 <fd2num>
  802000:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802003:	bb 00 00 00 00       	mov    $0x0,%ebx
  802008:	eb 36                	jmp    802040 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80200a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80200e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802015:	e8 ef f0 ff ff       	call   801109 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80201a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80201d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802021:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802028:	e8 dc f0 ff ff       	call   801109 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80202d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802030:	89 44 24 04          	mov    %eax,0x4(%esp)
  802034:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80203b:	e8 c9 f0 ff ff       	call   801109 <sys_page_unmap>
    err:
	return r;
}
  802040:	89 d8                	mov    %ebx,%eax
  802042:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802045:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802048:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80204b:	89 ec                	mov    %ebp,%esp
  80204d:	5d                   	pop    %ebp
  80204e:	c3                   	ret    

0080204f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802055:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	89 04 24             	mov    %eax,(%esp)
  802062:	e8 57 f3 ff ff       	call   8013be <fd_lookup>
  802067:	85 c0                	test   %eax,%eax
  802069:	78 15                	js     802080 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	89 04 24             	mov    %eax,(%esp)
  802071:	e8 ba f2 ff ff       	call   801330 <fd2data>
	return _pipeisclosed(fd, p);
  802076:	89 c2                	mov    %eax,%edx
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	e8 c2 fc ff ff       	call   801d42 <_pipeisclosed>
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    
	...

00802090 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	56                   	push   %esi
  802094:	53                   	push   %ebx
  802095:	83 ec 10             	sub    $0x10,%esp
  802098:	8b 75 08             	mov    0x8(%ebp),%esi
  80209b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  8020a1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  8020a3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8020a8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  8020ab:	89 04 24             	mov    %eax,(%esp)
  8020ae:	e8 02 f2 ff ff       	call   8012b5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  8020b3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  8020b8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	78 0e                	js     8020cf <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  8020c1:	a1 04 44 80 00       	mov    0x804404,%eax
  8020c6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  8020c9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  8020cc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  8020cf:	85 f6                	test   %esi,%esi
  8020d1:	74 02                	je     8020d5 <ipc_recv+0x45>
		*from_env_store = sender;
  8020d3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  8020d5:	85 db                	test   %ebx,%ebx
  8020d7:	74 02                	je     8020db <ipc_recv+0x4b>
		*perm_store = perm;
  8020d9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  8020db:	83 c4 10             	add    $0x10,%esp
  8020de:	5b                   	pop    %ebx
  8020df:	5e                   	pop    %esi
  8020e0:	5d                   	pop    %ebp
  8020e1:	c3                   	ret    

008020e2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	57                   	push   %edi
  8020e6:	56                   	push   %esi
  8020e7:	53                   	push   %ebx
  8020e8:	83 ec 1c             	sub    $0x1c,%esp
  8020eb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8020ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020f1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  8020f4:	85 db                	test   %ebx,%ebx
  8020f6:	75 04                	jne    8020fc <ipc_send+0x1a>
  8020f8:	85 f6                	test   %esi,%esi
  8020fa:	75 15                	jne    802111 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  8020fc:	85 db                	test   %ebx,%ebx
  8020fe:	74 16                	je     802116 <ipc_send+0x34>
  802100:	85 f6                	test   %esi,%esi
  802102:	0f 94 c0             	sete   %al
      pg = 0;
  802105:	84 c0                	test   %al,%al
  802107:	b8 00 00 00 00       	mov    $0x0,%eax
  80210c:	0f 45 d8             	cmovne %eax,%ebx
  80210f:	eb 05                	jmp    802116 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802111:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802116:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80211a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80211e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	89 04 24             	mov    %eax,(%esp)
  802128:	e8 54 f1 ff ff       	call   801281 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80212d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802130:	75 07                	jne    802139 <ipc_send+0x57>
           sys_yield();
  802132:	e8 e5 ee ff ff       	call   80101c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  802137:	eb dd                	jmp    802116 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  802139:	85 c0                	test   %eax,%eax
  80213b:	90                   	nop
  80213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802140:	74 1c                	je     80215e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802142:	c7 44 24 08 5e 29 80 	movl   $0x80295e,0x8(%esp)
  802149:	00 
  80214a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802151:	00 
  802152:	c7 04 24 68 29 80 00 	movl   $0x802968,(%esp)
  802159:	e8 de e1 ff ff       	call   80033c <_panic>
		}
    }
}
  80215e:	83 c4 1c             	add    $0x1c,%esp
  802161:	5b                   	pop    %ebx
  802162:	5e                   	pop    %esi
  802163:	5f                   	pop    %edi
  802164:	5d                   	pop    %ebp
  802165:	c3                   	ret    

00802166 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80216c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802171:	39 c8                	cmp    %ecx,%eax
  802173:	74 17                	je     80218c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802175:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80217a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80217d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802183:	8b 52 50             	mov    0x50(%edx),%edx
  802186:	39 ca                	cmp    %ecx,%edx
  802188:	75 14                	jne    80219e <ipc_find_env+0x38>
  80218a:	eb 05                	jmp    802191 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80218c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802191:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802194:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802199:	8b 40 40             	mov    0x40(%eax),%eax
  80219c:	eb 0e                	jmp    8021ac <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80219e:	83 c0 01             	add    $0x1,%eax
  8021a1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021a6:	75 d2                	jne    80217a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8021a8:	66 b8 00 00          	mov    $0x0,%ax
}
  8021ac:	5d                   	pop    %ebp
  8021ad:	c3                   	ret    
	...

008021b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021b6:	89 d0                	mov    %edx,%eax
  8021b8:	c1 e8 16             	shr    $0x16,%eax
  8021bb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021c2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021c7:	f6 c1 01             	test   $0x1,%cl
  8021ca:	74 1d                	je     8021e9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8021cc:	c1 ea 0c             	shr    $0xc,%edx
  8021cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021d6:	f6 c2 01             	test   $0x1,%dl
  8021d9:	74 0e                	je     8021e9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021db:	c1 ea 0c             	shr    $0xc,%edx
  8021de:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021e5:	ef 
  8021e6:	0f b7 c0             	movzwl %ax,%eax
}
  8021e9:	5d                   	pop    %ebp
  8021ea:	c3                   	ret    
  8021eb:	00 00                	add    %al,(%eax)
  8021ed:	00 00                	add    %al,(%eax)
	...

008021f0 <__udivdi3>:
  8021f0:	83 ec 1c             	sub    $0x1c,%esp
  8021f3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8021f7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8021fb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8021ff:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802203:	89 74 24 10          	mov    %esi,0x10(%esp)
  802207:	8b 74 24 24          	mov    0x24(%esp),%esi
  80220b:	85 ff                	test   %edi,%edi
  80220d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802211:	89 44 24 08          	mov    %eax,0x8(%esp)
  802215:	89 cd                	mov    %ecx,%ebp
  802217:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221b:	75 33                	jne    802250 <__udivdi3+0x60>
  80221d:	39 f1                	cmp    %esi,%ecx
  80221f:	77 57                	ja     802278 <__udivdi3+0x88>
  802221:	85 c9                	test   %ecx,%ecx
  802223:	75 0b                	jne    802230 <__udivdi3+0x40>
  802225:	b8 01 00 00 00       	mov    $0x1,%eax
  80222a:	31 d2                	xor    %edx,%edx
  80222c:	f7 f1                	div    %ecx
  80222e:	89 c1                	mov    %eax,%ecx
  802230:	89 f0                	mov    %esi,%eax
  802232:	31 d2                	xor    %edx,%edx
  802234:	f7 f1                	div    %ecx
  802236:	89 c6                	mov    %eax,%esi
  802238:	8b 44 24 04          	mov    0x4(%esp),%eax
  80223c:	f7 f1                	div    %ecx
  80223e:	89 f2                	mov    %esi,%edx
  802240:	8b 74 24 10          	mov    0x10(%esp),%esi
  802244:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802248:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80224c:	83 c4 1c             	add    $0x1c,%esp
  80224f:	c3                   	ret    
  802250:	31 d2                	xor    %edx,%edx
  802252:	31 c0                	xor    %eax,%eax
  802254:	39 f7                	cmp    %esi,%edi
  802256:	77 e8                	ja     802240 <__udivdi3+0x50>
  802258:	0f bd cf             	bsr    %edi,%ecx
  80225b:	83 f1 1f             	xor    $0x1f,%ecx
  80225e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802262:	75 2c                	jne    802290 <__udivdi3+0xa0>
  802264:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802268:	76 04                	jbe    80226e <__udivdi3+0x7e>
  80226a:	39 f7                	cmp    %esi,%edi
  80226c:	73 d2                	jae    802240 <__udivdi3+0x50>
  80226e:	31 d2                	xor    %edx,%edx
  802270:	b8 01 00 00 00       	mov    $0x1,%eax
  802275:	eb c9                	jmp    802240 <__udivdi3+0x50>
  802277:	90                   	nop
  802278:	89 f2                	mov    %esi,%edx
  80227a:	f7 f1                	div    %ecx
  80227c:	31 d2                	xor    %edx,%edx
  80227e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802282:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802286:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80228a:	83 c4 1c             	add    $0x1c,%esp
  80228d:	c3                   	ret    
  80228e:	66 90                	xchg   %ax,%ax
  802290:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802295:	b8 20 00 00 00       	mov    $0x20,%eax
  80229a:	89 ea                	mov    %ebp,%edx
  80229c:	2b 44 24 04          	sub    0x4(%esp),%eax
  8022a0:	d3 e7                	shl    %cl,%edi
  8022a2:	89 c1                	mov    %eax,%ecx
  8022a4:	d3 ea                	shr    %cl,%edx
  8022a6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022ab:	09 fa                	or     %edi,%edx
  8022ad:	89 f7                	mov    %esi,%edi
  8022af:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022b3:	89 f2                	mov    %esi,%edx
  8022b5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8022b9:	d3 e5                	shl    %cl,%ebp
  8022bb:	89 c1                	mov    %eax,%ecx
  8022bd:	d3 ef                	shr    %cl,%edi
  8022bf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022c4:	d3 e2                	shl    %cl,%edx
  8022c6:	89 c1                	mov    %eax,%ecx
  8022c8:	d3 ee                	shr    %cl,%esi
  8022ca:	09 d6                	or     %edx,%esi
  8022cc:	89 fa                	mov    %edi,%edx
  8022ce:	89 f0                	mov    %esi,%eax
  8022d0:	f7 74 24 0c          	divl   0xc(%esp)
  8022d4:	89 d7                	mov    %edx,%edi
  8022d6:	89 c6                	mov    %eax,%esi
  8022d8:	f7 e5                	mul    %ebp
  8022da:	39 d7                	cmp    %edx,%edi
  8022dc:	72 22                	jb     802300 <__udivdi3+0x110>
  8022de:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8022e2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022e7:	d3 e5                	shl    %cl,%ebp
  8022e9:	39 c5                	cmp    %eax,%ebp
  8022eb:	73 04                	jae    8022f1 <__udivdi3+0x101>
  8022ed:	39 d7                	cmp    %edx,%edi
  8022ef:	74 0f                	je     802300 <__udivdi3+0x110>
  8022f1:	89 f0                	mov    %esi,%eax
  8022f3:	31 d2                	xor    %edx,%edx
  8022f5:	e9 46 ff ff ff       	jmp    802240 <__udivdi3+0x50>
  8022fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802300:	8d 46 ff             	lea    -0x1(%esi),%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	8b 74 24 10          	mov    0x10(%esp),%esi
  802309:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80230d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802311:	83 c4 1c             	add    $0x1c,%esp
  802314:	c3                   	ret    
	...

00802320 <__umoddi3>:
  802320:	83 ec 1c             	sub    $0x1c,%esp
  802323:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802327:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80232b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80232f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802333:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802337:	8b 74 24 24          	mov    0x24(%esp),%esi
  80233b:	85 ed                	test   %ebp,%ebp
  80233d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802341:	89 44 24 08          	mov    %eax,0x8(%esp)
  802345:	89 cf                	mov    %ecx,%edi
  802347:	89 04 24             	mov    %eax,(%esp)
  80234a:	89 f2                	mov    %esi,%edx
  80234c:	75 1a                	jne    802368 <__umoddi3+0x48>
  80234e:	39 f1                	cmp    %esi,%ecx
  802350:	76 4e                	jbe    8023a0 <__umoddi3+0x80>
  802352:	f7 f1                	div    %ecx
  802354:	89 d0                	mov    %edx,%eax
  802356:	31 d2                	xor    %edx,%edx
  802358:	8b 74 24 10          	mov    0x10(%esp),%esi
  80235c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802360:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802364:	83 c4 1c             	add    $0x1c,%esp
  802367:	c3                   	ret    
  802368:	39 f5                	cmp    %esi,%ebp
  80236a:	77 54                	ja     8023c0 <__umoddi3+0xa0>
  80236c:	0f bd c5             	bsr    %ebp,%eax
  80236f:	83 f0 1f             	xor    $0x1f,%eax
  802372:	89 44 24 04          	mov    %eax,0x4(%esp)
  802376:	75 60                	jne    8023d8 <__umoddi3+0xb8>
  802378:	3b 0c 24             	cmp    (%esp),%ecx
  80237b:	0f 87 07 01 00 00    	ja     802488 <__umoddi3+0x168>
  802381:	89 f2                	mov    %esi,%edx
  802383:	8b 34 24             	mov    (%esp),%esi
  802386:	29 ce                	sub    %ecx,%esi
  802388:	19 ea                	sbb    %ebp,%edx
  80238a:	89 34 24             	mov    %esi,(%esp)
  80238d:	8b 04 24             	mov    (%esp),%eax
  802390:	8b 74 24 10          	mov    0x10(%esp),%esi
  802394:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802398:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80239c:	83 c4 1c             	add    $0x1c,%esp
  80239f:	c3                   	ret    
  8023a0:	85 c9                	test   %ecx,%ecx
  8023a2:	75 0b                	jne    8023af <__umoddi3+0x8f>
  8023a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a9:	31 d2                	xor    %edx,%edx
  8023ab:	f7 f1                	div    %ecx
  8023ad:	89 c1                	mov    %eax,%ecx
  8023af:	89 f0                	mov    %esi,%eax
  8023b1:	31 d2                	xor    %edx,%edx
  8023b3:	f7 f1                	div    %ecx
  8023b5:	8b 04 24             	mov    (%esp),%eax
  8023b8:	f7 f1                	div    %ecx
  8023ba:	eb 98                	jmp    802354 <__umoddi3+0x34>
  8023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023c0:	89 f2                	mov    %esi,%edx
  8023c2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8023c6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8023ca:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	c3                   	ret    
  8023d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023d8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023dd:	89 e8                	mov    %ebp,%eax
  8023df:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023e4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8023e8:	89 fa                	mov    %edi,%edx
  8023ea:	d3 e0                	shl    %cl,%eax
  8023ec:	89 e9                	mov    %ebp,%ecx
  8023ee:	d3 ea                	shr    %cl,%edx
  8023f0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023f5:	09 c2                	or     %eax,%edx
  8023f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023fb:	89 14 24             	mov    %edx,(%esp)
  8023fe:	89 f2                	mov    %esi,%edx
  802400:	d3 e7                	shl    %cl,%edi
  802402:	89 e9                	mov    %ebp,%ecx
  802404:	d3 ea                	shr    %cl,%edx
  802406:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80240b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80240f:	d3 e6                	shl    %cl,%esi
  802411:	89 e9                	mov    %ebp,%ecx
  802413:	d3 e8                	shr    %cl,%eax
  802415:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80241a:	09 f0                	or     %esi,%eax
  80241c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802420:	f7 34 24             	divl   (%esp)
  802423:	d3 e6                	shl    %cl,%esi
  802425:	89 74 24 08          	mov    %esi,0x8(%esp)
  802429:	89 d6                	mov    %edx,%esi
  80242b:	f7 e7                	mul    %edi
  80242d:	39 d6                	cmp    %edx,%esi
  80242f:	89 c1                	mov    %eax,%ecx
  802431:	89 d7                	mov    %edx,%edi
  802433:	72 3f                	jb     802474 <__umoddi3+0x154>
  802435:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802439:	72 35                	jb     802470 <__umoddi3+0x150>
  80243b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80243f:	29 c8                	sub    %ecx,%eax
  802441:	19 fe                	sbb    %edi,%esi
  802443:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802448:	89 f2                	mov    %esi,%edx
  80244a:	d3 e8                	shr    %cl,%eax
  80244c:	89 e9                	mov    %ebp,%ecx
  80244e:	d3 e2                	shl    %cl,%edx
  802450:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802455:	09 d0                	or     %edx,%eax
  802457:	89 f2                	mov    %esi,%edx
  802459:	d3 ea                	shr    %cl,%edx
  80245b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80245f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802463:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802467:	83 c4 1c             	add    $0x1c,%esp
  80246a:	c3                   	ret    
  80246b:	90                   	nop
  80246c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802470:	39 d6                	cmp    %edx,%esi
  802472:	75 c7                	jne    80243b <__umoddi3+0x11b>
  802474:	89 d7                	mov    %edx,%edi
  802476:	89 c1                	mov    %eax,%ecx
  802478:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80247c:	1b 3c 24             	sbb    (%esp),%edi
  80247f:	eb ba                	jmp    80243b <__umoddi3+0x11b>
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	39 f5                	cmp    %esi,%ebp
  80248a:	0f 82 f1 fe ff ff    	jb     802381 <__umoddi3+0x61>
  802490:	e9 f8 fe ff ff       	jmp    80238d <__umoddi3+0x6d>
