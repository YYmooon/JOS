
obj/user/idle.debug:     file format elf32-i386


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
  80002c:	e8 1b 00 00 00       	call   80004c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  80003a:	c7 05 00 30 80 00 a0 	movl   $0x8021a0,0x803000
  800041:	21 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800044:	e8 5b 01 00 00       	call   8001a4 <sys_yield>
  800049:	eb f9                	jmp    800044 <umain+0x10>
	...

0080004c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004c:	55                   	push   %ebp
  80004d:	89 e5                	mov    %esp,%ebp
  80004f:	83 ec 18             	sub    $0x18,%esp
  800052:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800055:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800058:	8b 75 08             	mov    0x8(%ebp),%esi
  80005b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80005e:	e8 11 01 00 00       	call   800174 <sys_getenvid>
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800075:	85 f6                	test   %esi,%esi
  800077:	7e 07                	jle    800080 <libmain+0x34>
		binaryname = argv[0];
  800079:	8b 03                	mov    (%ebx),%eax
  80007b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800080:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800084:	89 34 24             	mov    %esi,(%esp)
  800087:	e8 a8 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80008c:	e8 0b 00 00 00       	call   80009c <exit>
}
  800091:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800094:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800097:	89 ec                	mov    %ebp,%esp
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
	...

0080009c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009c:	55                   	push   %ebp
  80009d:	89 e5                	mov    %esp,%ebp
  80009f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000a2:	e8 17 06 00 00       	call   8006be <close_all>
	sys_env_destroy(0);
  8000a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ae:	e8 64 00 00 00       	call   800117 <sys_env_destroy>
}
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    
  8000b5:	00 00                	add    %al,(%eax)
	...

008000b8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8000c1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8000c4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d2:	89 c3                	mov    %eax,%ebx
  8000d4:	89 c7                	mov    %eax,%edi
  8000d6:	89 c6                	mov    %eax,%esi
  8000d8:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000da:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8000dd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8000e0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8000e3:	89 ec                	mov    %ebp,%esp
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8000f0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8000f3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000fb:	b8 01 00 00 00       	mov    $0x1,%eax
  800100:	89 d1                	mov    %edx,%ecx
  800102:	89 d3                	mov    %edx,%ebx
  800104:	89 d7                	mov    %edx,%edi
  800106:	89 d6                	mov    %edx,%esi
  800108:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80010a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80010d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800110:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800113:	89 ec                	mov    %ebp,%esp
  800115:	5d                   	pop    %ebp
  800116:	c3                   	ret    

00800117 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	83 ec 38             	sub    $0x38,%esp
  80011d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800120:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800123:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800126:	b9 00 00 00 00       	mov    $0x0,%ecx
  80012b:	b8 03 00 00 00       	mov    $0x3,%eax
  800130:	8b 55 08             	mov    0x8(%ebp),%edx
  800133:	89 cb                	mov    %ecx,%ebx
  800135:	89 cf                	mov    %ecx,%edi
  800137:	89 ce                	mov    %ecx,%esi
  800139:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80013b:	85 c0                	test   %eax,%eax
  80013d:	7e 28                	jle    800167 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80013f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800143:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80014a:	00 
  80014b:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  800152:	00 
  800153:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80015a:	00 
  80015b:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  800162:	e8 29 11 00 00       	call   801290 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800167:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80016a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80016d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800170:	89 ec                	mov    %ebp,%esp
  800172:	5d                   	pop    %ebp
  800173:	c3                   	ret    

00800174 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80017d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800180:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800183:	ba 00 00 00 00       	mov    $0x0,%edx
  800188:	b8 02 00 00 00       	mov    $0x2,%eax
  80018d:	89 d1                	mov    %edx,%ecx
  80018f:	89 d3                	mov    %edx,%ebx
  800191:	89 d7                	mov    %edx,%edi
  800193:	89 d6                	mov    %edx,%esi
  800195:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800197:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80019a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80019d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001a0:	89 ec                	mov    %ebp,%esp
  8001a2:	5d                   	pop    %ebp
  8001a3:	c3                   	ret    

008001a4 <sys_yield>:

void
sys_yield(void)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001ad:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001b0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b8:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001bd:	89 d1                	mov    %edx,%ecx
  8001bf:	89 d3                	mov    %edx,%ebx
  8001c1:	89 d7                	mov    %edx,%edi
  8001c3:	89 d6                	mov    %edx,%esi
  8001c5:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001c7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001ca:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001cd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001d0:	89 ec                	mov    %ebp,%esp
  8001d2:	5d                   	pop    %ebp
  8001d3:	c3                   	ret    

008001d4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	83 ec 38             	sub    $0x38,%esp
  8001da:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001dd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001e0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001e3:	be 00 00 00 00       	mov    $0x0,%esi
  8001e8:	b8 04 00 00 00       	mov    $0x4,%eax
  8001ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f6:	89 f7                	mov    %esi,%edi
  8001f8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	7e 28                	jle    800226 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fe:	89 44 24 10          	mov    %eax,0x10(%esp)
  800202:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800209:	00 
  80020a:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  800211:	00 
  800212:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800219:	00 
  80021a:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  800221:	e8 6a 10 00 00       	call   801290 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800226:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800229:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80022c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80022f:	89 ec                	mov    %ebp,%esp
  800231:	5d                   	pop    %ebp
  800232:	c3                   	ret    

00800233 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 38             	sub    $0x38,%esp
  800239:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80023c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80023f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800242:	b8 05 00 00 00       	mov    $0x5,%eax
  800247:	8b 75 18             	mov    0x18(%ebp),%esi
  80024a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80024d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800250:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800253:	8b 55 08             	mov    0x8(%ebp),%edx
  800256:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800258:	85 c0                	test   %eax,%eax
  80025a:	7e 28                	jle    800284 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80025c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800260:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800267:	00 
  800268:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  80026f:	00 
  800270:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800277:	00 
  800278:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  80027f:	e8 0c 10 00 00       	call   801290 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800284:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800287:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80028a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80028d:	89 ec                	mov    %ebp,%esp
  80028f:	5d                   	pop    %ebp
  800290:	c3                   	ret    

00800291 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	83 ec 38             	sub    $0x38,%esp
  800297:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80029a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80029d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a5:	b8 06 00 00 00       	mov    $0x6,%eax
  8002aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b0:	89 df                	mov    %ebx,%edi
  8002b2:	89 de                	mov    %ebx,%esi
  8002b4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002b6:	85 c0                	test   %eax,%eax
  8002b8:	7e 28                	jle    8002e2 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002be:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8002c5:	00 
  8002c6:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  8002cd:	00 
  8002ce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002d5:	00 
  8002d6:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  8002dd:	e8 ae 0f 00 00       	call   801290 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8002e2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002e5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002eb:	89 ec                	mov    %ebp,%esp
  8002ed:	5d                   	pop    %ebp
  8002ee:	c3                   	ret    

008002ef <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 38             	sub    $0x38,%esp
  8002f5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002f8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002fb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800303:	b8 08 00 00 00       	mov    $0x8,%eax
  800308:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80030b:	8b 55 08             	mov    0x8(%ebp),%edx
  80030e:	89 df                	mov    %ebx,%edi
  800310:	89 de                	mov    %ebx,%esi
  800312:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800314:	85 c0                	test   %eax,%eax
  800316:	7e 28                	jle    800340 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800318:	89 44 24 10          	mov    %eax,0x10(%esp)
  80031c:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800323:	00 
  800324:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  80032b:	00 
  80032c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800333:	00 
  800334:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  80033b:	e8 50 0f 00 00       	call   801290 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800340:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800343:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800346:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800349:	89 ec                	mov    %ebp,%esp
  80034b:	5d                   	pop    %ebp
  80034c:	c3                   	ret    

0080034d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	83 ec 38             	sub    $0x38,%esp
  800353:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800356:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800359:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80035c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800361:	b8 09 00 00 00       	mov    $0x9,%eax
  800366:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800369:	8b 55 08             	mov    0x8(%ebp),%edx
  80036c:	89 df                	mov    %ebx,%edi
  80036e:	89 de                	mov    %ebx,%esi
  800370:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800372:	85 c0                	test   %eax,%eax
  800374:	7e 28                	jle    80039e <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800376:	89 44 24 10          	mov    %eax,0x10(%esp)
  80037a:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800381:	00 
  800382:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  800389:	00 
  80038a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800391:	00 
  800392:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  800399:	e8 f2 0e 00 00       	call   801290 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80039e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003a1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003a7:	89 ec                	mov    %ebp,%esp
  8003a9:	5d                   	pop    %ebp
  8003aa:	c3                   	ret    

008003ab <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	83 ec 38             	sub    $0x38,%esp
  8003b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8003c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ca:	89 df                	mov    %ebx,%edi
  8003cc:	89 de                	mov    %ebx,%esi
  8003ce:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003d0:	85 c0                	test   %eax,%eax
  8003d2:	7e 28                	jle    8003fc <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003d4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003d8:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8003df:	00 
  8003e0:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  8003e7:	00 
  8003e8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003ef:	00 
  8003f0:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  8003f7:	e8 94 0e 00 00       	call   801290 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8003fc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003ff:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800402:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800405:	89 ec                	mov    %ebp,%esp
  800407:	5d                   	pop    %ebp
  800408:	c3                   	ret    

00800409 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 0c             	sub    $0xc,%esp
  80040f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800412:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800415:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800418:	be 00 00 00 00       	mov    $0x0,%esi
  80041d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800422:	8b 7d 14             	mov    0x14(%ebp),%edi
  800425:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800428:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80042b:	8b 55 08             	mov    0x8(%ebp),%edx
  80042e:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800430:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800433:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800436:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800439:	89 ec                	mov    %ebp,%esp
  80043b:	5d                   	pop    %ebp
  80043c:	c3                   	ret    

0080043d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	83 ec 38             	sub    $0x38,%esp
  800443:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800446:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800449:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80044c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800451:	b8 0d 00 00 00       	mov    $0xd,%eax
  800456:	8b 55 08             	mov    0x8(%ebp),%edx
  800459:	89 cb                	mov    %ecx,%ebx
  80045b:	89 cf                	mov    %ecx,%edi
  80045d:	89 ce                	mov    %ecx,%esi
  80045f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800461:	85 c0                	test   %eax,%eax
  800463:	7e 28                	jle    80048d <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800465:	89 44 24 10          	mov    %eax,0x10(%esp)
  800469:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800470:	00 
  800471:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  800478:	00 
  800479:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800480:	00 
  800481:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  800488:	e8 03 0e 00 00       	call   801290 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80048d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800490:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800493:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800496:	89 ec                	mov    %ebp,%esp
  800498:	5d                   	pop    %ebp
  800499:	c3                   	ret    
  80049a:	00 00                	add    %al,(%eax)
  80049c:	00 00                	add    %al,(%eax)
	...

008004a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8004ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8004ae:	5d                   	pop    %ebp
  8004af:	c3                   	ret    

008004b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	89 04 24             	mov    %eax,(%esp)
  8004bc:	e8 df ff ff ff       	call   8004a0 <fd2num>
  8004c1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8004c6:	c1 e0 0c             	shl    $0xc,%eax
}
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	53                   	push   %ebx
  8004cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8004d2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8004d7:	a8 01                	test   $0x1,%al
  8004d9:	74 34                	je     80050f <fd_alloc+0x44>
  8004db:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8004e0:	a8 01                	test   $0x1,%al
  8004e2:	74 32                	je     800516 <fd_alloc+0x4b>
  8004e4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8004e9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8004eb:	89 c2                	mov    %eax,%edx
  8004ed:	c1 ea 16             	shr    $0x16,%edx
  8004f0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004f7:	f6 c2 01             	test   $0x1,%dl
  8004fa:	74 1f                	je     80051b <fd_alloc+0x50>
  8004fc:	89 c2                	mov    %eax,%edx
  8004fe:	c1 ea 0c             	shr    $0xc,%edx
  800501:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800508:	f6 c2 01             	test   $0x1,%dl
  80050b:	75 17                	jne    800524 <fd_alloc+0x59>
  80050d:	eb 0c                	jmp    80051b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80050f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800514:	eb 05                	jmp    80051b <fd_alloc+0x50>
  800516:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80051b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80051d:	b8 00 00 00 00       	mov    $0x0,%eax
  800522:	eb 17                	jmp    80053b <fd_alloc+0x70>
  800524:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800529:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80052e:	75 b9                	jne    8004e9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800530:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  800536:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80053b:	5b                   	pop    %ebx
  80053c:	5d                   	pop    %ebp
  80053d:	c3                   	ret    

0080053e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80053e:	55                   	push   %ebp
  80053f:	89 e5                	mov    %esp,%ebp
  800541:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800544:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800549:	83 fa 1f             	cmp    $0x1f,%edx
  80054c:	77 3f                	ja     80058d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80054e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  800554:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800557:	89 d0                	mov    %edx,%eax
  800559:	c1 e8 16             	shr    $0x16,%eax
  80055c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800563:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800568:	f6 c1 01             	test   $0x1,%cl
  80056b:	74 20                	je     80058d <fd_lookup+0x4f>
  80056d:	89 d0                	mov    %edx,%eax
  80056f:	c1 e8 0c             	shr    $0xc,%eax
  800572:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800579:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80057e:	f6 c1 01             	test   $0x1,%cl
  800581:	74 0a                	je     80058d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	89 10                	mov    %edx,(%eax)
	return 0;
  800588:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80058d:	5d                   	pop    %ebp
  80058e:	c3                   	ret    

0080058f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
  800592:	53                   	push   %ebx
  800593:	83 ec 14             	sub    $0x14,%esp
  800596:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800599:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80059c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8005a1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8005a7:	75 17                	jne    8005c0 <dev_lookup+0x31>
  8005a9:	eb 07                	jmp    8005b2 <dev_lookup+0x23>
  8005ab:	39 0a                	cmp    %ecx,(%edx)
  8005ad:	75 11                	jne    8005c0 <dev_lookup+0x31>
  8005af:	90                   	nop
  8005b0:	eb 05                	jmp    8005b7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005b2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8005b7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8005b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005be:	eb 35                	jmp    8005f5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005c0:	83 c0 01             	add    $0x1,%eax
  8005c3:	8b 14 85 58 22 80 00 	mov    0x802258(,%eax,4),%edx
  8005ca:	85 d2                	test   %edx,%edx
  8005cc:	75 dd                	jne    8005ab <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005ce:	a1 04 40 80 00       	mov    0x804004,%eax
  8005d3:	8b 40 48             	mov    0x48(%eax),%eax
  8005d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005de:	c7 04 24 dc 21 80 00 	movl   $0x8021dc,(%esp)
  8005e5:	e8 a1 0d 00 00       	call   80138b <cprintf>
	*dev = 0;
  8005ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8005f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8005f5:	83 c4 14             	add    $0x14,%esp
  8005f8:	5b                   	pop    %ebx
  8005f9:	5d                   	pop    %ebp
  8005fa:	c3                   	ret    

008005fb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8005fb:	55                   	push   %ebp
  8005fc:	89 e5                	mov    %esp,%ebp
  8005fe:	83 ec 38             	sub    $0x38,%esp
  800601:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800604:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800607:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80060a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80060d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800611:	89 3c 24             	mov    %edi,(%esp)
  800614:	e8 87 fe ff ff       	call   8004a0 <fd2num>
  800619:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80061c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800620:	89 04 24             	mov    %eax,(%esp)
  800623:	e8 16 ff ff ff       	call   80053e <fd_lookup>
  800628:	89 c3                	mov    %eax,%ebx
  80062a:	85 c0                	test   %eax,%eax
  80062c:	78 05                	js     800633 <fd_close+0x38>
	    || fd != fd2)
  80062e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  800631:	74 0e                	je     800641 <fd_close+0x46>
		return (must_exist ? r : 0);
  800633:	89 f0                	mov    %esi,%eax
  800635:	84 c0                	test   %al,%al
  800637:	b8 00 00 00 00       	mov    $0x0,%eax
  80063c:	0f 44 d8             	cmove  %eax,%ebx
  80063f:	eb 3d                	jmp    80067e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800641:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800644:	89 44 24 04          	mov    %eax,0x4(%esp)
  800648:	8b 07                	mov    (%edi),%eax
  80064a:	89 04 24             	mov    %eax,(%esp)
  80064d:	e8 3d ff ff ff       	call   80058f <dev_lookup>
  800652:	89 c3                	mov    %eax,%ebx
  800654:	85 c0                	test   %eax,%eax
  800656:	78 16                	js     80066e <fd_close+0x73>
		if (dev->dev_close)
  800658:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80065e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800663:	85 c0                	test   %eax,%eax
  800665:	74 07                	je     80066e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  800667:	89 3c 24             	mov    %edi,(%esp)
  80066a:	ff d0                	call   *%eax
  80066c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80066e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800672:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800679:	e8 13 fc ff ff       	call   800291 <sys_page_unmap>
	return r;
}
  80067e:	89 d8                	mov    %ebx,%eax
  800680:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800683:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800686:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800689:	89 ec                	mov    %ebp,%esp
  80068b:	5d                   	pop    %ebp
  80068c:	c3                   	ret    

0080068d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80068d:	55                   	push   %ebp
  80068e:	89 e5                	mov    %esp,%ebp
  800690:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800693:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800696:	89 44 24 04          	mov    %eax,0x4(%esp)
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	89 04 24             	mov    %eax,(%esp)
  8006a0:	e8 99 fe ff ff       	call   80053e <fd_lookup>
  8006a5:	85 c0                	test   %eax,%eax
  8006a7:	78 13                	js     8006bc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8006a9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8006b0:	00 
  8006b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b4:	89 04 24             	mov    %eax,(%esp)
  8006b7:	e8 3f ff ff ff       	call   8005fb <fd_close>
}
  8006bc:	c9                   	leave  
  8006bd:	c3                   	ret    

008006be <close_all>:

void
close_all(void)
{
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
  8006c1:	53                   	push   %ebx
  8006c2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006c5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006ca:	89 1c 24             	mov    %ebx,(%esp)
  8006cd:	e8 bb ff ff ff       	call   80068d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006d2:	83 c3 01             	add    $0x1,%ebx
  8006d5:	83 fb 20             	cmp    $0x20,%ebx
  8006d8:	75 f0                	jne    8006ca <close_all+0xc>
		close(i);
}
  8006da:	83 c4 14             	add    $0x14,%esp
  8006dd:	5b                   	pop    %ebx
  8006de:	5d                   	pop    %ebp
  8006df:	c3                   	ret    

008006e0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 58             	sub    $0x58,%esp
  8006e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8006e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8006ec:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8006ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	89 04 24             	mov    %eax,(%esp)
  8006ff:	e8 3a fe ff ff       	call   80053e <fd_lookup>
  800704:	89 c3                	mov    %eax,%ebx
  800706:	85 c0                	test   %eax,%eax
  800708:	0f 88 e1 00 00 00    	js     8007ef <dup+0x10f>
		return r;
	close(newfdnum);
  80070e:	89 3c 24             	mov    %edi,(%esp)
  800711:	e8 77 ff ff ff       	call   80068d <close>

	newfd = INDEX2FD(newfdnum);
  800716:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80071c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80071f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800722:	89 04 24             	mov    %eax,(%esp)
  800725:	e8 86 fd ff ff       	call   8004b0 <fd2data>
  80072a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80072c:	89 34 24             	mov    %esi,(%esp)
  80072f:	e8 7c fd ff ff       	call   8004b0 <fd2data>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800737:	89 d8                	mov    %ebx,%eax
  800739:	c1 e8 16             	shr    $0x16,%eax
  80073c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800743:	a8 01                	test   $0x1,%al
  800745:	74 46                	je     80078d <dup+0xad>
  800747:	89 d8                	mov    %ebx,%eax
  800749:	c1 e8 0c             	shr    $0xc,%eax
  80074c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800753:	f6 c2 01             	test   $0x1,%dl
  800756:	74 35                	je     80078d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800758:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80075f:	25 07 0e 00 00       	and    $0xe07,%eax
  800764:	89 44 24 10          	mov    %eax,0x10(%esp)
  800768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80076b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80076f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800776:	00 
  800777:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80077b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800782:	e8 ac fa ff ff       	call   800233 <sys_page_map>
  800787:	89 c3                	mov    %eax,%ebx
  800789:	85 c0                	test   %eax,%eax
  80078b:	78 3b                	js     8007c8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80078d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800790:	89 c2                	mov    %eax,%edx
  800792:	c1 ea 0c             	shr    $0xc,%edx
  800795:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80079c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8007a2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007a6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007b1:	00 
  8007b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007bd:	e8 71 fa ff ff       	call   800233 <sys_page_map>
  8007c2:	89 c3                	mov    %eax,%ebx
  8007c4:	85 c0                	test   %eax,%eax
  8007c6:	79 25                	jns    8007ed <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007d3:	e8 b9 fa ff ff       	call   800291 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8007d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007e6:	e8 a6 fa ff ff       	call   800291 <sys_page_unmap>
	return r;
  8007eb:	eb 02                	jmp    8007ef <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8007ed:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8007ef:	89 d8                	mov    %ebx,%eax
  8007f1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8007f4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8007f7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8007fa:	89 ec                	mov    %ebp,%esp
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	53                   	push   %ebx
  800802:	83 ec 24             	sub    $0x24,%esp
  800805:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800808:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80080b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080f:	89 1c 24             	mov    %ebx,(%esp)
  800812:	e8 27 fd ff ff       	call   80053e <fd_lookup>
  800817:	85 c0                	test   %eax,%eax
  800819:	78 6d                	js     800888 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80081b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80081e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	89 04 24             	mov    %eax,(%esp)
  80082a:	e8 60 fd ff ff       	call   80058f <dev_lookup>
  80082f:	85 c0                	test   %eax,%eax
  800831:	78 55                	js     800888 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800836:	8b 50 08             	mov    0x8(%eax),%edx
  800839:	83 e2 03             	and    $0x3,%edx
  80083c:	83 fa 01             	cmp    $0x1,%edx
  80083f:	75 23                	jne    800864 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800841:	a1 04 40 80 00       	mov    0x804004,%eax
  800846:	8b 40 48             	mov    0x48(%eax),%eax
  800849:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80084d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800851:	c7 04 24 1d 22 80 00 	movl   $0x80221d,(%esp)
  800858:	e8 2e 0b 00 00       	call   80138b <cprintf>
		return -E_INVAL;
  80085d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800862:	eb 24                	jmp    800888 <read+0x8a>
	}
	if (!dev->dev_read)
  800864:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800867:	8b 52 08             	mov    0x8(%edx),%edx
  80086a:	85 d2                	test   %edx,%edx
  80086c:	74 15                	je     800883 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80086e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800871:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800875:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800878:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80087c:	89 04 24             	mov    %eax,(%esp)
  80087f:	ff d2                	call   *%edx
  800881:	eb 05                	jmp    800888 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800883:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800888:	83 c4 24             	add    $0x24,%esp
  80088b:	5b                   	pop    %ebx
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	57                   	push   %edi
  800892:	56                   	push   %esi
  800893:	53                   	push   %ebx
  800894:	83 ec 1c             	sub    $0x1c,%esp
  800897:	8b 7d 08             	mov    0x8(%ebp),%edi
  80089a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80089d:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a2:	85 f6                	test   %esi,%esi
  8008a4:	74 30                	je     8008d6 <readn+0x48>
  8008a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8008ab:	89 f2                	mov    %esi,%edx
  8008ad:	29 c2                	sub    %eax,%edx
  8008af:	89 54 24 08          	mov    %edx,0x8(%esp)
  8008b3:	03 45 0c             	add    0xc(%ebp),%eax
  8008b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ba:	89 3c 24             	mov    %edi,(%esp)
  8008bd:	e8 3c ff ff ff       	call   8007fe <read>
		if (m < 0)
  8008c2:	85 c0                	test   %eax,%eax
  8008c4:	78 10                	js     8008d6 <readn+0x48>
			return m;
		if (m == 0)
  8008c6:	85 c0                	test   %eax,%eax
  8008c8:	74 0a                	je     8008d4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008ca:	01 c3                	add    %eax,%ebx
  8008cc:	89 d8                	mov    %ebx,%eax
  8008ce:	39 f3                	cmp    %esi,%ebx
  8008d0:	72 d9                	jb     8008ab <readn+0x1d>
  8008d2:	eb 02                	jmp    8008d6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8008d4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8008d6:	83 c4 1c             	add    $0x1c,%esp
  8008d9:	5b                   	pop    %ebx
  8008da:	5e                   	pop    %esi
  8008db:	5f                   	pop    %edi
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	53                   	push   %ebx
  8008e2:	83 ec 24             	sub    $0x24,%esp
  8008e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ef:	89 1c 24             	mov    %ebx,(%esp)
  8008f2:	e8 47 fc ff ff       	call   80053e <fd_lookup>
  8008f7:	85 c0                	test   %eax,%eax
  8008f9:	78 68                	js     800963 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	89 04 24             	mov    %eax,(%esp)
  80090a:	e8 80 fc ff ff       	call   80058f <dev_lookup>
  80090f:	85 c0                	test   %eax,%eax
  800911:	78 50                	js     800963 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800916:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80091a:	75 23                	jne    80093f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80091c:	a1 04 40 80 00       	mov    0x804004,%eax
  800921:	8b 40 48             	mov    0x48(%eax),%eax
  800924:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800928:	89 44 24 04          	mov    %eax,0x4(%esp)
  80092c:	c7 04 24 39 22 80 00 	movl   $0x802239,(%esp)
  800933:	e8 53 0a 00 00       	call   80138b <cprintf>
		return -E_INVAL;
  800938:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80093d:	eb 24                	jmp    800963 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80093f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800942:	8b 52 0c             	mov    0xc(%edx),%edx
  800945:	85 d2                	test   %edx,%edx
  800947:	74 15                	je     80095e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800949:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80094c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800950:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800953:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800957:	89 04 24             	mov    %eax,(%esp)
  80095a:	ff d2                	call   *%edx
  80095c:	eb 05                	jmp    800963 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80095e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800963:	83 c4 24             	add    $0x24,%esp
  800966:	5b                   	pop    %ebx
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <seek>:

int
seek(int fdnum, off_t offset)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80096f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800972:	89 44 24 04          	mov    %eax,0x4(%esp)
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	89 04 24             	mov    %eax,(%esp)
  80097c:	e8 bd fb ff ff       	call   80053e <fd_lookup>
  800981:	85 c0                	test   %eax,%eax
  800983:	78 0e                	js     800993 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800985:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80098e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	53                   	push   %ebx
  800999:	83 ec 24             	sub    $0x24,%esp
  80099c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80099f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a6:	89 1c 24             	mov    %ebx,(%esp)
  8009a9:	e8 90 fb ff ff       	call   80053e <fd_lookup>
  8009ae:	85 c0                	test   %eax,%eax
  8009b0:	78 61                	js     800a13 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	89 04 24             	mov    %eax,(%esp)
  8009c1:	e8 c9 fb ff ff       	call   80058f <dev_lookup>
  8009c6:	85 c0                	test   %eax,%eax
  8009c8:	78 49                	js     800a13 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009d1:	75 23                	jne    8009f6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8009d3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009d8:	8b 40 48             	mov    0x48(%eax),%eax
  8009db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e3:	c7 04 24 fc 21 80 00 	movl   $0x8021fc,(%esp)
  8009ea:	e8 9c 09 00 00       	call   80138b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f4:	eb 1d                	jmp    800a13 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8009f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f9:	8b 52 18             	mov    0x18(%edx),%edx
  8009fc:	85 d2                	test   %edx,%edx
  8009fe:	74 0e                	je     800a0e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800a00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a07:	89 04 24             	mov    %eax,(%esp)
  800a0a:	ff d2                	call   *%edx
  800a0c:	eb 05                	jmp    800a13 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800a0e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800a13:	83 c4 24             	add    $0x24,%esp
  800a16:	5b                   	pop    %ebx
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	53                   	push   %ebx
  800a1d:	83 ec 24             	sub    $0x24,%esp
  800a20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a23:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a26:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	89 04 24             	mov    %eax,(%esp)
  800a30:	e8 09 fb ff ff       	call   80053e <fd_lookup>
  800a35:	85 c0                	test   %eax,%eax
  800a37:	78 52                	js     800a8b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a43:	8b 00                	mov    (%eax),%eax
  800a45:	89 04 24             	mov    %eax,(%esp)
  800a48:	e8 42 fb ff ff       	call   80058f <dev_lookup>
  800a4d:	85 c0                	test   %eax,%eax
  800a4f:	78 3a                	js     800a8b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  800a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a54:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a58:	74 2c                	je     800a86 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a5a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a5d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a64:	00 00 00 
	stat->st_isdir = 0;
  800a67:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a6e:	00 00 00 
	stat->st_dev = dev;
  800a71:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a77:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a7e:	89 14 24             	mov    %edx,(%esp)
  800a81:	ff 50 14             	call   *0x14(%eax)
  800a84:	eb 05                	jmp    800a8b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a86:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a8b:	83 c4 24             	add    $0x24,%esp
  800a8e:	5b                   	pop    %ebx
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 18             	sub    $0x18,%esp
  800a97:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800a9a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a9d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800aa4:	00 
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	89 04 24             	mov    %eax,(%esp)
  800aab:	e8 bc 01 00 00       	call   800c6c <open>
  800ab0:	89 c3                	mov    %eax,%ebx
  800ab2:	85 c0                	test   %eax,%eax
  800ab4:	78 1b                	js     800ad1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800abd:	89 1c 24             	mov    %ebx,(%esp)
  800ac0:	e8 54 ff ff ff       	call   800a19 <fstat>
  800ac5:	89 c6                	mov    %eax,%esi
	close(fd);
  800ac7:	89 1c 24             	mov    %ebx,(%esp)
  800aca:	e8 be fb ff ff       	call   80068d <close>
	return r;
  800acf:	89 f3                	mov    %esi,%ebx
}
  800ad1:	89 d8                	mov    %ebx,%eax
  800ad3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800ad6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800ad9:	89 ec                	mov    %ebp,%esp
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    
  800add:	00 00                	add    %al,(%eax)
	...

00800ae0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 18             	sub    $0x18,%esp
  800ae6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800ae9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800aec:	89 c3                	mov    %eax,%ebx
  800aee:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  800af0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800af7:	75 11                	jne    800b0a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800af9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800b00:	e8 61 13 00 00       	call   801e66 <ipc_find_env>
  800b05:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800b0a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800b11:	00 
  800b12:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800b19:	00 
  800b1a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b1e:	a1 00 40 80 00       	mov    0x804000,%eax
  800b23:	89 04 24             	mov    %eax,(%esp)
  800b26:	e8 b7 12 00 00       	call   801de2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800b2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b32:	00 
  800b33:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b3e:	e8 4d 12 00 00       	call   801d90 <ipc_recv>
}
  800b43:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800b46:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800b49:	89 ec                	mov    %ebp,%esp
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	53                   	push   %ebx
  800b51:	83 ec 14             	sub    $0x14,%esp
  800b54:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	8b 40 0c             	mov    0xc(%eax),%eax
  800b5d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b62:	ba 00 00 00 00       	mov    $0x0,%edx
  800b67:	b8 05 00 00 00       	mov    $0x5,%eax
  800b6c:	e8 6f ff ff ff       	call   800ae0 <fsipc>
  800b71:	85 c0                	test   %eax,%eax
  800b73:	78 2b                	js     800ba0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b75:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800b7c:	00 
  800b7d:	89 1c 24             	mov    %ebx,(%esp)
  800b80:	e8 26 0e 00 00       	call   8019ab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b85:	a1 80 50 80 00       	mov    0x805080,%eax
  800b8a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b90:	a1 84 50 80 00       	mov    0x805084,%eax
  800b95:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba0:	83 c4 14             	add    $0x14,%esp
  800ba3:	5b                   	pop    %ebx
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 40 0c             	mov    0xc(%eax),%eax
  800bb2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbc:	b8 06 00 00 00       	mov    $0x6,%eax
  800bc1:	e8 1a ff ff ff       	call   800ae0 <fsipc>
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	56                   	push   %esi
  800bcc:	53                   	push   %ebx
  800bcd:	83 ec 10             	sub    $0x10,%esp
  800bd0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 40 0c             	mov    0xc(%eax),%eax
  800bd9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800bde:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
  800be9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bee:	e8 ed fe ff ff       	call   800ae0 <fsipc>
  800bf3:	89 c3                	mov    %eax,%ebx
  800bf5:	85 c0                	test   %eax,%eax
  800bf7:	78 6a                	js     800c63 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800bf9:	39 c6                	cmp    %eax,%esi
  800bfb:	73 24                	jae    800c21 <devfile_read+0x59>
  800bfd:	c7 44 24 0c 68 22 80 	movl   $0x802268,0xc(%esp)
  800c04:	00 
  800c05:	c7 44 24 08 6f 22 80 	movl   $0x80226f,0x8(%esp)
  800c0c:	00 
  800c0d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800c14:	00 
  800c15:	c7 04 24 84 22 80 00 	movl   $0x802284,(%esp)
  800c1c:	e8 6f 06 00 00       	call   801290 <_panic>
	assert(r <= PGSIZE);
  800c21:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c26:	7e 24                	jle    800c4c <devfile_read+0x84>
  800c28:	c7 44 24 0c 8f 22 80 	movl   $0x80228f,0xc(%esp)
  800c2f:	00 
  800c30:	c7 44 24 08 6f 22 80 	movl   $0x80226f,0x8(%esp)
  800c37:	00 
  800c38:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800c3f:	00 
  800c40:	c7 04 24 84 22 80 00 	movl   $0x802284,(%esp)
  800c47:	e8 44 06 00 00       	call   801290 <_panic>
	memmove(buf, &fsipcbuf, r);
  800c4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c50:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c57:	00 
  800c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5b:	89 04 24             	mov    %eax,(%esp)
  800c5e:	e8 39 0f 00 00       	call   801b9c <memmove>
	return r;
}
  800c63:	89 d8                	mov    %ebx,%eax
  800c65:	83 c4 10             	add    $0x10,%esp
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
  800c71:	83 ec 20             	sub    $0x20,%esp
  800c74:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800c77:	89 34 24             	mov    %esi,(%esp)
  800c7a:	e8 e1 0c 00 00       	call   801960 <strlen>
		return -E_BAD_PATH;
  800c7f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800c84:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c89:	7f 5e                	jg     800ce9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800c8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c8e:	89 04 24             	mov    %eax,(%esp)
  800c91:	e8 35 f8 ff ff       	call   8004cb <fd_alloc>
  800c96:	89 c3                	mov    %eax,%ebx
  800c98:	85 c0                	test   %eax,%eax
  800c9a:	78 4d                	js     800ce9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800c9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ca0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800ca7:	e8 ff 0c 00 00       	call   8019ab <strcpy>
	fsipcbuf.open.req_omode = mode;
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800cb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb7:	b8 01 00 00 00       	mov    $0x1,%eax
  800cbc:	e8 1f fe ff ff       	call   800ae0 <fsipc>
  800cc1:	89 c3                	mov    %eax,%ebx
  800cc3:	85 c0                	test   %eax,%eax
  800cc5:	79 15                	jns    800cdc <open+0x70>
		fd_close(fd, 0);
  800cc7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800cce:	00 
  800ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cd2:	89 04 24             	mov    %eax,(%esp)
  800cd5:	e8 21 f9 ff ff       	call   8005fb <fd_close>
		return r;
  800cda:	eb 0d                	jmp    800ce9 <open+0x7d>
	}

	return fd2num(fd);
  800cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cdf:	89 04 24             	mov    %eax,(%esp)
  800ce2:	e8 b9 f7 ff ff       	call   8004a0 <fd2num>
  800ce7:	89 c3                	mov    %eax,%ebx
}
  800ce9:	89 d8                	mov    %ebx,%eax
  800ceb:	83 c4 20             	add    $0x20,%esp
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    
	...

00800d00 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	83 ec 18             	sub    $0x18,%esp
  800d06:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800d09:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800d0c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 04 24             	mov    %eax,(%esp)
  800d15:	e8 96 f7 ff ff       	call   8004b0 <fd2data>
  800d1a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  800d1c:	c7 44 24 04 9b 22 80 	movl   $0x80229b,0x4(%esp)
  800d23:	00 
  800d24:	89 34 24             	mov    %esi,(%esp)
  800d27:	e8 7f 0c 00 00       	call   8019ab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800d2c:	8b 43 04             	mov    0x4(%ebx),%eax
  800d2f:	2b 03                	sub    (%ebx),%eax
  800d31:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  800d37:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  800d3e:	00 00 00 
	stat->st_dev = &devpipe;
  800d41:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  800d48:	30 80 00 
	return 0;
}
  800d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d50:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800d53:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800d56:	89 ec                	mov    %ebp,%esp
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 14             	sub    $0x14,%esp
  800d61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800d64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d6f:	e8 1d f5 ff ff       	call   800291 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800d74:	89 1c 24             	mov    %ebx,(%esp)
  800d77:	e8 34 f7 ff ff       	call   8004b0 <fd2data>
  800d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d87:	e8 05 f5 ff ff       	call   800291 <sys_page_unmap>
}
  800d8c:	83 c4 14             	add    $0x14,%esp
  800d8f:	5b                   	pop    %ebx
  800d90:	5d                   	pop    %ebp
  800d91:	c3                   	ret    

00800d92 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	57                   	push   %edi
  800d96:	56                   	push   %esi
  800d97:	53                   	push   %ebx
  800d98:	83 ec 2c             	sub    $0x2c,%esp
  800d9b:	89 c7                	mov    %eax,%edi
  800d9d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800da0:	a1 04 40 80 00       	mov    0x804004,%eax
  800da5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800da8:	89 3c 24             	mov    %edi,(%esp)
  800dab:	e8 00 11 00 00       	call   801eb0 <pageref>
  800db0:	89 c6                	mov    %eax,%esi
  800db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800db5:	89 04 24             	mov    %eax,(%esp)
  800db8:	e8 f3 10 00 00       	call   801eb0 <pageref>
  800dbd:	39 c6                	cmp    %eax,%esi
  800dbf:	0f 94 c0             	sete   %al
  800dc2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  800dc5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800dcb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800dce:	39 cb                	cmp    %ecx,%ebx
  800dd0:	75 08                	jne    800dda <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  800dd2:	83 c4 2c             	add    $0x2c,%esp
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5f                   	pop    %edi
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  800dda:	83 f8 01             	cmp    $0x1,%eax
  800ddd:	75 c1                	jne    800da0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800ddf:	8b 52 58             	mov    0x58(%edx),%edx
  800de2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800de6:	89 54 24 08          	mov    %edx,0x8(%esp)
  800dea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800dee:	c7 04 24 a2 22 80 00 	movl   $0x8022a2,(%esp)
  800df5:	e8 91 05 00 00       	call   80138b <cprintf>
  800dfa:	eb a4                	jmp    800da0 <_pipeisclosed+0xe>

00800dfc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 2c             	sub    $0x2c,%esp
  800e05:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800e08:	89 34 24             	mov    %esi,(%esp)
  800e0b:	e8 a0 f6 ff ff       	call   8004b0 <fd2data>
  800e10:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e12:	bf 00 00 00 00       	mov    $0x0,%edi
  800e17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1b:	75 50                	jne    800e6d <devpipe_write+0x71>
  800e1d:	eb 5c                	jmp    800e7b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800e1f:	89 da                	mov    %ebx,%edx
  800e21:	89 f0                	mov    %esi,%eax
  800e23:	e8 6a ff ff ff       	call   800d92 <_pipeisclosed>
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	75 53                	jne    800e7f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800e2c:	e8 73 f3 ff ff       	call   8001a4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e31:	8b 43 04             	mov    0x4(%ebx),%eax
  800e34:	8b 13                	mov    (%ebx),%edx
  800e36:	83 c2 20             	add    $0x20,%edx
  800e39:	39 d0                	cmp    %edx,%eax
  800e3b:	73 e2                	jae    800e1f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e40:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  800e44:	88 55 e7             	mov    %dl,-0x19(%ebp)
  800e47:	89 c2                	mov    %eax,%edx
  800e49:	c1 fa 1f             	sar    $0x1f,%edx
  800e4c:	c1 ea 1b             	shr    $0x1b,%edx
  800e4f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800e52:	83 e1 1f             	and    $0x1f,%ecx
  800e55:	29 d1                	sub    %edx,%ecx
  800e57:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800e5b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800e5f:	83 c0 01             	add    $0x1,%eax
  800e62:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e65:	83 c7 01             	add    $0x1,%edi
  800e68:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800e6b:	74 0e                	je     800e7b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e6d:	8b 43 04             	mov    0x4(%ebx),%eax
  800e70:	8b 13                	mov    (%ebx),%edx
  800e72:	83 c2 20             	add    $0x20,%edx
  800e75:	39 d0                	cmp    %edx,%eax
  800e77:	73 a6                	jae    800e1f <devpipe_write+0x23>
  800e79:	eb c2                	jmp    800e3d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800e7b:	89 f8                	mov    %edi,%eax
  800e7d:	eb 05                	jmp    800e84 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e7f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800e84:	83 c4 2c             	add    $0x2c,%esp
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 28             	sub    $0x28,%esp
  800e92:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e95:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e98:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800e9b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800e9e:	89 3c 24             	mov    %edi,(%esp)
  800ea1:	e8 0a f6 ff ff       	call   8004b0 <fd2data>
  800ea6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ea8:	be 00 00 00 00       	mov    $0x0,%esi
  800ead:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb1:	75 47                	jne    800efa <devpipe_read+0x6e>
  800eb3:	eb 52                	jmp    800f07 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800eb5:	89 f0                	mov    %esi,%eax
  800eb7:	eb 5e                	jmp    800f17 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800eb9:	89 da                	mov    %ebx,%edx
  800ebb:	89 f8                	mov    %edi,%eax
  800ebd:	8d 76 00             	lea    0x0(%esi),%esi
  800ec0:	e8 cd fe ff ff       	call   800d92 <_pipeisclosed>
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	75 49                	jne    800f12 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800ec9:	e8 d6 f2 ff ff       	call   8001a4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800ece:	8b 03                	mov    (%ebx),%eax
  800ed0:	3b 43 04             	cmp    0x4(%ebx),%eax
  800ed3:	74 e4                	je     800eb9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800ed5:	89 c2                	mov    %eax,%edx
  800ed7:	c1 fa 1f             	sar    $0x1f,%edx
  800eda:	c1 ea 1b             	shr    $0x1b,%edx
  800edd:	01 d0                	add    %edx,%eax
  800edf:	83 e0 1f             	and    $0x1f,%eax
  800ee2:	29 d0                	sub    %edx,%eax
  800ee4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eec:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  800eef:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ef2:	83 c6 01             	add    $0x1,%esi
  800ef5:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ef8:	74 0d                	je     800f07 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  800efa:	8b 03                	mov    (%ebx),%eax
  800efc:	3b 43 04             	cmp    0x4(%ebx),%eax
  800eff:	75 d4                	jne    800ed5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800f01:	85 f6                	test   %esi,%esi
  800f03:	75 b0                	jne    800eb5 <devpipe_read+0x29>
  800f05:	eb b2                	jmp    800eb9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800f07:	89 f0                	mov    %esi,%eax
  800f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f10:	eb 05                	jmp    800f17 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800f12:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800f17:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f1a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f1d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f20:	89 ec                	mov    %ebp,%esp
  800f22:	5d                   	pop    %ebp
  800f23:	c3                   	ret    

00800f24 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	83 ec 48             	sub    $0x48,%esp
  800f2a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f2d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f30:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800f33:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800f36:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f39:	89 04 24             	mov    %eax,(%esp)
  800f3c:	e8 8a f5 ff ff       	call   8004cb <fd_alloc>
  800f41:	89 c3                	mov    %eax,%ebx
  800f43:	85 c0                	test   %eax,%eax
  800f45:	0f 88 45 01 00 00    	js     801090 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f4b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f52:	00 
  800f53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f56:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f61:	e8 6e f2 ff ff       	call   8001d4 <sys_page_alloc>
  800f66:	89 c3                	mov    %eax,%ebx
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	0f 88 20 01 00 00    	js     801090 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800f70:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f73:	89 04 24             	mov    %eax,(%esp)
  800f76:	e8 50 f5 ff ff       	call   8004cb <fd_alloc>
  800f7b:	89 c3                	mov    %eax,%ebx
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	0f 88 f8 00 00 00    	js     80107d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f85:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f8c:	00 
  800f8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f90:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f9b:	e8 34 f2 ff ff       	call   8001d4 <sys_page_alloc>
  800fa0:	89 c3                	mov    %eax,%ebx
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	0f 88 d3 00 00 00    	js     80107d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800faa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fad:	89 04 24             	mov    %eax,(%esp)
  800fb0:	e8 fb f4 ff ff       	call   8004b0 <fd2data>
  800fb5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800fb7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800fbe:	00 
  800fbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fc3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fca:	e8 05 f2 ff ff       	call   8001d4 <sys_page_alloc>
  800fcf:	89 c3                	mov    %eax,%ebx
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	0f 88 91 00 00 00    	js     80106a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800fd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fdc:	89 04 24             	mov    %eax,(%esp)
  800fdf:	e8 cc f4 ff ff       	call   8004b0 <fd2data>
  800fe4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  800feb:	00 
  800fec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ff0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800ff7:	00 
  800ff8:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ffc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801003:	e8 2b f2 ff ff       	call   800233 <sys_page_map>
  801008:	89 c3                	mov    %eax,%ebx
  80100a:	85 c0                	test   %eax,%eax
  80100c:	78 4c                	js     80105a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80100e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801014:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801017:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801019:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80101c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801023:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801029:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80102c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80102e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801031:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801038:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80103b:	89 04 24             	mov    %eax,(%esp)
  80103e:	e8 5d f4 ff ff       	call   8004a0 <fd2num>
  801043:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801045:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801048:	89 04 24             	mov    %eax,(%esp)
  80104b:	e8 50 f4 ff ff       	call   8004a0 <fd2num>
  801050:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801053:	bb 00 00 00 00       	mov    $0x0,%ebx
  801058:	eb 36                	jmp    801090 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80105a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80105e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801065:	e8 27 f2 ff ff       	call   800291 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80106a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801071:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801078:	e8 14 f2 ff ff       	call   800291 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80107d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801080:	89 44 24 04          	mov    %eax,0x4(%esp)
  801084:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80108b:	e8 01 f2 ff ff       	call   800291 <sys_page_unmap>
    err:
	return r;
}
  801090:	89 d8                	mov    %ebx,%eax
  801092:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801095:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801098:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80109b:	89 ec                	mov    %ebp,%esp
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	89 04 24             	mov    %eax,(%esp)
  8010b2:	e8 87 f4 ff ff       	call   80053e <fd_lookup>
  8010b7:	85 c0                	test   %eax,%eax
  8010b9:	78 15                	js     8010d0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8010bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010be:	89 04 24             	mov    %eax,(%esp)
  8010c1:	e8 ea f3 ff ff       	call   8004b0 <fd2data>
	return _pipeisclosed(fd, p);
  8010c6:	89 c2                	mov    %eax,%edx
  8010c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010cb:	e8 c2 fc ff ff       	call   800d92 <_pipeisclosed>
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    
	...

008010e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8010e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8010f0:	c7 44 24 04 ba 22 80 	movl   $0x8022ba,0x4(%esp)
  8010f7:	00 
  8010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fb:	89 04 24             	mov    %eax,(%esp)
  8010fe:	e8 a8 08 00 00       	call   8019ab <strcpy>
	return 0;
}
  801103:	b8 00 00 00 00       	mov    $0x0,%eax
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	57                   	push   %edi
  80110e:	56                   	push   %esi
  80110f:	53                   	push   %ebx
  801110:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801116:	be 00 00 00 00       	mov    $0x0,%esi
  80111b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111f:	74 43                	je     801164 <devcons_write+0x5a>
  801121:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801126:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80112c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80112f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801131:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801134:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801139:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80113c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801140:	03 45 0c             	add    0xc(%ebp),%eax
  801143:	89 44 24 04          	mov    %eax,0x4(%esp)
  801147:	89 3c 24             	mov    %edi,(%esp)
  80114a:	e8 4d 0a 00 00       	call   801b9c <memmove>
		sys_cputs(buf, m);
  80114f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801153:	89 3c 24             	mov    %edi,(%esp)
  801156:	e8 5d ef ff ff       	call   8000b8 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80115b:	01 de                	add    %ebx,%esi
  80115d:	89 f0                	mov    %esi,%eax
  80115f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801162:	72 c8                	jb     80112c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801164:	89 f0                	mov    %esi,%eax
  801166:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80116c:	5b                   	pop    %ebx
  80116d:	5e                   	pop    %esi
  80116e:	5f                   	pop    %edi
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    

00801171 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801177:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80117c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801180:	75 07                	jne    801189 <devcons_read+0x18>
  801182:	eb 31                	jmp    8011b5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801184:	e8 1b f0 ff ff       	call   8001a4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801190:	e8 52 ef ff ff       	call   8000e7 <sys_cgetc>
  801195:	85 c0                	test   %eax,%eax
  801197:	74 eb                	je     801184 <devcons_read+0x13>
  801199:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80119b:	85 c0                	test   %eax,%eax
  80119d:	78 16                	js     8011b5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80119f:	83 f8 04             	cmp    $0x4,%eax
  8011a2:	74 0c                	je     8011b0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	88 10                	mov    %dl,(%eax)
	return 1;
  8011a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8011ae:	eb 05                	jmp    8011b5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8011b0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8011c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011ca:	00 
  8011cb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8011ce:	89 04 24             	mov    %eax,(%esp)
  8011d1:	e8 e2 ee ff ff       	call   8000b8 <sys_cputs>
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <getchar>:

int
getchar(void)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8011de:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8011e5:	00 
  8011e6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8011e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011f4:	e8 05 f6 ff ff       	call   8007fe <read>
	if (r < 0)
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	78 0f                	js     80120c <getchar+0x34>
		return r;
	if (r < 1)
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	7e 06                	jle    801207 <getchar+0x2f>
		return -E_EOF;
	return c;
  801201:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801205:	eb 05                	jmp    80120c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801207:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801214:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801217:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	89 04 24             	mov    %eax,(%esp)
  801221:	e8 18 f3 ff ff       	call   80053e <fd_lookup>
  801226:	85 c0                	test   %eax,%eax
  801228:	78 11                	js     80123b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80122a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801233:	39 10                	cmp    %edx,(%eax)
  801235:	0f 94 c0             	sete   %al
  801238:	0f b6 c0             	movzbl %al,%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <opencons>:

int
opencons(void)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801243:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801246:	89 04 24             	mov    %eax,(%esp)
  801249:	e8 7d f2 ff ff       	call   8004cb <fd_alloc>
  80124e:	85 c0                	test   %eax,%eax
  801250:	78 3c                	js     80128e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801252:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801259:	00 
  80125a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801261:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801268:	e8 67 ef ff ff       	call   8001d4 <sys_page_alloc>
  80126d:	85 c0                	test   %eax,%eax
  80126f:	78 1d                	js     80128e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801271:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80127c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801286:	89 04 24             	mov    %eax,(%esp)
  801289:	e8 12 f2 ff ff       	call   8004a0 <fd2num>
}
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	56                   	push   %esi
  801294:	53                   	push   %ebx
  801295:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801298:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80129b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8012a1:	e8 ce ee ff ff       	call   800174 <sys_getenvid>
  8012a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012bc:	c7 04 24 c8 22 80 00 	movl   $0x8022c8,(%esp)
  8012c3:	e8 c3 00 00 00       	call   80138b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cf:	89 04 24             	mov    %eax,(%esp)
  8012d2:	e8 53 00 00 00       	call   80132a <vcprintf>
	cprintf("\n");
  8012d7:	c7 04 24 b3 22 80 00 	movl   $0x8022b3,(%esp)
  8012de:	e8 a8 00 00 00       	call   80138b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8012e3:	cc                   	int3   
  8012e4:	eb fd                	jmp    8012e3 <_panic+0x53>
	...

008012e8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	53                   	push   %ebx
  8012ec:	83 ec 14             	sub    $0x14,%esp
  8012ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8012f2:	8b 03                	mov    (%ebx),%eax
  8012f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f7:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8012fb:	83 c0 01             	add    $0x1,%eax
  8012fe:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801300:	3d ff 00 00 00       	cmp    $0xff,%eax
  801305:	75 19                	jne    801320 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801307:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80130e:	00 
  80130f:	8d 43 08             	lea    0x8(%ebx),%eax
  801312:	89 04 24             	mov    %eax,(%esp)
  801315:	e8 9e ed ff ff       	call   8000b8 <sys_cputs>
		b->idx = 0;
  80131a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801320:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801324:	83 c4 14             	add    $0x14,%esp
  801327:	5b                   	pop    %ebx
  801328:	5d                   	pop    %ebp
  801329:	c3                   	ret    

0080132a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801333:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80133a:	00 00 00 
	b.cnt = 0;
  80133d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801344:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	89 44 24 08          	mov    %eax,0x8(%esp)
  801355:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80135b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80135f:	c7 04 24 e8 12 80 00 	movl   $0x8012e8,(%esp)
  801366:	e8 9f 01 00 00       	call   80150a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80136b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801371:	89 44 24 04          	mov    %eax,0x4(%esp)
  801375:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80137b:	89 04 24             	mov    %eax,(%esp)
  80137e:	e8 35 ed ff ff       	call   8000b8 <sys_cputs>

	return b.cnt;
}
  801383:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801391:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801394:	89 44 24 04          	mov    %eax,0x4(%esp)
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	89 04 24             	mov    %eax,(%esp)
  80139e:	e8 87 ff ff ff       	call   80132a <vcprintf>
	va_end(ap);

	return cnt;
}
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    
	...

008013b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	57                   	push   %edi
  8013b4:	56                   	push   %esi
  8013b5:	53                   	push   %ebx
  8013b6:	83 ec 3c             	sub    $0x3c,%esp
  8013b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013bc:	89 d7                	mov    %edx,%edi
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013cd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8013d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8013d8:	72 11                	jb     8013eb <printnum+0x3b>
  8013da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013dd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8013e0:	76 09                	jbe    8013eb <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8013e2:	83 eb 01             	sub    $0x1,%ebx
  8013e5:	85 db                	test   %ebx,%ebx
  8013e7:	7f 51                	jg     80143a <printnum+0x8a>
  8013e9:	eb 5e                	jmp    801449 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8013eb:	89 74 24 10          	mov    %esi,0x10(%esp)
  8013ef:	83 eb 01             	sub    $0x1,%ebx
  8013f2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013fd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  801401:	8b 74 24 0c          	mov    0xc(%esp),%esi
  801405:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80140c:	00 
  80140d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801410:	89 04 24             	mov    %eax,(%esp)
  801413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801416:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141a:	e8 d1 0a 00 00       	call   801ef0 <__udivdi3>
  80141f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801423:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801427:	89 04 24             	mov    %eax,(%esp)
  80142a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80142e:	89 fa                	mov    %edi,%edx
  801430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801433:	e8 78 ff ff ff       	call   8013b0 <printnum>
  801438:	eb 0f                	jmp    801449 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80143a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80143e:	89 34 24             	mov    %esi,(%esp)
  801441:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801444:	83 eb 01             	sub    $0x1,%ebx
  801447:	75 f1                	jne    80143a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801449:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80144d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	89 44 24 08          	mov    %eax,0x8(%esp)
  801458:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80145f:	00 
  801460:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801463:	89 04 24             	mov    %eax,(%esp)
  801466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801469:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146d:	e8 ae 0b 00 00       	call   802020 <__umoddi3>
  801472:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801476:	0f be 80 eb 22 80 00 	movsbl 0x8022eb(%eax),%eax
  80147d:	89 04 24             	mov    %eax,(%esp)
  801480:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801483:	83 c4 3c             	add    $0x3c,%esp
  801486:	5b                   	pop    %ebx
  801487:	5e                   	pop    %esi
  801488:	5f                   	pop    %edi
  801489:	5d                   	pop    %ebp
  80148a:	c3                   	ret    

0080148b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80148e:	83 fa 01             	cmp    $0x1,%edx
  801491:	7e 0e                	jle    8014a1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801493:	8b 10                	mov    (%eax),%edx
  801495:	8d 4a 08             	lea    0x8(%edx),%ecx
  801498:	89 08                	mov    %ecx,(%eax)
  80149a:	8b 02                	mov    (%edx),%eax
  80149c:	8b 52 04             	mov    0x4(%edx),%edx
  80149f:	eb 22                	jmp    8014c3 <getuint+0x38>
	else if (lflag)
  8014a1:	85 d2                	test   %edx,%edx
  8014a3:	74 10                	je     8014b5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8014a5:	8b 10                	mov    (%eax),%edx
  8014a7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8014aa:	89 08                	mov    %ecx,(%eax)
  8014ac:	8b 02                	mov    (%edx),%eax
  8014ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b3:	eb 0e                	jmp    8014c3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8014b5:	8b 10                	mov    (%eax),%edx
  8014b7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8014ba:	89 08                	mov    %ecx,(%eax)
  8014bc:	8b 02                	mov    (%edx),%eax
  8014be:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8014c3:	5d                   	pop    %ebp
  8014c4:	c3                   	ret    

008014c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8014cb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8014cf:	8b 10                	mov    (%eax),%edx
  8014d1:	3b 50 04             	cmp    0x4(%eax),%edx
  8014d4:	73 0a                	jae    8014e0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8014d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d9:	88 0a                	mov    %cl,(%edx)
  8014db:	83 c2 01             	add    $0x1,%edx
  8014de:	89 10                	mov    %edx,(%eax)
}
  8014e0:	5d                   	pop    %ebp
  8014e1:	c3                   	ret    

008014e2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
  8014e5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014e8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8014eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	89 04 24             	mov    %eax,(%esp)
  801503:	e8 02 00 00 00       	call   80150a <vprintfmt>
	va_end(ap);
}
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	57                   	push   %edi
  80150e:	56                   	push   %esi
  80150f:	53                   	push   %ebx
  801510:	83 ec 4c             	sub    $0x4c,%esp
  801513:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801516:	8b 75 10             	mov    0x10(%ebp),%esi
  801519:	eb 12                	jmp    80152d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80151b:	85 c0                	test   %eax,%eax
  80151d:	0f 84 a9 03 00 00    	je     8018cc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  801523:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801527:	89 04 24             	mov    %eax,(%esp)
  80152a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80152d:	0f b6 06             	movzbl (%esi),%eax
  801530:	83 c6 01             	add    $0x1,%esi
  801533:	83 f8 25             	cmp    $0x25,%eax
  801536:	75 e3                	jne    80151b <vprintfmt+0x11>
  801538:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80153c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801543:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  801548:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80154f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801554:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801557:	eb 2b                	jmp    801584 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801559:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80155c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801560:	eb 22                	jmp    801584 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801562:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801565:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801569:	eb 19                	jmp    801584 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80156b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80156e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801575:	eb 0d                	jmp    801584 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801577:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80157a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80157d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801584:	0f b6 06             	movzbl (%esi),%eax
  801587:	0f b6 d0             	movzbl %al,%edx
  80158a:	8d 7e 01             	lea    0x1(%esi),%edi
  80158d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  801590:	83 e8 23             	sub    $0x23,%eax
  801593:	3c 55                	cmp    $0x55,%al
  801595:	0f 87 0b 03 00 00    	ja     8018a6 <vprintfmt+0x39c>
  80159b:	0f b6 c0             	movzbl %al,%eax
  80159e:	ff 24 85 20 24 80 00 	jmp    *0x802420(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8015a5:	83 ea 30             	sub    $0x30,%edx
  8015a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8015ab:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8015af:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015b2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8015b5:	83 fa 09             	cmp    $0x9,%edx
  8015b8:	77 4a                	ja     801604 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015ba:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8015bd:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8015c0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8015c3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8015c7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8015ca:	8d 50 d0             	lea    -0x30(%eax),%edx
  8015cd:	83 fa 09             	cmp    $0x9,%edx
  8015d0:	76 eb                	jbe    8015bd <vprintfmt+0xb3>
  8015d2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8015d5:	eb 2d                	jmp    801604 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8015d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015da:	8d 50 04             	lea    0x4(%eax),%edx
  8015dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8015e0:	8b 00                	mov    (%eax),%eax
  8015e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015e5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8015e8:	eb 1a                	jmp    801604 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015ea:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8015ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015f1:	79 91                	jns    801584 <vprintfmt+0x7a>
  8015f3:	e9 73 ff ff ff       	jmp    80156b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015f8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8015fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801602:	eb 80                	jmp    801584 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  801604:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801608:	0f 89 76 ff ff ff    	jns    801584 <vprintfmt+0x7a>
  80160e:	e9 64 ff ff ff       	jmp    801577 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801613:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801616:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801619:	e9 66 ff ff ff       	jmp    801584 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80161e:	8b 45 14             	mov    0x14(%ebp),%eax
  801621:	8d 50 04             	lea    0x4(%eax),%edx
  801624:	89 55 14             	mov    %edx,0x14(%ebp)
  801627:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80162b:	8b 00                	mov    (%eax),%eax
  80162d:	89 04 24             	mov    %eax,(%esp)
  801630:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801633:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801636:	e9 f2 fe ff ff       	jmp    80152d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80163b:	8b 45 14             	mov    0x14(%ebp),%eax
  80163e:	8d 50 04             	lea    0x4(%eax),%edx
  801641:	89 55 14             	mov    %edx,0x14(%ebp)
  801644:	8b 00                	mov    (%eax),%eax
  801646:	89 c2                	mov    %eax,%edx
  801648:	c1 fa 1f             	sar    $0x1f,%edx
  80164b:	31 d0                	xor    %edx,%eax
  80164d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80164f:	83 f8 0f             	cmp    $0xf,%eax
  801652:	7f 0b                	jg     80165f <vprintfmt+0x155>
  801654:	8b 14 85 80 25 80 00 	mov    0x802580(,%eax,4),%edx
  80165b:	85 d2                	test   %edx,%edx
  80165d:	75 23                	jne    801682 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80165f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801663:	c7 44 24 08 03 23 80 	movl   $0x802303,0x8(%esp)
  80166a:	00 
  80166b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80166f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801672:	89 3c 24             	mov    %edi,(%esp)
  801675:	e8 68 fe ff ff       	call   8014e2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80167a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80167d:	e9 ab fe ff ff       	jmp    80152d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  801682:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801686:	c7 44 24 08 81 22 80 	movl   $0x802281,0x8(%esp)
  80168d:	00 
  80168e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801692:	8b 7d 08             	mov    0x8(%ebp),%edi
  801695:	89 3c 24             	mov    %edi,(%esp)
  801698:	e8 45 fe ff ff       	call   8014e2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80169d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8016a0:	e9 88 fe ff ff       	jmp    80152d <vprintfmt+0x23>
  8016a5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8016a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8016ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b1:	8d 50 04             	lea    0x4(%eax),%edx
  8016b4:	89 55 14             	mov    %edx,0x14(%ebp)
  8016b7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8016b9:	85 f6                	test   %esi,%esi
  8016bb:	ba fc 22 80 00       	mov    $0x8022fc,%edx
  8016c0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8016c3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8016c7:	7e 06                	jle    8016cf <vprintfmt+0x1c5>
  8016c9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8016cd:	75 10                	jne    8016df <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016cf:	0f be 06             	movsbl (%esi),%eax
  8016d2:	83 c6 01             	add    $0x1,%esi
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	0f 85 86 00 00 00    	jne    801763 <vprintfmt+0x259>
  8016dd:	eb 76                	jmp    801755 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8016df:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016e3:	89 34 24             	mov    %esi,(%esp)
  8016e6:	e8 90 02 00 00       	call   80197b <strnlen>
  8016eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8016ee:	29 c2                	sub    %eax,%edx
  8016f0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8016f3:	85 d2                	test   %edx,%edx
  8016f5:	7e d8                	jle    8016cf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8016f7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8016fb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8016fe:	89 d6                	mov    %edx,%esi
  801700:	89 7d d0             	mov    %edi,-0x30(%ebp)
  801703:	89 c7                	mov    %eax,%edi
  801705:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801709:	89 3c 24             	mov    %edi,(%esp)
  80170c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80170f:	83 ee 01             	sub    $0x1,%esi
  801712:	75 f1                	jne    801705 <vprintfmt+0x1fb>
  801714:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801717:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80171a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80171d:	eb b0                	jmp    8016cf <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80171f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801723:	74 18                	je     80173d <vprintfmt+0x233>
  801725:	8d 50 e0             	lea    -0x20(%eax),%edx
  801728:	83 fa 5e             	cmp    $0x5e,%edx
  80172b:	76 10                	jbe    80173d <vprintfmt+0x233>
					putch('?', putdat);
  80172d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801731:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801738:	ff 55 08             	call   *0x8(%ebp)
  80173b:	eb 0a                	jmp    801747 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80173d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801741:	89 04 24             	mov    %eax,(%esp)
  801744:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801747:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80174b:	0f be 06             	movsbl (%esi),%eax
  80174e:	83 c6 01             	add    $0x1,%esi
  801751:	85 c0                	test   %eax,%eax
  801753:	75 0e                	jne    801763 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801755:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801758:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80175c:	7f 16                	jg     801774 <vprintfmt+0x26a>
  80175e:	e9 ca fd ff ff       	jmp    80152d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801763:	85 ff                	test   %edi,%edi
  801765:	78 b8                	js     80171f <vprintfmt+0x215>
  801767:	83 ef 01             	sub    $0x1,%edi
  80176a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801770:	79 ad                	jns    80171f <vprintfmt+0x215>
  801772:	eb e1                	jmp    801755 <vprintfmt+0x24b>
  801774:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801777:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80177a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80177e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801785:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801787:	83 ee 01             	sub    $0x1,%esi
  80178a:	75 ee                	jne    80177a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80178c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80178f:	e9 99 fd ff ff       	jmp    80152d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801794:	83 f9 01             	cmp    $0x1,%ecx
  801797:	7e 10                	jle    8017a9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  801799:	8b 45 14             	mov    0x14(%ebp),%eax
  80179c:	8d 50 08             	lea    0x8(%eax),%edx
  80179f:	89 55 14             	mov    %edx,0x14(%ebp)
  8017a2:	8b 30                	mov    (%eax),%esi
  8017a4:	8b 78 04             	mov    0x4(%eax),%edi
  8017a7:	eb 26                	jmp    8017cf <vprintfmt+0x2c5>
	else if (lflag)
  8017a9:	85 c9                	test   %ecx,%ecx
  8017ab:	74 12                	je     8017bf <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8017ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b0:	8d 50 04             	lea    0x4(%eax),%edx
  8017b3:	89 55 14             	mov    %edx,0x14(%ebp)
  8017b6:	8b 30                	mov    (%eax),%esi
  8017b8:	89 f7                	mov    %esi,%edi
  8017ba:	c1 ff 1f             	sar    $0x1f,%edi
  8017bd:	eb 10                	jmp    8017cf <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8017bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c2:	8d 50 04             	lea    0x4(%eax),%edx
  8017c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8017c8:	8b 30                	mov    (%eax),%esi
  8017ca:	89 f7                	mov    %esi,%edi
  8017cc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8017cf:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8017d4:	85 ff                	test   %edi,%edi
  8017d6:	0f 89 8c 00 00 00    	jns    801868 <vprintfmt+0x35e>
				putch('-', putdat);
  8017dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017e0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8017e7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8017ea:	f7 de                	neg    %esi
  8017ec:	83 d7 00             	adc    $0x0,%edi
  8017ef:	f7 df                	neg    %edi
			}
			base = 10;
  8017f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8017f6:	eb 70                	jmp    801868 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8017f8:	89 ca                	mov    %ecx,%edx
  8017fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8017fd:	e8 89 fc ff ff       	call   80148b <getuint>
  801802:	89 c6                	mov    %eax,%esi
  801804:	89 d7                	mov    %edx,%edi
			base = 10;
  801806:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80180b:	eb 5b                	jmp    801868 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80180d:	89 ca                	mov    %ecx,%edx
  80180f:	8d 45 14             	lea    0x14(%ebp),%eax
  801812:	e8 74 fc ff ff       	call   80148b <getuint>
  801817:	89 c6                	mov    %eax,%esi
  801819:	89 d7                	mov    %edx,%edi
			base = 8;
  80181b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  801820:	eb 46                	jmp    801868 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  801822:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801826:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80182d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801830:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801834:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80183b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80183e:	8b 45 14             	mov    0x14(%ebp),%eax
  801841:	8d 50 04             	lea    0x4(%eax),%edx
  801844:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801847:	8b 30                	mov    (%eax),%esi
  801849:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80184e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  801853:	eb 13                	jmp    801868 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801855:	89 ca                	mov    %ecx,%edx
  801857:	8d 45 14             	lea    0x14(%ebp),%eax
  80185a:	e8 2c fc ff ff       	call   80148b <getuint>
  80185f:	89 c6                	mov    %eax,%esi
  801861:	89 d7                	mov    %edx,%edi
			base = 16;
  801863:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  801868:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80186c:	89 54 24 10          	mov    %edx,0x10(%esp)
  801870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801873:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801877:	89 44 24 08          	mov    %eax,0x8(%esp)
  80187b:	89 34 24             	mov    %esi,(%esp)
  80187e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801882:	89 da                	mov    %ebx,%edx
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	e8 24 fb ff ff       	call   8013b0 <printnum>
			break;
  80188c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80188f:	e9 99 fc ff ff       	jmp    80152d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801894:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801898:	89 14 24             	mov    %edx,(%esp)
  80189b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80189e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8018a1:	e9 87 fc ff ff       	jmp    80152d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8018a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018aa:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8018b1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8018b4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8018b8:	0f 84 6f fc ff ff    	je     80152d <vprintfmt+0x23>
  8018be:	83 ee 01             	sub    $0x1,%esi
  8018c1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8018c5:	75 f7                	jne    8018be <vprintfmt+0x3b4>
  8018c7:	e9 61 fc ff ff       	jmp    80152d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8018cc:	83 c4 4c             	add    $0x4c,%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5f                   	pop    %edi
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    

008018d4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	83 ec 28             	sub    $0x28,%esp
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8018e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018e3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8018e7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8018ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	74 30                	je     801925 <vsnprintf+0x51>
  8018f5:	85 d2                	test   %edx,%edx
  8018f7:	7e 2c                	jle    801925 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8018f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801900:	8b 45 10             	mov    0x10(%ebp),%eax
  801903:	89 44 24 08          	mov    %eax,0x8(%esp)
  801907:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80190a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190e:	c7 04 24 c5 14 80 00 	movl   $0x8014c5,(%esp)
  801915:	e8 f0 fb ff ff       	call   80150a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80191a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801923:	eb 05                	jmp    80192a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801925:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801932:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801935:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801939:	8b 45 10             	mov    0x10(%ebp),%eax
  80193c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	89 44 24 04          	mov    %eax,0x4(%esp)
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	89 04 24             	mov    %eax,(%esp)
  80194d:	e8 82 ff ff ff       	call   8018d4 <vsnprintf>
	va_end(ap);

	return rc;
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    
	...

00801960 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	80 3a 00             	cmpb   $0x0,(%edx)
  80196e:	74 09                	je     801979 <strlen+0x19>
		n++;
  801970:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801973:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801977:	75 f7                	jne    801970 <strlen+0x10>
		n++;
	return n;
}
  801979:	5d                   	pop    %ebp
  80197a:	c3                   	ret    

0080197b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	53                   	push   %ebx
  80197f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801982:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801985:	b8 00 00 00 00       	mov    $0x0,%eax
  80198a:	85 c9                	test   %ecx,%ecx
  80198c:	74 1a                	je     8019a8 <strnlen+0x2d>
  80198e:	80 3b 00             	cmpb   $0x0,(%ebx)
  801991:	74 15                	je     8019a8 <strnlen+0x2d>
  801993:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  801998:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80199a:	39 ca                	cmp    %ecx,%edx
  80199c:	74 0a                	je     8019a8 <strnlen+0x2d>
  80199e:	83 c2 01             	add    $0x1,%edx
  8019a1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8019a6:	75 f0                	jne    801998 <strnlen+0x1d>
		n++;
	return n;
}
  8019a8:	5b                   	pop    %ebx
  8019a9:	5d                   	pop    %ebp
  8019aa:	c3                   	ret    

008019ab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	53                   	push   %ebx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8019b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ba:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8019be:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8019c1:	83 c2 01             	add    $0x1,%edx
  8019c4:	84 c9                	test   %cl,%cl
  8019c6:	75 f2                	jne    8019ba <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8019c8:	5b                   	pop    %ebx
  8019c9:	5d                   	pop    %ebp
  8019ca:	c3                   	ret    

008019cb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	53                   	push   %ebx
  8019cf:	83 ec 08             	sub    $0x8,%esp
  8019d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8019d5:	89 1c 24             	mov    %ebx,(%esp)
  8019d8:	e8 83 ff ff ff       	call   801960 <strlen>
	strcpy(dst + len, src);
  8019dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019e4:	01 d8                	add    %ebx,%eax
  8019e6:	89 04 24             	mov    %eax,(%esp)
  8019e9:	e8 bd ff ff ff       	call   8019ab <strcpy>
	return dst;
}
  8019ee:	89 d8                	mov    %ebx,%eax
  8019f0:	83 c4 08             	add    $0x8,%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5d                   	pop    %ebp
  8019f5:	c3                   	ret    

008019f6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	56                   	push   %esi
  8019fa:	53                   	push   %ebx
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a01:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a04:	85 f6                	test   %esi,%esi
  801a06:	74 18                	je     801a20 <strncpy+0x2a>
  801a08:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  801a0d:	0f b6 1a             	movzbl (%edx),%ebx
  801a10:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801a13:	80 3a 01             	cmpb   $0x1,(%edx)
  801a16:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a19:	83 c1 01             	add    $0x1,%ecx
  801a1c:	39 f1                	cmp    %esi,%ecx
  801a1e:	75 ed                	jne    801a0d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801a20:	5b                   	pop    %ebx
  801a21:	5e                   	pop    %esi
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    

00801a24 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	57                   	push   %edi
  801a28:	56                   	push   %esi
  801a29:	53                   	push   %ebx
  801a2a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a30:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801a33:	89 f8                	mov    %edi,%eax
  801a35:	85 f6                	test   %esi,%esi
  801a37:	74 2b                	je     801a64 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  801a39:	83 fe 01             	cmp    $0x1,%esi
  801a3c:	74 23                	je     801a61 <strlcpy+0x3d>
  801a3e:	0f b6 0b             	movzbl (%ebx),%ecx
  801a41:	84 c9                	test   %cl,%cl
  801a43:	74 1c                	je     801a61 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  801a45:	83 ee 02             	sub    $0x2,%esi
  801a48:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801a4d:	88 08                	mov    %cl,(%eax)
  801a4f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a52:	39 f2                	cmp    %esi,%edx
  801a54:	74 0b                	je     801a61 <strlcpy+0x3d>
  801a56:	83 c2 01             	add    $0x1,%edx
  801a59:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801a5d:	84 c9                	test   %cl,%cl
  801a5f:	75 ec                	jne    801a4d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  801a61:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801a64:	29 f8                	sub    %edi,%eax
}
  801a66:	5b                   	pop    %ebx
  801a67:	5e                   	pop    %esi
  801a68:	5f                   	pop    %edi
  801a69:	5d                   	pop    %ebp
  801a6a:	c3                   	ret    

00801a6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a71:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801a74:	0f b6 01             	movzbl (%ecx),%eax
  801a77:	84 c0                	test   %al,%al
  801a79:	74 16                	je     801a91 <strcmp+0x26>
  801a7b:	3a 02                	cmp    (%edx),%al
  801a7d:	75 12                	jne    801a91 <strcmp+0x26>
		p++, q++;
  801a7f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a82:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  801a86:	84 c0                	test   %al,%al
  801a88:	74 07                	je     801a91 <strcmp+0x26>
  801a8a:	83 c1 01             	add    $0x1,%ecx
  801a8d:	3a 02                	cmp    (%edx),%al
  801a8f:	74 ee                	je     801a7f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a91:	0f b6 c0             	movzbl %al,%eax
  801a94:	0f b6 12             	movzbl (%edx),%edx
  801a97:	29 d0                	sub    %edx,%eax
}
  801a99:	5d                   	pop    %ebp
  801a9a:	c3                   	ret    

00801a9b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	53                   	push   %ebx
  801a9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801aa5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801aa8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801aad:	85 d2                	test   %edx,%edx
  801aaf:	74 28                	je     801ad9 <strncmp+0x3e>
  801ab1:	0f b6 01             	movzbl (%ecx),%eax
  801ab4:	84 c0                	test   %al,%al
  801ab6:	74 24                	je     801adc <strncmp+0x41>
  801ab8:	3a 03                	cmp    (%ebx),%al
  801aba:	75 20                	jne    801adc <strncmp+0x41>
  801abc:	83 ea 01             	sub    $0x1,%edx
  801abf:	74 13                	je     801ad4 <strncmp+0x39>
		n--, p++, q++;
  801ac1:	83 c1 01             	add    $0x1,%ecx
  801ac4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ac7:	0f b6 01             	movzbl (%ecx),%eax
  801aca:	84 c0                	test   %al,%al
  801acc:	74 0e                	je     801adc <strncmp+0x41>
  801ace:	3a 03                	cmp    (%ebx),%al
  801ad0:	74 ea                	je     801abc <strncmp+0x21>
  801ad2:	eb 08                	jmp    801adc <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801ad9:	5b                   	pop    %ebx
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801adc:	0f b6 01             	movzbl (%ecx),%eax
  801adf:	0f b6 13             	movzbl (%ebx),%edx
  801ae2:	29 d0                	sub    %edx,%eax
  801ae4:	eb f3                	jmp    801ad9 <strncmp+0x3e>

00801ae6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801af0:	0f b6 10             	movzbl (%eax),%edx
  801af3:	84 d2                	test   %dl,%dl
  801af5:	74 1c                	je     801b13 <strchr+0x2d>
		if (*s == c)
  801af7:	38 ca                	cmp    %cl,%dl
  801af9:	75 09                	jne    801b04 <strchr+0x1e>
  801afb:	eb 1b                	jmp    801b18 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801afd:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  801b00:	38 ca                	cmp    %cl,%dl
  801b02:	74 14                	je     801b18 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b04:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  801b08:	84 d2                	test   %dl,%dl
  801b0a:	75 f1                	jne    801afd <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b11:	eb 05                	jmp    801b18 <strchr+0x32>
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b18:	5d                   	pop    %ebp
  801b19:	c3                   	ret    

00801b1a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801b24:	0f b6 10             	movzbl (%eax),%edx
  801b27:	84 d2                	test   %dl,%dl
  801b29:	74 14                	je     801b3f <strfind+0x25>
		if (*s == c)
  801b2b:	38 ca                	cmp    %cl,%dl
  801b2d:	75 06                	jne    801b35 <strfind+0x1b>
  801b2f:	eb 0e                	jmp    801b3f <strfind+0x25>
  801b31:	38 ca                	cmp    %cl,%dl
  801b33:	74 0a                	je     801b3f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b35:	83 c0 01             	add    $0x1,%eax
  801b38:	0f b6 10             	movzbl (%eax),%edx
  801b3b:	84 d2                	test   %dl,%dl
  801b3d:	75 f2                	jne    801b31 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  801b3f:	5d                   	pop    %ebp
  801b40:	c3                   	ret    

00801b41 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 0c             	sub    $0xc,%esp
  801b47:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b4a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b4d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b50:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b56:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801b59:	85 c9                	test   %ecx,%ecx
  801b5b:	74 30                	je     801b8d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801b5d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801b63:	75 25                	jne    801b8a <memset+0x49>
  801b65:	f6 c1 03             	test   $0x3,%cl
  801b68:	75 20                	jne    801b8a <memset+0x49>
		c &= 0xFF;
  801b6a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801b6d:	89 d3                	mov    %edx,%ebx
  801b6f:	c1 e3 08             	shl    $0x8,%ebx
  801b72:	89 d6                	mov    %edx,%esi
  801b74:	c1 e6 18             	shl    $0x18,%esi
  801b77:	89 d0                	mov    %edx,%eax
  801b79:	c1 e0 10             	shl    $0x10,%eax
  801b7c:	09 f0                	or     %esi,%eax
  801b7e:	09 d0                	or     %edx,%eax
  801b80:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801b82:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801b85:	fc                   	cld    
  801b86:	f3 ab                	rep stos %eax,%es:(%edi)
  801b88:	eb 03                	jmp    801b8d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801b8a:	fc                   	cld    
  801b8b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801b8d:	89 f8                	mov    %edi,%eax
  801b8f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b92:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b95:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b98:	89 ec                	mov    %ebp,%esp
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    

00801b9c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 08             	sub    $0x8,%esp
  801ba2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ba5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801bb1:	39 c6                	cmp    %eax,%esi
  801bb3:	73 36                	jae    801beb <memmove+0x4f>
  801bb5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801bb8:	39 d0                	cmp    %edx,%eax
  801bba:	73 2f                	jae    801beb <memmove+0x4f>
		s += n;
		d += n;
  801bbc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801bbf:	f6 c2 03             	test   $0x3,%dl
  801bc2:	75 1b                	jne    801bdf <memmove+0x43>
  801bc4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801bca:	75 13                	jne    801bdf <memmove+0x43>
  801bcc:	f6 c1 03             	test   $0x3,%cl
  801bcf:	75 0e                	jne    801bdf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801bd1:	83 ef 04             	sub    $0x4,%edi
  801bd4:	8d 72 fc             	lea    -0x4(%edx),%esi
  801bd7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801bda:	fd                   	std    
  801bdb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801bdd:	eb 09                	jmp    801be8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801bdf:	83 ef 01             	sub    $0x1,%edi
  801be2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801be5:	fd                   	std    
  801be6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801be8:	fc                   	cld    
  801be9:	eb 20                	jmp    801c0b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801beb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801bf1:	75 13                	jne    801c06 <memmove+0x6a>
  801bf3:	a8 03                	test   $0x3,%al
  801bf5:	75 0f                	jne    801c06 <memmove+0x6a>
  801bf7:	f6 c1 03             	test   $0x3,%cl
  801bfa:	75 0a                	jne    801c06 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801bfc:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801bff:	89 c7                	mov    %eax,%edi
  801c01:	fc                   	cld    
  801c02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801c04:	eb 05                	jmp    801c0b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801c06:	89 c7                	mov    %eax,%edi
  801c08:	fc                   	cld    
  801c09:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801c0b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c0e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c11:	89 ec                	mov    %ebp,%esp
  801c13:	5d                   	pop    %ebp
  801c14:	c3                   	ret    

00801c15 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801c1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	89 04 24             	mov    %eax,(%esp)
  801c2f:	e8 68 ff ff ff       	call   801b9c <memmove>
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	57                   	push   %edi
  801c3a:	56                   	push   %esi
  801c3b:	53                   	push   %ebx
  801c3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c42:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c4a:	85 ff                	test   %edi,%edi
  801c4c:	74 37                	je     801c85 <memcmp+0x4f>
		if (*s1 != *s2)
  801c4e:	0f b6 03             	movzbl (%ebx),%eax
  801c51:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c54:	83 ef 01             	sub    $0x1,%edi
  801c57:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  801c5c:	38 c8                	cmp    %cl,%al
  801c5e:	74 1c                	je     801c7c <memcmp+0x46>
  801c60:	eb 10                	jmp    801c72 <memcmp+0x3c>
  801c62:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801c67:	83 c2 01             	add    $0x1,%edx
  801c6a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801c6e:	38 c8                	cmp    %cl,%al
  801c70:	74 0a                	je     801c7c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  801c72:	0f b6 c0             	movzbl %al,%eax
  801c75:	0f b6 c9             	movzbl %cl,%ecx
  801c78:	29 c8                	sub    %ecx,%eax
  801c7a:	eb 09                	jmp    801c85 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c7c:	39 fa                	cmp    %edi,%edx
  801c7e:	75 e2                	jne    801c62 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c85:	5b                   	pop    %ebx
  801c86:	5e                   	pop    %esi
  801c87:	5f                   	pop    %edi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    

00801c8a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801c90:	89 c2                	mov    %eax,%edx
  801c92:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801c95:	39 d0                	cmp    %edx,%eax
  801c97:	73 19                	jae    801cb2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c99:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801c9d:	38 08                	cmp    %cl,(%eax)
  801c9f:	75 06                	jne    801ca7 <memfind+0x1d>
  801ca1:	eb 0f                	jmp    801cb2 <memfind+0x28>
  801ca3:	38 08                	cmp    %cl,(%eax)
  801ca5:	74 0b                	je     801cb2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801ca7:	83 c0 01             	add    $0x1,%eax
  801caa:	39 d0                	cmp    %edx,%eax
  801cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801cb0:	75 f1                	jne    801ca3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    

00801cb4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	57                   	push   %edi
  801cb8:	56                   	push   %esi
  801cb9:	53                   	push   %ebx
  801cba:	8b 55 08             	mov    0x8(%ebp),%edx
  801cbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801cc0:	0f b6 02             	movzbl (%edx),%eax
  801cc3:	3c 20                	cmp    $0x20,%al
  801cc5:	74 04                	je     801ccb <strtol+0x17>
  801cc7:	3c 09                	cmp    $0x9,%al
  801cc9:	75 0e                	jne    801cd9 <strtol+0x25>
		s++;
  801ccb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801cce:	0f b6 02             	movzbl (%edx),%eax
  801cd1:	3c 20                	cmp    $0x20,%al
  801cd3:	74 f6                	je     801ccb <strtol+0x17>
  801cd5:	3c 09                	cmp    $0x9,%al
  801cd7:	74 f2                	je     801ccb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  801cd9:	3c 2b                	cmp    $0x2b,%al
  801cdb:	75 0a                	jne    801ce7 <strtol+0x33>
		s++;
  801cdd:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801ce0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ce5:	eb 10                	jmp    801cf7 <strtol+0x43>
  801ce7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801cec:	3c 2d                	cmp    $0x2d,%al
  801cee:	75 07                	jne    801cf7 <strtol+0x43>
		s++, neg = 1;
  801cf0:	83 c2 01             	add    $0x1,%edx
  801cf3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801cf7:	85 db                	test   %ebx,%ebx
  801cf9:	0f 94 c0             	sete   %al
  801cfc:	74 05                	je     801d03 <strtol+0x4f>
  801cfe:	83 fb 10             	cmp    $0x10,%ebx
  801d01:	75 15                	jne    801d18 <strtol+0x64>
  801d03:	80 3a 30             	cmpb   $0x30,(%edx)
  801d06:	75 10                	jne    801d18 <strtol+0x64>
  801d08:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801d0c:	75 0a                	jne    801d18 <strtol+0x64>
		s += 2, base = 16;
  801d0e:	83 c2 02             	add    $0x2,%edx
  801d11:	bb 10 00 00 00       	mov    $0x10,%ebx
  801d16:	eb 13                	jmp    801d2b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  801d18:	84 c0                	test   %al,%al
  801d1a:	74 0f                	je     801d2b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801d1c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801d21:	80 3a 30             	cmpb   $0x30,(%edx)
  801d24:	75 05                	jne    801d2b <strtol+0x77>
		s++, base = 8;
  801d26:	83 c2 01             	add    $0x1,%edx
  801d29:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  801d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d30:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d32:	0f b6 0a             	movzbl (%edx),%ecx
  801d35:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801d38:	80 fb 09             	cmp    $0x9,%bl
  801d3b:	77 08                	ja     801d45 <strtol+0x91>
			dig = *s - '0';
  801d3d:	0f be c9             	movsbl %cl,%ecx
  801d40:	83 e9 30             	sub    $0x30,%ecx
  801d43:	eb 1e                	jmp    801d63 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  801d45:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  801d48:	80 fb 19             	cmp    $0x19,%bl
  801d4b:	77 08                	ja     801d55 <strtol+0xa1>
			dig = *s - 'a' + 10;
  801d4d:	0f be c9             	movsbl %cl,%ecx
  801d50:	83 e9 57             	sub    $0x57,%ecx
  801d53:	eb 0e                	jmp    801d63 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  801d55:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  801d58:	80 fb 19             	cmp    $0x19,%bl
  801d5b:	77 14                	ja     801d71 <strtol+0xbd>
			dig = *s - 'A' + 10;
  801d5d:	0f be c9             	movsbl %cl,%ecx
  801d60:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801d63:	39 f1                	cmp    %esi,%ecx
  801d65:	7d 0e                	jge    801d75 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801d67:	83 c2 01             	add    $0x1,%edx
  801d6a:	0f af c6             	imul   %esi,%eax
  801d6d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  801d6f:	eb c1                	jmp    801d32 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  801d71:	89 c1                	mov    %eax,%ecx
  801d73:	eb 02                	jmp    801d77 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801d75:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d7b:	74 05                	je     801d82 <strtol+0xce>
		*endptr = (char *) s;
  801d7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d80:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801d82:	89 ca                	mov    %ecx,%edx
  801d84:	f7 da                	neg    %edx
  801d86:	85 ff                	test   %edi,%edi
  801d88:	0f 45 c2             	cmovne %edx,%eax
}
  801d8b:	5b                   	pop    %ebx
  801d8c:	5e                   	pop    %esi
  801d8d:	5f                   	pop    %edi
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    

00801d90 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	56                   	push   %esi
  801d94:	53                   	push   %ebx
  801d95:	83 ec 10             	sub    $0x10,%esp
  801d98:	8b 75 08             	mov    0x8(%ebp),%esi
  801d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801da1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801da3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801da8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801dab:	89 04 24             	mov    %eax,(%esp)
  801dae:	e8 8a e6 ff ff       	call   80043d <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801db3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801db8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	78 0e                	js     801dcf <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801dc1:	a1 04 40 80 00       	mov    0x804004,%eax
  801dc6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801dc9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801dcc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801dcf:	85 f6                	test   %esi,%esi
  801dd1:	74 02                	je     801dd5 <ipc_recv+0x45>
		*from_env_store = sender;
  801dd3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801dd5:	85 db                	test   %ebx,%ebx
  801dd7:	74 02                	je     801ddb <ipc_recv+0x4b>
		*perm_store = perm;
  801dd9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801ddb:	83 c4 10             	add    $0x10,%esp
  801dde:	5b                   	pop    %ebx
  801ddf:	5e                   	pop    %esi
  801de0:	5d                   	pop    %ebp
  801de1:	c3                   	ret    

00801de2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	57                   	push   %edi
  801de6:	56                   	push   %esi
  801de7:	53                   	push   %ebx
  801de8:	83 ec 1c             	sub    $0x1c,%esp
  801deb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801dee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801df1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801df4:	85 db                	test   %ebx,%ebx
  801df6:	75 04                	jne    801dfc <ipc_send+0x1a>
  801df8:	85 f6                	test   %esi,%esi
  801dfa:	75 15                	jne    801e11 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801dfc:	85 db                	test   %ebx,%ebx
  801dfe:	74 16                	je     801e16 <ipc_send+0x34>
  801e00:	85 f6                	test   %esi,%esi
  801e02:	0f 94 c0             	sete   %al
      pg = 0;
  801e05:	84 c0                	test   %al,%al
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0c:	0f 45 d8             	cmovne %eax,%ebx
  801e0f:	eb 05                	jmp    801e16 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801e11:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801e16:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e1a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e1e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	89 04 24             	mov    %eax,(%esp)
  801e28:	e8 dc e5 ff ff       	call   800409 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801e2d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e30:	75 07                	jne    801e39 <ipc_send+0x57>
           sys_yield();
  801e32:	e8 6d e3 ff ff       	call   8001a4 <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801e37:	eb dd                	jmp    801e16 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	90                   	nop
  801e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e40:	74 1c                	je     801e5e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801e42:	c7 44 24 08 e0 25 80 	movl   $0x8025e0,0x8(%esp)
  801e49:	00 
  801e4a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801e51:	00 
  801e52:	c7 04 24 ea 25 80 00 	movl   $0x8025ea,(%esp)
  801e59:	e8 32 f4 ff ff       	call   801290 <_panic>
		}
    }
}
  801e5e:	83 c4 1c             	add    $0x1c,%esp
  801e61:	5b                   	pop    %ebx
  801e62:	5e                   	pop    %esi
  801e63:	5f                   	pop    %edi
  801e64:	5d                   	pop    %ebp
  801e65:	c3                   	ret    

00801e66 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e6c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801e71:	39 c8                	cmp    %ecx,%eax
  801e73:	74 17                	je     801e8c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e75:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e7a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e7d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e83:	8b 52 50             	mov    0x50(%edx),%edx
  801e86:	39 ca                	cmp    %ecx,%edx
  801e88:	75 14                	jne    801e9e <ipc_find_env+0x38>
  801e8a:	eb 05                	jmp    801e91 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e8c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801e91:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e94:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801e99:	8b 40 40             	mov    0x40(%eax),%eax
  801e9c:	eb 0e                	jmp    801eac <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e9e:	83 c0 01             	add    $0x1,%eax
  801ea1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ea6:	75 d2                	jne    801e7a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801ea8:	66 b8 00 00          	mov    $0x0,%ax
}
  801eac:	5d                   	pop    %ebp
  801ead:	c3                   	ret    
	...

00801eb0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801eb6:	89 d0                	mov    %edx,%eax
  801eb8:	c1 e8 16             	shr    $0x16,%eax
  801ebb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ec2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ec7:	f6 c1 01             	test   $0x1,%cl
  801eca:	74 1d                	je     801ee9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801ecc:	c1 ea 0c             	shr    $0xc,%edx
  801ecf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ed6:	f6 c2 01             	test   $0x1,%dl
  801ed9:	74 0e                	je     801ee9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801edb:	c1 ea 0c             	shr    $0xc,%edx
  801ede:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ee5:	ef 
  801ee6:	0f b7 c0             	movzwl %ax,%eax
}
  801ee9:	5d                   	pop    %ebp
  801eea:	c3                   	ret    
  801eeb:	00 00                	add    %al,(%eax)
  801eed:	00 00                	add    %al,(%eax)
	...

00801ef0 <__udivdi3>:
  801ef0:	83 ec 1c             	sub    $0x1c,%esp
  801ef3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801ef7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801efb:	8b 44 24 20          	mov    0x20(%esp),%eax
  801eff:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801f03:	89 74 24 10          	mov    %esi,0x10(%esp)
  801f07:	8b 74 24 24          	mov    0x24(%esp),%esi
  801f0b:	85 ff                	test   %edi,%edi
  801f0d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801f11:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f15:	89 cd                	mov    %ecx,%ebp
  801f17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1b:	75 33                	jne    801f50 <__udivdi3+0x60>
  801f1d:	39 f1                	cmp    %esi,%ecx
  801f1f:	77 57                	ja     801f78 <__udivdi3+0x88>
  801f21:	85 c9                	test   %ecx,%ecx
  801f23:	75 0b                	jne    801f30 <__udivdi3+0x40>
  801f25:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2a:	31 d2                	xor    %edx,%edx
  801f2c:	f7 f1                	div    %ecx
  801f2e:	89 c1                	mov    %eax,%ecx
  801f30:	89 f0                	mov    %esi,%eax
  801f32:	31 d2                	xor    %edx,%edx
  801f34:	f7 f1                	div    %ecx
  801f36:	89 c6                	mov    %eax,%esi
  801f38:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f3c:	f7 f1                	div    %ecx
  801f3e:	89 f2                	mov    %esi,%edx
  801f40:	8b 74 24 10          	mov    0x10(%esp),%esi
  801f44:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801f48:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801f4c:	83 c4 1c             	add    $0x1c,%esp
  801f4f:	c3                   	ret    
  801f50:	31 d2                	xor    %edx,%edx
  801f52:	31 c0                	xor    %eax,%eax
  801f54:	39 f7                	cmp    %esi,%edi
  801f56:	77 e8                	ja     801f40 <__udivdi3+0x50>
  801f58:	0f bd cf             	bsr    %edi,%ecx
  801f5b:	83 f1 1f             	xor    $0x1f,%ecx
  801f5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f62:	75 2c                	jne    801f90 <__udivdi3+0xa0>
  801f64:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  801f68:	76 04                	jbe    801f6e <__udivdi3+0x7e>
  801f6a:	39 f7                	cmp    %esi,%edi
  801f6c:	73 d2                	jae    801f40 <__udivdi3+0x50>
  801f6e:	31 d2                	xor    %edx,%edx
  801f70:	b8 01 00 00 00       	mov    $0x1,%eax
  801f75:	eb c9                	jmp    801f40 <__udivdi3+0x50>
  801f77:	90                   	nop
  801f78:	89 f2                	mov    %esi,%edx
  801f7a:	f7 f1                	div    %ecx
  801f7c:	31 d2                	xor    %edx,%edx
  801f7e:	8b 74 24 10          	mov    0x10(%esp),%esi
  801f82:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801f86:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801f8a:	83 c4 1c             	add    $0x1c,%esp
  801f8d:	c3                   	ret    
  801f8e:	66 90                	xchg   %ax,%ax
  801f90:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f95:	b8 20 00 00 00       	mov    $0x20,%eax
  801f9a:	89 ea                	mov    %ebp,%edx
  801f9c:	2b 44 24 04          	sub    0x4(%esp),%eax
  801fa0:	d3 e7                	shl    %cl,%edi
  801fa2:	89 c1                	mov    %eax,%ecx
  801fa4:	d3 ea                	shr    %cl,%edx
  801fa6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fab:	09 fa                	or     %edi,%edx
  801fad:	89 f7                	mov    %esi,%edi
  801faf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fb3:	89 f2                	mov    %esi,%edx
  801fb5:	8b 74 24 08          	mov    0x8(%esp),%esi
  801fb9:	d3 e5                	shl    %cl,%ebp
  801fbb:	89 c1                	mov    %eax,%ecx
  801fbd:	d3 ef                	shr    %cl,%edi
  801fbf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fc4:	d3 e2                	shl    %cl,%edx
  801fc6:	89 c1                	mov    %eax,%ecx
  801fc8:	d3 ee                	shr    %cl,%esi
  801fca:	09 d6                	or     %edx,%esi
  801fcc:	89 fa                	mov    %edi,%edx
  801fce:	89 f0                	mov    %esi,%eax
  801fd0:	f7 74 24 0c          	divl   0xc(%esp)
  801fd4:	89 d7                	mov    %edx,%edi
  801fd6:	89 c6                	mov    %eax,%esi
  801fd8:	f7 e5                	mul    %ebp
  801fda:	39 d7                	cmp    %edx,%edi
  801fdc:	72 22                	jb     802000 <__udivdi3+0x110>
  801fde:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  801fe2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fe7:	d3 e5                	shl    %cl,%ebp
  801fe9:	39 c5                	cmp    %eax,%ebp
  801feb:	73 04                	jae    801ff1 <__udivdi3+0x101>
  801fed:	39 d7                	cmp    %edx,%edi
  801fef:	74 0f                	je     802000 <__udivdi3+0x110>
  801ff1:	89 f0                	mov    %esi,%eax
  801ff3:	31 d2                	xor    %edx,%edx
  801ff5:	e9 46 ff ff ff       	jmp    801f40 <__udivdi3+0x50>
  801ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802000:	8d 46 ff             	lea    -0x1(%esi),%eax
  802003:	31 d2                	xor    %edx,%edx
  802005:	8b 74 24 10          	mov    0x10(%esp),%esi
  802009:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80200d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802011:	83 c4 1c             	add    $0x1c,%esp
  802014:	c3                   	ret    
	...

00802020 <__umoddi3>:
  802020:	83 ec 1c             	sub    $0x1c,%esp
  802023:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802027:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80202b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80202f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802033:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802037:	8b 74 24 24          	mov    0x24(%esp),%esi
  80203b:	85 ed                	test   %ebp,%ebp
  80203d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802041:	89 44 24 08          	mov    %eax,0x8(%esp)
  802045:	89 cf                	mov    %ecx,%edi
  802047:	89 04 24             	mov    %eax,(%esp)
  80204a:	89 f2                	mov    %esi,%edx
  80204c:	75 1a                	jne    802068 <__umoddi3+0x48>
  80204e:	39 f1                	cmp    %esi,%ecx
  802050:	76 4e                	jbe    8020a0 <__umoddi3+0x80>
  802052:	f7 f1                	div    %ecx
  802054:	89 d0                	mov    %edx,%eax
  802056:	31 d2                	xor    %edx,%edx
  802058:	8b 74 24 10          	mov    0x10(%esp),%esi
  80205c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802060:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802064:	83 c4 1c             	add    $0x1c,%esp
  802067:	c3                   	ret    
  802068:	39 f5                	cmp    %esi,%ebp
  80206a:	77 54                	ja     8020c0 <__umoddi3+0xa0>
  80206c:	0f bd c5             	bsr    %ebp,%eax
  80206f:	83 f0 1f             	xor    $0x1f,%eax
  802072:	89 44 24 04          	mov    %eax,0x4(%esp)
  802076:	75 60                	jne    8020d8 <__umoddi3+0xb8>
  802078:	3b 0c 24             	cmp    (%esp),%ecx
  80207b:	0f 87 07 01 00 00    	ja     802188 <__umoddi3+0x168>
  802081:	89 f2                	mov    %esi,%edx
  802083:	8b 34 24             	mov    (%esp),%esi
  802086:	29 ce                	sub    %ecx,%esi
  802088:	19 ea                	sbb    %ebp,%edx
  80208a:	89 34 24             	mov    %esi,(%esp)
  80208d:	8b 04 24             	mov    (%esp),%eax
  802090:	8b 74 24 10          	mov    0x10(%esp),%esi
  802094:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802098:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80209c:	83 c4 1c             	add    $0x1c,%esp
  80209f:	c3                   	ret    
  8020a0:	85 c9                	test   %ecx,%ecx
  8020a2:	75 0b                	jne    8020af <__umoddi3+0x8f>
  8020a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a9:	31 d2                	xor    %edx,%edx
  8020ab:	f7 f1                	div    %ecx
  8020ad:	89 c1                	mov    %eax,%ecx
  8020af:	89 f0                	mov    %esi,%eax
  8020b1:	31 d2                	xor    %edx,%edx
  8020b3:	f7 f1                	div    %ecx
  8020b5:	8b 04 24             	mov    (%esp),%eax
  8020b8:	f7 f1                	div    %ecx
  8020ba:	eb 98                	jmp    802054 <__umoddi3+0x34>
  8020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020c0:	89 f2                	mov    %esi,%edx
  8020c2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020c6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020ca:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020ce:	83 c4 1c             	add    $0x1c,%esp
  8020d1:	c3                   	ret    
  8020d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020d8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020dd:	89 e8                	mov    %ebp,%eax
  8020df:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020e4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8020e8:	89 fa                	mov    %edi,%edx
  8020ea:	d3 e0                	shl    %cl,%eax
  8020ec:	89 e9                	mov    %ebp,%ecx
  8020ee:	d3 ea                	shr    %cl,%edx
  8020f0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020f5:	09 c2                	or     %eax,%edx
  8020f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020fb:	89 14 24             	mov    %edx,(%esp)
  8020fe:	89 f2                	mov    %esi,%edx
  802100:	d3 e7                	shl    %cl,%edi
  802102:	89 e9                	mov    %ebp,%ecx
  802104:	d3 ea                	shr    %cl,%edx
  802106:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80210b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80210f:	d3 e6                	shl    %cl,%esi
  802111:	89 e9                	mov    %ebp,%ecx
  802113:	d3 e8                	shr    %cl,%eax
  802115:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80211a:	09 f0                	or     %esi,%eax
  80211c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802120:	f7 34 24             	divl   (%esp)
  802123:	d3 e6                	shl    %cl,%esi
  802125:	89 74 24 08          	mov    %esi,0x8(%esp)
  802129:	89 d6                	mov    %edx,%esi
  80212b:	f7 e7                	mul    %edi
  80212d:	39 d6                	cmp    %edx,%esi
  80212f:	89 c1                	mov    %eax,%ecx
  802131:	89 d7                	mov    %edx,%edi
  802133:	72 3f                	jb     802174 <__umoddi3+0x154>
  802135:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802139:	72 35                	jb     802170 <__umoddi3+0x150>
  80213b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80213f:	29 c8                	sub    %ecx,%eax
  802141:	19 fe                	sbb    %edi,%esi
  802143:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802148:	89 f2                	mov    %esi,%edx
  80214a:	d3 e8                	shr    %cl,%eax
  80214c:	89 e9                	mov    %ebp,%ecx
  80214e:	d3 e2                	shl    %cl,%edx
  802150:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802155:	09 d0                	or     %edx,%eax
  802157:	89 f2                	mov    %esi,%edx
  802159:	d3 ea                	shr    %cl,%edx
  80215b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80215f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802163:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802167:	83 c4 1c             	add    $0x1c,%esp
  80216a:	c3                   	ret    
  80216b:	90                   	nop
  80216c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802170:	39 d6                	cmp    %edx,%esi
  802172:	75 c7                	jne    80213b <__umoddi3+0x11b>
  802174:	89 d7                	mov    %edx,%edi
  802176:	89 c1                	mov    %eax,%ecx
  802178:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80217c:	1b 3c 24             	sbb    (%esp),%edi
  80217f:	eb ba                	jmp    80213b <__umoddi3+0x11b>
  802181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802188:	39 f5                	cmp    %esi,%ebp
  80218a:	0f 82 f1 fe ff ff    	jb     802081 <__umoddi3+0x61>
  802190:	e9 f8 fe ff ff       	jmp    80208d <__umoddi3+0x6d>
