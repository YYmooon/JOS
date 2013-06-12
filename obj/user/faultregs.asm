
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 67 05 00 00       	call   800598 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 1c             	sub    $0x1c,%esp
  80003d:	89 c3                	mov    %eax,%ebx
  80003f:	89 ce                	mov    %ecx,%esi
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800041:	8b 45 08             	mov    0x8(%ebp),%eax
  800044:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800048:	89 54 24 08          	mov    %edx,0x8(%esp)
  80004c:	c7 44 24 04 b1 27 80 	movl   $0x8027b1,0x4(%esp)
  800053:	00 
  800054:	c7 04 24 80 27 80 00 	movl   $0x802780,(%esp)
  80005b:	e8 9f 06 00 00       	call   8006ff <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800060:	8b 06                	mov    (%esi),%eax
  800062:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800066:	8b 03                	mov    (%ebx),%eax
  800068:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006c:	c7 44 24 04 90 27 80 	movl   $0x802790,0x4(%esp)
  800073:	00 
  800074:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  80007b:	e8 7f 06 00 00       	call   8006ff <cprintf>
  800080:	8b 06                	mov    (%esi),%eax
  800082:	39 03                	cmp    %eax,(%ebx)
  800084:	75 13                	jne    800099 <check_regs+0x65>
  800086:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  80008d:	e8 6d 06 00 00       	call   8006ff <cprintf>

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
	int mismatch = 0;
  800092:	bf 00 00 00 00       	mov    $0x0,%edi
  800097:	eb 11                	jmp    8000aa <check_regs+0x76>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800099:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  8000a0:	e8 5a 06 00 00       	call   8006ff <cprintf>
  8000a5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  8000aa:	8b 46 04             	mov    0x4(%esi),%eax
  8000ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b1:	8b 43 04             	mov    0x4(%ebx),%eax
  8000b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b8:	c7 44 24 04 b2 27 80 	movl   $0x8027b2,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  8000c7:	e8 33 06 00 00       	call   8006ff <cprintf>
  8000cc:	8b 46 04             	mov    0x4(%esi),%eax
  8000cf:	39 43 04             	cmp    %eax,0x4(%ebx)
  8000d2:	75 0e                	jne    8000e2 <check_regs+0xae>
  8000d4:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  8000db:	e8 1f 06 00 00       	call   8006ff <cprintf>
  8000e0:	eb 11                	jmp    8000f3 <check_regs+0xbf>
  8000e2:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  8000e9:	e8 11 06 00 00       	call   8006ff <cprintf>
  8000ee:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000f3:	8b 46 08             	mov    0x8(%esi),%eax
  8000f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000fa:	8b 43 08             	mov    0x8(%ebx),%eax
  8000fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  800101:	c7 44 24 04 b6 27 80 	movl   $0x8027b6,0x4(%esp)
  800108:	00 
  800109:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  800110:	e8 ea 05 00 00       	call   8006ff <cprintf>
  800115:	8b 46 08             	mov    0x8(%esi),%eax
  800118:	39 43 08             	cmp    %eax,0x8(%ebx)
  80011b:	75 0e                	jne    80012b <check_regs+0xf7>
  80011d:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  800124:	e8 d6 05 00 00       	call   8006ff <cprintf>
  800129:	eb 11                	jmp    80013c <check_regs+0x108>
  80012b:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  800132:	e8 c8 05 00 00       	call   8006ff <cprintf>
  800137:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  80013c:	8b 46 10             	mov    0x10(%esi),%eax
  80013f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800143:	8b 43 10             	mov    0x10(%ebx),%eax
  800146:	89 44 24 08          	mov    %eax,0x8(%esp)
  80014a:	c7 44 24 04 ba 27 80 	movl   $0x8027ba,0x4(%esp)
  800151:	00 
  800152:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  800159:	e8 a1 05 00 00       	call   8006ff <cprintf>
  80015e:	8b 46 10             	mov    0x10(%esi),%eax
  800161:	39 43 10             	cmp    %eax,0x10(%ebx)
  800164:	75 0e                	jne    800174 <check_regs+0x140>
  800166:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  80016d:	e8 8d 05 00 00       	call   8006ff <cprintf>
  800172:	eb 11                	jmp    800185 <check_regs+0x151>
  800174:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  80017b:	e8 7f 05 00 00       	call   8006ff <cprintf>
  800180:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800185:	8b 46 14             	mov    0x14(%esi),%eax
  800188:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018c:	8b 43 14             	mov    0x14(%ebx),%eax
  80018f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800193:	c7 44 24 04 be 27 80 	movl   $0x8027be,0x4(%esp)
  80019a:	00 
  80019b:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  8001a2:	e8 58 05 00 00       	call   8006ff <cprintf>
  8001a7:	8b 46 14             	mov    0x14(%esi),%eax
  8001aa:	39 43 14             	cmp    %eax,0x14(%ebx)
  8001ad:	75 0e                	jne    8001bd <check_regs+0x189>
  8001af:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  8001b6:	e8 44 05 00 00       	call   8006ff <cprintf>
  8001bb:	eb 11                	jmp    8001ce <check_regs+0x19a>
  8001bd:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  8001c4:	e8 36 05 00 00       	call   8006ff <cprintf>
  8001c9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  8001ce:	8b 46 18             	mov    0x18(%esi),%eax
  8001d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d5:	8b 43 18             	mov    0x18(%ebx),%eax
  8001d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001dc:	c7 44 24 04 c2 27 80 	movl   $0x8027c2,0x4(%esp)
  8001e3:	00 
  8001e4:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  8001eb:	e8 0f 05 00 00       	call   8006ff <cprintf>
  8001f0:	8b 46 18             	mov    0x18(%esi),%eax
  8001f3:	39 43 18             	cmp    %eax,0x18(%ebx)
  8001f6:	75 0e                	jne    800206 <check_regs+0x1d2>
  8001f8:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  8001ff:	e8 fb 04 00 00       	call   8006ff <cprintf>
  800204:	eb 11                	jmp    800217 <check_regs+0x1e3>
  800206:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  80020d:	e8 ed 04 00 00       	call   8006ff <cprintf>
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  800217:	8b 46 1c             	mov    0x1c(%esi),%eax
  80021a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021e:	8b 43 1c             	mov    0x1c(%ebx),%eax
  800221:	89 44 24 08          	mov    %eax,0x8(%esp)
  800225:	c7 44 24 04 c6 27 80 	movl   $0x8027c6,0x4(%esp)
  80022c:	00 
  80022d:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  800234:	e8 c6 04 00 00       	call   8006ff <cprintf>
  800239:	8b 46 1c             	mov    0x1c(%esi),%eax
  80023c:	39 43 1c             	cmp    %eax,0x1c(%ebx)
  80023f:	75 0e                	jne    80024f <check_regs+0x21b>
  800241:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  800248:	e8 b2 04 00 00       	call   8006ff <cprintf>
  80024d:	eb 11                	jmp    800260 <check_regs+0x22c>
  80024f:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  800256:	e8 a4 04 00 00       	call   8006ff <cprintf>
  80025b:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  800260:	8b 46 20             	mov    0x20(%esi),%eax
  800263:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800267:	8b 43 20             	mov    0x20(%ebx),%eax
  80026a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026e:	c7 44 24 04 ca 27 80 	movl   $0x8027ca,0x4(%esp)
  800275:	00 
  800276:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  80027d:	e8 7d 04 00 00       	call   8006ff <cprintf>
  800282:	8b 46 20             	mov    0x20(%esi),%eax
  800285:	39 43 20             	cmp    %eax,0x20(%ebx)
  800288:	75 0e                	jne    800298 <check_regs+0x264>
  80028a:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  800291:	e8 69 04 00 00       	call   8006ff <cprintf>
  800296:	eb 11                	jmp    8002a9 <check_regs+0x275>
  800298:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  80029f:	e8 5b 04 00 00       	call   8006ff <cprintf>
  8002a4:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  8002a9:	8b 46 24             	mov    0x24(%esi),%eax
  8002ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b0:	8b 43 24             	mov    0x24(%ebx),%eax
  8002b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b7:	c7 44 24 04 ce 27 80 	movl   $0x8027ce,0x4(%esp)
  8002be:	00 
  8002bf:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  8002c6:	e8 34 04 00 00       	call   8006ff <cprintf>
  8002cb:	8b 46 24             	mov    0x24(%esi),%eax
  8002ce:	39 43 24             	cmp    %eax,0x24(%ebx)
  8002d1:	75 0e                	jne    8002e1 <check_regs+0x2ad>
  8002d3:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  8002da:	e8 20 04 00 00       	call   8006ff <cprintf>
  8002df:	eb 11                	jmp    8002f2 <check_regs+0x2be>
  8002e1:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  8002e8:	e8 12 04 00 00       	call   8006ff <cprintf>
  8002ed:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esp, esp);
  8002f2:	8b 46 28             	mov    0x28(%esi),%eax
  8002f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f9:	8b 43 28             	mov    0x28(%ebx),%eax
  8002fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800300:	c7 44 24 04 d5 27 80 	movl   $0x8027d5,0x4(%esp)
  800307:	00 
  800308:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  80030f:	e8 eb 03 00 00       	call   8006ff <cprintf>
  800314:	8b 46 28             	mov    0x28(%esi),%eax
  800317:	39 43 28             	cmp    %eax,0x28(%ebx)
  80031a:	75 25                	jne    800341 <check_regs+0x30d>
  80031c:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  800323:	e8 d7 03 00 00       	call   8006ff <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032f:	c7 04 24 d9 27 80 00 	movl   $0x8027d9,(%esp)
  800336:	e8 c4 03 00 00       	call   8006ff <cprintf>
	if (!mismatch)
  80033b:	85 ff                	test   %edi,%edi
  80033d:	74 23                	je     800362 <check_regs+0x32e>
  80033f:	eb 2f                	jmp    800370 <check_regs+0x33c>
	CHECK(edx, regs.reg_edx);
	CHECK(ecx, regs.reg_ecx);
	CHECK(eax, regs.reg_eax);
	CHECK(eip, eip);
	CHECK(eflags, eflags);
	CHECK(esp, esp);
  800341:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  800348:	e8 b2 03 00 00       	call   8006ff <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  80034d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800350:	89 44 24 04          	mov    %eax,0x4(%esp)
  800354:	c7 04 24 d9 27 80 00 	movl   $0x8027d9,(%esp)
  80035b:	e8 9f 03 00 00       	call   8006ff <cprintf>
  800360:	eb 0e                	jmp    800370 <check_regs+0x33c>
	if (!mismatch)
		cprintf("OK\n");
  800362:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  800369:	e8 91 03 00 00       	call   8006ff <cprintf>
  80036e:	eb 0c                	jmp    80037c <check_regs+0x348>
	else
		cprintf("MISMATCH\n");
  800370:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  800377:	e8 83 03 00 00       	call   8006ff <cprintf>
}
  80037c:	83 c4 1c             	add    $0x1c,%esp
  80037f:	5b                   	pop    %ebx
  800380:	5e                   	pop    %esi
  800381:	5f                   	pop    %edi
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    

00800384 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	83 ec 28             	sub    $0x28,%esp
  80038a:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  800395:	74 27                	je     8003be <pgfault+0x3a>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  800397:	8b 40 28             	mov    0x28(%eax),%eax
  80039a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80039e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a2:	c7 44 24 08 40 28 80 	movl   $0x802840,0x8(%esp)
  8003a9:	00 
  8003aa:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  8003b1:	00 
  8003b2:	c7 04 24 e7 27 80 00 	movl   $0x8027e7,(%esp)
  8003b9:	e8 46 02 00 00       	call   800604 <_panic>
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003be:	8b 50 08             	mov    0x8(%eax),%edx
  8003c1:	89 15 80 40 80 00    	mov    %edx,0x804080
  8003c7:	8b 50 0c             	mov    0xc(%eax),%edx
  8003ca:	89 15 84 40 80 00    	mov    %edx,0x804084
  8003d0:	8b 50 10             	mov    0x10(%eax),%edx
  8003d3:	89 15 88 40 80 00    	mov    %edx,0x804088
  8003d9:	8b 50 14             	mov    0x14(%eax),%edx
  8003dc:	89 15 8c 40 80 00    	mov    %edx,0x80408c
  8003e2:	8b 50 18             	mov    0x18(%eax),%edx
  8003e5:	89 15 90 40 80 00    	mov    %edx,0x804090
  8003eb:	8b 50 1c             	mov    0x1c(%eax),%edx
  8003ee:	89 15 94 40 80 00    	mov    %edx,0x804094
  8003f4:	8b 50 20             	mov    0x20(%eax),%edx
  8003f7:	89 15 98 40 80 00    	mov    %edx,0x804098
  8003fd:	8b 50 24             	mov    0x24(%eax),%edx
  800400:	89 15 9c 40 80 00    	mov    %edx,0x80409c
	during.eip = utf->utf_eip;
  800406:	8b 50 28             	mov    0x28(%eax),%edx
  800409:	89 15 a0 40 80 00    	mov    %edx,0x8040a0
	during.eflags = utf->utf_eflags;
  80040f:	8b 50 2c             	mov    0x2c(%eax),%edx
  800412:	89 15 a4 40 80 00    	mov    %edx,0x8040a4
	during.esp = utf->utf_esp;
  800418:	8b 40 30             	mov    0x30(%eax),%eax
  80041b:	a3 a8 40 80 00       	mov    %eax,0x8040a8
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800420:	c7 44 24 04 ff 27 80 	movl   $0x8027ff,0x4(%esp)
  800427:	00 
  800428:	c7 04 24 0d 28 80 00 	movl   $0x80280d,(%esp)
  80042f:	b9 80 40 80 00       	mov    $0x804080,%ecx
  800434:	ba f8 27 80 00       	mov    $0x8027f8,%edx
  800439:	b8 00 40 80 00       	mov    $0x804000,%eax
  80043e:	e8 f1 fb ff ff       	call   800034 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800443:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80044a:	00 
  80044b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800452:	00 
  800453:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80045a:	e8 bd 0d 00 00       	call   80121c <sys_page_alloc>
  80045f:	85 c0                	test   %eax,%eax
  800461:	79 20                	jns    800483 <pgfault+0xff>
		panic("sys_page_alloc: %e", r);
  800463:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800467:	c7 44 24 08 14 28 80 	movl   $0x802814,0x8(%esp)
  80046e:	00 
  80046f:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800476:	00 
  800477:	c7 04 24 e7 27 80 00 	movl   $0x8027e7,(%esp)
  80047e:	e8 81 01 00 00       	call   800604 <_panic>
}
  800483:	c9                   	leave  
  800484:	c3                   	ret    

00800485 <umain>:

void
umain(int argc, char **argv)
{
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
  800488:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(pgfault);
  80048b:	c7 04 24 84 03 80 00 	movl   $0x800384,(%esp)
  800492:	e8 4d 10 00 00       	call   8014e4 <set_pgfault_handler>

	__asm __volatile(
  800497:	50                   	push   %eax
  800498:	9c                   	pushf  
  800499:	58                   	pop    %eax
  80049a:	0d d5 08 00 00       	or     $0x8d5,%eax
  80049f:	50                   	push   %eax
  8004a0:	9d                   	popf   
  8004a1:	a3 24 40 80 00       	mov    %eax,0x804024
  8004a6:	8d 05 e1 04 80 00    	lea    0x8004e1,%eax
  8004ac:	a3 20 40 80 00       	mov    %eax,0x804020
  8004b1:	58                   	pop    %eax
  8004b2:	89 3d 00 40 80 00    	mov    %edi,0x804000
  8004b8:	89 35 04 40 80 00    	mov    %esi,0x804004
  8004be:	89 2d 08 40 80 00    	mov    %ebp,0x804008
  8004c4:	89 1d 10 40 80 00    	mov    %ebx,0x804010
  8004ca:	89 15 14 40 80 00    	mov    %edx,0x804014
  8004d0:	89 0d 18 40 80 00    	mov    %ecx,0x804018
  8004d6:	a3 1c 40 80 00       	mov    %eax,0x80401c
  8004db:	89 25 28 40 80 00    	mov    %esp,0x804028
  8004e1:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  8004e8:	00 00 00 
  8004eb:	89 3d 40 40 80 00    	mov    %edi,0x804040
  8004f1:	89 35 44 40 80 00    	mov    %esi,0x804044
  8004f7:	89 2d 48 40 80 00    	mov    %ebp,0x804048
  8004fd:	89 1d 50 40 80 00    	mov    %ebx,0x804050
  800503:	89 15 54 40 80 00    	mov    %edx,0x804054
  800509:	89 0d 58 40 80 00    	mov    %ecx,0x804058
  80050f:	a3 5c 40 80 00       	mov    %eax,0x80405c
  800514:	89 25 68 40 80 00    	mov    %esp,0x804068
  80051a:	8b 3d 00 40 80 00    	mov    0x804000,%edi
  800520:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800526:	8b 2d 08 40 80 00    	mov    0x804008,%ebp
  80052c:	8b 1d 10 40 80 00    	mov    0x804010,%ebx
  800532:	8b 15 14 40 80 00    	mov    0x804014,%edx
  800538:	8b 0d 18 40 80 00    	mov    0x804018,%ecx
  80053e:	a1 1c 40 80 00       	mov    0x80401c,%eax
  800543:	8b 25 28 40 80 00    	mov    0x804028,%esp
  800549:	50                   	push   %eax
  80054a:	9c                   	pushf  
  80054b:	58                   	pop    %eax
  80054c:	a3 64 40 80 00       	mov    %eax,0x804064
  800551:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800552:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  800559:	74 0c                	je     800567 <umain+0xe2>
		cprintf("EIP after page-fault MISMATCH\n");
  80055b:	c7 04 24 74 28 80 00 	movl   $0x802874,(%esp)
  800562:	e8 98 01 00 00       	call   8006ff <cprintf>
	after.eip = before.eip;
  800567:	a1 20 40 80 00       	mov    0x804020,%eax
  80056c:	a3 60 40 80 00       	mov    %eax,0x804060

	check_regs(&before, "before", &after, "after", "after page-fault");
  800571:	c7 44 24 04 27 28 80 	movl   $0x802827,0x4(%esp)
  800578:	00 
  800579:	c7 04 24 38 28 80 00 	movl   $0x802838,(%esp)
  800580:	b9 40 40 80 00       	mov    $0x804040,%ecx
  800585:	ba f8 27 80 00       	mov    $0x8027f8,%edx
  80058a:	b8 00 40 80 00       	mov    $0x804000,%eax
  80058f:	e8 a0 fa ff ff       	call   800034 <check_regs>
}
  800594:	c9                   	leave  
  800595:	c3                   	ret    
	...

00800598 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	83 ec 18             	sub    $0x18,%esp
  80059e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8005a1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8005a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8005aa:	e8 0d 0c 00 00       	call   8011bc <sys_getenvid>
  8005af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005b4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005bc:	a3 b0 40 80 00       	mov    %eax,0x8040b0
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c1:	85 f6                	test   %esi,%esi
  8005c3:	7e 07                	jle    8005cc <libmain+0x34>
		binaryname = argv[0];
  8005c5:	8b 03                	mov    (%ebx),%eax
  8005c7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8005cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005d0:	89 34 24             	mov    %esi,(%esp)
  8005d3:	e8 ad fe ff ff       	call   800485 <umain>

	// exit gracefully
	exit();
  8005d8:	e8 0b 00 00 00       	call   8005e8 <exit>
}
  8005dd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8005e0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8005e3:	89 ec                	mov    %ebp,%esp
  8005e5:	5d                   	pop    %ebp
  8005e6:	c3                   	ret    
	...

008005e8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005e8:	55                   	push   %ebp
  8005e9:	89 e5                	mov    %esp,%ebp
  8005eb:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8005ee:	e8 ab 11 00 00       	call   80179e <close_all>
	sys_env_destroy(0);
  8005f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005fa:	e8 60 0b 00 00       	call   80115f <sys_env_destroy>
}
  8005ff:	c9                   	leave  
  800600:	c3                   	ret    
  800601:	00 00                	add    %al,(%eax)
	...

00800604 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800604:	55                   	push   %ebp
  800605:	89 e5                	mov    %esp,%ebp
  800607:	56                   	push   %esi
  800608:	53                   	push   %ebx
  800609:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80060c:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80060f:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800615:	e8 a2 0b 00 00       	call   8011bc <sys_getenvid>
  80061a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061d:	89 54 24 10          	mov    %edx,0x10(%esp)
  800621:	8b 55 08             	mov    0x8(%ebp),%edx
  800624:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800628:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800630:	c7 04 24 a0 28 80 00 	movl   $0x8028a0,(%esp)
  800637:	e8 c3 00 00 00       	call   8006ff <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80063c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800640:	8b 45 10             	mov    0x10(%ebp),%eax
  800643:	89 04 24             	mov    %eax,(%esp)
  800646:	e8 53 00 00 00       	call   80069e <vcprintf>
	cprintf("\n");
  80064b:	c7 04 24 b0 27 80 00 	movl   $0x8027b0,(%esp)
  800652:	e8 a8 00 00 00       	call   8006ff <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800657:	cc                   	int3   
  800658:	eb fd                	jmp    800657 <_panic+0x53>
	...

0080065c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	53                   	push   %ebx
  800660:	83 ec 14             	sub    $0x14,%esp
  800663:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800666:	8b 03                	mov    (%ebx),%eax
  800668:	8b 55 08             	mov    0x8(%ebp),%edx
  80066b:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80066f:	83 c0 01             	add    $0x1,%eax
  800672:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800674:	3d ff 00 00 00       	cmp    $0xff,%eax
  800679:	75 19                	jne    800694 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80067b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800682:	00 
  800683:	8d 43 08             	lea    0x8(%ebx),%eax
  800686:	89 04 24             	mov    %eax,(%esp)
  800689:	e8 72 0a 00 00       	call   801100 <sys_cputs>
		b->idx = 0;
  80068e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800694:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800698:	83 c4 14             	add    $0x14,%esp
  80069b:	5b                   	pop    %ebx
  80069c:	5d                   	pop    %ebp
  80069d:	c3                   	ret    

0080069e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80069e:	55                   	push   %ebp
  80069f:	89 e5                	mov    %esp,%ebp
  8006a1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8006a7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006ae:	00 00 00 
	b.cnt = 0;
  8006b1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006b8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006d3:	c7 04 24 5c 06 80 00 	movl   $0x80065c,(%esp)
  8006da:	e8 9b 01 00 00       	call   80087a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006df:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8006e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006ef:	89 04 24             	mov    %eax,(%esp)
  8006f2:	e8 09 0a 00 00       	call   801100 <sys_cputs>

	return b.cnt;
}
  8006f7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006fd:	c9                   	leave  
  8006fe:	c3                   	ret    

008006ff <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800705:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800708:	89 44 24 04          	mov    %eax,0x4(%esp)
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 04 24             	mov    %eax,(%esp)
  800712:	e8 87 ff ff ff       	call   80069e <vcprintf>
	va_end(ap);

	return cnt;
}
  800717:	c9                   	leave  
  800718:	c3                   	ret    
  800719:	00 00                	add    %al,(%eax)
  80071b:	00 00                	add    %al,(%eax)
  80071d:	00 00                	add    %al,(%eax)
	...

00800720 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800720:	55                   	push   %ebp
  800721:	89 e5                	mov    %esp,%ebp
  800723:	57                   	push   %edi
  800724:	56                   	push   %esi
  800725:	53                   	push   %ebx
  800726:	83 ec 3c             	sub    $0x3c,%esp
  800729:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072c:	89 d7                	mov    %edx,%edi
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800734:	8b 45 0c             	mov    0xc(%ebp),%eax
  800737:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80073a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80073d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800740:	b8 00 00 00 00       	mov    $0x0,%eax
  800745:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800748:	72 11                	jb     80075b <printnum+0x3b>
  80074a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80074d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800750:	76 09                	jbe    80075b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800752:	83 eb 01             	sub    $0x1,%ebx
  800755:	85 db                	test   %ebx,%ebx
  800757:	7f 51                	jg     8007aa <printnum+0x8a>
  800759:	eb 5e                	jmp    8007b9 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80075b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80075f:	83 eb 01             	sub    $0x1,%ebx
  800762:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800766:	8b 45 10             	mov    0x10(%ebp),%eax
  800769:	89 44 24 08          	mov    %eax,0x8(%esp)
  80076d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  800771:	8b 74 24 0c          	mov    0xc(%esp),%esi
  800775:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80077c:	00 
  80077d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800780:	89 04 24             	mov    %eax,(%esp)
  800783:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800786:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078a:	e8 41 1d 00 00       	call   8024d0 <__udivdi3>
  80078f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800793:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800797:	89 04 24             	mov    %eax,(%esp)
  80079a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80079e:	89 fa                	mov    %edi,%edx
  8007a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007a3:	e8 78 ff ff ff       	call   800720 <printnum>
  8007a8:	eb 0f                	jmp    8007b9 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ae:	89 34 24             	mov    %esi,(%esp)
  8007b1:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b4:	83 eb 01             	sub    $0x1,%ebx
  8007b7:	75 f1                	jne    8007aa <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007b9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007bd:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8007c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8007cf:	00 
  8007d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007d3:	89 04 24             	mov    %eax,(%esp)
  8007d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007dd:	e8 1e 1e 00 00       	call   802600 <__umoddi3>
  8007e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e6:	0f be 80 c3 28 80 00 	movsbl 0x8028c3(%eax),%eax
  8007ed:	89 04 24             	mov    %eax,(%esp)
  8007f0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8007f3:	83 c4 3c             	add    $0x3c,%esp
  8007f6:	5b                   	pop    %ebx
  8007f7:	5e                   	pop    %esi
  8007f8:	5f                   	pop    %edi
  8007f9:	5d                   	pop    %ebp
  8007fa:	c3                   	ret    

008007fb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007fe:	83 fa 01             	cmp    $0x1,%edx
  800801:	7e 0e                	jle    800811 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800803:	8b 10                	mov    (%eax),%edx
  800805:	8d 4a 08             	lea    0x8(%edx),%ecx
  800808:	89 08                	mov    %ecx,(%eax)
  80080a:	8b 02                	mov    (%edx),%eax
  80080c:	8b 52 04             	mov    0x4(%edx),%edx
  80080f:	eb 22                	jmp    800833 <getuint+0x38>
	else if (lflag)
  800811:	85 d2                	test   %edx,%edx
  800813:	74 10                	je     800825 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800815:	8b 10                	mov    (%eax),%edx
  800817:	8d 4a 04             	lea    0x4(%edx),%ecx
  80081a:	89 08                	mov    %ecx,(%eax)
  80081c:	8b 02                	mov    (%edx),%eax
  80081e:	ba 00 00 00 00       	mov    $0x0,%edx
  800823:	eb 0e                	jmp    800833 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800825:	8b 10                	mov    (%eax),%edx
  800827:	8d 4a 04             	lea    0x4(%edx),%ecx
  80082a:	89 08                	mov    %ecx,(%eax)
  80082c:	8b 02                	mov    (%edx),%eax
  80082e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80083b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80083f:	8b 10                	mov    (%eax),%edx
  800841:	3b 50 04             	cmp    0x4(%eax),%edx
  800844:	73 0a                	jae    800850 <sprintputch+0x1b>
		*b->buf++ = ch;
  800846:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800849:	88 0a                	mov    %cl,(%edx)
  80084b:	83 c2 01             	add    $0x1,%edx
  80084e:	89 10                	mov    %edx,(%eax)
}
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800858:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80085b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80085f:	8b 45 10             	mov    0x10(%ebp),%eax
  800862:	89 44 24 08          	mov    %eax,0x8(%esp)
  800866:	8b 45 0c             	mov    0xc(%ebp),%eax
  800869:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	89 04 24             	mov    %eax,(%esp)
  800873:	e8 02 00 00 00       	call   80087a <vprintfmt>
	va_end(ap);
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	57                   	push   %edi
  80087e:	56                   	push   %esi
  80087f:	53                   	push   %ebx
  800880:	83 ec 4c             	sub    $0x4c,%esp
  800883:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800886:	8b 75 10             	mov    0x10(%ebp),%esi
  800889:	eb 12                	jmp    80089d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80088b:	85 c0                	test   %eax,%eax
  80088d:	0f 84 a9 03 00 00    	je     800c3c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  800893:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800897:	89 04 24             	mov    %eax,(%esp)
  80089a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089d:	0f b6 06             	movzbl (%esi),%eax
  8008a0:	83 c6 01             	add    $0x1,%esi
  8008a3:	83 f8 25             	cmp    $0x25,%eax
  8008a6:	75 e3                	jne    80088b <vprintfmt+0x11>
  8008a8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8008ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8008b3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  8008b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8008bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008c4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8008c7:	eb 2b                	jmp    8008f4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c9:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8008cc:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8008d0:	eb 22                	jmp    8008f4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d2:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008d5:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8008d9:	eb 19                	jmp    8008f4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008db:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8008de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8008e5:	eb 0d                	jmp    8008f4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8008e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ed:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f4:	0f b6 06             	movzbl (%esi),%eax
  8008f7:	0f b6 d0             	movzbl %al,%edx
  8008fa:	8d 7e 01             	lea    0x1(%esi),%edi
  8008fd:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800900:	83 e8 23             	sub    $0x23,%eax
  800903:	3c 55                	cmp    $0x55,%al
  800905:	0f 87 0b 03 00 00    	ja     800c16 <vprintfmt+0x39c>
  80090b:	0f b6 c0             	movzbl %al,%eax
  80090e:	ff 24 85 00 2a 80 00 	jmp    *0x802a00(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800915:	83 ea 30             	sub    $0x30,%edx
  800918:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80091b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80091f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800922:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800925:	83 fa 09             	cmp    $0x9,%edx
  800928:	77 4a                	ja     800974 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80092a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800930:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800933:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  800937:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80093a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80093d:	83 fa 09             	cmp    $0x9,%edx
  800940:	76 eb                	jbe    80092d <vprintfmt+0xb3>
  800942:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800945:	eb 2d                	jmp    800974 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	8d 50 04             	lea    0x4(%eax),%edx
  80094d:	89 55 14             	mov    %edx,0x14(%ebp)
  800950:	8b 00                	mov    (%eax),%eax
  800952:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800955:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800958:	eb 1a                	jmp    800974 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80095a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80095d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800961:	79 91                	jns    8008f4 <vprintfmt+0x7a>
  800963:	e9 73 ff ff ff       	jmp    8008db <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800968:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80096b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800972:	eb 80                	jmp    8008f4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  800974:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800978:	0f 89 76 ff ff ff    	jns    8008f4 <vprintfmt+0x7a>
  80097e:	e9 64 ff ff ff       	jmp    8008e7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800983:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800986:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800989:	e9 66 ff ff ff       	jmp    8008f4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	8d 50 04             	lea    0x4(%eax),%edx
  800994:	89 55 14             	mov    %edx,0x14(%ebp)
  800997:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	89 04 24             	mov    %eax,(%esp)
  8009a0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8009a6:	e9 f2 fe ff ff       	jmp    80089d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	8d 50 04             	lea    0x4(%eax),%edx
  8009b1:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	89 c2                	mov    %eax,%edx
  8009b8:	c1 fa 1f             	sar    $0x1f,%edx
  8009bb:	31 d0                	xor    %edx,%eax
  8009bd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009bf:	83 f8 0f             	cmp    $0xf,%eax
  8009c2:	7f 0b                	jg     8009cf <vprintfmt+0x155>
  8009c4:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  8009cb:	85 d2                	test   %edx,%edx
  8009cd:	75 23                	jne    8009f2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  8009cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009d3:	c7 44 24 08 db 28 80 	movl   $0x8028db,0x8(%esp)
  8009da:	00 
  8009db:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009e2:	89 3c 24             	mov    %edi,(%esp)
  8009e5:	e8 68 fe ff ff       	call   800852 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ea:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8009ed:	e9 ab fe ff ff       	jmp    80089d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  8009f2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009f6:	c7 44 24 08 b9 2c 80 	movl   $0x802cb9,0x8(%esp)
  8009fd:	00 
  8009fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a02:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a05:	89 3c 24             	mov    %edi,(%esp)
  800a08:	e8 45 fe ff ff       	call   800852 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a0d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800a10:	e9 88 fe ff ff       	jmp    80089d <vprintfmt+0x23>
  800a15:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800a18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a1b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	8d 50 04             	lea    0x4(%eax),%edx
  800a24:	89 55 14             	mov    %edx,0x14(%ebp)
  800a27:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800a29:	85 f6                	test   %esi,%esi
  800a2b:	ba d4 28 80 00       	mov    $0x8028d4,%edx
  800a30:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  800a33:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a37:	7e 06                	jle    800a3f <vprintfmt+0x1c5>
  800a39:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800a3d:	75 10                	jne    800a4f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3f:	0f be 06             	movsbl (%esi),%eax
  800a42:	83 c6 01             	add    $0x1,%esi
  800a45:	85 c0                	test   %eax,%eax
  800a47:	0f 85 86 00 00 00    	jne    800ad3 <vprintfmt+0x259>
  800a4d:	eb 76                	jmp    800ac5 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a53:	89 34 24             	mov    %esi,(%esp)
  800a56:	e8 90 02 00 00       	call   800ceb <strnlen>
  800a5b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a5e:	29 c2                	sub    %eax,%edx
  800a60:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a63:	85 d2                	test   %edx,%edx
  800a65:	7e d8                	jle    800a3f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800a67:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800a6b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  800a6e:	89 d6                	mov    %edx,%esi
  800a70:	89 7d d0             	mov    %edi,-0x30(%ebp)
  800a73:	89 c7                	mov    %eax,%edi
  800a75:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a79:	89 3c 24             	mov    %edi,(%esp)
  800a7c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a7f:	83 ee 01             	sub    $0x1,%esi
  800a82:	75 f1                	jne    800a75 <vprintfmt+0x1fb>
  800a84:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800a87:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  800a8a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  800a8d:	eb b0                	jmp    800a3f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a8f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a93:	74 18                	je     800aad <vprintfmt+0x233>
  800a95:	8d 50 e0             	lea    -0x20(%eax),%edx
  800a98:	83 fa 5e             	cmp    $0x5e,%edx
  800a9b:	76 10                	jbe    800aad <vprintfmt+0x233>
					putch('?', putdat);
  800a9d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aa1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800aa8:	ff 55 08             	call   *0x8(%ebp)
  800aab:	eb 0a                	jmp    800ab7 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  800aad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ab1:	89 04 24             	mov    %eax,(%esp)
  800ab4:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab7:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800abb:	0f be 06             	movsbl (%esi),%eax
  800abe:	83 c6 01             	add    $0x1,%esi
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	75 0e                	jne    800ad3 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ac5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800acc:	7f 16                	jg     800ae4 <vprintfmt+0x26a>
  800ace:	e9 ca fd ff ff       	jmp    80089d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad3:	85 ff                	test   %edi,%edi
  800ad5:	78 b8                	js     800a8f <vprintfmt+0x215>
  800ad7:	83 ef 01             	sub    $0x1,%edi
  800ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ae0:	79 ad                	jns    800a8f <vprintfmt+0x215>
  800ae2:	eb e1                	jmp    800ac5 <vprintfmt+0x24b>
  800ae4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800ae7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800aea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aee:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800af5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af7:	83 ee 01             	sub    $0x1,%esi
  800afa:	75 ee                	jne    800aea <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800afc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800aff:	e9 99 fd ff ff       	jmp    80089d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b04:	83 f9 01             	cmp    $0x1,%ecx
  800b07:	7e 10                	jle    800b19 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  800b09:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0c:	8d 50 08             	lea    0x8(%eax),%edx
  800b0f:	89 55 14             	mov    %edx,0x14(%ebp)
  800b12:	8b 30                	mov    (%eax),%esi
  800b14:	8b 78 04             	mov    0x4(%eax),%edi
  800b17:	eb 26                	jmp    800b3f <vprintfmt+0x2c5>
	else if (lflag)
  800b19:	85 c9                	test   %ecx,%ecx
  800b1b:	74 12                	je     800b2f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  800b1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b20:	8d 50 04             	lea    0x4(%eax),%edx
  800b23:	89 55 14             	mov    %edx,0x14(%ebp)
  800b26:	8b 30                	mov    (%eax),%esi
  800b28:	89 f7                	mov    %esi,%edi
  800b2a:	c1 ff 1f             	sar    $0x1f,%edi
  800b2d:	eb 10                	jmp    800b3f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	8d 50 04             	lea    0x4(%eax),%edx
  800b35:	89 55 14             	mov    %edx,0x14(%ebp)
  800b38:	8b 30                	mov    (%eax),%esi
  800b3a:	89 f7                	mov    %esi,%edi
  800b3c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800b3f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b44:	85 ff                	test   %edi,%edi
  800b46:	0f 89 8c 00 00 00    	jns    800bd8 <vprintfmt+0x35e>
				putch('-', putdat);
  800b4c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b50:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b57:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b5a:	f7 de                	neg    %esi
  800b5c:	83 d7 00             	adc    $0x0,%edi
  800b5f:	f7 df                	neg    %edi
			}
			base = 10;
  800b61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b66:	eb 70                	jmp    800bd8 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b68:	89 ca                	mov    %ecx,%edx
  800b6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6d:	e8 89 fc ff ff       	call   8007fb <getuint>
  800b72:	89 c6                	mov    %eax,%esi
  800b74:	89 d7                	mov    %edx,%edi
			base = 10;
  800b76:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800b7b:	eb 5b                	jmp    800bd8 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800b7d:	89 ca                	mov    %ecx,%edx
  800b7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b82:	e8 74 fc ff ff       	call   8007fb <getuint>
  800b87:	89 c6                	mov    %eax,%esi
  800b89:	89 d7                	mov    %edx,%edi
			base = 8;
  800b8b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800b90:	eb 46                	jmp    800bd8 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  800b92:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b96:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b9d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800ba0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ba4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800bab:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800bae:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb1:	8d 50 04             	lea    0x4(%eax),%edx
  800bb4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb7:	8b 30                	mov    (%eax),%esi
  800bb9:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800bbe:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800bc3:	eb 13                	jmp    800bd8 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc5:	89 ca                	mov    %ecx,%edx
  800bc7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bca:	e8 2c fc ff ff       	call   8007fb <getuint>
  800bcf:	89 c6                	mov    %eax,%esi
  800bd1:	89 d7                	mov    %edx,%edi
			base = 16;
  800bd3:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bd8:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  800bdc:	89 54 24 10          	mov    %edx,0x10(%esp)
  800be0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800be3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800be7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800beb:	89 34 24             	mov    %esi,(%esp)
  800bee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bf2:	89 da                	mov    %ebx,%edx
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	e8 24 fb ff ff       	call   800720 <printnum>
			break;
  800bfc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800bff:	e9 99 fc ff ff       	jmp    80089d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c04:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c08:	89 14 24             	mov    %edx,(%esp)
  800c0b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c0e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800c11:	e9 87 fc ff ff       	jmp    80089d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c16:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c1a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c21:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c24:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800c28:	0f 84 6f fc ff ff    	je     80089d <vprintfmt+0x23>
  800c2e:	83 ee 01             	sub    $0x1,%esi
  800c31:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800c35:	75 f7                	jne    800c2e <vprintfmt+0x3b4>
  800c37:	e9 61 fc ff ff       	jmp    80089d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  800c3c:	83 c4 4c             	add    $0x4c,%esp
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 28             	sub    $0x28,%esp
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c50:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c53:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c57:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c61:	85 c0                	test   %eax,%eax
  800c63:	74 30                	je     800c95 <vsnprintf+0x51>
  800c65:	85 d2                	test   %edx,%edx
  800c67:	7e 2c                	jle    800c95 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c70:	8b 45 10             	mov    0x10(%ebp),%eax
  800c73:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c77:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c7e:	c7 04 24 35 08 80 00 	movl   $0x800835,(%esp)
  800c85:	e8 f0 fb ff ff       	call   80087a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c8d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c93:	eb 05                	jmp    800c9a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800c95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ca5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 04 24             	mov    %eax,(%esp)
  800cbd:	e8 82 ff ff ff       	call   800c44 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    
	...

00800cd0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdb:	80 3a 00             	cmpb   $0x0,(%edx)
  800cde:	74 09                	je     800ce9 <strlen+0x19>
		n++;
  800ce0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ce7:	75 f7                	jne    800ce0 <strlen+0x10>
		n++;
	return n;
}
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	53                   	push   %ebx
  800cef:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800cf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfa:	85 c9                	test   %ecx,%ecx
  800cfc:	74 1a                	je     800d18 <strnlen+0x2d>
  800cfe:	80 3b 00             	cmpb   $0x0,(%ebx)
  800d01:	74 15                	je     800d18 <strnlen+0x2d>
  800d03:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800d08:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0a:	39 ca                	cmp    %ecx,%edx
  800d0c:	74 0a                	je     800d18 <strnlen+0x2d>
  800d0e:	83 c2 01             	add    $0x1,%edx
  800d11:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800d16:	75 f0                	jne    800d08 <strnlen+0x1d>
		n++;
	return n;
}
  800d18:	5b                   	pop    %ebx
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	53                   	push   %ebx
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d25:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d2e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d31:	83 c2 01             	add    $0x1,%edx
  800d34:	84 c9                	test   %cl,%cl
  800d36:	75 f2                	jne    800d2a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d38:	5b                   	pop    %ebx
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 08             	sub    $0x8,%esp
  800d42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d45:	89 1c 24             	mov    %ebx,(%esp)
  800d48:	e8 83 ff ff ff       	call   800cd0 <strlen>
	strcpy(dst + len, src);
  800d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d50:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d54:	01 d8                	add    %ebx,%eax
  800d56:	89 04 24             	mov    %eax,(%esp)
  800d59:	e8 bd ff ff ff       	call   800d1b <strcpy>
	return dst;
}
  800d5e:	89 d8                	mov    %ebx,%eax
  800d60:	83 c4 08             	add    $0x8,%esp
  800d63:	5b                   	pop    %ebx
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d71:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d74:	85 f6                	test   %esi,%esi
  800d76:	74 18                	je     800d90 <strncpy+0x2a>
  800d78:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800d7d:	0f b6 1a             	movzbl (%edx),%ebx
  800d80:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d83:	80 3a 01             	cmpb   $0x1,(%edx)
  800d86:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d89:	83 c1 01             	add    $0x1,%ecx
  800d8c:	39 f1                	cmp    %esi,%ecx
  800d8e:	75 ed                	jne    800d7d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
  800d9a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800da0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800da3:	89 f8                	mov    %edi,%eax
  800da5:	85 f6                	test   %esi,%esi
  800da7:	74 2b                	je     800dd4 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  800da9:	83 fe 01             	cmp    $0x1,%esi
  800dac:	74 23                	je     800dd1 <strlcpy+0x3d>
  800dae:	0f b6 0b             	movzbl (%ebx),%ecx
  800db1:	84 c9                	test   %cl,%cl
  800db3:	74 1c                	je     800dd1 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  800db5:	83 ee 02             	sub    $0x2,%esi
  800db8:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800dbd:	88 08                	mov    %cl,(%eax)
  800dbf:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dc2:	39 f2                	cmp    %esi,%edx
  800dc4:	74 0b                	je     800dd1 <strlcpy+0x3d>
  800dc6:	83 c2 01             	add    $0x1,%edx
  800dc9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800dcd:	84 c9                	test   %cl,%cl
  800dcf:	75 ec                	jne    800dbd <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  800dd1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd4:	29 f8                	sub    %edi,%eax
}
  800dd6:	5b                   	pop    %ebx
  800dd7:	5e                   	pop    %esi
  800dd8:	5f                   	pop    %edi
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800de4:	0f b6 01             	movzbl (%ecx),%eax
  800de7:	84 c0                	test   %al,%al
  800de9:	74 16                	je     800e01 <strcmp+0x26>
  800deb:	3a 02                	cmp    (%edx),%al
  800ded:	75 12                	jne    800e01 <strcmp+0x26>
		p++, q++;
  800def:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800df2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  800df6:	84 c0                	test   %al,%al
  800df8:	74 07                	je     800e01 <strcmp+0x26>
  800dfa:	83 c1 01             	add    $0x1,%ecx
  800dfd:	3a 02                	cmp    (%edx),%al
  800dff:	74 ee                	je     800def <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	0f b6 12             	movzbl (%edx),%edx
  800e07:	29 d0                	sub    %edx,%eax
}
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	53                   	push   %ebx
  800e0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e15:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800e18:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e1d:	85 d2                	test   %edx,%edx
  800e1f:	74 28                	je     800e49 <strncmp+0x3e>
  800e21:	0f b6 01             	movzbl (%ecx),%eax
  800e24:	84 c0                	test   %al,%al
  800e26:	74 24                	je     800e4c <strncmp+0x41>
  800e28:	3a 03                	cmp    (%ebx),%al
  800e2a:	75 20                	jne    800e4c <strncmp+0x41>
  800e2c:	83 ea 01             	sub    $0x1,%edx
  800e2f:	74 13                	je     800e44 <strncmp+0x39>
		n--, p++, q++;
  800e31:	83 c1 01             	add    $0x1,%ecx
  800e34:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e37:	0f b6 01             	movzbl (%ecx),%eax
  800e3a:	84 c0                	test   %al,%al
  800e3c:	74 0e                	je     800e4c <strncmp+0x41>
  800e3e:	3a 03                	cmp    (%ebx),%al
  800e40:	74 ea                	je     800e2c <strncmp+0x21>
  800e42:	eb 08                	jmp    800e4c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800e49:	5b                   	pop    %ebx
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4c:	0f b6 01             	movzbl (%ecx),%eax
  800e4f:	0f b6 13             	movzbl (%ebx),%edx
  800e52:	29 d0                	sub    %edx,%eax
  800e54:	eb f3                	jmp    800e49 <strncmp+0x3e>

00800e56 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e60:	0f b6 10             	movzbl (%eax),%edx
  800e63:	84 d2                	test   %dl,%dl
  800e65:	74 1c                	je     800e83 <strchr+0x2d>
		if (*s == c)
  800e67:	38 ca                	cmp    %cl,%dl
  800e69:	75 09                	jne    800e74 <strchr+0x1e>
  800e6b:	eb 1b                	jmp    800e88 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e6d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  800e70:	38 ca                	cmp    %cl,%dl
  800e72:	74 14                	je     800e88 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e74:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  800e78:	84 d2                	test   %dl,%dl
  800e7a:	75 f1                	jne    800e6d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800e7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e81:	eb 05                	jmp    800e88 <strchr+0x32>
  800e83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    

00800e8a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e94:	0f b6 10             	movzbl (%eax),%edx
  800e97:	84 d2                	test   %dl,%dl
  800e99:	74 14                	je     800eaf <strfind+0x25>
		if (*s == c)
  800e9b:	38 ca                	cmp    %cl,%dl
  800e9d:	75 06                	jne    800ea5 <strfind+0x1b>
  800e9f:	eb 0e                	jmp    800eaf <strfind+0x25>
  800ea1:	38 ca                	cmp    %cl,%dl
  800ea3:	74 0a                	je     800eaf <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ea5:	83 c0 01             	add    $0x1,%eax
  800ea8:	0f b6 10             	movzbl (%eax),%edx
  800eab:	84 d2                	test   %dl,%dl
  800ead:	75 f2                	jne    800ea1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    

00800eb1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	83 ec 0c             	sub    $0xc,%esp
  800eb7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eba:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ebd:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800ec0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ec9:	85 c9                	test   %ecx,%ecx
  800ecb:	74 30                	je     800efd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ecd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ed3:	75 25                	jne    800efa <memset+0x49>
  800ed5:	f6 c1 03             	test   $0x3,%cl
  800ed8:	75 20                	jne    800efa <memset+0x49>
		c &= 0xFF;
  800eda:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800edd:	89 d3                	mov    %edx,%ebx
  800edf:	c1 e3 08             	shl    $0x8,%ebx
  800ee2:	89 d6                	mov    %edx,%esi
  800ee4:	c1 e6 18             	shl    $0x18,%esi
  800ee7:	89 d0                	mov    %edx,%eax
  800ee9:	c1 e0 10             	shl    $0x10,%eax
  800eec:	09 f0                	or     %esi,%eax
  800eee:	09 d0                	or     %edx,%eax
  800ef0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ef2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ef5:	fc                   	cld    
  800ef6:	f3 ab                	rep stos %eax,%es:(%edi)
  800ef8:	eb 03                	jmp    800efd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800efa:	fc                   	cld    
  800efb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800efd:	89 f8                	mov    %edi,%eax
  800eff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f02:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f05:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f08:	89 ec                	mov    %ebp,%esp
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    

00800f0c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 08             	sub    $0x8,%esp
  800f12:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f15:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f21:	39 c6                	cmp    %eax,%esi
  800f23:	73 36                	jae    800f5b <memmove+0x4f>
  800f25:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f28:	39 d0                	cmp    %edx,%eax
  800f2a:	73 2f                	jae    800f5b <memmove+0x4f>
		s += n;
		d += n;
  800f2c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f2f:	f6 c2 03             	test   $0x3,%dl
  800f32:	75 1b                	jne    800f4f <memmove+0x43>
  800f34:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f3a:	75 13                	jne    800f4f <memmove+0x43>
  800f3c:	f6 c1 03             	test   $0x3,%cl
  800f3f:	75 0e                	jne    800f4f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f41:	83 ef 04             	sub    $0x4,%edi
  800f44:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f47:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800f4a:	fd                   	std    
  800f4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f4d:	eb 09                	jmp    800f58 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f4f:	83 ef 01             	sub    $0x1,%edi
  800f52:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800f55:	fd                   	std    
  800f56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f58:	fc                   	cld    
  800f59:	eb 20                	jmp    800f7b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f5b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f61:	75 13                	jne    800f76 <memmove+0x6a>
  800f63:	a8 03                	test   $0x3,%al
  800f65:	75 0f                	jne    800f76 <memmove+0x6a>
  800f67:	f6 c1 03             	test   $0x3,%cl
  800f6a:	75 0a                	jne    800f76 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f6c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800f6f:	89 c7                	mov    %eax,%edi
  800f71:	fc                   	cld    
  800f72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f74:	eb 05                	jmp    800f7b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f76:	89 c7                	mov    %eax,%edi
  800f78:	fc                   	cld    
  800f79:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f7b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f7e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f81:	89 ec                	mov    %ebp,%esp
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	89 04 24             	mov    %eax,(%esp)
  800f9f:	e8 68 ff ff ff       	call   800f0c <memmove>
}
  800fa4:	c9                   	leave  
  800fa5:	c3                   	ret    

00800fa6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
  800fac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800faf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fb2:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fb5:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fba:	85 ff                	test   %edi,%edi
  800fbc:	74 37                	je     800ff5 <memcmp+0x4f>
		if (*s1 != *s2)
  800fbe:	0f b6 03             	movzbl (%ebx),%eax
  800fc1:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fc4:	83 ef 01             	sub    $0x1,%edi
  800fc7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800fcc:	38 c8                	cmp    %cl,%al
  800fce:	74 1c                	je     800fec <memcmp+0x46>
  800fd0:	eb 10                	jmp    800fe2 <memcmp+0x3c>
  800fd2:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800fd7:	83 c2 01             	add    $0x1,%edx
  800fda:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800fde:	38 c8                	cmp    %cl,%al
  800fe0:	74 0a                	je     800fec <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  800fe2:	0f b6 c0             	movzbl %al,%eax
  800fe5:	0f b6 c9             	movzbl %cl,%ecx
  800fe8:	29 c8                	sub    %ecx,%eax
  800fea:	eb 09                	jmp    800ff5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fec:	39 fa                	cmp    %edi,%edx
  800fee:	75 e2                	jne    800fd2 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801000:	89 c2                	mov    %eax,%edx
  801002:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801005:	39 d0                	cmp    %edx,%eax
  801007:	73 19                	jae    801022 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801009:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  80100d:	38 08                	cmp    %cl,(%eax)
  80100f:	75 06                	jne    801017 <memfind+0x1d>
  801011:	eb 0f                	jmp    801022 <memfind+0x28>
  801013:	38 08                	cmp    %cl,(%eax)
  801015:	74 0b                	je     801022 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801017:	83 c0 01             	add    $0x1,%eax
  80101a:	39 d0                	cmp    %edx,%eax
  80101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801020:	75 f1                	jne    801013 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801022:	5d                   	pop    %ebp
  801023:	c3                   	ret    

00801024 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	57                   	push   %edi
  801028:	56                   	push   %esi
  801029:	53                   	push   %ebx
  80102a:	8b 55 08             	mov    0x8(%ebp),%edx
  80102d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801030:	0f b6 02             	movzbl (%edx),%eax
  801033:	3c 20                	cmp    $0x20,%al
  801035:	74 04                	je     80103b <strtol+0x17>
  801037:	3c 09                	cmp    $0x9,%al
  801039:	75 0e                	jne    801049 <strtol+0x25>
		s++;
  80103b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103e:	0f b6 02             	movzbl (%edx),%eax
  801041:	3c 20                	cmp    $0x20,%al
  801043:	74 f6                	je     80103b <strtol+0x17>
  801045:	3c 09                	cmp    $0x9,%al
  801047:	74 f2                	je     80103b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  801049:	3c 2b                	cmp    $0x2b,%al
  80104b:	75 0a                	jne    801057 <strtol+0x33>
		s++;
  80104d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801050:	bf 00 00 00 00       	mov    $0x0,%edi
  801055:	eb 10                	jmp    801067 <strtol+0x43>
  801057:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80105c:	3c 2d                	cmp    $0x2d,%al
  80105e:	75 07                	jne    801067 <strtol+0x43>
		s++, neg = 1;
  801060:	83 c2 01             	add    $0x1,%edx
  801063:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801067:	85 db                	test   %ebx,%ebx
  801069:	0f 94 c0             	sete   %al
  80106c:	74 05                	je     801073 <strtol+0x4f>
  80106e:	83 fb 10             	cmp    $0x10,%ebx
  801071:	75 15                	jne    801088 <strtol+0x64>
  801073:	80 3a 30             	cmpb   $0x30,(%edx)
  801076:	75 10                	jne    801088 <strtol+0x64>
  801078:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80107c:	75 0a                	jne    801088 <strtol+0x64>
		s += 2, base = 16;
  80107e:	83 c2 02             	add    $0x2,%edx
  801081:	bb 10 00 00 00       	mov    $0x10,%ebx
  801086:	eb 13                	jmp    80109b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  801088:	84 c0                	test   %al,%al
  80108a:	74 0f                	je     80109b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80108c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801091:	80 3a 30             	cmpb   $0x30,(%edx)
  801094:	75 05                	jne    80109b <strtol+0x77>
		s++, base = 8;
  801096:	83 c2 01             	add    $0x1,%edx
  801099:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  80109b:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a2:	0f b6 0a             	movzbl (%edx),%ecx
  8010a5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8010a8:	80 fb 09             	cmp    $0x9,%bl
  8010ab:	77 08                	ja     8010b5 <strtol+0x91>
			dig = *s - '0';
  8010ad:	0f be c9             	movsbl %cl,%ecx
  8010b0:	83 e9 30             	sub    $0x30,%ecx
  8010b3:	eb 1e                	jmp    8010d3 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  8010b5:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  8010b8:	80 fb 19             	cmp    $0x19,%bl
  8010bb:	77 08                	ja     8010c5 <strtol+0xa1>
			dig = *s - 'a' + 10;
  8010bd:	0f be c9             	movsbl %cl,%ecx
  8010c0:	83 e9 57             	sub    $0x57,%ecx
  8010c3:	eb 0e                	jmp    8010d3 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  8010c5:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  8010c8:	80 fb 19             	cmp    $0x19,%bl
  8010cb:	77 14                	ja     8010e1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  8010cd:	0f be c9             	movsbl %cl,%ecx
  8010d0:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8010d3:	39 f1                	cmp    %esi,%ecx
  8010d5:	7d 0e                	jge    8010e5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8010d7:	83 c2 01             	add    $0x1,%edx
  8010da:	0f af c6             	imul   %esi,%eax
  8010dd:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  8010df:	eb c1                	jmp    8010a2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  8010e1:	89 c1                	mov    %eax,%ecx
  8010e3:	eb 02                	jmp    8010e7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010e5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010eb:	74 05                	je     8010f2 <strtol+0xce>
		*endptr = (char *) s;
  8010ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8010f0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  8010f2:	89 ca                	mov    %ecx,%edx
  8010f4:	f7 da                	neg    %edx
  8010f6:	85 ff                	test   %edi,%edi
  8010f8:	0f 45 c2             	cmovne %edx,%eax
}
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5f                   	pop    %edi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    

00801100 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	83 ec 0c             	sub    $0xc,%esp
  801106:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801109:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80110c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80110f:	b8 00 00 00 00       	mov    $0x0,%eax
  801114:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	89 c3                	mov    %eax,%ebx
  80111c:	89 c7                	mov    %eax,%edi
  80111e:	89 c6                	mov    %eax,%esi
  801120:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801122:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801125:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801128:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80112b:	89 ec                	mov    %ebp,%esp
  80112d:	5d                   	pop    %ebp
  80112e:	c3                   	ret    

0080112f <sys_cgetc>:

int
sys_cgetc(void)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 0c             	sub    $0xc,%esp
  801135:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801138:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80113b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80113e:	ba 00 00 00 00       	mov    $0x0,%edx
  801143:	b8 01 00 00 00       	mov    $0x1,%eax
  801148:	89 d1                	mov    %edx,%ecx
  80114a:	89 d3                	mov    %edx,%ebx
  80114c:	89 d7                	mov    %edx,%edi
  80114e:	89 d6                	mov    %edx,%esi
  801150:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801152:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801155:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801158:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80115b:	89 ec                	mov    %ebp,%esp
  80115d:	5d                   	pop    %ebp
  80115e:	c3                   	ret    

0080115f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	83 ec 38             	sub    $0x38,%esp
  801165:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801168:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80116b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80116e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801173:	b8 03 00 00 00       	mov    $0x3,%eax
  801178:	8b 55 08             	mov    0x8(%ebp),%edx
  80117b:	89 cb                	mov    %ecx,%ebx
  80117d:	89 cf                	mov    %ecx,%edi
  80117f:	89 ce                	mov    %ecx,%esi
  801181:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801183:	85 c0                	test   %eax,%eax
  801185:	7e 28                	jle    8011af <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801187:	89 44 24 10          	mov    %eax,0x10(%esp)
  80118b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801192:	00 
  801193:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  80119a:	00 
  80119b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011a2:	00 
  8011a3:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  8011aa:	e8 55 f4 ff ff       	call   800604 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011af:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011b2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011b5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011b8:	89 ec                	mov    %ebp,%esp
  8011ba:	5d                   	pop    %ebp
  8011bb:	c3                   	ret    

008011bc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 0c             	sub    $0xc,%esp
  8011c2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011c5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011c8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d0:	b8 02 00 00 00       	mov    $0x2,%eax
  8011d5:	89 d1                	mov    %edx,%ecx
  8011d7:	89 d3                	mov    %edx,%ebx
  8011d9:	89 d7                	mov    %edx,%edi
  8011db:	89 d6                	mov    %edx,%esi
  8011dd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011df:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011e2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011e5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011e8:	89 ec                	mov    %ebp,%esp
  8011ea:	5d                   	pop    %ebp
  8011eb:	c3                   	ret    

008011ec <sys_yield>:

void
sys_yield(void)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	83 ec 0c             	sub    $0xc,%esp
  8011f2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011f5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011f8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801200:	b8 0b 00 00 00       	mov    $0xb,%eax
  801205:	89 d1                	mov    %edx,%ecx
  801207:	89 d3                	mov    %edx,%ebx
  801209:	89 d7                	mov    %edx,%edi
  80120b:	89 d6                	mov    %edx,%esi
  80120d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80120f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801212:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801215:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801218:	89 ec                	mov    %ebp,%esp
  80121a:	5d                   	pop    %ebp
  80121b:	c3                   	ret    

0080121c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 38             	sub    $0x38,%esp
  801222:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801225:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801228:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80122b:	be 00 00 00 00       	mov    $0x0,%esi
  801230:	b8 04 00 00 00       	mov    $0x4,%eax
  801235:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801238:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123b:	8b 55 08             	mov    0x8(%ebp),%edx
  80123e:	89 f7                	mov    %esi,%edi
  801240:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801242:	85 c0                	test   %eax,%eax
  801244:	7e 28                	jle    80126e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801246:	89 44 24 10          	mov    %eax,0x10(%esp)
  80124a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801251:	00 
  801252:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  801259:	00 
  80125a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801261:	00 
  801262:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  801269:	e8 96 f3 ff ff       	call   800604 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80126e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801271:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801274:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801277:	89 ec                	mov    %ebp,%esp
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    

0080127b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	83 ec 38             	sub    $0x38,%esp
  801281:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801284:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801287:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128a:	b8 05 00 00 00       	mov    $0x5,%eax
  80128f:	8b 75 18             	mov    0x18(%ebp),%esi
  801292:	8b 7d 14             	mov    0x14(%ebp),%edi
  801295:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801298:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	7e 28                	jle    8012cc <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8012af:	00 
  8012b0:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  8012b7:	00 
  8012b8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012bf:	00 
  8012c0:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  8012c7:	e8 38 f3 ff ff       	call   800604 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012cc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012cf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012d5:	89 ec                	mov    %ebp,%esp
  8012d7:	5d                   	pop    %ebp
  8012d8:	c3                   	ret    

008012d9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	83 ec 38             	sub    $0x38,%esp
  8012df:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012e2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012e5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ed:	b8 06 00 00 00       	mov    $0x6,%eax
  8012f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f8:	89 df                	mov    %ebx,%edi
  8012fa:	89 de                	mov    %ebx,%esi
  8012fc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012fe:	85 c0                	test   %eax,%eax
  801300:	7e 28                	jle    80132a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801302:	89 44 24 10          	mov    %eax,0x10(%esp)
  801306:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80130d:	00 
  80130e:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  801315:	00 
  801316:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80131d:	00 
  80131e:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  801325:	e8 da f2 ff ff       	call   800604 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80132a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80132d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801330:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801333:	89 ec                	mov    %ebp,%esp
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    

00801337 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	83 ec 38             	sub    $0x38,%esp
  80133d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801340:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801343:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801346:	bb 00 00 00 00       	mov    $0x0,%ebx
  80134b:	b8 08 00 00 00       	mov    $0x8,%eax
  801350:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801353:	8b 55 08             	mov    0x8(%ebp),%edx
  801356:	89 df                	mov    %ebx,%edi
  801358:	89 de                	mov    %ebx,%esi
  80135a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80135c:	85 c0                	test   %eax,%eax
  80135e:	7e 28                	jle    801388 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801360:	89 44 24 10          	mov    %eax,0x10(%esp)
  801364:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80136b:	00 
  80136c:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  801373:	00 
  801374:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80137b:	00 
  80137c:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  801383:	e8 7c f2 ff ff       	call   800604 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801388:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80138b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80138e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801391:	89 ec                	mov    %ebp,%esp
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    

00801395 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 38             	sub    $0x38,%esp
  80139b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80139e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a9:	b8 09 00 00 00       	mov    $0x9,%eax
  8013ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b4:	89 df                	mov    %ebx,%edi
  8013b6:	89 de                	mov    %ebx,%esi
  8013b8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	7e 28                	jle    8013e6 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013c2:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8013c9:	00 
  8013ca:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  8013d1:	00 
  8013d2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013d9:	00 
  8013da:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  8013e1:	e8 1e f2 ff ff       	call   800604 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8013e6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013e9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013ec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013ef:	89 ec                	mov    %ebp,%esp
  8013f1:	5d                   	pop    %ebp
  8013f2:	c3                   	ret    

008013f3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	83 ec 38             	sub    $0x38,%esp
  8013f9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013ff:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801402:	bb 00 00 00 00       	mov    $0x0,%ebx
  801407:	b8 0a 00 00 00       	mov    $0xa,%eax
  80140c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80140f:	8b 55 08             	mov    0x8(%ebp),%edx
  801412:	89 df                	mov    %ebx,%edi
  801414:	89 de                	mov    %ebx,%esi
  801416:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801418:	85 c0                	test   %eax,%eax
  80141a:	7e 28                	jle    801444 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80141c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801420:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801427:	00 
  801428:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  80142f:	00 
  801430:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801437:	00 
  801438:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  80143f:	e8 c0 f1 ff ff       	call   800604 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801444:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801447:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80144a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80144d:	89 ec                	mov    %ebp,%esp
  80144f:	5d                   	pop    %ebp
  801450:	c3                   	ret    

00801451 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 0c             	sub    $0xc,%esp
  801457:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80145a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80145d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801460:	be 00 00 00 00       	mov    $0x0,%esi
  801465:	b8 0c 00 00 00       	mov    $0xc,%eax
  80146a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80146d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801470:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801473:	8b 55 08             	mov    0x8(%ebp),%edx
  801476:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801478:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80147b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80147e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801481:	89 ec                	mov    %ebp,%esp
  801483:	5d                   	pop    %ebp
  801484:	c3                   	ret    

00801485 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 38             	sub    $0x38,%esp
  80148b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80148e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801491:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801494:	b9 00 00 00 00       	mov    $0x0,%ecx
  801499:	b8 0d 00 00 00       	mov    $0xd,%eax
  80149e:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a1:	89 cb                	mov    %ecx,%ebx
  8014a3:	89 cf                	mov    %ecx,%edi
  8014a5:	89 ce                	mov    %ecx,%esi
  8014a7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	7e 28                	jle    8014d5 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ad:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014b1:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8014b8:	00 
  8014b9:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  8014c0:	00 
  8014c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014c8:	00 
  8014c9:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  8014d0:	e8 2f f1 ff ff       	call   800604 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8014d5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014d8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014db:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014de:	89 ec                	mov    %ebp,%esp
  8014e0:	5d                   	pop    %ebp
  8014e1:	c3                   	ret    
	...

008014e4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8014ea:	83 3d b4 40 80 00 00 	cmpl   $0x0,0x8040b4
  8014f1:	75 54                	jne    801547 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  8014f3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014fa:	00 
  8014fb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801502:	ee 
  801503:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80150a:	e8 0d fd ff ff       	call   80121c <sys_page_alloc>
  80150f:	85 c0                	test   %eax,%eax
  801511:	79 20                	jns    801533 <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  801513:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801517:	c7 44 24 08 ea 2b 80 	movl   $0x802bea,0x8(%esp)
  80151e:	00 
  80151f:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801526:	00 
  801527:	c7 04 24 02 2c 80 00 	movl   $0x802c02,(%esp)
  80152e:	e8 d1 f0 ff ff       	call   800604 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801533:	c7 44 24 04 54 15 80 	movl   $0x801554,0x4(%esp)
  80153a:	00 
  80153b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801542:	e8 ac fe ff ff       	call   8013f3 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	a3 b4 40 80 00       	mov    %eax,0x8040b4
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    
  801551:	00 00                	add    %al,(%eax)
	...

00801554 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801554:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801555:	a1 b4 40 80 00       	mov    0x8040b4,%eax
	call *%eax
  80155a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80155c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  80155f:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  801563:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  801566:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  80156a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  80156e:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801570:	83 c4 08             	add    $0x8,%esp
	popal
  801573:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801574:	83 c4 04             	add    $0x4,%esp
	popfl
  801577:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  801578:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801579:	c3                   	ret    
  80157a:	00 00                	add    %al,(%eax)
  80157c:	00 00                	add    %al,(%eax)
	...

00801580 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	05 00 00 00 30       	add    $0x30000000,%eax
  80158b:	c1 e8 0c             	shr    $0xc,%eax
}
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    

00801590 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	89 04 24             	mov    %eax,(%esp)
  80159c:	e8 df ff ff ff       	call   801580 <fd2num>
  8015a1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8015a6:	c1 e0 0c             	shl    $0xc,%eax
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	53                   	push   %ebx
  8015af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015b2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8015b7:	a8 01                	test   $0x1,%al
  8015b9:	74 34                	je     8015ef <fd_alloc+0x44>
  8015bb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8015c0:	a8 01                	test   $0x1,%al
  8015c2:	74 32                	je     8015f6 <fd_alloc+0x4b>
  8015c4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8015c9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015cb:	89 c2                	mov    %eax,%edx
  8015cd:	c1 ea 16             	shr    $0x16,%edx
  8015d0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015d7:	f6 c2 01             	test   $0x1,%dl
  8015da:	74 1f                	je     8015fb <fd_alloc+0x50>
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	c1 ea 0c             	shr    $0xc,%edx
  8015e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015e8:	f6 c2 01             	test   $0x1,%dl
  8015eb:	75 17                	jne    801604 <fd_alloc+0x59>
  8015ed:	eb 0c                	jmp    8015fb <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8015ef:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8015f4:	eb 05                	jmp    8015fb <fd_alloc+0x50>
  8015f6:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8015fb:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  8015fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801602:	eb 17                	jmp    80161b <fd_alloc+0x70>
  801604:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801609:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80160e:	75 b9                	jne    8015c9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801610:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  801616:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80161b:	5b                   	pop    %ebx
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    

0080161e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801624:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801629:	83 fa 1f             	cmp    $0x1f,%edx
  80162c:	77 3f                	ja     80166d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80162e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  801634:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801637:	89 d0                	mov    %edx,%eax
  801639:	c1 e8 16             	shr    $0x16,%eax
  80163c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801643:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801648:	f6 c1 01             	test   $0x1,%cl
  80164b:	74 20                	je     80166d <fd_lookup+0x4f>
  80164d:	89 d0                	mov    %edx,%eax
  80164f:	c1 e8 0c             	shr    $0xc,%eax
  801652:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801659:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80165e:	f6 c1 01             	test   $0x1,%cl
  801661:	74 0a                	je     80166d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801663:	8b 45 0c             	mov    0xc(%ebp),%eax
  801666:	89 10                	mov    %edx,(%eax)
	return 0;
  801668:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166d:	5d                   	pop    %ebp
  80166e:	c3                   	ret    

0080166f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	53                   	push   %ebx
  801673:	83 ec 14             	sub    $0x14,%esp
  801676:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801679:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801681:	39 0d 04 30 80 00    	cmp    %ecx,0x803004
  801687:	75 17                	jne    8016a0 <dev_lookup+0x31>
  801689:	eb 07                	jmp    801692 <dev_lookup+0x23>
  80168b:	39 0a                	cmp    %ecx,(%edx)
  80168d:	75 11                	jne    8016a0 <dev_lookup+0x31>
  80168f:	90                   	nop
  801690:	eb 05                	jmp    801697 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801692:	ba 04 30 80 00       	mov    $0x803004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801697:	89 13                	mov    %edx,(%ebx)
			return 0;
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
  80169e:	eb 35                	jmp    8016d5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016a0:	83 c0 01             	add    $0x1,%eax
  8016a3:	8b 14 85 90 2c 80 00 	mov    0x802c90(,%eax,4),%edx
  8016aa:	85 d2                	test   %edx,%edx
  8016ac:	75 dd                	jne    80168b <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016ae:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  8016b3:	8b 40 48             	mov    0x48(%eax),%eax
  8016b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016be:	c7 04 24 10 2c 80 00 	movl   $0x802c10,(%esp)
  8016c5:	e8 35 f0 ff ff       	call   8006ff <cprintf>
	*dev = 0;
  8016ca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8016d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016d5:	83 c4 14             	add    $0x14,%esp
  8016d8:	5b                   	pop    %ebx
  8016d9:	5d                   	pop    %ebp
  8016da:	c3                   	ret    

008016db <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 38             	sub    $0x38,%esp
  8016e1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016e4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016e7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8016ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016ed:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016f1:	89 3c 24             	mov    %edi,(%esp)
  8016f4:	e8 87 fe ff ff       	call   801580 <fd2num>
  8016f9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8016fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801700:	89 04 24             	mov    %eax,(%esp)
  801703:	e8 16 ff ff ff       	call   80161e <fd_lookup>
  801708:	89 c3                	mov    %eax,%ebx
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 05                	js     801713 <fd_close+0x38>
	    || fd != fd2)
  80170e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801711:	74 0e                	je     801721 <fd_close+0x46>
		return (must_exist ? r : 0);
  801713:	89 f0                	mov    %esi,%eax
  801715:	84 c0                	test   %al,%al
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
  80171c:	0f 44 d8             	cmove  %eax,%ebx
  80171f:	eb 3d                	jmp    80175e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801721:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801724:	89 44 24 04          	mov    %eax,0x4(%esp)
  801728:	8b 07                	mov    (%edi),%eax
  80172a:	89 04 24             	mov    %eax,(%esp)
  80172d:	e8 3d ff ff ff       	call   80166f <dev_lookup>
  801732:	89 c3                	mov    %eax,%ebx
  801734:	85 c0                	test   %eax,%eax
  801736:	78 16                	js     80174e <fd_close+0x73>
		if (dev->dev_close)
  801738:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80173b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80173e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801743:	85 c0                	test   %eax,%eax
  801745:	74 07                	je     80174e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801747:	89 3c 24             	mov    %edi,(%esp)
  80174a:	ff d0                	call   *%eax
  80174c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80174e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801752:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801759:	e8 7b fb ff ff       	call   8012d9 <sys_page_unmap>
	return r;
}
  80175e:	89 d8                	mov    %ebx,%eax
  801760:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801763:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801766:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801769:	89 ec                	mov    %ebp,%esp
  80176b:	5d                   	pop    %ebp
  80176c:	c3                   	ret    

0080176d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801773:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801776:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	89 04 24             	mov    %eax,(%esp)
  801780:	e8 99 fe ff ff       	call   80161e <fd_lookup>
  801785:	85 c0                	test   %eax,%eax
  801787:	78 13                	js     80179c <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801789:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801790:	00 
  801791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801794:	89 04 24             	mov    %eax,(%esp)
  801797:	e8 3f ff ff ff       	call   8016db <fd_close>
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <close_all>:

void
close_all(void)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017a5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017aa:	89 1c 24             	mov    %ebx,(%esp)
  8017ad:	e8 bb ff ff ff       	call   80176d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017b2:	83 c3 01             	add    $0x1,%ebx
  8017b5:	83 fb 20             	cmp    $0x20,%ebx
  8017b8:	75 f0                	jne    8017aa <close_all+0xc>
		close(i);
}
  8017ba:	83 c4 14             	add    $0x14,%esp
  8017bd:	5b                   	pop    %ebx
  8017be:	5d                   	pop    %ebp
  8017bf:	c3                   	ret    

008017c0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 58             	sub    $0x58,%esp
  8017c6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017c9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017cc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8017cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	89 04 24             	mov    %eax,(%esp)
  8017df:	e8 3a fe ff ff       	call   80161e <fd_lookup>
  8017e4:	89 c3                	mov    %eax,%ebx
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	0f 88 e1 00 00 00    	js     8018cf <dup+0x10f>
		return r;
	close(newfdnum);
  8017ee:	89 3c 24             	mov    %edi,(%esp)
  8017f1:	e8 77 ff ff ff       	call   80176d <close>

	newfd = INDEX2FD(newfdnum);
  8017f6:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8017fc:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8017ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801802:	89 04 24             	mov    %eax,(%esp)
  801805:	e8 86 fd ff ff       	call   801590 <fd2data>
  80180a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80180c:	89 34 24             	mov    %esi,(%esp)
  80180f:	e8 7c fd ff ff       	call   801590 <fd2data>
  801814:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801817:	89 d8                	mov    %ebx,%eax
  801819:	c1 e8 16             	shr    $0x16,%eax
  80181c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801823:	a8 01                	test   $0x1,%al
  801825:	74 46                	je     80186d <dup+0xad>
  801827:	89 d8                	mov    %ebx,%eax
  801829:	c1 e8 0c             	shr    $0xc,%eax
  80182c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801833:	f6 c2 01             	test   $0x1,%dl
  801836:	74 35                	je     80186d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801838:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80183f:	25 07 0e 00 00       	and    $0xe07,%eax
  801844:	89 44 24 10          	mov    %eax,0x10(%esp)
  801848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80184b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80184f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801856:	00 
  801857:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80185b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801862:	e8 14 fa ff ff       	call   80127b <sys_page_map>
  801867:	89 c3                	mov    %eax,%ebx
  801869:	85 c0                	test   %eax,%eax
  80186b:	78 3b                	js     8018a8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80186d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801870:	89 c2                	mov    %eax,%edx
  801872:	c1 ea 0c             	shr    $0xc,%edx
  801875:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80187c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801882:	89 54 24 10          	mov    %edx,0x10(%esp)
  801886:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80188a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801891:	00 
  801892:	89 44 24 04          	mov    %eax,0x4(%esp)
  801896:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80189d:	e8 d9 f9 ff ff       	call   80127b <sys_page_map>
  8018a2:	89 c3                	mov    %eax,%ebx
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	79 25                	jns    8018cd <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8018a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018b3:	e8 21 fa ff ff       	call   8012d9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018c6:	e8 0e fa ff ff       	call   8012d9 <sys_page_unmap>
	return r;
  8018cb:	eb 02                	jmp    8018cf <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8018cd:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018cf:	89 d8                	mov    %ebx,%eax
  8018d1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018d4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018d7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018da:	89 ec                	mov    %ebp,%esp
  8018dc:	5d                   	pop    %ebp
  8018dd:	c3                   	ret    

008018de <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 24             	sub    $0x24,%esp
  8018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ef:	89 1c 24             	mov    %ebx,(%esp)
  8018f2:	e8 27 fd ff ff       	call   80161e <fd_lookup>
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	78 6d                	js     801968 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	89 04 24             	mov    %eax,(%esp)
  80190a:	e8 60 fd ff ff       	call   80166f <dev_lookup>
  80190f:	85 c0                	test   %eax,%eax
  801911:	78 55                	js     801968 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801916:	8b 50 08             	mov    0x8(%eax),%edx
  801919:	83 e2 03             	and    $0x3,%edx
  80191c:	83 fa 01             	cmp    $0x1,%edx
  80191f:	75 23                	jne    801944 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801921:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801926:	8b 40 48             	mov    0x48(%eax),%eax
  801929:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80192d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801931:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  801938:	e8 c2 ed ff ff       	call   8006ff <cprintf>
		return -E_INVAL;
  80193d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801942:	eb 24                	jmp    801968 <read+0x8a>
	}
	if (!dev->dev_read)
  801944:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801947:	8b 52 08             	mov    0x8(%edx),%edx
  80194a:	85 d2                	test   %edx,%edx
  80194c:	74 15                	je     801963 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80194e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801951:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801955:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801958:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80195c:	89 04 24             	mov    %eax,(%esp)
  80195f:	ff d2                	call   *%edx
  801961:	eb 05                	jmp    801968 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801963:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801968:	83 c4 24             	add    $0x24,%esp
  80196b:	5b                   	pop    %ebx
  80196c:	5d                   	pop    %ebp
  80196d:	c3                   	ret    

0080196e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	57                   	push   %edi
  801972:	56                   	push   %esi
  801973:	53                   	push   %ebx
  801974:	83 ec 1c             	sub    $0x1c,%esp
  801977:	8b 7d 08             	mov    0x8(%ebp),%edi
  80197a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80197d:	b8 00 00 00 00       	mov    $0x0,%eax
  801982:	85 f6                	test   %esi,%esi
  801984:	74 30                	je     8019b6 <readn+0x48>
  801986:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  80198b:	89 f2                	mov    %esi,%edx
  80198d:	29 c2                	sub    %eax,%edx
  80198f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801993:	03 45 0c             	add    0xc(%ebp),%eax
  801996:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199a:	89 3c 24             	mov    %edi,(%esp)
  80199d:	e8 3c ff ff ff       	call   8018de <read>
		if (m < 0)
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	78 10                	js     8019b6 <readn+0x48>
			return m;
		if (m == 0)
  8019a6:	85 c0                	test   %eax,%eax
  8019a8:	74 0a                	je     8019b4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019aa:	01 c3                	add    %eax,%ebx
  8019ac:	89 d8                	mov    %ebx,%eax
  8019ae:	39 f3                	cmp    %esi,%ebx
  8019b0:	72 d9                	jb     80198b <readn+0x1d>
  8019b2:	eb 02                	jmp    8019b6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8019b4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8019b6:	83 c4 1c             	add    $0x1c,%esp
  8019b9:	5b                   	pop    %ebx
  8019ba:	5e                   	pop    %esi
  8019bb:	5f                   	pop    %edi
  8019bc:	5d                   	pop    %ebp
  8019bd:	c3                   	ret    

008019be <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	53                   	push   %ebx
  8019c2:	83 ec 24             	sub    $0x24,%esp
  8019c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cf:	89 1c 24             	mov    %ebx,(%esp)
  8019d2:	e8 47 fc ff ff       	call   80161e <fd_lookup>
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	78 68                	js     801a43 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e5:	8b 00                	mov    (%eax),%eax
  8019e7:	89 04 24             	mov    %eax,(%esp)
  8019ea:	e8 80 fc ff ff       	call   80166f <dev_lookup>
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	78 50                	js     801a43 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019fa:	75 23                	jne    801a1f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019fc:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801a01:	8b 40 48             	mov    0x48(%eax),%eax
  801a04:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0c:	c7 04 24 70 2c 80 00 	movl   $0x802c70,(%esp)
  801a13:	e8 e7 ec ff ff       	call   8006ff <cprintf>
		return -E_INVAL;
  801a18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a1d:	eb 24                	jmp    801a43 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a22:	8b 52 0c             	mov    0xc(%edx),%edx
  801a25:	85 d2                	test   %edx,%edx
  801a27:	74 15                	je     801a3e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a2c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a37:	89 04 24             	mov    %eax,(%esp)
  801a3a:	ff d2                	call   *%edx
  801a3c:	eb 05                	jmp    801a43 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a3e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a43:	83 c4 24             	add    $0x24,%esp
  801a46:	5b                   	pop    %ebx
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    

00801a49 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a4f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	89 04 24             	mov    %eax,(%esp)
  801a5c:	e8 bd fb ff ff       	call   80161e <fd_lookup>
  801a61:	85 c0                	test   %eax,%eax
  801a63:	78 0e                	js     801a73 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	53                   	push   %ebx
  801a79:	83 ec 24             	sub    $0x24,%esp
  801a7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a86:	89 1c 24             	mov    %ebx,(%esp)
  801a89:	e8 90 fb ff ff       	call   80161e <fd_lookup>
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	78 61                	js     801af3 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a92:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9c:	8b 00                	mov    (%eax),%eax
  801a9e:	89 04 24             	mov    %eax,(%esp)
  801aa1:	e8 c9 fb ff ff       	call   80166f <dev_lookup>
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	78 49                	js     801af3 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aad:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ab1:	75 23                	jne    801ad6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801ab3:	a1 b0 40 80 00       	mov    0x8040b0,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ab8:	8b 40 48             	mov    0x48(%eax),%eax
  801abb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac3:	c7 04 24 30 2c 80 00 	movl   $0x802c30,(%esp)
  801aca:	e8 30 ec ff ff       	call   8006ff <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801acf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ad4:	eb 1d                	jmp    801af3 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  801ad6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad9:	8b 52 18             	mov    0x18(%edx),%edx
  801adc:	85 d2                	test   %edx,%edx
  801ade:	74 0e                	je     801aee <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ae0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ae3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ae7:	89 04 24             	mov    %eax,(%esp)
  801aea:	ff d2                	call   *%edx
  801aec:	eb 05                	jmp    801af3 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801aee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801af3:	83 c4 24             	add    $0x24,%esp
  801af6:	5b                   	pop    %ebx
  801af7:	5d                   	pop    %ebp
  801af8:	c3                   	ret    

00801af9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	53                   	push   %ebx
  801afd:	83 ec 24             	sub    $0x24,%esp
  801b00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b03:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	89 04 24             	mov    %eax,(%esp)
  801b10:	e8 09 fb ff ff       	call   80161e <fd_lookup>
  801b15:	85 c0                	test   %eax,%eax
  801b17:	78 52                	js     801b6b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b23:	8b 00                	mov    (%eax),%eax
  801b25:	89 04 24             	mov    %eax,(%esp)
  801b28:	e8 42 fb ff ff       	call   80166f <dev_lookup>
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 3a                	js     801b6b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  801b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b34:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b38:	74 2c                	je     801b66 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b3a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b3d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b44:	00 00 00 
	stat->st_isdir = 0;
  801b47:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b4e:	00 00 00 
	stat->st_dev = dev;
  801b51:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b57:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b5e:	89 14 24             	mov    %edx,(%esp)
  801b61:	ff 50 14             	call   *0x14(%eax)
  801b64:	eb 05                	jmp    801b6b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b66:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b6b:	83 c4 24             	add    $0x24,%esp
  801b6e:	5b                   	pop    %ebx
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    

00801b71 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 18             	sub    $0x18,%esp
  801b77:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b7a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b7d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b84:	00 
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	89 04 24             	mov    %eax,(%esp)
  801b8b:	e8 bc 01 00 00       	call   801d4c <open>
  801b90:	89 c3                	mov    %eax,%ebx
  801b92:	85 c0                	test   %eax,%eax
  801b94:	78 1b                	js     801bb1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9d:	89 1c 24             	mov    %ebx,(%esp)
  801ba0:	e8 54 ff ff ff       	call   801af9 <fstat>
  801ba5:	89 c6                	mov    %eax,%esi
	close(fd);
  801ba7:	89 1c 24             	mov    %ebx,(%esp)
  801baa:	e8 be fb ff ff       	call   80176d <close>
	return r;
  801baf:	89 f3                	mov    %esi,%ebx
}
  801bb1:	89 d8                	mov    %ebx,%eax
  801bb3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801bb6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801bb9:	89 ec                	mov    %ebp,%esp
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    
  801bbd:	00 00                	add    %al,(%eax)
	...

00801bc0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 18             	sub    $0x18,%esp
  801bc6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801bc9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801bcc:	89 c3                	mov    %eax,%ebx
  801bce:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801bd0:	83 3d ac 40 80 00 00 	cmpl   $0x0,0x8040ac
  801bd7:	75 11                	jne    801bea <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801be0:	e8 61 08 00 00       	call   802446 <ipc_find_env>
  801be5:	a3 ac 40 80 00       	mov    %eax,0x8040ac
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bea:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bf1:	00 
  801bf2:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801bf9:	00 
  801bfa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bfe:	a1 ac 40 80 00       	mov    0x8040ac,%eax
  801c03:	89 04 24             	mov    %eax,(%esp)
  801c06:	e8 b7 07 00 00       	call   8023c2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c0b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c12:	00 
  801c13:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c1e:	e8 4d 07 00 00       	call   802370 <ipc_recv>
}
  801c23:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801c26:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801c29:	89 ec                	mov    %ebp,%esp
  801c2b:	5d                   	pop    %ebp
  801c2c:	c3                   	ret    

00801c2d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	53                   	push   %ebx
  801c31:	83 ec 14             	sub    $0x14,%esp
  801c34:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c3d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c42:	ba 00 00 00 00       	mov    $0x0,%edx
  801c47:	b8 05 00 00 00       	mov    $0x5,%eax
  801c4c:	e8 6f ff ff ff       	call   801bc0 <fsipc>
  801c51:	85 c0                	test   %eax,%eax
  801c53:	78 2b                	js     801c80 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c55:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c5c:	00 
  801c5d:	89 1c 24             	mov    %ebx,(%esp)
  801c60:	e8 b6 f0 ff ff       	call   800d1b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c65:	a1 80 50 80 00       	mov    0x805080,%eax
  801c6a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c70:	a1 84 50 80 00       	mov    0x805084,%eax
  801c75:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c80:	83 c4 14             	add    $0x14,%esp
  801c83:	5b                   	pop    %ebx
  801c84:	5d                   	pop    %ebp
  801c85:	c3                   	ret    

00801c86 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c92:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801c97:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9c:	b8 06 00 00 00       	mov    $0x6,%eax
  801ca1:	e8 1a ff ff ff       	call   801bc0 <fsipc>
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	56                   	push   %esi
  801cac:	53                   	push   %ebx
  801cad:	83 ec 10             	sub    $0x10,%esp
  801cb0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801cbe:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cc4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc9:	b8 03 00 00 00       	mov    $0x3,%eax
  801cce:	e8 ed fe ff ff       	call   801bc0 <fsipc>
  801cd3:	89 c3                	mov    %eax,%ebx
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	78 6a                	js     801d43 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801cd9:	39 c6                	cmp    %eax,%esi
  801cdb:	73 24                	jae    801d01 <devfile_read+0x59>
  801cdd:	c7 44 24 0c a0 2c 80 	movl   $0x802ca0,0xc(%esp)
  801ce4:	00 
  801ce5:	c7 44 24 08 a7 2c 80 	movl   $0x802ca7,0x8(%esp)
  801cec:	00 
  801ced:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801cf4:	00 
  801cf5:	c7 04 24 bc 2c 80 00 	movl   $0x802cbc,(%esp)
  801cfc:	e8 03 e9 ff ff       	call   800604 <_panic>
	assert(r <= PGSIZE);
  801d01:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d06:	7e 24                	jle    801d2c <devfile_read+0x84>
  801d08:	c7 44 24 0c c7 2c 80 	movl   $0x802cc7,0xc(%esp)
  801d0f:	00 
  801d10:	c7 44 24 08 a7 2c 80 	movl   $0x802ca7,0x8(%esp)
  801d17:	00 
  801d18:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801d1f:	00 
  801d20:	c7 04 24 bc 2c 80 00 	movl   $0x802cbc,(%esp)
  801d27:	e8 d8 e8 ff ff       	call   800604 <_panic>
	memmove(buf, &fsipcbuf, r);
  801d2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d30:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801d37:	00 
  801d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3b:	89 04 24             	mov    %eax,(%esp)
  801d3e:	e8 c9 f1 ff ff       	call   800f0c <memmove>
	return r;
}
  801d43:	89 d8                	mov    %ebx,%eax
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	5b                   	pop    %ebx
  801d49:	5e                   	pop    %esi
  801d4a:	5d                   	pop    %ebp
  801d4b:	c3                   	ret    

00801d4c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	56                   	push   %esi
  801d50:	53                   	push   %ebx
  801d51:	83 ec 20             	sub    $0x20,%esp
  801d54:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d57:	89 34 24             	mov    %esi,(%esp)
  801d5a:	e8 71 ef ff ff       	call   800cd0 <strlen>
		return -E_BAD_PATH;
  801d5f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d64:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d69:	7f 5e                	jg     801dc9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6e:	89 04 24             	mov    %eax,(%esp)
  801d71:	e8 35 f8 ff ff       	call   8015ab <fd_alloc>
  801d76:	89 c3                	mov    %eax,%ebx
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	78 4d                	js     801dc9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d7c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d80:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801d87:	e8 8f ef ff ff       	call   800d1b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8f:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d97:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9c:	e8 1f fe ff ff       	call   801bc0 <fsipc>
  801da1:	89 c3                	mov    %eax,%ebx
  801da3:	85 c0                	test   %eax,%eax
  801da5:	79 15                	jns    801dbc <open+0x70>
		fd_close(fd, 0);
  801da7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dae:	00 
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	89 04 24             	mov    %eax,(%esp)
  801db5:	e8 21 f9 ff ff       	call   8016db <fd_close>
		return r;
  801dba:	eb 0d                	jmp    801dc9 <open+0x7d>
	}

	return fd2num(fd);
  801dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbf:	89 04 24             	mov    %eax,(%esp)
  801dc2:	e8 b9 f7 ff ff       	call   801580 <fd2num>
  801dc7:	89 c3                	mov    %eax,%ebx
}
  801dc9:	89 d8                	mov    %ebx,%eax
  801dcb:	83 c4 20             	add    $0x20,%esp
  801dce:	5b                   	pop    %ebx
  801dcf:	5e                   	pop    %esi
  801dd0:	5d                   	pop    %ebp
  801dd1:	c3                   	ret    
	...

00801de0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 18             	sub    $0x18,%esp
  801de6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801de9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801dec:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	89 04 24             	mov    %eax,(%esp)
  801df5:	e8 96 f7 ff ff       	call   801590 <fd2data>
  801dfa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801dfc:	c7 44 24 04 d3 2c 80 	movl   $0x802cd3,0x4(%esp)
  801e03:	00 
  801e04:	89 34 24             	mov    %esi,(%esp)
  801e07:	e8 0f ef ff ff       	call   800d1b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e0c:	8b 43 04             	mov    0x4(%ebx),%eax
  801e0f:	2b 03                	sub    (%ebx),%eax
  801e11:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801e17:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801e1e:	00 00 00 
	stat->st_dev = &devpipe;
  801e21:	c7 86 88 00 00 00 20 	movl   $0x803020,0x88(%esi)
  801e28:	30 80 00 
	return 0;
}
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e30:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e33:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e36:	89 ec                	mov    %ebp,%esp
  801e38:	5d                   	pop    %ebp
  801e39:	c3                   	ret    

00801e3a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	53                   	push   %ebx
  801e3e:	83 ec 14             	sub    $0x14,%esp
  801e41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e44:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e4f:	e8 85 f4 ff ff       	call   8012d9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e54:	89 1c 24             	mov    %ebx,(%esp)
  801e57:	e8 34 f7 ff ff       	call   801590 <fd2data>
  801e5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e67:	e8 6d f4 ff ff       	call   8012d9 <sys_page_unmap>
}
  801e6c:	83 c4 14             	add    $0x14,%esp
  801e6f:	5b                   	pop    %ebx
  801e70:	5d                   	pop    %ebp
  801e71:	c3                   	ret    

00801e72 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	57                   	push   %edi
  801e76:	56                   	push   %esi
  801e77:	53                   	push   %ebx
  801e78:	83 ec 2c             	sub    $0x2c,%esp
  801e7b:	89 c7                	mov    %eax,%edi
  801e7d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e80:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801e85:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e88:	89 3c 24             	mov    %edi,(%esp)
  801e8b:	e8 00 06 00 00       	call   802490 <pageref>
  801e90:	89 c6                	mov    %eax,%esi
  801e92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e95:	89 04 24             	mov    %eax,(%esp)
  801e98:	e8 f3 05 00 00       	call   802490 <pageref>
  801e9d:	39 c6                	cmp    %eax,%esi
  801e9f:	0f 94 c0             	sete   %al
  801ea2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801ea5:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  801eab:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801eae:	39 cb                	cmp    %ecx,%ebx
  801eb0:	75 08                	jne    801eba <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  801eb2:	83 c4 2c             	add    $0x2c,%esp
  801eb5:	5b                   	pop    %ebx
  801eb6:	5e                   	pop    %esi
  801eb7:	5f                   	pop    %edi
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801eba:	83 f8 01             	cmp    $0x1,%eax
  801ebd:	75 c1                	jne    801e80 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ebf:	8b 52 58             	mov    0x58(%edx),%edx
  801ec2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ec6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ece:	c7 04 24 da 2c 80 00 	movl   $0x802cda,(%esp)
  801ed5:	e8 25 e8 ff ff       	call   8006ff <cprintf>
  801eda:	eb a4                	jmp    801e80 <_pipeisclosed+0xe>

00801edc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	57                   	push   %edi
  801ee0:	56                   	push   %esi
  801ee1:	53                   	push   %ebx
  801ee2:	83 ec 2c             	sub    $0x2c,%esp
  801ee5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ee8:	89 34 24             	mov    %esi,(%esp)
  801eeb:	e8 a0 f6 ff ff       	call   801590 <fd2data>
  801ef0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ef2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801efb:	75 50                	jne    801f4d <devpipe_write+0x71>
  801efd:	eb 5c                	jmp    801f5b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801eff:	89 da                	mov    %ebx,%edx
  801f01:	89 f0                	mov    %esi,%eax
  801f03:	e8 6a ff ff ff       	call   801e72 <_pipeisclosed>
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	75 53                	jne    801f5f <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f0c:	e8 db f2 ff ff       	call   8011ec <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f11:	8b 43 04             	mov    0x4(%ebx),%eax
  801f14:	8b 13                	mov    (%ebx),%edx
  801f16:	83 c2 20             	add    $0x20,%edx
  801f19:	39 d0                	cmp    %edx,%eax
  801f1b:	73 e2                	jae    801eff <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f20:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  801f24:	88 55 e7             	mov    %dl,-0x19(%ebp)
  801f27:	89 c2                	mov    %eax,%edx
  801f29:	c1 fa 1f             	sar    $0x1f,%edx
  801f2c:	c1 ea 1b             	shr    $0x1b,%edx
  801f2f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801f32:	83 e1 1f             	and    $0x1f,%ecx
  801f35:	29 d1                	sub    %edx,%ecx
  801f37:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801f3b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801f3f:	83 c0 01             	add    $0x1,%eax
  801f42:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f45:	83 c7 01             	add    $0x1,%edi
  801f48:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f4b:	74 0e                	je     801f5b <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f4d:	8b 43 04             	mov    0x4(%ebx),%eax
  801f50:	8b 13                	mov    (%ebx),%edx
  801f52:	83 c2 20             	add    $0x20,%edx
  801f55:	39 d0                	cmp    %edx,%eax
  801f57:	73 a6                	jae    801eff <devpipe_write+0x23>
  801f59:	eb c2                	jmp    801f1d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f5b:	89 f8                	mov    %edi,%eax
  801f5d:	eb 05                	jmp    801f64 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f5f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f64:	83 c4 2c             	add    $0x2c,%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5f                   	pop    %edi
  801f6a:	5d                   	pop    %ebp
  801f6b:	c3                   	ret    

00801f6c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 28             	sub    $0x28,%esp
  801f72:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f75:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801f78:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801f7b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f7e:	89 3c 24             	mov    %edi,(%esp)
  801f81:	e8 0a f6 ff ff       	call   801590 <fd2data>
  801f86:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f88:	be 00 00 00 00       	mov    $0x0,%esi
  801f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f91:	75 47                	jne    801fda <devpipe_read+0x6e>
  801f93:	eb 52                	jmp    801fe7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801f95:	89 f0                	mov    %esi,%eax
  801f97:	eb 5e                	jmp    801ff7 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f99:	89 da                	mov    %ebx,%edx
  801f9b:	89 f8                	mov    %edi,%eax
  801f9d:	8d 76 00             	lea    0x0(%esi),%esi
  801fa0:	e8 cd fe ff ff       	call   801e72 <_pipeisclosed>
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	75 49                	jne    801ff2 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801fa9:	e8 3e f2 ff ff       	call   8011ec <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801fae:	8b 03                	mov    (%ebx),%eax
  801fb0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fb3:	74 e4                	je     801f99 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fb5:	89 c2                	mov    %eax,%edx
  801fb7:	c1 fa 1f             	sar    $0x1f,%edx
  801fba:	c1 ea 1b             	shr    $0x1b,%edx
  801fbd:	01 d0                	add    %edx,%eax
  801fbf:	83 e0 1f             	and    $0x1f,%eax
  801fc2:	29 d0                	sub    %edx,%eax
  801fc4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801fcf:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fd2:	83 c6 01             	add    $0x1,%esi
  801fd5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fd8:	74 0d                	je     801fe7 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  801fda:	8b 03                	mov    (%ebx),%eax
  801fdc:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fdf:	75 d4                	jne    801fb5 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801fe1:	85 f6                	test   %esi,%esi
  801fe3:	75 b0                	jne    801f95 <devpipe_read+0x29>
  801fe5:	eb b2                	jmp    801f99 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801fe7:	89 f0                	mov    %esi,%eax
  801fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ff0:	eb 05                	jmp    801ff7 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ff2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801ff7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ffa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ffd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802000:	89 ec                	mov    %ebp,%esp
  802002:	5d                   	pop    %ebp
  802003:	c3                   	ret    

00802004 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 48             	sub    $0x48,%esp
  80200a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80200d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802010:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802013:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802016:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802019:	89 04 24             	mov    %eax,(%esp)
  80201c:	e8 8a f5 ff ff       	call   8015ab <fd_alloc>
  802021:	89 c3                	mov    %eax,%ebx
  802023:	85 c0                	test   %eax,%eax
  802025:	0f 88 45 01 00 00    	js     802170 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80202b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802032:	00 
  802033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802036:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802041:	e8 d6 f1 ff ff       	call   80121c <sys_page_alloc>
  802046:	89 c3                	mov    %eax,%ebx
  802048:	85 c0                	test   %eax,%eax
  80204a:	0f 88 20 01 00 00    	js     802170 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802050:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802053:	89 04 24             	mov    %eax,(%esp)
  802056:	e8 50 f5 ff ff       	call   8015ab <fd_alloc>
  80205b:	89 c3                	mov    %eax,%ebx
  80205d:	85 c0                	test   %eax,%eax
  80205f:	0f 88 f8 00 00 00    	js     80215d <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802065:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80206c:	00 
  80206d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802070:	89 44 24 04          	mov    %eax,0x4(%esp)
  802074:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80207b:	e8 9c f1 ff ff       	call   80121c <sys_page_alloc>
  802080:	89 c3                	mov    %eax,%ebx
  802082:	85 c0                	test   %eax,%eax
  802084:	0f 88 d3 00 00 00    	js     80215d <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80208a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80208d:	89 04 24             	mov    %eax,(%esp)
  802090:	e8 fb f4 ff ff       	call   801590 <fd2data>
  802095:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802097:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80209e:	00 
  80209f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020aa:	e8 6d f1 ff ff       	call   80121c <sys_page_alloc>
  8020af:	89 c3                	mov    %eax,%ebx
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	0f 88 91 00 00 00    	js     80214a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020bc:	89 04 24             	mov    %eax,(%esp)
  8020bf:	e8 cc f4 ff ff       	call   801590 <fd2data>
  8020c4:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8020cb:	00 
  8020cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020d7:	00 
  8020d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e3:	e8 93 f1 ff ff       	call   80127b <sys_page_map>
  8020e8:	89 c3                	mov    %eax,%ebx
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	78 4c                	js     80213a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8020ee:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8020f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802103:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802109:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80210e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802111:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80211b:	89 04 24             	mov    %eax,(%esp)
  80211e:	e8 5d f4 ff ff       	call   801580 <fd2num>
  802123:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802125:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802128:	89 04 24             	mov    %eax,(%esp)
  80212b:	e8 50 f4 ff ff       	call   801580 <fd2num>
  802130:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802133:	bb 00 00 00 00       	mov    $0x0,%ebx
  802138:	eb 36                	jmp    802170 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  80213a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80213e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802145:	e8 8f f1 ff ff       	call   8012d9 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80214a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80214d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802151:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802158:	e8 7c f1 ff ff       	call   8012d9 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80215d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802160:	89 44 24 04          	mov    %eax,0x4(%esp)
  802164:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80216b:	e8 69 f1 ff ff       	call   8012d9 <sys_page_unmap>
    err:
	return r;
}
  802170:	89 d8                	mov    %ebx,%eax
  802172:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802175:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802178:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80217b:	89 ec                	mov    %ebp,%esp
  80217d:	5d                   	pop    %ebp
  80217e:	c3                   	ret    

0080217f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802185:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802188:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	89 04 24             	mov    %eax,(%esp)
  802192:	e8 87 f4 ff ff       	call   80161e <fd_lookup>
  802197:	85 c0                	test   %eax,%eax
  802199:	78 15                	js     8021b0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	89 04 24             	mov    %eax,(%esp)
  8021a1:	e8 ea f3 ff ff       	call   801590 <fd2data>
	return _pipeisclosed(fd, p);
  8021a6:	89 c2                	mov    %eax,%edx
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	e8 c2 fc ff ff       	call   801e72 <_pipeisclosed>
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    
	...

008021c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	5d                   	pop    %ebp
  8021c9:	c3                   	ret    

008021ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8021d0:	c7 44 24 04 f2 2c 80 	movl   $0x802cf2,0x4(%esp)
  8021d7:	00 
  8021d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021db:	89 04 24             	mov    %eax,(%esp)
  8021de:	e8 38 eb ff ff       	call   800d1b <strcpy>
	return 0;
}
  8021e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	57                   	push   %edi
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
  8021f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021f6:	be 00 00 00 00       	mov    $0x0,%esi
  8021fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021ff:	74 43                	je     802244 <devcons_write+0x5a>
  802201:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802206:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80220c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80220f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802211:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802214:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802219:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80221c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802220:	03 45 0c             	add    0xc(%ebp),%eax
  802223:	89 44 24 04          	mov    %eax,0x4(%esp)
  802227:	89 3c 24             	mov    %edi,(%esp)
  80222a:	e8 dd ec ff ff       	call   800f0c <memmove>
		sys_cputs(buf, m);
  80222f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802233:	89 3c 24             	mov    %edi,(%esp)
  802236:	e8 c5 ee ff ff       	call   801100 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80223b:	01 de                	add    %ebx,%esi
  80223d:	89 f0                	mov    %esi,%eax
  80223f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802242:	72 c8                	jb     80220c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802244:	89 f0                	mov    %esi,%eax
  802246:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80224c:	5b                   	pop    %ebx
  80224d:	5e                   	pop    %esi
  80224e:	5f                   	pop    %edi
  80224f:	5d                   	pop    %ebp
  802250:	c3                   	ret    

00802251 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  80225c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802260:	75 07                	jne    802269 <devcons_read+0x18>
  802262:	eb 31                	jmp    802295 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802264:	e8 83 ef ff ff       	call   8011ec <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	e8 ba ee ff ff       	call   80112f <sys_cgetc>
  802275:	85 c0                	test   %eax,%eax
  802277:	74 eb                	je     802264 <devcons_read+0x13>
  802279:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80227b:	85 c0                	test   %eax,%eax
  80227d:	78 16                	js     802295 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80227f:	83 f8 04             	cmp    $0x4,%eax
  802282:	74 0c                	je     802290 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  802284:	8b 45 0c             	mov    0xc(%ebp),%eax
  802287:	88 10                	mov    %dl,(%eax)
	return 1;
  802289:	b8 01 00 00 00       	mov    $0x1,%eax
  80228e:	eb 05                	jmp    802295 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802290:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022aa:	00 
  8022ab:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022ae:	89 04 24             	mov    %eax,(%esp)
  8022b1:	e8 4a ee ff ff       	call   801100 <sys_cputs>
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <getchar>:

int
getchar(void)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022be:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022c5:	00 
  8022c6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d4:	e8 05 f6 ff ff       	call   8018de <read>
	if (r < 0)
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	78 0f                	js     8022ec <getchar+0x34>
		return r;
	if (r < 1)
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	7e 06                	jle    8022e7 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022e1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8022e5:	eb 05                	jmp    8022ec <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8022e7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	89 04 24             	mov    %eax,(%esp)
  802301:	e8 18 f3 ff ff       	call   80161e <fd_lookup>
  802306:	85 c0                	test   %eax,%eax
  802308:	78 11                	js     80231b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802313:	39 10                	cmp    %edx,(%eax)
  802315:	0f 94 c0             	sete   %al
  802318:	0f b6 c0             	movzbl %al,%eax
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <opencons>:

int
opencons(void)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802323:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802326:	89 04 24             	mov    %eax,(%esp)
  802329:	e8 7d f2 ff ff       	call   8015ab <fd_alloc>
  80232e:	85 c0                	test   %eax,%eax
  802330:	78 3c                	js     80236e <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802332:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802339:	00 
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802341:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802348:	e8 cf ee ff ff       	call   80121c <sys_page_alloc>
  80234d:	85 c0                	test   %eax,%eax
  80234f:	78 1d                	js     80236e <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802351:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802366:	89 04 24             	mov    %eax,(%esp)
  802369:	e8 12 f2 ff ff       	call   801580 <fd2num>
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	56                   	push   %esi
  802374:	53                   	push   %ebx
  802375:	83 ec 10             	sub    $0x10,%esp
  802378:	8b 75 08             	mov    0x8(%ebp),%esi
  80237b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  802381:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  802383:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802388:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80238b:	89 04 24             	mov    %eax,(%esp)
  80238e:	e8 f2 f0 ff ff       	call   801485 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  802393:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  802398:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  80239d:	85 c0                	test   %eax,%eax
  80239f:	78 0e                	js     8023af <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  8023a1:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  8023a6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  8023a9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  8023ac:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  8023af:	85 f6                	test   %esi,%esi
  8023b1:	74 02                	je     8023b5 <ipc_recv+0x45>
		*from_env_store = sender;
  8023b3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  8023b5:	85 db                	test   %ebx,%ebx
  8023b7:	74 02                	je     8023bb <ipc_recv+0x4b>
		*perm_store = perm;
  8023b9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  8023bb:	83 c4 10             	add    $0x10,%esp
  8023be:	5b                   	pop    %ebx
  8023bf:	5e                   	pop    %esi
  8023c0:	5d                   	pop    %ebp
  8023c1:	c3                   	ret    

008023c2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	57                   	push   %edi
  8023c6:	56                   	push   %esi
  8023c7:	53                   	push   %ebx
  8023c8:	83 ec 1c             	sub    $0x1c,%esp
  8023cb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8023ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023d1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  8023d4:	85 db                	test   %ebx,%ebx
  8023d6:	75 04                	jne    8023dc <ipc_send+0x1a>
  8023d8:	85 f6                	test   %esi,%esi
  8023da:	75 15                	jne    8023f1 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  8023dc:	85 db                	test   %ebx,%ebx
  8023de:	74 16                	je     8023f6 <ipc_send+0x34>
  8023e0:	85 f6                	test   %esi,%esi
  8023e2:	0f 94 c0             	sete   %al
      pg = 0;
  8023e5:	84 c0                	test   %al,%al
  8023e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ec:	0f 45 d8             	cmovne %eax,%ebx
  8023ef:	eb 05                	jmp    8023f6 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  8023f1:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  8023f6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8023fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	89 04 24             	mov    %eax,(%esp)
  802408:	e8 44 f0 ff ff       	call   801451 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  80240d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802410:	75 07                	jne    802419 <ipc_send+0x57>
           sys_yield();
  802412:	e8 d5 ed ff ff       	call   8011ec <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  802417:	eb dd                	jmp    8023f6 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  802419:	85 c0                	test   %eax,%eax
  80241b:	90                   	nop
  80241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802420:	74 1c                	je     80243e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  802422:	c7 44 24 08 fe 2c 80 	movl   $0x802cfe,0x8(%esp)
  802429:	00 
  80242a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  802431:	00 
  802432:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  802439:	e8 c6 e1 ff ff       	call   800604 <_panic>
		}
    }
}
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    

00802446 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
  802449:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80244c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802451:	39 c8                	cmp    %ecx,%eax
  802453:	74 17                	je     80246c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802455:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80245a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80245d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802463:	8b 52 50             	mov    0x50(%edx),%edx
  802466:	39 ca                	cmp    %ecx,%edx
  802468:	75 14                	jne    80247e <ipc_find_env+0x38>
  80246a:	eb 05                	jmp    802471 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80246c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802471:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802474:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802479:	8b 40 40             	mov    0x40(%eax),%eax
  80247c:	eb 0e                	jmp    80248c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80247e:	83 c0 01             	add    $0x1,%eax
  802481:	3d 00 04 00 00       	cmp    $0x400,%eax
  802486:	75 d2                	jne    80245a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802488:	66 b8 00 00          	mov    $0x0,%ax
}
  80248c:	5d                   	pop    %ebp
  80248d:	c3                   	ret    
	...

00802490 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
  802493:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802496:	89 d0                	mov    %edx,%eax
  802498:	c1 e8 16             	shr    $0x16,%eax
  80249b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024a2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024a7:	f6 c1 01             	test   $0x1,%cl
  8024aa:	74 1d                	je     8024c9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024ac:	c1 ea 0c             	shr    $0xc,%edx
  8024af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024b6:	f6 c2 01             	test   $0x1,%dl
  8024b9:	74 0e                	je     8024c9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024bb:	c1 ea 0c             	shr    $0xc,%edx
  8024be:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024c5:	ef 
  8024c6:	0f b7 c0             	movzwl %ax,%eax
}
  8024c9:	5d                   	pop    %ebp
  8024ca:	c3                   	ret    
  8024cb:	00 00                	add    %al,(%eax)
  8024cd:	00 00                	add    %al,(%eax)
	...

008024d0 <__udivdi3>:
  8024d0:	83 ec 1c             	sub    $0x1c,%esp
  8024d3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8024d7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8024db:	8b 44 24 20          	mov    0x20(%esp),%eax
  8024df:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8024e3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8024e7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8024eb:	85 ff                	test   %edi,%edi
  8024ed:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8024f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f5:	89 cd                	mov    %ecx,%ebp
  8024f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024fb:	75 33                	jne    802530 <__udivdi3+0x60>
  8024fd:	39 f1                	cmp    %esi,%ecx
  8024ff:	77 57                	ja     802558 <__udivdi3+0x88>
  802501:	85 c9                	test   %ecx,%ecx
  802503:	75 0b                	jne    802510 <__udivdi3+0x40>
  802505:	b8 01 00 00 00       	mov    $0x1,%eax
  80250a:	31 d2                	xor    %edx,%edx
  80250c:	f7 f1                	div    %ecx
  80250e:	89 c1                	mov    %eax,%ecx
  802510:	89 f0                	mov    %esi,%eax
  802512:	31 d2                	xor    %edx,%edx
  802514:	f7 f1                	div    %ecx
  802516:	89 c6                	mov    %eax,%esi
  802518:	8b 44 24 04          	mov    0x4(%esp),%eax
  80251c:	f7 f1                	div    %ecx
  80251e:	89 f2                	mov    %esi,%edx
  802520:	8b 74 24 10          	mov    0x10(%esp),%esi
  802524:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802528:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80252c:	83 c4 1c             	add    $0x1c,%esp
  80252f:	c3                   	ret    
  802530:	31 d2                	xor    %edx,%edx
  802532:	31 c0                	xor    %eax,%eax
  802534:	39 f7                	cmp    %esi,%edi
  802536:	77 e8                	ja     802520 <__udivdi3+0x50>
  802538:	0f bd cf             	bsr    %edi,%ecx
  80253b:	83 f1 1f             	xor    $0x1f,%ecx
  80253e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802542:	75 2c                	jne    802570 <__udivdi3+0xa0>
  802544:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802548:	76 04                	jbe    80254e <__udivdi3+0x7e>
  80254a:	39 f7                	cmp    %esi,%edi
  80254c:	73 d2                	jae    802520 <__udivdi3+0x50>
  80254e:	31 d2                	xor    %edx,%edx
  802550:	b8 01 00 00 00       	mov    $0x1,%eax
  802555:	eb c9                	jmp    802520 <__udivdi3+0x50>
  802557:	90                   	nop
  802558:	89 f2                	mov    %esi,%edx
  80255a:	f7 f1                	div    %ecx
  80255c:	31 d2                	xor    %edx,%edx
  80255e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802562:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802566:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80256a:	83 c4 1c             	add    $0x1c,%esp
  80256d:	c3                   	ret    
  80256e:	66 90                	xchg   %ax,%ax
  802570:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802575:	b8 20 00 00 00       	mov    $0x20,%eax
  80257a:	89 ea                	mov    %ebp,%edx
  80257c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802580:	d3 e7                	shl    %cl,%edi
  802582:	89 c1                	mov    %eax,%ecx
  802584:	d3 ea                	shr    %cl,%edx
  802586:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80258b:	09 fa                	or     %edi,%edx
  80258d:	89 f7                	mov    %esi,%edi
  80258f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802593:	89 f2                	mov    %esi,%edx
  802595:	8b 74 24 08          	mov    0x8(%esp),%esi
  802599:	d3 e5                	shl    %cl,%ebp
  80259b:	89 c1                	mov    %eax,%ecx
  80259d:	d3 ef                	shr    %cl,%edi
  80259f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025a4:	d3 e2                	shl    %cl,%edx
  8025a6:	89 c1                	mov    %eax,%ecx
  8025a8:	d3 ee                	shr    %cl,%esi
  8025aa:	09 d6                	or     %edx,%esi
  8025ac:	89 fa                	mov    %edi,%edx
  8025ae:	89 f0                	mov    %esi,%eax
  8025b0:	f7 74 24 0c          	divl   0xc(%esp)
  8025b4:	89 d7                	mov    %edx,%edi
  8025b6:	89 c6                	mov    %eax,%esi
  8025b8:	f7 e5                	mul    %ebp
  8025ba:	39 d7                	cmp    %edx,%edi
  8025bc:	72 22                	jb     8025e0 <__udivdi3+0x110>
  8025be:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8025c2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025c7:	d3 e5                	shl    %cl,%ebp
  8025c9:	39 c5                	cmp    %eax,%ebp
  8025cb:	73 04                	jae    8025d1 <__udivdi3+0x101>
  8025cd:	39 d7                	cmp    %edx,%edi
  8025cf:	74 0f                	je     8025e0 <__udivdi3+0x110>
  8025d1:	89 f0                	mov    %esi,%eax
  8025d3:	31 d2                	xor    %edx,%edx
  8025d5:	e9 46 ff ff ff       	jmp    802520 <__udivdi3+0x50>
  8025da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025e0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8025e3:	31 d2                	xor    %edx,%edx
  8025e5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025e9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025ed:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025f1:	83 c4 1c             	add    $0x1c,%esp
  8025f4:	c3                   	ret    
	...

00802600 <__umoddi3>:
  802600:	83 ec 1c             	sub    $0x1c,%esp
  802603:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802607:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80260b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80260f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802613:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802617:	8b 74 24 24          	mov    0x24(%esp),%esi
  80261b:	85 ed                	test   %ebp,%ebp
  80261d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802621:	89 44 24 08          	mov    %eax,0x8(%esp)
  802625:	89 cf                	mov    %ecx,%edi
  802627:	89 04 24             	mov    %eax,(%esp)
  80262a:	89 f2                	mov    %esi,%edx
  80262c:	75 1a                	jne    802648 <__umoddi3+0x48>
  80262e:	39 f1                	cmp    %esi,%ecx
  802630:	76 4e                	jbe    802680 <__umoddi3+0x80>
  802632:	f7 f1                	div    %ecx
  802634:	89 d0                	mov    %edx,%eax
  802636:	31 d2                	xor    %edx,%edx
  802638:	8b 74 24 10          	mov    0x10(%esp),%esi
  80263c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802640:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802644:	83 c4 1c             	add    $0x1c,%esp
  802647:	c3                   	ret    
  802648:	39 f5                	cmp    %esi,%ebp
  80264a:	77 54                	ja     8026a0 <__umoddi3+0xa0>
  80264c:	0f bd c5             	bsr    %ebp,%eax
  80264f:	83 f0 1f             	xor    $0x1f,%eax
  802652:	89 44 24 04          	mov    %eax,0x4(%esp)
  802656:	75 60                	jne    8026b8 <__umoddi3+0xb8>
  802658:	3b 0c 24             	cmp    (%esp),%ecx
  80265b:	0f 87 07 01 00 00    	ja     802768 <__umoddi3+0x168>
  802661:	89 f2                	mov    %esi,%edx
  802663:	8b 34 24             	mov    (%esp),%esi
  802666:	29 ce                	sub    %ecx,%esi
  802668:	19 ea                	sbb    %ebp,%edx
  80266a:	89 34 24             	mov    %esi,(%esp)
  80266d:	8b 04 24             	mov    (%esp),%eax
  802670:	8b 74 24 10          	mov    0x10(%esp),%esi
  802674:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802678:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80267c:	83 c4 1c             	add    $0x1c,%esp
  80267f:	c3                   	ret    
  802680:	85 c9                	test   %ecx,%ecx
  802682:	75 0b                	jne    80268f <__umoddi3+0x8f>
  802684:	b8 01 00 00 00       	mov    $0x1,%eax
  802689:	31 d2                	xor    %edx,%edx
  80268b:	f7 f1                	div    %ecx
  80268d:	89 c1                	mov    %eax,%ecx
  80268f:	89 f0                	mov    %esi,%eax
  802691:	31 d2                	xor    %edx,%edx
  802693:	f7 f1                	div    %ecx
  802695:	8b 04 24             	mov    (%esp),%eax
  802698:	f7 f1                	div    %ecx
  80269a:	eb 98                	jmp    802634 <__umoddi3+0x34>
  80269c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a0:	89 f2                	mov    %esi,%edx
  8026a2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026a6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026aa:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026ae:	83 c4 1c             	add    $0x1c,%esp
  8026b1:	c3                   	ret    
  8026b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026b8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026bd:	89 e8                	mov    %ebp,%eax
  8026bf:	bd 20 00 00 00       	mov    $0x20,%ebp
  8026c4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8026c8:	89 fa                	mov    %edi,%edx
  8026ca:	d3 e0                	shl    %cl,%eax
  8026cc:	89 e9                	mov    %ebp,%ecx
  8026ce:	d3 ea                	shr    %cl,%edx
  8026d0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026d5:	09 c2                	or     %eax,%edx
  8026d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026db:	89 14 24             	mov    %edx,(%esp)
  8026de:	89 f2                	mov    %esi,%edx
  8026e0:	d3 e7                	shl    %cl,%edi
  8026e2:	89 e9                	mov    %ebp,%ecx
  8026e4:	d3 ea                	shr    %cl,%edx
  8026e6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ef:	d3 e6                	shl    %cl,%esi
  8026f1:	89 e9                	mov    %ebp,%ecx
  8026f3:	d3 e8                	shr    %cl,%eax
  8026f5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026fa:	09 f0                	or     %esi,%eax
  8026fc:	8b 74 24 08          	mov    0x8(%esp),%esi
  802700:	f7 34 24             	divl   (%esp)
  802703:	d3 e6                	shl    %cl,%esi
  802705:	89 74 24 08          	mov    %esi,0x8(%esp)
  802709:	89 d6                	mov    %edx,%esi
  80270b:	f7 e7                	mul    %edi
  80270d:	39 d6                	cmp    %edx,%esi
  80270f:	89 c1                	mov    %eax,%ecx
  802711:	89 d7                	mov    %edx,%edi
  802713:	72 3f                	jb     802754 <__umoddi3+0x154>
  802715:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802719:	72 35                	jb     802750 <__umoddi3+0x150>
  80271b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80271f:	29 c8                	sub    %ecx,%eax
  802721:	19 fe                	sbb    %edi,%esi
  802723:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802728:	89 f2                	mov    %esi,%edx
  80272a:	d3 e8                	shr    %cl,%eax
  80272c:	89 e9                	mov    %ebp,%ecx
  80272e:	d3 e2                	shl    %cl,%edx
  802730:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802735:	09 d0                	or     %edx,%eax
  802737:	89 f2                	mov    %esi,%edx
  802739:	d3 ea                	shr    %cl,%edx
  80273b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80273f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802743:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802747:	83 c4 1c             	add    $0x1c,%esp
  80274a:	c3                   	ret    
  80274b:	90                   	nop
  80274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802750:	39 d6                	cmp    %edx,%esi
  802752:	75 c7                	jne    80271b <__umoddi3+0x11b>
  802754:	89 d7                	mov    %edx,%edi
  802756:	89 c1                	mov    %eax,%ecx
  802758:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80275c:	1b 3c 24             	sbb    (%esp),%edi
  80275f:	eb ba                	jmp    80271b <__umoddi3+0x11b>
  802761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802768:	39 f5                	cmp    %esi,%ebp
  80276a:	0f 82 f1 fe ff ff    	jb     802661 <__umoddi3+0x61>
  802770:	e9 f8 fe ff ff       	jmp    80266d <__umoddi3+0x6d>
