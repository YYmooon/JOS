
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 4b 07 00 00       	call   80077c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	83 ec 14             	sub    $0x14,%esp
  80003b:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800041:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  800048:	e8 ae 0e 00 00       	call   800efb <strcpy>
	fsipcbuf.open.req_omode = mode;
  80004d:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800053:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80005a:	e8 47 17 00 00       	call   8017a6 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80005f:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800066:	00 
  800067:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800076:	00 
  800077:	89 04 24             	mov    %eax,(%esp)
  80007a:	e8 a3 16 00 00       	call   801722 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  80007f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800086:	00 
  800087:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  80008e:	cc 
  80008f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800096:	e8 35 16 00 00       	call   8016d0 <ipc_recv>
}
  80009b:	83 c4 14             	add    $0x14,%esp
  80009e:	5b                   	pop    %ebx
  80009f:	5d                   	pop    %ebp
  8000a0:	c3                   	ret    

008000a1 <umain>:

void
umain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	57                   	push   %edi
  8000a5:	56                   	push   %esi
  8000a6:	53                   	push   %ebx
  8000a7:	81 ec cc 02 00 00    	sub    $0x2cc,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b2:	b8 e0 28 80 00       	mov    $0x8028e0,%eax
  8000b7:	e8 78 ff ff ff       	call   800034 <xopen>
  8000bc:	85 c0                	test   %eax,%eax
  8000be:	79 25                	jns    8000e5 <umain+0x44>
  8000c0:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8000c3:	74 3c                	je     800101 <umain+0x60>
		panic("serve_open /not-found: %e", r);
  8000c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c9:	c7 44 24 08 eb 28 80 	movl   $0x8028eb,0x8(%esp)
  8000d0:	00 
  8000d1:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  8000d8:	00 
  8000d9:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  8000e0:	e8 03 07 00 00       	call   8007e8 <_panic>
	else if (r >= 0)
		panic("serve_open /not-found succeeded!");
  8000e5:	c7 44 24 08 a0 2a 80 	movl   $0x802aa0,0x8(%esp)
  8000ec:	00 
  8000ed:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8000f4:	00 
  8000f5:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  8000fc:	e8 e7 06 00 00       	call   8007e8 <_panic>

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800101:	ba 00 00 00 00       	mov    $0x0,%edx
  800106:	b8 15 29 80 00       	mov    $0x802915,%eax
  80010b:	e8 24 ff ff ff       	call   800034 <xopen>
  800110:	85 c0                	test   %eax,%eax
  800112:	79 20                	jns    800134 <umain+0x93>
		panic("serve_open /newmotd: %e", r);
  800114:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800118:	c7 44 24 08 1e 29 80 	movl   $0x80291e,0x8(%esp)
  80011f:	00 
  800120:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800127:	00 
  800128:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  80012f:	e8 b4 06 00 00       	call   8007e8 <_panic>
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  800134:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  80013b:	75 12                	jne    80014f <umain+0xae>
  80013d:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  800144:	75 09                	jne    80014f <umain+0xae>
  800146:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  80014d:	74 1c                	je     80016b <umain+0xca>
		panic("serve_open did not fill struct Fd correctly\n");
  80014f:	c7 44 24 08 c4 2a 80 	movl   $0x802ac4,0x8(%esp)
  800156:	00 
  800157:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80015e:	00 
  80015f:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  800166:	e8 7d 06 00 00       	call   8007e8 <_panic>
	cprintf("serve_open is good\n");
  80016b:	c7 04 24 36 29 80 00 	movl   $0x802936,(%esp)
  800172:	e8 6c 07 00 00       	call   8008e3 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800177:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800181:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800188:	ff 15 1c 40 80 00    	call   *0x80401c
  80018e:	85 c0                	test   %eax,%eax
  800190:	79 20                	jns    8001b2 <umain+0x111>
		panic("file_stat: %e", r);
  800192:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800196:	c7 44 24 08 4a 29 80 	movl   $0x80294a,0x8(%esp)
  80019d:	00 
  80019e:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8001a5:	00 
  8001a6:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  8001ad:	e8 36 06 00 00       	call   8007e8 <_panic>
	if (strlen(msg) != st.st_size)
  8001b2:	a1 00 40 80 00       	mov    0x804000,%eax
  8001b7:	89 04 24             	mov    %eax,(%esp)
  8001ba:	e8 f1 0c 00 00       	call   800eb0 <strlen>
  8001bf:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c2:	74 34                	je     8001f8 <umain+0x157>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8001c4:	a1 00 40 80 00       	mov    0x804000,%eax
  8001c9:	89 04 24             	mov    %eax,(%esp)
  8001cc:	e8 df 0c 00 00       	call   800eb0 <strlen>
  8001d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001dc:	c7 44 24 08 f4 2a 80 	movl   $0x802af4,0x8(%esp)
  8001e3:	00 
  8001e4:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8001eb:	00 
  8001ec:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  8001f3:	e8 f0 05 00 00       	call   8007e8 <_panic>
	cprintf("file_stat is good\n");
  8001f8:	c7 04 24 58 29 80 00 	movl   $0x802958,(%esp)
  8001ff:	e8 df 06 00 00       	call   8008e3 <cprintf>

	memset(buf, 0, sizeof buf);
  800204:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80020b:	00 
  80020c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800213:	00 
  800214:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  80021a:	89 1c 24             	mov    %ebx,(%esp)
  80021d:	e8 6f 0e 00 00       	call   801091 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800222:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800229:	00 
  80022a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80022e:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800235:	ff 15 10 40 80 00    	call   *0x804010
  80023b:	85 c0                	test   %eax,%eax
  80023d:	79 20                	jns    80025f <umain+0x1be>
		panic("file_read: %e", r);
  80023f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800243:	c7 44 24 08 6b 29 80 	movl   $0x80296b,0x8(%esp)
  80024a:	00 
  80024b:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  800252:	00 
  800253:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  80025a:	e8 89 05 00 00       	call   8007e8 <_panic>
	if (strcmp(buf, msg) != 0)
  80025f:	a1 00 40 80 00       	mov    0x804000,%eax
  800264:	89 44 24 04          	mov    %eax,0x4(%esp)
  800268:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  80026e:	89 04 24             	mov    %eax,(%esp)
  800271:	e8 45 0d 00 00       	call   800fbb <strcmp>
  800276:	85 c0                	test   %eax,%eax
  800278:	74 1c                	je     800296 <umain+0x1f5>
		panic("file_read returned wrong data");
  80027a:	c7 44 24 08 79 29 80 	movl   $0x802979,0x8(%esp)
  800281:	00 
  800282:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  800289:	00 
  80028a:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  800291:	e8 52 05 00 00       	call   8007e8 <_panic>
	cprintf("file_read is good\n");
  800296:	c7 04 24 97 29 80 00 	movl   $0x802997,(%esp)
  80029d:	e8 41 06 00 00       	call   8008e3 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8002a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8002a9:	ff 15 18 40 80 00    	call   *0x804018
  8002af:	85 c0                	test   %eax,%eax
  8002b1:	79 20                	jns    8002d3 <umain+0x232>
		panic("file_close: %e", r);
  8002b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b7:	c7 44 24 08 aa 29 80 	movl   $0x8029aa,0x8(%esp)
  8002be:	00 
  8002bf:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8002c6:	00 
  8002c7:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  8002ce:	e8 15 05 00 00       	call   8007e8 <_panic>
	cprintf("file_close is good\n");
  8002d3:	c7 04 24 b9 29 80 00 	movl   $0x8029b9,(%esp)
  8002da:	e8 04 06 00 00       	call   8008e3 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8002df:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8002e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e7:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8002ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ef:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8002f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f7:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8002fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8002ff:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  800306:	cc 
  800307:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80030e:	e8 a6 11 00 00       	call   8014b9 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  800313:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80031a:	00 
  80031b:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800321:	89 44 24 04          	mov    %eax,0x4(%esp)
  800325:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800328:	89 04 24             	mov    %eax,(%esp)
  80032b:	ff 15 10 40 80 00    	call   *0x804010
  800331:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800334:	74 20                	je     800356 <umain+0x2b5>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  800336:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80033a:	c7 44 24 08 1c 2b 80 	movl   $0x802b1c,0x8(%esp)
  800341:	00 
  800342:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800349:	00 
  80034a:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  800351:	e8 92 04 00 00       	call   8007e8 <_panic>
	cprintf("stale fileid is good\n");
  800356:	c7 04 24 cd 29 80 00 	movl   $0x8029cd,(%esp)
  80035d:	e8 81 05 00 00       	call   8008e3 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800362:	ba 02 01 00 00       	mov    $0x102,%edx
  800367:	b8 e3 29 80 00       	mov    $0x8029e3,%eax
  80036c:	e8 c3 fc ff ff       	call   800034 <xopen>
  800371:	85 c0                	test   %eax,%eax
  800373:	79 20                	jns    800395 <umain+0x2f4>
		panic("serve_open /new-file: %e", r);
  800375:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800379:	c7 44 24 08 ed 29 80 	movl   $0x8029ed,0x8(%esp)
  800380:	00 
  800381:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  800388:	00 
  800389:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  800390:	e8 53 04 00 00       	call   8007e8 <_panic>

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800395:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  80039b:	a1 00 40 80 00       	mov    0x804000,%eax
  8003a0:	89 04 24             	mov    %eax,(%esp)
  8003a3:	e8 08 0b 00 00       	call   800eb0 <strlen>
  8003a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ac:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b5:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8003bc:	ff d3                	call   *%ebx
  8003be:	89 c3                	mov    %eax,%ebx
  8003c0:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c5:	89 04 24             	mov    %eax,(%esp)
  8003c8:	e8 e3 0a 00 00       	call   800eb0 <strlen>
  8003cd:	39 c3                	cmp    %eax,%ebx
  8003cf:	74 20                	je     8003f1 <umain+0x350>
		panic("file_write: %e", r);
  8003d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003d5:	c7 44 24 08 06 2a 80 	movl   $0x802a06,0x8(%esp)
  8003dc:	00 
  8003dd:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
  8003e4:	00 
  8003e5:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  8003ec:	e8 f7 03 00 00       	call   8007e8 <_panic>
	cprintf("file_write is good\n");
  8003f1:	c7 04 24 15 2a 80 00 	movl   $0x802a15,(%esp)
  8003f8:	e8 e6 04 00 00       	call   8008e3 <cprintf>

	FVA->fd_offset = 0;
  8003fd:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800404:	00 00 00 
	memset(buf, 0, sizeof buf);
  800407:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80040e:	00 
  80040f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800416:	00 
  800417:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  80041d:	89 1c 24             	mov    %ebx,(%esp)
  800420:	e8 6c 0c 00 00       	call   801091 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800425:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80042c:	00 
  80042d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800431:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800438:	ff 15 10 40 80 00    	call   *0x804010
  80043e:	89 c3                	mov    %eax,%ebx
  800440:	85 c0                	test   %eax,%eax
  800442:	79 20                	jns    800464 <umain+0x3c3>
		panic("file_read after file_write: %e", r);
  800444:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800448:	c7 44 24 08 54 2b 80 	movl   $0x802b54,0x8(%esp)
  80044f:	00 
  800450:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  800457:	00 
  800458:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  80045f:	e8 84 03 00 00       	call   8007e8 <_panic>
	if (r != strlen(msg))
  800464:	a1 00 40 80 00       	mov    0x804000,%eax
  800469:	89 04 24             	mov    %eax,(%esp)
  80046c:	e8 3f 0a 00 00       	call   800eb0 <strlen>
  800471:	39 d8                	cmp    %ebx,%eax
  800473:	74 20                	je     800495 <umain+0x3f4>
		panic("file_read after file_write returned wrong length: %d", r);
  800475:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800479:	c7 44 24 08 74 2b 80 	movl   $0x802b74,0x8(%esp)
  800480:	00 
  800481:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  800488:	00 
  800489:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  800490:	e8 53 03 00 00       	call   8007e8 <_panic>
	if (strcmp(buf, msg) != 0)
  800495:	a1 00 40 80 00       	mov    0x804000,%eax
  80049a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049e:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8004a4:	89 04 24             	mov    %eax,(%esp)
  8004a7:	e8 0f 0b 00 00       	call   800fbb <strcmp>
  8004ac:	85 c0                	test   %eax,%eax
  8004ae:	74 1c                	je     8004cc <umain+0x42b>
		panic("file_read after file_write returned wrong data");
  8004b0:	c7 44 24 08 ac 2b 80 	movl   $0x802bac,0x8(%esp)
  8004b7:	00 
  8004b8:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8004bf:	00 
  8004c0:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  8004c7:	e8 1c 03 00 00       	call   8007e8 <_panic>
	cprintf("file_read after file_write is good\n");
  8004cc:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  8004d3:	e8 0b 04 00 00       	call   8008e3 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8004d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004df:	00 
  8004e0:	c7 04 24 e0 28 80 00 	movl   $0x8028e0,(%esp)
  8004e7:	e8 d0 1a 00 00       	call   801fbc <open>
  8004ec:	85 c0                	test   %eax,%eax
  8004ee:	79 25                	jns    800515 <umain+0x474>
  8004f0:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8004f3:	74 3c                	je     800531 <umain+0x490>
		panic("open /not-found: %e", r);
  8004f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f9:	c7 44 24 08 f1 28 80 	movl   $0x8028f1,0x8(%esp)
  800500:	00 
  800501:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  800508:	00 
  800509:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  800510:	e8 d3 02 00 00       	call   8007e8 <_panic>
	else if (r >= 0)
		panic("open /not-found succeeded!");
  800515:	c7 44 24 08 29 2a 80 	movl   $0x802a29,0x8(%esp)
  80051c:	00 
  80051d:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800524:	00 
  800525:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  80052c:	e8 b7 02 00 00       	call   8007e8 <_panic>

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  800531:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800538:	00 
  800539:	c7 04 24 15 29 80 00 	movl   $0x802915,(%esp)
  800540:	e8 77 1a 00 00       	call   801fbc <open>
  800545:	85 c0                	test   %eax,%eax
  800547:	79 20                	jns    800569 <umain+0x4c8>
		panic("open /newmotd: %e", r);
  800549:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80054d:	c7 44 24 08 24 29 80 	movl   $0x802924,0x8(%esp)
  800554:	00 
  800555:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80055c:	00 
  80055d:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  800564:	e8 7f 02 00 00       	call   8007e8 <_panic>
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800569:	05 00 00 0d 00       	add    $0xd0000,%eax
  80056e:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800571:	83 38 66             	cmpl   $0x66,(%eax)
  800574:	75 0c                	jne    800582 <umain+0x4e1>
  800576:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80057a:	75 06                	jne    800582 <umain+0x4e1>
  80057c:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
  800580:	74 1c                	je     80059e <umain+0x4fd>
		panic("open did not fill struct Fd correctly\n");
  800582:	c7 44 24 08 00 2c 80 	movl   $0x802c00,0x8(%esp)
  800589:	00 
  80058a:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  800591:	00 
  800592:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  800599:	e8 4a 02 00 00       	call   8007e8 <_panic>
	cprintf("open is good\n");
  80059e:	c7 04 24 3c 29 80 00 	movl   $0x80293c,(%esp)
  8005a5:	e8 39 03 00 00       	call   8008e3 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8005aa:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  8005b1:	00 
  8005b2:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  8005b9:	e8 fe 19 00 00       	call   801fbc <open>
  8005be:	89 c6                	mov    %eax,%esi
  8005c0:	85 c0                	test   %eax,%eax
  8005c2:	79 20                	jns    8005e4 <umain+0x543>
		panic("creat /big: %e", f);
  8005c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005c8:	c7 44 24 08 49 2a 80 	movl   $0x802a49,0x8(%esp)
  8005cf:	00 
  8005d0:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  8005d7:	00 
  8005d8:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  8005df:	e8 04 02 00 00       	call   8007e8 <_panic>
	memset(buf, 0, sizeof(buf));
  8005e4:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8005eb:	00 
  8005ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8005f3:	00 
  8005f4:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8005fa:	89 04 24             	mov    %eax,(%esp)
  8005fd:	e8 8f 0a 00 00       	call   801091 <memset>
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800602:	bb 00 00 00 00       	mov    $0x0,%ebx
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800607:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  80060d:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800613:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80061a:	00 
  80061b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80061f:	89 34 24             	mov    %esi,(%esp)
  800622:	e8 07 16 00 00       	call   801c2e <write>
  800627:	85 c0                	test   %eax,%eax
  800629:	79 24                	jns    80064f <umain+0x5ae>
			panic("write /big@%d: %e", i, r);
  80062b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80062f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800633:	c7 44 24 08 58 2a 80 	movl   $0x802a58,0x8(%esp)
  80063a:	00 
  80063b:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  800642:	00 
  800643:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  80064a:	e8 99 01 00 00       	call   8007e8 <_panic>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
	return ipc_recv(NULL, FVA, NULL);
}

void
umain(int argc, char **argv)
  80064f:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  800655:	89 c3                	mov    %eax,%ebx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800657:	3d 00 e0 01 00       	cmp    $0x1e000,%eax
  80065c:	75 af                	jne    80060d <umain+0x56c>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  80065e:	89 34 24             	mov    %esi,(%esp)
  800661:	e8 77 13 00 00       	call   8019dd <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  800666:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80066d:	00 
  80066e:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  800675:	e8 42 19 00 00       	call   801fbc <open>
  80067a:	89 c7                	mov    %eax,%edi
  80067c:	85 c0                	test   %eax,%eax
  80067e:	79 20                	jns    8006a0 <umain+0x5ff>
		panic("open /big: %e", f);
  800680:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800684:	c7 44 24 08 6a 2a 80 	movl   $0x802a6a,0x8(%esp)
  80068b:	00 
  80068c:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  800693:	00 
  800694:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  80069b:	e8 48 01 00 00       	call   8007e8 <_panic>
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
  8006a0:	bb 00 00 00 00       	mov    $0x0,%ebx
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006a5:	8d b5 4c fd ff ff    	lea    -0x2b4(%ebp),%esi
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  8006ab:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006b1:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8006b8:	00 
  8006b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006bd:	89 3c 24             	mov    %edi,(%esp)
  8006c0:	e8 19 15 00 00       	call   801bde <readn>
  8006c5:	85 c0                	test   %eax,%eax
  8006c7:	79 24                	jns    8006ed <umain+0x64c>
			panic("read /big@%d: %e", i, r);
  8006c9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006cd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006d1:	c7 44 24 08 78 2a 80 	movl   $0x802a78,0x8(%esp)
  8006d8:	00 
  8006d9:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  8006e0:	00 
  8006e1:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  8006e8:	e8 fb 00 00 00       	call   8007e8 <_panic>
		if (r != sizeof(buf))
  8006ed:	3d 00 02 00 00       	cmp    $0x200,%eax
  8006f2:	74 2c                	je     800720 <umain+0x67f>
			panic("read /big from %d returned %d < %d bytes",
  8006f4:	c7 44 24 14 00 02 00 	movl   $0x200,0x14(%esp)
  8006fb:	00 
  8006fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800700:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800704:	c7 44 24 08 28 2c 80 	movl   $0x802c28,0x8(%esp)
  80070b:	00 
  80070c:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  800713:	00 
  800714:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  80071b:	e8 c8 00 00 00       	call   8007e8 <_panic>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800720:	8b 06                	mov    (%esi),%eax
  800722:	39 d8                	cmp    %ebx,%eax
  800724:	74 24                	je     80074a <umain+0x6a9>
			panic("read /big from %d returned bad data %d",
  800726:	89 44 24 10          	mov    %eax,0x10(%esp)
  80072a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80072e:	c7 44 24 08 54 2c 80 	movl   $0x802c54,0x8(%esp)
  800735:	00 
  800736:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80073d:	00 
  80073e:	c7 04 24 05 29 80 00 	movl   $0x802905,(%esp)
  800745:	e8 9e 00 00 00       	call   8007e8 <_panic>
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80074a:	8d 98 00 02 00 00    	lea    0x200(%eax),%ebx
  800750:	81 fb ff df 01 00    	cmp    $0x1dfff,%ebx
  800756:	0f 8e 4f ff ff ff    	jle    8006ab <umain+0x60a>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  80075c:	89 3c 24             	mov    %edi,(%esp)
  80075f:	e8 79 12 00 00       	call   8019dd <close>
	cprintf("large file is good\n");
  800764:	c7 04 24 89 2a 80 00 	movl   $0x802a89,(%esp)
  80076b:	e8 73 01 00 00       	call   8008e3 <cprintf>
}
  800770:	81 c4 cc 02 00 00    	add    $0x2cc,%esp
  800776:	5b                   	pop    %ebx
  800777:	5e                   	pop    %esi
  800778:	5f                   	pop    %edi
  800779:	5d                   	pop    %ebp
  80077a:	c3                   	ret    
	...

0080077c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	83 ec 18             	sub    $0x18,%esp
  800782:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800785:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800788:	8b 75 08             	mov    0x8(%ebp),%esi
  80078b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80078e:	e8 09 0c 00 00       	call   80139c <sys_getenvid>
  800793:	25 ff 03 00 00       	and    $0x3ff,%eax
  800798:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80079b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007a0:	a3 04 50 80 00       	mov    %eax,0x805004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007a5:	85 f6                	test   %esi,%esi
  8007a7:	7e 07                	jle    8007b0 <libmain+0x34>
		binaryname = argv[0];
  8007a9:	8b 03                	mov    (%ebx),%eax
  8007ab:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8007b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007b4:	89 34 24             	mov    %esi,(%esp)
  8007b7:	e8 e5 f8 ff ff       	call   8000a1 <umain>

	// exit gracefully
	exit();
  8007bc:	e8 0b 00 00 00       	call   8007cc <exit>
}
  8007c1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8007c4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8007c7:	89 ec                	mov    %ebp,%esp
  8007c9:	5d                   	pop    %ebp
  8007ca:	c3                   	ret    
	...

008007cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8007d2:	e8 37 12 00 00       	call   801a0e <close_all>
	sys_env_destroy(0);
  8007d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007de:	e8 5c 0b 00 00       	call   80133f <sys_env_destroy>
}
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    
  8007e5:	00 00                	add    %al,(%eax)
	...

008007e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	56                   	push   %esi
  8007ec:	53                   	push   %ebx
  8007ed:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8007f0:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007f3:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
  8007f9:	e8 9e 0b 00 00       	call   80139c <sys_getenvid>
  8007fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800801:	89 54 24 10          	mov    %edx,0x10(%esp)
  800805:	8b 55 08             	mov    0x8(%ebp),%edx
  800808:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80080c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800810:	89 44 24 04          	mov    %eax,0x4(%esp)
  800814:	c7 04 24 ac 2c 80 00 	movl   $0x802cac,(%esp)
  80081b:	e8 c3 00 00 00       	call   8008e3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800820:	89 74 24 04          	mov    %esi,0x4(%esp)
  800824:	8b 45 10             	mov    0x10(%ebp),%eax
  800827:	89 04 24             	mov    %eax,(%esp)
  80082a:	e8 53 00 00 00       	call   800882 <vcprintf>
	cprintf("\n");
  80082f:	c7 04 24 fb 30 80 00 	movl   $0x8030fb,(%esp)
  800836:	e8 a8 00 00 00       	call   8008e3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80083b:	cc                   	int3   
  80083c:	eb fd                	jmp    80083b <_panic+0x53>
	...

00800840 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	53                   	push   %ebx
  800844:	83 ec 14             	sub    $0x14,%esp
  800847:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80084a:	8b 03                	mov    (%ebx),%eax
  80084c:	8b 55 08             	mov    0x8(%ebp),%edx
  80084f:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800853:	83 c0 01             	add    $0x1,%eax
  800856:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800858:	3d ff 00 00 00       	cmp    $0xff,%eax
  80085d:	75 19                	jne    800878 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80085f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800866:	00 
  800867:	8d 43 08             	lea    0x8(%ebx),%eax
  80086a:	89 04 24             	mov    %eax,(%esp)
  80086d:	e8 6e 0a 00 00       	call   8012e0 <sys_cputs>
		b->idx = 0;
  800872:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800878:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80087c:	83 c4 14             	add    $0x14,%esp
  80087f:	5b                   	pop    %ebx
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80088b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800892:	00 00 00 
	b.cnt = 0;
  800895:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80089c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80089f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b7:	c7 04 24 40 08 80 00 	movl   $0x800840,(%esp)
  8008be:	e8 97 01 00 00       	call   800a5a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8008c3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008cd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8008d3:	89 04 24             	mov    %eax,(%esp)
  8008d6:	e8 05 0a 00 00       	call   8012e0 <sys_cputs>

	return b.cnt;
}
  8008db:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    

008008e3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008e9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8008ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	89 04 24             	mov    %eax,(%esp)
  8008f6:	e8 87 ff ff ff       	call   800882 <vcprintf>
	va_end(ap);

	return cnt;
}
  8008fb:	c9                   	leave  
  8008fc:	c3                   	ret    
  8008fd:	00 00                	add    %al,(%eax)
	...

00800900 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	57                   	push   %edi
  800904:	56                   	push   %esi
  800905:	53                   	push   %ebx
  800906:	83 ec 3c             	sub    $0x3c,%esp
  800909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80090c:	89 d7                	mov    %edx,%edi
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800914:	8b 45 0c             	mov    0xc(%ebp),%eax
  800917:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80091a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80091d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800920:	b8 00 00 00 00       	mov    $0x0,%eax
  800925:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800928:	72 11                	jb     80093b <printnum+0x3b>
  80092a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80092d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800930:	76 09                	jbe    80093b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800932:	83 eb 01             	sub    $0x1,%ebx
  800935:	85 db                	test   %ebx,%ebx
  800937:	7f 51                	jg     80098a <printnum+0x8a>
  800939:	eb 5e                	jmp    800999 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80093b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80093f:	83 eb 01             	sub    $0x1,%ebx
  800942:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800946:	8b 45 10             	mov    0x10(%ebp),%eax
  800949:	89 44 24 08          	mov    %eax,0x8(%esp)
  80094d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800951:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800955:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80095c:	00 
  80095d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800960:	89 04 24             	mov    %eax,(%esp)
  800963:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800966:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096a:	e8 b1 1c 00 00       	call   802620 <__udivdi3>
  80096f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800973:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800977:	89 04 24             	mov    %eax,(%esp)
  80097a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80097e:	89 fa                	mov    %edi,%edx
  800980:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800983:	e8 78 ff ff ff       	call   800900 <printnum>
  800988:	eb 0f                	jmp    800999 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80098a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80098e:	89 34 24             	mov    %esi,(%esp)
  800991:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800994:	83 eb 01             	sub    $0x1,%ebx
  800997:	75 f1                	jne    80098a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800999:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80099d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8009af:	00 
  8009b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b3:	89 04 24             	mov    %eax,(%esp)
  8009b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009bd:	e8 8e 1d 00 00       	call   802750 <__umoddi3>
  8009c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009c6:	0f be 80 cf 2c 80 00 	movsbl 0x802ccf(%eax),%eax
  8009cd:	89 04 24             	mov    %eax,(%esp)
  8009d0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8009d3:	83 c4 3c             	add    $0x3c,%esp
  8009d6:	5b                   	pop    %ebx
  8009d7:	5e                   	pop    %esi
  8009d8:	5f                   	pop    %edi
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009de:	83 fa 01             	cmp    $0x1,%edx
  8009e1:	7e 0e                	jle    8009f1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8009e3:	8b 10                	mov    (%eax),%edx
  8009e5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8009e8:	89 08                	mov    %ecx,(%eax)
  8009ea:	8b 02                	mov    (%edx),%eax
  8009ec:	8b 52 04             	mov    0x4(%edx),%edx
  8009ef:	eb 22                	jmp    800a13 <getuint+0x38>
	else if (lflag)
  8009f1:	85 d2                	test   %edx,%edx
  8009f3:	74 10                	je     800a05 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8009f5:	8b 10                	mov    (%eax),%edx
  8009f7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8009fa:	89 08                	mov    %ecx,(%eax)
  8009fc:	8b 02                	mov    (%edx),%eax
  8009fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800a03:	eb 0e                	jmp    800a13 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800a05:	8b 10                	mov    (%eax),%edx
  800a07:	8d 4a 04             	lea    0x4(%edx),%ecx
  800a0a:	89 08                	mov    %ecx,(%eax)
  800a0c:	8b 02                	mov    (%edx),%eax
  800a0e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800a1b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800a1f:	8b 10                	mov    (%eax),%edx
  800a21:	3b 50 04             	cmp    0x4(%eax),%edx
  800a24:	73 0a                	jae    800a30 <sprintputch+0x1b>
		*b->buf++ = ch;
  800a26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a29:	88 0a                	mov    %cl,(%edx)
  800a2b:	83 c2 01             	add    $0x1,%edx
  800a2e:	89 10                	mov    %edx,(%eax)
}
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a38:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800a3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a42:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a49:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	89 04 24             	mov    %eax,(%esp)
  800a53:	e8 02 00 00 00       	call   800a5a <vprintfmt>
	va_end(ap);
}
  800a58:	c9                   	leave  
  800a59:	c3                   	ret    

00800a5a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	57                   	push   %edi
  800a5e:	56                   	push   %esi
  800a5f:	53                   	push   %ebx
  800a60:	83 ec 4c             	sub    $0x4c,%esp
  800a63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a66:	8b 75 10             	mov    0x10(%ebp),%esi
  800a69:	eb 12                	jmp    800a7d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800a6b:	85 c0                	test   %eax,%eax
  800a6d:	0f 84 a9 03 00 00    	je     800e1c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800a73:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a77:	89 04 24             	mov    %eax,(%esp)
  800a7a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7d:	0f b6 06             	movzbl (%esi),%eax
  800a80:	83 c6 01             	add    $0x1,%esi
  800a83:	83 f8 25             	cmp    $0x25,%eax
  800a86:	75 e3                	jne    800a6b <vprintfmt+0x11>
  800a88:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800a8c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800a93:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800a98:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800a9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aa4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800aa7:	eb 2b                	jmp    800ad4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aa9:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800aac:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800ab0:	eb 22                	jmp    800ad4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ab2:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ab5:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800ab9:	eb 19                	jmp    800ad4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800abb:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800abe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ac5:	eb 0d                	jmp    800ad4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800ac7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800acd:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ad4:	0f b6 06             	movzbl (%esi),%eax
  800ad7:	0f b6 d0             	movzbl %al,%edx
  800ada:	8d 7e 01             	lea    0x1(%esi),%edi
  800add:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800ae0:	83 e8 23             	sub    $0x23,%eax
  800ae3:	3c 55                	cmp    $0x55,%al
  800ae5:	0f 87 0b 03 00 00    	ja     800df6 <vprintfmt+0x39c>
  800aeb:	0f b6 c0             	movzbl %al,%eax
  800aee:	ff 24 85 20 2e 80 00 	jmp    *0x802e20(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800af5:	83 ea 30             	sub    $0x30,%edx
  800af8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  800afb:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  800aff:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b02:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800b05:	83 fa 09             	cmp    $0x9,%edx
  800b08:	77 4a                	ja     800b54 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b0a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b0d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800b10:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800b13:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800b17:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800b1a:	8d 50 d0             	lea    -0x30(%eax),%edx
  800b1d:	83 fa 09             	cmp    $0x9,%edx
  800b20:	76 eb                	jbe    800b0d <vprintfmt+0xb3>
  800b22:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800b25:	eb 2d                	jmp    800b54 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b27:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2a:	8d 50 04             	lea    0x4(%eax),%edx
  800b2d:	89 55 14             	mov    %edx,0x14(%ebp)
  800b30:	8b 00                	mov    (%eax),%eax
  800b32:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b35:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800b38:	eb 1a                	jmp    800b54 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b3a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  800b3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b41:	79 91                	jns    800ad4 <vprintfmt+0x7a>
  800b43:	e9 73 ff ff ff       	jmp    800abb <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b48:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800b4b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b52:	eb 80                	jmp    800ad4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800b54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b58:	0f 89 76 ff ff ff    	jns    800ad4 <vprintfmt+0x7a>
  800b5e:	e9 64 ff ff ff       	jmp    800ac7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b63:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b66:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800b69:	e9 66 ff ff ff       	jmp    800ad4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b71:	8d 50 04             	lea    0x4(%eax),%edx
  800b74:	89 55 14             	mov    %edx,0x14(%ebp)
  800b77:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	89 04 24             	mov    %eax,(%esp)
  800b80:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b83:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800b86:	e9 f2 fe ff ff       	jmp    800a7d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8e:	8d 50 04             	lea    0x4(%eax),%edx
  800b91:	89 55 14             	mov    %edx,0x14(%ebp)
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	89 c2                	mov    %eax,%edx
  800b98:	c1 fa 1f             	sar    $0x1f,%edx
  800b9b:	31 d0                	xor    %edx,%eax
  800b9d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b9f:	83 f8 0f             	cmp    $0xf,%eax
  800ba2:	7f 0b                	jg     800baf <vprintfmt+0x155>
  800ba4:	8b 14 85 80 2f 80 00 	mov    0x802f80(,%eax,4),%edx
  800bab:	85 d2                	test   %edx,%edx
  800bad:	75 23                	jne    800bd2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  800baf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bb3:	c7 44 24 08 e7 2c 80 	movl   $0x802ce7,0x8(%esp)
  800bba:	00 
  800bbb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bbf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bc2:	89 3c 24             	mov    %edi,(%esp)
  800bc5:	e8 68 fe ff ff       	call   800a32 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bca:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800bcd:	e9 ab fe ff ff       	jmp    800a7d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  800bd2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bd6:	c7 44 24 08 c9 30 80 	movl   $0x8030c9,0x8(%esp)
  800bdd:	00 
  800bde:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800be2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800be5:	89 3c 24             	mov    %edi,(%esp)
  800be8:	e8 45 fe ff ff       	call   800a32 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bed:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800bf0:	e9 88 fe ff ff       	jmp    800a7d <vprintfmt+0x23>
  800bf5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800bf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bfb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800c01:	8d 50 04             	lea    0x4(%eax),%edx
  800c04:	89 55 14             	mov    %edx,0x14(%ebp)
  800c07:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800c09:	85 f6                	test   %esi,%esi
  800c0b:	ba e0 2c 80 00       	mov    $0x802ce0,%edx
  800c10:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800c13:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800c17:	7e 06                	jle    800c1f <vprintfmt+0x1c5>
  800c19:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800c1d:	75 10                	jne    800c2f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c1f:	0f be 06             	movsbl (%esi),%eax
  800c22:	83 c6 01             	add    $0x1,%esi
  800c25:	85 c0                	test   %eax,%eax
  800c27:	0f 85 86 00 00 00    	jne    800cb3 <vprintfmt+0x259>
  800c2d:	eb 76                	jmp    800ca5 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c2f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c33:	89 34 24             	mov    %esi,(%esp)
  800c36:	e8 90 02 00 00       	call   800ecb <strnlen>
  800c3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800c3e:	29 c2                	sub    %eax,%edx
  800c40:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800c43:	85 d2                	test   %edx,%edx
  800c45:	7e d8                	jle    800c1f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800c47:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800c4b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  800c4e:	89 d6                	mov    %edx,%esi
  800c50:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800c53:	89 c7                	mov    %eax,%edi
  800c55:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c59:	89 3c 24             	mov    %edi,(%esp)
  800c5c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c5f:	83 ee 01             	sub    $0x1,%esi
  800c62:	75 f1                	jne    800c55 <vprintfmt+0x1fb>
  800c64:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800c67:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  800c6a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  800c6d:	eb b0                	jmp    800c1f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800c6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c73:	74 18                	je     800c8d <vprintfmt+0x233>
  800c75:	8d 50 e0             	lea    -0x20(%eax),%edx
  800c78:	83 fa 5e             	cmp    $0x5e,%edx
  800c7b:	76 10                	jbe    800c8d <vprintfmt+0x233>
					putch('?', putdat);
  800c7d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c81:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800c88:	ff 55 08             	call   *0x8(%ebp)
  800c8b:	eb 0a                	jmp    800c97 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  800c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c91:	89 04 24             	mov    %eax,(%esp)
  800c94:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c97:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800c9b:	0f be 06             	movsbl (%esi),%eax
  800c9e:	83 c6 01             	add    $0x1,%esi
  800ca1:	85 c0                	test   %eax,%eax
  800ca3:	75 0e                	jne    800cb3 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ca5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ca8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cac:	7f 16                	jg     800cc4 <vprintfmt+0x26a>
  800cae:	e9 ca fd ff ff       	jmp    800a7d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cb3:	85 ff                	test   %edi,%edi
  800cb5:	78 b8                	js     800c6f <vprintfmt+0x215>
  800cb7:	83 ef 01             	sub    $0x1,%edi
  800cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800cc0:	79 ad                	jns    800c6f <vprintfmt+0x215>
  800cc2:	eb e1                	jmp    800ca5 <vprintfmt+0x24b>
  800cc4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800cc7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800cca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800cce:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800cd5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cd7:	83 ee 01             	sub    $0x1,%esi
  800cda:	75 ee                	jne    800cca <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cdc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800cdf:	e9 99 fd ff ff       	jmp    800a7d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800ce4:	83 f9 01             	cmp    $0x1,%ecx
  800ce7:	7e 10                	jle    800cf9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cec:	8d 50 08             	lea    0x8(%eax),%edx
  800cef:	89 55 14             	mov    %edx,0x14(%ebp)
  800cf2:	8b 30                	mov    (%eax),%esi
  800cf4:	8b 78 04             	mov    0x4(%eax),%edi
  800cf7:	eb 26                	jmp    800d1f <vprintfmt+0x2c5>
	else if (lflag)
  800cf9:	85 c9                	test   %ecx,%ecx
  800cfb:	74 12                	je     800d0f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  800cfd:	8b 45 14             	mov    0x14(%ebp),%eax
  800d00:	8d 50 04             	lea    0x4(%eax),%edx
  800d03:	89 55 14             	mov    %edx,0x14(%ebp)
  800d06:	8b 30                	mov    (%eax),%esi
  800d08:	89 f7                	mov    %esi,%edi
  800d0a:	c1 ff 1f             	sar    $0x1f,%edi
  800d0d:	eb 10                	jmp    800d1f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  800d0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d12:	8d 50 04             	lea    0x4(%eax),%edx
  800d15:	89 55 14             	mov    %edx,0x14(%ebp)
  800d18:	8b 30                	mov    (%eax),%esi
  800d1a:	89 f7                	mov    %esi,%edi
  800d1c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800d1f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800d24:	85 ff                	test   %edi,%edi
  800d26:	0f 89 8c 00 00 00    	jns    800db8 <vprintfmt+0x35e>
				putch('-', putdat);
  800d2c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d30:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800d37:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800d3a:	f7 de                	neg    %esi
  800d3c:	83 d7 00             	adc    $0x0,%edi
  800d3f:	f7 df                	neg    %edi
			}
			base = 10;
  800d41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d46:	eb 70                	jmp    800db8 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d48:	89 ca                	mov    %ecx,%edx
  800d4a:	8d 45 14             	lea    0x14(%ebp),%eax
  800d4d:	e8 89 fc ff ff       	call   8009db <getuint>
  800d52:	89 c6                	mov    %eax,%esi
  800d54:	89 d7                	mov    %edx,%edi
			base = 10;
  800d56:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800d5b:	eb 5b                	jmp    800db8 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800d5d:	89 ca                	mov    %ecx,%edx
  800d5f:	8d 45 14             	lea    0x14(%ebp),%eax
  800d62:	e8 74 fc ff ff       	call   8009db <getuint>
  800d67:	89 c6                	mov    %eax,%esi
  800d69:	89 d7                	mov    %edx,%edi
			base = 8;
  800d6b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800d70:	eb 46                	jmp    800db8 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800d72:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d76:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800d7d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800d80:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d84:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800d8b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800d8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d91:	8d 50 04             	lea    0x4(%eax),%edx
  800d94:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d97:	8b 30                	mov    (%eax),%esi
  800d99:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800d9e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800da3:	eb 13                	jmp    800db8 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800da5:	89 ca                	mov    %ecx,%edx
  800da7:	8d 45 14             	lea    0x14(%ebp),%eax
  800daa:	e8 2c fc ff ff       	call   8009db <getuint>
  800daf:	89 c6                	mov    %eax,%esi
  800db1:	89 d7                	mov    %edx,%edi
			base = 16;
  800db3:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800db8:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  800dbc:	89 54 24 10          	mov    %edx,0x10(%esp)
  800dc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800dc3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800dc7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dcb:	89 34 24             	mov    %esi,(%esp)
  800dce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dd2:	89 da                	mov    %ebx,%edx
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	e8 24 fb ff ff       	call   800900 <printnum>
			break;
  800ddc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800ddf:	e9 99 fc ff ff       	jmp    800a7d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800de4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800de8:	89 14 24             	mov    %edx,(%esp)
  800deb:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dee:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800df1:	e9 87 fc ff ff       	jmp    800a7d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800df6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800dfa:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800e01:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e04:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800e08:	0f 84 6f fc ff ff    	je     800a7d <vprintfmt+0x23>
  800e0e:	83 ee 01             	sub    $0x1,%esi
  800e11:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800e15:	75 f7                	jne    800e0e <vprintfmt+0x3b4>
  800e17:	e9 61 fc ff ff       	jmp    800a7d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  800e1c:	83 c4 4c             	add    $0x4c,%esp
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 28             	sub    $0x28,%esp
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e33:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e37:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	74 30                	je     800e75 <vsnprintf+0x51>
  800e45:	85 d2                	test   %edx,%edx
  800e47:	7e 2c                	jle    800e75 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e49:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e50:	8b 45 10             	mov    0x10(%ebp),%eax
  800e53:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e57:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e5e:	c7 04 24 15 0a 80 00 	movl   $0x800a15,(%esp)
  800e65:	e8 f0 fb ff ff       	call   800a5a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e6d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e73:	eb 05                	jmp    800e7a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800e75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e82:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e85:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e89:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	89 04 24             	mov    %eax,(%esp)
  800e9d:	e8 82 ff ff ff       	call   800e24 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    
	...

00800eb0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800eb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebb:	80 3a 00             	cmpb   $0x0,(%edx)
  800ebe:	74 09                	je     800ec9 <strlen+0x19>
		n++;
  800ec0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ec3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ec7:	75 f7                	jne    800ec0 <strlen+0x10>
		n++;
	return n;
}
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	53                   	push   %ebx
  800ecf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ed2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eda:	85 c9                	test   %ecx,%ecx
  800edc:	74 1a                	je     800ef8 <strnlen+0x2d>
  800ede:	80 3b 00             	cmpb   $0x0,(%ebx)
  800ee1:	74 15                	je     800ef8 <strnlen+0x2d>
  800ee3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800ee8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eea:	39 ca                	cmp    %ecx,%edx
  800eec:	74 0a                	je     800ef8 <strnlen+0x2d>
  800eee:	83 c2 01             	add    $0x1,%edx
  800ef1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800ef6:	75 f0                	jne    800ee8 <strnlen+0x1d>
		n++;
	return n;
}
  800ef8:	5b                   	pop    %ebx
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	53                   	push   %ebx
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f05:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800f0e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800f11:	83 c2 01             	add    $0x1,%edx
  800f14:	84 c9                	test   %cl,%cl
  800f16:	75 f2                	jne    800f0a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800f18:	5b                   	pop    %ebx
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	53                   	push   %ebx
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f25:	89 1c 24             	mov    %ebx,(%esp)
  800f28:	e8 83 ff ff ff       	call   800eb0 <strlen>
	strcpy(dst + len, src);
  800f2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f30:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f34:	01 d8                	add    %ebx,%eax
  800f36:	89 04 24             	mov    %eax,(%esp)
  800f39:	e8 bd ff ff ff       	call   800efb <strcpy>
	return dst;
}
  800f3e:	89 d8                	mov    %ebx,%eax
  800f40:	83 c4 08             	add    $0x8,%esp
  800f43:	5b                   	pop    %ebx
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f51:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f54:	85 f6                	test   %esi,%esi
  800f56:	74 18                	je     800f70 <strncpy+0x2a>
  800f58:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800f5d:	0f b6 1a             	movzbl (%edx),%ebx
  800f60:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f63:	80 3a 01             	cmpb   $0x1,(%edx)
  800f66:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f69:	83 c1 01             	add    $0x1,%ecx
  800f6c:	39 f1                	cmp    %esi,%ecx
  800f6e:	75 ed                	jne    800f5d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	57                   	push   %edi
  800f78:	56                   	push   %esi
  800f79:	53                   	push   %ebx
  800f7a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f80:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f83:	89 f8                	mov    %edi,%eax
  800f85:	85 f6                	test   %esi,%esi
  800f87:	74 2b                	je     800fb4 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800f89:	83 fe 01             	cmp    $0x1,%esi
  800f8c:	74 23                	je     800fb1 <strlcpy+0x3d>
  800f8e:	0f b6 0b             	movzbl (%ebx),%ecx
  800f91:	84 c9                	test   %cl,%cl
  800f93:	74 1c                	je     800fb1 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800f95:	83 ee 02             	sub    $0x2,%esi
  800f98:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800f9d:	88 08                	mov    %cl,(%eax)
  800f9f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fa2:	39 f2                	cmp    %esi,%edx
  800fa4:	74 0b                	je     800fb1 <strlcpy+0x3d>
  800fa6:	83 c2 01             	add    $0x1,%edx
  800fa9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800fad:	84 c9                	test   %cl,%cl
  800faf:	75 ec                	jne    800f9d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800fb1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fb4:	29 f8                	sub    %edi,%eax
}
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5f                   	pop    %edi
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800fc4:	0f b6 01             	movzbl (%ecx),%eax
  800fc7:	84 c0                	test   %al,%al
  800fc9:	74 16                	je     800fe1 <strcmp+0x26>
  800fcb:	3a 02                	cmp    (%edx),%al
  800fcd:	75 12                	jne    800fe1 <strcmp+0x26>
		p++, q++;
  800fcf:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fd2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800fd6:	84 c0                	test   %al,%al
  800fd8:	74 07                	je     800fe1 <strcmp+0x26>
  800fda:	83 c1 01             	add    $0x1,%ecx
  800fdd:	3a 02                	cmp    (%edx),%al
  800fdf:	74 ee                	je     800fcf <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe1:	0f b6 c0             	movzbl %al,%eax
  800fe4:	0f b6 12             	movzbl (%edx),%edx
  800fe7:	29 d0                	sub    %edx,%eax
}
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	53                   	push   %ebx
  800fef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ff5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ff8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ffd:	85 d2                	test   %edx,%edx
  800fff:	74 28                	je     801029 <strncmp+0x3e>
  801001:	0f b6 01             	movzbl (%ecx),%eax
  801004:	84 c0                	test   %al,%al
  801006:	74 24                	je     80102c <strncmp+0x41>
  801008:	3a 03                	cmp    (%ebx),%al
  80100a:	75 20                	jne    80102c <strncmp+0x41>
  80100c:	83 ea 01             	sub    $0x1,%edx
  80100f:	74 13                	je     801024 <strncmp+0x39>
		n--, p++, q++;
  801011:	83 c1 01             	add    $0x1,%ecx
  801014:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801017:	0f b6 01             	movzbl (%ecx),%eax
  80101a:	84 c0                	test   %al,%al
  80101c:	74 0e                	je     80102c <strncmp+0x41>
  80101e:	3a 03                	cmp    (%ebx),%al
  801020:	74 ea                	je     80100c <strncmp+0x21>
  801022:	eb 08                	jmp    80102c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801024:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801029:	5b                   	pop    %ebx
  80102a:	5d                   	pop    %ebp
  80102b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80102c:	0f b6 01             	movzbl (%ecx),%eax
  80102f:	0f b6 13             	movzbl (%ebx),%edx
  801032:	29 d0                	sub    %edx,%eax
  801034:	eb f3                	jmp    801029 <strncmp+0x3e>

00801036 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801040:	0f b6 10             	movzbl (%eax),%edx
  801043:	84 d2                	test   %dl,%dl
  801045:	74 1c                	je     801063 <strchr+0x2d>
		if (*s == c)
  801047:	38 ca                	cmp    %cl,%dl
  801049:	75 09                	jne    801054 <strchr+0x1e>
  80104b:	eb 1b                	jmp    801068 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80104d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  801050:	38 ca                	cmp    %cl,%dl
  801052:	74 14                	je     801068 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801054:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  801058:	84 d2                	test   %dl,%dl
  80105a:	75 f1                	jne    80104d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80105c:	b8 00 00 00 00       	mov    $0x0,%eax
  801061:	eb 05                	jmp    801068 <strchr+0x32>
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801074:	0f b6 10             	movzbl (%eax),%edx
  801077:	84 d2                	test   %dl,%dl
  801079:	74 14                	je     80108f <strfind+0x25>
		if (*s == c)
  80107b:	38 ca                	cmp    %cl,%dl
  80107d:	75 06                	jne    801085 <strfind+0x1b>
  80107f:	eb 0e                	jmp    80108f <strfind+0x25>
  801081:	38 ca                	cmp    %cl,%dl
  801083:	74 0a                	je     80108f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801085:	83 c0 01             	add    $0x1,%eax
  801088:	0f b6 10             	movzbl (%eax),%edx
  80108b:	84 d2                	test   %dl,%dl
  80108d:	75 f2                	jne    801081 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80108f:	5d                   	pop    %ebp
  801090:	c3                   	ret    

00801091 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	83 ec 0c             	sub    $0xc,%esp
  801097:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80109a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80109d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8010a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8010a9:	85 c9                	test   %ecx,%ecx
  8010ab:	74 30                	je     8010dd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8010ad:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8010b3:	75 25                	jne    8010da <memset+0x49>
  8010b5:	f6 c1 03             	test   $0x3,%cl
  8010b8:	75 20                	jne    8010da <memset+0x49>
		c &= 0xFF;
  8010ba:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010bd:	89 d3                	mov    %edx,%ebx
  8010bf:	c1 e3 08             	shl    $0x8,%ebx
  8010c2:	89 d6                	mov    %edx,%esi
  8010c4:	c1 e6 18             	shl    $0x18,%esi
  8010c7:	89 d0                	mov    %edx,%eax
  8010c9:	c1 e0 10             	shl    $0x10,%eax
  8010cc:	09 f0                	or     %esi,%eax
  8010ce:	09 d0                	or     %edx,%eax
  8010d0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8010d2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8010d5:	fc                   	cld    
  8010d6:	f3 ab                	rep stos %eax,%es:(%edi)
  8010d8:	eb 03                	jmp    8010dd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8010da:	fc                   	cld    
  8010db:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8010dd:	89 f8                	mov    %edi,%eax
  8010df:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010e2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010e5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010e8:	89 ec                	mov    %ebp,%esp
  8010ea:	5d                   	pop    %ebp
  8010eb:	c3                   	ret    

008010ec <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	83 ec 08             	sub    $0x8,%esp
  8010f2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010f5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801101:	39 c6                	cmp    %eax,%esi
  801103:	73 36                	jae    80113b <memmove+0x4f>
  801105:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801108:	39 d0                	cmp    %edx,%eax
  80110a:	73 2f                	jae    80113b <memmove+0x4f>
		s += n;
		d += n;
  80110c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80110f:	f6 c2 03             	test   $0x3,%dl
  801112:	75 1b                	jne    80112f <memmove+0x43>
  801114:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80111a:	75 13                	jne    80112f <memmove+0x43>
  80111c:	f6 c1 03             	test   $0x3,%cl
  80111f:	75 0e                	jne    80112f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801121:	83 ef 04             	sub    $0x4,%edi
  801124:	8d 72 fc             	lea    -0x4(%edx),%esi
  801127:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80112a:	fd                   	std    
  80112b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80112d:	eb 09                	jmp    801138 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80112f:	83 ef 01             	sub    $0x1,%edi
  801132:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801135:	fd                   	std    
  801136:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801138:	fc                   	cld    
  801139:	eb 20                	jmp    80115b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80113b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801141:	75 13                	jne    801156 <memmove+0x6a>
  801143:	a8 03                	test   $0x3,%al
  801145:	75 0f                	jne    801156 <memmove+0x6a>
  801147:	f6 c1 03             	test   $0x3,%cl
  80114a:	75 0a                	jne    801156 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80114c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80114f:	89 c7                	mov    %eax,%edi
  801151:	fc                   	cld    
  801152:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801154:	eb 05                	jmp    80115b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801156:	89 c7                	mov    %eax,%edi
  801158:	fc                   	cld    
  801159:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80115b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80115e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801161:	89 ec                	mov    %ebp,%esp
  801163:	5d                   	pop    %ebp
  801164:	c3                   	ret    

00801165 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80116b:	8b 45 10             	mov    0x10(%ebp),%eax
  80116e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	89 44 24 04          	mov    %eax,0x4(%esp)
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	89 04 24             	mov    %eax,(%esp)
  80117f:	e8 68 ff ff ff       	call   8010ec <memmove>
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	57                   	push   %edi
  80118a:	56                   	push   %esi
  80118b:	53                   	push   %ebx
  80118c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80118f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801192:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801195:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80119a:	85 ff                	test   %edi,%edi
  80119c:	74 37                	je     8011d5 <memcmp+0x4f>
		if (*s1 != *s2)
  80119e:	0f b6 03             	movzbl (%ebx),%eax
  8011a1:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8011a4:	83 ef 01             	sub    $0x1,%edi
  8011a7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  8011ac:	38 c8                	cmp    %cl,%al
  8011ae:	74 1c                	je     8011cc <memcmp+0x46>
  8011b0:	eb 10                	jmp    8011c2 <memcmp+0x3c>
  8011b2:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  8011b7:	83 c2 01             	add    $0x1,%edx
  8011ba:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  8011be:	38 c8                	cmp    %cl,%al
  8011c0:	74 0a                	je     8011cc <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  8011c2:	0f b6 c0             	movzbl %al,%eax
  8011c5:	0f b6 c9             	movzbl %cl,%ecx
  8011c8:	29 c8                	sub    %ecx,%eax
  8011ca:	eb 09                	jmp    8011d5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8011cc:	39 fa                	cmp    %edi,%edx
  8011ce:	75 e2                	jne    8011b2 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d5:	5b                   	pop    %ebx
  8011d6:	5e                   	pop    %esi
  8011d7:	5f                   	pop    %edi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    

008011da <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8011e0:	89 c2                	mov    %eax,%edx
  8011e2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8011e5:	39 d0                	cmp    %edx,%eax
  8011e7:	73 19                	jae    801202 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011e9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  8011ed:	38 08                	cmp    %cl,(%eax)
  8011ef:	75 06                	jne    8011f7 <memfind+0x1d>
  8011f1:	eb 0f                	jmp    801202 <memfind+0x28>
  8011f3:	38 08                	cmp    %cl,(%eax)
  8011f5:	74 0b                	je     801202 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011f7:	83 c0 01             	add    $0x1,%eax
  8011fa:	39 d0                	cmp    %edx,%eax
  8011fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801200:	75 f1                	jne    8011f3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801202:	5d                   	pop    %ebp
  801203:	c3                   	ret    

00801204 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	57                   	push   %edi
  801208:	56                   	push   %esi
  801209:	53                   	push   %ebx
  80120a:	8b 55 08             	mov    0x8(%ebp),%edx
  80120d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801210:	0f b6 02             	movzbl (%edx),%eax
  801213:	3c 20                	cmp    $0x20,%al
  801215:	74 04                	je     80121b <strtol+0x17>
  801217:	3c 09                	cmp    $0x9,%al
  801219:	75 0e                	jne    801229 <strtol+0x25>
		s++;
  80121b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80121e:	0f b6 02             	movzbl (%edx),%eax
  801221:	3c 20                	cmp    $0x20,%al
  801223:	74 f6                	je     80121b <strtol+0x17>
  801225:	3c 09                	cmp    $0x9,%al
  801227:	74 f2                	je     80121b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  801229:	3c 2b                	cmp    $0x2b,%al
  80122b:	75 0a                	jne    801237 <strtol+0x33>
		s++;
  80122d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801230:	bf 00 00 00 00       	mov    $0x0,%edi
  801235:	eb 10                	jmp    801247 <strtol+0x43>
  801237:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80123c:	3c 2d                	cmp    $0x2d,%al
  80123e:	75 07                	jne    801247 <strtol+0x43>
		s++, neg = 1;
  801240:	83 c2 01             	add    $0x1,%edx
  801243:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801247:	85 db                	test   %ebx,%ebx
  801249:	0f 94 c0             	sete   %al
  80124c:	74 05                	je     801253 <strtol+0x4f>
  80124e:	83 fb 10             	cmp    $0x10,%ebx
  801251:	75 15                	jne    801268 <strtol+0x64>
  801253:	80 3a 30             	cmpb   $0x30,(%edx)
  801256:	75 10                	jne    801268 <strtol+0x64>
  801258:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80125c:	75 0a                	jne    801268 <strtol+0x64>
		s += 2, base = 16;
  80125e:	83 c2 02             	add    $0x2,%edx
  801261:	bb 10 00 00 00       	mov    $0x10,%ebx
  801266:	eb 13                	jmp    80127b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  801268:	84 c0                	test   %al,%al
  80126a:	74 0f                	je     80127b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80126c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801271:	80 3a 30             	cmpb   $0x30,(%edx)
  801274:	75 05                	jne    80127b <strtol+0x77>
		s++, base = 8;
  801276:	83 c2 01             	add    $0x1,%edx
  801279:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  80127b:	b8 00 00 00 00       	mov    $0x0,%eax
  801280:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801282:	0f b6 0a             	movzbl (%edx),%ecx
  801285:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801288:	80 fb 09             	cmp    $0x9,%bl
  80128b:	77 08                	ja     801295 <strtol+0x91>
			dig = *s - '0';
  80128d:	0f be c9             	movsbl %cl,%ecx
  801290:	83 e9 30             	sub    $0x30,%ecx
  801293:	eb 1e                	jmp    8012b3 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  801295:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  801298:	80 fb 19             	cmp    $0x19,%bl
  80129b:	77 08                	ja     8012a5 <strtol+0xa1>
			dig = *s - 'a' + 10;
  80129d:	0f be c9             	movsbl %cl,%ecx
  8012a0:	83 e9 57             	sub    $0x57,%ecx
  8012a3:	eb 0e                	jmp    8012b3 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  8012a5:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  8012a8:	80 fb 19             	cmp    $0x19,%bl
  8012ab:	77 14                	ja     8012c1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  8012ad:	0f be c9             	movsbl %cl,%ecx
  8012b0:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8012b3:	39 f1                	cmp    %esi,%ecx
  8012b5:	7d 0e                	jge    8012c5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8012b7:	83 c2 01             	add    $0x1,%edx
  8012ba:	0f af c6             	imul   %esi,%eax
  8012bd:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  8012bf:	eb c1                	jmp    801282 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  8012c1:	89 c1                	mov    %eax,%ecx
  8012c3:	eb 02                	jmp    8012c7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8012c5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012cb:	74 05                	je     8012d2 <strtol+0xce>
		*endptr = (char *) s;
  8012cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012d0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  8012d2:	89 ca                	mov    %ecx,%edx
  8012d4:	f7 da                	neg    %edx
  8012d6:	85 ff                	test   %edi,%edi
  8012d8:	0f 45 c2             	cmovne %edx,%eax
}
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    

008012e0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 0c             	sub    $0xc,%esp
  8012e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012ec:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fa:	89 c3                	mov    %eax,%ebx
  8012fc:	89 c7                	mov    %eax,%edi
  8012fe:	89 c6                	mov    %eax,%esi
  801300:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801302:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801305:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801308:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80130b:	89 ec                	mov    %ebp,%esp
  80130d:	5d                   	pop    %ebp
  80130e:	c3                   	ret    

0080130f <sys_cgetc>:

int
sys_cgetc(void)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801318:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80131b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80131e:	ba 00 00 00 00       	mov    $0x0,%edx
  801323:	b8 01 00 00 00       	mov    $0x1,%eax
  801328:	89 d1                	mov    %edx,%ecx
  80132a:	89 d3                	mov    %edx,%ebx
  80132c:	89 d7                	mov    %edx,%edi
  80132e:	89 d6                	mov    %edx,%esi
  801330:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801332:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801335:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801338:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80133b:	89 ec                	mov    %ebp,%esp
  80133d:	5d                   	pop    %ebp
  80133e:	c3                   	ret    

0080133f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 38             	sub    $0x38,%esp
  801345:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801348:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80134b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80134e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801353:	b8 03 00 00 00       	mov    $0x3,%eax
  801358:	8b 55 08             	mov    0x8(%ebp),%edx
  80135b:	89 cb                	mov    %ecx,%ebx
  80135d:	89 cf                	mov    %ecx,%edi
  80135f:	89 ce                	mov    %ecx,%esi
  801361:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801363:	85 c0                	test   %eax,%eax
  801365:	7e 28                	jle    80138f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801367:	89 44 24 10          	mov    %eax,0x10(%esp)
  80136b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801372:	00 
  801373:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  80137a:	00 
  80137b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801382:	00 
  801383:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  80138a:	e8 59 f4 ff ff       	call   8007e8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80138f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801392:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801395:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801398:	89 ec                	mov    %ebp,%esp
  80139a:	5d                   	pop    %ebp
  80139b:	c3                   	ret    

0080139c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	83 ec 0c             	sub    $0xc,%esp
  8013a2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013a5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013a8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b0:	b8 02 00 00 00       	mov    $0x2,%eax
  8013b5:	89 d1                	mov    %edx,%ecx
  8013b7:	89 d3                	mov    %edx,%ebx
  8013b9:	89 d7                	mov    %edx,%edi
  8013bb:	89 d6                	mov    %edx,%esi
  8013bd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013bf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013c2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013c5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013c8:	89 ec                	mov    %ebp,%esp
  8013ca:	5d                   	pop    %ebp
  8013cb:	c3                   	ret    

008013cc <sys_yield>:

void
sys_yield(void)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 0c             	sub    $0xc,%esp
  8013d2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013d5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013d8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013db:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013e5:	89 d1                	mov    %edx,%ecx
  8013e7:	89 d3                	mov    %edx,%ebx
  8013e9:	89 d7                	mov    %edx,%edi
  8013eb:	89 d6                	mov    %edx,%esi
  8013ed:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8013ef:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013f2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013f5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013f8:	89 ec                	mov    %ebp,%esp
  8013fa:	5d                   	pop    %ebp
  8013fb:	c3                   	ret    

008013fc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 38             	sub    $0x38,%esp
  801402:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801405:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801408:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80140b:	be 00 00 00 00       	mov    $0x0,%esi
  801410:	b8 04 00 00 00       	mov    $0x4,%eax
  801415:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801418:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141b:	8b 55 08             	mov    0x8(%ebp),%edx
  80141e:	89 f7                	mov    %esi,%edi
  801420:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801422:	85 c0                	test   %eax,%eax
  801424:	7e 28                	jle    80144e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801426:	89 44 24 10          	mov    %eax,0x10(%esp)
  80142a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801431:	00 
  801432:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  801439:	00 
  80143a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801441:	00 
  801442:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  801449:	e8 9a f3 ff ff       	call   8007e8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80144e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801451:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801454:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801457:	89 ec                	mov    %ebp,%esp
  801459:	5d                   	pop    %ebp
  80145a:	c3                   	ret    

0080145b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 38             	sub    $0x38,%esp
  801461:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801464:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801467:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80146a:	b8 05 00 00 00       	mov    $0x5,%eax
  80146f:	8b 75 18             	mov    0x18(%ebp),%esi
  801472:	8b 7d 14             	mov    0x14(%ebp),%edi
  801475:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801478:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80147b:	8b 55 08             	mov    0x8(%ebp),%edx
  80147e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801480:	85 c0                	test   %eax,%eax
  801482:	7e 28                	jle    8014ac <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801484:	89 44 24 10          	mov    %eax,0x10(%esp)
  801488:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80148f:	00 
  801490:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  801497:	00 
  801498:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80149f:	00 
  8014a0:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  8014a7:	e8 3c f3 ff ff       	call   8007e8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8014ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014af:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014b5:	89 ec                	mov    %ebp,%esp
  8014b7:	5d                   	pop    %ebp
  8014b8:	c3                   	ret    

008014b9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 38             	sub    $0x38,%esp
  8014bf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014c2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014c5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014cd:	b8 06 00 00 00       	mov    $0x6,%eax
  8014d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d8:	89 df                	mov    %ebx,%edi
  8014da:	89 de                	mov    %ebx,%esi
  8014dc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	7e 28                	jle    80150a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014e6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8014ed:	00 
  8014ee:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  8014f5:	00 
  8014f6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014fd:	00 
  8014fe:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  801505:	e8 de f2 ff ff       	call   8007e8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80150a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80150d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801510:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801513:	89 ec                	mov    %ebp,%esp
  801515:	5d                   	pop    %ebp
  801516:	c3                   	ret    

00801517 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	83 ec 38             	sub    $0x38,%esp
  80151d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801520:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801523:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801526:	bb 00 00 00 00       	mov    $0x0,%ebx
  80152b:	b8 08 00 00 00       	mov    $0x8,%eax
  801530:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	89 df                	mov    %ebx,%edi
  801538:	89 de                	mov    %ebx,%esi
  80153a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80153c:	85 c0                	test   %eax,%eax
  80153e:	7e 28                	jle    801568 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801540:	89 44 24 10          	mov    %eax,0x10(%esp)
  801544:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80154b:	00 
  80154c:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  801553:	00 
  801554:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80155b:	00 
  80155c:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  801563:	e8 80 f2 ff ff       	call   8007e8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801568:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80156b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80156e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801571:	89 ec                	mov    %ebp,%esp
  801573:	5d                   	pop    %ebp
  801574:	c3                   	ret    

00801575 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 38             	sub    $0x38,%esp
  80157b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80157e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801581:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801584:	bb 00 00 00 00       	mov    $0x0,%ebx
  801589:	b8 09 00 00 00       	mov    $0x9,%eax
  80158e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801591:	8b 55 08             	mov    0x8(%ebp),%edx
  801594:	89 df                	mov    %ebx,%edi
  801596:	89 de                	mov    %ebx,%esi
  801598:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80159a:	85 c0                	test   %eax,%eax
  80159c:	7e 28                	jle    8015c6 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80159e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015a2:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8015a9:	00 
  8015aa:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  8015b1:	00 
  8015b2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015b9:	00 
  8015ba:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  8015c1:	e8 22 f2 ff ff       	call   8007e8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8015c6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015c9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015cc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015cf:	89 ec                	mov    %ebp,%esp
  8015d1:	5d                   	pop    %ebp
  8015d2:	c3                   	ret    

008015d3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 38             	sub    $0x38,%esp
  8015d9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015dc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015df:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f2:	89 df                	mov    %ebx,%edi
  8015f4:	89 de                	mov    %ebx,%esi
  8015f6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	7e 28                	jle    801624 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  801600:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801607:	00 
  801608:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  80160f:	00 
  801610:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801617:	00 
  801618:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  80161f:	e8 c4 f1 ff ff       	call   8007e8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801624:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801627:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80162a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80162d:	89 ec                	mov    %ebp,%esp
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    

00801631 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 0c             	sub    $0xc,%esp
  801637:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80163a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80163d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801640:	be 00 00 00 00       	mov    $0x0,%esi
  801645:	b8 0c 00 00 00       	mov    $0xc,%eax
  80164a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80164d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801650:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801653:	8b 55 08             	mov    0x8(%ebp),%edx
  801656:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801658:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80165b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80165e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801661:	89 ec                	mov    %ebp,%esp
  801663:	5d                   	pop    %ebp
  801664:	c3                   	ret    

00801665 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	83 ec 38             	sub    $0x38,%esp
  80166b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80166e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801671:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801674:	b9 00 00 00 00       	mov    $0x0,%ecx
  801679:	b8 0d 00 00 00       	mov    $0xd,%eax
  80167e:	8b 55 08             	mov    0x8(%ebp),%edx
  801681:	89 cb                	mov    %ecx,%ebx
  801683:	89 cf                	mov    %ecx,%edi
  801685:	89 ce                	mov    %ecx,%esi
  801687:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801689:	85 c0                	test   %eax,%eax
  80168b:	7e 28                	jle    8016b5 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80168d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801691:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801698:	00 
  801699:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  8016a0:	00 
  8016a1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016a8:	00 
  8016a9:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  8016b0:	e8 33 f1 ff ff       	call   8007e8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8016b5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016b8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016bb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016be:	89 ec                	mov    %ebp,%esp
  8016c0:	5d                   	pop    %ebp
  8016c1:	c3                   	ret    
	...

008016d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
  8016d5:	83 ec 10             	sub    $0x10,%esp
  8016d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8016db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  8016e1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  8016e3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8016e8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  8016eb:	89 04 24             	mov    %eax,(%esp)
  8016ee:	e8 72 ff ff ff       	call   801665 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  8016f3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  8016f8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	78 0e                	js     80170f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801701:	a1 04 50 80 00       	mov    0x805004,%eax
  801706:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801709:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  80170c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  80170f:	85 f6                	test   %esi,%esi
  801711:	74 02                	je     801715 <ipc_recv+0x45>
		*from_env_store = sender;
  801713:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801715:	85 db                	test   %ebx,%ebx
  801717:	74 02                	je     80171b <ipc_recv+0x4b>
		*perm_store = perm;
  801719:	89 13                	mov    %edx,(%ebx)
	return val;

}
  80171b:	83 c4 10             	add    $0x10,%esp
  80171e:	5b                   	pop    %ebx
  80171f:	5e                   	pop    %esi
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    

00801722 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	57                   	push   %edi
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
  801728:	83 ec 1c             	sub    $0x1c,%esp
  80172b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80172e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801731:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801734:	85 db                	test   %ebx,%ebx
  801736:	75 04                	jne    80173c <ipc_send+0x1a>
  801738:	85 f6                	test   %esi,%esi
  80173a:	75 15                	jne    801751 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80173c:	85 db                	test   %ebx,%ebx
  80173e:	74 16                	je     801756 <ipc_send+0x34>
  801740:	85 f6                	test   %esi,%esi
  801742:	0f 94 c0             	sete   %al
      pg = 0;
  801745:	84 c0                	test   %al,%al
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
  80174c:	0f 45 d8             	cmovne %eax,%ebx
  80174f:	eb 05                	jmp    801756 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801751:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801756:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80175a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80175e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	89 04 24             	mov    %eax,(%esp)
  801768:	e8 c4 fe ff ff       	call   801631 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80176d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801770:	75 07                	jne    801779 <ipc_send+0x57>
           sys_yield();
  801772:	e8 55 fc ff ff       	call   8013cc <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801777:	eb dd                	jmp    801756 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801779:	85 c0                	test   %eax,%eax
  80177b:	90                   	nop
  80177c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801780:	74 1c                	je     80179e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801782:	c7 44 24 08 0a 30 80 	movl   $0x80300a,0x8(%esp)
  801789:	00 
  80178a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801791:	00 
  801792:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801799:	e8 4a f0 ff ff       	call   8007e8 <_panic>
		}
    }
}
  80179e:	83 c4 1c             	add    $0x1c,%esp
  8017a1:	5b                   	pop    %ebx
  8017a2:	5e                   	pop    %esi
  8017a3:	5f                   	pop    %edi
  8017a4:	5d                   	pop    %ebp
  8017a5:	c3                   	ret    

008017a6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8017ac:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8017b1:	39 c8                	cmp    %ecx,%eax
  8017b3:	74 17                	je     8017cc <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8017b5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8017ba:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8017bd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8017c3:	8b 52 50             	mov    0x50(%edx),%edx
  8017c6:	39 ca                	cmp    %ecx,%edx
  8017c8:	75 14                	jne    8017de <ipc_find_env+0x38>
  8017ca:	eb 05                	jmp    8017d1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8017d1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8017d4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8017d9:	8b 40 40             	mov    0x40(%eax),%eax
  8017dc:	eb 0e                	jmp    8017ec <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8017de:	83 c0 01             	add    $0x1,%eax
  8017e1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8017e6:	75 d2                	jne    8017ba <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8017e8:	66 b8 00 00          	mov    $0x0,%ax
}
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    
	...

008017f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8017fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	89 04 24             	mov    %eax,(%esp)
  80180c:	e8 df ff ff ff       	call   8017f0 <fd2num>
  801811:	05 20 00 0d 00       	add    $0xd0020,%eax
  801816:	c1 e0 0c             	shl    $0xc,%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	53                   	push   %ebx
  80181f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801822:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801827:	a8 01                	test   $0x1,%al
  801829:	74 34                	je     80185f <fd_alloc+0x44>
  80182b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801830:	a8 01                	test   $0x1,%al
  801832:	74 32                	je     801866 <fd_alloc+0x4b>
  801834:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801839:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80183b:	89 c2                	mov    %eax,%edx
  80183d:	c1 ea 16             	shr    $0x16,%edx
  801840:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801847:	f6 c2 01             	test   $0x1,%dl
  80184a:	74 1f                	je     80186b <fd_alloc+0x50>
  80184c:	89 c2                	mov    %eax,%edx
  80184e:	c1 ea 0c             	shr    $0xc,%edx
  801851:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801858:	f6 c2 01             	test   $0x1,%dl
  80185b:	75 17                	jne    801874 <fd_alloc+0x59>
  80185d:	eb 0c                	jmp    80186b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80185f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801864:	eb 05                	jmp    80186b <fd_alloc+0x50>
  801866:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80186b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80186d:	b8 00 00 00 00       	mov    $0x0,%eax
  801872:	eb 17                	jmp    80188b <fd_alloc+0x70>
  801874:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801879:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80187e:	75 b9                	jne    801839 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801880:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801886:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80188b:	5b                   	pop    %ebx
  80188c:	5d                   	pop    %ebp
  80188d:	c3                   	ret    

0080188e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801894:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801899:	83 fa 1f             	cmp    $0x1f,%edx
  80189c:	77 3f                	ja     8018dd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80189e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  8018a4:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018a7:	89 d0                	mov    %edx,%eax
  8018a9:	c1 e8 16             	shr    $0x16,%eax
  8018ac:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018b8:	f6 c1 01             	test   $0x1,%cl
  8018bb:	74 20                	je     8018dd <fd_lookup+0x4f>
  8018bd:	89 d0                	mov    %edx,%eax
  8018bf:	c1 e8 0c             	shr    $0xc,%eax
  8018c2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018ce:	f6 c1 01             	test   $0x1,%cl
  8018d1:	74 0a                	je     8018dd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d6:	89 10                	mov    %edx,(%eax)
	return 0;
  8018d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018dd:	5d                   	pop    %ebp
  8018de:	c3                   	ret    

008018df <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	53                   	push   %ebx
  8018e3:	83 ec 14             	sub    $0x14,%esp
  8018e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8018ec:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8018f1:	39 0d 08 40 80 00    	cmp    %ecx,0x804008
  8018f7:	75 17                	jne    801910 <dev_lookup+0x31>
  8018f9:	eb 07                	jmp    801902 <dev_lookup+0x23>
  8018fb:	39 0a                	cmp    %ecx,(%edx)
  8018fd:	75 11                	jne    801910 <dev_lookup+0x31>
  8018ff:	90                   	nop
  801900:	eb 05                	jmp    801907 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801902:	ba 08 40 80 00       	mov    $0x804008,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801907:	89 13                	mov    %edx,(%ebx)
			return 0;
  801909:	b8 00 00 00 00       	mov    $0x0,%eax
  80190e:	eb 35                	jmp    801945 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801910:	83 c0 01             	add    $0x1,%eax
  801913:	8b 14 85 a0 30 80 00 	mov    0x8030a0(,%eax,4),%edx
  80191a:	85 d2                	test   %edx,%edx
  80191c:	75 dd                	jne    8018fb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80191e:	a1 04 50 80 00       	mov    0x805004,%eax
  801923:	8b 40 48             	mov    0x48(%eax),%eax
  801926:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80192a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192e:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  801935:	e8 a9 ef ff ff       	call   8008e3 <cprintf>
	*dev = 0;
  80193a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801940:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801945:	83 c4 14             	add    $0x14,%esp
  801948:	5b                   	pop    %ebx
  801949:	5d                   	pop    %ebp
  80194a:	c3                   	ret    

0080194b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	83 ec 38             	sub    $0x38,%esp
  801951:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801954:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801957:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80195a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80195d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801961:	89 3c 24             	mov    %edi,(%esp)
  801964:	e8 87 fe ff ff       	call   8017f0 <fd2num>
  801969:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80196c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801970:	89 04 24             	mov    %eax,(%esp)
  801973:	e8 16 ff ff ff       	call   80188e <fd_lookup>
  801978:	89 c3                	mov    %eax,%ebx
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 05                	js     801983 <fd_close+0x38>
	    || fd != fd2)
  80197e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801981:	74 0e                	je     801991 <fd_close+0x46>
		return (must_exist ? r : 0);
  801983:	89 f0                	mov    %esi,%eax
  801985:	84 c0                	test   %al,%al
  801987:	b8 00 00 00 00       	mov    $0x0,%eax
  80198c:	0f 44 d8             	cmove  %eax,%ebx
  80198f:	eb 3d                	jmp    8019ce <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801991:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801994:	89 44 24 04          	mov    %eax,0x4(%esp)
  801998:	8b 07                	mov    (%edi),%eax
  80199a:	89 04 24             	mov    %eax,(%esp)
  80199d:	e8 3d ff ff ff       	call   8018df <dev_lookup>
  8019a2:	89 c3                	mov    %eax,%ebx
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 16                	js     8019be <fd_close+0x73>
		if (dev->dev_close)
  8019a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8019ae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	74 07                	je     8019be <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8019b7:	89 3c 24             	mov    %edi,(%esp)
  8019ba:	ff d0                	call   *%eax
  8019bc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8019be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019c9:	e8 eb fa ff ff       	call   8014b9 <sys_page_unmap>
	return r;
}
  8019ce:	89 d8                	mov    %ebx,%eax
  8019d0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019d3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019d6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019d9:	89 ec                	mov    %ebp,%esp
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    

008019dd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	89 04 24             	mov    %eax,(%esp)
  8019f0:	e8 99 fe ff ff       	call   80188e <fd_lookup>
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	78 13                	js     801a0c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8019f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a00:	00 
  801a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a04:	89 04 24             	mov    %eax,(%esp)
  801a07:	e8 3f ff ff ff       	call   80194b <fd_close>
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <close_all>:

void
close_all(void)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	53                   	push   %ebx
  801a12:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a15:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a1a:	89 1c 24             	mov    %ebx,(%esp)
  801a1d:	e8 bb ff ff ff       	call   8019dd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801a22:	83 c3 01             	add    $0x1,%ebx
  801a25:	83 fb 20             	cmp    $0x20,%ebx
  801a28:	75 f0                	jne    801a1a <close_all+0xc>
		close(i);
}
  801a2a:	83 c4 14             	add    $0x14,%esp
  801a2d:	5b                   	pop    %ebx
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 58             	sub    $0x58,%esp
  801a36:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a39:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a3c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a3f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a42:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	89 04 24             	mov    %eax,(%esp)
  801a4f:	e8 3a fe ff ff       	call   80188e <fd_lookup>
  801a54:	89 c3                	mov    %eax,%ebx
  801a56:	85 c0                	test   %eax,%eax
  801a58:	0f 88 e1 00 00 00    	js     801b3f <dup+0x10f>
		return r;
	close(newfdnum);
  801a5e:	89 3c 24             	mov    %edi,(%esp)
  801a61:	e8 77 ff ff ff       	call   8019dd <close>

	newfd = INDEX2FD(newfdnum);
  801a66:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801a6c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a72:	89 04 24             	mov    %eax,(%esp)
  801a75:	e8 86 fd ff ff       	call   801800 <fd2data>
  801a7a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a7c:	89 34 24             	mov    %esi,(%esp)
  801a7f:	e8 7c fd ff ff       	call   801800 <fd2data>
  801a84:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a87:	89 d8                	mov    %ebx,%eax
  801a89:	c1 e8 16             	shr    $0x16,%eax
  801a8c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a93:	a8 01                	test   $0x1,%al
  801a95:	74 46                	je     801add <dup+0xad>
  801a97:	89 d8                	mov    %ebx,%eax
  801a99:	c1 e8 0c             	shr    $0xc,%eax
  801a9c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801aa3:	f6 c2 01             	test   $0x1,%dl
  801aa6:	74 35                	je     801add <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801aa8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801aaf:	25 07 0e 00 00       	and    $0xe07,%eax
  801ab4:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ab8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801abb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801abf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ac6:	00 
  801ac7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801acb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad2:	e8 84 f9 ff ff       	call   80145b <sys_page_map>
  801ad7:	89 c3                	mov    %eax,%ebx
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	78 3b                	js     801b18 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801add:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ae0:	89 c2                	mov    %eax,%edx
  801ae2:	c1 ea 0c             	shr    $0xc,%edx
  801ae5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801aec:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801af2:	89 54 24 10          	mov    %edx,0x10(%esp)
  801af6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801afa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b01:	00 
  801b02:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b0d:	e8 49 f9 ff ff       	call   80145b <sys_page_map>
  801b12:	89 c3                	mov    %eax,%ebx
  801b14:	85 c0                	test   %eax,%eax
  801b16:	79 25                	jns    801b3d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801b18:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b23:	e8 91 f9 ff ff       	call   8014b9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b36:	e8 7e f9 ff ff       	call   8014b9 <sys_page_unmap>
	return r;
  801b3b:	eb 02                	jmp    801b3f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801b3d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801b3f:	89 d8                	mov    %ebx,%eax
  801b41:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b44:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b47:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b4a:	89 ec                	mov    %ebp,%esp
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    

00801b4e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	53                   	push   %ebx
  801b52:	83 ec 24             	sub    $0x24,%esp
  801b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b58:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5f:	89 1c 24             	mov    %ebx,(%esp)
  801b62:	e8 27 fd ff ff       	call   80188e <fd_lookup>
  801b67:	85 c0                	test   %eax,%eax
  801b69:	78 6d                	js     801bd8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b75:	8b 00                	mov    (%eax),%eax
  801b77:	89 04 24             	mov    %eax,(%esp)
  801b7a:	e8 60 fd ff ff       	call   8018df <dev_lookup>
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 55                	js     801bd8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b86:	8b 50 08             	mov    0x8(%eax),%edx
  801b89:	83 e2 03             	and    $0x3,%edx
  801b8c:	83 fa 01             	cmp    $0x1,%edx
  801b8f:	75 23                	jne    801bb4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b91:	a1 04 50 80 00       	mov    0x805004,%eax
  801b96:	8b 40 48             	mov    0x48(%eax),%eax
  801b99:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba1:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  801ba8:	e8 36 ed ff ff       	call   8008e3 <cprintf>
		return -E_INVAL;
  801bad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bb2:	eb 24                	jmp    801bd8 <read+0x8a>
	}
	if (!dev->dev_read)
  801bb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb7:	8b 52 08             	mov    0x8(%edx),%edx
  801bba:	85 d2                	test   %edx,%edx
  801bbc:	74 15                	je     801bd3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801bbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bc8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bcc:	89 04 24             	mov    %eax,(%esp)
  801bcf:	ff d2                	call   *%edx
  801bd1:	eb 05                	jmp    801bd8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801bd3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801bd8:	83 c4 24             	add    $0x24,%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5d                   	pop    %ebp
  801bdd:	c3                   	ret    

00801bde <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	57                   	push   %edi
  801be2:	56                   	push   %esi
  801be3:	53                   	push   %ebx
  801be4:	83 ec 1c             	sub    $0x1c,%esp
  801be7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bea:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bed:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf2:	85 f6                	test   %esi,%esi
  801bf4:	74 30                	je     801c26 <readn+0x48>
  801bf6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bfb:	89 f2                	mov    %esi,%edx
  801bfd:	29 c2                	sub    %eax,%edx
  801bff:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c03:	03 45 0c             	add    0xc(%ebp),%eax
  801c06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0a:	89 3c 24             	mov    %edi,(%esp)
  801c0d:	e8 3c ff ff ff       	call   801b4e <read>
		if (m < 0)
  801c12:	85 c0                	test   %eax,%eax
  801c14:	78 10                	js     801c26 <readn+0x48>
			return m;
		if (m == 0)
  801c16:	85 c0                	test   %eax,%eax
  801c18:	74 0a                	je     801c24 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c1a:	01 c3                	add    %eax,%ebx
  801c1c:	89 d8                	mov    %ebx,%eax
  801c1e:	39 f3                	cmp    %esi,%ebx
  801c20:	72 d9                	jb     801bfb <readn+0x1d>
  801c22:	eb 02                	jmp    801c26 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  801c24:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  801c26:	83 c4 1c             	add    $0x1c,%esp
  801c29:	5b                   	pop    %ebx
  801c2a:	5e                   	pop    %esi
  801c2b:	5f                   	pop    %edi
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    

00801c2e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	53                   	push   %ebx
  801c32:	83 ec 24             	sub    $0x24,%esp
  801c35:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c38:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3f:	89 1c 24             	mov    %ebx,(%esp)
  801c42:	e8 47 fc ff ff       	call   80188e <fd_lookup>
  801c47:	85 c0                	test   %eax,%eax
  801c49:	78 68                	js     801cb3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c55:	8b 00                	mov    (%eax),%eax
  801c57:	89 04 24             	mov    %eax,(%esp)
  801c5a:	e8 80 fc ff ff       	call   8018df <dev_lookup>
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	78 50                	js     801cb3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c66:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c6a:	75 23                	jne    801c8f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c6c:	a1 04 50 80 00       	mov    0x805004,%eax
  801c71:	8b 40 48             	mov    0x48(%eax),%eax
  801c74:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7c:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  801c83:	e8 5b ec ff ff       	call   8008e3 <cprintf>
		return -E_INVAL;
  801c88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c8d:	eb 24                	jmp    801cb3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c92:	8b 52 0c             	mov    0xc(%edx),%edx
  801c95:	85 d2                	test   %edx,%edx
  801c97:	74 15                	je     801cae <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c9c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ca0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ca3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca7:	89 04 24             	mov    %eax,(%esp)
  801caa:	ff d2                	call   *%edx
  801cac:	eb 05                	jmp    801cb3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801cae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801cb3:	83 c4 24             	add    $0x24,%esp
  801cb6:	5b                   	pop    %ebx
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    

00801cb9 <seek>:

int
seek(int fdnum, off_t offset)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cbf:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	89 04 24             	mov    %eax,(%esp)
  801ccc:	e8 bd fb ff ff       	call   80188e <fd_lookup>
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	78 0e                	js     801ce3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801cde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	53                   	push   %ebx
  801ce9:	83 ec 24             	sub    $0x24,%esp
  801cec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf6:	89 1c 24             	mov    %ebx,(%esp)
  801cf9:	e8 90 fb ff ff       	call   80188e <fd_lookup>
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	78 61                	js     801d63 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d05:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0c:	8b 00                	mov    (%eax),%eax
  801d0e:	89 04 24             	mov    %eax,(%esp)
  801d11:	e8 c9 fb ff ff       	call   8018df <dev_lookup>
  801d16:	85 c0                	test   %eax,%eax
  801d18:	78 49                	js     801d63 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d21:	75 23                	jne    801d46 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801d23:	a1 04 50 80 00       	mov    0x805004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d28:	8b 40 48             	mov    0x48(%eax),%eax
  801d2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d33:	c7 04 24 40 30 80 00 	movl   $0x803040,(%esp)
  801d3a:	e8 a4 eb ff ff       	call   8008e3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801d3f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d44:	eb 1d                	jmp    801d63 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d49:	8b 52 18             	mov    0x18(%edx),%edx
  801d4c:	85 d2                	test   %edx,%edx
  801d4e:	74 0e                	je     801d5e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d57:	89 04 24             	mov    %eax,(%esp)
  801d5a:	ff d2                	call   *%edx
  801d5c:	eb 05                	jmp    801d63 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801d5e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801d63:	83 c4 24             	add    $0x24,%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    

00801d69 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	53                   	push   %ebx
  801d6d:	83 ec 24             	sub    $0x24,%esp
  801d70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d73:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d76:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	89 04 24             	mov    %eax,(%esp)
  801d80:	e8 09 fb ff ff       	call   80188e <fd_lookup>
  801d85:	85 c0                	test   %eax,%eax
  801d87:	78 52                	js     801ddb <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d93:	8b 00                	mov    (%eax),%eax
  801d95:	89 04 24             	mov    %eax,(%esp)
  801d98:	e8 42 fb ff ff       	call   8018df <dev_lookup>
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	78 3a                	js     801ddb <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801da8:	74 2c                	je     801dd6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801daa:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801dad:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801db4:	00 00 00 
	stat->st_isdir = 0;
  801db7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dbe:	00 00 00 
	stat->st_dev = dev;
  801dc1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801dc7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dcb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dce:	89 14 24             	mov    %edx,(%esp)
  801dd1:	ff 50 14             	call   *0x14(%eax)
  801dd4:	eb 05                	jmp    801ddb <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801dd6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801ddb:	83 c4 24             	add    $0x24,%esp
  801dde:	5b                   	pop    %ebx
  801ddf:	5d                   	pop    %ebp
  801de0:	c3                   	ret    

00801de1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 18             	sub    $0x18,%esp
  801de7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801dea:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ded:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801df4:	00 
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	89 04 24             	mov    %eax,(%esp)
  801dfb:	e8 bc 01 00 00       	call   801fbc <open>
  801e00:	89 c3                	mov    %eax,%ebx
  801e02:	85 c0                	test   %eax,%eax
  801e04:	78 1b                	js     801e21 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0d:	89 1c 24             	mov    %ebx,(%esp)
  801e10:	e8 54 ff ff ff       	call   801d69 <fstat>
  801e15:	89 c6                	mov    %eax,%esi
	close(fd);
  801e17:	89 1c 24             	mov    %ebx,(%esp)
  801e1a:	e8 be fb ff ff       	call   8019dd <close>
	return r;
  801e1f:	89 f3                	mov    %esi,%ebx
}
  801e21:	89 d8                	mov    %ebx,%eax
  801e23:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e26:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e29:	89 ec                	mov    %ebp,%esp
  801e2b:	5d                   	pop    %ebp
  801e2c:	c3                   	ret    
  801e2d:	00 00                	add    %al,(%eax)
	...

00801e30 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 18             	sub    $0x18,%esp
  801e36:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e39:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e3c:	89 c3                	mov    %eax,%ebx
  801e3e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801e40:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801e47:	75 11                	jne    801e5a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e50:	e8 51 f9 ff ff       	call   8017a6 <ipc_find_env>
  801e55:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e5a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e61:	00 
  801e62:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801e69:	00 
  801e6a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e6e:	a1 00 50 80 00       	mov    0x805000,%eax
  801e73:	89 04 24             	mov    %eax,(%esp)
  801e76:	e8 a7 f8 ff ff       	call   801722 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e82:	00 
  801e83:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e8e:	e8 3d f8 ff ff       	call   8016d0 <ipc_recv>
}
  801e93:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e96:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e99:	89 ec                	mov    %ebp,%esp
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    

00801e9d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	53                   	push   %ebx
  801ea1:	83 ec 14             	sub    $0x14,%esp
  801ea4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	8b 40 0c             	mov    0xc(%eax),%eax
  801ead:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801eb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb7:	b8 05 00 00 00       	mov    $0x5,%eax
  801ebc:	e8 6f ff ff ff       	call   801e30 <fsipc>
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	78 2b                	js     801ef0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ec5:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ecc:	00 
  801ecd:	89 1c 24             	mov    %ebx,(%esp)
  801ed0:	e8 26 f0 ff ff       	call   800efb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ed5:	a1 80 60 80 00       	mov    0x806080,%eax
  801eda:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ee0:	a1 84 60 80 00       	mov    0x806084,%eax
  801ee5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef0:	83 c4 14             	add    $0x14,%esp
  801ef3:	5b                   	pop    %ebx
  801ef4:	5d                   	pop    %ebp
  801ef5:	c3                   	ret    

00801ef6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	8b 40 0c             	mov    0xc(%eax),%eax
  801f02:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f07:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0c:	b8 06 00 00 00       	mov    $0x6,%eax
  801f11:	e8 1a ff ff ff       	call   801e30 <fsipc>
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	56                   	push   %esi
  801f1c:	53                   	push   %ebx
  801f1d:	83 ec 10             	sub    $0x10,%esp
  801f20:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	8b 40 0c             	mov    0xc(%eax),%eax
  801f29:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f2e:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f34:	ba 00 00 00 00       	mov    $0x0,%edx
  801f39:	b8 03 00 00 00       	mov    $0x3,%eax
  801f3e:	e8 ed fe ff ff       	call   801e30 <fsipc>
  801f43:	89 c3                	mov    %eax,%ebx
  801f45:	85 c0                	test   %eax,%eax
  801f47:	78 6a                	js     801fb3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801f49:	39 c6                	cmp    %eax,%esi
  801f4b:	73 24                	jae    801f71 <devfile_read+0x59>
  801f4d:	c7 44 24 0c b0 30 80 	movl   $0x8030b0,0xc(%esp)
  801f54:	00 
  801f55:	c7 44 24 08 b7 30 80 	movl   $0x8030b7,0x8(%esp)
  801f5c:	00 
  801f5d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801f64:	00 
  801f65:	c7 04 24 cc 30 80 00 	movl   $0x8030cc,(%esp)
  801f6c:	e8 77 e8 ff ff       	call   8007e8 <_panic>
	assert(r <= PGSIZE);
  801f71:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f76:	7e 24                	jle    801f9c <devfile_read+0x84>
  801f78:	c7 44 24 0c d7 30 80 	movl   $0x8030d7,0xc(%esp)
  801f7f:	00 
  801f80:	c7 44 24 08 b7 30 80 	movl   $0x8030b7,0x8(%esp)
  801f87:	00 
  801f88:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801f8f:	00 
  801f90:	c7 04 24 cc 30 80 00 	movl   $0x8030cc,(%esp)
  801f97:	e8 4c e8 ff ff       	call   8007e8 <_panic>
	memmove(buf, &fsipcbuf, r);
  801f9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fa0:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fa7:	00 
  801fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fab:	89 04 24             	mov    %eax,(%esp)
  801fae:	e8 39 f1 ff ff       	call   8010ec <memmove>
	return r;
}
  801fb3:	89 d8                	mov    %ebx,%eax
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	5b                   	pop    %ebx
  801fb9:	5e                   	pop    %esi
  801fba:	5d                   	pop    %ebp
  801fbb:	c3                   	ret    

00801fbc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	56                   	push   %esi
  801fc0:	53                   	push   %ebx
  801fc1:	83 ec 20             	sub    $0x20,%esp
  801fc4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801fc7:	89 34 24             	mov    %esi,(%esp)
  801fca:	e8 e1 ee ff ff       	call   800eb0 <strlen>
		return -E_BAD_PATH;
  801fcf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801fd4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fd9:	7f 5e                	jg     802039 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801fdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fde:	89 04 24             	mov    %eax,(%esp)
  801fe1:	e8 35 f8 ff ff       	call   80181b <fd_alloc>
  801fe6:	89 c3                	mov    %eax,%ebx
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	78 4d                	js     802039 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801fec:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ff0:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801ff7:	e8 ff ee ff ff       	call   800efb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fff:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802004:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802007:	b8 01 00 00 00       	mov    $0x1,%eax
  80200c:	e8 1f fe ff ff       	call   801e30 <fsipc>
  802011:	89 c3                	mov    %eax,%ebx
  802013:	85 c0                	test   %eax,%eax
  802015:	79 15                	jns    80202c <open+0x70>
		fd_close(fd, 0);
  802017:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80201e:	00 
  80201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802022:	89 04 24             	mov    %eax,(%esp)
  802025:	e8 21 f9 ff ff       	call   80194b <fd_close>
		return r;
  80202a:	eb 0d                	jmp    802039 <open+0x7d>
	}

	return fd2num(fd);
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	89 04 24             	mov    %eax,(%esp)
  802032:	e8 b9 f7 ff ff       	call   8017f0 <fd2num>
  802037:	89 c3                	mov    %eax,%ebx
}
  802039:	89 d8                	mov    %ebx,%eax
  80203b:	83 c4 20             	add    $0x20,%esp
  80203e:	5b                   	pop    %ebx
  80203f:	5e                   	pop    %esi
  802040:	5d                   	pop    %ebp
  802041:	c3                   	ret    
	...

00802050 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 18             	sub    $0x18,%esp
  802056:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802059:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80205c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	89 04 24             	mov    %eax,(%esp)
  802065:	e8 96 f7 ff ff       	call   801800 <fd2data>
  80206a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80206c:	c7 44 24 04 e3 30 80 	movl   $0x8030e3,0x4(%esp)
  802073:	00 
  802074:	89 34 24             	mov    %esi,(%esp)
  802077:	e8 7f ee ff ff       	call   800efb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80207c:	8b 43 04             	mov    0x4(%ebx),%eax
  80207f:	2b 03                	sub    (%ebx),%eax
  802081:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802087:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80208e:	00 00 00 
	stat->st_dev = &devpipe;
  802091:	c7 86 88 00 00 00 24 	movl   $0x804024,0x88(%esi)
  802098:	40 80 00 
	return 0;
}
  80209b:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8020a3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8020a6:	89 ec                	mov    %ebp,%esp
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    

008020aa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	53                   	push   %ebx
  8020ae:	83 ec 14             	sub    $0x14,%esp
  8020b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020bf:	e8 f5 f3 ff ff       	call   8014b9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020c4:	89 1c 24             	mov    %ebx,(%esp)
  8020c7:	e8 34 f7 ff ff       	call   801800 <fd2data>
  8020cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d7:	e8 dd f3 ff ff       	call   8014b9 <sys_page_unmap>
}
  8020dc:	83 c4 14             	add    $0x14,%esp
  8020df:	5b                   	pop    %ebx
  8020e0:	5d                   	pop    %ebp
  8020e1:	c3                   	ret    

008020e2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	57                   	push   %edi
  8020e6:	56                   	push   %esi
  8020e7:	53                   	push   %ebx
  8020e8:	83 ec 2c             	sub    $0x2c,%esp
  8020eb:	89 c7                	mov    %eax,%edi
  8020ed:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8020f0:	a1 04 50 80 00       	mov    0x805004,%eax
  8020f5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020f8:	89 3c 24             	mov    %edi,(%esp)
  8020fb:	e8 e0 04 00 00       	call   8025e0 <pageref>
  802100:	89 c6                	mov    %eax,%esi
  802102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802105:	89 04 24             	mov    %eax,(%esp)
  802108:	e8 d3 04 00 00       	call   8025e0 <pageref>
  80210d:	39 c6                	cmp    %eax,%esi
  80210f:	0f 94 c0             	sete   %al
  802112:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802115:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80211b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80211e:	39 cb                	cmp    %ecx,%ebx
  802120:	75 08                	jne    80212a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  802122:	83 c4 2c             	add    $0x2c,%esp
  802125:	5b                   	pop    %ebx
  802126:	5e                   	pop    %esi
  802127:	5f                   	pop    %edi
  802128:	5d                   	pop    %ebp
  802129:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80212a:	83 f8 01             	cmp    $0x1,%eax
  80212d:	75 c1                	jne    8020f0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80212f:	8b 52 58             	mov    0x58(%edx),%edx
  802132:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802136:	89 54 24 08          	mov    %edx,0x8(%esp)
  80213a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80213e:	c7 04 24 ea 30 80 00 	movl   $0x8030ea,(%esp)
  802145:	e8 99 e7 ff ff       	call   8008e3 <cprintf>
  80214a:	eb a4                	jmp    8020f0 <_pipeisclosed+0xe>

0080214c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	57                   	push   %edi
  802150:	56                   	push   %esi
  802151:	53                   	push   %ebx
  802152:	83 ec 2c             	sub    $0x2c,%esp
  802155:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802158:	89 34 24             	mov    %esi,(%esp)
  80215b:	e8 a0 f6 ff ff       	call   801800 <fd2data>
  802160:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802162:	bf 00 00 00 00       	mov    $0x0,%edi
  802167:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80216b:	75 50                	jne    8021bd <devpipe_write+0x71>
  80216d:	eb 5c                	jmp    8021cb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80216f:	89 da                	mov    %ebx,%edx
  802171:	89 f0                	mov    %esi,%eax
  802173:	e8 6a ff ff ff       	call   8020e2 <_pipeisclosed>
  802178:	85 c0                	test   %eax,%eax
  80217a:	75 53                	jne    8021cf <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80217c:	e8 4b f2 ff ff       	call   8013cc <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802181:	8b 43 04             	mov    0x4(%ebx),%eax
  802184:	8b 13                	mov    (%ebx),%edx
  802186:	83 c2 20             	add    $0x20,%edx
  802189:	39 d0                	cmp    %edx,%eax
  80218b:	73 e2                	jae    80216f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80218d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802190:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  802194:	88 55 e7             	mov    %dl,-0x19(%ebp)
  802197:	89 c2                	mov    %eax,%edx
  802199:	c1 fa 1f             	sar    $0x1f,%edx
  80219c:	c1 ea 1b             	shr    $0x1b,%edx
  80219f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8021a2:	83 e1 1f             	and    $0x1f,%ecx
  8021a5:	29 d1                	sub    %edx,%ecx
  8021a7:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8021ab:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8021af:	83 c0 01             	add    $0x1,%eax
  8021b2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021b5:	83 c7 01             	add    $0x1,%edi
  8021b8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021bb:	74 0e                	je     8021cb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021bd:	8b 43 04             	mov    0x4(%ebx),%eax
  8021c0:	8b 13                	mov    (%ebx),%edx
  8021c2:	83 c2 20             	add    $0x20,%edx
  8021c5:	39 d0                	cmp    %edx,%eax
  8021c7:	73 a6                	jae    80216f <devpipe_write+0x23>
  8021c9:	eb c2                	jmp    80218d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8021cb:	89 f8                	mov    %edi,%eax
  8021cd:	eb 05                	jmp    8021d4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8021d4:	83 c4 2c             	add    $0x2c,%esp
  8021d7:	5b                   	pop    %ebx
  8021d8:	5e                   	pop    %esi
  8021d9:	5f                   	pop    %edi
  8021da:	5d                   	pop    %ebp
  8021db:	c3                   	ret    

008021dc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	83 ec 28             	sub    $0x28,%esp
  8021e2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8021e5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8021e8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8021eb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8021ee:	89 3c 24             	mov    %edi,(%esp)
  8021f1:	e8 0a f6 ff ff       	call   801800 <fd2data>
  8021f6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021f8:	be 00 00 00 00       	mov    $0x0,%esi
  8021fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802201:	75 47                	jne    80224a <devpipe_read+0x6e>
  802203:	eb 52                	jmp    802257 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802205:	89 f0                	mov    %esi,%eax
  802207:	eb 5e                	jmp    802267 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802209:	89 da                	mov    %ebx,%edx
  80220b:	89 f8                	mov    %edi,%eax
  80220d:	8d 76 00             	lea    0x0(%esi),%esi
  802210:	e8 cd fe ff ff       	call   8020e2 <_pipeisclosed>
  802215:	85 c0                	test   %eax,%eax
  802217:	75 49                	jne    802262 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802219:	e8 ae f1 ff ff       	call   8013cc <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80221e:	8b 03                	mov    (%ebx),%eax
  802220:	3b 43 04             	cmp    0x4(%ebx),%eax
  802223:	74 e4                	je     802209 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802225:	89 c2                	mov    %eax,%edx
  802227:	c1 fa 1f             	sar    $0x1f,%edx
  80222a:	c1 ea 1b             	shr    $0x1b,%edx
  80222d:	01 d0                	add    %edx,%eax
  80222f:	83 e0 1f             	and    $0x1f,%eax
  802232:	29 d0                	sub    %edx,%eax
  802234:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802239:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80223f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802242:	83 c6 01             	add    $0x1,%esi
  802245:	3b 75 10             	cmp    0x10(%ebp),%esi
  802248:	74 0d                	je     802257 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80224a:	8b 03                	mov    (%ebx),%eax
  80224c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80224f:	75 d4                	jne    802225 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802251:	85 f6                	test   %esi,%esi
  802253:	75 b0                	jne    802205 <devpipe_read+0x29>
  802255:	eb b2                	jmp    802209 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802257:	89 f0                	mov    %esi,%eax
  802259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802260:	eb 05                	jmp    802267 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802262:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802267:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80226a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80226d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802270:	89 ec                	mov    %ebp,%esp
  802272:	5d                   	pop    %ebp
  802273:	c3                   	ret    

00802274 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 48             	sub    $0x48,%esp
  80227a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80227d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802280:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802283:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802286:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802289:	89 04 24             	mov    %eax,(%esp)
  80228c:	e8 8a f5 ff ff       	call   80181b <fd_alloc>
  802291:	89 c3                	mov    %eax,%ebx
  802293:	85 c0                	test   %eax,%eax
  802295:	0f 88 45 01 00 00    	js     8023e0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80229b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022a2:	00 
  8022a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b1:	e8 46 f1 ff ff       	call   8013fc <sys_page_alloc>
  8022b6:	89 c3                	mov    %eax,%ebx
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	0f 88 20 01 00 00    	js     8023e0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8022c0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8022c3:	89 04 24             	mov    %eax,(%esp)
  8022c6:	e8 50 f5 ff ff       	call   80181b <fd_alloc>
  8022cb:	89 c3                	mov    %eax,%ebx
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	0f 88 f8 00 00 00    	js     8023cd <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022d5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022dc:	00 
  8022dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022eb:	e8 0c f1 ff ff       	call   8013fc <sys_page_alloc>
  8022f0:	89 c3                	mov    %eax,%ebx
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	0f 88 d3 00 00 00    	js     8023cd <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8022fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022fd:	89 04 24             	mov    %eax,(%esp)
  802300:	e8 fb f4 ff ff       	call   801800 <fd2data>
  802305:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802307:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80230e:	00 
  80230f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802313:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80231a:	e8 dd f0 ff ff       	call   8013fc <sys_page_alloc>
  80231f:	89 c3                	mov    %eax,%ebx
  802321:	85 c0                	test   %eax,%eax
  802323:	0f 88 91 00 00 00    	js     8023ba <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802329:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80232c:	89 04 24             	mov    %eax,(%esp)
  80232f:	e8 cc f4 ff ff       	call   801800 <fd2data>
  802334:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80233b:	00 
  80233c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802340:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802347:	00 
  802348:	89 74 24 04          	mov    %esi,0x4(%esp)
  80234c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802353:	e8 03 f1 ff ff       	call   80145b <sys_page_map>
  802358:	89 c3                	mov    %eax,%ebx
  80235a:	85 c0                	test   %eax,%eax
  80235c:	78 4c                	js     8023aa <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80235e:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802367:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80236c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802373:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80237c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80237e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802381:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80238b:	89 04 24             	mov    %eax,(%esp)
  80238e:	e8 5d f4 ff ff       	call   8017f0 <fd2num>
  802393:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802395:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802398:	89 04 24             	mov    %eax,(%esp)
  80239b:	e8 50 f4 ff ff       	call   8017f0 <fd2num>
  8023a0:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8023a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023a8:	eb 36                	jmp    8023e0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  8023aa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b5:	e8 ff f0 ff ff       	call   8014b9 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8023ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023c8:	e8 ec f0 ff ff       	call   8014b9 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8023cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023db:	e8 d9 f0 ff ff       	call   8014b9 <sys_page_unmap>
    err:
	return r;
}
  8023e0:	89 d8                	mov    %ebx,%eax
  8023e2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8023e5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8023e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8023eb:	89 ec                	mov    %ebp,%esp
  8023ed:	5d                   	pop    %ebp
  8023ee:	c3                   	ret    

008023ef <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	89 04 24             	mov    %eax,(%esp)
  802402:	e8 87 f4 ff ff       	call   80188e <fd_lookup>
  802407:	85 c0                	test   %eax,%eax
  802409:	78 15                	js     802420 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	89 04 24             	mov    %eax,(%esp)
  802411:	e8 ea f3 ff ff       	call   801800 <fd2data>
	return _pipeisclosed(fd, p);
  802416:	89 c2                	mov    %eax,%edx
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	e8 c2 fc ff ff       	call   8020e2 <_pipeisclosed>
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    
	...

00802430 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
  802438:	5d                   	pop    %ebp
  802439:	c3                   	ret    

0080243a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802440:	c7 44 24 04 02 31 80 	movl   $0x803102,0x4(%esp)
  802447:	00 
  802448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244b:	89 04 24             	mov    %eax,(%esp)
  80244e:	e8 a8 ea ff ff       	call   800efb <strcpy>
	return 0;
}
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	57                   	push   %edi
  80245e:	56                   	push   %esi
  80245f:	53                   	push   %ebx
  802460:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802466:	be 00 00 00 00       	mov    $0x0,%esi
  80246b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80246f:	74 43                	je     8024b4 <devcons_write+0x5a>
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802476:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80247c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80247f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802481:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802484:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802489:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80248c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802490:	03 45 0c             	add    0xc(%ebp),%eax
  802493:	89 44 24 04          	mov    %eax,0x4(%esp)
  802497:	89 3c 24             	mov    %edi,(%esp)
  80249a:	e8 4d ec ff ff       	call   8010ec <memmove>
		sys_cputs(buf, m);
  80249f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024a3:	89 3c 24             	mov    %edi,(%esp)
  8024a6:	e8 35 ee ff ff       	call   8012e0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024ab:	01 de                	add    %ebx,%esi
  8024ad:	89 f0                	mov    %esi,%eax
  8024af:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024b2:	72 c8                	jb     80247c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8024b4:	89 f0                	mov    %esi,%eax
  8024b6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8024bc:	5b                   	pop    %ebx
  8024bd:	5e                   	pop    %esi
  8024be:	5f                   	pop    %edi
  8024bf:	5d                   	pop    %ebp
  8024c0:	c3                   	ret    

008024c1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8024c7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8024cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024d0:	75 07                	jne    8024d9 <devcons_read+0x18>
  8024d2:	eb 31                	jmp    802505 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8024d4:	e8 f3 ee ff ff       	call   8013cc <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e0:	e8 2a ee ff ff       	call   80130f <sys_cgetc>
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	74 eb                	je     8024d4 <devcons_read+0x13>
  8024e9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	78 16                	js     802505 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8024ef:	83 f8 04             	cmp    $0x4,%eax
  8024f2:	74 0c                	je     802500 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  8024f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f7:	88 10                	mov    %dl,(%eax)
	return 1;
  8024f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024fe:	eb 05                	jmp    802505 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802500:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802513:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80251a:	00 
  80251b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80251e:	89 04 24             	mov    %eax,(%esp)
  802521:	e8 ba ed ff ff       	call   8012e0 <sys_cputs>
}
  802526:	c9                   	leave  
  802527:	c3                   	ret    

00802528 <getchar>:

int
getchar(void)
{
  802528:	55                   	push   %ebp
  802529:	89 e5                	mov    %esp,%ebp
  80252b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80252e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802535:	00 
  802536:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802539:	89 44 24 04          	mov    %eax,0x4(%esp)
  80253d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802544:	e8 05 f6 ff ff       	call   801b4e <read>
	if (r < 0)
  802549:	85 c0                	test   %eax,%eax
  80254b:	78 0f                	js     80255c <getchar+0x34>
		return r;
	if (r < 1)
  80254d:	85 c0                	test   %eax,%eax
  80254f:	7e 06                	jle    802557 <getchar+0x2f>
		return -E_EOF;
	return c;
  802551:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802555:	eb 05                	jmp    80255c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802557:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    

0080255e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802564:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802567:	89 44 24 04          	mov    %eax,0x4(%esp)
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	89 04 24             	mov    %eax,(%esp)
  802571:	e8 18 f3 ff ff       	call   80188e <fd_lookup>
  802576:	85 c0                	test   %eax,%eax
  802578:	78 11                	js     80258b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802583:	39 10                	cmp    %edx,(%eax)
  802585:	0f 94 c0             	sete   %al
  802588:	0f b6 c0             	movzbl %al,%eax
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <opencons>:

int
opencons(void)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
  802590:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802593:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802596:	89 04 24             	mov    %eax,(%esp)
  802599:	e8 7d f2 ff ff       	call   80181b <fd_alloc>
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	78 3c                	js     8025de <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025a2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025a9:	00 
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025b8:	e8 3f ee ff ff       	call   8013fc <sys_page_alloc>
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	78 1d                	js     8025de <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8025c1:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025d6:	89 04 24             	mov    %eax,(%esp)
  8025d9:	e8 12 f2 ff ff       	call   8017f0 <fd2num>
}
  8025de:	c9                   	leave  
  8025df:	c3                   	ret    

008025e0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025e6:	89 d0                	mov    %edx,%eax
  8025e8:	c1 e8 16             	shr    $0x16,%eax
  8025eb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025f2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025f7:	f6 c1 01             	test   $0x1,%cl
  8025fa:	74 1d                	je     802619 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8025fc:	c1 ea 0c             	shr    $0xc,%edx
  8025ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802606:	f6 c2 01             	test   $0x1,%dl
  802609:	74 0e                	je     802619 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80260b:	c1 ea 0c             	shr    $0xc,%edx
  80260e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802615:	ef 
  802616:	0f b7 c0             	movzwl %ax,%eax
}
  802619:	5d                   	pop    %ebp
  80261a:	c3                   	ret    
  80261b:	00 00                	add    %al,(%eax)
  80261d:	00 00                	add    %al,(%eax)
	...

00802620 <__udivdi3>:
  802620:	83 ec 1c             	sub    $0x1c,%esp
  802623:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802627:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80262b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80262f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802633:	89 74 24 10          	mov    %esi,0x10(%esp)
  802637:	8b 74 24 24          	mov    0x24(%esp),%esi
  80263b:	85 ff                	test   %edi,%edi
  80263d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802641:	89 44 24 08          	mov    %eax,0x8(%esp)
  802645:	89 cd                	mov    %ecx,%ebp
  802647:	89 44 24 04          	mov    %eax,0x4(%esp)
  80264b:	75 33                	jne    802680 <__udivdi3+0x60>
  80264d:	39 f1                	cmp    %esi,%ecx
  80264f:	77 57                	ja     8026a8 <__udivdi3+0x88>
  802651:	85 c9                	test   %ecx,%ecx
  802653:	75 0b                	jne    802660 <__udivdi3+0x40>
  802655:	b8 01 00 00 00       	mov    $0x1,%eax
  80265a:	31 d2                	xor    %edx,%edx
  80265c:	f7 f1                	div    %ecx
  80265e:	89 c1                	mov    %eax,%ecx
  802660:	89 f0                	mov    %esi,%eax
  802662:	31 d2                	xor    %edx,%edx
  802664:	f7 f1                	div    %ecx
  802666:	89 c6                	mov    %eax,%esi
  802668:	8b 44 24 04          	mov    0x4(%esp),%eax
  80266c:	f7 f1                	div    %ecx
  80266e:	89 f2                	mov    %esi,%edx
  802670:	8b 74 24 10          	mov    0x10(%esp),%esi
  802674:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802678:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80267c:	83 c4 1c             	add    $0x1c,%esp
  80267f:	c3                   	ret    
  802680:	31 d2                	xor    %edx,%edx
  802682:	31 c0                	xor    %eax,%eax
  802684:	39 f7                	cmp    %esi,%edi
  802686:	77 e8                	ja     802670 <__udivdi3+0x50>
  802688:	0f bd cf             	bsr    %edi,%ecx
  80268b:	83 f1 1f             	xor    $0x1f,%ecx
  80268e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802692:	75 2c                	jne    8026c0 <__udivdi3+0xa0>
  802694:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802698:	76 04                	jbe    80269e <__udivdi3+0x7e>
  80269a:	39 f7                	cmp    %esi,%edi
  80269c:	73 d2                	jae    802670 <__udivdi3+0x50>
  80269e:	31 d2                	xor    %edx,%edx
  8026a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a5:	eb c9                	jmp    802670 <__udivdi3+0x50>
  8026a7:	90                   	nop
  8026a8:	89 f2                	mov    %esi,%edx
  8026aa:	f7 f1                	div    %ecx
  8026ac:	31 d2                	xor    %edx,%edx
  8026ae:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026b2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026b6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026ba:	83 c4 1c             	add    $0x1c,%esp
  8026bd:	c3                   	ret    
  8026be:	66 90                	xchg   %ax,%ax
  8026c0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026c5:	b8 20 00 00 00       	mov    $0x20,%eax
  8026ca:	89 ea                	mov    %ebp,%edx
  8026cc:	2b 44 24 04          	sub    0x4(%esp),%eax
  8026d0:	d3 e7                	shl    %cl,%edi
  8026d2:	89 c1                	mov    %eax,%ecx
  8026d4:	d3 ea                	shr    %cl,%edx
  8026d6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026db:	09 fa                	or     %edi,%edx
  8026dd:	89 f7                	mov    %esi,%edi
  8026df:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026e3:	89 f2                	mov    %esi,%edx
  8026e5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8026e9:	d3 e5                	shl    %cl,%ebp
  8026eb:	89 c1                	mov    %eax,%ecx
  8026ed:	d3 ef                	shr    %cl,%edi
  8026ef:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026f4:	d3 e2                	shl    %cl,%edx
  8026f6:	89 c1                	mov    %eax,%ecx
  8026f8:	d3 ee                	shr    %cl,%esi
  8026fa:	09 d6                	or     %edx,%esi
  8026fc:	89 fa                	mov    %edi,%edx
  8026fe:	89 f0                	mov    %esi,%eax
  802700:	f7 74 24 0c          	divl   0xc(%esp)
  802704:	89 d7                	mov    %edx,%edi
  802706:	89 c6                	mov    %eax,%esi
  802708:	f7 e5                	mul    %ebp
  80270a:	39 d7                	cmp    %edx,%edi
  80270c:	72 22                	jb     802730 <__udivdi3+0x110>
  80270e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802712:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802717:	d3 e5                	shl    %cl,%ebp
  802719:	39 c5                	cmp    %eax,%ebp
  80271b:	73 04                	jae    802721 <__udivdi3+0x101>
  80271d:	39 d7                	cmp    %edx,%edi
  80271f:	74 0f                	je     802730 <__udivdi3+0x110>
  802721:	89 f0                	mov    %esi,%eax
  802723:	31 d2                	xor    %edx,%edx
  802725:	e9 46 ff ff ff       	jmp    802670 <__udivdi3+0x50>
  80272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802730:	8d 46 ff             	lea    -0x1(%esi),%eax
  802733:	31 d2                	xor    %edx,%edx
  802735:	8b 74 24 10          	mov    0x10(%esp),%esi
  802739:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80273d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802741:	83 c4 1c             	add    $0x1c,%esp
  802744:	c3                   	ret    
	...

00802750 <__umoddi3>:
  802750:	83 ec 1c             	sub    $0x1c,%esp
  802753:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802757:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80275b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80275f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802763:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802767:	8b 74 24 24          	mov    0x24(%esp),%esi
  80276b:	85 ed                	test   %ebp,%ebp
  80276d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802771:	89 44 24 08          	mov    %eax,0x8(%esp)
  802775:	89 cf                	mov    %ecx,%edi
  802777:	89 04 24             	mov    %eax,(%esp)
  80277a:	89 f2                	mov    %esi,%edx
  80277c:	75 1a                	jne    802798 <__umoddi3+0x48>
  80277e:	39 f1                	cmp    %esi,%ecx
  802780:	76 4e                	jbe    8027d0 <__umoddi3+0x80>
  802782:	f7 f1                	div    %ecx
  802784:	89 d0                	mov    %edx,%eax
  802786:	31 d2                	xor    %edx,%edx
  802788:	8b 74 24 10          	mov    0x10(%esp),%esi
  80278c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802790:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802794:	83 c4 1c             	add    $0x1c,%esp
  802797:	c3                   	ret    
  802798:	39 f5                	cmp    %esi,%ebp
  80279a:	77 54                	ja     8027f0 <__umoddi3+0xa0>
  80279c:	0f bd c5             	bsr    %ebp,%eax
  80279f:	83 f0 1f             	xor    $0x1f,%eax
  8027a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a6:	75 60                	jne    802808 <__umoddi3+0xb8>
  8027a8:	3b 0c 24             	cmp    (%esp),%ecx
  8027ab:	0f 87 07 01 00 00    	ja     8028b8 <__umoddi3+0x168>
  8027b1:	89 f2                	mov    %esi,%edx
  8027b3:	8b 34 24             	mov    (%esp),%esi
  8027b6:	29 ce                	sub    %ecx,%esi
  8027b8:	19 ea                	sbb    %ebp,%edx
  8027ba:	89 34 24             	mov    %esi,(%esp)
  8027bd:	8b 04 24             	mov    (%esp),%eax
  8027c0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8027c4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8027c8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8027cc:	83 c4 1c             	add    $0x1c,%esp
  8027cf:	c3                   	ret    
  8027d0:	85 c9                	test   %ecx,%ecx
  8027d2:	75 0b                	jne    8027df <__umoddi3+0x8f>
  8027d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d9:	31 d2                	xor    %edx,%edx
  8027db:	f7 f1                	div    %ecx
  8027dd:	89 c1                	mov    %eax,%ecx
  8027df:	89 f0                	mov    %esi,%eax
  8027e1:	31 d2                	xor    %edx,%edx
  8027e3:	f7 f1                	div    %ecx
  8027e5:	8b 04 24             	mov    (%esp),%eax
  8027e8:	f7 f1                	div    %ecx
  8027ea:	eb 98                	jmp    802784 <__umoddi3+0x34>
  8027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027f0:	89 f2                	mov    %esi,%edx
  8027f2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8027f6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8027fa:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8027fe:	83 c4 1c             	add    $0x1c,%esp
  802801:	c3                   	ret    
  802802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802808:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80280d:	89 e8                	mov    %ebp,%eax
  80280f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802814:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802818:	89 fa                	mov    %edi,%edx
  80281a:	d3 e0                	shl    %cl,%eax
  80281c:	89 e9                	mov    %ebp,%ecx
  80281e:	d3 ea                	shr    %cl,%edx
  802820:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802825:	09 c2                	or     %eax,%edx
  802827:	8b 44 24 08          	mov    0x8(%esp),%eax
  80282b:	89 14 24             	mov    %edx,(%esp)
  80282e:	89 f2                	mov    %esi,%edx
  802830:	d3 e7                	shl    %cl,%edi
  802832:	89 e9                	mov    %ebp,%ecx
  802834:	d3 ea                	shr    %cl,%edx
  802836:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80283b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80283f:	d3 e6                	shl    %cl,%esi
  802841:	89 e9                	mov    %ebp,%ecx
  802843:	d3 e8                	shr    %cl,%eax
  802845:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80284a:	09 f0                	or     %esi,%eax
  80284c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802850:	f7 34 24             	divl   (%esp)
  802853:	d3 e6                	shl    %cl,%esi
  802855:	89 74 24 08          	mov    %esi,0x8(%esp)
  802859:	89 d6                	mov    %edx,%esi
  80285b:	f7 e7                	mul    %edi
  80285d:	39 d6                	cmp    %edx,%esi
  80285f:	89 c1                	mov    %eax,%ecx
  802861:	89 d7                	mov    %edx,%edi
  802863:	72 3f                	jb     8028a4 <__umoddi3+0x154>
  802865:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802869:	72 35                	jb     8028a0 <__umoddi3+0x150>
  80286b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80286f:	29 c8                	sub    %ecx,%eax
  802871:	19 fe                	sbb    %edi,%esi
  802873:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802878:	89 f2                	mov    %esi,%edx
  80287a:	d3 e8                	shr    %cl,%eax
  80287c:	89 e9                	mov    %ebp,%ecx
  80287e:	d3 e2                	shl    %cl,%edx
  802880:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802885:	09 d0                	or     %edx,%eax
  802887:	89 f2                	mov    %esi,%edx
  802889:	d3 ea                	shr    %cl,%edx
  80288b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80288f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802893:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802897:	83 c4 1c             	add    $0x1c,%esp
  80289a:	c3                   	ret    
  80289b:	90                   	nop
  80289c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028a0:	39 d6                	cmp    %edx,%esi
  8028a2:	75 c7                	jne    80286b <__umoddi3+0x11b>
  8028a4:	89 d7                	mov    %edx,%edi
  8028a6:	89 c1                	mov    %eax,%ecx
  8028a8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8028ac:	1b 3c 24             	sbb    (%esp),%edi
  8028af:	eb ba                	jmp    80286b <__umoddi3+0x11b>
  8028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028b8:	39 f5                	cmp    %esi,%ebp
  8028ba:	0f 82 f1 fe ff ff    	jb     8027b1 <__umoddi3+0x61>
  8028c0:	e9 f8 fe ff ff       	jmp    8027bd <__umoddi3+0x6d>
