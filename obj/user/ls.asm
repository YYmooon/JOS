
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 0b 03 00 00       	call   80033c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
  800048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004b:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80004f:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800056:	74 23                	je     80007b <ls1+0x3b>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800058:	89 f0                	mov    %esi,%eax
  80005a:	3c 01                	cmp    $0x1,%al
  80005c:	19 c0                	sbb    %eax,%eax
  80005e:	83 e0 c9             	and    $0xffffffc9,%eax
  800061:	83 c0 64             	add    $0x64,%eax
  800064:	89 44 24 08          	mov    %eax,0x8(%esp)
  800068:	8b 45 10             	mov    0x10(%ebp),%eax
  80006b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006f:	c7 04 24 22 27 80 00 	movl   $0x802722,(%esp)
  800076:	e8 ce 1c 00 00       	call   801d49 <printf>
	if(prefix) {
  80007b:	85 db                	test   %ebx,%ebx
  80007d:	74 38                	je     8000b7 <ls1+0x77>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80007f:	b8 88 27 80 00       	mov    $0x802788,%eax
	const char *sep;

	if(flag['l'])
		printf("%11d %c ", size, isdir ? 'd' : '-');
	if(prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800084:	80 3b 00             	cmpb   $0x0,(%ebx)
  800087:	74 1a                	je     8000a3 <ls1+0x63>
  800089:	89 1c 24             	mov    %ebx,(%esp)
  80008c:	e8 df 09 00 00       	call   800a70 <strlen>
			sep = "/";
  800091:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  800096:	b8 20 27 80 00       	mov    $0x802720,%eax
  80009b:	ba 88 27 80 00       	mov    $0x802788,%edx
  8000a0:	0f 44 c2             	cmove  %edx,%eax
		else
			sep = "";
		printf("%s%s", prefix, sep);
  8000a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000a7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000ab:	c7 04 24 2b 27 80 00 	movl   $0x80272b,(%esp)
  8000b2:	e8 92 1c 00 00       	call   801d49 <printf>
	}
	printf("%s", name);
  8000b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8000ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000be:	c7 04 24 b5 2b 80 00 	movl   $0x802bb5,(%esp)
  8000c5:	e8 7f 1c 00 00       	call   801d49 <printf>
	if(flag['F'] && isdir)
  8000ca:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000d1:	74 12                	je     8000e5 <ls1+0xa5>
  8000d3:	89 f0                	mov    %esi,%eax
  8000d5:	84 c0                	test   %al,%al
  8000d7:	74 0c                	je     8000e5 <ls1+0xa5>
		printf("/");
  8000d9:	c7 04 24 20 27 80 00 	movl   $0x802720,(%esp)
  8000e0:	e8 64 1c 00 00       	call   801d49 <printf>
	printf("\n");
  8000e5:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  8000ec:	e8 58 1c 00 00       	call   801d49 <printf>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	5b                   	pop    %ebx
  8000f5:	5e                   	pop    %esi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	57                   	push   %edi
  8000fc:	56                   	push   %esi
  8000fd:	53                   	push   %ebx
  8000fe:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  800104:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800107:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80010e:	00 
  80010f:	8b 45 08             	mov    0x8(%ebp),%eax
  800112:	89 04 24             	mov    %eax,(%esp)
  800115:	e8 92 1a 00 00       	call   801bac <open>
  80011a:	89 c6                	mov    %eax,%esi
  80011c:	85 c0                	test   %eax,%eax
  80011e:	79 59                	jns    800179 <lsdir+0x81>
		panic("open %s: %e", path, fd);
  800120:	89 44 24 10          	mov    %eax,0x10(%esp)
  800124:	8b 45 08             	mov    0x8(%ebp),%eax
  800127:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80012b:	c7 44 24 08 30 27 80 	movl   $0x802730,0x8(%esp)
  800132:	00 
  800133:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  80013a:	00 
  80013b:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  800142:	e8 61 02 00 00       	call   8003a8 <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  800147:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  80014e:	74 2f                	je     80017f <lsdir+0x87>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800150:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800154:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80015a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80015e:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800165:	0f 94 c0             	sete   %al
  800168:	0f b6 c0             	movzbl %al,%eax
  80016b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016f:	89 3c 24             	mov    %edi,(%esp)
  800172:	e8 c9 fe ff ff       	call   800040 <ls1>
  800177:	eb 06                	jmp    80017f <lsdir+0x87>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800179:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
  80017f:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  800186:	00 
  800187:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80018b:	89 34 24             	mov    %esi,(%esp)
  80018e:	e8 3b 16 00 00       	call   8017ce <readn>
  800193:	3d 00 01 00 00       	cmp    $0x100,%eax
  800198:	74 ad                	je     800147 <lsdir+0x4f>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80019a:	85 c0                	test   %eax,%eax
  80019c:	7e 23                	jle    8001c1 <lsdir+0xc9>
		panic("short read in directory %s", path);
  80019e:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a5:	c7 44 24 08 46 27 80 	movl   $0x802746,0x8(%esp)
  8001ac:	00 
  8001ad:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001b4:	00 
  8001b5:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  8001bc:	e8 e7 01 00 00       	call   8003a8 <_panic>
	if (n < 0)
  8001c1:	85 c0                	test   %eax,%eax
  8001c3:	79 27                	jns    8001ec <lsdir+0xf4>
		panic("error reading directory %s: %e", path, n);
  8001c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d0:	c7 44 24 08 8c 27 80 	movl   $0x80278c,0x8(%esp)
  8001d7:	00 
  8001d8:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8001df:	00 
  8001e0:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  8001e7:	e8 bc 01 00 00       	call   8003a8 <_panic>
}
  8001ec:	81 c4 2c 01 00 00    	add    $0x12c,%esp
  8001f2:	5b                   	pop    %ebx
  8001f3:	5e                   	pop    %esi
  8001f4:	5f                   	pop    %edi
  8001f5:	5d                   	pop    %ebp
  8001f6:	c3                   	ret    

008001f7 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	53                   	push   %ebx
  8001fb:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  800201:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  800204:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  80020a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020e:	89 1c 24             	mov    %ebx,(%esp)
  800211:	e8 bb 17 00 00       	call   8019d1 <stat>
  800216:	85 c0                	test   %eax,%eax
  800218:	79 24                	jns    80023e <ls+0x47>
		panic("stat %s: %e", path, r);
  80021a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80021e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800222:	c7 44 24 08 61 27 80 	movl   $0x802761,0x8(%esp)
  800229:	00 
  80022a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800231:	00 
  800232:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  800239:	e8 6a 01 00 00       	call   8003a8 <_panic>
	if (st.st_isdir && !flag['d'])
  80023e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800241:	85 c0                	test   %eax,%eax
  800243:	74 1a                	je     80025f <ls+0x68>
  800245:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  80024c:	75 11                	jne    80025f <ls+0x68>
		lsdir(path, prefix);
  80024e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800251:	89 44 24 04          	mov    %eax,0x4(%esp)
  800255:	89 1c 24             	mov    %ebx,(%esp)
  800258:	e8 9b fe ff ff       	call   8000f8 <lsdir>
  80025d:	eb 23                	jmp    800282 <ls+0x8b>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  80025f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800263:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800266:	89 54 24 08          	mov    %edx,0x8(%esp)
  80026a:	85 c0                	test   %eax,%eax
  80026c:	0f 95 c0             	setne  %al
  80026f:	0f b6 c0             	movzbl %al,%eax
  800272:	89 44 24 04          	mov    %eax,0x4(%esp)
  800276:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80027d:	e8 be fd ff ff       	call   800040 <ls1>
}
  800282:	81 c4 b4 00 00 00    	add    $0xb4,%esp
  800288:	5b                   	pop    %ebx
  800289:	5d                   	pop    %ebp
  80028a:	c3                   	ret    

0080028b <usage>:
	printf("\n");
}

void
usage(void)
{
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	83 ec 18             	sub    $0x18,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800291:	c7 04 24 6d 27 80 00 	movl   $0x80276d,(%esp)
  800298:	e8 ac 1a 00 00       	call   801d49 <printf>
	exit();
  80029d:	e8 ea 00 00 00       	call   80038c <exit>
}
  8002a2:	c9                   	leave  
  8002a3:	c3                   	ret    

008002a4 <umain>:

void
umain(int argc, char **argv)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	56                   	push   %esi
  8002a8:	53                   	push   %ebx
  8002a9:	83 ec 20             	sub    $0x20,%esp
  8002ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  8002af:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ba:	8d 45 08             	lea    0x8(%ebp),%eax
  8002bd:	89 04 24             	mov    %eax,(%esp)
  8002c0:	e8 bf 0f 00 00       	call   801284 <argstart>
	while ((i = argnext(&args)) >= 0)
  8002c5:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  8002c8:	eb 1e                	jmp    8002e8 <umain+0x44>
		switch (i) {
  8002ca:	83 f8 64             	cmp    $0x64,%eax
  8002cd:	74 0a                	je     8002d9 <umain+0x35>
  8002cf:	83 f8 6c             	cmp    $0x6c,%eax
  8002d2:	74 05                	je     8002d9 <umain+0x35>
  8002d4:	83 f8 46             	cmp    $0x46,%eax
  8002d7:	75 0a                	jne    8002e3 <umain+0x3f>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  8002d9:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  8002e0:	01 
			break;
  8002e1:	eb 05                	jmp    8002e8 <umain+0x44>
		default:
			usage();
  8002e3:	e8 a3 ff ff ff       	call   80028b <usage>
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8002e8:	89 1c 24             	mov    %ebx,(%esp)
  8002eb:	e8 c4 0f 00 00       	call   8012b4 <argnext>
  8002f0:	85 c0                	test   %eax,%eax
  8002f2:	79 d6                	jns    8002ca <umain+0x26>
			break;
		default:
			usage();
		}

	if (argc == 1)
  8002f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f7:	83 f8 01             	cmp    $0x1,%eax
  8002fa:	74 0c                	je     800308 <umain+0x64>
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  8002fc:	bb 01 00 00 00       	mov    $0x1,%ebx
  800301:	83 f8 01             	cmp    $0x1,%eax
  800304:	7f 18                	jg     80031e <umain+0x7a>
  800306:	eb 2d                	jmp    800335 <umain+0x91>
		default:
			usage();
		}

	if (argc == 1)
		ls("/", "");
  800308:	c7 44 24 04 88 27 80 	movl   $0x802788,0x4(%esp)
  80030f:	00 
  800310:	c7 04 24 20 27 80 00 	movl   $0x802720,(%esp)
  800317:	e8 db fe ff ff       	call   8001f7 <ls>
  80031c:	eb 17                	jmp    800335 <umain+0x91>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
  80031e:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800321:	89 44 24 04          	mov    %eax,0x4(%esp)
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	e8 ca fe ff ff       	call   8001f7 <ls>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80032d:	83 c3 01             	add    $0x1,%ebx
  800330:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  800333:	7f e9                	jg     80031e <umain+0x7a>
			ls(argv[i], argv[i]);
	}
}
  800335:	83 c4 20             	add    $0x20,%esp
  800338:	5b                   	pop    %ebx
  800339:	5e                   	pop    %esi
  80033a:	5d                   	pop    %ebp
  80033b:	c3                   	ret    

0080033c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	83 ec 18             	sub    $0x18,%esp
  800342:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800345:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800348:	8b 75 08             	mov    0x8(%ebp),%esi
  80034b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80034e:	e8 09 0c 00 00       	call   800f5c <sys_getenvid>
  800353:	25 ff 03 00 00       	and    $0x3ff,%eax
  800358:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80035b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800360:	a3 20 44 80 00       	mov    %eax,0x804420
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800365:	85 f6                	test   %esi,%esi
  800367:	7e 07                	jle    800370 <libmain+0x34>
		binaryname = argv[0];
  800369:	8b 03                	mov    (%ebx),%eax
  80036b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800370:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800374:	89 34 24             	mov    %esi,(%esp)
  800377:	e8 28 ff ff ff       	call   8002a4 <umain>

	// exit gracefully
	exit();
  80037c:	e8 0b 00 00 00       	call   80038c <exit>
}
  800381:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800384:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800387:	89 ec                	mov    %ebp,%esp
  800389:	5d                   	pop    %ebp
  80038a:	c3                   	ret    
	...

0080038c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800392:	e8 67 12 00 00       	call   8015fe <close_all>
	sys_env_destroy(0);
  800397:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80039e:	e8 5c 0b 00 00       	call   800eff <sys_env_destroy>
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    
  8003a5:	00 00                	add    %al,(%eax)
	...

008003a8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	56                   	push   %esi
  8003ac:	53                   	push   %ebx
  8003ad:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8003b0:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003b3:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8003b9:	e8 9e 0b 00 00       	call   800f5c <sys_getenvid>
  8003be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d4:	c7 04 24 b8 27 80 00 	movl   $0x8027b8,(%esp)
  8003db:	e8 c3 00 00 00       	call   8004a3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003e0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e7:	89 04 24             	mov    %eax,(%esp)
  8003ea:	e8 53 00 00 00       	call   800442 <vcprintf>
	cprintf("\n");
  8003ef:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  8003f6:	e8 a8 00 00 00       	call   8004a3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003fb:	cc                   	int3   
  8003fc:	eb fd                	jmp    8003fb <_panic+0x53>
	...

00800400 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	53                   	push   %ebx
  800404:	83 ec 14             	sub    $0x14,%esp
  800407:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80040a:	8b 03                	mov    (%ebx),%eax
  80040c:	8b 55 08             	mov    0x8(%ebp),%edx
  80040f:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800413:	83 c0 01             	add    $0x1,%eax
  800416:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800418:	3d ff 00 00 00       	cmp    $0xff,%eax
  80041d:	75 19                	jne    800438 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80041f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800426:	00 
  800427:	8d 43 08             	lea    0x8(%ebx),%eax
  80042a:	89 04 24             	mov    %eax,(%esp)
  80042d:	e8 6e 0a 00 00       	call   800ea0 <sys_cputs>
		b->idx = 0;
  800432:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800438:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80043c:	83 c4 14             	add    $0x14,%esp
  80043f:	5b                   	pop    %ebx
  800440:	5d                   	pop    %ebp
  800441:	c3                   	ret    

00800442 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800442:	55                   	push   %ebp
  800443:	89 e5                	mov    %esp,%ebp
  800445:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80044b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800452:	00 00 00 
	b.cnt = 0;
  800455:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80045c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80045f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800462:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	89 44 24 08          	mov    %eax,0x8(%esp)
  80046d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800473:	89 44 24 04          	mov    %eax,0x4(%esp)
  800477:	c7 04 24 00 04 80 00 	movl   $0x800400,(%esp)
  80047e:	e8 97 01 00 00       	call   80061a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800483:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800489:	89 44 24 04          	mov    %eax,0x4(%esp)
  80048d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800493:	89 04 24             	mov    %eax,(%esp)
  800496:	e8 05 0a 00 00       	call   800ea0 <sys_cputs>

	return b.cnt;
}
  80049b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004a9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b3:	89 04 24             	mov    %eax,(%esp)
  8004b6:	e8 87 ff ff ff       	call   800442 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004bb:	c9                   	leave  
  8004bc:	c3                   	ret    
  8004bd:	00 00                	add    %al,(%eax)
	...

008004c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	57                   	push   %edi
  8004c4:	56                   	push   %esi
  8004c5:	53                   	push   %ebx
  8004c6:	83 ec 3c             	sub    $0x3c,%esp
  8004c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004cc:	89 d7                	mov    %edx,%edi
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004dd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004e8:	72 11                	jb     8004fb <printnum+0x3b>
  8004ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ed:	39 45 10             	cmp    %eax,0x10(%ebp)
  8004f0:	76 09                	jbe    8004fb <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004f2:	83 eb 01             	sub    $0x1,%ebx
  8004f5:	85 db                	test   %ebx,%ebx
  8004f7:	7f 51                	jg     80054a <printnum+0x8a>
  8004f9:	eb 5e                	jmp    800559 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004fb:	89 74 24 10          	mov    %esi,0x10(%esp)
  8004ff:	83 eb 01             	sub    $0x1,%ebx
  800502:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800506:	8b 45 10             	mov    0x10(%ebp),%eax
  800509:	89 44 24 08          	mov    %eax,0x8(%esp)
  80050d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800511:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800515:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80051c:	00 
  80051d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800520:	89 04 24             	mov    %eax,(%esp)
  800523:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800526:	89 44 24 04          	mov    %eax,0x4(%esp)
  80052a:	e8 31 1f 00 00       	call   802460 <__udivdi3>
  80052f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800533:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800537:	89 04 24             	mov    %eax,(%esp)
  80053a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80053e:	89 fa                	mov    %edi,%edx
  800540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800543:	e8 78 ff ff ff       	call   8004c0 <printnum>
  800548:	eb 0f                	jmp    800559 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80054a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80054e:	89 34 24             	mov    %esi,(%esp)
  800551:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800554:	83 eb 01             	sub    $0x1,%ebx
  800557:	75 f1                	jne    80054a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800559:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800561:	8b 45 10             	mov    0x10(%ebp),%eax
  800564:	89 44 24 08          	mov    %eax,0x8(%esp)
  800568:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80056f:	00 
  800570:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800573:	89 04 24             	mov    %eax,(%esp)
  800576:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80057d:	e8 0e 20 00 00       	call   802590 <__umoddi3>
  800582:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800586:	0f be 80 db 27 80 00 	movsbl 0x8027db(%eax),%eax
  80058d:	89 04 24             	mov    %eax,(%esp)
  800590:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800593:	83 c4 3c             	add    $0x3c,%esp
  800596:	5b                   	pop    %ebx
  800597:	5e                   	pop    %esi
  800598:	5f                   	pop    %edi
  800599:	5d                   	pop    %ebp
  80059a:	c3                   	ret    

0080059b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80059e:	83 fa 01             	cmp    $0x1,%edx
  8005a1:	7e 0e                	jle    8005b1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005a3:	8b 10                	mov    (%eax),%edx
  8005a5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005a8:	89 08                	mov    %ecx,(%eax)
  8005aa:	8b 02                	mov    (%edx),%eax
  8005ac:	8b 52 04             	mov    0x4(%edx),%edx
  8005af:	eb 22                	jmp    8005d3 <getuint+0x38>
	else if (lflag)
  8005b1:	85 d2                	test   %edx,%edx
  8005b3:	74 10                	je     8005c5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005b5:	8b 10                	mov    (%eax),%edx
  8005b7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ba:	89 08                	mov    %ecx,(%eax)
  8005bc:	8b 02                	mov    (%edx),%eax
  8005be:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c3:	eb 0e                	jmp    8005d3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005c5:	8b 10                	mov    (%eax),%edx
  8005c7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ca:	89 08                	mov    %ecx,(%eax)
  8005cc:	8b 02                	mov    (%edx),%eax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
  8005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005db:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005df:	8b 10                	mov    (%eax),%edx
  8005e1:	3b 50 04             	cmp    0x4(%eax),%edx
  8005e4:	73 0a                	jae    8005f0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005e9:	88 0a                	mov    %cl,(%edx)
  8005eb:	83 c2 01             	add    $0x1,%edx
  8005ee:	89 10                	mov    %edx,(%eax)
}
  8005f0:	5d                   	pop    %ebp
  8005f1:	c3                   	ret    

008005f2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005f2:	55                   	push   %ebp
  8005f3:	89 e5                	mov    %esp,%ebp
  8005f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005f8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800602:	89 44 24 08          	mov    %eax,0x8(%esp)
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	89 04 24             	mov    %eax,(%esp)
  800613:	e8 02 00 00 00       	call   80061a <vprintfmt>
	va_end(ap);
}
  800618:	c9                   	leave  
  800619:	c3                   	ret    

0080061a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80061a:	55                   	push   %ebp
  80061b:	89 e5                	mov    %esp,%ebp
  80061d:	57                   	push   %edi
  80061e:	56                   	push   %esi
  80061f:	53                   	push   %ebx
  800620:	83 ec 4c             	sub    $0x4c,%esp
  800623:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800626:	8b 75 10             	mov    0x10(%ebp),%esi
  800629:	eb 12                	jmp    80063d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80062b:	85 c0                	test   %eax,%eax
  80062d:	0f 84 a9 03 00 00    	je     8009dc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800633:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800637:	89 04 24             	mov    %eax,(%esp)
  80063a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063d:	0f b6 06             	movzbl (%esi),%eax
  800640:	83 c6 01             	add    $0x1,%esi
  800643:	83 f8 25             	cmp    $0x25,%eax
  800646:	75 e3                	jne    80062b <vprintfmt+0x11>
  800648:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80064c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800653:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800658:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80065f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800664:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800667:	eb 2b                	jmp    800694 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800669:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80066c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800670:	eb 22                	jmp    800694 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800672:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800675:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800679:	eb 19                	jmp    800694 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80067e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800685:	eb 0d                	jmp    800694 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800687:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80068a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80068d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800694:	0f b6 06             	movzbl (%esi),%eax
  800697:	0f b6 d0             	movzbl %al,%edx
  80069a:	8d 7e 01             	lea    0x1(%esi),%edi
  80069d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006a0:	83 e8 23             	sub    $0x23,%eax
  8006a3:	3c 55                	cmp    $0x55,%al
  8006a5:	0f 87 0b 03 00 00    	ja     8009b6 <vprintfmt+0x39c>
  8006ab:	0f b6 c0             	movzbl %al,%eax
  8006ae:	ff 24 85 20 29 80 00 	jmp    *0x802920(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006b5:	83 ea 30             	sub    $0x30,%edx
  8006b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8006bb:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8006bf:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8006c5:	83 fa 09             	cmp    $0x9,%edx
  8006c8:	77 4a                	ja     800714 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ca:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006cd:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8006d0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8006d3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8006d7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006da:	8d 50 d0             	lea    -0x30(%eax),%edx
  8006dd:	83 fa 09             	cmp    $0x9,%edx
  8006e0:	76 eb                	jbe    8006cd <vprintfmt+0xb3>
  8006e2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006e5:	eb 2d                	jmp    800714 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006f8:	eb 1a                	jmp    800714 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006fa:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8006fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800701:	79 91                	jns    800694 <vprintfmt+0x7a>
  800703:	e9 73 ff ff ff       	jmp    80067b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800708:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80070b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800712:	eb 80                	jmp    800694 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800714:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800718:	0f 89 76 ff ff ff    	jns    800694 <vprintfmt+0x7a>
  80071e:	e9 64 ff ff ff       	jmp    800687 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800723:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800726:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800729:	e9 66 ff ff ff       	jmp    800694 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 50 04             	lea    0x4(%eax),%edx
  800734:	89 55 14             	mov    %edx,0x14(%ebp)
  800737:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	89 04 24             	mov    %eax,(%esp)
  800740:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800743:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800746:	e9 f2 fe ff ff       	jmp    80063d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8d 50 04             	lea    0x4(%eax),%edx
  800751:	89 55 14             	mov    %edx,0x14(%ebp)
  800754:	8b 00                	mov    (%eax),%eax
  800756:	89 c2                	mov    %eax,%edx
  800758:	c1 fa 1f             	sar    $0x1f,%edx
  80075b:	31 d0                	xor    %edx,%eax
  80075d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80075f:	83 f8 0f             	cmp    $0xf,%eax
  800762:	7f 0b                	jg     80076f <vprintfmt+0x155>
  800764:	8b 14 85 80 2a 80 00 	mov    0x802a80(,%eax,4),%edx
  80076b:	85 d2                	test   %edx,%edx
  80076d:	75 23                	jne    800792 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80076f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800773:	c7 44 24 08 f3 27 80 	movl   $0x8027f3,0x8(%esp)
  80077a:	00 
  80077b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80077f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800782:	89 3c 24             	mov    %edi,(%esp)
  800785:	e8 68 fe ff ff       	call   8005f2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80078d:	e9 ab fe ff ff       	jmp    80063d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800792:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800796:	c7 44 24 08 b5 2b 80 	movl   $0x802bb5,0x8(%esp)
  80079d:	00 
  80079e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007a5:	89 3c 24             	mov    %edi,(%esp)
  8007a8:	e8 45 fe ff ff       	call   8005f2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ad:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8007b0:	e9 88 fe ff ff       	jmp    80063d <vprintfmt+0x23>
  8007b5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8007b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8d 50 04             	lea    0x4(%eax),%edx
  8007c4:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8007c9:	85 f6                	test   %esi,%esi
  8007cb:	ba ec 27 80 00       	mov    $0x8027ec,%edx
  8007d0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8007d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007d7:	7e 06                	jle    8007df <vprintfmt+0x1c5>
  8007d9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8007dd:	75 10                	jne    8007ef <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007df:	0f be 06             	movsbl (%esi),%eax
  8007e2:	83 c6 01             	add    $0x1,%esi
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	0f 85 86 00 00 00    	jne    800873 <vprintfmt+0x259>
  8007ed:	eb 76                	jmp    800865 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ef:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f3:	89 34 24             	mov    %esi,(%esp)
  8007f6:	e8 90 02 00 00       	call   800a8b <strnlen>
  8007fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007fe:	29 c2                	sub    %eax,%edx
  800800:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800803:	85 d2                	test   %edx,%edx
  800805:	7e d8                	jle    8007df <vprintfmt+0x1c5>
					putch(padc, putdat);
  800807:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80080b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80080e:	89 d6                	mov    %edx,%esi
  800810:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800813:	89 c7                	mov    %eax,%edi
  800815:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800819:	89 3c 24             	mov    %edi,(%esp)
  80081c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80081f:	83 ee 01             	sub    $0x1,%esi
  800822:	75 f1                	jne    800815 <vprintfmt+0x1fb>
  800824:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800827:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80082a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80082d:	eb b0                	jmp    8007df <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80082f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800833:	74 18                	je     80084d <vprintfmt+0x233>
  800835:	8d 50 e0             	lea    -0x20(%eax),%edx
  800838:	83 fa 5e             	cmp    $0x5e,%edx
  80083b:	76 10                	jbe    80084d <vprintfmt+0x233>
					putch('?', putdat);
  80083d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800841:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800848:	ff 55 08             	call   *0x8(%ebp)
  80084b:	eb 0a                	jmp    800857 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80084d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800851:	89 04 24             	mov    %eax,(%esp)
  800854:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800857:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80085b:	0f be 06             	movsbl (%esi),%eax
  80085e:	83 c6 01             	add    $0x1,%esi
  800861:	85 c0                	test   %eax,%eax
  800863:	75 0e                	jne    800873 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800865:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800868:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80086c:	7f 16                	jg     800884 <vprintfmt+0x26a>
  80086e:	e9 ca fd ff ff       	jmp    80063d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800873:	85 ff                	test   %edi,%edi
  800875:	78 b8                	js     80082f <vprintfmt+0x215>
  800877:	83 ef 01             	sub    $0x1,%edi
  80087a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800880:	79 ad                	jns    80082f <vprintfmt+0x215>
  800882:	eb e1                	jmp    800865 <vprintfmt+0x24b>
  800884:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800887:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80088a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80088e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800895:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800897:	83 ee 01             	sub    $0x1,%esi
  80089a:	75 ee                	jne    80088a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80089f:	e9 99 fd ff ff       	jmp    80063d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008a4:	83 f9 01             	cmp    $0x1,%ecx
  8008a7:	7e 10                	jle    8008b9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	8d 50 08             	lea    0x8(%eax),%edx
  8008af:	89 55 14             	mov    %edx,0x14(%ebp)
  8008b2:	8b 30                	mov    (%eax),%esi
  8008b4:	8b 78 04             	mov    0x4(%eax),%edi
  8008b7:	eb 26                	jmp    8008df <vprintfmt+0x2c5>
	else if (lflag)
  8008b9:	85 c9                	test   %ecx,%ecx
  8008bb:	74 12                	je     8008cf <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	8d 50 04             	lea    0x4(%eax),%edx
  8008c3:	89 55 14             	mov    %edx,0x14(%ebp)
  8008c6:	8b 30                	mov    (%eax),%esi
  8008c8:	89 f7                	mov    %esi,%edi
  8008ca:	c1 ff 1f             	sar    $0x1f,%edi
  8008cd:	eb 10                	jmp    8008df <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8d 50 04             	lea    0x4(%eax),%edx
  8008d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d8:	8b 30                	mov    (%eax),%esi
  8008da:	89 f7                	mov    %esi,%edi
  8008dc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008df:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008e4:	85 ff                	test   %edi,%edi
  8008e6:	0f 89 8c 00 00 00    	jns    800978 <vprintfmt+0x35e>
				putch('-', putdat);
  8008ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008f0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008f7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008fa:	f7 de                	neg    %esi
  8008fc:	83 d7 00             	adc    $0x0,%edi
  8008ff:	f7 df                	neg    %edi
			}
			base = 10;
  800901:	b8 0a 00 00 00       	mov    $0xa,%eax
  800906:	eb 70                	jmp    800978 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800908:	89 ca                	mov    %ecx,%edx
  80090a:	8d 45 14             	lea    0x14(%ebp),%eax
  80090d:	e8 89 fc ff ff       	call   80059b <getuint>
  800912:	89 c6                	mov    %eax,%esi
  800914:	89 d7                	mov    %edx,%edi
			base = 10;
  800916:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80091b:	eb 5b                	jmp    800978 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80091d:	89 ca                	mov    %ecx,%edx
  80091f:	8d 45 14             	lea    0x14(%ebp),%eax
  800922:	e8 74 fc ff ff       	call   80059b <getuint>
  800927:	89 c6                	mov    %eax,%esi
  800929:	89 d7                	mov    %edx,%edi
			base = 8;
  80092b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800930:	eb 46                	jmp    800978 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800932:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800936:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80093d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800940:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800944:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80094b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800957:	8b 30                	mov    (%eax),%esi
  800959:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80095e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800963:	eb 13                	jmp    800978 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800965:	89 ca                	mov    %ecx,%edx
  800967:	8d 45 14             	lea    0x14(%ebp),%eax
  80096a:	e8 2c fc ff ff       	call   80059b <getuint>
  80096f:	89 c6                	mov    %eax,%esi
  800971:	89 d7                	mov    %edx,%edi
			base = 16;
  800973:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800978:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80097c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800980:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800983:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800987:	89 44 24 08          	mov    %eax,0x8(%esp)
  80098b:	89 34 24             	mov    %esi,(%esp)
  80098e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800992:	89 da                	mov    %ebx,%edx
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	e8 24 fb ff ff       	call   8004c0 <printnum>
			break;
  80099c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80099f:	e9 99 fc ff ff       	jmp    80063d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009a8:	89 14 24             	mov    %edx,(%esp)
  8009ab:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ae:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8009b1:	e9 87 fc ff ff       	jmp    80063d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009ba:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009c1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009c4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8009c8:	0f 84 6f fc ff ff    	je     80063d <vprintfmt+0x23>
  8009ce:	83 ee 01             	sub    $0x1,%esi
  8009d1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8009d5:	75 f7                	jne    8009ce <vprintfmt+0x3b4>
  8009d7:	e9 61 fc ff ff       	jmp    80063d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8009dc:	83 c4 4c             	add    $0x4c,%esp
  8009df:	5b                   	pop    %ebx
  8009e0:	5e                   	pop    %esi
  8009e1:	5f                   	pop    %edi
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	83 ec 28             	sub    $0x28,%esp
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009f3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009f7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a01:	85 c0                	test   %eax,%eax
  800a03:	74 30                	je     800a35 <vsnprintf+0x51>
  800a05:	85 d2                	test   %edx,%edx
  800a07:	7e 2c                	jle    800a35 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a10:	8b 45 10             	mov    0x10(%ebp),%eax
  800a13:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a1e:	c7 04 24 d5 05 80 00 	movl   $0x8005d5,(%esp)
  800a25:	e8 f0 fb ff ff       	call   80061a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a2d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a33:	eb 05                	jmp    800a3a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a42:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a45:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a49:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	89 04 24             	mov    %eax,(%esp)
  800a5d:	e8 82 ff ff ff       	call   8009e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a62:	c9                   	leave  
  800a63:	c3                   	ret    
	...

00800a70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a76:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7b:	80 3a 00             	cmpb   $0x0,(%edx)
  800a7e:	74 09                	je     800a89 <strlen+0x19>
		n++;
  800a80:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a87:	75 f7                	jne    800a80 <strlen+0x10>
		n++;
	return n;
}
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	53                   	push   %ebx
  800a8f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a95:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9a:	85 c9                	test   %ecx,%ecx
  800a9c:	74 1a                	je     800ab8 <strnlen+0x2d>
  800a9e:	80 3b 00             	cmpb   $0x0,(%ebx)
  800aa1:	74 15                	je     800ab8 <strnlen+0x2d>
  800aa3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800aa8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aaa:	39 ca                	cmp    %ecx,%edx
  800aac:	74 0a                	je     800ab8 <strnlen+0x2d>
  800aae:	83 c2 01             	add    $0x1,%edx
  800ab1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800ab6:	75 f0                	jne    800aa8 <strnlen+0x1d>
		n++;
	return n;
}
  800ab8:	5b                   	pop    %ebx
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	53                   	push   %ebx
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aca:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ace:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ad1:	83 c2 01             	add    $0x1,%edx
  800ad4:	84 c9                	test   %cl,%cl
  800ad6:	75 f2                	jne    800aca <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ad8:	5b                   	pop    %ebx
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	53                   	push   %ebx
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ae5:	89 1c 24             	mov    %ebx,(%esp)
  800ae8:	e8 83 ff ff ff       	call   800a70 <strlen>
	strcpy(dst + len, src);
  800aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af0:	89 54 24 04          	mov    %edx,0x4(%esp)
  800af4:	01 d8                	add    %ebx,%eax
  800af6:	89 04 24             	mov    %eax,(%esp)
  800af9:	e8 bd ff ff ff       	call   800abb <strcpy>
	return dst;
}
  800afe:	89 d8                	mov    %ebx,%eax
  800b00:	83 c4 08             	add    $0x8,%esp
  800b03:	5b                   	pop    %ebx
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	56                   	push   %esi
  800b0a:	53                   	push   %ebx
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b11:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b14:	85 f6                	test   %esi,%esi
  800b16:	74 18                	je     800b30 <strncpy+0x2a>
  800b18:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800b1d:	0f b6 1a             	movzbl (%edx),%ebx
  800b20:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b23:	80 3a 01             	cmpb   $0x1,(%edx)
  800b26:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b29:	83 c1 01             	add    $0x1,%ecx
  800b2c:	39 f1                	cmp    %esi,%ecx
  800b2e:	75 ed                	jne    800b1d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b30:	5b                   	pop    %ebx
  800b31:	5e                   	pop    %esi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	57                   	push   %edi
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
  800b3a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b40:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b43:	89 f8                	mov    %edi,%eax
  800b45:	85 f6                	test   %esi,%esi
  800b47:	74 2b                	je     800b74 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800b49:	83 fe 01             	cmp    $0x1,%esi
  800b4c:	74 23                	je     800b71 <strlcpy+0x3d>
  800b4e:	0f b6 0b             	movzbl (%ebx),%ecx
  800b51:	84 c9                	test   %cl,%cl
  800b53:	74 1c                	je     800b71 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800b55:	83 ee 02             	sub    $0x2,%esi
  800b58:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b5d:	88 08                	mov    %cl,(%eax)
  800b5f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b62:	39 f2                	cmp    %esi,%edx
  800b64:	74 0b                	je     800b71 <strlcpy+0x3d>
  800b66:	83 c2 01             	add    $0x1,%edx
  800b69:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b6d:	84 c9                	test   %cl,%cl
  800b6f:	75 ec                	jne    800b5d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800b71:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b74:	29 f8                	sub    %edi,%eax
}
  800b76:	5b                   	pop    %ebx
  800b77:	5e                   	pop    %esi
  800b78:	5f                   	pop    %edi
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b81:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b84:	0f b6 01             	movzbl (%ecx),%eax
  800b87:	84 c0                	test   %al,%al
  800b89:	74 16                	je     800ba1 <strcmp+0x26>
  800b8b:	3a 02                	cmp    (%edx),%al
  800b8d:	75 12                	jne    800ba1 <strcmp+0x26>
		p++, q++;
  800b8f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b92:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800b96:	84 c0                	test   %al,%al
  800b98:	74 07                	je     800ba1 <strcmp+0x26>
  800b9a:	83 c1 01             	add    $0x1,%ecx
  800b9d:	3a 02                	cmp    (%edx),%al
  800b9f:	74 ee                	je     800b8f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba1:	0f b6 c0             	movzbl %al,%eax
  800ba4:	0f b6 12             	movzbl (%edx),%edx
  800ba7:	29 d0                	sub    %edx,%eax
}
  800ba9:	5d                   	pop    %ebp
  800baa:	c3                   	ret    

00800bab <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	53                   	push   %ebx
  800baf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bb5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800bbd:	85 d2                	test   %edx,%edx
  800bbf:	74 28                	je     800be9 <strncmp+0x3e>
  800bc1:	0f b6 01             	movzbl (%ecx),%eax
  800bc4:	84 c0                	test   %al,%al
  800bc6:	74 24                	je     800bec <strncmp+0x41>
  800bc8:	3a 03                	cmp    (%ebx),%al
  800bca:	75 20                	jne    800bec <strncmp+0x41>
  800bcc:	83 ea 01             	sub    $0x1,%edx
  800bcf:	74 13                	je     800be4 <strncmp+0x39>
		n--, p++, q++;
  800bd1:	83 c1 01             	add    $0x1,%ecx
  800bd4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800bd7:	0f b6 01             	movzbl (%ecx),%eax
  800bda:	84 c0                	test   %al,%al
  800bdc:	74 0e                	je     800bec <strncmp+0x41>
  800bde:	3a 03                	cmp    (%ebx),%al
  800be0:	74 ea                	je     800bcc <strncmp+0x21>
  800be2:	eb 08                	jmp    800bec <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800be9:	5b                   	pop    %ebx
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bec:	0f b6 01             	movzbl (%ecx),%eax
  800bef:	0f b6 13             	movzbl (%ebx),%edx
  800bf2:	29 d0                	sub    %edx,%eax
  800bf4:	eb f3                	jmp    800be9 <strncmp+0x3e>

00800bf6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c00:	0f b6 10             	movzbl (%eax),%edx
  800c03:	84 d2                	test   %dl,%dl
  800c05:	74 1c                	je     800c23 <strchr+0x2d>
		if (*s == c)
  800c07:	38 ca                	cmp    %cl,%dl
  800c09:	75 09                	jne    800c14 <strchr+0x1e>
  800c0b:	eb 1b                	jmp    800c28 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c0d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800c10:	38 ca                	cmp    %cl,%dl
  800c12:	74 14                	je     800c28 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c14:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800c18:	84 d2                	test   %dl,%dl
  800c1a:	75 f1                	jne    800c0d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c21:	eb 05                	jmp    800c28 <strchr+0x32>
  800c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c34:	0f b6 10             	movzbl (%eax),%edx
  800c37:	84 d2                	test   %dl,%dl
  800c39:	74 14                	je     800c4f <strfind+0x25>
		if (*s == c)
  800c3b:	38 ca                	cmp    %cl,%dl
  800c3d:	75 06                	jne    800c45 <strfind+0x1b>
  800c3f:	eb 0e                	jmp    800c4f <strfind+0x25>
  800c41:	38 ca                	cmp    %cl,%dl
  800c43:	74 0a                	je     800c4f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c45:	83 c0 01             	add    $0x1,%eax
  800c48:	0f b6 10             	movzbl (%eax),%edx
  800c4b:	84 d2                	test   %dl,%dl
  800c4d:	75 f2                	jne    800c41 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 0c             	sub    $0xc,%esp
  800c57:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c5a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c5d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800c60:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c66:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c69:	85 c9                	test   %ecx,%ecx
  800c6b:	74 30                	je     800c9d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c6d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c73:	75 25                	jne    800c9a <memset+0x49>
  800c75:	f6 c1 03             	test   $0x3,%cl
  800c78:	75 20                	jne    800c9a <memset+0x49>
		c &= 0xFF;
  800c7a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c7d:	89 d3                	mov    %edx,%ebx
  800c7f:	c1 e3 08             	shl    $0x8,%ebx
  800c82:	89 d6                	mov    %edx,%esi
  800c84:	c1 e6 18             	shl    $0x18,%esi
  800c87:	89 d0                	mov    %edx,%eax
  800c89:	c1 e0 10             	shl    $0x10,%eax
  800c8c:	09 f0                	or     %esi,%eax
  800c8e:	09 d0                	or     %edx,%eax
  800c90:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c92:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c95:	fc                   	cld    
  800c96:	f3 ab                	rep stos %eax,%es:(%edi)
  800c98:	eb 03                	jmp    800c9d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c9a:	fc                   	cld    
  800c9b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c9d:	89 f8                	mov    %edi,%eax
  800c9f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ca2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ca5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ca8:	89 ec                	mov    %ebp,%esp
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cb5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cc1:	39 c6                	cmp    %eax,%esi
  800cc3:	73 36                	jae    800cfb <memmove+0x4f>
  800cc5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cc8:	39 d0                	cmp    %edx,%eax
  800cca:	73 2f                	jae    800cfb <memmove+0x4f>
		s += n;
		d += n;
  800ccc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ccf:	f6 c2 03             	test   $0x3,%dl
  800cd2:	75 1b                	jne    800cef <memmove+0x43>
  800cd4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cda:	75 13                	jne    800cef <memmove+0x43>
  800cdc:	f6 c1 03             	test   $0x3,%cl
  800cdf:	75 0e                	jne    800cef <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ce1:	83 ef 04             	sub    $0x4,%edi
  800ce4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ce7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800cea:	fd                   	std    
  800ceb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ced:	eb 09                	jmp    800cf8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cef:	83 ef 01             	sub    $0x1,%edi
  800cf2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800cf5:	fd                   	std    
  800cf6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cf8:	fc                   	cld    
  800cf9:	eb 20                	jmp    800d1b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cfb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d01:	75 13                	jne    800d16 <memmove+0x6a>
  800d03:	a8 03                	test   $0x3,%al
  800d05:	75 0f                	jne    800d16 <memmove+0x6a>
  800d07:	f6 c1 03             	test   $0x3,%cl
  800d0a:	75 0a                	jne    800d16 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d0c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800d0f:	89 c7                	mov    %eax,%edi
  800d11:	fc                   	cld    
  800d12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d14:	eb 05                	jmp    800d1b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d16:	89 c7                	mov    %eax,%edi
  800d18:	fc                   	cld    
  800d19:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d1b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d1e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d21:	89 ec                	mov    %ebp,%esp
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	89 04 24             	mov    %eax,(%esp)
  800d3f:	e8 68 ff ff ff       	call   800cac <memmove>
}
  800d44:	c9                   	leave  
  800d45:	c3                   	ret    

00800d46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	57                   	push   %edi
  800d4a:	56                   	push   %esi
  800d4b:	53                   	push   %ebx
  800d4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d52:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d55:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d5a:	85 ff                	test   %edi,%edi
  800d5c:	74 37                	je     800d95 <memcmp+0x4f>
		if (*s1 != *s2)
  800d5e:	0f b6 03             	movzbl (%ebx),%eax
  800d61:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d64:	83 ef 01             	sub    $0x1,%edi
  800d67:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800d6c:	38 c8                	cmp    %cl,%al
  800d6e:	74 1c                	je     800d8c <memcmp+0x46>
  800d70:	eb 10                	jmp    800d82 <memcmp+0x3c>
  800d72:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800d77:	83 c2 01             	add    $0x1,%edx
  800d7a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800d7e:	38 c8                	cmp    %cl,%al
  800d80:	74 0a                	je     800d8c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800d82:	0f b6 c0             	movzbl %al,%eax
  800d85:	0f b6 c9             	movzbl %cl,%ecx
  800d88:	29 c8                	sub    %ecx,%eax
  800d8a:	eb 09                	jmp    800d95 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d8c:	39 fa                	cmp    %edi,%edx
  800d8e:	75 e2                	jne    800d72 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800da0:	89 c2                	mov    %eax,%edx
  800da2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800da5:	39 d0                	cmp    %edx,%eax
  800da7:	73 19                	jae    800dc2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800da9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800dad:	38 08                	cmp    %cl,(%eax)
  800daf:	75 06                	jne    800db7 <memfind+0x1d>
  800db1:	eb 0f                	jmp    800dc2 <memfind+0x28>
  800db3:	38 08                	cmp    %cl,(%eax)
  800db5:	74 0b                	je     800dc2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800db7:	83 c0 01             	add    $0x1,%eax
  800dba:	39 d0                	cmp    %edx,%eax
  800dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800dc0:	75 f1                	jne    800db3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800dc2:	5d                   	pop    %ebp
  800dc3:	c3                   	ret    

00800dc4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
  800dca:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dd0:	0f b6 02             	movzbl (%edx),%eax
  800dd3:	3c 20                	cmp    $0x20,%al
  800dd5:	74 04                	je     800ddb <strtol+0x17>
  800dd7:	3c 09                	cmp    $0x9,%al
  800dd9:	75 0e                	jne    800de9 <strtol+0x25>
		s++;
  800ddb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dde:	0f b6 02             	movzbl (%edx),%eax
  800de1:	3c 20                	cmp    $0x20,%al
  800de3:	74 f6                	je     800ddb <strtol+0x17>
  800de5:	3c 09                	cmp    $0x9,%al
  800de7:	74 f2                	je     800ddb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800de9:	3c 2b                	cmp    $0x2b,%al
  800deb:	75 0a                	jne    800df7 <strtol+0x33>
		s++;
  800ded:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800df0:	bf 00 00 00 00       	mov    $0x0,%edi
  800df5:	eb 10                	jmp    800e07 <strtol+0x43>
  800df7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800dfc:	3c 2d                	cmp    $0x2d,%al
  800dfe:	75 07                	jne    800e07 <strtol+0x43>
		s++, neg = 1;
  800e00:	83 c2 01             	add    $0x1,%edx
  800e03:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e07:	85 db                	test   %ebx,%ebx
  800e09:	0f 94 c0             	sete   %al
  800e0c:	74 05                	je     800e13 <strtol+0x4f>
  800e0e:	83 fb 10             	cmp    $0x10,%ebx
  800e11:	75 15                	jne    800e28 <strtol+0x64>
  800e13:	80 3a 30             	cmpb   $0x30,(%edx)
  800e16:	75 10                	jne    800e28 <strtol+0x64>
  800e18:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e1c:	75 0a                	jne    800e28 <strtol+0x64>
		s += 2, base = 16;
  800e1e:	83 c2 02             	add    $0x2,%edx
  800e21:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e26:	eb 13                	jmp    800e3b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800e28:	84 c0                	test   %al,%al
  800e2a:	74 0f                	je     800e3b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e2c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e31:	80 3a 30             	cmpb   $0x30,(%edx)
  800e34:	75 05                	jne    800e3b <strtol+0x77>
		s++, base = 8;
  800e36:	83 c2 01             	add    $0x1,%edx
  800e39:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e40:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e42:	0f b6 0a             	movzbl (%edx),%ecx
  800e45:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800e48:	80 fb 09             	cmp    $0x9,%bl
  800e4b:	77 08                	ja     800e55 <strtol+0x91>
			dig = *s - '0';
  800e4d:	0f be c9             	movsbl %cl,%ecx
  800e50:	83 e9 30             	sub    $0x30,%ecx
  800e53:	eb 1e                	jmp    800e73 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800e55:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800e58:	80 fb 19             	cmp    $0x19,%bl
  800e5b:	77 08                	ja     800e65 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800e5d:	0f be c9             	movsbl %cl,%ecx
  800e60:	83 e9 57             	sub    $0x57,%ecx
  800e63:	eb 0e                	jmp    800e73 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800e65:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800e68:	80 fb 19             	cmp    $0x19,%bl
  800e6b:	77 14                	ja     800e81 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800e6d:	0f be c9             	movsbl %cl,%ecx
  800e70:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e73:	39 f1                	cmp    %esi,%ecx
  800e75:	7d 0e                	jge    800e85 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e77:	83 c2 01             	add    $0x1,%edx
  800e7a:	0f af c6             	imul   %esi,%eax
  800e7d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800e7f:	eb c1                	jmp    800e42 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800e81:	89 c1                	mov    %eax,%ecx
  800e83:	eb 02                	jmp    800e87 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e85:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8b:	74 05                	je     800e92 <strtol+0xce>
		*endptr = (char *) s;
  800e8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e90:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800e92:	89 ca                	mov    %ecx,%edx
  800e94:	f7 da                	neg    %edx
  800e96:	85 ff                	test   %edi,%edi
  800e98:	0f 45 c2             	cmovne %edx,%eax
}
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	83 ec 0c             	sub    $0xc,%esp
  800ea6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eac:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eba:	89 c3                	mov    %eax,%ebx
  800ebc:	89 c7                	mov    %eax,%edi
  800ebe:	89 c6                	mov    %eax,%esi
  800ec0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ec2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ec8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ecb:	89 ec                	mov    %ebp,%esp
  800ecd:	5d                   	pop    %ebp
  800ece:	c3                   	ret    

00800ecf <sys_cgetc>:

int
sys_cgetc(void)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 0c             	sub    $0xc,%esp
  800ed5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800edb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ede:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee3:	b8 01 00 00 00       	mov    $0x1,%eax
  800ee8:	89 d1                	mov    %edx,%ecx
  800eea:	89 d3                	mov    %edx,%ebx
  800eec:	89 d7                	mov    %edx,%edi
  800eee:	89 d6                	mov    %edx,%esi
  800ef0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ef2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800efb:	89 ec                	mov    %ebp,%esp
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    

00800eff <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 38             	sub    $0x38,%esp
  800f05:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f08:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f0b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f13:	b8 03 00 00 00       	mov    $0x3,%eax
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	89 cb                	mov    %ecx,%ebx
  800f1d:	89 cf                	mov    %ecx,%edi
  800f1f:	89 ce                	mov    %ecx,%esi
  800f21:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f23:	85 c0                	test   %eax,%eax
  800f25:	7e 28                	jle    800f4f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f27:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f32:	00 
  800f33:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  800f3a:	00 
  800f3b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f42:	00 
  800f43:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  800f4a:	e8 59 f4 ff ff       	call   8003a8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f4f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f52:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f55:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f58:	89 ec                	mov    %ebp,%esp
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 0c             	sub    $0xc,%esp
  800f62:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f65:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f68:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	b8 02 00 00 00       	mov    $0x2,%eax
  800f75:	89 d1                	mov    %edx,%ecx
  800f77:	89 d3                	mov    %edx,%ebx
  800f79:	89 d7                	mov    %edx,%edi
  800f7b:	89 d6                	mov    %edx,%esi
  800f7d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f82:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f88:	89 ec                	mov    %ebp,%esp
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <sys_yield>:

void
sys_yield(void)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 0c             	sub    $0xc,%esp
  800f92:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f95:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f98:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fa5:	89 d1                	mov    %edx,%ecx
  800fa7:	89 d3                	mov    %edx,%ebx
  800fa9:	89 d7                	mov    %edx,%edi
  800fab:	89 d6                	mov    %edx,%esi
  800fad:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800faf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fb8:	89 ec                	mov    %ebp,%esp
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 38             	sub    $0x38,%esp
  800fc2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fc8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcb:	be 00 00 00 00       	mov    $0x0,%esi
  800fd0:	b8 04 00 00 00       	mov    $0x4,%eax
  800fd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fde:	89 f7                	mov    %esi,%edi
  800fe0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe2:	85 c0                	test   %eax,%eax
  800fe4:	7e 28                	jle    80100e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fea:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ff1:	00 
  800ff2:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  800ff9:	00 
  800ffa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801001:	00 
  801002:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  801009:	e8 9a f3 ff ff       	call   8003a8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80100e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801011:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801014:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801017:	89 ec                	mov    %ebp,%esp
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    

0080101b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	83 ec 38             	sub    $0x38,%esp
  801021:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801024:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801027:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102a:	b8 05 00 00 00       	mov    $0x5,%eax
  80102f:	8b 75 18             	mov    0x18(%ebp),%esi
  801032:	8b 7d 14             	mov    0x14(%ebp),%edi
  801035:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801038:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103b:	8b 55 08             	mov    0x8(%ebp),%edx
  80103e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801040:	85 c0                	test   %eax,%eax
  801042:	7e 28                	jle    80106c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801044:	89 44 24 10          	mov    %eax,0x10(%esp)
  801048:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80104f:	00 
  801050:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  801057:	00 
  801058:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80105f:	00 
  801060:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  801067:	e8 3c f3 ff ff       	call   8003a8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80106c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80106f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801072:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801075:	89 ec                	mov    %ebp,%esp
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    

00801079 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	83 ec 38             	sub    $0x38,%esp
  80107f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801082:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801085:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801088:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108d:	b8 06 00 00 00       	mov    $0x6,%eax
  801092:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801095:	8b 55 08             	mov    0x8(%ebp),%edx
  801098:	89 df                	mov    %ebx,%edi
  80109a:	89 de                	mov    %ebx,%esi
  80109c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	7e 28                	jle    8010ca <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8010ad:	00 
  8010ae:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  8010b5:	00 
  8010b6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010bd:	00 
  8010be:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  8010c5:	e8 de f2 ff ff       	call   8003a8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010ca:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010cd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010d3:	89 ec                	mov    %ebp,%esp
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	83 ec 38             	sub    $0x38,%esp
  8010dd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010e0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010e3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8010f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f6:	89 df                	mov    %ebx,%edi
  8010f8:	89 de                	mov    %ebx,%esi
  8010fa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	7e 28                	jle    801128 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801100:	89 44 24 10          	mov    %eax,0x10(%esp)
  801104:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80110b:	00 
  80110c:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  801113:	00 
  801114:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80111b:	00 
  80111c:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  801123:	e8 80 f2 ff ff       	call   8003a8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801128:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80112b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80112e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801131:	89 ec                	mov    %ebp,%esp
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 38             	sub    $0x38,%esp
  80113b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80113e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801141:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801144:	bb 00 00 00 00       	mov    $0x0,%ebx
  801149:	b8 09 00 00 00       	mov    $0x9,%eax
  80114e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801151:	8b 55 08             	mov    0x8(%ebp),%edx
  801154:	89 df                	mov    %ebx,%edi
  801156:	89 de                	mov    %ebx,%esi
  801158:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80115a:	85 c0                	test   %eax,%eax
  80115c:	7e 28                	jle    801186 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80115e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801162:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801169:	00 
  80116a:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  801171:	00 
  801172:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801179:	00 
  80117a:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  801181:	e8 22 f2 ff ff       	call   8003a8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801186:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801189:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80118c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80118f:	89 ec                	mov    %ebp,%esp
  801191:	5d                   	pop    %ebp
  801192:	c3                   	ret    

00801193 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	83 ec 38             	sub    $0x38,%esp
  801199:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80119c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80119f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011af:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b2:	89 df                	mov    %ebx,%edi
  8011b4:	89 de                	mov    %ebx,%esi
  8011b6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	7e 28                	jle    8011e4 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8011c7:	00 
  8011c8:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  8011cf:	00 
  8011d0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d7:	00 
  8011d8:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  8011df:	e8 c4 f1 ff ff       	call   8003a8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011e4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011e7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011ea:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011ed:	89 ec                	mov    %ebp,%esp
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    

008011f1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 0c             	sub    $0xc,%esp
  8011f7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011fa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011fd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801200:	be 00 00 00 00       	mov    $0x0,%esi
  801205:	b8 0c 00 00 00       	mov    $0xc,%eax
  80120a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80120d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801210:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801218:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80121b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80121e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801221:	89 ec                	mov    %ebp,%esp
  801223:	5d                   	pop    %ebp
  801224:	c3                   	ret    

00801225 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	83 ec 38             	sub    $0x38,%esp
  80122b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80122e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801231:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801234:	b9 00 00 00 00       	mov    $0x0,%ecx
  801239:	b8 0d 00 00 00       	mov    $0xd,%eax
  80123e:	8b 55 08             	mov    0x8(%ebp),%edx
  801241:	89 cb                	mov    %ecx,%ebx
  801243:	89 cf                	mov    %ecx,%edi
  801245:	89 ce                	mov    %ecx,%esi
  801247:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801249:	85 c0                	test   %eax,%eax
  80124b:	7e 28                	jle    801275 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80124d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801251:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801258:	00 
  801259:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  801260:	00 
  801261:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801268:	00 
  801269:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  801270:	e8 33 f1 ff ff       	call   8003a8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801275:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801278:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80127b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80127e:	89 ec                	mov    %ebp,%esp
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    
	...

00801284 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	8b 55 08             	mov    0x8(%ebp),%edx
  80128a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128d:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801290:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801292:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801295:	83 3a 01             	cmpl   $0x1,(%edx)
  801298:	7e 09                	jle    8012a3 <argstart+0x1f>
  80129a:	ba 88 27 80 00       	mov    $0x802788,%edx
  80129f:	85 c9                	test   %ecx,%ecx
  8012a1:	75 05                	jne    8012a8 <argstart+0x24>
  8012a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a8:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  8012ab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8012b2:	5d                   	pop    %ebp
  8012b3:	c3                   	ret    

008012b4 <argnext>:

int
argnext(struct Argstate *args)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	53                   	push   %ebx
  8012b8:	83 ec 14             	sub    $0x14,%esp
  8012bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8012be:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8012c5:	8b 43 08             	mov    0x8(%ebx),%eax
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 71                	je     80133d <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  8012cc:	80 38 00             	cmpb   $0x0,(%eax)
  8012cf:	75 50                	jne    801321 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8012d1:	8b 0b                	mov    (%ebx),%ecx
  8012d3:	83 39 01             	cmpl   $0x1,(%ecx)
  8012d6:	74 57                	je     80132f <argnext+0x7b>
		    || args->argv[1][0] != '-'
  8012d8:	8b 53 04             	mov    0x4(%ebx),%edx
  8012db:	8b 42 04             	mov    0x4(%edx),%eax
  8012de:	80 38 2d             	cmpb   $0x2d,(%eax)
  8012e1:	75 4c                	jne    80132f <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  8012e3:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8012e7:	74 46                	je     80132f <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8012e9:	83 c0 01             	add    $0x1,%eax
  8012ec:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8012ef:	8b 01                	mov    (%ecx),%eax
  8012f1:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8012f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012fc:	8d 42 08             	lea    0x8(%edx),%eax
  8012ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801303:	83 c2 04             	add    $0x4,%edx
  801306:	89 14 24             	mov    %edx,(%esp)
  801309:	e8 9e f9 ff ff       	call   800cac <memmove>
		(*args->argc)--;
  80130e:	8b 03                	mov    (%ebx),%eax
  801310:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801313:	8b 43 08             	mov    0x8(%ebx),%eax
  801316:	80 38 2d             	cmpb   $0x2d,(%eax)
  801319:	75 06                	jne    801321 <argnext+0x6d>
  80131b:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80131f:	74 0e                	je     80132f <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801321:	8b 53 08             	mov    0x8(%ebx),%edx
  801324:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801327:	83 c2 01             	add    $0x1,%edx
  80132a:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  80132d:	eb 13                	jmp    801342 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  80132f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801336:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80133b:	eb 05                	jmp    801342 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  80133d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801342:	83 c4 14             	add    $0x14,%esp
  801345:	5b                   	pop    %ebx
  801346:	5d                   	pop    %ebp
  801347:	c3                   	ret    

00801348 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	53                   	push   %ebx
  80134c:	83 ec 14             	sub    $0x14,%esp
  80134f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801352:	8b 43 08             	mov    0x8(%ebx),%eax
  801355:	85 c0                	test   %eax,%eax
  801357:	74 5a                	je     8013b3 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  801359:	80 38 00             	cmpb   $0x0,(%eax)
  80135c:	74 0c                	je     80136a <argnextvalue+0x22>
		args->argvalue = args->curarg;
  80135e:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801361:	c7 43 08 88 27 80 00 	movl   $0x802788,0x8(%ebx)
  801368:	eb 44                	jmp    8013ae <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  80136a:	8b 03                	mov    (%ebx),%eax
  80136c:	83 38 01             	cmpl   $0x1,(%eax)
  80136f:	7e 2f                	jle    8013a0 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  801371:	8b 53 04             	mov    0x4(%ebx),%edx
  801374:	8b 4a 04             	mov    0x4(%edx),%ecx
  801377:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80137a:	8b 00                	mov    (%eax),%eax
  80137c:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801383:	89 44 24 08          	mov    %eax,0x8(%esp)
  801387:	8d 42 08             	lea    0x8(%edx),%eax
  80138a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138e:	83 c2 04             	add    $0x4,%edx
  801391:	89 14 24             	mov    %edx,(%esp)
  801394:	e8 13 f9 ff ff       	call   800cac <memmove>
		(*args->argc)--;
  801399:	8b 03                	mov    (%ebx),%eax
  80139b:	83 28 01             	subl   $0x1,(%eax)
  80139e:	eb 0e                	jmp    8013ae <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  8013a0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8013a7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  8013ae:	8b 43 0c             	mov    0xc(%ebx),%eax
  8013b1:	eb 05                	jmp    8013b8 <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  8013b3:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  8013b8:	83 c4 14             	add    $0x14,%esp
  8013bb:	5b                   	pop    %ebx
  8013bc:	5d                   	pop    %ebp
  8013bd:	c3                   	ret    

008013be <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	83 ec 18             	sub    $0x18,%esp
  8013c4:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8013c7:	8b 42 0c             	mov    0xc(%edx),%eax
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	75 08                	jne    8013d6 <argvalue+0x18>
  8013ce:	89 14 24             	mov    %edx,(%esp)
  8013d1:	e8 72 ff ff ff       	call   801348 <argnextvalue>
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    
	...

008013e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8013eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8013ee:	5d                   	pop    %ebp
  8013ef:	c3                   	ret    

008013f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	89 04 24             	mov    %eax,(%esp)
  8013fc:	e8 df ff ff ff       	call   8013e0 <fd2num>
  801401:	05 20 00 0d 00       	add    $0xd0020,%eax
  801406:	c1 e0 0c             	shl    $0xc,%eax
}
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	53                   	push   %ebx
  80140f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801412:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801417:	a8 01                	test   $0x1,%al
  801419:	74 34                	je     80144f <fd_alloc+0x44>
  80141b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801420:	a8 01                	test   $0x1,%al
  801422:	74 32                	je     801456 <fd_alloc+0x4b>
  801424:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801429:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80142b:	89 c2                	mov    %eax,%edx
  80142d:	c1 ea 16             	shr    $0x16,%edx
  801430:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801437:	f6 c2 01             	test   $0x1,%dl
  80143a:	74 1f                	je     80145b <fd_alloc+0x50>
  80143c:	89 c2                	mov    %eax,%edx
  80143e:	c1 ea 0c             	shr    $0xc,%edx
  801441:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801448:	f6 c2 01             	test   $0x1,%dl
  80144b:	75 17                	jne    801464 <fd_alloc+0x59>
  80144d:	eb 0c                	jmp    80145b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80144f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801454:	eb 05                	jmp    80145b <fd_alloc+0x50>
  801456:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80145b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80145d:	b8 00 00 00 00       	mov    $0x0,%eax
  801462:	eb 17                	jmp    80147b <fd_alloc+0x70>
  801464:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801469:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80146e:	75 b9                	jne    801429 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801470:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801476:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80147b:	5b                   	pop    %ebx
  80147c:	5d                   	pop    %ebp
  80147d:	c3                   	ret    

0080147e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801484:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801489:	83 fa 1f             	cmp    $0x1f,%edx
  80148c:	77 3f                	ja     8014cd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80148e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801494:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801497:	89 d0                	mov    %edx,%eax
  801499:	c1 e8 16             	shr    $0x16,%eax
  80149c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014a8:	f6 c1 01             	test   $0x1,%cl
  8014ab:	74 20                	je     8014cd <fd_lookup+0x4f>
  8014ad:	89 d0                	mov    %edx,%eax
  8014af:	c1 e8 0c             	shr    $0xc,%eax
  8014b2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014be:	f6 c1 01             	test   $0x1,%cl
  8014c1:	74 0a                	je     8014cd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	89 10                	mov    %edx,(%eax)
	return 0;
  8014c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014cd:	5d                   	pop    %ebp
  8014ce:	c3                   	ret    

008014cf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	53                   	push   %ebx
  8014d3:	83 ec 14             	sub    $0x14,%esp
  8014d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8014dc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014e1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8014e7:	75 17                	jne    801500 <dev_lookup+0x31>
  8014e9:	eb 07                	jmp    8014f2 <dev_lookup+0x23>
  8014eb:	39 0a                	cmp    %ecx,(%edx)
  8014ed:	75 11                	jne    801500 <dev_lookup+0x31>
  8014ef:	90                   	nop
  8014f0:	eb 05                	jmp    8014f7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8014f2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8014f7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8014f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fe:	eb 35                	jmp    801535 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801500:	83 c0 01             	add    $0x1,%eax
  801503:	8b 14 85 8c 2b 80 00 	mov    0x802b8c(,%eax,4),%edx
  80150a:	85 d2                	test   %edx,%edx
  80150c:	75 dd                	jne    8014eb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80150e:	a1 20 44 80 00       	mov    0x804420,%eax
  801513:	8b 40 48             	mov    0x48(%eax),%eax
  801516:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80151a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151e:	c7 04 24 0c 2b 80 00 	movl   $0x802b0c,(%esp)
  801525:	e8 79 ef ff ff       	call   8004a3 <cprintf>
	*dev = 0;
  80152a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801530:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801535:	83 c4 14             	add    $0x14,%esp
  801538:	5b                   	pop    %ebx
  801539:	5d                   	pop    %ebp
  80153a:	c3                   	ret    

0080153b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 38             	sub    $0x38,%esp
  801541:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801544:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801547:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80154a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80154d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801551:	89 3c 24             	mov    %edi,(%esp)
  801554:	e8 87 fe ff ff       	call   8013e0 <fd2num>
  801559:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80155c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801560:	89 04 24             	mov    %eax,(%esp)
  801563:	e8 16 ff ff ff       	call   80147e <fd_lookup>
  801568:	89 c3                	mov    %eax,%ebx
  80156a:	85 c0                	test   %eax,%eax
  80156c:	78 05                	js     801573 <fd_close+0x38>
	    || fd != fd2)
  80156e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801571:	74 0e                	je     801581 <fd_close+0x46>
		return (must_exist ? r : 0);
  801573:	89 f0                	mov    %esi,%eax
  801575:	84 c0                	test   %al,%al
  801577:	b8 00 00 00 00       	mov    $0x0,%eax
  80157c:	0f 44 d8             	cmove  %eax,%ebx
  80157f:	eb 3d                	jmp    8015be <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801581:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801584:	89 44 24 04          	mov    %eax,0x4(%esp)
  801588:	8b 07                	mov    (%edi),%eax
  80158a:	89 04 24             	mov    %eax,(%esp)
  80158d:	e8 3d ff ff ff       	call   8014cf <dev_lookup>
  801592:	89 c3                	mov    %eax,%ebx
  801594:	85 c0                	test   %eax,%eax
  801596:	78 16                	js     8015ae <fd_close+0x73>
		if (dev->dev_close)
  801598:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80159b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80159e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	74 07                	je     8015ae <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8015a7:	89 3c 24             	mov    %edi,(%esp)
  8015aa:	ff d0                	call   *%eax
  8015ac:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b9:	e8 bb fa ff ff       	call   801079 <sys_page_unmap>
	return r;
}
  8015be:	89 d8                	mov    %ebx,%eax
  8015c0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015c3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015c9:	89 ec                	mov    %ebp,%esp
  8015cb:	5d                   	pop    %ebp
  8015cc:	c3                   	ret    

008015cd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	89 04 24             	mov    %eax,(%esp)
  8015e0:	e8 99 fe ff ff       	call   80147e <fd_lookup>
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	78 13                	js     8015fc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8015e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015f0:	00 
  8015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f4:	89 04 24             	mov    %eax,(%esp)
  8015f7:	e8 3f ff ff ff       	call   80153b <fd_close>
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <close_all>:

void
close_all(void)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	53                   	push   %ebx
  801602:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801605:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80160a:	89 1c 24             	mov    %ebx,(%esp)
  80160d:	e8 bb ff ff ff       	call   8015cd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801612:	83 c3 01             	add    $0x1,%ebx
  801615:	83 fb 20             	cmp    $0x20,%ebx
  801618:	75 f0                	jne    80160a <close_all+0xc>
		close(i);
}
  80161a:	83 c4 14             	add    $0x14,%esp
  80161d:	5b                   	pop    %ebx
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    

00801620 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 58             	sub    $0x58,%esp
  801626:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801629:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80162c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80162f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801632:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801635:	89 44 24 04          	mov    %eax,0x4(%esp)
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	89 04 24             	mov    %eax,(%esp)
  80163f:	e8 3a fe ff ff       	call   80147e <fd_lookup>
  801644:	89 c3                	mov    %eax,%ebx
  801646:	85 c0                	test   %eax,%eax
  801648:	0f 88 e1 00 00 00    	js     80172f <dup+0x10f>
		return r;
	close(newfdnum);
  80164e:	89 3c 24             	mov    %edi,(%esp)
  801651:	e8 77 ff ff ff       	call   8015cd <close>

	newfd = INDEX2FD(newfdnum);
  801656:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80165c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80165f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801662:	89 04 24             	mov    %eax,(%esp)
  801665:	e8 86 fd ff ff       	call   8013f0 <fd2data>
  80166a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80166c:	89 34 24             	mov    %esi,(%esp)
  80166f:	e8 7c fd ff ff       	call   8013f0 <fd2data>
  801674:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801677:	89 d8                	mov    %ebx,%eax
  801679:	c1 e8 16             	shr    $0x16,%eax
  80167c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801683:	a8 01                	test   $0x1,%al
  801685:	74 46                	je     8016cd <dup+0xad>
  801687:	89 d8                	mov    %ebx,%eax
  801689:	c1 e8 0c             	shr    $0xc,%eax
  80168c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801693:	f6 c2 01             	test   $0x1,%dl
  801696:	74 35                	je     8016cd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801698:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80169f:	25 07 0e 00 00       	and    $0xe07,%eax
  8016a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016b6:	00 
  8016b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016c2:	e8 54 f9 ff ff       	call   80101b <sys_page_map>
  8016c7:	89 c3                	mov    %eax,%ebx
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 3b                	js     801708 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016d0:	89 c2                	mov    %eax,%edx
  8016d2:	c1 ea 0c             	shr    $0xc,%edx
  8016d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016dc:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016e2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016e6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016f1:	00 
  8016f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016fd:	e8 19 f9 ff ff       	call   80101b <sys_page_map>
  801702:	89 c3                	mov    %eax,%ebx
  801704:	85 c0                	test   %eax,%eax
  801706:	79 25                	jns    80172d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801708:	89 74 24 04          	mov    %esi,0x4(%esp)
  80170c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801713:	e8 61 f9 ff ff       	call   801079 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801718:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80171b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801726:	e8 4e f9 ff ff       	call   801079 <sys_page_unmap>
	return r;
  80172b:	eb 02                	jmp    80172f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80172d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80172f:	89 d8                	mov    %ebx,%eax
  801731:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801734:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801737:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80173a:	89 ec                	mov    %ebp,%esp
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    

0080173e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	53                   	push   %ebx
  801742:	83 ec 24             	sub    $0x24,%esp
  801745:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801748:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80174b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80174f:	89 1c 24             	mov    %ebx,(%esp)
  801752:	e8 27 fd ff ff       	call   80147e <fd_lookup>
  801757:	85 c0                	test   %eax,%eax
  801759:	78 6d                	js     8017c8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80175b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801765:	8b 00                	mov    (%eax),%eax
  801767:	89 04 24             	mov    %eax,(%esp)
  80176a:	e8 60 fd ff ff       	call   8014cf <dev_lookup>
  80176f:	85 c0                	test   %eax,%eax
  801771:	78 55                	js     8017c8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801776:	8b 50 08             	mov    0x8(%eax),%edx
  801779:	83 e2 03             	and    $0x3,%edx
  80177c:	83 fa 01             	cmp    $0x1,%edx
  80177f:	75 23                	jne    8017a4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801781:	a1 20 44 80 00       	mov    0x804420,%eax
  801786:	8b 40 48             	mov    0x48(%eax),%eax
  801789:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80178d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801791:	c7 04 24 50 2b 80 00 	movl   $0x802b50,(%esp)
  801798:	e8 06 ed ff ff       	call   8004a3 <cprintf>
		return -E_INVAL;
  80179d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a2:	eb 24                	jmp    8017c8 <read+0x8a>
	}
	if (!dev->dev_read)
  8017a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a7:	8b 52 08             	mov    0x8(%edx),%edx
  8017aa:	85 d2                	test   %edx,%edx
  8017ac:	74 15                	je     8017c3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017bc:	89 04 24             	mov    %eax,(%esp)
  8017bf:	ff d2                	call   *%edx
  8017c1:	eb 05                	jmp    8017c8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8017c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8017c8:	83 c4 24             	add    $0x24,%esp
  8017cb:	5b                   	pop    %ebx
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    

008017ce <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	57                   	push   %edi
  8017d2:	56                   	push   %esi
  8017d3:	53                   	push   %ebx
  8017d4:	83 ec 1c             	sub    $0x1c,%esp
  8017d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017da:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e2:	85 f6                	test   %esi,%esi
  8017e4:	74 30                	je     801816 <readn+0x48>
  8017e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017eb:	89 f2                	mov    %esi,%edx
  8017ed:	29 c2                	sub    %eax,%edx
  8017ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  8017f3:	03 45 0c             	add    0xc(%ebp),%eax
  8017f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fa:	89 3c 24             	mov    %edi,(%esp)
  8017fd:	e8 3c ff ff ff       	call   80173e <read>
		if (m < 0)
  801802:	85 c0                	test   %eax,%eax
  801804:	78 10                	js     801816 <readn+0x48>
			return m;
		if (m == 0)
  801806:	85 c0                	test   %eax,%eax
  801808:	74 0a                	je     801814 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80180a:	01 c3                	add    %eax,%ebx
  80180c:	89 d8                	mov    %ebx,%eax
  80180e:	39 f3                	cmp    %esi,%ebx
  801810:	72 d9                	jb     8017eb <readn+0x1d>
  801812:	eb 02                	jmp    801816 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801814:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801816:	83 c4 1c             	add    $0x1c,%esp
  801819:	5b                   	pop    %ebx
  80181a:	5e                   	pop    %esi
  80181b:	5f                   	pop    %edi
  80181c:	5d                   	pop    %ebp
  80181d:	c3                   	ret    

0080181e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	53                   	push   %ebx
  801822:	83 ec 24             	sub    $0x24,%esp
  801825:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801828:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80182b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182f:	89 1c 24             	mov    %ebx,(%esp)
  801832:	e8 47 fc ff ff       	call   80147e <fd_lookup>
  801837:	85 c0                	test   %eax,%eax
  801839:	78 68                	js     8018a3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80183b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801845:	8b 00                	mov    (%eax),%eax
  801847:	89 04 24             	mov    %eax,(%esp)
  80184a:	e8 80 fc ff ff       	call   8014cf <dev_lookup>
  80184f:	85 c0                	test   %eax,%eax
  801851:	78 50                	js     8018a3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801856:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80185a:	75 23                	jne    80187f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80185c:	a1 20 44 80 00       	mov    0x804420,%eax
  801861:	8b 40 48             	mov    0x48(%eax),%eax
  801864:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801868:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186c:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
  801873:	e8 2b ec ff ff       	call   8004a3 <cprintf>
		return -E_INVAL;
  801878:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80187d:	eb 24                	jmp    8018a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80187f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801882:	8b 52 0c             	mov    0xc(%edx),%edx
  801885:	85 d2                	test   %edx,%edx
  801887:	74 15                	je     80189e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801889:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801890:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801893:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801897:	89 04 24             	mov    %eax,(%esp)
  80189a:	ff d2                	call   *%edx
  80189c:	eb 05                	jmp    8018a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80189e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8018a3:	83 c4 24             	add    $0x24,%esp
  8018a6:	5b                   	pop    %ebx
  8018a7:	5d                   	pop    %ebp
  8018a8:	c3                   	ret    

008018a9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018af:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	89 04 24             	mov    %eax,(%esp)
  8018bc:	e8 bd fb ff ff       	call   80147e <fd_lookup>
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 0e                	js     8018d3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	53                   	push   %ebx
  8018d9:	83 ec 24             	sub    $0x24,%esp
  8018dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e6:	89 1c 24             	mov    %ebx,(%esp)
  8018e9:	e8 90 fb ff ff       	call   80147e <fd_lookup>
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	78 61                	js     801953 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fc:	8b 00                	mov    (%eax),%eax
  8018fe:	89 04 24             	mov    %eax,(%esp)
  801901:	e8 c9 fb ff ff       	call   8014cf <dev_lookup>
  801906:	85 c0                	test   %eax,%eax
  801908:	78 49                	js     801953 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80190a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801911:	75 23                	jne    801936 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801913:	a1 20 44 80 00       	mov    0x804420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801918:	8b 40 48             	mov    0x48(%eax),%eax
  80191b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80191f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801923:	c7 04 24 2c 2b 80 00 	movl   $0x802b2c,(%esp)
  80192a:	e8 74 eb ff ff       	call   8004a3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80192f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801934:	eb 1d                	jmp    801953 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801936:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801939:	8b 52 18             	mov    0x18(%edx),%edx
  80193c:	85 d2                	test   %edx,%edx
  80193e:	74 0e                	je     80194e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801940:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801943:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801947:	89 04 24             	mov    %eax,(%esp)
  80194a:	ff d2                	call   *%edx
  80194c:	eb 05                	jmp    801953 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80194e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801953:	83 c4 24             	add    $0x24,%esp
  801956:	5b                   	pop    %ebx
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    

00801959 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	53                   	push   %ebx
  80195d:	83 ec 24             	sub    $0x24,%esp
  801960:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801963:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801966:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	89 04 24             	mov    %eax,(%esp)
  801970:	e8 09 fb ff ff       	call   80147e <fd_lookup>
  801975:	85 c0                	test   %eax,%eax
  801977:	78 52                	js     8019cb <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801979:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801980:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801983:	8b 00                	mov    (%eax),%eax
  801985:	89 04 24             	mov    %eax,(%esp)
  801988:	e8 42 fb ff ff       	call   8014cf <dev_lookup>
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 3a                	js     8019cb <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801994:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801998:	74 2c                	je     8019c6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80199a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80199d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019a4:	00 00 00 
	stat->st_isdir = 0;
  8019a7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019ae:	00 00 00 
	stat->st_dev = dev;
  8019b1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019be:	89 14 24             	mov    %edx,(%esp)
  8019c1:	ff 50 14             	call   *0x14(%eax)
  8019c4:	eb 05                	jmp    8019cb <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8019c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8019cb:	83 c4 24             	add    $0x24,%esp
  8019ce:	5b                   	pop    %ebx
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    

008019d1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 18             	sub    $0x18,%esp
  8019d7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8019da:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019e4:	00 
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	89 04 24             	mov    %eax,(%esp)
  8019eb:	e8 bc 01 00 00       	call   801bac <open>
  8019f0:	89 c3                	mov    %eax,%ebx
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 1b                	js     801a11 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8019f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fd:	89 1c 24             	mov    %ebx,(%esp)
  801a00:	e8 54 ff ff ff       	call   801959 <fstat>
  801a05:	89 c6                	mov    %eax,%esi
	close(fd);
  801a07:	89 1c 24             	mov    %ebx,(%esp)
  801a0a:	e8 be fb ff ff       	call   8015cd <close>
	return r;
  801a0f:	89 f3                	mov    %esi,%ebx
}
  801a11:	89 d8                	mov    %ebx,%eax
  801a13:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a16:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a19:	89 ec                	mov    %ebp,%esp
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    
  801a1d:	00 00                	add    %al,(%eax)
	...

00801a20 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 18             	sub    $0x18,%esp
  801a26:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a29:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801a2c:	89 c3                	mov    %eax,%ebx
  801a2e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801a30:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a37:	75 11                	jne    801a4a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a40:	e8 91 09 00 00       	call   8023d6 <ipc_find_env>
  801a45:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a4a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a51:	00 
  801a52:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801a59:	00 
  801a5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a5e:	a1 00 40 80 00       	mov    0x804000,%eax
  801a63:	89 04 24             	mov    %eax,(%esp)
  801a66:	e8 e7 08 00 00       	call   802352 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a72:	00 
  801a73:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7e:	e8 7d 08 00 00       	call   802300 <ipc_recv>
}
  801a83:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a86:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a89:	89 ec                	mov    %ebp,%esp
  801a8b:	5d                   	pop    %ebp
  801a8c:	c3                   	ret    

00801a8d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	53                   	push   %ebx
  801a91:	83 ec 14             	sub    $0x14,%esp
  801a94:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a9d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa7:	b8 05 00 00 00       	mov    $0x5,%eax
  801aac:	e8 6f ff ff ff       	call   801a20 <fsipc>
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	78 2b                	js     801ae0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ab5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801abc:	00 
  801abd:	89 1c 24             	mov    %ebx,(%esp)
  801ac0:	e8 f6 ef ff ff       	call   800abb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ac5:	a1 80 50 80 00       	mov    0x805080,%eax
  801aca:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ad0:	a1 84 50 80 00       	mov    0x805084,%eax
  801ad5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae0:	83 c4 14             	add    $0x14,%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5d                   	pop    %ebp
  801ae5:	c3                   	ret    

00801ae6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	8b 40 0c             	mov    0xc(%eax),%eax
  801af2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801af7:	ba 00 00 00 00       	mov    $0x0,%edx
  801afc:	b8 06 00 00 00       	mov    $0x6,%eax
  801b01:	e8 1a ff ff ff       	call   801a20 <fsipc>
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	56                   	push   %esi
  801b0c:	53                   	push   %ebx
  801b0d:	83 ec 10             	sub    $0x10,%esp
  801b10:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	8b 40 0c             	mov    0xc(%eax),%eax
  801b19:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b1e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b24:	ba 00 00 00 00       	mov    $0x0,%edx
  801b29:	b8 03 00 00 00       	mov    $0x3,%eax
  801b2e:	e8 ed fe ff ff       	call   801a20 <fsipc>
  801b33:	89 c3                	mov    %eax,%ebx
  801b35:	85 c0                	test   %eax,%eax
  801b37:	78 6a                	js     801ba3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b39:	39 c6                	cmp    %eax,%esi
  801b3b:	73 24                	jae    801b61 <devfile_read+0x59>
  801b3d:	c7 44 24 0c 9c 2b 80 	movl   $0x802b9c,0xc(%esp)
  801b44:	00 
  801b45:	c7 44 24 08 a3 2b 80 	movl   $0x802ba3,0x8(%esp)
  801b4c:	00 
  801b4d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801b54:	00 
  801b55:	c7 04 24 b8 2b 80 00 	movl   $0x802bb8,(%esp)
  801b5c:	e8 47 e8 ff ff       	call   8003a8 <_panic>
	assert(r <= PGSIZE);
  801b61:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b66:	7e 24                	jle    801b8c <devfile_read+0x84>
  801b68:	c7 44 24 0c c3 2b 80 	movl   $0x802bc3,0xc(%esp)
  801b6f:	00 
  801b70:	c7 44 24 08 a3 2b 80 	movl   $0x802ba3,0x8(%esp)
  801b77:	00 
  801b78:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801b7f:	00 
  801b80:	c7 04 24 b8 2b 80 00 	movl   $0x802bb8,(%esp)
  801b87:	e8 1c e8 ff ff       	call   8003a8 <_panic>
	memmove(buf, &fsipcbuf, r);
  801b8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b90:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b97:	00 
  801b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9b:	89 04 24             	mov    %eax,(%esp)
  801b9e:	e8 09 f1 ff ff       	call   800cac <memmove>
	return r;
}
  801ba3:	89 d8                	mov    %ebx,%eax
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	5b                   	pop    %ebx
  801ba9:	5e                   	pop    %esi
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    

00801bac <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	56                   	push   %esi
  801bb0:	53                   	push   %ebx
  801bb1:	83 ec 20             	sub    $0x20,%esp
  801bb4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801bb7:	89 34 24             	mov    %esi,(%esp)
  801bba:	e8 b1 ee ff ff       	call   800a70 <strlen>
		return -E_BAD_PATH;
  801bbf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801bc4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bc9:	7f 5e                	jg     801c29 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801bcb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bce:	89 04 24             	mov    %eax,(%esp)
  801bd1:	e8 35 f8 ff ff       	call   80140b <fd_alloc>
  801bd6:	89 c3                	mov    %eax,%ebx
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	78 4d                	js     801c29 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801bdc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801be0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801be7:	e8 cf ee ff ff       	call   800abb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bef:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bf7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfc:	e8 1f fe ff ff       	call   801a20 <fsipc>
  801c01:	89 c3                	mov    %eax,%ebx
  801c03:	85 c0                	test   %eax,%eax
  801c05:	79 15                	jns    801c1c <open+0x70>
		fd_close(fd, 0);
  801c07:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c0e:	00 
  801c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c12:	89 04 24             	mov    %eax,(%esp)
  801c15:	e8 21 f9 ff ff       	call   80153b <fd_close>
		return r;
  801c1a:	eb 0d                	jmp    801c29 <open+0x7d>
	}

	return fd2num(fd);
  801c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1f:	89 04 24             	mov    %eax,(%esp)
  801c22:	e8 b9 f7 ff ff       	call   8013e0 <fd2num>
  801c27:	89 c3                	mov    %eax,%ebx
}
  801c29:	89 d8                	mov    %ebx,%eax
  801c2b:	83 c4 20             	add    $0x20,%esp
  801c2e:	5b                   	pop    %ebx
  801c2f:	5e                   	pop    %esi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    
	...

00801c34 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	53                   	push   %ebx
  801c38:	83 ec 14             	sub    $0x14,%esp
  801c3b:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801c3d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801c41:	7e 31                	jle    801c74 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801c43:	8b 40 04             	mov    0x4(%eax),%eax
  801c46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c4a:	8d 43 10             	lea    0x10(%ebx),%eax
  801c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c51:	8b 03                	mov    (%ebx),%eax
  801c53:	89 04 24             	mov    %eax,(%esp)
  801c56:	e8 c3 fb ff ff       	call   80181e <write>
		if (result > 0)
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	7e 03                	jle    801c62 <writebuf+0x2e>
			b->result += result;
  801c5f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801c62:	39 43 04             	cmp    %eax,0x4(%ebx)
  801c65:	74 0d                	je     801c74 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801c67:	85 c0                	test   %eax,%eax
  801c69:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6e:	0f 4f c2             	cmovg  %edx,%eax
  801c71:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801c74:	83 c4 14             	add    $0x14,%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5d                   	pop    %ebp
  801c79:	c3                   	ret    

00801c7a <putch>:

static void
putch(int ch, void *thunk)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	53                   	push   %ebx
  801c7e:	83 ec 04             	sub    $0x4,%esp
  801c81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801c84:	8b 43 04             	mov    0x4(%ebx),%eax
  801c87:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8a:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801c8e:	83 c0 01             	add    $0x1,%eax
  801c91:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801c94:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c99:	75 0e                	jne    801ca9 <putch+0x2f>
		writebuf(b);
  801c9b:	89 d8                	mov    %ebx,%eax
  801c9d:	e8 92 ff ff ff       	call   801c34 <writebuf>
		b->idx = 0;
  801ca2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801ca9:	83 c4 04             	add    $0x4,%esp
  801cac:	5b                   	pop    %ebx
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    

00801caf <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801cc1:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801cc8:	00 00 00 
	b.result = 0;
  801ccb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801cd2:	00 00 00 
	b.error = 1;
  801cd5:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801cdc:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801cdf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ced:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf7:	c7 04 24 7a 1c 80 00 	movl   $0x801c7a,(%esp)
  801cfe:	e8 17 e9 ff ff       	call   80061a <vprintfmt>
	if (b.idx > 0)
  801d03:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801d0a:	7e 0b                	jle    801d17 <vfprintf+0x68>
		writebuf(&b);
  801d0c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801d12:	e8 1d ff ff ff       	call   801c34 <writebuf>

	return (b.result ? b.result : b.error);
  801d17:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d2e:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801d31:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	89 04 24             	mov    %eax,(%esp)
  801d42:	e8 68 ff ff ff       	call   801caf <vfprintf>
	va_end(ap);

	return cnt;
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <printf>:

int
printf(const char *fmt, ...)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d4f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801d52:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d64:	e8 46 ff ff ff       	call   801caf <vfprintf>
	va_end(ap);

	return cnt;
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    
  801d6b:	00 00                	add    %al,(%eax)
  801d6d:	00 00                	add    %al,(%eax)
	...

00801d70 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 18             	sub    $0x18,%esp
  801d76:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d79:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d7c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	89 04 24             	mov    %eax,(%esp)
  801d85:	e8 66 f6 ff ff       	call   8013f0 <fd2data>
  801d8a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801d8c:	c7 44 24 04 cf 2b 80 	movl   $0x802bcf,0x4(%esp)
  801d93:	00 
  801d94:	89 34 24             	mov    %esi,(%esp)
  801d97:	e8 1f ed ff ff       	call   800abb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d9c:	8b 43 04             	mov    0x4(%ebx),%eax
  801d9f:	2b 03                	sub    (%ebx),%eax
  801da1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801da7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801dae:	00 00 00 
	stat->st_dev = &devpipe;
  801db1:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801db8:	30 80 00 
	return 0;
}
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801dc3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801dc6:	89 ec                	mov    %ebp,%esp
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	53                   	push   %ebx
  801dce:	83 ec 14             	sub    $0x14,%esp
  801dd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dd4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dd8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ddf:	e8 95 f2 ff ff       	call   801079 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801de4:	89 1c 24             	mov    %ebx,(%esp)
  801de7:	e8 04 f6 ff ff       	call   8013f0 <fd2data>
  801dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df7:	e8 7d f2 ff ff       	call   801079 <sys_page_unmap>
}
  801dfc:	83 c4 14             	add    $0x14,%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	57                   	push   %edi
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	83 ec 2c             	sub    $0x2c,%esp
  801e0b:	89 c7                	mov    %eax,%edi
  801e0d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e10:	a1 20 44 80 00       	mov    0x804420,%eax
  801e15:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e18:	89 3c 24             	mov    %edi,(%esp)
  801e1b:	e8 00 06 00 00       	call   802420 <pageref>
  801e20:	89 c6                	mov    %eax,%esi
  801e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e25:	89 04 24             	mov    %eax,(%esp)
  801e28:	e8 f3 05 00 00       	call   802420 <pageref>
  801e2d:	39 c6                	cmp    %eax,%esi
  801e2f:	0f 94 c0             	sete   %al
  801e32:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801e35:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801e3b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e3e:	39 cb                	cmp    %ecx,%ebx
  801e40:	75 08                	jne    801e4a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801e42:	83 c4 2c             	add    $0x2c,%esp
  801e45:	5b                   	pop    %ebx
  801e46:	5e                   	pop    %esi
  801e47:	5f                   	pop    %edi
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801e4a:	83 f8 01             	cmp    $0x1,%eax
  801e4d:	75 c1                	jne    801e10 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e4f:	8b 52 58             	mov    0x58(%edx),%edx
  801e52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e56:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e5e:	c7 04 24 d6 2b 80 00 	movl   $0x802bd6,(%esp)
  801e65:	e8 39 e6 ff ff       	call   8004a3 <cprintf>
  801e6a:	eb a4                	jmp    801e10 <_pipeisclosed+0xe>

00801e6c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	57                   	push   %edi
  801e70:	56                   	push   %esi
  801e71:	53                   	push   %ebx
  801e72:	83 ec 2c             	sub    $0x2c,%esp
  801e75:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e78:	89 34 24             	mov    %esi,(%esp)
  801e7b:	e8 70 f5 ff ff       	call   8013f0 <fd2data>
  801e80:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e82:	bf 00 00 00 00       	mov    $0x0,%edi
  801e87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e8b:	75 50                	jne    801edd <devpipe_write+0x71>
  801e8d:	eb 5c                	jmp    801eeb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e8f:	89 da                	mov    %ebx,%edx
  801e91:	89 f0                	mov    %esi,%eax
  801e93:	e8 6a ff ff ff       	call   801e02 <_pipeisclosed>
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	75 53                	jne    801eef <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e9c:	e8 eb f0 ff ff       	call   800f8c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ea1:	8b 43 04             	mov    0x4(%ebx),%eax
  801ea4:	8b 13                	mov    (%ebx),%edx
  801ea6:	83 c2 20             	add    $0x20,%edx
  801ea9:	39 d0                	cmp    %edx,%eax
  801eab:	73 e2                	jae    801e8f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb0:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801eb4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801eb7:	89 c2                	mov    %eax,%edx
  801eb9:	c1 fa 1f             	sar    $0x1f,%edx
  801ebc:	c1 ea 1b             	shr    $0x1b,%edx
  801ebf:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ec2:	83 e1 1f             	and    $0x1f,%ecx
  801ec5:	29 d1                	sub    %edx,%ecx
  801ec7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801ecb:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ecf:	83 c0 01             	add    $0x1,%eax
  801ed2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ed5:	83 c7 01             	add    $0x1,%edi
  801ed8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801edb:	74 0e                	je     801eeb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801edd:	8b 43 04             	mov    0x4(%ebx),%eax
  801ee0:	8b 13                	mov    (%ebx),%edx
  801ee2:	83 c2 20             	add    $0x20,%edx
  801ee5:	39 d0                	cmp    %edx,%eax
  801ee7:	73 a6                	jae    801e8f <devpipe_write+0x23>
  801ee9:	eb c2                	jmp    801ead <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801eeb:	89 f8                	mov    %edi,%eax
  801eed:	eb 05                	jmp    801ef4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ef4:	83 c4 2c             	add    $0x2c,%esp
  801ef7:	5b                   	pop    %ebx
  801ef8:	5e                   	pop    %esi
  801ef9:	5f                   	pop    %edi
  801efa:	5d                   	pop    %ebp
  801efb:	c3                   	ret    

00801efc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 28             	sub    $0x28,%esp
  801f02:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f05:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801f08:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801f0b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f0e:	89 3c 24             	mov    %edi,(%esp)
  801f11:	e8 da f4 ff ff       	call   8013f0 <fd2data>
  801f16:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f18:	be 00 00 00 00       	mov    $0x0,%esi
  801f1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f21:	75 47                	jne    801f6a <devpipe_read+0x6e>
  801f23:	eb 52                	jmp    801f77 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801f25:	89 f0                	mov    %esi,%eax
  801f27:	eb 5e                	jmp    801f87 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f29:	89 da                	mov    %ebx,%edx
  801f2b:	89 f8                	mov    %edi,%eax
  801f2d:	8d 76 00             	lea    0x0(%esi),%esi
  801f30:	e8 cd fe ff ff       	call   801e02 <_pipeisclosed>
  801f35:	85 c0                	test   %eax,%eax
  801f37:	75 49                	jne    801f82 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f39:	e8 4e f0 ff ff       	call   800f8c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f3e:	8b 03                	mov    (%ebx),%eax
  801f40:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f43:	74 e4                	je     801f29 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f45:	89 c2                	mov    %eax,%edx
  801f47:	c1 fa 1f             	sar    $0x1f,%edx
  801f4a:	c1 ea 1b             	shr    $0x1b,%edx
  801f4d:	01 d0                	add    %edx,%eax
  801f4f:	83 e0 1f             	and    $0x1f,%eax
  801f52:	29 d0                	sub    %edx,%eax
  801f54:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801f5f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f62:	83 c6 01             	add    $0x1,%esi
  801f65:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f68:	74 0d                	je     801f77 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801f6a:	8b 03                	mov    (%ebx),%eax
  801f6c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f6f:	75 d4                	jne    801f45 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f71:	85 f6                	test   %esi,%esi
  801f73:	75 b0                	jne    801f25 <devpipe_read+0x29>
  801f75:	eb b2                	jmp    801f29 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f77:	89 f0                	mov    %esi,%eax
  801f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f80:	eb 05                	jmp    801f87 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f87:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f8a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f8d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f90:	89 ec                	mov    %ebp,%esp
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    

00801f94 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 48             	sub    $0x48,%esp
  801f9a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f9d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801fa0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801fa3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fa6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fa9:	89 04 24             	mov    %eax,(%esp)
  801fac:	e8 5a f4 ff ff       	call   80140b <fd_alloc>
  801fb1:	89 c3                	mov    %eax,%ebx
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	0f 88 45 01 00 00    	js     802100 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fbb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fc2:	00 
  801fc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd1:	e8 e6 ef ff ff       	call   800fbc <sys_page_alloc>
  801fd6:	89 c3                	mov    %eax,%ebx
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	0f 88 20 01 00 00    	js     802100 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fe0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801fe3:	89 04 24             	mov    %eax,(%esp)
  801fe6:	e8 20 f4 ff ff       	call   80140b <fd_alloc>
  801feb:	89 c3                	mov    %eax,%ebx
  801fed:	85 c0                	test   %eax,%eax
  801fef:	0f 88 f8 00 00 00    	js     8020ed <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ffc:	00 
  801ffd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802000:	89 44 24 04          	mov    %eax,0x4(%esp)
  802004:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80200b:	e8 ac ef ff ff       	call   800fbc <sys_page_alloc>
  802010:	89 c3                	mov    %eax,%ebx
  802012:	85 c0                	test   %eax,%eax
  802014:	0f 88 d3 00 00 00    	js     8020ed <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80201a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80201d:	89 04 24             	mov    %eax,(%esp)
  802020:	e8 cb f3 ff ff       	call   8013f0 <fd2data>
  802025:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802027:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80202e:	00 
  80202f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802033:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80203a:	e8 7d ef ff ff       	call   800fbc <sys_page_alloc>
  80203f:	89 c3                	mov    %eax,%ebx
  802041:	85 c0                	test   %eax,%eax
  802043:	0f 88 91 00 00 00    	js     8020da <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802049:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80204c:	89 04 24             	mov    %eax,(%esp)
  80204f:	e8 9c f3 ff ff       	call   8013f0 <fd2data>
  802054:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80205b:	00 
  80205c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802060:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802067:	00 
  802068:	89 74 24 04          	mov    %esi,0x4(%esp)
  80206c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802073:	e8 a3 ef ff ff       	call   80101b <sys_page_map>
  802078:	89 c3                	mov    %eax,%ebx
  80207a:	85 c0                	test   %eax,%eax
  80207c:	78 4c                	js     8020ca <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80207e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802084:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802087:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80208c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802093:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802099:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80209c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80209e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020a1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8020a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ab:	89 04 24             	mov    %eax,(%esp)
  8020ae:	e8 2d f3 ff ff       	call   8013e0 <fd2num>
  8020b3:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8020b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020b8:	89 04 24             	mov    %eax,(%esp)
  8020bb:	e8 20 f3 ff ff       	call   8013e0 <fd2num>
  8020c0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8020c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020c8:	eb 36                	jmp    802100 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  8020ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d5:	e8 9f ef ff ff       	call   801079 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e8:	e8 8c ef ff ff       	call   801079 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020fb:	e8 79 ef ff ff       	call   801079 <sys_page_unmap>
    err:
	return r;
}
  802100:	89 d8                	mov    %ebx,%eax
  802102:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802105:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802108:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80210b:	89 ec                	mov    %ebp,%esp
  80210d:	5d                   	pop    %ebp
  80210e:	c3                   	ret    

0080210f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802115:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	89 04 24             	mov    %eax,(%esp)
  802122:	e8 57 f3 ff ff       	call   80147e <fd_lookup>
  802127:	85 c0                	test   %eax,%eax
  802129:	78 15                	js     802140 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80212b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212e:	89 04 24             	mov    %eax,(%esp)
  802131:	e8 ba f2 ff ff       	call   8013f0 <fd2data>
	return _pipeisclosed(fd, p);
  802136:	89 c2                	mov    %eax,%edx
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	e8 c2 fc ff ff       	call   801e02 <_pipeisclosed>
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    
	...

00802150 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802153:	b8 00 00 00 00       	mov    $0x0,%eax
  802158:	5d                   	pop    %ebp
  802159:	c3                   	ret    

0080215a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802160:	c7 44 24 04 ee 2b 80 	movl   $0x802bee,0x4(%esp)
  802167:	00 
  802168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216b:	89 04 24             	mov    %eax,(%esp)
  80216e:	e8 48 e9 ff ff       	call   800abb <strcpy>
	return 0;
}
  802173:	b8 00 00 00 00       	mov    $0x0,%eax
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	57                   	push   %edi
  80217e:	56                   	push   %esi
  80217f:	53                   	push   %ebx
  802180:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802186:	be 00 00 00 00       	mov    $0x0,%esi
  80218b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80218f:	74 43                	je     8021d4 <devcons_write+0x5a>
  802191:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802196:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80219c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80219f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8021a1:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8021a4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8021a9:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8021ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b0:	03 45 0c             	add    0xc(%ebp),%eax
  8021b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b7:	89 3c 24             	mov    %edi,(%esp)
  8021ba:	e8 ed ea ff ff       	call   800cac <memmove>
		sys_cputs(buf, m);
  8021bf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021c3:	89 3c 24             	mov    %edi,(%esp)
  8021c6:	e8 d5 ec ff ff       	call   800ea0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021cb:	01 de                	add    %ebx,%esi
  8021cd:	89 f0                	mov    %esi,%eax
  8021cf:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021d2:	72 c8                	jb     80219c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8021d4:	89 f0                	mov    %esi,%eax
  8021d6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8021dc:	5b                   	pop    %ebx
  8021dd:	5e                   	pop    %esi
  8021de:	5f                   	pop    %edi
  8021df:	5d                   	pop    %ebp
  8021e0:	c3                   	ret    

008021e1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8021ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021f0:	75 07                	jne    8021f9 <devcons_read+0x18>
  8021f2:	eb 31                	jmp    802225 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021f4:	e8 93 ed ff ff       	call   800f8c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802200:	e8 ca ec ff ff       	call   800ecf <sys_cgetc>
  802205:	85 c0                	test   %eax,%eax
  802207:	74 eb                	je     8021f4 <devcons_read+0x13>
  802209:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80220b:	85 c0                	test   %eax,%eax
  80220d:	78 16                	js     802225 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80220f:	83 f8 04             	cmp    $0x4,%eax
  802212:	74 0c                	je     802220 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  802214:	8b 45 0c             	mov    0xc(%ebp),%eax
  802217:	88 10                	mov    %dl,(%eax)
	return 1;
  802219:	b8 01 00 00 00       	mov    $0x1,%eax
  80221e:	eb 05                	jmp    802225 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802220:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802233:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80223a:	00 
  80223b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80223e:	89 04 24             	mov    %eax,(%esp)
  802241:	e8 5a ec ff ff       	call   800ea0 <sys_cputs>
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <getchar>:

int
getchar(void)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80224e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802255:	00 
  802256:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802259:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802264:	e8 d5 f4 ff ff       	call   80173e <read>
	if (r < 0)
  802269:	85 c0                	test   %eax,%eax
  80226b:	78 0f                	js     80227c <getchar+0x34>
		return r;
	if (r < 1)
  80226d:	85 c0                	test   %eax,%eax
  80226f:	7e 06                	jle    802277 <getchar+0x2f>
		return -E_EOF;
	return c;
  802271:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802275:	eb 05                	jmp    80227c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802277:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802284:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802287:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	89 04 24             	mov    %eax,(%esp)
  802291:	e8 e8 f1 ff ff       	call   80147e <fd_lookup>
  802296:	85 c0                	test   %eax,%eax
  802298:	78 11                	js     8022ab <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022a3:	39 10                	cmp    %edx,(%eax)
  8022a5:	0f 94 c0             	sete   %al
  8022a8:	0f b6 c0             	movzbl %al,%eax
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <opencons>:

int
opencons(void)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022b6:	89 04 24             	mov    %eax,(%esp)
  8022b9:	e8 4d f1 ff ff       	call   80140b <fd_alloc>
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	78 3c                	js     8022fe <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022c9:	00 
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d8:	e8 df ec ff ff       	call   800fbc <sys_page_alloc>
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	78 1d                	js     8022fe <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8022e1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022f6:	89 04 24             	mov    %eax,(%esp)
  8022f9:	e8 e2 f0 ff ff       	call   8013e0 <fd2num>
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	56                   	push   %esi
  802304:	53                   	push   %ebx
  802305:	83 ec 10             	sub    $0x10,%esp
  802308:	8b 75 08             	mov    0x8(%ebp),%esi
  80230b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802311:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802313:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802318:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80231b:	89 04 24             	mov    %eax,(%esp)
  80231e:	e8 02 ef ff ff       	call   801225 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802323:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802328:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80232d:	85 c0                	test   %eax,%eax
  80232f:	78 0e                	js     80233f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  802331:	a1 20 44 80 00       	mov    0x804420,%eax
  802336:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  802339:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80233c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80233f:	85 f6                	test   %esi,%esi
  802341:	74 02                	je     802345 <ipc_recv+0x45>
		*from_env_store = sender;
  802343:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  802345:	85 db                	test   %ebx,%ebx
  802347:	74 02                	je     80234b <ipc_recv+0x4b>
		*perm_store = perm;
  802349:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80234b:	83 c4 10             	add    $0x10,%esp
  80234e:	5b                   	pop    %ebx
  80234f:	5e                   	pop    %esi
  802350:	5d                   	pop    %ebp
  802351:	c3                   	ret    

00802352 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	57                   	push   %edi
  802356:	56                   	push   %esi
  802357:	53                   	push   %ebx
  802358:	83 ec 1c             	sub    $0x1c,%esp
  80235b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80235e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802361:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  802364:	85 db                	test   %ebx,%ebx
  802366:	75 04                	jne    80236c <ipc_send+0x1a>
  802368:	85 f6                	test   %esi,%esi
  80236a:	75 15                	jne    802381 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80236c:	85 db                	test   %ebx,%ebx
  80236e:	74 16                	je     802386 <ipc_send+0x34>
  802370:	85 f6                	test   %esi,%esi
  802372:	0f 94 c0             	sete   %al
      pg = 0;
  802375:	84 c0                	test   %al,%al
  802377:	b8 00 00 00 00       	mov    $0x0,%eax
  80237c:	0f 45 d8             	cmovne %eax,%ebx
  80237f:	eb 05                	jmp    802386 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802381:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802386:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80238a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80238e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	89 04 24             	mov    %eax,(%esp)
  802398:	e8 54 ee ff ff       	call   8011f1 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80239d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023a0:	75 07                	jne    8023a9 <ipc_send+0x57>
           sys_yield();
  8023a2:	e8 e5 eb ff ff       	call   800f8c <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  8023a7:	eb dd                	jmp    802386 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	90                   	nop
  8023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023b0:	74 1c                	je     8023ce <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  8023b2:	c7 44 24 08 fa 2b 80 	movl   $0x802bfa,0x8(%esp)
  8023b9:	00 
  8023ba:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8023c1:	00 
  8023c2:	c7 04 24 04 2c 80 00 	movl   $0x802c04,(%esp)
  8023c9:	e8 da df ff ff       	call   8003a8 <_panic>
		}
    }
}
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    

008023d6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8023dc:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8023e1:	39 c8                	cmp    %ecx,%eax
  8023e3:	74 17                	je     8023fc <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023e5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8023ea:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023ed:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023f3:	8b 52 50             	mov    0x50(%edx),%edx
  8023f6:	39 ca                	cmp    %ecx,%edx
  8023f8:	75 14                	jne    80240e <ipc_find_env+0x38>
  8023fa:	eb 05                	jmp    802401 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023fc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802401:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802404:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802409:	8b 40 40             	mov    0x40(%eax),%eax
  80240c:	eb 0e                	jmp    80241c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80240e:	83 c0 01             	add    $0x1,%eax
  802411:	3d 00 04 00 00       	cmp    $0x400,%eax
  802416:	75 d2                	jne    8023ea <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802418:	66 b8 00 00          	mov    $0x0,%ax
}
  80241c:	5d                   	pop    %ebp
  80241d:	c3                   	ret    
	...

00802420 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802426:	89 d0                	mov    %edx,%eax
  802428:	c1 e8 16             	shr    $0x16,%eax
  80242b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802432:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802437:	f6 c1 01             	test   $0x1,%cl
  80243a:	74 1d                	je     802459 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80243c:	c1 ea 0c             	shr    $0xc,%edx
  80243f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802446:	f6 c2 01             	test   $0x1,%dl
  802449:	74 0e                	je     802459 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80244b:	c1 ea 0c             	shr    $0xc,%edx
  80244e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802455:	ef 
  802456:	0f b7 c0             	movzwl %ax,%eax
}
  802459:	5d                   	pop    %ebp
  80245a:	c3                   	ret    
  80245b:	00 00                	add    %al,(%eax)
  80245d:	00 00                	add    %al,(%eax)
	...

00802460 <__udivdi3>:
  802460:	83 ec 1c             	sub    $0x1c,%esp
  802463:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802467:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80246b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80246f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802473:	89 74 24 10          	mov    %esi,0x10(%esp)
  802477:	8b 74 24 24          	mov    0x24(%esp),%esi
  80247b:	85 ff                	test   %edi,%edi
  80247d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802481:	89 44 24 08          	mov    %eax,0x8(%esp)
  802485:	89 cd                	mov    %ecx,%ebp
  802487:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248b:	75 33                	jne    8024c0 <__udivdi3+0x60>
  80248d:	39 f1                	cmp    %esi,%ecx
  80248f:	77 57                	ja     8024e8 <__udivdi3+0x88>
  802491:	85 c9                	test   %ecx,%ecx
  802493:	75 0b                	jne    8024a0 <__udivdi3+0x40>
  802495:	b8 01 00 00 00       	mov    $0x1,%eax
  80249a:	31 d2                	xor    %edx,%edx
  80249c:	f7 f1                	div    %ecx
  80249e:	89 c1                	mov    %eax,%ecx
  8024a0:	89 f0                	mov    %esi,%eax
  8024a2:	31 d2                	xor    %edx,%edx
  8024a4:	f7 f1                	div    %ecx
  8024a6:	89 c6                	mov    %eax,%esi
  8024a8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024ac:	f7 f1                	div    %ecx
  8024ae:	89 f2                	mov    %esi,%edx
  8024b0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8024b4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8024b8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8024bc:	83 c4 1c             	add    $0x1c,%esp
  8024bf:	c3                   	ret    
  8024c0:	31 d2                	xor    %edx,%edx
  8024c2:	31 c0                	xor    %eax,%eax
  8024c4:	39 f7                	cmp    %esi,%edi
  8024c6:	77 e8                	ja     8024b0 <__udivdi3+0x50>
  8024c8:	0f bd cf             	bsr    %edi,%ecx
  8024cb:	83 f1 1f             	xor    $0x1f,%ecx
  8024ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024d2:	75 2c                	jne    802500 <__udivdi3+0xa0>
  8024d4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  8024d8:	76 04                	jbe    8024de <__udivdi3+0x7e>
  8024da:	39 f7                	cmp    %esi,%edi
  8024dc:	73 d2                	jae    8024b0 <__udivdi3+0x50>
  8024de:	31 d2                	xor    %edx,%edx
  8024e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e5:	eb c9                	jmp    8024b0 <__udivdi3+0x50>
  8024e7:	90                   	nop
  8024e8:	89 f2                	mov    %esi,%edx
  8024ea:	f7 f1                	div    %ecx
  8024ec:	31 d2                	xor    %edx,%edx
  8024ee:	8b 74 24 10          	mov    0x10(%esp),%esi
  8024f2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8024f6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8024fa:	83 c4 1c             	add    $0x1c,%esp
  8024fd:	c3                   	ret    
  8024fe:	66 90                	xchg   %ax,%ax
  802500:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802505:	b8 20 00 00 00       	mov    $0x20,%eax
  80250a:	89 ea                	mov    %ebp,%edx
  80250c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802510:	d3 e7                	shl    %cl,%edi
  802512:	89 c1                	mov    %eax,%ecx
  802514:	d3 ea                	shr    %cl,%edx
  802516:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80251b:	09 fa                	or     %edi,%edx
  80251d:	89 f7                	mov    %esi,%edi
  80251f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802523:	89 f2                	mov    %esi,%edx
  802525:	8b 74 24 08          	mov    0x8(%esp),%esi
  802529:	d3 e5                	shl    %cl,%ebp
  80252b:	89 c1                	mov    %eax,%ecx
  80252d:	d3 ef                	shr    %cl,%edi
  80252f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802534:	d3 e2                	shl    %cl,%edx
  802536:	89 c1                	mov    %eax,%ecx
  802538:	d3 ee                	shr    %cl,%esi
  80253a:	09 d6                	or     %edx,%esi
  80253c:	89 fa                	mov    %edi,%edx
  80253e:	89 f0                	mov    %esi,%eax
  802540:	f7 74 24 0c          	divl   0xc(%esp)
  802544:	89 d7                	mov    %edx,%edi
  802546:	89 c6                	mov    %eax,%esi
  802548:	f7 e5                	mul    %ebp
  80254a:	39 d7                	cmp    %edx,%edi
  80254c:	72 22                	jb     802570 <__udivdi3+0x110>
  80254e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802552:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802557:	d3 e5                	shl    %cl,%ebp
  802559:	39 c5                	cmp    %eax,%ebp
  80255b:	73 04                	jae    802561 <__udivdi3+0x101>
  80255d:	39 d7                	cmp    %edx,%edi
  80255f:	74 0f                	je     802570 <__udivdi3+0x110>
  802561:	89 f0                	mov    %esi,%eax
  802563:	31 d2                	xor    %edx,%edx
  802565:	e9 46 ff ff ff       	jmp    8024b0 <__udivdi3+0x50>
  80256a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802570:	8d 46 ff             	lea    -0x1(%esi),%eax
  802573:	31 d2                	xor    %edx,%edx
  802575:	8b 74 24 10          	mov    0x10(%esp),%esi
  802579:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80257d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802581:	83 c4 1c             	add    $0x1c,%esp
  802584:	c3                   	ret    
	...

00802590 <__umoddi3>:
  802590:	83 ec 1c             	sub    $0x1c,%esp
  802593:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802597:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80259b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80259f:	89 74 24 10          	mov    %esi,0x10(%esp)
  8025a3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8025a7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8025ab:	85 ed                	test   %ebp,%ebp
  8025ad:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8025b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025b5:	89 cf                	mov    %ecx,%edi
  8025b7:	89 04 24             	mov    %eax,(%esp)
  8025ba:	89 f2                	mov    %esi,%edx
  8025bc:	75 1a                	jne    8025d8 <__umoddi3+0x48>
  8025be:	39 f1                	cmp    %esi,%ecx
  8025c0:	76 4e                	jbe    802610 <__umoddi3+0x80>
  8025c2:	f7 f1                	div    %ecx
  8025c4:	89 d0                	mov    %edx,%eax
  8025c6:	31 d2                	xor    %edx,%edx
  8025c8:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025cc:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025d0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025d4:	83 c4 1c             	add    $0x1c,%esp
  8025d7:	c3                   	ret    
  8025d8:	39 f5                	cmp    %esi,%ebp
  8025da:	77 54                	ja     802630 <__umoddi3+0xa0>
  8025dc:	0f bd c5             	bsr    %ebp,%eax
  8025df:	83 f0 1f             	xor    $0x1f,%eax
  8025e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e6:	75 60                	jne    802648 <__umoddi3+0xb8>
  8025e8:	3b 0c 24             	cmp    (%esp),%ecx
  8025eb:	0f 87 07 01 00 00    	ja     8026f8 <__umoddi3+0x168>
  8025f1:	89 f2                	mov    %esi,%edx
  8025f3:	8b 34 24             	mov    (%esp),%esi
  8025f6:	29 ce                	sub    %ecx,%esi
  8025f8:	19 ea                	sbb    %ebp,%edx
  8025fa:	89 34 24             	mov    %esi,(%esp)
  8025fd:	8b 04 24             	mov    (%esp),%eax
  802600:	8b 74 24 10          	mov    0x10(%esp),%esi
  802604:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802608:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80260c:	83 c4 1c             	add    $0x1c,%esp
  80260f:	c3                   	ret    
  802610:	85 c9                	test   %ecx,%ecx
  802612:	75 0b                	jne    80261f <__umoddi3+0x8f>
  802614:	b8 01 00 00 00       	mov    $0x1,%eax
  802619:	31 d2                	xor    %edx,%edx
  80261b:	f7 f1                	div    %ecx
  80261d:	89 c1                	mov    %eax,%ecx
  80261f:	89 f0                	mov    %esi,%eax
  802621:	31 d2                	xor    %edx,%edx
  802623:	f7 f1                	div    %ecx
  802625:	8b 04 24             	mov    (%esp),%eax
  802628:	f7 f1                	div    %ecx
  80262a:	eb 98                	jmp    8025c4 <__umoddi3+0x34>
  80262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802630:	89 f2                	mov    %esi,%edx
  802632:	8b 74 24 10          	mov    0x10(%esp),%esi
  802636:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80263a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80263e:	83 c4 1c             	add    $0x1c,%esp
  802641:	c3                   	ret    
  802642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802648:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80264d:	89 e8                	mov    %ebp,%eax
  80264f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802654:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802658:	89 fa                	mov    %edi,%edx
  80265a:	d3 e0                	shl    %cl,%eax
  80265c:	89 e9                	mov    %ebp,%ecx
  80265e:	d3 ea                	shr    %cl,%edx
  802660:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802665:	09 c2                	or     %eax,%edx
  802667:	8b 44 24 08          	mov    0x8(%esp),%eax
  80266b:	89 14 24             	mov    %edx,(%esp)
  80266e:	89 f2                	mov    %esi,%edx
  802670:	d3 e7                	shl    %cl,%edi
  802672:	89 e9                	mov    %ebp,%ecx
  802674:	d3 ea                	shr    %cl,%edx
  802676:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80267b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80267f:	d3 e6                	shl    %cl,%esi
  802681:	89 e9                	mov    %ebp,%ecx
  802683:	d3 e8                	shr    %cl,%eax
  802685:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80268a:	09 f0                	or     %esi,%eax
  80268c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802690:	f7 34 24             	divl   (%esp)
  802693:	d3 e6                	shl    %cl,%esi
  802695:	89 74 24 08          	mov    %esi,0x8(%esp)
  802699:	89 d6                	mov    %edx,%esi
  80269b:	f7 e7                	mul    %edi
  80269d:	39 d6                	cmp    %edx,%esi
  80269f:	89 c1                	mov    %eax,%ecx
  8026a1:	89 d7                	mov    %edx,%edi
  8026a3:	72 3f                	jb     8026e4 <__umoddi3+0x154>
  8026a5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8026a9:	72 35                	jb     8026e0 <__umoddi3+0x150>
  8026ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026af:	29 c8                	sub    %ecx,%eax
  8026b1:	19 fe                	sbb    %edi,%esi
  8026b3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026b8:	89 f2                	mov    %esi,%edx
  8026ba:	d3 e8                	shr    %cl,%eax
  8026bc:	89 e9                	mov    %ebp,%ecx
  8026be:	d3 e2                	shl    %cl,%edx
  8026c0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026c5:	09 d0                	or     %edx,%eax
  8026c7:	89 f2                	mov    %esi,%edx
  8026c9:	d3 ea                	shr    %cl,%edx
  8026cb:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026cf:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026d3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026d7:	83 c4 1c             	add    $0x1c,%esp
  8026da:	c3                   	ret    
  8026db:	90                   	nop
  8026dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026e0:	39 d6                	cmp    %edx,%esi
  8026e2:	75 c7                	jne    8026ab <__umoddi3+0x11b>
  8026e4:	89 d7                	mov    %edx,%edi
  8026e6:	89 c1                	mov    %eax,%ecx
  8026e8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8026ec:	1b 3c 24             	sbb    (%esp),%edi
  8026ef:	eb ba                	jmp    8026ab <__umoddi3+0x11b>
  8026f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026f8:	39 f5                	cmp    %esi,%ebp
  8026fa:	0f 82 f1 fe ff ff    	jb     8025f1 <__umoddi3+0x61>
  802700:	e9 f8 fe ff ff       	jmp    8025fd <__umoddi3+0x6d>
