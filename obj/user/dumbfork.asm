
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 1f 02 00 00       	call   800250 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 20             	sub    $0x20,%esp
  80003c:	8b 75 08             	mov    0x8(%ebp),%esi
  80003f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  800042:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800049:	00 
  80004a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80004e:	89 34 24             	mov    %esi,(%esp)
  800051:	e8 86 0e 00 00       	call   800edc <sys_page_alloc>
  800056:	85 c0                	test   %eax,%eax
  800058:	79 20                	jns    80007a <duppage+0x46>
		panic("sys_page_alloc: %e", r);
  80005a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005e:	c7 44 24 08 c0 23 80 	movl   $0x8023c0,0x8(%esp)
  800065:	00 
  800066:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  80006d:	00 
  80006e:	c7 04 24 d3 23 80 00 	movl   $0x8023d3,(%esp)
  800075:	e8 42 02 00 00       	call   8002bc <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80007a:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  800081:	00 
  800082:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  800089:	00 
  80008a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800091:	00 
  800092:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800096:	89 34 24             	mov    %esi,(%esp)
  800099:	e8 9d 0e 00 00       	call   800f3b <sys_page_map>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	79 20                	jns    8000c2 <duppage+0x8e>
		panic("sys_page_map: %e", r);
  8000a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a6:	c7 44 24 08 e3 23 80 	movl   $0x8023e3,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 d3 23 80 00 	movl   $0x8023d3,(%esp)
  8000bd:	e8 fa 01 00 00       	call   8002bc <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8000c2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8000c9:	00 
  8000ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000ce:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8000d5:	e8 f2 0a 00 00       	call   800bcc <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8000da:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8000e1:	00 
  8000e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000e9:	e8 ab 0e 00 00       	call   800f99 <sys_page_unmap>
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	79 20                	jns    800112 <duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8000f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f6:	c7 44 24 08 f4 23 80 	movl   $0x8023f4,0x8(%esp)
  8000fd:	00 
  8000fe:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800105:	00 
  800106:	c7 04 24 d3 23 80 00 	movl   $0x8023d3,(%esp)
  80010d:	e8 aa 01 00 00       	call   8002bc <_panic>
}
  800112:	83 c4 20             	add    $0x20,%esp
  800115:	5b                   	pop    %ebx
  800116:	5e                   	pop    %esi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    

00800119 <dumbfork>:

envid_t
dumbfork(void)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	83 ec 20             	sub    $0x20,%esp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  800121:	be 07 00 00 00       	mov    $0x7,%esi
  800126:	89 f0                	mov    %esi,%eax
  800128:	cd 30                	int    $0x30
  80012a:	89 c6                	mov    %eax,%esi
  80012c:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  80012e:	85 c0                	test   %eax,%eax
  800130:	79 20                	jns    800152 <dumbfork+0x39>
		panic("sys_exofork: %e", envid);
  800132:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800136:	c7 44 24 08 07 24 80 	movl   $0x802407,0x8(%esp)
  80013d:	00 
  80013e:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  800145:	00 
  800146:	c7 04 24 d3 23 80 00 	movl   $0x8023d3,(%esp)
  80014d:	e8 6a 01 00 00       	call   8002bc <_panic>
	if (envid == 0) {
  800152:	85 c0                	test   %eax,%eax
  800154:	75 19                	jne    80016f <dumbfork+0x56>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  800156:	e8 21 0d 00 00       	call   800e7c <sys_getenvid>
  80015b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800160:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80016d:	eb 7e                	jmp    8001ed <dumbfork+0xd4>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80016f:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  800176:	b8 00 60 80 00       	mov    $0x806000,%eax
  80017b:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800180:	76 23                	jbe    8001a5 <dumbfork+0x8c>
  800182:	b8 00 00 80 00       	mov    $0x800000,%eax
		duppage(envid, addr);
  800187:	89 44 24 04          	mov    %eax,0x4(%esp)
  80018b:	89 1c 24             	mov    %ebx,(%esp)
  80018e:	e8 a1 fe ff ff       	call   800034 <duppage>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800196:	05 00 10 00 00       	add    $0x1000,%eax
  80019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80019e:	3d 00 60 80 00       	cmp    $0x806000,%eax
  8001a3:	72 e2                	jb     800187 <dumbfork+0x6e>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8001a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b1:	89 34 24             	mov    %esi,(%esp)
  8001b4:	e8 7b fe ff ff       	call   800034 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8001b9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8001c0:	00 
  8001c1:	89 34 24             	mov    %esi,(%esp)
  8001c4:	e8 2e 0e 00 00       	call   800ff7 <sys_env_set_status>
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	79 20                	jns    8001ed <dumbfork+0xd4>
		panic("sys_env_set_status: %e", r);
  8001cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d1:	c7 44 24 08 17 24 80 	movl   $0x802417,0x8(%esp)
  8001d8:	00 
  8001d9:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  8001e0:	00 
  8001e1:	c7 04 24 d3 23 80 00 	movl   $0x8023d3,(%esp)
  8001e8:	e8 cf 00 00 00       	call   8002bc <_panic>

	return envid;
}
  8001ed:	89 f0                	mov    %esi,%eax
  8001ef:	83 c4 20             	add    $0x20,%esp
  8001f2:	5b                   	pop    %ebx
  8001f3:	5e                   	pop    %esi
  8001f4:	5d                   	pop    %ebp
  8001f5:	c3                   	ret    

008001f6 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	57                   	push   %edi
  8001fa:	56                   	push   %esi
  8001fb:	53                   	push   %ebx
  8001fc:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  8001ff:	e8 15 ff ff ff       	call   800119 <dumbfork>
  800204:	89 c3                	mov    %eax,%ebx

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800206:	be 00 00 00 00       	mov    $0x0,%esi
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80020b:	bf 35 24 80 00       	mov    $0x802435,%edi

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800210:	eb 26                	jmp    800238 <umain+0x42>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  800212:	85 db                	test   %ebx,%ebx
  800214:	b8 2e 24 80 00       	mov    $0x80242e,%eax
  800219:	0f 44 c7             	cmove  %edi,%eax
  80021c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800220:	89 74 24 04          	mov    %esi,0x4(%esp)
  800224:	c7 04 24 3b 24 80 00 	movl   $0x80243b,(%esp)
  80022b:	e8 87 01 00 00       	call   8003b7 <cprintf>
		sys_yield();
  800230:	e8 77 0c 00 00       	call   800eac <sys_yield>

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800235:	83 c6 01             	add    $0x1,%esi
  800238:	83 fb 01             	cmp    $0x1,%ebx
  80023b:	19 c0                	sbb    %eax,%eax
  80023d:	83 e0 0a             	and    $0xa,%eax
  800240:	83 c0 0a             	add    $0xa,%eax
  800243:	39 c6                	cmp    %eax,%esi
  800245:	7c cb                	jl     800212 <umain+0x1c>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  800247:	83 c4 1c             	add    $0x1c,%esp
  80024a:	5b                   	pop    %ebx
  80024b:	5e                   	pop    %esi
  80024c:	5f                   	pop    %edi
  80024d:	5d                   	pop    %ebp
  80024e:	c3                   	ret    
	...

00800250 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 18             	sub    $0x18,%esp
  800256:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800259:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80025c:	8b 75 08             	mov    0x8(%ebp),%esi
  80025f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800262:	e8 15 0c 00 00       	call   800e7c <sys_getenvid>
  800267:	25 ff 03 00 00       	and    $0x3ff,%eax
  80026c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80026f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800274:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800279:	85 f6                	test   %esi,%esi
  80027b:	7e 07                	jle    800284 <libmain+0x34>
		binaryname = argv[0];
  80027d:	8b 03                	mov    (%ebx),%eax
  80027f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800284:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800288:	89 34 24             	mov    %esi,(%esp)
  80028b:	e8 66 ff ff ff       	call   8001f6 <umain>

	// exit gracefully
	exit();
  800290:	e8 0b 00 00 00       	call   8002a0 <exit>
}
  800295:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800298:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80029b:	89 ec                	mov    %ebp,%esp
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    
	...

008002a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8002a6:	e8 23 11 00 00       	call   8013ce <close_all>
	sys_env_destroy(0);
  8002ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002b2:	e8 68 0b 00 00       	call   800e1f <sys_env_destroy>
}
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    
  8002b9:	00 00                	add    %al,(%eax)
	...

008002bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
  8002c1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8002c4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002c7:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8002cd:	e8 aa 0b 00 00       	call   800e7c <sys_getenvid>
  8002d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002dc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002e0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e8:	c7 04 24 58 24 80 00 	movl   $0x802458,(%esp)
  8002ef:	e8 c3 00 00 00       	call   8003b7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002f4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fb:	89 04 24             	mov    %eax,(%esp)
  8002fe:	e8 53 00 00 00       	call   800356 <vcprintf>
	cprintf("\n");
  800303:	c7 04 24 4b 24 80 00 	movl   $0x80244b,(%esp)
  80030a:	e8 a8 00 00 00       	call   8003b7 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80030f:	cc                   	int3   
  800310:	eb fd                	jmp    80030f <_panic+0x53>
	...

00800314 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	53                   	push   %ebx
  800318:	83 ec 14             	sub    $0x14,%esp
  80031b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80031e:	8b 03                	mov    (%ebx),%eax
  800320:	8b 55 08             	mov    0x8(%ebp),%edx
  800323:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800327:	83 c0 01             	add    $0x1,%eax
  80032a:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80032c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800331:	75 19                	jne    80034c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800333:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80033a:	00 
  80033b:	8d 43 08             	lea    0x8(%ebx),%eax
  80033e:	89 04 24             	mov    %eax,(%esp)
  800341:	e8 7a 0a 00 00       	call   800dc0 <sys_cputs>
		b->idx = 0;
  800346:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80034c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800350:	83 c4 14             	add    $0x14,%esp
  800353:	5b                   	pop    %ebx
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    

00800356 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80035f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800366:	00 00 00 
	b.cnt = 0;
  800369:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800370:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800373:	8b 45 0c             	mov    0xc(%ebp),%eax
  800376:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80037a:	8b 45 08             	mov    0x8(%ebp),%eax
  80037d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800381:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800387:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038b:	c7 04 24 14 03 80 00 	movl   $0x800314,(%esp)
  800392:	e8 a3 01 00 00       	call   80053a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800397:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80039d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003a7:	89 04 24             	mov    %eax,(%esp)
  8003aa:	e8 11 0a 00 00       	call   800dc0 <sys_cputs>

	return b.cnt;
}
  8003af:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003bd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c7:	89 04 24             	mov    %eax,(%esp)
  8003ca:	e8 87 ff ff ff       	call   800356 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003cf:	c9                   	leave  
  8003d0:	c3                   	ret    
	...

008003e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	57                   	push   %edi
  8003e4:	56                   	push   %esi
  8003e5:	53                   	push   %ebx
  8003e6:	83 ec 3c             	sub    $0x3c,%esp
  8003e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ec:	89 d7                	mov    %edx,%edi
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003fd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800400:	b8 00 00 00 00       	mov    $0x0,%eax
  800405:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800408:	72 11                	jb     80041b <printnum+0x3b>
  80040a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800410:	76 09                	jbe    80041b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800412:	83 eb 01             	sub    $0x1,%ebx
  800415:	85 db                	test   %ebx,%ebx
  800417:	7f 51                	jg     80046a <printnum+0x8a>
  800419:	eb 5e                	jmp    800479 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80041b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80041f:	83 eb 01             	sub    $0x1,%ebx
  800422:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800426:	8b 45 10             	mov    0x10(%ebp),%eax
  800429:	89 44 24 08          	mov    %eax,0x8(%esp)
  80042d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800431:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800435:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80043c:	00 
  80043d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800440:	89 04 24             	mov    %eax,(%esp)
  800443:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800446:	89 44 24 04          	mov    %eax,0x4(%esp)
  80044a:	e8 b1 1c 00 00       	call   802100 <__udivdi3>
  80044f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800453:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800457:	89 04 24             	mov    %eax,(%esp)
  80045a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80045e:	89 fa                	mov    %edi,%edx
  800460:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800463:	e8 78 ff ff ff       	call   8003e0 <printnum>
  800468:	eb 0f                	jmp    800479 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80046a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046e:	89 34 24             	mov    %esi,(%esp)
  800471:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800474:	83 eb 01             	sub    $0x1,%ebx
  800477:	75 f1                	jne    80046a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800479:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80047d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800481:	8b 45 10             	mov    0x10(%ebp),%eax
  800484:	89 44 24 08          	mov    %eax,0x8(%esp)
  800488:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80048f:	00 
  800490:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800493:	89 04 24             	mov    %eax,(%esp)
  800496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800499:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049d:	e8 8e 1d 00 00       	call   802230 <__umoddi3>
  8004a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004a6:	0f be 80 7b 24 80 00 	movsbl 0x80247b(%eax),%eax
  8004ad:	89 04 24             	mov    %eax,(%esp)
  8004b0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8004b3:	83 c4 3c             	add    $0x3c,%esp
  8004b6:	5b                   	pop    %ebx
  8004b7:	5e                   	pop    %esi
  8004b8:	5f                   	pop    %edi
  8004b9:	5d                   	pop    %ebp
  8004ba:	c3                   	ret    

008004bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004be:	83 fa 01             	cmp    $0x1,%edx
  8004c1:	7e 0e                	jle    8004d1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004c3:	8b 10                	mov    (%eax),%edx
  8004c5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004c8:	89 08                	mov    %ecx,(%eax)
  8004ca:	8b 02                	mov    (%edx),%eax
  8004cc:	8b 52 04             	mov    0x4(%edx),%edx
  8004cf:	eb 22                	jmp    8004f3 <getuint+0x38>
	else if (lflag)
  8004d1:	85 d2                	test   %edx,%edx
  8004d3:	74 10                	je     8004e5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004d5:	8b 10                	mov    (%eax),%edx
  8004d7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004da:	89 08                	mov    %ecx,(%eax)
  8004dc:	8b 02                	mov    (%edx),%eax
  8004de:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e3:	eb 0e                	jmp    8004f3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004e5:	8b 10                	mov    (%eax),%edx
  8004e7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004ea:	89 08                	mov    %ecx,(%eax)
  8004ec:	8b 02                	mov    (%edx),%eax
  8004ee:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    

008004f5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004fb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ff:	8b 10                	mov    (%eax),%edx
  800501:	3b 50 04             	cmp    0x4(%eax),%edx
  800504:	73 0a                	jae    800510 <sprintputch+0x1b>
		*b->buf++ = ch;
  800506:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800509:	88 0a                	mov    %cl,(%edx)
  80050b:	83 c2 01             	add    $0x1,%edx
  80050e:	89 10                	mov    %edx,(%eax)
}
  800510:	5d                   	pop    %ebp
  800511:	c3                   	ret    

00800512 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800512:	55                   	push   %ebp
  800513:	89 e5                	mov    %esp,%ebp
  800515:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800518:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80051b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	89 44 24 08          	mov    %eax,0x8(%esp)
  800526:	8b 45 0c             	mov    0xc(%ebp),%eax
  800529:	89 44 24 04          	mov    %eax,0x4(%esp)
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	89 04 24             	mov    %eax,(%esp)
  800533:	e8 02 00 00 00       	call   80053a <vprintfmt>
	va_end(ap);
}
  800538:	c9                   	leave  
  800539:	c3                   	ret    

0080053a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80053a:	55                   	push   %ebp
  80053b:	89 e5                	mov    %esp,%ebp
  80053d:	57                   	push   %edi
  80053e:	56                   	push   %esi
  80053f:	53                   	push   %ebx
  800540:	83 ec 4c             	sub    $0x4c,%esp
  800543:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800546:	8b 75 10             	mov    0x10(%ebp),%esi
  800549:	eb 12                	jmp    80055d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80054b:	85 c0                	test   %eax,%eax
  80054d:	0f 84 a9 03 00 00    	je     8008fc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800553:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800557:	89 04 24             	mov    %eax,(%esp)
  80055a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055d:	0f b6 06             	movzbl (%esi),%eax
  800560:	83 c6 01             	add    $0x1,%esi
  800563:	83 f8 25             	cmp    $0x25,%eax
  800566:	75 e3                	jne    80054b <vprintfmt+0x11>
  800568:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80056c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800573:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800578:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80057f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800584:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800587:	eb 2b                	jmp    8005b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800589:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80058c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800590:	eb 22                	jmp    8005b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800592:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800595:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800599:	eb 19                	jmp    8005b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80059e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005a5:	eb 0d                	jmp    8005b4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8005a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ad:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b4:	0f b6 06             	movzbl (%esi),%eax
  8005b7:	0f b6 d0             	movzbl %al,%edx
  8005ba:	8d 7e 01             	lea    0x1(%esi),%edi
  8005bd:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005c0:	83 e8 23             	sub    $0x23,%eax
  8005c3:	3c 55                	cmp    $0x55,%al
  8005c5:	0f 87 0b 03 00 00    	ja     8008d6 <vprintfmt+0x39c>
  8005cb:	0f b6 c0             	movzbl %al,%eax
  8005ce:	ff 24 85 c0 25 80 00 	jmp    *0x8025c0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005d5:	83 ea 30             	sub    $0x30,%edx
  8005d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8005db:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8005df:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8005e5:	83 fa 09             	cmp    $0x9,%edx
  8005e8:	77 4a                	ja     800634 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ea:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ed:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8005f0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8005f3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8005f7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005fa:	8d 50 d0             	lea    -0x30(%eax),%edx
  8005fd:	83 fa 09             	cmp    $0x9,%edx
  800600:	76 eb                	jbe    8005ed <vprintfmt+0xb3>
  800602:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800605:	eb 2d                	jmp    800634 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	8d 50 04             	lea    0x4(%eax),%edx
  80060d:	89 55 14             	mov    %edx,0x14(%ebp)
  800610:	8b 00                	mov    (%eax),%eax
  800612:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800615:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800618:	eb 1a                	jmp    800634 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80061d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800621:	79 91                	jns    8005b4 <vprintfmt+0x7a>
  800623:	e9 73 ff ff ff       	jmp    80059b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800628:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80062b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800632:	eb 80                	jmp    8005b4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800634:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800638:	0f 89 76 ff ff ff    	jns    8005b4 <vprintfmt+0x7a>
  80063e:	e9 64 ff ff ff       	jmp    8005a7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800643:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800646:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800649:	e9 66 ff ff ff       	jmp    8005b4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8d 50 04             	lea    0x4(%eax),%edx
  800654:	89 55 14             	mov    %edx,0x14(%ebp)
  800657:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	89 04 24             	mov    %eax,(%esp)
  800660:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800663:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800666:	e9 f2 fe ff ff       	jmp    80055d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 50 04             	lea    0x4(%eax),%edx
  800671:	89 55 14             	mov    %edx,0x14(%ebp)
  800674:	8b 00                	mov    (%eax),%eax
  800676:	89 c2                	mov    %eax,%edx
  800678:	c1 fa 1f             	sar    $0x1f,%edx
  80067b:	31 d0                	xor    %edx,%eax
  80067d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80067f:	83 f8 0f             	cmp    $0xf,%eax
  800682:	7f 0b                	jg     80068f <vprintfmt+0x155>
  800684:	8b 14 85 20 27 80 00 	mov    0x802720(,%eax,4),%edx
  80068b:	85 d2                	test   %edx,%edx
  80068d:	75 23                	jne    8006b2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80068f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800693:	c7 44 24 08 93 24 80 	movl   $0x802493,0x8(%esp)
  80069a:	00 
  80069b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80069f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006a2:	89 3c 24             	mov    %edi,(%esp)
  8006a5:	e8 68 fe ff ff       	call   800512 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006aa:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8006ad:	e9 ab fe ff ff       	jmp    80055d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  8006b2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006b6:	c7 44 24 08 55 28 80 	movl   $0x802855,0x8(%esp)
  8006bd:	00 
  8006be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006c5:	89 3c 24             	mov    %edi,(%esp)
  8006c8:	e8 45 fe ff ff       	call   800512 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006cd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8006d0:	e9 88 fe ff ff       	jmp    80055d <vprintfmt+0x23>
  8006d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8006e9:	85 f6                	test   %esi,%esi
  8006eb:	ba 8c 24 80 00       	mov    $0x80248c,%edx
  8006f0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8006f3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006f7:	7e 06                	jle    8006ff <vprintfmt+0x1c5>
  8006f9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8006fd:	75 10                	jne    80070f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ff:	0f be 06             	movsbl (%esi),%eax
  800702:	83 c6 01             	add    $0x1,%esi
  800705:	85 c0                	test   %eax,%eax
  800707:	0f 85 86 00 00 00    	jne    800793 <vprintfmt+0x259>
  80070d:	eb 76                	jmp    800785 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80070f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800713:	89 34 24             	mov    %esi,(%esp)
  800716:	e8 90 02 00 00       	call   8009ab <strnlen>
  80071b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80071e:	29 c2                	sub    %eax,%edx
  800720:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800723:	85 d2                	test   %edx,%edx
  800725:	7e d8                	jle    8006ff <vprintfmt+0x1c5>
					putch(padc, putdat);
  800727:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80072b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80072e:	89 d6                	mov    %edx,%esi
  800730:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800733:	89 c7                	mov    %eax,%edi
  800735:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800739:	89 3c 24             	mov    %edi,(%esp)
  80073c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80073f:	83 ee 01             	sub    $0x1,%esi
  800742:	75 f1                	jne    800735 <vprintfmt+0x1fb>
  800744:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800747:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80074a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80074d:	eb b0                	jmp    8006ff <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80074f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800753:	74 18                	je     80076d <vprintfmt+0x233>
  800755:	8d 50 e0             	lea    -0x20(%eax),%edx
  800758:	83 fa 5e             	cmp    $0x5e,%edx
  80075b:	76 10                	jbe    80076d <vprintfmt+0x233>
					putch('?', putdat);
  80075d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800761:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800768:	ff 55 08             	call   *0x8(%ebp)
  80076b:	eb 0a                	jmp    800777 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80076d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800771:	89 04 24             	mov    %eax,(%esp)
  800774:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800777:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80077b:	0f be 06             	movsbl (%esi),%eax
  80077e:	83 c6 01             	add    $0x1,%esi
  800781:	85 c0                	test   %eax,%eax
  800783:	75 0e                	jne    800793 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800785:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800788:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80078c:	7f 16                	jg     8007a4 <vprintfmt+0x26a>
  80078e:	e9 ca fd ff ff       	jmp    80055d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800793:	85 ff                	test   %edi,%edi
  800795:	78 b8                	js     80074f <vprintfmt+0x215>
  800797:	83 ef 01             	sub    $0x1,%edi
  80079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8007a0:	79 ad                	jns    80074f <vprintfmt+0x215>
  8007a2:	eb e1                	jmp    800785 <vprintfmt+0x24b>
  8007a4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8007a7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8007aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007ae:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8007b5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007b7:	83 ee 01             	sub    $0x1,%esi
  8007ba:	75 ee                	jne    8007aa <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007bc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8007bf:	e9 99 fd ff ff       	jmp    80055d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007c4:	83 f9 01             	cmp    $0x1,%ecx
  8007c7:	7e 10                	jle    8007d9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8d 50 08             	lea    0x8(%eax),%edx
  8007cf:	89 55 14             	mov    %edx,0x14(%ebp)
  8007d2:	8b 30                	mov    (%eax),%esi
  8007d4:	8b 78 04             	mov    0x4(%eax),%edi
  8007d7:	eb 26                	jmp    8007ff <vprintfmt+0x2c5>
	else if (lflag)
  8007d9:	85 c9                	test   %ecx,%ecx
  8007db:	74 12                	je     8007ef <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8d 50 04             	lea    0x4(%eax),%edx
  8007e3:	89 55 14             	mov    %edx,0x14(%ebp)
  8007e6:	8b 30                	mov    (%eax),%esi
  8007e8:	89 f7                	mov    %esi,%edi
  8007ea:	c1 ff 1f             	sar    $0x1f,%edi
  8007ed:	eb 10                	jmp    8007ff <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8d 50 04             	lea    0x4(%eax),%edx
  8007f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007f8:	8b 30                	mov    (%eax),%esi
  8007fa:	89 f7                	mov    %esi,%edi
  8007fc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007ff:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800804:	85 ff                	test   %edi,%edi
  800806:	0f 89 8c 00 00 00    	jns    800898 <vprintfmt+0x35e>
				putch('-', putdat);
  80080c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800810:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800817:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80081a:	f7 de                	neg    %esi
  80081c:	83 d7 00             	adc    $0x0,%edi
  80081f:	f7 df                	neg    %edi
			}
			base = 10;
  800821:	b8 0a 00 00 00       	mov    $0xa,%eax
  800826:	eb 70                	jmp    800898 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800828:	89 ca                	mov    %ecx,%edx
  80082a:	8d 45 14             	lea    0x14(%ebp),%eax
  80082d:	e8 89 fc ff ff       	call   8004bb <getuint>
  800832:	89 c6                	mov    %eax,%esi
  800834:	89 d7                	mov    %edx,%edi
			base = 10;
  800836:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80083b:	eb 5b                	jmp    800898 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80083d:	89 ca                	mov    %ecx,%edx
  80083f:	8d 45 14             	lea    0x14(%ebp),%eax
  800842:	e8 74 fc ff ff       	call   8004bb <getuint>
  800847:	89 c6                	mov    %eax,%esi
  800849:	89 d7                	mov    %edx,%edi
			base = 8;
  80084b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800850:	eb 46                	jmp    800898 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800852:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800856:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80085d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800860:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800864:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80086b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	8d 50 04             	lea    0x4(%eax),%edx
  800874:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800877:	8b 30                	mov    (%eax),%esi
  800879:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80087e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800883:	eb 13                	jmp    800898 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800885:	89 ca                	mov    %ecx,%edx
  800887:	8d 45 14             	lea    0x14(%ebp),%eax
  80088a:	e8 2c fc ff ff       	call   8004bb <getuint>
  80088f:	89 c6                	mov    %eax,%esi
  800891:	89 d7                	mov    %edx,%edi
			base = 16;
  800893:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800898:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80089c:	89 54 24 10          	mov    %edx,0x10(%esp)
  8008a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8008a3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ab:	89 34 24             	mov    %esi,(%esp)
  8008ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008b2:	89 da                	mov    %ebx,%edx
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	e8 24 fb ff ff       	call   8003e0 <printnum>
			break;
  8008bc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8008bf:	e9 99 fc ff ff       	jmp    80055d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008c8:	89 14 24             	mov    %edx,(%esp)
  8008cb:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ce:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8008d1:	e9 87 fc ff ff       	jmp    80055d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008da:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008e1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8008e8:	0f 84 6f fc ff ff    	je     80055d <vprintfmt+0x23>
  8008ee:	83 ee 01             	sub    $0x1,%esi
  8008f1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8008f5:	75 f7                	jne    8008ee <vprintfmt+0x3b4>
  8008f7:	e9 61 fc ff ff       	jmp    80055d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8008fc:	83 c4 4c             	add    $0x4c,%esp
  8008ff:	5b                   	pop    %ebx
  800900:	5e                   	pop    %esi
  800901:	5f                   	pop    %edi
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	83 ec 28             	sub    $0x28,%esp
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800910:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800913:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800917:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80091a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800921:	85 c0                	test   %eax,%eax
  800923:	74 30                	je     800955 <vsnprintf+0x51>
  800925:	85 d2                	test   %edx,%edx
  800927:	7e 2c                	jle    800955 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800930:	8b 45 10             	mov    0x10(%ebp),%eax
  800933:	89 44 24 08          	mov    %eax,0x8(%esp)
  800937:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80093a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80093e:	c7 04 24 f5 04 80 00 	movl   $0x8004f5,(%esp)
  800945:	e8 f0 fb ff ff       	call   80053a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80094a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80094d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800953:	eb 05                	jmp    80095a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800955:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    

0080095c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800962:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800965:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800969:	8b 45 10             	mov    0x10(%ebp),%eax
  80096c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800970:	8b 45 0c             	mov    0xc(%ebp),%eax
  800973:	89 44 24 04          	mov    %eax,0x4(%esp)
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	89 04 24             	mov    %eax,(%esp)
  80097d:	e8 82 ff ff ff       	call   800904 <vsnprintf>
	va_end(ap);

	return rc;
}
  800982:	c9                   	leave  
  800983:	c3                   	ret    
	...

00800990 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800996:	b8 00 00 00 00       	mov    $0x0,%eax
  80099b:	80 3a 00             	cmpb   $0x0,(%edx)
  80099e:	74 09                	je     8009a9 <strlen+0x19>
		n++;
  8009a0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009a7:	75 f7                	jne    8009a0 <strlen+0x10>
		n++;
	return n;
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	53                   	push   %ebx
  8009af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ba:	85 c9                	test   %ecx,%ecx
  8009bc:	74 1a                	je     8009d8 <strnlen+0x2d>
  8009be:	80 3b 00             	cmpb   $0x0,(%ebx)
  8009c1:	74 15                	je     8009d8 <strnlen+0x2d>
  8009c3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8009c8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ca:	39 ca                	cmp    %ecx,%edx
  8009cc:	74 0a                	je     8009d8 <strnlen+0x2d>
  8009ce:	83 c2 01             	add    $0x1,%edx
  8009d1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8009d6:	75 f0                	jne    8009c8 <strnlen+0x1d>
		n++;
	return n;
}
  8009d8:	5b                   	pop    %ebx
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	53                   	push   %ebx
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ea:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009ee:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009f1:	83 c2 01             	add    $0x1,%edx
  8009f4:	84 c9                	test   %cl,%cl
  8009f6:	75 f2                	jne    8009ea <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	53                   	push   %ebx
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a05:	89 1c 24             	mov    %ebx,(%esp)
  800a08:	e8 83 ff ff ff       	call   800990 <strlen>
	strcpy(dst + len, src);
  800a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a10:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a14:	01 d8                	add    %ebx,%eax
  800a16:	89 04 24             	mov    %eax,(%esp)
  800a19:	e8 bd ff ff ff       	call   8009db <strcpy>
	return dst;
}
  800a1e:	89 d8                	mov    %ebx,%eax
  800a20:	83 c4 08             	add    $0x8,%esp
  800a23:	5b                   	pop    %ebx
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	56                   	push   %esi
  800a2a:	53                   	push   %ebx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a31:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a34:	85 f6                	test   %esi,%esi
  800a36:	74 18                	je     800a50 <strncpy+0x2a>
  800a38:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800a3d:	0f b6 1a             	movzbl (%edx),%ebx
  800a40:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a43:	80 3a 01             	cmpb   $0x1,(%edx)
  800a46:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a49:	83 c1 01             	add    $0x1,%ecx
  800a4c:	39 f1                	cmp    %esi,%ecx
  800a4e:	75 ed                	jne    800a3d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a50:	5b                   	pop    %ebx
  800a51:	5e                   	pop    %esi
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	57                   	push   %edi
  800a58:	56                   	push   %esi
  800a59:	53                   	push   %ebx
  800a5a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a60:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a63:	89 f8                	mov    %edi,%eax
  800a65:	85 f6                	test   %esi,%esi
  800a67:	74 2b                	je     800a94 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800a69:	83 fe 01             	cmp    $0x1,%esi
  800a6c:	74 23                	je     800a91 <strlcpy+0x3d>
  800a6e:	0f b6 0b             	movzbl (%ebx),%ecx
  800a71:	84 c9                	test   %cl,%cl
  800a73:	74 1c                	je     800a91 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800a75:	83 ee 02             	sub    $0x2,%esi
  800a78:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a7d:	88 08                	mov    %cl,(%eax)
  800a7f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a82:	39 f2                	cmp    %esi,%edx
  800a84:	74 0b                	je     800a91 <strlcpy+0x3d>
  800a86:	83 c2 01             	add    $0x1,%edx
  800a89:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a8d:	84 c9                	test   %cl,%cl
  800a8f:	75 ec                	jne    800a7d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800a91:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a94:	29 f8                	sub    %edi,%eax
}
  800a96:	5b                   	pop    %ebx
  800a97:	5e                   	pop    %esi
  800a98:	5f                   	pop    %edi
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aa4:	0f b6 01             	movzbl (%ecx),%eax
  800aa7:	84 c0                	test   %al,%al
  800aa9:	74 16                	je     800ac1 <strcmp+0x26>
  800aab:	3a 02                	cmp    (%edx),%al
  800aad:	75 12                	jne    800ac1 <strcmp+0x26>
		p++, q++;
  800aaf:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ab2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800ab6:	84 c0                	test   %al,%al
  800ab8:	74 07                	je     800ac1 <strcmp+0x26>
  800aba:	83 c1 01             	add    $0x1,%ecx
  800abd:	3a 02                	cmp    (%edx),%al
  800abf:	74 ee                	je     800aaf <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac1:	0f b6 c0             	movzbl %al,%eax
  800ac4:	0f b6 12             	movzbl (%edx),%edx
  800ac7:	29 d0                	sub    %edx,%eax
}
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	53                   	push   %ebx
  800acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ad5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ad8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800add:	85 d2                	test   %edx,%edx
  800adf:	74 28                	je     800b09 <strncmp+0x3e>
  800ae1:	0f b6 01             	movzbl (%ecx),%eax
  800ae4:	84 c0                	test   %al,%al
  800ae6:	74 24                	je     800b0c <strncmp+0x41>
  800ae8:	3a 03                	cmp    (%ebx),%al
  800aea:	75 20                	jne    800b0c <strncmp+0x41>
  800aec:	83 ea 01             	sub    $0x1,%edx
  800aef:	74 13                	je     800b04 <strncmp+0x39>
		n--, p++, q++;
  800af1:	83 c1 01             	add    $0x1,%ecx
  800af4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800af7:	0f b6 01             	movzbl (%ecx),%eax
  800afa:	84 c0                	test   %al,%al
  800afc:	74 0e                	je     800b0c <strncmp+0x41>
  800afe:	3a 03                	cmp    (%ebx),%al
  800b00:	74 ea                	je     800aec <strncmp+0x21>
  800b02:	eb 08                	jmp    800b0c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b04:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b09:	5b                   	pop    %ebx
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0c:	0f b6 01             	movzbl (%ecx),%eax
  800b0f:	0f b6 13             	movzbl (%ebx),%edx
  800b12:	29 d0                	sub    %edx,%eax
  800b14:	eb f3                	jmp    800b09 <strncmp+0x3e>

00800b16 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b20:	0f b6 10             	movzbl (%eax),%edx
  800b23:	84 d2                	test   %dl,%dl
  800b25:	74 1c                	je     800b43 <strchr+0x2d>
		if (*s == c)
  800b27:	38 ca                	cmp    %cl,%dl
  800b29:	75 09                	jne    800b34 <strchr+0x1e>
  800b2b:	eb 1b                	jmp    800b48 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b2d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800b30:	38 ca                	cmp    %cl,%dl
  800b32:	74 14                	je     800b48 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b34:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800b38:	84 d2                	test   %dl,%dl
  800b3a:	75 f1                	jne    800b2d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b41:	eb 05                	jmp    800b48 <strchr+0x32>
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b54:	0f b6 10             	movzbl (%eax),%edx
  800b57:	84 d2                	test   %dl,%dl
  800b59:	74 14                	je     800b6f <strfind+0x25>
		if (*s == c)
  800b5b:	38 ca                	cmp    %cl,%dl
  800b5d:	75 06                	jne    800b65 <strfind+0x1b>
  800b5f:	eb 0e                	jmp    800b6f <strfind+0x25>
  800b61:	38 ca                	cmp    %cl,%dl
  800b63:	74 0a                	je     800b6f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b65:	83 c0 01             	add    $0x1,%eax
  800b68:	0f b6 10             	movzbl (%eax),%edx
  800b6b:	84 d2                	test   %dl,%dl
  800b6d:	75 f2                	jne    800b61 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 0c             	sub    $0xc,%esp
  800b77:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b7a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b7d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800b80:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b86:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b89:	85 c9                	test   %ecx,%ecx
  800b8b:	74 30                	je     800bbd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b8d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b93:	75 25                	jne    800bba <memset+0x49>
  800b95:	f6 c1 03             	test   $0x3,%cl
  800b98:	75 20                	jne    800bba <memset+0x49>
		c &= 0xFF;
  800b9a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b9d:	89 d3                	mov    %edx,%ebx
  800b9f:	c1 e3 08             	shl    $0x8,%ebx
  800ba2:	89 d6                	mov    %edx,%esi
  800ba4:	c1 e6 18             	shl    $0x18,%esi
  800ba7:	89 d0                	mov    %edx,%eax
  800ba9:	c1 e0 10             	shl    $0x10,%eax
  800bac:	09 f0                	or     %esi,%eax
  800bae:	09 d0                	or     %edx,%eax
  800bb0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bb2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800bb5:	fc                   	cld    
  800bb6:	f3 ab                	rep stos %eax,%es:(%edi)
  800bb8:	eb 03                	jmp    800bbd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bba:	fc                   	cld    
  800bbb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bbd:	89 f8                	mov    %edi,%eax
  800bbf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800bc2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bc5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bc8:	89 ec                	mov    %ebp,%esp
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800bd5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bde:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be1:	39 c6                	cmp    %eax,%esi
  800be3:	73 36                	jae    800c1b <memmove+0x4f>
  800be5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be8:	39 d0                	cmp    %edx,%eax
  800bea:	73 2f                	jae    800c1b <memmove+0x4f>
		s += n;
		d += n;
  800bec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bef:	f6 c2 03             	test   $0x3,%dl
  800bf2:	75 1b                	jne    800c0f <memmove+0x43>
  800bf4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bfa:	75 13                	jne    800c0f <memmove+0x43>
  800bfc:	f6 c1 03             	test   $0x3,%cl
  800bff:	75 0e                	jne    800c0f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c01:	83 ef 04             	sub    $0x4,%edi
  800c04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c07:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c0a:	fd                   	std    
  800c0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c0d:	eb 09                	jmp    800c18 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c0f:	83 ef 01             	sub    $0x1,%edi
  800c12:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c15:	fd                   	std    
  800c16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c18:	fc                   	cld    
  800c19:	eb 20                	jmp    800c3b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c1b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c21:	75 13                	jne    800c36 <memmove+0x6a>
  800c23:	a8 03                	test   $0x3,%al
  800c25:	75 0f                	jne    800c36 <memmove+0x6a>
  800c27:	f6 c1 03             	test   $0x3,%cl
  800c2a:	75 0a                	jne    800c36 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c2c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c2f:	89 c7                	mov    %eax,%edi
  800c31:	fc                   	cld    
  800c32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c34:	eb 05                	jmp    800c3b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c36:	89 c7                	mov    %eax,%edi
  800c38:	fc                   	cld    
  800c39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c3b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c3e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c41:	89 ec                	mov    %ebp,%esp
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 04 24             	mov    %eax,(%esp)
  800c5f:	e8 68 ff ff ff       	call   800bcc <memmove>
}
  800c64:	c9                   	leave  
  800c65:	c3                   	ret    

00800c66 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	57                   	push   %edi
  800c6a:	56                   	push   %esi
  800c6b:	53                   	push   %ebx
  800c6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c72:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7a:	85 ff                	test   %edi,%edi
  800c7c:	74 37                	je     800cb5 <memcmp+0x4f>
		if (*s1 != *s2)
  800c7e:	0f b6 03             	movzbl (%ebx),%eax
  800c81:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c84:	83 ef 01             	sub    $0x1,%edi
  800c87:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800c8c:	38 c8                	cmp    %cl,%al
  800c8e:	74 1c                	je     800cac <memcmp+0x46>
  800c90:	eb 10                	jmp    800ca2 <memcmp+0x3c>
  800c92:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800c97:	83 c2 01             	add    $0x1,%edx
  800c9a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800c9e:	38 c8                	cmp    %cl,%al
  800ca0:	74 0a                	je     800cac <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800ca2:	0f b6 c0             	movzbl %al,%eax
  800ca5:	0f b6 c9             	movzbl %cl,%ecx
  800ca8:	29 c8                	sub    %ecx,%eax
  800caa:	eb 09                	jmp    800cb5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cac:	39 fa                	cmp    %edi,%edx
  800cae:	75 e2                	jne    800c92 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800cc0:	89 c2                	mov    %eax,%edx
  800cc2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cc5:	39 d0                	cmp    %edx,%eax
  800cc7:	73 19                	jae    800ce2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cc9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800ccd:	38 08                	cmp    %cl,(%eax)
  800ccf:	75 06                	jne    800cd7 <memfind+0x1d>
  800cd1:	eb 0f                	jmp    800ce2 <memfind+0x28>
  800cd3:	38 08                	cmp    %cl,(%eax)
  800cd5:	74 0b                	je     800ce2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cd7:	83 c0 01             	add    $0x1,%eax
  800cda:	39 d0                	cmp    %edx,%eax
  800cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ce0:	75 f1                	jne    800cd3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ced:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf0:	0f b6 02             	movzbl (%edx),%eax
  800cf3:	3c 20                	cmp    $0x20,%al
  800cf5:	74 04                	je     800cfb <strtol+0x17>
  800cf7:	3c 09                	cmp    $0x9,%al
  800cf9:	75 0e                	jne    800d09 <strtol+0x25>
		s++;
  800cfb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cfe:	0f b6 02             	movzbl (%edx),%eax
  800d01:	3c 20                	cmp    $0x20,%al
  800d03:	74 f6                	je     800cfb <strtol+0x17>
  800d05:	3c 09                	cmp    $0x9,%al
  800d07:	74 f2                	je     800cfb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d09:	3c 2b                	cmp    $0x2b,%al
  800d0b:	75 0a                	jne    800d17 <strtol+0x33>
		s++;
  800d0d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d10:	bf 00 00 00 00       	mov    $0x0,%edi
  800d15:	eb 10                	jmp    800d27 <strtol+0x43>
  800d17:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d1c:	3c 2d                	cmp    $0x2d,%al
  800d1e:	75 07                	jne    800d27 <strtol+0x43>
		s++, neg = 1;
  800d20:	83 c2 01             	add    $0x1,%edx
  800d23:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d27:	85 db                	test   %ebx,%ebx
  800d29:	0f 94 c0             	sete   %al
  800d2c:	74 05                	je     800d33 <strtol+0x4f>
  800d2e:	83 fb 10             	cmp    $0x10,%ebx
  800d31:	75 15                	jne    800d48 <strtol+0x64>
  800d33:	80 3a 30             	cmpb   $0x30,(%edx)
  800d36:	75 10                	jne    800d48 <strtol+0x64>
  800d38:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d3c:	75 0a                	jne    800d48 <strtol+0x64>
		s += 2, base = 16;
  800d3e:	83 c2 02             	add    $0x2,%edx
  800d41:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d46:	eb 13                	jmp    800d5b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  800d48:	84 c0                	test   %al,%al
  800d4a:	74 0f                	je     800d5b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d4c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d51:	80 3a 30             	cmpb   $0x30,(%edx)
  800d54:	75 05                	jne    800d5b <strtol+0x77>
		s++, base = 8;
  800d56:	83 c2 01             	add    $0x1,%edx
  800d59:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d60:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d62:	0f b6 0a             	movzbl (%edx),%ecx
  800d65:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d68:	80 fb 09             	cmp    $0x9,%bl
  800d6b:	77 08                	ja     800d75 <strtol+0x91>
			dig = *s - '0';
  800d6d:	0f be c9             	movsbl %cl,%ecx
  800d70:	83 e9 30             	sub    $0x30,%ecx
  800d73:	eb 1e                	jmp    800d93 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800d75:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800d78:	80 fb 19             	cmp    $0x19,%bl
  800d7b:	77 08                	ja     800d85 <strtol+0xa1>
			dig = *s - 'a' + 10;
  800d7d:	0f be c9             	movsbl %cl,%ecx
  800d80:	83 e9 57             	sub    $0x57,%ecx
  800d83:	eb 0e                	jmp    800d93 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800d85:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800d88:	80 fb 19             	cmp    $0x19,%bl
  800d8b:	77 14                	ja     800da1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800d8d:	0f be c9             	movsbl %cl,%ecx
  800d90:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d93:	39 f1                	cmp    %esi,%ecx
  800d95:	7d 0e                	jge    800da5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d97:	83 c2 01             	add    $0x1,%edx
  800d9a:	0f af c6             	imul   %esi,%eax
  800d9d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  800d9f:	eb c1                	jmp    800d62 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800da1:	89 c1                	mov    %eax,%ecx
  800da3:	eb 02                	jmp    800da7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800da5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800da7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dab:	74 05                	je     800db2 <strtol+0xce>
		*endptr = (char *) s;
  800dad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800db0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800db2:	89 ca                	mov    %ecx,%edx
  800db4:	f7 da                	neg    %edx
  800db6:	85 ff                	test   %edi,%edi
  800db8:	0f 45 c2             	cmovne %edx,%eax
}
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5f                   	pop    %edi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    

00800dc0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dc9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dcc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dda:	89 c3                	mov    %eax,%ebx
  800ddc:	89 c7                	mov    %eax,%edi
  800dde:	89 c6                	mov    %eax,%esi
  800de0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800de2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800de5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800de8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800deb:	89 ec                	mov    %ebp,%esp
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    

00800def <sys_cgetc>:

int
sys_cgetc(void)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800df8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dfb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800e03:	b8 01 00 00 00       	mov    $0x1,%eax
  800e08:	89 d1                	mov    %edx,%ecx
  800e0a:	89 d3                	mov    %edx,%ebx
  800e0c:	89 d7                	mov    %edx,%edi
  800e0e:	89 d6                	mov    %edx,%esi
  800e10:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e12:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e15:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e18:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e1b:	89 ec                	mov    %ebp,%esp
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    

00800e1f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 38             	sub    $0x38,%esp
  800e25:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e28:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e2b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e33:	b8 03 00 00 00       	mov    $0x3,%eax
  800e38:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3b:	89 cb                	mov    %ecx,%ebx
  800e3d:	89 cf                	mov    %ecx,%edi
  800e3f:	89 ce                	mov    %ecx,%esi
  800e41:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e43:	85 c0                	test   %eax,%eax
  800e45:	7e 28                	jle    800e6f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e47:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e52:	00 
  800e53:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  800e5a:	00 
  800e5b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e62:	00 
  800e63:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  800e6a:	e8 4d f4 ff ff       	call   8002bc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e6f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e72:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e75:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e78:	89 ec                	mov    %ebp,%esp
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    

00800e7c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e85:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e88:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e90:	b8 02 00 00 00       	mov    $0x2,%eax
  800e95:	89 d1                	mov    %edx,%ecx
  800e97:	89 d3                	mov    %edx,%ebx
  800e99:	89 d7                	mov    %edx,%edi
  800e9b:	89 d6                	mov    %edx,%esi
  800e9d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e9f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ea2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ea5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ea8:	89 ec                	mov    %ebp,%esp
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <sys_yield>:

void
sys_yield(void)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 0c             	sub    $0xc,%esp
  800eb2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eb5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eb8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ec5:	89 d1                	mov    %edx,%ecx
  800ec7:	89 d3                	mov    %edx,%ebx
  800ec9:	89 d7                	mov    %edx,%edi
  800ecb:	89 d6                	mov    %edx,%esi
  800ecd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ecf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ed2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ed5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ed8:	89 ec                	mov    %ebp,%esp
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 38             	sub    $0x38,%esp
  800ee2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ee5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ee8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eeb:	be 00 00 00 00       	mov    $0x0,%esi
  800ef0:	b8 04 00 00 00       	mov    $0x4,%eax
  800ef5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efb:	8b 55 08             	mov    0x8(%ebp),%edx
  800efe:	89 f7                	mov    %esi,%edi
  800f00:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f02:	85 c0                	test   %eax,%eax
  800f04:	7e 28                	jle    800f2e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f06:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f0a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f11:	00 
  800f12:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  800f19:	00 
  800f1a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f21:	00 
  800f22:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  800f29:	e8 8e f3 ff ff       	call   8002bc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f2e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f31:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f34:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f37:	89 ec                	mov    %ebp,%esp
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    

00800f3b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 38             	sub    $0x38,%esp
  800f41:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f44:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f47:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4a:	b8 05 00 00 00       	mov    $0x5,%eax
  800f4f:	8b 75 18             	mov    0x18(%ebp),%esi
  800f52:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f60:	85 c0                	test   %eax,%eax
  800f62:	7e 28                	jle    800f8c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f64:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f68:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f6f:	00 
  800f70:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  800f77:	00 
  800f78:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7f:	00 
  800f80:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  800f87:	e8 30 f3 ff ff       	call   8002bc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f8c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f8f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f92:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f95:	89 ec                	mov    %ebp,%esp
  800f97:	5d                   	pop    %ebp
  800f98:	c3                   	ret    

00800f99 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	83 ec 38             	sub    $0x38,%esp
  800f9f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fa2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fad:	b8 06 00 00 00       	mov    $0x6,%eax
  800fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb8:	89 df                	mov    %ebx,%edi
  800fba:	89 de                	mov    %ebx,%esi
  800fbc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	7e 28                	jle    800fea <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fcd:	00 
  800fce:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  800fd5:	00 
  800fd6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fdd:	00 
  800fde:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  800fe5:	e8 d2 f2 ff ff       	call   8002bc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fea:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fed:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ff0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ff3:	89 ec                	mov    %ebp,%esp
  800ff5:	5d                   	pop    %ebp
  800ff6:	c3                   	ret    

00800ff7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	83 ec 38             	sub    $0x38,%esp
  800ffd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801000:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801003:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801006:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100b:	b8 08 00 00 00       	mov    $0x8,%eax
  801010:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801013:	8b 55 08             	mov    0x8(%ebp),%edx
  801016:	89 df                	mov    %ebx,%edi
  801018:	89 de                	mov    %ebx,%esi
  80101a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80101c:	85 c0                	test   %eax,%eax
  80101e:	7e 28                	jle    801048 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801020:	89 44 24 10          	mov    %eax,0x10(%esp)
  801024:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80102b:	00 
  80102c:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  801033:	00 
  801034:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80103b:	00 
  80103c:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  801043:	e8 74 f2 ff ff       	call   8002bc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801048:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80104b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80104e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801051:	89 ec                	mov    %ebp,%esp
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	83 ec 38             	sub    $0x38,%esp
  80105b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80105e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801061:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801064:	bb 00 00 00 00       	mov    $0x0,%ebx
  801069:	b8 09 00 00 00       	mov    $0x9,%eax
  80106e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801071:	8b 55 08             	mov    0x8(%ebp),%edx
  801074:	89 df                	mov    %ebx,%edi
  801076:	89 de                	mov    %ebx,%esi
  801078:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80107a:	85 c0                	test   %eax,%eax
  80107c:	7e 28                	jle    8010a6 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80107e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801082:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801089:	00 
  80108a:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  801091:	00 
  801092:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801099:	00 
  80109a:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  8010a1:	e8 16 f2 ff ff       	call   8002bc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010a6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010af:	89 ec                	mov    %ebp,%esp
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 38             	sub    $0x38,%esp
  8010b9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010bc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010bf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d2:	89 df                	mov    %ebx,%edi
  8010d4:	89 de                	mov    %ebx,%esi
  8010d6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d8:	85 c0                	test   %eax,%eax
  8010da:	7e 28                	jle    801104 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010e7:	00 
  8010e8:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  8010ef:	00 
  8010f0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f7:	00 
  8010f8:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  8010ff:	e8 b8 f1 ff ff       	call   8002bc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801104:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801107:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80110a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80110d:	89 ec                	mov    %ebp,%esp
  80110f:	5d                   	pop    %ebp
  801110:	c3                   	ret    

00801111 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 0c             	sub    $0xc,%esp
  801117:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80111a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80111d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801120:	be 00 00 00 00       	mov    $0x0,%esi
  801125:	b8 0c 00 00 00       	mov    $0xc,%eax
  80112a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80112d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801130:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801138:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80113b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80113e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801141:	89 ec                	mov    %ebp,%esp
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 38             	sub    $0x38,%esp
  80114b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80114e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801151:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801154:	b9 00 00 00 00       	mov    $0x0,%ecx
  801159:	b8 0d 00 00 00       	mov    $0xd,%eax
  80115e:	8b 55 08             	mov    0x8(%ebp),%edx
  801161:	89 cb                	mov    %ecx,%ebx
  801163:	89 cf                	mov    %ecx,%edi
  801165:	89 ce                	mov    %ecx,%esi
  801167:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801169:	85 c0                	test   %eax,%eax
  80116b:	7e 28                	jle    801195 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80116d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801171:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801178:	00 
  801179:	c7 44 24 08 7f 27 80 	movl   $0x80277f,0x8(%esp)
  801180:	00 
  801181:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801188:	00 
  801189:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  801190:	e8 27 f1 ff ff       	call   8002bc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801195:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801198:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80119b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80119e:	89 ec                	mov    %ebp,%esp
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    
	...

008011b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8011bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	89 04 24             	mov    %eax,(%esp)
  8011cc:	e8 df ff ff ff       	call   8011b0 <fd2num>
  8011d1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8011d6:	c1 e0 0c             	shl    $0xc,%eax
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	53                   	push   %ebx
  8011df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011e2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8011e7:	a8 01                	test   $0x1,%al
  8011e9:	74 34                	je     80121f <fd_alloc+0x44>
  8011eb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8011f0:	a8 01                	test   $0x1,%al
  8011f2:	74 32                	je     801226 <fd_alloc+0x4b>
  8011f4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8011f9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	c1 ea 16             	shr    $0x16,%edx
  801200:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801207:	f6 c2 01             	test   $0x1,%dl
  80120a:	74 1f                	je     80122b <fd_alloc+0x50>
  80120c:	89 c2                	mov    %eax,%edx
  80120e:	c1 ea 0c             	shr    $0xc,%edx
  801211:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801218:	f6 c2 01             	test   $0x1,%dl
  80121b:	75 17                	jne    801234 <fd_alloc+0x59>
  80121d:	eb 0c                	jmp    80122b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80121f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801224:	eb 05                	jmp    80122b <fd_alloc+0x50>
  801226:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80122b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80122d:	b8 00 00 00 00       	mov    $0x0,%eax
  801232:	eb 17                	jmp    80124b <fd_alloc+0x70>
  801234:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801239:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80123e:	75 b9                	jne    8011f9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801240:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801246:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80124b:	5b                   	pop    %ebx
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801254:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801259:	83 fa 1f             	cmp    $0x1f,%edx
  80125c:	77 3f                	ja     80129d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80125e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801264:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801267:	89 d0                	mov    %edx,%eax
  801269:	c1 e8 16             	shr    $0x16,%eax
  80126c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801273:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801278:	f6 c1 01             	test   $0x1,%cl
  80127b:	74 20                	je     80129d <fd_lookup+0x4f>
  80127d:	89 d0                	mov    %edx,%eax
  80127f:	c1 e8 0c             	shr    $0xc,%eax
  801282:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801289:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80128e:	f6 c1 01             	test   $0x1,%cl
  801291:	74 0a                	je     80129d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801293:	8b 45 0c             	mov    0xc(%ebp),%eax
  801296:	89 10                	mov    %edx,(%eax)
	return 0;
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129d:	5d                   	pop    %ebp
  80129e:	c3                   	ret    

0080129f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	53                   	push   %ebx
  8012a3:	83 ec 14             	sub    $0x14,%esp
  8012a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8012ac:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012b1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8012b7:	75 17                	jne    8012d0 <dev_lookup+0x31>
  8012b9:	eb 07                	jmp    8012c2 <dev_lookup+0x23>
  8012bb:	39 0a                	cmp    %ecx,(%edx)
  8012bd:	75 11                	jne    8012d0 <dev_lookup+0x31>
  8012bf:	90                   	nop
  8012c0:	eb 05                	jmp    8012c7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8012c2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8012c7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8012c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ce:	eb 35                	jmp    801305 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8012d0:	83 c0 01             	add    $0x1,%eax
  8012d3:	8b 14 85 2c 28 80 00 	mov    0x80282c(,%eax,4),%edx
  8012da:	85 d2                	test   %edx,%edx
  8012dc:	75 dd                	jne    8012bb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012de:	a1 04 40 80 00       	mov    0x804004,%eax
  8012e3:	8b 40 48             	mov    0x48(%eax),%eax
  8012e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ee:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  8012f5:	e8 bd f0 ff ff       	call   8003b7 <cprintf>
	*dev = 0;
  8012fa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801300:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801305:	83 c4 14             	add    $0x14,%esp
  801308:	5b                   	pop    %ebx
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    

0080130b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 38             	sub    $0x38,%esp
  801311:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801314:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801317:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80131a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80131d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801321:	89 3c 24             	mov    %edi,(%esp)
  801324:	e8 87 fe ff ff       	call   8011b0 <fd2num>
  801329:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80132c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801330:	89 04 24             	mov    %eax,(%esp)
  801333:	e8 16 ff ff ff       	call   80124e <fd_lookup>
  801338:	89 c3                	mov    %eax,%ebx
  80133a:	85 c0                	test   %eax,%eax
  80133c:	78 05                	js     801343 <fd_close+0x38>
	    || fd != fd2)
  80133e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801341:	74 0e                	je     801351 <fd_close+0x46>
		return (must_exist ? r : 0);
  801343:	89 f0                	mov    %esi,%eax
  801345:	84 c0                	test   %al,%al
  801347:	b8 00 00 00 00       	mov    $0x0,%eax
  80134c:	0f 44 d8             	cmove  %eax,%ebx
  80134f:	eb 3d                	jmp    80138e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801351:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801354:	89 44 24 04          	mov    %eax,0x4(%esp)
  801358:	8b 07                	mov    (%edi),%eax
  80135a:	89 04 24             	mov    %eax,(%esp)
  80135d:	e8 3d ff ff ff       	call   80129f <dev_lookup>
  801362:	89 c3                	mov    %eax,%ebx
  801364:	85 c0                	test   %eax,%eax
  801366:	78 16                	js     80137e <fd_close+0x73>
		if (dev->dev_close)
  801368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80136e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801373:	85 c0                	test   %eax,%eax
  801375:	74 07                	je     80137e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801377:	89 3c 24             	mov    %edi,(%esp)
  80137a:	ff d0                	call   *%eax
  80137c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80137e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801382:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801389:	e8 0b fc ff ff       	call   800f99 <sys_page_unmap>
	return r;
}
  80138e:	89 d8                	mov    %ebx,%eax
  801390:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801393:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801396:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801399:	89 ec                	mov    %ebp,%esp
  80139b:	5d                   	pop    %ebp
  80139c:	c3                   	ret    

0080139d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	89 04 24             	mov    %eax,(%esp)
  8013b0:	e8 99 fe ff ff       	call   80124e <fd_lookup>
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 13                	js     8013cc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8013b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013c0:	00 
  8013c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c4:	89 04 24             	mov    %eax,(%esp)
  8013c7:	e8 3f ff ff ff       	call   80130b <fd_close>
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <close_all>:

void
close_all(void)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	53                   	push   %ebx
  8013d2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013da:	89 1c 24             	mov    %ebx,(%esp)
  8013dd:	e8 bb ff ff ff       	call   80139d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8013e2:	83 c3 01             	add    $0x1,%ebx
  8013e5:	83 fb 20             	cmp    $0x20,%ebx
  8013e8:	75 f0                	jne    8013da <close_all+0xc>
		close(i);
}
  8013ea:	83 c4 14             	add    $0x14,%esp
  8013ed:	5b                   	pop    %ebx
  8013ee:	5d                   	pop    %ebp
  8013ef:	c3                   	ret    

008013f0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	83 ec 58             	sub    $0x58,%esp
  8013f6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013f9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013fc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8013ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801402:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801405:	89 44 24 04          	mov    %eax,0x4(%esp)
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	89 04 24             	mov    %eax,(%esp)
  80140f:	e8 3a fe ff ff       	call   80124e <fd_lookup>
  801414:	89 c3                	mov    %eax,%ebx
  801416:	85 c0                	test   %eax,%eax
  801418:	0f 88 e1 00 00 00    	js     8014ff <dup+0x10f>
		return r;
	close(newfdnum);
  80141e:	89 3c 24             	mov    %edi,(%esp)
  801421:	e8 77 ff ff ff       	call   80139d <close>

	newfd = INDEX2FD(newfdnum);
  801426:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80142c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80142f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801432:	89 04 24             	mov    %eax,(%esp)
  801435:	e8 86 fd ff ff       	call   8011c0 <fd2data>
  80143a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80143c:	89 34 24             	mov    %esi,(%esp)
  80143f:	e8 7c fd ff ff       	call   8011c0 <fd2data>
  801444:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801447:	89 d8                	mov    %ebx,%eax
  801449:	c1 e8 16             	shr    $0x16,%eax
  80144c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801453:	a8 01                	test   $0x1,%al
  801455:	74 46                	je     80149d <dup+0xad>
  801457:	89 d8                	mov    %ebx,%eax
  801459:	c1 e8 0c             	shr    $0xc,%eax
  80145c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801463:	f6 c2 01             	test   $0x1,%dl
  801466:	74 35                	je     80149d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801468:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80146f:	25 07 0e 00 00       	and    $0xe07,%eax
  801474:	89 44 24 10          	mov    %eax,0x10(%esp)
  801478:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80147b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80147f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801486:	00 
  801487:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80148b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801492:	e8 a4 fa ff ff       	call   800f3b <sys_page_map>
  801497:	89 c3                	mov    %eax,%ebx
  801499:	85 c0                	test   %eax,%eax
  80149b:	78 3b                	js     8014d8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80149d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a0:	89 c2                	mov    %eax,%edx
  8014a2:	c1 ea 0c             	shr    $0xc,%edx
  8014a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014ac:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8014b2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8014b6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014c1:	00 
  8014c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014cd:	e8 69 fa ff ff       	call   800f3b <sys_page_map>
  8014d2:	89 c3                	mov    %eax,%ebx
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	79 25                	jns    8014fd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8014d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014e3:	e8 b1 fa ff ff       	call   800f99 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014f6:	e8 9e fa ff ff       	call   800f99 <sys_page_unmap>
	return r;
  8014fb:	eb 02                	jmp    8014ff <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8014fd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014ff:	89 d8                	mov    %ebx,%eax
  801501:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801504:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801507:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80150a:	89 ec                	mov    %ebp,%esp
  80150c:	5d                   	pop    %ebp
  80150d:	c3                   	ret    

0080150e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	53                   	push   %ebx
  801512:	83 ec 24             	sub    $0x24,%esp
  801515:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801518:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151f:	89 1c 24             	mov    %ebx,(%esp)
  801522:	e8 27 fd ff ff       	call   80124e <fd_lookup>
  801527:	85 c0                	test   %eax,%eax
  801529:	78 6d                	js     801598 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801535:	8b 00                	mov    (%eax),%eax
  801537:	89 04 24             	mov    %eax,(%esp)
  80153a:	e8 60 fd ff ff       	call   80129f <dev_lookup>
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 55                	js     801598 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801546:	8b 50 08             	mov    0x8(%eax),%edx
  801549:	83 e2 03             	and    $0x3,%edx
  80154c:	83 fa 01             	cmp    $0x1,%edx
  80154f:	75 23                	jne    801574 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801551:	a1 04 40 80 00       	mov    0x804004,%eax
  801556:	8b 40 48             	mov    0x48(%eax),%eax
  801559:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80155d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801561:	c7 04 24 f0 27 80 00 	movl   $0x8027f0,(%esp)
  801568:	e8 4a ee ff ff       	call   8003b7 <cprintf>
		return -E_INVAL;
  80156d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801572:	eb 24                	jmp    801598 <read+0x8a>
	}
	if (!dev->dev_read)
  801574:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801577:	8b 52 08             	mov    0x8(%edx),%edx
  80157a:	85 d2                	test   %edx,%edx
  80157c:	74 15                	je     801593 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80157e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801581:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801585:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801588:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80158c:	89 04 24             	mov    %eax,(%esp)
  80158f:	ff d2                	call   *%edx
  801591:	eb 05                	jmp    801598 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801593:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801598:	83 c4 24             	add    $0x24,%esp
  80159b:	5b                   	pop    %ebx
  80159c:	5d                   	pop    %ebp
  80159d:	c3                   	ret    

0080159e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	57                   	push   %edi
  8015a2:	56                   	push   %esi
  8015a3:	53                   	push   %ebx
  8015a4:	83 ec 1c             	sub    $0x1c,%esp
  8015a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b2:	85 f6                	test   %esi,%esi
  8015b4:	74 30                	je     8015e6 <readn+0x48>
  8015b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015bb:	89 f2                	mov    %esi,%edx
  8015bd:	29 c2                	sub    %eax,%edx
  8015bf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015c3:	03 45 0c             	add    0xc(%ebp),%eax
  8015c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ca:	89 3c 24             	mov    %edi,(%esp)
  8015cd:	e8 3c ff ff ff       	call   80150e <read>
		if (m < 0)
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	78 10                	js     8015e6 <readn+0x48>
			return m;
		if (m == 0)
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	74 0a                	je     8015e4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015da:	01 c3                	add    %eax,%ebx
  8015dc:	89 d8                	mov    %ebx,%eax
  8015de:	39 f3                	cmp    %esi,%ebx
  8015e0:	72 d9                	jb     8015bb <readn+0x1d>
  8015e2:	eb 02                	jmp    8015e6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8015e4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8015e6:	83 c4 1c             	add    $0x1c,%esp
  8015e9:	5b                   	pop    %ebx
  8015ea:	5e                   	pop    %esi
  8015eb:	5f                   	pop    %edi
  8015ec:	5d                   	pop    %ebp
  8015ed:	c3                   	ret    

008015ee <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	53                   	push   %ebx
  8015f2:	83 ec 24             	sub    $0x24,%esp
  8015f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ff:	89 1c 24             	mov    %ebx,(%esp)
  801602:	e8 47 fc ff ff       	call   80124e <fd_lookup>
  801607:	85 c0                	test   %eax,%eax
  801609:	78 68                	js     801673 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80160b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801615:	8b 00                	mov    (%eax),%eax
  801617:	89 04 24             	mov    %eax,(%esp)
  80161a:	e8 80 fc ff ff       	call   80129f <dev_lookup>
  80161f:	85 c0                	test   %eax,%eax
  801621:	78 50                	js     801673 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801626:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80162a:	75 23                	jne    80164f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80162c:	a1 04 40 80 00       	mov    0x804004,%eax
  801631:	8b 40 48             	mov    0x48(%eax),%eax
  801634:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801638:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163c:	c7 04 24 0c 28 80 00 	movl   $0x80280c,(%esp)
  801643:	e8 6f ed ff ff       	call   8003b7 <cprintf>
		return -E_INVAL;
  801648:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164d:	eb 24                	jmp    801673 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80164f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801652:	8b 52 0c             	mov    0xc(%edx),%edx
  801655:	85 d2                	test   %edx,%edx
  801657:	74 15                	je     80166e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801659:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801660:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801663:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801667:	89 04 24             	mov    %eax,(%esp)
  80166a:	ff d2                	call   *%edx
  80166c:	eb 05                	jmp    801673 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80166e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801673:	83 c4 24             	add    $0x24,%esp
  801676:	5b                   	pop    %ebx
  801677:	5d                   	pop    %ebp
  801678:	c3                   	ret    

00801679 <seek>:

int
seek(int fdnum, off_t offset)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80167f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801682:	89 44 24 04          	mov    %eax,0x4(%esp)
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	89 04 24             	mov    %eax,(%esp)
  80168c:	e8 bd fb ff ff       	call   80124e <fd_lookup>
  801691:	85 c0                	test   %eax,%eax
  801693:	78 0e                	js     8016a3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801695:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	53                   	push   %ebx
  8016a9:	83 ec 24             	sub    $0x24,%esp
  8016ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b6:	89 1c 24             	mov    %ebx,(%esp)
  8016b9:	e8 90 fb ff ff       	call   80124e <fd_lookup>
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	78 61                	js     801723 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cc:	8b 00                	mov    (%eax),%eax
  8016ce:	89 04 24             	mov    %eax,(%esp)
  8016d1:	e8 c9 fb ff ff       	call   80129f <dev_lookup>
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	78 49                	js     801723 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016e1:	75 23                	jne    801706 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016e3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016e8:	8b 40 48             	mov    0x48(%eax),%eax
  8016eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f3:	c7 04 24 cc 27 80 00 	movl   $0x8027cc,(%esp)
  8016fa:	e8 b8 ec ff ff       	call   8003b7 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8016ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801704:	eb 1d                	jmp    801723 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801709:	8b 52 18             	mov    0x18(%edx),%edx
  80170c:	85 d2                	test   %edx,%edx
  80170e:	74 0e                	je     80171e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801710:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801713:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801717:	89 04 24             	mov    %eax,(%esp)
  80171a:	ff d2                	call   *%edx
  80171c:	eb 05                	jmp    801723 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80171e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801723:	83 c4 24             	add    $0x24,%esp
  801726:	5b                   	pop    %ebx
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    

00801729 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	53                   	push   %ebx
  80172d:	83 ec 24             	sub    $0x24,%esp
  801730:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801733:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801736:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	89 04 24             	mov    %eax,(%esp)
  801740:	e8 09 fb ff ff       	call   80124e <fd_lookup>
  801745:	85 c0                	test   %eax,%eax
  801747:	78 52                	js     80179b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801749:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801753:	8b 00                	mov    (%eax),%eax
  801755:	89 04 24             	mov    %eax,(%esp)
  801758:	e8 42 fb ff ff       	call   80129f <dev_lookup>
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 3a                	js     80179b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801764:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801768:	74 2c                	je     801796 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80176a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80176d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801774:	00 00 00 
	stat->st_isdir = 0;
  801777:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80177e:	00 00 00 
	stat->st_dev = dev;
  801781:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801787:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80178b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80178e:	89 14 24             	mov    %edx,(%esp)
  801791:	ff 50 14             	call   *0x14(%eax)
  801794:	eb 05                	jmp    80179b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801796:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80179b:	83 c4 24             	add    $0x24,%esp
  80179e:	5b                   	pop    %ebx
  80179f:	5d                   	pop    %ebp
  8017a0:	c3                   	ret    

008017a1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 18             	sub    $0x18,%esp
  8017a7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8017aa:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017b4:	00 
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	89 04 24             	mov    %eax,(%esp)
  8017bb:	e8 bc 01 00 00       	call   80197c <open>
  8017c0:	89 c3                	mov    %eax,%ebx
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	78 1b                	js     8017e1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cd:	89 1c 24             	mov    %ebx,(%esp)
  8017d0:	e8 54 ff ff ff       	call   801729 <fstat>
  8017d5:	89 c6                	mov    %eax,%esi
	close(fd);
  8017d7:	89 1c 24             	mov    %ebx,(%esp)
  8017da:	e8 be fb ff ff       	call   80139d <close>
	return r;
  8017df:	89 f3                	mov    %esi,%ebx
}
  8017e1:	89 d8                	mov    %ebx,%eax
  8017e3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8017e6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8017e9:	89 ec                	mov    %ebp,%esp
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    
  8017ed:	00 00                	add    %al,(%eax)
	...

008017f0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 18             	sub    $0x18,%esp
  8017f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8017f9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8017fc:	89 c3                	mov    %eax,%ebx
  8017fe:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801800:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801807:	75 11                	jne    80181a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801809:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801810:	e8 61 08 00 00       	call   802076 <ipc_find_env>
  801815:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80181a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801821:	00 
  801822:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801829:	00 
  80182a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80182e:	a1 00 40 80 00       	mov    0x804000,%eax
  801833:	89 04 24             	mov    %eax,(%esp)
  801836:	e8 b7 07 00 00       	call   801ff2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80183b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801842:	00 
  801843:	89 74 24 04          	mov    %esi,0x4(%esp)
  801847:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80184e:	e8 4d 07 00 00       	call   801fa0 <ipc_recv>
}
  801853:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801856:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801859:	89 ec                	mov    %ebp,%esp
  80185b:	5d                   	pop    %ebp
  80185c:	c3                   	ret    

0080185d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	53                   	push   %ebx
  801861:	83 ec 14             	sub    $0x14,%esp
  801864:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	8b 40 0c             	mov    0xc(%eax),%eax
  80186d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801872:	ba 00 00 00 00       	mov    $0x0,%edx
  801877:	b8 05 00 00 00       	mov    $0x5,%eax
  80187c:	e8 6f ff ff ff       	call   8017f0 <fsipc>
  801881:	85 c0                	test   %eax,%eax
  801883:	78 2b                	js     8018b0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801885:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80188c:	00 
  80188d:	89 1c 24             	mov    %ebx,(%esp)
  801890:	e8 46 f1 ff ff       	call   8009db <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801895:	a1 80 50 80 00       	mov    0x805080,%eax
  80189a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018a0:	a1 84 50 80 00       	mov    0x805084,%eax
  8018a5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b0:	83 c4 14             	add    $0x14,%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cc:	b8 06 00 00 00       	mov    $0x6,%eax
  8018d1:	e8 1a ff ff ff       	call   8017f0 <fsipc>
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	56                   	push   %esi
  8018dc:	53                   	push   %ebx
  8018dd:	83 ec 10             	sub    $0x10,%esp
  8018e0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018ee:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f9:	b8 03 00 00 00       	mov    $0x3,%eax
  8018fe:	e8 ed fe ff ff       	call   8017f0 <fsipc>
  801903:	89 c3                	mov    %eax,%ebx
  801905:	85 c0                	test   %eax,%eax
  801907:	78 6a                	js     801973 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801909:	39 c6                	cmp    %eax,%esi
  80190b:	73 24                	jae    801931 <devfile_read+0x59>
  80190d:	c7 44 24 0c 3c 28 80 	movl   $0x80283c,0xc(%esp)
  801914:	00 
  801915:	c7 44 24 08 43 28 80 	movl   $0x802843,0x8(%esp)
  80191c:	00 
  80191d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801924:	00 
  801925:	c7 04 24 58 28 80 00 	movl   $0x802858,(%esp)
  80192c:	e8 8b e9 ff ff       	call   8002bc <_panic>
	assert(r <= PGSIZE);
  801931:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801936:	7e 24                	jle    80195c <devfile_read+0x84>
  801938:	c7 44 24 0c 63 28 80 	movl   $0x802863,0xc(%esp)
  80193f:	00 
  801940:	c7 44 24 08 43 28 80 	movl   $0x802843,0x8(%esp)
  801947:	00 
  801948:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80194f:	00 
  801950:	c7 04 24 58 28 80 00 	movl   $0x802858,(%esp)
  801957:	e8 60 e9 ff ff       	call   8002bc <_panic>
	memmove(buf, &fsipcbuf, r);
  80195c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801960:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801967:	00 
  801968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196b:	89 04 24             	mov    %eax,(%esp)
  80196e:	e8 59 f2 ff ff       	call   800bcc <memmove>
	return r;
}
  801973:	89 d8                	mov    %ebx,%eax
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	5b                   	pop    %ebx
  801979:	5e                   	pop    %esi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    

0080197c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	56                   	push   %esi
  801980:	53                   	push   %ebx
  801981:	83 ec 20             	sub    $0x20,%esp
  801984:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801987:	89 34 24             	mov    %esi,(%esp)
  80198a:	e8 01 f0 ff ff       	call   800990 <strlen>
		return -E_BAD_PATH;
  80198f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801994:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801999:	7f 5e                	jg     8019f9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80199b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199e:	89 04 24             	mov    %eax,(%esp)
  8019a1:	e8 35 f8 ff ff       	call   8011db <fd_alloc>
  8019a6:	89 c3                	mov    %eax,%ebx
  8019a8:	85 c0                	test   %eax,%eax
  8019aa:	78 4d                	js     8019f9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8019ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019b0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8019b7:	e8 1f f0 ff ff       	call   8009db <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bf:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8019cc:	e8 1f fe ff ff       	call   8017f0 <fsipc>
  8019d1:	89 c3                	mov    %eax,%ebx
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	79 15                	jns    8019ec <open+0x70>
		fd_close(fd, 0);
  8019d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019de:	00 
  8019df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e2:	89 04 24             	mov    %eax,(%esp)
  8019e5:	e8 21 f9 ff ff       	call   80130b <fd_close>
		return r;
  8019ea:	eb 0d                	jmp    8019f9 <open+0x7d>
	}

	return fd2num(fd);
  8019ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ef:	89 04 24             	mov    %eax,(%esp)
  8019f2:	e8 b9 f7 ff ff       	call   8011b0 <fd2num>
  8019f7:	89 c3                	mov    %eax,%ebx
}
  8019f9:	89 d8                	mov    %ebx,%eax
  8019fb:	83 c4 20             	add    $0x20,%esp
  8019fe:	5b                   	pop    %ebx
  8019ff:	5e                   	pop    %esi
  801a00:	5d                   	pop    %ebp
  801a01:	c3                   	ret    
	...

00801a10 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 18             	sub    $0x18,%esp
  801a16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a19:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	89 04 24             	mov    %eax,(%esp)
  801a25:	e8 96 f7 ff ff       	call   8011c0 <fd2data>
  801a2a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801a2c:	c7 44 24 04 6f 28 80 	movl   $0x80286f,0x4(%esp)
  801a33:	00 
  801a34:	89 34 24             	mov    %esi,(%esp)
  801a37:	e8 9f ef ff ff       	call   8009db <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a3c:	8b 43 04             	mov    0x4(%ebx),%eax
  801a3f:	2b 03                	sub    (%ebx),%eax
  801a41:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801a47:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801a4e:	00 00 00 
	stat->st_dev = &devpipe;
  801a51:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801a58:	30 80 00 
	return 0;
}
  801a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a60:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a63:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a66:	89 ec                	mov    %ebp,%esp
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    

00801a6a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	53                   	push   %ebx
  801a6e:	83 ec 14             	sub    $0x14,%esp
  801a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a74:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7f:	e8 15 f5 ff ff       	call   800f99 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a84:	89 1c 24             	mov    %ebx,(%esp)
  801a87:	e8 34 f7 ff ff       	call   8011c0 <fd2data>
  801a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a97:	e8 fd f4 ff ff       	call   800f99 <sys_page_unmap>
}
  801a9c:	83 c4 14             	add    $0x14,%esp
  801a9f:	5b                   	pop    %ebx
  801aa0:	5d                   	pop    %ebp
  801aa1:	c3                   	ret    

00801aa2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	57                   	push   %edi
  801aa6:	56                   	push   %esi
  801aa7:	53                   	push   %ebx
  801aa8:	83 ec 2c             	sub    $0x2c,%esp
  801aab:	89 c7                	mov    %eax,%edi
  801aad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801ab0:	a1 04 40 80 00       	mov    0x804004,%eax
  801ab5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ab8:	89 3c 24             	mov    %edi,(%esp)
  801abb:	e8 00 06 00 00       	call   8020c0 <pageref>
  801ac0:	89 c6                	mov    %eax,%esi
  801ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ac5:	89 04 24             	mov    %eax,(%esp)
  801ac8:	e8 f3 05 00 00       	call   8020c0 <pageref>
  801acd:	39 c6                	cmp    %eax,%esi
  801acf:	0f 94 c0             	sete   %al
  801ad2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801ad5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801adb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ade:	39 cb                	cmp    %ecx,%ebx
  801ae0:	75 08                	jne    801aea <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801ae2:	83 c4 2c             	add    $0x2c,%esp
  801ae5:	5b                   	pop    %ebx
  801ae6:	5e                   	pop    %esi
  801ae7:	5f                   	pop    %edi
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801aea:	83 f8 01             	cmp    $0x1,%eax
  801aed:	75 c1                	jne    801ab0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801aef:	8b 52 58             	mov    0x58(%edx),%edx
  801af2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801af6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801afa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801afe:	c7 04 24 76 28 80 00 	movl   $0x802876,(%esp)
  801b05:	e8 ad e8 ff ff       	call   8003b7 <cprintf>
  801b0a:	eb a4                	jmp    801ab0 <_pipeisclosed+0xe>

00801b0c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	57                   	push   %edi
  801b10:	56                   	push   %esi
  801b11:	53                   	push   %ebx
  801b12:	83 ec 2c             	sub    $0x2c,%esp
  801b15:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801b18:	89 34 24             	mov    %esi,(%esp)
  801b1b:	e8 a0 f6 ff ff       	call   8011c0 <fd2data>
  801b20:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b22:	bf 00 00 00 00       	mov    $0x0,%edi
  801b27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b2b:	75 50                	jne    801b7d <devpipe_write+0x71>
  801b2d:	eb 5c                	jmp    801b8b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801b2f:	89 da                	mov    %ebx,%edx
  801b31:	89 f0                	mov    %esi,%eax
  801b33:	e8 6a ff ff ff       	call   801aa2 <_pipeisclosed>
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	75 53                	jne    801b8f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801b3c:	e8 6b f3 ff ff       	call   800eac <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b41:	8b 43 04             	mov    0x4(%ebx),%eax
  801b44:	8b 13                	mov    (%ebx),%edx
  801b46:	83 c2 20             	add    $0x20,%edx
  801b49:	39 d0                	cmp    %edx,%eax
  801b4b:	73 e2                	jae    801b2f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b50:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801b54:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801b57:	89 c2                	mov    %eax,%edx
  801b59:	c1 fa 1f             	sar    $0x1f,%edx
  801b5c:	c1 ea 1b             	shr    $0x1b,%edx
  801b5f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801b62:	83 e1 1f             	and    $0x1f,%ecx
  801b65:	29 d1                	sub    %edx,%ecx
  801b67:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801b6b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801b6f:	83 c0 01             	add    $0x1,%eax
  801b72:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b75:	83 c7 01             	add    $0x1,%edi
  801b78:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b7b:	74 0e                	je     801b8b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b7d:	8b 43 04             	mov    0x4(%ebx),%eax
  801b80:	8b 13                	mov    (%ebx),%edx
  801b82:	83 c2 20             	add    $0x20,%edx
  801b85:	39 d0                	cmp    %edx,%eax
  801b87:	73 a6                	jae    801b2f <devpipe_write+0x23>
  801b89:	eb c2                	jmp    801b4d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801b8b:	89 f8                	mov    %edi,%eax
  801b8d:	eb 05                	jmp    801b94 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b8f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801b94:	83 c4 2c             	add    $0x2c,%esp
  801b97:	5b                   	pop    %ebx
  801b98:	5e                   	pop    %esi
  801b99:	5f                   	pop    %edi
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    

00801b9c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 28             	sub    $0x28,%esp
  801ba2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ba5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ba8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801bab:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801bae:	89 3c 24             	mov    %edi,(%esp)
  801bb1:	e8 0a f6 ff ff       	call   8011c0 <fd2data>
  801bb6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bb8:	be 00 00 00 00       	mov    $0x0,%esi
  801bbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bc1:	75 47                	jne    801c0a <devpipe_read+0x6e>
  801bc3:	eb 52                	jmp    801c17 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801bc5:	89 f0                	mov    %esi,%eax
  801bc7:	eb 5e                	jmp    801c27 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801bc9:	89 da                	mov    %ebx,%edx
  801bcb:	89 f8                	mov    %edi,%eax
  801bcd:	8d 76 00             	lea    0x0(%esi),%esi
  801bd0:	e8 cd fe ff ff       	call   801aa2 <_pipeisclosed>
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	75 49                	jne    801c22 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801bd9:	e8 ce f2 ff ff       	call   800eac <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801bde:	8b 03                	mov    (%ebx),%eax
  801be0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801be3:	74 e4                	je     801bc9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801be5:	89 c2                	mov    %eax,%edx
  801be7:	c1 fa 1f             	sar    $0x1f,%edx
  801bea:	c1 ea 1b             	shr    $0x1b,%edx
  801bed:	01 d0                	add    %edx,%eax
  801bef:	83 e0 1f             	and    $0x1f,%eax
  801bf2:	29 d0                	sub    %edx,%eax
  801bf4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801bff:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c02:	83 c6 01             	add    $0x1,%esi
  801c05:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c08:	74 0d                	je     801c17 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801c0a:	8b 03                	mov    (%ebx),%eax
  801c0c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c0f:	75 d4                	jne    801be5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801c11:	85 f6                	test   %esi,%esi
  801c13:	75 b0                	jne    801bc5 <devpipe_read+0x29>
  801c15:	eb b2                	jmp    801bc9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801c17:	89 f0                	mov    %esi,%eax
  801c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c20:	eb 05                	jmp    801c27 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c22:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801c27:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c2a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c2d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c30:	89 ec                	mov    %ebp,%esp
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    

00801c34 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 48             	sub    $0x48,%esp
  801c3a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801c3d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801c40:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801c43:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c46:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801c49:	89 04 24             	mov    %eax,(%esp)
  801c4c:	e8 8a f5 ff ff       	call   8011db <fd_alloc>
  801c51:	89 c3                	mov    %eax,%ebx
  801c53:	85 c0                	test   %eax,%eax
  801c55:	0f 88 45 01 00 00    	js     801da0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c5b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c62:	00 
  801c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c66:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c71:	e8 66 f2 ff ff       	call   800edc <sys_page_alloc>
  801c76:	89 c3                	mov    %eax,%ebx
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	0f 88 20 01 00 00    	js     801da0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801c80:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801c83:	89 04 24             	mov    %eax,(%esp)
  801c86:	e8 50 f5 ff ff       	call   8011db <fd_alloc>
  801c8b:	89 c3                	mov    %eax,%ebx
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	0f 88 f8 00 00 00    	js     801d8d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c95:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c9c:	00 
  801c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cab:	e8 2c f2 ff ff       	call   800edc <sys_page_alloc>
  801cb0:	89 c3                	mov    %eax,%ebx
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	0f 88 d3 00 00 00    	js     801d8d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801cba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cbd:	89 04 24             	mov    %eax,(%esp)
  801cc0:	e8 fb f4 ff ff       	call   8011c0 <fd2data>
  801cc5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801cce:	00 
  801ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cda:	e8 fd f1 ff ff       	call   800edc <sys_page_alloc>
  801cdf:	89 c3                	mov    %eax,%ebx
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	0f 88 91 00 00 00    	js     801d7a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cec:	89 04 24             	mov    %eax,(%esp)
  801cef:	e8 cc f4 ff ff       	call   8011c0 <fd2data>
  801cf4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801cfb:	00 
  801cfc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d00:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d07:	00 
  801d08:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d0c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d13:	e8 23 f2 ff ff       	call   800f3b <sys_page_map>
  801d18:	89 c3                	mov    %eax,%ebx
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	78 4c                	js     801d6a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d1e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d27:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d33:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d3c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d41:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d4b:	89 04 24             	mov    %eax,(%esp)
  801d4e:	e8 5d f4 ff ff       	call   8011b0 <fd2num>
  801d53:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d58:	89 04 24             	mov    %eax,(%esp)
  801d5b:	e8 50 f4 ff ff       	call   8011b0 <fd2num>
  801d60:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801d63:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d68:	eb 36                	jmp    801da0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  801d6a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d75:	e8 1f f2 ff ff       	call   800f99 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801d7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d88:	e8 0c f2 ff ff       	call   800f99 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d9b:	e8 f9 f1 ff ff       	call   800f99 <sys_page_unmap>
    err:
	return r;
}
  801da0:	89 d8                	mov    %ebx,%eax
  801da2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801da5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801da8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801dab:	89 ec                	mov    %ebp,%esp
  801dad:	5d                   	pop    %ebp
  801dae:	c3                   	ret    

00801daf <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801db5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801db8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	89 04 24             	mov    %eax,(%esp)
  801dc2:	e8 87 f4 ff ff       	call   80124e <fd_lookup>
  801dc7:	85 c0                	test   %eax,%eax
  801dc9:	78 15                	js     801de0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dce:	89 04 24             	mov    %eax,(%esp)
  801dd1:	e8 ea f3 ff ff       	call   8011c0 <fd2data>
	return _pipeisclosed(fd, p);
  801dd6:	89 c2                	mov    %eax,%edx
  801dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddb:	e8 c2 fc ff ff       	call   801aa2 <_pipeisclosed>
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    
	...

00801df0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801df3:	b8 00 00 00 00       	mov    $0x0,%eax
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    

00801dfa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801e00:	c7 44 24 04 8e 28 80 	movl   $0x80288e,0x4(%esp)
  801e07:	00 
  801e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0b:	89 04 24             	mov    %eax,(%esp)
  801e0e:	e8 c8 eb ff ff       	call   8009db <strcpy>
	return 0;
}
  801e13:	b8 00 00 00 00       	mov    $0x0,%eax
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	57                   	push   %edi
  801e1e:	56                   	push   %esi
  801e1f:	53                   	push   %ebx
  801e20:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e26:	be 00 00 00 00       	mov    $0x0,%esi
  801e2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2f:	74 43                	je     801e74 <devcons_write+0x5a>
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e36:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e3f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801e41:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e44:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801e49:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e4c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e50:	03 45 0c             	add    0xc(%ebp),%eax
  801e53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e57:	89 3c 24             	mov    %edi,(%esp)
  801e5a:	e8 6d ed ff ff       	call   800bcc <memmove>
		sys_cputs(buf, m);
  801e5f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e63:	89 3c 24             	mov    %edi,(%esp)
  801e66:	e8 55 ef ff ff       	call   800dc0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e6b:	01 de                	add    %ebx,%esi
  801e6d:	89 f0                	mov    %esi,%eax
  801e6f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e72:	72 c8                	jb     801e3c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801e74:	89 f0                	mov    %esi,%eax
  801e76:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801e7c:	5b                   	pop    %ebx
  801e7d:	5e                   	pop    %esi
  801e7e:	5f                   	pop    %edi
  801e7f:	5d                   	pop    %ebp
  801e80:	c3                   	ret    

00801e81 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801e8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e90:	75 07                	jne    801e99 <devcons_read+0x18>
  801e92:	eb 31                	jmp    801ec5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801e94:	e8 13 f0 ff ff       	call   800eac <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ea0:	e8 4a ef ff ff       	call   800def <sys_cgetc>
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	74 eb                	je     801e94 <devcons_read+0x13>
  801ea9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801eab:	85 c0                	test   %eax,%eax
  801ead:	78 16                	js     801ec5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801eaf:	83 f8 04             	cmp    $0x4,%eax
  801eb2:	74 0c                	je     801ec0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb7:	88 10                	mov    %dl,(%eax)
	return 1;
  801eb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebe:	eb 05                	jmp    801ec5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801ec0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801ed3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801eda:	00 
  801edb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ede:	89 04 24             	mov    %eax,(%esp)
  801ee1:	e8 da ee ff ff       	call   800dc0 <sys_cputs>
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <getchar>:

int
getchar(void)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801eee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801ef5:	00 
  801ef6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f04:	e8 05 f6 ff ff       	call   80150e <read>
	if (r < 0)
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	78 0f                	js     801f1c <getchar+0x34>
		return r;
	if (r < 1)
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	7e 06                	jle    801f17 <getchar+0x2f>
		return -E_EOF;
	return c;
  801f11:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801f15:	eb 05                	jmp    801f1c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801f17:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	89 04 24             	mov    %eax,(%esp)
  801f31:	e8 18 f3 ff ff       	call   80124e <fd_lookup>
  801f36:	85 c0                	test   %eax,%eax
  801f38:	78 11                	js     801f4b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f43:	39 10                	cmp    %edx,(%eax)
  801f45:	0f 94 c0             	sete   %al
  801f48:	0f b6 c0             	movzbl %al,%eax
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <opencons>:

int
opencons(void)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f56:	89 04 24             	mov    %eax,(%esp)
  801f59:	e8 7d f2 ff ff       	call   8011db <fd_alloc>
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	78 3c                	js     801f9e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f62:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f69:	00 
  801f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f78:	e8 5f ef ff ff       	call   800edc <sys_page_alloc>
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	78 1d                	js     801f9e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801f81:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f96:	89 04 24             	mov    %eax,(%esp)
  801f99:	e8 12 f2 ff ff       	call   8011b0 <fd2num>
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	56                   	push   %esi
  801fa4:	53                   	push   %ebx
  801fa5:	83 ec 10             	sub    $0x10,%esp
  801fa8:	8b 75 08             	mov    0x8(%ebp),%esi
  801fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801fb1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801fb3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fb8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801fbb:	89 04 24             	mov    %eax,(%esp)
  801fbe:	e8 82 f1 ff ff       	call   801145 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801fc3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801fc8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	78 0e                	js     801fdf <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801fd1:	a1 04 40 80 00       	mov    0x804004,%eax
  801fd6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801fd9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801fdc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801fdf:	85 f6                	test   %esi,%esi
  801fe1:	74 02                	je     801fe5 <ipc_recv+0x45>
		*from_env_store = sender;
  801fe3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801fe5:	85 db                	test   %ebx,%ebx
  801fe7:	74 02                	je     801feb <ipc_recv+0x4b>
		*perm_store = perm;
  801fe9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801feb:	83 c4 10             	add    $0x10,%esp
  801fee:	5b                   	pop    %ebx
  801fef:	5e                   	pop    %esi
  801ff0:	5d                   	pop    %ebp
  801ff1:	c3                   	ret    

00801ff2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	57                   	push   %edi
  801ff6:	56                   	push   %esi
  801ff7:	53                   	push   %ebx
  801ff8:	83 ec 1c             	sub    $0x1c,%esp
  801ffb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ffe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802001:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  802004:	85 db                	test   %ebx,%ebx
  802006:	75 04                	jne    80200c <ipc_send+0x1a>
  802008:	85 f6                	test   %esi,%esi
  80200a:	75 15                	jne    802021 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  80200c:	85 db                	test   %ebx,%ebx
  80200e:	74 16                	je     802026 <ipc_send+0x34>
  802010:	85 f6                	test   %esi,%esi
  802012:	0f 94 c0             	sete   %al
      pg = 0;
  802015:	84 c0                	test   %al,%al
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
  80201c:	0f 45 d8             	cmovne %eax,%ebx
  80201f:	eb 05                	jmp    802026 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  802021:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  802026:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80202a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80202e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	89 04 24             	mov    %eax,(%esp)
  802038:	e8 d4 f0 ff ff       	call   801111 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80203d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802040:	75 07                	jne    802049 <ipc_send+0x57>
           sys_yield();
  802042:	e8 65 ee ff ff       	call   800eac <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  802047:	eb dd                	jmp    802026 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  802049:	85 c0                	test   %eax,%eax
  80204b:	90                   	nop
  80204c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802050:	74 1c                	je     80206e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802052:	c7 44 24 08 9a 28 80 	movl   $0x80289a,0x8(%esp)
  802059:	00 
  80205a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802061:	00 
  802062:	c7 04 24 a4 28 80 00 	movl   $0x8028a4,(%esp)
  802069:	e8 4e e2 ff ff       	call   8002bc <_panic>
		}
    }
}
  80206e:	83 c4 1c             	add    $0x1c,%esp
  802071:	5b                   	pop    %ebx
  802072:	5e                   	pop    %esi
  802073:	5f                   	pop    %edi
  802074:	5d                   	pop    %ebp
  802075:	c3                   	ret    

00802076 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80207c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802081:	39 c8                	cmp    %ecx,%eax
  802083:	74 17                	je     80209c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802085:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80208a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80208d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802093:	8b 52 50             	mov    0x50(%edx),%edx
  802096:	39 ca                	cmp    %ecx,%edx
  802098:	75 14                	jne    8020ae <ipc_find_env+0x38>
  80209a:	eb 05                	jmp    8020a1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80209c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8020a1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020a4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8020a9:	8b 40 40             	mov    0x40(%eax),%eax
  8020ac:	eb 0e                	jmp    8020bc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8020ae:	83 c0 01             	add    $0x1,%eax
  8020b1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020b6:	75 d2                	jne    80208a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8020b8:	66 b8 00 00          	mov    $0x0,%ax
}
  8020bc:	5d                   	pop    %ebp
  8020bd:	c3                   	ret    
	...

008020c0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020c6:	89 d0                	mov    %edx,%eax
  8020c8:	c1 e8 16             	shr    $0x16,%eax
  8020cb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020d7:	f6 c1 01             	test   $0x1,%cl
  8020da:	74 1d                	je     8020f9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8020dc:	c1 ea 0c             	shr    $0xc,%edx
  8020df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020e6:	f6 c2 01             	test   $0x1,%dl
  8020e9:	74 0e                	je     8020f9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020eb:	c1 ea 0c             	shr    $0xc,%edx
  8020ee:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020f5:	ef 
  8020f6:	0f b7 c0             	movzwl %ax,%eax
}
  8020f9:	5d                   	pop    %ebp
  8020fa:	c3                   	ret    
  8020fb:	00 00                	add    %al,(%eax)
  8020fd:	00 00                	add    %al,(%eax)
	...

00802100 <__udivdi3>:
  802100:	83 ec 1c             	sub    $0x1c,%esp
  802103:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802107:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80210b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80210f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802113:	89 74 24 10          	mov    %esi,0x10(%esp)
  802117:	8b 74 24 24          	mov    0x24(%esp),%esi
  80211b:	85 ff                	test   %edi,%edi
  80211d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802121:	89 44 24 08          	mov    %eax,0x8(%esp)
  802125:	89 cd                	mov    %ecx,%ebp
  802127:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212b:	75 33                	jne    802160 <__udivdi3+0x60>
  80212d:	39 f1                	cmp    %esi,%ecx
  80212f:	77 57                	ja     802188 <__udivdi3+0x88>
  802131:	85 c9                	test   %ecx,%ecx
  802133:	75 0b                	jne    802140 <__udivdi3+0x40>
  802135:	b8 01 00 00 00       	mov    $0x1,%eax
  80213a:	31 d2                	xor    %edx,%edx
  80213c:	f7 f1                	div    %ecx
  80213e:	89 c1                	mov    %eax,%ecx
  802140:	89 f0                	mov    %esi,%eax
  802142:	31 d2                	xor    %edx,%edx
  802144:	f7 f1                	div    %ecx
  802146:	89 c6                	mov    %eax,%esi
  802148:	8b 44 24 04          	mov    0x4(%esp),%eax
  80214c:	f7 f1                	div    %ecx
  80214e:	89 f2                	mov    %esi,%edx
  802150:	8b 74 24 10          	mov    0x10(%esp),%esi
  802154:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802158:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80215c:	83 c4 1c             	add    $0x1c,%esp
  80215f:	c3                   	ret    
  802160:	31 d2                	xor    %edx,%edx
  802162:	31 c0                	xor    %eax,%eax
  802164:	39 f7                	cmp    %esi,%edi
  802166:	77 e8                	ja     802150 <__udivdi3+0x50>
  802168:	0f bd cf             	bsr    %edi,%ecx
  80216b:	83 f1 1f             	xor    $0x1f,%ecx
  80216e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802172:	75 2c                	jne    8021a0 <__udivdi3+0xa0>
  802174:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802178:	76 04                	jbe    80217e <__udivdi3+0x7e>
  80217a:	39 f7                	cmp    %esi,%edi
  80217c:	73 d2                	jae    802150 <__udivdi3+0x50>
  80217e:	31 d2                	xor    %edx,%edx
  802180:	b8 01 00 00 00       	mov    $0x1,%eax
  802185:	eb c9                	jmp    802150 <__udivdi3+0x50>
  802187:	90                   	nop
  802188:	89 f2                	mov    %esi,%edx
  80218a:	f7 f1                	div    %ecx
  80218c:	31 d2                	xor    %edx,%edx
  80218e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802192:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802196:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80219a:	83 c4 1c             	add    $0x1c,%esp
  80219d:	c3                   	ret    
  80219e:	66 90                	xchg   %ax,%ax
  8021a0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021a5:	b8 20 00 00 00       	mov    $0x20,%eax
  8021aa:	89 ea                	mov    %ebp,%edx
  8021ac:	2b 44 24 04          	sub    0x4(%esp),%eax
  8021b0:	d3 e7                	shl    %cl,%edi
  8021b2:	89 c1                	mov    %eax,%ecx
  8021b4:	d3 ea                	shr    %cl,%edx
  8021b6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021bb:	09 fa                	or     %edi,%edx
  8021bd:	89 f7                	mov    %esi,%edi
  8021bf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021c3:	89 f2                	mov    %esi,%edx
  8021c5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8021c9:	d3 e5                	shl    %cl,%ebp
  8021cb:	89 c1                	mov    %eax,%ecx
  8021cd:	d3 ef                	shr    %cl,%edi
  8021cf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021d4:	d3 e2                	shl    %cl,%edx
  8021d6:	89 c1                	mov    %eax,%ecx
  8021d8:	d3 ee                	shr    %cl,%esi
  8021da:	09 d6                	or     %edx,%esi
  8021dc:	89 fa                	mov    %edi,%edx
  8021de:	89 f0                	mov    %esi,%eax
  8021e0:	f7 74 24 0c          	divl   0xc(%esp)
  8021e4:	89 d7                	mov    %edx,%edi
  8021e6:	89 c6                	mov    %eax,%esi
  8021e8:	f7 e5                	mul    %ebp
  8021ea:	39 d7                	cmp    %edx,%edi
  8021ec:	72 22                	jb     802210 <__udivdi3+0x110>
  8021ee:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8021f2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021f7:	d3 e5                	shl    %cl,%ebp
  8021f9:	39 c5                	cmp    %eax,%ebp
  8021fb:	73 04                	jae    802201 <__udivdi3+0x101>
  8021fd:	39 d7                	cmp    %edx,%edi
  8021ff:	74 0f                	je     802210 <__udivdi3+0x110>
  802201:	89 f0                	mov    %esi,%eax
  802203:	31 d2                	xor    %edx,%edx
  802205:	e9 46 ff ff ff       	jmp    802150 <__udivdi3+0x50>
  80220a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802210:	8d 46 ff             	lea    -0x1(%esi),%eax
  802213:	31 d2                	xor    %edx,%edx
  802215:	8b 74 24 10          	mov    0x10(%esp),%esi
  802219:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80221d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802221:	83 c4 1c             	add    $0x1c,%esp
  802224:	c3                   	ret    
	...

00802230 <__umoddi3>:
  802230:	83 ec 1c             	sub    $0x1c,%esp
  802233:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802237:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80223b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80223f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802243:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802247:	8b 74 24 24          	mov    0x24(%esp),%esi
  80224b:	85 ed                	test   %ebp,%ebp
  80224d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802251:	89 44 24 08          	mov    %eax,0x8(%esp)
  802255:	89 cf                	mov    %ecx,%edi
  802257:	89 04 24             	mov    %eax,(%esp)
  80225a:	89 f2                	mov    %esi,%edx
  80225c:	75 1a                	jne    802278 <__umoddi3+0x48>
  80225e:	39 f1                	cmp    %esi,%ecx
  802260:	76 4e                	jbe    8022b0 <__umoddi3+0x80>
  802262:	f7 f1                	div    %ecx
  802264:	89 d0                	mov    %edx,%eax
  802266:	31 d2                	xor    %edx,%edx
  802268:	8b 74 24 10          	mov    0x10(%esp),%esi
  80226c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802270:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802274:	83 c4 1c             	add    $0x1c,%esp
  802277:	c3                   	ret    
  802278:	39 f5                	cmp    %esi,%ebp
  80227a:	77 54                	ja     8022d0 <__umoddi3+0xa0>
  80227c:	0f bd c5             	bsr    %ebp,%eax
  80227f:	83 f0 1f             	xor    $0x1f,%eax
  802282:	89 44 24 04          	mov    %eax,0x4(%esp)
  802286:	75 60                	jne    8022e8 <__umoddi3+0xb8>
  802288:	3b 0c 24             	cmp    (%esp),%ecx
  80228b:	0f 87 07 01 00 00    	ja     802398 <__umoddi3+0x168>
  802291:	89 f2                	mov    %esi,%edx
  802293:	8b 34 24             	mov    (%esp),%esi
  802296:	29 ce                	sub    %ecx,%esi
  802298:	19 ea                	sbb    %ebp,%edx
  80229a:	89 34 24             	mov    %esi,(%esp)
  80229d:	8b 04 24             	mov    (%esp),%eax
  8022a0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8022a4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8022a8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8022ac:	83 c4 1c             	add    $0x1c,%esp
  8022af:	c3                   	ret    
  8022b0:	85 c9                	test   %ecx,%ecx
  8022b2:	75 0b                	jne    8022bf <__umoddi3+0x8f>
  8022b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b9:	31 d2                	xor    %edx,%edx
  8022bb:	f7 f1                	div    %ecx
  8022bd:	89 c1                	mov    %eax,%ecx
  8022bf:	89 f0                	mov    %esi,%eax
  8022c1:	31 d2                	xor    %edx,%edx
  8022c3:	f7 f1                	div    %ecx
  8022c5:	8b 04 24             	mov    (%esp),%eax
  8022c8:	f7 f1                	div    %ecx
  8022ca:	eb 98                	jmp    802264 <__umoddi3+0x34>
  8022cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	89 f2                	mov    %esi,%edx
  8022d2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8022d6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8022da:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8022de:	83 c4 1c             	add    $0x1c,%esp
  8022e1:	c3                   	ret    
  8022e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022e8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022ed:	89 e8                	mov    %ebp,%eax
  8022ef:	bd 20 00 00 00       	mov    $0x20,%ebp
  8022f4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8022f8:	89 fa                	mov    %edi,%edx
  8022fa:	d3 e0                	shl    %cl,%eax
  8022fc:	89 e9                	mov    %ebp,%ecx
  8022fe:	d3 ea                	shr    %cl,%edx
  802300:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802305:	09 c2                	or     %eax,%edx
  802307:	8b 44 24 08          	mov    0x8(%esp),%eax
  80230b:	89 14 24             	mov    %edx,(%esp)
  80230e:	89 f2                	mov    %esi,%edx
  802310:	d3 e7                	shl    %cl,%edi
  802312:	89 e9                	mov    %ebp,%ecx
  802314:	d3 ea                	shr    %cl,%edx
  802316:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80231b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80231f:	d3 e6                	shl    %cl,%esi
  802321:	89 e9                	mov    %ebp,%ecx
  802323:	d3 e8                	shr    %cl,%eax
  802325:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80232a:	09 f0                	or     %esi,%eax
  80232c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802330:	f7 34 24             	divl   (%esp)
  802333:	d3 e6                	shl    %cl,%esi
  802335:	89 74 24 08          	mov    %esi,0x8(%esp)
  802339:	89 d6                	mov    %edx,%esi
  80233b:	f7 e7                	mul    %edi
  80233d:	39 d6                	cmp    %edx,%esi
  80233f:	89 c1                	mov    %eax,%ecx
  802341:	89 d7                	mov    %edx,%edi
  802343:	72 3f                	jb     802384 <__umoddi3+0x154>
  802345:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802349:	72 35                	jb     802380 <__umoddi3+0x150>
  80234b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80234f:	29 c8                	sub    %ecx,%eax
  802351:	19 fe                	sbb    %edi,%esi
  802353:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802358:	89 f2                	mov    %esi,%edx
  80235a:	d3 e8                	shr    %cl,%eax
  80235c:	89 e9                	mov    %ebp,%ecx
  80235e:	d3 e2                	shl    %cl,%edx
  802360:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802365:	09 d0                	or     %edx,%eax
  802367:	89 f2                	mov    %esi,%edx
  802369:	d3 ea                	shr    %cl,%edx
  80236b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80236f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802373:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802377:	83 c4 1c             	add    $0x1c,%esp
  80237a:	c3                   	ret    
  80237b:	90                   	nop
  80237c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802380:	39 d6                	cmp    %edx,%esi
  802382:	75 c7                	jne    80234b <__umoddi3+0x11b>
  802384:	89 d7                	mov    %edx,%edi
  802386:	89 c1                	mov    %eax,%ecx
  802388:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80238c:	1b 3c 24             	sbb    (%esp),%edi
  80238f:	eb ba                	jmp    80234b <__umoddi3+0x11b>
  802391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802398:	39 f5                	cmp    %esi,%ebp
  80239a:	0f 82 f1 fe ff ff    	jb     802291 <__umoddi3+0x61>
  8023a0:	e9 f8 fe ff ff       	jmp    80229d <__umoddi3+0x6d>
