
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 0f 00 00 00       	call   800040 <libmain>
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
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800037:	66 b8 28 00          	mov    $0x28,%ax
  80003b:	8e d8                	mov    %eax,%ds
}
  80003d:	5d                   	pop    %ebp
  80003e:	c3                   	ret    
	...

00800040 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
  800046:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800049:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80004c:	8b 75 08             	mov    0x8(%ebp),%esi
  80004f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800052:	e8 11 01 00 00       	call   800168 <sys_getenvid>
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800064:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800069:	85 f6                	test   %esi,%esi
  80006b:	7e 07                	jle    800074 <libmain+0x34>
		binaryname = argv[0];
  80006d:	8b 03                	mov    (%ebx),%eax
  80006f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800074:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800078:	89 34 24             	mov    %esi,(%esp)
  80007b:	e8 b4 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800080:	e8 0b 00 00 00       	call   800090 <exit>
}
  800085:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800088:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80008b:	89 ec                	mov    %ebp,%esp
  80008d:	5d                   	pop    %ebp
  80008e:	c3                   	ret    
	...

00800090 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800096:	e8 13 06 00 00       	call   8006ae <close_all>
	sys_env_destroy(0);
  80009b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a2:	e8 64 00 00 00       	call   80010b <sys_env_destroy>
}
  8000a7:	c9                   	leave  
  8000a8:	c3                   	ret    
  8000a9:	00 00                	add    %al,(%eax)
	...

008000ac <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8000b5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8000b8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c6:	89 c3                	mov    %eax,%ebx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 c6                	mov    %eax,%esi
  8000cc:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8000d1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8000d4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8000d7:	89 ec                	mov    %ebp,%esp
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    

008000db <sys_cgetc>:

int
sys_cgetc(void)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8000e4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8000e7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f4:	89 d1                	mov    %edx,%ecx
  8000f6:	89 d3                	mov    %edx,%ebx
  8000f8:	89 d7                	mov    %edx,%edi
  8000fa:	89 d6                	mov    %edx,%esi
  8000fc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000fe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800101:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800104:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800107:	89 ec                	mov    %ebp,%esp
  800109:	5d                   	pop    %ebp
  80010a:	c3                   	ret    

0080010b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	83 ec 38             	sub    $0x38,%esp
  800111:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800114:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800117:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80011f:	b8 03 00 00 00       	mov    $0x3,%eax
  800124:	8b 55 08             	mov    0x8(%ebp),%edx
  800127:	89 cb                	mov    %ecx,%ebx
  800129:	89 cf                	mov    %ecx,%edi
  80012b:	89 ce                	mov    %ecx,%esi
  80012d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80012f:	85 c0                	test   %eax,%eax
  800131:	7e 28                	jle    80015b <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800133:	89 44 24 10          	mov    %eax,0x10(%esp)
  800137:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80013e:	00 
  80013f:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  800146:	00 
  800147:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80014e:	00 
  80014f:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  800156:	e8 25 11 00 00       	call   801280 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80015b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80015e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800161:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800164:	89 ec                	mov    %ebp,%esp
  800166:	5d                   	pop    %ebp
  800167:	c3                   	ret    

00800168 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	83 ec 0c             	sub    $0xc,%esp
  80016e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800171:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800174:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800177:	ba 00 00 00 00       	mov    $0x0,%edx
  80017c:	b8 02 00 00 00       	mov    $0x2,%eax
  800181:	89 d1                	mov    %edx,%ecx
  800183:	89 d3                	mov    %edx,%ebx
  800185:	89 d7                	mov    %edx,%edi
  800187:	89 d6                	mov    %edx,%esi
  800189:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80018b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80018e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800191:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800194:	89 ec                	mov    %ebp,%esp
  800196:	5d                   	pop    %ebp
  800197:	c3                   	ret    

00800198 <sys_yield>:

void
sys_yield(void)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	83 ec 0c             	sub    $0xc,%esp
  80019e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001a1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001a4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ac:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001b1:	89 d1                	mov    %edx,%ecx
  8001b3:	89 d3                	mov    %edx,%ebx
  8001b5:	89 d7                	mov    %edx,%edi
  8001b7:	89 d6                	mov    %edx,%esi
  8001b9:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001be:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001c4:	89 ec                	mov    %ebp,%esp
  8001c6:	5d                   	pop    %ebp
  8001c7:	c3                   	ret    

008001c8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	83 ec 38             	sub    $0x38,%esp
  8001ce:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001d1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001d4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001d7:	be 00 00 00 00       	mov    $0x0,%esi
  8001dc:	b8 04 00 00 00       	mov    $0x4,%eax
  8001e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ea:	89 f7                	mov    %esi,%edi
  8001ec:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001ee:	85 c0                	test   %eax,%eax
  8001f0:	7e 28                	jle    80021a <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001f6:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001fd:	00 
  8001fe:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  800205:	00 
  800206:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80020d:	00 
  80020e:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  800215:	e8 66 10 00 00       	call   801280 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80021a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80021d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800220:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800223:	89 ec                	mov    %ebp,%esp
  800225:	5d                   	pop    %ebp
  800226:	c3                   	ret    

00800227 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	83 ec 38             	sub    $0x38,%esp
  80022d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800230:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800233:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800236:	b8 05 00 00 00       	mov    $0x5,%eax
  80023b:	8b 75 18             	mov    0x18(%ebp),%esi
  80023e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800241:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800244:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800247:	8b 55 08             	mov    0x8(%ebp),%edx
  80024a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80024c:	85 c0                	test   %eax,%eax
  80024e:	7e 28                	jle    800278 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800250:	89 44 24 10          	mov    %eax,0x10(%esp)
  800254:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80025b:	00 
  80025c:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  800263:	00 
  800264:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80026b:	00 
  80026c:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  800273:	e8 08 10 00 00       	call   801280 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800278:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80027b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80027e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800281:	89 ec                	mov    %ebp,%esp
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    

00800285 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	83 ec 38             	sub    $0x38,%esp
  80028b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80028e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800291:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800294:	bb 00 00 00 00       	mov    $0x0,%ebx
  800299:	b8 06 00 00 00       	mov    $0x6,%eax
  80029e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a4:	89 df                	mov    %ebx,%edi
  8002a6:	89 de                	mov    %ebx,%esi
  8002a8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002aa:	85 c0                	test   %eax,%eax
  8002ac:	7e 28                	jle    8002d6 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ae:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002b2:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8002b9:	00 
  8002ba:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  8002c1:	00 
  8002c2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002c9:	00 
  8002ca:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  8002d1:	e8 aa 0f 00 00       	call   801280 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8002d6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002d9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002dc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002df:	89 ec                	mov    %ebp,%esp
  8002e1:	5d                   	pop    %ebp
  8002e2:	c3                   	ret    

008002e3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 38             	sub    $0x38,%esp
  8002e9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002ef:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8002fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800302:	89 df                	mov    %ebx,%edi
  800304:	89 de                	mov    %ebx,%esi
  800306:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800308:	85 c0                	test   %eax,%eax
  80030a:	7e 28                	jle    800334 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80030c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800310:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800317:	00 
  800318:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  80031f:	00 
  800320:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800327:	00 
  800328:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  80032f:	e8 4c 0f 00 00       	call   801280 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800334:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800337:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80033a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80033d:	89 ec                	mov    %ebp,%esp
  80033f:	5d                   	pop    %ebp
  800340:	c3                   	ret    

00800341 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	83 ec 38             	sub    $0x38,%esp
  800347:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80034a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80034d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800350:	bb 00 00 00 00       	mov    $0x0,%ebx
  800355:	b8 09 00 00 00       	mov    $0x9,%eax
  80035a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80035d:	8b 55 08             	mov    0x8(%ebp),%edx
  800360:	89 df                	mov    %ebx,%edi
  800362:	89 de                	mov    %ebx,%esi
  800364:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800366:	85 c0                	test   %eax,%eax
  800368:	7e 28                	jle    800392 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80036a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80036e:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800375:	00 
  800376:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  80037d:	00 
  80037e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800385:	00 
  800386:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  80038d:	e8 ee 0e 00 00       	call   801280 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800392:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800395:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800398:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80039b:	89 ec                	mov    %ebp,%esp
  80039d:	5d                   	pop    %ebp
  80039e:	c3                   	ret    

0080039f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 38             	sub    $0x38,%esp
  8003a5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003a8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003ab:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8003b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8003be:	89 df                	mov    %ebx,%edi
  8003c0:	89 de                	mov    %ebx,%esi
  8003c2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003c4:	85 c0                	test   %eax,%eax
  8003c6:	7e 28                	jle    8003f0 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003c8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003cc:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8003d3:	00 
  8003d4:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  8003db:	00 
  8003dc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003e3:	00 
  8003e4:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  8003eb:	e8 90 0e 00 00       	call   801280 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8003f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003f3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003f6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003f9:	89 ec                	mov    %ebp,%esp
  8003fb:	5d                   	pop    %ebp
  8003fc:	c3                   	ret    

008003fd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	83 ec 0c             	sub    $0xc,%esp
  800403:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800406:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800409:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80040c:	be 00 00 00 00       	mov    $0x0,%esi
  800411:	b8 0c 00 00 00       	mov    $0xc,%eax
  800416:	8b 7d 14             	mov    0x14(%ebp),%edi
  800419:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80041c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80041f:	8b 55 08             	mov    0x8(%ebp),%edx
  800422:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800424:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800427:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80042a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80042d:	89 ec                	mov    %ebp,%esp
  80042f:	5d                   	pop    %ebp
  800430:	c3                   	ret    

00800431 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	83 ec 38             	sub    $0x38,%esp
  800437:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80043a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80043d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800440:	b9 00 00 00 00       	mov    $0x0,%ecx
  800445:	b8 0d 00 00 00       	mov    $0xd,%eax
  80044a:	8b 55 08             	mov    0x8(%ebp),%edx
  80044d:	89 cb                	mov    %ecx,%ebx
  80044f:	89 cf                	mov    %ecx,%edi
  800451:	89 ce                	mov    %ecx,%esi
  800453:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800455:	85 c0                	test   %eax,%eax
  800457:	7e 28                	jle    800481 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800459:	89 44 24 10          	mov    %eax,0x10(%esp)
  80045d:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800464:	00 
  800465:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  80046c:	00 
  80046d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800474:	00 
  800475:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  80047c:	e8 ff 0d 00 00       	call   801280 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800481:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800484:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800487:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80048a:	89 ec                	mov    %ebp,%esp
  80048c:	5d                   	pop    %ebp
  80048d:	c3                   	ret    
	...

00800490 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800493:	8b 45 08             	mov    0x8(%ebp),%eax
  800496:	05 00 00 00 30       	add    $0x30000000,%eax
  80049b:	c1 e8 0c             	shr    $0xc,%eax
}
  80049e:	5d                   	pop    %ebp
  80049f:	c3                   	ret    

008004a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	89 04 24             	mov    %eax,(%esp)
  8004ac:	e8 df ff ff ff       	call   800490 <fd2num>
  8004b1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8004b6:	c1 e0 0c             	shl    $0xc,%eax
}
  8004b9:	c9                   	leave  
  8004ba:	c3                   	ret    

008004bb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	53                   	push   %ebx
  8004bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8004c2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8004c7:	a8 01                	test   $0x1,%al
  8004c9:	74 34                	je     8004ff <fd_alloc+0x44>
  8004cb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8004d0:	a8 01                	test   $0x1,%al
  8004d2:	74 32                	je     800506 <fd_alloc+0x4b>
  8004d4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8004d9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8004db:	89 c2                	mov    %eax,%edx
  8004dd:	c1 ea 16             	shr    $0x16,%edx
  8004e0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004e7:	f6 c2 01             	test   $0x1,%dl
  8004ea:	74 1f                	je     80050b <fd_alloc+0x50>
  8004ec:	89 c2                	mov    %eax,%edx
  8004ee:	c1 ea 0c             	shr    $0xc,%edx
  8004f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004f8:	f6 c2 01             	test   $0x1,%dl
  8004fb:	75 17                	jne    800514 <fd_alloc+0x59>
  8004fd:	eb 0c                	jmp    80050b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8004ff:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800504:	eb 05                	jmp    80050b <fd_alloc+0x50>
  800506:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80050b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80050d:	b8 00 00 00 00       	mov    $0x0,%eax
  800512:	eb 17                	jmp    80052b <fd_alloc+0x70>
  800514:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800519:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80051e:	75 b9                	jne    8004d9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800520:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  800526:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80052b:	5b                   	pop    %ebx
  80052c:	5d                   	pop    %ebp
  80052d:	c3                   	ret    

0080052e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80052e:	55                   	push   %ebp
  80052f:	89 e5                	mov    %esp,%ebp
  800531:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800534:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800539:	83 fa 1f             	cmp    $0x1f,%edx
  80053c:	77 3f                	ja     80057d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80053e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  800544:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800547:	89 d0                	mov    %edx,%eax
  800549:	c1 e8 16             	shr    $0x16,%eax
  80054c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800553:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800558:	f6 c1 01             	test   $0x1,%cl
  80055b:	74 20                	je     80057d <fd_lookup+0x4f>
  80055d:	89 d0                	mov    %edx,%eax
  80055f:	c1 e8 0c             	shr    $0xc,%eax
  800562:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800569:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80056e:	f6 c1 01             	test   $0x1,%cl
  800571:	74 0a                	je     80057d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800573:	8b 45 0c             	mov    0xc(%ebp),%eax
  800576:	89 10                	mov    %edx,(%eax)
	return 0;
  800578:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80057d:	5d                   	pop    %ebp
  80057e:	c3                   	ret    

0080057f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
  800582:	53                   	push   %ebx
  800583:	83 ec 14             	sub    $0x14,%esp
  800586:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800589:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80058c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  800591:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  800597:	75 17                	jne    8005b0 <dev_lookup+0x31>
  800599:	eb 07                	jmp    8005a2 <dev_lookup+0x23>
  80059b:	39 0a                	cmp    %ecx,(%edx)
  80059d:	75 11                	jne    8005b0 <dev_lookup+0x31>
  80059f:	90                   	nop
  8005a0:	eb 05                	jmp    8005a7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005a2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8005a7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8005a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ae:	eb 35                	jmp    8005e5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005b0:	83 c0 01             	add    $0x1,%eax
  8005b3:	8b 14 85 54 22 80 00 	mov    0x802254(,%eax,4),%edx
  8005ba:	85 d2                	test   %edx,%edx
  8005bc:	75 dd                	jne    80059b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005be:	a1 04 40 80 00       	mov    0x804004,%eax
  8005c3:	8b 40 48             	mov    0x48(%eax),%eax
  8005c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ce:	c7 04 24 d8 21 80 00 	movl   $0x8021d8,(%esp)
  8005d5:	e8 a1 0d 00 00       	call   80137b <cprintf>
	*dev = 0;
  8005da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8005e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8005e5:	83 c4 14             	add    $0x14,%esp
  8005e8:	5b                   	pop    %ebx
  8005e9:	5d                   	pop    %ebp
  8005ea:	c3                   	ret    

008005eb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
  8005ee:	83 ec 38             	sub    $0x38,%esp
  8005f1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8005f4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8005f7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8005fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005fd:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800601:	89 3c 24             	mov    %edi,(%esp)
  800604:	e8 87 fe ff ff       	call   800490 <fd2num>
  800609:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80060c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800610:	89 04 24             	mov    %eax,(%esp)
  800613:	e8 16 ff ff ff       	call   80052e <fd_lookup>
  800618:	89 c3                	mov    %eax,%ebx
  80061a:	85 c0                	test   %eax,%eax
  80061c:	78 05                	js     800623 <fd_close+0x38>
	    || fd != fd2)
  80061e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  800621:	74 0e                	je     800631 <fd_close+0x46>
		return (must_exist ? r : 0);
  800623:	89 f0                	mov    %esi,%eax
  800625:	84 c0                	test   %al,%al
  800627:	b8 00 00 00 00       	mov    $0x0,%eax
  80062c:	0f 44 d8             	cmove  %eax,%ebx
  80062f:	eb 3d                	jmp    80066e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800631:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800634:	89 44 24 04          	mov    %eax,0x4(%esp)
  800638:	8b 07                	mov    (%edi),%eax
  80063a:	89 04 24             	mov    %eax,(%esp)
  80063d:	e8 3d ff ff ff       	call   80057f <dev_lookup>
  800642:	89 c3                	mov    %eax,%ebx
  800644:	85 c0                	test   %eax,%eax
  800646:	78 16                	js     80065e <fd_close+0x73>
		if (dev->dev_close)
  800648:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80064e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800653:	85 c0                	test   %eax,%eax
  800655:	74 07                	je     80065e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  800657:	89 3c 24             	mov    %edi,(%esp)
  80065a:	ff d0                	call   *%eax
  80065c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80065e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800662:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800669:	e8 17 fc ff ff       	call   800285 <sys_page_unmap>
	return r;
}
  80066e:	89 d8                	mov    %ebx,%eax
  800670:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800673:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800676:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800679:	89 ec                	mov    %ebp,%esp
  80067b:	5d                   	pop    %ebp
  80067c:	c3                   	ret    

0080067d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800683:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800686:	89 44 24 04          	mov    %eax,0x4(%esp)
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 04 24             	mov    %eax,(%esp)
  800690:	e8 99 fe ff ff       	call   80052e <fd_lookup>
  800695:	85 c0                	test   %eax,%eax
  800697:	78 13                	js     8006ac <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  800699:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8006a0:	00 
  8006a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a4:	89 04 24             	mov    %eax,(%esp)
  8006a7:	e8 3f ff ff ff       	call   8005eb <fd_close>
}
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <close_all>:

void
close_all(void)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006b5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006ba:	89 1c 24             	mov    %ebx,(%esp)
  8006bd:	e8 bb ff ff ff       	call   80067d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006c2:	83 c3 01             	add    $0x1,%ebx
  8006c5:	83 fb 20             	cmp    $0x20,%ebx
  8006c8:	75 f0                	jne    8006ba <close_all+0xc>
		close(i);
}
  8006ca:	83 c4 14             	add    $0x14,%esp
  8006cd:	5b                   	pop    %ebx
  8006ce:	5d                   	pop    %ebp
  8006cf:	c3                   	ret    

008006d0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
  8006d3:	83 ec 58             	sub    $0x58,%esp
  8006d6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8006d9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8006dc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8006df:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	89 04 24             	mov    %eax,(%esp)
  8006ef:	e8 3a fe ff ff       	call   80052e <fd_lookup>
  8006f4:	89 c3                	mov    %eax,%ebx
  8006f6:	85 c0                	test   %eax,%eax
  8006f8:	0f 88 e1 00 00 00    	js     8007df <dup+0x10f>
		return r;
	close(newfdnum);
  8006fe:	89 3c 24             	mov    %edi,(%esp)
  800701:	e8 77 ff ff ff       	call   80067d <close>

	newfd = INDEX2FD(newfdnum);
  800706:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80070c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80070f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800712:	89 04 24             	mov    %eax,(%esp)
  800715:	e8 86 fd ff ff       	call   8004a0 <fd2data>
  80071a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80071c:	89 34 24             	mov    %esi,(%esp)
  80071f:	e8 7c fd ff ff       	call   8004a0 <fd2data>
  800724:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800727:	89 d8                	mov    %ebx,%eax
  800729:	c1 e8 16             	shr    $0x16,%eax
  80072c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800733:	a8 01                	test   $0x1,%al
  800735:	74 46                	je     80077d <dup+0xad>
  800737:	89 d8                	mov    %ebx,%eax
  800739:	c1 e8 0c             	shr    $0xc,%eax
  80073c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800743:	f6 c2 01             	test   $0x1,%dl
  800746:	74 35                	je     80077d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800748:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80074f:	25 07 0e 00 00       	and    $0xe07,%eax
  800754:	89 44 24 10          	mov    %eax,0x10(%esp)
  800758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80075b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80075f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800766:	00 
  800767:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80076b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800772:	e8 b0 fa ff ff       	call   800227 <sys_page_map>
  800777:	89 c3                	mov    %eax,%ebx
  800779:	85 c0                	test   %eax,%eax
  80077b:	78 3b                	js     8007b8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80077d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800780:	89 c2                	mov    %eax,%edx
  800782:	c1 ea 0c             	shr    $0xc,%edx
  800785:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80078c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800792:	89 54 24 10          	mov    %edx,0x10(%esp)
  800796:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80079a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007a1:	00 
  8007a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007ad:	e8 75 fa ff ff       	call   800227 <sys_page_map>
  8007b2:	89 c3                	mov    %eax,%ebx
  8007b4:	85 c0                	test   %eax,%eax
  8007b6:	79 25                	jns    8007dd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007c3:	e8 bd fa ff ff       	call   800285 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8007c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007d6:	e8 aa fa ff ff       	call   800285 <sys_page_unmap>
	return r;
  8007db:	eb 02                	jmp    8007df <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8007dd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8007df:	89 d8                	mov    %ebx,%eax
  8007e1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8007e4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8007e7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8007ea:	89 ec                	mov    %ebp,%esp
  8007ec:	5d                   	pop    %ebp
  8007ed:	c3                   	ret    

008007ee <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	53                   	push   %ebx
  8007f2:	83 ec 24             	sub    $0x24,%esp
  8007f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ff:	89 1c 24             	mov    %ebx,(%esp)
  800802:	e8 27 fd ff ff       	call   80052e <fd_lookup>
  800807:	85 c0                	test   %eax,%eax
  800809:	78 6d                	js     800878 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80080b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80080e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	89 04 24             	mov    %eax,(%esp)
  80081a:	e8 60 fd ff ff       	call   80057f <dev_lookup>
  80081f:	85 c0                	test   %eax,%eax
  800821:	78 55                	js     800878 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800826:	8b 50 08             	mov    0x8(%eax),%edx
  800829:	83 e2 03             	and    $0x3,%edx
  80082c:	83 fa 01             	cmp    $0x1,%edx
  80082f:	75 23                	jne    800854 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800831:	a1 04 40 80 00       	mov    0x804004,%eax
  800836:	8b 40 48             	mov    0x48(%eax),%eax
  800839:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80083d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800841:	c7 04 24 19 22 80 00 	movl   $0x802219,(%esp)
  800848:	e8 2e 0b 00 00       	call   80137b <cprintf>
		return -E_INVAL;
  80084d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800852:	eb 24                	jmp    800878 <read+0x8a>
	}
	if (!dev->dev_read)
  800854:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800857:	8b 52 08             	mov    0x8(%edx),%edx
  80085a:	85 d2                	test   %edx,%edx
  80085c:	74 15                	je     800873 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80085e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800861:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800865:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800868:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80086c:	89 04 24             	mov    %eax,(%esp)
  80086f:	ff d2                	call   *%edx
  800871:	eb 05                	jmp    800878 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800873:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800878:	83 c4 24             	add    $0x24,%esp
  80087b:	5b                   	pop    %ebx
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	57                   	push   %edi
  800882:	56                   	push   %esi
  800883:	53                   	push   %ebx
  800884:	83 ec 1c             	sub    $0x1c,%esp
  800887:	8b 7d 08             	mov    0x8(%ebp),%edi
  80088a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80088d:	b8 00 00 00 00       	mov    $0x0,%eax
  800892:	85 f6                	test   %esi,%esi
  800894:	74 30                	je     8008c6 <readn+0x48>
  800896:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80089b:	89 f2                	mov    %esi,%edx
  80089d:	29 c2                	sub    %eax,%edx
  80089f:	89 54 24 08          	mov    %edx,0x8(%esp)
  8008a3:	03 45 0c             	add    0xc(%ebp),%eax
  8008a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008aa:	89 3c 24             	mov    %edi,(%esp)
  8008ad:	e8 3c ff ff ff       	call   8007ee <read>
		if (m < 0)
  8008b2:	85 c0                	test   %eax,%eax
  8008b4:	78 10                	js     8008c6 <readn+0x48>
			return m;
		if (m == 0)
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	74 0a                	je     8008c4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008ba:	01 c3                	add    %eax,%ebx
  8008bc:	89 d8                	mov    %ebx,%eax
  8008be:	39 f3                	cmp    %esi,%ebx
  8008c0:	72 d9                	jb     80089b <readn+0x1d>
  8008c2:	eb 02                	jmp    8008c6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8008c4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8008c6:	83 c4 1c             	add    $0x1c,%esp
  8008c9:	5b                   	pop    %ebx
  8008ca:	5e                   	pop    %esi
  8008cb:	5f                   	pop    %edi
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	53                   	push   %ebx
  8008d2:	83 ec 24             	sub    $0x24,%esp
  8008d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008df:	89 1c 24             	mov    %ebx,(%esp)
  8008e2:	e8 47 fc ff ff       	call   80052e <fd_lookup>
  8008e7:	85 c0                	test   %eax,%eax
  8008e9:	78 68                	js     800953 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	89 04 24             	mov    %eax,(%esp)
  8008fa:	e8 80 fc ff ff       	call   80057f <dev_lookup>
  8008ff:	85 c0                	test   %eax,%eax
  800901:	78 50                	js     800953 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800906:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80090a:	75 23                	jne    80092f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80090c:	a1 04 40 80 00       	mov    0x804004,%eax
  800911:	8b 40 48             	mov    0x48(%eax),%eax
  800914:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800918:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091c:	c7 04 24 35 22 80 00 	movl   $0x802235,(%esp)
  800923:	e8 53 0a 00 00       	call   80137b <cprintf>
		return -E_INVAL;
  800928:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80092d:	eb 24                	jmp    800953 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80092f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800932:	8b 52 0c             	mov    0xc(%edx),%edx
  800935:	85 d2                	test   %edx,%edx
  800937:	74 15                	je     80094e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800939:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80093c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800940:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800943:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800947:	89 04 24             	mov    %eax,(%esp)
  80094a:	ff d2                	call   *%edx
  80094c:	eb 05                	jmp    800953 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80094e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800953:	83 c4 24             	add    $0x24,%esp
  800956:	5b                   	pop    %ebx
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    

00800959 <seek>:

int
seek(int fdnum, off_t offset)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80095f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800962:	89 44 24 04          	mov    %eax,0x4(%esp)
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	89 04 24             	mov    %eax,(%esp)
  80096c:	e8 bd fb ff ff       	call   80052e <fd_lookup>
  800971:	85 c0                	test   %eax,%eax
  800973:	78 0e                	js     800983 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800975:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80097e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800983:	c9                   	leave  
  800984:	c3                   	ret    

00800985 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	53                   	push   %ebx
  800989:	83 ec 24             	sub    $0x24,%esp
  80098c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80098f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800992:	89 44 24 04          	mov    %eax,0x4(%esp)
  800996:	89 1c 24             	mov    %ebx,(%esp)
  800999:	e8 90 fb ff ff       	call   80052e <fd_lookup>
  80099e:	85 c0                	test   %eax,%eax
  8009a0:	78 61                	js     800a03 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	89 04 24             	mov    %eax,(%esp)
  8009b1:	e8 c9 fb ff ff       	call   80057f <dev_lookup>
  8009b6:	85 c0                	test   %eax,%eax
  8009b8:	78 49                	js     800a03 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009c1:	75 23                	jne    8009e6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8009c3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009c8:	8b 40 48             	mov    0x48(%eax),%eax
  8009cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d3:	c7 04 24 f8 21 80 00 	movl   $0x8021f8,(%esp)
  8009da:	e8 9c 09 00 00       	call   80137b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e4:	eb 1d                	jmp    800a03 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8009e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009e9:	8b 52 18             	mov    0x18(%edx),%edx
  8009ec:	85 d2                	test   %edx,%edx
  8009ee:	74 0e                	je     8009fe <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8009f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009f7:	89 04 24             	mov    %eax,(%esp)
  8009fa:	ff d2                	call   *%edx
  8009fc:	eb 05                	jmp    800a03 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8009fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800a03:	83 c4 24             	add    $0x24,%esp
  800a06:	5b                   	pop    %ebx
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    

00800a09 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	53                   	push   %ebx
  800a0d:	83 ec 24             	sub    $0x24,%esp
  800a10:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a13:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	89 04 24             	mov    %eax,(%esp)
  800a20:	e8 09 fb ff ff       	call   80052e <fd_lookup>
  800a25:	85 c0                	test   %eax,%eax
  800a27:	78 52                	js     800a7b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	89 04 24             	mov    %eax,(%esp)
  800a38:	e8 42 fb ff ff       	call   80057f <dev_lookup>
  800a3d:	85 c0                	test   %eax,%eax
  800a3f:	78 3a                	js     800a7b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  800a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a44:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a48:	74 2c                	je     800a76 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a4a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a4d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a54:	00 00 00 
	stat->st_isdir = 0;
  800a57:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a5e:	00 00 00 
	stat->st_dev = dev;
  800a61:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a67:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a6e:	89 14 24             	mov    %edx,(%esp)
  800a71:	ff 50 14             	call   *0x14(%eax)
  800a74:	eb 05                	jmp    800a7b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a76:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a7b:	83 c4 24             	add    $0x24,%esp
  800a7e:	5b                   	pop    %ebx
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 18             	sub    $0x18,%esp
  800a87:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800a8a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a94:	00 
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	89 04 24             	mov    %eax,(%esp)
  800a9b:	e8 bc 01 00 00       	call   800c5c <open>
  800aa0:	89 c3                	mov    %eax,%ebx
  800aa2:	85 c0                	test   %eax,%eax
  800aa4:	78 1b                	js     800ac1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aad:	89 1c 24             	mov    %ebx,(%esp)
  800ab0:	e8 54 ff ff ff       	call   800a09 <fstat>
  800ab5:	89 c6                	mov    %eax,%esi
	close(fd);
  800ab7:	89 1c 24             	mov    %ebx,(%esp)
  800aba:	e8 be fb ff ff       	call   80067d <close>
	return r;
  800abf:	89 f3                	mov    %esi,%ebx
}
  800ac1:	89 d8                	mov    %ebx,%eax
  800ac3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800ac6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800ac9:	89 ec                	mov    %ebp,%esp
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    
  800acd:	00 00                	add    %al,(%eax)
	...

00800ad0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	83 ec 18             	sub    $0x18,%esp
  800ad6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800ad9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800adc:	89 c3                	mov    %eax,%ebx
  800ade:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  800ae0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ae7:	75 11                	jne    800afa <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ae9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800af0:	e8 61 13 00 00       	call   801e56 <ipc_find_env>
  800af5:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800afa:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800b01:	00 
  800b02:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800b09:	00 
  800b0a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b0e:	a1 00 40 80 00       	mov    0x804000,%eax
  800b13:	89 04 24             	mov    %eax,(%esp)
  800b16:	e8 b7 12 00 00       	call   801dd2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800b1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b22:	00 
  800b23:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b2e:	e8 4d 12 00 00       	call   801d80 <ipc_recv>
}
  800b33:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800b36:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800b39:	89 ec                	mov    %ebp,%esp
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	53                   	push   %ebx
  800b41:	83 ec 14             	sub    $0x14,%esp
  800b44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	8b 40 0c             	mov    0xc(%eax),%eax
  800b4d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b52:	ba 00 00 00 00       	mov    $0x0,%edx
  800b57:	b8 05 00 00 00       	mov    $0x5,%eax
  800b5c:	e8 6f ff ff ff       	call   800ad0 <fsipc>
  800b61:	85 c0                	test   %eax,%eax
  800b63:	78 2b                	js     800b90 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b65:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800b6c:	00 
  800b6d:	89 1c 24             	mov    %ebx,(%esp)
  800b70:	e8 26 0e 00 00       	call   80199b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b75:	a1 80 50 80 00       	mov    0x805080,%eax
  800b7a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b80:	a1 84 50 80 00       	mov    0x805084,%eax
  800b85:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b90:	83 c4 14             	add    $0x14,%esp
  800b93:	5b                   	pop    %ebx
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	8b 40 0c             	mov    0xc(%eax),%eax
  800ba2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800ba7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bac:	b8 06 00 00 00       	mov    $0x6,%eax
  800bb1:	e8 1a ff ff ff       	call   800ad0 <fsipc>
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	83 ec 10             	sub    $0x10,%esp
  800bc0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8b 40 0c             	mov    0xc(%eax),%eax
  800bc9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800bce:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800bd4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bde:	e8 ed fe ff ff       	call   800ad0 <fsipc>
  800be3:	89 c3                	mov    %eax,%ebx
  800be5:	85 c0                	test   %eax,%eax
  800be7:	78 6a                	js     800c53 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800be9:	39 c6                	cmp    %eax,%esi
  800beb:	73 24                	jae    800c11 <devfile_read+0x59>
  800bed:	c7 44 24 0c 64 22 80 	movl   $0x802264,0xc(%esp)
  800bf4:	00 
  800bf5:	c7 44 24 08 6b 22 80 	movl   $0x80226b,0x8(%esp)
  800bfc:	00 
  800bfd:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800c04:	00 
  800c05:	c7 04 24 80 22 80 00 	movl   $0x802280,(%esp)
  800c0c:	e8 6f 06 00 00       	call   801280 <_panic>
	assert(r <= PGSIZE);
  800c11:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c16:	7e 24                	jle    800c3c <devfile_read+0x84>
  800c18:	c7 44 24 0c 8b 22 80 	movl   $0x80228b,0xc(%esp)
  800c1f:	00 
  800c20:	c7 44 24 08 6b 22 80 	movl   $0x80226b,0x8(%esp)
  800c27:	00 
  800c28:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800c2f:	00 
  800c30:	c7 04 24 80 22 80 00 	movl   $0x802280,(%esp)
  800c37:	e8 44 06 00 00       	call   801280 <_panic>
	memmove(buf, &fsipcbuf, r);
  800c3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c40:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c47:	00 
  800c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4b:	89 04 24             	mov    %eax,(%esp)
  800c4e:	e8 39 0f 00 00       	call   801b8c <memmove>
	return r;
}
  800c53:	89 d8                	mov    %ebx,%eax
  800c55:	83 c4 10             	add    $0x10,%esp
  800c58:	5b                   	pop    %ebx
  800c59:	5e                   	pop    %esi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
  800c61:	83 ec 20             	sub    $0x20,%esp
  800c64:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800c67:	89 34 24             	mov    %esi,(%esp)
  800c6a:	e8 e1 0c 00 00       	call   801950 <strlen>
		return -E_BAD_PATH;
  800c6f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800c74:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c79:	7f 5e                	jg     800cd9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800c7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c7e:	89 04 24             	mov    %eax,(%esp)
  800c81:	e8 35 f8 ff ff       	call   8004bb <fd_alloc>
  800c86:	89 c3                	mov    %eax,%ebx
  800c88:	85 c0                	test   %eax,%eax
  800c8a:	78 4d                	js     800cd9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800c8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c90:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800c97:	e8 ff 0c 00 00       	call   80199b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ca4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca7:	b8 01 00 00 00       	mov    $0x1,%eax
  800cac:	e8 1f fe ff ff       	call   800ad0 <fsipc>
  800cb1:	89 c3                	mov    %eax,%ebx
  800cb3:	85 c0                	test   %eax,%eax
  800cb5:	79 15                	jns    800ccc <open+0x70>
		fd_close(fd, 0);
  800cb7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800cbe:	00 
  800cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cc2:	89 04 24             	mov    %eax,(%esp)
  800cc5:	e8 21 f9 ff ff       	call   8005eb <fd_close>
		return r;
  800cca:	eb 0d                	jmp    800cd9 <open+0x7d>
	}

	return fd2num(fd);
  800ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ccf:	89 04 24             	mov    %eax,(%esp)
  800cd2:	e8 b9 f7 ff ff       	call   800490 <fd2num>
  800cd7:	89 c3                	mov    %eax,%ebx
}
  800cd9:	89 d8                	mov    %ebx,%eax
  800cdb:	83 c4 20             	add    $0x20,%esp
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    
	...

00800cf0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 18             	sub    $0x18,%esp
  800cf6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800cf9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800cfc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	89 04 24             	mov    %eax,(%esp)
  800d05:	e8 96 f7 ff ff       	call   8004a0 <fd2data>
  800d0a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  800d0c:	c7 44 24 04 97 22 80 	movl   $0x802297,0x4(%esp)
  800d13:	00 
  800d14:	89 34 24             	mov    %esi,(%esp)
  800d17:	e8 7f 0c 00 00       	call   80199b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800d1c:	8b 43 04             	mov    0x4(%ebx),%eax
  800d1f:	2b 03                	sub    (%ebx),%eax
  800d21:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  800d27:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  800d2e:	00 00 00 
	stat->st_dev = &devpipe;
  800d31:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  800d38:	30 80 00 
	return 0;
}
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800d43:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800d46:	89 ec                	mov    %ebp,%esp
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 14             	sub    $0x14,%esp
  800d51:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800d54:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d5f:	e8 21 f5 ff ff       	call   800285 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800d64:	89 1c 24             	mov    %ebx,(%esp)
  800d67:	e8 34 f7 ff ff       	call   8004a0 <fd2data>
  800d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d77:	e8 09 f5 ff ff       	call   800285 <sys_page_unmap>
}
  800d7c:	83 c4 14             	add    $0x14,%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    

00800d82 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 2c             	sub    $0x2c,%esp
  800d8b:	89 c7                	mov    %eax,%edi
  800d8d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800d90:	a1 04 40 80 00       	mov    0x804004,%eax
  800d95:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800d98:	89 3c 24             	mov    %edi,(%esp)
  800d9b:	e8 00 11 00 00       	call   801ea0 <pageref>
  800da0:	89 c6                	mov    %eax,%esi
  800da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800da5:	89 04 24             	mov    %eax,(%esp)
  800da8:	e8 f3 10 00 00       	call   801ea0 <pageref>
  800dad:	39 c6                	cmp    %eax,%esi
  800daf:	0f 94 c0             	sete   %al
  800db2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  800db5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800dbb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800dbe:	39 cb                	cmp    %ecx,%ebx
  800dc0:	75 08                	jne    800dca <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  800dc2:	83 c4 2c             	add    $0x2c,%esp
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  800dca:	83 f8 01             	cmp    $0x1,%eax
  800dcd:	75 c1                	jne    800d90 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800dcf:	8b 52 58             	mov    0x58(%edx),%edx
  800dd2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800dd6:	89 54 24 08          	mov    %edx,0x8(%esp)
  800dda:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800dde:	c7 04 24 9e 22 80 00 	movl   $0x80229e,(%esp)
  800de5:	e8 91 05 00 00       	call   80137b <cprintf>
  800dea:	eb a4                	jmp    800d90 <_pipeisclosed+0xe>

00800dec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
  800df2:	83 ec 2c             	sub    $0x2c,%esp
  800df5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800df8:	89 34 24             	mov    %esi,(%esp)
  800dfb:	e8 a0 f6 ff ff       	call   8004a0 <fd2data>
  800e00:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e02:	bf 00 00 00 00       	mov    $0x0,%edi
  800e07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0b:	75 50                	jne    800e5d <devpipe_write+0x71>
  800e0d:	eb 5c                	jmp    800e6b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800e0f:	89 da                	mov    %ebx,%edx
  800e11:	89 f0                	mov    %esi,%eax
  800e13:	e8 6a ff ff ff       	call   800d82 <_pipeisclosed>
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	75 53                	jne    800e6f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800e1c:	e8 77 f3 ff ff       	call   800198 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e21:	8b 43 04             	mov    0x4(%ebx),%eax
  800e24:	8b 13                	mov    (%ebx),%edx
  800e26:	83 c2 20             	add    $0x20,%edx
  800e29:	39 d0                	cmp    %edx,%eax
  800e2b:	73 e2                	jae    800e0f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e30:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  800e34:	88 55 e7             	mov    %dl,-0x19(%ebp)
  800e37:	89 c2                	mov    %eax,%edx
  800e39:	c1 fa 1f             	sar    $0x1f,%edx
  800e3c:	c1 ea 1b             	shr    $0x1b,%edx
  800e3f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800e42:	83 e1 1f             	and    $0x1f,%ecx
  800e45:	29 d1                	sub    %edx,%ecx
  800e47:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800e4b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800e4f:	83 c0 01             	add    $0x1,%eax
  800e52:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e55:	83 c7 01             	add    $0x1,%edi
  800e58:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800e5b:	74 0e                	je     800e6b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e5d:	8b 43 04             	mov    0x4(%ebx),%eax
  800e60:	8b 13                	mov    (%ebx),%edx
  800e62:	83 c2 20             	add    $0x20,%edx
  800e65:	39 d0                	cmp    %edx,%eax
  800e67:	73 a6                	jae    800e0f <devpipe_write+0x23>
  800e69:	eb c2                	jmp    800e2d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800e6b:	89 f8                	mov    %edi,%eax
  800e6d:	eb 05                	jmp    800e74 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800e74:	83 c4 2c             	add    $0x2c,%esp
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    

00800e7c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 28             	sub    $0x28,%esp
  800e82:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e85:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e88:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800e8b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800e8e:	89 3c 24             	mov    %edi,(%esp)
  800e91:	e8 0a f6 ff ff       	call   8004a0 <fd2data>
  800e96:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e98:	be 00 00 00 00       	mov    $0x0,%esi
  800e9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea1:	75 47                	jne    800eea <devpipe_read+0x6e>
  800ea3:	eb 52                	jmp    800ef7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800ea5:	89 f0                	mov    %esi,%eax
  800ea7:	eb 5e                	jmp    800f07 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800ea9:	89 da                	mov    %ebx,%edx
  800eab:	89 f8                	mov    %edi,%eax
  800ead:	8d 76 00             	lea    0x0(%esi),%esi
  800eb0:	e8 cd fe ff ff       	call   800d82 <_pipeisclosed>
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	75 49                	jne    800f02 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800eb9:	e8 da f2 ff ff       	call   800198 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800ebe:	8b 03                	mov    (%ebx),%eax
  800ec0:	3b 43 04             	cmp    0x4(%ebx),%eax
  800ec3:	74 e4                	je     800ea9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800ec5:	89 c2                	mov    %eax,%edx
  800ec7:	c1 fa 1f             	sar    $0x1f,%edx
  800eca:	c1 ea 1b             	shr    $0x1b,%edx
  800ecd:	01 d0                	add    %edx,%eax
  800ecf:	83 e0 1f             	and    $0x1f,%eax
  800ed2:	29 d0                	sub    %edx,%eax
  800ed4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  800edf:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ee2:	83 c6 01             	add    $0x1,%esi
  800ee5:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ee8:	74 0d                	je     800ef7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  800eea:	8b 03                	mov    (%ebx),%eax
  800eec:	3b 43 04             	cmp    0x4(%ebx),%eax
  800eef:	75 d4                	jne    800ec5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800ef1:	85 f6                	test   %esi,%esi
  800ef3:	75 b0                	jne    800ea5 <devpipe_read+0x29>
  800ef5:	eb b2                	jmp    800ea9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800ef7:	89 f0                	mov    %esi,%eax
  800ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f00:	eb 05                	jmp    800f07 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800f02:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800f07:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f0a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f0d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f10:	89 ec                	mov    %ebp,%esp
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    

00800f14 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 48             	sub    $0x48,%esp
  800f1a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f1d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f20:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800f23:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800f26:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f29:	89 04 24             	mov    %eax,(%esp)
  800f2c:	e8 8a f5 ff ff       	call   8004bb <fd_alloc>
  800f31:	89 c3                	mov    %eax,%ebx
  800f33:	85 c0                	test   %eax,%eax
  800f35:	0f 88 45 01 00 00    	js     801080 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f3b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f42:	00 
  800f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f46:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f51:	e8 72 f2 ff ff       	call   8001c8 <sys_page_alloc>
  800f56:	89 c3                	mov    %eax,%ebx
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	0f 88 20 01 00 00    	js     801080 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800f60:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f63:	89 04 24             	mov    %eax,(%esp)
  800f66:	e8 50 f5 ff ff       	call   8004bb <fd_alloc>
  800f6b:	89 c3                	mov    %eax,%ebx
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	0f 88 f8 00 00 00    	js     80106d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f75:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f7c:	00 
  800f7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f8b:	e8 38 f2 ff ff       	call   8001c8 <sys_page_alloc>
  800f90:	89 c3                	mov    %eax,%ebx
  800f92:	85 c0                	test   %eax,%eax
  800f94:	0f 88 d3 00 00 00    	js     80106d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800f9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f9d:	89 04 24             	mov    %eax,(%esp)
  800fa0:	e8 fb f4 ff ff       	call   8004a0 <fd2data>
  800fa5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800fa7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800fae:	00 
  800faf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fb3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fba:	e8 09 f2 ff ff       	call   8001c8 <sys_page_alloc>
  800fbf:	89 c3                	mov    %eax,%ebx
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	0f 88 91 00 00 00    	js     80105a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800fc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fcc:	89 04 24             	mov    %eax,(%esp)
  800fcf:	e8 cc f4 ff ff       	call   8004a0 <fd2data>
  800fd4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  800fdb:	00 
  800fdc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fe0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800fe7:	00 
  800fe8:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ff3:	e8 2f f2 ff ff       	call   800227 <sys_page_map>
  800ff8:	89 c3                	mov    %eax,%ebx
  800ffa:	85 c0                	test   %eax,%eax
  800ffc:	78 4c                	js     80104a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800ffe:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801004:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801007:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801009:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80100c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801013:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801019:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80101c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80101e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801021:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801028:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80102b:	89 04 24             	mov    %eax,(%esp)
  80102e:	e8 5d f4 ff ff       	call   800490 <fd2num>
  801033:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801035:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801038:	89 04 24             	mov    %eax,(%esp)
  80103b:	e8 50 f4 ff ff       	call   800490 <fd2num>
  801040:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801043:	bb 00 00 00 00       	mov    $0x0,%ebx
  801048:	eb 36                	jmp    801080 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80104a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80104e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801055:	e8 2b f2 ff ff       	call   800285 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80105a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80105d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801061:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801068:	e8 18 f2 ff ff       	call   800285 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80106d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801070:	89 44 24 04          	mov    %eax,0x4(%esp)
  801074:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80107b:	e8 05 f2 ff ff       	call   800285 <sys_page_unmap>
    err:
	return r;
}
  801080:	89 d8                	mov    %ebx,%eax
  801082:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801085:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801088:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80108b:	89 ec                	mov    %ebp,%esp
  80108d:	5d                   	pop    %ebp
  80108e:	c3                   	ret    

0080108f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801095:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801098:	89 44 24 04          	mov    %eax,0x4(%esp)
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	89 04 24             	mov    %eax,(%esp)
  8010a2:	e8 87 f4 ff ff       	call   80052e <fd_lookup>
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	78 15                	js     8010c0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8010ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ae:	89 04 24             	mov    %eax,(%esp)
  8010b1:	e8 ea f3 ff ff       	call   8004a0 <fd2data>
	return _pipeisclosed(fd, p);
  8010b6:	89 c2                	mov    %eax,%edx
  8010b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bb:	e8 c2 fc ff ff       	call   800d82 <_pipeisclosed>
}
  8010c0:	c9                   	leave  
  8010c1:	c3                   	ret    
	...

008010d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8010d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    

008010da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8010e0:	c7 44 24 04 b6 22 80 	movl   $0x8022b6,0x4(%esp)
  8010e7:	00 
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	89 04 24             	mov    %eax,(%esp)
  8010ee:	e8 a8 08 00 00       	call   80199b <strcpy>
	return 0;
}
  8010f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	57                   	push   %edi
  8010fe:	56                   	push   %esi
  8010ff:	53                   	push   %ebx
  801100:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801106:	be 00 00 00 00       	mov    $0x0,%esi
  80110b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110f:	74 43                	je     801154 <devcons_write+0x5a>
  801111:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801116:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80111c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80111f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801121:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801124:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801129:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80112c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801130:	03 45 0c             	add    0xc(%ebp),%eax
  801133:	89 44 24 04          	mov    %eax,0x4(%esp)
  801137:	89 3c 24             	mov    %edi,(%esp)
  80113a:	e8 4d 0a 00 00       	call   801b8c <memmove>
		sys_cputs(buf, m);
  80113f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801143:	89 3c 24             	mov    %edi,(%esp)
  801146:	e8 61 ef ff ff       	call   8000ac <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80114b:	01 de                	add    %ebx,%esi
  80114d:	89 f0                	mov    %esi,%eax
  80114f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801152:	72 c8                	jb     80111c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801154:	89 f0                	mov    %esi,%eax
  801156:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5f                   	pop    %edi
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801167:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80116c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801170:	75 07                	jne    801179 <devcons_read+0x18>
  801172:	eb 31                	jmp    8011a5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801174:	e8 1f f0 ff ff       	call   800198 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801180:	e8 56 ef ff ff       	call   8000db <sys_cgetc>
  801185:	85 c0                	test   %eax,%eax
  801187:	74 eb                	je     801174 <devcons_read+0x13>
  801189:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80118b:	85 c0                	test   %eax,%eax
  80118d:	78 16                	js     8011a5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80118f:	83 f8 04             	cmp    $0x4,%eax
  801192:	74 0c                	je     8011a0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	88 10                	mov    %dl,(%eax)
	return 1;
  801199:	b8 01 00 00 00       	mov    $0x1,%eax
  80119e:	eb 05                	jmp    8011a5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8011a0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8011b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011ba:	00 
  8011bb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8011be:	89 04 24             	mov    %eax,(%esp)
  8011c1:	e8 e6 ee ff ff       	call   8000ac <sys_cputs>
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <getchar>:

int
getchar(void)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8011ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8011d5:	00 
  8011d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8011d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011e4:	e8 05 f6 ff ff       	call   8007ee <read>
	if (r < 0)
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	78 0f                	js     8011fc <getchar+0x34>
		return r;
	if (r < 1)
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	7e 06                	jle    8011f7 <getchar+0x2f>
		return -E_EOF;
	return c;
  8011f1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8011f5:	eb 05                	jmp    8011fc <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8011f7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801204:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801207:	89 44 24 04          	mov    %eax,0x4(%esp)
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	89 04 24             	mov    %eax,(%esp)
  801211:	e8 18 f3 ff ff       	call   80052e <fd_lookup>
  801216:	85 c0                	test   %eax,%eax
  801218:	78 11                	js     80122b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80121a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80121d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801223:	39 10                	cmp    %edx,(%eax)
  801225:	0f 94 c0             	sete   %al
  801228:	0f b6 c0             	movzbl %al,%eax
}
  80122b:	c9                   	leave  
  80122c:	c3                   	ret    

0080122d <opencons>:

int
opencons(void)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801233:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801236:	89 04 24             	mov    %eax,(%esp)
  801239:	e8 7d f2 ff ff       	call   8004bb <fd_alloc>
  80123e:	85 c0                	test   %eax,%eax
  801240:	78 3c                	js     80127e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801242:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801249:	00 
  80124a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801251:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801258:	e8 6b ef ff ff       	call   8001c8 <sys_page_alloc>
  80125d:	85 c0                	test   %eax,%eax
  80125f:	78 1d                	js     80127e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801261:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80126c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801276:	89 04 24             	mov    %eax,(%esp)
  801279:	e8 12 f2 ff ff       	call   800490 <fd2num>
}
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	56                   	push   %esi
  801284:	53                   	push   %ebx
  801285:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801288:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80128b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801291:	e8 d2 ee ff ff       	call   800168 <sys_getenvid>
  801296:	8b 55 0c             	mov    0xc(%ebp),%edx
  801299:	89 54 24 10          	mov    %edx,0x10(%esp)
  80129d:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012a4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ac:	c7 04 24 c4 22 80 00 	movl   $0x8022c4,(%esp)
  8012b3:	e8 c3 00 00 00       	call   80137b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	89 04 24             	mov    %eax,(%esp)
  8012c2:	e8 53 00 00 00       	call   80131a <vcprintf>
	cprintf("\n");
  8012c7:	c7 04 24 af 22 80 00 	movl   $0x8022af,(%esp)
  8012ce:	e8 a8 00 00 00       	call   80137b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8012d3:	cc                   	int3   
  8012d4:	eb fd                	jmp    8012d3 <_panic+0x53>
	...

008012d8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	53                   	push   %ebx
  8012dc:	83 ec 14             	sub    $0x14,%esp
  8012df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8012e2:	8b 03                	mov    (%ebx),%eax
  8012e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e7:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8012eb:	83 c0 01             	add    $0x1,%eax
  8012ee:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8012f0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8012f5:	75 19                	jne    801310 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8012f7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8012fe:	00 
  8012ff:	8d 43 08             	lea    0x8(%ebx),%eax
  801302:	89 04 24             	mov    %eax,(%esp)
  801305:	e8 a2 ed ff ff       	call   8000ac <sys_cputs>
		b->idx = 0;
  80130a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801310:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801314:	83 c4 14             	add    $0x14,%esp
  801317:	5b                   	pop    %ebx
  801318:	5d                   	pop    %ebp
  801319:	c3                   	ret    

0080131a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801323:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80132a:	00 00 00 
	b.cnt = 0;
  80132d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801334:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	89 44 24 08          	mov    %eax,0x8(%esp)
  801345:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80134b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134f:	c7 04 24 d8 12 80 00 	movl   $0x8012d8,(%esp)
  801356:	e8 9f 01 00 00       	call   8014fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80135b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801361:	89 44 24 04          	mov    %eax,0x4(%esp)
  801365:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80136b:	89 04 24             	mov    %eax,(%esp)
  80136e:	e8 39 ed ff ff       	call   8000ac <sys_cputs>

	return b.cnt;
}
  801373:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801381:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801384:	89 44 24 04          	mov    %eax,0x4(%esp)
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	89 04 24             	mov    %eax,(%esp)
  80138e:	e8 87 ff ff ff       	call   80131a <vcprintf>
	va_end(ap);

	return cnt;
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    
	...

008013a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	57                   	push   %edi
  8013a4:	56                   	push   %esi
  8013a5:	53                   	push   %ebx
  8013a6:	83 ec 3c             	sub    $0x3c,%esp
  8013a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013ac:	89 d7                	mov    %edx,%edi
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013bd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8013c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8013c8:	72 11                	jb     8013db <printnum+0x3b>
  8013ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013cd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8013d0:	76 09                	jbe    8013db <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8013d2:	83 eb 01             	sub    $0x1,%ebx
  8013d5:	85 db                	test   %ebx,%ebx
  8013d7:	7f 51                	jg     80142a <printnum+0x8a>
  8013d9:	eb 5e                	jmp    801439 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8013db:	89 74 24 10          	mov    %esi,0x10(%esp)
  8013df:	83 eb 01             	sub    $0x1,%ebx
  8013e2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013ed:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8013f1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  8013f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8013fc:	00 
  8013fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801400:	89 04 24             	mov    %eax,(%esp)
  801403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140a:	e8 d1 0a 00 00       	call   801ee0 <__udivdi3>
  80140f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801413:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801417:	89 04 24             	mov    %eax,(%esp)
  80141a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80141e:	89 fa                	mov    %edi,%edx
  801420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801423:	e8 78 ff ff ff       	call   8013a0 <printnum>
  801428:	eb 0f                	jmp    801439 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80142a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80142e:	89 34 24             	mov    %esi,(%esp)
  801431:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801434:	83 eb 01             	sub    $0x1,%ebx
  801437:	75 f1                	jne    80142a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801439:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80143d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801441:	8b 45 10             	mov    0x10(%ebp),%eax
  801444:	89 44 24 08          	mov    %eax,0x8(%esp)
  801448:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80144f:	00 
  801450:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801453:	89 04 24             	mov    %eax,(%esp)
  801456:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801459:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145d:	e8 ae 0b 00 00       	call   802010 <__umoddi3>
  801462:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801466:	0f be 80 e7 22 80 00 	movsbl 0x8022e7(%eax),%eax
  80146d:	89 04 24             	mov    %eax,(%esp)
  801470:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801473:	83 c4 3c             	add    $0x3c,%esp
  801476:	5b                   	pop    %ebx
  801477:	5e                   	pop    %esi
  801478:	5f                   	pop    %edi
  801479:	5d                   	pop    %ebp
  80147a:	c3                   	ret    

0080147b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80147e:	83 fa 01             	cmp    $0x1,%edx
  801481:	7e 0e                	jle    801491 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801483:	8b 10                	mov    (%eax),%edx
  801485:	8d 4a 08             	lea    0x8(%edx),%ecx
  801488:	89 08                	mov    %ecx,(%eax)
  80148a:	8b 02                	mov    (%edx),%eax
  80148c:	8b 52 04             	mov    0x4(%edx),%edx
  80148f:	eb 22                	jmp    8014b3 <getuint+0x38>
	else if (lflag)
  801491:	85 d2                	test   %edx,%edx
  801493:	74 10                	je     8014a5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801495:	8b 10                	mov    (%eax),%edx
  801497:	8d 4a 04             	lea    0x4(%edx),%ecx
  80149a:	89 08                	mov    %ecx,(%eax)
  80149c:	8b 02                	mov    (%edx),%eax
  80149e:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a3:	eb 0e                	jmp    8014b3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8014a5:	8b 10                	mov    (%eax),%edx
  8014a7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8014aa:	89 08                	mov    %ecx,(%eax)
  8014ac:	8b 02                	mov    (%edx),%eax
  8014ae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8014b3:	5d                   	pop    %ebp
  8014b4:	c3                   	ret    

008014b5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8014bb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8014bf:	8b 10                	mov    (%eax),%edx
  8014c1:	3b 50 04             	cmp    0x4(%eax),%edx
  8014c4:	73 0a                	jae    8014d0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8014c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014c9:	88 0a                	mov    %cl,(%edx)
  8014cb:	83 c2 01             	add    $0x1,%edx
  8014ce:	89 10                	mov    %edx,(%eax)
}
  8014d0:	5d                   	pop    %ebp
  8014d1:	c3                   	ret    

008014d2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014d8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8014db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014df:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	89 04 24             	mov    %eax,(%esp)
  8014f3:	e8 02 00 00 00       	call   8014fa <vprintfmt>
	va_end(ap);
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	57                   	push   %edi
  8014fe:	56                   	push   %esi
  8014ff:	53                   	push   %ebx
  801500:	83 ec 4c             	sub    $0x4c,%esp
  801503:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801506:	8b 75 10             	mov    0x10(%ebp),%esi
  801509:	eb 12                	jmp    80151d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80150b:	85 c0                	test   %eax,%eax
  80150d:	0f 84 a9 03 00 00    	je     8018bc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  801513:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801517:	89 04 24             	mov    %eax,(%esp)
  80151a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80151d:	0f b6 06             	movzbl (%esi),%eax
  801520:	83 c6 01             	add    $0x1,%esi
  801523:	83 f8 25             	cmp    $0x25,%eax
  801526:	75 e3                	jne    80150b <vprintfmt+0x11>
  801528:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80152c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801533:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  801538:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80153f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801544:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801547:	eb 2b                	jmp    801574 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801549:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80154c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801550:	eb 22                	jmp    801574 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801552:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801555:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801559:	eb 19                	jmp    801574 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80155b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80155e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801565:	eb 0d                	jmp    801574 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80156a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80156d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801574:	0f b6 06             	movzbl (%esi),%eax
  801577:	0f b6 d0             	movzbl %al,%edx
  80157a:	8d 7e 01             	lea    0x1(%esi),%edi
  80157d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  801580:	83 e8 23             	sub    $0x23,%eax
  801583:	3c 55                	cmp    $0x55,%al
  801585:	0f 87 0b 03 00 00    	ja     801896 <vprintfmt+0x39c>
  80158b:	0f b6 c0             	movzbl %al,%eax
  80158e:	ff 24 85 20 24 80 00 	jmp    *0x802420(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801595:	83 ea 30             	sub    $0x30,%edx
  801598:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80159b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80159f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015a2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8015a5:	83 fa 09             	cmp    $0x9,%edx
  8015a8:	77 4a                	ja     8015f4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015aa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8015ad:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8015b0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8015b3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8015b7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8015ba:	8d 50 d0             	lea    -0x30(%eax),%edx
  8015bd:	83 fa 09             	cmp    $0x9,%edx
  8015c0:	76 eb                	jbe    8015ad <vprintfmt+0xb3>
  8015c2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8015c5:	eb 2d                	jmp    8015f4 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8015c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ca:	8d 50 04             	lea    0x4(%eax),%edx
  8015cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8015d0:	8b 00                	mov    (%eax),%eax
  8015d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015d5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8015d8:	eb 1a                	jmp    8015f4 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015da:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8015dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015e1:	79 91                	jns    801574 <vprintfmt+0x7a>
  8015e3:	e9 73 ff ff ff       	jmp    80155b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015e8:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8015eb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8015f2:	eb 80                	jmp    801574 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  8015f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015f8:	0f 89 76 ff ff ff    	jns    801574 <vprintfmt+0x7a>
  8015fe:	e9 64 ff ff ff       	jmp    801567 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801603:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801606:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801609:	e9 66 ff ff ff       	jmp    801574 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80160e:	8b 45 14             	mov    0x14(%ebp),%eax
  801611:	8d 50 04             	lea    0x4(%eax),%edx
  801614:	89 55 14             	mov    %edx,0x14(%ebp)
  801617:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80161b:	8b 00                	mov    (%eax),%eax
  80161d:	89 04 24             	mov    %eax,(%esp)
  801620:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801623:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801626:	e9 f2 fe ff ff       	jmp    80151d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80162b:	8b 45 14             	mov    0x14(%ebp),%eax
  80162e:	8d 50 04             	lea    0x4(%eax),%edx
  801631:	89 55 14             	mov    %edx,0x14(%ebp)
  801634:	8b 00                	mov    (%eax),%eax
  801636:	89 c2                	mov    %eax,%edx
  801638:	c1 fa 1f             	sar    $0x1f,%edx
  80163b:	31 d0                	xor    %edx,%eax
  80163d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80163f:	83 f8 0f             	cmp    $0xf,%eax
  801642:	7f 0b                	jg     80164f <vprintfmt+0x155>
  801644:	8b 14 85 80 25 80 00 	mov    0x802580(,%eax,4),%edx
  80164b:	85 d2                	test   %edx,%edx
  80164d:	75 23                	jne    801672 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80164f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801653:	c7 44 24 08 ff 22 80 	movl   $0x8022ff,0x8(%esp)
  80165a:	00 
  80165b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80165f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801662:	89 3c 24             	mov    %edi,(%esp)
  801665:	e8 68 fe ff ff       	call   8014d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80166a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80166d:	e9 ab fe ff ff       	jmp    80151d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  801672:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801676:	c7 44 24 08 7d 22 80 	movl   $0x80227d,0x8(%esp)
  80167d:	00 
  80167e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801682:	8b 7d 08             	mov    0x8(%ebp),%edi
  801685:	89 3c 24             	mov    %edi,(%esp)
  801688:	e8 45 fe ff ff       	call   8014d2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80168d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  801690:	e9 88 fe ff ff       	jmp    80151d <vprintfmt+0x23>
  801695:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80169b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80169e:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a1:	8d 50 04             	lea    0x4(%eax),%edx
  8016a4:	89 55 14             	mov    %edx,0x14(%ebp)
  8016a7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8016a9:	85 f6                	test   %esi,%esi
  8016ab:	ba f8 22 80 00       	mov    $0x8022f8,%edx
  8016b0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8016b3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8016b7:	7e 06                	jle    8016bf <vprintfmt+0x1c5>
  8016b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8016bd:	75 10                	jne    8016cf <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016bf:	0f be 06             	movsbl (%esi),%eax
  8016c2:	83 c6 01             	add    $0x1,%esi
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	0f 85 86 00 00 00    	jne    801753 <vprintfmt+0x259>
  8016cd:	eb 76                	jmp    801745 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8016cf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016d3:	89 34 24             	mov    %esi,(%esp)
  8016d6:	e8 90 02 00 00       	call   80196b <strnlen>
  8016db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8016de:	29 c2                	sub    %eax,%edx
  8016e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8016e3:	85 d2                	test   %edx,%edx
  8016e5:	7e d8                	jle    8016bf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8016e7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8016eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8016ee:	89 d6                	mov    %edx,%esi
  8016f0:	89 7d d0             	mov    %edi,-0x30(%ebp)
  8016f3:	89 c7                	mov    %eax,%edi
  8016f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016f9:	89 3c 24             	mov    %edi,(%esp)
  8016fc:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8016ff:	83 ee 01             	sub    $0x1,%esi
  801702:	75 f1                	jne    8016f5 <vprintfmt+0x1fb>
  801704:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801707:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80170a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80170d:	eb b0                	jmp    8016bf <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80170f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801713:	74 18                	je     80172d <vprintfmt+0x233>
  801715:	8d 50 e0             	lea    -0x20(%eax),%edx
  801718:	83 fa 5e             	cmp    $0x5e,%edx
  80171b:	76 10                	jbe    80172d <vprintfmt+0x233>
					putch('?', putdat);
  80171d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801721:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801728:	ff 55 08             	call   *0x8(%ebp)
  80172b:	eb 0a                	jmp    801737 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80172d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801731:	89 04 24             	mov    %eax,(%esp)
  801734:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801737:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80173b:	0f be 06             	movsbl (%esi),%eax
  80173e:	83 c6 01             	add    $0x1,%esi
  801741:	85 c0                	test   %eax,%eax
  801743:	75 0e                	jne    801753 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801745:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801748:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80174c:	7f 16                	jg     801764 <vprintfmt+0x26a>
  80174e:	e9 ca fd ff ff       	jmp    80151d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801753:	85 ff                	test   %edi,%edi
  801755:	78 b8                	js     80170f <vprintfmt+0x215>
  801757:	83 ef 01             	sub    $0x1,%edi
  80175a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801760:	79 ad                	jns    80170f <vprintfmt+0x215>
  801762:	eb e1                	jmp    801745 <vprintfmt+0x24b>
  801764:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801767:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80176a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80176e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801775:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801777:	83 ee 01             	sub    $0x1,%esi
  80177a:	75 ee                	jne    80176a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80177c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80177f:	e9 99 fd ff ff       	jmp    80151d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801784:	83 f9 01             	cmp    $0x1,%ecx
  801787:	7e 10                	jle    801799 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  801789:	8b 45 14             	mov    0x14(%ebp),%eax
  80178c:	8d 50 08             	lea    0x8(%eax),%edx
  80178f:	89 55 14             	mov    %edx,0x14(%ebp)
  801792:	8b 30                	mov    (%eax),%esi
  801794:	8b 78 04             	mov    0x4(%eax),%edi
  801797:	eb 26                	jmp    8017bf <vprintfmt+0x2c5>
	else if (lflag)
  801799:	85 c9                	test   %ecx,%ecx
  80179b:	74 12                	je     8017af <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80179d:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a0:	8d 50 04             	lea    0x4(%eax),%edx
  8017a3:	89 55 14             	mov    %edx,0x14(%ebp)
  8017a6:	8b 30                	mov    (%eax),%esi
  8017a8:	89 f7                	mov    %esi,%edi
  8017aa:	c1 ff 1f             	sar    $0x1f,%edi
  8017ad:	eb 10                	jmp    8017bf <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8017af:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b2:	8d 50 04             	lea    0x4(%eax),%edx
  8017b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8017b8:	8b 30                	mov    (%eax),%esi
  8017ba:	89 f7                	mov    %esi,%edi
  8017bc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8017bf:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8017c4:	85 ff                	test   %edi,%edi
  8017c6:	0f 89 8c 00 00 00    	jns    801858 <vprintfmt+0x35e>
				putch('-', putdat);
  8017cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017d0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8017d7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8017da:	f7 de                	neg    %esi
  8017dc:	83 d7 00             	adc    $0x0,%edi
  8017df:	f7 df                	neg    %edi
			}
			base = 10;
  8017e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8017e6:	eb 70                	jmp    801858 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8017e8:	89 ca                	mov    %ecx,%edx
  8017ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8017ed:	e8 89 fc ff ff       	call   80147b <getuint>
  8017f2:	89 c6                	mov    %eax,%esi
  8017f4:	89 d7                	mov    %edx,%edi
			base = 10;
  8017f6:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8017fb:	eb 5b                	jmp    801858 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8017fd:	89 ca                	mov    %ecx,%edx
  8017ff:	8d 45 14             	lea    0x14(%ebp),%eax
  801802:	e8 74 fc ff ff       	call   80147b <getuint>
  801807:	89 c6                	mov    %eax,%esi
  801809:	89 d7                	mov    %edx,%edi
			base = 8;
  80180b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  801810:	eb 46                	jmp    801858 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  801812:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801816:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80181d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801820:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801824:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80182b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80182e:	8b 45 14             	mov    0x14(%ebp),%eax
  801831:	8d 50 04             	lea    0x4(%eax),%edx
  801834:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801837:	8b 30                	mov    (%eax),%esi
  801839:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80183e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  801843:	eb 13                	jmp    801858 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801845:	89 ca                	mov    %ecx,%edx
  801847:	8d 45 14             	lea    0x14(%ebp),%eax
  80184a:	e8 2c fc ff ff       	call   80147b <getuint>
  80184f:	89 c6                	mov    %eax,%esi
  801851:	89 d7                	mov    %edx,%edi
			base = 16;
  801853:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  801858:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80185c:	89 54 24 10          	mov    %edx,0x10(%esp)
  801860:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801863:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801867:	89 44 24 08          	mov    %eax,0x8(%esp)
  80186b:	89 34 24             	mov    %esi,(%esp)
  80186e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801872:	89 da                	mov    %ebx,%edx
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	e8 24 fb ff ff       	call   8013a0 <printnum>
			break;
  80187c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80187f:	e9 99 fc ff ff       	jmp    80151d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801884:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801888:	89 14 24             	mov    %edx,(%esp)
  80188b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80188e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  801891:	e9 87 fc ff ff       	jmp    80151d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801896:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80189a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8018a1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8018a4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8018a8:	0f 84 6f fc ff ff    	je     80151d <vprintfmt+0x23>
  8018ae:	83 ee 01             	sub    $0x1,%esi
  8018b1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8018b5:	75 f7                	jne    8018ae <vprintfmt+0x3b4>
  8018b7:	e9 61 fc ff ff       	jmp    80151d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8018bc:	83 c4 4c             	add    $0x4c,%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5f                   	pop    %edi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    

008018c4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 28             	sub    $0x28,%esp
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8018d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018d3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8018d7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8018da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	74 30                	je     801915 <vsnprintf+0x51>
  8018e5:	85 d2                	test   %edx,%edx
  8018e7:	7e 2c                	jle    801915 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8018e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018f7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8018fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fe:	c7 04 24 b5 14 80 00 	movl   $0x8014b5,(%esp)
  801905:	e8 f0 fb ff ff       	call   8014fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80190a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80190d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801913:	eb 05                	jmp    80191a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801915:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801922:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801925:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801929:	8b 45 10             	mov    0x10(%ebp),%eax
  80192c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	89 44 24 04          	mov    %eax,0x4(%esp)
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	89 04 24             	mov    %eax,(%esp)
  80193d:	e8 82 ff ff ff       	call   8018c4 <vsnprintf>
	va_end(ap);

	return rc;
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    
	...

00801950 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801956:	b8 00 00 00 00       	mov    $0x0,%eax
  80195b:	80 3a 00             	cmpb   $0x0,(%edx)
  80195e:	74 09                	je     801969 <strlen+0x19>
		n++;
  801960:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801963:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801967:	75 f7                	jne    801960 <strlen+0x10>
		n++;
	return n;
}
  801969:	5d                   	pop    %ebp
  80196a:	c3                   	ret    

0080196b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	53                   	push   %ebx
  80196f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801972:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801975:	b8 00 00 00 00       	mov    $0x0,%eax
  80197a:	85 c9                	test   %ecx,%ecx
  80197c:	74 1a                	je     801998 <strnlen+0x2d>
  80197e:	80 3b 00             	cmpb   $0x0,(%ebx)
  801981:	74 15                	je     801998 <strnlen+0x2d>
  801983:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  801988:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80198a:	39 ca                	cmp    %ecx,%edx
  80198c:	74 0a                	je     801998 <strnlen+0x2d>
  80198e:	83 c2 01             	add    $0x1,%edx
  801991:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  801996:	75 f0                	jne    801988 <strnlen+0x1d>
		n++;
	return n;
}
  801998:	5b                   	pop    %ebx
  801999:	5d                   	pop    %ebp
  80199a:	c3                   	ret    

0080199b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	53                   	push   %ebx
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8019a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019aa:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8019ae:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8019b1:	83 c2 01             	add    $0x1,%edx
  8019b4:	84 c9                	test   %cl,%cl
  8019b6:	75 f2                	jne    8019aa <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8019b8:	5b                   	pop    %ebx
  8019b9:	5d                   	pop    %ebp
  8019ba:	c3                   	ret    

008019bb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	53                   	push   %ebx
  8019bf:	83 ec 08             	sub    $0x8,%esp
  8019c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8019c5:	89 1c 24             	mov    %ebx,(%esp)
  8019c8:	e8 83 ff ff ff       	call   801950 <strlen>
	strcpy(dst + len, src);
  8019cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019d4:	01 d8                	add    %ebx,%eax
  8019d6:	89 04 24             	mov    %eax,(%esp)
  8019d9:	e8 bd ff ff ff       	call   80199b <strcpy>
	return dst;
}
  8019de:	89 d8                	mov    %ebx,%eax
  8019e0:	83 c4 08             	add    $0x8,%esp
  8019e3:	5b                   	pop    %ebx
  8019e4:	5d                   	pop    %ebp
  8019e5:	c3                   	ret    

008019e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	56                   	push   %esi
  8019ea:	53                   	push   %ebx
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f1:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019f4:	85 f6                	test   %esi,%esi
  8019f6:	74 18                	je     801a10 <strncpy+0x2a>
  8019f8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8019fd:	0f b6 1a             	movzbl (%edx),%ebx
  801a00:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801a03:	80 3a 01             	cmpb   $0x1,(%edx)
  801a06:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a09:	83 c1 01             	add    $0x1,%ecx
  801a0c:	39 f1                	cmp    %esi,%ecx
  801a0e:	75 ed                	jne    8019fd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801a10:	5b                   	pop    %ebx
  801a11:	5e                   	pop    %esi
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    

00801a14 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	57                   	push   %edi
  801a18:	56                   	push   %esi
  801a19:	53                   	push   %ebx
  801a1a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a20:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801a23:	89 f8                	mov    %edi,%eax
  801a25:	85 f6                	test   %esi,%esi
  801a27:	74 2b                	je     801a54 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  801a29:	83 fe 01             	cmp    $0x1,%esi
  801a2c:	74 23                	je     801a51 <strlcpy+0x3d>
  801a2e:	0f b6 0b             	movzbl (%ebx),%ecx
  801a31:	84 c9                	test   %cl,%cl
  801a33:	74 1c                	je     801a51 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  801a35:	83 ee 02             	sub    $0x2,%esi
  801a38:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801a3d:	88 08                	mov    %cl,(%eax)
  801a3f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a42:	39 f2                	cmp    %esi,%edx
  801a44:	74 0b                	je     801a51 <strlcpy+0x3d>
  801a46:	83 c2 01             	add    $0x1,%edx
  801a49:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801a4d:	84 c9                	test   %cl,%cl
  801a4f:	75 ec                	jne    801a3d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  801a51:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801a54:	29 f8                	sub    %edi,%eax
}
  801a56:	5b                   	pop    %ebx
  801a57:	5e                   	pop    %esi
  801a58:	5f                   	pop    %edi
  801a59:	5d                   	pop    %ebp
  801a5a:	c3                   	ret    

00801a5b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a61:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801a64:	0f b6 01             	movzbl (%ecx),%eax
  801a67:	84 c0                	test   %al,%al
  801a69:	74 16                	je     801a81 <strcmp+0x26>
  801a6b:	3a 02                	cmp    (%edx),%al
  801a6d:	75 12                	jne    801a81 <strcmp+0x26>
		p++, q++;
  801a6f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a72:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  801a76:	84 c0                	test   %al,%al
  801a78:	74 07                	je     801a81 <strcmp+0x26>
  801a7a:	83 c1 01             	add    $0x1,%ecx
  801a7d:	3a 02                	cmp    (%edx),%al
  801a7f:	74 ee                	je     801a6f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a81:	0f b6 c0             	movzbl %al,%eax
  801a84:	0f b6 12             	movzbl (%edx),%edx
  801a87:	29 d0                	sub    %edx,%eax
}
  801a89:	5d                   	pop    %ebp
  801a8a:	c3                   	ret    

00801a8b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	53                   	push   %ebx
  801a8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a95:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801a98:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801a9d:	85 d2                	test   %edx,%edx
  801a9f:	74 28                	je     801ac9 <strncmp+0x3e>
  801aa1:	0f b6 01             	movzbl (%ecx),%eax
  801aa4:	84 c0                	test   %al,%al
  801aa6:	74 24                	je     801acc <strncmp+0x41>
  801aa8:	3a 03                	cmp    (%ebx),%al
  801aaa:	75 20                	jne    801acc <strncmp+0x41>
  801aac:	83 ea 01             	sub    $0x1,%edx
  801aaf:	74 13                	je     801ac4 <strncmp+0x39>
		n--, p++, q++;
  801ab1:	83 c1 01             	add    $0x1,%ecx
  801ab4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ab7:	0f b6 01             	movzbl (%ecx),%eax
  801aba:	84 c0                	test   %al,%al
  801abc:	74 0e                	je     801acc <strncmp+0x41>
  801abe:	3a 03                	cmp    (%ebx),%al
  801ac0:	74 ea                	je     801aac <strncmp+0x21>
  801ac2:	eb 08                	jmp    801acc <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801ac4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801ac9:	5b                   	pop    %ebx
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801acc:	0f b6 01             	movzbl (%ecx),%eax
  801acf:	0f b6 13             	movzbl (%ebx),%edx
  801ad2:	29 d0                	sub    %edx,%eax
  801ad4:	eb f3                	jmp    801ac9 <strncmp+0x3e>

00801ad6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801ae0:	0f b6 10             	movzbl (%eax),%edx
  801ae3:	84 d2                	test   %dl,%dl
  801ae5:	74 1c                	je     801b03 <strchr+0x2d>
		if (*s == c)
  801ae7:	38 ca                	cmp    %cl,%dl
  801ae9:	75 09                	jne    801af4 <strchr+0x1e>
  801aeb:	eb 1b                	jmp    801b08 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801aed:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  801af0:	38 ca                	cmp    %cl,%dl
  801af2:	74 14                	je     801b08 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801af4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  801af8:	84 d2                	test   %dl,%dl
  801afa:	75 f1                	jne    801aed <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  801afc:	b8 00 00 00 00       	mov    $0x0,%eax
  801b01:	eb 05                	jmp    801b08 <strchr+0x32>
  801b03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801b14:	0f b6 10             	movzbl (%eax),%edx
  801b17:	84 d2                	test   %dl,%dl
  801b19:	74 14                	je     801b2f <strfind+0x25>
		if (*s == c)
  801b1b:	38 ca                	cmp    %cl,%dl
  801b1d:	75 06                	jne    801b25 <strfind+0x1b>
  801b1f:	eb 0e                	jmp    801b2f <strfind+0x25>
  801b21:	38 ca                	cmp    %cl,%dl
  801b23:	74 0a                	je     801b2f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b25:	83 c0 01             	add    $0x1,%eax
  801b28:	0f b6 10             	movzbl (%eax),%edx
  801b2b:	84 d2                	test   %dl,%dl
  801b2d:	75 f2                	jne    801b21 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    

00801b31 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b3a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b3d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b40:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b46:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801b49:	85 c9                	test   %ecx,%ecx
  801b4b:	74 30                	je     801b7d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801b4d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801b53:	75 25                	jne    801b7a <memset+0x49>
  801b55:	f6 c1 03             	test   $0x3,%cl
  801b58:	75 20                	jne    801b7a <memset+0x49>
		c &= 0xFF;
  801b5a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801b5d:	89 d3                	mov    %edx,%ebx
  801b5f:	c1 e3 08             	shl    $0x8,%ebx
  801b62:	89 d6                	mov    %edx,%esi
  801b64:	c1 e6 18             	shl    $0x18,%esi
  801b67:	89 d0                	mov    %edx,%eax
  801b69:	c1 e0 10             	shl    $0x10,%eax
  801b6c:	09 f0                	or     %esi,%eax
  801b6e:	09 d0                	or     %edx,%eax
  801b70:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801b72:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801b75:	fc                   	cld    
  801b76:	f3 ab                	rep stos %eax,%es:(%edi)
  801b78:	eb 03                	jmp    801b7d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801b7a:	fc                   	cld    
  801b7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801b7d:	89 f8                	mov    %edi,%eax
  801b7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b82:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b88:	89 ec                	mov    %ebp,%esp
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    

00801b8c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 08             	sub    $0x8,%esp
  801b92:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b95:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801ba1:	39 c6                	cmp    %eax,%esi
  801ba3:	73 36                	jae    801bdb <memmove+0x4f>
  801ba5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801ba8:	39 d0                	cmp    %edx,%eax
  801baa:	73 2f                	jae    801bdb <memmove+0x4f>
		s += n;
		d += n;
  801bac:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801baf:	f6 c2 03             	test   $0x3,%dl
  801bb2:	75 1b                	jne    801bcf <memmove+0x43>
  801bb4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801bba:	75 13                	jne    801bcf <memmove+0x43>
  801bbc:	f6 c1 03             	test   $0x3,%cl
  801bbf:	75 0e                	jne    801bcf <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801bc1:	83 ef 04             	sub    $0x4,%edi
  801bc4:	8d 72 fc             	lea    -0x4(%edx),%esi
  801bc7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801bca:	fd                   	std    
  801bcb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801bcd:	eb 09                	jmp    801bd8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801bcf:	83 ef 01             	sub    $0x1,%edi
  801bd2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801bd5:	fd                   	std    
  801bd6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801bd8:	fc                   	cld    
  801bd9:	eb 20                	jmp    801bfb <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801bdb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801be1:	75 13                	jne    801bf6 <memmove+0x6a>
  801be3:	a8 03                	test   $0x3,%al
  801be5:	75 0f                	jne    801bf6 <memmove+0x6a>
  801be7:	f6 c1 03             	test   $0x3,%cl
  801bea:	75 0a                	jne    801bf6 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801bec:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801bef:	89 c7                	mov    %eax,%edi
  801bf1:	fc                   	cld    
  801bf2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801bf4:	eb 05                	jmp    801bfb <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801bf6:	89 c7                	mov    %eax,%edi
  801bf8:	fc                   	cld    
  801bf9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801bfb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801bfe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c01:	89 ec                	mov    %ebp,%esp
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    

00801c05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	89 04 24             	mov    %eax,(%esp)
  801c1f:	e8 68 ff ff ff       	call   801b8c <memmove>
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	57                   	push   %edi
  801c2a:	56                   	push   %esi
  801c2b:	53                   	push   %ebx
  801c2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c32:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c35:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c3a:	85 ff                	test   %edi,%edi
  801c3c:	74 37                	je     801c75 <memcmp+0x4f>
		if (*s1 != *s2)
  801c3e:	0f b6 03             	movzbl (%ebx),%eax
  801c41:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c44:	83 ef 01             	sub    $0x1,%edi
  801c47:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  801c4c:	38 c8                	cmp    %cl,%al
  801c4e:	74 1c                	je     801c6c <memcmp+0x46>
  801c50:	eb 10                	jmp    801c62 <memcmp+0x3c>
  801c52:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801c57:	83 c2 01             	add    $0x1,%edx
  801c5a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801c5e:	38 c8                	cmp    %cl,%al
  801c60:	74 0a                	je     801c6c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  801c62:	0f b6 c0             	movzbl %al,%eax
  801c65:	0f b6 c9             	movzbl %cl,%ecx
  801c68:	29 c8                	sub    %ecx,%eax
  801c6a:	eb 09                	jmp    801c75 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c6c:	39 fa                	cmp    %edi,%edx
  801c6e:	75 e2                	jne    801c52 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c75:	5b                   	pop    %ebx
  801c76:	5e                   	pop    %esi
  801c77:	5f                   	pop    %edi
  801c78:	5d                   	pop    %ebp
  801c79:	c3                   	ret    

00801c7a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801c80:	89 c2                	mov    %eax,%edx
  801c82:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801c85:	39 d0                	cmp    %edx,%eax
  801c87:	73 19                	jae    801ca2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c89:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801c8d:	38 08                	cmp    %cl,(%eax)
  801c8f:	75 06                	jne    801c97 <memfind+0x1d>
  801c91:	eb 0f                	jmp    801ca2 <memfind+0x28>
  801c93:	38 08                	cmp    %cl,(%eax)
  801c95:	74 0b                	je     801ca2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c97:	83 c0 01             	add    $0x1,%eax
  801c9a:	39 d0                	cmp    %edx,%eax
  801c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ca0:	75 f1                	jne    801c93 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    

00801ca4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	57                   	push   %edi
  801ca8:	56                   	push   %esi
  801ca9:	53                   	push   %ebx
  801caa:	8b 55 08             	mov    0x8(%ebp),%edx
  801cad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801cb0:	0f b6 02             	movzbl (%edx),%eax
  801cb3:	3c 20                	cmp    $0x20,%al
  801cb5:	74 04                	je     801cbb <strtol+0x17>
  801cb7:	3c 09                	cmp    $0x9,%al
  801cb9:	75 0e                	jne    801cc9 <strtol+0x25>
		s++;
  801cbb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801cbe:	0f b6 02             	movzbl (%edx),%eax
  801cc1:	3c 20                	cmp    $0x20,%al
  801cc3:	74 f6                	je     801cbb <strtol+0x17>
  801cc5:	3c 09                	cmp    $0x9,%al
  801cc7:	74 f2                	je     801cbb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  801cc9:	3c 2b                	cmp    $0x2b,%al
  801ccb:	75 0a                	jne    801cd7 <strtol+0x33>
		s++;
  801ccd:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801cd0:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd5:	eb 10                	jmp    801ce7 <strtol+0x43>
  801cd7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801cdc:	3c 2d                	cmp    $0x2d,%al
  801cde:	75 07                	jne    801ce7 <strtol+0x43>
		s++, neg = 1;
  801ce0:	83 c2 01             	add    $0x1,%edx
  801ce3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ce7:	85 db                	test   %ebx,%ebx
  801ce9:	0f 94 c0             	sete   %al
  801cec:	74 05                	je     801cf3 <strtol+0x4f>
  801cee:	83 fb 10             	cmp    $0x10,%ebx
  801cf1:	75 15                	jne    801d08 <strtol+0x64>
  801cf3:	80 3a 30             	cmpb   $0x30,(%edx)
  801cf6:	75 10                	jne    801d08 <strtol+0x64>
  801cf8:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801cfc:	75 0a                	jne    801d08 <strtol+0x64>
		s += 2, base = 16;
  801cfe:	83 c2 02             	add    $0x2,%edx
  801d01:	bb 10 00 00 00       	mov    $0x10,%ebx
  801d06:	eb 13                	jmp    801d1b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  801d08:	84 c0                	test   %al,%al
  801d0a:	74 0f                	je     801d1b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801d0c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801d11:	80 3a 30             	cmpb   $0x30,(%edx)
  801d14:	75 05                	jne    801d1b <strtol+0x77>
		s++, base = 8;
  801d16:	83 c2 01             	add    $0x1,%edx
  801d19:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d20:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d22:	0f b6 0a             	movzbl (%edx),%ecx
  801d25:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801d28:	80 fb 09             	cmp    $0x9,%bl
  801d2b:	77 08                	ja     801d35 <strtol+0x91>
			dig = *s - '0';
  801d2d:	0f be c9             	movsbl %cl,%ecx
  801d30:	83 e9 30             	sub    $0x30,%ecx
  801d33:	eb 1e                	jmp    801d53 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  801d35:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  801d38:	80 fb 19             	cmp    $0x19,%bl
  801d3b:	77 08                	ja     801d45 <strtol+0xa1>
			dig = *s - 'a' + 10;
  801d3d:	0f be c9             	movsbl %cl,%ecx
  801d40:	83 e9 57             	sub    $0x57,%ecx
  801d43:	eb 0e                	jmp    801d53 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  801d45:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  801d48:	80 fb 19             	cmp    $0x19,%bl
  801d4b:	77 14                	ja     801d61 <strtol+0xbd>
			dig = *s - 'A' + 10;
  801d4d:	0f be c9             	movsbl %cl,%ecx
  801d50:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801d53:	39 f1                	cmp    %esi,%ecx
  801d55:	7d 0e                	jge    801d65 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801d57:	83 c2 01             	add    $0x1,%edx
  801d5a:	0f af c6             	imul   %esi,%eax
  801d5d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  801d5f:	eb c1                	jmp    801d22 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  801d61:	89 c1                	mov    %eax,%ecx
  801d63:	eb 02                	jmp    801d67 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801d65:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d6b:	74 05                	je     801d72 <strtol+0xce>
		*endptr = (char *) s;
  801d6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d70:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801d72:	89 ca                	mov    %ecx,%edx
  801d74:	f7 da                	neg    %edx
  801d76:	85 ff                	test   %edi,%edi
  801d78:	0f 45 c2             	cmovne %edx,%eax
}
  801d7b:	5b                   	pop    %ebx
  801d7c:	5e                   	pop    %esi
  801d7d:	5f                   	pop    %edi
  801d7e:	5d                   	pop    %ebp
  801d7f:	c3                   	ret    

00801d80 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	56                   	push   %esi
  801d84:	53                   	push   %ebx
  801d85:	83 ec 10             	sub    $0x10,%esp
  801d88:	8b 75 08             	mov    0x8(%ebp),%esi
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801d91:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801d93:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d98:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801d9b:	89 04 24             	mov    %eax,(%esp)
  801d9e:	e8 8e e6 ff ff       	call   800431 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801da3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801da8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801dad:	85 c0                	test   %eax,%eax
  801daf:	78 0e                	js     801dbf <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801db1:	a1 04 40 80 00       	mov    0x804004,%eax
  801db6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801db9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801dbc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801dbf:	85 f6                	test   %esi,%esi
  801dc1:	74 02                	je     801dc5 <ipc_recv+0x45>
		*from_env_store = sender;
  801dc3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801dc5:	85 db                	test   %ebx,%ebx
  801dc7:	74 02                	je     801dcb <ipc_recv+0x4b>
		*perm_store = perm;
  801dc9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	5b                   	pop    %ebx
  801dcf:	5e                   	pop    %esi
  801dd0:	5d                   	pop    %ebp
  801dd1:	c3                   	ret    

00801dd2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	57                   	push   %edi
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 1c             	sub    $0x1c,%esp
  801ddb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801dde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801de1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801de4:	85 db                	test   %ebx,%ebx
  801de6:	75 04                	jne    801dec <ipc_send+0x1a>
  801de8:	85 f6                	test   %esi,%esi
  801dea:	75 15                	jne    801e01 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801dec:	85 db                	test   %ebx,%ebx
  801dee:	74 16                	je     801e06 <ipc_send+0x34>
  801df0:	85 f6                	test   %esi,%esi
  801df2:	0f 94 c0             	sete   %al
      pg = 0;
  801df5:	84 c0                	test   %al,%al
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	0f 45 d8             	cmovne %eax,%ebx
  801dff:	eb 05                	jmp    801e06 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801e01:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801e06:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e0a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e0e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	89 04 24             	mov    %eax,(%esp)
  801e18:	e8 e0 e5 ff ff       	call   8003fd <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801e1d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e20:	75 07                	jne    801e29 <ipc_send+0x57>
           sys_yield();
  801e22:	e8 71 e3 ff ff       	call   800198 <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801e27:	eb dd                	jmp    801e06 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	90                   	nop
  801e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e30:	74 1c                	je     801e4e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801e32:	c7 44 24 08 e0 25 80 	movl   $0x8025e0,0x8(%esp)
  801e39:	00 
  801e3a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801e41:	00 
  801e42:	c7 04 24 ea 25 80 00 	movl   $0x8025ea,(%esp)
  801e49:	e8 32 f4 ff ff       	call   801280 <_panic>
		}
    }
}
  801e4e:	83 c4 1c             	add    $0x1c,%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5f                   	pop    %edi
  801e54:	5d                   	pop    %ebp
  801e55:	c3                   	ret    

00801e56 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e5c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801e61:	39 c8                	cmp    %ecx,%eax
  801e63:	74 17                	je     801e7c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e65:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e6a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e6d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e73:	8b 52 50             	mov    0x50(%edx),%edx
  801e76:	39 ca                	cmp    %ecx,%edx
  801e78:	75 14                	jne    801e8e <ipc_find_env+0x38>
  801e7a:	eb 05                	jmp    801e81 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801e81:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e84:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801e89:	8b 40 40             	mov    0x40(%eax),%eax
  801e8c:	eb 0e                	jmp    801e9c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e8e:	83 c0 01             	add    $0x1,%eax
  801e91:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e96:	75 d2                	jne    801e6a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e98:	66 b8 00 00          	mov    $0x0,%ax
}
  801e9c:	5d                   	pop    %ebp
  801e9d:	c3                   	ret    
	...

00801ea0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ea6:	89 d0                	mov    %edx,%eax
  801ea8:	c1 e8 16             	shr    $0x16,%eax
  801eab:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801eb7:	f6 c1 01             	test   $0x1,%cl
  801eba:	74 1d                	je     801ed9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801ebc:	c1 ea 0c             	shr    $0xc,%edx
  801ebf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ec6:	f6 c2 01             	test   $0x1,%dl
  801ec9:	74 0e                	je     801ed9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ecb:	c1 ea 0c             	shr    $0xc,%edx
  801ece:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ed5:	ef 
  801ed6:	0f b7 c0             	movzwl %ax,%eax
}
  801ed9:	5d                   	pop    %ebp
  801eda:	c3                   	ret    
  801edb:	00 00                	add    %al,(%eax)
  801edd:	00 00                	add    %al,(%eax)
	...

00801ee0 <__udivdi3>:
  801ee0:	83 ec 1c             	sub    $0x1c,%esp
  801ee3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801ee7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801eeb:	8b 44 24 20          	mov    0x20(%esp),%eax
  801eef:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801ef3:	89 74 24 10          	mov    %esi,0x10(%esp)
  801ef7:	8b 74 24 24          	mov    0x24(%esp),%esi
  801efb:	85 ff                	test   %edi,%edi
  801efd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801f01:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f05:	89 cd                	mov    %ecx,%ebp
  801f07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0b:	75 33                	jne    801f40 <__udivdi3+0x60>
  801f0d:	39 f1                	cmp    %esi,%ecx
  801f0f:	77 57                	ja     801f68 <__udivdi3+0x88>
  801f11:	85 c9                	test   %ecx,%ecx
  801f13:	75 0b                	jne    801f20 <__udivdi3+0x40>
  801f15:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1a:	31 d2                	xor    %edx,%edx
  801f1c:	f7 f1                	div    %ecx
  801f1e:	89 c1                	mov    %eax,%ecx
  801f20:	89 f0                	mov    %esi,%eax
  801f22:	31 d2                	xor    %edx,%edx
  801f24:	f7 f1                	div    %ecx
  801f26:	89 c6                	mov    %eax,%esi
  801f28:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f2c:	f7 f1                	div    %ecx
  801f2e:	89 f2                	mov    %esi,%edx
  801f30:	8b 74 24 10          	mov    0x10(%esp),%esi
  801f34:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801f38:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801f3c:	83 c4 1c             	add    $0x1c,%esp
  801f3f:	c3                   	ret    
  801f40:	31 d2                	xor    %edx,%edx
  801f42:	31 c0                	xor    %eax,%eax
  801f44:	39 f7                	cmp    %esi,%edi
  801f46:	77 e8                	ja     801f30 <__udivdi3+0x50>
  801f48:	0f bd cf             	bsr    %edi,%ecx
  801f4b:	83 f1 1f             	xor    $0x1f,%ecx
  801f4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f52:	75 2c                	jne    801f80 <__udivdi3+0xa0>
  801f54:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  801f58:	76 04                	jbe    801f5e <__udivdi3+0x7e>
  801f5a:	39 f7                	cmp    %esi,%edi
  801f5c:	73 d2                	jae    801f30 <__udivdi3+0x50>
  801f5e:	31 d2                	xor    %edx,%edx
  801f60:	b8 01 00 00 00       	mov    $0x1,%eax
  801f65:	eb c9                	jmp    801f30 <__udivdi3+0x50>
  801f67:	90                   	nop
  801f68:	89 f2                	mov    %esi,%edx
  801f6a:	f7 f1                	div    %ecx
  801f6c:	31 d2                	xor    %edx,%edx
  801f6e:	8b 74 24 10          	mov    0x10(%esp),%esi
  801f72:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801f76:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801f7a:	83 c4 1c             	add    $0x1c,%esp
  801f7d:	c3                   	ret    
  801f7e:	66 90                	xchg   %ax,%ax
  801f80:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f85:	b8 20 00 00 00       	mov    $0x20,%eax
  801f8a:	89 ea                	mov    %ebp,%edx
  801f8c:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f90:	d3 e7                	shl    %cl,%edi
  801f92:	89 c1                	mov    %eax,%ecx
  801f94:	d3 ea                	shr    %cl,%edx
  801f96:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f9b:	09 fa                	or     %edi,%edx
  801f9d:	89 f7                	mov    %esi,%edi
  801f9f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fa3:	89 f2                	mov    %esi,%edx
  801fa5:	8b 74 24 08          	mov    0x8(%esp),%esi
  801fa9:	d3 e5                	shl    %cl,%ebp
  801fab:	89 c1                	mov    %eax,%ecx
  801fad:	d3 ef                	shr    %cl,%edi
  801faf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fb4:	d3 e2                	shl    %cl,%edx
  801fb6:	89 c1                	mov    %eax,%ecx
  801fb8:	d3 ee                	shr    %cl,%esi
  801fba:	09 d6                	or     %edx,%esi
  801fbc:	89 fa                	mov    %edi,%edx
  801fbe:	89 f0                	mov    %esi,%eax
  801fc0:	f7 74 24 0c          	divl   0xc(%esp)
  801fc4:	89 d7                	mov    %edx,%edi
  801fc6:	89 c6                	mov    %eax,%esi
  801fc8:	f7 e5                	mul    %ebp
  801fca:	39 d7                	cmp    %edx,%edi
  801fcc:	72 22                	jb     801ff0 <__udivdi3+0x110>
  801fce:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  801fd2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fd7:	d3 e5                	shl    %cl,%ebp
  801fd9:	39 c5                	cmp    %eax,%ebp
  801fdb:	73 04                	jae    801fe1 <__udivdi3+0x101>
  801fdd:	39 d7                	cmp    %edx,%edi
  801fdf:	74 0f                	je     801ff0 <__udivdi3+0x110>
  801fe1:	89 f0                	mov    %esi,%eax
  801fe3:	31 d2                	xor    %edx,%edx
  801fe5:	e9 46 ff ff ff       	jmp    801f30 <__udivdi3+0x50>
  801fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ff0:	8d 46 ff             	lea    -0x1(%esi),%eax
  801ff3:	31 d2                	xor    %edx,%edx
  801ff5:	8b 74 24 10          	mov    0x10(%esp),%esi
  801ff9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801ffd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802001:	83 c4 1c             	add    $0x1c,%esp
  802004:	c3                   	ret    
	...

00802010 <__umoddi3>:
  802010:	83 ec 1c             	sub    $0x1c,%esp
  802013:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802017:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80201b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80201f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802023:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802027:	8b 74 24 24          	mov    0x24(%esp),%esi
  80202b:	85 ed                	test   %ebp,%ebp
  80202d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802031:	89 44 24 08          	mov    %eax,0x8(%esp)
  802035:	89 cf                	mov    %ecx,%edi
  802037:	89 04 24             	mov    %eax,(%esp)
  80203a:	89 f2                	mov    %esi,%edx
  80203c:	75 1a                	jne    802058 <__umoddi3+0x48>
  80203e:	39 f1                	cmp    %esi,%ecx
  802040:	76 4e                	jbe    802090 <__umoddi3+0x80>
  802042:	f7 f1                	div    %ecx
  802044:	89 d0                	mov    %edx,%eax
  802046:	31 d2                	xor    %edx,%edx
  802048:	8b 74 24 10          	mov    0x10(%esp),%esi
  80204c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802050:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802054:	83 c4 1c             	add    $0x1c,%esp
  802057:	c3                   	ret    
  802058:	39 f5                	cmp    %esi,%ebp
  80205a:	77 54                	ja     8020b0 <__umoddi3+0xa0>
  80205c:	0f bd c5             	bsr    %ebp,%eax
  80205f:	83 f0 1f             	xor    $0x1f,%eax
  802062:	89 44 24 04          	mov    %eax,0x4(%esp)
  802066:	75 60                	jne    8020c8 <__umoddi3+0xb8>
  802068:	3b 0c 24             	cmp    (%esp),%ecx
  80206b:	0f 87 07 01 00 00    	ja     802178 <__umoddi3+0x168>
  802071:	89 f2                	mov    %esi,%edx
  802073:	8b 34 24             	mov    (%esp),%esi
  802076:	29 ce                	sub    %ecx,%esi
  802078:	19 ea                	sbb    %ebp,%edx
  80207a:	89 34 24             	mov    %esi,(%esp)
  80207d:	8b 04 24             	mov    (%esp),%eax
  802080:	8b 74 24 10          	mov    0x10(%esp),%esi
  802084:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802088:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80208c:	83 c4 1c             	add    $0x1c,%esp
  80208f:	c3                   	ret    
  802090:	85 c9                	test   %ecx,%ecx
  802092:	75 0b                	jne    80209f <__umoddi3+0x8f>
  802094:	b8 01 00 00 00       	mov    $0x1,%eax
  802099:	31 d2                	xor    %edx,%edx
  80209b:	f7 f1                	div    %ecx
  80209d:	89 c1                	mov    %eax,%ecx
  80209f:	89 f0                	mov    %esi,%eax
  8020a1:	31 d2                	xor    %edx,%edx
  8020a3:	f7 f1                	div    %ecx
  8020a5:	8b 04 24             	mov    (%esp),%eax
  8020a8:	f7 f1                	div    %ecx
  8020aa:	eb 98                	jmp    802044 <__umoddi3+0x34>
  8020ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020b0:	89 f2                	mov    %esi,%edx
  8020b2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020b6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020ba:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020be:	83 c4 1c             	add    $0x1c,%esp
  8020c1:	c3                   	ret    
  8020c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020c8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020cd:	89 e8                	mov    %ebp,%eax
  8020cf:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020d4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8020d8:	89 fa                	mov    %edi,%edx
  8020da:	d3 e0                	shl    %cl,%eax
  8020dc:	89 e9                	mov    %ebp,%ecx
  8020de:	d3 ea                	shr    %cl,%edx
  8020e0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020e5:	09 c2                	or     %eax,%edx
  8020e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020eb:	89 14 24             	mov    %edx,(%esp)
  8020ee:	89 f2                	mov    %esi,%edx
  8020f0:	d3 e7                	shl    %cl,%edi
  8020f2:	89 e9                	mov    %ebp,%ecx
  8020f4:	d3 ea                	shr    %cl,%edx
  8020f6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020ff:	d3 e6                	shl    %cl,%esi
  802101:	89 e9                	mov    %ebp,%ecx
  802103:	d3 e8                	shr    %cl,%eax
  802105:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80210a:	09 f0                	or     %esi,%eax
  80210c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802110:	f7 34 24             	divl   (%esp)
  802113:	d3 e6                	shl    %cl,%esi
  802115:	89 74 24 08          	mov    %esi,0x8(%esp)
  802119:	89 d6                	mov    %edx,%esi
  80211b:	f7 e7                	mul    %edi
  80211d:	39 d6                	cmp    %edx,%esi
  80211f:	89 c1                	mov    %eax,%ecx
  802121:	89 d7                	mov    %edx,%edi
  802123:	72 3f                	jb     802164 <__umoddi3+0x154>
  802125:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802129:	72 35                	jb     802160 <__umoddi3+0x150>
  80212b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80212f:	29 c8                	sub    %ecx,%eax
  802131:	19 fe                	sbb    %edi,%esi
  802133:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802138:	89 f2                	mov    %esi,%edx
  80213a:	d3 e8                	shr    %cl,%eax
  80213c:	89 e9                	mov    %ebp,%ecx
  80213e:	d3 e2                	shl    %cl,%edx
  802140:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802145:	09 d0                	or     %edx,%eax
  802147:	89 f2                	mov    %esi,%edx
  802149:	d3 ea                	shr    %cl,%edx
  80214b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80214f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802153:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802157:	83 c4 1c             	add    $0x1c,%esp
  80215a:	c3                   	ret    
  80215b:	90                   	nop
  80215c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802160:	39 d6                	cmp    %edx,%esi
  802162:	75 c7                	jne    80212b <__umoddi3+0x11b>
  802164:	89 d7                	mov    %edx,%edi
  802166:	89 c1                	mov    %eax,%ecx
  802168:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80216c:	1b 3c 24             	sbb    (%esp),%edi
  80216f:	eb ba                	jmp    80212b <__umoddi3+0x11b>
  802171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802178:	39 f5                	cmp    %esi,%ebp
  80217a:	0f 82 f1 fe ff ff    	jb     802071 <__umoddi3+0x61>
  802180:	e9 f8 fe ff ff       	jmp    80207d <__umoddi3+0x6d>
