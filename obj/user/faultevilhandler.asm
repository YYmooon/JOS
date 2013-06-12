
obj/user/faultevilhandler.debug:     file format elf32-i386


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
  80002c:	e8 47 00 00 00       	call   800078 <libmain>
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
  800037:	83 ec 18             	sub    $0x18,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  80003a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800041:	00 
  800042:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800049:	ee 
  80004a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800051:	e8 aa 01 00 00       	call   800200 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800056:	c7 44 24 04 20 00 10 	movl   $0xf0100020,0x4(%esp)
  80005d:	f0 
  80005e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800065:	e8 6d 03 00 00       	call   8003d7 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  80006a:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800071:	00 00 00 
}
  800074:	c9                   	leave  
  800075:	c3                   	ret    
	...

00800078 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800078:	55                   	push   %ebp
  800079:	89 e5                	mov    %esp,%ebp
  80007b:	83 ec 18             	sub    $0x18,%esp
  80007e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800081:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800084:	8b 75 08             	mov    0x8(%ebp),%esi
  800087:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80008a:	e8 11 01 00 00       	call   8001a0 <sys_getenvid>
  80008f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800094:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800097:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009c:	a3 04 40 80 00       	mov    %eax,0x804004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a1:	85 f6                	test   %esi,%esi
  8000a3:	7e 07                	jle    8000ac <libmain+0x34>
		binaryname = argv[0];
  8000a5:	8b 03                	mov    (%ebx),%eax
  8000a7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000b0:	89 34 24             	mov    %esi,(%esp)
  8000b3:	e8 7c ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000b8:	e8 0b 00 00 00       	call   8000c8 <exit>
}
  8000bd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000c0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000c3:	89 ec                	mov    %ebp,%esp
  8000c5:	5d                   	pop    %ebp
  8000c6:	c3                   	ret    
	...

008000c8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000ce:	e8 1b 06 00 00       	call   8006ee <close_all>
	sys_env_destroy(0);
  8000d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000da:	e8 64 00 00 00       	call   800143 <sys_env_destroy>
}
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    
  8000e1:	00 00                	add    %al,(%eax)
	...

008000e4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8000ed:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8000f0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fe:	89 c3                	mov    %eax,%ebx
  800100:	89 c7                	mov    %eax,%edi
  800102:	89 c6                	mov    %eax,%esi
  800104:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800106:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800109:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80010c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80010f:	89 ec                	mov    %ebp,%esp
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    

00800113 <sys_cgetc>:

int
sys_cgetc(void)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80011c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80011f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800122:	ba 00 00 00 00       	mov    $0x0,%edx
  800127:	b8 01 00 00 00       	mov    $0x1,%eax
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	89 d3                	mov    %edx,%ebx
  800130:	89 d7                	mov    %edx,%edi
  800132:	89 d6                	mov    %edx,%esi
  800134:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800136:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800139:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80013c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80013f:	89 ec                	mov    %ebp,%esp
  800141:	5d                   	pop    %ebp
  800142:	c3                   	ret    

00800143 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 38             	sub    $0x38,%esp
  800149:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80014c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80014f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800152:	b9 00 00 00 00       	mov    $0x0,%ecx
  800157:	b8 03 00 00 00       	mov    $0x3,%eax
  80015c:	8b 55 08             	mov    0x8(%ebp),%edx
  80015f:	89 cb                	mov    %ecx,%ebx
  800161:	89 cf                	mov    %ecx,%edi
  800163:	89 ce                	mov    %ecx,%esi
  800165:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800167:	85 c0                	test   %eax,%eax
  800169:	7e 28                	jle    800193 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80016b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80016f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800176:	00 
  800177:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  80017e:	00 
  80017f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800186:	00 
  800187:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  80018e:	e8 2d 11 00 00       	call   8012c0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800193:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800196:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800199:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80019c:	89 ec                	mov    %ebp,%esp
  80019e:	5d                   	pop    %ebp
  80019f:	c3                   	ret    

008001a0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001a9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001ac:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001af:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b4:	b8 02 00 00 00       	mov    $0x2,%eax
  8001b9:	89 d1                	mov    %edx,%ecx
  8001bb:	89 d3                	mov    %edx,%ebx
  8001bd:	89 d7                	mov    %edx,%edi
  8001bf:	89 d6                	mov    %edx,%esi
  8001c1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001c3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001c6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001c9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001cc:	89 ec                	mov    %ebp,%esp
  8001ce:	5d                   	pop    %ebp
  8001cf:	c3                   	ret    

008001d0 <sys_yield>:

void
sys_yield(void)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001d9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001dc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001df:	ba 00 00 00 00       	mov    $0x0,%edx
  8001e4:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001e9:	89 d1                	mov    %edx,%ecx
  8001eb:	89 d3                	mov    %edx,%ebx
  8001ed:	89 d7                	mov    %edx,%edi
  8001ef:	89 d6                	mov    %edx,%esi
  8001f1:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001f3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001f6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001f9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001fc:	89 ec                	mov    %ebp,%esp
  8001fe:	5d                   	pop    %ebp
  8001ff:	c3                   	ret    

00800200 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	83 ec 38             	sub    $0x38,%esp
  800206:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800209:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80020c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80020f:	be 00 00 00 00       	mov    $0x0,%esi
  800214:	b8 04 00 00 00       	mov    $0x4,%eax
  800219:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80021c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021f:	8b 55 08             	mov    0x8(%ebp),%edx
  800222:	89 f7                	mov    %esi,%edi
  800224:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800226:	85 c0                	test   %eax,%eax
  800228:	7e 28                	jle    800252 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  80022a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80022e:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800235:	00 
  800236:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  80023d:	00 
  80023e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800245:	00 
  800246:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  80024d:	e8 6e 10 00 00       	call   8012c0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800252:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800255:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800258:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80025b:	89 ec                	mov    %ebp,%esp
  80025d:	5d                   	pop    %ebp
  80025e:	c3                   	ret    

0080025f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	83 ec 38             	sub    $0x38,%esp
  800265:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800268:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80026b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80026e:	b8 05 00 00 00       	mov    $0x5,%eax
  800273:	8b 75 18             	mov    0x18(%ebp),%esi
  800276:	8b 7d 14             	mov    0x14(%ebp),%edi
  800279:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80027c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027f:	8b 55 08             	mov    0x8(%ebp),%edx
  800282:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800284:	85 c0                	test   %eax,%eax
  800286:	7e 28                	jle    8002b0 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800288:	89 44 24 10          	mov    %eax,0x10(%esp)
  80028c:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800293:	00 
  800294:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  80029b:	00 
  80029c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002a3:	00 
  8002a4:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  8002ab:	e8 10 10 00 00       	call   8012c0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8002b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002b3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002b6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002b9:	89 ec                	mov    %ebp,%esp
  8002bb:	5d                   	pop    %ebp
  8002bc:	c3                   	ret    

008002bd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 38             	sub    $0x38,%esp
  8002c3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002c6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002c9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002d1:	b8 06 00 00 00       	mov    $0x6,%eax
  8002d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002dc:	89 df                	mov    %ebx,%edi
  8002de:	89 de                	mov    %ebx,%esi
  8002e0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002e2:	85 c0                	test   %eax,%eax
  8002e4:	7e 28                	jle    80030e <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002ea:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8002f1:	00 
  8002f2:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  8002f9:	00 
  8002fa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800301:	00 
  800302:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  800309:	e8 b2 0f 00 00       	call   8012c0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80030e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800311:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800314:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800317:	89 ec                	mov    %ebp,%esp
  800319:	5d                   	pop    %ebp
  80031a:	c3                   	ret    

0080031b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 38             	sub    $0x38,%esp
  800321:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800324:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800327:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80032a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80032f:	b8 08 00 00 00       	mov    $0x8,%eax
  800334:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800337:	8b 55 08             	mov    0x8(%ebp),%edx
  80033a:	89 df                	mov    %ebx,%edi
  80033c:	89 de                	mov    %ebx,%esi
  80033e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800340:	85 c0                	test   %eax,%eax
  800342:	7e 28                	jle    80036c <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800344:	89 44 24 10          	mov    %eax,0x10(%esp)
  800348:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80034f:	00 
  800350:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  800357:	00 
  800358:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80035f:	00 
  800360:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  800367:	e8 54 0f 00 00       	call   8012c0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80036c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80036f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800372:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800375:	89 ec                	mov    %ebp,%esp
  800377:	5d                   	pop    %ebp
  800378:	c3                   	ret    

00800379 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 38             	sub    $0x38,%esp
  80037f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800382:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800385:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800388:	bb 00 00 00 00       	mov    $0x0,%ebx
  80038d:	b8 09 00 00 00       	mov    $0x9,%eax
  800392:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800395:	8b 55 08             	mov    0x8(%ebp),%edx
  800398:	89 df                	mov    %ebx,%edi
  80039a:	89 de                	mov    %ebx,%esi
  80039c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80039e:	85 c0                	test   %eax,%eax
  8003a0:	7e 28                	jle    8003ca <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003a2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003a6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8003ad:	00 
  8003ae:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  8003b5:	00 
  8003b6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003bd:	00 
  8003be:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  8003c5:	e8 f6 0e 00 00       	call   8012c0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8003ca:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003cd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003d0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003d3:	89 ec                	mov    %ebp,%esp
  8003d5:	5d                   	pop    %ebp
  8003d6:	c3                   	ret    

008003d7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8003d7:	55                   	push   %ebp
  8003d8:	89 e5                	mov    %esp,%ebp
  8003da:	83 ec 38             	sub    $0x38,%esp
  8003dd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003e0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003e3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8003f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003f6:	89 df                	mov    %ebx,%edi
  8003f8:	89 de                	mov    %ebx,%esi
  8003fa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003fc:	85 c0                	test   %eax,%eax
  8003fe:	7e 28                	jle    800428 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800400:	89 44 24 10          	mov    %eax,0x10(%esp)
  800404:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80040b:	00 
  80040c:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  800413:	00 
  800414:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80041b:	00 
  80041c:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  800423:	e8 98 0e 00 00       	call   8012c0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800428:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80042b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80042e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800431:	89 ec                	mov    %ebp,%esp
  800433:	5d                   	pop    %ebp
  800434:	c3                   	ret    

00800435 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	83 ec 0c             	sub    $0xc,%esp
  80043b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80043e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800441:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800444:	be 00 00 00 00       	mov    $0x0,%esi
  800449:	b8 0c 00 00 00       	mov    $0xc,%eax
  80044e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800451:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800454:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800457:	8b 55 08             	mov    0x8(%ebp),%edx
  80045a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80045c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80045f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800462:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800465:	89 ec                	mov    %ebp,%esp
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    

00800469 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
  80046c:	83 ec 38             	sub    $0x38,%esp
  80046f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800472:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800475:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800478:	b9 00 00 00 00       	mov    $0x0,%ecx
  80047d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800482:	8b 55 08             	mov    0x8(%ebp),%edx
  800485:	89 cb                	mov    %ecx,%ebx
  800487:	89 cf                	mov    %ecx,%edi
  800489:	89 ce                	mov    %ecx,%esi
  80048b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80048d:	85 c0                	test   %eax,%eax
  80048f:	7e 28                	jle    8004b9 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800491:	89 44 24 10          	mov    %eax,0x10(%esp)
  800495:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80049c:	00 
  80049d:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  8004a4:	00 
  8004a5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004ac:	00 
  8004ad:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  8004b4:	e8 07 0e 00 00       	call   8012c0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8004b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004c2:	89 ec                	mov    %ebp,%esp
  8004c4:	5d                   	pop    %ebp
  8004c5:	c3                   	ret    
	...

008004d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8004db:	c1 e8 0c             	shr    $0xc,%eax
}
  8004de:	5d                   	pop    %ebp
  8004df:	c3                   	ret    

008004e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	89 04 24             	mov    %eax,(%esp)
  8004ec:	e8 df ff ff ff       	call   8004d0 <fd2num>
  8004f1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8004f6:	c1 e0 0c             	shl    $0xc,%eax
}
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	53                   	push   %ebx
  8004ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800502:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800507:	a8 01                	test   $0x1,%al
  800509:	74 34                	je     80053f <fd_alloc+0x44>
  80050b:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800510:	a8 01                	test   $0x1,%al
  800512:	74 32                	je     800546 <fd_alloc+0x4b>
  800514:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800519:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80051b:	89 c2                	mov    %eax,%edx
  80051d:	c1 ea 16             	shr    $0x16,%edx
  800520:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800527:	f6 c2 01             	test   $0x1,%dl
  80052a:	74 1f                	je     80054b <fd_alloc+0x50>
  80052c:	89 c2                	mov    %eax,%edx
  80052e:	c1 ea 0c             	shr    $0xc,%edx
  800531:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800538:	f6 c2 01             	test   $0x1,%dl
  80053b:	75 17                	jne    800554 <fd_alloc+0x59>
  80053d:	eb 0c                	jmp    80054b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80053f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800544:	eb 05                	jmp    80054b <fd_alloc+0x50>
  800546:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80054b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80054d:	b8 00 00 00 00       	mov    $0x0,%eax
  800552:	eb 17                	jmp    80056b <fd_alloc+0x70>
  800554:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800559:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80055e:	75 b9                	jne    800519 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800560:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  800566:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80056b:	5b                   	pop    %ebx
  80056c:	5d                   	pop    %ebp
  80056d:	c3                   	ret    

0080056e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800574:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800579:	83 fa 1f             	cmp    $0x1f,%edx
  80057c:	77 3f                	ja     8005bd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80057e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  800584:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800587:	89 d0                	mov    %edx,%eax
  800589:	c1 e8 16             	shr    $0x16,%eax
  80058c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800593:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800598:	f6 c1 01             	test   $0x1,%cl
  80059b:	74 20                	je     8005bd <fd_lookup+0x4f>
  80059d:	89 d0                	mov    %edx,%eax
  80059f:	c1 e8 0c             	shr    $0xc,%eax
  8005a2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8005a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8005ae:	f6 c1 01             	test   $0x1,%cl
  8005b1:	74 0a                	je     8005bd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8005b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b6:	89 10                	mov    %edx,(%eax)
	return 0;
  8005b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8005bd:	5d                   	pop    %ebp
  8005be:	c3                   	ret    

008005bf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
  8005c2:	53                   	push   %ebx
  8005c3:	83 ec 14             	sub    $0x14,%esp
  8005c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8005cc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8005d1:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  8005d7:	75 17                	jne    8005f0 <dev_lookup+0x31>
  8005d9:	eb 07                	jmp    8005e2 <dev_lookup+0x23>
  8005db:	39 0a                	cmp    %ecx,(%edx)
  8005dd:	75 11                	jne    8005f0 <dev_lookup+0x31>
  8005df:	90                   	nop
  8005e0:	eb 05                	jmp    8005e7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005e2:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8005e7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8005e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ee:	eb 35                	jmp    800625 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005f0:	83 c0 01             	add    $0x1,%eax
  8005f3:	8b 14 85 94 22 80 00 	mov    0x802294(,%eax,4),%edx
  8005fa:	85 d2                	test   %edx,%edx
  8005fc:	75 dd                	jne    8005db <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005fe:	a1 04 40 80 00       	mov    0x804004,%eax
  800603:	8b 40 48             	mov    0x48(%eax),%eax
  800606:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80060a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060e:	c7 04 24 18 22 80 00 	movl   $0x802218,(%esp)
  800615:	e8 a1 0d 00 00       	call   8013bb <cprintf>
	*dev = 0;
  80061a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  800620:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800625:	83 c4 14             	add    $0x14,%esp
  800628:	5b                   	pop    %ebx
  800629:	5d                   	pop    %ebp
  80062a:	c3                   	ret    

0080062b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80062b:	55                   	push   %ebp
  80062c:	89 e5                	mov    %esp,%ebp
  80062e:	83 ec 38             	sub    $0x38,%esp
  800631:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800634:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800637:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80063a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80063d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800641:	89 3c 24             	mov    %edi,(%esp)
  800644:	e8 87 fe ff ff       	call   8004d0 <fd2num>
  800649:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80064c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800650:	89 04 24             	mov    %eax,(%esp)
  800653:	e8 16 ff ff ff       	call   80056e <fd_lookup>
  800658:	89 c3                	mov    %eax,%ebx
  80065a:	85 c0                	test   %eax,%eax
  80065c:	78 05                	js     800663 <fd_close+0x38>
	    || fd != fd2)
  80065e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  800661:	74 0e                	je     800671 <fd_close+0x46>
		return (must_exist ? r : 0);
  800663:	89 f0                	mov    %esi,%eax
  800665:	84 c0                	test   %al,%al
  800667:	b8 00 00 00 00       	mov    $0x0,%eax
  80066c:	0f 44 d8             	cmove  %eax,%ebx
  80066f:	eb 3d                	jmp    8006ae <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800671:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800674:	89 44 24 04          	mov    %eax,0x4(%esp)
  800678:	8b 07                	mov    (%edi),%eax
  80067a:	89 04 24             	mov    %eax,(%esp)
  80067d:	e8 3d ff ff ff       	call   8005bf <dev_lookup>
  800682:	89 c3                	mov    %eax,%ebx
  800684:	85 c0                	test   %eax,%eax
  800686:	78 16                	js     80069e <fd_close+0x73>
		if (dev->dev_close)
  800688:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80068e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800693:	85 c0                	test   %eax,%eax
  800695:	74 07                	je     80069e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  800697:	89 3c 24             	mov    %edi,(%esp)
  80069a:	ff d0                	call   *%eax
  80069c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80069e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006a9:	e8 0f fc ff ff       	call   8002bd <sys_page_unmap>
	return r;
}
  8006ae:	89 d8                	mov    %ebx,%eax
  8006b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8006b3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8006b6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8006b9:	89 ec                	mov    %ebp,%esp
  8006bb:	5d                   	pop    %ebp
  8006bc:	c3                   	ret    

008006bd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8006c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	89 04 24             	mov    %eax,(%esp)
  8006d0:	e8 99 fe ff ff       	call   80056e <fd_lookup>
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	78 13                	js     8006ec <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8006d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8006e0:	00 
  8006e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006e4:	89 04 24             	mov    %eax,(%esp)
  8006e7:	e8 3f ff ff ff       	call   80062b <fd_close>
}
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <close_all>:

void
close_all(void)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	53                   	push   %ebx
  8006f2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006f5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006fa:	89 1c 24             	mov    %ebx,(%esp)
  8006fd:	e8 bb ff ff ff       	call   8006bd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800702:	83 c3 01             	add    $0x1,%ebx
  800705:	83 fb 20             	cmp    $0x20,%ebx
  800708:	75 f0                	jne    8006fa <close_all+0xc>
		close(i);
}
  80070a:	83 c4 14             	add    $0x14,%esp
  80070d:	5b                   	pop    %ebx
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	83 ec 58             	sub    $0x58,%esp
  800716:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800719:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80071c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80071f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800722:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800725:	89 44 24 04          	mov    %eax,0x4(%esp)
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 04 24             	mov    %eax,(%esp)
  80072f:	e8 3a fe ff ff       	call   80056e <fd_lookup>
  800734:	89 c3                	mov    %eax,%ebx
  800736:	85 c0                	test   %eax,%eax
  800738:	0f 88 e1 00 00 00    	js     80081f <dup+0x10f>
		return r;
	close(newfdnum);
  80073e:	89 3c 24             	mov    %edi,(%esp)
  800741:	e8 77 ff ff ff       	call   8006bd <close>

	newfd = INDEX2FD(newfdnum);
  800746:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80074c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80074f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800752:	89 04 24             	mov    %eax,(%esp)
  800755:	e8 86 fd ff ff       	call   8004e0 <fd2data>
  80075a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80075c:	89 34 24             	mov    %esi,(%esp)
  80075f:	e8 7c fd ff ff       	call   8004e0 <fd2data>
  800764:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800767:	89 d8                	mov    %ebx,%eax
  800769:	c1 e8 16             	shr    $0x16,%eax
  80076c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800773:	a8 01                	test   $0x1,%al
  800775:	74 46                	je     8007bd <dup+0xad>
  800777:	89 d8                	mov    %ebx,%eax
  800779:	c1 e8 0c             	shr    $0xc,%eax
  80077c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800783:	f6 c2 01             	test   $0x1,%dl
  800786:	74 35                	je     8007bd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800788:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80078f:	25 07 0e 00 00       	and    $0xe07,%eax
  800794:	89 44 24 10          	mov    %eax,0x10(%esp)
  800798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80079b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80079f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007a6:	00 
  8007a7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007b2:	e8 a8 fa ff ff       	call   80025f <sys_page_map>
  8007b7:	89 c3                	mov    %eax,%ebx
  8007b9:	85 c0                	test   %eax,%eax
  8007bb:	78 3b                	js     8007f8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8007bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	c1 ea 0c             	shr    $0xc,%edx
  8007c5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007cc:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8007d2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007d6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007e1:	00 
  8007e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007ed:	e8 6d fa ff ff       	call   80025f <sys_page_map>
  8007f2:	89 c3                	mov    %eax,%ebx
  8007f4:	85 c0                	test   %eax,%eax
  8007f6:	79 25                	jns    80081d <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800803:	e8 b5 fa ff ff       	call   8002bd <sys_page_unmap>
	sys_page_unmap(0, nva);
  800808:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80080b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800816:	e8 a2 fa ff ff       	call   8002bd <sys_page_unmap>
	return r;
  80081b:	eb 02                	jmp    80081f <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  80081d:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80081f:	89 d8                	mov    %ebx,%eax
  800821:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800824:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800827:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80082a:	89 ec                	mov    %ebp,%esp
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	53                   	push   %ebx
  800832:	83 ec 24             	sub    $0x24,%esp
  800835:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800838:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80083b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083f:	89 1c 24             	mov    %ebx,(%esp)
  800842:	e8 27 fd ff ff       	call   80056e <fd_lookup>
  800847:	85 c0                	test   %eax,%eax
  800849:	78 6d                	js     8008b8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80084b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80084e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	89 04 24             	mov    %eax,(%esp)
  80085a:	e8 60 fd ff ff       	call   8005bf <dev_lookup>
  80085f:	85 c0                	test   %eax,%eax
  800861:	78 55                	js     8008b8 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800866:	8b 50 08             	mov    0x8(%eax),%edx
  800869:	83 e2 03             	and    $0x3,%edx
  80086c:	83 fa 01             	cmp    $0x1,%edx
  80086f:	75 23                	jne    800894 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800871:	a1 04 40 80 00       	mov    0x804004,%eax
  800876:	8b 40 48             	mov    0x48(%eax),%eax
  800879:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80087d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800881:	c7 04 24 59 22 80 00 	movl   $0x802259,(%esp)
  800888:	e8 2e 0b 00 00       	call   8013bb <cprintf>
		return -E_INVAL;
  80088d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800892:	eb 24                	jmp    8008b8 <read+0x8a>
	}
	if (!dev->dev_read)
  800894:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800897:	8b 52 08             	mov    0x8(%edx),%edx
  80089a:	85 d2                	test   %edx,%edx
  80089c:	74 15                	je     8008b3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80089e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008a1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008ac:	89 04 24             	mov    %eax,(%esp)
  8008af:	ff d2                	call   *%edx
  8008b1:	eb 05                	jmp    8008b8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8008b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8008b8:	83 c4 24             	add    $0x24,%esp
  8008bb:	5b                   	pop    %ebx
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    

008008be <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	57                   	push   %edi
  8008c2:	56                   	push   %esi
  8008c3:	53                   	push   %ebx
  8008c4:	83 ec 1c             	sub    $0x1c,%esp
  8008c7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ca:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d2:	85 f6                	test   %esi,%esi
  8008d4:	74 30                	je     800906 <readn+0x48>
  8008d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8008db:	89 f2                	mov    %esi,%edx
  8008dd:	29 c2                	sub    %eax,%edx
  8008df:	89 54 24 08          	mov    %edx,0x8(%esp)
  8008e3:	03 45 0c             	add    0xc(%ebp),%eax
  8008e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ea:	89 3c 24             	mov    %edi,(%esp)
  8008ed:	e8 3c ff ff ff       	call   80082e <read>
		if (m < 0)
  8008f2:	85 c0                	test   %eax,%eax
  8008f4:	78 10                	js     800906 <readn+0x48>
			return m;
		if (m == 0)
  8008f6:	85 c0                	test   %eax,%eax
  8008f8:	74 0a                	je     800904 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008fa:	01 c3                	add    %eax,%ebx
  8008fc:	89 d8                	mov    %ebx,%eax
  8008fe:	39 f3                	cmp    %esi,%ebx
  800900:	72 d9                	jb     8008db <readn+0x1d>
  800902:	eb 02                	jmp    800906 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  800904:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  800906:	83 c4 1c             	add    $0x1c,%esp
  800909:	5b                   	pop    %ebx
  80090a:	5e                   	pop    %esi
  80090b:	5f                   	pop    %edi
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	53                   	push   %ebx
  800912:	83 ec 24             	sub    $0x24,%esp
  800915:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800918:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80091b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091f:	89 1c 24             	mov    %ebx,(%esp)
  800922:	e8 47 fc ff ff       	call   80056e <fd_lookup>
  800927:	85 c0                	test   %eax,%eax
  800929:	78 68                	js     800993 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80092b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80092e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	89 04 24             	mov    %eax,(%esp)
  80093a:	e8 80 fc ff ff       	call   8005bf <dev_lookup>
  80093f:	85 c0                	test   %eax,%eax
  800941:	78 50                	js     800993 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800946:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80094a:	75 23                	jne    80096f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80094c:	a1 04 40 80 00       	mov    0x804004,%eax
  800951:	8b 40 48             	mov    0x48(%eax),%eax
  800954:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095c:	c7 04 24 75 22 80 00 	movl   $0x802275,(%esp)
  800963:	e8 53 0a 00 00       	call   8013bb <cprintf>
		return -E_INVAL;
  800968:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80096d:	eb 24                	jmp    800993 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80096f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800972:	8b 52 0c             	mov    0xc(%edx),%edx
  800975:	85 d2                	test   %edx,%edx
  800977:	74 15                	je     80098e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800979:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80097c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800980:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800983:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800987:	89 04 24             	mov    %eax,(%esp)
  80098a:	ff d2                	call   *%edx
  80098c:	eb 05                	jmp    800993 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80098e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800993:	83 c4 24             	add    $0x24,%esp
  800996:	5b                   	pop    %ebx
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    

00800999 <seek>:

int
seek(int fdnum, off_t offset)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80099f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8009a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	89 04 24             	mov    %eax,(%esp)
  8009ac:	e8 bd fb ff ff       	call   80056e <fd_lookup>
  8009b1:	85 c0                	test   %eax,%eax
  8009b3:	78 0e                	js     8009c3 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8009be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c3:	c9                   	leave  
  8009c4:	c3                   	ret    

008009c5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	53                   	push   %ebx
  8009c9:	83 ec 24             	sub    $0x24,%esp
  8009cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d6:	89 1c 24             	mov    %ebx,(%esp)
  8009d9:	e8 90 fb ff ff       	call   80056e <fd_lookup>
  8009de:	85 c0                	test   %eax,%eax
  8009e0:	78 61                	js     800a43 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	89 04 24             	mov    %eax,(%esp)
  8009f1:	e8 c9 fb ff ff       	call   8005bf <dev_lookup>
  8009f6:	85 c0                	test   %eax,%eax
  8009f8:	78 49                	js     800a43 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800a01:	75 23                	jne    800a26 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800a03:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800a08:	8b 40 48             	mov    0x48(%eax),%eax
  800a0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a13:	c7 04 24 38 22 80 00 	movl   $0x802238,(%esp)
  800a1a:	e8 9c 09 00 00       	call   8013bb <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800a1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a24:	eb 1d                	jmp    800a43 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  800a26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a29:	8b 52 18             	mov    0x18(%edx),%edx
  800a2c:	85 d2                	test   %edx,%edx
  800a2e:	74 0e                	je     800a3e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800a30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a37:	89 04 24             	mov    %eax,(%esp)
  800a3a:	ff d2                	call   *%edx
  800a3c:	eb 05                	jmp    800a43 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800a3e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800a43:	83 c4 24             	add    $0x24,%esp
  800a46:	5b                   	pop    %ebx
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	53                   	push   %ebx
  800a4d:	83 ec 24             	sub    $0x24,%esp
  800a50:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a53:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	89 04 24             	mov    %eax,(%esp)
  800a60:	e8 09 fb ff ff       	call   80056e <fd_lookup>
  800a65:	85 c0                	test   %eax,%eax
  800a67:	78 52                	js     800abb <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a73:	8b 00                	mov    (%eax),%eax
  800a75:	89 04 24             	mov    %eax,(%esp)
  800a78:	e8 42 fb ff ff       	call   8005bf <dev_lookup>
  800a7d:	85 c0                	test   %eax,%eax
  800a7f:	78 3a                	js     800abb <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  800a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a84:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a88:	74 2c                	je     800ab6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a8a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a8d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a94:	00 00 00 
	stat->st_isdir = 0;
  800a97:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a9e:	00 00 00 
	stat->st_dev = dev;
  800aa1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800aa7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800aae:	89 14 24             	mov    %edx,(%esp)
  800ab1:	ff 50 14             	call   *0x14(%eax)
  800ab4:	eb 05                	jmp    800abb <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800ab6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800abb:	83 c4 24             	add    $0x24,%esp
  800abe:	5b                   	pop    %ebx
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	83 ec 18             	sub    $0x18,%esp
  800ac7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800aca:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800acd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800ad4:	00 
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	89 04 24             	mov    %eax,(%esp)
  800adb:	e8 bc 01 00 00       	call   800c9c <open>
  800ae0:	89 c3                	mov    %eax,%ebx
  800ae2:	85 c0                	test   %eax,%eax
  800ae4:	78 1b                	js     800b01 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aed:	89 1c 24             	mov    %ebx,(%esp)
  800af0:	e8 54 ff ff ff       	call   800a49 <fstat>
  800af5:	89 c6                	mov    %eax,%esi
	close(fd);
  800af7:	89 1c 24             	mov    %ebx,(%esp)
  800afa:	e8 be fb ff ff       	call   8006bd <close>
	return r;
  800aff:	89 f3                	mov    %esi,%ebx
}
  800b01:	89 d8                	mov    %ebx,%eax
  800b03:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800b06:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800b09:	89 ec                	mov    %ebp,%esp
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    
  800b0d:	00 00                	add    %al,(%eax)
	...

00800b10 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 18             	sub    $0x18,%esp
  800b16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800b19:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800b1c:	89 c3                	mov    %eax,%ebx
  800b1e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  800b20:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800b27:	75 11                	jne    800b3a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800b29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800b30:	e8 61 13 00 00       	call   801e96 <ipc_find_env>
  800b35:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800b3a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800b41:	00 
  800b42:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800b49:	00 
  800b4a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b4e:	a1 00 40 80 00       	mov    0x804000,%eax
  800b53:	89 04 24             	mov    %eax,(%esp)
  800b56:	e8 b7 12 00 00       	call   801e12 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800b5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b62:	00 
  800b63:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b6e:	e8 4d 12 00 00       	call   801dc0 <ipc_recv>
}
  800b73:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800b76:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800b79:	89 ec                	mov    %ebp,%esp
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	53                   	push   %ebx
  800b81:	83 ec 14             	sub    $0x14,%esp
  800b84:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	8b 40 0c             	mov    0xc(%eax),%eax
  800b8d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b92:	ba 00 00 00 00       	mov    $0x0,%edx
  800b97:	b8 05 00 00 00       	mov    $0x5,%eax
  800b9c:	e8 6f ff ff ff       	call   800b10 <fsipc>
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	78 2b                	js     800bd0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800ba5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800bac:	00 
  800bad:	89 1c 24             	mov    %ebx,(%esp)
  800bb0:	e8 26 0e 00 00       	call   8019db <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800bb5:	a1 80 50 80 00       	mov    0x805080,%eax
  800bba:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800bc0:	a1 84 50 80 00       	mov    0x805084,%eax
  800bc5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800bcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd0:	83 c4 14             	add    $0x14,%esp
  800bd3:	5b                   	pop    %ebx
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8b 40 0c             	mov    0xc(%eax),%eax
  800be2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800be7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bec:	b8 06 00 00 00       	mov    $0x6,%eax
  800bf1:	e8 1a ff ff ff       	call   800b10 <fsipc>
}
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	83 ec 10             	sub    $0x10,%esp
  800c00:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8b 40 0c             	mov    0xc(%eax),%eax
  800c09:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800c0e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800c14:	ba 00 00 00 00       	mov    $0x0,%edx
  800c19:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1e:	e8 ed fe ff ff       	call   800b10 <fsipc>
  800c23:	89 c3                	mov    %eax,%ebx
  800c25:	85 c0                	test   %eax,%eax
  800c27:	78 6a                	js     800c93 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800c29:	39 c6                	cmp    %eax,%esi
  800c2b:	73 24                	jae    800c51 <devfile_read+0x59>
  800c2d:	c7 44 24 0c a4 22 80 	movl   $0x8022a4,0xc(%esp)
  800c34:	00 
  800c35:	c7 44 24 08 ab 22 80 	movl   $0x8022ab,0x8(%esp)
  800c3c:	00 
  800c3d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800c44:	00 
  800c45:	c7 04 24 c0 22 80 00 	movl   $0x8022c0,(%esp)
  800c4c:	e8 6f 06 00 00       	call   8012c0 <_panic>
	assert(r <= PGSIZE);
  800c51:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c56:	7e 24                	jle    800c7c <devfile_read+0x84>
  800c58:	c7 44 24 0c cb 22 80 	movl   $0x8022cb,0xc(%esp)
  800c5f:	00 
  800c60:	c7 44 24 08 ab 22 80 	movl   $0x8022ab,0x8(%esp)
  800c67:	00 
  800c68:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800c6f:	00 
  800c70:	c7 04 24 c0 22 80 00 	movl   $0x8022c0,(%esp)
  800c77:	e8 44 06 00 00       	call   8012c0 <_panic>
	memmove(buf, &fsipcbuf, r);
  800c7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c80:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c87:	00 
  800c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8b:	89 04 24             	mov    %eax,(%esp)
  800c8e:	e8 39 0f 00 00       	call   801bcc <memmove>
	return r;
}
  800c93:	89 d8                	mov    %ebx,%eax
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 20             	sub    $0x20,%esp
  800ca4:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800ca7:	89 34 24             	mov    %esi,(%esp)
  800caa:	e8 e1 0c 00 00       	call   801990 <strlen>
		return -E_BAD_PATH;
  800caf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800cb4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800cb9:	7f 5e                	jg     800d19 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800cbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cbe:	89 04 24             	mov    %eax,(%esp)
  800cc1:	e8 35 f8 ff ff       	call   8004fb <fd_alloc>
  800cc6:	89 c3                	mov    %eax,%ebx
  800cc8:	85 c0                	test   %eax,%eax
  800cca:	78 4d                	js     800d19 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800ccc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cd0:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800cd7:	e8 ff 0c 00 00       	call   8019db <strcpy>
	fsipcbuf.open.req_omode = mode;
  800cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdf:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ce4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce7:	b8 01 00 00 00       	mov    $0x1,%eax
  800cec:	e8 1f fe ff ff       	call   800b10 <fsipc>
  800cf1:	89 c3                	mov    %eax,%ebx
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	79 15                	jns    800d0c <open+0x70>
		fd_close(fd, 0);
  800cf7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800cfe:	00 
  800cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d02:	89 04 24             	mov    %eax,(%esp)
  800d05:	e8 21 f9 ff ff       	call   80062b <fd_close>
		return r;
  800d0a:	eb 0d                	jmp    800d19 <open+0x7d>
	}

	return fd2num(fd);
  800d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d0f:	89 04 24             	mov    %eax,(%esp)
  800d12:	e8 b9 f7 ff ff       	call   8004d0 <fd2num>
  800d17:	89 c3                	mov    %eax,%ebx
}
  800d19:	89 d8                	mov    %ebx,%eax
  800d1b:	83 c4 20             	add    $0x20,%esp
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    
	...

00800d30 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 18             	sub    $0x18,%esp
  800d36:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800d39:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800d3c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	89 04 24             	mov    %eax,(%esp)
  800d45:	e8 96 f7 ff ff       	call   8004e0 <fd2data>
  800d4a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  800d4c:	c7 44 24 04 d7 22 80 	movl   $0x8022d7,0x4(%esp)
  800d53:	00 
  800d54:	89 34 24             	mov    %esi,(%esp)
  800d57:	e8 7f 0c 00 00       	call   8019db <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800d5c:	8b 43 04             	mov    0x4(%ebx),%eax
  800d5f:	2b 03                	sub    (%ebx),%eax
  800d61:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  800d67:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  800d6e:	00 00 00 
	stat->st_dev = &devpipe;
  800d71:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  800d78:	30 80 00 
	return 0;
}
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d80:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800d83:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800d86:	89 ec                	mov    %ebp,%esp
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 14             	sub    $0x14,%esp
  800d91:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800d94:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d9f:	e8 19 f5 ff ff       	call   8002bd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800da4:	89 1c 24             	mov    %ebx,(%esp)
  800da7:	e8 34 f7 ff ff       	call   8004e0 <fd2data>
  800dac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800db0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800db7:	e8 01 f5 ff ff       	call   8002bd <sys_page_unmap>
}
  800dbc:	83 c4 14             	add    $0x14,%esp
  800dbf:	5b                   	pop    %ebx
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 2c             	sub    $0x2c,%esp
  800dcb:	89 c7                	mov    %eax,%edi
  800dcd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800dd0:	a1 04 40 80 00       	mov    0x804004,%eax
  800dd5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800dd8:	89 3c 24             	mov    %edi,(%esp)
  800ddb:	e8 00 11 00 00       	call   801ee0 <pageref>
  800de0:	89 c6                	mov    %eax,%esi
  800de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800de5:	89 04 24             	mov    %eax,(%esp)
  800de8:	e8 f3 10 00 00       	call   801ee0 <pageref>
  800ded:	39 c6                	cmp    %eax,%esi
  800def:	0f 94 c0             	sete   %al
  800df2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  800df5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800dfb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800dfe:	39 cb                	cmp    %ecx,%ebx
  800e00:	75 08                	jne    800e0a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  800e02:	83 c4 2c             	add    $0x2c,%esp
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  800e0a:	83 f8 01             	cmp    $0x1,%eax
  800e0d:	75 c1                	jne    800dd0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800e0f:	8b 52 58             	mov    0x58(%edx),%edx
  800e12:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e16:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e1a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800e1e:	c7 04 24 de 22 80 00 	movl   $0x8022de,(%esp)
  800e25:	e8 91 05 00 00       	call   8013bb <cprintf>
  800e2a:	eb a4                	jmp    800dd0 <_pipeisclosed+0xe>

00800e2c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	57                   	push   %edi
  800e30:	56                   	push   %esi
  800e31:	53                   	push   %ebx
  800e32:	83 ec 2c             	sub    $0x2c,%esp
  800e35:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800e38:	89 34 24             	mov    %esi,(%esp)
  800e3b:	e8 a0 f6 ff ff       	call   8004e0 <fd2data>
  800e40:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e42:	bf 00 00 00 00       	mov    $0x0,%edi
  800e47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e4b:	75 50                	jne    800e9d <devpipe_write+0x71>
  800e4d:	eb 5c                	jmp    800eab <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800e4f:	89 da                	mov    %ebx,%edx
  800e51:	89 f0                	mov    %esi,%eax
  800e53:	e8 6a ff ff ff       	call   800dc2 <_pipeisclosed>
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	75 53                	jne    800eaf <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800e5c:	e8 6f f3 ff ff       	call   8001d0 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e61:	8b 43 04             	mov    0x4(%ebx),%eax
  800e64:	8b 13                	mov    (%ebx),%edx
  800e66:	83 c2 20             	add    $0x20,%edx
  800e69:	39 d0                	cmp    %edx,%eax
  800e6b:	73 e2                	jae    800e4f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e70:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  800e74:	88 55 e7             	mov    %dl,-0x19(%ebp)
  800e77:	89 c2                	mov    %eax,%edx
  800e79:	c1 fa 1f             	sar    $0x1f,%edx
  800e7c:	c1 ea 1b             	shr    $0x1b,%edx
  800e7f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800e82:	83 e1 1f             	and    $0x1f,%ecx
  800e85:	29 d1                	sub    %edx,%ecx
  800e87:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800e8b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800e8f:	83 c0 01             	add    $0x1,%eax
  800e92:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e95:	83 c7 01             	add    $0x1,%edi
  800e98:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800e9b:	74 0e                	je     800eab <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e9d:	8b 43 04             	mov    0x4(%ebx),%eax
  800ea0:	8b 13                	mov    (%ebx),%edx
  800ea2:	83 c2 20             	add    $0x20,%edx
  800ea5:	39 d0                	cmp    %edx,%eax
  800ea7:	73 a6                	jae    800e4f <devpipe_write+0x23>
  800ea9:	eb c2                	jmp    800e6d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800eab:	89 f8                	mov    %edi,%eax
  800ead:	eb 05                	jmp    800eb4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800eaf:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800eb4:	83 c4 2c             	add    $0x2c,%esp
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 28             	sub    $0x28,%esp
  800ec2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ec5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ec8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800ecb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800ece:	89 3c 24             	mov    %edi,(%esp)
  800ed1:	e8 0a f6 ff ff       	call   8004e0 <fd2data>
  800ed6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ed8:	be 00 00 00 00       	mov    $0x0,%esi
  800edd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee1:	75 47                	jne    800f2a <devpipe_read+0x6e>
  800ee3:	eb 52                	jmp    800f37 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800ee5:	89 f0                	mov    %esi,%eax
  800ee7:	eb 5e                	jmp    800f47 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800ee9:	89 da                	mov    %ebx,%edx
  800eeb:	89 f8                	mov    %edi,%eax
  800eed:	8d 76 00             	lea    0x0(%esi),%esi
  800ef0:	e8 cd fe ff ff       	call   800dc2 <_pipeisclosed>
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 49                	jne    800f42 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800ef9:	e8 d2 f2 ff ff       	call   8001d0 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800efe:	8b 03                	mov    (%ebx),%eax
  800f00:	3b 43 04             	cmp    0x4(%ebx),%eax
  800f03:	74 e4                	je     800ee9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800f05:	89 c2                	mov    %eax,%edx
  800f07:	c1 fa 1f             	sar    $0x1f,%edx
  800f0a:	c1 ea 1b             	shr    $0x1b,%edx
  800f0d:	01 d0                	add    %edx,%eax
  800f0f:	83 e0 1f             	and    $0x1f,%eax
  800f12:	29 d0                	sub    %edx,%eax
  800f14:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800f19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  800f1f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800f22:	83 c6 01             	add    $0x1,%esi
  800f25:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f28:	74 0d                	je     800f37 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  800f2a:	8b 03                	mov    (%ebx),%eax
  800f2c:	3b 43 04             	cmp    0x4(%ebx),%eax
  800f2f:	75 d4                	jne    800f05 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800f31:	85 f6                	test   %esi,%esi
  800f33:	75 b0                	jne    800ee5 <devpipe_read+0x29>
  800f35:	eb b2                	jmp    800ee9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800f37:	89 f0                	mov    %esi,%eax
  800f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f40:	eb 05                	jmp    800f47 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800f42:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800f47:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f4a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f4d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f50:	89 ec                	mov    %ebp,%esp
  800f52:	5d                   	pop    %ebp
  800f53:	c3                   	ret    

00800f54 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	83 ec 48             	sub    $0x48,%esp
  800f5a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f5d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f60:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800f63:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800f66:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f69:	89 04 24             	mov    %eax,(%esp)
  800f6c:	e8 8a f5 ff ff       	call   8004fb <fd_alloc>
  800f71:	89 c3                	mov    %eax,%ebx
  800f73:	85 c0                	test   %eax,%eax
  800f75:	0f 88 45 01 00 00    	js     8010c0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f7b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f82:	00 
  800f83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f86:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f91:	e8 6a f2 ff ff       	call   800200 <sys_page_alloc>
  800f96:	89 c3                	mov    %eax,%ebx
  800f98:	85 c0                	test   %eax,%eax
  800f9a:	0f 88 20 01 00 00    	js     8010c0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800fa0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fa3:	89 04 24             	mov    %eax,(%esp)
  800fa6:	e8 50 f5 ff ff       	call   8004fb <fd_alloc>
  800fab:	89 c3                	mov    %eax,%ebx
  800fad:	85 c0                	test   %eax,%eax
  800faf:	0f 88 f8 00 00 00    	js     8010ad <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800fb5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800fbc:	00 
  800fbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fc4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fcb:	e8 30 f2 ff ff       	call   800200 <sys_page_alloc>
  800fd0:	89 c3                	mov    %eax,%ebx
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	0f 88 d3 00 00 00    	js     8010ad <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800fda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fdd:	89 04 24             	mov    %eax,(%esp)
  800fe0:	e8 fb f4 ff ff       	call   8004e0 <fd2data>
  800fe5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800fe7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800fee:	00 
  800fef:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ffa:	e8 01 f2 ff ff       	call   800200 <sys_page_alloc>
  800fff:	89 c3                	mov    %eax,%ebx
  801001:	85 c0                	test   %eax,%eax
  801003:	0f 88 91 00 00 00    	js     80109a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801009:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80100c:	89 04 24             	mov    %eax,(%esp)
  80100f:	e8 cc f4 ff ff       	call   8004e0 <fd2data>
  801014:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  80101b:	00 
  80101c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801020:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801027:	00 
  801028:	89 74 24 04          	mov    %esi,0x4(%esp)
  80102c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801033:	e8 27 f2 ff ff       	call   80025f <sys_page_map>
  801038:	89 c3                	mov    %eax,%ebx
  80103a:	85 c0                	test   %eax,%eax
  80103c:	78 4c                	js     80108a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80103e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801047:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801049:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80104c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801053:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801059:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80105c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80105e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801061:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80106b:	89 04 24             	mov    %eax,(%esp)
  80106e:	e8 5d f4 ff ff       	call   8004d0 <fd2num>
  801073:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801075:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801078:	89 04 24             	mov    %eax,(%esp)
  80107b:	e8 50 f4 ff ff       	call   8004d0 <fd2num>
  801080:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801083:	bb 00 00 00 00       	mov    $0x0,%ebx
  801088:	eb 36                	jmp    8010c0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80108a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80108e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801095:	e8 23 f2 ff ff       	call   8002bd <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80109a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80109d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010a8:	e8 10 f2 ff ff       	call   8002bd <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8010ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010bb:	e8 fd f1 ff ff       	call   8002bd <sys_page_unmap>
    err:
	return r;
}
  8010c0:	89 d8                	mov    %ebx,%eax
  8010c2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010c5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010c8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010cb:	89 ec                	mov    %ebp,%esp
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    

008010cf <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	89 04 24             	mov    %eax,(%esp)
  8010e2:	e8 87 f4 ff ff       	call   80056e <fd_lookup>
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	78 15                	js     801100 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8010eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ee:	89 04 24             	mov    %eax,(%esp)
  8010f1:	e8 ea f3 ff ff       	call   8004e0 <fd2data>
	return _pipeisclosed(fd, p);
  8010f6:	89 c2                	mov    %eax,%edx
  8010f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010fb:	e8 c2 fc ff ff       	call   800dc2 <_pipeisclosed>
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    
	...

00801110 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801113:	b8 00 00 00 00       	mov    $0x0,%eax
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    

0080111a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801120:	c7 44 24 04 f6 22 80 	movl   $0x8022f6,0x4(%esp)
  801127:	00 
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	89 04 24             	mov    %eax,(%esp)
  80112e:	e8 a8 08 00 00       	call   8019db <strcpy>
	return 0;
}
  801133:	b8 00 00 00 00       	mov    $0x0,%eax
  801138:	c9                   	leave  
  801139:	c3                   	ret    

0080113a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	57                   	push   %edi
  80113e:	56                   	push   %esi
  80113f:	53                   	push   %ebx
  801140:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801146:	be 00 00 00 00       	mov    $0x0,%esi
  80114b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114f:	74 43                	je     801194 <devcons_write+0x5a>
  801151:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801156:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80115c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80115f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801161:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801164:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801169:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80116c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801170:	03 45 0c             	add    0xc(%ebp),%eax
  801173:	89 44 24 04          	mov    %eax,0x4(%esp)
  801177:	89 3c 24             	mov    %edi,(%esp)
  80117a:	e8 4d 0a 00 00       	call   801bcc <memmove>
		sys_cputs(buf, m);
  80117f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801183:	89 3c 24             	mov    %edi,(%esp)
  801186:	e8 59 ef ff ff       	call   8000e4 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80118b:	01 de                	add    %ebx,%esi
  80118d:	89 f0                	mov    %esi,%eax
  80118f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801192:	72 c8                	jb     80115c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801194:	89 f0                	mov    %esi,%eax
  801196:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80119c:	5b                   	pop    %ebx
  80119d:	5e                   	pop    %esi
  80119e:	5f                   	pop    %edi
  80119f:	5d                   	pop    %ebp
  8011a0:	c3                   	ret    

008011a1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8011a7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8011ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b0:	75 07                	jne    8011b9 <devcons_read+0x18>
  8011b2:	eb 31                	jmp    8011e5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8011b4:	e8 17 f0 ff ff       	call   8001d0 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8011b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011c0:	e8 4e ef ff ff       	call   800113 <sys_cgetc>
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	74 eb                	je     8011b4 <devcons_read+0x13>
  8011c9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	78 16                	js     8011e5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8011cf:	83 f8 04             	cmp    $0x4,%eax
  8011d2:	74 0c                	je     8011e0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	88 10                	mov    %dl,(%eax)
	return 1;
  8011d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8011de:	eb 05                	jmp    8011e5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8011e0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

008011e7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8011f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011fa:	00 
  8011fb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8011fe:	89 04 24             	mov    %eax,(%esp)
  801201:	e8 de ee ff ff       	call   8000e4 <sys_cputs>
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <getchar>:

int
getchar(void)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80120e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801215:	00 
  801216:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801219:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801224:	e8 05 f6 ff ff       	call   80082e <read>
	if (r < 0)
  801229:	85 c0                	test   %eax,%eax
  80122b:	78 0f                	js     80123c <getchar+0x34>
		return r;
	if (r < 1)
  80122d:	85 c0                	test   %eax,%eax
  80122f:	7e 06                	jle    801237 <getchar+0x2f>
		return -E_EOF;
	return c;
  801231:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801235:	eb 05                	jmp    80123c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801237:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801244:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	89 04 24             	mov    %eax,(%esp)
  801251:	e8 18 f3 ff ff       	call   80056e <fd_lookup>
  801256:	85 c0                	test   %eax,%eax
  801258:	78 11                	js     80126b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80125a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801263:	39 10                	cmp    %edx,(%eax)
  801265:	0f 94 c0             	sete   %al
  801268:	0f b6 c0             	movzbl %al,%eax
}
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <opencons>:

int
opencons(void)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801273:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801276:	89 04 24             	mov    %eax,(%esp)
  801279:	e8 7d f2 ff ff       	call   8004fb <fd_alloc>
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 3c                	js     8012be <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801282:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801289:	00 
  80128a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801291:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801298:	e8 63 ef ff ff       	call   800200 <sys_page_alloc>
  80129d:	85 c0                	test   %eax,%eax
  80129f:	78 1d                	js     8012be <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8012a1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012aa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8012ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012af:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8012b6:	89 04 24             	mov    %eax,(%esp)
  8012b9:	e8 12 f2 ff ff       	call   8004d0 <fd2num>
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	56                   	push   %esi
  8012c4:	53                   	push   %ebx
  8012c5:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8012c8:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8012cb:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8012d1:	e8 ca ee ff ff       	call   8001a0 <sys_getenvid>
  8012d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ec:	c7 04 24 04 23 80 00 	movl   $0x802304,(%esp)
  8012f3:	e8 c3 00 00 00       	call   8013bb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	89 04 24             	mov    %eax,(%esp)
  801302:	e8 53 00 00 00       	call   80135a <vcprintf>
	cprintf("\n");
  801307:	c7 04 24 ef 22 80 00 	movl   $0x8022ef,(%esp)
  80130e:	e8 a8 00 00 00       	call   8013bb <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801313:	cc                   	int3   
  801314:	eb fd                	jmp    801313 <_panic+0x53>
	...

00801318 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	53                   	push   %ebx
  80131c:	83 ec 14             	sub    $0x14,%esp
  80131f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801322:	8b 03                	mov    (%ebx),%eax
  801324:	8b 55 08             	mov    0x8(%ebp),%edx
  801327:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80132b:	83 c0 01             	add    $0x1,%eax
  80132e:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801330:	3d ff 00 00 00       	cmp    $0xff,%eax
  801335:	75 19                	jne    801350 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801337:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80133e:	00 
  80133f:	8d 43 08             	lea    0x8(%ebx),%eax
  801342:	89 04 24             	mov    %eax,(%esp)
  801345:	e8 9a ed ff ff       	call   8000e4 <sys_cputs>
		b->idx = 0;
  80134a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801350:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801354:	83 c4 14             	add    $0x14,%esp
  801357:	5b                   	pop    %ebx
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    

0080135a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801363:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80136a:	00 00 00 
	b.cnt = 0;
  80136d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801374:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	89 44 24 08          	mov    %eax,0x8(%esp)
  801385:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80138b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138f:	c7 04 24 18 13 80 00 	movl   $0x801318,(%esp)
  801396:	e8 9f 01 00 00       	call   80153a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80139b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8013a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8013ab:	89 04 24             	mov    %eax,(%esp)
  8013ae:	e8 31 ed ff ff       	call   8000e4 <sys_cputs>

	return b.cnt;
}
  8013b3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8013c1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8013c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	89 04 24             	mov    %eax,(%esp)
  8013ce:	e8 87 ff ff ff       	call   80135a <vcprintf>
	va_end(ap);

	return cnt;
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    
	...

008013e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	57                   	push   %edi
  8013e4:	56                   	push   %esi
  8013e5:	53                   	push   %ebx
  8013e6:	83 ec 3c             	sub    $0x3c,%esp
  8013e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013ec:	89 d7                	mov    %edx,%edi
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013fd:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801400:	b8 00 00 00 00       	mov    $0x0,%eax
  801405:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801408:	72 11                	jb     80141b <printnum+0x3b>
  80140a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80140d:	39 45 10             	cmp    %eax,0x10(%ebp)
  801410:	76 09                	jbe    80141b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801412:	83 eb 01             	sub    $0x1,%ebx
  801415:	85 db                	test   %ebx,%ebx
  801417:	7f 51                	jg     80146a <printnum+0x8a>
  801419:	eb 5e                	jmp    801479 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80141b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80141f:	83 eb 01             	sub    $0x1,%ebx
  801422:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801426:	8b 45 10             	mov    0x10(%ebp),%eax
  801429:	89 44 24 08          	mov    %eax,0x8(%esp)
  80142d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  801431:	8b 74 24 0c          	mov    0xc(%esp),%esi
  801435:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80143c:	00 
  80143d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801440:	89 04 24             	mov    %eax,(%esp)
  801443:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801446:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144a:	e8 d1 0a 00 00       	call   801f20 <__udivdi3>
  80144f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801453:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801457:	89 04 24             	mov    %eax,(%esp)
  80145a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80145e:	89 fa                	mov    %edi,%edx
  801460:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801463:	e8 78 ff ff ff       	call   8013e0 <printnum>
  801468:	eb 0f                	jmp    801479 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80146a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80146e:	89 34 24             	mov    %esi,(%esp)
  801471:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801474:	83 eb 01             	sub    $0x1,%ebx
  801477:	75 f1                	jne    80146a <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801479:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80147d:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801481:	8b 45 10             	mov    0x10(%ebp),%eax
  801484:	89 44 24 08          	mov    %eax,0x8(%esp)
  801488:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80148f:	00 
  801490:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801493:	89 04 24             	mov    %eax,(%esp)
  801496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801499:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149d:	e8 ae 0b 00 00       	call   802050 <__umoddi3>
  8014a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014a6:	0f be 80 27 23 80 00 	movsbl 0x802327(%eax),%eax
  8014ad:	89 04 24             	mov    %eax,(%esp)
  8014b0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8014b3:	83 c4 3c             	add    $0x3c,%esp
  8014b6:	5b                   	pop    %ebx
  8014b7:	5e                   	pop    %esi
  8014b8:	5f                   	pop    %edi
  8014b9:	5d                   	pop    %ebp
  8014ba:	c3                   	ret    

008014bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8014be:	83 fa 01             	cmp    $0x1,%edx
  8014c1:	7e 0e                	jle    8014d1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8014c3:	8b 10                	mov    (%eax),%edx
  8014c5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8014c8:	89 08                	mov    %ecx,(%eax)
  8014ca:	8b 02                	mov    (%edx),%eax
  8014cc:	8b 52 04             	mov    0x4(%edx),%edx
  8014cf:	eb 22                	jmp    8014f3 <getuint+0x38>
	else if (lflag)
  8014d1:	85 d2                	test   %edx,%edx
  8014d3:	74 10                	je     8014e5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8014d5:	8b 10                	mov    (%eax),%edx
  8014d7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8014da:	89 08                	mov    %ecx,(%eax)
  8014dc:	8b 02                	mov    (%edx),%eax
  8014de:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e3:	eb 0e                	jmp    8014f3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8014e5:	8b 10                	mov    (%eax),%edx
  8014e7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8014ea:	89 08                	mov    %ecx,(%eax)
  8014ec:	8b 02                	mov    (%edx),%eax
  8014ee:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8014f3:	5d                   	pop    %ebp
  8014f4:	c3                   	ret    

008014f5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8014fb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8014ff:	8b 10                	mov    (%eax),%edx
  801501:	3b 50 04             	cmp    0x4(%eax),%edx
  801504:	73 0a                	jae    801510 <sprintputch+0x1b>
		*b->buf++ = ch;
  801506:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801509:	88 0a                	mov    %cl,(%edx)
  80150b:	83 c2 01             	add    $0x1,%edx
  80150e:	89 10                	mov    %edx,(%eax)
}
  801510:	5d                   	pop    %ebp
  801511:	c3                   	ret    

00801512 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801518:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80151b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80151f:	8b 45 10             	mov    0x10(%ebp),%eax
  801522:	89 44 24 08          	mov    %eax,0x8(%esp)
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	89 04 24             	mov    %eax,(%esp)
  801533:	e8 02 00 00 00       	call   80153a <vprintfmt>
	va_end(ap);
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	57                   	push   %edi
  80153e:	56                   	push   %esi
  80153f:	53                   	push   %ebx
  801540:	83 ec 4c             	sub    $0x4c,%esp
  801543:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801546:	8b 75 10             	mov    0x10(%ebp),%esi
  801549:	eb 12                	jmp    80155d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80154b:	85 c0                	test   %eax,%eax
  80154d:	0f 84 a9 03 00 00    	je     8018fc <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  801553:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801557:	89 04 24             	mov    %eax,(%esp)
  80155a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80155d:	0f b6 06             	movzbl (%esi),%eax
  801560:	83 c6 01             	add    $0x1,%esi
  801563:	83 f8 25             	cmp    $0x25,%eax
  801566:	75 e3                	jne    80154b <vprintfmt+0x11>
  801568:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  80156c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801573:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  801578:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80157f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801584:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801587:	eb 2b                	jmp    8015b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801589:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80158c:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801590:	eb 22                	jmp    8015b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801592:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801595:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801599:	eb 19                	jmp    8015b4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80159b:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80159e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8015a5:	eb 0d                	jmp    8015b4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8015a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015ad:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015b4:	0f b6 06             	movzbl (%esi),%eax
  8015b7:	0f b6 d0             	movzbl %al,%edx
  8015ba:	8d 7e 01             	lea    0x1(%esi),%edi
  8015bd:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8015c0:	83 e8 23             	sub    $0x23,%eax
  8015c3:	3c 55                	cmp    $0x55,%al
  8015c5:	0f 87 0b 03 00 00    	ja     8018d6 <vprintfmt+0x39c>
  8015cb:	0f b6 c0             	movzbl %al,%eax
  8015ce:	ff 24 85 60 24 80 00 	jmp    *0x802460(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8015d5:	83 ea 30             	sub    $0x30,%edx
  8015d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  8015db:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8015df:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015e2:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8015e5:	83 fa 09             	cmp    $0x9,%edx
  8015e8:	77 4a                	ja     801634 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015ea:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8015ed:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8015f0:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8015f3:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  8015f7:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8015fa:	8d 50 d0             	lea    -0x30(%eax),%edx
  8015fd:	83 fa 09             	cmp    $0x9,%edx
  801600:	76 eb                	jbe    8015ed <vprintfmt+0xb3>
  801602:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801605:	eb 2d                	jmp    801634 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801607:	8b 45 14             	mov    0x14(%ebp),%eax
  80160a:	8d 50 04             	lea    0x4(%eax),%edx
  80160d:	89 55 14             	mov    %edx,0x14(%ebp)
  801610:	8b 00                	mov    (%eax),%eax
  801612:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801615:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801618:	eb 1a                	jmp    801634 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80161a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80161d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801621:	79 91                	jns    8015b4 <vprintfmt+0x7a>
  801623:	e9 73 ff ff ff       	jmp    80159b <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801628:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80162b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801632:	eb 80                	jmp    8015b4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  801634:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801638:	0f 89 76 ff ff ff    	jns    8015b4 <vprintfmt+0x7a>
  80163e:	e9 64 ff ff ff       	jmp    8015a7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801643:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801646:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801649:	e9 66 ff ff ff       	jmp    8015b4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80164e:	8b 45 14             	mov    0x14(%ebp),%eax
  801651:	8d 50 04             	lea    0x4(%eax),%edx
  801654:	89 55 14             	mov    %edx,0x14(%ebp)
  801657:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80165b:	8b 00                	mov    (%eax),%eax
  80165d:	89 04 24             	mov    %eax,(%esp)
  801660:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801663:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801666:	e9 f2 fe ff ff       	jmp    80155d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80166b:	8b 45 14             	mov    0x14(%ebp),%eax
  80166e:	8d 50 04             	lea    0x4(%eax),%edx
  801671:	89 55 14             	mov    %edx,0x14(%ebp)
  801674:	8b 00                	mov    (%eax),%eax
  801676:	89 c2                	mov    %eax,%edx
  801678:	c1 fa 1f             	sar    $0x1f,%edx
  80167b:	31 d0                	xor    %edx,%eax
  80167d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80167f:	83 f8 0f             	cmp    $0xf,%eax
  801682:	7f 0b                	jg     80168f <vprintfmt+0x155>
  801684:	8b 14 85 c0 25 80 00 	mov    0x8025c0(,%eax,4),%edx
  80168b:	85 d2                	test   %edx,%edx
  80168d:	75 23                	jne    8016b2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  80168f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801693:	c7 44 24 08 3f 23 80 	movl   $0x80233f,0x8(%esp)
  80169a:	00 
  80169b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80169f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016a2:	89 3c 24             	mov    %edi,(%esp)
  8016a5:	e8 68 fe ff ff       	call   801512 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016aa:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8016ad:	e9 ab fe ff ff       	jmp    80155d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  8016b2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8016b6:	c7 44 24 08 bd 22 80 	movl   $0x8022bd,0x8(%esp)
  8016bd:	00 
  8016be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016c5:	89 3c 24             	mov    %edi,(%esp)
  8016c8:	e8 45 fe ff ff       	call   801512 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016cd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8016d0:	e9 88 fe ff ff       	jmp    80155d <vprintfmt+0x23>
  8016d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8016d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8016de:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e1:	8d 50 04             	lea    0x4(%eax),%edx
  8016e4:	89 55 14             	mov    %edx,0x14(%ebp)
  8016e7:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8016e9:	85 f6                	test   %esi,%esi
  8016eb:	ba 38 23 80 00       	mov    $0x802338,%edx
  8016f0:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  8016f3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8016f7:	7e 06                	jle    8016ff <vprintfmt+0x1c5>
  8016f9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8016fd:	75 10                	jne    80170f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016ff:	0f be 06             	movsbl (%esi),%eax
  801702:	83 c6 01             	add    $0x1,%esi
  801705:	85 c0                	test   %eax,%eax
  801707:	0f 85 86 00 00 00    	jne    801793 <vprintfmt+0x259>
  80170d:	eb 76                	jmp    801785 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80170f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801713:	89 34 24             	mov    %esi,(%esp)
  801716:	e8 90 02 00 00       	call   8019ab <strnlen>
  80171b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80171e:	29 c2                	sub    %eax,%edx
  801720:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801723:	85 d2                	test   %edx,%edx
  801725:	7e d8                	jle    8016ff <vprintfmt+0x1c5>
					putch(padc, putdat);
  801727:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80172b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80172e:	89 d6                	mov    %edx,%esi
  801730:	89 7d d0             	mov    %edi,-0x30(%ebp)
  801733:	89 c7                	mov    %eax,%edi
  801735:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801739:	89 3c 24             	mov    %edi,(%esp)
  80173c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80173f:	83 ee 01             	sub    $0x1,%esi
  801742:	75 f1                	jne    801735 <vprintfmt+0x1fb>
  801744:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801747:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80174a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80174d:	eb b0                	jmp    8016ff <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80174f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801753:	74 18                	je     80176d <vprintfmt+0x233>
  801755:	8d 50 e0             	lea    -0x20(%eax),%edx
  801758:	83 fa 5e             	cmp    $0x5e,%edx
  80175b:	76 10                	jbe    80176d <vprintfmt+0x233>
					putch('?', putdat);
  80175d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801761:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801768:	ff 55 08             	call   *0x8(%ebp)
  80176b:	eb 0a                	jmp    801777 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  80176d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801771:	89 04 24             	mov    %eax,(%esp)
  801774:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801777:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80177b:	0f be 06             	movsbl (%esi),%eax
  80177e:	83 c6 01             	add    $0x1,%esi
  801781:	85 c0                	test   %eax,%eax
  801783:	75 0e                	jne    801793 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801785:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801788:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80178c:	7f 16                	jg     8017a4 <vprintfmt+0x26a>
  80178e:	e9 ca fd ff ff       	jmp    80155d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801793:	85 ff                	test   %edi,%edi
  801795:	78 b8                	js     80174f <vprintfmt+0x215>
  801797:	83 ef 01             	sub    $0x1,%edi
  80179a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8017a0:	79 ad                	jns    80174f <vprintfmt+0x215>
  8017a2:	eb e1                	jmp    801785 <vprintfmt+0x24b>
  8017a4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8017a7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8017aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017ae:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8017b5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8017b7:	83 ee 01             	sub    $0x1,%esi
  8017ba:	75 ee                	jne    8017aa <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8017bc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8017bf:	e9 99 fd ff ff       	jmp    80155d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8017c4:	83 f9 01             	cmp    $0x1,%ecx
  8017c7:	7e 10                	jle    8017d9 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  8017c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017cc:	8d 50 08             	lea    0x8(%eax),%edx
  8017cf:	89 55 14             	mov    %edx,0x14(%ebp)
  8017d2:	8b 30                	mov    (%eax),%esi
  8017d4:	8b 78 04             	mov    0x4(%eax),%edi
  8017d7:	eb 26                	jmp    8017ff <vprintfmt+0x2c5>
	else if (lflag)
  8017d9:	85 c9                	test   %ecx,%ecx
  8017db:	74 12                	je     8017ef <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  8017dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e0:	8d 50 04             	lea    0x4(%eax),%edx
  8017e3:	89 55 14             	mov    %edx,0x14(%ebp)
  8017e6:	8b 30                	mov    (%eax),%esi
  8017e8:	89 f7                	mov    %esi,%edi
  8017ea:	c1 ff 1f             	sar    $0x1f,%edi
  8017ed:	eb 10                	jmp    8017ff <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  8017ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f2:	8d 50 04             	lea    0x4(%eax),%edx
  8017f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8017f8:	8b 30                	mov    (%eax),%esi
  8017fa:	89 f7                	mov    %esi,%edi
  8017fc:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8017ff:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801804:	85 ff                	test   %edi,%edi
  801806:	0f 89 8c 00 00 00    	jns    801898 <vprintfmt+0x35e>
				putch('-', putdat);
  80180c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801810:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801817:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80181a:	f7 de                	neg    %esi
  80181c:	83 d7 00             	adc    $0x0,%edi
  80181f:	f7 df                	neg    %edi
			}
			base = 10;
  801821:	b8 0a 00 00 00       	mov    $0xa,%eax
  801826:	eb 70                	jmp    801898 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801828:	89 ca                	mov    %ecx,%edx
  80182a:	8d 45 14             	lea    0x14(%ebp),%eax
  80182d:	e8 89 fc ff ff       	call   8014bb <getuint>
  801832:	89 c6                	mov    %eax,%esi
  801834:	89 d7                	mov    %edx,%edi
			base = 10;
  801836:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80183b:	eb 5b                	jmp    801898 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80183d:	89 ca                	mov    %ecx,%edx
  80183f:	8d 45 14             	lea    0x14(%ebp),%eax
  801842:	e8 74 fc ff ff       	call   8014bb <getuint>
  801847:	89 c6                	mov    %eax,%esi
  801849:	89 d7                	mov    %edx,%edi
			base = 8;
  80184b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  801850:	eb 46                	jmp    801898 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  801852:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801856:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80185d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801860:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801864:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80186b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80186e:	8b 45 14             	mov    0x14(%ebp),%eax
  801871:	8d 50 04             	lea    0x4(%eax),%edx
  801874:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801877:	8b 30                	mov    (%eax),%esi
  801879:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80187e:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  801883:	eb 13                	jmp    801898 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801885:	89 ca                	mov    %ecx,%edx
  801887:	8d 45 14             	lea    0x14(%ebp),%eax
  80188a:	e8 2c fc ff ff       	call   8014bb <getuint>
  80188f:	89 c6                	mov    %eax,%esi
  801891:	89 d7                	mov    %edx,%edi
			base = 16;
  801893:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  801898:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  80189c:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018a3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8018a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018ab:	89 34 24             	mov    %esi,(%esp)
  8018ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018b2:	89 da                	mov    %ebx,%edx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	e8 24 fb ff ff       	call   8013e0 <printnum>
			break;
  8018bc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8018bf:	e9 99 fc ff ff       	jmp    80155d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8018c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018c8:	89 14 24             	mov    %edx,(%esp)
  8018cb:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8018ce:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8018d1:	e9 87 fc ff ff       	jmp    80155d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8018d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018da:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8018e1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8018e4:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8018e8:	0f 84 6f fc ff ff    	je     80155d <vprintfmt+0x23>
  8018ee:	83 ee 01             	sub    $0x1,%esi
  8018f1:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8018f5:	75 f7                	jne    8018ee <vprintfmt+0x3b4>
  8018f7:	e9 61 fc ff ff       	jmp    80155d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  8018fc:	83 c4 4c             	add    $0x4c,%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5e                   	pop    %esi
  801901:	5f                   	pop    %edi
  801902:	5d                   	pop    %ebp
  801903:	c3                   	ret    

00801904 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 28             	sub    $0x28,%esp
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801910:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801913:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801917:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80191a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801921:	85 c0                	test   %eax,%eax
  801923:	74 30                	je     801955 <vsnprintf+0x51>
  801925:	85 d2                	test   %edx,%edx
  801927:	7e 2c                	jle    801955 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801929:	8b 45 14             	mov    0x14(%ebp),%eax
  80192c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	89 44 24 08          	mov    %eax,0x8(%esp)
  801937:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80193a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193e:	c7 04 24 f5 14 80 00 	movl   $0x8014f5,(%esp)
  801945:	e8 f0 fb ff ff       	call   80153a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80194a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801953:	eb 05                	jmp    80195a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801955:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801962:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801965:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801969:	8b 45 10             	mov    0x10(%ebp),%eax
  80196c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801970:	8b 45 0c             	mov    0xc(%ebp),%eax
  801973:	89 44 24 04          	mov    %eax,0x4(%esp)
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	89 04 24             	mov    %eax,(%esp)
  80197d:	e8 82 ff ff ff       	call   801904 <vsnprintf>
	va_end(ap);

	return rc;
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    
	...

00801990 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801996:	b8 00 00 00 00       	mov    $0x0,%eax
  80199b:	80 3a 00             	cmpb   $0x0,(%edx)
  80199e:	74 09                	je     8019a9 <strlen+0x19>
		n++;
  8019a0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8019a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8019a7:	75 f7                	jne    8019a0 <strlen+0x10>
		n++;
	return n;
}
  8019a9:	5d                   	pop    %ebp
  8019aa:	c3                   	ret    

008019ab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	53                   	push   %ebx
  8019af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8019b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8019b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ba:	85 c9                	test   %ecx,%ecx
  8019bc:	74 1a                	je     8019d8 <strnlen+0x2d>
  8019be:	80 3b 00             	cmpb   $0x0,(%ebx)
  8019c1:	74 15                	je     8019d8 <strnlen+0x2d>
  8019c3:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8019c8:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8019ca:	39 ca                	cmp    %ecx,%edx
  8019cc:	74 0a                	je     8019d8 <strnlen+0x2d>
  8019ce:	83 c2 01             	add    $0x1,%edx
  8019d1:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8019d6:	75 f0                	jne    8019c8 <strnlen+0x1d>
		n++;
	return n;
}
  8019d8:	5b                   	pop    %ebx
  8019d9:	5d                   	pop    %ebp
  8019da:	c3                   	ret    

008019db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	53                   	push   %ebx
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8019e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ea:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8019ee:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8019f1:	83 c2 01             	add    $0x1,%edx
  8019f4:	84 c9                	test   %cl,%cl
  8019f6:	75 f2                	jne    8019ea <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8019f8:	5b                   	pop    %ebx
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    

008019fb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	53                   	push   %ebx
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801a05:	89 1c 24             	mov    %ebx,(%esp)
  801a08:	e8 83 ff ff ff       	call   801990 <strlen>
	strcpy(dst + len, src);
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a14:	01 d8                	add    %ebx,%eax
  801a16:	89 04 24             	mov    %eax,(%esp)
  801a19:	e8 bd ff ff ff       	call   8019db <strcpy>
	return dst;
}
  801a1e:	89 d8                	mov    %ebx,%eax
  801a20:	83 c4 08             	add    $0x8,%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5d                   	pop    %ebp
  801a25:	c3                   	ret    

00801a26 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	56                   	push   %esi
  801a2a:	53                   	push   %ebx
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a31:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a34:	85 f6                	test   %esi,%esi
  801a36:	74 18                	je     801a50 <strncpy+0x2a>
  801a38:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  801a3d:	0f b6 1a             	movzbl (%edx),%ebx
  801a40:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801a43:	80 3a 01             	cmpb   $0x1,(%edx)
  801a46:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a49:	83 c1 01             	add    $0x1,%ecx
  801a4c:	39 f1                	cmp    %esi,%ecx
  801a4e:	75 ed                	jne    801a3d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801a50:	5b                   	pop    %ebx
  801a51:	5e                   	pop    %esi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    

00801a54 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	57                   	push   %edi
  801a58:	56                   	push   %esi
  801a59:	53                   	push   %ebx
  801a5a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a60:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801a63:	89 f8                	mov    %edi,%eax
  801a65:	85 f6                	test   %esi,%esi
  801a67:	74 2b                	je     801a94 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  801a69:	83 fe 01             	cmp    $0x1,%esi
  801a6c:	74 23                	je     801a91 <strlcpy+0x3d>
  801a6e:	0f b6 0b             	movzbl (%ebx),%ecx
  801a71:	84 c9                	test   %cl,%cl
  801a73:	74 1c                	je     801a91 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  801a75:	83 ee 02             	sub    $0x2,%esi
  801a78:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801a7d:	88 08                	mov    %cl,(%eax)
  801a7f:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a82:	39 f2                	cmp    %esi,%edx
  801a84:	74 0b                	je     801a91 <strlcpy+0x3d>
  801a86:	83 c2 01             	add    $0x1,%edx
  801a89:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801a8d:	84 c9                	test   %cl,%cl
  801a8f:	75 ec                	jne    801a7d <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  801a91:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801a94:	29 f8                	sub    %edi,%eax
}
  801a96:	5b                   	pop    %ebx
  801a97:	5e                   	pop    %esi
  801a98:	5f                   	pop    %edi
  801a99:	5d                   	pop    %ebp
  801a9a:	c3                   	ret    

00801a9b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801aa4:	0f b6 01             	movzbl (%ecx),%eax
  801aa7:	84 c0                	test   %al,%al
  801aa9:	74 16                	je     801ac1 <strcmp+0x26>
  801aab:	3a 02                	cmp    (%edx),%al
  801aad:	75 12                	jne    801ac1 <strcmp+0x26>
		p++, q++;
  801aaf:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801ab2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  801ab6:	84 c0                	test   %al,%al
  801ab8:	74 07                	je     801ac1 <strcmp+0x26>
  801aba:	83 c1 01             	add    $0x1,%ecx
  801abd:	3a 02                	cmp    (%edx),%al
  801abf:	74 ee                	je     801aaf <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ac1:	0f b6 c0             	movzbl %al,%eax
  801ac4:	0f b6 12             	movzbl (%edx),%edx
  801ac7:	29 d0                	sub    %edx,%eax
}
  801ac9:	5d                   	pop    %ebp
  801aca:	c3                   	ret    

00801acb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	53                   	push   %ebx
  801acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ad5:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801ad8:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801add:	85 d2                	test   %edx,%edx
  801adf:	74 28                	je     801b09 <strncmp+0x3e>
  801ae1:	0f b6 01             	movzbl (%ecx),%eax
  801ae4:	84 c0                	test   %al,%al
  801ae6:	74 24                	je     801b0c <strncmp+0x41>
  801ae8:	3a 03                	cmp    (%ebx),%al
  801aea:	75 20                	jne    801b0c <strncmp+0x41>
  801aec:	83 ea 01             	sub    $0x1,%edx
  801aef:	74 13                	je     801b04 <strncmp+0x39>
		n--, p++, q++;
  801af1:	83 c1 01             	add    $0x1,%ecx
  801af4:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801af7:	0f b6 01             	movzbl (%ecx),%eax
  801afa:	84 c0                	test   %al,%al
  801afc:	74 0e                	je     801b0c <strncmp+0x41>
  801afe:	3a 03                	cmp    (%ebx),%al
  801b00:	74 ea                	je     801aec <strncmp+0x21>
  801b02:	eb 08                	jmp    801b0c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801b04:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801b09:	5b                   	pop    %ebx
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801b0c:	0f b6 01             	movzbl (%ecx),%eax
  801b0f:	0f b6 13             	movzbl (%ebx),%edx
  801b12:	29 d0                	sub    %edx,%eax
  801b14:	eb f3                	jmp    801b09 <strncmp+0x3e>

00801b16 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801b20:	0f b6 10             	movzbl (%eax),%edx
  801b23:	84 d2                	test   %dl,%dl
  801b25:	74 1c                	je     801b43 <strchr+0x2d>
		if (*s == c)
  801b27:	38 ca                	cmp    %cl,%dl
  801b29:	75 09                	jne    801b34 <strchr+0x1e>
  801b2b:	eb 1b                	jmp    801b48 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b2d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  801b30:	38 ca                	cmp    %cl,%dl
  801b32:	74 14                	je     801b48 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b34:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  801b38:	84 d2                	test   %dl,%dl
  801b3a:	75 f1                	jne    801b2d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  801b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b41:	eb 05                	jmp    801b48 <strchr+0x32>
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    

00801b4a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801b54:	0f b6 10             	movzbl (%eax),%edx
  801b57:	84 d2                	test   %dl,%dl
  801b59:	74 14                	je     801b6f <strfind+0x25>
		if (*s == c)
  801b5b:	38 ca                	cmp    %cl,%dl
  801b5d:	75 06                	jne    801b65 <strfind+0x1b>
  801b5f:	eb 0e                	jmp    801b6f <strfind+0x25>
  801b61:	38 ca                	cmp    %cl,%dl
  801b63:	74 0a                	je     801b6f <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b65:	83 c0 01             	add    $0x1,%eax
  801b68:	0f b6 10             	movzbl (%eax),%edx
  801b6b:	84 d2                	test   %dl,%dl
  801b6d:	75 f2                	jne    801b61 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    

00801b71 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 0c             	sub    $0xc,%esp
  801b77:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b7a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b7d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b80:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b86:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801b89:	85 c9                	test   %ecx,%ecx
  801b8b:	74 30                	je     801bbd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801b8d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801b93:	75 25                	jne    801bba <memset+0x49>
  801b95:	f6 c1 03             	test   $0x3,%cl
  801b98:	75 20                	jne    801bba <memset+0x49>
		c &= 0xFF;
  801b9a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801b9d:	89 d3                	mov    %edx,%ebx
  801b9f:	c1 e3 08             	shl    $0x8,%ebx
  801ba2:	89 d6                	mov    %edx,%esi
  801ba4:	c1 e6 18             	shl    $0x18,%esi
  801ba7:	89 d0                	mov    %edx,%eax
  801ba9:	c1 e0 10             	shl    $0x10,%eax
  801bac:	09 f0                	or     %esi,%eax
  801bae:	09 d0                	or     %edx,%eax
  801bb0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801bb2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801bb5:	fc                   	cld    
  801bb6:	f3 ab                	rep stos %eax,%es:(%edi)
  801bb8:	eb 03                	jmp    801bbd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801bba:	fc                   	cld    
  801bbb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801bbd:	89 f8                	mov    %edi,%eax
  801bbf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801bc2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801bc5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801bc8:	89 ec                	mov    %ebp,%esp
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    

00801bcc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 08             	sub    $0x8,%esp
  801bd2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801bd5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bde:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801be1:	39 c6                	cmp    %eax,%esi
  801be3:	73 36                	jae    801c1b <memmove+0x4f>
  801be5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801be8:	39 d0                	cmp    %edx,%eax
  801bea:	73 2f                	jae    801c1b <memmove+0x4f>
		s += n;
		d += n;
  801bec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801bef:	f6 c2 03             	test   $0x3,%dl
  801bf2:	75 1b                	jne    801c0f <memmove+0x43>
  801bf4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801bfa:	75 13                	jne    801c0f <memmove+0x43>
  801bfc:	f6 c1 03             	test   $0x3,%cl
  801bff:	75 0e                	jne    801c0f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c01:	83 ef 04             	sub    $0x4,%edi
  801c04:	8d 72 fc             	lea    -0x4(%edx),%esi
  801c07:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c0a:	fd                   	std    
  801c0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801c0d:	eb 09                	jmp    801c18 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801c0f:	83 ef 01             	sub    $0x1,%edi
  801c12:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801c15:	fd                   	std    
  801c16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801c18:	fc                   	cld    
  801c19:	eb 20                	jmp    801c3b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801c1b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801c21:	75 13                	jne    801c36 <memmove+0x6a>
  801c23:	a8 03                	test   $0x3,%al
  801c25:	75 0f                	jne    801c36 <memmove+0x6a>
  801c27:	f6 c1 03             	test   $0x3,%cl
  801c2a:	75 0a                	jne    801c36 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801c2c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801c2f:	89 c7                	mov    %eax,%edi
  801c31:	fc                   	cld    
  801c32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801c34:	eb 05                	jmp    801c3b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801c36:	89 c7                	mov    %eax,%edi
  801c38:	fc                   	cld    
  801c39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801c3b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c3e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c41:	89 ec                	mov    %ebp,%esp
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    

00801c45 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	89 04 24             	mov    %eax,(%esp)
  801c5f:	e8 68 ff ff ff       	call   801bcc <memmove>
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	57                   	push   %edi
  801c6a:	56                   	push   %esi
  801c6b:	53                   	push   %ebx
  801c6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c72:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c75:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c7a:	85 ff                	test   %edi,%edi
  801c7c:	74 37                	je     801cb5 <memcmp+0x4f>
		if (*s1 != *s2)
  801c7e:	0f b6 03             	movzbl (%ebx),%eax
  801c81:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c84:	83 ef 01             	sub    $0x1,%edi
  801c87:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  801c8c:	38 c8                	cmp    %cl,%al
  801c8e:	74 1c                	je     801cac <memcmp+0x46>
  801c90:	eb 10                	jmp    801ca2 <memcmp+0x3c>
  801c92:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801c97:	83 c2 01             	add    $0x1,%edx
  801c9a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801c9e:	38 c8                	cmp    %cl,%al
  801ca0:	74 0a                	je     801cac <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  801ca2:	0f b6 c0             	movzbl %al,%eax
  801ca5:	0f b6 c9             	movzbl %cl,%ecx
  801ca8:	29 c8                	sub    %ecx,%eax
  801caa:	eb 09                	jmp    801cb5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801cac:	39 fa                	cmp    %edi,%edx
  801cae:	75 e2                	jne    801c92 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb5:	5b                   	pop    %ebx
  801cb6:	5e                   	pop    %esi
  801cb7:	5f                   	pop    %edi
  801cb8:	5d                   	pop    %ebp
  801cb9:	c3                   	ret    

00801cba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801cc0:	89 c2                	mov    %eax,%edx
  801cc2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801cc5:	39 d0                	cmp    %edx,%eax
  801cc7:	73 19                	jae    801ce2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801cc9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801ccd:	38 08                	cmp    %cl,(%eax)
  801ccf:	75 06                	jne    801cd7 <memfind+0x1d>
  801cd1:	eb 0f                	jmp    801ce2 <memfind+0x28>
  801cd3:	38 08                	cmp    %cl,(%eax)
  801cd5:	74 0b                	je     801ce2 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801cd7:	83 c0 01             	add    $0x1,%eax
  801cda:	39 d0                	cmp    %edx,%eax
  801cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ce0:	75 f1                	jne    801cd3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801ce2:	5d                   	pop    %ebp
  801ce3:	c3                   	ret    

00801ce4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	57                   	push   %edi
  801ce8:	56                   	push   %esi
  801ce9:	53                   	push   %ebx
  801cea:	8b 55 08             	mov    0x8(%ebp),%edx
  801ced:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801cf0:	0f b6 02             	movzbl (%edx),%eax
  801cf3:	3c 20                	cmp    $0x20,%al
  801cf5:	74 04                	je     801cfb <strtol+0x17>
  801cf7:	3c 09                	cmp    $0x9,%al
  801cf9:	75 0e                	jne    801d09 <strtol+0x25>
		s++;
  801cfb:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801cfe:	0f b6 02             	movzbl (%edx),%eax
  801d01:	3c 20                	cmp    $0x20,%al
  801d03:	74 f6                	je     801cfb <strtol+0x17>
  801d05:	3c 09                	cmp    $0x9,%al
  801d07:	74 f2                	je     801cfb <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  801d09:	3c 2b                	cmp    $0x2b,%al
  801d0b:	75 0a                	jne    801d17 <strtol+0x33>
		s++;
  801d0d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801d10:	bf 00 00 00 00       	mov    $0x0,%edi
  801d15:	eb 10                	jmp    801d27 <strtol+0x43>
  801d17:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801d1c:	3c 2d                	cmp    $0x2d,%al
  801d1e:	75 07                	jne    801d27 <strtol+0x43>
		s++, neg = 1;
  801d20:	83 c2 01             	add    $0x1,%edx
  801d23:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801d27:	85 db                	test   %ebx,%ebx
  801d29:	0f 94 c0             	sete   %al
  801d2c:	74 05                	je     801d33 <strtol+0x4f>
  801d2e:	83 fb 10             	cmp    $0x10,%ebx
  801d31:	75 15                	jne    801d48 <strtol+0x64>
  801d33:	80 3a 30             	cmpb   $0x30,(%edx)
  801d36:	75 10                	jne    801d48 <strtol+0x64>
  801d38:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801d3c:	75 0a                	jne    801d48 <strtol+0x64>
		s += 2, base = 16;
  801d3e:	83 c2 02             	add    $0x2,%edx
  801d41:	bb 10 00 00 00       	mov    $0x10,%ebx
  801d46:	eb 13                	jmp    801d5b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  801d48:	84 c0                	test   %al,%al
  801d4a:	74 0f                	je     801d5b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801d4c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801d51:	80 3a 30             	cmpb   $0x30,(%edx)
  801d54:	75 05                	jne    801d5b <strtol+0x77>
		s++, base = 8;
  801d56:	83 c2 01             	add    $0x1,%edx
  801d59:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  801d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d60:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d62:	0f b6 0a             	movzbl (%edx),%ecx
  801d65:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801d68:	80 fb 09             	cmp    $0x9,%bl
  801d6b:	77 08                	ja     801d75 <strtol+0x91>
			dig = *s - '0';
  801d6d:	0f be c9             	movsbl %cl,%ecx
  801d70:	83 e9 30             	sub    $0x30,%ecx
  801d73:	eb 1e                	jmp    801d93 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  801d75:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  801d78:	80 fb 19             	cmp    $0x19,%bl
  801d7b:	77 08                	ja     801d85 <strtol+0xa1>
			dig = *s - 'a' + 10;
  801d7d:	0f be c9             	movsbl %cl,%ecx
  801d80:	83 e9 57             	sub    $0x57,%ecx
  801d83:	eb 0e                	jmp    801d93 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  801d85:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  801d88:	80 fb 19             	cmp    $0x19,%bl
  801d8b:	77 14                	ja     801da1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  801d8d:	0f be c9             	movsbl %cl,%ecx
  801d90:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801d93:	39 f1                	cmp    %esi,%ecx
  801d95:	7d 0e                	jge    801da5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801d97:	83 c2 01             	add    $0x1,%edx
  801d9a:	0f af c6             	imul   %esi,%eax
  801d9d:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  801d9f:	eb c1                	jmp    801d62 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  801da1:	89 c1                	mov    %eax,%ecx
  801da3:	eb 02                	jmp    801da7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801da5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801da7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dab:	74 05                	je     801db2 <strtol+0xce>
		*endptr = (char *) s;
  801dad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801db0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801db2:	89 ca                	mov    %ecx,%edx
  801db4:	f7 da                	neg    %edx
  801db6:	85 ff                	test   %edi,%edi
  801db8:	0f 45 c2             	cmovne %edx,%eax
}
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5f                   	pop    %edi
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    

00801dc0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	56                   	push   %esi
  801dc4:	53                   	push   %ebx
  801dc5:	83 ec 10             	sub    $0x10,%esp
  801dc8:	8b 75 08             	mov    0x8(%ebp),%esi
  801dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801dd1:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801dd3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801dd8:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801ddb:	89 04 24             	mov    %eax,(%esp)
  801dde:	e8 86 e6 ff ff       	call   800469 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801de3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801de8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 0e                	js     801dff <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801df1:	a1 04 40 80 00       	mov    0x804004,%eax
  801df6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801df9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801dfc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801dff:	85 f6                	test   %esi,%esi
  801e01:	74 02                	je     801e05 <ipc_recv+0x45>
		*from_env_store = sender;
  801e03:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801e05:	85 db                	test   %ebx,%ebx
  801e07:	74 02                	je     801e0b <ipc_recv+0x4b>
		*perm_store = perm;
  801e09:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	5b                   	pop    %ebx
  801e0f:	5e                   	pop    %esi
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    

00801e12 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	57                   	push   %edi
  801e16:	56                   	push   %esi
  801e17:	53                   	push   %ebx
  801e18:	83 ec 1c             	sub    $0x1c,%esp
  801e1b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e21:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801e24:	85 db                	test   %ebx,%ebx
  801e26:	75 04                	jne    801e2c <ipc_send+0x1a>
  801e28:	85 f6                	test   %esi,%esi
  801e2a:	75 15                	jne    801e41 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801e2c:	85 db                	test   %ebx,%ebx
  801e2e:	74 16                	je     801e46 <ipc_send+0x34>
  801e30:	85 f6                	test   %esi,%esi
  801e32:	0f 94 c0             	sete   %al
      pg = 0;
  801e35:	84 c0                	test   %al,%al
  801e37:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3c:	0f 45 d8             	cmovne %eax,%ebx
  801e3f:	eb 05                	jmp    801e46 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801e41:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801e46:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e4a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e4e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	89 04 24             	mov    %eax,(%esp)
  801e58:	e8 d8 e5 ff ff       	call   800435 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801e5d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e60:	75 07                	jne    801e69 <ipc_send+0x57>
           sys_yield();
  801e62:	e8 69 e3 ff ff       	call   8001d0 <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801e67:	eb dd                	jmp    801e46 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	90                   	nop
  801e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e70:	74 1c                	je     801e8e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801e72:	c7 44 24 08 20 26 80 	movl   $0x802620,0x8(%esp)
  801e79:	00 
  801e7a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801e81:	00 
  801e82:	c7 04 24 2a 26 80 00 	movl   $0x80262a,(%esp)
  801e89:	e8 32 f4 ff ff       	call   8012c0 <_panic>
		}
    }
}
  801e8e:	83 c4 1c             	add    $0x1c,%esp
  801e91:	5b                   	pop    %ebx
  801e92:	5e                   	pop    %esi
  801e93:	5f                   	pop    %edi
  801e94:	5d                   	pop    %ebp
  801e95:	c3                   	ret    

00801e96 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e9c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801ea1:	39 c8                	cmp    %ecx,%eax
  801ea3:	74 17                	je     801ebc <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ea5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801eaa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801ead:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801eb3:	8b 52 50             	mov    0x50(%edx),%edx
  801eb6:	39 ca                	cmp    %ecx,%edx
  801eb8:	75 14                	jne    801ece <ipc_find_env+0x38>
  801eba:	eb 05                	jmp    801ec1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ebc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801ec1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ec4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801ec9:	8b 40 40             	mov    0x40(%eax),%eax
  801ecc:	eb 0e                	jmp    801edc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ece:	83 c0 01             	add    $0x1,%eax
  801ed1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ed6:	75 d2                	jne    801eaa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801ed8:	66 b8 00 00          	mov    $0x0,%ax
}
  801edc:	5d                   	pop    %ebp
  801edd:	c3                   	ret    
	...

00801ee0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ee6:	89 d0                	mov    %edx,%eax
  801ee8:	c1 e8 16             	shr    $0x16,%eax
  801eeb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ef7:	f6 c1 01             	test   $0x1,%cl
  801efa:	74 1d                	je     801f19 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801efc:	c1 ea 0c             	shr    $0xc,%edx
  801eff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f06:	f6 c2 01             	test   $0x1,%dl
  801f09:	74 0e                	je     801f19 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f0b:	c1 ea 0c             	shr    $0xc,%edx
  801f0e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f15:	ef 
  801f16:	0f b7 c0             	movzwl %ax,%eax
}
  801f19:	5d                   	pop    %ebp
  801f1a:	c3                   	ret    
  801f1b:	00 00                	add    %al,(%eax)
  801f1d:	00 00                	add    %al,(%eax)
	...

00801f20 <__udivdi3>:
  801f20:	83 ec 1c             	sub    $0x1c,%esp
  801f23:	89 7c 24 14          	mov    %edi,0x14(%esp)
  801f27:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  801f2b:	8b 44 24 20          	mov    0x20(%esp),%eax
  801f2f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801f33:	89 74 24 10          	mov    %esi,0x10(%esp)
  801f37:	8b 74 24 24          	mov    0x24(%esp),%esi
  801f3b:	85 ff                	test   %edi,%edi
  801f3d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  801f41:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f45:	89 cd                	mov    %ecx,%ebp
  801f47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f4b:	75 33                	jne    801f80 <__udivdi3+0x60>
  801f4d:	39 f1                	cmp    %esi,%ecx
  801f4f:	77 57                	ja     801fa8 <__udivdi3+0x88>
  801f51:	85 c9                	test   %ecx,%ecx
  801f53:	75 0b                	jne    801f60 <__udivdi3+0x40>
  801f55:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5a:	31 d2                	xor    %edx,%edx
  801f5c:	f7 f1                	div    %ecx
  801f5e:	89 c1                	mov    %eax,%ecx
  801f60:	89 f0                	mov    %esi,%eax
  801f62:	31 d2                	xor    %edx,%edx
  801f64:	f7 f1                	div    %ecx
  801f66:	89 c6                	mov    %eax,%esi
  801f68:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f6c:	f7 f1                	div    %ecx
  801f6e:	89 f2                	mov    %esi,%edx
  801f70:	8b 74 24 10          	mov    0x10(%esp),%esi
  801f74:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801f78:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801f7c:	83 c4 1c             	add    $0x1c,%esp
  801f7f:	c3                   	ret    
  801f80:	31 d2                	xor    %edx,%edx
  801f82:	31 c0                	xor    %eax,%eax
  801f84:	39 f7                	cmp    %esi,%edi
  801f86:	77 e8                	ja     801f70 <__udivdi3+0x50>
  801f88:	0f bd cf             	bsr    %edi,%ecx
  801f8b:	83 f1 1f             	xor    $0x1f,%ecx
  801f8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f92:	75 2c                	jne    801fc0 <__udivdi3+0xa0>
  801f94:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  801f98:	76 04                	jbe    801f9e <__udivdi3+0x7e>
  801f9a:	39 f7                	cmp    %esi,%edi
  801f9c:	73 d2                	jae    801f70 <__udivdi3+0x50>
  801f9e:	31 d2                	xor    %edx,%edx
  801fa0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa5:	eb c9                	jmp    801f70 <__udivdi3+0x50>
  801fa7:	90                   	nop
  801fa8:	89 f2                	mov    %esi,%edx
  801faa:	f7 f1                	div    %ecx
  801fac:	31 d2                	xor    %edx,%edx
  801fae:	8b 74 24 10          	mov    0x10(%esp),%esi
  801fb2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  801fb6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  801fba:	83 c4 1c             	add    $0x1c,%esp
  801fbd:	c3                   	ret    
  801fbe:	66 90                	xchg   %ax,%ax
  801fc0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fc5:	b8 20 00 00 00       	mov    $0x20,%eax
  801fca:	89 ea                	mov    %ebp,%edx
  801fcc:	2b 44 24 04          	sub    0x4(%esp),%eax
  801fd0:	d3 e7                	shl    %cl,%edi
  801fd2:	89 c1                	mov    %eax,%ecx
  801fd4:	d3 ea                	shr    %cl,%edx
  801fd6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fdb:	09 fa                	or     %edi,%edx
  801fdd:	89 f7                	mov    %esi,%edi
  801fdf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fe3:	89 f2                	mov    %esi,%edx
  801fe5:	8b 74 24 08          	mov    0x8(%esp),%esi
  801fe9:	d3 e5                	shl    %cl,%ebp
  801feb:	89 c1                	mov    %eax,%ecx
  801fed:	d3 ef                	shr    %cl,%edi
  801fef:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ff4:	d3 e2                	shl    %cl,%edx
  801ff6:	89 c1                	mov    %eax,%ecx
  801ff8:	d3 ee                	shr    %cl,%esi
  801ffa:	09 d6                	or     %edx,%esi
  801ffc:	89 fa                	mov    %edi,%edx
  801ffe:	89 f0                	mov    %esi,%eax
  802000:	f7 74 24 0c          	divl   0xc(%esp)
  802004:	89 d7                	mov    %edx,%edi
  802006:	89 c6                	mov    %eax,%esi
  802008:	f7 e5                	mul    %ebp
  80200a:	39 d7                	cmp    %edx,%edi
  80200c:	72 22                	jb     802030 <__udivdi3+0x110>
  80200e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802012:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802017:	d3 e5                	shl    %cl,%ebp
  802019:	39 c5                	cmp    %eax,%ebp
  80201b:	73 04                	jae    802021 <__udivdi3+0x101>
  80201d:	39 d7                	cmp    %edx,%edi
  80201f:	74 0f                	je     802030 <__udivdi3+0x110>
  802021:	89 f0                	mov    %esi,%eax
  802023:	31 d2                	xor    %edx,%edx
  802025:	e9 46 ff ff ff       	jmp    801f70 <__udivdi3+0x50>
  80202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802030:	8d 46 ff             	lea    -0x1(%esi),%eax
  802033:	31 d2                	xor    %edx,%edx
  802035:	8b 74 24 10          	mov    0x10(%esp),%esi
  802039:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80203d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802041:	83 c4 1c             	add    $0x1c,%esp
  802044:	c3                   	ret    
	...

00802050 <__umoddi3>:
  802050:	83 ec 1c             	sub    $0x1c,%esp
  802053:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802057:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80205b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80205f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802063:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802067:	8b 74 24 24          	mov    0x24(%esp),%esi
  80206b:	85 ed                	test   %ebp,%ebp
  80206d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802071:	89 44 24 08          	mov    %eax,0x8(%esp)
  802075:	89 cf                	mov    %ecx,%edi
  802077:	89 04 24             	mov    %eax,(%esp)
  80207a:	89 f2                	mov    %esi,%edx
  80207c:	75 1a                	jne    802098 <__umoddi3+0x48>
  80207e:	39 f1                	cmp    %esi,%ecx
  802080:	76 4e                	jbe    8020d0 <__umoddi3+0x80>
  802082:	f7 f1                	div    %ecx
  802084:	89 d0                	mov    %edx,%eax
  802086:	31 d2                	xor    %edx,%edx
  802088:	8b 74 24 10          	mov    0x10(%esp),%esi
  80208c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802090:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802094:	83 c4 1c             	add    $0x1c,%esp
  802097:	c3                   	ret    
  802098:	39 f5                	cmp    %esi,%ebp
  80209a:	77 54                	ja     8020f0 <__umoddi3+0xa0>
  80209c:	0f bd c5             	bsr    %ebp,%eax
  80209f:	83 f0 1f             	xor    $0x1f,%eax
  8020a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a6:	75 60                	jne    802108 <__umoddi3+0xb8>
  8020a8:	3b 0c 24             	cmp    (%esp),%ecx
  8020ab:	0f 87 07 01 00 00    	ja     8021b8 <__umoddi3+0x168>
  8020b1:	89 f2                	mov    %esi,%edx
  8020b3:	8b 34 24             	mov    (%esp),%esi
  8020b6:	29 ce                	sub    %ecx,%esi
  8020b8:	19 ea                	sbb    %ebp,%edx
  8020ba:	89 34 24             	mov    %esi,(%esp)
  8020bd:	8b 04 24             	mov    (%esp),%eax
  8020c0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020c4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020c8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020cc:	83 c4 1c             	add    $0x1c,%esp
  8020cf:	c3                   	ret    
  8020d0:	85 c9                	test   %ecx,%ecx
  8020d2:	75 0b                	jne    8020df <__umoddi3+0x8f>
  8020d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d9:	31 d2                	xor    %edx,%edx
  8020db:	f7 f1                	div    %ecx
  8020dd:	89 c1                	mov    %eax,%ecx
  8020df:	89 f0                	mov    %esi,%eax
  8020e1:	31 d2                	xor    %edx,%edx
  8020e3:	f7 f1                	div    %ecx
  8020e5:	8b 04 24             	mov    (%esp),%eax
  8020e8:	f7 f1                	div    %ecx
  8020ea:	eb 98                	jmp    802084 <__umoddi3+0x34>
  8020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020f0:	89 f2                	mov    %esi,%edx
  8020f2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8020f6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8020fa:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8020fe:	83 c4 1c             	add    $0x1c,%esp
  802101:	c3                   	ret    
  802102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802108:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80210d:	89 e8                	mov    %ebp,%eax
  80210f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802114:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802118:	89 fa                	mov    %edi,%edx
  80211a:	d3 e0                	shl    %cl,%eax
  80211c:	89 e9                	mov    %ebp,%ecx
  80211e:	d3 ea                	shr    %cl,%edx
  802120:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802125:	09 c2                	or     %eax,%edx
  802127:	8b 44 24 08          	mov    0x8(%esp),%eax
  80212b:	89 14 24             	mov    %edx,(%esp)
  80212e:	89 f2                	mov    %esi,%edx
  802130:	d3 e7                	shl    %cl,%edi
  802132:	89 e9                	mov    %ebp,%ecx
  802134:	d3 ea                	shr    %cl,%edx
  802136:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80213b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80213f:	d3 e6                	shl    %cl,%esi
  802141:	89 e9                	mov    %ebp,%ecx
  802143:	d3 e8                	shr    %cl,%eax
  802145:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80214a:	09 f0                	or     %esi,%eax
  80214c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802150:	f7 34 24             	divl   (%esp)
  802153:	d3 e6                	shl    %cl,%esi
  802155:	89 74 24 08          	mov    %esi,0x8(%esp)
  802159:	89 d6                	mov    %edx,%esi
  80215b:	f7 e7                	mul    %edi
  80215d:	39 d6                	cmp    %edx,%esi
  80215f:	89 c1                	mov    %eax,%ecx
  802161:	89 d7                	mov    %edx,%edi
  802163:	72 3f                	jb     8021a4 <__umoddi3+0x154>
  802165:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802169:	72 35                	jb     8021a0 <__umoddi3+0x150>
  80216b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80216f:	29 c8                	sub    %ecx,%eax
  802171:	19 fe                	sbb    %edi,%esi
  802173:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802178:	89 f2                	mov    %esi,%edx
  80217a:	d3 e8                	shr    %cl,%eax
  80217c:	89 e9                	mov    %ebp,%ecx
  80217e:	d3 e2                	shl    %cl,%edx
  802180:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802185:	09 d0                	or     %edx,%eax
  802187:	89 f2                	mov    %esi,%edx
  802189:	d3 ea                	shr    %cl,%edx
  80218b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80218f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802193:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802197:	83 c4 1c             	add    $0x1c,%esp
  80219a:	c3                   	ret    
  80219b:	90                   	nop
  80219c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021a0:	39 d6                	cmp    %edx,%esi
  8021a2:	75 c7                	jne    80216b <__umoddi3+0x11b>
  8021a4:	89 d7                	mov    %edx,%edi
  8021a6:	89 c1                	mov    %eax,%ecx
  8021a8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8021ac:	1b 3c 24             	sbb    (%esp),%edi
  8021af:	eb ba                	jmp    80216b <__umoddi3+0x11b>
  8021b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021b8:	39 f5                	cmp    %esi,%ebp
  8021ba:	0f 82 f1 fe ff ff    	jb     8020b1 <__umoddi3+0x61>
  8021c0:	e9 f8 fe ff ff       	jmp    8020bd <__umoddi3+0x6d>
