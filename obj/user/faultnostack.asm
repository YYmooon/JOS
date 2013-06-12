
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 2b 00 00 00       	call   80005c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  80003a:	c7 44 24 04 ac 04 80 	movl   $0x8004ac,0x4(%esp)
  800041:	00 
  800042:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800049:	e8 6d 03 00 00       	call   8003bb <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  80004e:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800055:	00 00 00 
}
  800058:	c9                   	leave  
  800059:	c3                   	ret    
	...

0080005c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	83 ec 18             	sub    $0x18,%esp
  800062:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800065:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800068:	8b 75 08             	mov    0x8(%ebp),%esi
  80006b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80006e:	e8 11 01 00 00       	call   800184 <sys_getenvid>
  800073:	25 ff 03 00 00       	and    $0x3ff,%eax
  800078:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800080:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800085:	85 f6                	test   %esi,%esi
  800087:	7e 07                	jle    800090 <libmain+0x34>
		binaryname = argv[0];
  800089:	8b 03                	mov    (%ebx),%eax
  80008b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800090:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800094:	89 34 24             	mov    %esi,(%esp)
  800097:	e8 98 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80009c:	e8 0b 00 00 00       	call   8000ac <exit>
}
  8000a1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000a4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000a7:	89 ec                	mov    %ebp,%esp
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    
	...

008000ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000b2:	e8 47 06 00 00       	call   8006fe <close_all>
	sys_env_destroy(0);
  8000b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000be:	e8 64 00 00 00       	call   800127 <sys_env_destroy>
}
  8000c3:	c9                   	leave  
  8000c4:	c3                   	ret    
  8000c5:	00 00                	add    %al,(%eax)
	...

008000c8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8000d1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8000d4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000df:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e2:	89 c3                	mov    %eax,%ebx
  8000e4:	89 c7                	mov    %eax,%edi
  8000e6:	89 c6                	mov    %eax,%esi
  8000e8:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ea:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8000ed:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8000f0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8000f3:	89 ec                	mov    %ebp,%esp
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    

008000f7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800100:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800103:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800106:	ba 00 00 00 00       	mov    $0x0,%edx
  80010b:	b8 01 00 00 00       	mov    $0x1,%eax
  800110:	89 d1                	mov    %edx,%ecx
  800112:	89 d3                	mov    %edx,%ebx
  800114:	89 d7                	mov    %edx,%edi
  800116:	89 d6                	mov    %edx,%esi
  800118:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80011a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80011d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800120:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800123:	89 ec                	mov    %ebp,%esp
  800125:	5d                   	pop    %ebp
  800126:	c3                   	ret    

00800127 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	83 ec 38             	sub    $0x38,%esp
  80012d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800130:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800133:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800136:	b9 00 00 00 00       	mov    $0x0,%ecx
  80013b:	b8 03 00 00 00       	mov    $0x3,%eax
  800140:	8b 55 08             	mov    0x8(%ebp),%edx
  800143:	89 cb                	mov    %ecx,%ebx
  800145:	89 cf                	mov    %ecx,%edi
  800147:	89 ce                	mov    %ecx,%esi
  800149:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80014b:	85 c0                	test   %eax,%eax
  80014d:	7e 28                	jle    800177 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80014f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800153:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80015a:	00 
  80015b:	c7 44 24 08 6a 22 80 	movl   $0x80226a,0x8(%esp)
  800162:	00 
  800163:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80016a:	00 
  80016b:	c7 04 24 87 22 80 00 	movl   $0x802287,(%esp)
  800172:	e8 59 11 00 00       	call   8012d0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800177:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80017a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80017d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800180:	89 ec                	mov    %ebp,%esp
  800182:	5d                   	pop    %ebp
  800183:	c3                   	ret    

00800184 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80018d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800190:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800193:	ba 00 00 00 00       	mov    $0x0,%edx
  800198:	b8 02 00 00 00       	mov    $0x2,%eax
  80019d:	89 d1                	mov    %edx,%ecx
  80019f:	89 d3                	mov    %edx,%ebx
  8001a1:	89 d7                	mov    %edx,%edi
  8001a3:	89 d6                	mov    %edx,%esi
  8001a5:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001a7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001aa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001ad:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001b0:	89 ec                	mov    %ebp,%esp
  8001b2:	5d                   	pop    %ebp
  8001b3:	c3                   	ret    

008001b4 <sys_yield>:

void
sys_yield(void)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001bd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001c0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8001c8:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001cd:	89 d1                	mov    %edx,%ecx
  8001cf:	89 d3                	mov    %edx,%ebx
  8001d1:	89 d7                	mov    %edx,%edi
  8001d3:	89 d6                	mov    %edx,%esi
  8001d5:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001d7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001da:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001dd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001e0:	89 ec                	mov    %ebp,%esp
  8001e2:	5d                   	pop    %ebp
  8001e3:	c3                   	ret    

008001e4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	83 ec 38             	sub    $0x38,%esp
  8001ea:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001ed:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001f0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001f3:	be 00 00 00 00       	mov    $0x0,%esi
  8001f8:	b8 04 00 00 00       	mov    $0x4,%eax
  8001fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800200:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800203:	8b 55 08             	mov    0x8(%ebp),%edx
  800206:	89 f7                	mov    %esi,%edi
  800208:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80020a:	85 c0                	test   %eax,%eax
  80020c:	7e 28                	jle    800236 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  80020e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800212:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800219:	00 
  80021a:	c7 44 24 08 6a 22 80 	movl   $0x80226a,0x8(%esp)
  800221:	00 
  800222:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800229:	00 
  80022a:	c7 04 24 87 22 80 00 	movl   $0x802287,(%esp)
  800231:	e8 9a 10 00 00       	call   8012d0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800236:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800239:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80023c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80023f:	89 ec                	mov    %ebp,%esp
  800241:	5d                   	pop    %ebp
  800242:	c3                   	ret    

00800243 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	83 ec 38             	sub    $0x38,%esp
  800249:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80024c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80024f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800252:	b8 05 00 00 00       	mov    $0x5,%eax
  800257:	8b 75 18             	mov    0x18(%ebp),%esi
  80025a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80025d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800260:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800263:	8b 55 08             	mov    0x8(%ebp),%edx
  800266:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800268:	85 c0                	test   %eax,%eax
  80026a:	7e 28                	jle    800294 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80026c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800270:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800277:	00 
  800278:	c7 44 24 08 6a 22 80 	movl   $0x80226a,0x8(%esp)
  80027f:	00 
  800280:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800287:	00 
  800288:	c7 04 24 87 22 80 00 	movl   $0x802287,(%esp)
  80028f:	e8 3c 10 00 00       	call   8012d0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800294:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800297:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80029a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80029d:	89 ec                	mov    %ebp,%esp
  80029f:	5d                   	pop    %ebp
  8002a0:	c3                   	ret    

008002a1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 38             	sub    $0x38,%esp
  8002a7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002aa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002ad:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b5:	b8 06 00 00 00       	mov    $0x6,%eax
  8002ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c0:	89 df                	mov    %ebx,%edi
  8002c2:	89 de                	mov    %ebx,%esi
  8002c4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002c6:	85 c0                	test   %eax,%eax
  8002c8:	7e 28                	jle    8002f2 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002ce:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8002d5:	00 
  8002d6:	c7 44 24 08 6a 22 80 	movl   $0x80226a,0x8(%esp)
  8002dd:	00 
  8002de:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002e5:	00 
  8002e6:	c7 04 24 87 22 80 00 	movl   $0x802287,(%esp)
  8002ed:	e8 de 0f 00 00       	call   8012d0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8002f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002f5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002fb:	89 ec                	mov    %ebp,%esp
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    

008002ff <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	83 ec 38             	sub    $0x38,%esp
  800305:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800308:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80030b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80030e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800313:	b8 08 00 00 00       	mov    $0x8,%eax
  800318:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80031b:	8b 55 08             	mov    0x8(%ebp),%edx
  80031e:	89 df                	mov    %ebx,%edi
  800320:	89 de                	mov    %ebx,%esi
  800322:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800324:	85 c0                	test   %eax,%eax
  800326:	7e 28                	jle    800350 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800328:	89 44 24 10          	mov    %eax,0x10(%esp)
  80032c:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800333:	00 
  800334:	c7 44 24 08 6a 22 80 	movl   $0x80226a,0x8(%esp)
  80033b:	00 
  80033c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800343:	00 
  800344:	c7 04 24 87 22 80 00 	movl   $0x802287,(%esp)
  80034b:	e8 80 0f 00 00       	call   8012d0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800350:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800353:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800356:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800359:	89 ec                	mov    %ebp,%esp
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    

0080035d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 38             	sub    $0x38,%esp
  800363:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800366:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800369:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80036c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800371:	b8 09 00 00 00       	mov    $0x9,%eax
  800376:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800379:	8b 55 08             	mov    0x8(%ebp),%edx
  80037c:	89 df                	mov    %ebx,%edi
  80037e:	89 de                	mov    %ebx,%esi
  800380:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800382:	85 c0                	test   %eax,%eax
  800384:	7e 28                	jle    8003ae <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800386:	89 44 24 10          	mov    %eax,0x10(%esp)
  80038a:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800391:	00 
  800392:	c7 44 24 08 6a 22 80 	movl   $0x80226a,0x8(%esp)
  800399:	00 
  80039a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003a1:	00 
  8003a2:	c7 04 24 87 22 80 00 	movl   $0x802287,(%esp)
  8003a9:	e8 22 0f 00 00       	call   8012d0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8003ae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003b1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003b4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b7:	89 ec                	mov    %ebp,%esp
  8003b9:	5d                   	pop    %ebp
  8003ba:	c3                   	ret    

008003bb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	83 ec 38             	sub    $0x38,%esp
  8003c1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003c4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003c7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8003d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8003da:	89 df                	mov    %ebx,%edi
  8003dc:	89 de                	mov    %ebx,%esi
  8003de:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003e0:	85 c0                	test   %eax,%eax
  8003e2:	7e 28                	jle    80040c <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003e4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003e8:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8003ef:	00 
  8003f0:	c7 44 24 08 6a 22 80 	movl   $0x80226a,0x8(%esp)
  8003f7:	00 
  8003f8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003ff:	00 
  800400:	c7 04 24 87 22 80 00 	movl   $0x802287,(%esp)
  800407:	e8 c4 0e 00 00       	call   8012d0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80040c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80040f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800412:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800415:	89 ec                	mov    %ebp,%esp
  800417:	5d                   	pop    %ebp
  800418:	c3                   	ret    

00800419 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 0c             	sub    $0xc,%esp
  80041f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800422:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800425:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800428:	be 00 00 00 00       	mov    $0x0,%esi
  80042d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800432:	8b 7d 14             	mov    0x14(%ebp),%edi
  800435:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800438:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80043b:	8b 55 08             	mov    0x8(%ebp),%edx
  80043e:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800440:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800443:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800446:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800449:	89 ec                	mov    %ebp,%esp
  80044b:	5d                   	pop    %ebp
  80044c:	c3                   	ret    

0080044d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	83 ec 38             	sub    $0x38,%esp
  800453:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800456:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800459:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80045c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800461:	b8 0d 00 00 00       	mov    $0xd,%eax
  800466:	8b 55 08             	mov    0x8(%ebp),%edx
  800469:	89 cb                	mov    %ecx,%ebx
  80046b:	89 cf                	mov    %ecx,%edi
  80046d:	89 ce                	mov    %ecx,%esi
  80046f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800471:	85 c0                	test   %eax,%eax
  800473:	7e 28                	jle    80049d <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800475:	89 44 24 10          	mov    %eax,0x10(%esp)
  800479:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800480:	00 
  800481:	c7 44 24 08 6a 22 80 	movl   $0x80226a,0x8(%esp)
  800488:	00 
  800489:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800490:	00 
  800491:	c7 04 24 87 22 80 00 	movl   $0x802287,(%esp)
  800498:	e8 33 0e 00 00       	call   8012d0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80049d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004a0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004a3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004a6:	89 ec                	mov    %ebp,%esp
  8004a8:	5d                   	pop    %ebp
  8004a9:	c3                   	ret    
	...

008004ac <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8004ac:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8004ad:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8004b2:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8004b4:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  8004b7:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  8004bb:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  8004be:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  8004c2:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  8004c6:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8004c8:	83 c4 08             	add    $0x8,%esp
	popal
  8004cb:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8004cc:	83 c4 04             	add    $0x4,%esp
	popfl
  8004cf:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8004d0:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8004d1:	c3                   	ret    
	...

008004e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8004eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8004ee:	5d                   	pop    %ebp
  8004ef:	c3                   	ret    

008004f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	89 04 24             	mov    %eax,(%esp)
  8004fc:	e8 df ff ff ff       	call   8004e0 <fd2num>
  800501:	05 20 00 0d 00       	add    $0xd0020,%eax
  800506:	c1 e0 0c             	shl    $0xc,%eax
}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	53                   	push   %ebx
  80050f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800512:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800517:	a8 01                	test   $0x1,%al
  800519:	74 34                	je     80054f <fd_alloc+0x44>
  80051b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800520:	a8 01                	test   $0x1,%al
  800522:	74 32                	je     800556 <fd_alloc+0x4b>
  800524:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800529:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80052b:	89 c2                	mov    %eax,%edx
  80052d:	c1 ea 16             	shr    $0x16,%edx
  800530:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800537:	f6 c2 01             	test   $0x1,%dl
  80053a:	74 1f                	je     80055b <fd_alloc+0x50>
  80053c:	89 c2                	mov    %eax,%edx
  80053e:	c1 ea 0c             	shr    $0xc,%edx
  800541:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800548:	f6 c2 01             	test   $0x1,%dl
  80054b:	75 17                	jne    800564 <fd_alloc+0x59>
  80054d:	eb 0c                	jmp    80055b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80054f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800554:	eb 05                	jmp    80055b <fd_alloc+0x50>
  800556:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80055b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80055d:	b8 00 00 00 00       	mov    $0x0,%eax
  800562:	eb 17                	jmp    80057b <fd_alloc+0x70>
  800564:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800569:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80056e:	75 b9                	jne    800529 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800570:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  800576:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80057b:	5b                   	pop    %ebx
  80057c:	5d                   	pop    %ebp
  80057d:	c3                   	ret    

0080057e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800584:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800589:	83 fa 1f             	cmp    $0x1f,%edx
  80058c:	77 3f                	ja     8005cd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80058e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  800594:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800597:	89 d0                	mov    %edx,%eax
  800599:	c1 e8 16             	shr    $0x16,%eax
  80059c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8005a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8005a8:	f6 c1 01             	test   $0x1,%cl
  8005ab:	74 20                	je     8005cd <fd_lookup+0x4f>
  8005ad:	89 d0                	mov    %edx,%eax
  8005af:	c1 e8 0c             	shr    $0xc,%eax
  8005b2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8005b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8005be:	f6 c1 01             	test   $0x1,%cl
  8005c1:	74 0a                	je     8005cd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8005c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c6:	89 10                	mov    %edx,(%eax)
	return 0;
  8005c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8005cd:	5d                   	pop    %ebp
  8005ce:	c3                   	ret    

008005cf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	53                   	push   %ebx
  8005d3:	83 ec 14             	sub    $0x14,%esp
  8005d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8005dc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8005e1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8005e7:	75 17                	jne    800600 <dev_lookup+0x31>
  8005e9:	eb 07                	jmp    8005f2 <dev_lookup+0x23>
  8005eb:	39 0a                	cmp    %ecx,(%edx)
  8005ed:	75 11                	jne    800600 <dev_lookup+0x31>
  8005ef:	90                   	nop
  8005f0:	eb 05                	jmp    8005f7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005f2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8005f7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8005f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fe:	eb 35                	jmp    800635 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800600:	83 c0 01             	add    $0x1,%eax
  800603:	8b 14 85 14 23 80 00 	mov    0x802314(,%eax,4),%edx
  80060a:	85 d2                	test   %edx,%edx
  80060c:	75 dd                	jne    8005eb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80060e:	a1 04 40 80 00       	mov    0x804004,%eax
  800613:	8b 40 48             	mov    0x48(%eax),%eax
  800616:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80061a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061e:	c7 04 24 98 22 80 00 	movl   $0x802298,(%esp)
  800625:	e8 a1 0d 00 00       	call   8013cb <cprintf>
	*dev = 0;
  80062a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  800630:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800635:	83 c4 14             	add    $0x14,%esp
  800638:	5b                   	pop    %ebx
  800639:	5d                   	pop    %ebp
  80063a:	c3                   	ret    

0080063b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	83 ec 38             	sub    $0x38,%esp
  800641:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800644:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800647:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80064a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80064d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800651:	89 3c 24             	mov    %edi,(%esp)
  800654:	e8 87 fe ff ff       	call   8004e0 <fd2num>
  800659:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80065c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800660:	89 04 24             	mov    %eax,(%esp)
  800663:	e8 16 ff ff ff       	call   80057e <fd_lookup>
  800668:	89 c3                	mov    %eax,%ebx
  80066a:	85 c0                	test   %eax,%eax
  80066c:	78 05                	js     800673 <fd_close+0x38>
	    || fd != fd2)
  80066e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  800671:	74 0e                	je     800681 <fd_close+0x46>
		return (must_exist ? r : 0);
  800673:	89 f0                	mov    %esi,%eax
  800675:	84 c0                	test   %al,%al
  800677:	b8 00 00 00 00       	mov    $0x0,%eax
  80067c:	0f 44 d8             	cmove  %eax,%ebx
  80067f:	eb 3d                	jmp    8006be <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800681:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800684:	89 44 24 04          	mov    %eax,0x4(%esp)
  800688:	8b 07                	mov    (%edi),%eax
  80068a:	89 04 24             	mov    %eax,(%esp)
  80068d:	e8 3d ff ff ff       	call   8005cf <dev_lookup>
  800692:	89 c3                	mov    %eax,%ebx
  800694:	85 c0                	test   %eax,%eax
  800696:	78 16                	js     8006ae <fd_close+0x73>
		if (dev->dev_close)
  800698:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80069e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8006a3:	85 c0                	test   %eax,%eax
  8006a5:	74 07                	je     8006ae <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8006a7:	89 3c 24             	mov    %edi,(%esp)
  8006aa:	ff d0                	call   *%eax
  8006ac:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8006ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006b9:	e8 e3 fb ff ff       	call   8002a1 <sys_page_unmap>
	return r;
}
  8006be:	89 d8                	mov    %ebx,%eax
  8006c0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8006c3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8006c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8006c9:	89 ec                	mov    %ebp,%esp
  8006cb:	5d                   	pop    %ebp
  8006cc:	c3                   	ret    

008006cd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8006cd:	55                   	push   %ebp
  8006ce:	89 e5                	mov    %esp,%ebp
  8006d0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8006d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	89 04 24             	mov    %eax,(%esp)
  8006e0:	e8 99 fe ff ff       	call   80057e <fd_lookup>
  8006e5:	85 c0                	test   %eax,%eax
  8006e7:	78 13                	js     8006fc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8006e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8006f0:	00 
  8006f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f4:	89 04 24             	mov    %eax,(%esp)
  8006f7:	e8 3f ff ff ff       	call   80063b <fd_close>
}
  8006fc:	c9                   	leave  
  8006fd:	c3                   	ret    

008006fe <close_all>:

void
close_all(void)
{
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	53                   	push   %ebx
  800702:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800705:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80070a:	89 1c 24             	mov    %ebx,(%esp)
  80070d:	e8 bb ff ff ff       	call   8006cd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800712:	83 c3 01             	add    $0x1,%ebx
  800715:	83 fb 20             	cmp    $0x20,%ebx
  800718:	75 f0                	jne    80070a <close_all+0xc>
		close(i);
}
  80071a:	83 c4 14             	add    $0x14,%esp
  80071d:	5b                   	pop    %ebx
  80071e:	5d                   	pop    %ebp
  80071f:	c3                   	ret    

00800720 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800720:	55                   	push   %ebp
  800721:	89 e5                	mov    %esp,%ebp
  800723:	83 ec 58             	sub    $0x58,%esp
  800726:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800729:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80072c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80072f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800732:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800735:	89 44 24 04          	mov    %eax,0x4(%esp)
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 04 24             	mov    %eax,(%esp)
  80073f:	e8 3a fe ff ff       	call   80057e <fd_lookup>
  800744:	89 c3                	mov    %eax,%ebx
  800746:	85 c0                	test   %eax,%eax
  800748:	0f 88 e1 00 00 00    	js     80082f <dup+0x10f>
		return r;
	close(newfdnum);
  80074e:	89 3c 24             	mov    %edi,(%esp)
  800751:	e8 77 ff ff ff       	call   8006cd <close>

	newfd = INDEX2FD(newfdnum);
  800756:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80075c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80075f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800762:	89 04 24             	mov    %eax,(%esp)
  800765:	e8 86 fd ff ff       	call   8004f0 <fd2data>
  80076a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80076c:	89 34 24             	mov    %esi,(%esp)
  80076f:	e8 7c fd ff ff       	call   8004f0 <fd2data>
  800774:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800777:	89 d8                	mov    %ebx,%eax
  800779:	c1 e8 16             	shr    $0x16,%eax
  80077c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800783:	a8 01                	test   $0x1,%al
  800785:	74 46                	je     8007cd <dup+0xad>
  800787:	89 d8                	mov    %ebx,%eax
  800789:	c1 e8 0c             	shr    $0xc,%eax
  80078c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800793:	f6 c2 01             	test   $0x1,%dl
  800796:	74 35                	je     8007cd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800798:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80079f:	25 07 0e 00 00       	and    $0xe07,%eax
  8007a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007b6:	00 
  8007b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007c2:	e8 7c fa ff ff       	call   800243 <sys_page_map>
  8007c7:	89 c3                	mov    %eax,%ebx
  8007c9:	85 c0                	test   %eax,%eax
  8007cb:	78 3b                	js     800808 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8007cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007d0:	89 c2                	mov    %eax,%edx
  8007d2:	c1 ea 0c             	shr    $0xc,%edx
  8007d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007dc:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8007e2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007e6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007f1:	00 
  8007f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007fd:	e8 41 fa ff ff       	call   800243 <sys_page_map>
  800802:	89 c3                	mov    %eax,%ebx
  800804:	85 c0                	test   %eax,%eax
  800806:	79 25                	jns    80082d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800808:	89 74 24 04          	mov    %esi,0x4(%esp)
  80080c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800813:	e8 89 fa ff ff       	call   8002a1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800818:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80081b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800826:	e8 76 fa ff ff       	call   8002a1 <sys_page_unmap>
	return r;
  80082b:	eb 02                	jmp    80082f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80082d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80082f:	89 d8                	mov    %ebx,%eax
  800831:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800834:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800837:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80083a:	89 ec                	mov    %ebp,%esp
  80083c:	5d                   	pop    %ebp
  80083d:	c3                   	ret    

0080083e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	53                   	push   %ebx
  800842:	83 ec 24             	sub    $0x24,%esp
  800845:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800848:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80084b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084f:	89 1c 24             	mov    %ebx,(%esp)
  800852:	e8 27 fd ff ff       	call   80057e <fd_lookup>
  800857:	85 c0                	test   %eax,%eax
  800859:	78 6d                	js     8008c8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80085b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80085e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800865:	8b 00                	mov    (%eax),%eax
  800867:	89 04 24             	mov    %eax,(%esp)
  80086a:	e8 60 fd ff ff       	call   8005cf <dev_lookup>
  80086f:	85 c0                	test   %eax,%eax
  800871:	78 55                	js     8008c8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800876:	8b 50 08             	mov    0x8(%eax),%edx
  800879:	83 e2 03             	and    $0x3,%edx
  80087c:	83 fa 01             	cmp    $0x1,%edx
  80087f:	75 23                	jne    8008a4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800881:	a1 04 40 80 00       	mov    0x804004,%eax
  800886:	8b 40 48             	mov    0x48(%eax),%eax
  800889:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80088d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800891:	c7 04 24 d9 22 80 00 	movl   $0x8022d9,(%esp)
  800898:	e8 2e 0b 00 00       	call   8013cb <cprintf>
		return -E_INVAL;
  80089d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a2:	eb 24                	jmp    8008c8 <read+0x8a>
	}
	if (!dev->dev_read)
  8008a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a7:	8b 52 08             	mov    0x8(%edx),%edx
  8008aa:	85 d2                	test   %edx,%edx
  8008ac:	74 15                	je     8008c3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8008ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008b8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008bc:	89 04 24             	mov    %eax,(%esp)
  8008bf:	ff d2                	call   *%edx
  8008c1:	eb 05                	jmp    8008c8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8008c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8008c8:	83 c4 24             	add    $0x24,%esp
  8008cb:	5b                   	pop    %ebx
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	57                   	push   %edi
  8008d2:	56                   	push   %esi
  8008d3:	53                   	push   %ebx
  8008d4:	83 ec 1c             	sub    $0x1c,%esp
  8008d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008da:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e2:	85 f6                	test   %esi,%esi
  8008e4:	74 30                	je     800916 <readn+0x48>
  8008e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8008eb:	89 f2                	mov    %esi,%edx
  8008ed:	29 c2                	sub    %eax,%edx
  8008ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  8008f3:	03 45 0c             	add    0xc(%ebp),%eax
  8008f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008fa:	89 3c 24             	mov    %edi,(%esp)
  8008fd:	e8 3c ff ff ff       	call   80083e <read>
		if (m < 0)
  800902:	85 c0                	test   %eax,%eax
  800904:	78 10                	js     800916 <readn+0x48>
			return m;
		if (m == 0)
  800906:	85 c0                	test   %eax,%eax
  800908:	74 0a                	je     800914 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80090a:	01 c3                	add    %eax,%ebx
  80090c:	89 d8                	mov    %ebx,%eax
  80090e:	39 f3                	cmp    %esi,%ebx
  800910:	72 d9                	jb     8008eb <readn+0x1d>
  800912:	eb 02                	jmp    800916 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  800914:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  800916:	83 c4 1c             	add    $0x1c,%esp
  800919:	5b                   	pop    %ebx
  80091a:	5e                   	pop    %esi
  80091b:	5f                   	pop    %edi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	53                   	push   %ebx
  800922:	83 ec 24             	sub    $0x24,%esp
  800925:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800928:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80092b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80092f:	89 1c 24             	mov    %ebx,(%esp)
  800932:	e8 47 fc ff ff       	call   80057e <fd_lookup>
  800937:	85 c0                	test   %eax,%eax
  800939:	78 68                	js     8009a3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80093b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80093e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	89 04 24             	mov    %eax,(%esp)
  80094a:	e8 80 fc ff ff       	call   8005cf <dev_lookup>
  80094f:	85 c0                	test   %eax,%eax
  800951:	78 50                	js     8009a3 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800956:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80095a:	75 23                	jne    80097f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80095c:	a1 04 40 80 00       	mov    0x804004,%eax
  800961:	8b 40 48             	mov    0x48(%eax),%eax
  800964:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800968:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096c:	c7 04 24 f5 22 80 00 	movl   $0x8022f5,(%esp)
  800973:	e8 53 0a 00 00       	call   8013cb <cprintf>
		return -E_INVAL;
  800978:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80097d:	eb 24                	jmp    8009a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80097f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800982:	8b 52 0c             	mov    0xc(%edx),%edx
  800985:	85 d2                	test   %edx,%edx
  800987:	74 15                	je     80099e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800989:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80098c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800990:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800993:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800997:	89 04 24             	mov    %eax,(%esp)
  80099a:	ff d2                	call   *%edx
  80099c:	eb 05                	jmp    8009a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80099e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8009a3:	83 c4 24             	add    $0x24,%esp
  8009a6:	5b                   	pop    %ebx
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009af:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8009b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	89 04 24             	mov    %eax,(%esp)
  8009bc:	e8 bd fb ff ff       	call   80057e <fd_lookup>
  8009c1:	85 c0                	test   %eax,%eax
  8009c3:	78 0e                	js     8009d3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8009c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8009ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    

008009d5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	53                   	push   %ebx
  8009d9:	83 ec 24             	sub    $0x24,%esp
  8009dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e6:	89 1c 24             	mov    %ebx,(%esp)
  8009e9:	e8 90 fb ff ff       	call   80057e <fd_lookup>
  8009ee:	85 c0                	test   %eax,%eax
  8009f0:	78 61                	js     800a53 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fc:	8b 00                	mov    (%eax),%eax
  8009fe:	89 04 24             	mov    %eax,(%esp)
  800a01:	e8 c9 fb ff ff       	call   8005cf <dev_lookup>
  800a06:	85 c0                	test   %eax,%eax
  800a08:	78 49                	js     800a53 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800a11:	75 23                	jne    800a36 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800a13:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800a18:	8b 40 48             	mov    0x48(%eax),%eax
  800a1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a23:	c7 04 24 b8 22 80 00 	movl   $0x8022b8,(%esp)
  800a2a:	e8 9c 09 00 00       	call   8013cb <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800a2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a34:	eb 1d                	jmp    800a53 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  800a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a39:	8b 52 18             	mov    0x18(%edx),%edx
  800a3c:	85 d2                	test   %edx,%edx
  800a3e:	74 0e                	je     800a4e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800a40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a47:	89 04 24             	mov    %eax,(%esp)
  800a4a:	ff d2                	call   *%edx
  800a4c:	eb 05                	jmp    800a53 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800a4e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800a53:	83 c4 24             	add    $0x24,%esp
  800a56:	5b                   	pop    %ebx
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	53                   	push   %ebx
  800a5d:	83 ec 24             	sub    $0x24,%esp
  800a60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a63:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a66:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	89 04 24             	mov    %eax,(%esp)
  800a70:	e8 09 fb ff ff       	call   80057e <fd_lookup>
  800a75:	85 c0                	test   %eax,%eax
  800a77:	78 52                	js     800acb <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	89 04 24             	mov    %eax,(%esp)
  800a88:	e8 42 fb ff ff       	call   8005cf <dev_lookup>
  800a8d:	85 c0                	test   %eax,%eax
  800a8f:	78 3a                	js     800acb <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  800a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a94:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a98:	74 2c                	je     800ac6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a9a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a9d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800aa4:	00 00 00 
	stat->st_isdir = 0;
  800aa7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800aae:	00 00 00 
	stat->st_dev = dev;
  800ab1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800ab7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800abb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800abe:	89 14 24             	mov    %edx,(%esp)
  800ac1:	ff 50 14             	call   *0x14(%eax)
  800ac4:	eb 05                	jmp    800acb <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800ac6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800acb:	83 c4 24             	add    $0x24,%esp
  800ace:	5b                   	pop    %ebx
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 18             	sub    $0x18,%esp
  800ad7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800ada:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800add:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800ae4:	00 
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	89 04 24             	mov    %eax,(%esp)
  800aeb:	e8 bc 01 00 00       	call   800cac <open>
  800af0:	89 c3                	mov    %eax,%ebx
  800af2:	85 c0                	test   %eax,%eax
  800af4:	78 1b                	js     800b11 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800afd:	89 1c 24             	mov    %ebx,(%esp)
  800b00:	e8 54 ff ff ff       	call   800a59 <fstat>
  800b05:	89 c6                	mov    %eax,%esi
	close(fd);
  800b07:	89 1c 24             	mov    %ebx,(%esp)
  800b0a:	e8 be fb ff ff       	call   8006cd <close>
	return r;
  800b0f:	89 f3                	mov    %esi,%ebx
}
  800b11:	89 d8                	mov    %ebx,%eax
  800b13:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800b16:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800b19:	89 ec                	mov    %ebp,%esp
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    
  800b1d:	00 00                	add    %al,(%eax)
	...

00800b20 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	83 ec 18             	sub    $0x18,%esp
  800b26:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800b29:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800b2c:	89 c3                	mov    %eax,%ebx
  800b2e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  800b30:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800b37:	75 11                	jne    800b4a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800b39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800b40:	e8 d1 13 00 00       	call   801f16 <ipc_find_env>
  800b45:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800b4a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800b51:	00 
  800b52:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800b59:	00 
  800b5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b5e:	a1 00 40 80 00       	mov    0x804000,%eax
  800b63:	89 04 24             	mov    %eax,(%esp)
  800b66:	e8 27 13 00 00       	call   801e92 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800b6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b72:	00 
  800b73:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b7e:	e8 bd 12 00 00       	call   801e40 <ipc_recv>
}
  800b83:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800b86:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800b89:	89 ec                	mov    %ebp,%esp
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	53                   	push   %ebx
  800b91:	83 ec 14             	sub    $0x14,%esp
  800b94:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8b 40 0c             	mov    0xc(%eax),%eax
  800b9d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba7:	b8 05 00 00 00       	mov    $0x5,%eax
  800bac:	e8 6f ff ff ff       	call   800b20 <fsipc>
  800bb1:	85 c0                	test   %eax,%eax
  800bb3:	78 2b                	js     800be0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800bb5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800bbc:	00 
  800bbd:	89 1c 24             	mov    %ebx,(%esp)
  800bc0:	e8 26 0e 00 00       	call   8019eb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800bc5:	a1 80 50 80 00       	mov    0x805080,%eax
  800bca:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800bd0:	a1 84 50 80 00       	mov    0x805084,%eax
  800bd5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be0:	83 c4 14             	add    $0x14,%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8b 40 0c             	mov    0xc(%eax),%eax
  800bf2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800bf7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfc:	b8 06 00 00 00       	mov    $0x6,%eax
  800c01:	e8 1a ff ff ff       	call   800b20 <fsipc>
}
  800c06:	c9                   	leave  
  800c07:	c3                   	ret    

00800c08 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	83 ec 10             	sub    $0x10,%esp
  800c10:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8b 40 0c             	mov    0xc(%eax),%eax
  800c19:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800c1e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800c24:	ba 00 00 00 00       	mov    $0x0,%edx
  800c29:	b8 03 00 00 00       	mov    $0x3,%eax
  800c2e:	e8 ed fe ff ff       	call   800b20 <fsipc>
  800c33:	89 c3                	mov    %eax,%ebx
  800c35:	85 c0                	test   %eax,%eax
  800c37:	78 6a                	js     800ca3 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800c39:	39 c6                	cmp    %eax,%esi
  800c3b:	73 24                	jae    800c61 <devfile_read+0x59>
  800c3d:	c7 44 24 0c 24 23 80 	movl   $0x802324,0xc(%esp)
  800c44:	00 
  800c45:	c7 44 24 08 2b 23 80 	movl   $0x80232b,0x8(%esp)
  800c4c:	00 
  800c4d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800c54:	00 
  800c55:	c7 04 24 40 23 80 00 	movl   $0x802340,(%esp)
  800c5c:	e8 6f 06 00 00       	call   8012d0 <_panic>
	assert(r <= PGSIZE);
  800c61:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c66:	7e 24                	jle    800c8c <devfile_read+0x84>
  800c68:	c7 44 24 0c 4b 23 80 	movl   $0x80234b,0xc(%esp)
  800c6f:	00 
  800c70:	c7 44 24 08 2b 23 80 	movl   $0x80232b,0x8(%esp)
  800c77:	00 
  800c78:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800c7f:	00 
  800c80:	c7 04 24 40 23 80 00 	movl   $0x802340,(%esp)
  800c87:	e8 44 06 00 00       	call   8012d0 <_panic>
	memmove(buf, &fsipcbuf, r);
  800c8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c90:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c97:	00 
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	89 04 24             	mov    %eax,(%esp)
  800c9e:	e8 39 0f 00 00       	call   801bdc <memmove>
	return r;
}
  800ca3:	89 d8                	mov    %ebx,%eax
  800ca5:	83 c4 10             	add    $0x10,%esp
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 20             	sub    $0x20,%esp
  800cb4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800cb7:	89 34 24             	mov    %esi,(%esp)
  800cba:	e8 e1 0c 00 00       	call   8019a0 <strlen>
		return -E_BAD_PATH;
  800cbf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800cc4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800cc9:	7f 5e                	jg     800d29 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800ccb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cce:	89 04 24             	mov    %eax,(%esp)
  800cd1:	e8 35 f8 ff ff       	call   80050b <fd_alloc>
  800cd6:	89 c3                	mov    %eax,%ebx
  800cd8:	85 c0                	test   %eax,%eax
  800cda:	78 4d                	js     800d29 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800cdc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ce0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800ce7:	e8 ff 0c 00 00       	call   8019eb <strcpy>
	fsipcbuf.open.req_omode = mode;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cf7:	b8 01 00 00 00       	mov    $0x1,%eax
  800cfc:	e8 1f fe ff ff       	call   800b20 <fsipc>
  800d01:	89 c3                	mov    %eax,%ebx
  800d03:	85 c0                	test   %eax,%eax
  800d05:	79 15                	jns    800d1c <open+0x70>
		fd_close(fd, 0);
  800d07:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800d0e:	00 
  800d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d12:	89 04 24             	mov    %eax,(%esp)
  800d15:	e8 21 f9 ff ff       	call   80063b <fd_close>
		return r;
  800d1a:	eb 0d                	jmp    800d29 <open+0x7d>
	}

	return fd2num(fd);
  800d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d1f:	89 04 24             	mov    %eax,(%esp)
  800d22:	e8 b9 f7 ff ff       	call   8004e0 <fd2num>
  800d27:	89 c3                	mov    %eax,%ebx
}
  800d29:	89 d8                	mov    %ebx,%eax
  800d2b:	83 c4 20             	add    $0x20,%esp
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    
	...

00800d40 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 18             	sub    $0x18,%esp
  800d46:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800d49:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	89 04 24             	mov    %eax,(%esp)
  800d55:	e8 96 f7 ff ff       	call   8004f0 <fd2data>
  800d5a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  800d5c:	c7 44 24 04 57 23 80 	movl   $0x802357,0x4(%esp)
  800d63:	00 
  800d64:	89 34 24             	mov    %esi,(%esp)
  800d67:	e8 7f 0c 00 00       	call   8019eb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800d6c:	8b 43 04             	mov    0x4(%ebx),%eax
  800d6f:	2b 03                	sub    (%ebx),%eax
  800d71:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  800d77:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  800d7e:	00 00 00 
	stat->st_dev = &devpipe;
  800d81:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  800d88:	30 80 00 
	return 0;
}
  800d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d90:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800d93:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800d96:	89 ec                	mov    %ebp,%esp
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	53                   	push   %ebx
  800d9e:	83 ec 14             	sub    $0x14,%esp
  800da1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800da4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800da8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800daf:	e8 ed f4 ff ff       	call   8002a1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800db4:	89 1c 24             	mov    %ebx,(%esp)
  800db7:	e8 34 f7 ff ff       	call   8004f0 <fd2data>
  800dbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800dc7:	e8 d5 f4 ff ff       	call   8002a1 <sys_page_unmap>
}
  800dcc:	83 c4 14             	add    $0x14,%esp
  800dcf:	5b                   	pop    %ebx
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    

00800dd2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	57                   	push   %edi
  800dd6:	56                   	push   %esi
  800dd7:	53                   	push   %ebx
  800dd8:	83 ec 2c             	sub    $0x2c,%esp
  800ddb:	89 c7                	mov    %eax,%edi
  800ddd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800de0:	a1 04 40 80 00       	mov    0x804004,%eax
  800de5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800de8:	89 3c 24             	mov    %edi,(%esp)
  800deb:	e8 70 11 00 00       	call   801f60 <pageref>
  800df0:	89 c6                	mov    %eax,%esi
  800df2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800df5:	89 04 24             	mov    %eax,(%esp)
  800df8:	e8 63 11 00 00       	call   801f60 <pageref>
  800dfd:	39 c6                	cmp    %eax,%esi
  800dff:	0f 94 c0             	sete   %al
  800e02:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  800e05:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800e0b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800e0e:	39 cb                	cmp    %ecx,%ebx
  800e10:	75 08                	jne    800e1a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  800e12:	83 c4 2c             	add    $0x2c,%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  800e1a:	83 f8 01             	cmp    $0x1,%eax
  800e1d:	75 c1                	jne    800de0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800e1f:	8b 52 58             	mov    0x58(%edx),%edx
  800e22:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e26:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e2a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800e2e:	c7 04 24 5e 23 80 00 	movl   $0x80235e,(%esp)
  800e35:	e8 91 05 00 00       	call   8013cb <cprintf>
  800e3a:	eb a4                	jmp    800de0 <_pipeisclosed+0xe>

00800e3c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
  800e42:	83 ec 2c             	sub    $0x2c,%esp
  800e45:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800e48:	89 34 24             	mov    %esi,(%esp)
  800e4b:	e8 a0 f6 ff ff       	call   8004f0 <fd2data>
  800e50:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e52:	bf 00 00 00 00       	mov    $0x0,%edi
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	75 50                	jne    800ead <devpipe_write+0x71>
  800e5d:	eb 5c                	jmp    800ebb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800e5f:	89 da                	mov    %ebx,%edx
  800e61:	89 f0                	mov    %esi,%eax
  800e63:	e8 6a ff ff ff       	call   800dd2 <_pipeisclosed>
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	75 53                	jne    800ebf <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800e6c:	e8 43 f3 ff ff       	call   8001b4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e71:	8b 43 04             	mov    0x4(%ebx),%eax
  800e74:	8b 13                	mov    (%ebx),%edx
  800e76:	83 c2 20             	add    $0x20,%edx
  800e79:	39 d0                	cmp    %edx,%eax
  800e7b:	73 e2                	jae    800e5f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e80:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  800e84:	88 55 e7             	mov    %dl,-0x19(%ebp)
  800e87:	89 c2                	mov    %eax,%edx
  800e89:	c1 fa 1f             	sar    $0x1f,%edx
  800e8c:	c1 ea 1b             	shr    $0x1b,%edx
  800e8f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800e92:	83 e1 1f             	and    $0x1f,%ecx
  800e95:	29 d1                	sub    %edx,%ecx
  800e97:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800e9b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800e9f:	83 c0 01             	add    $0x1,%eax
  800ea2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ea5:	83 c7 01             	add    $0x1,%edi
  800ea8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800eab:	74 0e                	je     800ebb <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800ead:	8b 43 04             	mov    0x4(%ebx),%eax
  800eb0:	8b 13                	mov    (%ebx),%edx
  800eb2:	83 c2 20             	add    $0x20,%edx
  800eb5:	39 d0                	cmp    %edx,%eax
  800eb7:	73 a6                	jae    800e5f <devpipe_write+0x23>
  800eb9:	eb c2                	jmp    800e7d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800ebb:	89 f8                	mov    %edi,%eax
  800ebd:	eb 05                	jmp    800ec4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800ec4:	83 c4 2c             	add    $0x2c,%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 28             	sub    $0x28,%esp
  800ed2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ed8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800edb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800ede:	89 3c 24             	mov    %edi,(%esp)
  800ee1:	e8 0a f6 ff ff       	call   8004f0 <fd2data>
  800ee6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ee8:	be 00 00 00 00       	mov    $0x0,%esi
  800eed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef1:	75 47                	jne    800f3a <devpipe_read+0x6e>
  800ef3:	eb 52                	jmp    800f47 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800ef5:	89 f0                	mov    %esi,%eax
  800ef7:	eb 5e                	jmp    800f57 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800ef9:	89 da                	mov    %ebx,%edx
  800efb:	89 f8                	mov    %edi,%eax
  800efd:	8d 76 00             	lea    0x0(%esi),%esi
  800f00:	e8 cd fe ff ff       	call   800dd2 <_pipeisclosed>
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 49                	jne    800f52 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800f09:	e8 a6 f2 ff ff       	call   8001b4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800f0e:	8b 03                	mov    (%ebx),%eax
  800f10:	3b 43 04             	cmp    0x4(%ebx),%eax
  800f13:	74 e4                	je     800ef9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800f15:	89 c2                	mov    %eax,%edx
  800f17:	c1 fa 1f             	sar    $0x1f,%edx
  800f1a:	c1 ea 1b             	shr    $0x1b,%edx
  800f1d:	01 d0                	add    %edx,%eax
  800f1f:	83 e0 1f             	and    $0x1f,%eax
  800f22:	29 d0                	sub    %edx,%eax
  800f24:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  800f2f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800f32:	83 c6 01             	add    $0x1,%esi
  800f35:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f38:	74 0d                	je     800f47 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  800f3a:	8b 03                	mov    (%ebx),%eax
  800f3c:	3b 43 04             	cmp    0x4(%ebx),%eax
  800f3f:	75 d4                	jne    800f15 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800f41:	85 f6                	test   %esi,%esi
  800f43:	75 b0                	jne    800ef5 <devpipe_read+0x29>
  800f45:	eb b2                	jmp    800ef9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800f47:	89 f0                	mov    %esi,%eax
  800f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f50:	eb 05                	jmp    800f57 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800f57:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f5a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f5d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f60:	89 ec                	mov    %ebp,%esp
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 48             	sub    $0x48,%esp
  800f6a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f6d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f70:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800f73:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800f76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f79:	89 04 24             	mov    %eax,(%esp)
  800f7c:	e8 8a f5 ff ff       	call   80050b <fd_alloc>
  800f81:	89 c3                	mov    %eax,%ebx
  800f83:	85 c0                	test   %eax,%eax
  800f85:	0f 88 45 01 00 00    	js     8010d0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f8b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f92:	00 
  800f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f96:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fa1:	e8 3e f2 ff ff       	call   8001e4 <sys_page_alloc>
  800fa6:	89 c3                	mov    %eax,%ebx
  800fa8:	85 c0                	test   %eax,%eax
  800faa:	0f 88 20 01 00 00    	js     8010d0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800fb0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fb3:	89 04 24             	mov    %eax,(%esp)
  800fb6:	e8 50 f5 ff ff       	call   80050b <fd_alloc>
  800fbb:	89 c3                	mov    %eax,%ebx
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	0f 88 f8 00 00 00    	js     8010bd <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800fc5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800fcc:	00 
  800fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fdb:	e8 04 f2 ff ff       	call   8001e4 <sys_page_alloc>
  800fe0:	89 c3                	mov    %eax,%ebx
  800fe2:	85 c0                	test   %eax,%eax
  800fe4:	0f 88 d3 00 00 00    	js     8010bd <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800fea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fed:	89 04 24             	mov    %eax,(%esp)
  800ff0:	e8 fb f4 ff ff       	call   8004f0 <fd2data>
  800ff5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ff7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ffe:	00 
  800fff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801003:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80100a:	e8 d5 f1 ff ff       	call   8001e4 <sys_page_alloc>
  80100f:	89 c3                	mov    %eax,%ebx
  801011:	85 c0                	test   %eax,%eax
  801013:	0f 88 91 00 00 00    	js     8010aa <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801019:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80101c:	89 04 24             	mov    %eax,(%esp)
  80101f:	e8 cc f4 ff ff       	call   8004f0 <fd2data>
  801024:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80102b:	00 
  80102c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801030:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801037:	00 
  801038:	89 74 24 04          	mov    %esi,0x4(%esp)
  80103c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801043:	e8 fb f1 ff ff       	call   800243 <sys_page_map>
  801048:	89 c3                	mov    %eax,%ebx
  80104a:	85 c0                	test   %eax,%eax
  80104c:	78 4c                	js     80109a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80104e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801057:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801059:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80105c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801063:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801069:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80106e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801071:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80107b:	89 04 24             	mov    %eax,(%esp)
  80107e:	e8 5d f4 ff ff       	call   8004e0 <fd2num>
  801083:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801085:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801088:	89 04 24             	mov    %eax,(%esp)
  80108b:	e8 50 f4 ff ff       	call   8004e0 <fd2num>
  801090:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801093:	bb 00 00 00 00       	mov    $0x0,%ebx
  801098:	eb 36                	jmp    8010d0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80109a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80109e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010a5:	e8 f7 f1 ff ff       	call   8002a1 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8010aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010b8:	e8 e4 f1 ff ff       	call   8002a1 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8010bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010cb:	e8 d1 f1 ff ff       	call   8002a1 <sys_page_unmap>
    err:
	return r;
}
  8010d0:	89 d8                	mov    %ebx,%eax
  8010d2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010db:	89 ec                	mov    %ebp,%esp
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    

008010df <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	89 04 24             	mov    %eax,(%esp)
  8010f2:	e8 87 f4 ff ff       	call   80057e <fd_lookup>
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	78 15                	js     801110 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8010fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010fe:	89 04 24             	mov    %eax,(%esp)
  801101:	e8 ea f3 ff ff       	call   8004f0 <fd2data>
	return _pipeisclosed(fd, p);
  801106:	89 c2                	mov    %eax,%edx
  801108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110b:	e8 c2 fc ff ff       	call   800dd2 <_pipeisclosed>
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    
	...

00801120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801123:	b8 00 00 00 00       	mov    $0x0,%eax
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    

0080112a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801130:	c7 44 24 04 76 23 80 	movl   $0x802376,0x4(%esp)
  801137:	00 
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	89 04 24             	mov    %eax,(%esp)
  80113e:	e8 a8 08 00 00       	call   8019eb <strcpy>
	return 0;
}
  801143:	b8 00 00 00 00       	mov    $0x0,%eax
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	57                   	push   %edi
  80114e:	56                   	push   %esi
  80114f:	53                   	push   %ebx
  801150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801156:	be 00 00 00 00       	mov    $0x0,%esi
  80115b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115f:	74 43                	je     8011a4 <devcons_write+0x5a>
  801161:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801166:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80116c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80116f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801171:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801174:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801179:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80117c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801180:	03 45 0c             	add    0xc(%ebp),%eax
  801183:	89 44 24 04          	mov    %eax,0x4(%esp)
  801187:	89 3c 24             	mov    %edi,(%esp)
  80118a:	e8 4d 0a 00 00       	call   801bdc <memmove>
		sys_cputs(buf, m);
  80118f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801193:	89 3c 24             	mov    %edi,(%esp)
  801196:	e8 2d ef ff ff       	call   8000c8 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80119b:	01 de                	add    %ebx,%esi
  80119d:	89 f0                	mov    %esi,%eax
  80119f:	3b 75 10             	cmp    0x10(%ebp),%esi
  8011a2:	72 c8                	jb     80116c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8011a4:	89 f0                	mov    %esi,%eax
  8011a6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8011ac:	5b                   	pop    %ebx
  8011ad:	5e                   	pop    %esi
  8011ae:	5f                   	pop    %edi
  8011af:	5d                   	pop    %ebp
  8011b0:	c3                   	ret    

008011b1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8011b7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	75 07                	jne    8011c9 <devcons_read+0x18>
  8011c2:	eb 31                	jmp    8011f5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8011c4:	e8 eb ef ff ff       	call   8001b4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8011c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011d0:	e8 22 ef ff ff       	call   8000f7 <sys_cgetc>
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	74 eb                	je     8011c4 <devcons_read+0x13>
  8011d9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	78 16                	js     8011f5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8011df:	83 f8 04             	cmp    $0x4,%eax
  8011e2:	74 0c                	je     8011f0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e7:	88 10                	mov    %dl,(%eax)
	return 1;
  8011e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8011ee:	eb 05                	jmp    8011f5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801203:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80120a:	00 
  80120b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80120e:	89 04 24             	mov    %eax,(%esp)
  801211:	e8 b2 ee ff ff       	call   8000c8 <sys_cputs>
}
  801216:	c9                   	leave  
  801217:	c3                   	ret    

00801218 <getchar>:

int
getchar(void)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80121e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801225:	00 
  801226:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801229:	89 44 24 04          	mov    %eax,0x4(%esp)
  80122d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801234:	e8 05 f6 ff ff       	call   80083e <read>
	if (r < 0)
  801239:	85 c0                	test   %eax,%eax
  80123b:	78 0f                	js     80124c <getchar+0x34>
		return r;
	if (r < 1)
  80123d:	85 c0                	test   %eax,%eax
  80123f:	7e 06                	jle    801247 <getchar+0x2f>
		return -E_EOF;
	return c;
  801241:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801245:	eb 05                	jmp    80124c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801247:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	89 04 24             	mov    %eax,(%esp)
  801261:	e8 18 f3 ff ff       	call   80057e <fd_lookup>
  801266:	85 c0                	test   %eax,%eax
  801268:	78 11                	js     80127b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80126a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801273:	39 10                	cmp    %edx,(%eax)
  801275:	0f 94 c0             	sete   %al
  801278:	0f b6 c0             	movzbl %al,%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <opencons>:

int
opencons(void)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801283:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801286:	89 04 24             	mov    %eax,(%esp)
  801289:	e8 7d f2 ff ff       	call   80050b <fd_alloc>
  80128e:	85 c0                	test   %eax,%eax
  801290:	78 3c                	js     8012ce <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801292:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801299:	00 
  80129a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a8:	e8 37 ef ff ff       	call   8001e4 <sys_page_alloc>
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	78 1d                	js     8012ce <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8012b1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8012b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ba:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8012bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8012c6:	89 04 24             	mov    %eax,(%esp)
  8012c9:	e8 12 f2 ff ff       	call   8004e0 <fd2num>
}
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	56                   	push   %esi
  8012d4:	53                   	push   %ebx
  8012d5:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8012d8:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8012db:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8012e1:	e8 9e ee ff ff       	call   800184 <sys_getenvid>
  8012e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012fc:	c7 04 24 84 23 80 00 	movl   $0x802384,(%esp)
  801303:	e8 c3 00 00 00       	call   8013cb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801308:	89 74 24 04          	mov    %esi,0x4(%esp)
  80130c:	8b 45 10             	mov    0x10(%ebp),%eax
  80130f:	89 04 24             	mov    %eax,(%esp)
  801312:	e8 53 00 00 00       	call   80136a <vcprintf>
	cprintf("\n");
  801317:	c7 04 24 6f 23 80 00 	movl   $0x80236f,(%esp)
  80131e:	e8 a8 00 00 00       	call   8013cb <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801323:	cc                   	int3   
  801324:	eb fd                	jmp    801323 <_panic+0x53>
	...

00801328 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	53                   	push   %ebx
  80132c:	83 ec 14             	sub    $0x14,%esp
  80132f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801332:	8b 03                	mov    (%ebx),%eax
  801334:	8b 55 08             	mov    0x8(%ebp),%edx
  801337:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80133b:	83 c0 01             	add    $0x1,%eax
  80133e:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801340:	3d ff 00 00 00       	cmp    $0xff,%eax
  801345:	75 19                	jne    801360 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801347:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80134e:	00 
  80134f:	8d 43 08             	lea    0x8(%ebx),%eax
  801352:	89 04 24             	mov    %eax,(%esp)
  801355:	e8 6e ed ff ff       	call   8000c8 <sys_cputs>
		b->idx = 0;
  80135a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801360:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801364:	83 c4 14             	add    $0x14,%esp
  801367:	5b                   	pop    %ebx
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801373:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80137a:	00 00 00 
	b.cnt = 0;
  80137d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801384:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	89 44 24 08          	mov    %eax,0x8(%esp)
  801395:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80139b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139f:	c7 04 24 28 13 80 00 	movl   $0x801328,(%esp)
  8013a6:	e8 9f 01 00 00       	call   80154a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8013ab:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8013b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8013bb:	89 04 24             	mov    %eax,(%esp)
  8013be:	e8 05 ed ff ff       	call   8000c8 <sys_cputs>

	return b.cnt;
}
  8013c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8013d1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8013d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	89 04 24             	mov    %eax,(%esp)
  8013de:	e8 87 ff ff ff       	call   80136a <vcprintf>
	va_end(ap);

	return cnt;
}
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    
	...

008013f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	57                   	push   %edi
  8013f4:	56                   	push   %esi
  8013f5:	53                   	push   %ebx
  8013f6:	83 ec 3c             	sub    $0x3c,%esp
  8013f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013fc:	89 d7                	mov    %edx,%edi
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801404:	8b 45 0c             	mov    0xc(%ebp),%eax
  801407:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80140a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80140d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801418:	72 11                	jb     80142b <printnum+0x3b>
  80141a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80141d:	39 45 10             	cmp    %eax,0x10(%ebp)
  801420:	76 09                	jbe    80142b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801422:	83 eb 01             	sub    $0x1,%ebx
  801425:	85 db                	test   %ebx,%ebx
  801427:	7f 51                	jg     80147a <printnum+0x8a>
  801429:	eb 5e                	jmp    801489 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80142b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80142f:	83 eb 01             	sub    $0x1,%ebx
  801432:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801436:	8b 45 10             	mov    0x10(%ebp),%eax
  801439:	89 44 24 08          	mov    %eax,0x8(%esp)
  80143d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  801441:	8b 74 24 0c          	mov    0xc(%esp),%esi
  801445:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80144c:	00 
  80144d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801450:	89 04 24             	mov    %eax,(%esp)
  801453:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801456:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145a:	e8 41 0b 00 00       	call   801fa0 <__udivdi3>
  80145f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801463:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801467:	89 04 24             	mov    %eax,(%esp)
  80146a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80146e:	89 fa                	mov    %edi,%edx
  801470:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801473:	e8 78 ff ff ff       	call   8013f0 <printnum>
  801478:	eb 0f                	jmp    801489 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80147a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80147e:	89 34 24             	mov    %esi,(%esp)
  801481:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801484:	83 eb 01             	sub    $0x1,%ebx
  801487:	75 f1                	jne    80147a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801489:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80148d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	89 44 24 08          	mov    %eax,0x8(%esp)
  801498:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80149f:	00 
  8014a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a3:	89 04 24             	mov    %eax,(%esp)
  8014a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ad:	e8 1e 0c 00 00       	call   8020d0 <__umoddi3>
  8014b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014b6:	0f be 80 a7 23 80 00 	movsbl 0x8023a7(%eax),%eax
  8014bd:	89 04 24             	mov    %eax,(%esp)
  8014c0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8014c3:	83 c4 3c             	add    $0x3c,%esp
  8014c6:	5b                   	pop    %ebx
  8014c7:	5e                   	pop    %esi
  8014c8:	5f                   	pop    %edi
  8014c9:	5d                   	pop    %ebp
  8014ca:	c3                   	ret    

008014cb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8014ce:	83 fa 01             	cmp    $0x1,%edx
  8014d1:	7e 0e                	jle    8014e1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8014d3:	8b 10                	mov    (%eax),%edx
  8014d5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8014d8:	89 08                	mov    %ecx,(%eax)
  8014da:	8b 02                	mov    (%edx),%eax
  8014dc:	8b 52 04             	mov    0x4(%edx),%edx
  8014df:	eb 22                	jmp    801503 <getuint+0x38>
	else if (lflag)
  8014e1:	85 d2                	test   %edx,%edx
  8014e3:	74 10                	je     8014f5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8014e5:	8b 10                	mov    (%eax),%edx
  8014e7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8014ea:	89 08                	mov    %ecx,(%eax)
  8014ec:	8b 02                	mov    (%edx),%eax
  8014ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f3:	eb 0e                	jmp    801503 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8014f5:	8b 10                	mov    (%eax),%edx
  8014f7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8014fa:	89 08                	mov    %ecx,(%eax)
  8014fc:	8b 02                	mov    (%edx),%eax
  8014fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801503:	5d                   	pop    %ebp
  801504:	c3                   	ret    

00801505 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80150b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80150f:	8b 10                	mov    (%eax),%edx
  801511:	3b 50 04             	cmp    0x4(%eax),%edx
  801514:	73 0a                	jae    801520 <sprintputch+0x1b>
		*b->buf++ = ch;
  801516:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801519:	88 0a                	mov    %cl,(%edx)
  80151b:	83 c2 01             	add    $0x1,%edx
  80151e:	89 10                	mov    %edx,(%eax)
}
  801520:	5d                   	pop    %ebp
  801521:	c3                   	ret    

00801522 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801528:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80152b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80152f:	8b 45 10             	mov    0x10(%ebp),%eax
  801532:	89 44 24 08          	mov    %eax,0x8(%esp)
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	89 04 24             	mov    %eax,(%esp)
  801543:	e8 02 00 00 00       	call   80154a <vprintfmt>
	va_end(ap);
}
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	57                   	push   %edi
  80154e:	56                   	push   %esi
  80154f:	53                   	push   %ebx
  801550:	83 ec 4c             	sub    $0x4c,%esp
  801553:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801556:	8b 75 10             	mov    0x10(%ebp),%esi
  801559:	eb 12                	jmp    80156d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80155b:	85 c0                	test   %eax,%eax
  80155d:	0f 84 a9 03 00 00    	je     80190c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  801563:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801567:	89 04 24             	mov    %eax,(%esp)
  80156a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80156d:	0f b6 06             	movzbl (%esi),%eax
  801570:	83 c6 01             	add    $0x1,%esi
  801573:	83 f8 25             	cmp    $0x25,%eax
  801576:	75 e3                	jne    80155b <vprintfmt+0x11>
  801578:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80157c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801583:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  801588:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80158f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801594:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801597:	eb 2b                	jmp    8015c4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801599:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80159c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8015a0:	eb 22                	jmp    8015c4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015a2:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8015a5:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8015a9:	eb 19                	jmp    8015c4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015ab:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8015ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8015b5:	eb 0d                	jmp    8015c4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8015b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015bd:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015c4:	0f b6 06             	movzbl (%esi),%eax
  8015c7:	0f b6 d0             	movzbl %al,%edx
  8015ca:	8d 7e 01             	lea    0x1(%esi),%edi
  8015cd:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8015d0:	83 e8 23             	sub    $0x23,%eax
  8015d3:	3c 55                	cmp    $0x55,%al
  8015d5:	0f 87 0b 03 00 00    	ja     8018e6 <vprintfmt+0x39c>
  8015db:	0f b6 c0             	movzbl %al,%eax
  8015de:	ff 24 85 e0 24 80 00 	jmp    *0x8024e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8015e5:	83 ea 30             	sub    $0x30,%edx
  8015e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8015eb:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8015ef:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015f2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8015f5:	83 fa 09             	cmp    $0x9,%edx
  8015f8:	77 4a                	ja     801644 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015fa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8015fd:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  801600:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  801603:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  801607:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80160a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80160d:	83 fa 09             	cmp    $0x9,%edx
  801610:	76 eb                	jbe    8015fd <vprintfmt+0xb3>
  801612:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801615:	eb 2d                	jmp    801644 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801617:	8b 45 14             	mov    0x14(%ebp),%eax
  80161a:	8d 50 04             	lea    0x4(%eax),%edx
  80161d:	89 55 14             	mov    %edx,0x14(%ebp)
  801620:	8b 00                	mov    (%eax),%eax
  801622:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801625:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801628:	eb 1a                	jmp    801644 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80162a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80162d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801631:	79 91                	jns    8015c4 <vprintfmt+0x7a>
  801633:	e9 73 ff ff ff       	jmp    8015ab <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801638:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80163b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801642:	eb 80                	jmp    8015c4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  801644:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801648:	0f 89 76 ff ff ff    	jns    8015c4 <vprintfmt+0x7a>
  80164e:	e9 64 ff ff ff       	jmp    8015b7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801653:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801656:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801659:	e9 66 ff ff ff       	jmp    8015c4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80165e:	8b 45 14             	mov    0x14(%ebp),%eax
  801661:	8d 50 04             	lea    0x4(%eax),%edx
  801664:	89 55 14             	mov    %edx,0x14(%ebp)
  801667:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80166b:	8b 00                	mov    (%eax),%eax
  80166d:	89 04 24             	mov    %eax,(%esp)
  801670:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801673:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801676:	e9 f2 fe ff ff       	jmp    80156d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80167b:	8b 45 14             	mov    0x14(%ebp),%eax
  80167e:	8d 50 04             	lea    0x4(%eax),%edx
  801681:	89 55 14             	mov    %edx,0x14(%ebp)
  801684:	8b 00                	mov    (%eax),%eax
  801686:	89 c2                	mov    %eax,%edx
  801688:	c1 fa 1f             	sar    $0x1f,%edx
  80168b:	31 d0                	xor    %edx,%eax
  80168d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80168f:	83 f8 0f             	cmp    $0xf,%eax
  801692:	7f 0b                	jg     80169f <vprintfmt+0x155>
  801694:	8b 14 85 40 26 80 00 	mov    0x802640(,%eax,4),%edx
  80169b:	85 d2                	test   %edx,%edx
  80169d:	75 23                	jne    8016c2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80169f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016a3:	c7 44 24 08 bf 23 80 	movl   $0x8023bf,0x8(%esp)
  8016aa:	00 
  8016ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016af:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016b2:	89 3c 24             	mov    %edi,(%esp)
  8016b5:	e8 68 fe ff ff       	call   801522 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016ba:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8016bd:	e9 ab fe ff ff       	jmp    80156d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  8016c2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8016c6:	c7 44 24 08 3d 23 80 	movl   $0x80233d,0x8(%esp)
  8016cd:	00 
  8016ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016d5:	89 3c 24             	mov    %edi,(%esp)
  8016d8:	e8 45 fe ff ff       	call   801522 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016dd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8016e0:	e9 88 fe ff ff       	jmp    80156d <vprintfmt+0x23>
  8016e5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8016e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8016ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f1:	8d 50 04             	lea    0x4(%eax),%edx
  8016f4:	89 55 14             	mov    %edx,0x14(%ebp)
  8016f7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8016f9:	85 f6                	test   %esi,%esi
  8016fb:	ba b8 23 80 00       	mov    $0x8023b8,%edx
  801700:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  801703:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801707:	7e 06                	jle    80170f <vprintfmt+0x1c5>
  801709:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80170d:	75 10                	jne    80171f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80170f:	0f be 06             	movsbl (%esi),%eax
  801712:	83 c6 01             	add    $0x1,%esi
  801715:	85 c0                	test   %eax,%eax
  801717:	0f 85 86 00 00 00    	jne    8017a3 <vprintfmt+0x259>
  80171d:	eb 76                	jmp    801795 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80171f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801723:	89 34 24             	mov    %esi,(%esp)
  801726:	e8 90 02 00 00       	call   8019bb <strnlen>
  80172b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80172e:	29 c2                	sub    %eax,%edx
  801730:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801733:	85 d2                	test   %edx,%edx
  801735:	7e d8                	jle    80170f <vprintfmt+0x1c5>
					putch(padc, putdat);
  801737:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80173b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80173e:	89 d6                	mov    %edx,%esi
  801740:	89 7d d0             	mov    %edi,-0x30(%ebp)
  801743:	89 c7                	mov    %eax,%edi
  801745:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801749:	89 3c 24             	mov    %edi,(%esp)
  80174c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80174f:	83 ee 01             	sub    $0x1,%esi
  801752:	75 f1                	jne    801745 <vprintfmt+0x1fb>
  801754:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801757:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80175a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80175d:	eb b0                	jmp    80170f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80175f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801763:	74 18                	je     80177d <vprintfmt+0x233>
  801765:	8d 50 e0             	lea    -0x20(%eax),%edx
  801768:	83 fa 5e             	cmp    $0x5e,%edx
  80176b:	76 10                	jbe    80177d <vprintfmt+0x233>
					putch('?', putdat);
  80176d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801771:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801778:	ff 55 08             	call   *0x8(%ebp)
  80177b:	eb 0a                	jmp    801787 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80177d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801781:	89 04 24             	mov    %eax,(%esp)
  801784:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801787:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80178b:	0f be 06             	movsbl (%esi),%eax
  80178e:	83 c6 01             	add    $0x1,%esi
  801791:	85 c0                	test   %eax,%eax
  801793:	75 0e                	jne    8017a3 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801795:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801798:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80179c:	7f 16                	jg     8017b4 <vprintfmt+0x26a>
  80179e:	e9 ca fd ff ff       	jmp    80156d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8017a3:	85 ff                	test   %edi,%edi
  8017a5:	78 b8                	js     80175f <vprintfmt+0x215>
  8017a7:	83 ef 01             	sub    $0x1,%edi
  8017aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8017b0:	79 ad                	jns    80175f <vprintfmt+0x215>
  8017b2:	eb e1                	jmp    801795 <vprintfmt+0x24b>
  8017b4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8017b7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8017ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8017c5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8017c7:	83 ee 01             	sub    $0x1,%esi
  8017ca:	75 ee                	jne    8017ba <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8017cc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8017cf:	e9 99 fd ff ff       	jmp    80156d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8017d4:	83 f9 01             	cmp    $0x1,%ecx
  8017d7:	7e 10                	jle    8017e9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  8017d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017dc:	8d 50 08             	lea    0x8(%eax),%edx
  8017df:	89 55 14             	mov    %edx,0x14(%ebp)
  8017e2:	8b 30                	mov    (%eax),%esi
  8017e4:	8b 78 04             	mov    0x4(%eax),%edi
  8017e7:	eb 26                	jmp    80180f <vprintfmt+0x2c5>
	else if (lflag)
  8017e9:	85 c9                	test   %ecx,%ecx
  8017eb:	74 12                	je     8017ff <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8017ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f0:	8d 50 04             	lea    0x4(%eax),%edx
  8017f3:	89 55 14             	mov    %edx,0x14(%ebp)
  8017f6:	8b 30                	mov    (%eax),%esi
  8017f8:	89 f7                	mov    %esi,%edi
  8017fa:	c1 ff 1f             	sar    $0x1f,%edi
  8017fd:	eb 10                	jmp    80180f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8017ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801802:	8d 50 04             	lea    0x4(%eax),%edx
  801805:	89 55 14             	mov    %edx,0x14(%ebp)
  801808:	8b 30                	mov    (%eax),%esi
  80180a:	89 f7                	mov    %esi,%edi
  80180c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80180f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801814:	85 ff                	test   %edi,%edi
  801816:	0f 89 8c 00 00 00    	jns    8018a8 <vprintfmt+0x35e>
				putch('-', putdat);
  80181c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801820:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801827:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80182a:	f7 de                	neg    %esi
  80182c:	83 d7 00             	adc    $0x0,%edi
  80182f:	f7 df                	neg    %edi
			}
			base = 10;
  801831:	b8 0a 00 00 00       	mov    $0xa,%eax
  801836:	eb 70                	jmp    8018a8 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801838:	89 ca                	mov    %ecx,%edx
  80183a:	8d 45 14             	lea    0x14(%ebp),%eax
  80183d:	e8 89 fc ff ff       	call   8014cb <getuint>
  801842:	89 c6                	mov    %eax,%esi
  801844:	89 d7                	mov    %edx,%edi
			base = 10;
  801846:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80184b:	eb 5b                	jmp    8018a8 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80184d:	89 ca                	mov    %ecx,%edx
  80184f:	8d 45 14             	lea    0x14(%ebp),%eax
  801852:	e8 74 fc ff ff       	call   8014cb <getuint>
  801857:	89 c6                	mov    %eax,%esi
  801859:	89 d7                	mov    %edx,%edi
			base = 8;
  80185b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  801860:	eb 46                	jmp    8018a8 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  801862:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801866:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80186d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801870:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801874:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80187b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80187e:	8b 45 14             	mov    0x14(%ebp),%eax
  801881:	8d 50 04             	lea    0x4(%eax),%edx
  801884:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801887:	8b 30                	mov    (%eax),%esi
  801889:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80188e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  801893:	eb 13                	jmp    8018a8 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801895:	89 ca                	mov    %ecx,%edx
  801897:	8d 45 14             	lea    0x14(%ebp),%eax
  80189a:	e8 2c fc ff ff       	call   8014cb <getuint>
  80189f:	89 c6                	mov    %eax,%esi
  8018a1:	89 d7                	mov    %edx,%edi
			base = 16;
  8018a3:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8018a8:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  8018ac:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8018b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018bb:	89 34 24             	mov    %esi,(%esp)
  8018be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018c2:	89 da                	mov    %ebx,%edx
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	e8 24 fb ff ff       	call   8013f0 <printnum>
			break;
  8018cc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8018cf:	e9 99 fc ff ff       	jmp    80156d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8018d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018d8:	89 14 24             	mov    %edx,(%esp)
  8018db:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8018de:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8018e1:	e9 87 fc ff ff       	jmp    80156d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8018e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8018f1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8018f4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8018f8:	0f 84 6f fc ff ff    	je     80156d <vprintfmt+0x23>
  8018fe:	83 ee 01             	sub    $0x1,%esi
  801901:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  801905:	75 f7                	jne    8018fe <vprintfmt+0x3b4>
  801907:	e9 61 fc ff ff       	jmp    80156d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80190c:	83 c4 4c             	add    $0x4c,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5f                   	pop    %edi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    

00801914 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 28             	sub    $0x28,%esp
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801920:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801923:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801927:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80192a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801931:	85 c0                	test   %eax,%eax
  801933:	74 30                	je     801965 <vsnprintf+0x51>
  801935:	85 d2                	test   %edx,%edx
  801937:	7e 2c                	jle    801965 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801939:	8b 45 14             	mov    0x14(%ebp),%eax
  80193c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801940:	8b 45 10             	mov    0x10(%ebp),%eax
  801943:	89 44 24 08          	mov    %eax,0x8(%esp)
  801947:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80194a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194e:	c7 04 24 05 15 80 00 	movl   $0x801505,(%esp)
  801955:	e8 f0 fb ff ff       	call   80154a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80195a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80195d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801963:	eb 05                	jmp    80196a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801965:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801972:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801975:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801979:	8b 45 10             	mov    0x10(%ebp),%eax
  80197c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801980:	8b 45 0c             	mov    0xc(%ebp),%eax
  801983:	89 44 24 04          	mov    %eax,0x4(%esp)
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	89 04 24             	mov    %eax,(%esp)
  80198d:	e8 82 ff ff ff       	call   801914 <vsnprintf>
	va_end(ap);

	return rc;
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    
	...

008019a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8019a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ab:	80 3a 00             	cmpb   $0x0,(%edx)
  8019ae:	74 09                	je     8019b9 <strlen+0x19>
		n++;
  8019b0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8019b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8019b7:	75 f7                	jne    8019b0 <strlen+0x10>
		n++;
	return n;
}
  8019b9:	5d                   	pop    %ebp
  8019ba:	c3                   	ret    

008019bb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	53                   	push   %ebx
  8019bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8019c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8019c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ca:	85 c9                	test   %ecx,%ecx
  8019cc:	74 1a                	je     8019e8 <strnlen+0x2d>
  8019ce:	80 3b 00             	cmpb   $0x0,(%ebx)
  8019d1:	74 15                	je     8019e8 <strnlen+0x2d>
  8019d3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8019d8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8019da:	39 ca                	cmp    %ecx,%edx
  8019dc:	74 0a                	je     8019e8 <strnlen+0x2d>
  8019de:	83 c2 01             	add    $0x1,%edx
  8019e1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8019e6:	75 f0                	jne    8019d8 <strnlen+0x1d>
		n++;
	return n;
}
  8019e8:	5b                   	pop    %ebx
  8019e9:	5d                   	pop    %ebp
  8019ea:	c3                   	ret    

008019eb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	53                   	push   %ebx
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8019f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fa:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8019fe:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801a01:	83 c2 01             	add    $0x1,%edx
  801a04:	84 c9                	test   %cl,%cl
  801a06:	75 f2                	jne    8019fa <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801a08:	5b                   	pop    %ebx
  801a09:	5d                   	pop    %ebp
  801a0a:	c3                   	ret    

00801a0b <strcat>:

char *
strcat(char *dst, const char *src)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	53                   	push   %ebx
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801a15:	89 1c 24             	mov    %ebx,(%esp)
  801a18:	e8 83 ff ff ff       	call   8019a0 <strlen>
	strcpy(dst + len, src);
  801a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a20:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a24:	01 d8                	add    %ebx,%eax
  801a26:	89 04 24             	mov    %eax,(%esp)
  801a29:	e8 bd ff ff ff       	call   8019eb <strcpy>
	return dst;
}
  801a2e:	89 d8                	mov    %ebx,%eax
  801a30:	83 c4 08             	add    $0x8,%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    

00801a36 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	56                   	push   %esi
  801a3a:	53                   	push   %ebx
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a41:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a44:	85 f6                	test   %esi,%esi
  801a46:	74 18                	je     801a60 <strncpy+0x2a>
  801a48:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  801a4d:	0f b6 1a             	movzbl (%edx),%ebx
  801a50:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801a53:	80 3a 01             	cmpb   $0x1,(%edx)
  801a56:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a59:	83 c1 01             	add    $0x1,%ecx
  801a5c:	39 f1                	cmp    %esi,%ecx
  801a5e:	75 ed                	jne    801a4d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801a60:	5b                   	pop    %ebx
  801a61:	5e                   	pop    %esi
  801a62:	5d                   	pop    %ebp
  801a63:	c3                   	ret    

00801a64 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	57                   	push   %edi
  801a68:	56                   	push   %esi
  801a69:	53                   	push   %ebx
  801a6a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a70:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801a73:	89 f8                	mov    %edi,%eax
  801a75:	85 f6                	test   %esi,%esi
  801a77:	74 2b                	je     801aa4 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  801a79:	83 fe 01             	cmp    $0x1,%esi
  801a7c:	74 23                	je     801aa1 <strlcpy+0x3d>
  801a7e:	0f b6 0b             	movzbl (%ebx),%ecx
  801a81:	84 c9                	test   %cl,%cl
  801a83:	74 1c                	je     801aa1 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  801a85:	83 ee 02             	sub    $0x2,%esi
  801a88:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801a8d:	88 08                	mov    %cl,(%eax)
  801a8f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a92:	39 f2                	cmp    %esi,%edx
  801a94:	74 0b                	je     801aa1 <strlcpy+0x3d>
  801a96:	83 c2 01             	add    $0x1,%edx
  801a99:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801a9d:	84 c9                	test   %cl,%cl
  801a9f:	75 ec                	jne    801a8d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  801aa1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801aa4:	29 f8                	sub    %edi,%eax
}
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	5f                   	pop    %edi
  801aa9:	5d                   	pop    %ebp
  801aaa:	c3                   	ret    

00801aab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801ab4:	0f b6 01             	movzbl (%ecx),%eax
  801ab7:	84 c0                	test   %al,%al
  801ab9:	74 16                	je     801ad1 <strcmp+0x26>
  801abb:	3a 02                	cmp    (%edx),%al
  801abd:	75 12                	jne    801ad1 <strcmp+0x26>
		p++, q++;
  801abf:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801ac2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  801ac6:	84 c0                	test   %al,%al
  801ac8:	74 07                	je     801ad1 <strcmp+0x26>
  801aca:	83 c1 01             	add    $0x1,%ecx
  801acd:	3a 02                	cmp    (%edx),%al
  801acf:	74 ee                	je     801abf <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ad1:	0f b6 c0             	movzbl %al,%eax
  801ad4:	0f b6 12             	movzbl (%edx),%edx
  801ad7:	29 d0                	sub    %edx,%eax
}
  801ad9:	5d                   	pop    %ebp
  801ada:	c3                   	ret    

00801adb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	53                   	push   %ebx
  801adf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ae2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ae5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801aed:	85 d2                	test   %edx,%edx
  801aef:	74 28                	je     801b19 <strncmp+0x3e>
  801af1:	0f b6 01             	movzbl (%ecx),%eax
  801af4:	84 c0                	test   %al,%al
  801af6:	74 24                	je     801b1c <strncmp+0x41>
  801af8:	3a 03                	cmp    (%ebx),%al
  801afa:	75 20                	jne    801b1c <strncmp+0x41>
  801afc:	83 ea 01             	sub    $0x1,%edx
  801aff:	74 13                	je     801b14 <strncmp+0x39>
		n--, p++, q++;
  801b01:	83 c1 01             	add    $0x1,%ecx
  801b04:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801b07:	0f b6 01             	movzbl (%ecx),%eax
  801b0a:	84 c0                	test   %al,%al
  801b0c:	74 0e                	je     801b1c <strncmp+0x41>
  801b0e:	3a 03                	cmp    (%ebx),%al
  801b10:	74 ea                	je     801afc <strncmp+0x21>
  801b12:	eb 08                	jmp    801b1c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801b14:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801b19:	5b                   	pop    %ebx
  801b1a:	5d                   	pop    %ebp
  801b1b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801b1c:	0f b6 01             	movzbl (%ecx),%eax
  801b1f:	0f b6 13             	movzbl (%ebx),%edx
  801b22:	29 d0                	sub    %edx,%eax
  801b24:	eb f3                	jmp    801b19 <strncmp+0x3e>

00801b26 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801b30:	0f b6 10             	movzbl (%eax),%edx
  801b33:	84 d2                	test   %dl,%dl
  801b35:	74 1c                	je     801b53 <strchr+0x2d>
		if (*s == c)
  801b37:	38 ca                	cmp    %cl,%dl
  801b39:	75 09                	jne    801b44 <strchr+0x1e>
  801b3b:	eb 1b                	jmp    801b58 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b3d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  801b40:	38 ca                	cmp    %cl,%dl
  801b42:	74 14                	je     801b58 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b44:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  801b48:	84 d2                	test   %dl,%dl
  801b4a:	75 f1                	jne    801b3d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  801b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b51:	eb 05                	jmp    801b58 <strchr+0x32>
  801b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    

00801b5a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801b64:	0f b6 10             	movzbl (%eax),%edx
  801b67:	84 d2                	test   %dl,%dl
  801b69:	74 14                	je     801b7f <strfind+0x25>
		if (*s == c)
  801b6b:	38 ca                	cmp    %cl,%dl
  801b6d:	75 06                	jne    801b75 <strfind+0x1b>
  801b6f:	eb 0e                	jmp    801b7f <strfind+0x25>
  801b71:	38 ca                	cmp    %cl,%dl
  801b73:	74 0a                	je     801b7f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b75:	83 c0 01             	add    $0x1,%eax
  801b78:	0f b6 10             	movzbl (%eax),%edx
  801b7b:	84 d2                	test   %dl,%dl
  801b7d:	75 f2                	jne    801b71 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  801b7f:	5d                   	pop    %ebp
  801b80:	c3                   	ret    

00801b81 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 0c             	sub    $0xc,%esp
  801b87:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b8a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b8d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b90:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b96:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801b99:	85 c9                	test   %ecx,%ecx
  801b9b:	74 30                	je     801bcd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801b9d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801ba3:	75 25                	jne    801bca <memset+0x49>
  801ba5:	f6 c1 03             	test   $0x3,%cl
  801ba8:	75 20                	jne    801bca <memset+0x49>
		c &= 0xFF;
  801baa:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801bad:	89 d3                	mov    %edx,%ebx
  801baf:	c1 e3 08             	shl    $0x8,%ebx
  801bb2:	89 d6                	mov    %edx,%esi
  801bb4:	c1 e6 18             	shl    $0x18,%esi
  801bb7:	89 d0                	mov    %edx,%eax
  801bb9:	c1 e0 10             	shl    $0x10,%eax
  801bbc:	09 f0                	or     %esi,%eax
  801bbe:	09 d0                	or     %edx,%eax
  801bc0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801bc2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801bc5:	fc                   	cld    
  801bc6:	f3 ab                	rep stos %eax,%es:(%edi)
  801bc8:	eb 03                	jmp    801bcd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801bca:	fc                   	cld    
  801bcb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801bcd:	89 f8                	mov    %edi,%eax
  801bcf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801bd2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801bd5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801bd8:	89 ec                	mov    %ebp,%esp
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    

00801bdc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 08             	sub    $0x8,%esp
  801be2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801be5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801bf1:	39 c6                	cmp    %eax,%esi
  801bf3:	73 36                	jae    801c2b <memmove+0x4f>
  801bf5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801bf8:	39 d0                	cmp    %edx,%eax
  801bfa:	73 2f                	jae    801c2b <memmove+0x4f>
		s += n;
		d += n;
  801bfc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801bff:	f6 c2 03             	test   $0x3,%dl
  801c02:	75 1b                	jne    801c1f <memmove+0x43>
  801c04:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801c0a:	75 13                	jne    801c1f <memmove+0x43>
  801c0c:	f6 c1 03             	test   $0x3,%cl
  801c0f:	75 0e                	jne    801c1f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c11:	83 ef 04             	sub    $0x4,%edi
  801c14:	8d 72 fc             	lea    -0x4(%edx),%esi
  801c17:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c1a:	fd                   	std    
  801c1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801c1d:	eb 09                	jmp    801c28 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801c1f:	83 ef 01             	sub    $0x1,%edi
  801c22:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801c25:	fd                   	std    
  801c26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801c28:	fc                   	cld    
  801c29:	eb 20                	jmp    801c4b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801c2b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801c31:	75 13                	jne    801c46 <memmove+0x6a>
  801c33:	a8 03                	test   $0x3,%al
  801c35:	75 0f                	jne    801c46 <memmove+0x6a>
  801c37:	f6 c1 03             	test   $0x3,%cl
  801c3a:	75 0a                	jne    801c46 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801c3c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801c3f:	89 c7                	mov    %eax,%edi
  801c41:	fc                   	cld    
  801c42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801c44:	eb 05                	jmp    801c4b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801c46:	89 c7                	mov    %eax,%edi
  801c48:	fc                   	cld    
  801c49:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801c4b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c4e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c51:	89 ec                	mov    %ebp,%esp
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    

00801c55 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	89 04 24             	mov    %eax,(%esp)
  801c6f:	e8 68 ff ff ff       	call   801bdc <memmove>
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	57                   	push   %edi
  801c7a:	56                   	push   %esi
  801c7b:	53                   	push   %ebx
  801c7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c82:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c8a:	85 ff                	test   %edi,%edi
  801c8c:	74 37                	je     801cc5 <memcmp+0x4f>
		if (*s1 != *s2)
  801c8e:	0f b6 03             	movzbl (%ebx),%eax
  801c91:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c94:	83 ef 01             	sub    $0x1,%edi
  801c97:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  801c9c:	38 c8                	cmp    %cl,%al
  801c9e:	74 1c                	je     801cbc <memcmp+0x46>
  801ca0:	eb 10                	jmp    801cb2 <memcmp+0x3c>
  801ca2:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801ca7:	83 c2 01             	add    $0x1,%edx
  801caa:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801cae:	38 c8                	cmp    %cl,%al
  801cb0:	74 0a                	je     801cbc <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  801cb2:	0f b6 c0             	movzbl %al,%eax
  801cb5:	0f b6 c9             	movzbl %cl,%ecx
  801cb8:	29 c8                	sub    %ecx,%eax
  801cba:	eb 09                	jmp    801cc5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801cbc:	39 fa                	cmp    %edi,%edx
  801cbe:	75 e2                	jne    801ca2 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc5:	5b                   	pop    %ebx
  801cc6:	5e                   	pop    %esi
  801cc7:	5f                   	pop    %edi
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    

00801cca <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801cd0:	89 c2                	mov    %eax,%edx
  801cd2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801cd5:	39 d0                	cmp    %edx,%eax
  801cd7:	73 19                	jae    801cf2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801cd9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801cdd:	38 08                	cmp    %cl,(%eax)
  801cdf:	75 06                	jne    801ce7 <memfind+0x1d>
  801ce1:	eb 0f                	jmp    801cf2 <memfind+0x28>
  801ce3:	38 08                	cmp    %cl,(%eax)
  801ce5:	74 0b                	je     801cf2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801ce7:	83 c0 01             	add    $0x1,%eax
  801cea:	39 d0                	cmp    %edx,%eax
  801cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801cf0:	75 f1                	jne    801ce3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801cf2:	5d                   	pop    %ebp
  801cf3:	c3                   	ret    

00801cf4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	57                   	push   %edi
  801cf8:	56                   	push   %esi
  801cf9:	53                   	push   %ebx
  801cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  801cfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d00:	0f b6 02             	movzbl (%edx),%eax
  801d03:	3c 20                	cmp    $0x20,%al
  801d05:	74 04                	je     801d0b <strtol+0x17>
  801d07:	3c 09                	cmp    $0x9,%al
  801d09:	75 0e                	jne    801d19 <strtol+0x25>
		s++;
  801d0b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d0e:	0f b6 02             	movzbl (%edx),%eax
  801d11:	3c 20                	cmp    $0x20,%al
  801d13:	74 f6                	je     801d0b <strtol+0x17>
  801d15:	3c 09                	cmp    $0x9,%al
  801d17:	74 f2                	je     801d0b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  801d19:	3c 2b                	cmp    $0x2b,%al
  801d1b:	75 0a                	jne    801d27 <strtol+0x33>
		s++;
  801d1d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801d20:	bf 00 00 00 00       	mov    $0x0,%edi
  801d25:	eb 10                	jmp    801d37 <strtol+0x43>
  801d27:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801d2c:	3c 2d                	cmp    $0x2d,%al
  801d2e:	75 07                	jne    801d37 <strtol+0x43>
		s++, neg = 1;
  801d30:	83 c2 01             	add    $0x1,%edx
  801d33:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801d37:	85 db                	test   %ebx,%ebx
  801d39:	0f 94 c0             	sete   %al
  801d3c:	74 05                	je     801d43 <strtol+0x4f>
  801d3e:	83 fb 10             	cmp    $0x10,%ebx
  801d41:	75 15                	jne    801d58 <strtol+0x64>
  801d43:	80 3a 30             	cmpb   $0x30,(%edx)
  801d46:	75 10                	jne    801d58 <strtol+0x64>
  801d48:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801d4c:	75 0a                	jne    801d58 <strtol+0x64>
		s += 2, base = 16;
  801d4e:	83 c2 02             	add    $0x2,%edx
  801d51:	bb 10 00 00 00       	mov    $0x10,%ebx
  801d56:	eb 13                	jmp    801d6b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  801d58:	84 c0                	test   %al,%al
  801d5a:	74 0f                	je     801d6b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801d5c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801d61:	80 3a 30             	cmpb   $0x30,(%edx)
  801d64:	75 05                	jne    801d6b <strtol+0x77>
		s++, base = 8;
  801d66:	83 c2 01             	add    $0x1,%edx
  801d69:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  801d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d70:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d72:	0f b6 0a             	movzbl (%edx),%ecx
  801d75:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801d78:	80 fb 09             	cmp    $0x9,%bl
  801d7b:	77 08                	ja     801d85 <strtol+0x91>
			dig = *s - '0';
  801d7d:	0f be c9             	movsbl %cl,%ecx
  801d80:	83 e9 30             	sub    $0x30,%ecx
  801d83:	eb 1e                	jmp    801da3 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  801d85:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  801d88:	80 fb 19             	cmp    $0x19,%bl
  801d8b:	77 08                	ja     801d95 <strtol+0xa1>
			dig = *s - 'a' + 10;
  801d8d:	0f be c9             	movsbl %cl,%ecx
  801d90:	83 e9 57             	sub    $0x57,%ecx
  801d93:	eb 0e                	jmp    801da3 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  801d95:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  801d98:	80 fb 19             	cmp    $0x19,%bl
  801d9b:	77 14                	ja     801db1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  801d9d:	0f be c9             	movsbl %cl,%ecx
  801da0:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801da3:	39 f1                	cmp    %esi,%ecx
  801da5:	7d 0e                	jge    801db5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801da7:	83 c2 01             	add    $0x1,%edx
  801daa:	0f af c6             	imul   %esi,%eax
  801dad:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  801daf:	eb c1                	jmp    801d72 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  801db1:	89 c1                	mov    %eax,%ecx
  801db3:	eb 02                	jmp    801db7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801db5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801db7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dbb:	74 05                	je     801dc2 <strtol+0xce>
		*endptr = (char *) s;
  801dbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801dc0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801dc2:	89 ca                	mov    %ecx,%edx
  801dc4:	f7 da                	neg    %edx
  801dc6:	85 ff                	test   %edi,%edi
  801dc8:	0f 45 c2             	cmovne %edx,%eax
}
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5f                   	pop    %edi
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    

00801dd0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  801dd6:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801ddd:	75 54                	jne    801e33 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  801ddf:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801de6:	00 
  801de7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801dee:	ee 
  801def:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df6:	e8 e9 e3 ff ff       	call   8001e4 <sys_page_alloc>
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	79 20                	jns    801e1f <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  801dff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e03:	c7 44 24 08 a0 26 80 	movl   $0x8026a0,0x8(%esp)
  801e0a:	00 
  801e0b:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801e12:	00 
  801e13:	c7 04 24 b8 26 80 00 	movl   $0x8026b8,(%esp)
  801e1a:	e8 b1 f4 ff ff       	call   8012d0 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801e1f:	c7 44 24 04 ac 04 80 	movl   $0x8004ac,0x4(%esp)
  801e26:	00 
  801e27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e2e:	e8 88 e5 ff ff       	call   8003bb <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801e33:	8b 45 08             	mov    0x8(%ebp),%eax
  801e36:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    
  801e3d:	00 00                	add    %al,(%eax)
	...

00801e40 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	56                   	push   %esi
  801e44:	53                   	push   %ebx
  801e45:	83 ec 10             	sub    $0x10,%esp
  801e48:	8b 75 08             	mov    0x8(%ebp),%esi
  801e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801e51:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801e53:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e58:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801e5b:	89 04 24             	mov    %eax,(%esp)
  801e5e:	e8 ea e5 ff ff       	call   80044d <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801e63:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801e68:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801e6d:	85 c0                	test   %eax,%eax
  801e6f:	78 0e                	js     801e7f <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801e71:	a1 04 40 80 00       	mov    0x804004,%eax
  801e76:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801e79:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801e7c:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801e7f:	85 f6                	test   %esi,%esi
  801e81:	74 02                	je     801e85 <ipc_recv+0x45>
		*from_env_store = sender;
  801e83:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801e85:	85 db                	test   %ebx,%ebx
  801e87:	74 02                	je     801e8b <ipc_recv+0x4b>
		*perm_store = perm;
  801e89:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	5b                   	pop    %ebx
  801e8f:	5e                   	pop    %esi
  801e90:	5d                   	pop    %ebp
  801e91:	c3                   	ret    

00801e92 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	57                   	push   %edi
  801e96:	56                   	push   %esi
  801e97:	53                   	push   %ebx
  801e98:	83 ec 1c             	sub    $0x1c,%esp
  801e9b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ea1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801ea4:	85 db                	test   %ebx,%ebx
  801ea6:	75 04                	jne    801eac <ipc_send+0x1a>
  801ea8:	85 f6                	test   %esi,%esi
  801eaa:	75 15                	jne    801ec1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801eac:	85 db                	test   %ebx,%ebx
  801eae:	74 16                	je     801ec6 <ipc_send+0x34>
  801eb0:	85 f6                	test   %esi,%esi
  801eb2:	0f 94 c0             	sete   %al
      pg = 0;
  801eb5:	84 c0                	test   %al,%al
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebc:	0f 45 d8             	cmovne %eax,%ebx
  801ebf:	eb 05                	jmp    801ec6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801ec1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801ec6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801eca:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ece:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	89 04 24             	mov    %eax,(%esp)
  801ed8:	e8 3c e5 ff ff       	call   800419 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801edd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ee0:	75 07                	jne    801ee9 <ipc_send+0x57>
           sys_yield();
  801ee2:	e8 cd e2 ff ff       	call   8001b4 <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801ee7:	eb dd                	jmp    801ec6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	90                   	nop
  801eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ef0:	74 1c                	je     801f0e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801ef2:	c7 44 24 08 c6 26 80 	movl   $0x8026c6,0x8(%esp)
  801ef9:	00 
  801efa:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801f01:	00 
  801f02:	c7 04 24 d0 26 80 00 	movl   $0x8026d0,(%esp)
  801f09:	e8 c2 f3 ff ff       	call   8012d0 <_panic>
		}
    }
}
  801f0e:	83 c4 1c             	add    $0x1c,%esp
  801f11:	5b                   	pop    %ebx
  801f12:	5e                   	pop    %esi
  801f13:	5f                   	pop    %edi
  801f14:	5d                   	pop    %ebp
  801f15:	c3                   	ret    

00801f16 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801f1c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801f21:	39 c8                	cmp    %ecx,%eax
  801f23:	74 17                	je     801f3c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f25:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801f2a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f2d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f33:	8b 52 50             	mov    0x50(%edx),%edx
  801f36:	39 ca                	cmp    %ecx,%edx
  801f38:	75 14                	jne    801f4e <ipc_find_env+0x38>
  801f3a:	eb 05                	jmp    801f41 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801f41:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f44:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801f49:	8b 40 40             	mov    0x40(%eax),%eax
  801f4c:	eb 0e                	jmp    801f5c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f4e:	83 c0 01             	add    $0x1,%eax
  801f51:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f56:	75 d2                	jne    801f2a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801f58:	66 b8 00 00          	mov    $0x0,%ax
}
  801f5c:	5d                   	pop    %ebp
  801f5d:	c3                   	ret    
	...

00801f60 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f66:	89 d0                	mov    %edx,%eax
  801f68:	c1 e8 16             	shr    $0x16,%eax
  801f6b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f77:	f6 c1 01             	test   $0x1,%cl
  801f7a:	74 1d                	je     801f99 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f7c:	c1 ea 0c             	shr    $0xc,%edx
  801f7f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f86:	f6 c2 01             	test   $0x1,%dl
  801f89:	74 0e                	je     801f99 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f8b:	c1 ea 0c             	shr    $0xc,%edx
  801f8e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f95:	ef 
  801f96:	0f b7 c0             	movzwl %ax,%eax
}
  801f99:	5d                   	pop    %ebp
  801f9a:	c3                   	ret    
  801f9b:	00 00                	add    %al,(%eax)
  801f9d:	00 00                	add    %al,(%eax)
	...

00801fa0 <__udivdi3>:
  801fa0:	83 ec 1c             	sub    $0x1c,%esp
  801fa3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801fa7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801fab:	8b 44 24 20          	mov    0x20(%esp),%eax
  801faf:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801fb3:	89 74 24 10          	mov    %esi,0x10(%esp)
  801fb7:	8b 74 24 24          	mov    0x24(%esp),%esi
  801fbb:	85 ff                	test   %edi,%edi
  801fbd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801fc1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc5:	89 cd                	mov    %ecx,%ebp
  801fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fcb:	75 33                	jne    802000 <__udivdi3+0x60>
  801fcd:	39 f1                	cmp    %esi,%ecx
  801fcf:	77 57                	ja     802028 <__udivdi3+0x88>
  801fd1:	85 c9                	test   %ecx,%ecx
  801fd3:	75 0b                	jne    801fe0 <__udivdi3+0x40>
  801fd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801fda:	31 d2                	xor    %edx,%edx
  801fdc:	f7 f1                	div    %ecx
  801fde:	89 c1                	mov    %eax,%ecx
  801fe0:	89 f0                	mov    %esi,%eax
  801fe2:	31 d2                	xor    %edx,%edx
  801fe4:	f7 f1                	div    %ecx
  801fe6:	89 c6                	mov    %eax,%esi
  801fe8:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fec:	f7 f1                	div    %ecx
  801fee:	89 f2                	mov    %esi,%edx
  801ff0:	8b 74 24 10          	mov    0x10(%esp),%esi
  801ff4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801ff8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801ffc:	83 c4 1c             	add    $0x1c,%esp
  801fff:	c3                   	ret    
  802000:	31 d2                	xor    %edx,%edx
  802002:	31 c0                	xor    %eax,%eax
  802004:	39 f7                	cmp    %esi,%edi
  802006:	77 e8                	ja     801ff0 <__udivdi3+0x50>
  802008:	0f bd cf             	bsr    %edi,%ecx
  80200b:	83 f1 1f             	xor    $0x1f,%ecx
  80200e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802012:	75 2c                	jne    802040 <__udivdi3+0xa0>
  802014:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802018:	76 04                	jbe    80201e <__udivdi3+0x7e>
  80201a:	39 f7                	cmp    %esi,%edi
  80201c:	73 d2                	jae    801ff0 <__udivdi3+0x50>
  80201e:	31 d2                	xor    %edx,%edx
  802020:	b8 01 00 00 00       	mov    $0x1,%eax
  802025:	eb c9                	jmp    801ff0 <__udivdi3+0x50>
  802027:	90                   	nop
  802028:	89 f2                	mov    %esi,%edx
  80202a:	f7 f1                	div    %ecx
  80202c:	31 d2                	xor    %edx,%edx
  80202e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802032:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802036:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80203a:	83 c4 1c             	add    $0x1c,%esp
  80203d:	c3                   	ret    
  80203e:	66 90                	xchg   %ax,%ax
  802040:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802045:	b8 20 00 00 00       	mov    $0x20,%eax
  80204a:	89 ea                	mov    %ebp,%edx
  80204c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802050:	d3 e7                	shl    %cl,%edi
  802052:	89 c1                	mov    %eax,%ecx
  802054:	d3 ea                	shr    %cl,%edx
  802056:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80205b:	09 fa                	or     %edi,%edx
  80205d:	89 f7                	mov    %esi,%edi
  80205f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802063:	89 f2                	mov    %esi,%edx
  802065:	8b 74 24 08          	mov    0x8(%esp),%esi
  802069:	d3 e5                	shl    %cl,%ebp
  80206b:	89 c1                	mov    %eax,%ecx
  80206d:	d3 ef                	shr    %cl,%edi
  80206f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802074:	d3 e2                	shl    %cl,%edx
  802076:	89 c1                	mov    %eax,%ecx
  802078:	d3 ee                	shr    %cl,%esi
  80207a:	09 d6                	or     %edx,%esi
  80207c:	89 fa                	mov    %edi,%edx
  80207e:	89 f0                	mov    %esi,%eax
  802080:	f7 74 24 0c          	divl   0xc(%esp)
  802084:	89 d7                	mov    %edx,%edi
  802086:	89 c6                	mov    %eax,%esi
  802088:	f7 e5                	mul    %ebp
  80208a:	39 d7                	cmp    %edx,%edi
  80208c:	72 22                	jb     8020b0 <__udivdi3+0x110>
  80208e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802092:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802097:	d3 e5                	shl    %cl,%ebp
  802099:	39 c5                	cmp    %eax,%ebp
  80209b:	73 04                	jae    8020a1 <__udivdi3+0x101>
  80209d:	39 d7                	cmp    %edx,%edi
  80209f:	74 0f                	je     8020b0 <__udivdi3+0x110>
  8020a1:	89 f0                	mov    %esi,%eax
  8020a3:	31 d2                	xor    %edx,%edx
  8020a5:	e9 46 ff ff ff       	jmp    801ff0 <__udivdi3+0x50>
  8020aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020b0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8020b3:	31 d2                	xor    %edx,%edx
  8020b5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020b9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020bd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020c1:	83 c4 1c             	add    $0x1c,%esp
  8020c4:	c3                   	ret    
	...

008020d0 <__umoddi3>:
  8020d0:	83 ec 1c             	sub    $0x1c,%esp
  8020d3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8020d7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8020db:	8b 44 24 20          	mov    0x20(%esp),%eax
  8020df:	89 74 24 10          	mov    %esi,0x10(%esp)
  8020e3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8020e7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8020eb:	85 ed                	test   %ebp,%ebp
  8020ed:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8020f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020f5:	89 cf                	mov    %ecx,%edi
  8020f7:	89 04 24             	mov    %eax,(%esp)
  8020fa:	89 f2                	mov    %esi,%edx
  8020fc:	75 1a                	jne    802118 <__umoddi3+0x48>
  8020fe:	39 f1                	cmp    %esi,%ecx
  802100:	76 4e                	jbe    802150 <__umoddi3+0x80>
  802102:	f7 f1                	div    %ecx
  802104:	89 d0                	mov    %edx,%eax
  802106:	31 d2                	xor    %edx,%edx
  802108:	8b 74 24 10          	mov    0x10(%esp),%esi
  80210c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802110:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802114:	83 c4 1c             	add    $0x1c,%esp
  802117:	c3                   	ret    
  802118:	39 f5                	cmp    %esi,%ebp
  80211a:	77 54                	ja     802170 <__umoddi3+0xa0>
  80211c:	0f bd c5             	bsr    %ebp,%eax
  80211f:	83 f0 1f             	xor    $0x1f,%eax
  802122:	89 44 24 04          	mov    %eax,0x4(%esp)
  802126:	75 60                	jne    802188 <__umoddi3+0xb8>
  802128:	3b 0c 24             	cmp    (%esp),%ecx
  80212b:	0f 87 07 01 00 00    	ja     802238 <__umoddi3+0x168>
  802131:	89 f2                	mov    %esi,%edx
  802133:	8b 34 24             	mov    (%esp),%esi
  802136:	29 ce                	sub    %ecx,%esi
  802138:	19 ea                	sbb    %ebp,%edx
  80213a:	89 34 24             	mov    %esi,(%esp)
  80213d:	8b 04 24             	mov    (%esp),%eax
  802140:	8b 74 24 10          	mov    0x10(%esp),%esi
  802144:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802148:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80214c:	83 c4 1c             	add    $0x1c,%esp
  80214f:	c3                   	ret    
  802150:	85 c9                	test   %ecx,%ecx
  802152:	75 0b                	jne    80215f <__umoddi3+0x8f>
  802154:	b8 01 00 00 00       	mov    $0x1,%eax
  802159:	31 d2                	xor    %edx,%edx
  80215b:	f7 f1                	div    %ecx
  80215d:	89 c1                	mov    %eax,%ecx
  80215f:	89 f0                	mov    %esi,%eax
  802161:	31 d2                	xor    %edx,%edx
  802163:	f7 f1                	div    %ecx
  802165:	8b 04 24             	mov    (%esp),%eax
  802168:	f7 f1                	div    %ecx
  80216a:	eb 98                	jmp    802104 <__umoddi3+0x34>
  80216c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802170:	89 f2                	mov    %esi,%edx
  802172:	8b 74 24 10          	mov    0x10(%esp),%esi
  802176:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80217a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80217e:	83 c4 1c             	add    $0x1c,%esp
  802181:	c3                   	ret    
  802182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802188:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80218d:	89 e8                	mov    %ebp,%eax
  80218f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802194:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802198:	89 fa                	mov    %edi,%edx
  80219a:	d3 e0                	shl    %cl,%eax
  80219c:	89 e9                	mov    %ebp,%ecx
  80219e:	d3 ea                	shr    %cl,%edx
  8021a0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021a5:	09 c2                	or     %eax,%edx
  8021a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021ab:	89 14 24             	mov    %edx,(%esp)
  8021ae:	89 f2                	mov    %esi,%edx
  8021b0:	d3 e7                	shl    %cl,%edi
  8021b2:	89 e9                	mov    %ebp,%ecx
  8021b4:	d3 ea                	shr    %cl,%edx
  8021b6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021bf:	d3 e6                	shl    %cl,%esi
  8021c1:	89 e9                	mov    %ebp,%ecx
  8021c3:	d3 e8                	shr    %cl,%eax
  8021c5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021ca:	09 f0                	or     %esi,%eax
  8021cc:	8b 74 24 08          	mov    0x8(%esp),%esi
  8021d0:	f7 34 24             	divl   (%esp)
  8021d3:	d3 e6                	shl    %cl,%esi
  8021d5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8021d9:	89 d6                	mov    %edx,%esi
  8021db:	f7 e7                	mul    %edi
  8021dd:	39 d6                	cmp    %edx,%esi
  8021df:	89 c1                	mov    %eax,%ecx
  8021e1:	89 d7                	mov    %edx,%edi
  8021e3:	72 3f                	jb     802224 <__umoddi3+0x154>
  8021e5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8021e9:	72 35                	jb     802220 <__umoddi3+0x150>
  8021eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021ef:	29 c8                	sub    %ecx,%eax
  8021f1:	19 fe                	sbb    %edi,%esi
  8021f3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021f8:	89 f2                	mov    %esi,%edx
  8021fa:	d3 e8                	shr    %cl,%eax
  8021fc:	89 e9                	mov    %ebp,%ecx
  8021fe:	d3 e2                	shl    %cl,%edx
  802200:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802205:	09 d0                	or     %edx,%eax
  802207:	89 f2                	mov    %esi,%edx
  802209:	d3 ea                	shr    %cl,%edx
  80220b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80220f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802213:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802217:	83 c4 1c             	add    $0x1c,%esp
  80221a:	c3                   	ret    
  80221b:	90                   	nop
  80221c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802220:	39 d6                	cmp    %edx,%esi
  802222:	75 c7                	jne    8021eb <__umoddi3+0x11b>
  802224:	89 d7                	mov    %edx,%edi
  802226:	89 c1                	mov    %eax,%ecx
  802228:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80222c:	1b 3c 24             	sbb    (%esp),%edi
  80222f:	eb ba                	jmp    8021eb <__umoddi3+0x11b>
  802231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802238:	39 f5                	cmp    %esi,%ebp
  80223a:	0f 82 f1 fe ff ff    	jb     802131 <__umoddi3+0x61>
  802240:	e9 f8 fe ff ff       	jmp    80213d <__umoddi3+0x6d>
