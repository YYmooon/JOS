
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 d3 00 00 00       	call   800104 <libmain>
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
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
  80003d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800040:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800043:	83 ff 01             	cmp    $0x1,%edi
  800046:	0f 8e 8a 00 00 00    	jle    8000d6 <umain+0xa2>
  80004c:	c7 44 24 04 60 22 80 	movl   $0x802260,0x4(%esp)
  800053:	00 
  800054:	8b 46 04             	mov    0x4(%esi),%eax
  800057:	89 04 24             	mov    %eax,(%esp)
  80005a:	e8 1c 02 00 00       	call   80027b <strcmp>
void
umain(int argc, char **argv)
{
	int i, nflag;

	nflag = 0;
  80005f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800066:	85 c0                	test   %eax,%eax
  800068:	0f 85 86 00 00 00    	jne    8000f4 <umain+0xc0>
		nflag = 1;
		argc--;
  80006e:	83 ef 01             	sub    $0x1,%edi
		argv++;
	}
	for (i = 1; i < argc; i++) {
  800071:	83 ff 01             	cmp    $0x1,%edi
  800074:	0f 8e 81 00 00 00    	jle    8000fb <umain+0xc7>

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
  80007a:	83 c6 04             	add    $0x4,%esi
{
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
  80007d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800084:	eb 6e                	jmp    8000f4 <umain+0xc0>
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
		if (i > 1)
  800086:	83 fb 01             	cmp    $0x1,%ebx
  800089:	7e 1c                	jle    8000a7 <umain+0x73>
			write(1, " ", 1);
  80008b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800092:	00 
  800093:	c7 44 24 04 63 22 80 	movl   $0x802263,0x4(%esp)
  80009a:	00 
  80009b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000a2:	e8 27 0d 00 00       	call   800dce <write>
		write(1, argv[i], strlen(argv[i]));
  8000a7:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000aa:	89 04 24             	mov    %eax,(%esp)
  8000ad:	e8 be 00 00 00       	call   800170 <strlen>
  8000b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b6:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000c4:	e8 05 0d 00 00       	call   800dce <write>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  8000c9:	83 c3 01             	add    $0x1,%ebx
  8000cc:	39 fb                	cmp    %edi,%ebx
  8000ce:	7c b6                	jl     800086 <umain+0x52>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  8000d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000d4:	75 25                	jne    8000fb <umain+0xc7>
		write(1, "\n", 1);
  8000d6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000dd:	00 
  8000de:	c7 44 24 04 73 23 80 	movl   $0x802373,0x4(%esp)
  8000e5:	00 
  8000e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000ed:	e8 dc 0c 00 00       	call   800dce <write>
  8000f2:	eb 07                	jmp    8000fb <umain+0xc7>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  8000f4:	bb 01 00 00 00       	mov    $0x1,%ebx
  8000f9:	eb ac                	jmp    8000a7 <umain+0x73>
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
		write(1, "\n", 1);
}
  8000fb:	83 c4 2c             	add    $0x2c,%esp
  8000fe:	5b                   	pop    %ebx
  8000ff:	5e                   	pop    %esi
  800100:	5f                   	pop    %edi
  800101:	5d                   	pop    %ebp
  800102:	c3                   	ret    
	...

00800104 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	83 ec 18             	sub    $0x18,%esp
  80010a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80010d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800110:	8b 75 08             	mov    0x8(%ebp),%esi
  800113:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800116:	e8 41 05 00 00       	call   80065c <sys_getenvid>
  80011b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800120:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800123:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800128:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012d:	85 f6                	test   %esi,%esi
  80012f:	7e 07                	jle    800138 <libmain+0x34>
		binaryname = argv[0];
  800131:	8b 03                	mov    (%ebx),%eax
  800133:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800138:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80013c:	89 34 24             	mov    %esi,(%esp)
  80013f:	e8 f0 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800144:	e8 0b 00 00 00       	call   800154 <exit>
}
  800149:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80014c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80014f:	89 ec                	mov    %ebp,%esp
  800151:	5d                   	pop    %ebp
  800152:	c3                   	ret    
	...

00800154 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80015a:	e8 4f 0a 00 00       	call   800bae <close_all>
	sys_env_destroy(0);
  80015f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800166:	e8 94 04 00 00       	call   8005ff <sys_env_destroy>
}
  80016b:	c9                   	leave  
  80016c:	c3                   	ret    
  80016d:	00 00                	add    %al,(%eax)
	...

00800170 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800176:	b8 00 00 00 00       	mov    $0x0,%eax
  80017b:	80 3a 00             	cmpb   $0x0,(%edx)
  80017e:	74 09                	je     800189 <strlen+0x19>
		n++;
  800180:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800183:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800187:	75 f7                	jne    800180 <strlen+0x10>
		n++;
	return n;
}
  800189:	5d                   	pop    %ebp
  80018a:	c3                   	ret    

0080018b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	53                   	push   %ebx
  80018f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800192:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800195:	b8 00 00 00 00       	mov    $0x0,%eax
  80019a:	85 c9                	test   %ecx,%ecx
  80019c:	74 1a                	je     8001b8 <strnlen+0x2d>
  80019e:	80 3b 00             	cmpb   $0x0,(%ebx)
  8001a1:	74 15                	je     8001b8 <strnlen+0x2d>
  8001a3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8001a8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8001aa:	39 ca                	cmp    %ecx,%edx
  8001ac:	74 0a                	je     8001b8 <strnlen+0x2d>
  8001ae:	83 c2 01             	add    $0x1,%edx
  8001b1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8001b6:	75 f0                	jne    8001a8 <strnlen+0x1d>
		n++;
	return n;
}
  8001b8:	5b                   	pop    %ebx
  8001b9:	5d                   	pop    %ebp
  8001ba:	c3                   	ret    

008001bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	53                   	push   %ebx
  8001bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ca:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8001ce:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8001d1:	83 c2 01             	add    $0x1,%edx
  8001d4:	84 c9                	test   %cl,%cl
  8001d6:	75 f2                	jne    8001ca <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8001d8:	5b                   	pop    %ebx
  8001d9:	5d                   	pop    %ebp
  8001da:	c3                   	ret    

008001db <strcat>:

char *
strcat(char *dst, const char *src)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	53                   	push   %ebx
  8001df:	83 ec 08             	sub    $0x8,%esp
  8001e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001e5:	89 1c 24             	mov    %ebx,(%esp)
  8001e8:	e8 83 ff ff ff       	call   800170 <strlen>
	strcpy(dst + len, src);
  8001ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001f4:	01 d8                	add    %ebx,%eax
  8001f6:	89 04 24             	mov    %eax,(%esp)
  8001f9:	e8 bd ff ff ff       	call   8001bb <strcpy>
	return dst;
}
  8001fe:	89 d8                	mov    %ebx,%eax
  800200:	83 c4 08             	add    $0x8,%esp
  800203:	5b                   	pop    %ebx
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    

00800206 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	56                   	push   %esi
  80020a:	53                   	push   %ebx
  80020b:	8b 45 08             	mov    0x8(%ebp),%eax
  80020e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800211:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800214:	85 f6                	test   %esi,%esi
  800216:	74 18                	je     800230 <strncpy+0x2a>
  800218:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  80021d:	0f b6 1a             	movzbl (%edx),%ebx
  800220:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800223:	80 3a 01             	cmpb   $0x1,(%edx)
  800226:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800229:	83 c1 01             	add    $0x1,%ecx
  80022c:	39 f1                	cmp    %esi,%ecx
  80022e:	75 ed                	jne    80021d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800230:	5b                   	pop    %ebx
  800231:	5e                   	pop    %esi
  800232:	5d                   	pop    %ebp
  800233:	c3                   	ret    

00800234 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	57                   	push   %edi
  800238:	56                   	push   %esi
  800239:	53                   	push   %ebx
  80023a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80023d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800240:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800243:	89 f8                	mov    %edi,%eax
  800245:	85 f6                	test   %esi,%esi
  800247:	74 2b                	je     800274 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800249:	83 fe 01             	cmp    $0x1,%esi
  80024c:	74 23                	je     800271 <strlcpy+0x3d>
  80024e:	0f b6 0b             	movzbl (%ebx),%ecx
  800251:	84 c9                	test   %cl,%cl
  800253:	74 1c                	je     800271 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800255:	83 ee 02             	sub    $0x2,%esi
  800258:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80025d:	88 08                	mov    %cl,(%eax)
  80025f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800262:	39 f2                	cmp    %esi,%edx
  800264:	74 0b                	je     800271 <strlcpy+0x3d>
  800266:	83 c2 01             	add    $0x1,%edx
  800269:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80026d:	84 c9                	test   %cl,%cl
  80026f:	75 ec                	jne    80025d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800271:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800274:	29 f8                	sub    %edi,%eax
}
  800276:	5b                   	pop    %ebx
  800277:	5e                   	pop    %esi
  800278:	5f                   	pop    %edi
  800279:	5d                   	pop    %ebp
  80027a:	c3                   	ret    

0080027b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800281:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800284:	0f b6 01             	movzbl (%ecx),%eax
  800287:	84 c0                	test   %al,%al
  800289:	74 16                	je     8002a1 <strcmp+0x26>
  80028b:	3a 02                	cmp    (%edx),%al
  80028d:	75 12                	jne    8002a1 <strcmp+0x26>
		p++, q++;
  80028f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800292:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800296:	84 c0                	test   %al,%al
  800298:	74 07                	je     8002a1 <strcmp+0x26>
  80029a:	83 c1 01             	add    $0x1,%ecx
  80029d:	3a 02                	cmp    (%edx),%al
  80029f:	74 ee                	je     80028f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8002a1:	0f b6 c0             	movzbl %al,%eax
  8002a4:	0f b6 12             	movzbl (%edx),%edx
  8002a7:	29 d0                	sub    %edx,%eax
}
  8002a9:	5d                   	pop    %ebp
  8002aa:	c3                   	ret    

008002ab <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	53                   	push   %ebx
  8002af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8002b8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8002bd:	85 d2                	test   %edx,%edx
  8002bf:	74 28                	je     8002e9 <strncmp+0x3e>
  8002c1:	0f b6 01             	movzbl (%ecx),%eax
  8002c4:	84 c0                	test   %al,%al
  8002c6:	74 24                	je     8002ec <strncmp+0x41>
  8002c8:	3a 03                	cmp    (%ebx),%al
  8002ca:	75 20                	jne    8002ec <strncmp+0x41>
  8002cc:	83 ea 01             	sub    $0x1,%edx
  8002cf:	74 13                	je     8002e4 <strncmp+0x39>
		n--, p++, q++;
  8002d1:	83 c1 01             	add    $0x1,%ecx
  8002d4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8002d7:	0f b6 01             	movzbl (%ecx),%eax
  8002da:	84 c0                	test   %al,%al
  8002dc:	74 0e                	je     8002ec <strncmp+0x41>
  8002de:	3a 03                	cmp    (%ebx),%al
  8002e0:	74 ea                	je     8002cc <strncmp+0x21>
  8002e2:	eb 08                	jmp    8002ec <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8002e4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8002e9:	5b                   	pop    %ebx
  8002ea:	5d                   	pop    %ebp
  8002eb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8002ec:	0f b6 01             	movzbl (%ecx),%eax
  8002ef:	0f b6 13             	movzbl (%ebx),%edx
  8002f2:	29 d0                	sub    %edx,%eax
  8002f4:	eb f3                	jmp    8002e9 <strncmp+0x3e>

008002f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
  8002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800300:	0f b6 10             	movzbl (%eax),%edx
  800303:	84 d2                	test   %dl,%dl
  800305:	74 1c                	je     800323 <strchr+0x2d>
		if (*s == c)
  800307:	38 ca                	cmp    %cl,%dl
  800309:	75 09                	jne    800314 <strchr+0x1e>
  80030b:	eb 1b                	jmp    800328 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80030d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800310:	38 ca                	cmp    %cl,%dl
  800312:	74 14                	je     800328 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800314:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800318:	84 d2                	test   %dl,%dl
  80031a:	75 f1                	jne    80030d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80031c:	b8 00 00 00 00       	mov    $0x0,%eax
  800321:	eb 05                	jmp    800328 <strchr+0x32>
  800323:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800328:	5d                   	pop    %ebp
  800329:	c3                   	ret    

0080032a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	8b 45 08             	mov    0x8(%ebp),%eax
  800330:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800334:	0f b6 10             	movzbl (%eax),%edx
  800337:	84 d2                	test   %dl,%dl
  800339:	74 14                	je     80034f <strfind+0x25>
		if (*s == c)
  80033b:	38 ca                	cmp    %cl,%dl
  80033d:	75 06                	jne    800345 <strfind+0x1b>
  80033f:	eb 0e                	jmp    80034f <strfind+0x25>
  800341:	38 ca                	cmp    %cl,%dl
  800343:	74 0a                	je     80034f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800345:	83 c0 01             	add    $0x1,%eax
  800348:	0f b6 10             	movzbl (%eax),%edx
  80034b:	84 d2                	test   %dl,%dl
  80034d:	75 f2                	jne    800341 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80034f:	5d                   	pop    %ebp
  800350:	c3                   	ret    

00800351 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80035a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80035d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800360:	8b 7d 08             	mov    0x8(%ebp),%edi
  800363:	8b 45 0c             	mov    0xc(%ebp),%eax
  800366:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800369:	85 c9                	test   %ecx,%ecx
  80036b:	74 30                	je     80039d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80036d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800373:	75 25                	jne    80039a <memset+0x49>
  800375:	f6 c1 03             	test   $0x3,%cl
  800378:	75 20                	jne    80039a <memset+0x49>
		c &= 0xFF;
  80037a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80037d:	89 d3                	mov    %edx,%ebx
  80037f:	c1 e3 08             	shl    $0x8,%ebx
  800382:	89 d6                	mov    %edx,%esi
  800384:	c1 e6 18             	shl    $0x18,%esi
  800387:	89 d0                	mov    %edx,%eax
  800389:	c1 e0 10             	shl    $0x10,%eax
  80038c:	09 f0                	or     %esi,%eax
  80038e:	09 d0                	or     %edx,%eax
  800390:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800392:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800395:	fc                   	cld    
  800396:	f3 ab                	rep stos %eax,%es:(%edi)
  800398:	eb 03                	jmp    80039d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80039a:	fc                   	cld    
  80039b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80039d:	89 f8                	mov    %edi,%eax
  80039f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003a2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003a5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003a8:	89 ec                	mov    %ebp,%esp
  8003aa:	5d                   	pop    %ebp
  8003ab:	c3                   	ret    

008003ac <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003b5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003be:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8003c1:	39 c6                	cmp    %eax,%esi
  8003c3:	73 36                	jae    8003fb <memmove+0x4f>
  8003c5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8003c8:	39 d0                	cmp    %edx,%eax
  8003ca:	73 2f                	jae    8003fb <memmove+0x4f>
		s += n;
		d += n;
  8003cc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8003cf:	f6 c2 03             	test   $0x3,%dl
  8003d2:	75 1b                	jne    8003ef <memmove+0x43>
  8003d4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8003da:	75 13                	jne    8003ef <memmove+0x43>
  8003dc:	f6 c1 03             	test   $0x3,%cl
  8003df:	75 0e                	jne    8003ef <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8003e1:	83 ef 04             	sub    $0x4,%edi
  8003e4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8003e7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8003ea:	fd                   	std    
  8003eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8003ed:	eb 09                	jmp    8003f8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8003ef:	83 ef 01             	sub    $0x1,%edi
  8003f2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8003f5:	fd                   	std    
  8003f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8003f8:	fc                   	cld    
  8003f9:	eb 20                	jmp    80041b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8003fb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800401:	75 13                	jne    800416 <memmove+0x6a>
  800403:	a8 03                	test   $0x3,%al
  800405:	75 0f                	jne    800416 <memmove+0x6a>
  800407:	f6 c1 03             	test   $0x3,%cl
  80040a:	75 0a                	jne    800416 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80040c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80040f:	89 c7                	mov    %eax,%edi
  800411:	fc                   	cld    
  800412:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800414:	eb 05                	jmp    80041b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800416:	89 c7                	mov    %eax,%edi
  800418:	fc                   	cld    
  800419:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80041b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80041e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800421:	89 ec                	mov    %ebp,%esp
  800423:	5d                   	pop    %ebp
  800424:	c3                   	ret    

00800425 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800425:	55                   	push   %ebp
  800426:	89 e5                	mov    %esp,%ebp
  800428:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80042b:	8b 45 10             	mov    0x10(%ebp),%eax
  80042e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800432:	8b 45 0c             	mov    0xc(%ebp),%eax
  800435:	89 44 24 04          	mov    %eax,0x4(%esp)
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	89 04 24             	mov    %eax,(%esp)
  80043f:	e8 68 ff ff ff       	call   8003ac <memmove>
}
  800444:	c9                   	leave  
  800445:	c3                   	ret    

00800446 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	57                   	push   %edi
  80044a:	56                   	push   %esi
  80044b:	53                   	push   %ebx
  80044c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80044f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800452:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80045a:	85 ff                	test   %edi,%edi
  80045c:	74 37                	je     800495 <memcmp+0x4f>
		if (*s1 != *s2)
  80045e:	0f b6 03             	movzbl (%ebx),%eax
  800461:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800464:	83 ef 01             	sub    $0x1,%edi
  800467:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  80046c:	38 c8                	cmp    %cl,%al
  80046e:	74 1c                	je     80048c <memcmp+0x46>
  800470:	eb 10                	jmp    800482 <memcmp+0x3c>
  800472:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800477:	83 c2 01             	add    $0x1,%edx
  80047a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  80047e:	38 c8                	cmp    %cl,%al
  800480:	74 0a                	je     80048c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800482:	0f b6 c0             	movzbl %al,%eax
  800485:	0f b6 c9             	movzbl %cl,%ecx
  800488:	29 c8                	sub    %ecx,%eax
  80048a:	eb 09                	jmp    800495 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80048c:	39 fa                	cmp    %edi,%edx
  80048e:	75 e2                	jne    800472 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800495:	5b                   	pop    %ebx
  800496:	5e                   	pop    %esi
  800497:	5f                   	pop    %edi
  800498:	5d                   	pop    %ebp
  800499:	c3                   	ret    

0080049a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8004a0:	89 c2                	mov    %eax,%edx
  8004a2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8004a5:	39 d0                	cmp    %edx,%eax
  8004a7:	73 19                	jae    8004c2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8004a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  8004ad:	38 08                	cmp    %cl,(%eax)
  8004af:	75 06                	jne    8004b7 <memfind+0x1d>
  8004b1:	eb 0f                	jmp    8004c2 <memfind+0x28>
  8004b3:	38 08                	cmp    %cl,(%eax)
  8004b5:	74 0b                	je     8004c2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8004b7:	83 c0 01             	add    $0x1,%eax
  8004ba:	39 d0                	cmp    %edx,%eax
  8004bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8004c0:	75 f1                	jne    8004b3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8004c2:	5d                   	pop    %ebp
  8004c3:	c3                   	ret    

008004c4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	57                   	push   %edi
  8004c8:	56                   	push   %esi
  8004c9:	53                   	push   %ebx
  8004ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8004cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8004d0:	0f b6 02             	movzbl (%edx),%eax
  8004d3:	3c 20                	cmp    $0x20,%al
  8004d5:	74 04                	je     8004db <strtol+0x17>
  8004d7:	3c 09                	cmp    $0x9,%al
  8004d9:	75 0e                	jne    8004e9 <strtol+0x25>
		s++;
  8004db:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8004de:	0f b6 02             	movzbl (%edx),%eax
  8004e1:	3c 20                	cmp    $0x20,%al
  8004e3:	74 f6                	je     8004db <strtol+0x17>
  8004e5:	3c 09                	cmp    $0x9,%al
  8004e7:	74 f2                	je     8004db <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  8004e9:	3c 2b                	cmp    $0x2b,%al
  8004eb:	75 0a                	jne    8004f7 <strtol+0x33>
		s++;
  8004ed:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8004f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8004f5:	eb 10                	jmp    800507 <strtol+0x43>
  8004f7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8004fc:	3c 2d                	cmp    $0x2d,%al
  8004fe:	75 07                	jne    800507 <strtol+0x43>
		s++, neg = 1;
  800500:	83 c2 01             	add    $0x1,%edx
  800503:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800507:	85 db                	test   %ebx,%ebx
  800509:	0f 94 c0             	sete   %al
  80050c:	74 05                	je     800513 <strtol+0x4f>
  80050e:	83 fb 10             	cmp    $0x10,%ebx
  800511:	75 15                	jne    800528 <strtol+0x64>
  800513:	80 3a 30             	cmpb   $0x30,(%edx)
  800516:	75 10                	jne    800528 <strtol+0x64>
  800518:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80051c:	75 0a                	jne    800528 <strtol+0x64>
		s += 2, base = 16;
  80051e:	83 c2 02             	add    $0x2,%edx
  800521:	bb 10 00 00 00       	mov    $0x10,%ebx
  800526:	eb 13                	jmp    80053b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800528:	84 c0                	test   %al,%al
  80052a:	74 0f                	je     80053b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80052c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800531:	80 3a 30             	cmpb   $0x30,(%edx)
  800534:	75 05                	jne    80053b <strtol+0x77>
		s++, base = 8;
  800536:	83 c2 01             	add    $0x1,%edx
  800539:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  80053b:	b8 00 00 00 00       	mov    $0x0,%eax
  800540:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800542:	0f b6 0a             	movzbl (%edx),%ecx
  800545:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800548:	80 fb 09             	cmp    $0x9,%bl
  80054b:	77 08                	ja     800555 <strtol+0x91>
			dig = *s - '0';
  80054d:	0f be c9             	movsbl %cl,%ecx
  800550:	83 e9 30             	sub    $0x30,%ecx
  800553:	eb 1e                	jmp    800573 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800555:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800558:	80 fb 19             	cmp    $0x19,%bl
  80055b:	77 08                	ja     800565 <strtol+0xa1>
			dig = *s - 'a' + 10;
  80055d:	0f be c9             	movsbl %cl,%ecx
  800560:	83 e9 57             	sub    $0x57,%ecx
  800563:	eb 0e                	jmp    800573 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800565:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800568:	80 fb 19             	cmp    $0x19,%bl
  80056b:	77 14                	ja     800581 <strtol+0xbd>
			dig = *s - 'A' + 10;
  80056d:	0f be c9             	movsbl %cl,%ecx
  800570:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800573:	39 f1                	cmp    %esi,%ecx
  800575:	7d 0e                	jge    800585 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800577:	83 c2 01             	add    $0x1,%edx
  80057a:	0f af c6             	imul   %esi,%eax
  80057d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  80057f:	eb c1                	jmp    800542 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800581:	89 c1                	mov    %eax,%ecx
  800583:	eb 02                	jmp    800587 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800585:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800587:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80058b:	74 05                	je     800592 <strtol+0xce>
		*endptr = (char *) s;
  80058d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800590:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800592:	89 ca                	mov    %ecx,%edx
  800594:	f7 da                	neg    %edx
  800596:	85 ff                	test   %edi,%edi
  800598:	0f 45 c2             	cmovne %edx,%eax
}
  80059b:	5b                   	pop    %ebx
  80059c:	5e                   	pop    %esi
  80059d:	5f                   	pop    %edi
  80059e:	5d                   	pop    %ebp
  80059f:	c3                   	ret    

008005a0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8005a9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8005ac:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005af:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ba:	89 c3                	mov    %eax,%ebx
  8005bc:	89 c7                	mov    %eax,%edi
  8005be:	89 c6                	mov    %eax,%esi
  8005c0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8005c2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8005c5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8005c8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005cb:	89 ec                	mov    %ebp,%esp
  8005cd:	5d                   	pop    %ebp
  8005ce:	c3                   	ret    

008005cf <sys_cgetc>:

int
sys_cgetc(void)
{
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	83 ec 0c             	sub    $0xc,%esp
  8005d5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8005d8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8005db:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005de:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8005e8:	89 d1                	mov    %edx,%ecx
  8005ea:	89 d3                	mov    %edx,%ebx
  8005ec:	89 d7                	mov    %edx,%edi
  8005ee:	89 d6                	mov    %edx,%esi
  8005f0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8005f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8005f5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8005f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005fb:	89 ec                	mov    %ebp,%esp
  8005fd:	5d                   	pop    %ebp
  8005fe:	c3                   	ret    

008005ff <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8005ff:	55                   	push   %ebp
  800600:	89 e5                	mov    %esp,%ebp
  800602:	83 ec 38             	sub    $0x38,%esp
  800605:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800608:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80060b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80060e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800613:	b8 03 00 00 00       	mov    $0x3,%eax
  800618:	8b 55 08             	mov    0x8(%ebp),%edx
  80061b:	89 cb                	mov    %ecx,%ebx
  80061d:	89 cf                	mov    %ecx,%edi
  80061f:	89 ce                	mov    %ecx,%esi
  800621:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800623:	85 c0                	test   %eax,%eax
  800625:	7e 28                	jle    80064f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800627:	89 44 24 10          	mov    %eax,0x10(%esp)
  80062b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800632:	00 
  800633:	c7 44 24 08 6f 22 80 	movl   $0x80226f,0x8(%esp)
  80063a:	00 
  80063b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800642:	00 
  800643:	c7 04 24 8c 22 80 00 	movl   $0x80228c,(%esp)
  80064a:	e8 31 11 00 00       	call   801780 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80064f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800652:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800655:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800658:	89 ec                	mov    %ebp,%esp
  80065a:	5d                   	pop    %ebp
  80065b:	c3                   	ret    

0080065c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	83 ec 0c             	sub    $0xc,%esp
  800662:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800665:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800668:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80066b:	ba 00 00 00 00       	mov    $0x0,%edx
  800670:	b8 02 00 00 00       	mov    $0x2,%eax
  800675:	89 d1                	mov    %edx,%ecx
  800677:	89 d3                	mov    %edx,%ebx
  800679:	89 d7                	mov    %edx,%edi
  80067b:	89 d6                	mov    %edx,%esi
  80067d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80067f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800682:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800685:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800688:	89 ec                	mov    %ebp,%esp
  80068a:	5d                   	pop    %ebp
  80068b:	c3                   	ret    

0080068c <sys_yield>:

void
sys_yield(void)
{
  80068c:	55                   	push   %ebp
  80068d:	89 e5                	mov    %esp,%ebp
  80068f:	83 ec 0c             	sub    $0xc,%esp
  800692:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800695:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800698:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80069b:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8006a5:	89 d1                	mov    %edx,%ecx
  8006a7:	89 d3                	mov    %edx,%ebx
  8006a9:	89 d7                	mov    %edx,%edi
  8006ab:	89 d6                	mov    %edx,%esi
  8006ad:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8006af:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8006b2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8006b5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8006b8:	89 ec                	mov    %ebp,%esp
  8006ba:	5d                   	pop    %ebp
  8006bb:	c3                   	ret    

008006bc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	83 ec 38             	sub    $0x38,%esp
  8006c2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8006c5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8006c8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006cb:	be 00 00 00 00       	mov    $0x0,%esi
  8006d0:	b8 04 00 00 00       	mov    $0x4,%eax
  8006d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006db:	8b 55 08             	mov    0x8(%ebp),%edx
  8006de:	89 f7                	mov    %esi,%edi
  8006e0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8006e2:	85 c0                	test   %eax,%eax
  8006e4:	7e 28                	jle    80070e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8006e6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006ea:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8006f1:	00 
  8006f2:	c7 44 24 08 6f 22 80 	movl   $0x80226f,0x8(%esp)
  8006f9:	00 
  8006fa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800701:	00 
  800702:	c7 04 24 8c 22 80 00 	movl   $0x80228c,(%esp)
  800709:	e8 72 10 00 00       	call   801780 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80070e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800711:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800714:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800717:	89 ec                	mov    %ebp,%esp
  800719:	5d                   	pop    %ebp
  80071a:	c3                   	ret    

0080071b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	83 ec 38             	sub    $0x38,%esp
  800721:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800724:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800727:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80072a:	b8 05 00 00 00       	mov    $0x5,%eax
  80072f:	8b 75 18             	mov    0x18(%ebp),%esi
  800732:	8b 7d 14             	mov    0x14(%ebp),%edi
  800735:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800738:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80073b:	8b 55 08             	mov    0x8(%ebp),%edx
  80073e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800740:	85 c0                	test   %eax,%eax
  800742:	7e 28                	jle    80076c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800744:	89 44 24 10          	mov    %eax,0x10(%esp)
  800748:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80074f:	00 
  800750:	c7 44 24 08 6f 22 80 	movl   $0x80226f,0x8(%esp)
  800757:	00 
  800758:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80075f:	00 
  800760:	c7 04 24 8c 22 80 00 	movl   $0x80228c,(%esp)
  800767:	e8 14 10 00 00       	call   801780 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80076c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80076f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800772:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800775:	89 ec                	mov    %ebp,%esp
  800777:	5d                   	pop    %ebp
  800778:	c3                   	ret    

00800779 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	83 ec 38             	sub    $0x38,%esp
  80077f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800782:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800785:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800788:	bb 00 00 00 00       	mov    $0x0,%ebx
  80078d:	b8 06 00 00 00       	mov    $0x6,%eax
  800792:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800795:	8b 55 08             	mov    0x8(%ebp),%edx
  800798:	89 df                	mov    %ebx,%edi
  80079a:	89 de                	mov    %ebx,%esi
  80079c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	7e 28                	jle    8007ca <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8007a2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007a6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8007ad:	00 
  8007ae:	c7 44 24 08 6f 22 80 	movl   $0x80226f,0x8(%esp)
  8007b5:	00 
  8007b6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8007bd:	00 
  8007be:	c7 04 24 8c 22 80 00 	movl   $0x80228c,(%esp)
  8007c5:	e8 b6 0f 00 00       	call   801780 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8007ca:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8007cd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8007d0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8007d3:	89 ec                	mov    %ebp,%esp
  8007d5:	5d                   	pop    %ebp
  8007d6:	c3                   	ret    

008007d7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	83 ec 38             	sub    $0x38,%esp
  8007dd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8007e0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8007e3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8007f6:	89 df                	mov    %ebx,%edi
  8007f8:	89 de                	mov    %ebx,%esi
  8007fa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8007fc:	85 c0                	test   %eax,%eax
  8007fe:	7e 28                	jle    800828 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800800:	89 44 24 10          	mov    %eax,0x10(%esp)
  800804:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80080b:	00 
  80080c:	c7 44 24 08 6f 22 80 	movl   $0x80226f,0x8(%esp)
  800813:	00 
  800814:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80081b:	00 
  80081c:	c7 04 24 8c 22 80 00 	movl   $0x80228c,(%esp)
  800823:	e8 58 0f 00 00       	call   801780 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800828:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80082b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80082e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800831:	89 ec                	mov    %ebp,%esp
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	83 ec 38             	sub    $0x38,%esp
  80083b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80083e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800841:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800844:	bb 00 00 00 00       	mov    $0x0,%ebx
  800849:	b8 09 00 00 00       	mov    $0x9,%eax
  80084e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800851:	8b 55 08             	mov    0x8(%ebp),%edx
  800854:	89 df                	mov    %ebx,%edi
  800856:	89 de                	mov    %ebx,%esi
  800858:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80085a:	85 c0                	test   %eax,%eax
  80085c:	7e 28                	jle    800886 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80085e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800862:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800869:	00 
  80086a:	c7 44 24 08 6f 22 80 	movl   $0x80226f,0x8(%esp)
  800871:	00 
  800872:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800879:	00 
  80087a:	c7 04 24 8c 22 80 00 	movl   $0x80228c,(%esp)
  800881:	e8 fa 0e 00 00       	call   801780 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800886:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800889:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80088c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80088f:	89 ec                	mov    %ebp,%esp
  800891:	5d                   	pop    %ebp
  800892:	c3                   	ret    

00800893 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	83 ec 38             	sub    $0x38,%esp
  800899:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80089c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80089f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008af:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b2:	89 df                	mov    %ebx,%edi
  8008b4:	89 de                	mov    %ebx,%esi
  8008b6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	7e 28                	jle    8008e4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8008bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8008c0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8008c7:	00 
  8008c8:	c7 44 24 08 6f 22 80 	movl   $0x80226f,0x8(%esp)
  8008cf:	00 
  8008d0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8008d7:	00 
  8008d8:	c7 04 24 8c 22 80 00 	movl   $0x80228c,(%esp)
  8008df:	e8 9c 0e 00 00       	call   801780 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8008e4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8008e7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8008ea:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8008ed:	89 ec                	mov    %ebp,%esp
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 0c             	sub    $0xc,%esp
  8008f7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8008fa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8008fd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800900:	be 00 00 00 00       	mov    $0x0,%esi
  800905:	b8 0c 00 00 00       	mov    $0xc,%eax
  80090a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80090d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800910:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800913:	8b 55 08             	mov    0x8(%ebp),%edx
  800916:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800918:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80091b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80091e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800921:	89 ec                	mov    %ebp,%esp
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	83 ec 38             	sub    $0x38,%esp
  80092b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80092e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800931:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800934:	b9 00 00 00 00       	mov    $0x0,%ecx
  800939:	b8 0d 00 00 00       	mov    $0xd,%eax
  80093e:	8b 55 08             	mov    0x8(%ebp),%edx
  800941:	89 cb                	mov    %ecx,%ebx
  800943:	89 cf                	mov    %ecx,%edi
  800945:	89 ce                	mov    %ecx,%esi
  800947:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800949:	85 c0                	test   %eax,%eax
  80094b:	7e 28                	jle    800975 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80094d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800951:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800958:	00 
  800959:	c7 44 24 08 6f 22 80 	movl   $0x80226f,0x8(%esp)
  800960:	00 
  800961:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800968:	00 
  800969:	c7 04 24 8c 22 80 00 	movl   $0x80228c,(%esp)
  800970:	e8 0b 0e 00 00       	call   801780 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800975:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800978:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80097b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80097e:	89 ec                	mov    %ebp,%esp
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    
	...

00800990 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	05 00 00 00 30       	add    $0x30000000,%eax
  80099b:	c1 e8 0c             	shr    $0xc,%eax
}
  80099e:	5d                   	pop    %ebp
  80099f:	c3                   	ret    

008009a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	89 04 24             	mov    %eax,(%esp)
  8009ac:	e8 df ff ff ff       	call   800990 <fd2num>
  8009b1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8009b6:	c1 e0 0c             	shl    $0xc,%eax
}
  8009b9:	c9                   	leave  
  8009ba:	c3                   	ret    

008009bb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	53                   	push   %ebx
  8009bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8009c2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8009c7:	a8 01                	test   $0x1,%al
  8009c9:	74 34                	je     8009ff <fd_alloc+0x44>
  8009cb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8009d0:	a8 01                	test   $0x1,%al
  8009d2:	74 32                	je     800a06 <fd_alloc+0x4b>
  8009d4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8009d9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8009db:	89 c2                	mov    %eax,%edx
  8009dd:	c1 ea 16             	shr    $0x16,%edx
  8009e0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8009e7:	f6 c2 01             	test   $0x1,%dl
  8009ea:	74 1f                	je     800a0b <fd_alloc+0x50>
  8009ec:	89 c2                	mov    %eax,%edx
  8009ee:	c1 ea 0c             	shr    $0xc,%edx
  8009f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8009f8:	f6 c2 01             	test   $0x1,%dl
  8009fb:	75 17                	jne    800a14 <fd_alloc+0x59>
  8009fd:	eb 0c                	jmp    800a0b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8009ff:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800a04:	eb 05                	jmp    800a0b <fd_alloc+0x50>
  800a06:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  800a0b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a12:	eb 17                	jmp    800a2b <fd_alloc+0x70>
  800a14:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800a19:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800a1e:	75 b9                	jne    8009d9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800a20:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  800a26:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800a2b:	5b                   	pop    %ebx
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800a34:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800a39:	83 fa 1f             	cmp    $0x1f,%edx
  800a3c:	77 3f                	ja     800a7d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800a3e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  800a44:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800a47:	89 d0                	mov    %edx,%eax
  800a49:	c1 e8 16             	shr    $0x16,%eax
  800a4c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800a53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800a58:	f6 c1 01             	test   $0x1,%cl
  800a5b:	74 20                	je     800a7d <fd_lookup+0x4f>
  800a5d:	89 d0                	mov    %edx,%eax
  800a5f:	c1 e8 0c             	shr    $0xc,%eax
  800a62:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800a69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800a6e:	f6 c1 01             	test   $0x1,%cl
  800a71:	74 0a                	je     800a7d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a76:	89 10                	mov    %edx,(%eax)
	return 0;
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7d:	5d                   	pop    %ebp
  800a7e:	c3                   	ret    

00800a7f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	53                   	push   %ebx
  800a83:	83 ec 14             	sub    $0x14,%esp
  800a86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  800a8c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  800a91:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  800a97:	75 17                	jne    800ab0 <dev_lookup+0x31>
  800a99:	eb 07                	jmp    800aa2 <dev_lookup+0x23>
  800a9b:	39 0a                	cmp    %ecx,(%edx)
  800a9d:	75 11                	jne    800ab0 <dev_lookup+0x31>
  800a9f:	90                   	nop
  800aa0:	eb 05                	jmp    800aa7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800aa2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  800aa7:	89 13                	mov    %edx,(%ebx)
			return 0;
  800aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800aae:	eb 35                	jmp    800ae5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800ab0:	83 c0 01             	add    $0x1,%eax
  800ab3:	8b 14 85 18 23 80 00 	mov    0x802318(,%eax,4),%edx
  800aba:	85 d2                	test   %edx,%edx
  800abc:	75 dd                	jne    800a9b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800abe:	a1 04 40 80 00       	mov    0x804004,%eax
  800ac3:	8b 40 48             	mov    0x48(%eax),%eax
  800ac6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ace:	c7 04 24 9c 22 80 00 	movl   $0x80229c,(%esp)
  800ad5:	e8 a1 0d 00 00       	call   80187b <cprintf>
	*dev = 0;
  800ada:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  800ae0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ae5:	83 c4 14             	add    $0x14,%esp
  800ae8:	5b                   	pop    %ebx
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	83 ec 38             	sub    $0x38,%esp
  800af1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800af4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800af7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800afa:	8b 7d 08             	mov    0x8(%ebp),%edi
  800afd:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800b01:	89 3c 24             	mov    %edi,(%esp)
  800b04:	e8 87 fe ff ff       	call   800990 <fd2num>
  800b09:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800b0c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b10:	89 04 24             	mov    %eax,(%esp)
  800b13:	e8 16 ff ff ff       	call   800a2e <fd_lookup>
  800b18:	89 c3                	mov    %eax,%ebx
  800b1a:	85 c0                	test   %eax,%eax
  800b1c:	78 05                	js     800b23 <fd_close+0x38>
	    || fd != fd2)
  800b1e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  800b21:	74 0e                	je     800b31 <fd_close+0x46>
		return (must_exist ? r : 0);
  800b23:	89 f0                	mov    %esi,%eax
  800b25:	84 c0                	test   %al,%al
  800b27:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2c:	0f 44 d8             	cmove  %eax,%ebx
  800b2f:	eb 3d                	jmp    800b6e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800b31:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b38:	8b 07                	mov    (%edi),%eax
  800b3a:	89 04 24             	mov    %eax,(%esp)
  800b3d:	e8 3d ff ff ff       	call   800a7f <dev_lookup>
  800b42:	89 c3                	mov    %eax,%ebx
  800b44:	85 c0                	test   %eax,%eax
  800b46:	78 16                	js     800b5e <fd_close+0x73>
		if (dev->dev_close)
  800b48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b4b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800b4e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800b53:	85 c0                	test   %eax,%eax
  800b55:	74 07                	je     800b5e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  800b57:	89 3c 24             	mov    %edi,(%esp)
  800b5a:	ff d0                	call   *%eax
  800b5c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800b5e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b69:	e8 0b fc ff ff       	call   800779 <sys_page_unmap>
	return r;
}
  800b6e:	89 d8                	mov    %ebx,%eax
  800b70:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800b73:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b76:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b79:	89 ec                	mov    %ebp,%esp
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800b83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b86:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	89 04 24             	mov    %eax,(%esp)
  800b90:	e8 99 fe ff ff       	call   800a2e <fd_lookup>
  800b95:	85 c0                	test   %eax,%eax
  800b97:	78 13                	js     800bac <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  800b99:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800ba0:	00 
  800ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ba4:	89 04 24             	mov    %eax,(%esp)
  800ba7:	e8 3f ff ff ff       	call   800aeb <fd_close>
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <close_all>:

void
close_all(void)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	53                   	push   %ebx
  800bb2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800bb5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800bba:	89 1c 24             	mov    %ebx,(%esp)
  800bbd:	e8 bb ff ff ff       	call   800b7d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800bc2:	83 c3 01             	add    $0x1,%ebx
  800bc5:	83 fb 20             	cmp    $0x20,%ebx
  800bc8:	75 f0                	jne    800bba <close_all+0xc>
		close(i);
}
  800bca:	83 c4 14             	add    $0x14,%esp
  800bcd:	5b                   	pop    %ebx
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    

00800bd0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 58             	sub    $0x58,%esp
  800bd6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800bd9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bdc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800bdf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800be2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800be5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	89 04 24             	mov    %eax,(%esp)
  800bef:	e8 3a fe ff ff       	call   800a2e <fd_lookup>
  800bf4:	89 c3                	mov    %eax,%ebx
  800bf6:	85 c0                	test   %eax,%eax
  800bf8:	0f 88 e1 00 00 00    	js     800cdf <dup+0x10f>
		return r;
	close(newfdnum);
  800bfe:	89 3c 24             	mov    %edi,(%esp)
  800c01:	e8 77 ff ff ff       	call   800b7d <close>

	newfd = INDEX2FD(newfdnum);
  800c06:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  800c0c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  800c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c12:	89 04 24             	mov    %eax,(%esp)
  800c15:	e8 86 fd ff ff       	call   8009a0 <fd2data>
  800c1a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800c1c:	89 34 24             	mov    %esi,(%esp)
  800c1f:	e8 7c fd ff ff       	call   8009a0 <fd2data>
  800c24:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800c27:	89 d8                	mov    %ebx,%eax
  800c29:	c1 e8 16             	shr    $0x16,%eax
  800c2c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800c33:	a8 01                	test   $0x1,%al
  800c35:	74 46                	je     800c7d <dup+0xad>
  800c37:	89 d8                	mov    %ebx,%eax
  800c39:	c1 e8 0c             	shr    $0xc,%eax
  800c3c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800c43:	f6 c2 01             	test   $0x1,%dl
  800c46:	74 35                	je     800c7d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800c48:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800c4f:	25 07 0e 00 00       	and    $0xe07,%eax
  800c54:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800c66:	00 
  800c67:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c72:	e8 a4 fa ff ff       	call   80071b <sys_page_map>
  800c77:	89 c3                	mov    %eax,%ebx
  800c79:	85 c0                	test   %eax,%eax
  800c7b:	78 3b                	js     800cb8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800c7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c80:	89 c2                	mov    %eax,%edx
  800c82:	c1 ea 0c             	shr    $0xc,%edx
  800c85:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800c8c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800c92:	89 54 24 10          	mov    %edx,0x10(%esp)
  800c96:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800c9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800ca1:	00 
  800ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ca6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cad:	e8 69 fa ff ff       	call   80071b <sys_page_map>
  800cb2:	89 c3                	mov    %eax,%ebx
  800cb4:	85 c0                	test   %eax,%eax
  800cb6:	79 25                	jns    800cdd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800cb8:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cbc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cc3:	e8 b1 fa ff ff       	call   800779 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800cc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ccf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cd6:	e8 9e fa ff ff       	call   800779 <sys_page_unmap>
	return r;
  800cdb:	eb 02                	jmp    800cdf <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  800cdd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800cdf:	89 d8                	mov    %ebx,%eax
  800ce1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ce4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ce7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cea:	89 ec                	mov    %ebp,%esp
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	53                   	push   %ebx
  800cf2:	83 ec 24             	sub    $0x24,%esp
  800cf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cf8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cff:	89 1c 24             	mov    %ebx,(%esp)
  800d02:	e8 27 fd ff ff       	call   800a2e <fd_lookup>
  800d07:	85 c0                	test   %eax,%eax
  800d09:	78 6d                	js     800d78 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	89 04 24             	mov    %eax,(%esp)
  800d1a:	e8 60 fd ff ff       	call   800a7f <dev_lookup>
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	78 55                	js     800d78 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d26:	8b 50 08             	mov    0x8(%eax),%edx
  800d29:	83 e2 03             	and    $0x3,%edx
  800d2c:	83 fa 01             	cmp    $0x1,%edx
  800d2f:	75 23                	jne    800d54 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800d31:	a1 04 40 80 00       	mov    0x804004,%eax
  800d36:	8b 40 48             	mov    0x48(%eax),%eax
  800d39:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d41:	c7 04 24 dd 22 80 00 	movl   $0x8022dd,(%esp)
  800d48:	e8 2e 0b 00 00       	call   80187b <cprintf>
		return -E_INVAL;
  800d4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d52:	eb 24                	jmp    800d78 <read+0x8a>
	}
	if (!dev->dev_read)
  800d54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d57:	8b 52 08             	mov    0x8(%edx),%edx
  800d5a:	85 d2                	test   %edx,%edx
  800d5c:	74 15                	je     800d73 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800d5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d61:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d6c:	89 04 24             	mov    %eax,(%esp)
  800d6f:	ff d2                	call   *%edx
  800d71:	eb 05                	jmp    800d78 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800d73:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800d78:	83 c4 24             	add    $0x24,%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 1c             	sub    $0x1c,%esp
  800d87:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d8a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d92:	85 f6                	test   %esi,%esi
  800d94:	74 30                	je     800dc6 <readn+0x48>
  800d96:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  800d9b:	89 f2                	mov    %esi,%edx
  800d9d:	29 c2                	sub    %eax,%edx
  800d9f:	89 54 24 08          	mov    %edx,0x8(%esp)
  800da3:	03 45 0c             	add    0xc(%ebp),%eax
  800da6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800daa:	89 3c 24             	mov    %edi,(%esp)
  800dad:	e8 3c ff ff ff       	call   800cee <read>
		if (m < 0)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	78 10                	js     800dc6 <readn+0x48>
			return m;
		if (m == 0)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	74 0a                	je     800dc4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800dba:	01 c3                	add    %eax,%ebx
  800dbc:	89 d8                	mov    %ebx,%eax
  800dbe:	39 f3                	cmp    %esi,%ebx
  800dc0:	72 d9                	jb     800d9b <readn+0x1d>
  800dc2:	eb 02                	jmp    800dc6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  800dc4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  800dc6:	83 c4 1c             	add    $0x1c,%esp
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5f                   	pop    %edi
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    

00800dce <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	53                   	push   %ebx
  800dd2:	83 ec 24             	sub    $0x24,%esp
  800dd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dd8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ddf:	89 1c 24             	mov    %ebx,(%esp)
  800de2:	e8 47 fc ff ff       	call   800a2e <fd_lookup>
  800de7:	85 c0                	test   %eax,%eax
  800de9:	78 68                	js     800e53 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800deb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dee:	89 44 24 04          	mov    %eax,0x4(%esp)
  800df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df5:	8b 00                	mov    (%eax),%eax
  800df7:	89 04 24             	mov    %eax,(%esp)
  800dfa:	e8 80 fc ff ff       	call   800a7f <dev_lookup>
  800dff:	85 c0                	test   %eax,%eax
  800e01:	78 50                	js     800e53 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e06:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800e0a:	75 23                	jne    800e2f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800e0c:	a1 04 40 80 00       	mov    0x804004,%eax
  800e11:	8b 40 48             	mov    0x48(%eax),%eax
  800e14:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800e18:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e1c:	c7 04 24 f9 22 80 00 	movl   $0x8022f9,(%esp)
  800e23:	e8 53 0a 00 00       	call   80187b <cprintf>
		return -E_INVAL;
  800e28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e2d:	eb 24                	jmp    800e53 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e32:	8b 52 0c             	mov    0xc(%edx),%edx
  800e35:	85 d2                	test   %edx,%edx
  800e37:	74 15                	je     800e4e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800e39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e3c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e47:	89 04 24             	mov    %eax,(%esp)
  800e4a:	ff d2                	call   *%edx
  800e4c:	eb 05                	jmp    800e53 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800e4e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800e53:	83 c4 24             	add    $0x24,%esp
  800e56:	5b                   	pop    %ebx
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <seek>:

int
seek(int fdnum, off_t offset)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e5f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800e62:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	89 04 24             	mov    %eax,(%esp)
  800e6c:	e8 bd fb ff ff       	call   800a2e <fd_lookup>
  800e71:	85 c0                	test   %eax,%eax
  800e73:	78 0e                	js     800e83 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	53                   	push   %ebx
  800e89:	83 ec 24             	sub    $0x24,%esp
  800e8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e8f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e92:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e96:	89 1c 24             	mov    %ebx,(%esp)
  800e99:	e8 90 fb ff ff       	call   800a2e <fd_lookup>
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	78 61                	js     800f03 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ea2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	89 04 24             	mov    %eax,(%esp)
  800eb1:	e8 c9 fb ff ff       	call   800a7f <dev_lookup>
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	78 49                	js     800f03 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800ec1:	75 23                	jne    800ee6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800ec3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800ec8:	8b 40 48             	mov    0x48(%eax),%eax
  800ecb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800ecf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ed3:	c7 04 24 bc 22 80 00 	movl   $0x8022bc,(%esp)
  800eda:	e8 9c 09 00 00       	call   80187b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800edf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ee4:	eb 1d                	jmp    800f03 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  800ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee9:	8b 52 18             	mov    0x18(%edx),%edx
  800eec:	85 d2                	test   %edx,%edx
  800eee:	74 0e                	je     800efe <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ef7:	89 04 24             	mov    %eax,(%esp)
  800efa:	ff d2                	call   *%edx
  800efc:	eb 05                	jmp    800f03 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800efe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800f03:	83 c4 24             	add    $0x24,%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 24             	sub    $0x24,%esp
  800f10:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f13:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f16:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 04 24             	mov    %eax,(%esp)
  800f20:	e8 09 fb ff ff       	call   800a2e <fd_lookup>
  800f25:	85 c0                	test   %eax,%eax
  800f27:	78 52                	js     800f7b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f33:	8b 00                	mov    (%eax),%eax
  800f35:	89 04 24             	mov    %eax,(%esp)
  800f38:	e8 42 fb ff ff       	call   800a7f <dev_lookup>
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	78 3a                	js     800f7b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  800f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f44:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800f48:	74 2c                	je     800f76 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800f4a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800f4d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800f54:	00 00 00 
	stat->st_isdir = 0;
  800f57:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800f5e:	00 00 00 
	stat->st_dev = dev;
  800f61:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800f67:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800f6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f6e:	89 14 24             	mov    %edx,(%esp)
  800f71:	ff 50 14             	call   *0x14(%eax)
  800f74:	eb 05                	jmp    800f7b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800f76:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800f7b:	83 c4 24             	add    $0x24,%esp
  800f7e:	5b                   	pop    %ebx
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    

00800f81 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 18             	sub    $0x18,%esp
  800f87:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800f8a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800f94:	00 
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	89 04 24             	mov    %eax,(%esp)
  800f9b:	e8 bc 01 00 00       	call   80115c <open>
  800fa0:	89 c3                	mov    %eax,%ebx
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	78 1b                	js     800fc1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fad:	89 1c 24             	mov    %ebx,(%esp)
  800fb0:	e8 54 ff ff ff       	call   800f09 <fstat>
  800fb5:	89 c6                	mov    %eax,%esi
	close(fd);
  800fb7:	89 1c 24             	mov    %ebx,(%esp)
  800fba:	e8 be fb ff ff       	call   800b7d <close>
	return r;
  800fbf:	89 f3                	mov    %esi,%ebx
}
  800fc1:	89 d8                	mov    %ebx,%eax
  800fc3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800fc6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800fc9:	89 ec                	mov    %ebp,%esp
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    
  800fcd:	00 00                	add    %al,(%eax)
	...

00800fd0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 18             	sub    $0x18,%esp
  800fd6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800fd9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800fdc:	89 c3                	mov    %eax,%ebx
  800fde:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  800fe0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800fe7:	75 11                	jne    800ffa <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800fe9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800ff0:	e8 31 0f 00 00       	call   801f26 <ipc_find_env>
  800ff5:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ffa:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801001:	00 
  801002:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801009:	00 
  80100a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80100e:	a1 00 40 80 00       	mov    0x804000,%eax
  801013:	89 04 24             	mov    %eax,(%esp)
  801016:	e8 87 0e 00 00       	call   801ea2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80101b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801022:	00 
  801023:	89 74 24 04          	mov    %esi,0x4(%esp)
  801027:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80102e:	e8 1d 0e 00 00       	call   801e50 <ipc_recv>
}
  801033:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801036:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801039:	89 ec                	mov    %ebp,%esp
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	53                   	push   %ebx
  801041:	83 ec 14             	sub    $0x14,%esp
  801044:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	8b 40 0c             	mov    0xc(%eax),%eax
  80104d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801052:	ba 00 00 00 00       	mov    $0x0,%edx
  801057:	b8 05 00 00 00       	mov    $0x5,%eax
  80105c:	e8 6f ff ff ff       	call   800fd0 <fsipc>
  801061:	85 c0                	test   %eax,%eax
  801063:	78 2b                	js     801090 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801065:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80106c:	00 
  80106d:	89 1c 24             	mov    %ebx,(%esp)
  801070:	e8 46 f1 ff ff       	call   8001bb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801075:	a1 80 50 80 00       	mov    0x805080,%eax
  80107a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801080:	a1 84 50 80 00       	mov    0x805084,%eax
  801085:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80108b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801090:	83 c4 14             	add    $0x14,%esp
  801093:	5b                   	pop    %ebx
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    

00801096 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8b 40 0c             	mov    0xc(%eax),%eax
  8010a2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8010a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ac:	b8 06 00 00 00       	mov    $0x6,%eax
  8010b1:	e8 1a ff ff ff       	call   800fd0 <fsipc>
}
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    

008010b8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	56                   	push   %esi
  8010bc:	53                   	push   %ebx
  8010bd:	83 ec 10             	sub    $0x10,%esp
  8010c0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8010c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8010ce:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8010d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d9:	b8 03 00 00 00       	mov    $0x3,%eax
  8010de:	e8 ed fe ff ff       	call   800fd0 <fsipc>
  8010e3:	89 c3                	mov    %eax,%ebx
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	78 6a                	js     801153 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8010e9:	39 c6                	cmp    %eax,%esi
  8010eb:	73 24                	jae    801111 <devfile_read+0x59>
  8010ed:	c7 44 24 0c 28 23 80 	movl   $0x802328,0xc(%esp)
  8010f4:	00 
  8010f5:	c7 44 24 08 2f 23 80 	movl   $0x80232f,0x8(%esp)
  8010fc:	00 
  8010fd:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801104:	00 
  801105:	c7 04 24 44 23 80 00 	movl   $0x802344,(%esp)
  80110c:	e8 6f 06 00 00       	call   801780 <_panic>
	assert(r <= PGSIZE);
  801111:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801116:	7e 24                	jle    80113c <devfile_read+0x84>
  801118:	c7 44 24 0c 4f 23 80 	movl   $0x80234f,0xc(%esp)
  80111f:	00 
  801120:	c7 44 24 08 2f 23 80 	movl   $0x80232f,0x8(%esp)
  801127:	00 
  801128:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80112f:	00 
  801130:	c7 04 24 44 23 80 00 	movl   $0x802344,(%esp)
  801137:	e8 44 06 00 00       	call   801780 <_panic>
	memmove(buf, &fsipcbuf, r);
  80113c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801140:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801147:	00 
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	89 04 24             	mov    %eax,(%esp)
  80114e:	e8 59 f2 ff ff       	call   8003ac <memmove>
	return r;
}
  801153:	89 d8                	mov    %ebx,%eax
  801155:	83 c4 10             	add    $0x10,%esp
  801158:	5b                   	pop    %ebx
  801159:	5e                   	pop    %esi
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    

0080115c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	56                   	push   %esi
  801160:	53                   	push   %ebx
  801161:	83 ec 20             	sub    $0x20,%esp
  801164:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801167:	89 34 24             	mov    %esi,(%esp)
  80116a:	e8 01 f0 ff ff       	call   800170 <strlen>
		return -E_BAD_PATH;
  80116f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801174:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801179:	7f 5e                	jg     8011d9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80117b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80117e:	89 04 24             	mov    %eax,(%esp)
  801181:	e8 35 f8 ff ff       	call   8009bb <fd_alloc>
  801186:	89 c3                	mov    %eax,%ebx
  801188:	85 c0                	test   %eax,%eax
  80118a:	78 4d                	js     8011d9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80118c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801190:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801197:	e8 1f f0 ff ff       	call   8001bb <strcpy>
	fsipcbuf.open.req_omode = mode;
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8011a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8011ac:	e8 1f fe ff ff       	call   800fd0 <fsipc>
  8011b1:	89 c3                	mov    %eax,%ebx
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	79 15                	jns    8011cc <open+0x70>
		fd_close(fd, 0);
  8011b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8011be:	00 
  8011bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c2:	89 04 24             	mov    %eax,(%esp)
  8011c5:	e8 21 f9 ff ff       	call   800aeb <fd_close>
		return r;
  8011ca:	eb 0d                	jmp    8011d9 <open+0x7d>
	}

	return fd2num(fd);
  8011cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011cf:	89 04 24             	mov    %eax,(%esp)
  8011d2:	e8 b9 f7 ff ff       	call   800990 <fd2num>
  8011d7:	89 c3                	mov    %eax,%ebx
}
  8011d9:	89 d8                	mov    %ebx,%eax
  8011db:	83 c4 20             	add    $0x20,%esp
  8011de:	5b                   	pop    %ebx
  8011df:	5e                   	pop    %esi
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    
	...

008011f0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	83 ec 18             	sub    $0x18,%esp
  8011f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8011f9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8011fc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	89 04 24             	mov    %eax,(%esp)
  801205:	e8 96 f7 ff ff       	call   8009a0 <fd2data>
  80120a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80120c:	c7 44 24 04 5b 23 80 	movl   $0x80235b,0x4(%esp)
  801213:	00 
  801214:	89 34 24             	mov    %esi,(%esp)
  801217:	e8 9f ef ff ff       	call   8001bb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80121c:	8b 43 04             	mov    0x4(%ebx),%eax
  80121f:	2b 03                	sub    (%ebx),%eax
  801221:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801227:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80122e:	00 00 00 
	stat->st_dev = &devpipe;
  801231:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801238:	30 80 00 
	return 0;
}
  80123b:	b8 00 00 00 00       	mov    $0x0,%eax
  801240:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801243:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801246:	89 ec                	mov    %ebp,%esp
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    

0080124a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	53                   	push   %ebx
  80124e:	83 ec 14             	sub    $0x14,%esp
  801251:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801254:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801258:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80125f:	e8 15 f5 ff ff       	call   800779 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801264:	89 1c 24             	mov    %ebx,(%esp)
  801267:	e8 34 f7 ff ff       	call   8009a0 <fd2data>
  80126c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801277:	e8 fd f4 ff ff       	call   800779 <sys_page_unmap>
}
  80127c:	83 c4 14             	add    $0x14,%esp
  80127f:	5b                   	pop    %ebx
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    

00801282 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	57                   	push   %edi
  801286:	56                   	push   %esi
  801287:	53                   	push   %ebx
  801288:	83 ec 2c             	sub    $0x2c,%esp
  80128b:	89 c7                	mov    %eax,%edi
  80128d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801290:	a1 04 40 80 00       	mov    0x804004,%eax
  801295:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801298:	89 3c 24             	mov    %edi,(%esp)
  80129b:	e8 d0 0c 00 00       	call   801f70 <pageref>
  8012a0:	89 c6                	mov    %eax,%esi
  8012a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a5:	89 04 24             	mov    %eax,(%esp)
  8012a8:	e8 c3 0c 00 00       	call   801f70 <pageref>
  8012ad:	39 c6                	cmp    %eax,%esi
  8012af:	0f 94 c0             	sete   %al
  8012b2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8012b5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8012bb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8012be:	39 cb                	cmp    %ecx,%ebx
  8012c0:	75 08                	jne    8012ca <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8012c2:	83 c4 2c             	add    $0x2c,%esp
  8012c5:	5b                   	pop    %ebx
  8012c6:	5e                   	pop    %esi
  8012c7:	5f                   	pop    %edi
  8012c8:	5d                   	pop    %ebp
  8012c9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8012ca:	83 f8 01             	cmp    $0x1,%eax
  8012cd:	75 c1                	jne    801290 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8012cf:	8b 52 58             	mov    0x58(%edx),%edx
  8012d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012d6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8012da:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012de:	c7 04 24 62 23 80 00 	movl   $0x802362,(%esp)
  8012e5:	e8 91 05 00 00       	call   80187b <cprintf>
  8012ea:	eb a4                	jmp    801290 <_pipeisclosed+0xe>

008012ec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	57                   	push   %edi
  8012f0:	56                   	push   %esi
  8012f1:	53                   	push   %ebx
  8012f2:	83 ec 2c             	sub    $0x2c,%esp
  8012f5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8012f8:	89 34 24             	mov    %esi,(%esp)
  8012fb:	e8 a0 f6 ff ff       	call   8009a0 <fd2data>
  801300:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801302:	bf 00 00 00 00       	mov    $0x0,%edi
  801307:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80130b:	75 50                	jne    80135d <devpipe_write+0x71>
  80130d:	eb 5c                	jmp    80136b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80130f:	89 da                	mov    %ebx,%edx
  801311:	89 f0                	mov    %esi,%eax
  801313:	e8 6a ff ff ff       	call   801282 <_pipeisclosed>
  801318:	85 c0                	test   %eax,%eax
  80131a:	75 53                	jne    80136f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80131c:	e8 6b f3 ff ff       	call   80068c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801321:	8b 43 04             	mov    0x4(%ebx),%eax
  801324:	8b 13                	mov    (%ebx),%edx
  801326:	83 c2 20             	add    $0x20,%edx
  801329:	39 d0                	cmp    %edx,%eax
  80132b:	73 e2                	jae    80130f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80132d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801330:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801334:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801337:	89 c2                	mov    %eax,%edx
  801339:	c1 fa 1f             	sar    $0x1f,%edx
  80133c:	c1 ea 1b             	shr    $0x1b,%edx
  80133f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801342:	83 e1 1f             	and    $0x1f,%ecx
  801345:	29 d1                	sub    %edx,%ecx
  801347:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80134b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  80134f:	83 c0 01             	add    $0x1,%eax
  801352:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801355:	83 c7 01             	add    $0x1,%edi
  801358:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80135b:	74 0e                	je     80136b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80135d:	8b 43 04             	mov    0x4(%ebx),%eax
  801360:	8b 13                	mov    (%ebx),%edx
  801362:	83 c2 20             	add    $0x20,%edx
  801365:	39 d0                	cmp    %edx,%eax
  801367:	73 a6                	jae    80130f <devpipe_write+0x23>
  801369:	eb c2                	jmp    80132d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80136b:	89 f8                	mov    %edi,%eax
  80136d:	eb 05                	jmp    801374 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801374:	83 c4 2c             	add    $0x2c,%esp
  801377:	5b                   	pop    %ebx
  801378:	5e                   	pop    %esi
  801379:	5f                   	pop    %edi
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    

0080137c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 28             	sub    $0x28,%esp
  801382:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801385:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801388:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80138b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80138e:	89 3c 24             	mov    %edi,(%esp)
  801391:	e8 0a f6 ff ff       	call   8009a0 <fd2data>
  801396:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801398:	be 00 00 00 00       	mov    $0x0,%esi
  80139d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a1:	75 47                	jne    8013ea <devpipe_read+0x6e>
  8013a3:	eb 52                	jmp    8013f7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8013a5:	89 f0                	mov    %esi,%eax
  8013a7:	eb 5e                	jmp    801407 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8013a9:	89 da                	mov    %ebx,%edx
  8013ab:	89 f8                	mov    %edi,%eax
  8013ad:	8d 76 00             	lea    0x0(%esi),%esi
  8013b0:	e8 cd fe ff ff       	call   801282 <_pipeisclosed>
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	75 49                	jne    801402 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8013b9:	e8 ce f2 ff ff       	call   80068c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8013be:	8b 03                	mov    (%ebx),%eax
  8013c0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8013c3:	74 e4                	je     8013a9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8013c5:	89 c2                	mov    %eax,%edx
  8013c7:	c1 fa 1f             	sar    $0x1f,%edx
  8013ca:	c1 ea 1b             	shr    $0x1b,%edx
  8013cd:	01 d0                	add    %edx,%eax
  8013cf:	83 e0 1f             	and    $0x1f,%eax
  8013d2:	29 d0                	sub    %edx,%eax
  8013d4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8013d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013dc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8013df:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8013e2:	83 c6 01             	add    $0x1,%esi
  8013e5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013e8:	74 0d                	je     8013f7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8013ea:	8b 03                	mov    (%ebx),%eax
  8013ec:	3b 43 04             	cmp    0x4(%ebx),%eax
  8013ef:	75 d4                	jne    8013c5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8013f1:	85 f6                	test   %esi,%esi
  8013f3:	75 b0                	jne    8013a5 <devpipe_read+0x29>
  8013f5:	eb b2                	jmp    8013a9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8013f7:	89 f0                	mov    %esi,%eax
  8013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801400:	eb 05                	jmp    801407 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801402:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801407:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80140a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80140d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801410:	89 ec                	mov    %ebp,%esp
  801412:	5d                   	pop    %ebp
  801413:	c3                   	ret    

00801414 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 48             	sub    $0x48,%esp
  80141a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80141d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801420:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801423:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801426:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801429:	89 04 24             	mov    %eax,(%esp)
  80142c:	e8 8a f5 ff ff       	call   8009bb <fd_alloc>
  801431:	89 c3                	mov    %eax,%ebx
  801433:	85 c0                	test   %eax,%eax
  801435:	0f 88 45 01 00 00    	js     801580 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80143b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801442:	00 
  801443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801446:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801451:	e8 66 f2 ff ff       	call   8006bc <sys_page_alloc>
  801456:	89 c3                	mov    %eax,%ebx
  801458:	85 c0                	test   %eax,%eax
  80145a:	0f 88 20 01 00 00    	js     801580 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801460:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801463:	89 04 24             	mov    %eax,(%esp)
  801466:	e8 50 f5 ff ff       	call   8009bb <fd_alloc>
  80146b:	89 c3                	mov    %eax,%ebx
  80146d:	85 c0                	test   %eax,%eax
  80146f:	0f 88 f8 00 00 00    	js     80156d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801475:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80147c:	00 
  80147d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801480:	89 44 24 04          	mov    %eax,0x4(%esp)
  801484:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80148b:	e8 2c f2 ff ff       	call   8006bc <sys_page_alloc>
  801490:	89 c3                	mov    %eax,%ebx
  801492:	85 c0                	test   %eax,%eax
  801494:	0f 88 d3 00 00 00    	js     80156d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80149a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80149d:	89 04 24             	mov    %eax,(%esp)
  8014a0:	e8 fb f4 ff ff       	call   8009a0 <fd2data>
  8014a5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014a7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8014ae:	00 
  8014af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014ba:	e8 fd f1 ff ff       	call   8006bc <sys_page_alloc>
  8014bf:	89 c3                	mov    %eax,%ebx
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	0f 88 91 00 00 00    	js     80155a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014cc:	89 04 24             	mov    %eax,(%esp)
  8014cf:	e8 cc f4 ff ff       	call   8009a0 <fd2data>
  8014d4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8014db:	00 
  8014dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014e7:	00 
  8014e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014f3:	e8 23 f2 ff ff       	call   80071b <sys_page_map>
  8014f8:	89 c3                	mov    %eax,%ebx
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	78 4c                	js     80154a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8014fe:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801507:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80150c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801513:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801519:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80151e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801521:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80152b:	89 04 24             	mov    %eax,(%esp)
  80152e:	e8 5d f4 ff ff       	call   800990 <fd2num>
  801533:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801535:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801538:	89 04 24             	mov    %eax,(%esp)
  80153b:	e8 50 f4 ff ff       	call   800990 <fd2num>
  801540:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801543:	bb 00 00 00 00       	mov    $0x0,%ebx
  801548:	eb 36                	jmp    801580 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80154a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80154e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801555:	e8 1f f2 ff ff       	call   800779 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80155a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801561:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801568:	e8 0c f2 ff ff       	call   800779 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80156d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801570:	89 44 24 04          	mov    %eax,0x4(%esp)
  801574:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80157b:	e8 f9 f1 ff ff       	call   800779 <sys_page_unmap>
    err:
	return r;
}
  801580:	89 d8                	mov    %ebx,%eax
  801582:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801585:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801588:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80158b:	89 ec                	mov    %ebp,%esp
  80158d:	5d                   	pop    %ebp
  80158e:	c3                   	ret    

0080158f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801595:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801598:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	89 04 24             	mov    %eax,(%esp)
  8015a2:	e8 87 f4 ff ff       	call   800a2e <fd_lookup>
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	78 15                	js     8015c0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8015ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ae:	89 04 24             	mov    %eax,(%esp)
  8015b1:	e8 ea f3 ff ff       	call   8009a0 <fd2data>
	return _pipeisclosed(fd, p);
  8015b6:	89 c2                	mov    %eax,%edx
  8015b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bb:	e8 c2 fc ff ff       	call   801282 <_pipeisclosed>
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    
	...

008015d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8015d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d8:	5d                   	pop    %ebp
  8015d9:	c3                   	ret    

008015da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8015e0:	c7 44 24 04 7a 23 80 	movl   $0x80237a,0x4(%esp)
  8015e7:	00 
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	89 04 24             	mov    %eax,(%esp)
  8015ee:	e8 c8 eb ff ff       	call   8001bb <strcpy>
	return 0;
}
  8015f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	57                   	push   %edi
  8015fe:	56                   	push   %esi
  8015ff:	53                   	push   %ebx
  801600:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801606:	be 00 00 00 00       	mov    $0x0,%esi
  80160b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80160f:	74 43                	je     801654 <devcons_write+0x5a>
  801611:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801616:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80161c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80161f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801621:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801624:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801629:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80162c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801630:	03 45 0c             	add    0xc(%ebp),%eax
  801633:	89 44 24 04          	mov    %eax,0x4(%esp)
  801637:	89 3c 24             	mov    %edi,(%esp)
  80163a:	e8 6d ed ff ff       	call   8003ac <memmove>
		sys_cputs(buf, m);
  80163f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801643:	89 3c 24             	mov    %edi,(%esp)
  801646:	e8 55 ef ff ff       	call   8005a0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80164b:	01 de                	add    %ebx,%esi
  80164d:	89 f0                	mov    %esi,%eax
  80164f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801652:	72 c8                	jb     80161c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801654:	89 f0                	mov    %esi,%eax
  801656:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5f                   	pop    %edi
  80165f:	5d                   	pop    %ebp
  801660:	c3                   	ret    

00801661 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801667:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80166c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801670:	75 07                	jne    801679 <devcons_read+0x18>
  801672:	eb 31                	jmp    8016a5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801674:	e8 13 f0 ff ff       	call   80068c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801680:	e8 4a ef ff ff       	call   8005cf <sys_cgetc>
  801685:	85 c0                	test   %eax,%eax
  801687:	74 eb                	je     801674 <devcons_read+0x13>
  801689:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80168b:	85 c0                	test   %eax,%eax
  80168d:	78 16                	js     8016a5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80168f:	83 f8 04             	cmp    $0x4,%eax
  801692:	74 0c                	je     8016a0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801694:	8b 45 0c             	mov    0xc(%ebp),%eax
  801697:	88 10                	mov    %dl,(%eax)
	return 1;
  801699:	b8 01 00 00 00       	mov    $0x1,%eax
  80169e:	eb 05                	jmp    8016a5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8016b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016ba:	00 
  8016bb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8016be:	89 04 24             	mov    %eax,(%esp)
  8016c1:	e8 da ee ff ff       	call   8005a0 <sys_cputs>
}
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <getchar>:

int
getchar(void)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8016ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8016d5:	00 
  8016d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8016d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e4:	e8 05 f6 ff ff       	call   800cee <read>
	if (r < 0)
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	78 0f                	js     8016fc <getchar+0x34>
		return r;
	if (r < 1)
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	7e 06                	jle    8016f7 <getchar+0x2f>
		return -E_EOF;
	return c;
  8016f1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8016f5:	eb 05                	jmp    8016fc <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8016f7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801704:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801707:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	89 04 24             	mov    %eax,(%esp)
  801711:	e8 18 f3 ff ff       	call   800a2e <fd_lookup>
  801716:	85 c0                	test   %eax,%eax
  801718:	78 11                	js     80172b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80171a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801723:	39 10                	cmp    %edx,(%eax)
  801725:	0f 94 c0             	sete   %al
  801728:	0f b6 c0             	movzbl %al,%eax
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <opencons>:

int
opencons(void)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801733:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801736:	89 04 24             	mov    %eax,(%esp)
  801739:	e8 7d f2 ff ff       	call   8009bb <fd_alloc>
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 3c                	js     80177e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801742:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801749:	00 
  80174a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801751:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801758:	e8 5f ef ff ff       	call   8006bc <sys_page_alloc>
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 1d                	js     80177e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801761:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801776:	89 04 24             	mov    %eax,(%esp)
  801779:	e8 12 f2 ff ff       	call   800990 <fd2num>
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	56                   	push   %esi
  801784:	53                   	push   %ebx
  801785:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801788:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80178b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801791:	e8 c6 ee ff ff       	call   80065c <sys_getenvid>
  801796:	8b 55 0c             	mov    0xc(%ebp),%edx
  801799:	89 54 24 10          	mov    %edx,0x10(%esp)
  80179d:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8017a4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ac:	c7 04 24 88 23 80 00 	movl   $0x802388,(%esp)
  8017b3:	e8 c3 00 00 00       	call   80187b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bf:	89 04 24             	mov    %eax,(%esp)
  8017c2:	e8 53 00 00 00       	call   80181a <vcprintf>
	cprintf("\n");
  8017c7:	c7 04 24 73 23 80 00 	movl   $0x802373,(%esp)
  8017ce:	e8 a8 00 00 00       	call   80187b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8017d3:	cc                   	int3   
  8017d4:	eb fd                	jmp    8017d3 <_panic+0x53>
	...

008017d8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	53                   	push   %ebx
  8017dc:	83 ec 14             	sub    $0x14,%esp
  8017df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8017e2:	8b 03                	mov    (%ebx),%eax
  8017e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e7:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8017eb:	83 c0 01             	add    $0x1,%eax
  8017ee:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8017f0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017f5:	75 19                	jne    801810 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8017f7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8017fe:	00 
  8017ff:	8d 43 08             	lea    0x8(%ebx),%eax
  801802:	89 04 24             	mov    %eax,(%esp)
  801805:	e8 96 ed ff ff       	call   8005a0 <sys_cputs>
		b->idx = 0;
  80180a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801810:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801814:	83 c4 14             	add    $0x14,%esp
  801817:	5b                   	pop    %ebx
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    

0080181a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801823:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80182a:	00 00 00 
	b.cnt = 0;
  80182d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801834:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	89 44 24 08          	mov    %eax,0x8(%esp)
  801845:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80184b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184f:	c7 04 24 d8 17 80 00 	movl   $0x8017d8,(%esp)
  801856:	e8 9f 01 00 00       	call   8019fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80185b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801861:	89 44 24 04          	mov    %eax,0x4(%esp)
  801865:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80186b:	89 04 24             	mov    %eax,(%esp)
  80186e:	e8 2d ed ff ff       	call   8005a0 <sys_cputs>

	return b.cnt;
}
  801873:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801881:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801884:	89 44 24 04          	mov    %eax,0x4(%esp)
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	89 04 24             	mov    %eax,(%esp)
  80188e:	e8 87 ff ff ff       	call   80181a <vcprintf>
	va_end(ap);

	return cnt;
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    
	...

008018a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	57                   	push   %edi
  8018a4:	56                   	push   %esi
  8018a5:	53                   	push   %ebx
  8018a6:	83 ec 3c             	sub    $0x3c,%esp
  8018a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018ac:	89 d7                	mov    %edx,%edi
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018bd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8018c8:	72 11                	jb     8018db <printnum+0x3b>
  8018ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018cd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8018d0:	76 09                	jbe    8018db <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8018d2:	83 eb 01             	sub    $0x1,%ebx
  8018d5:	85 db                	test   %ebx,%ebx
  8018d7:	7f 51                	jg     80192a <printnum+0x8a>
  8018d9:	eb 5e                	jmp    801939 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018db:	89 74 24 10          	mov    %esi,0x10(%esp)
  8018df:	83 eb 01             	sub    $0x1,%ebx
  8018e2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8018e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018ed:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8018f1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8018f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018fc:	00 
  8018fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801900:	89 04 24             	mov    %eax,(%esp)
  801903:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801906:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190a:	e8 a1 06 00 00       	call   801fb0 <__udivdi3>
  80190f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801913:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801917:	89 04 24             	mov    %eax,(%esp)
  80191a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80191e:	89 fa                	mov    %edi,%edx
  801920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801923:	e8 78 ff ff ff       	call   8018a0 <printnum>
  801928:	eb 0f                	jmp    801939 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80192a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80192e:	89 34 24             	mov    %esi,(%esp)
  801931:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801934:	83 eb 01             	sub    $0x1,%ebx
  801937:	75 f1                	jne    80192a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801939:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80193d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801941:	8b 45 10             	mov    0x10(%ebp),%eax
  801944:	89 44 24 08          	mov    %eax,0x8(%esp)
  801948:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80194f:	00 
  801950:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801953:	89 04 24             	mov    %eax,(%esp)
  801956:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801959:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195d:	e8 7e 07 00 00       	call   8020e0 <__umoddi3>
  801962:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801966:	0f be 80 ab 23 80 00 	movsbl 0x8023ab(%eax),%eax
  80196d:	89 04 24             	mov    %eax,(%esp)
  801970:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801973:	83 c4 3c             	add    $0x3c,%esp
  801976:	5b                   	pop    %ebx
  801977:	5e                   	pop    %esi
  801978:	5f                   	pop    %edi
  801979:	5d                   	pop    %ebp
  80197a:	c3                   	ret    

0080197b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80197e:	83 fa 01             	cmp    $0x1,%edx
  801981:	7e 0e                	jle    801991 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801983:	8b 10                	mov    (%eax),%edx
  801985:	8d 4a 08             	lea    0x8(%edx),%ecx
  801988:	89 08                	mov    %ecx,(%eax)
  80198a:	8b 02                	mov    (%edx),%eax
  80198c:	8b 52 04             	mov    0x4(%edx),%edx
  80198f:	eb 22                	jmp    8019b3 <getuint+0x38>
	else if (lflag)
  801991:	85 d2                	test   %edx,%edx
  801993:	74 10                	je     8019a5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801995:	8b 10                	mov    (%eax),%edx
  801997:	8d 4a 04             	lea    0x4(%edx),%ecx
  80199a:	89 08                	mov    %ecx,(%eax)
  80199c:	8b 02                	mov    (%edx),%eax
  80199e:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a3:	eb 0e                	jmp    8019b3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8019a5:	8b 10                	mov    (%eax),%edx
  8019a7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8019aa:	89 08                	mov    %ecx,(%eax)
  8019ac:	8b 02                	mov    (%edx),%eax
  8019ae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019b3:	5d                   	pop    %ebp
  8019b4:	c3                   	ret    

008019b5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8019bb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8019bf:	8b 10                	mov    (%eax),%edx
  8019c1:	3b 50 04             	cmp    0x4(%eax),%edx
  8019c4:	73 0a                	jae    8019d0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8019c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c9:	88 0a                	mov    %cl,(%edx)
  8019cb:	83 c2 01             	add    $0x1,%edx
  8019ce:	89 10                	mov    %edx,(%eax)
}
  8019d0:	5d                   	pop    %ebp
  8019d1:	c3                   	ret    

008019d2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8019d8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8019db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019df:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	89 04 24             	mov    %eax,(%esp)
  8019f3:	e8 02 00 00 00       	call   8019fa <vprintfmt>
	va_end(ap);
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	57                   	push   %edi
  8019fe:	56                   	push   %esi
  8019ff:	53                   	push   %ebx
  801a00:	83 ec 4c             	sub    $0x4c,%esp
  801a03:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a06:	8b 75 10             	mov    0x10(%ebp),%esi
  801a09:	eb 12                	jmp    801a1d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	0f 84 a9 03 00 00    	je     801dbc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  801a13:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a17:	89 04 24             	mov    %eax,(%esp)
  801a1a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a1d:	0f b6 06             	movzbl (%esi),%eax
  801a20:	83 c6 01             	add    $0x1,%esi
  801a23:	83 f8 25             	cmp    $0x25,%eax
  801a26:	75 e3                	jne    801a0b <vprintfmt+0x11>
  801a28:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801a2c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801a33:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  801a38:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801a3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a44:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801a47:	eb 2b                	jmp    801a74 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a49:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801a4c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801a50:	eb 22                	jmp    801a74 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a52:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801a55:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801a59:	eb 19                	jmp    801a74 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a5b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  801a5e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801a65:	eb 0d                	jmp    801a74 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801a67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a6d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a74:	0f b6 06             	movzbl (%esi),%eax
  801a77:	0f b6 d0             	movzbl %al,%edx
  801a7a:	8d 7e 01             	lea    0x1(%esi),%edi
  801a7d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  801a80:	83 e8 23             	sub    $0x23,%eax
  801a83:	3c 55                	cmp    $0x55,%al
  801a85:	0f 87 0b 03 00 00    	ja     801d96 <vprintfmt+0x39c>
  801a8b:	0f b6 c0             	movzbl %al,%eax
  801a8e:	ff 24 85 e0 24 80 00 	jmp    *0x8024e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801a95:	83 ea 30             	sub    $0x30,%edx
  801a98:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  801a9b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  801a9f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aa2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  801aa5:	83 fa 09             	cmp    $0x9,%edx
  801aa8:	77 4a                	ja     801af4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aaa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801aad:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  801ab0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  801ab3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  801ab7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801aba:	8d 50 d0             	lea    -0x30(%eax),%edx
  801abd:	83 fa 09             	cmp    $0x9,%edx
  801ac0:	76 eb                	jbe    801aad <vprintfmt+0xb3>
  801ac2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801ac5:	eb 2d                	jmp    801af4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801ac7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aca:	8d 50 04             	lea    0x4(%eax),%edx
  801acd:	89 55 14             	mov    %edx,0x14(%ebp)
  801ad0:	8b 00                	mov    (%eax),%eax
  801ad2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ad5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801ad8:	eb 1a                	jmp    801af4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ada:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  801add:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ae1:	79 91                	jns    801a74 <vprintfmt+0x7a>
  801ae3:	e9 73 ff ff ff       	jmp    801a5b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ae8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801aeb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801af2:	eb 80                	jmp    801a74 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  801af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801af8:	0f 89 76 ff ff ff    	jns    801a74 <vprintfmt+0x7a>
  801afe:	e9 64 ff ff ff       	jmp    801a67 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b03:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b06:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801b09:	e9 66 ff ff ff       	jmp    801a74 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b11:	8d 50 04             	lea    0x4(%eax),%edx
  801b14:	89 55 14             	mov    %edx,0x14(%ebp)
  801b17:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b1b:	8b 00                	mov    (%eax),%eax
  801b1d:	89 04 24             	mov    %eax,(%esp)
  801b20:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b23:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801b26:	e9 f2 fe ff ff       	jmp    801a1d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2e:	8d 50 04             	lea    0x4(%eax),%edx
  801b31:	89 55 14             	mov    %edx,0x14(%ebp)
  801b34:	8b 00                	mov    (%eax),%eax
  801b36:	89 c2                	mov    %eax,%edx
  801b38:	c1 fa 1f             	sar    $0x1f,%edx
  801b3b:	31 d0                	xor    %edx,%eax
  801b3d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801b3f:	83 f8 0f             	cmp    $0xf,%eax
  801b42:	7f 0b                	jg     801b4f <vprintfmt+0x155>
  801b44:	8b 14 85 40 26 80 00 	mov    0x802640(,%eax,4),%edx
  801b4b:	85 d2                	test   %edx,%edx
  801b4d:	75 23                	jne    801b72 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  801b4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b53:	c7 44 24 08 c3 23 80 	movl   $0x8023c3,0x8(%esp)
  801b5a:	00 
  801b5b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b5f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b62:	89 3c 24             	mov    %edi,(%esp)
  801b65:	e8 68 fe ff ff       	call   8019d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b6a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801b6d:	e9 ab fe ff ff       	jmp    801a1d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  801b72:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801b76:	c7 44 24 08 41 23 80 	movl   $0x802341,0x8(%esp)
  801b7d:	00 
  801b7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b82:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b85:	89 3c 24             	mov    %edi,(%esp)
  801b88:	e8 45 fe ff ff       	call   8019d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b8d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  801b90:	e9 88 fe ff ff       	jmp    801a1d <vprintfmt+0x23>
  801b95:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801b98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b9b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801b9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba1:	8d 50 04             	lea    0x4(%eax),%edx
  801ba4:	89 55 14             	mov    %edx,0x14(%ebp)
  801ba7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801ba9:	85 f6                	test   %esi,%esi
  801bab:	ba bc 23 80 00       	mov    $0x8023bc,%edx
  801bb0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  801bb3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801bb7:	7e 06                	jle    801bbf <vprintfmt+0x1c5>
  801bb9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  801bbd:	75 10                	jne    801bcf <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801bbf:	0f be 06             	movsbl (%esi),%eax
  801bc2:	83 c6 01             	add    $0x1,%esi
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	0f 85 86 00 00 00    	jne    801c53 <vprintfmt+0x259>
  801bcd:	eb 76                	jmp    801c45 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bcf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bd3:	89 34 24             	mov    %esi,(%esp)
  801bd6:	e8 b0 e5 ff ff       	call   80018b <strnlen>
  801bdb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801bde:	29 c2                	sub    %eax,%edx
  801be0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801be3:	85 d2                	test   %edx,%edx
  801be5:	7e d8                	jle    801bbf <vprintfmt+0x1c5>
					putch(padc, putdat);
  801be7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  801beb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  801bee:	89 d6                	mov    %edx,%esi
  801bf0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  801bf3:	89 c7                	mov    %eax,%edi
  801bf5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bf9:	89 3c 24             	mov    %edi,(%esp)
  801bfc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bff:	83 ee 01             	sub    $0x1,%esi
  801c02:	75 f1                	jne    801bf5 <vprintfmt+0x1fb>
  801c04:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801c07:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  801c0a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  801c0d:	eb b0                	jmp    801bbf <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801c0f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c13:	74 18                	je     801c2d <vprintfmt+0x233>
  801c15:	8d 50 e0             	lea    -0x20(%eax),%edx
  801c18:	83 fa 5e             	cmp    $0x5e,%edx
  801c1b:	76 10                	jbe    801c2d <vprintfmt+0x233>
					putch('?', putdat);
  801c1d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c21:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801c28:	ff 55 08             	call   *0x8(%ebp)
  801c2b:	eb 0a                	jmp    801c37 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  801c2d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c31:	89 04 24             	mov    %eax,(%esp)
  801c34:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c37:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  801c3b:	0f be 06             	movsbl (%esi),%eax
  801c3e:	83 c6 01             	add    $0x1,%esi
  801c41:	85 c0                	test   %eax,%eax
  801c43:	75 0e                	jne    801c53 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c45:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c4c:	7f 16                	jg     801c64 <vprintfmt+0x26a>
  801c4e:	e9 ca fd ff ff       	jmp    801a1d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c53:	85 ff                	test   %edi,%edi
  801c55:	78 b8                	js     801c0f <vprintfmt+0x215>
  801c57:	83 ef 01             	sub    $0x1,%edi
  801c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c60:	79 ad                	jns    801c0f <vprintfmt+0x215>
  801c62:	eb e1                	jmp    801c45 <vprintfmt+0x24b>
  801c64:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801c67:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801c6a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c6e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801c75:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c77:	83 ee 01             	sub    $0x1,%esi
  801c7a:	75 ee                	jne    801c6a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c7c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  801c7f:	e9 99 fd ff ff       	jmp    801a1d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801c84:	83 f9 01             	cmp    $0x1,%ecx
  801c87:	7e 10                	jle    801c99 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  801c89:	8b 45 14             	mov    0x14(%ebp),%eax
  801c8c:	8d 50 08             	lea    0x8(%eax),%edx
  801c8f:	89 55 14             	mov    %edx,0x14(%ebp)
  801c92:	8b 30                	mov    (%eax),%esi
  801c94:	8b 78 04             	mov    0x4(%eax),%edi
  801c97:	eb 26                	jmp    801cbf <vprintfmt+0x2c5>
	else if (lflag)
  801c99:	85 c9                	test   %ecx,%ecx
  801c9b:	74 12                	je     801caf <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  801c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca0:	8d 50 04             	lea    0x4(%eax),%edx
  801ca3:	89 55 14             	mov    %edx,0x14(%ebp)
  801ca6:	8b 30                	mov    (%eax),%esi
  801ca8:	89 f7                	mov    %esi,%edi
  801caa:	c1 ff 1f             	sar    $0x1f,%edi
  801cad:	eb 10                	jmp    801cbf <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  801caf:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb2:	8d 50 04             	lea    0x4(%eax),%edx
  801cb5:	89 55 14             	mov    %edx,0x14(%ebp)
  801cb8:	8b 30                	mov    (%eax),%esi
  801cba:	89 f7                	mov    %esi,%edi
  801cbc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801cbf:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801cc4:	85 ff                	test   %edi,%edi
  801cc6:	0f 89 8c 00 00 00    	jns    801d58 <vprintfmt+0x35e>
				putch('-', putdat);
  801ccc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cd0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801cd7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801cda:	f7 de                	neg    %esi
  801cdc:	83 d7 00             	adc    $0x0,%edi
  801cdf:	f7 df                	neg    %edi
			}
			base = 10;
  801ce1:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ce6:	eb 70                	jmp    801d58 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801ce8:	89 ca                	mov    %ecx,%edx
  801cea:	8d 45 14             	lea    0x14(%ebp),%eax
  801ced:	e8 89 fc ff ff       	call   80197b <getuint>
  801cf2:	89 c6                	mov    %eax,%esi
  801cf4:	89 d7                	mov    %edx,%edi
			base = 10;
  801cf6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  801cfb:	eb 5b                	jmp    801d58 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  801cfd:	89 ca                	mov    %ecx,%edx
  801cff:	8d 45 14             	lea    0x14(%ebp),%eax
  801d02:	e8 74 fc ff ff       	call   80197b <getuint>
  801d07:	89 c6                	mov    %eax,%esi
  801d09:	89 d7                	mov    %edx,%edi
			base = 8;
  801d0b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  801d10:	eb 46                	jmp    801d58 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  801d12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d16:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801d1d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801d20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d24:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801d2b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801d2e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d31:	8d 50 04             	lea    0x4(%eax),%edx
  801d34:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d37:	8b 30                	mov    (%eax),%esi
  801d39:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801d3e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  801d43:	eb 13                	jmp    801d58 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d45:	89 ca                	mov    %ecx,%edx
  801d47:	8d 45 14             	lea    0x14(%ebp),%eax
  801d4a:	e8 2c fc ff ff       	call   80197b <getuint>
  801d4f:	89 c6                	mov    %eax,%esi
  801d51:	89 d7                	mov    %edx,%edi
			base = 16;
  801d53:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d58:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  801d5c:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d63:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d67:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d6b:	89 34 24             	mov    %esi,(%esp)
  801d6e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d72:	89 da                	mov    %ebx,%edx
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	e8 24 fb ff ff       	call   8018a0 <printnum>
			break;
  801d7c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  801d7f:	e9 99 fc ff ff       	jmp    801a1d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801d84:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d88:	89 14 24             	mov    %edx,(%esp)
  801d8b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801d8e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  801d91:	e9 87 fc ff ff       	jmp    801a1d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801d96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d9a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801da1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801da4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  801da8:	0f 84 6f fc ff ff    	je     801a1d <vprintfmt+0x23>
  801dae:	83 ee 01             	sub    $0x1,%esi
  801db1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  801db5:	75 f7                	jne    801dae <vprintfmt+0x3b4>
  801db7:	e9 61 fc ff ff       	jmp    801a1d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  801dbc:	83 c4 4c             	add    $0x4c,%esp
  801dbf:	5b                   	pop    %ebx
  801dc0:	5e                   	pop    %esi
  801dc1:	5f                   	pop    %edi
  801dc2:	5d                   	pop    %ebp
  801dc3:	c3                   	ret    

00801dc4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 28             	sub    $0x28,%esp
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801dd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801dd3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801dd7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801dda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801de1:	85 c0                	test   %eax,%eax
  801de3:	74 30                	je     801e15 <vsnprintf+0x51>
  801de5:	85 d2                	test   %edx,%edx
  801de7:	7e 2c                	jle    801e15 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801de9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801df0:	8b 45 10             	mov    0x10(%ebp),%eax
  801df3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801dfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfe:	c7 04 24 b5 19 80 00 	movl   $0x8019b5,(%esp)
  801e05:	e8 f0 fb ff ff       	call   8019fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e13:	eb 05                	jmp    801e1a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801e15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e22:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801e25:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e29:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	89 04 24             	mov    %eax,(%esp)
  801e3d:	e8 82 ff ff ff       	call   801dc4 <vsnprintf>
	va_end(ap);

	return rc;
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    
	...

00801e50 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	56                   	push   %esi
  801e54:	53                   	push   %ebx
  801e55:	83 ec 10             	sub    $0x10,%esp
  801e58:	8b 75 08             	mov    0x8(%ebp),%esi
  801e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801e61:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801e63:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e68:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801e6b:	89 04 24             	mov    %eax,(%esp)
  801e6e:	e8 b2 ea ff ff       	call   800925 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801e73:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801e78:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	78 0e                	js     801e8f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801e81:	a1 04 40 80 00       	mov    0x804004,%eax
  801e86:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801e89:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801e8c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801e8f:	85 f6                	test   %esi,%esi
  801e91:	74 02                	je     801e95 <ipc_recv+0x45>
		*from_env_store = sender;
  801e93:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801e95:	85 db                	test   %ebx,%ebx
  801e97:	74 02                	je     801e9b <ipc_recv+0x4b>
		*perm_store = perm;
  801e99:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	5b                   	pop    %ebx
  801e9f:	5e                   	pop    %esi
  801ea0:	5d                   	pop    %ebp
  801ea1:	c3                   	ret    

00801ea2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	57                   	push   %edi
  801ea6:	56                   	push   %esi
  801ea7:	53                   	push   %ebx
  801ea8:	83 ec 1c             	sub    $0x1c,%esp
  801eab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801eae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801eb1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801eb4:	85 db                	test   %ebx,%ebx
  801eb6:	75 04                	jne    801ebc <ipc_send+0x1a>
  801eb8:	85 f6                	test   %esi,%esi
  801eba:	75 15                	jne    801ed1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801ebc:	85 db                	test   %ebx,%ebx
  801ebe:	74 16                	je     801ed6 <ipc_send+0x34>
  801ec0:	85 f6                	test   %esi,%esi
  801ec2:	0f 94 c0             	sete   %al
      pg = 0;
  801ec5:	84 c0                	test   %al,%al
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecc:	0f 45 d8             	cmovne %eax,%ebx
  801ecf:	eb 05                	jmp    801ed6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801ed1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801ed6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801eda:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ede:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	89 04 24             	mov    %eax,(%esp)
  801ee8:	e8 04 ea ff ff       	call   8008f1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801eed:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ef0:	75 07                	jne    801ef9 <ipc_send+0x57>
           sys_yield();
  801ef2:	e8 95 e7 ff ff       	call   80068c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801ef7:	eb dd                	jmp    801ed6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	90                   	nop
  801efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f00:	74 1c                	je     801f1e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801f02:	c7 44 24 08 a0 26 80 	movl   $0x8026a0,0x8(%esp)
  801f09:	00 
  801f0a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801f11:	00 
  801f12:	c7 04 24 aa 26 80 00 	movl   $0x8026aa,(%esp)
  801f19:	e8 62 f8 ff ff       	call   801780 <_panic>
		}
    }
}
  801f1e:	83 c4 1c             	add    $0x1c,%esp
  801f21:	5b                   	pop    %ebx
  801f22:	5e                   	pop    %esi
  801f23:	5f                   	pop    %edi
  801f24:	5d                   	pop    %ebp
  801f25:	c3                   	ret    

00801f26 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801f2c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801f31:	39 c8                	cmp    %ecx,%eax
  801f33:	74 17                	je     801f4c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f35:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801f3a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f3d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f43:	8b 52 50             	mov    0x50(%edx),%edx
  801f46:	39 ca                	cmp    %ecx,%edx
  801f48:	75 14                	jne    801f5e <ipc_find_env+0x38>
  801f4a:	eb 05                	jmp    801f51 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f4c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801f51:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f54:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801f59:	8b 40 40             	mov    0x40(%eax),%eax
  801f5c:	eb 0e                	jmp    801f6c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f5e:	83 c0 01             	add    $0x1,%eax
  801f61:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f66:	75 d2                	jne    801f3a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801f68:	66 b8 00 00          	mov    $0x0,%ax
}
  801f6c:	5d                   	pop    %ebp
  801f6d:	c3                   	ret    
	...

00801f70 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f76:	89 d0                	mov    %edx,%eax
  801f78:	c1 e8 16             	shr    $0x16,%eax
  801f7b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f87:	f6 c1 01             	test   $0x1,%cl
  801f8a:	74 1d                	je     801fa9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f8c:	c1 ea 0c             	shr    $0xc,%edx
  801f8f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f96:	f6 c2 01             	test   $0x1,%dl
  801f99:	74 0e                	je     801fa9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f9b:	c1 ea 0c             	shr    $0xc,%edx
  801f9e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fa5:	ef 
  801fa6:	0f b7 c0             	movzwl %ax,%eax
}
  801fa9:	5d                   	pop    %ebp
  801faa:	c3                   	ret    
  801fab:	00 00                	add    %al,(%eax)
  801fad:	00 00                	add    %al,(%eax)
	...

00801fb0 <__udivdi3>:
  801fb0:	83 ec 1c             	sub    $0x1c,%esp
  801fb3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801fb7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801fbb:	8b 44 24 20          	mov    0x20(%esp),%eax
  801fbf:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801fc3:	89 74 24 10          	mov    %esi,0x10(%esp)
  801fc7:	8b 74 24 24          	mov    0x24(%esp),%esi
  801fcb:	85 ff                	test   %edi,%edi
  801fcd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801fd1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fd5:	89 cd                	mov    %ecx,%ebp
  801fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fdb:	75 33                	jne    802010 <__udivdi3+0x60>
  801fdd:	39 f1                	cmp    %esi,%ecx
  801fdf:	77 57                	ja     802038 <__udivdi3+0x88>
  801fe1:	85 c9                	test   %ecx,%ecx
  801fe3:	75 0b                	jne    801ff0 <__udivdi3+0x40>
  801fe5:	b8 01 00 00 00       	mov    $0x1,%eax
  801fea:	31 d2                	xor    %edx,%edx
  801fec:	f7 f1                	div    %ecx
  801fee:	89 c1                	mov    %eax,%ecx
  801ff0:	89 f0                	mov    %esi,%eax
  801ff2:	31 d2                	xor    %edx,%edx
  801ff4:	f7 f1                	div    %ecx
  801ff6:	89 c6                	mov    %eax,%esi
  801ff8:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ffc:	f7 f1                	div    %ecx
  801ffe:	89 f2                	mov    %esi,%edx
  802000:	8b 74 24 10          	mov    0x10(%esp),%esi
  802004:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802008:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80200c:	83 c4 1c             	add    $0x1c,%esp
  80200f:	c3                   	ret    
  802010:	31 d2                	xor    %edx,%edx
  802012:	31 c0                	xor    %eax,%eax
  802014:	39 f7                	cmp    %esi,%edi
  802016:	77 e8                	ja     802000 <__udivdi3+0x50>
  802018:	0f bd cf             	bsr    %edi,%ecx
  80201b:	83 f1 1f             	xor    $0x1f,%ecx
  80201e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802022:	75 2c                	jne    802050 <__udivdi3+0xa0>
  802024:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802028:	76 04                	jbe    80202e <__udivdi3+0x7e>
  80202a:	39 f7                	cmp    %esi,%edi
  80202c:	73 d2                	jae    802000 <__udivdi3+0x50>
  80202e:	31 d2                	xor    %edx,%edx
  802030:	b8 01 00 00 00       	mov    $0x1,%eax
  802035:	eb c9                	jmp    802000 <__udivdi3+0x50>
  802037:	90                   	nop
  802038:	89 f2                	mov    %esi,%edx
  80203a:	f7 f1                	div    %ecx
  80203c:	31 d2                	xor    %edx,%edx
  80203e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802042:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802046:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80204a:	83 c4 1c             	add    $0x1c,%esp
  80204d:	c3                   	ret    
  80204e:	66 90                	xchg   %ax,%ax
  802050:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802055:	b8 20 00 00 00       	mov    $0x20,%eax
  80205a:	89 ea                	mov    %ebp,%edx
  80205c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802060:	d3 e7                	shl    %cl,%edi
  802062:	89 c1                	mov    %eax,%ecx
  802064:	d3 ea                	shr    %cl,%edx
  802066:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80206b:	09 fa                	or     %edi,%edx
  80206d:	89 f7                	mov    %esi,%edi
  80206f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802073:	89 f2                	mov    %esi,%edx
  802075:	8b 74 24 08          	mov    0x8(%esp),%esi
  802079:	d3 e5                	shl    %cl,%ebp
  80207b:	89 c1                	mov    %eax,%ecx
  80207d:	d3 ef                	shr    %cl,%edi
  80207f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802084:	d3 e2                	shl    %cl,%edx
  802086:	89 c1                	mov    %eax,%ecx
  802088:	d3 ee                	shr    %cl,%esi
  80208a:	09 d6                	or     %edx,%esi
  80208c:	89 fa                	mov    %edi,%edx
  80208e:	89 f0                	mov    %esi,%eax
  802090:	f7 74 24 0c          	divl   0xc(%esp)
  802094:	89 d7                	mov    %edx,%edi
  802096:	89 c6                	mov    %eax,%esi
  802098:	f7 e5                	mul    %ebp
  80209a:	39 d7                	cmp    %edx,%edi
  80209c:	72 22                	jb     8020c0 <__udivdi3+0x110>
  80209e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8020a2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020a7:	d3 e5                	shl    %cl,%ebp
  8020a9:	39 c5                	cmp    %eax,%ebp
  8020ab:	73 04                	jae    8020b1 <__udivdi3+0x101>
  8020ad:	39 d7                	cmp    %edx,%edi
  8020af:	74 0f                	je     8020c0 <__udivdi3+0x110>
  8020b1:	89 f0                	mov    %esi,%eax
  8020b3:	31 d2                	xor    %edx,%edx
  8020b5:	e9 46 ff ff ff       	jmp    802000 <__udivdi3+0x50>
  8020ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020c0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8020c3:	31 d2                	xor    %edx,%edx
  8020c5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020c9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020cd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020d1:	83 c4 1c             	add    $0x1c,%esp
  8020d4:	c3                   	ret    
	...

008020e0 <__umoddi3>:
  8020e0:	83 ec 1c             	sub    $0x1c,%esp
  8020e3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8020e7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8020eb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8020ef:	89 74 24 10          	mov    %esi,0x10(%esp)
  8020f3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8020f7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8020fb:	85 ed                	test   %ebp,%ebp
  8020fd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802101:	89 44 24 08          	mov    %eax,0x8(%esp)
  802105:	89 cf                	mov    %ecx,%edi
  802107:	89 04 24             	mov    %eax,(%esp)
  80210a:	89 f2                	mov    %esi,%edx
  80210c:	75 1a                	jne    802128 <__umoddi3+0x48>
  80210e:	39 f1                	cmp    %esi,%ecx
  802110:	76 4e                	jbe    802160 <__umoddi3+0x80>
  802112:	f7 f1                	div    %ecx
  802114:	89 d0                	mov    %edx,%eax
  802116:	31 d2                	xor    %edx,%edx
  802118:	8b 74 24 10          	mov    0x10(%esp),%esi
  80211c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802120:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802124:	83 c4 1c             	add    $0x1c,%esp
  802127:	c3                   	ret    
  802128:	39 f5                	cmp    %esi,%ebp
  80212a:	77 54                	ja     802180 <__umoddi3+0xa0>
  80212c:	0f bd c5             	bsr    %ebp,%eax
  80212f:	83 f0 1f             	xor    $0x1f,%eax
  802132:	89 44 24 04          	mov    %eax,0x4(%esp)
  802136:	75 60                	jne    802198 <__umoddi3+0xb8>
  802138:	3b 0c 24             	cmp    (%esp),%ecx
  80213b:	0f 87 07 01 00 00    	ja     802248 <__umoddi3+0x168>
  802141:	89 f2                	mov    %esi,%edx
  802143:	8b 34 24             	mov    (%esp),%esi
  802146:	29 ce                	sub    %ecx,%esi
  802148:	19 ea                	sbb    %ebp,%edx
  80214a:	89 34 24             	mov    %esi,(%esp)
  80214d:	8b 04 24             	mov    (%esp),%eax
  802150:	8b 74 24 10          	mov    0x10(%esp),%esi
  802154:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802158:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80215c:	83 c4 1c             	add    $0x1c,%esp
  80215f:	c3                   	ret    
  802160:	85 c9                	test   %ecx,%ecx
  802162:	75 0b                	jne    80216f <__umoddi3+0x8f>
  802164:	b8 01 00 00 00       	mov    $0x1,%eax
  802169:	31 d2                	xor    %edx,%edx
  80216b:	f7 f1                	div    %ecx
  80216d:	89 c1                	mov    %eax,%ecx
  80216f:	89 f0                	mov    %esi,%eax
  802171:	31 d2                	xor    %edx,%edx
  802173:	f7 f1                	div    %ecx
  802175:	8b 04 24             	mov    (%esp),%eax
  802178:	f7 f1                	div    %ecx
  80217a:	eb 98                	jmp    802114 <__umoddi3+0x34>
  80217c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802180:	89 f2                	mov    %esi,%edx
  802182:	8b 74 24 10          	mov    0x10(%esp),%esi
  802186:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80218a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80218e:	83 c4 1c             	add    $0x1c,%esp
  802191:	c3                   	ret    
  802192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802198:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80219d:	89 e8                	mov    %ebp,%eax
  80219f:	bd 20 00 00 00       	mov    $0x20,%ebp
  8021a4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8021a8:	89 fa                	mov    %edi,%edx
  8021aa:	d3 e0                	shl    %cl,%eax
  8021ac:	89 e9                	mov    %ebp,%ecx
  8021ae:	d3 ea                	shr    %cl,%edx
  8021b0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021b5:	09 c2                	or     %eax,%edx
  8021b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021bb:	89 14 24             	mov    %edx,(%esp)
  8021be:	89 f2                	mov    %esi,%edx
  8021c0:	d3 e7                	shl    %cl,%edi
  8021c2:	89 e9                	mov    %ebp,%ecx
  8021c4:	d3 ea                	shr    %cl,%edx
  8021c6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021cf:	d3 e6                	shl    %cl,%esi
  8021d1:	89 e9                	mov    %ebp,%ecx
  8021d3:	d3 e8                	shr    %cl,%eax
  8021d5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021da:	09 f0                	or     %esi,%eax
  8021dc:	8b 74 24 08          	mov    0x8(%esp),%esi
  8021e0:	f7 34 24             	divl   (%esp)
  8021e3:	d3 e6                	shl    %cl,%esi
  8021e5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8021e9:	89 d6                	mov    %edx,%esi
  8021eb:	f7 e7                	mul    %edi
  8021ed:	39 d6                	cmp    %edx,%esi
  8021ef:	89 c1                	mov    %eax,%ecx
  8021f1:	89 d7                	mov    %edx,%edi
  8021f3:	72 3f                	jb     802234 <__umoddi3+0x154>
  8021f5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8021f9:	72 35                	jb     802230 <__umoddi3+0x150>
  8021fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021ff:	29 c8                	sub    %ecx,%eax
  802201:	19 fe                	sbb    %edi,%esi
  802203:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802208:	89 f2                	mov    %esi,%edx
  80220a:	d3 e8                	shr    %cl,%eax
  80220c:	89 e9                	mov    %ebp,%ecx
  80220e:	d3 e2                	shl    %cl,%edx
  802210:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802215:	09 d0                	or     %edx,%eax
  802217:	89 f2                	mov    %esi,%edx
  802219:	d3 ea                	shr    %cl,%edx
  80221b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80221f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802223:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802227:	83 c4 1c             	add    $0x1c,%esp
  80222a:	c3                   	ret    
  80222b:	90                   	nop
  80222c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802230:	39 d6                	cmp    %edx,%esi
  802232:	75 c7                	jne    8021fb <__umoddi3+0x11b>
  802234:	89 d7                	mov    %edx,%edi
  802236:	89 c1                	mov    %eax,%ecx
  802238:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80223c:	1b 3c 24             	sbb    (%esp),%edi
  80223f:	eb ba                	jmp    8021fb <__umoddi3+0x11b>
  802241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802248:	39 f5                	cmp    %esi,%ebp
  80224a:	0f 82 f1 fe ff ff    	jb     802141 <__umoddi3+0x61>
  802250:	e9 f8 fe ff ff       	jmp    80214d <__umoddi3+0x6d>
