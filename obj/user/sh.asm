
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 df 09 00 00       	call   800a10 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	83 ec 1c             	sub    $0x1c,%esp
  800049:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int t;

	if (s == 0) {
  80004c:	85 db                	test   %ebx,%ebx
  80004e:	75 23                	jne    800073 <_gettoken+0x33>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
  800050:	be 00 00 00 00       	mov    $0x0,%esi
_gettoken(char *s, char **p1, char **p2)
{
	int t;

	if (s == 0) {
		if (debug > 1)
  800055:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80005c:	0f 8e 37 01 00 00    	jle    800199 <_gettoken+0x159>
			cprintf("GETTOKEN NULL\n");
  800062:	c7 04 24 80 38 80 00 	movl   $0x803880,(%esp)
  800069:	e8 09 0b 00 00       	call   800b77 <cprintf>
  80006e:	e9 26 01 00 00       	jmp    800199 <_gettoken+0x159>
		return 0;
	}

	if (debug > 1)
  800073:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80007a:	7e 10                	jle    80008c <_gettoken+0x4c>
		cprintf("GETTOKEN: %s\n", s);
  80007c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800080:	c7 04 24 8f 38 80 00 	movl   $0x80388f,(%esp)
  800087:	e8 eb 0a 00 00       	call   800b77 <cprintf>

	*p1 = 0;
  80008c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80008f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*p2 = 0;
  800095:	8b 55 10             	mov    0x10(%ebp),%edx
  800098:	c7 02 00 00 00 00    	movl   $0x0,(%edx)

	while (strchr(WHITESPACE, *s))
  80009e:	eb 06                	jmp    8000a6 <_gettoken+0x66>
		*s++ = 0;
  8000a0:	c6 03 00             	movb   $0x0,(%ebx)
  8000a3:	83 c3 01             	add    $0x1,%ebx
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8000a6:	0f be 03             	movsbl (%ebx),%eax
  8000a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ad:	c7 04 24 9d 38 80 00 	movl   $0x80389d,(%esp)
  8000b4:	e8 0d 13 00 00       	call   8013c6 <strchr>
  8000b9:	85 c0                	test   %eax,%eax
  8000bb:	75 e3                	jne    8000a0 <_gettoken+0x60>
  8000bd:	89 df                	mov    %ebx,%edi
		*s++ = 0;
	if (*s == 0) {
  8000bf:	0f b6 03             	movzbl (%ebx),%eax
  8000c2:	84 c0                	test   %al,%al
  8000c4:	75 23                	jne    8000e9 <_gettoken+0xa9>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000c6:	be 00 00 00 00       	mov    $0x0,%esi
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
		*s++ = 0;
	if (*s == 0) {
		if (debug > 1)
  8000cb:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  8000d2:	0f 8e c1 00 00 00    	jle    800199 <_gettoken+0x159>
			cprintf("EOL\n");
  8000d8:	c7 04 24 a2 38 80 00 	movl   $0x8038a2,(%esp)
  8000df:	e8 93 0a 00 00       	call   800b77 <cprintf>
  8000e4:	e9 b0 00 00 00       	jmp    800199 <_gettoken+0x159>
		return 0;
	}
	if (strchr(SYMBOLS, *s)) {
  8000e9:	0f be c0             	movsbl %al,%eax
  8000ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000f0:	c7 04 24 b3 38 80 00 	movl   $0x8038b3,(%esp)
  8000f7:	e8 ca 12 00 00       	call   8013c6 <strchr>
  8000fc:	85 c0                	test   %eax,%eax
  8000fe:	74 2e                	je     80012e <_gettoken+0xee>
		t = *s;
  800100:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  800103:	8b 45 0c             	mov    0xc(%ebp),%eax
  800106:	89 18                	mov    %ebx,(%eax)
		*s++ = 0;
  800108:	c6 03 00             	movb   $0x0,(%ebx)
  80010b:	83 c7 01             	add    $0x1,%edi
  80010e:	8b 55 10             	mov    0x10(%ebp),%edx
  800111:	89 3a                	mov    %edi,(%edx)
		*p2 = s;
		if (debug > 1)
  800113:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80011a:	7e 7d                	jle    800199 <_gettoken+0x159>
			cprintf("TOK %c\n", t);
  80011c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800120:	c7 04 24 a7 38 80 00 	movl   $0x8038a7,(%esp)
  800127:	e8 4b 0a 00 00       	call   800b77 <cprintf>
  80012c:	eb 6b                	jmp    800199 <_gettoken+0x159>
		return t;
	}
	*p1 = s;
  80012e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800131:	89 18                	mov    %ebx,(%eax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800133:	0f b6 03             	movzbl (%ebx),%eax
  800136:	84 c0                	test   %al,%al
  800138:	75 0c                	jne    800146 <_gettoken+0x106>
  80013a:	eb 21                	jmp    80015d <_gettoken+0x11d>
		s++;
  80013c:	83 c3 01             	add    $0x1,%ebx
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80013f:	0f b6 03             	movzbl (%ebx),%eax
  800142:	84 c0                	test   %al,%al
  800144:	74 17                	je     80015d <_gettoken+0x11d>
  800146:	0f be c0             	movsbl %al,%eax
  800149:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014d:	c7 04 24 af 38 80 00 	movl   $0x8038af,(%esp)
  800154:	e8 6d 12 00 00       	call   8013c6 <strchr>
  800159:	85 c0                	test   %eax,%eax
  80015b:	74 df                	je     80013c <_gettoken+0xfc>
		s++;
	*p2 = s;
  80015d:	8b 55 10             	mov    0x10(%ebp),%edx
  800160:	89 1a                	mov    %ebx,(%edx)
		t = **p2;
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
  800162:	be 77 00 00 00       	mov    $0x77,%esi
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
		s++;
	*p2 = s;
	if (debug > 1) {
  800167:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80016e:	7e 29                	jle    800199 <_gettoken+0x159>
		t = **p2;
  800170:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800173:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  800176:	8b 55 0c             	mov    0xc(%ebp),%edx
  800179:	8b 02                	mov    (%edx),%eax
  80017b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017f:	c7 04 24 bb 38 80 00 	movl   $0x8038bb,(%esp)
  800186:	e8 ec 09 00 00       	call   800b77 <cprintf>
		**p2 = t;
  80018b:	8b 55 10             	mov    0x10(%ebp),%edx
  80018e:	8b 02                	mov    (%edx),%eax
  800190:	89 f2                	mov    %esi,%edx
  800192:	88 10                	mov    %dl,(%eax)
	}
	return 'w';
  800194:	be 77 00 00 00       	mov    $0x77,%esi
}
  800199:	89 f0                	mov    %esi,%eax
  80019b:	83 c4 1c             	add    $0x1c,%esp
  80019e:	5b                   	pop    %ebx
  80019f:	5e                   	pop    %esi
  8001a0:	5f                   	pop    %edi
  8001a1:	5d                   	pop    %ebp
  8001a2:	c3                   	ret    

008001a3 <gettoken>:

int
gettoken(char *s, char **p1)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	83 ec 18             	sub    $0x18,%esp
  8001a9:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001ac:	85 c0                	test   %eax,%eax
  8001ae:	74 24                	je     8001d4 <gettoken+0x31>
		nc = _gettoken(s, &np1, &np2);
  8001b0:	c7 44 24 08 08 60 80 	movl   $0x806008,0x8(%esp)
  8001b7:	00 
  8001b8:	c7 44 24 04 04 60 80 	movl   $0x806004,0x4(%esp)
  8001bf:	00 
  8001c0:	89 04 24             	mov    %eax,(%esp)
  8001c3:	e8 78 fe ff ff       	call   800040 <_gettoken>
  8001c8:	a3 0c 60 80 00       	mov    %eax,0x80600c
		return 0;
  8001cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d2:	eb 3c                	jmp    800210 <gettoken+0x6d>
	}
	c = nc;
  8001d4:	a1 0c 60 80 00       	mov    0x80600c,%eax
  8001d9:	a3 10 60 80 00       	mov    %eax,0x806010
	*p1 = np1;
  8001de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e1:	8b 15 04 60 80 00    	mov    0x806004,%edx
  8001e7:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001e9:	c7 44 24 08 08 60 80 	movl   $0x806008,0x8(%esp)
  8001f0:	00 
  8001f1:	c7 44 24 04 04 60 80 	movl   $0x806004,0x4(%esp)
  8001f8:	00 
  8001f9:	a1 08 60 80 00       	mov    0x806008,%eax
  8001fe:	89 04 24             	mov    %eax,(%esp)
  800201:	e8 3a fe ff ff       	call   800040 <_gettoken>
  800206:	a3 0c 60 80 00       	mov    %eax,0x80600c
	return c;
  80020b:	a1 10 60 80 00       	mov    0x806010,%eax
}
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	57                   	push   %edi
  800216:	56                   	push   %esi
  800217:	53                   	push   %ebx
  800218:	81 ec 6c 04 00 00    	sub    $0x46c,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);
  80021e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800225:	00 
  800226:	8b 45 08             	mov    0x8(%ebp),%eax
  800229:	89 04 24             	mov    %eax,(%esp)
  80022c:	e8 72 ff ff ff       	call   8001a3 <gettoken>

again:
	argc = 0;
  800231:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		switch ((c = gettoken(0, &t))) {
  800236:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
  800239:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80023d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800244:	e8 5a ff ff ff       	call   8001a3 <gettoken>
  800249:	83 f8 77             	cmp    $0x77,%eax
  80024c:	74 37                	je     800285 <runcmd+0x73>
  80024e:	83 f8 77             	cmp    $0x77,%eax
  800251:	7f 20                	jg     800273 <runcmd+0x61>
  800253:	83 f8 3c             	cmp    $0x3c,%eax
  800256:	74 4f                	je     8002a7 <runcmd+0x95>
  800258:	83 f8 3e             	cmp    $0x3e,%eax
  80025b:	0f 84 c8 00 00 00    	je     800329 <runcmd+0x117>
runcmd(char* s)
{
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800261:	bf 00 00 00 00       	mov    $0x0,%edi
	gettoken(s, 0);

again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {
  800266:	85 c0                	test   %eax,%eax
  800268:	0f 84 49 02 00 00    	je     8004b7 <runcmd+0x2a5>
  80026e:	e9 24 02 00 00       	jmp    800497 <runcmd+0x285>
  800273:	83 f8 7c             	cmp    $0x7c,%eax
  800276:	0f 85 1b 02 00 00    	jne    800497 <runcmd+0x285>
  80027c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800280:	e9 25 01 00 00       	jmp    8003aa <runcmd+0x198>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  800285:	83 fe 10             	cmp    $0x10,%esi
  800288:	75 11                	jne    80029b <runcmd+0x89>
				cprintf("too many arguments\n");
  80028a:	c7 04 24 c5 38 80 00 	movl   $0x8038c5,(%esp)
  800291:	e8 e1 08 00 00       	call   800b77 <cprintf>
				exit();
  800296:	e8 c5 07 00 00       	call   800a60 <exit>
			}
			argv[argc++] = t;
  80029b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80029e:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  8002a2:	83 c6 01             	add    $0x1,%esi
			break;
  8002a5:	eb 92                	jmp    800239 <runcmd+0x27>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8002a7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002b2:	e8 ec fe ff ff       	call   8001a3 <gettoken>
  8002b7:	83 f8 77             	cmp    $0x77,%eax
  8002ba:	74 11                	je     8002cd <runcmd+0xbb>
				cprintf("syntax error: < not followed by word\n");
  8002bc:	c7 04 24 10 3a 80 00 	movl   $0x803a10,(%esp)
  8002c3:	e8 af 08 00 00       	call   800b77 <cprintf>
				exit();
  8002c8:	e8 93 07 00 00       	call   800a60 <exit>
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  8002cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002d4:	00 
  8002d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002d8:	89 04 24             	mov    %eax,(%esp)
  8002db:	e8 3c 24 00 00       	call   80271c <open>
  8002e0:	89 c7                	mov    %eax,%edi
  8002e2:	85 c0                	test   %eax,%eax
  8002e4:	79 1e                	jns    800304 <runcmd+0xf2>
				cprintf("open %s for read: %e", t, fd);
  8002e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ea:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f1:	c7 04 24 d9 38 80 00 	movl   $0x8038d9,(%esp)
  8002f8:	e8 7a 08 00 00       	call   800b77 <cprintf>
				exit();
  8002fd:	e8 5e 07 00 00       	call   800a60 <exit>
  800302:	eb 08                	jmp    80030c <runcmd+0xfa>
			}
			if (fd != 0) {
  800304:	85 c0                	test   %eax,%eax
  800306:	0f 84 2d ff ff ff    	je     800239 <runcmd+0x27>
				dup(fd, 0);
  80030c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800313:	00 
  800314:	89 3c 24             	mov    %edi,(%esp)
  800317:	e8 74 1e 00 00       	call   802190 <dup>
				close(fd);
  80031c:	89 3c 24             	mov    %edi,(%esp)
  80031f:	e8 19 1e 00 00       	call   80213d <close>
  800324:	e9 10 ff ff ff       	jmp    800239 <runcmd+0x27>
			}
			break;

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  800329:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80032d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800334:	e8 6a fe ff ff       	call   8001a3 <gettoken>
  800339:	83 f8 77             	cmp    $0x77,%eax
  80033c:	74 11                	je     80034f <runcmd+0x13d>
				cprintf("syntax error: > not followed by word\n");
  80033e:	c7 04 24 38 3a 80 00 	movl   $0x803a38,(%esp)
  800345:	e8 2d 08 00 00       	call   800b77 <cprintf>
				exit();
  80034a:	e8 11 07 00 00       	call   800a60 <exit>
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80034f:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  800356:	00 
  800357:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80035a:	89 04 24             	mov    %eax,(%esp)
  80035d:	e8 ba 23 00 00       	call   80271c <open>
  800362:	89 c7                	mov    %eax,%edi
  800364:	85 c0                	test   %eax,%eax
  800366:	79 1c                	jns    800384 <runcmd+0x172>
				cprintf("open %s for write: %e", t, fd);
  800368:	89 44 24 08          	mov    %eax,0x8(%esp)
  80036c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80036f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800373:	c7 04 24 ee 38 80 00 	movl   $0x8038ee,(%esp)
  80037a:	e8 f8 07 00 00       	call   800b77 <cprintf>
				exit();
  80037f:	e8 dc 06 00 00       	call   800a60 <exit>
			}
			if (fd != 1) {
  800384:	83 ff 01             	cmp    $0x1,%edi
  800387:	0f 84 ac fe ff ff    	je     800239 <runcmd+0x27>
				dup(fd, 1);
  80038d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800394:	00 
  800395:	89 3c 24             	mov    %edi,(%esp)
  800398:	e8 f3 1d 00 00       	call   802190 <dup>
				close(fd);
  80039d:	89 3c 24             	mov    %edi,(%esp)
  8003a0:	e8 98 1d 00 00       	call   80213d <close>
  8003a5:	e9 8f fe ff ff       	jmp    800239 <runcmd+0x27>
			}
			break;

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8003aa:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8003b0:	89 04 24             	mov    %eax,(%esp)
  8003b3:	e8 ec 2d 00 00       	call   8031a4 <pipe>
  8003b8:	85 c0                	test   %eax,%eax
  8003ba:	79 15                	jns    8003d1 <runcmd+0x1bf>
				cprintf("pipe: %e", r);
  8003bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c0:	c7 04 24 04 39 80 00 	movl   $0x803904,(%esp)
  8003c7:	e8 ab 07 00 00       	call   800b77 <cprintf>
				exit();
  8003cc:	e8 8f 06 00 00       	call   800a60 <exit>
			}
			if (debug)
  8003d1:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8003d8:	74 20                	je     8003fa <runcmd+0x1e8>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  8003da:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  8003e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e4:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8003ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ee:	c7 04 24 0d 39 80 00 	movl   $0x80390d,(%esp)
  8003f5:	e8 7d 07 00 00       	call   800b77 <cprintf>
			if ((r = fork()) < 0) {
  8003fa:	e8 54 17 00 00       	call   801b53 <fork>
  8003ff:	89 c7                	mov    %eax,%edi
  800401:	85 c0                	test   %eax,%eax
  800403:	79 15                	jns    80041a <runcmd+0x208>
				cprintf("fork: %e", r);
  800405:	89 44 24 04          	mov    %eax,0x4(%esp)
  800409:	c7 04 24 65 3f 80 00 	movl   $0x803f65,(%esp)
  800410:	e8 62 07 00 00       	call   800b77 <cprintf>
				exit();
  800415:	e8 46 06 00 00       	call   800a60 <exit>
			}
			if (r == 0) {
  80041a:	85 ff                	test   %edi,%edi
  80041c:	75 40                	jne    80045e <runcmd+0x24c>
				if (p[0] != 0) {
  80041e:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800424:	85 c0                	test   %eax,%eax
  800426:	74 1e                	je     800446 <runcmd+0x234>
					dup(p[0], 0);
  800428:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80042f:	00 
  800430:	89 04 24             	mov    %eax,(%esp)
  800433:	e8 58 1d 00 00       	call   802190 <dup>
					close(p[0]);
  800438:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80043e:	89 04 24             	mov    %eax,(%esp)
  800441:	e8 f7 1c 00 00       	call   80213d <close>
				}
				close(p[1]);
  800446:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80044c:	89 04 24             	mov    %eax,(%esp)
  80044f:	e8 e9 1c 00 00       	call   80213d <close>

	pipe_child = 0;
	gettoken(s, 0);

again:
	argc = 0;
  800454:	be 00 00 00 00       	mov    $0x0,%esi
				if (p[0] != 0) {
					dup(p[0], 0);
					close(p[0]);
				}
				close(p[1]);
				goto again;
  800459:	e9 db fd ff ff       	jmp    800239 <runcmd+0x27>
			} else {
				pipe_child = r;
				if (p[1] != 1) {
  80045e:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800464:	83 f8 01             	cmp    $0x1,%eax
  800467:	74 1e                	je     800487 <runcmd+0x275>
					dup(p[1], 1);
  800469:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800470:	00 
  800471:	89 04 24             	mov    %eax,(%esp)
  800474:	e8 17 1d 00 00       	call   802190 <dup>
					close(p[1]);
  800479:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80047f:	89 04 24             	mov    %eax,(%esp)
  800482:	e8 b6 1c 00 00       	call   80213d <close>
				}
				close(p[0]);
  800487:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80048d:	89 04 24             	mov    %eax,(%esp)
  800490:	e8 a8 1c 00 00       	call   80213d <close>
				goto runit;
  800495:	eb 20                	jmp    8004b7 <runcmd+0x2a5>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800497:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80049b:	c7 44 24 08 1a 39 80 	movl   $0x80391a,0x8(%esp)
  8004a2:	00 
  8004a3:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8004aa:	00 
  8004ab:	c7 04 24 36 39 80 00 	movl   $0x803936,(%esp)
  8004b2:	e8 c5 05 00 00       	call   800a7c <_panic>
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  8004b7:	85 f6                	test   %esi,%esi
  8004b9:	75 1e                	jne    8004d9 <runcmd+0x2c7>
		if (debug)
  8004bb:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004c2:	0f 84 7b 01 00 00    	je     800643 <runcmd+0x431>
			cprintf("EMPTY COMMAND\n");
  8004c8:	c7 04 24 40 39 80 00 	movl   $0x803940,(%esp)
  8004cf:	e8 a3 06 00 00       	call   800b77 <cprintf>
  8004d4:	e9 6a 01 00 00       	jmp    800643 <runcmd+0x431>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  8004d9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004dc:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004df:	74 22                	je     800503 <runcmd+0x2f1>
		argv0buf[0] = '/';
  8004e1:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  8004e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ec:	8d 9d a4 fb ff ff    	lea    -0x45c(%ebp),%ebx
  8004f2:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  8004f8:	89 04 24             	mov    %eax,(%esp)
  8004fb:	e8 8b 0d 00 00       	call   80128b <strcpy>
		argv[0] = argv0buf;
  800500:	89 5d a8             	mov    %ebx,-0x58(%ebp)
	}
	argv[argc] = 0;
  800503:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  80050a:	00 

	// Print the command.
	if (debug) {
  80050b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800512:	74 48                	je     80055c <runcmd+0x34a>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800514:	a1 24 64 80 00       	mov    0x806424,%eax
  800519:	8b 40 48             	mov    0x48(%eax),%eax
  80051c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800520:	c7 04 24 4f 39 80 00 	movl   $0x80394f,(%esp)
  800527:	e8 4b 06 00 00       	call   800b77 <cprintf>
		for (i = 0; argv[i]; i++)
  80052c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80052f:	85 c0                	test   %eax,%eax
  800531:	74 1d                	je     800550 <runcmd+0x33e>
  800533:	8d 5d ac             	lea    -0x54(%ebp),%ebx
			cprintf(" %s", argv[i]);
  800536:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053a:	c7 04 24 da 39 80 00 	movl   $0x8039da,(%esp)
  800541:	e8 31 06 00 00       	call   800b77 <cprintf>
  800546:	83 c3 04             	add    $0x4,%ebx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800549:	8b 43 fc             	mov    -0x4(%ebx),%eax
  80054c:	85 c0                	test   %eax,%eax
  80054e:	75 e6                	jne    800536 <runcmd+0x324>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  800550:	c7 04 24 a0 38 80 00 	movl   $0x8038a0,(%esp)
  800557:	e8 1b 06 00 00       	call   800b77 <cprintf>
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  80055c:	8d 45 a8             	lea    -0x58(%ebp),%eax
  80055f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800563:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800566:	89 04 24             	mov    %eax,(%esp)
  800569:	e8 6e 23 00 00       	call   8028dc <spawn>
  80056e:	89 c3                	mov    %eax,%ebx
  800570:	85 c0                	test   %eax,%eax
  800572:	79 1e                	jns    800592 <runcmd+0x380>
		cprintf("spawn %s: %e\n", argv[0], r);
  800574:	89 44 24 08          	mov    %eax,0x8(%esp)
  800578:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80057b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80057f:	c7 04 24 5d 39 80 00 	movl   $0x80395d,(%esp)
  800586:	e8 ec 05 00 00       	call   800b77 <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  80058b:	e8 de 1b 00 00       	call   80216e <close_all>
  800590:	eb 5a                	jmp    8005ec <runcmd+0x3da>
  800592:	e8 d7 1b 00 00       	call   80216e <close_all>
	if (r >= 0) {
		if (debug)
  800597:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80059e:	74 23                	je     8005c3 <runcmd+0x3b1>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8005a0:	a1 24 64 80 00       	mov    0x806424,%eax
  8005a5:	8b 40 48             	mov    0x48(%eax),%eax
  8005a8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005ac:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8005af:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b7:	c7 04 24 6b 39 80 00 	movl   $0x80396b,(%esp)
  8005be:	e8 b4 05 00 00       	call   800b77 <cprintf>
		wait(r);
  8005c3:	89 1c 24             	mov    %ebx,(%esp)
  8005c6:	e8 89 2d 00 00       	call   803354 <wait>
		if (debug)
  8005cb:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005d2:	74 18                	je     8005ec <runcmd+0x3da>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8005d4:	a1 24 64 80 00       	mov    0x806424,%eax
  8005d9:	8b 40 48             	mov    0x48(%eax),%eax
  8005dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e0:	c7 04 24 80 39 80 00 	movl   $0x803980,(%esp)
  8005e7:	e8 8b 05 00 00       	call   800b77 <cprintf>
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  8005ec:	85 ff                	test   %edi,%edi
  8005ee:	74 4e                	je     80063e <runcmd+0x42c>
		if (debug)
  8005f0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005f7:	74 1c                	je     800615 <runcmd+0x403>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  8005f9:	a1 24 64 80 00       	mov    0x806424,%eax
  8005fe:	8b 40 48             	mov    0x48(%eax),%eax
  800601:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800605:	89 44 24 04          	mov    %eax,0x4(%esp)
  800609:	c7 04 24 96 39 80 00 	movl   $0x803996,(%esp)
  800610:	e8 62 05 00 00       	call   800b77 <cprintf>
		wait(pipe_child);
  800615:	89 3c 24             	mov    %edi,(%esp)
  800618:	e8 37 2d 00 00       	call   803354 <wait>
		if (debug)
  80061d:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800624:	74 18                	je     80063e <runcmd+0x42c>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800626:	a1 24 64 80 00       	mov    0x806424,%eax
  80062b:	8b 40 48             	mov    0x48(%eax),%eax
  80062e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800632:	c7 04 24 80 39 80 00 	movl   $0x803980,(%esp)
  800639:	e8 39 05 00 00       	call   800b77 <cprintf>
	}

	// Done!
	exit();
  80063e:	e8 1d 04 00 00       	call   800a60 <exit>
}
  800643:	81 c4 6c 04 00 00    	add    $0x46c,%esp
  800649:	5b                   	pop    %ebx
  80064a:	5e                   	pop    %esi
  80064b:	5f                   	pop    %edi
  80064c:	5d                   	pop    %ebp
  80064d:	c3                   	ret    

0080064e <usage>:
}


void
usage(void)
{
  80064e:	55                   	push   %ebp
  80064f:	89 e5                	mov    %esp,%ebp
  800651:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800654:	c7 04 24 60 3a 80 00 	movl   $0x803a60,(%esp)
  80065b:	e8 17 05 00 00       	call   800b77 <cprintf>
	exit();
  800660:	e8 fb 03 00 00       	call   800a60 <exit>
}
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <umain>:

void
umain(int argc, char **argv)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	57                   	push   %edi
  80066b:	56                   	push   %esi
  80066c:	53                   	push   %ebx
  80066d:	83 ec 4c             	sub    $0x4c,%esp
  800670:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  800673:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800676:	89 44 24 08          	mov    %eax,0x8(%esp)
  80067a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80067e:	8d 45 08             	lea    0x8(%ebp),%eax
  800681:	89 04 24             	mov    %eax,(%esp)
  800684:	e8 6b 17 00 00       	call   801df4 <argstart>
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
  800689:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
umain(int argc, char **argv)
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
  800690:	bf 3f 00 00 00       	mov    $0x3f,%edi
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800695:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800698:	eb 2f                	jmp    8006c9 <umain+0x62>
		switch (r) {
  80069a:	83 f8 69             	cmp    $0x69,%eax
  80069d:	74 0c                	je     8006ab <umain+0x44>
  80069f:	83 f8 78             	cmp    $0x78,%eax
  8006a2:	74 1e                	je     8006c2 <umain+0x5b>
  8006a4:	83 f8 64             	cmp    $0x64,%eax
  8006a7:	75 12                	jne    8006bb <umain+0x54>
  8006a9:	eb 07                	jmp    8006b2 <umain+0x4b>
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006ab:	bf 01 00 00 00       	mov    $0x1,%edi
  8006b0:	eb 17                	jmp    8006c9 <umain+0x62>
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
		switch (r) {
		case 'd':
			debug++;
  8006b2:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
			break;
  8006b9:	eb 0e                	jmp    8006c9 <umain+0x62>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  8006bb:	e8 8e ff ff ff       	call   80064e <usage>
  8006c0:	eb 07                	jmp    8006c9 <umain+0x62>
			break;
		case 'i':
			interactive = 1;
			break;
		case 'x':
			echocmds = 1;
  8006c2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  8006c9:	89 1c 24             	mov    %ebx,(%esp)
  8006cc:	e8 53 17 00 00       	call   801e24 <argnext>
  8006d1:	85 c0                	test   %eax,%eax
  8006d3:	79 c5                	jns    80069a <umain+0x33>
  8006d5:	89 fb                	mov    %edi,%ebx
			break;
		default:
			usage();
		}

	if (argc > 2)
  8006d7:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006db:	7e 05                	jle    8006e2 <umain+0x7b>
		usage();
  8006dd:	e8 6c ff ff ff       	call   80064e <usage>
	if (argc == 2) {
  8006e2:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006e6:	75 72                	jne    80075a <umain+0xf3>
		close(0);
  8006e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006ef:	e8 49 1a 00 00       	call   80213d <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  8006f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8006fb:	00 
  8006fc:	8b 46 04             	mov    0x4(%esi),%eax
  8006ff:	89 04 24             	mov    %eax,(%esp)
  800702:	e8 15 20 00 00       	call   80271c <open>
  800707:	85 c0                	test   %eax,%eax
  800709:	79 27                	jns    800732 <umain+0xcb>
			panic("open %s: %e", argv[1], r);
  80070b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80070f:	8b 46 04             	mov    0x4(%esi),%eax
  800712:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800716:	c7 44 24 08 b6 39 80 	movl   $0x8039b6,0x8(%esp)
  80071d:	00 
  80071e:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  800725:	00 
  800726:	c7 04 24 36 39 80 00 	movl   $0x803936,(%esp)
  80072d:	e8 4a 03 00 00       	call   800a7c <_panic>
		assert(r == 0);
  800732:	85 c0                	test   %eax,%eax
  800734:	74 24                	je     80075a <umain+0xf3>
  800736:	c7 44 24 0c c2 39 80 	movl   $0x8039c2,0xc(%esp)
  80073d:	00 
  80073e:	c7 44 24 08 c9 39 80 	movl   $0x8039c9,0x8(%esp)
  800745:	00 
  800746:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  80074d:	00 
  80074e:	c7 04 24 36 39 80 00 	movl   $0x803936,(%esp)
  800755:	e8 22 03 00 00       	call   800a7c <_panic>
	}
	if (interactive == '?')
  80075a:	83 fb 3f             	cmp    $0x3f,%ebx
  80075d:	75 0e                	jne    80076d <umain+0x106>
		interactive = iscons(0);
  80075f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800766:	e8 23 02 00 00       	call   80098e <iscons>
  80076b:	89 c7                	mov    %eax,%edi

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  80076d:	85 ff                	test   %edi,%edi
  80076f:	b8 00 00 00 00       	mov    $0x0,%eax
  800774:	ba b3 39 80 00       	mov    $0x8039b3,%edx
  800779:	0f 45 c2             	cmovne %edx,%eax
  80077c:	89 04 24             	mov    %eax,(%esp)
  80077f:	e8 cc 09 00 00       	call   801150 <readline>
  800784:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  800786:	85 c0                	test   %eax,%eax
  800788:	75 1a                	jne    8007a4 <umain+0x13d>
			if (debug)
  80078a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800791:	74 0c                	je     80079f <umain+0x138>
				cprintf("EXITING\n");
  800793:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  80079a:	e8 d8 03 00 00       	call   800b77 <cprintf>
			exit();	// end of file
  80079f:	e8 bc 02 00 00       	call   800a60 <exit>
		}
		if (debug)
  8007a4:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007ab:	74 10                	je     8007bd <umain+0x156>
			cprintf("LINE: %s\n", buf);
  8007ad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007b1:	c7 04 24 e7 39 80 00 	movl   $0x8039e7,(%esp)
  8007b8:	e8 ba 03 00 00       	call   800b77 <cprintf>
		if (buf[0] == '#')
  8007bd:	80 3b 23             	cmpb   $0x23,(%ebx)
  8007c0:	74 ab                	je     80076d <umain+0x106>
			continue;
		if (echocmds)
  8007c2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007c6:	74 10                	je     8007d8 <umain+0x171>
			printf("# %s\n", buf);
  8007c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007cc:	c7 04 24 f1 39 80 00 	movl   $0x8039f1,(%esp)
  8007d3:	e8 e1 20 00 00       	call   8028b9 <printf>
		if (debug)
  8007d8:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007df:	74 0c                	je     8007ed <umain+0x186>
			cprintf("BEFORE FORK\n");
  8007e1:	c7 04 24 f7 39 80 00 	movl   $0x8039f7,(%esp)
  8007e8:	e8 8a 03 00 00       	call   800b77 <cprintf>
		if ((r = fork()) < 0)
  8007ed:	e8 61 13 00 00       	call   801b53 <fork>
  8007f2:	89 c6                	mov    %eax,%esi
  8007f4:	85 c0                	test   %eax,%eax
  8007f6:	79 20                	jns    800818 <umain+0x1b1>
			panic("fork: %e", r);
  8007f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007fc:	c7 44 24 08 65 3f 80 	movl   $0x803f65,0x8(%esp)
  800803:	00 
  800804:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  80080b:	00 
  80080c:	c7 04 24 36 39 80 00 	movl   $0x803936,(%esp)
  800813:	e8 64 02 00 00       	call   800a7c <_panic>
		if (debug)
  800818:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80081f:	74 10                	je     800831 <umain+0x1ca>
			cprintf("FORK: %d\n", r);
  800821:	89 44 24 04          	mov    %eax,0x4(%esp)
  800825:	c7 04 24 04 3a 80 00 	movl   $0x803a04,(%esp)
  80082c:	e8 46 03 00 00       	call   800b77 <cprintf>
		if (r == 0) {
  800831:	85 f6                	test   %esi,%esi
  800833:	75 12                	jne    800847 <umain+0x1e0>
			runcmd(buf);
  800835:	89 1c 24             	mov    %ebx,(%esp)
  800838:	e8 d5 f9 ff ff       	call   800212 <runcmd>
			exit();
  80083d:	e8 1e 02 00 00       	call   800a60 <exit>
  800842:	e9 26 ff ff ff       	jmp    80076d <umain+0x106>
		} else
			wait(r);
  800847:	89 34 24             	mov    %esi,(%esp)
  80084a:	e8 05 2b 00 00       	call   803354 <wait>
  80084f:	90                   	nop
  800850:	e9 18 ff ff ff       	jmp    80076d <umain+0x106>
	...

00800860 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800870:	c7 44 24 04 81 3a 80 	movl   $0x803a81,0x4(%esp)
  800877:	00 
  800878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087b:	89 04 24             	mov    %eax,(%esp)
  80087e:	e8 08 0a 00 00       	call   80128b <strcpy>
	return 0;
}
  800883:	b8 00 00 00 00       	mov    $0x0,%eax
  800888:	c9                   	leave  
  800889:	c3                   	ret    

0080088a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	57                   	push   %edi
  80088e:	56                   	push   %esi
  80088f:	53                   	push   %ebx
  800890:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800896:	be 00 00 00 00       	mov    $0x0,%esi
  80089b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80089f:	74 43                	je     8008e4 <devcons_write+0x5a>
  8008a1:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8008a6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8008ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008af:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8008b1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8008b4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8008b9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8008bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008c0:	03 45 0c             	add    0xc(%ebp),%eax
  8008c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c7:	89 3c 24             	mov    %edi,(%esp)
  8008ca:	e8 ad 0b 00 00       	call   80147c <memmove>
		sys_cputs(buf, m);
  8008cf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008d3:	89 3c 24             	mov    %edi,(%esp)
  8008d6:	e8 95 0d 00 00       	call   801670 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008db:	01 de                	add    %ebx,%esi
  8008dd:	89 f0                	mov    %esi,%eax
  8008df:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008e2:	72 c8                	jb     8008ac <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8008e4:	89 f0                	mov    %esi,%eax
  8008e6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8008ec:	5b                   	pop    %ebx
  8008ed:	5e                   	pop    %esi
  8008ee:	5f                   	pop    %edi
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8008f7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8008fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800900:	75 07                	jne    800909 <devcons_read+0x18>
  800902:	eb 31                	jmp    800935 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800904:	e8 53 0e 00 00       	call   80175c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800910:	e8 8a 0d 00 00       	call   80169f <sys_cgetc>
  800915:	85 c0                	test   %eax,%eax
  800917:	74 eb                	je     800904 <devcons_read+0x13>
  800919:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80091b:	85 c0                	test   %eax,%eax
  80091d:	78 16                	js     800935 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80091f:	83 f8 04             	cmp    $0x4,%eax
  800922:	74 0c                	je     800930 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	88 10                	mov    %dl,(%eax)
	return 1;
  800929:	b8 01 00 00 00       	mov    $0x1,%eax
  80092e:	eb 05                	jmp    800935 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800930:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800935:	c9                   	leave  
  800936:	c3                   	ret    

00800937 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800943:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80094a:	00 
  80094b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80094e:	89 04 24             	mov    %eax,(%esp)
  800951:	e8 1a 0d 00 00       	call   801670 <sys_cputs>
}
  800956:	c9                   	leave  
  800957:	c3                   	ret    

00800958 <getchar>:

int
getchar(void)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80095e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800965:	00 
  800966:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800969:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800974:	e8 35 19 00 00       	call   8022ae <read>
	if (r < 0)
  800979:	85 c0                	test   %eax,%eax
  80097b:	78 0f                	js     80098c <getchar+0x34>
		return r;
	if (r < 1)
  80097d:	85 c0                	test   %eax,%eax
  80097f:	7e 06                	jle    800987 <getchar+0x2f>
		return -E_EOF;
	return c;
  800981:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800985:	eb 05                	jmp    80098c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800987:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80098c:	c9                   	leave  
  80098d:	c3                   	ret    

0080098e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800994:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800997:	89 44 24 04          	mov    %eax,0x4(%esp)
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	89 04 24             	mov    %eax,(%esp)
  8009a1:	e8 48 16 00 00       	call   801fee <fd_lookup>
  8009a6:	85 c0                	test   %eax,%eax
  8009a8:	78 11                	js     8009bb <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8009aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ad:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009b3:	39 10                	cmp    %edx,(%eax)
  8009b5:	0f 94 c0             	sete   %al
  8009b8:	0f b6 c0             	movzbl %al,%eax
}
  8009bb:	c9                   	leave  
  8009bc:	c3                   	ret    

008009bd <opencons>:

int
opencons(void)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8009c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009c6:	89 04 24             	mov    %eax,(%esp)
  8009c9:	e8 ad 15 00 00       	call   801f7b <fd_alloc>
  8009ce:	85 c0                	test   %eax,%eax
  8009d0:	78 3c                	js     800a0e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8009d9:	00 
  8009da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009e8:	e8 9f 0d 00 00       	call   80178c <sys_page_alloc>
  8009ed:	85 c0                	test   %eax,%eax
  8009ef:	78 1d                	js     800a0e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8009f1:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a06:	89 04 24             	mov    %eax,(%esp)
  800a09:	e8 42 15 00 00       	call   801f50 <fd2num>
}
  800a0e:	c9                   	leave  
  800a0f:	c3                   	ret    

00800a10 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	83 ec 18             	sub    $0x18,%esp
  800a16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800a19:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800a1c:	8b 75 08             	mov    0x8(%ebp),%esi
  800a1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800a22:	e8 05 0d 00 00       	call   80172c <sys_getenvid>
  800a27:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a2c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a2f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a34:	a3 24 64 80 00       	mov    %eax,0x806424
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a39:	85 f6                	test   %esi,%esi
  800a3b:	7e 07                	jle    800a44 <libmain+0x34>
		binaryname = argv[0];
  800a3d:	8b 03                	mov    (%ebx),%eax
  800a3f:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800a44:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a48:	89 34 24             	mov    %esi,(%esp)
  800a4b:	e8 17 fc ff ff       	call   800667 <umain>

	// exit gracefully
	exit();
  800a50:	e8 0b 00 00 00       	call   800a60 <exit>
}
  800a55:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800a58:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800a5b:	89 ec                	mov    %ebp,%esp
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    
	...

00800a60 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800a66:	e8 03 17 00 00       	call   80216e <close_all>
	sys_env_destroy(0);
  800a6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a72:	e8 58 0c 00 00       	call   8016cf <sys_env_destroy>
}
  800a77:	c9                   	leave  
  800a78:	c3                   	ret    
  800a79:	00 00                	add    %al,(%eax)
	...

00800a7c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	56                   	push   %esi
  800a80:	53                   	push   %ebx
  800a81:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800a84:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a87:	8b 1d 1c 50 80 00    	mov    0x80501c,%ebx
  800a8d:	e8 9a 0c 00 00       	call   80172c <sys_getenvid>
  800a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a95:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a99:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800aa0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa8:	c7 04 24 98 3a 80 00 	movl   $0x803a98,(%esp)
  800aaf:	e8 c3 00 00 00       	call   800b77 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ab4:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ab8:	8b 45 10             	mov    0x10(%ebp),%eax
  800abb:	89 04 24             	mov    %eax,(%esp)
  800abe:	e8 53 00 00 00       	call   800b16 <vcprintf>
	cprintf("\n");
  800ac3:	c7 04 24 a0 38 80 00 	movl   $0x8038a0,(%esp)
  800aca:	e8 a8 00 00 00       	call   800b77 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800acf:	cc                   	int3   
  800ad0:	eb fd                	jmp    800acf <_panic+0x53>
	...

00800ad4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	53                   	push   %ebx
  800ad8:	83 ec 14             	sub    $0x14,%esp
  800adb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800ade:	8b 03                	mov    (%ebx),%eax
  800ae0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae3:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800ae7:	83 c0 01             	add    $0x1,%eax
  800aea:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800aec:	3d ff 00 00 00       	cmp    $0xff,%eax
  800af1:	75 19                	jne    800b0c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800af3:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800afa:	00 
  800afb:	8d 43 08             	lea    0x8(%ebx),%eax
  800afe:	89 04 24             	mov    %eax,(%esp)
  800b01:	e8 6a 0b 00 00       	call   801670 <sys_cputs>
		b->idx = 0;
  800b06:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800b0c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800b10:	83 c4 14             	add    $0x14,%esp
  800b13:	5b                   	pop    %ebx
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800b1f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b26:	00 00 00 
	b.cnt = 0;
  800b29:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b30:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b41:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b4b:	c7 04 24 d4 0a 80 00 	movl   $0x800ad4,(%esp)
  800b52:	e8 a3 01 00 00       	call   800cfa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b57:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b61:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b67:	89 04 24             	mov    %eax,(%esp)
  800b6a:	e8 01 0b 00 00       	call   801670 <sys_cputs>

	return b.cnt;
}
  800b6f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b75:	c9                   	leave  
  800b76:	c3                   	ret    

00800b77 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b7d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	89 04 24             	mov    %eax,(%esp)
  800b8a:	e8 87 ff ff ff       	call   800b16 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    
	...

00800ba0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	57                   	push   %edi
  800ba4:	56                   	push   %esi
  800ba5:	53                   	push   %ebx
  800ba6:	83 ec 3c             	sub    $0x3c,%esp
  800ba9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bac:	89 d7                	mov    %edx,%edi
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800bbd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800bc8:	72 11                	jb     800bdb <printnum+0x3b>
  800bca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bcd:	39 45 10             	cmp    %eax,0x10(%ebp)
  800bd0:	76 09                	jbe    800bdb <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bd2:	83 eb 01             	sub    $0x1,%ebx
  800bd5:	85 db                	test   %ebx,%ebx
  800bd7:	7f 51                	jg     800c2a <printnum+0x8a>
  800bd9:	eb 5e                	jmp    800c39 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bdb:	89 74 24 10          	mov    %esi,0x10(%esp)
  800bdf:	83 eb 01             	sub    $0x1,%ebx
  800be2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800be6:	8b 45 10             	mov    0x10(%ebp),%eax
  800be9:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bed:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800bf1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800bf5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800bfc:	00 
  800bfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c00:	89 04 24             	mov    %eax,(%esp)
  800c03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c06:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c0a:	e8 b1 29 00 00       	call   8035c0 <__udivdi3>
  800c0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800c13:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800c17:	89 04 24             	mov    %eax,(%esp)
  800c1a:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c1e:	89 fa                	mov    %edi,%edx
  800c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c23:	e8 78 ff ff ff       	call   800ba0 <printnum>
  800c28:	eb 0f                	jmp    800c39 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c2a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c2e:	89 34 24             	mov    %esi,(%esp)
  800c31:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c34:	83 eb 01             	sub    $0x1,%ebx
  800c37:	75 f1                	jne    800c2a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c39:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c3d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c48:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800c4f:	00 
  800c50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c53:	89 04 24             	mov    %eax,(%esp)
  800c56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c59:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c5d:	e8 8e 2a 00 00       	call   8036f0 <__umoddi3>
  800c62:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c66:	0f be 80 bb 3a 80 00 	movsbl 0x803abb(%eax),%eax
  800c6d:	89 04 24             	mov    %eax,(%esp)
  800c70:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800c73:	83 c4 3c             	add    $0x3c,%esp
  800c76:	5b                   	pop    %ebx
  800c77:	5e                   	pop    %esi
  800c78:	5f                   	pop    %edi
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c7e:	83 fa 01             	cmp    $0x1,%edx
  800c81:	7e 0e                	jle    800c91 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800c83:	8b 10                	mov    (%eax),%edx
  800c85:	8d 4a 08             	lea    0x8(%edx),%ecx
  800c88:	89 08                	mov    %ecx,(%eax)
  800c8a:	8b 02                	mov    (%edx),%eax
  800c8c:	8b 52 04             	mov    0x4(%edx),%edx
  800c8f:	eb 22                	jmp    800cb3 <getuint+0x38>
	else if (lflag)
  800c91:	85 d2                	test   %edx,%edx
  800c93:	74 10                	je     800ca5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800c95:	8b 10                	mov    (%eax),%edx
  800c97:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c9a:	89 08                	mov    %ecx,(%eax)
  800c9c:	8b 02                	mov    (%edx),%eax
  800c9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca3:	eb 0e                	jmp    800cb3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800ca5:	8b 10                	mov    (%eax),%edx
  800ca7:	8d 4a 04             	lea    0x4(%edx),%ecx
  800caa:	89 08                	mov    %ecx,(%eax)
  800cac:	8b 02                	mov    (%edx),%eax
  800cae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800cbb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800cbf:	8b 10                	mov    (%eax),%edx
  800cc1:	3b 50 04             	cmp    0x4(%eax),%edx
  800cc4:	73 0a                	jae    800cd0 <sprintputch+0x1b>
		*b->buf++ = ch;
  800cc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc9:	88 0a                	mov    %cl,(%edx)
  800ccb:	83 c2 01             	add    $0x1,%edx
  800cce:	89 10                	mov    %edx,(%eax)
}
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cd8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800cdb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce2:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	89 04 24             	mov    %eax,(%esp)
  800cf3:	e8 02 00 00 00       	call   800cfa <vprintfmt>
	va_end(ap);
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	57                   	push   %edi
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
  800d00:	83 ec 4c             	sub    $0x4c,%esp
  800d03:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d06:	8b 75 10             	mov    0x10(%ebp),%esi
  800d09:	eb 12                	jmp    800d1d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	0f 84 a9 03 00 00    	je     8010bc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800d13:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d17:	89 04 24             	mov    %eax,(%esp)
  800d1a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d1d:	0f b6 06             	movzbl (%esi),%eax
  800d20:	83 c6 01             	add    $0x1,%esi
  800d23:	83 f8 25             	cmp    $0x25,%eax
  800d26:	75 e3                	jne    800d0b <vprintfmt+0x11>
  800d28:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800d2c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800d33:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800d38:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800d3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d44:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800d47:	eb 2b                	jmp    800d74 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d49:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800d4c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800d50:	eb 22                	jmp    800d74 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d52:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d55:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800d59:	eb 19                	jmp    800d74 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d5b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800d5e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800d65:	eb 0d                	jmp    800d74 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800d67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d6d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d74:	0f b6 06             	movzbl (%esi),%eax
  800d77:	0f b6 d0             	movzbl %al,%edx
  800d7a:	8d 7e 01             	lea    0x1(%esi),%edi
  800d7d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800d80:	83 e8 23             	sub    $0x23,%eax
  800d83:	3c 55                	cmp    $0x55,%al
  800d85:	0f 87 0b 03 00 00    	ja     801096 <vprintfmt+0x39c>
  800d8b:	0f b6 c0             	movzbl %al,%eax
  800d8e:	ff 24 85 00 3c 80 00 	jmp    *0x803c00(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800d95:	83 ea 30             	sub    $0x30,%edx
  800d98:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  800d9b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  800d9f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800da2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800da5:	83 fa 09             	cmp    $0x9,%edx
  800da8:	77 4a                	ja     800df4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800daa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dad:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800db0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800db3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800db7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800dba:	8d 50 d0             	lea    -0x30(%eax),%edx
  800dbd:	83 fa 09             	cmp    $0x9,%edx
  800dc0:	76 eb                	jbe    800dad <vprintfmt+0xb3>
  800dc2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800dc5:	eb 2d                	jmp    800df4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dca:	8d 50 04             	lea    0x4(%eax),%edx
  800dcd:	89 55 14             	mov    %edx,0x14(%ebp)
  800dd0:	8b 00                	mov    (%eax),%eax
  800dd2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dd5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800dd8:	eb 1a                	jmp    800df4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dda:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  800ddd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800de1:	79 91                	jns    800d74 <vprintfmt+0x7a>
  800de3:	e9 73 ff ff ff       	jmp    800d5b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800de8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800deb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800df2:	eb 80                	jmp    800d74 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800df4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df8:	0f 89 76 ff ff ff    	jns    800d74 <vprintfmt+0x7a>
  800dfe:	e9 64 ff ff ff       	jmp    800d67 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e03:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e06:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800e09:	e9 66 ff ff ff       	jmp    800d74 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e11:	8d 50 04             	lea    0x4(%eax),%edx
  800e14:	89 55 14             	mov    %edx,0x14(%ebp)
  800e17:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800e1b:	8b 00                	mov    (%eax),%eax
  800e1d:	89 04 24             	mov    %eax,(%esp)
  800e20:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e23:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800e26:	e9 f2 fe ff ff       	jmp    800d1d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2e:	8d 50 04             	lea    0x4(%eax),%edx
  800e31:	89 55 14             	mov    %edx,0x14(%ebp)
  800e34:	8b 00                	mov    (%eax),%eax
  800e36:	89 c2                	mov    %eax,%edx
  800e38:	c1 fa 1f             	sar    $0x1f,%edx
  800e3b:	31 d0                	xor    %edx,%eax
  800e3d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e3f:	83 f8 0f             	cmp    $0xf,%eax
  800e42:	7f 0b                	jg     800e4f <vprintfmt+0x155>
  800e44:	8b 14 85 60 3d 80 00 	mov    0x803d60(,%eax,4),%edx
  800e4b:	85 d2                	test   %edx,%edx
  800e4d:	75 23                	jne    800e72 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  800e4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e53:	c7 44 24 08 d3 3a 80 	movl   $0x803ad3,0x8(%esp)
  800e5a:	00 
  800e5b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800e5f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e62:	89 3c 24             	mov    %edi,(%esp)
  800e65:	e8 68 fe ff ff       	call   800cd2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e6a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800e6d:	e9 ab fe ff ff       	jmp    800d1d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800e72:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e76:	c7 44 24 08 db 39 80 	movl   $0x8039db,0x8(%esp)
  800e7d:	00 
  800e7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800e82:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e85:	89 3c 24             	mov    %edi,(%esp)
  800e88:	e8 45 fe ff ff       	call   800cd2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e8d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800e90:	e9 88 fe ff ff       	jmp    800d1d <vprintfmt+0x23>
  800e95:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800e98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e9b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea1:	8d 50 04             	lea    0x4(%eax),%edx
  800ea4:	89 55 14             	mov    %edx,0x14(%ebp)
  800ea7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800ea9:	85 f6                	test   %esi,%esi
  800eab:	ba cc 3a 80 00       	mov    $0x803acc,%edx
  800eb0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800eb3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800eb7:	7e 06                	jle    800ebf <vprintfmt+0x1c5>
  800eb9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800ebd:	75 10                	jne    800ecf <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ebf:	0f be 06             	movsbl (%esi),%eax
  800ec2:	83 c6 01             	add    $0x1,%esi
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	0f 85 86 00 00 00    	jne    800f53 <vprintfmt+0x259>
  800ecd:	eb 76                	jmp    800f45 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ecf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ed3:	89 34 24             	mov    %esi,(%esp)
  800ed6:	e8 80 03 00 00       	call   80125b <strnlen>
  800edb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ede:	29 c2                	sub    %eax,%edx
  800ee0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ee3:	85 d2                	test   %edx,%edx
  800ee5:	7e d8                	jle    800ebf <vprintfmt+0x1c5>
					putch(padc, putdat);
  800ee7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800eeb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  800eee:	89 d6                	mov    %edx,%esi
  800ef0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800ef3:	89 c7                	mov    %eax,%edi
  800ef5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ef9:	89 3c 24             	mov    %edi,(%esp)
  800efc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eff:	83 ee 01             	sub    $0x1,%esi
  800f02:	75 f1                	jne    800ef5 <vprintfmt+0x1fb>
  800f04:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800f07:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  800f0a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  800f0d:	eb b0                	jmp    800ebf <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800f0f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f13:	74 18                	je     800f2d <vprintfmt+0x233>
  800f15:	8d 50 e0             	lea    -0x20(%eax),%edx
  800f18:	83 fa 5e             	cmp    $0x5e,%edx
  800f1b:	76 10                	jbe    800f2d <vprintfmt+0x233>
					putch('?', putdat);
  800f1d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800f21:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800f28:	ff 55 08             	call   *0x8(%ebp)
  800f2b:	eb 0a                	jmp    800f37 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  800f2d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800f31:	89 04 24             	mov    %eax,(%esp)
  800f34:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f37:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800f3b:	0f be 06             	movsbl (%esi),%eax
  800f3e:	83 c6 01             	add    $0x1,%esi
  800f41:	85 c0                	test   %eax,%eax
  800f43:	75 0e                	jne    800f53 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f45:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f4c:	7f 16                	jg     800f64 <vprintfmt+0x26a>
  800f4e:	e9 ca fd ff ff       	jmp    800d1d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f53:	85 ff                	test   %edi,%edi
  800f55:	78 b8                	js     800f0f <vprintfmt+0x215>
  800f57:	83 ef 01             	sub    $0x1,%edi
  800f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f60:	79 ad                	jns    800f0f <vprintfmt+0x215>
  800f62:	eb e1                	jmp    800f45 <vprintfmt+0x24b>
  800f64:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800f67:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800f6a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800f6e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800f75:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f77:	83 ee 01             	sub    $0x1,%esi
  800f7a:	75 ee                	jne    800f6a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f7c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800f7f:	e9 99 fd ff ff       	jmp    800d1d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800f84:	83 f9 01             	cmp    $0x1,%ecx
  800f87:	7e 10                	jle    800f99 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800f89:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8c:	8d 50 08             	lea    0x8(%eax),%edx
  800f8f:	89 55 14             	mov    %edx,0x14(%ebp)
  800f92:	8b 30                	mov    (%eax),%esi
  800f94:	8b 78 04             	mov    0x4(%eax),%edi
  800f97:	eb 26                	jmp    800fbf <vprintfmt+0x2c5>
	else if (lflag)
  800f99:	85 c9                	test   %ecx,%ecx
  800f9b:	74 12                	je     800faf <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  800f9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa0:	8d 50 04             	lea    0x4(%eax),%edx
  800fa3:	89 55 14             	mov    %edx,0x14(%ebp)
  800fa6:	8b 30                	mov    (%eax),%esi
  800fa8:	89 f7                	mov    %esi,%edi
  800faa:	c1 ff 1f             	sar    $0x1f,%edi
  800fad:	eb 10                	jmp    800fbf <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  800faf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb2:	8d 50 04             	lea    0x4(%eax),%edx
  800fb5:	89 55 14             	mov    %edx,0x14(%ebp)
  800fb8:	8b 30                	mov    (%eax),%esi
  800fba:	89 f7                	mov    %esi,%edi
  800fbc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800fbf:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800fc4:	85 ff                	test   %edi,%edi
  800fc6:	0f 89 8c 00 00 00    	jns    801058 <vprintfmt+0x35e>
				putch('-', putdat);
  800fcc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800fd0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800fd7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800fda:	f7 de                	neg    %esi
  800fdc:	83 d7 00             	adc    $0x0,%edi
  800fdf:	f7 df                	neg    %edi
			}
			base = 10;
  800fe1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fe6:	eb 70                	jmp    801058 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fe8:	89 ca                	mov    %ecx,%edx
  800fea:	8d 45 14             	lea    0x14(%ebp),%eax
  800fed:	e8 89 fc ff ff       	call   800c7b <getuint>
  800ff2:	89 c6                	mov    %eax,%esi
  800ff4:	89 d7                	mov    %edx,%edi
			base = 10;
  800ff6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800ffb:	eb 5b                	jmp    801058 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800ffd:	89 ca                	mov    %ecx,%edx
  800fff:	8d 45 14             	lea    0x14(%ebp),%eax
  801002:	e8 74 fc ff ff       	call   800c7b <getuint>
  801007:	89 c6                	mov    %eax,%esi
  801009:	89 d7                	mov    %edx,%edi
			base = 8;
  80100b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  801010:	eb 46                	jmp    801058 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  801012:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801016:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80101d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801020:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801024:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80102b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80102e:	8b 45 14             	mov    0x14(%ebp),%eax
  801031:	8d 50 04             	lea    0x4(%eax),%edx
  801034:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801037:	8b 30                	mov    (%eax),%esi
  801039:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80103e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  801043:	eb 13                	jmp    801058 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801045:	89 ca                	mov    %ecx,%edx
  801047:	8d 45 14             	lea    0x14(%ebp),%eax
  80104a:	e8 2c fc ff ff       	call   800c7b <getuint>
  80104f:	89 c6                	mov    %eax,%esi
  801051:	89 d7                	mov    %edx,%edi
			base = 16;
  801053:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  801058:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80105c:	89 54 24 10          	mov    %edx,0x10(%esp)
  801060:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801063:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801067:	89 44 24 08          	mov    %eax,0x8(%esp)
  80106b:	89 34 24             	mov    %esi,(%esp)
  80106e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801072:	89 da                	mov    %ebx,%edx
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	e8 24 fb ff ff       	call   800ba0 <printnum>
			break;
  80107c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80107f:	e9 99 fc ff ff       	jmp    800d1d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801084:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801088:	89 14 24             	mov    %edx,(%esp)
  80108b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80108e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  801091:	e9 87 fc ff ff       	jmp    800d1d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801096:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80109a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8010a1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010a4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8010a8:	0f 84 6f fc ff ff    	je     800d1d <vprintfmt+0x23>
  8010ae:	83 ee 01             	sub    $0x1,%esi
  8010b1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8010b5:	75 f7                	jne    8010ae <vprintfmt+0x3b4>
  8010b7:	e9 61 fc ff ff       	jmp    800d1d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8010bc:	83 c4 4c             	add    $0x4c,%esp
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 28             	sub    $0x28,%esp
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010d3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010d7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010e1:	85 c0                	test   %eax,%eax
  8010e3:	74 30                	je     801115 <vsnprintf+0x51>
  8010e5:	85 d2                	test   %edx,%edx
  8010e7:	7e 2c                	jle    801115 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010f7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010fe:	c7 04 24 b5 0c 80 00 	movl   $0x800cb5,(%esp)
  801105:	e8 f0 fb ff ff       	call   800cfa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80110a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80110d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801113:	eb 05                	jmp    80111a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801115:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801122:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801125:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801129:	8b 45 10             	mov    0x10(%ebp),%eax
  80112c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	89 44 24 04          	mov    %eax,0x4(%esp)
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	89 04 24             	mov    %eax,(%esp)
  80113d:	e8 82 ff ff ff       	call   8010c4 <vsnprintf>
	va_end(ap);

	return rc;
}
  801142:	c9                   	leave  
  801143:	c3                   	ret    
	...

00801150 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	57                   	push   %edi
  801154:	56                   	push   %esi
  801155:	53                   	push   %ebx
  801156:	83 ec 1c             	sub    $0x1c,%esp
  801159:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	74 18                	je     801178 <readline+0x28>
		fprintf(1, "%s", prompt);
  801160:	89 44 24 08          	mov    %eax,0x8(%esp)
  801164:	c7 44 24 04 db 39 80 	movl   $0x8039db,0x4(%esp)
  80116b:	00 
  80116c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801173:	e8 20 17 00 00       	call   802898 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  801178:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80117f:	e8 0a f8 ff ff       	call   80098e <iscons>
  801184:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  801186:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  80118b:	e8 c8 f7 ff ff       	call   800958 <getchar>
  801190:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801192:	85 c0                	test   %eax,%eax
  801194:	79 25                	jns    8011bb <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  801196:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  80119b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  80119e:	0f 84 88 00 00 00    	je     80122c <readline+0xdc>
				cprintf("read error: %e\n", c);
  8011a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011a8:	c7 04 24 bf 3d 80 00 	movl   $0x803dbf,(%esp)
  8011af:	e8 c3 f9 ff ff       	call   800b77 <cprintf>
			return NULL;
  8011b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b9:	eb 71                	jmp    80122c <readline+0xdc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8011bb:	83 f8 08             	cmp    $0x8,%eax
  8011be:	74 05                	je     8011c5 <readline+0x75>
  8011c0:	83 f8 7f             	cmp    $0x7f,%eax
  8011c3:	75 19                	jne    8011de <readline+0x8e>
  8011c5:	85 f6                	test   %esi,%esi
  8011c7:	7e 15                	jle    8011de <readline+0x8e>
			if (echoing)
  8011c9:	85 ff                	test   %edi,%edi
  8011cb:	74 0c                	je     8011d9 <readline+0x89>
				cputchar('\b');
  8011cd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8011d4:	e8 5e f7 ff ff       	call   800937 <cputchar>
			i--;
  8011d9:	83 ee 01             	sub    $0x1,%esi
  8011dc:	eb ad                	jmp    80118b <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011de:	83 fb 1f             	cmp    $0x1f,%ebx
  8011e1:	7e 1f                	jle    801202 <readline+0xb2>
  8011e3:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8011e9:	7f 17                	jg     801202 <readline+0xb2>
			if (echoing)
  8011eb:	85 ff                	test   %edi,%edi
  8011ed:	74 08                	je     8011f7 <readline+0xa7>
				cputchar(c);
  8011ef:	89 1c 24             	mov    %ebx,(%esp)
  8011f2:	e8 40 f7 ff ff       	call   800937 <cputchar>
			buf[i++] = c;
  8011f7:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  8011fd:	83 c6 01             	add    $0x1,%esi
  801200:	eb 89                	jmp    80118b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  801202:	83 fb 0a             	cmp    $0xa,%ebx
  801205:	74 09                	je     801210 <readline+0xc0>
  801207:	83 fb 0d             	cmp    $0xd,%ebx
  80120a:	0f 85 7b ff ff ff    	jne    80118b <readline+0x3b>
			if (echoing)
  801210:	85 ff                	test   %edi,%edi
  801212:	74 0c                	je     801220 <readline+0xd0>
				cputchar('\n');
  801214:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80121b:	e8 17 f7 ff ff       	call   800937 <cputchar>
			buf[i] = 0;
  801220:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  801227:	b8 20 60 80 00       	mov    $0x806020,%eax
		}
	}
}
  80122c:	83 c4 1c             	add    $0x1c,%esp
  80122f:	5b                   	pop    %ebx
  801230:	5e                   	pop    %esi
  801231:	5f                   	pop    %edi
  801232:	5d                   	pop    %ebp
  801233:	c3                   	ret    
	...

00801240 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	80 3a 00             	cmpb   $0x0,(%edx)
  80124e:	74 09                	je     801259 <strlen+0x19>
		n++;
  801250:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801253:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801257:	75 f7                	jne    801250 <strlen+0x10>
		n++;
	return n;
}
  801259:	5d                   	pop    %ebp
  80125a:	c3                   	ret    

0080125b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	53                   	push   %ebx
  80125f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801262:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801265:	b8 00 00 00 00       	mov    $0x0,%eax
  80126a:	85 c9                	test   %ecx,%ecx
  80126c:	74 1a                	je     801288 <strnlen+0x2d>
  80126e:	80 3b 00             	cmpb   $0x0,(%ebx)
  801271:	74 15                	je     801288 <strnlen+0x2d>
  801273:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  801278:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80127a:	39 ca                	cmp    %ecx,%edx
  80127c:	74 0a                	je     801288 <strnlen+0x2d>
  80127e:	83 c2 01             	add    $0x1,%edx
  801281:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  801286:	75 f0                	jne    801278 <strnlen+0x1d>
		n++;
	return n;
}
  801288:	5b                   	pop    %ebx
  801289:	5d                   	pop    %ebp
  80128a:	c3                   	ret    

0080128b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	53                   	push   %ebx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801295:	ba 00 00 00 00       	mov    $0x0,%edx
  80129a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80129e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8012a1:	83 c2 01             	add    $0x1,%edx
  8012a4:	84 c9                	test   %cl,%cl
  8012a6:	75 f2                	jne    80129a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8012a8:	5b                   	pop    %ebx
  8012a9:	5d                   	pop    %ebp
  8012aa:	c3                   	ret    

008012ab <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	53                   	push   %ebx
  8012af:	83 ec 08             	sub    $0x8,%esp
  8012b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8012b5:	89 1c 24             	mov    %ebx,(%esp)
  8012b8:	e8 83 ff ff ff       	call   801240 <strlen>
	strcpy(dst + len, src);
  8012bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012c4:	01 d8                	add    %ebx,%eax
  8012c6:	89 04 24             	mov    %eax,(%esp)
  8012c9:	e8 bd ff ff ff       	call   80128b <strcpy>
	return dst;
}
  8012ce:	89 d8                	mov    %ebx,%eax
  8012d0:	83 c4 08             	add    $0x8,%esp
  8012d3:	5b                   	pop    %ebx
  8012d4:	5d                   	pop    %ebp
  8012d5:	c3                   	ret    

008012d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	56                   	push   %esi
  8012da:	53                   	push   %ebx
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012e4:	85 f6                	test   %esi,%esi
  8012e6:	74 18                	je     801300 <strncpy+0x2a>
  8012e8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8012ed:	0f b6 1a             	movzbl (%edx),%ebx
  8012f0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8012f3:	80 3a 01             	cmpb   $0x1,(%edx)
  8012f6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f9:	83 c1 01             	add    $0x1,%ecx
  8012fc:	39 f1                	cmp    %esi,%ecx
  8012fe:	75 ed                	jne    8012ed <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801300:	5b                   	pop    %ebx
  801301:	5e                   	pop    %esi
  801302:	5d                   	pop    %ebp
  801303:	c3                   	ret    

00801304 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	57                   	push   %edi
  801308:	56                   	push   %esi
  801309:	53                   	push   %ebx
  80130a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80130d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801310:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801313:	89 f8                	mov    %edi,%eax
  801315:	85 f6                	test   %esi,%esi
  801317:	74 2b                	je     801344 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  801319:	83 fe 01             	cmp    $0x1,%esi
  80131c:	74 23                	je     801341 <strlcpy+0x3d>
  80131e:	0f b6 0b             	movzbl (%ebx),%ecx
  801321:	84 c9                	test   %cl,%cl
  801323:	74 1c                	je     801341 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  801325:	83 ee 02             	sub    $0x2,%esi
  801328:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80132d:	88 08                	mov    %cl,(%eax)
  80132f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801332:	39 f2                	cmp    %esi,%edx
  801334:	74 0b                	je     801341 <strlcpy+0x3d>
  801336:	83 c2 01             	add    $0x1,%edx
  801339:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80133d:	84 c9                	test   %cl,%cl
  80133f:	75 ec                	jne    80132d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  801341:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801344:	29 f8                	sub    %edi,%eax
}
  801346:	5b                   	pop    %ebx
  801347:	5e                   	pop    %esi
  801348:	5f                   	pop    %edi
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    

0080134b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801351:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801354:	0f b6 01             	movzbl (%ecx),%eax
  801357:	84 c0                	test   %al,%al
  801359:	74 16                	je     801371 <strcmp+0x26>
  80135b:	3a 02                	cmp    (%edx),%al
  80135d:	75 12                	jne    801371 <strcmp+0x26>
		p++, q++;
  80135f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801362:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  801366:	84 c0                	test   %al,%al
  801368:	74 07                	je     801371 <strcmp+0x26>
  80136a:	83 c1 01             	add    $0x1,%ecx
  80136d:	3a 02                	cmp    (%edx),%al
  80136f:	74 ee                	je     80135f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801371:	0f b6 c0             	movzbl %al,%eax
  801374:	0f b6 12             	movzbl (%edx),%edx
  801377:	29 d0                	sub    %edx,%eax
}
  801379:	5d                   	pop    %ebp
  80137a:	c3                   	ret    

0080137b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	53                   	push   %ebx
  80137f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801382:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801385:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801388:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80138d:	85 d2                	test   %edx,%edx
  80138f:	74 28                	je     8013b9 <strncmp+0x3e>
  801391:	0f b6 01             	movzbl (%ecx),%eax
  801394:	84 c0                	test   %al,%al
  801396:	74 24                	je     8013bc <strncmp+0x41>
  801398:	3a 03                	cmp    (%ebx),%al
  80139a:	75 20                	jne    8013bc <strncmp+0x41>
  80139c:	83 ea 01             	sub    $0x1,%edx
  80139f:	74 13                	je     8013b4 <strncmp+0x39>
		n--, p++, q++;
  8013a1:	83 c1 01             	add    $0x1,%ecx
  8013a4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013a7:	0f b6 01             	movzbl (%ecx),%eax
  8013aa:	84 c0                	test   %al,%al
  8013ac:	74 0e                	je     8013bc <strncmp+0x41>
  8013ae:	3a 03                	cmp    (%ebx),%al
  8013b0:	74 ea                	je     80139c <strncmp+0x21>
  8013b2:	eb 08                	jmp    8013bc <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8013b4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8013b9:	5b                   	pop    %ebx
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013bc:	0f b6 01             	movzbl (%ecx),%eax
  8013bf:	0f b6 13             	movzbl (%ebx),%edx
  8013c2:	29 d0                	sub    %edx,%eax
  8013c4:	eb f3                	jmp    8013b9 <strncmp+0x3e>

008013c6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013d0:	0f b6 10             	movzbl (%eax),%edx
  8013d3:	84 d2                	test   %dl,%dl
  8013d5:	74 1c                	je     8013f3 <strchr+0x2d>
		if (*s == c)
  8013d7:	38 ca                	cmp    %cl,%dl
  8013d9:	75 09                	jne    8013e4 <strchr+0x1e>
  8013db:	eb 1b                	jmp    8013f8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013dd:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  8013e0:	38 ca                	cmp    %cl,%dl
  8013e2:	74 14                	je     8013f8 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013e4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  8013e8:	84 d2                	test   %dl,%dl
  8013ea:	75 f1                	jne    8013dd <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  8013ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f1:	eb 05                	jmp    8013f8 <strchr+0x32>
  8013f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f8:	5d                   	pop    %ebp
  8013f9:	c3                   	ret    

008013fa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801404:	0f b6 10             	movzbl (%eax),%edx
  801407:	84 d2                	test   %dl,%dl
  801409:	74 14                	je     80141f <strfind+0x25>
		if (*s == c)
  80140b:	38 ca                	cmp    %cl,%dl
  80140d:	75 06                	jne    801415 <strfind+0x1b>
  80140f:	eb 0e                	jmp    80141f <strfind+0x25>
  801411:	38 ca                	cmp    %cl,%dl
  801413:	74 0a                	je     80141f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801415:	83 c0 01             	add    $0x1,%eax
  801418:	0f b6 10             	movzbl (%eax),%edx
  80141b:	84 d2                	test   %dl,%dl
  80141d:	75 f2                	jne    801411 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80141f:	5d                   	pop    %ebp
  801420:	c3                   	ret    

00801421 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	83 ec 0c             	sub    $0xc,%esp
  801427:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80142a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80142d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801430:	8b 7d 08             	mov    0x8(%ebp),%edi
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801439:	85 c9                	test   %ecx,%ecx
  80143b:	74 30                	je     80146d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80143d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801443:	75 25                	jne    80146a <memset+0x49>
  801445:	f6 c1 03             	test   $0x3,%cl
  801448:	75 20                	jne    80146a <memset+0x49>
		c &= 0xFF;
  80144a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80144d:	89 d3                	mov    %edx,%ebx
  80144f:	c1 e3 08             	shl    $0x8,%ebx
  801452:	89 d6                	mov    %edx,%esi
  801454:	c1 e6 18             	shl    $0x18,%esi
  801457:	89 d0                	mov    %edx,%eax
  801459:	c1 e0 10             	shl    $0x10,%eax
  80145c:	09 f0                	or     %esi,%eax
  80145e:	09 d0                	or     %edx,%eax
  801460:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801462:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801465:	fc                   	cld    
  801466:	f3 ab                	rep stos %eax,%es:(%edi)
  801468:	eb 03                	jmp    80146d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80146a:	fc                   	cld    
  80146b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80146d:	89 f8                	mov    %edi,%eax
  80146f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801472:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801475:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801478:	89 ec                	mov    %ebp,%esp
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 08             	sub    $0x8,%esp
  801482:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801485:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80148e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801491:	39 c6                	cmp    %eax,%esi
  801493:	73 36                	jae    8014cb <memmove+0x4f>
  801495:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801498:	39 d0                	cmp    %edx,%eax
  80149a:	73 2f                	jae    8014cb <memmove+0x4f>
		s += n;
		d += n;
  80149c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80149f:	f6 c2 03             	test   $0x3,%dl
  8014a2:	75 1b                	jne    8014bf <memmove+0x43>
  8014a4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8014aa:	75 13                	jne    8014bf <memmove+0x43>
  8014ac:	f6 c1 03             	test   $0x3,%cl
  8014af:	75 0e                	jne    8014bf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014b1:	83 ef 04             	sub    $0x4,%edi
  8014b4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8014b7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014ba:	fd                   	std    
  8014bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8014bd:	eb 09                	jmp    8014c8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014bf:	83 ef 01             	sub    $0x1,%edi
  8014c2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014c5:	fd                   	std    
  8014c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014c8:	fc                   	cld    
  8014c9:	eb 20                	jmp    8014eb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8014cb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8014d1:	75 13                	jne    8014e6 <memmove+0x6a>
  8014d3:	a8 03                	test   $0x3,%al
  8014d5:	75 0f                	jne    8014e6 <memmove+0x6a>
  8014d7:	f6 c1 03             	test   $0x3,%cl
  8014da:	75 0a                	jne    8014e6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014dc:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014df:	89 c7                	mov    %eax,%edi
  8014e1:	fc                   	cld    
  8014e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8014e4:	eb 05                	jmp    8014eb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014e6:	89 c7                	mov    %eax,%edi
  8014e8:	fc                   	cld    
  8014e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8014eb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014ee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014f1:	89 ec                	mov    %ebp,%esp
  8014f3:	5d                   	pop    %ebp
  8014f4:	c3                   	ret    

008014f5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8014fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801502:	8b 45 0c             	mov    0xc(%ebp),%eax
  801505:	89 44 24 04          	mov    %eax,0x4(%esp)
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	89 04 24             	mov    %eax,(%esp)
  80150f:	e8 68 ff ff ff       	call   80147c <memmove>
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	57                   	push   %edi
  80151a:	56                   	push   %esi
  80151b:	53                   	push   %ebx
  80151c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80151f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801522:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801525:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80152a:	85 ff                	test   %edi,%edi
  80152c:	74 37                	je     801565 <memcmp+0x4f>
		if (*s1 != *s2)
  80152e:	0f b6 03             	movzbl (%ebx),%eax
  801531:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801534:	83 ef 01             	sub    $0x1,%edi
  801537:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  80153c:	38 c8                	cmp    %cl,%al
  80153e:	74 1c                	je     80155c <memcmp+0x46>
  801540:	eb 10                	jmp    801552 <memcmp+0x3c>
  801542:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801547:	83 c2 01             	add    $0x1,%edx
  80154a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  80154e:	38 c8                	cmp    %cl,%al
  801550:	74 0a                	je     80155c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  801552:	0f b6 c0             	movzbl %al,%eax
  801555:	0f b6 c9             	movzbl %cl,%ecx
  801558:	29 c8                	sub    %ecx,%eax
  80155a:	eb 09                	jmp    801565 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80155c:	39 fa                	cmp    %edi,%edx
  80155e:	75 e2                	jne    801542 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801565:	5b                   	pop    %ebx
  801566:	5e                   	pop    %esi
  801567:	5f                   	pop    %edi
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    

0080156a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801570:	89 c2                	mov    %eax,%edx
  801572:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801575:	39 d0                	cmp    %edx,%eax
  801577:	73 19                	jae    801592 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801579:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  80157d:	38 08                	cmp    %cl,(%eax)
  80157f:	75 06                	jne    801587 <memfind+0x1d>
  801581:	eb 0f                	jmp    801592 <memfind+0x28>
  801583:	38 08                	cmp    %cl,(%eax)
  801585:	74 0b                	je     801592 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801587:	83 c0 01             	add    $0x1,%eax
  80158a:	39 d0                	cmp    %edx,%eax
  80158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801590:	75 f1                	jne    801583 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801592:	5d                   	pop    %ebp
  801593:	c3                   	ret    

00801594 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	57                   	push   %edi
  801598:	56                   	push   %esi
  801599:	53                   	push   %ebx
  80159a:	8b 55 08             	mov    0x8(%ebp),%edx
  80159d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a0:	0f b6 02             	movzbl (%edx),%eax
  8015a3:	3c 20                	cmp    $0x20,%al
  8015a5:	74 04                	je     8015ab <strtol+0x17>
  8015a7:	3c 09                	cmp    $0x9,%al
  8015a9:	75 0e                	jne    8015b9 <strtol+0x25>
		s++;
  8015ab:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ae:	0f b6 02             	movzbl (%edx),%eax
  8015b1:	3c 20                	cmp    $0x20,%al
  8015b3:	74 f6                	je     8015ab <strtol+0x17>
  8015b5:	3c 09                	cmp    $0x9,%al
  8015b7:	74 f2                	je     8015ab <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b9:	3c 2b                	cmp    $0x2b,%al
  8015bb:	75 0a                	jne    8015c7 <strtol+0x33>
		s++;
  8015bd:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8015c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8015c5:	eb 10                	jmp    8015d7 <strtol+0x43>
  8015c7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8015cc:	3c 2d                	cmp    $0x2d,%al
  8015ce:	75 07                	jne    8015d7 <strtol+0x43>
		s++, neg = 1;
  8015d0:	83 c2 01             	add    $0x1,%edx
  8015d3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d7:	85 db                	test   %ebx,%ebx
  8015d9:	0f 94 c0             	sete   %al
  8015dc:	74 05                	je     8015e3 <strtol+0x4f>
  8015de:	83 fb 10             	cmp    $0x10,%ebx
  8015e1:	75 15                	jne    8015f8 <strtol+0x64>
  8015e3:	80 3a 30             	cmpb   $0x30,(%edx)
  8015e6:	75 10                	jne    8015f8 <strtol+0x64>
  8015e8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8015ec:	75 0a                	jne    8015f8 <strtol+0x64>
		s += 2, base = 16;
  8015ee:	83 c2 02             	add    $0x2,%edx
  8015f1:	bb 10 00 00 00       	mov    $0x10,%ebx
  8015f6:	eb 13                	jmp    80160b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  8015f8:	84 c0                	test   %al,%al
  8015fa:	74 0f                	je     80160b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8015fc:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801601:	80 3a 30             	cmpb   $0x30,(%edx)
  801604:	75 05                	jne    80160b <strtol+0x77>
		s++, base = 8;
  801606:	83 c2 01             	add    $0x1,%edx
  801609:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
  801610:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801612:	0f b6 0a             	movzbl (%edx),%ecx
  801615:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801618:	80 fb 09             	cmp    $0x9,%bl
  80161b:	77 08                	ja     801625 <strtol+0x91>
			dig = *s - '0';
  80161d:	0f be c9             	movsbl %cl,%ecx
  801620:	83 e9 30             	sub    $0x30,%ecx
  801623:	eb 1e                	jmp    801643 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  801625:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  801628:	80 fb 19             	cmp    $0x19,%bl
  80162b:	77 08                	ja     801635 <strtol+0xa1>
			dig = *s - 'a' + 10;
  80162d:	0f be c9             	movsbl %cl,%ecx
  801630:	83 e9 57             	sub    $0x57,%ecx
  801633:	eb 0e                	jmp    801643 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  801635:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  801638:	80 fb 19             	cmp    $0x19,%bl
  80163b:	77 14                	ja     801651 <strtol+0xbd>
			dig = *s - 'A' + 10;
  80163d:	0f be c9             	movsbl %cl,%ecx
  801640:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801643:	39 f1                	cmp    %esi,%ecx
  801645:	7d 0e                	jge    801655 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801647:	83 c2 01             	add    $0x1,%edx
  80164a:	0f af c6             	imul   %esi,%eax
  80164d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  80164f:	eb c1                	jmp    801612 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  801651:	89 c1                	mov    %eax,%ecx
  801653:	eb 02                	jmp    801657 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801655:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801657:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80165b:	74 05                	je     801662 <strtol+0xce>
		*endptr = (char *) s;
  80165d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801660:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801662:	89 ca                	mov    %ecx,%edx
  801664:	f7 da                	neg    %edx
  801666:	85 ff                	test   %edi,%edi
  801668:	0f 45 c2             	cmovne %edx,%eax
}
  80166b:	5b                   	pop    %ebx
  80166c:	5e                   	pop    %esi
  80166d:	5f                   	pop    %edi
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 0c             	sub    $0xc,%esp
  801676:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801679:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80167c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
  801684:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801687:	8b 55 08             	mov    0x8(%ebp),%edx
  80168a:	89 c3                	mov    %eax,%ebx
  80168c:	89 c7                	mov    %eax,%edi
  80168e:	89 c6                	mov    %eax,%esi
  801690:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801692:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801695:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801698:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80169b:	89 ec                	mov    %ebp,%esp
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    

0080169f <sys_cgetc>:

int
sys_cgetc(void)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 0c             	sub    $0xc,%esp
  8016a5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016a8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016ab:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b8:	89 d1                	mov    %edx,%ecx
  8016ba:	89 d3                	mov    %edx,%ebx
  8016bc:	89 d7                	mov    %edx,%edi
  8016be:	89 d6                	mov    %edx,%esi
  8016c0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8016c2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016c5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016c8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016cb:	89 ec                	mov    %ebp,%esp
  8016cd:	5d                   	pop    %ebp
  8016ce:	c3                   	ret    

008016cf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 38             	sub    $0x38,%esp
  8016d5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016d8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016db:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8016e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016eb:	89 cb                	mov    %ecx,%ebx
  8016ed:	89 cf                	mov    %ecx,%edi
  8016ef:	89 ce                	mov    %ecx,%esi
  8016f1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	7e 28                	jle    80171f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016f7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016fb:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801702:	00 
  801703:	c7 44 24 08 cf 3d 80 	movl   $0x803dcf,0x8(%esp)
  80170a:	00 
  80170b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801712:	00 
  801713:	c7 04 24 ec 3d 80 00 	movl   $0x803dec,(%esp)
  80171a:	e8 5d f3 ff ff       	call   800a7c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80171f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801722:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801725:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801728:	89 ec                	mov    %ebp,%esp
  80172a:	5d                   	pop    %ebp
  80172b:	c3                   	ret    

0080172c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 0c             	sub    $0xc,%esp
  801732:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801735:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801738:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80173b:	ba 00 00 00 00       	mov    $0x0,%edx
  801740:	b8 02 00 00 00       	mov    $0x2,%eax
  801745:	89 d1                	mov    %edx,%ecx
  801747:	89 d3                	mov    %edx,%ebx
  801749:	89 d7                	mov    %edx,%edi
  80174b:	89 d6                	mov    %edx,%esi
  80174d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80174f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801752:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801755:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801758:	89 ec                	mov    %ebp,%esp
  80175a:	5d                   	pop    %ebp
  80175b:	c3                   	ret    

0080175c <sys_yield>:

void
sys_yield(void)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 0c             	sub    $0xc,%esp
  801762:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801765:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801768:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80176b:	ba 00 00 00 00       	mov    $0x0,%edx
  801770:	b8 0b 00 00 00       	mov    $0xb,%eax
  801775:	89 d1                	mov    %edx,%ecx
  801777:	89 d3                	mov    %edx,%ebx
  801779:	89 d7                	mov    %edx,%edi
  80177b:	89 d6                	mov    %edx,%esi
  80177d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80177f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801782:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801785:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801788:	89 ec                	mov    %ebp,%esp
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    

0080178c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 38             	sub    $0x38,%esp
  801792:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801795:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801798:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80179b:	be 00 00 00 00       	mov    $0x0,%esi
  8017a0:	b8 04 00 00 00       	mov    $0x4,%eax
  8017a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ae:	89 f7                	mov    %esi,%edi
  8017b0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017b2:	85 c0                	test   %eax,%eax
  8017b4:	7e 28                	jle    8017de <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017b6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017ba:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8017c1:	00 
  8017c2:	c7 44 24 08 cf 3d 80 	movl   $0x803dcf,0x8(%esp)
  8017c9:	00 
  8017ca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017d1:	00 
  8017d2:	c7 04 24 ec 3d 80 00 	movl   $0x803dec,(%esp)
  8017d9:	e8 9e f2 ff ff       	call   800a7c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8017de:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017e1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8017e4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017e7:	89 ec                	mov    %ebp,%esp
  8017e9:	5d                   	pop    %ebp
  8017ea:	c3                   	ret    

008017eb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 38             	sub    $0x38,%esp
  8017f1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017f4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017f7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fa:	b8 05 00 00 00       	mov    $0x5,%eax
  8017ff:	8b 75 18             	mov    0x18(%ebp),%esi
  801802:	8b 7d 14             	mov    0x14(%ebp),%edi
  801805:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801808:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80180b:	8b 55 08             	mov    0x8(%ebp),%edx
  80180e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801810:	85 c0                	test   %eax,%eax
  801812:	7e 28                	jle    80183c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801814:	89 44 24 10          	mov    %eax,0x10(%esp)
  801818:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80181f:	00 
  801820:	c7 44 24 08 cf 3d 80 	movl   $0x803dcf,0x8(%esp)
  801827:	00 
  801828:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80182f:	00 
  801830:	c7 04 24 ec 3d 80 00 	movl   $0x803dec,(%esp)
  801837:	e8 40 f2 ff ff       	call   800a7c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80183c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80183f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801842:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801845:	89 ec                	mov    %ebp,%esp
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    

00801849 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 38             	sub    $0x38,%esp
  80184f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801852:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801855:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801858:	bb 00 00 00 00       	mov    $0x0,%ebx
  80185d:	b8 06 00 00 00       	mov    $0x6,%eax
  801862:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801865:	8b 55 08             	mov    0x8(%ebp),%edx
  801868:	89 df                	mov    %ebx,%edi
  80186a:	89 de                	mov    %ebx,%esi
  80186c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80186e:	85 c0                	test   %eax,%eax
  801870:	7e 28                	jle    80189a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801872:	89 44 24 10          	mov    %eax,0x10(%esp)
  801876:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80187d:	00 
  80187e:	c7 44 24 08 cf 3d 80 	movl   $0x803dcf,0x8(%esp)
  801885:	00 
  801886:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80188d:	00 
  80188e:	c7 04 24 ec 3d 80 00 	movl   $0x803dec,(%esp)
  801895:	e8 e2 f1 ff ff       	call   800a7c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80189a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80189d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018a3:	89 ec                	mov    %ebp,%esp
  8018a5:	5d                   	pop    %ebp
  8018a6:	c3                   	ret    

008018a7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 38             	sub    $0x38,%esp
  8018ad:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8018b0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8018b3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8018c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c6:	89 df                	mov    %ebx,%edi
  8018c8:	89 de                	mov    %ebx,%esi
  8018ca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	7e 28                	jle    8018f8 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018d4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8018db:	00 
  8018dc:	c7 44 24 08 cf 3d 80 	movl   $0x803dcf,0x8(%esp)
  8018e3:	00 
  8018e4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018eb:	00 
  8018ec:	c7 04 24 ec 3d 80 00 	movl   $0x803dec,(%esp)
  8018f3:	e8 84 f1 ff ff       	call   800a7c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8018f8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018fb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018fe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801901:	89 ec                	mov    %ebp,%esp
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    

00801905 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 38             	sub    $0x38,%esp
  80190b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80190e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801911:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801914:	bb 00 00 00 00       	mov    $0x0,%ebx
  801919:	b8 09 00 00 00       	mov    $0x9,%eax
  80191e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801921:	8b 55 08             	mov    0x8(%ebp),%edx
  801924:	89 df                	mov    %ebx,%edi
  801926:	89 de                	mov    %ebx,%esi
  801928:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80192a:	85 c0                	test   %eax,%eax
  80192c:	7e 28                	jle    801956 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80192e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801932:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801939:	00 
  80193a:	c7 44 24 08 cf 3d 80 	movl   $0x803dcf,0x8(%esp)
  801941:	00 
  801942:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801949:	00 
  80194a:	c7 04 24 ec 3d 80 00 	movl   $0x803dec,(%esp)
  801951:	e8 26 f1 ff ff       	call   800a7c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801956:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801959:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80195c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80195f:	89 ec                	mov    %ebp,%esp
  801961:	5d                   	pop    %ebp
  801962:	c3                   	ret    

00801963 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 38             	sub    $0x38,%esp
  801969:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80196c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80196f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801972:	bb 00 00 00 00       	mov    $0x0,%ebx
  801977:	b8 0a 00 00 00       	mov    $0xa,%eax
  80197c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80197f:	8b 55 08             	mov    0x8(%ebp),%edx
  801982:	89 df                	mov    %ebx,%edi
  801984:	89 de                	mov    %ebx,%esi
  801986:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801988:	85 c0                	test   %eax,%eax
  80198a:	7e 28                	jle    8019b4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80198c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801990:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801997:	00 
  801998:	c7 44 24 08 cf 3d 80 	movl   $0x803dcf,0x8(%esp)
  80199f:	00 
  8019a0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8019a7:	00 
  8019a8:	c7 04 24 ec 3d 80 00 	movl   $0x803dec,(%esp)
  8019af:	e8 c8 f0 ff ff       	call   800a7c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8019b4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019b7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019ba:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019bd:	89 ec                	mov    %ebp,%esp
  8019bf:	5d                   	pop    %ebp
  8019c0:	c3                   	ret    

008019c1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	83 ec 0c             	sub    $0xc,%esp
  8019c7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019ca:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019cd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019d0:	be 00 00 00 00       	mov    $0x0,%esi
  8019d5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8019da:	8b 7d 14             	mov    0x14(%ebp),%edi
  8019dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8019e8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019eb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019ee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019f1:	89 ec                	mov    %ebp,%esp
  8019f3:	5d                   	pop    %ebp
  8019f4:	c3                   	ret    

008019f5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 38             	sub    $0x38,%esp
  8019fb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019fe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a01:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a04:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a09:	b8 0d 00 00 00       	mov    $0xd,%eax
  801a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801a11:	89 cb                	mov    %ecx,%ebx
  801a13:	89 cf                	mov    %ecx,%edi
  801a15:	89 ce                	mov    %ecx,%esi
  801a17:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	7e 28                	jle    801a45 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a1d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a21:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801a28:	00 
  801a29:	c7 44 24 08 cf 3d 80 	movl   $0x803dcf,0x8(%esp)
  801a30:	00 
  801a31:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a38:	00 
  801a39:	c7 04 24 ec 3d 80 00 	movl   $0x803dec,(%esp)
  801a40:	e8 37 f0 ff ff       	call   800a7c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801a45:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a48:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a4b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a4e:	89 ec                	mov    %ebp,%esp
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    
	...

00801a54 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	53                   	push   %ebx
  801a58:	83 ec 24             	sub    $0x24,%esp
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801a5e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((err & FEC_WR) == 0 || (uvpd[PDX(addr)] & PTE_P) == 0 || (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  801a60:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801a64:	74 21                	je     801a87 <pgfault+0x33>
  801a66:	89 d8                	mov    %ebx,%eax
  801a68:	c1 e8 16             	shr    $0x16,%eax
  801a6b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a72:	a8 01                	test   $0x1,%al
  801a74:	74 11                	je     801a87 <pgfault+0x33>
  801a76:	89 d8                	mov    %ebx,%eax
  801a78:	c1 e8 0c             	shr    $0xc,%eax
  801a7b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a82:	f6 c4 08             	test   $0x8,%ah
  801a85:	75 1c                	jne    801aa3 <pgfault+0x4f>
		panic ("pgfault: not a write or attempting to access a non-COW page");
  801a87:	c7 44 24 08 fc 3d 80 	movl   $0x803dfc,0x8(%esp)
  801a8e:	00 
  801a8f:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  801a96:	00 
  801a97:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  801a9e:	e8 d9 ef ff ff       	call   800a7c <_panic>
	if((r = sys_page_alloc (0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  801aa3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801aaa:	00 
  801aab:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801ab2:	00 
  801ab3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aba:	e8 cd fc ff ff       	call   80178c <sys_page_alloc>
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	79 20                	jns    801ae3 <pgfault+0x8f>
		panic("pgfault: page allocation failed : %e", r);
  801ac3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ac7:	c7 44 24 08 38 3e 80 	movl   $0x803e38,0x8(%esp)
  801ace:	00 
  801acf:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  801ad6:	00 
  801ad7:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  801ade:	e8 99 ef ff ff       	call   800a7c <_panic>
	addr = ROUNDDOWN (addr, PGSIZE);
  801ae3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove (PFTEMP, addr, PGSIZE);
  801ae9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801af0:	00 
  801af1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801af5:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801afc:	e8 7b f9 ff ff       	call   80147c <memmove>
	if ((r = sys_page_map (0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  801b01:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801b08:	00 
  801b09:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801b0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b14:	00 
  801b15:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801b1c:	00 
  801b1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b24:	e8 c2 fc ff ff       	call   8017eb <sys_page_map>
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	79 20                	jns    801b4d <pgfault+0xf9>
		panic ("pgfault: page mapping failed : %e", r);
  801b2d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b31:	c7 44 24 08 60 3e 80 	movl   $0x803e60,0x8(%esp)
  801b38:	00 
  801b39:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  801b40:	00 
  801b41:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  801b48:	e8 2f ef ff ff       	call   800a7c <_panic>
	//panic("pgfault not implemented");
}
  801b4d:	83 c4 24             	add    $0x24,%esp
  801b50:	5b                   	pop    %ebx
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    

00801b53 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	57                   	push   %edi
  801b57:	56                   	push   %esi
  801b58:	53                   	push   %ebx
  801b59:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler (pgfault);
  801b5c:	c7 04 24 54 1a 80 00 	movl   $0x801a54,(%esp)
  801b63:	e8 58 18 00 00       	call   8033c0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801b68:	ba 07 00 00 00       	mov    $0x7,%edx
  801b6d:	89 d0                	mov    %edx,%eax
  801b6f:	cd 30                	int    $0x30
  801b71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b74:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uint32_t addr;
	int r;
	envid = sys_exofork();
	if (envid < 0)
  801b76:	85 c0                	test   %eax,%eax
  801b78:	79 20                	jns    801b9a <fork+0x47>
		panic("sys_exofork: %e", envid);
  801b7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b7e:	c7 44 24 08 5e 3f 80 	movl   $0x803f5e,0x8(%esp)
  801b85:	00 
  801b86:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  801b8d:	00 
  801b8e:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  801b95:	e8 e2 ee ff ff       	call   800a7c <_panic>
	if (envid == 0) {
  801b9a:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801b9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ba3:	75 1c                	jne    801bc1 <fork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801ba5:	e8 82 fb ff ff       	call   80172c <sys_getenvid>
  801baa:	25 ff 03 00 00       	and    $0x3ff,%eax
  801baf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801bb2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801bb7:	a3 24 64 80 00       	mov    %eax,0x806424
		return 0;
  801bbc:	e9 06 02 00 00       	jmp    801dc7 <fork+0x274>
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
  801bc1:	89 d8                	mov    %ebx,%eax
  801bc3:	c1 e8 16             	shr    $0x16,%eax
  801bc6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801bcd:	a8 01                	test   $0x1,%al
  801bcf:	0f 84 57 01 00 00    	je     801d2c <fork+0x1d9>
  801bd5:	89 de                	mov    %ebx,%esi
  801bd7:	c1 ee 0c             	shr    $0xc,%esi
  801bda:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801be1:	a8 01                	test   $0x1,%al
  801be3:	0f 84 43 01 00 00    	je     801d2c <fork+0x1d9>
  801be9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801bf0:	a8 04                	test   $0x4,%al
  801bf2:	0f 84 34 01 00 00    	je     801d2c <fork+0x1d9>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  801bf8:	c1 e6 0c             	shl    $0xc,%esi
	pte_t pte = uvpt[PGNUM(addr)];
  801bfb:	89 f0                	mov    %esi,%eax
  801bfd:	c1 e8 0c             	shr    $0xc,%eax
  801c00:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(pte & PTE_SHARE){
  801c07:	f6 c4 04             	test   $0x4,%ah
  801c0a:	74 45                	je     801c51 <fork+0xfe>
		if((r = sys_page_map(0,addr, envid, addr, pte & PTE_SYSCALL)) < 0){
  801c0c:	25 07 0e 00 00       	and    $0xe07,%eax
  801c11:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c15:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c19:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801c1d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c28:	e8 be fb ff ff       	call   8017eb <sys_page_map>
  801c2d:	85 c0                	test   %eax,%eax
  801c2f:	0f 89 f7 00 00 00    	jns    801d2c <fork+0x1d9>
			panic ("duppage: error at lab5");
  801c35:	c7 44 24 08 6e 3f 80 	movl   $0x803f6e,0x8(%esp)
  801c3c:	00 
  801c3d:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  801c44:	00 
  801c45:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  801c4c:	e8 2b ee ff ff       	call   800a7c <_panic>
		}
	}
	else if((pte & PTE_W) > 0 || (pte & PTE_COW) > 0) {
  801c51:	a9 02 08 00 00       	test   $0x802,%eax
  801c56:	0f 84 8c 00 00 00    	je     801ce8 <fork+0x195>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  801c5c:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801c63:	00 
  801c64:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c68:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801c6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c77:	e8 6f fb ff ff       	call   8017eb <sys_page_map>
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	79 20                	jns    801ca0 <fork+0x14d>
			panic ("duppage: page re-mapping failed at 1 : %e", r);
  801c80:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c84:	c7 44 24 08 84 3e 80 	movl   $0x803e84,0x8(%esp)
  801c8b:	00 
  801c8c:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  801c93:	00 
  801c94:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  801c9b:	e8 dc ed ff ff       	call   800a7c <_panic>
		if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  801ca0:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801ca7:	00 
  801ca8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801cac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cb3:	00 
  801cb4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cb8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cbf:	e8 27 fb ff ff       	call   8017eb <sys_page_map>
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	79 64                	jns    801d2c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 2 : %e", r);
  801cc8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ccc:	c7 44 24 08 b0 3e 80 	movl   $0x803eb0,0x8(%esp)
  801cd3:	00 
  801cd4:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  801cdb:	00 
  801cdc:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  801ce3:	e8 94 ed ff ff       	call   800a7c <_panic>
	} 
	else{
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801ce8:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801cef:	00 
  801cf0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801cf4:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801cf8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cfc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d03:	e8 e3 fa ff ff       	call   8017eb <sys_page_map>
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	79 20                	jns    801d2c <fork+0x1d9>
			panic ("duppage: page re-mapping failed at 3 : %e", r);
  801d0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d10:	c7 44 24 08 dc 3e 80 	movl   $0x803edc,0x8(%esp)
  801d17:	00 
  801d18:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801d1f:	00 
  801d20:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  801d27:	e8 50 ed ff ff       	call   800a7c <_panic>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for (addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE) {
  801d2c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d32:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801d38:	0f 85 83 fe ff ff    	jne    801bc1 <fork+0x6e>
		if ((uvpd[PDX(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_P) > 0 && (uvpt[PGNUM(addr)] & PTE_U) > 0)
		duppage (envid, PGNUM(addr));
	}
	if ((r = sys_page_alloc (envid, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_W|PTE_P)) < 0)
  801d3e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d45:	00 
  801d46:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801d4d:	ee 
  801d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d51:	89 04 24             	mov    %eax,(%esp)
  801d54:	e8 33 fa ff ff       	call   80178c <sys_page_alloc>
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	79 20                	jns    801d7d <fork+0x22a>
		panic ("fork: page allocation failed : %e", r);
  801d5d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d61:	c7 44 24 08 08 3f 80 	movl   $0x803f08,0x8(%esp)
  801d68:	00 
  801d69:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801d70:	00 
  801d71:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  801d78:	e8 ff ec ff ff       	call   800a7c <_panic>
	extern void _pgfault_upcall (void);
	sys_env_set_pgfault_upcall (envid, _pgfault_upcall);
  801d7d:	c7 44 24 04 30 34 80 	movl   $0x803430,0x4(%esp)
  801d84:	00 
  801d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d88:	89 04 24             	mov    %eax,(%esp)
  801d8b:	e8 d3 fb ff ff       	call   801963 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801d90:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801d97:	00 
  801d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d9b:	89 04 24             	mov    %eax,(%esp)
  801d9e:	e8 04 fb ff ff       	call   8018a7 <sys_env_set_status>
  801da3:	85 c0                	test   %eax,%eax
  801da5:	79 20                	jns    801dc7 <fork+0x274>
		panic("fork: set child env status failed : %e", r);
  801da7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dab:	c7 44 24 08 2c 3f 80 	movl   $0x803f2c,0x8(%esp)
  801db2:	00 
  801db3:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  801dba:	00 
  801dbb:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  801dc2:	e8 b5 ec ff ff       	call   800a7c <_panic>
	return envid;
	//panic("fork not implemented");
	
}
  801dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dca:	83 c4 3c             	add    $0x3c,%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5e                   	pop    %esi
  801dcf:	5f                   	pop    %edi
  801dd0:	5d                   	pop    %ebp
  801dd1:	c3                   	ret    

00801dd2 <sfork>:

// Challenge!
int
sfork(void)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801dd8:	c7 44 24 08 85 3f 80 	movl   $0x803f85,0x8(%esp)
  801ddf:	00 
  801de0:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  801de7:	00 
  801de8:	c7 04 24 53 3f 80 00 	movl   $0x803f53,(%esp)
  801def:	e8 88 ec ff ff       	call   800a7c <_panic>

00801df4 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	8b 55 08             	mov    0x8(%ebp),%edx
  801dfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dfd:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801e00:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801e02:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801e05:	83 3a 01             	cmpl   $0x1,(%edx)
  801e08:	7e 09                	jle    801e13 <argstart+0x1f>
  801e0a:	ba a1 38 80 00       	mov    $0x8038a1,%edx
  801e0f:	85 c9                	test   %ecx,%ecx
  801e11:	75 05                	jne    801e18 <argstart+0x24>
  801e13:	ba 00 00 00 00       	mov    $0x0,%edx
  801e18:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801e1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    

00801e24 <argnext>:

int
argnext(struct Argstate *args)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	53                   	push   %ebx
  801e28:	83 ec 14             	sub    $0x14,%esp
  801e2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801e2e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801e35:	8b 43 08             	mov    0x8(%ebx),%eax
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	74 71                	je     801ead <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801e3c:	80 38 00             	cmpb   $0x0,(%eax)
  801e3f:	75 50                	jne    801e91 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801e41:	8b 0b                	mov    (%ebx),%ecx
  801e43:	83 39 01             	cmpl   $0x1,(%ecx)
  801e46:	74 57                	je     801e9f <argnext+0x7b>
		    || args->argv[1][0] != '-'
  801e48:	8b 53 04             	mov    0x4(%ebx),%edx
  801e4b:	8b 42 04             	mov    0x4(%edx),%eax
  801e4e:	80 38 2d             	cmpb   $0x2d,(%eax)
  801e51:	75 4c                	jne    801e9f <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801e53:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801e57:	74 46                	je     801e9f <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801e59:	83 c0 01             	add    $0x1,%eax
  801e5c:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e5f:	8b 01                	mov    (%ecx),%eax
  801e61:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801e68:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e6c:	8d 42 08             	lea    0x8(%edx),%eax
  801e6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e73:	83 c2 04             	add    $0x4,%edx
  801e76:	89 14 24             	mov    %edx,(%esp)
  801e79:	e8 fe f5 ff ff       	call   80147c <memmove>
		(*args->argc)--;
  801e7e:	8b 03                	mov    (%ebx),%eax
  801e80:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801e83:	8b 43 08             	mov    0x8(%ebx),%eax
  801e86:	80 38 2d             	cmpb   $0x2d,(%eax)
  801e89:	75 06                	jne    801e91 <argnext+0x6d>
  801e8b:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801e8f:	74 0e                	je     801e9f <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801e91:	8b 53 08             	mov    0x8(%ebx),%edx
  801e94:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801e97:	83 c2 01             	add    $0x1,%edx
  801e9a:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801e9d:	eb 13                	jmp    801eb2 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  801e9f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801ea6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801eab:	eb 05                	jmp    801eb2 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  801ead:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801eb2:	83 c4 14             	add    $0x14,%esp
  801eb5:	5b                   	pop    %ebx
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    

00801eb8 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	53                   	push   %ebx
  801ebc:	83 ec 14             	sub    $0x14,%esp
  801ebf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801ec2:	8b 43 08             	mov    0x8(%ebx),%eax
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	74 5a                	je     801f23 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  801ec9:	80 38 00             	cmpb   $0x0,(%eax)
  801ecc:	74 0c                	je     801eda <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801ece:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801ed1:	c7 43 08 a1 38 80 00 	movl   $0x8038a1,0x8(%ebx)
  801ed8:	eb 44                	jmp    801f1e <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  801eda:	8b 03                	mov    (%ebx),%eax
  801edc:	83 38 01             	cmpl   $0x1,(%eax)
  801edf:	7e 2f                	jle    801f10 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  801ee1:	8b 53 04             	mov    0x4(%ebx),%edx
  801ee4:	8b 4a 04             	mov    0x4(%edx),%ecx
  801ee7:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801eea:	8b 00                	mov    (%eax),%eax
  801eec:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801ef3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef7:	8d 42 08             	lea    0x8(%edx),%eax
  801efa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efe:	83 c2 04             	add    $0x4,%edx
  801f01:	89 14 24             	mov    %edx,(%esp)
  801f04:	e8 73 f5 ff ff       	call   80147c <memmove>
		(*args->argc)--;
  801f09:	8b 03                	mov    (%ebx),%eax
  801f0b:	83 28 01             	subl   $0x1,(%eax)
  801f0e:	eb 0e                	jmp    801f1e <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  801f10:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801f17:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801f1e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f21:	eb 05                	jmp    801f28 <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  801f28:	83 c4 14             	add    $0x14,%esp
  801f2b:	5b                   	pop    %ebx
  801f2c:	5d                   	pop    %ebp
  801f2d:	c3                   	ret    

00801f2e <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 18             	sub    $0x18,%esp
  801f34:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801f37:	8b 42 0c             	mov    0xc(%edx),%eax
  801f3a:	85 c0                	test   %eax,%eax
  801f3c:	75 08                	jne    801f46 <argvalue+0x18>
  801f3e:	89 14 24             	mov    %edx,(%esp)
  801f41:	e8 72 ff ff ff       	call   801eb8 <argnextvalue>
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    
	...

00801f50 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	05 00 00 00 30       	add    $0x30000000,%eax
  801f5b:	c1 e8 0c             	shr    $0xc,%eax
}
  801f5e:	5d                   	pop    %ebp
  801f5f:	c3                   	ret    

00801f60 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	89 04 24             	mov    %eax,(%esp)
  801f6c:	e8 df ff ff ff       	call   801f50 <fd2num>
  801f71:	05 20 00 0d 00       	add    $0xd0020,%eax
  801f76:	c1 e0 0c             	shl    $0xc,%eax
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	53                   	push   %ebx
  801f7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f82:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801f87:	a8 01                	test   $0x1,%al
  801f89:	74 34                	je     801fbf <fd_alloc+0x44>
  801f8b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801f90:	a8 01                	test   $0x1,%al
  801f92:	74 32                	je     801fc6 <fd_alloc+0x4b>
  801f94:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801f99:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f9b:	89 c2                	mov    %eax,%edx
  801f9d:	c1 ea 16             	shr    $0x16,%edx
  801fa0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801fa7:	f6 c2 01             	test   $0x1,%dl
  801faa:	74 1f                	je     801fcb <fd_alloc+0x50>
  801fac:	89 c2                	mov    %eax,%edx
  801fae:	c1 ea 0c             	shr    $0xc,%edx
  801fb1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801fb8:	f6 c2 01             	test   $0x1,%dl
  801fbb:	75 17                	jne    801fd4 <fd_alloc+0x59>
  801fbd:	eb 0c                	jmp    801fcb <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801fbf:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801fc4:	eb 05                	jmp    801fcb <fd_alloc+0x50>
  801fc6:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801fcb:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd2:	eb 17                	jmp    801feb <fd_alloc+0x70>
  801fd4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fd9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801fde:	75 b9                	jne    801f99 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801fe0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801fe6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801feb:	5b                   	pop    %ebx
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    

00801fee <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ff4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ff9:	83 fa 1f             	cmp    $0x1f,%edx
  801ffc:	77 3f                	ja     80203d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801ffe:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  802004:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802007:	89 d0                	mov    %edx,%eax
  802009:	c1 e8 16             	shr    $0x16,%eax
  80200c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802013:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802018:	f6 c1 01             	test   $0x1,%cl
  80201b:	74 20                	je     80203d <fd_lookup+0x4f>
  80201d:	89 d0                	mov    %edx,%eax
  80201f:	c1 e8 0c             	shr    $0xc,%eax
  802022:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802029:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80202e:	f6 c1 01             	test   $0x1,%cl
  802031:	74 0a                	je     80203d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802033:	8b 45 0c             	mov    0xc(%ebp),%eax
  802036:	89 10                	mov    %edx,(%eax)
	return 0;
  802038:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203d:	5d                   	pop    %ebp
  80203e:	c3                   	ret    

0080203f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	53                   	push   %ebx
  802043:	83 ec 14             	sub    $0x14,%esp
  802046:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802049:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80204c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  802051:	39 0d 20 50 80 00    	cmp    %ecx,0x805020
  802057:	75 17                	jne    802070 <dev_lookup+0x31>
  802059:	eb 07                	jmp    802062 <dev_lookup+0x23>
  80205b:	39 0a                	cmp    %ecx,(%edx)
  80205d:	75 11                	jne    802070 <dev_lookup+0x31>
  80205f:	90                   	nop
  802060:	eb 05                	jmp    802067 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802062:	ba 20 50 80 00       	mov    $0x805020,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  802067:	89 13                	mov    %edx,(%ebx)
			return 0;
  802069:	b8 00 00 00 00       	mov    $0x0,%eax
  80206e:	eb 35                	jmp    8020a5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802070:	83 c0 01             	add    $0x1,%eax
  802073:	8b 14 85 18 40 80 00 	mov    0x804018(,%eax,4),%edx
  80207a:	85 d2                	test   %edx,%edx
  80207c:	75 dd                	jne    80205b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80207e:	a1 24 64 80 00       	mov    0x806424,%eax
  802083:	8b 40 48             	mov    0x48(%eax),%eax
  802086:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80208a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208e:	c7 04 24 9c 3f 80 00 	movl   $0x803f9c,(%esp)
  802095:	e8 dd ea ff ff       	call   800b77 <cprintf>
	*dev = 0;
  80209a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8020a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020a5:	83 c4 14             	add    $0x14,%esp
  8020a8:	5b                   	pop    %ebx
  8020a9:	5d                   	pop    %ebp
  8020aa:	c3                   	ret    

008020ab <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 38             	sub    $0x38,%esp
  8020b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8020b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8020b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8020ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020bd:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8020c1:	89 3c 24             	mov    %edi,(%esp)
  8020c4:	e8 87 fe ff ff       	call   801f50 <fd2num>
  8020c9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8020cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020d0:	89 04 24             	mov    %eax,(%esp)
  8020d3:	e8 16 ff ff ff       	call   801fee <fd_lookup>
  8020d8:	89 c3                	mov    %eax,%ebx
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	78 05                	js     8020e3 <fd_close+0x38>
	    || fd != fd2)
  8020de:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8020e1:	74 0e                	je     8020f1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8020e3:	89 f0                	mov    %esi,%eax
  8020e5:	84 c0                	test   %al,%al
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ec:	0f 44 d8             	cmove  %eax,%ebx
  8020ef:	eb 3d                	jmp    80212e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8020f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f8:	8b 07                	mov    (%edi),%eax
  8020fa:	89 04 24             	mov    %eax,(%esp)
  8020fd:	e8 3d ff ff ff       	call   80203f <dev_lookup>
  802102:	89 c3                	mov    %eax,%ebx
  802104:	85 c0                	test   %eax,%eax
  802106:	78 16                	js     80211e <fd_close+0x73>
		if (dev->dev_close)
  802108:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80210e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  802113:	85 c0                	test   %eax,%eax
  802115:	74 07                	je     80211e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  802117:	89 3c 24             	mov    %edi,(%esp)
  80211a:	ff d0                	call   *%eax
  80211c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80211e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802122:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802129:	e8 1b f7 ff ff       	call   801849 <sys_page_unmap>
	return r;
}
  80212e:	89 d8                	mov    %ebx,%eax
  802130:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802133:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802136:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802139:	89 ec                	mov    %ebp,%esp
  80213b:	5d                   	pop    %ebp
  80213c:	c3                   	ret    

0080213d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802143:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802146:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	89 04 24             	mov    %eax,(%esp)
  802150:	e8 99 fe ff ff       	call   801fee <fd_lookup>
  802155:	85 c0                	test   %eax,%eax
  802157:	78 13                	js     80216c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  802159:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802160:	00 
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	89 04 24             	mov    %eax,(%esp)
  802167:	e8 3f ff ff ff       	call   8020ab <fd_close>
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <close_all>:

void
close_all(void)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	53                   	push   %ebx
  802172:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802175:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80217a:	89 1c 24             	mov    %ebx,(%esp)
  80217d:	e8 bb ff ff ff       	call   80213d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802182:	83 c3 01             	add    $0x1,%ebx
  802185:	83 fb 20             	cmp    $0x20,%ebx
  802188:	75 f0                	jne    80217a <close_all+0xc>
		close(i);
}
  80218a:	83 c4 14             	add    $0x14,%esp
  80218d:	5b                   	pop    %ebx
  80218e:	5d                   	pop    %ebp
  80218f:	c3                   	ret    

00802190 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 58             	sub    $0x58,%esp
  802196:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802199:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80219c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80219f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8021a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	89 04 24             	mov    %eax,(%esp)
  8021af:	e8 3a fe ff ff       	call   801fee <fd_lookup>
  8021b4:	89 c3                	mov    %eax,%ebx
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	0f 88 e1 00 00 00    	js     80229f <dup+0x10f>
		return r;
	close(newfdnum);
  8021be:	89 3c 24             	mov    %edi,(%esp)
  8021c1:	e8 77 ff ff ff       	call   80213d <close>

	newfd = INDEX2FD(newfdnum);
  8021c6:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8021cc:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8021cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021d2:	89 04 24             	mov    %eax,(%esp)
  8021d5:	e8 86 fd ff ff       	call   801f60 <fd2data>
  8021da:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8021dc:	89 34 24             	mov    %esi,(%esp)
  8021df:	e8 7c fd ff ff       	call   801f60 <fd2data>
  8021e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021e7:	89 d8                	mov    %ebx,%eax
  8021e9:	c1 e8 16             	shr    $0x16,%eax
  8021ec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8021f3:	a8 01                	test   $0x1,%al
  8021f5:	74 46                	je     80223d <dup+0xad>
  8021f7:	89 d8                	mov    %ebx,%eax
  8021f9:	c1 e8 0c             	shr    $0xc,%eax
  8021fc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802203:	f6 c2 01             	test   $0x1,%dl
  802206:	74 35                	je     80223d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802208:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80220f:	25 07 0e 00 00       	and    $0xe07,%eax
  802214:	89 44 24 10          	mov    %eax,0x10(%esp)
  802218:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80221b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80221f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802226:	00 
  802227:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80222b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802232:	e8 b4 f5 ff ff       	call   8017eb <sys_page_map>
  802237:	89 c3                	mov    %eax,%ebx
  802239:	85 c0                	test   %eax,%eax
  80223b:	78 3b                	js     802278 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80223d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802240:	89 c2                	mov    %eax,%edx
  802242:	c1 ea 0c             	shr    $0xc,%edx
  802245:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80224c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802252:	89 54 24 10          	mov    %edx,0x10(%esp)
  802256:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80225a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802261:	00 
  802262:	89 44 24 04          	mov    %eax,0x4(%esp)
  802266:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80226d:	e8 79 f5 ff ff       	call   8017eb <sys_page_map>
  802272:	89 c3                	mov    %eax,%ebx
  802274:	85 c0                	test   %eax,%eax
  802276:	79 25                	jns    80229d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802278:	89 74 24 04          	mov    %esi,0x4(%esp)
  80227c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802283:	e8 c1 f5 ff ff       	call   801849 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80228b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802296:	e8 ae f5 ff ff       	call   801849 <sys_page_unmap>
	return r;
  80229b:	eb 02                	jmp    80229f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80229d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80229f:	89 d8                	mov    %ebx,%eax
  8022a1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8022a4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8022a7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8022aa:	89 ec                	mov    %ebp,%esp
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    

008022ae <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	53                   	push   %ebx
  8022b2:	83 ec 24             	sub    $0x24,%esp
  8022b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022bf:	89 1c 24             	mov    %ebx,(%esp)
  8022c2:	e8 27 fd ff ff       	call   801fee <fd_lookup>
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	78 6d                	js     802338 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d5:	8b 00                	mov    (%eax),%eax
  8022d7:	89 04 24             	mov    %eax,(%esp)
  8022da:	e8 60 fd ff ff       	call   80203f <dev_lookup>
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	78 55                	js     802338 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e6:	8b 50 08             	mov    0x8(%eax),%edx
  8022e9:	83 e2 03             	and    $0x3,%edx
  8022ec:	83 fa 01             	cmp    $0x1,%edx
  8022ef:	75 23                	jne    802314 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022f1:	a1 24 64 80 00       	mov    0x806424,%eax
  8022f6:	8b 40 48             	mov    0x48(%eax),%eax
  8022f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802301:	c7 04 24 dd 3f 80 00 	movl   $0x803fdd,(%esp)
  802308:	e8 6a e8 ff ff       	call   800b77 <cprintf>
		return -E_INVAL;
  80230d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802312:	eb 24                	jmp    802338 <read+0x8a>
	}
	if (!dev->dev_read)
  802314:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802317:	8b 52 08             	mov    0x8(%edx),%edx
  80231a:	85 d2                	test   %edx,%edx
  80231c:	74 15                	je     802333 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80231e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802321:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802325:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802328:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80232c:	89 04 24             	mov    %eax,(%esp)
  80232f:	ff d2                	call   *%edx
  802331:	eb 05                	jmp    802338 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  802333:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  802338:	83 c4 24             	add    $0x24,%esp
  80233b:	5b                   	pop    %ebx
  80233c:	5d                   	pop    %ebp
  80233d:	c3                   	ret    

0080233e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	57                   	push   %edi
  802342:	56                   	push   %esi
  802343:	53                   	push   %ebx
  802344:	83 ec 1c             	sub    $0x1c,%esp
  802347:	8b 7d 08             	mov    0x8(%ebp),%edi
  80234a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80234d:	b8 00 00 00 00       	mov    $0x0,%eax
  802352:	85 f6                	test   %esi,%esi
  802354:	74 30                	je     802386 <readn+0x48>
  802356:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80235b:	89 f2                	mov    %esi,%edx
  80235d:	29 c2                	sub    %eax,%edx
  80235f:	89 54 24 08          	mov    %edx,0x8(%esp)
  802363:	03 45 0c             	add    0xc(%ebp),%eax
  802366:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236a:	89 3c 24             	mov    %edi,(%esp)
  80236d:	e8 3c ff ff ff       	call   8022ae <read>
		if (m < 0)
  802372:	85 c0                	test   %eax,%eax
  802374:	78 10                	js     802386 <readn+0x48>
			return m;
		if (m == 0)
  802376:	85 c0                	test   %eax,%eax
  802378:	74 0a                	je     802384 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80237a:	01 c3                	add    %eax,%ebx
  80237c:	89 d8                	mov    %ebx,%eax
  80237e:	39 f3                	cmp    %esi,%ebx
  802380:	72 d9                	jb     80235b <readn+0x1d>
  802382:	eb 02                	jmp    802386 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  802384:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  802386:	83 c4 1c             	add    $0x1c,%esp
  802389:	5b                   	pop    %ebx
  80238a:	5e                   	pop    %esi
  80238b:	5f                   	pop    %edi
  80238c:	5d                   	pop    %ebp
  80238d:	c3                   	ret    

0080238e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	53                   	push   %ebx
  802392:	83 ec 24             	sub    $0x24,%esp
  802395:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802398:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80239b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239f:	89 1c 24             	mov    %ebx,(%esp)
  8023a2:	e8 47 fc ff ff       	call   801fee <fd_lookup>
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	78 68                	js     802413 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	89 04 24             	mov    %eax,(%esp)
  8023ba:	e8 80 fc ff ff       	call   80203f <dev_lookup>
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	78 50                	js     802413 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8023ca:	75 23                	jne    8023ef <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023cc:	a1 24 64 80 00       	mov    0x806424,%eax
  8023d1:	8b 40 48             	mov    0x48(%eax),%eax
  8023d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023dc:	c7 04 24 f9 3f 80 00 	movl   $0x803ff9,(%esp)
  8023e3:	e8 8f e7 ff ff       	call   800b77 <cprintf>
		return -E_INVAL;
  8023e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023ed:	eb 24                	jmp    802413 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f2:	8b 52 0c             	mov    0xc(%edx),%edx
  8023f5:	85 d2                	test   %edx,%edx
  8023f7:	74 15                	je     80240e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8023f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023fc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802400:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802403:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802407:	89 04 24             	mov    %eax,(%esp)
  80240a:	ff d2                	call   *%edx
  80240c:	eb 05                	jmp    802413 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80240e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  802413:	83 c4 24             	add    $0x24,%esp
  802416:	5b                   	pop    %ebx
  802417:	5d                   	pop    %ebp
  802418:	c3                   	ret    

00802419 <seek>:

int
seek(int fdnum, off_t offset)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
  80241c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80241f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802422:	89 44 24 04          	mov    %eax,0x4(%esp)
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	89 04 24             	mov    %eax,(%esp)
  80242c:	e8 bd fb ff ff       	call   801fee <fd_lookup>
  802431:	85 c0                	test   %eax,%eax
  802433:	78 0e                	js     802443 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  802435:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	53                   	push   %ebx
  802449:	83 ec 24             	sub    $0x24,%esp
  80244c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80244f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802452:	89 44 24 04          	mov    %eax,0x4(%esp)
  802456:	89 1c 24             	mov    %ebx,(%esp)
  802459:	e8 90 fb ff ff       	call   801fee <fd_lookup>
  80245e:	85 c0                	test   %eax,%eax
  802460:	78 61                	js     8024c3 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802465:	89 44 24 04          	mov    %eax,0x4(%esp)
  802469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246c:	8b 00                	mov    (%eax),%eax
  80246e:	89 04 24             	mov    %eax,(%esp)
  802471:	e8 c9 fb ff ff       	call   80203f <dev_lookup>
  802476:	85 c0                	test   %eax,%eax
  802478:	78 49                	js     8024c3 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80247a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802481:	75 23                	jne    8024a6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802483:	a1 24 64 80 00       	mov    0x806424,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802488:	8b 40 48             	mov    0x48(%eax),%eax
  80248b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80248f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802493:	c7 04 24 bc 3f 80 00 	movl   $0x803fbc,(%esp)
  80249a:	e8 d8 e6 ff ff       	call   800b77 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80249f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024a4:	eb 1d                	jmp    8024c3 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8024a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a9:	8b 52 18             	mov    0x18(%edx),%edx
  8024ac:	85 d2                	test   %edx,%edx
  8024ae:	74 0e                	je     8024be <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8024b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024b7:	89 04 24             	mov    %eax,(%esp)
  8024ba:	ff d2                	call   *%edx
  8024bc:	eb 05                	jmp    8024c3 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8024be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8024c3:	83 c4 24             	add    $0x24,%esp
  8024c6:	5b                   	pop    %ebx
  8024c7:	5d                   	pop    %ebp
  8024c8:	c3                   	ret    

008024c9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	53                   	push   %ebx
  8024cd:	83 ec 24             	sub    $0x24,%esp
  8024d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024da:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dd:	89 04 24             	mov    %eax,(%esp)
  8024e0:	e8 09 fb ff ff       	call   801fee <fd_lookup>
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	78 52                	js     80253b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f3:	8b 00                	mov    (%eax),%eax
  8024f5:	89 04 24             	mov    %eax,(%esp)
  8024f8:	e8 42 fb ff ff       	call   80203f <dev_lookup>
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	78 3a                	js     80253b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802508:	74 2c                	je     802536 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80250a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80250d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802514:	00 00 00 
	stat->st_isdir = 0;
  802517:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80251e:	00 00 00 
	stat->st_dev = dev;
  802521:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802527:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80252b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252e:	89 14 24             	mov    %edx,(%esp)
  802531:	ff 50 14             	call   *0x14(%eax)
  802534:	eb 05                	jmp    80253b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  802536:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80253b:	83 c4 24             	add    $0x24,%esp
  80253e:	5b                   	pop    %ebx
  80253f:	5d                   	pop    %ebp
  802540:	c3                   	ret    

00802541 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
  802544:	83 ec 18             	sub    $0x18,%esp
  802547:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80254a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80254d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802554:	00 
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	89 04 24             	mov    %eax,(%esp)
  80255b:	e8 bc 01 00 00       	call   80271c <open>
  802560:	89 c3                	mov    %eax,%ebx
  802562:	85 c0                	test   %eax,%eax
  802564:	78 1b                	js     802581 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  802566:	8b 45 0c             	mov    0xc(%ebp),%eax
  802569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80256d:	89 1c 24             	mov    %ebx,(%esp)
  802570:	e8 54 ff ff ff       	call   8024c9 <fstat>
  802575:	89 c6                	mov    %eax,%esi
	close(fd);
  802577:	89 1c 24             	mov    %ebx,(%esp)
  80257a:	e8 be fb ff ff       	call   80213d <close>
	return r;
  80257f:	89 f3                	mov    %esi,%ebx
}
  802581:	89 d8                	mov    %ebx,%eax
  802583:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802586:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802589:	89 ec                	mov    %ebp,%esp
  80258b:	5d                   	pop    %ebp
  80258c:	c3                   	ret    
  80258d:	00 00                	add    %al,(%eax)
	...

00802590 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 18             	sub    $0x18,%esp
  802596:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802599:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80259c:	89 c3                	mov    %eax,%ebx
  80259e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8025a0:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  8025a7:	75 11                	jne    8025ba <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8025b0:	e8 81 0f 00 00       	call   803536 <ipc_find_env>
  8025b5:	a3 20 64 80 00       	mov    %eax,0x806420
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025ba:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8025c1:	00 
  8025c2:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8025c9:	00 
  8025ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025ce:	a1 20 64 80 00       	mov    0x806420,%eax
  8025d3:	89 04 24             	mov    %eax,(%esp)
  8025d6:	e8 d7 0e 00 00       	call   8034b2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8025db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025e2:	00 
  8025e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025ee:	e8 6d 0e 00 00       	call   803460 <ipc_recv>
}
  8025f3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8025f6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8025f9:	89 ec                	mov    %ebp,%esp
  8025fb:	5d                   	pop    %ebp
  8025fc:	c3                   	ret    

008025fd <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
  802600:	53                   	push   %ebx
  802601:	83 ec 14             	sub    $0x14,%esp
  802604:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	8b 40 0c             	mov    0xc(%eax),%eax
  80260d:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802612:	ba 00 00 00 00       	mov    $0x0,%edx
  802617:	b8 05 00 00 00       	mov    $0x5,%eax
  80261c:	e8 6f ff ff ff       	call   802590 <fsipc>
  802621:	85 c0                	test   %eax,%eax
  802623:	78 2b                	js     802650 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802625:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80262c:	00 
  80262d:	89 1c 24             	mov    %ebx,(%esp)
  802630:	e8 56 ec ff ff       	call   80128b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802635:	a1 80 70 80 00       	mov    0x807080,%eax
  80263a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802640:	a1 84 70 80 00       	mov    0x807084,%eax
  802645:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80264b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802650:	83 c4 14             	add    $0x14,%esp
  802653:	5b                   	pop    %ebx
  802654:	5d                   	pop    %ebp
  802655:	c3                   	ret    

00802656 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
  802659:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80265c:	8b 45 08             	mov    0x8(%ebp),%eax
  80265f:	8b 40 0c             	mov    0xc(%eax),%eax
  802662:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  802667:	ba 00 00 00 00       	mov    $0x0,%edx
  80266c:	b8 06 00 00 00       	mov    $0x6,%eax
  802671:	e8 1a ff ff ff       	call   802590 <fsipc>
}
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	56                   	push   %esi
  80267c:	53                   	push   %ebx
  80267d:	83 ec 10             	sub    $0x10,%esp
  802680:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	8b 40 0c             	mov    0xc(%eax),%eax
  802689:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80268e:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802694:	ba 00 00 00 00       	mov    $0x0,%edx
  802699:	b8 03 00 00 00       	mov    $0x3,%eax
  80269e:	e8 ed fe ff ff       	call   802590 <fsipc>
  8026a3:	89 c3                	mov    %eax,%ebx
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	78 6a                	js     802713 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8026a9:	39 c6                	cmp    %eax,%esi
  8026ab:	73 24                	jae    8026d1 <devfile_read+0x59>
  8026ad:	c7 44 24 0c 28 40 80 	movl   $0x804028,0xc(%esp)
  8026b4:	00 
  8026b5:	c7 44 24 08 c9 39 80 	movl   $0x8039c9,0x8(%esp)
  8026bc:	00 
  8026bd:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8026c4:	00 
  8026c5:	c7 04 24 2f 40 80 00 	movl   $0x80402f,(%esp)
  8026cc:	e8 ab e3 ff ff       	call   800a7c <_panic>
	assert(r <= PGSIZE);
  8026d1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8026d6:	7e 24                	jle    8026fc <devfile_read+0x84>
  8026d8:	c7 44 24 0c 3a 40 80 	movl   $0x80403a,0xc(%esp)
  8026df:	00 
  8026e0:	c7 44 24 08 c9 39 80 	movl   $0x8039c9,0x8(%esp)
  8026e7:	00 
  8026e8:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8026ef:	00 
  8026f0:	c7 04 24 2f 40 80 00 	movl   $0x80402f,(%esp)
  8026f7:	e8 80 e3 ff ff       	call   800a7c <_panic>
	memmove(buf, &fsipcbuf, r);
  8026fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802700:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802707:	00 
  802708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80270b:	89 04 24             	mov    %eax,(%esp)
  80270e:	e8 69 ed ff ff       	call   80147c <memmove>
	return r;
}
  802713:	89 d8                	mov    %ebx,%eax
  802715:	83 c4 10             	add    $0x10,%esp
  802718:	5b                   	pop    %ebx
  802719:	5e                   	pop    %esi
  80271a:	5d                   	pop    %ebp
  80271b:	c3                   	ret    

0080271c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
  80271f:	56                   	push   %esi
  802720:	53                   	push   %ebx
  802721:	83 ec 20             	sub    $0x20,%esp
  802724:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802727:	89 34 24             	mov    %esi,(%esp)
  80272a:	e8 11 eb ff ff       	call   801240 <strlen>
		return -E_BAD_PATH;
  80272f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802734:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802739:	7f 5e                	jg     802799 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80273b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80273e:	89 04 24             	mov    %eax,(%esp)
  802741:	e8 35 f8 ff ff       	call   801f7b <fd_alloc>
  802746:	89 c3                	mov    %eax,%ebx
  802748:	85 c0                	test   %eax,%eax
  80274a:	78 4d                	js     802799 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80274c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802750:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  802757:	e8 2f eb ff ff       	call   80128b <strcpy>
	fsipcbuf.open.req_omode = mode;
  80275c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275f:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802767:	b8 01 00 00 00       	mov    $0x1,%eax
  80276c:	e8 1f fe ff ff       	call   802590 <fsipc>
  802771:	89 c3                	mov    %eax,%ebx
  802773:	85 c0                	test   %eax,%eax
  802775:	79 15                	jns    80278c <open+0x70>
		fd_close(fd, 0);
  802777:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80277e:	00 
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	89 04 24             	mov    %eax,(%esp)
  802785:	e8 21 f9 ff ff       	call   8020ab <fd_close>
		return r;
  80278a:	eb 0d                	jmp    802799 <open+0x7d>
	}

	return fd2num(fd);
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	89 04 24             	mov    %eax,(%esp)
  802792:	e8 b9 f7 ff ff       	call   801f50 <fd2num>
  802797:	89 c3                	mov    %eax,%ebx
}
  802799:	89 d8                	mov    %ebx,%eax
  80279b:	83 c4 20             	add    $0x20,%esp
  80279e:	5b                   	pop    %ebx
  80279f:	5e                   	pop    %esi
  8027a0:	5d                   	pop    %ebp
  8027a1:	c3                   	ret    
	...

008027a4 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
  8027a7:	53                   	push   %ebx
  8027a8:	83 ec 14             	sub    $0x14,%esp
  8027ab:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8027ad:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8027b1:	7e 31                	jle    8027e4 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8027b3:	8b 40 04             	mov    0x4(%eax),%eax
  8027b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027ba:	8d 43 10             	lea    0x10(%ebx),%eax
  8027bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c1:	8b 03                	mov    (%ebx),%eax
  8027c3:	89 04 24             	mov    %eax,(%esp)
  8027c6:	e8 c3 fb ff ff       	call   80238e <write>
		if (result > 0)
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	7e 03                	jle    8027d2 <writebuf+0x2e>
			b->result += result;
  8027cf:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8027d2:	39 43 04             	cmp    %eax,0x4(%ebx)
  8027d5:	74 0d                	je     8027e4 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8027de:	0f 4f c2             	cmovg  %edx,%eax
  8027e1:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8027e4:	83 c4 14             	add    $0x14,%esp
  8027e7:	5b                   	pop    %ebx
  8027e8:	5d                   	pop    %ebp
  8027e9:	c3                   	ret    

008027ea <putch>:

static void
putch(int ch, void *thunk)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	53                   	push   %ebx
  8027ee:	83 ec 04             	sub    $0x4,%esp
  8027f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8027f4:	8b 43 04             	mov    0x4(%ebx),%eax
  8027f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fa:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  8027fe:	83 c0 01             	add    $0x1,%eax
  802801:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  802804:	3d 00 01 00 00       	cmp    $0x100,%eax
  802809:	75 0e                	jne    802819 <putch+0x2f>
		writebuf(b);
  80280b:	89 d8                	mov    %ebx,%eax
  80280d:	e8 92 ff ff ff       	call   8027a4 <writebuf>
		b->idx = 0;
  802812:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  802819:	83 c4 04             	add    $0x4,%esp
  80281c:	5b                   	pop    %ebx
  80281d:	5d                   	pop    %ebp
  80281e:	c3                   	ret    

0080281f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80281f:	55                   	push   %ebp
  802820:	89 e5                	mov    %esp,%ebp
  802822:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802831:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802838:	00 00 00 
	b.result = 0;
  80283b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802842:	00 00 00 
	b.error = 1;
  802845:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  80284c:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80284f:	8b 45 10             	mov    0x10(%ebp),%eax
  802852:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802856:	8b 45 0c             	mov    0xc(%ebp),%eax
  802859:	89 44 24 08          	mov    %eax,0x8(%esp)
  80285d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802863:	89 44 24 04          	mov    %eax,0x4(%esp)
  802867:	c7 04 24 ea 27 80 00 	movl   $0x8027ea,(%esp)
  80286e:	e8 87 e4 ff ff       	call   800cfa <vprintfmt>
	if (b.idx > 0)
  802873:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80287a:	7e 0b                	jle    802887 <vfprintf+0x68>
		writebuf(&b);
  80287c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802882:	e8 1d ff ff ff       	call   8027a4 <writebuf>

	return (b.result ? b.result : b.error);
  802887:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802896:	c9                   	leave  
  802897:	c3                   	ret    

00802898 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802898:	55                   	push   %ebp
  802899:	89 e5                	mov    %esp,%ebp
  80289b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80289e:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8028a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	89 04 24             	mov    %eax,(%esp)
  8028b2:	e8 68 ff ff ff       	call   80281f <vfprintf>
	va_end(ap);

	return cnt;
}
  8028b7:	c9                   	leave  
  8028b8:	c3                   	ret    

008028b9 <printf>:

int
printf(const char *fmt, ...)
{
  8028b9:	55                   	push   %ebp
  8028ba:	89 e5                	mov    %esp,%ebp
  8028bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8028bf:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8028c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8028d4:	e8 46 ff ff ff       	call   80281f <vfprintf>
	va_end(ap);

	return cnt;
}
  8028d9:	c9                   	leave  
  8028da:	c3                   	ret    
	...

008028dc <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8028dc:	55                   	push   %ebp
  8028dd:	89 e5                	mov    %esp,%ebp
  8028df:	57                   	push   %edi
  8028e0:	56                   	push   %esi
  8028e1:	53                   	push   %ebx
  8028e2:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8028e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8028ef:	00 
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	89 04 24             	mov    %eax,(%esp)
  8028f6:	e8 21 fe ff ff       	call   80271c <open>
  8028fb:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  802901:	85 c0                	test   %eax,%eax
  802903:	0f 88 b2 05 00 00    	js     802ebb <spawn+0x5df>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802909:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802910:	00 
  802911:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802917:	89 44 24 04          	mov    %eax,0x4(%esp)
  80291b:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802921:	89 04 24             	mov    %eax,(%esp)
  802924:	e8 15 fa ff ff       	call   80233e <readn>
  802929:	3d 00 02 00 00       	cmp    $0x200,%eax
  80292e:	75 0c                	jne    80293c <spawn+0x60>
	    || elf->e_magic != ELF_MAGIC) {
  802930:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802937:	45 4c 46 
  80293a:	74 3b                	je     802977 <spawn+0x9b>
		close(fd);
  80293c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802942:	89 04 24             	mov    %eax,(%esp)
  802945:	e8 f3 f7 ff ff       	call   80213d <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80294a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802951:	46 
  802952:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80295c:	c7 04 24 46 40 80 00 	movl   $0x804046,(%esp)
  802963:	e8 0f e2 ff ff       	call   800b77 <cprintf>
		return -E_NOT_EXEC;
  802968:	c7 85 84 fd ff ff f2 	movl   $0xfffffff2,-0x27c(%ebp)
  80296f:	ff ff ff 
  802972:	e9 50 05 00 00       	jmp    802ec7 <spawn+0x5eb>
  802977:	ba 07 00 00 00       	mov    $0x7,%edx
  80297c:	89 d0                	mov    %edx,%eax
  80297e:	cd 30                	int    $0x30
  802980:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802986:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80298c:	85 c0                	test   %eax,%eax
  80298e:	0f 88 33 05 00 00    	js     802ec7 <spawn+0x5eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802994:	89 c6                	mov    %eax,%esi
  802996:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80299c:	6b f6 7c             	imul   $0x7c,%esi,%esi
  80299f:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8029a5:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8029ab:	b9 11 00 00 00       	mov    $0x11,%ecx
  8029b0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8029b2:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8029b8:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8029be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c1:	8b 02                	mov    (%edx),%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	74 5f                	je     802a26 <spawn+0x14a>
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8029c7:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  8029cc:	be 00 00 00 00       	mov    $0x0,%esi
  8029d1:	89 d7                	mov    %edx,%edi
		string_size += strlen(argv[argc]) + 1;
  8029d3:	89 04 24             	mov    %eax,(%esp)
  8029d6:	e8 65 e8 ff ff       	call   801240 <strlen>
  8029db:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8029df:	83 c6 01             	add    $0x1,%esi
  8029e2:	89 f2                	mov    %esi,%edx
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  8029e4:	8d 0c b5 00 00 00 00 	lea    0x0(,%esi,4),%ecx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8029eb:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	75 e1                	jne    8029d3 <spawn+0xf7>
  8029f2:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  8029f8:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8029fe:	bf 00 10 40 00       	mov    $0x401000,%edi
  802a03:	29 df                	sub    %ebx,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802a05:	89 f8                	mov    %edi,%eax
  802a07:	83 e0 fc             	and    $0xfffffffc,%eax
  802a0a:	f7 d2                	not    %edx
  802a0c:	8d 14 90             	lea    (%eax,%edx,4),%edx
  802a0f:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802a15:	89 d0                	mov    %edx,%eax
  802a17:	83 e8 08             	sub    $0x8,%eax
  802a1a:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802a1f:	77 2d                	ja     802a4e <spawn+0x172>
  802a21:	e9 b2 04 00 00       	jmp    802ed8 <spawn+0x5fc>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802a26:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802a2d:	00 00 00 
  802a30:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  802a37:	00 00 00 
  802a3a:	be 00 00 00 00       	mov    $0x0,%esi
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802a3f:	c7 85 94 fd ff ff fc 	movl   $0x400ffc,-0x26c(%ebp)
  802a46:	0f 40 00 
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802a49:	bf 00 10 40 00       	mov    $0x401000,%edi
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802a4e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802a55:	00 
  802a56:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802a5d:	00 
  802a5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a65:	e8 22 ed ff ff       	call   80178c <sys_page_alloc>
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	0f 88 6b 04 00 00    	js     802edd <spawn+0x601>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802a72:	85 f6                	test   %esi,%esi
  802a74:	7e 46                	jle    802abc <spawn+0x1e0>
  802a76:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a7b:	89 b5 90 fd ff ff    	mov    %esi,-0x270(%ebp)
  802a81:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  802a84:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802a8a:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802a90:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  802a93:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  802a96:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a9a:	89 3c 24             	mov    %edi,(%esp)
  802a9d:	e8 e9 e7 ff ff       	call   80128b <strcpy>
		string_store += strlen(argv[i]) + 1;
  802aa2:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  802aa5:	89 04 24             	mov    %eax,(%esp)
  802aa8:	e8 93 e7 ff ff       	call   801240 <strlen>
  802aad:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802ab1:	83 c3 01             	add    $0x1,%ebx
  802ab4:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  802aba:	75 c8                	jne    802a84 <spawn+0x1a8>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802abc:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802ac2:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802ac8:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802acf:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802ad5:	74 24                	je     802afb <spawn+0x21f>
  802ad7:	c7 44 24 0c bc 40 80 	movl   $0x8040bc,0xc(%esp)
  802ade:	00 
  802adf:	c7 44 24 08 c9 39 80 	movl   $0x8039c9,0x8(%esp)
  802ae6:	00 
  802ae7:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  802aee:	00 
  802aef:	c7 04 24 60 40 80 00 	movl   $0x804060,(%esp)
  802af6:	e8 81 df ff ff       	call   800a7c <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802afb:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802b01:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802b06:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802b0c:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802b0f:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802b15:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802b18:	89 d0                	mov    %edx,%eax
  802b1a:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802b1f:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802b25:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802b2c:	00 
  802b2d:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802b34:	ee 
  802b35:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802b3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b3f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802b46:	00 
  802b47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b4e:	e8 98 ec ff ff       	call   8017eb <sys_page_map>
  802b53:	89 c3                	mov    %eax,%ebx
  802b55:	85 c0                	test   %eax,%eax
  802b57:	78 1a                	js     802b73 <spawn+0x297>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802b59:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802b60:	00 
  802b61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b68:	e8 dc ec ff ff       	call   801849 <sys_page_unmap>
  802b6d:	89 c3                	mov    %eax,%ebx
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	79 1f                	jns    802b92 <spawn+0x2b6>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802b73:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802b7a:	00 
  802b7b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b82:	e8 c2 ec ff ff       	call   801849 <sys_page_unmap>
	return r;
  802b87:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802b8d:	e9 35 03 00 00       	jmp    802ec7 <spawn+0x5eb>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802b92:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802b98:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  802b9f:	00 
  802ba0:	0f 84 e2 01 00 00    	je     802d88 <spawn+0x4ac>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802ba6:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802bad:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802bb3:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802bba:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  802bbd:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802bc3:	83 3a 01             	cmpl   $0x1,(%edx)
  802bc6:	0f 85 9b 01 00 00    	jne    802d67 <spawn+0x48b>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802bcc:	8b 42 18             	mov    0x18(%edx),%eax
  802bcf:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802bd2:	83 f8 01             	cmp    $0x1,%eax
  802bd5:	19 c0                	sbb    %eax,%eax
  802bd7:	83 e0 fe             	and    $0xfffffffe,%eax
  802bda:	83 c0 07             	add    $0x7,%eax
  802bdd:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802be3:	8b 52 04             	mov    0x4(%edx),%edx
  802be6:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  802bec:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802bf2:	8b 70 10             	mov    0x10(%eax),%esi
  802bf5:	8b 50 14             	mov    0x14(%eax),%edx
  802bf8:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  802bfe:	8b 40 08             	mov    0x8(%eax),%eax
  802c01:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802c07:	25 ff 0f 00 00       	and    $0xfff,%eax
  802c0c:	74 16                	je     802c24 <spawn+0x348>
		va -= i;
  802c0e:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  802c14:	01 c2                	add    %eax,%edx
  802c16:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
		filesz += i;
  802c1c:	01 c6                	add    %eax,%esi
		fileoffset -= i;
  802c1e:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802c24:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  802c2b:	0f 84 36 01 00 00    	je     802d67 <spawn+0x48b>
  802c31:	bf 00 00 00 00       	mov    $0x0,%edi
  802c36:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i >= filesz) {
  802c3b:	39 f7                	cmp    %esi,%edi
  802c3d:	72 31                	jb     802c70 <spawn+0x394>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802c3f:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802c45:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c49:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802c4f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802c53:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802c59:	89 04 24             	mov    %eax,(%esp)
  802c5c:	e8 2b eb ff ff       	call   80178c <sys_page_alloc>
  802c61:	85 c0                	test   %eax,%eax
  802c63:	0f 89 ea 00 00 00    	jns    802d53 <spawn+0x477>
  802c69:	89 c6                	mov    %eax,%esi
  802c6b:	e9 27 02 00 00       	jmp    802e97 <spawn+0x5bb>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802c70:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802c77:	00 
  802c78:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c7f:	00 
  802c80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c87:	e8 00 eb ff ff       	call   80178c <sys_page_alloc>
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	0f 88 f9 01 00 00    	js     802e8d <spawn+0x5b1>
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
  802c94:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  802c9a:	01 d8                	add    %ebx,%eax
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ca0:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802ca6:	89 04 24             	mov    %eax,(%esp)
  802ca9:	e8 6b f7 ff ff       	call   802419 <seek>
  802cae:	85 c0                	test   %eax,%eax
  802cb0:	0f 88 db 01 00 00    	js     802e91 <spawn+0x5b5>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802cb6:	89 f0                	mov    %esi,%eax
  802cb8:	29 f8                	sub    %edi,%eax
  802cba:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802cbf:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cc4:	0f 47 c2             	cmova  %edx,%eax
  802cc7:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ccb:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802cd2:	00 
  802cd3:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802cd9:	89 04 24             	mov    %eax,(%esp)
  802cdc:	e8 5d f6 ff ff       	call   80233e <readn>
  802ce1:	85 c0                	test   %eax,%eax
  802ce3:	0f 88 ac 01 00 00    	js     802e95 <spawn+0x5b9>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802ce9:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802cef:	89 54 24 10          	mov    %edx,0x10(%esp)
  802cf3:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802cf9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cfd:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802d03:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d07:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802d0e:	00 
  802d0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d16:	e8 d0 ea ff ff       	call   8017eb <sys_page_map>
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	79 20                	jns    802d3f <spawn+0x463>
				panic("spawn: sys_page_map data: %e", r);
  802d1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d23:	c7 44 24 08 6c 40 80 	movl   $0x80406c,0x8(%esp)
  802d2a:	00 
  802d2b:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  802d32:	00 
  802d33:	c7 04 24 60 40 80 00 	movl   $0x804060,(%esp)
  802d3a:	e8 3d dd ff ff       	call   800a7c <_panic>
			sys_page_unmap(0, UTEMP);
  802d3f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802d46:	00 
  802d47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d4e:	e8 f6 ea ff ff       	call   801849 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802d53:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802d59:	89 df                	mov    %ebx,%edi
  802d5b:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  802d61:	0f 82 d4 fe ff ff    	jb     802c3b <spawn+0x35f>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d67:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802d6e:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  802d75:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802d7c:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  802d82:	0f 8f 35 fe ff ff    	jg     802bbd <spawn+0x2e1>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802d88:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802d8e:	89 04 24             	mov    %eax,(%esp)
  802d91:	e8 a7 f3 ff ff       	call   80213d <close>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  802d96:	be 00 00 00 00       	mov    $0x0,%esi
			if (((uvpd[PDX(PGADDR(0,pn,0))]&PTE_P) && (uvpd[PDX(PGADDR(0,pn,0))]&PTE_U)) 
  802d9b:	89 f2                	mov    %esi,%edx
  802d9d:	c1 e2 0c             	shl    $0xc,%edx
  802da0:	89 d0                	mov    %edx,%eax
  802da2:	c1 e8 16             	shr    $0x16,%eax
  802da5:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  802dac:	f6 c1 01             	test   $0x1,%cl
  802daf:	74 5b                	je     802e0c <spawn+0x530>
  802db1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802db8:	a8 04                	test   $0x4,%al
  802dba:	74 50                	je     802e0c <spawn+0x530>
				&& ((uvpt[pn]&PTE_P) && (uvpt[pn]&PTE_U) && (uvpt[pn]&PTE_SHARE))) {
  802dbc:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  802dc3:	a8 01                	test   $0x1,%al
  802dc5:	74 45                	je     802e0c <spawn+0x530>
  802dc7:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  802dce:	a8 04                	test   $0x4,%al
  802dd0:	74 3a                	je     802e0c <spawn+0x530>
  802dd2:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  802dd9:	f6 c4 04             	test   $0x4,%ah
  802ddc:	74 2e                	je     802e0c <spawn+0x530>
			sys_page_map(0, (void *)PGADDR(0,pn,0), child, (void *)PGADDR(0,pn,0), uvpt[pn]&PTE_SYSCALL);
  802dde:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  802de5:	25 07 0e 00 00       	and    $0xe07,%eax
  802dea:	89 44 24 10          	mov    %eax,0x10(%esp)
  802dee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802df2:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802df8:	89 44 24 08          	mov    %eax,0x8(%esp)
  802dfc:	89 54 24 04          	mov    %edx,0x4(%esp)
  802e00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e07:	e8 df e9 ff ff       	call   8017eb <sys_page_map>
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int pn ;
	for (pn = 0; pn < PGNUM(USTACKTOP); pn++){
  802e0c:	83 c6 01             	add    $0x1,%esi
  802e0f:	81 fe fe eb 0e 00    	cmp    $0xeebfe,%esi
  802e15:	75 84                	jne    802d9b <spawn+0x4bf>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802e17:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e21:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802e27:	89 04 24             	mov    %eax,(%esp)
  802e2a:	e8 d6 ea ff ff       	call   801905 <sys_env_set_trapframe>
  802e2f:	85 c0                	test   %eax,%eax
  802e31:	79 20                	jns    802e53 <spawn+0x577>
		panic("sys_env_set_trapframe: %e", r);
  802e33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e37:	c7 44 24 08 89 40 80 	movl   $0x804089,0x8(%esp)
  802e3e:	00 
  802e3f:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  802e46:	00 
  802e47:	c7 04 24 60 40 80 00 	movl   $0x804060,(%esp)
  802e4e:	e8 29 dc ff ff       	call   800a7c <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802e53:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802e5a:	00 
  802e5b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802e61:	89 04 24             	mov    %eax,(%esp)
  802e64:	e8 3e ea ff ff       	call   8018a7 <sys_env_set_status>
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	79 5a                	jns    802ec7 <spawn+0x5eb>
		panic("sys_env_set_status: %e", r);
  802e6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e71:	c7 44 24 08 a3 40 80 	movl   $0x8040a3,0x8(%esp)
  802e78:	00 
  802e79:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  802e80:	00 
  802e81:	c7 04 24 60 40 80 00 	movl   $0x804060,(%esp)
  802e88:	e8 ef db ff ff       	call   800a7c <_panic>
  802e8d:	89 c6                	mov    %eax,%esi
  802e8f:	eb 06                	jmp    802e97 <spawn+0x5bb>
  802e91:	89 c6                	mov    %eax,%esi
  802e93:	eb 02                	jmp    802e97 <spawn+0x5bb>
  802e95:	89 c6                	mov    %eax,%esi

	return child;

error:
	sys_env_destroy(child);
  802e97:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802e9d:	89 04 24             	mov    %eax,(%esp)
  802ea0:	e8 2a e8 ff ff       	call   8016cf <sys_env_destroy>
	close(fd);
  802ea5:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802eab:	89 04 24             	mov    %eax,(%esp)
  802eae:	e8 8a f2 ff ff       	call   80213d <close>
	return r;
  802eb3:	89 b5 84 fd ff ff    	mov    %esi,-0x27c(%ebp)
  802eb9:	eb 0c                	jmp    802ec7 <spawn+0x5eb>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  802ebb:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802ec1:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802ec7:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802ecd:	81 c4 ac 02 00 00    	add    $0x2ac,%esp
  802ed3:	5b                   	pop    %ebx
  802ed4:	5e                   	pop    %esi
  802ed5:	5f                   	pop    %edi
  802ed6:	5d                   	pop    %ebp
  802ed7:	c3                   	ret    
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802ed8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  802edd:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  802ee3:	eb e2                	jmp    802ec7 <spawn+0x5eb>

00802ee5 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802ee5:	55                   	push   %ebp
  802ee6:	89 e5                	mov    %esp,%ebp
  802ee8:	56                   	push   %esi
  802ee9:	53                   	push   %ebx
  802eea:	83 ec 10             	sub    $0x10,%esp
  802eed:	8b 75 0c             	mov    0xc(%ebp),%esi
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802ef0:	8d 45 14             	lea    0x14(%ebp),%eax
  802ef3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802ef7:	74 66                	je     802f5f <spawnl+0x7a>
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802ef9:	b9 00 00 00 00       	mov    $0x0,%ecx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  802efe:	83 c1 01             	add    $0x1,%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802f01:	89 c2                	mov    %eax,%edx
  802f03:	83 c0 04             	add    $0x4,%eax
  802f06:	83 3a 00             	cmpl   $0x0,(%edx)
  802f09:	75 f3                	jne    802efe <spawnl+0x19>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802f0b:	8d 04 8d 26 00 00 00 	lea    0x26(,%ecx,4),%eax
  802f12:	83 e0 f0             	and    $0xfffffff0,%eax
  802f15:	29 c4                	sub    %eax,%esp
  802f17:	8d 44 24 17          	lea    0x17(%esp),%eax
  802f1b:	83 e0 f0             	and    $0xfffffff0,%eax
  802f1e:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802f20:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  802f22:	c7 44 88 04 00 00 00 	movl   $0x0,0x4(%eax,%ecx,4)
  802f29:	00 

	va_start(vl, arg0);
  802f2a:	8d 55 10             	lea    0x10(%ebp),%edx
	unsigned i;
	for(i=0;i<argc;i++)
  802f2d:	89 ce                	mov    %ecx,%esi
  802f2f:	85 c9                	test   %ecx,%ecx
  802f31:	74 16                	je     802f49 <spawnl+0x64>
  802f33:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  802f38:	83 c0 01             	add    $0x1,%eax
  802f3b:	89 d1                	mov    %edx,%ecx
  802f3d:	83 c2 04             	add    $0x4,%edx
  802f40:	8b 09                	mov    (%ecx),%ecx
  802f42:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802f45:	39 f0                	cmp    %esi,%eax
  802f47:	75 ef                	jne    802f38 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802f49:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	89 04 24             	mov    %eax,(%esp)
  802f53:	e8 84 f9 ff ff       	call   8028dc <spawn>
}
  802f58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f5b:	5b                   	pop    %ebx
  802f5c:	5e                   	pop    %esi
  802f5d:	5d                   	pop    %ebp
  802f5e:	c3                   	ret    
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802f5f:	83 ec 20             	sub    $0x20,%esp
  802f62:	8d 44 24 17          	lea    0x17(%esp),%eax
  802f66:	83 e0 f0             	and    $0xfffffff0,%eax
  802f69:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802f6b:	89 30                	mov    %esi,(%eax)
	argv[argc+1] = NULL;
  802f6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f74:	eb d3                	jmp    802f49 <spawnl+0x64>
	...

00802f80 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f80:	55                   	push   %ebp
  802f81:	89 e5                	mov    %esp,%ebp
  802f83:	83 ec 18             	sub    $0x18,%esp
  802f86:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802f89:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	89 04 24             	mov    %eax,(%esp)
  802f95:	e8 c6 ef ff ff       	call   801f60 <fd2data>
  802f9a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802f9c:	c7 44 24 04 e4 40 80 	movl   $0x8040e4,0x4(%esp)
  802fa3:	00 
  802fa4:	89 34 24             	mov    %esi,(%esp)
  802fa7:	e8 df e2 ff ff       	call   80128b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802fac:	8b 43 04             	mov    0x4(%ebx),%eax
  802faf:	2b 03                	sub    (%ebx),%eax
  802fb1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802fb7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  802fbe:	00 00 00 
	stat->st_dev = &devpipe;
  802fc1:	c7 86 88 00 00 00 3c 	movl   $0x80503c,0x88(%esi)
  802fc8:	50 80 00 
	return 0;
}
  802fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802fd3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802fd6:	89 ec                	mov    %ebp,%esp
  802fd8:	5d                   	pop    %ebp
  802fd9:	c3                   	ret    

00802fda <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802fda:	55                   	push   %ebp
  802fdb:	89 e5                	mov    %esp,%ebp
  802fdd:	53                   	push   %ebx
  802fde:	83 ec 14             	sub    $0x14,%esp
  802fe1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802fe4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802fe8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fef:	e8 55 e8 ff ff       	call   801849 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802ff4:	89 1c 24             	mov    %ebx,(%esp)
  802ff7:	e8 64 ef ff ff       	call   801f60 <fd2data>
  802ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803000:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803007:	e8 3d e8 ff ff       	call   801849 <sys_page_unmap>
}
  80300c:	83 c4 14             	add    $0x14,%esp
  80300f:	5b                   	pop    %ebx
  803010:	5d                   	pop    %ebp
  803011:	c3                   	ret    

00803012 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803012:	55                   	push   %ebp
  803013:	89 e5                	mov    %esp,%ebp
  803015:	57                   	push   %edi
  803016:	56                   	push   %esi
  803017:	53                   	push   %ebx
  803018:	83 ec 2c             	sub    $0x2c,%esp
  80301b:	89 c7                	mov    %eax,%edi
  80301d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803020:	a1 24 64 80 00       	mov    0x806424,%eax
  803025:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803028:	89 3c 24             	mov    %edi,(%esp)
  80302b:	e8 50 05 00 00       	call   803580 <pageref>
  803030:	89 c6                	mov    %eax,%esi
  803032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803035:	89 04 24             	mov    %eax,(%esp)
  803038:	e8 43 05 00 00       	call   803580 <pageref>
  80303d:	39 c6                	cmp    %eax,%esi
  80303f:	0f 94 c0             	sete   %al
  803042:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  803045:	8b 15 24 64 80 00    	mov    0x806424,%edx
  80304b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80304e:	39 cb                	cmp    %ecx,%ebx
  803050:	75 08                	jne    80305a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803052:	83 c4 2c             	add    $0x2c,%esp
  803055:	5b                   	pop    %ebx
  803056:	5e                   	pop    %esi
  803057:	5f                   	pop    %edi
  803058:	5d                   	pop    %ebp
  803059:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80305a:	83 f8 01             	cmp    $0x1,%eax
  80305d:	75 c1                	jne    803020 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80305f:	8b 52 58             	mov    0x58(%edx),%edx
  803062:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803066:	89 54 24 08          	mov    %edx,0x8(%esp)
  80306a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80306e:	c7 04 24 eb 40 80 00 	movl   $0x8040eb,(%esp)
  803075:	e8 fd da ff ff       	call   800b77 <cprintf>
  80307a:	eb a4                	jmp    803020 <_pipeisclosed+0xe>

0080307c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80307c:	55                   	push   %ebp
  80307d:	89 e5                	mov    %esp,%ebp
  80307f:	57                   	push   %edi
  803080:	56                   	push   %esi
  803081:	53                   	push   %ebx
  803082:	83 ec 2c             	sub    $0x2c,%esp
  803085:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803088:	89 34 24             	mov    %esi,(%esp)
  80308b:	e8 d0 ee ff ff       	call   801f60 <fd2data>
  803090:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803092:	bf 00 00 00 00       	mov    $0x0,%edi
  803097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80309b:	75 50                	jne    8030ed <devpipe_write+0x71>
  80309d:	eb 5c                	jmp    8030fb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80309f:	89 da                	mov    %ebx,%edx
  8030a1:	89 f0                	mov    %esi,%eax
  8030a3:	e8 6a ff ff ff       	call   803012 <_pipeisclosed>
  8030a8:	85 c0                	test   %eax,%eax
  8030aa:	75 53                	jne    8030ff <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8030ac:	e8 ab e6 ff ff       	call   80175c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8030b1:	8b 43 04             	mov    0x4(%ebx),%eax
  8030b4:	8b 13                	mov    (%ebx),%edx
  8030b6:	83 c2 20             	add    $0x20,%edx
  8030b9:	39 d0                	cmp    %edx,%eax
  8030bb:	73 e2                	jae    80309f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8030bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  8030c4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  8030c7:	89 c2                	mov    %eax,%edx
  8030c9:	c1 fa 1f             	sar    $0x1f,%edx
  8030cc:	c1 ea 1b             	shr    $0x1b,%edx
  8030cf:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8030d2:	83 e1 1f             	and    $0x1f,%ecx
  8030d5:	29 d1                	sub    %edx,%ecx
  8030d7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8030db:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8030df:	83 c0 01             	add    $0x1,%eax
  8030e2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8030e5:	83 c7 01             	add    $0x1,%edi
  8030e8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8030eb:	74 0e                	je     8030fb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8030ed:	8b 43 04             	mov    0x4(%ebx),%eax
  8030f0:	8b 13                	mov    (%ebx),%edx
  8030f2:	83 c2 20             	add    $0x20,%edx
  8030f5:	39 d0                	cmp    %edx,%eax
  8030f7:	73 a6                	jae    80309f <devpipe_write+0x23>
  8030f9:	eb c2                	jmp    8030bd <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8030fb:	89 f8                	mov    %edi,%eax
  8030fd:	eb 05                	jmp    803104 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8030ff:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  803104:	83 c4 2c             	add    $0x2c,%esp
  803107:	5b                   	pop    %ebx
  803108:	5e                   	pop    %esi
  803109:	5f                   	pop    %edi
  80310a:	5d                   	pop    %ebp
  80310b:	c3                   	ret    

0080310c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80310c:	55                   	push   %ebp
  80310d:	89 e5                	mov    %esp,%ebp
  80310f:	83 ec 28             	sub    $0x28,%esp
  803112:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803115:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803118:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80311b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80311e:	89 3c 24             	mov    %edi,(%esp)
  803121:	e8 3a ee ff ff       	call   801f60 <fd2data>
  803126:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803128:	be 00 00 00 00       	mov    $0x0,%esi
  80312d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803131:	75 47                	jne    80317a <devpipe_read+0x6e>
  803133:	eb 52                	jmp    803187 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  803135:	89 f0                	mov    %esi,%eax
  803137:	eb 5e                	jmp    803197 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803139:	89 da                	mov    %ebx,%edx
  80313b:	89 f8                	mov    %edi,%eax
  80313d:	8d 76 00             	lea    0x0(%esi),%esi
  803140:	e8 cd fe ff ff       	call   803012 <_pipeisclosed>
  803145:	85 c0                	test   %eax,%eax
  803147:	75 49                	jne    803192 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803149:	e8 0e e6 ff ff       	call   80175c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80314e:	8b 03                	mov    (%ebx),%eax
  803150:	3b 43 04             	cmp    0x4(%ebx),%eax
  803153:	74 e4                	je     803139 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803155:	89 c2                	mov    %eax,%edx
  803157:	c1 fa 1f             	sar    $0x1f,%edx
  80315a:	c1 ea 1b             	shr    $0x1b,%edx
  80315d:	01 d0                	add    %edx,%eax
  80315f:	83 e0 1f             	and    $0x1f,%eax
  803162:	29 d0                	sub    %edx,%eax
  803164:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803169:	8b 55 0c             	mov    0xc(%ebp),%edx
  80316c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80316f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803172:	83 c6 01             	add    $0x1,%esi
  803175:	3b 75 10             	cmp    0x10(%ebp),%esi
  803178:	74 0d                	je     803187 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80317a:	8b 03                	mov    (%ebx),%eax
  80317c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80317f:	75 d4                	jne    803155 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803181:	85 f6                	test   %esi,%esi
  803183:	75 b0                	jne    803135 <devpipe_read+0x29>
  803185:	eb b2                	jmp    803139 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803187:	89 f0                	mov    %esi,%eax
  803189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803190:	eb 05                	jmp    803197 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803192:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  803197:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80319a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80319d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8031a0:	89 ec                	mov    %ebp,%esp
  8031a2:	5d                   	pop    %ebp
  8031a3:	c3                   	ret    

008031a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8031a4:	55                   	push   %ebp
  8031a5:	89 e5                	mov    %esp,%ebp
  8031a7:	83 ec 48             	sub    $0x48,%esp
  8031aa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8031ad:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8031b0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8031b3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8031b9:	89 04 24             	mov    %eax,(%esp)
  8031bc:	e8 ba ed ff ff       	call   801f7b <fd_alloc>
  8031c1:	89 c3                	mov    %eax,%ebx
  8031c3:	85 c0                	test   %eax,%eax
  8031c5:	0f 88 45 01 00 00    	js     803310 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031cb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8031d2:	00 
  8031d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031e1:	e8 a6 e5 ff ff       	call   80178c <sys_page_alloc>
  8031e6:	89 c3                	mov    %eax,%ebx
  8031e8:	85 c0                	test   %eax,%eax
  8031ea:	0f 88 20 01 00 00    	js     803310 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8031f0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8031f3:	89 04 24             	mov    %eax,(%esp)
  8031f6:	e8 80 ed ff ff       	call   801f7b <fd_alloc>
  8031fb:	89 c3                	mov    %eax,%ebx
  8031fd:	85 c0                	test   %eax,%eax
  8031ff:	0f 88 f8 00 00 00    	js     8032fd <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803205:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80320c:	00 
  80320d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803210:	89 44 24 04          	mov    %eax,0x4(%esp)
  803214:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80321b:	e8 6c e5 ff ff       	call   80178c <sys_page_alloc>
  803220:	89 c3                	mov    %eax,%ebx
  803222:	85 c0                	test   %eax,%eax
  803224:	0f 88 d3 00 00 00    	js     8032fd <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80322a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322d:	89 04 24             	mov    %eax,(%esp)
  803230:	e8 2b ed ff ff       	call   801f60 <fd2data>
  803235:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803237:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80323e:	00 
  80323f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803243:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80324a:	e8 3d e5 ff ff       	call   80178c <sys_page_alloc>
  80324f:	89 c3                	mov    %eax,%ebx
  803251:	85 c0                	test   %eax,%eax
  803253:	0f 88 91 00 00 00    	js     8032ea <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803259:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80325c:	89 04 24             	mov    %eax,(%esp)
  80325f:	e8 fc ec ff ff       	call   801f60 <fd2data>
  803264:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80326b:	00 
  80326c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803270:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803277:	00 
  803278:	89 74 24 04          	mov    %esi,0x4(%esp)
  80327c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803283:	e8 63 e5 ff ff       	call   8017eb <sys_page_map>
  803288:	89 c3                	mov    %eax,%ebx
  80328a:	85 c0                	test   %eax,%eax
  80328c:	78 4c                	js     8032da <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80328e:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803294:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803297:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8032a3:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  8032a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ac:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8032ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032b1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8032b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bb:	89 04 24             	mov    %eax,(%esp)
  8032be:	e8 8d ec ff ff       	call   801f50 <fd2num>
  8032c3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8032c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c8:	89 04 24             	mov    %eax,(%esp)
  8032cb:	e8 80 ec ff ff       	call   801f50 <fd2num>
  8032d0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8032d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8032d8:	eb 36                	jmp    803310 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  8032da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8032de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032e5:	e8 5f e5 ff ff       	call   801849 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8032ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032f8:	e8 4c e5 ff ff       	call   801849 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8032fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803300:	89 44 24 04          	mov    %eax,0x4(%esp)
  803304:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80330b:	e8 39 e5 ff ff       	call   801849 <sys_page_unmap>
    err:
	return r;
}
  803310:	89 d8                	mov    %ebx,%eax
  803312:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803315:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803318:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80331b:	89 ec                	mov    %ebp,%esp
  80331d:	5d                   	pop    %ebp
  80331e:	c3                   	ret    

0080331f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80331f:	55                   	push   %ebp
  803320:	89 e5                	mov    %esp,%ebp
  803322:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803325:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803328:	89 44 24 04          	mov    %eax,0x4(%esp)
  80332c:	8b 45 08             	mov    0x8(%ebp),%eax
  80332f:	89 04 24             	mov    %eax,(%esp)
  803332:	e8 b7 ec ff ff       	call   801fee <fd_lookup>
  803337:	85 c0                	test   %eax,%eax
  803339:	78 15                	js     803350 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80333b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333e:	89 04 24             	mov    %eax,(%esp)
  803341:	e8 1a ec ff ff       	call   801f60 <fd2data>
	return _pipeisclosed(fd, p);
  803346:	89 c2                	mov    %eax,%edx
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	e8 c2 fc ff ff       	call   803012 <_pipeisclosed>
}
  803350:	c9                   	leave  
  803351:	c3                   	ret    
	...

00803354 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803354:	55                   	push   %ebp
  803355:	89 e5                	mov    %esp,%ebp
  803357:	56                   	push   %esi
  803358:	53                   	push   %ebx
  803359:	83 ec 10             	sub    $0x10,%esp
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  80335f:	85 c0                	test   %eax,%eax
  803361:	75 24                	jne    803387 <wait+0x33>
  803363:	c7 44 24 0c 03 41 80 	movl   $0x804103,0xc(%esp)
  80336a:	00 
  80336b:	c7 44 24 08 c9 39 80 	movl   $0x8039c9,0x8(%esp)
  803372:	00 
  803373:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  80337a:	00 
  80337b:	c7 04 24 0e 41 80 00 	movl   $0x80410e,(%esp)
  803382:	e8 f5 d6 ff ff       	call   800a7c <_panic>
	e = &envs[ENVX(envid)];
  803387:	89 c3                	mov    %eax,%ebx
  803389:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80338f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803392:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803398:	8b 73 48             	mov    0x48(%ebx),%esi
  80339b:	39 c6                	cmp    %eax,%esi
  80339d:	75 1a                	jne    8033b9 <wait+0x65>
  80339f:	8b 43 54             	mov    0x54(%ebx),%eax
  8033a2:	85 c0                	test   %eax,%eax
  8033a4:	74 13                	je     8033b9 <wait+0x65>
		sys_yield();
  8033a6:	e8 b1 e3 ff ff       	call   80175c <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8033ab:	8b 43 48             	mov    0x48(%ebx),%eax
  8033ae:	39 f0                	cmp    %esi,%eax
  8033b0:	75 07                	jne    8033b9 <wait+0x65>
  8033b2:	8b 43 54             	mov    0x54(%ebx),%eax
  8033b5:	85 c0                	test   %eax,%eax
  8033b7:	75 ed                	jne    8033a6 <wait+0x52>
		sys_yield();
}
  8033b9:	83 c4 10             	add    $0x10,%esp
  8033bc:	5b                   	pop    %ebx
  8033bd:	5e                   	pop    %esi
  8033be:	5d                   	pop    %ebp
  8033bf:	c3                   	ret    

008033c0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8033c0:	55                   	push   %ebp
  8033c1:	89 e5                	mov    %esp,%ebp
  8033c3:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8033c6:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8033cd:	75 54                	jne    803423 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  8033cf:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8033d6:	00 
  8033d7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8033de:	ee 
  8033df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8033e6:	e8 a1 e3 ff ff       	call   80178c <sys_page_alloc>
  8033eb:	85 c0                	test   %eax,%eax
  8033ed:	79 20                	jns    80340f <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  8033ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033f3:	c7 44 24 08 19 41 80 	movl   $0x804119,0x8(%esp)
  8033fa:	00 
  8033fb:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  803402:	00 
  803403:	c7 04 24 31 41 80 00 	movl   $0x804131,(%esp)
  80340a:	e8 6d d6 ff ff       	call   800a7c <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  80340f:	c7 44 24 04 30 34 80 	movl   $0x803430,0x4(%esp)
  803416:	00 
  803417:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80341e:	e8 40 e5 ff ff       	call   801963 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80342b:	c9                   	leave  
  80342c:	c3                   	ret    
  80342d:	00 00                	add    %al,(%eax)
	...

00803430 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803430:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803431:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  803436:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803438:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  80343b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  80343f:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  803442:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  803446:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  80344a:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  80344c:	83 c4 08             	add    $0x8,%esp
	popal
  80344f:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803450:	83 c4 04             	add    $0x4,%esp
	popfl
  803453:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  803454:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803455:	c3                   	ret    
	...

00803460 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803460:	55                   	push   %ebp
  803461:	89 e5                	mov    %esp,%ebp
  803463:	56                   	push   %esi
  803464:	53                   	push   %ebx
  803465:	83 ec 10             	sub    $0x10,%esp
  803468:	8b 75 08             	mov    0x8(%ebp),%esi
  80346b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  803471:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  803473:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803478:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80347b:	89 04 24             	mov    %eax,(%esp)
  80347e:	e8 72 e5 ff ff       	call   8019f5 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  803483:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  803488:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80348d:	85 c0                	test   %eax,%eax
  80348f:	78 0e                	js     80349f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  803491:	a1 24 64 80 00       	mov    0x806424,%eax
  803496:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  803499:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80349c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80349f:	85 f6                	test   %esi,%esi
  8034a1:	74 02                	je     8034a5 <ipc_recv+0x45>
		*from_env_store = sender;
  8034a3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  8034a5:	85 db                	test   %ebx,%ebx
  8034a7:	74 02                	je     8034ab <ipc_recv+0x4b>
		*perm_store = perm;
  8034a9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  8034ab:	83 c4 10             	add    $0x10,%esp
  8034ae:	5b                   	pop    %ebx
  8034af:	5e                   	pop    %esi
  8034b0:	5d                   	pop    %ebp
  8034b1:	c3                   	ret    

008034b2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8034b2:	55                   	push   %ebp
  8034b3:	89 e5                	mov    %esp,%ebp
  8034b5:	57                   	push   %edi
  8034b6:	56                   	push   %esi
  8034b7:	53                   	push   %ebx
  8034b8:	83 ec 1c             	sub    $0x1c,%esp
  8034bb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8034be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8034c1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  8034c4:	85 db                	test   %ebx,%ebx
  8034c6:	75 04                	jne    8034cc <ipc_send+0x1a>
  8034c8:	85 f6                	test   %esi,%esi
  8034ca:	75 15                	jne    8034e1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  8034cc:	85 db                	test   %ebx,%ebx
  8034ce:	74 16                	je     8034e6 <ipc_send+0x34>
  8034d0:	85 f6                	test   %esi,%esi
  8034d2:	0f 94 c0             	sete   %al
      pg = 0;
  8034d5:	84 c0                	test   %al,%al
  8034d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034dc:	0f 45 d8             	cmovne %eax,%ebx
  8034df:	eb 05                	jmp    8034e6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  8034e1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  8034e6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8034ea:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8034f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f5:	89 04 24             	mov    %eax,(%esp)
  8034f8:	e8 c4 e4 ff ff       	call   8019c1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  8034fd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803500:	75 07                	jne    803509 <ipc_send+0x57>
           sys_yield();
  803502:	e8 55 e2 ff ff       	call   80175c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  803507:	eb dd                	jmp    8034e6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  803509:	85 c0                	test   %eax,%eax
  80350b:	90                   	nop
  80350c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803510:	74 1c                	je     80352e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  803512:	c7 44 24 08 3f 41 80 	movl   $0x80413f,0x8(%esp)
  803519:	00 
  80351a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  803521:	00 
  803522:	c7 04 24 49 41 80 00 	movl   $0x804149,(%esp)
  803529:	e8 4e d5 ff ff       	call   800a7c <_panic>
		}
    }
}
  80352e:	83 c4 1c             	add    $0x1c,%esp
  803531:	5b                   	pop    %ebx
  803532:	5e                   	pop    %esi
  803533:	5f                   	pop    %edi
  803534:	5d                   	pop    %ebp
  803535:	c3                   	ret    

00803536 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803536:	55                   	push   %ebp
  803537:	89 e5                	mov    %esp,%ebp
  803539:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80353c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  803541:	39 c8                	cmp    %ecx,%eax
  803543:	74 17                	je     80355c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803545:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80354a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80354d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803553:	8b 52 50             	mov    0x50(%edx),%edx
  803556:	39 ca                	cmp    %ecx,%edx
  803558:	75 14                	jne    80356e <ipc_find_env+0x38>
  80355a:	eb 05                	jmp    803561 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80355c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  803561:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803564:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  803569:	8b 40 40             	mov    0x40(%eax),%eax
  80356c:	eb 0e                	jmp    80357c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80356e:	83 c0 01             	add    $0x1,%eax
  803571:	3d 00 04 00 00       	cmp    $0x400,%eax
  803576:	75 d2                	jne    80354a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803578:	66 b8 00 00          	mov    $0x0,%ax
}
  80357c:	5d                   	pop    %ebp
  80357d:	c3                   	ret    
	...

00803580 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803580:	55                   	push   %ebp
  803581:	89 e5                	mov    %esp,%ebp
  803583:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803586:	89 d0                	mov    %edx,%eax
  803588:	c1 e8 16             	shr    $0x16,%eax
  80358b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803592:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803597:	f6 c1 01             	test   $0x1,%cl
  80359a:	74 1d                	je     8035b9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80359c:	c1 ea 0c             	shr    $0xc,%edx
  80359f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8035a6:	f6 c2 01             	test   $0x1,%dl
  8035a9:	74 0e                	je     8035b9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8035ab:	c1 ea 0c             	shr    $0xc,%edx
  8035ae:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8035b5:	ef 
  8035b6:	0f b7 c0             	movzwl %ax,%eax
}
  8035b9:	5d                   	pop    %ebp
  8035ba:	c3                   	ret    
  8035bb:	00 00                	add    %al,(%eax)
  8035bd:	00 00                	add    %al,(%eax)
	...

008035c0 <__udivdi3>:
  8035c0:	83 ec 1c             	sub    $0x1c,%esp
  8035c3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8035c7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8035cb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8035cf:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8035d3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8035d7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8035db:	85 ff                	test   %edi,%edi
  8035dd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8035e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8035e5:	89 cd                	mov    %ecx,%ebp
  8035e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035eb:	75 33                	jne    803620 <__udivdi3+0x60>
  8035ed:	39 f1                	cmp    %esi,%ecx
  8035ef:	77 57                	ja     803648 <__udivdi3+0x88>
  8035f1:	85 c9                	test   %ecx,%ecx
  8035f3:	75 0b                	jne    803600 <__udivdi3+0x40>
  8035f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8035fa:	31 d2                	xor    %edx,%edx
  8035fc:	f7 f1                	div    %ecx
  8035fe:	89 c1                	mov    %eax,%ecx
  803600:	89 f0                	mov    %esi,%eax
  803602:	31 d2                	xor    %edx,%edx
  803604:	f7 f1                	div    %ecx
  803606:	89 c6                	mov    %eax,%esi
  803608:	8b 44 24 04          	mov    0x4(%esp),%eax
  80360c:	f7 f1                	div    %ecx
  80360e:	89 f2                	mov    %esi,%edx
  803610:	8b 74 24 10          	mov    0x10(%esp),%esi
  803614:	8b 7c 24 14          	mov    0x14(%esp),%edi
  803618:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80361c:	83 c4 1c             	add    $0x1c,%esp
  80361f:	c3                   	ret    
  803620:	31 d2                	xor    %edx,%edx
  803622:	31 c0                	xor    %eax,%eax
  803624:	39 f7                	cmp    %esi,%edi
  803626:	77 e8                	ja     803610 <__udivdi3+0x50>
  803628:	0f bd cf             	bsr    %edi,%ecx
  80362b:	83 f1 1f             	xor    $0x1f,%ecx
  80362e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803632:	75 2c                	jne    803660 <__udivdi3+0xa0>
  803634:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  803638:	76 04                	jbe    80363e <__udivdi3+0x7e>
  80363a:	39 f7                	cmp    %esi,%edi
  80363c:	73 d2                	jae    803610 <__udivdi3+0x50>
  80363e:	31 d2                	xor    %edx,%edx
  803640:	b8 01 00 00 00       	mov    $0x1,%eax
  803645:	eb c9                	jmp    803610 <__udivdi3+0x50>
  803647:	90                   	nop
  803648:	89 f2                	mov    %esi,%edx
  80364a:	f7 f1                	div    %ecx
  80364c:	31 d2                	xor    %edx,%edx
  80364e:	8b 74 24 10          	mov    0x10(%esp),%esi
  803652:	8b 7c 24 14          	mov    0x14(%esp),%edi
  803656:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80365a:	83 c4 1c             	add    $0x1c,%esp
  80365d:	c3                   	ret    
  80365e:	66 90                	xchg   %ax,%ax
  803660:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803665:	b8 20 00 00 00       	mov    $0x20,%eax
  80366a:	89 ea                	mov    %ebp,%edx
  80366c:	2b 44 24 04          	sub    0x4(%esp),%eax
  803670:	d3 e7                	shl    %cl,%edi
  803672:	89 c1                	mov    %eax,%ecx
  803674:	d3 ea                	shr    %cl,%edx
  803676:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80367b:	09 fa                	or     %edi,%edx
  80367d:	89 f7                	mov    %esi,%edi
  80367f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803683:	89 f2                	mov    %esi,%edx
  803685:	8b 74 24 08          	mov    0x8(%esp),%esi
  803689:	d3 e5                	shl    %cl,%ebp
  80368b:	89 c1                	mov    %eax,%ecx
  80368d:	d3 ef                	shr    %cl,%edi
  80368f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803694:	d3 e2                	shl    %cl,%edx
  803696:	89 c1                	mov    %eax,%ecx
  803698:	d3 ee                	shr    %cl,%esi
  80369a:	09 d6                	or     %edx,%esi
  80369c:	89 fa                	mov    %edi,%edx
  80369e:	89 f0                	mov    %esi,%eax
  8036a0:	f7 74 24 0c          	divl   0xc(%esp)
  8036a4:	89 d7                	mov    %edx,%edi
  8036a6:	89 c6                	mov    %eax,%esi
  8036a8:	f7 e5                	mul    %ebp
  8036aa:	39 d7                	cmp    %edx,%edi
  8036ac:	72 22                	jb     8036d0 <__udivdi3+0x110>
  8036ae:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8036b2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8036b7:	d3 e5                	shl    %cl,%ebp
  8036b9:	39 c5                	cmp    %eax,%ebp
  8036bb:	73 04                	jae    8036c1 <__udivdi3+0x101>
  8036bd:	39 d7                	cmp    %edx,%edi
  8036bf:	74 0f                	je     8036d0 <__udivdi3+0x110>
  8036c1:	89 f0                	mov    %esi,%eax
  8036c3:	31 d2                	xor    %edx,%edx
  8036c5:	e9 46 ff ff ff       	jmp    803610 <__udivdi3+0x50>
  8036ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8036d0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8036d3:	31 d2                	xor    %edx,%edx
  8036d5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8036d9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8036dd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8036e1:	83 c4 1c             	add    $0x1c,%esp
  8036e4:	c3                   	ret    
	...

008036f0 <__umoddi3>:
  8036f0:	83 ec 1c             	sub    $0x1c,%esp
  8036f3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8036f7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8036fb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8036ff:	89 74 24 10          	mov    %esi,0x10(%esp)
  803703:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  803707:	8b 74 24 24          	mov    0x24(%esp),%esi
  80370b:	85 ed                	test   %ebp,%ebp
  80370d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  803711:	89 44 24 08          	mov    %eax,0x8(%esp)
  803715:	89 cf                	mov    %ecx,%edi
  803717:	89 04 24             	mov    %eax,(%esp)
  80371a:	89 f2                	mov    %esi,%edx
  80371c:	75 1a                	jne    803738 <__umoddi3+0x48>
  80371e:	39 f1                	cmp    %esi,%ecx
  803720:	76 4e                	jbe    803770 <__umoddi3+0x80>
  803722:	f7 f1                	div    %ecx
  803724:	89 d0                	mov    %edx,%eax
  803726:	31 d2                	xor    %edx,%edx
  803728:	8b 74 24 10          	mov    0x10(%esp),%esi
  80372c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  803730:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  803734:	83 c4 1c             	add    $0x1c,%esp
  803737:	c3                   	ret    
  803738:	39 f5                	cmp    %esi,%ebp
  80373a:	77 54                	ja     803790 <__umoddi3+0xa0>
  80373c:	0f bd c5             	bsr    %ebp,%eax
  80373f:	83 f0 1f             	xor    $0x1f,%eax
  803742:	89 44 24 04          	mov    %eax,0x4(%esp)
  803746:	75 60                	jne    8037a8 <__umoddi3+0xb8>
  803748:	3b 0c 24             	cmp    (%esp),%ecx
  80374b:	0f 87 07 01 00 00    	ja     803858 <__umoddi3+0x168>
  803751:	89 f2                	mov    %esi,%edx
  803753:	8b 34 24             	mov    (%esp),%esi
  803756:	29 ce                	sub    %ecx,%esi
  803758:	19 ea                	sbb    %ebp,%edx
  80375a:	89 34 24             	mov    %esi,(%esp)
  80375d:	8b 04 24             	mov    (%esp),%eax
  803760:	8b 74 24 10          	mov    0x10(%esp),%esi
  803764:	8b 7c 24 14          	mov    0x14(%esp),%edi
  803768:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80376c:	83 c4 1c             	add    $0x1c,%esp
  80376f:	c3                   	ret    
  803770:	85 c9                	test   %ecx,%ecx
  803772:	75 0b                	jne    80377f <__umoddi3+0x8f>
  803774:	b8 01 00 00 00       	mov    $0x1,%eax
  803779:	31 d2                	xor    %edx,%edx
  80377b:	f7 f1                	div    %ecx
  80377d:	89 c1                	mov    %eax,%ecx
  80377f:	89 f0                	mov    %esi,%eax
  803781:	31 d2                	xor    %edx,%edx
  803783:	f7 f1                	div    %ecx
  803785:	8b 04 24             	mov    (%esp),%eax
  803788:	f7 f1                	div    %ecx
  80378a:	eb 98                	jmp    803724 <__umoddi3+0x34>
  80378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803790:	89 f2                	mov    %esi,%edx
  803792:	8b 74 24 10          	mov    0x10(%esp),%esi
  803796:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80379a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80379e:	83 c4 1c             	add    $0x1c,%esp
  8037a1:	c3                   	ret    
  8037a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8037a8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8037ad:	89 e8                	mov    %ebp,%eax
  8037af:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037b4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8037b8:	89 fa                	mov    %edi,%edx
  8037ba:	d3 e0                	shl    %cl,%eax
  8037bc:	89 e9                	mov    %ebp,%ecx
  8037be:	d3 ea                	shr    %cl,%edx
  8037c0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8037c5:	09 c2                	or     %eax,%edx
  8037c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037cb:	89 14 24             	mov    %edx,(%esp)
  8037ce:	89 f2                	mov    %esi,%edx
  8037d0:	d3 e7                	shl    %cl,%edi
  8037d2:	89 e9                	mov    %ebp,%ecx
  8037d4:	d3 ea                	shr    %cl,%edx
  8037d6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8037db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037df:	d3 e6                	shl    %cl,%esi
  8037e1:	89 e9                	mov    %ebp,%ecx
  8037e3:	d3 e8                	shr    %cl,%eax
  8037e5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8037ea:	09 f0                	or     %esi,%eax
  8037ec:	8b 74 24 08          	mov    0x8(%esp),%esi
  8037f0:	f7 34 24             	divl   (%esp)
  8037f3:	d3 e6                	shl    %cl,%esi
  8037f5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8037f9:	89 d6                	mov    %edx,%esi
  8037fb:	f7 e7                	mul    %edi
  8037fd:	39 d6                	cmp    %edx,%esi
  8037ff:	89 c1                	mov    %eax,%ecx
  803801:	89 d7                	mov    %edx,%edi
  803803:	72 3f                	jb     803844 <__umoddi3+0x154>
  803805:	39 44 24 08          	cmp    %eax,0x8(%esp)
  803809:	72 35                	jb     803840 <__umoddi3+0x150>
  80380b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80380f:	29 c8                	sub    %ecx,%eax
  803811:	19 fe                	sbb    %edi,%esi
  803813:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803818:	89 f2                	mov    %esi,%edx
  80381a:	d3 e8                	shr    %cl,%eax
  80381c:	89 e9                	mov    %ebp,%ecx
  80381e:	d3 e2                	shl    %cl,%edx
  803820:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803825:	09 d0                	or     %edx,%eax
  803827:	89 f2                	mov    %esi,%edx
  803829:	d3 ea                	shr    %cl,%edx
  80382b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80382f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  803833:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  803837:	83 c4 1c             	add    $0x1c,%esp
  80383a:	c3                   	ret    
  80383b:	90                   	nop
  80383c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803840:	39 d6                	cmp    %edx,%esi
  803842:	75 c7                	jne    80380b <__umoddi3+0x11b>
  803844:	89 d7                	mov    %edx,%edi
  803846:	89 c1                	mov    %eax,%ecx
  803848:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80384c:	1b 3c 24             	sbb    (%esp),%edi
  80384f:	eb ba                	jmp    80380b <__umoddi3+0x11b>
  803851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803858:	39 f5                	cmp    %esi,%ebp
  80385a:	0f 82 f1 fe ff ff    	jb     803751 <__umoddi3+0x61>
  803860:	e9 f8 fe ff ff       	jmp    80375d <__umoddi3+0x6d>
