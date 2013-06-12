
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	sys_cputs(hello, 1024*1024);
  80003a:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  800041:	00 
  800042:	a1 00 30 80 00       	mov    0x803000,%eax
  800047:	89 04 24             	mov    %eax,(%esp)
  80004a:	e8 71 00 00 00       	call   8000c0 <sys_cputs>
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    
  800051:	00 00                	add    %al,(%eax)
	...

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
  80005a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80005d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800060:	8b 75 08             	mov    0x8(%ebp),%esi
  800063:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800066:	e8 11 01 00 00       	call   80017c <sys_getenvid>
  80006b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800070:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800073:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800078:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007d:	85 f6                	test   %esi,%esi
  80007f:	7e 07                	jle    800088 <libmain+0x34>
		binaryname = argv[0];
  800081:	8b 03                	mov    (%ebx),%eax
  800083:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800088:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80008c:	89 34 24             	mov    %esi,(%esp)
  80008f:	e8 a0 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800094:	e8 0b 00 00 00       	call   8000a4 <exit>
}
  800099:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80009c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80009f:	89 ec                	mov    %ebp,%esp
  8000a1:	5d                   	pop    %ebp
  8000a2:	c3                   	ret    
	...

008000a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000aa:	e8 1f 06 00 00       	call   8006ce <close_all>
	sys_env_destroy(0);
  8000af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b6:	e8 64 00 00 00       	call   80011f <sys_env_destroy>
}
  8000bb:	c9                   	leave  
  8000bc:	c3                   	ret    
  8000bd:	00 00                	add    %al,(%eax)
	...

008000c0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8000c9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8000cc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000da:	89 c3                	mov    %eax,%ebx
  8000dc:	89 c7                	mov    %eax,%edi
  8000de:	89 c6                	mov    %eax,%esi
  8000e0:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000e2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8000e5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8000e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8000eb:	89 ec                	mov    %ebp,%esp
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ef:	55                   	push   %ebp
  8000f0:	89 e5                	mov    %esp,%ebp
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8000f8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8000fb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800103:	b8 01 00 00 00       	mov    $0x1,%eax
  800108:	89 d1                	mov    %edx,%ecx
  80010a:	89 d3                	mov    %edx,%ebx
  80010c:	89 d7                	mov    %edx,%edi
  80010e:	89 d6                	mov    %edx,%esi
  800110:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800112:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800115:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800118:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80011b:	89 ec                	mov    %ebp,%esp
  80011d:	5d                   	pop    %ebp
  80011e:	c3                   	ret    

0080011f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 38             	sub    $0x38,%esp
  800125:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800128:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80012b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80012e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800133:	b8 03 00 00 00       	mov    $0x3,%eax
  800138:	8b 55 08             	mov    0x8(%ebp),%edx
  80013b:	89 cb                	mov    %ecx,%ebx
  80013d:	89 cf                	mov    %ecx,%edi
  80013f:	89 ce                	mov    %ecx,%esi
  800141:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800143:	85 c0                	test   %eax,%eax
  800145:	7e 28                	jle    80016f <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800147:	89 44 24 10          	mov    %eax,0x10(%esp)
  80014b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800152:	00 
  800153:	c7 44 24 08 d8 21 80 	movl   $0x8021d8,0x8(%esp)
  80015a:	00 
  80015b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800162:	00 
  800163:	c7 04 24 f5 21 80 00 	movl   $0x8021f5,(%esp)
  80016a:	e8 31 11 00 00       	call   8012a0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80016f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800172:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800175:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800178:	89 ec                	mov    %ebp,%esp
  80017a:	5d                   	pop    %ebp
  80017b:	c3                   	ret    

0080017c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800185:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800188:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80018b:	ba 00 00 00 00       	mov    $0x0,%edx
  800190:	b8 02 00 00 00       	mov    $0x2,%eax
  800195:	89 d1                	mov    %edx,%ecx
  800197:	89 d3                	mov    %edx,%ebx
  800199:	89 d7                	mov    %edx,%edi
  80019b:	89 d6                	mov    %edx,%esi
  80019d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80019f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001a2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001a5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001a8:	89 ec                	mov    %ebp,%esp
  8001aa:	5d                   	pop    %ebp
  8001ab:	c3                   	ret    

008001ac <sys_yield>:

void
sys_yield(void)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001b5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001b8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8001c0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001c5:	89 d1                	mov    %edx,%ecx
  8001c7:	89 d3                	mov    %edx,%ebx
  8001c9:	89 d7                	mov    %edx,%edi
  8001cb:	89 d6                	mov    %edx,%esi
  8001cd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001cf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001d2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001d5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001d8:	89 ec                	mov    %ebp,%esp
  8001da:	5d                   	pop    %ebp
  8001db:	c3                   	ret    

008001dc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 38             	sub    $0x38,%esp
  8001e2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001e5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001e8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001eb:	be 00 00 00 00       	mov    $0x0,%esi
  8001f0:	b8 04 00 00 00       	mov    $0x4,%eax
  8001f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fe:	89 f7                	mov    %esi,%edi
  800200:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800202:	85 c0                	test   %eax,%eax
  800204:	7e 28                	jle    80022e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800206:	89 44 24 10          	mov    %eax,0x10(%esp)
  80020a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800211:	00 
  800212:	c7 44 24 08 d8 21 80 	movl   $0x8021d8,0x8(%esp)
  800219:	00 
  80021a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800221:	00 
  800222:	c7 04 24 f5 21 80 00 	movl   $0x8021f5,(%esp)
  800229:	e8 72 10 00 00       	call   8012a0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80022e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800231:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800234:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800237:	89 ec                	mov    %ebp,%esp
  800239:	5d                   	pop    %ebp
  80023a:	c3                   	ret    

0080023b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	83 ec 38             	sub    $0x38,%esp
  800241:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800244:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800247:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80024a:	b8 05 00 00 00       	mov    $0x5,%eax
  80024f:	8b 75 18             	mov    0x18(%ebp),%esi
  800252:	8b 7d 14             	mov    0x14(%ebp),%edi
  800255:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800258:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025b:	8b 55 08             	mov    0x8(%ebp),%edx
  80025e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800260:	85 c0                	test   %eax,%eax
  800262:	7e 28                	jle    80028c <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800264:	89 44 24 10          	mov    %eax,0x10(%esp)
  800268:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80026f:	00 
  800270:	c7 44 24 08 d8 21 80 	movl   $0x8021d8,0x8(%esp)
  800277:	00 
  800278:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80027f:	00 
  800280:	c7 04 24 f5 21 80 00 	movl   $0x8021f5,(%esp)
  800287:	e8 14 10 00 00       	call   8012a0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80028c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80028f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800292:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800295:	89 ec                	mov    %ebp,%esp
  800297:	5d                   	pop    %ebp
  800298:	c3                   	ret    

00800299 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 38             	sub    $0x38,%esp
  80029f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002a2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002a5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ad:	b8 06 00 00 00       	mov    $0x6,%eax
  8002b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b8:	89 df                	mov    %ebx,%edi
  8002ba:	89 de                	mov    %ebx,%esi
  8002bc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002be:	85 c0                	test   %eax,%eax
  8002c0:	7e 28                	jle    8002ea <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002c6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8002cd:	00 
  8002ce:	c7 44 24 08 d8 21 80 	movl   $0x8021d8,0x8(%esp)
  8002d5:	00 
  8002d6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002dd:	00 
  8002de:	c7 04 24 f5 21 80 00 	movl   $0x8021f5,(%esp)
  8002e5:	e8 b6 0f 00 00       	call   8012a0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8002ea:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002ed:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002f0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002f3:	89 ec                	mov    %ebp,%esp
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	83 ec 38             	sub    $0x38,%esp
  8002fd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800300:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800303:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800306:	bb 00 00 00 00       	mov    $0x0,%ebx
  80030b:	b8 08 00 00 00       	mov    $0x8,%eax
  800310:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800313:	8b 55 08             	mov    0x8(%ebp),%edx
  800316:	89 df                	mov    %ebx,%edi
  800318:	89 de                	mov    %ebx,%esi
  80031a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80031c:	85 c0                	test   %eax,%eax
  80031e:	7e 28                	jle    800348 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800320:	89 44 24 10          	mov    %eax,0x10(%esp)
  800324:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80032b:	00 
  80032c:	c7 44 24 08 d8 21 80 	movl   $0x8021d8,0x8(%esp)
  800333:	00 
  800334:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80033b:	00 
  80033c:	c7 04 24 f5 21 80 00 	movl   $0x8021f5,(%esp)
  800343:	e8 58 0f 00 00       	call   8012a0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800348:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80034b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80034e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800351:	89 ec                	mov    %ebp,%esp
  800353:	5d                   	pop    %ebp
  800354:	c3                   	ret    

00800355 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	83 ec 38             	sub    $0x38,%esp
  80035b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80035e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800361:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800364:	bb 00 00 00 00       	mov    $0x0,%ebx
  800369:	b8 09 00 00 00       	mov    $0x9,%eax
  80036e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800371:	8b 55 08             	mov    0x8(%ebp),%edx
  800374:	89 df                	mov    %ebx,%edi
  800376:	89 de                	mov    %ebx,%esi
  800378:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80037a:	85 c0                	test   %eax,%eax
  80037c:	7e 28                	jle    8003a6 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80037e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800382:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800389:	00 
  80038a:	c7 44 24 08 d8 21 80 	movl   $0x8021d8,0x8(%esp)
  800391:	00 
  800392:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800399:	00 
  80039a:	c7 04 24 f5 21 80 00 	movl   $0x8021f5,(%esp)
  8003a1:	e8 fa 0e 00 00       	call   8012a0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8003a6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003a9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003ac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003af:	89 ec                	mov    %ebp,%esp
  8003b1:	5d                   	pop    %ebp
  8003b2:	c3                   	ret    

008003b3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
  8003b6:	83 ec 38             	sub    $0x38,%esp
  8003b9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003bc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003bf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8003cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d2:	89 df                	mov    %ebx,%edi
  8003d4:	89 de                	mov    %ebx,%esi
  8003d6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003d8:	85 c0                	test   %eax,%eax
  8003da:	7e 28                	jle    800404 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003e0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8003e7:	00 
  8003e8:	c7 44 24 08 d8 21 80 	movl   $0x8021d8,0x8(%esp)
  8003ef:	00 
  8003f0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003f7:	00 
  8003f8:	c7 04 24 f5 21 80 00 	movl   $0x8021f5,(%esp)
  8003ff:	e8 9c 0e 00 00       	call   8012a0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800404:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800407:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80040a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80040d:	89 ec                	mov    %ebp,%esp
  80040f:	5d                   	pop    %ebp
  800410:	c3                   	ret    

00800411 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800411:	55                   	push   %ebp
  800412:	89 e5                	mov    %esp,%ebp
  800414:	83 ec 0c             	sub    $0xc,%esp
  800417:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80041a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80041d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800420:	be 00 00 00 00       	mov    $0x0,%esi
  800425:	b8 0c 00 00 00       	mov    $0xc,%eax
  80042a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80042d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800433:	8b 55 08             	mov    0x8(%ebp),%edx
  800436:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800438:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80043b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80043e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800441:	89 ec                	mov    %ebp,%esp
  800443:	5d                   	pop    %ebp
  800444:	c3                   	ret    

00800445 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	83 ec 38             	sub    $0x38,%esp
  80044b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80044e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800451:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800454:	b9 00 00 00 00       	mov    $0x0,%ecx
  800459:	b8 0d 00 00 00       	mov    $0xd,%eax
  80045e:	8b 55 08             	mov    0x8(%ebp),%edx
  800461:	89 cb                	mov    %ecx,%ebx
  800463:	89 cf                	mov    %ecx,%edi
  800465:	89 ce                	mov    %ecx,%esi
  800467:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800469:	85 c0                	test   %eax,%eax
  80046b:	7e 28                	jle    800495 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80046d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800471:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800478:	00 
  800479:	c7 44 24 08 d8 21 80 	movl   $0x8021d8,0x8(%esp)
  800480:	00 
  800481:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800488:	00 
  800489:	c7 04 24 f5 21 80 00 	movl   $0x8021f5,(%esp)
  800490:	e8 0b 0e 00 00       	call   8012a0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800495:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800498:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80049b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80049e:	89 ec                	mov    %ebp,%esp
  8004a0:	5d                   	pop    %ebp
  8004a1:	c3                   	ret    
	...

008004b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8004bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8004be:	5d                   	pop    %ebp
  8004bf:	c3                   	ret    

008004c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c9:	89 04 24             	mov    %eax,(%esp)
  8004cc:	e8 df ff ff ff       	call   8004b0 <fd2num>
  8004d1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8004d6:	c1 e0 0c             	shl    $0xc,%eax
}
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	53                   	push   %ebx
  8004df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8004e2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8004e7:	a8 01                	test   $0x1,%al
  8004e9:	74 34                	je     80051f <fd_alloc+0x44>
  8004eb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8004f0:	a8 01                	test   $0x1,%al
  8004f2:	74 32                	je     800526 <fd_alloc+0x4b>
  8004f4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8004f9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8004fb:	89 c2                	mov    %eax,%edx
  8004fd:	c1 ea 16             	shr    $0x16,%edx
  800500:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800507:	f6 c2 01             	test   $0x1,%dl
  80050a:	74 1f                	je     80052b <fd_alloc+0x50>
  80050c:	89 c2                	mov    %eax,%edx
  80050e:	c1 ea 0c             	shr    $0xc,%edx
  800511:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800518:	f6 c2 01             	test   $0x1,%dl
  80051b:	75 17                	jne    800534 <fd_alloc+0x59>
  80051d:	eb 0c                	jmp    80052b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80051f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800524:	eb 05                	jmp    80052b <fd_alloc+0x50>
  800526:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80052b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80052d:	b8 00 00 00 00       	mov    $0x0,%eax
  800532:	eb 17                	jmp    80054b <fd_alloc+0x70>
  800534:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800539:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80053e:	75 b9                	jne    8004f9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800540:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  800546:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80054b:	5b                   	pop    %ebx
  80054c:	5d                   	pop    %ebp
  80054d:	c3                   	ret    

0080054e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800554:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800559:	83 fa 1f             	cmp    $0x1f,%edx
  80055c:	77 3f                	ja     80059d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80055e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  800564:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800567:	89 d0                	mov    %edx,%eax
  800569:	c1 e8 16             	shr    $0x16,%eax
  80056c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800573:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800578:	f6 c1 01             	test   $0x1,%cl
  80057b:	74 20                	je     80059d <fd_lookup+0x4f>
  80057d:	89 d0                	mov    %edx,%eax
  80057f:	c1 e8 0c             	shr    $0xc,%eax
  800582:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800589:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80058e:	f6 c1 01             	test   $0x1,%cl
  800591:	74 0a                	je     80059d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800593:	8b 45 0c             	mov    0xc(%ebp),%eax
  800596:	89 10                	mov    %edx,(%eax)
	return 0;
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80059d:	5d                   	pop    %ebp
  80059e:	c3                   	ret    

0080059f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
  8005a2:	53                   	push   %ebx
  8005a3:	83 ec 14             	sub    $0x14,%esp
  8005a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8005ac:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8005b1:	39 0d 08 30 80 00    	cmp    %ecx,0x803008
  8005b7:	75 17                	jne    8005d0 <dev_lookup+0x31>
  8005b9:	eb 07                	jmp    8005c2 <dev_lookup+0x23>
  8005bb:	39 0a                	cmp    %ecx,(%edx)
  8005bd:	75 11                	jne    8005d0 <dev_lookup+0x31>
  8005bf:	90                   	nop
  8005c0:	eb 05                	jmp    8005c7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005c2:	ba 08 30 80 00       	mov    $0x803008,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8005c7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8005c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ce:	eb 35                	jmp    800605 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005d0:	83 c0 01             	add    $0x1,%eax
  8005d3:	8b 14 85 80 22 80 00 	mov    0x802280(,%eax,4),%edx
  8005da:	85 d2                	test   %edx,%edx
  8005dc:	75 dd                	jne    8005bb <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005de:	a1 04 40 80 00       	mov    0x804004,%eax
  8005e3:	8b 40 48             	mov    0x48(%eax),%eax
  8005e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ee:	c7 04 24 04 22 80 00 	movl   $0x802204,(%esp)
  8005f5:	e8 a1 0d 00 00       	call   80139b <cprintf>
	*dev = 0;
  8005fa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  800600:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800605:	83 c4 14             	add    $0x14,%esp
  800608:	5b                   	pop    %ebx
  800609:	5d                   	pop    %ebp
  80060a:	c3                   	ret    

0080060b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80060b:	55                   	push   %ebp
  80060c:	89 e5                	mov    %esp,%ebp
  80060e:	83 ec 38             	sub    $0x38,%esp
  800611:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800614:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800617:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80061a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80061d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800621:	89 3c 24             	mov    %edi,(%esp)
  800624:	e8 87 fe ff ff       	call   8004b0 <fd2num>
  800629:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80062c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800630:	89 04 24             	mov    %eax,(%esp)
  800633:	e8 16 ff ff ff       	call   80054e <fd_lookup>
  800638:	89 c3                	mov    %eax,%ebx
  80063a:	85 c0                	test   %eax,%eax
  80063c:	78 05                	js     800643 <fd_close+0x38>
	    || fd != fd2)
  80063e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  800641:	74 0e                	je     800651 <fd_close+0x46>
		return (must_exist ? r : 0);
  800643:	89 f0                	mov    %esi,%eax
  800645:	84 c0                	test   %al,%al
  800647:	b8 00 00 00 00       	mov    $0x0,%eax
  80064c:	0f 44 d8             	cmove  %eax,%ebx
  80064f:	eb 3d                	jmp    80068e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800651:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800654:	89 44 24 04          	mov    %eax,0x4(%esp)
  800658:	8b 07                	mov    (%edi),%eax
  80065a:	89 04 24             	mov    %eax,(%esp)
  80065d:	e8 3d ff ff ff       	call   80059f <dev_lookup>
  800662:	89 c3                	mov    %eax,%ebx
  800664:	85 c0                	test   %eax,%eax
  800666:	78 16                	js     80067e <fd_close+0x73>
		if (dev->dev_close)
  800668:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80066e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800673:	85 c0                	test   %eax,%eax
  800675:	74 07                	je     80067e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  800677:	89 3c 24             	mov    %edi,(%esp)
  80067a:	ff d0                	call   *%eax
  80067c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80067e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800682:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800689:	e8 0b fc ff ff       	call   800299 <sys_page_unmap>
	return r;
}
  80068e:	89 d8                	mov    %ebx,%eax
  800690:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800693:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800696:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800699:	89 ec                	mov    %ebp,%esp
  80069b:	5d                   	pop    %ebp
  80069c:	c3                   	ret    

0080069d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
  8006a0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8006a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	89 04 24             	mov    %eax,(%esp)
  8006b0:	e8 99 fe ff ff       	call   80054e <fd_lookup>
  8006b5:	85 c0                	test   %eax,%eax
  8006b7:	78 13                	js     8006cc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8006b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8006c0:	00 
  8006c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c4:	89 04 24             	mov    %eax,(%esp)
  8006c7:	e8 3f ff ff ff       	call   80060b <fd_close>
}
  8006cc:	c9                   	leave  
  8006cd:	c3                   	ret    

008006ce <close_all>:

void
close_all(void)
{
  8006ce:	55                   	push   %ebp
  8006cf:	89 e5                	mov    %esp,%ebp
  8006d1:	53                   	push   %ebx
  8006d2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006da:	89 1c 24             	mov    %ebx,(%esp)
  8006dd:	e8 bb ff ff ff       	call   80069d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006e2:	83 c3 01             	add    $0x1,%ebx
  8006e5:	83 fb 20             	cmp    $0x20,%ebx
  8006e8:	75 f0                	jne    8006da <close_all+0xc>
		close(i);
}
  8006ea:	83 c4 14             	add    $0x14,%esp
  8006ed:	5b                   	pop    %ebx
  8006ee:	5d                   	pop    %ebp
  8006ef:	c3                   	ret    

008006f0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	83 ec 58             	sub    $0x58,%esp
  8006f6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8006f9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8006fc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8006ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800702:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800705:	89 44 24 04          	mov    %eax,0x4(%esp)
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	89 04 24             	mov    %eax,(%esp)
  80070f:	e8 3a fe ff ff       	call   80054e <fd_lookup>
  800714:	89 c3                	mov    %eax,%ebx
  800716:	85 c0                	test   %eax,%eax
  800718:	0f 88 e1 00 00 00    	js     8007ff <dup+0x10f>
		return r;
	close(newfdnum);
  80071e:	89 3c 24             	mov    %edi,(%esp)
  800721:	e8 77 ff ff ff       	call   80069d <close>

	newfd = INDEX2FD(newfdnum);
  800726:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80072c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80072f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800732:	89 04 24             	mov    %eax,(%esp)
  800735:	e8 86 fd ff ff       	call   8004c0 <fd2data>
  80073a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80073c:	89 34 24             	mov    %esi,(%esp)
  80073f:	e8 7c fd ff ff       	call   8004c0 <fd2data>
  800744:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800747:	89 d8                	mov    %ebx,%eax
  800749:	c1 e8 16             	shr    $0x16,%eax
  80074c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800753:	a8 01                	test   $0x1,%al
  800755:	74 46                	je     80079d <dup+0xad>
  800757:	89 d8                	mov    %ebx,%eax
  800759:	c1 e8 0c             	shr    $0xc,%eax
  80075c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800763:	f6 c2 01             	test   $0x1,%dl
  800766:	74 35                	je     80079d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800768:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80076f:	25 07 0e 00 00       	and    $0xe07,%eax
  800774:	89 44 24 10          	mov    %eax,0x10(%esp)
  800778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80077b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80077f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800786:	00 
  800787:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80078b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800792:	e8 a4 fa ff ff       	call   80023b <sys_page_map>
  800797:	89 c3                	mov    %eax,%ebx
  800799:	85 c0                	test   %eax,%eax
  80079b:	78 3b                	js     8007d8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80079d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007a0:	89 c2                	mov    %eax,%edx
  8007a2:	c1 ea 0c             	shr    $0xc,%edx
  8007a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007ac:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8007b2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007b6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007c1:	00 
  8007c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007cd:	e8 69 fa ff ff       	call   80023b <sys_page_map>
  8007d2:	89 c3                	mov    %eax,%ebx
  8007d4:	85 c0                	test   %eax,%eax
  8007d6:	79 25                	jns    8007fd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007e3:	e8 b1 fa ff ff       	call   800299 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8007e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007f6:	e8 9e fa ff ff       	call   800299 <sys_page_unmap>
	return r;
  8007fb:	eb 02                	jmp    8007ff <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8007fd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8007ff:	89 d8                	mov    %ebx,%eax
  800801:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800804:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800807:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80080a:	89 ec                	mov    %ebp,%esp
  80080c:	5d                   	pop    %ebp
  80080d:	c3                   	ret    

0080080e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	53                   	push   %ebx
  800812:	83 ec 24             	sub    $0x24,%esp
  800815:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800818:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80081b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081f:	89 1c 24             	mov    %ebx,(%esp)
  800822:	e8 27 fd ff ff       	call   80054e <fd_lookup>
  800827:	85 c0                	test   %eax,%eax
  800829:	78 6d                	js     800898 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80082b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80082e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800835:	8b 00                	mov    (%eax),%eax
  800837:	89 04 24             	mov    %eax,(%esp)
  80083a:	e8 60 fd ff ff       	call   80059f <dev_lookup>
  80083f:	85 c0                	test   %eax,%eax
  800841:	78 55                	js     800898 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800846:	8b 50 08             	mov    0x8(%eax),%edx
  800849:	83 e2 03             	and    $0x3,%edx
  80084c:	83 fa 01             	cmp    $0x1,%edx
  80084f:	75 23                	jne    800874 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800851:	a1 04 40 80 00       	mov    0x804004,%eax
  800856:	8b 40 48             	mov    0x48(%eax),%eax
  800859:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80085d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800861:	c7 04 24 45 22 80 00 	movl   $0x802245,(%esp)
  800868:	e8 2e 0b 00 00       	call   80139b <cprintf>
		return -E_INVAL;
  80086d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800872:	eb 24                	jmp    800898 <read+0x8a>
	}
	if (!dev->dev_read)
  800874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800877:	8b 52 08             	mov    0x8(%edx),%edx
  80087a:	85 d2                	test   %edx,%edx
  80087c:	74 15                	je     800893 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80087e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800881:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800885:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800888:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80088c:	89 04 24             	mov    %eax,(%esp)
  80088f:	ff d2                	call   *%edx
  800891:	eb 05                	jmp    800898 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800893:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800898:	83 c4 24             	add    $0x24,%esp
  80089b:	5b                   	pop    %ebx
  80089c:	5d                   	pop    %ebp
  80089d:	c3                   	ret    

0080089e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	57                   	push   %edi
  8008a2:	56                   	push   %esi
  8008a3:	53                   	push   %ebx
  8008a4:	83 ec 1c             	sub    $0x1c,%esp
  8008a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	74 30                	je     8008e6 <readn+0x48>
  8008b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8008bb:	89 f2                	mov    %esi,%edx
  8008bd:	29 c2                	sub    %eax,%edx
  8008bf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8008c3:	03 45 0c             	add    0xc(%ebp),%eax
  8008c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ca:	89 3c 24             	mov    %edi,(%esp)
  8008cd:	e8 3c ff ff ff       	call   80080e <read>
		if (m < 0)
  8008d2:	85 c0                	test   %eax,%eax
  8008d4:	78 10                	js     8008e6 <readn+0x48>
			return m;
		if (m == 0)
  8008d6:	85 c0                	test   %eax,%eax
  8008d8:	74 0a                	je     8008e4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008da:	01 c3                	add    %eax,%ebx
  8008dc:	89 d8                	mov    %ebx,%eax
  8008de:	39 f3                	cmp    %esi,%ebx
  8008e0:	72 d9                	jb     8008bb <readn+0x1d>
  8008e2:	eb 02                	jmp    8008e6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8008e4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8008e6:	83 c4 1c             	add    $0x1c,%esp
  8008e9:	5b                   	pop    %ebx
  8008ea:	5e                   	pop    %esi
  8008eb:	5f                   	pop    %edi
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    

008008ee <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	53                   	push   %ebx
  8008f2:	83 ec 24             	sub    $0x24,%esp
  8008f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ff:	89 1c 24             	mov    %ebx,(%esp)
  800902:	e8 47 fc ff ff       	call   80054e <fd_lookup>
  800907:	85 c0                	test   %eax,%eax
  800909:	78 68                	js     800973 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80090b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80090e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	89 04 24             	mov    %eax,(%esp)
  80091a:	e8 80 fc ff ff       	call   80059f <dev_lookup>
  80091f:	85 c0                	test   %eax,%eax
  800921:	78 50                	js     800973 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800926:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80092a:	75 23                	jne    80094f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80092c:	a1 04 40 80 00       	mov    0x804004,%eax
  800931:	8b 40 48             	mov    0x48(%eax),%eax
  800934:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800938:	89 44 24 04          	mov    %eax,0x4(%esp)
  80093c:	c7 04 24 61 22 80 00 	movl   $0x802261,(%esp)
  800943:	e8 53 0a 00 00       	call   80139b <cprintf>
		return -E_INVAL;
  800948:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80094d:	eb 24                	jmp    800973 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80094f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800952:	8b 52 0c             	mov    0xc(%edx),%edx
  800955:	85 d2                	test   %edx,%edx
  800957:	74 15                	je     80096e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800959:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80095c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800960:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800963:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800967:	89 04 24             	mov    %eax,(%esp)
  80096a:	ff d2                	call   *%edx
  80096c:	eb 05                	jmp    800973 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80096e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800973:	83 c4 24             	add    $0x24,%esp
  800976:	5b                   	pop    %ebx
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <seek>:

int
seek(int fdnum, off_t offset)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80097f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800982:	89 44 24 04          	mov    %eax,0x4(%esp)
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	89 04 24             	mov    %eax,(%esp)
  80098c:	e8 bd fb ff ff       	call   80054e <fd_lookup>
  800991:	85 c0                	test   %eax,%eax
  800993:	78 0e                	js     8009a3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800998:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80099e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    

008009a5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	53                   	push   %ebx
  8009a9:	83 ec 24             	sub    $0x24,%esp
  8009ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b6:	89 1c 24             	mov    %ebx,(%esp)
  8009b9:	e8 90 fb ff ff       	call   80054e <fd_lookup>
  8009be:	85 c0                	test   %eax,%eax
  8009c0:	78 61                	js     800a23 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	89 04 24             	mov    %eax,(%esp)
  8009d1:	e8 c9 fb ff ff       	call   80059f <dev_lookup>
  8009d6:	85 c0                	test   %eax,%eax
  8009d8:	78 49                	js     800a23 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009e1:	75 23                	jne    800a06 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8009e3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009e8:	8b 40 48             	mov    0x48(%eax),%eax
  8009eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f3:	c7 04 24 24 22 80 00 	movl   $0x802224,(%esp)
  8009fa:	e8 9c 09 00 00       	call   80139b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a04:	eb 1d                	jmp    800a23 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  800a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a09:	8b 52 18             	mov    0x18(%edx),%edx
  800a0c:	85 d2                	test   %edx,%edx
  800a0e:	74 0e                	je     800a1e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800a10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a17:	89 04 24             	mov    %eax,(%esp)
  800a1a:	ff d2                	call   *%edx
  800a1c:	eb 05                	jmp    800a23 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800a1e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800a23:	83 c4 24             	add    $0x24,%esp
  800a26:	5b                   	pop    %ebx
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	53                   	push   %ebx
  800a2d:	83 ec 24             	sub    $0x24,%esp
  800a30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a33:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	89 04 24             	mov    %eax,(%esp)
  800a40:	e8 09 fb ff ff       	call   80054e <fd_lookup>
  800a45:	85 c0                	test   %eax,%eax
  800a47:	78 52                	js     800a9b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a53:	8b 00                	mov    (%eax),%eax
  800a55:	89 04 24             	mov    %eax,(%esp)
  800a58:	e8 42 fb ff ff       	call   80059f <dev_lookup>
  800a5d:	85 c0                	test   %eax,%eax
  800a5f:	78 3a                	js     800a9b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  800a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a64:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a68:	74 2c                	je     800a96 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a6a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a6d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a74:	00 00 00 
	stat->st_isdir = 0;
  800a77:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a7e:	00 00 00 
	stat->st_dev = dev;
  800a81:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a87:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a8e:	89 14 24             	mov    %edx,(%esp)
  800a91:	ff 50 14             	call   *0x14(%eax)
  800a94:	eb 05                	jmp    800a9b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a96:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a9b:	83 c4 24             	add    $0x24,%esp
  800a9e:	5b                   	pop    %ebx
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 18             	sub    $0x18,%esp
  800aa7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800aaa:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800aad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800ab4:	00 
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	89 04 24             	mov    %eax,(%esp)
  800abb:	e8 bc 01 00 00       	call   800c7c <open>
  800ac0:	89 c3                	mov    %eax,%ebx
  800ac2:	85 c0                	test   %eax,%eax
  800ac4:	78 1b                	js     800ae1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800acd:	89 1c 24             	mov    %ebx,(%esp)
  800ad0:	e8 54 ff ff ff       	call   800a29 <fstat>
  800ad5:	89 c6                	mov    %eax,%esi
	close(fd);
  800ad7:	89 1c 24             	mov    %ebx,(%esp)
  800ada:	e8 be fb ff ff       	call   80069d <close>
	return r;
  800adf:	89 f3                	mov    %esi,%ebx
}
  800ae1:	89 d8                	mov    %ebx,%eax
  800ae3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800ae6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800ae9:	89 ec                	mov    %ebp,%esp
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    
  800aed:	00 00                	add    %al,(%eax)
	...

00800af0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 18             	sub    $0x18,%esp
  800af6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800af9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800afc:	89 c3                	mov    %eax,%ebx
  800afe:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  800b00:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800b07:	75 11                	jne    800b1a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800b09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800b10:	e8 61 13 00 00       	call   801e76 <ipc_find_env>
  800b15:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800b1a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800b21:	00 
  800b22:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800b29:	00 
  800b2a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b2e:	a1 00 40 80 00       	mov    0x804000,%eax
  800b33:	89 04 24             	mov    %eax,(%esp)
  800b36:	e8 b7 12 00 00       	call   801df2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800b3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b42:	00 
  800b43:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b4e:	e8 4d 12 00 00       	call   801da0 <ipc_recv>
}
  800b53:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800b56:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800b59:	89 ec                	mov    %ebp,%esp
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	53                   	push   %ebx
  800b61:	83 ec 14             	sub    $0x14,%esp
  800b64:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	8b 40 0c             	mov    0xc(%eax),%eax
  800b6d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b72:	ba 00 00 00 00       	mov    $0x0,%edx
  800b77:	b8 05 00 00 00       	mov    $0x5,%eax
  800b7c:	e8 6f ff ff ff       	call   800af0 <fsipc>
  800b81:	85 c0                	test   %eax,%eax
  800b83:	78 2b                	js     800bb0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b85:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800b8c:	00 
  800b8d:	89 1c 24             	mov    %ebx,(%esp)
  800b90:	e8 26 0e 00 00       	call   8019bb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b95:	a1 80 50 80 00       	mov    0x805080,%eax
  800b9a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800ba0:	a1 84 50 80 00       	mov    0x805084,%eax
  800ba5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb0:	83 c4 14             	add    $0x14,%esp
  800bb3:	5b                   	pop    %ebx
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 40 0c             	mov    0xc(%eax),%eax
  800bc2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcc:	b8 06 00 00 00       	mov    $0x6,%eax
  800bd1:	e8 1a ff ff ff       	call   800af0 <fsipc>
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
  800bdd:	83 ec 10             	sub    $0x10,%esp
  800be0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8b 40 0c             	mov    0xc(%eax),%eax
  800be9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800bee:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800bf4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfe:	e8 ed fe ff ff       	call   800af0 <fsipc>
  800c03:	89 c3                	mov    %eax,%ebx
  800c05:	85 c0                	test   %eax,%eax
  800c07:	78 6a                	js     800c73 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800c09:	39 c6                	cmp    %eax,%esi
  800c0b:	73 24                	jae    800c31 <devfile_read+0x59>
  800c0d:	c7 44 24 0c 90 22 80 	movl   $0x802290,0xc(%esp)
  800c14:	00 
  800c15:	c7 44 24 08 97 22 80 	movl   $0x802297,0x8(%esp)
  800c1c:	00 
  800c1d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800c24:	00 
  800c25:	c7 04 24 ac 22 80 00 	movl   $0x8022ac,(%esp)
  800c2c:	e8 6f 06 00 00       	call   8012a0 <_panic>
	assert(r <= PGSIZE);
  800c31:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c36:	7e 24                	jle    800c5c <devfile_read+0x84>
  800c38:	c7 44 24 0c b7 22 80 	movl   $0x8022b7,0xc(%esp)
  800c3f:	00 
  800c40:	c7 44 24 08 97 22 80 	movl   $0x802297,0x8(%esp)
  800c47:	00 
  800c48:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800c4f:	00 
  800c50:	c7 04 24 ac 22 80 00 	movl   $0x8022ac,(%esp)
  800c57:	e8 44 06 00 00       	call   8012a0 <_panic>
	memmove(buf, &fsipcbuf, r);
  800c5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c60:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c67:	00 
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	89 04 24             	mov    %eax,(%esp)
  800c6e:	e8 39 0f 00 00       	call   801bac <memmove>
	return r;
}
  800c73:	89 d8                	mov    %ebx,%eax
  800c75:	83 c4 10             	add    $0x10,%esp
  800c78:	5b                   	pop    %ebx
  800c79:	5e                   	pop    %esi
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    

00800c7c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	56                   	push   %esi
  800c80:	53                   	push   %ebx
  800c81:	83 ec 20             	sub    $0x20,%esp
  800c84:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800c87:	89 34 24             	mov    %esi,(%esp)
  800c8a:	e8 e1 0c 00 00       	call   801970 <strlen>
		return -E_BAD_PATH;
  800c8f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800c94:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c99:	7f 5e                	jg     800cf9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800c9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c9e:	89 04 24             	mov    %eax,(%esp)
  800ca1:	e8 35 f8 ff ff       	call   8004db <fd_alloc>
  800ca6:	89 c3                	mov    %eax,%ebx
  800ca8:	85 c0                	test   %eax,%eax
  800caa:	78 4d                	js     800cf9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800cac:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cb0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800cb7:	e8 ff 0c 00 00       	call   8019bb <strcpy>
	fsipcbuf.open.req_omode = mode;
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc7:	b8 01 00 00 00       	mov    $0x1,%eax
  800ccc:	e8 1f fe ff ff       	call   800af0 <fsipc>
  800cd1:	89 c3                	mov    %eax,%ebx
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	79 15                	jns    800cec <open+0x70>
		fd_close(fd, 0);
  800cd7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800cde:	00 
  800cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ce2:	89 04 24             	mov    %eax,(%esp)
  800ce5:	e8 21 f9 ff ff       	call   80060b <fd_close>
		return r;
  800cea:	eb 0d                	jmp    800cf9 <open+0x7d>
	}

	return fd2num(fd);
  800cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cef:	89 04 24             	mov    %eax,(%esp)
  800cf2:	e8 b9 f7 ff ff       	call   8004b0 <fd2num>
  800cf7:	89 c3                	mov    %eax,%ebx
}
  800cf9:	89 d8                	mov    %ebx,%eax
  800cfb:	83 c4 20             	add    $0x20,%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    
	...

00800d10 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	83 ec 18             	sub    $0x18,%esp
  800d16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800d19:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800d1c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	89 04 24             	mov    %eax,(%esp)
  800d25:	e8 96 f7 ff ff       	call   8004c0 <fd2data>
  800d2a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  800d2c:	c7 44 24 04 c3 22 80 	movl   $0x8022c3,0x4(%esp)
  800d33:	00 
  800d34:	89 34 24             	mov    %esi,(%esp)
  800d37:	e8 7f 0c 00 00       	call   8019bb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800d3c:	8b 43 04             	mov    0x4(%ebx),%eax
  800d3f:	2b 03                	sub    (%ebx),%eax
  800d41:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  800d47:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  800d4e:	00 00 00 
	stat->st_dev = &devpipe;
  800d51:	c7 86 88 00 00 00 24 	movl   $0x803024,0x88(%esi)
  800d58:	30 80 00 
	return 0;
}
  800d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d60:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800d63:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800d66:	89 ec                	mov    %ebp,%esp
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 14             	sub    $0x14,%esp
  800d71:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800d74:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d7f:	e8 15 f5 ff ff       	call   800299 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800d84:	89 1c 24             	mov    %ebx,(%esp)
  800d87:	e8 34 f7 ff ff       	call   8004c0 <fd2data>
  800d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d97:	e8 fd f4 ff ff       	call   800299 <sys_page_unmap>
}
  800d9c:	83 c4 14             	add    $0x14,%esp
  800d9f:	5b                   	pop    %ebx
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
  800da8:	83 ec 2c             	sub    $0x2c,%esp
  800dab:	89 c7                	mov    %eax,%edi
  800dad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800db0:	a1 04 40 80 00       	mov    0x804004,%eax
  800db5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800db8:	89 3c 24             	mov    %edi,(%esp)
  800dbb:	e8 00 11 00 00       	call   801ec0 <pageref>
  800dc0:	89 c6                	mov    %eax,%esi
  800dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800dc5:	89 04 24             	mov    %eax,(%esp)
  800dc8:	e8 f3 10 00 00       	call   801ec0 <pageref>
  800dcd:	39 c6                	cmp    %eax,%esi
  800dcf:	0f 94 c0             	sete   %al
  800dd2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  800dd5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800ddb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800dde:	39 cb                	cmp    %ecx,%ebx
  800de0:	75 08                	jne    800dea <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  800de2:	83 c4 2c             	add    $0x2c,%esp
  800de5:	5b                   	pop    %ebx
  800de6:	5e                   	pop    %esi
  800de7:	5f                   	pop    %edi
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  800dea:	83 f8 01             	cmp    $0x1,%eax
  800ded:	75 c1                	jne    800db0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800def:	8b 52 58             	mov    0x58(%edx),%edx
  800df2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800df6:	89 54 24 08          	mov    %edx,0x8(%esp)
  800dfa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800dfe:	c7 04 24 ca 22 80 00 	movl   $0x8022ca,(%esp)
  800e05:	e8 91 05 00 00       	call   80139b <cprintf>
  800e0a:	eb a4                	jmp    800db0 <_pipeisclosed+0xe>

00800e0c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	57                   	push   %edi
  800e10:	56                   	push   %esi
  800e11:	53                   	push   %ebx
  800e12:	83 ec 2c             	sub    $0x2c,%esp
  800e15:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800e18:	89 34 24             	mov    %esi,(%esp)
  800e1b:	e8 a0 f6 ff ff       	call   8004c0 <fd2data>
  800e20:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e22:	bf 00 00 00 00       	mov    $0x0,%edi
  800e27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2b:	75 50                	jne    800e7d <devpipe_write+0x71>
  800e2d:	eb 5c                	jmp    800e8b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800e2f:	89 da                	mov    %ebx,%edx
  800e31:	89 f0                	mov    %esi,%eax
  800e33:	e8 6a ff ff ff       	call   800da2 <_pipeisclosed>
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	75 53                	jne    800e8f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800e3c:	e8 6b f3 ff ff       	call   8001ac <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e41:	8b 43 04             	mov    0x4(%ebx),%eax
  800e44:	8b 13                	mov    (%ebx),%edx
  800e46:	83 c2 20             	add    $0x20,%edx
  800e49:	39 d0                	cmp    %edx,%eax
  800e4b:	73 e2                	jae    800e2f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e50:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  800e54:	88 55 e7             	mov    %dl,-0x19(%ebp)
  800e57:	89 c2                	mov    %eax,%edx
  800e59:	c1 fa 1f             	sar    $0x1f,%edx
  800e5c:	c1 ea 1b             	shr    $0x1b,%edx
  800e5f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800e62:	83 e1 1f             	and    $0x1f,%ecx
  800e65:	29 d1                	sub    %edx,%ecx
  800e67:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800e6b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800e6f:	83 c0 01             	add    $0x1,%eax
  800e72:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e75:	83 c7 01             	add    $0x1,%edi
  800e78:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800e7b:	74 0e                	je     800e8b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e7d:	8b 43 04             	mov    0x4(%ebx),%eax
  800e80:	8b 13                	mov    (%ebx),%edx
  800e82:	83 c2 20             	add    $0x20,%edx
  800e85:	39 d0                	cmp    %edx,%eax
  800e87:	73 a6                	jae    800e2f <devpipe_write+0x23>
  800e89:	eb c2                	jmp    800e4d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800e8b:	89 f8                	mov    %edi,%eax
  800e8d:	eb 05                	jmp    800e94 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e8f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800e94:	83 c4 2c             	add    $0x2c,%esp
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 28             	sub    $0x28,%esp
  800ea2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800eab:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800eae:	89 3c 24             	mov    %edi,(%esp)
  800eb1:	e8 0a f6 ff ff       	call   8004c0 <fd2data>
  800eb6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800eb8:	be 00 00 00 00       	mov    $0x0,%esi
  800ebd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec1:	75 47                	jne    800f0a <devpipe_read+0x6e>
  800ec3:	eb 52                	jmp    800f17 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800ec5:	89 f0                	mov    %esi,%eax
  800ec7:	eb 5e                	jmp    800f27 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800ec9:	89 da                	mov    %ebx,%edx
  800ecb:	89 f8                	mov    %edi,%eax
  800ecd:	8d 76 00             	lea    0x0(%esi),%esi
  800ed0:	e8 cd fe ff ff       	call   800da2 <_pipeisclosed>
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 49                	jne    800f22 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800ed9:	e8 ce f2 ff ff       	call   8001ac <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800ede:	8b 03                	mov    (%ebx),%eax
  800ee0:	3b 43 04             	cmp    0x4(%ebx),%eax
  800ee3:	74 e4                	je     800ec9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800ee5:	89 c2                	mov    %eax,%edx
  800ee7:	c1 fa 1f             	sar    $0x1f,%edx
  800eea:	c1 ea 1b             	shr    $0x1b,%edx
  800eed:	01 d0                	add    %edx,%eax
  800eef:	83 e0 1f             	and    $0x1f,%eax
  800ef2:	29 d0                	sub    %edx,%eax
  800ef4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  800eff:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800f02:	83 c6 01             	add    $0x1,%esi
  800f05:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f08:	74 0d                	je     800f17 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  800f0a:	8b 03                	mov    (%ebx),%eax
  800f0c:	3b 43 04             	cmp    0x4(%ebx),%eax
  800f0f:	75 d4                	jne    800ee5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800f11:	85 f6                	test   %esi,%esi
  800f13:	75 b0                	jne    800ec5 <devpipe_read+0x29>
  800f15:	eb b2                	jmp    800ec9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800f17:	89 f0                	mov    %esi,%eax
  800f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f20:	eb 05                	jmp    800f27 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800f22:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800f27:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f2a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f2d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f30:	89 ec                	mov    %ebp,%esp
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    

00800f34 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 48             	sub    $0x48,%esp
  800f3a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f3d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f40:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800f43:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800f46:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f49:	89 04 24             	mov    %eax,(%esp)
  800f4c:	e8 8a f5 ff ff       	call   8004db <fd_alloc>
  800f51:	89 c3                	mov    %eax,%ebx
  800f53:	85 c0                	test   %eax,%eax
  800f55:	0f 88 45 01 00 00    	js     8010a0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f5b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f62:	00 
  800f63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f66:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f71:	e8 66 f2 ff ff       	call   8001dc <sys_page_alloc>
  800f76:	89 c3                	mov    %eax,%ebx
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	0f 88 20 01 00 00    	js     8010a0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800f80:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f83:	89 04 24             	mov    %eax,(%esp)
  800f86:	e8 50 f5 ff ff       	call   8004db <fd_alloc>
  800f8b:	89 c3                	mov    %eax,%ebx
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	0f 88 f8 00 00 00    	js     80108d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f95:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f9c:	00 
  800f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fa4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fab:	e8 2c f2 ff ff       	call   8001dc <sys_page_alloc>
  800fb0:	89 c3                	mov    %eax,%ebx
  800fb2:	85 c0                	test   %eax,%eax
  800fb4:	0f 88 d3 00 00 00    	js     80108d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800fba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fbd:	89 04 24             	mov    %eax,(%esp)
  800fc0:	e8 fb f4 ff ff       	call   8004c0 <fd2data>
  800fc5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800fc7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800fce:	00 
  800fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fd3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fda:	e8 fd f1 ff ff       	call   8001dc <sys_page_alloc>
  800fdf:	89 c3                	mov    %eax,%ebx
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	0f 88 91 00 00 00    	js     80107a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800fe9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fec:	89 04 24             	mov    %eax,(%esp)
  800fef:	e8 cc f4 ff ff       	call   8004c0 <fd2data>
  800ff4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  800ffb:	00 
  800ffc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801000:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801007:	00 
  801008:	89 74 24 04          	mov    %esi,0x4(%esp)
  80100c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801013:	e8 23 f2 ff ff       	call   80023b <sys_page_map>
  801018:	89 c3                	mov    %eax,%ebx
  80101a:	85 c0                	test   %eax,%eax
  80101c:	78 4c                	js     80106a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80101e:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801024:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801027:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80102c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801033:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801039:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80103c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801041:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80104b:	89 04 24             	mov    %eax,(%esp)
  80104e:	e8 5d f4 ff ff       	call   8004b0 <fd2num>
  801053:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801055:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801058:	89 04 24             	mov    %eax,(%esp)
  80105b:	e8 50 f4 ff ff       	call   8004b0 <fd2num>
  801060:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801063:	bb 00 00 00 00       	mov    $0x0,%ebx
  801068:	eb 36                	jmp    8010a0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80106a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80106e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801075:	e8 1f f2 ff ff       	call   800299 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80107a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80107d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801081:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801088:	e8 0c f2 ff ff       	call   800299 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80108d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801090:	89 44 24 04          	mov    %eax,0x4(%esp)
  801094:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80109b:	e8 f9 f1 ff ff       	call   800299 <sys_page_unmap>
    err:
	return r;
}
  8010a0:	89 d8                	mov    %ebx,%eax
  8010a2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010a8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ab:	89 ec                	mov    %ebp,%esp
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	89 04 24             	mov    %eax,(%esp)
  8010c2:	e8 87 f4 ff ff       	call   80054e <fd_lookup>
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	78 15                	js     8010e0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8010cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ce:	89 04 24             	mov    %eax,(%esp)
  8010d1:	e8 ea f3 ff ff       	call   8004c0 <fd2data>
	return _pipeisclosed(fd, p);
  8010d6:	89 c2                	mov    %eax,%edx
  8010d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010db:	e8 c2 fc ff ff       	call   800da2 <_pipeisclosed>
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    
	...

008010f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8010f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f8:	5d                   	pop    %ebp
  8010f9:	c3                   	ret    

008010fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801100:	c7 44 24 04 e2 22 80 	movl   $0x8022e2,0x4(%esp)
  801107:	00 
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	89 04 24             	mov    %eax,(%esp)
  80110e:	e8 a8 08 00 00       	call   8019bb <strcpy>
	return 0;
}
  801113:	b8 00 00 00 00       	mov    $0x0,%eax
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	57                   	push   %edi
  80111e:	56                   	push   %esi
  80111f:	53                   	push   %ebx
  801120:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801126:	be 00 00 00 00       	mov    $0x0,%esi
  80112b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112f:	74 43                	je     801174 <devcons_write+0x5a>
  801131:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801136:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80113c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80113f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801141:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801144:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801149:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80114c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801150:	03 45 0c             	add    0xc(%ebp),%eax
  801153:	89 44 24 04          	mov    %eax,0x4(%esp)
  801157:	89 3c 24             	mov    %edi,(%esp)
  80115a:	e8 4d 0a 00 00       	call   801bac <memmove>
		sys_cputs(buf, m);
  80115f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801163:	89 3c 24             	mov    %edi,(%esp)
  801166:	e8 55 ef ff ff       	call   8000c0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80116b:	01 de                	add    %ebx,%esi
  80116d:	89 f0                	mov    %esi,%eax
  80116f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801172:	72 c8                	jb     80113c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801174:	89 f0                	mov    %esi,%eax
  801176:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80117c:	5b                   	pop    %ebx
  80117d:	5e                   	pop    %esi
  80117e:	5f                   	pop    %edi
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    

00801181 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
  801184:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801187:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80118c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801190:	75 07                	jne    801199 <devcons_read+0x18>
  801192:	eb 31                	jmp    8011c5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801194:	e8 13 f0 ff ff       	call   8001ac <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011a0:	e8 4a ef ff ff       	call   8000ef <sys_cgetc>
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	74 eb                	je     801194 <devcons_read+0x13>
  8011a9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	78 16                	js     8011c5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8011af:	83 f8 04             	cmp    $0x4,%eax
  8011b2:	74 0c                	je     8011c0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	88 10                	mov    %dl,(%eax)
	return 1;
  8011b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8011be:	eb 05                	jmp    8011c5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8011d3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011da:	00 
  8011db:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8011de:	89 04 24             	mov    %eax,(%esp)
  8011e1:	e8 da ee ff ff       	call   8000c0 <sys_cputs>
}
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <getchar>:

int
getchar(void)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8011ee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8011f5:	00 
  8011f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8011f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801204:	e8 05 f6 ff ff       	call   80080e <read>
	if (r < 0)
  801209:	85 c0                	test   %eax,%eax
  80120b:	78 0f                	js     80121c <getchar+0x34>
		return r;
	if (r < 1)
  80120d:	85 c0                	test   %eax,%eax
  80120f:	7e 06                	jle    801217 <getchar+0x2f>
		return -E_EOF;
	return c;
  801211:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801215:	eb 05                	jmp    80121c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801217:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    

0080121e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801224:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801227:	89 44 24 04          	mov    %eax,0x4(%esp)
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	89 04 24             	mov    %eax,(%esp)
  801231:	e8 18 f3 ff ff       	call   80054e <fd_lookup>
  801236:	85 c0                	test   %eax,%eax
  801238:	78 11                	js     80124b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80123a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123d:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801243:	39 10                	cmp    %edx,(%eax)
  801245:	0f 94 c0             	sete   %al
  801248:	0f b6 c0             	movzbl %al,%eax
}
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    

0080124d <opencons>:

int
opencons(void)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801253:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801256:	89 04 24             	mov    %eax,(%esp)
  801259:	e8 7d f2 ff ff       	call   8004db <fd_alloc>
  80125e:	85 c0                	test   %eax,%eax
  801260:	78 3c                	js     80129e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801262:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801269:	00 
  80126a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801271:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801278:	e8 5f ef ff ff       	call   8001dc <sys_page_alloc>
  80127d:	85 c0                	test   %eax,%eax
  80127f:	78 1d                	js     80129e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801281:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801296:	89 04 24             	mov    %eax,(%esp)
  801299:	e8 12 f2 ff ff       	call   8004b0 <fd2num>
}
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	56                   	push   %esi
  8012a4:	53                   	push   %ebx
  8012a5:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8012a8:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8012ab:	8b 1d 04 30 80 00    	mov    0x803004,%ebx
  8012b1:	e8 c6 ee ff ff       	call   80017c <sys_getenvid>
  8012b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cc:	c7 04 24 f0 22 80 00 	movl   $0x8022f0,(%esp)
  8012d3:	e8 c3 00 00 00       	call   80139b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012df:	89 04 24             	mov    %eax,(%esp)
  8012e2:	e8 53 00 00 00       	call   80133a <vcprintf>
	cprintf("\n");
  8012e7:	c7 04 24 db 22 80 00 	movl   $0x8022db,(%esp)
  8012ee:	e8 a8 00 00 00       	call   80139b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8012f3:	cc                   	int3   
  8012f4:	eb fd                	jmp    8012f3 <_panic+0x53>
	...

008012f8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	53                   	push   %ebx
  8012fc:	83 ec 14             	sub    $0x14,%esp
  8012ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801302:	8b 03                	mov    (%ebx),%eax
  801304:	8b 55 08             	mov    0x8(%ebp),%edx
  801307:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80130b:	83 c0 01             	add    $0x1,%eax
  80130e:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801310:	3d ff 00 00 00       	cmp    $0xff,%eax
  801315:	75 19                	jne    801330 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801317:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80131e:	00 
  80131f:	8d 43 08             	lea    0x8(%ebx),%eax
  801322:	89 04 24             	mov    %eax,(%esp)
  801325:	e8 96 ed ff ff       	call   8000c0 <sys_cputs>
		b->idx = 0;
  80132a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801330:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801334:	83 c4 14             	add    $0x14,%esp
  801337:	5b                   	pop    %ebx
  801338:	5d                   	pop    %ebp
  801339:	c3                   	ret    

0080133a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801343:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80134a:	00 00 00 
	b.cnt = 0;
  80134d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801354:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	89 44 24 08          	mov    %eax,0x8(%esp)
  801365:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80136b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136f:	c7 04 24 f8 12 80 00 	movl   $0x8012f8,(%esp)
  801376:	e8 9f 01 00 00       	call   80151a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80137b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801381:	89 44 24 04          	mov    %eax,0x4(%esp)
  801385:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80138b:	89 04 24             	mov    %eax,(%esp)
  80138e:	e8 2d ed ff ff       	call   8000c0 <sys_cputs>

	return b.cnt;
}
  801393:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8013a1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8013a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	89 04 24             	mov    %eax,(%esp)
  8013ae:	e8 87 ff ff ff       	call   80133a <vcprintf>
	va_end(ap);

	return cnt;
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    
	...

008013c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	57                   	push   %edi
  8013c4:	56                   	push   %esi
  8013c5:	53                   	push   %ebx
  8013c6:	83 ec 3c             	sub    $0x3c,%esp
  8013c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013cc:	89 d7                	mov    %edx,%edi
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013dd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8013e8:	72 11                	jb     8013fb <printnum+0x3b>
  8013ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ed:	39 45 10             	cmp    %eax,0x10(%ebp)
  8013f0:	76 09                	jbe    8013fb <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8013f2:	83 eb 01             	sub    $0x1,%ebx
  8013f5:	85 db                	test   %ebx,%ebx
  8013f7:	7f 51                	jg     80144a <printnum+0x8a>
  8013f9:	eb 5e                	jmp    801459 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8013fb:	89 74 24 10          	mov    %esi,0x10(%esp)
  8013ff:	83 eb 01             	sub    $0x1,%ebx
  801402:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	89 44 24 08          	mov    %eax,0x8(%esp)
  80140d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  801411:	8b 74 24 0c          	mov    0xc(%esp),%esi
  801415:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80141c:	00 
  80141d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801420:	89 04 24             	mov    %eax,(%esp)
  801423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801426:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142a:	e8 d1 0a 00 00       	call   801f00 <__udivdi3>
  80142f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801433:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801437:	89 04 24             	mov    %eax,(%esp)
  80143a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80143e:	89 fa                	mov    %edi,%edx
  801440:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801443:	e8 78 ff ff ff       	call   8013c0 <printnum>
  801448:	eb 0f                	jmp    801459 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80144a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80144e:	89 34 24             	mov    %esi,(%esp)
  801451:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801454:	83 eb 01             	sub    $0x1,%ebx
  801457:	75 f1                	jne    80144a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801459:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80145d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801461:	8b 45 10             	mov    0x10(%ebp),%eax
  801464:	89 44 24 08          	mov    %eax,0x8(%esp)
  801468:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80146f:	00 
  801470:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801473:	89 04 24             	mov    %eax,(%esp)
  801476:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147d:	e8 ae 0b 00 00       	call   802030 <__umoddi3>
  801482:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801486:	0f be 80 13 23 80 00 	movsbl 0x802313(%eax),%eax
  80148d:	89 04 24             	mov    %eax,(%esp)
  801490:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801493:	83 c4 3c             	add    $0x3c,%esp
  801496:	5b                   	pop    %ebx
  801497:	5e                   	pop    %esi
  801498:	5f                   	pop    %edi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80149e:	83 fa 01             	cmp    $0x1,%edx
  8014a1:	7e 0e                	jle    8014b1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8014a3:	8b 10                	mov    (%eax),%edx
  8014a5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8014a8:	89 08                	mov    %ecx,(%eax)
  8014aa:	8b 02                	mov    (%edx),%eax
  8014ac:	8b 52 04             	mov    0x4(%edx),%edx
  8014af:	eb 22                	jmp    8014d3 <getuint+0x38>
	else if (lflag)
  8014b1:	85 d2                	test   %edx,%edx
  8014b3:	74 10                	je     8014c5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8014b5:	8b 10                	mov    (%eax),%edx
  8014b7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8014ba:	89 08                	mov    %ecx,(%eax)
  8014bc:	8b 02                	mov    (%edx),%eax
  8014be:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c3:	eb 0e                	jmp    8014d3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8014c5:	8b 10                	mov    (%eax),%edx
  8014c7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8014ca:	89 08                	mov    %ecx,(%eax)
  8014cc:	8b 02                	mov    (%edx),%eax
  8014ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    

008014d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8014db:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8014df:	8b 10                	mov    (%eax),%edx
  8014e1:	3b 50 04             	cmp    0x4(%eax),%edx
  8014e4:	73 0a                	jae    8014f0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8014e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e9:	88 0a                	mov    %cl,(%edx)
  8014eb:	83 c2 01             	add    $0x1,%edx
  8014ee:	89 10                	mov    %edx,(%eax)
}
  8014f0:	5d                   	pop    %ebp
  8014f1:	c3                   	ret    

008014f2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014f8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8014fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801502:	89 44 24 08          	mov    %eax,0x8(%esp)
  801506:	8b 45 0c             	mov    0xc(%ebp),%eax
  801509:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	89 04 24             	mov    %eax,(%esp)
  801513:	e8 02 00 00 00       	call   80151a <vprintfmt>
	va_end(ap);
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	57                   	push   %edi
  80151e:	56                   	push   %esi
  80151f:	53                   	push   %ebx
  801520:	83 ec 4c             	sub    $0x4c,%esp
  801523:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801526:	8b 75 10             	mov    0x10(%ebp),%esi
  801529:	eb 12                	jmp    80153d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80152b:	85 c0                	test   %eax,%eax
  80152d:	0f 84 a9 03 00 00    	je     8018dc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  801533:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801537:	89 04 24             	mov    %eax,(%esp)
  80153a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80153d:	0f b6 06             	movzbl (%esi),%eax
  801540:	83 c6 01             	add    $0x1,%esi
  801543:	83 f8 25             	cmp    $0x25,%eax
  801546:	75 e3                	jne    80152b <vprintfmt+0x11>
  801548:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80154c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801553:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  801558:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80155f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801564:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801567:	eb 2b                	jmp    801594 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801569:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80156c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801570:	eb 22                	jmp    801594 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801572:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801575:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801579:	eb 19                	jmp    801594 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80157b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80157e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801585:	eb 0d                	jmp    801594 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801587:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80158a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80158d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801594:	0f b6 06             	movzbl (%esi),%eax
  801597:	0f b6 d0             	movzbl %al,%edx
  80159a:	8d 7e 01             	lea    0x1(%esi),%edi
  80159d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8015a0:	83 e8 23             	sub    $0x23,%eax
  8015a3:	3c 55                	cmp    $0x55,%al
  8015a5:	0f 87 0b 03 00 00    	ja     8018b6 <vprintfmt+0x39c>
  8015ab:	0f b6 c0             	movzbl %al,%eax
  8015ae:	ff 24 85 60 24 80 00 	jmp    *0x802460(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8015b5:	83 ea 30             	sub    $0x30,%edx
  8015b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8015bb:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8015bf:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015c2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8015c5:	83 fa 09             	cmp    $0x9,%edx
  8015c8:	77 4a                	ja     801614 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015ca:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8015cd:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8015d0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8015d3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8015d7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8015da:	8d 50 d0             	lea    -0x30(%eax),%edx
  8015dd:	83 fa 09             	cmp    $0x9,%edx
  8015e0:	76 eb                	jbe    8015cd <vprintfmt+0xb3>
  8015e2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8015e5:	eb 2d                	jmp    801614 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8015e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ea:	8d 50 04             	lea    0x4(%eax),%edx
  8015ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8015f0:	8b 00                	mov    (%eax),%eax
  8015f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015f5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8015f8:	eb 1a                	jmp    801614 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015fa:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  8015fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801601:	79 91                	jns    801594 <vprintfmt+0x7a>
  801603:	e9 73 ff ff ff       	jmp    80157b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801608:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80160b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801612:	eb 80                	jmp    801594 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  801614:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801618:	0f 89 76 ff ff ff    	jns    801594 <vprintfmt+0x7a>
  80161e:	e9 64 ff ff ff       	jmp    801587 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801623:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801626:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801629:	e9 66 ff ff ff       	jmp    801594 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80162e:	8b 45 14             	mov    0x14(%ebp),%eax
  801631:	8d 50 04             	lea    0x4(%eax),%edx
  801634:	89 55 14             	mov    %edx,0x14(%ebp)
  801637:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80163b:	8b 00                	mov    (%eax),%eax
  80163d:	89 04 24             	mov    %eax,(%esp)
  801640:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801643:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801646:	e9 f2 fe ff ff       	jmp    80153d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80164b:	8b 45 14             	mov    0x14(%ebp),%eax
  80164e:	8d 50 04             	lea    0x4(%eax),%edx
  801651:	89 55 14             	mov    %edx,0x14(%ebp)
  801654:	8b 00                	mov    (%eax),%eax
  801656:	89 c2                	mov    %eax,%edx
  801658:	c1 fa 1f             	sar    $0x1f,%edx
  80165b:	31 d0                	xor    %edx,%eax
  80165d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80165f:	83 f8 0f             	cmp    $0xf,%eax
  801662:	7f 0b                	jg     80166f <vprintfmt+0x155>
  801664:	8b 14 85 c0 25 80 00 	mov    0x8025c0(,%eax,4),%edx
  80166b:	85 d2                	test   %edx,%edx
  80166d:	75 23                	jne    801692 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80166f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801673:	c7 44 24 08 2b 23 80 	movl   $0x80232b,0x8(%esp)
  80167a:	00 
  80167b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80167f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801682:	89 3c 24             	mov    %edi,(%esp)
  801685:	e8 68 fe ff ff       	call   8014f2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80168a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80168d:	e9 ab fe ff ff       	jmp    80153d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  801692:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801696:	c7 44 24 08 a9 22 80 	movl   $0x8022a9,0x8(%esp)
  80169d:	00 
  80169e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016a5:	89 3c 24             	mov    %edi,(%esp)
  8016a8:	e8 45 fe ff ff       	call   8014f2 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016ad:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8016b0:	e9 88 fe ff ff       	jmp    80153d <vprintfmt+0x23>
  8016b5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8016b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8016be:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c1:	8d 50 04             	lea    0x4(%eax),%edx
  8016c4:	89 55 14             	mov    %edx,0x14(%ebp)
  8016c7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8016c9:	85 f6                	test   %esi,%esi
  8016cb:	ba 24 23 80 00       	mov    $0x802324,%edx
  8016d0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8016d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8016d7:	7e 06                	jle    8016df <vprintfmt+0x1c5>
  8016d9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8016dd:	75 10                	jne    8016ef <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016df:	0f be 06             	movsbl (%esi),%eax
  8016e2:	83 c6 01             	add    $0x1,%esi
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	0f 85 86 00 00 00    	jne    801773 <vprintfmt+0x259>
  8016ed:	eb 76                	jmp    801765 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8016ef:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016f3:	89 34 24             	mov    %esi,(%esp)
  8016f6:	e8 90 02 00 00       	call   80198b <strnlen>
  8016fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8016fe:	29 c2                	sub    %eax,%edx
  801700:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801703:	85 d2                	test   %edx,%edx
  801705:	7e d8                	jle    8016df <vprintfmt+0x1c5>
					putch(padc, putdat);
  801707:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80170b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80170e:	89 d6                	mov    %edx,%esi
  801710:	89 7d d0             	mov    %edi,-0x30(%ebp)
  801713:	89 c7                	mov    %eax,%edi
  801715:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801719:	89 3c 24             	mov    %edi,(%esp)
  80171c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80171f:	83 ee 01             	sub    $0x1,%esi
  801722:	75 f1                	jne    801715 <vprintfmt+0x1fb>
  801724:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801727:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80172a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80172d:	eb b0                	jmp    8016df <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80172f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801733:	74 18                	je     80174d <vprintfmt+0x233>
  801735:	8d 50 e0             	lea    -0x20(%eax),%edx
  801738:	83 fa 5e             	cmp    $0x5e,%edx
  80173b:	76 10                	jbe    80174d <vprintfmt+0x233>
					putch('?', putdat);
  80173d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801741:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801748:	ff 55 08             	call   *0x8(%ebp)
  80174b:	eb 0a                	jmp    801757 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80174d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801751:	89 04 24             	mov    %eax,(%esp)
  801754:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801757:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80175b:	0f be 06             	movsbl (%esi),%eax
  80175e:	83 c6 01             	add    $0x1,%esi
  801761:	85 c0                	test   %eax,%eax
  801763:	75 0e                	jne    801773 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801765:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801768:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80176c:	7f 16                	jg     801784 <vprintfmt+0x26a>
  80176e:	e9 ca fd ff ff       	jmp    80153d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801773:	85 ff                	test   %edi,%edi
  801775:	78 b8                	js     80172f <vprintfmt+0x215>
  801777:	83 ef 01             	sub    $0x1,%edi
  80177a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801780:	79 ad                	jns    80172f <vprintfmt+0x215>
  801782:	eb e1                	jmp    801765 <vprintfmt+0x24b>
  801784:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801787:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80178a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80178e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801795:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801797:	83 ee 01             	sub    $0x1,%esi
  80179a:	75 ee                	jne    80178a <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80179c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80179f:	e9 99 fd ff ff       	jmp    80153d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8017a4:	83 f9 01             	cmp    $0x1,%ecx
  8017a7:	7e 10                	jle    8017b9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  8017a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ac:	8d 50 08             	lea    0x8(%eax),%edx
  8017af:	89 55 14             	mov    %edx,0x14(%ebp)
  8017b2:	8b 30                	mov    (%eax),%esi
  8017b4:	8b 78 04             	mov    0x4(%eax),%edi
  8017b7:	eb 26                	jmp    8017df <vprintfmt+0x2c5>
	else if (lflag)
  8017b9:	85 c9                	test   %ecx,%ecx
  8017bb:	74 12                	je     8017cf <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8017bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c0:	8d 50 04             	lea    0x4(%eax),%edx
  8017c3:	89 55 14             	mov    %edx,0x14(%ebp)
  8017c6:	8b 30                	mov    (%eax),%esi
  8017c8:	89 f7                	mov    %esi,%edi
  8017ca:	c1 ff 1f             	sar    $0x1f,%edi
  8017cd:	eb 10                	jmp    8017df <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8017cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8017d2:	8d 50 04             	lea    0x4(%eax),%edx
  8017d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8017d8:	8b 30                	mov    (%eax),%esi
  8017da:	89 f7                	mov    %esi,%edi
  8017dc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8017df:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8017e4:	85 ff                	test   %edi,%edi
  8017e6:	0f 89 8c 00 00 00    	jns    801878 <vprintfmt+0x35e>
				putch('-', putdat);
  8017ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017f0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8017f7:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8017fa:	f7 de                	neg    %esi
  8017fc:	83 d7 00             	adc    $0x0,%edi
  8017ff:	f7 df                	neg    %edi
			}
			base = 10;
  801801:	b8 0a 00 00 00       	mov    $0xa,%eax
  801806:	eb 70                	jmp    801878 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801808:	89 ca                	mov    %ecx,%edx
  80180a:	8d 45 14             	lea    0x14(%ebp),%eax
  80180d:	e8 89 fc ff ff       	call   80149b <getuint>
  801812:	89 c6                	mov    %eax,%esi
  801814:	89 d7                	mov    %edx,%edi
			base = 10;
  801816:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80181b:	eb 5b                	jmp    801878 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80181d:	89 ca                	mov    %ecx,%edx
  80181f:	8d 45 14             	lea    0x14(%ebp),%eax
  801822:	e8 74 fc ff ff       	call   80149b <getuint>
  801827:	89 c6                	mov    %eax,%esi
  801829:	89 d7                	mov    %edx,%edi
			base = 8;
  80182b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  801830:	eb 46                	jmp    801878 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  801832:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801836:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80183d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801840:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801844:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80184b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80184e:	8b 45 14             	mov    0x14(%ebp),%eax
  801851:	8d 50 04             	lea    0x4(%eax),%edx
  801854:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801857:	8b 30                	mov    (%eax),%esi
  801859:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80185e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  801863:	eb 13                	jmp    801878 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801865:	89 ca                	mov    %ecx,%edx
  801867:	8d 45 14             	lea    0x14(%ebp),%eax
  80186a:	e8 2c fc ff ff       	call   80149b <getuint>
  80186f:	89 c6                	mov    %eax,%esi
  801871:	89 d7                	mov    %edx,%edi
			base = 16;
  801873:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  801878:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80187c:	89 54 24 10          	mov    %edx,0x10(%esp)
  801880:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801883:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801887:	89 44 24 08          	mov    %eax,0x8(%esp)
  80188b:	89 34 24             	mov    %esi,(%esp)
  80188e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801892:	89 da                	mov    %ebx,%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	e8 24 fb ff ff       	call   8013c0 <printnum>
			break;
  80189c:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80189f:	e9 99 fc ff ff       	jmp    80153d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8018a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018a8:	89 14 24             	mov    %edx,(%esp)
  8018ab:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8018ae:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8018b1:	e9 87 fc ff ff       	jmp    80153d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8018b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018ba:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8018c1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8018c4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8018c8:	0f 84 6f fc ff ff    	je     80153d <vprintfmt+0x23>
  8018ce:	83 ee 01             	sub    $0x1,%esi
  8018d1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8018d5:	75 f7                	jne    8018ce <vprintfmt+0x3b4>
  8018d7:	e9 61 fc ff ff       	jmp    80153d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8018dc:	83 c4 4c             	add    $0x4c,%esp
  8018df:	5b                   	pop    %ebx
  8018e0:	5e                   	pop    %esi
  8018e1:	5f                   	pop    %edi
  8018e2:	5d                   	pop    %ebp
  8018e3:	c3                   	ret    

008018e4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 28             	sub    $0x28,%esp
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8018f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018f3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8018f7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8018fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801901:	85 c0                	test   %eax,%eax
  801903:	74 30                	je     801935 <vsnprintf+0x51>
  801905:	85 d2                	test   %edx,%edx
  801907:	7e 2c                	jle    801935 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801909:	8b 45 14             	mov    0x14(%ebp),%eax
  80190c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801910:	8b 45 10             	mov    0x10(%ebp),%eax
  801913:	89 44 24 08          	mov    %eax,0x8(%esp)
  801917:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80191a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191e:	c7 04 24 d5 14 80 00 	movl   $0x8014d5,(%esp)
  801925:	e8 f0 fb ff ff       	call   80151a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80192a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80192d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801933:	eb 05                	jmp    80193a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801935:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801942:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801945:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801949:	8b 45 10             	mov    0x10(%ebp),%eax
  80194c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801950:	8b 45 0c             	mov    0xc(%ebp),%eax
  801953:	89 44 24 04          	mov    %eax,0x4(%esp)
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	89 04 24             	mov    %eax,(%esp)
  80195d:	e8 82 ff ff ff       	call   8018e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    
	...

00801970 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801976:	b8 00 00 00 00       	mov    $0x0,%eax
  80197b:	80 3a 00             	cmpb   $0x0,(%edx)
  80197e:	74 09                	je     801989 <strlen+0x19>
		n++;
  801980:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801983:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801987:	75 f7                	jne    801980 <strlen+0x10>
		n++;
	return n;
}
  801989:	5d                   	pop    %ebp
  80198a:	c3                   	ret    

0080198b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	53                   	push   %ebx
  80198f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801992:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801995:	b8 00 00 00 00       	mov    $0x0,%eax
  80199a:	85 c9                	test   %ecx,%ecx
  80199c:	74 1a                	je     8019b8 <strnlen+0x2d>
  80199e:	80 3b 00             	cmpb   $0x0,(%ebx)
  8019a1:	74 15                	je     8019b8 <strnlen+0x2d>
  8019a3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8019a8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8019aa:	39 ca                	cmp    %ecx,%edx
  8019ac:	74 0a                	je     8019b8 <strnlen+0x2d>
  8019ae:	83 c2 01             	add    $0x1,%edx
  8019b1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8019b6:	75 f0                	jne    8019a8 <strnlen+0x1d>
		n++;
	return n;
}
  8019b8:	5b                   	pop    %ebx
  8019b9:	5d                   	pop    %ebp
  8019ba:	c3                   	ret    

008019bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	53                   	push   %ebx
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8019c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ca:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8019ce:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8019d1:	83 c2 01             	add    $0x1,%edx
  8019d4:	84 c9                	test   %cl,%cl
  8019d6:	75 f2                	jne    8019ca <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8019d8:	5b                   	pop    %ebx
  8019d9:	5d                   	pop    %ebp
  8019da:	c3                   	ret    

008019db <strcat>:

char *
strcat(char *dst, const char *src)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	53                   	push   %ebx
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8019e5:	89 1c 24             	mov    %ebx,(%esp)
  8019e8:	e8 83 ff ff ff       	call   801970 <strlen>
	strcpy(dst + len, src);
  8019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019f4:	01 d8                	add    %ebx,%eax
  8019f6:	89 04 24             	mov    %eax,(%esp)
  8019f9:	e8 bd ff ff ff       	call   8019bb <strcpy>
	return dst;
}
  8019fe:	89 d8                	mov    %ebx,%eax
  801a00:	83 c4 08             	add    $0x8,%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5d                   	pop    %ebp
  801a05:	c3                   	ret    

00801a06 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	56                   	push   %esi
  801a0a:	53                   	push   %ebx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a11:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a14:	85 f6                	test   %esi,%esi
  801a16:	74 18                	je     801a30 <strncpy+0x2a>
  801a18:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  801a1d:	0f b6 1a             	movzbl (%edx),%ebx
  801a20:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801a23:	80 3a 01             	cmpb   $0x1,(%edx)
  801a26:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a29:	83 c1 01             	add    $0x1,%ecx
  801a2c:	39 f1                	cmp    %esi,%ecx
  801a2e:	75 ed                	jne    801a1d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801a30:	5b                   	pop    %ebx
  801a31:	5e                   	pop    %esi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    

00801a34 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	57                   	push   %edi
  801a38:	56                   	push   %esi
  801a39:	53                   	push   %ebx
  801a3a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a40:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801a43:	89 f8                	mov    %edi,%eax
  801a45:	85 f6                	test   %esi,%esi
  801a47:	74 2b                	je     801a74 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  801a49:	83 fe 01             	cmp    $0x1,%esi
  801a4c:	74 23                	je     801a71 <strlcpy+0x3d>
  801a4e:	0f b6 0b             	movzbl (%ebx),%ecx
  801a51:	84 c9                	test   %cl,%cl
  801a53:	74 1c                	je     801a71 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  801a55:	83 ee 02             	sub    $0x2,%esi
  801a58:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801a5d:	88 08                	mov    %cl,(%eax)
  801a5f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a62:	39 f2                	cmp    %esi,%edx
  801a64:	74 0b                	je     801a71 <strlcpy+0x3d>
  801a66:	83 c2 01             	add    $0x1,%edx
  801a69:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801a6d:	84 c9                	test   %cl,%cl
  801a6f:	75 ec                	jne    801a5d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  801a71:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801a74:	29 f8                	sub    %edi,%eax
}
  801a76:	5b                   	pop    %ebx
  801a77:	5e                   	pop    %esi
  801a78:	5f                   	pop    %edi
  801a79:	5d                   	pop    %ebp
  801a7a:	c3                   	ret    

00801a7b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a81:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801a84:	0f b6 01             	movzbl (%ecx),%eax
  801a87:	84 c0                	test   %al,%al
  801a89:	74 16                	je     801aa1 <strcmp+0x26>
  801a8b:	3a 02                	cmp    (%edx),%al
  801a8d:	75 12                	jne    801aa1 <strcmp+0x26>
		p++, q++;
  801a8f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a92:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  801a96:	84 c0                	test   %al,%al
  801a98:	74 07                	je     801aa1 <strcmp+0x26>
  801a9a:	83 c1 01             	add    $0x1,%ecx
  801a9d:	3a 02                	cmp    (%edx),%al
  801a9f:	74 ee                	je     801a8f <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801aa1:	0f b6 c0             	movzbl %al,%eax
  801aa4:	0f b6 12             	movzbl (%edx),%edx
  801aa7:	29 d0                	sub    %edx,%eax
}
  801aa9:	5d                   	pop    %ebp
  801aaa:	c3                   	ret    

00801aab <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	53                   	push   %ebx
  801aaf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ab5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801ab8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801abd:	85 d2                	test   %edx,%edx
  801abf:	74 28                	je     801ae9 <strncmp+0x3e>
  801ac1:	0f b6 01             	movzbl (%ecx),%eax
  801ac4:	84 c0                	test   %al,%al
  801ac6:	74 24                	je     801aec <strncmp+0x41>
  801ac8:	3a 03                	cmp    (%ebx),%al
  801aca:	75 20                	jne    801aec <strncmp+0x41>
  801acc:	83 ea 01             	sub    $0x1,%edx
  801acf:	74 13                	je     801ae4 <strncmp+0x39>
		n--, p++, q++;
  801ad1:	83 c1 01             	add    $0x1,%ecx
  801ad4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ad7:	0f b6 01             	movzbl (%ecx),%eax
  801ada:	84 c0                	test   %al,%al
  801adc:	74 0e                	je     801aec <strncmp+0x41>
  801ade:	3a 03                	cmp    (%ebx),%al
  801ae0:	74 ea                	je     801acc <strncmp+0x21>
  801ae2:	eb 08                	jmp    801aec <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801ae4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801ae9:	5b                   	pop    %ebx
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801aec:	0f b6 01             	movzbl (%ecx),%eax
  801aef:	0f b6 13             	movzbl (%ebx),%edx
  801af2:	29 d0                	sub    %edx,%eax
  801af4:	eb f3                	jmp    801ae9 <strncmp+0x3e>

00801af6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801b00:	0f b6 10             	movzbl (%eax),%edx
  801b03:	84 d2                	test   %dl,%dl
  801b05:	74 1c                	je     801b23 <strchr+0x2d>
		if (*s == c)
  801b07:	38 ca                	cmp    %cl,%dl
  801b09:	75 09                	jne    801b14 <strchr+0x1e>
  801b0b:	eb 1b                	jmp    801b28 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b0d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  801b10:	38 ca                	cmp    %cl,%dl
  801b12:	74 14                	je     801b28 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b14:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  801b18:	84 d2                	test   %dl,%dl
  801b1a:	75 f1                	jne    801b0d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  801b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b21:	eb 05                	jmp    801b28 <strchr+0x32>
  801b23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b28:	5d                   	pop    %ebp
  801b29:	c3                   	ret    

00801b2a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801b34:	0f b6 10             	movzbl (%eax),%edx
  801b37:	84 d2                	test   %dl,%dl
  801b39:	74 14                	je     801b4f <strfind+0x25>
		if (*s == c)
  801b3b:	38 ca                	cmp    %cl,%dl
  801b3d:	75 06                	jne    801b45 <strfind+0x1b>
  801b3f:	eb 0e                	jmp    801b4f <strfind+0x25>
  801b41:	38 ca                	cmp    %cl,%dl
  801b43:	74 0a                	je     801b4f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b45:	83 c0 01             	add    $0x1,%eax
  801b48:	0f b6 10             	movzbl (%eax),%edx
  801b4b:	84 d2                	test   %dl,%dl
  801b4d:	75 f2                	jne    801b41 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  801b4f:	5d                   	pop    %ebp
  801b50:	c3                   	ret    

00801b51 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 0c             	sub    $0xc,%esp
  801b57:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b5a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b5d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b60:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b66:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801b69:	85 c9                	test   %ecx,%ecx
  801b6b:	74 30                	je     801b9d <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801b6d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801b73:	75 25                	jne    801b9a <memset+0x49>
  801b75:	f6 c1 03             	test   $0x3,%cl
  801b78:	75 20                	jne    801b9a <memset+0x49>
		c &= 0xFF;
  801b7a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801b7d:	89 d3                	mov    %edx,%ebx
  801b7f:	c1 e3 08             	shl    $0x8,%ebx
  801b82:	89 d6                	mov    %edx,%esi
  801b84:	c1 e6 18             	shl    $0x18,%esi
  801b87:	89 d0                	mov    %edx,%eax
  801b89:	c1 e0 10             	shl    $0x10,%eax
  801b8c:	09 f0                	or     %esi,%eax
  801b8e:	09 d0                	or     %edx,%eax
  801b90:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801b92:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801b95:	fc                   	cld    
  801b96:	f3 ab                	rep stos %eax,%es:(%edi)
  801b98:	eb 03                	jmp    801b9d <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801b9a:	fc                   	cld    
  801b9b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801b9d:	89 f8                	mov    %edi,%eax
  801b9f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ba2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ba5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ba8:	89 ec                	mov    %ebp,%esp
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    

00801bac <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 08             	sub    $0x8,%esp
  801bb2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801bb5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801bc1:	39 c6                	cmp    %eax,%esi
  801bc3:	73 36                	jae    801bfb <memmove+0x4f>
  801bc5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801bc8:	39 d0                	cmp    %edx,%eax
  801bca:	73 2f                	jae    801bfb <memmove+0x4f>
		s += n;
		d += n;
  801bcc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801bcf:	f6 c2 03             	test   $0x3,%dl
  801bd2:	75 1b                	jne    801bef <memmove+0x43>
  801bd4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801bda:	75 13                	jne    801bef <memmove+0x43>
  801bdc:	f6 c1 03             	test   $0x3,%cl
  801bdf:	75 0e                	jne    801bef <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801be1:	83 ef 04             	sub    $0x4,%edi
  801be4:	8d 72 fc             	lea    -0x4(%edx),%esi
  801be7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801bea:	fd                   	std    
  801beb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801bed:	eb 09                	jmp    801bf8 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801bef:	83 ef 01             	sub    $0x1,%edi
  801bf2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801bf5:	fd                   	std    
  801bf6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801bf8:	fc                   	cld    
  801bf9:	eb 20                	jmp    801c1b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801bfb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801c01:	75 13                	jne    801c16 <memmove+0x6a>
  801c03:	a8 03                	test   $0x3,%al
  801c05:	75 0f                	jne    801c16 <memmove+0x6a>
  801c07:	f6 c1 03             	test   $0x3,%cl
  801c0a:	75 0a                	jne    801c16 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801c0c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801c0f:	89 c7                	mov    %eax,%edi
  801c11:	fc                   	cld    
  801c12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801c14:	eb 05                	jmp    801c1b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801c16:	89 c7                	mov    %eax,%edi
  801c18:	fc                   	cld    
  801c19:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801c1b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c1e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c21:	89 ec                	mov    %ebp,%esp
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    

00801c25 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	89 04 24             	mov    %eax,(%esp)
  801c3f:	e8 68 ff ff ff       	call   801bac <memmove>
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	57                   	push   %edi
  801c4a:	56                   	push   %esi
  801c4b:	53                   	push   %ebx
  801c4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c52:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c5a:	85 ff                	test   %edi,%edi
  801c5c:	74 37                	je     801c95 <memcmp+0x4f>
		if (*s1 != *s2)
  801c5e:	0f b6 03             	movzbl (%ebx),%eax
  801c61:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c64:	83 ef 01             	sub    $0x1,%edi
  801c67:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  801c6c:	38 c8                	cmp    %cl,%al
  801c6e:	74 1c                	je     801c8c <memcmp+0x46>
  801c70:	eb 10                	jmp    801c82 <memcmp+0x3c>
  801c72:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801c77:	83 c2 01             	add    $0x1,%edx
  801c7a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801c7e:	38 c8                	cmp    %cl,%al
  801c80:	74 0a                	je     801c8c <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  801c82:	0f b6 c0             	movzbl %al,%eax
  801c85:	0f b6 c9             	movzbl %cl,%ecx
  801c88:	29 c8                	sub    %ecx,%eax
  801c8a:	eb 09                	jmp    801c95 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c8c:	39 fa                	cmp    %edi,%edx
  801c8e:	75 e2                	jne    801c72 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c95:	5b                   	pop    %ebx
  801c96:	5e                   	pop    %esi
  801c97:	5f                   	pop    %edi
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    

00801c9a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801ca0:	89 c2                	mov    %eax,%edx
  801ca2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801ca5:	39 d0                	cmp    %edx,%eax
  801ca7:	73 19                	jae    801cc2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ca9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801cad:	38 08                	cmp    %cl,(%eax)
  801caf:	75 06                	jne    801cb7 <memfind+0x1d>
  801cb1:	eb 0f                	jmp    801cc2 <memfind+0x28>
  801cb3:	38 08                	cmp    %cl,(%eax)
  801cb5:	74 0b                	je     801cc2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801cb7:	83 c0 01             	add    $0x1,%eax
  801cba:	39 d0                	cmp    %edx,%eax
  801cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801cc0:	75 f1                	jne    801cb3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    

00801cc4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	57                   	push   %edi
  801cc8:	56                   	push   %esi
  801cc9:	53                   	push   %ebx
  801cca:	8b 55 08             	mov    0x8(%ebp),%edx
  801ccd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801cd0:	0f b6 02             	movzbl (%edx),%eax
  801cd3:	3c 20                	cmp    $0x20,%al
  801cd5:	74 04                	je     801cdb <strtol+0x17>
  801cd7:	3c 09                	cmp    $0x9,%al
  801cd9:	75 0e                	jne    801ce9 <strtol+0x25>
		s++;
  801cdb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801cde:	0f b6 02             	movzbl (%edx),%eax
  801ce1:	3c 20                	cmp    $0x20,%al
  801ce3:	74 f6                	je     801cdb <strtol+0x17>
  801ce5:	3c 09                	cmp    $0x9,%al
  801ce7:	74 f2                	je     801cdb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ce9:	3c 2b                	cmp    $0x2b,%al
  801ceb:	75 0a                	jne    801cf7 <strtol+0x33>
		s++;
  801ced:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801cf0:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf5:	eb 10                	jmp    801d07 <strtol+0x43>
  801cf7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801cfc:	3c 2d                	cmp    $0x2d,%al
  801cfe:	75 07                	jne    801d07 <strtol+0x43>
		s++, neg = 1;
  801d00:	83 c2 01             	add    $0x1,%edx
  801d03:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801d07:	85 db                	test   %ebx,%ebx
  801d09:	0f 94 c0             	sete   %al
  801d0c:	74 05                	je     801d13 <strtol+0x4f>
  801d0e:	83 fb 10             	cmp    $0x10,%ebx
  801d11:	75 15                	jne    801d28 <strtol+0x64>
  801d13:	80 3a 30             	cmpb   $0x30,(%edx)
  801d16:	75 10                	jne    801d28 <strtol+0x64>
  801d18:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801d1c:	75 0a                	jne    801d28 <strtol+0x64>
		s += 2, base = 16;
  801d1e:	83 c2 02             	add    $0x2,%edx
  801d21:	bb 10 00 00 00       	mov    $0x10,%ebx
  801d26:	eb 13                	jmp    801d3b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  801d28:	84 c0                	test   %al,%al
  801d2a:	74 0f                	je     801d3b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801d2c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801d31:	80 3a 30             	cmpb   $0x30,(%edx)
  801d34:	75 05                	jne    801d3b <strtol+0x77>
		s++, base = 8;
  801d36:	83 c2 01             	add    $0x1,%edx
  801d39:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d40:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d42:	0f b6 0a             	movzbl (%edx),%ecx
  801d45:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801d48:	80 fb 09             	cmp    $0x9,%bl
  801d4b:	77 08                	ja     801d55 <strtol+0x91>
			dig = *s - '0';
  801d4d:	0f be c9             	movsbl %cl,%ecx
  801d50:	83 e9 30             	sub    $0x30,%ecx
  801d53:	eb 1e                	jmp    801d73 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  801d55:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  801d58:	80 fb 19             	cmp    $0x19,%bl
  801d5b:	77 08                	ja     801d65 <strtol+0xa1>
			dig = *s - 'a' + 10;
  801d5d:	0f be c9             	movsbl %cl,%ecx
  801d60:	83 e9 57             	sub    $0x57,%ecx
  801d63:	eb 0e                	jmp    801d73 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  801d65:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  801d68:	80 fb 19             	cmp    $0x19,%bl
  801d6b:	77 14                	ja     801d81 <strtol+0xbd>
			dig = *s - 'A' + 10;
  801d6d:	0f be c9             	movsbl %cl,%ecx
  801d70:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801d73:	39 f1                	cmp    %esi,%ecx
  801d75:	7d 0e                	jge    801d85 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801d77:	83 c2 01             	add    $0x1,%edx
  801d7a:	0f af c6             	imul   %esi,%eax
  801d7d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  801d7f:	eb c1                	jmp    801d42 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  801d81:	89 c1                	mov    %eax,%ecx
  801d83:	eb 02                	jmp    801d87 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801d85:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d8b:	74 05                	je     801d92 <strtol+0xce>
		*endptr = (char *) s;
  801d8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d90:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801d92:	89 ca                	mov    %ecx,%edx
  801d94:	f7 da                	neg    %edx
  801d96:	85 ff                	test   %edi,%edi
  801d98:	0f 45 c2             	cmovne %edx,%eax
}
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5f                   	pop    %edi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    

00801da0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	56                   	push   %esi
  801da4:	53                   	push   %ebx
  801da5:	83 ec 10             	sub    $0x10,%esp
  801da8:	8b 75 08             	mov    0x8(%ebp),%esi
  801dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801db1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801db3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801db8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801dbb:	89 04 24             	mov    %eax,(%esp)
  801dbe:	e8 82 e6 ff ff       	call   800445 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801dc3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801dc8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	78 0e                	js     801ddf <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801dd1:	a1 04 40 80 00       	mov    0x804004,%eax
  801dd6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801dd9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801ddc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801ddf:	85 f6                	test   %esi,%esi
  801de1:	74 02                	je     801de5 <ipc_recv+0x45>
		*from_env_store = sender;
  801de3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801de5:	85 db                	test   %ebx,%ebx
  801de7:	74 02                	je     801deb <ipc_recv+0x4b>
		*perm_store = perm;
  801de9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	5b                   	pop    %ebx
  801def:	5e                   	pop    %esi
  801df0:	5d                   	pop    %ebp
  801df1:	c3                   	ret    

00801df2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	57                   	push   %edi
  801df6:	56                   	push   %esi
  801df7:	53                   	push   %ebx
  801df8:	83 ec 1c             	sub    $0x1c,%esp
  801dfb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801dfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e01:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801e04:	85 db                	test   %ebx,%ebx
  801e06:	75 04                	jne    801e0c <ipc_send+0x1a>
  801e08:	85 f6                	test   %esi,%esi
  801e0a:	75 15                	jne    801e21 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801e0c:	85 db                	test   %ebx,%ebx
  801e0e:	74 16                	je     801e26 <ipc_send+0x34>
  801e10:	85 f6                	test   %esi,%esi
  801e12:	0f 94 c0             	sete   %al
      pg = 0;
  801e15:	84 c0                	test   %al,%al
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1c:	0f 45 d8             	cmovne %eax,%ebx
  801e1f:	eb 05                	jmp    801e26 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801e21:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801e26:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e2a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e2e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	89 04 24             	mov    %eax,(%esp)
  801e38:	e8 d4 e5 ff ff       	call   800411 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801e3d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e40:	75 07                	jne    801e49 <ipc_send+0x57>
           sys_yield();
  801e42:	e8 65 e3 ff ff       	call   8001ac <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801e47:	eb dd                	jmp    801e26 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801e49:	85 c0                	test   %eax,%eax
  801e4b:	90                   	nop
  801e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e50:	74 1c                	je     801e6e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801e52:	c7 44 24 08 20 26 80 	movl   $0x802620,0x8(%esp)
  801e59:	00 
  801e5a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801e61:	00 
  801e62:	c7 04 24 2a 26 80 00 	movl   $0x80262a,(%esp)
  801e69:	e8 32 f4 ff ff       	call   8012a0 <_panic>
		}
    }
}
  801e6e:	83 c4 1c             	add    $0x1c,%esp
  801e71:	5b                   	pop    %ebx
  801e72:	5e                   	pop    %esi
  801e73:	5f                   	pop    %edi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    

00801e76 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e7c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801e81:	39 c8                	cmp    %ecx,%eax
  801e83:	74 17                	je     801e9c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e85:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e8a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e8d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e93:	8b 52 50             	mov    0x50(%edx),%edx
  801e96:	39 ca                	cmp    %ecx,%edx
  801e98:	75 14                	jne    801eae <ipc_find_env+0x38>
  801e9a:	eb 05                	jmp    801ea1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801ea1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ea4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801ea9:	8b 40 40             	mov    0x40(%eax),%eax
  801eac:	eb 0e                	jmp    801ebc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801eae:	83 c0 01             	add    $0x1,%eax
  801eb1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801eb6:	75 d2                	jne    801e8a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801eb8:	66 b8 00 00          	mov    $0x0,%ax
}
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    
	...

00801ec0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ec6:	89 d0                	mov    %edx,%eax
  801ec8:	c1 e8 16             	shr    $0x16,%eax
  801ecb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ed2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ed7:	f6 c1 01             	test   $0x1,%cl
  801eda:	74 1d                	je     801ef9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801edc:	c1 ea 0c             	shr    $0xc,%edx
  801edf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ee6:	f6 c2 01             	test   $0x1,%dl
  801ee9:	74 0e                	je     801ef9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801eeb:	c1 ea 0c             	shr    $0xc,%edx
  801eee:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ef5:	ef 
  801ef6:	0f b7 c0             	movzwl %ax,%eax
}
  801ef9:	5d                   	pop    %ebp
  801efa:	c3                   	ret    
  801efb:	00 00                	add    %al,(%eax)
  801efd:	00 00                	add    %al,(%eax)
	...

00801f00 <__udivdi3>:
  801f00:	83 ec 1c             	sub    $0x1c,%esp
  801f03:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801f07:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801f0b:	8b 44 24 20          	mov    0x20(%esp),%eax
  801f0f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801f13:	89 74 24 10          	mov    %esi,0x10(%esp)
  801f17:	8b 74 24 24          	mov    0x24(%esp),%esi
  801f1b:	85 ff                	test   %edi,%edi
  801f1d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801f21:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f25:	89 cd                	mov    %ecx,%ebp
  801f27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2b:	75 33                	jne    801f60 <__udivdi3+0x60>
  801f2d:	39 f1                	cmp    %esi,%ecx
  801f2f:	77 57                	ja     801f88 <__udivdi3+0x88>
  801f31:	85 c9                	test   %ecx,%ecx
  801f33:	75 0b                	jne    801f40 <__udivdi3+0x40>
  801f35:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3a:	31 d2                	xor    %edx,%edx
  801f3c:	f7 f1                	div    %ecx
  801f3e:	89 c1                	mov    %eax,%ecx
  801f40:	89 f0                	mov    %esi,%eax
  801f42:	31 d2                	xor    %edx,%edx
  801f44:	f7 f1                	div    %ecx
  801f46:	89 c6                	mov    %eax,%esi
  801f48:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f4c:	f7 f1                	div    %ecx
  801f4e:	89 f2                	mov    %esi,%edx
  801f50:	8b 74 24 10          	mov    0x10(%esp),%esi
  801f54:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801f58:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801f5c:	83 c4 1c             	add    $0x1c,%esp
  801f5f:	c3                   	ret    
  801f60:	31 d2                	xor    %edx,%edx
  801f62:	31 c0                	xor    %eax,%eax
  801f64:	39 f7                	cmp    %esi,%edi
  801f66:	77 e8                	ja     801f50 <__udivdi3+0x50>
  801f68:	0f bd cf             	bsr    %edi,%ecx
  801f6b:	83 f1 1f             	xor    $0x1f,%ecx
  801f6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f72:	75 2c                	jne    801fa0 <__udivdi3+0xa0>
  801f74:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  801f78:	76 04                	jbe    801f7e <__udivdi3+0x7e>
  801f7a:	39 f7                	cmp    %esi,%edi
  801f7c:	73 d2                	jae    801f50 <__udivdi3+0x50>
  801f7e:	31 d2                	xor    %edx,%edx
  801f80:	b8 01 00 00 00       	mov    $0x1,%eax
  801f85:	eb c9                	jmp    801f50 <__udivdi3+0x50>
  801f87:	90                   	nop
  801f88:	89 f2                	mov    %esi,%edx
  801f8a:	f7 f1                	div    %ecx
  801f8c:	31 d2                	xor    %edx,%edx
  801f8e:	8b 74 24 10          	mov    0x10(%esp),%esi
  801f92:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801f96:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801f9a:	83 c4 1c             	add    $0x1c,%esp
  801f9d:	c3                   	ret    
  801f9e:	66 90                	xchg   %ax,%ax
  801fa0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fa5:	b8 20 00 00 00       	mov    $0x20,%eax
  801faa:	89 ea                	mov    %ebp,%edx
  801fac:	2b 44 24 04          	sub    0x4(%esp),%eax
  801fb0:	d3 e7                	shl    %cl,%edi
  801fb2:	89 c1                	mov    %eax,%ecx
  801fb4:	d3 ea                	shr    %cl,%edx
  801fb6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fbb:	09 fa                	or     %edi,%edx
  801fbd:	89 f7                	mov    %esi,%edi
  801fbf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fc3:	89 f2                	mov    %esi,%edx
  801fc5:	8b 74 24 08          	mov    0x8(%esp),%esi
  801fc9:	d3 e5                	shl    %cl,%ebp
  801fcb:	89 c1                	mov    %eax,%ecx
  801fcd:	d3 ef                	shr    %cl,%edi
  801fcf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fd4:	d3 e2                	shl    %cl,%edx
  801fd6:	89 c1                	mov    %eax,%ecx
  801fd8:	d3 ee                	shr    %cl,%esi
  801fda:	09 d6                	or     %edx,%esi
  801fdc:	89 fa                	mov    %edi,%edx
  801fde:	89 f0                	mov    %esi,%eax
  801fe0:	f7 74 24 0c          	divl   0xc(%esp)
  801fe4:	89 d7                	mov    %edx,%edi
  801fe6:	89 c6                	mov    %eax,%esi
  801fe8:	f7 e5                	mul    %ebp
  801fea:	39 d7                	cmp    %edx,%edi
  801fec:	72 22                	jb     802010 <__udivdi3+0x110>
  801fee:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  801ff2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ff7:	d3 e5                	shl    %cl,%ebp
  801ff9:	39 c5                	cmp    %eax,%ebp
  801ffb:	73 04                	jae    802001 <__udivdi3+0x101>
  801ffd:	39 d7                	cmp    %edx,%edi
  801fff:	74 0f                	je     802010 <__udivdi3+0x110>
  802001:	89 f0                	mov    %esi,%eax
  802003:	31 d2                	xor    %edx,%edx
  802005:	e9 46 ff ff ff       	jmp    801f50 <__udivdi3+0x50>
  80200a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802010:	8d 46 ff             	lea    -0x1(%esi),%eax
  802013:	31 d2                	xor    %edx,%edx
  802015:	8b 74 24 10          	mov    0x10(%esp),%esi
  802019:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80201d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802021:	83 c4 1c             	add    $0x1c,%esp
  802024:	c3                   	ret    
	...

00802030 <__umoddi3>:
  802030:	83 ec 1c             	sub    $0x1c,%esp
  802033:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802037:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80203b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80203f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802043:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802047:	8b 74 24 24          	mov    0x24(%esp),%esi
  80204b:	85 ed                	test   %ebp,%ebp
  80204d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802051:	89 44 24 08          	mov    %eax,0x8(%esp)
  802055:	89 cf                	mov    %ecx,%edi
  802057:	89 04 24             	mov    %eax,(%esp)
  80205a:	89 f2                	mov    %esi,%edx
  80205c:	75 1a                	jne    802078 <__umoddi3+0x48>
  80205e:	39 f1                	cmp    %esi,%ecx
  802060:	76 4e                	jbe    8020b0 <__umoddi3+0x80>
  802062:	f7 f1                	div    %ecx
  802064:	89 d0                	mov    %edx,%eax
  802066:	31 d2                	xor    %edx,%edx
  802068:	8b 74 24 10          	mov    0x10(%esp),%esi
  80206c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802070:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802074:	83 c4 1c             	add    $0x1c,%esp
  802077:	c3                   	ret    
  802078:	39 f5                	cmp    %esi,%ebp
  80207a:	77 54                	ja     8020d0 <__umoddi3+0xa0>
  80207c:	0f bd c5             	bsr    %ebp,%eax
  80207f:	83 f0 1f             	xor    $0x1f,%eax
  802082:	89 44 24 04          	mov    %eax,0x4(%esp)
  802086:	75 60                	jne    8020e8 <__umoddi3+0xb8>
  802088:	3b 0c 24             	cmp    (%esp),%ecx
  80208b:	0f 87 07 01 00 00    	ja     802198 <__umoddi3+0x168>
  802091:	89 f2                	mov    %esi,%edx
  802093:	8b 34 24             	mov    (%esp),%esi
  802096:	29 ce                	sub    %ecx,%esi
  802098:	19 ea                	sbb    %ebp,%edx
  80209a:	89 34 24             	mov    %esi,(%esp)
  80209d:	8b 04 24             	mov    (%esp),%eax
  8020a0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020a4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020a8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020ac:	83 c4 1c             	add    $0x1c,%esp
  8020af:	c3                   	ret    
  8020b0:	85 c9                	test   %ecx,%ecx
  8020b2:	75 0b                	jne    8020bf <__umoddi3+0x8f>
  8020b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b9:	31 d2                	xor    %edx,%edx
  8020bb:	f7 f1                	div    %ecx
  8020bd:	89 c1                	mov    %eax,%ecx
  8020bf:	89 f0                	mov    %esi,%eax
  8020c1:	31 d2                	xor    %edx,%edx
  8020c3:	f7 f1                	div    %ecx
  8020c5:	8b 04 24             	mov    (%esp),%eax
  8020c8:	f7 f1                	div    %ecx
  8020ca:	eb 98                	jmp    802064 <__umoddi3+0x34>
  8020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020d0:	89 f2                	mov    %esi,%edx
  8020d2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020d6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020da:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020de:	83 c4 1c             	add    $0x1c,%esp
  8020e1:	c3                   	ret    
  8020e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020e8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020ed:	89 e8                	mov    %ebp,%eax
  8020ef:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020f4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8020f8:	89 fa                	mov    %edi,%edx
  8020fa:	d3 e0                	shl    %cl,%eax
  8020fc:	89 e9                	mov    %ebp,%ecx
  8020fe:	d3 ea                	shr    %cl,%edx
  802100:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802105:	09 c2                	or     %eax,%edx
  802107:	8b 44 24 08          	mov    0x8(%esp),%eax
  80210b:	89 14 24             	mov    %edx,(%esp)
  80210e:	89 f2                	mov    %esi,%edx
  802110:	d3 e7                	shl    %cl,%edi
  802112:	89 e9                	mov    %ebp,%ecx
  802114:	d3 ea                	shr    %cl,%edx
  802116:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80211b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80211f:	d3 e6                	shl    %cl,%esi
  802121:	89 e9                	mov    %ebp,%ecx
  802123:	d3 e8                	shr    %cl,%eax
  802125:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80212a:	09 f0                	or     %esi,%eax
  80212c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802130:	f7 34 24             	divl   (%esp)
  802133:	d3 e6                	shl    %cl,%esi
  802135:	89 74 24 08          	mov    %esi,0x8(%esp)
  802139:	89 d6                	mov    %edx,%esi
  80213b:	f7 e7                	mul    %edi
  80213d:	39 d6                	cmp    %edx,%esi
  80213f:	89 c1                	mov    %eax,%ecx
  802141:	89 d7                	mov    %edx,%edi
  802143:	72 3f                	jb     802184 <__umoddi3+0x154>
  802145:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802149:	72 35                	jb     802180 <__umoddi3+0x150>
  80214b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80214f:	29 c8                	sub    %ecx,%eax
  802151:	19 fe                	sbb    %edi,%esi
  802153:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802158:	89 f2                	mov    %esi,%edx
  80215a:	d3 e8                	shr    %cl,%eax
  80215c:	89 e9                	mov    %ebp,%ecx
  80215e:	d3 e2                	shl    %cl,%edx
  802160:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802165:	09 d0                	or     %edx,%eax
  802167:	89 f2                	mov    %esi,%edx
  802169:	d3 ea                	shr    %cl,%edx
  80216b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80216f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802173:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802177:	83 c4 1c             	add    $0x1c,%esp
  80217a:	c3                   	ret    
  80217b:	90                   	nop
  80217c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802180:	39 d6                	cmp    %edx,%esi
  802182:	75 c7                	jne    80214b <__umoddi3+0x11b>
  802184:	89 d7                	mov    %edx,%edi
  802186:	89 c1                	mov    %eax,%ecx
  802188:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80218c:	1b 3c 24             	sbb    (%esp),%edi
  80218f:	eb ba                	jmp    80214b <__umoddi3+0x11b>
  802191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802198:	39 f5                	cmp    %esi,%ebp
  80219a:	0f 82 f1 fe ff ff    	jb     802091 <__umoddi3+0x61>
  8021a0:	e9 f8 fe ff ff       	jmp    80209d <__umoddi3+0x6d>
