
obj/fs/fs:     file format elf32-i386


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
  80002c:	e8 6b 0e 00 00       	call   800e9c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	89 c1                	mov    %eax,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80003a:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003f:	ec                   	in     (%dx),%al
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800040:	0f b6 d8             	movzbl %al,%ebx
  800043:	89 d8                	mov    %ebx,%eax
  800045:	25 c0 00 00 00       	and    $0xc0,%eax
  80004a:	83 f8 40             	cmp    $0x40,%eax
  80004d:	75 f0                	jne    80003f <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  80004f:	b0 00                	mov    $0x0,%al
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800051:	84 c9                	test   %cl,%cl
  800053:	74 0a                	je     80005f <ide_wait_ready+0x2b>
  800055:	83 e3 21             	and    $0x21,%ebx
		return -1;
	return 0;
  800058:	83 fb 01             	cmp    $0x1,%ebx
  80005b:	19 c0                	sbb    %eax,%eax
  80005d:	f7 d0                	not    %eax
}
  80005f:	5b                   	pop    %ebx
  800060:	5d                   	pop    %ebp
  800061:	c3                   	ret    

00800062 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800062:	55                   	push   %ebp
  800063:	89 e5                	mov    %esp,%ebp
  800065:	53                   	push   %ebx
  800066:	83 ec 14             	sub    $0x14,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800069:	b8 00 00 00 00       	mov    $0x0,%eax
  80006e:	e8 c1 ff ff ff       	call   800034 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800073:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800078:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80007d:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80007e:	b2 f7                	mov    $0xf7,%dl
  800080:	ec                   	in     (%dx),%al
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  800081:	bb 01 00 00 00       	mov    $0x1,%ebx
	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800086:	a8 a1                	test   $0xa1,%al
  800088:	75 0f                	jne    800099 <ide_probe_disk1+0x37>

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80008a:	b3 00                	mov    $0x0,%bl
  80008c:	eb 10                	jmp    80009e <ide_probe_disk1+0x3c>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  80008e:	83 c3 01             	add    $0x1,%ebx

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  800091:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  800097:	74 05                	je     80009e <ide_probe_disk1+0x3c>
  800099:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  80009a:	a8 a1                	test   $0xa1,%al
  80009c:	75 f0                	jne    80008e <ide_probe_disk1+0x2c>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80009e:	ba f6 01 00 00       	mov    $0x1f6,%edx
  8000a3:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  8000a8:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a9:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  8000af:	0f 9e c0             	setle  %al
  8000b2:	0f b6 c0             	movzbl %al,%eax
  8000b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b9:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  8000c0:	e8 3e 0f 00 00       	call   801003 <cprintf>
	return (x < 1000);
  8000c5:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  8000cb:	0f 9e c0             	setle  %al
}
  8000ce:	83 c4 14             	add    $0x14,%esp
  8000d1:	5b                   	pop    %ebx
  8000d2:	5d                   	pop    %ebp
  8000d3:	c3                   	ret    

008000d4 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000d4:	55                   	push   %ebp
  8000d5:	89 e5                	mov    %esp,%ebp
  8000d7:	83 ec 18             	sub    $0x18,%esp
  8000da:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000dd:	83 f8 01             	cmp    $0x1,%eax
  8000e0:	76 1c                	jbe    8000fe <ide_set_disk+0x2a>
		panic("bad disk number");
  8000e2:	c7 44 24 08 97 30 80 	movl   $0x803097,0x8(%esp)
  8000e9:	00 
  8000ea:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8000f1:	00 
  8000f2:	c7 04 24 a7 30 80 00 	movl   $0x8030a7,(%esp)
  8000f9:	e8 0a 0e 00 00       	call   800f08 <_panic>
	diskno = d;
  8000fe:	a3 00 40 80 00       	mov    %eax,0x804000
}
  800103:	c9                   	leave  
  800104:	c3                   	ret    

00800105 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800105:	55                   	push   %ebp
  800106:	89 e5                	mov    %esp,%ebp
  800108:	57                   	push   %edi
  800109:	56                   	push   %esi
  80010a:	53                   	push   %ebx
  80010b:	83 ec 1c             	sub    $0x1c,%esp
  80010e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800111:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800114:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800117:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  80011d:	76 24                	jbe    800143 <ide_read+0x3e>
  80011f:	c7 44 24 0c b0 30 80 	movl   $0x8030b0,0xc(%esp)
  800126:	00 
  800127:	c7 44 24 08 bd 30 80 	movl   $0x8030bd,0x8(%esp)
  80012e:	00 
  80012f:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800136:	00 
  800137:	c7 04 24 a7 30 80 00 	movl   $0x8030a7,(%esp)
  80013e:	e8 c5 0d 00 00       	call   800f08 <_panic>

	ide_wait_ready(0);
  800143:	b8 00 00 00 00       	mov    $0x0,%eax
  800148:	e8 e7 fe ff ff       	call   800034 <ide_wait_ready>
  80014d:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800152:	89 f0                	mov    %esi,%eax
  800154:	ee                   	out    %al,(%dx)
  800155:	b2 f3                	mov    $0xf3,%dl
  800157:	89 f8                	mov    %edi,%eax
  800159:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  80015a:	89 f8                	mov    %edi,%eax
  80015c:	c1 e8 08             	shr    $0x8,%eax
  80015f:	b2 f4                	mov    $0xf4,%dl
  800161:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800162:	89 f8                	mov    %edi,%eax
  800164:	c1 e8 10             	shr    $0x10,%eax
  800167:	b2 f5                	mov    $0xf5,%dl
  800169:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80016a:	a1 00 40 80 00       	mov    0x804000,%eax
  80016f:	83 e0 01             	and    $0x1,%eax
  800172:	c1 e0 04             	shl    $0x4,%eax
  800175:	83 c8 e0             	or     $0xffffffe0,%eax
  800178:	c1 ef 18             	shr    $0x18,%edi
  80017b:	83 e7 0f             	and    $0xf,%edi
  80017e:	09 f8                	or     %edi,%eax
  800180:	b2 f6                	mov    $0xf6,%dl
  800182:	ee                   	out    %al,(%dx)
  800183:	b2 f7                	mov    $0xf7,%dl
  800185:	b8 20 00 00 00       	mov    $0x20,%eax
  80018a:	ee                   	out    %al,(%dx)
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  80018b:	b8 00 00 00 00       	mov    $0x0,%eax
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800190:	85 f6                	test   %esi,%esi
  800192:	74 2d                	je     8001c1 <ide_read+0xbc>
		if ((r = ide_wait_ready(1)) < 0)
  800194:	b8 01 00 00 00       	mov    $0x1,%eax
  800199:	e8 96 fe ff ff       	call   800034 <ide_wait_ready>
  80019e:	85 c0                	test   %eax,%eax
  8001a0:	78 1f                	js     8001c1 <ide_read+0xbc>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  8001a2:	89 df                	mov    %ebx,%edi
  8001a4:	b9 80 00 00 00       	mov    $0x80,%ecx
  8001a9:	ba f0 01 00 00       	mov    $0x1f0,%edx
  8001ae:	fc                   	cld    
  8001af:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001b1:	81 c3 00 02 00 00    	add    $0x200,%ebx
  8001b7:	83 ee 01             	sub    $0x1,%esi
  8001ba:	75 d8                	jne    800194 <ide_read+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001c1:	83 c4 1c             	add    $0x1c,%esp
  8001c4:	5b                   	pop    %ebx
  8001c5:	5e                   	pop    %esi
  8001c6:	5f                   	pop    %edi
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    

008001c9 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	57                   	push   %edi
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	83 ec 1c             	sub    $0x1c,%esp
  8001d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8001d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001d8:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001db:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001e1:	76 24                	jbe    800207 <ide_write+0x3e>
  8001e3:	c7 44 24 0c b0 30 80 	movl   $0x8030b0,0xc(%esp)
  8001ea:	00 
  8001eb:	c7 44 24 08 bd 30 80 	movl   $0x8030bd,0x8(%esp)
  8001f2:	00 
  8001f3:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  8001fa:	00 
  8001fb:	c7 04 24 a7 30 80 00 	movl   $0x8030a7,(%esp)
  800202:	e8 01 0d 00 00       	call   800f08 <_panic>

	ide_wait_ready(0);
  800207:	b8 00 00 00 00       	mov    $0x0,%eax
  80020c:	e8 23 fe ff ff       	call   800034 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800211:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800216:	89 f8                	mov    %edi,%eax
  800218:	ee                   	out    %al,(%dx)
  800219:	b2 f3                	mov    $0xf3,%dl
  80021b:	89 f0                	mov    %esi,%eax
  80021d:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  80021e:	89 f0                	mov    %esi,%eax
  800220:	c1 e8 08             	shr    $0x8,%eax
  800223:	b2 f4                	mov    $0xf4,%dl
  800225:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800226:	89 f0                	mov    %esi,%eax
  800228:	c1 e8 10             	shr    $0x10,%eax
  80022b:	b2 f5                	mov    $0xf5,%dl
  80022d:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80022e:	a1 00 40 80 00       	mov    0x804000,%eax
  800233:	83 e0 01             	and    $0x1,%eax
  800236:	c1 e0 04             	shl    $0x4,%eax
  800239:	83 c8 e0             	or     $0xffffffe0,%eax
  80023c:	c1 ee 18             	shr    $0x18,%esi
  80023f:	83 e6 0f             	and    $0xf,%esi
  800242:	09 f0                	or     %esi,%eax
  800244:	b2 f6                	mov    $0xf6,%dl
  800246:	ee                   	out    %al,(%dx)
  800247:	b2 f7                	mov    $0xf7,%dl
  800249:	b8 30 00 00 00       	mov    $0x30,%eax
  80024e:	ee                   	out    %al,(%dx)
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80024f:	b8 00 00 00 00       	mov    $0x0,%eax
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800254:	85 ff                	test   %edi,%edi
  800256:	74 2d                	je     800285 <ide_write+0xbc>
		if ((r = ide_wait_ready(1)) < 0)
  800258:	b8 01 00 00 00       	mov    $0x1,%eax
  80025d:	e8 d2 fd ff ff       	call   800034 <ide_wait_ready>
  800262:	85 c0                	test   %eax,%eax
  800264:	78 1f                	js     800285 <ide_write+0xbc>
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  800266:	89 de                	mov    %ebx,%esi
  800268:	b9 80 00 00 00       	mov    $0x80,%ecx
  80026d:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800272:	fc                   	cld    
  800273:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800275:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80027b:	83 ef 01             	sub    $0x1,%edi
  80027e:	75 d8                	jne    800258 <ide_write+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  800280:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800285:	83 c4 1c             	add    $0x1c,%esp
  800288:	5b                   	pop    %ebx
  800289:	5e                   	pop    %esi
  80028a:	5f                   	pop    %edi
  80028b:	5d                   	pop    %ebp
  80028c:	c3                   	ret    
  80028d:	00 00                	add    %al,(%eax)
	...

00800290 <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	56                   	push   %esi
  800294:	53                   	push   %ebx
  800295:	83 ec 20             	sub    $0x20,%esp
  800298:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80029b:	8b 18                	mov    (%eax),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80029d:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
  8002a3:	81 fa ff ff ff bf    	cmp    $0xbfffffff,%edx
  8002a9:	76 2e                	jbe    8002d9 <bc_pgfault+0x49>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  8002ab:	8b 50 04             	mov    0x4(%eax),%edx
  8002ae:	89 54 24 14          	mov    %edx,0x14(%esp)
  8002b2:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8002b6:	8b 40 28             	mov    0x28(%eax),%eax
  8002b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002bd:	c7 44 24 08 d4 30 80 	movl   $0x8030d4,0x8(%esp)
  8002c4:	00 
  8002c5:	c7 44 24 04 29 00 00 	movl   $0x29,0x4(%esp)
  8002cc:	00 
  8002cd:	c7 04 24 4a 31 80 00 	movl   $0x80314a,(%esp)
  8002d4:	e8 2f 0c 00 00       	call   800f08 <_panic>
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8002d9:	8d b3 00 00 00 f0    	lea    -0x10000000(%ebx),%esi
  8002df:	c1 ee 0c             	shr    $0xc,%esi
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8002e2:	a1 08 90 80 00       	mov    0x809008,%eax
  8002e7:	85 c0                	test   %eax,%eax
  8002e9:	74 25                	je     800310 <bc_pgfault+0x80>
  8002eb:	3b 70 04             	cmp    0x4(%eax),%esi
  8002ee:	72 20                	jb     800310 <bc_pgfault+0x80>
		panic("reading non-existent block %08x\n", blockno);
  8002f0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002f4:	c7 44 24 08 04 31 80 	movl   $0x803104,0x8(%esp)
  8002fb:	00 
  8002fc:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800303:	00 
  800304:	c7 04 24 4a 31 80 00 	movl   $0x80314a,(%esp)
  80030b:	e8 f8 0b 00 00       	call   800f08 <_panic>
	// Allocate a page in the disk map region, read the contents
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//
	// LAB 5: you code here:
	addr = ROUNDDOWN(addr, PGSIZE);
  800310:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	sys_page_alloc(0, addr, PTE_P | PTE_W |PTE_U);
  800316:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80031d:	00 
  80031e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800322:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800329:	e8 ee 17 00 00       	call   801b1c <sys_page_alloc>
	ide_read(blockno*BLKSECTS, addr, BLKSECTS);
  80032e:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  800335:	00 
  800336:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80033a:	c1 e6 03             	shl    $0x3,%esi
  80033d:	89 34 24             	mov    %esi,(%esp)
  800340:	e8 c0 fd ff ff       	call   800105 <ide_read>
}
  800345:	83 c4 20             	add    $0x20,%esp
  800348:	5b                   	pop    %ebx
  800349:	5e                   	pop    %esi
  80034a:	5d                   	pop    %ebp
  80034b:	c3                   	ret    

0080034c <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	83 ec 18             	sub    $0x18,%esp
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  800355:	85 c0                	test   %eax,%eax
  800357:	74 0f                	je     800368 <diskaddr+0x1c>
  800359:	8b 15 08 90 80 00    	mov    0x809008,%edx
  80035f:	85 d2                	test   %edx,%edx
  800361:	74 25                	je     800388 <diskaddr+0x3c>
  800363:	3b 42 04             	cmp    0x4(%edx),%eax
  800366:	72 20                	jb     800388 <diskaddr+0x3c>
		panic("bad block number %08x in diskaddr", blockno);
  800368:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80036c:	c7 44 24 08 28 31 80 	movl   $0x803128,0x8(%esp)
  800373:	00 
  800374:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  80037b:	00 
  80037c:	c7 04 24 4a 31 80 00 	movl   $0x80314a,(%esp)
  800383:	e8 80 0b 00 00       	call   800f08 <_panic>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800388:	05 00 00 01 00       	add    $0x10000,%eax
  80038d:	c1 e0 0c             	shl    $0xc,%eax
}
  800390:	c9                   	leave  
  800391:	c3                   	ret    

00800392 <va_is_mapped>:


// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800392:	55                   	push   %ebp
  800393:	89 e5                	mov    %esp,%ebp
  800395:	8b 55 08             	mov    0x8(%ebp),%edx
    return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  800398:	89 d0                	mov    %edx,%eax
  80039a:	c1 e8 16             	shr    $0x16,%eax
  80039d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	f6 c1 01             	test   $0x1,%cl
  8003ac:	74 0d                	je     8003bb <va_is_mapped+0x29>
  8003ae:	c1 ea 0c             	shr    $0xc,%edx
  8003b1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8003b8:	83 e0 01             	and    $0x1,%eax
}
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
    return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	c1 e8 0c             	shr    $0xc,%eax
  8003c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8003cd:	a8 40                	test   $0x40,%al
  8003cf:	0f 95 c0             	setne  %al
}
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    

008003d4 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	53                   	push   %ebx
  8003d8:	83 ec 24             	sub    $0x24,%esp
    addr             = (void *) ROUNDDOWN(addr, PGSIZE);
  8003db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003de:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    uint32_t sectno  = ((uint32_t)addr - DISKMAP) / SECTSIZE;
    uint32_t blockno = (sectno / BLKSECTS);

    if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  8003e4:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  8003ea:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  8003ef:	76 20                	jbe    800411 <flush_block+0x3d>
        panic("flush_block of bad va %08x", addr);
  8003f1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003f5:	c7 44 24 08 52 31 80 	movl   $0x803152,0x8(%esp)
  8003fc:	00 
  8003fd:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  800404:	00 
  800405:	c7 04 24 4a 31 80 00 	movl   $0x80314a,(%esp)
  80040c:	e8 f7 0a 00 00       	call   800f08 <_panic>

    // LAB 5: Your code here.
    if(va_is_dirty(addr) && va_is_mapped(addr)) {
  800411:	89 1c 24             	mov    %ebx,(%esp)
  800414:	e8 a4 ff ff ff       	call   8003bd <va_is_dirty>
  800419:	84 c0                	test   %al,%al
  80041b:	74 4d                	je     80046a <flush_block+0x96>
  80041d:	89 1c 24             	mov    %ebx,(%esp)
  800420:	e8 6d ff ff ff       	call   800392 <va_is_mapped>
  800425:	84 c0                	test   %al,%al
  800427:	74 41                	je     80046a <flush_block+0x96>
        ide_write(sectno, addr, BLKSECTS);
  800429:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  800430:	00 
  800431:	89 5c 24 04          	mov    %ebx,0x4(%esp)
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
    addr             = (void *) ROUNDDOWN(addr, PGSIZE);
    uint32_t sectno  = ((uint32_t)addr - DISKMAP) / SECTSIZE;
  800435:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80043b:	c1 e8 09             	shr    $0x9,%eax
    if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
        panic("flush_block of bad va %08x", addr);

    // LAB 5: Your code here.
    if(va_is_dirty(addr) && va_is_mapped(addr)) {
        ide_write(sectno, addr, BLKSECTS);
  80043e:	89 04 24             	mov    %eax,(%esp)
  800441:	e8 83 fd ff ff       	call   8001c9 <ide_write>
        sys_page_map(0, addr, 
  800446:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  80044d:	00 
  80044e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800452:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800459:	00 
  80045a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80045e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800465:	e8 11 17 00 00       	call   801b7b <sys_page_map>
                     0, addr,
                     (PTE_SYSCALL));
       // BC_DEBUG("Wrote block %08x, now mapped r/o\n", blockno);
    }
}
  80046a:	83 c4 24             	add    $0x24,%esp
  80046d:	5b                   	pop    %ebx
  80046e:	5d                   	pop    %ebp
  80046f:	c3                   	ret    

00800470 <bc_init>:



void
bc_init(void)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800479:	c7 04 24 90 02 80 00 	movl   $0x800290,(%esp)
  800480:	e8 5f 19 00 00       	call   801de4 <set_pgfault_handler>

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800485:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80048c:	e8 bb fe ff ff       	call   80034c <diskaddr>
  800491:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800498:	00 
  800499:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a3:	89 04 24             	mov    %eax,(%esp)
  8004a6:	e8 61 13 00 00       	call   80180c <memmove>
}
  8004ab:	c9                   	leave  
  8004ac:	c3                   	ret    
  8004ad:	00 00                	add    %al,(%eax)
	...

008004b0 <skip_slash>:


// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
	while (*p == '/')
  8004b3:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004b6:	75 08                	jne    8004c0 <skip_slash+0x10>
		p++;
  8004b8:	83 c0 01             	add    $0x1,%eax

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  8004bb:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004be:	74 f8                	je     8004b8 <skip_slash+0x8>
		p++;
	return p;
}
  8004c0:	5d                   	pop    %ebp
  8004c1:	c3                   	ret    

008004c2 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	83 ec 18             	sub    $0x18,%esp
	if (super->s_magic != FS_MAGIC)
  8004c8:	a1 08 90 80 00       	mov    0x809008,%eax
  8004cd:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8004d3:	74 1c                	je     8004f1 <check_super+0x2f>
		panic("bad file system magic number");
  8004d5:	c7 44 24 08 6d 31 80 	movl   $0x80316d,0x8(%esp)
  8004dc:	00 
  8004dd:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  8004e4:	00 
  8004e5:	c7 04 24 8a 31 80 00 	movl   $0x80318a,(%esp)
  8004ec:	e8 17 0a 00 00       	call   800f08 <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8004f1:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8004f8:	76 1c                	jbe    800516 <check_super+0x54>
		panic("file system is too large");
  8004fa:	c7 44 24 08 92 31 80 	movl   $0x803192,0x8(%esp)
  800501:	00 
  800502:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800509:	00 
  80050a:	c7 04 24 8a 31 80 00 	movl   $0x80318a,(%esp)
  800511:	e8 f2 09 00 00       	call   800f08 <_panic>

	cprintf("superblock is good\n");
  800516:	c7 04 24 ab 31 80 00 	movl   $0x8031ab,(%esp)
  80051d:	e8 e1 0a 00 00       	call   801003 <cprintf>
}
  800522:	c9                   	leave  
  800523:	c3                   	ret    

00800524 <block_is_free>:
bool
block_is_free(uint32_t blockno)
{
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if (super == 0 || blockno >= super->s_nblocks)
  80052a:	8b 15 08 90 80 00    	mov    0x809008,%edx
        return 0;
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
	cprintf("superblock is good\n");
}
bool
block_is_free(uint32_t blockno)
{
    if (super == 0 || blockno >= super->s_nblocks)
  800535:	85 d2                	test   %edx,%edx
  800537:	74 1b                	je     800554 <block_is_free+0x30>
  800539:	39 4a 04             	cmp    %ecx,0x4(%edx)
  80053c:	76 16                	jbe    800554 <block_is_free+0x30>
        return 0;
    if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  80053e:	b8 01 00 00 00       	mov    $0x1,%eax
  800543:	d3 e0                	shl    %cl,%eax
  800545:	c1 e9 05             	shr    $0x5,%ecx
		panic("file system is too large");

	cprintf("superblock is good\n");
}
bool
block_is_free(uint32_t blockno)
  800548:	8b 15 04 90 80 00    	mov    0x809004,%edx
  80054e:	85 04 8a             	test   %eax,(%edx,%ecx,4)
  800551:	0f 95 c0             	setne  %al
    if (super == 0 || blockno >= super->s_nblocks)
        return 0;
    if (bitmap[blockno / 32] & (1 << (blockno % 32)))
        return 1;
    return 0;
}
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	83 ec 18             	sub    $0x18,%esp
  80055c:	8b 4d 08             	mov    0x8(%ebp),%ecx
    // Blockno zero is the null pointer of block numbers.
    if (blockno == 0)
  80055f:	85 c9                	test   %ecx,%ecx
  800561:	75 1c                	jne    80057f <free_block+0x29>
        panic("attempt to free zero block");
  800563:	c7 44 24 08 bf 31 80 	movl   $0x8031bf,0x8(%esp)
  80056a:	00 
  80056b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800572:	00 
  800573:	c7 04 24 8a 31 80 00 	movl   $0x80318a,(%esp)
  80057a:	e8 89 09 00 00       	call   800f08 <_panic>
    bitmap[blockno/32] |= 1<<(blockno%32);
  80057f:	89 c8                	mov    %ecx,%eax
  800581:	c1 e8 05             	shr    $0x5,%eax
  800584:	c1 e0 02             	shl    $0x2,%eax
  800587:	03 05 04 90 80 00    	add    0x809004,%eax
  80058d:	ba 01 00 00 00       	mov    $0x1,%edx
  800592:	d3 e2                	shl    %cl,%edx
  800594:	09 10                	or     %edx,(%eax)
}
  800596:	c9                   	leave  
  800597:	c3                   	ret    

00800598 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	57                   	push   %edi
  80059c:	56                   	push   %esi
  80059d:	53                   	push   %ebx
  80059e:	83 ec 2c             	sub    $0x2c,%esp
	  // LAB 5: Your code here.

    unsigned blockno = 0;
    unsigned bit, mask, entry;

    for(blockno = 1; blockno < super->s_nblocks; blockno++) {
  8005a1:	a1 08 90 80 00       	mov    0x809008,%eax
  8005a6:	8b 40 04             	mov    0x4(%eax),%eax
  8005a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ac:	83 f8 01             	cmp    $0x1,%eax
  8005af:	0f 86 97 00 00 00    	jbe    80064c <alloc_block+0xb4>
      bit = 1<<(blockno%32);
      mask = ~bit;
      entry = blockno/32;

      if(bitmap[entry] & bit) {
  8005b5:	a1 04 90 80 00       	mov    0x809004,%eax
  8005ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005bd:	8b 18                	mov    (%eax),%ebx
	  // LAB 5: Your code here.

    unsigned blockno = 0;
    unsigned bit, mask, entry;

    for(blockno = 1; blockno < super->s_nblocks; blockno++) {
  8005bf:	b9 01 00 00 00       	mov    $0x1,%ecx
      bit = 1<<(blockno%32);
      mask = ~bit;
      entry = blockno/32;

      if(bitmap[entry] & bit) {
  8005c4:	f6 c3 02             	test   $0x2,%bl
  8005c7:	74 74                	je     80063d <alloc_block+0xa5>
  8005c9:	eb 25                	jmp    8005f0 <alloc_block+0x58>

    unsigned blockno = 0;
    unsigned bit, mask, entry;

    for(blockno = 1; blockno < super->s_nblocks; blockno++) {
      bit = 1<<(blockno%32);
  8005cb:	89 c8                	mov    %ecx,%eax
  8005cd:	ba 01 00 00 00       	mov    $0x1,%edx
  8005d2:	d3 e2                	shl    %cl,%edx
      mask = ~bit;
  8005d4:	89 d3                	mov    %edx,%ebx
  8005d6:	f7 d3                	not    %ebx
  8005d8:	89 5d dc             	mov    %ebx,-0x24(%ebp)
      entry = blockno/32;
  8005db:	89 ce                	mov    %ecx,%esi
  8005dd:	c1 ee 05             	shr    $0x5,%esi

      if(bitmap[entry] & bit) {
  8005e0:	c1 e6 02             	shl    $0x2,%esi
  8005e3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005e6:	01 f7                	add    %esi,%edi
  8005e8:	8b 1f                	mov    (%edi),%ebx
  8005ea:	85 d3                	test   %edx,%ebx
  8005ec:	74 4f                	je     80063d <alloc_block+0xa5>
  8005ee:	eb 19                	jmp    800609 <alloc_block+0x71>
  8005f0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005f3:	be 00 00 00 00       	mov    $0x0,%esi
    unsigned blockno = 0;
    unsigned bit, mask, entry;

    for(blockno = 1; blockno < super->s_nblocks; blockno++) {
      bit = 1<<(blockno%32);
      mask = ~bit;
  8005f8:	c7 45 dc fd ff ff ff 	movl   $0xfffffffd,-0x24(%ebp)

    unsigned blockno = 0;
    unsigned bit, mask, entry;

    for(blockno = 1; blockno < super->s_nblocks; blockno++) {
      bit = 1<<(blockno%32);
  8005ff:	ba 02 00 00 00       	mov    $0x2,%edx
  800604:	b8 01 00 00 00       	mov    $0x1,%eax
      mask = ~bit;
      entry = blockno/32;

      if(bitmap[entry] & bit) {
        bitmap[entry] = bitmap[entry] & mask;
  800609:	23 5d dc             	and    -0x24(%ebp),%ebx
  80060c:	89 1f                	mov    %ebx,(%edi)
        assert(!(bitmap[entry] & bit));
  80060e:	8b 0d 04 90 80 00    	mov    0x809004,%ecx
  800614:	85 14 31             	test   %edx,(%ecx,%esi,1)
  800617:	74 38                	je     800651 <alloc_block+0xb9>
  800619:	c7 44 24 0c da 31 80 	movl   $0x8031da,0xc(%esp)
  800620:	00 
  800621:	c7 44 24 08 bd 30 80 	movl   $0x8030bd,0x8(%esp)
  800628:	00 
  800629:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  800630:	00 
  800631:	c7 04 24 8a 31 80 00 	movl   $0x80318a,(%esp)
  800638:	e8 cb 08 00 00       	call   800f08 <_panic>
	  // LAB 5: Your code here.

    unsigned blockno = 0;
    unsigned bit, mask, entry;

    for(blockno = 1; blockno < super->s_nblocks; blockno++) {
  80063d:	83 c1 01             	add    $0x1,%ecx
  800640:	3b 4d e4             	cmp    -0x1c(%ebp),%ecx
  800643:	75 86                	jne    8005cb <alloc_block+0x33>
        assert(!(bitmap[entry] & bit));
        return blockno;
      }
    }

    return -E_NO_DISK;
  800645:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80064a:	eb 05                	jmp    800651 <alloc_block+0xb9>
  80064c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
}
  800651:	83 c4 2c             	add    $0x2c,%esp
  800654:	5b                   	pop    %ebx
  800655:	5e                   	pop    %esi
  800656:	5f                   	pop    %edi
  800657:	5d                   	pop    %ebp
  800658:	c3                   	ret    

00800659 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
  80065c:	56                   	push   %esi
  80065d:	53                   	push   %ebx
  80065e:	83 ec 10             	sub    $0x10,%esp
    uint32_t i;

    // Make sure all bitmap blocks are marked in-use
    for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800661:	a1 08 90 80 00       	mov    0x809008,%eax
  800666:	8b 70 04             	mov    0x4(%eax),%esi
  800669:	85 f6                	test   %esi,%esi
  80066b:	74 44                	je     8006b1 <check_bitmap+0x58>
  80066d:	bb 00 00 00 00       	mov    $0x0,%ebx
        assert(!block_is_free(2+i));
  800672:	8d 43 02             	lea    0x2(%ebx),%eax
  800675:	89 04 24             	mov    %eax,(%esp)
  800678:	e8 a7 fe ff ff       	call   800524 <block_is_free>
  80067d:	84 c0                	test   %al,%al
  80067f:	74 24                	je     8006a5 <check_bitmap+0x4c>
  800681:	c7 44 24 0c f1 31 80 	movl   $0x8031f1,0xc(%esp)
  800688:	00 
  800689:	c7 44 24 08 bd 30 80 	movl   $0x8030bd,0x8(%esp)
  800690:	00 
  800691:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  800698:	00 
  800699:	c7 04 24 8a 31 80 00 	movl   $0x80318a,(%esp)
  8006a0:	e8 63 08 00 00       	call   800f08 <_panic>
check_bitmap(void)
{
    uint32_t i;

    // Make sure all bitmap blocks are marked in-use
    for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8006a5:	83 c3 01             	add    $0x1,%ebx
  8006a8:	89 d8                	mov    %ebx,%eax
  8006aa:	c1 e0 0f             	shl    $0xf,%eax
  8006ad:	39 f0                	cmp    %esi,%eax
  8006af:	72 c1                	jb     800672 <check_bitmap+0x19>
        assert(!block_is_free(2+i));

    // Make sure the reserved and root blocks are marked in-use.
    assert(!block_is_free(0));
  8006b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006b8:	e8 67 fe ff ff       	call   800524 <block_is_free>
  8006bd:	84 c0                	test   %al,%al
  8006bf:	74 24                	je     8006e5 <check_bitmap+0x8c>
  8006c1:	c7 44 24 0c 05 32 80 	movl   $0x803205,0xc(%esp)
  8006c8:	00 
  8006c9:	c7 44 24 08 bd 30 80 	movl   $0x8030bd,0x8(%esp)
  8006d0:	00 
  8006d1:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8006d8:	00 
  8006d9:	c7 04 24 8a 31 80 00 	movl   $0x80318a,(%esp)
  8006e0:	e8 23 08 00 00       	call   800f08 <_panic>
    assert(!block_is_free(1));
  8006e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006ec:	e8 33 fe ff ff       	call   800524 <block_is_free>
  8006f1:	84 c0                	test   %al,%al
  8006f3:	74 24                	je     800719 <check_bitmap+0xc0>
  8006f5:	c7 44 24 0c 17 32 80 	movl   $0x803217,0xc(%esp)
  8006fc:	00 
  8006fd:	c7 44 24 08 bd 30 80 	movl   $0x8030bd,0x8(%esp)
  800704:	00 
  800705:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  80070c:	00 
  80070d:	c7 04 24 8a 31 80 00 	movl   $0x80318a,(%esp)
  800714:	e8 ef 07 00 00       	call   800f08 <_panic>

    cprintf("bitmap is good\n");
  800719:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  800720:	e8 de 08 00 00       	call   801003 <cprintf>
}
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	5b                   	pop    %ebx
  800729:	5e                   	pop    %esi
  80072a:	5d                   	pop    %ebp
  80072b:	c3                   	ret    

0080072c <fs_init>:
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
  80072c:	55                   	push   %ebp
  80072d:	89 e5                	mov    %esp,%ebp
  80072f:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  800732:	e8 2b f9 ff ff       	call   800062 <ide_probe_disk1>
  800737:	84 c0                	test   %al,%al
  800739:	74 0e                	je     800749 <fs_init+0x1d>
		ide_set_disk(1);
  80073b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800742:	e8 8d f9 ff ff       	call   8000d4 <ide_set_disk>
  800747:	eb 0c                	jmp    800755 <fs_init+0x29>
	else
		ide_set_disk(0);
  800749:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800750:	e8 7f f9 ff ff       	call   8000d4 <ide_set_disk>

	bc_init();
  800755:	e8 16 fd ff ff       	call   800470 <bc_init>

	// Set "super" to point to the super block.
	super = diskaddr(1);
  80075a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800761:	e8 e6 fb ff ff       	call   80034c <diskaddr>
  800766:	a3 08 90 80 00       	mov    %eax,0x809008
	bitmap = diskaddr(2);
  80076b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800772:	e8 d5 fb ff ff       	call   80034c <diskaddr>
  800777:	a3 04 90 80 00       	mov    %eax,0x809004
	check_super();
  80077c:	e8 41 fd ff ff       	call   8004c2 <check_super>
	check_bitmap();
  800781:	e8 d3 fe ff ff       	call   800659 <check_bitmap>
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	56                   	push   %esi
  80078c:	53                   	push   %ebx
  80078d:	83 ec 10             	sub    $0x10,%esp
  800790:	8b 75 08             	mov    0x8(%ebp),%esi
  800793:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	uint32_t *ptr;
	char *blk;
	int v = 0;

	if (filebno < NDIRECT)
		ptr = &f->f_direct[filebno];
  800796:	8d 84 9e 88 00 00 00 	lea    0x88(%esi,%ebx,4),%eax
	int r;
	uint32_t *ptr;
	char *blk;
	int v = 0;

	if (filebno < NDIRECT)
  80079d:	83 fb 09             	cmp    $0x9,%ebx
  8007a0:	76 37                	jbe    8007d9 <file_get_block+0x51>
		if (v < 0 || !alloc) {
			return -E_NOT_FOUND;
		}
		ptr = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
	} else
		return -E_INVAL;
  8007a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	char *blk;
	int v = 0;

	if (filebno < NDIRECT)
		ptr = &f->f_direct[filebno];
	else if (filebno < NDIRECT + NINDIRECT) {
  8007a7:	81 fb 09 04 00 00    	cmp    $0x409,%ebx
  8007ad:	77 50                	ja     8007ff <file_get_block+0x77>
		if(alloc && f->f_indirect == 0){
  8007af:	83 be b0 00 00 00 00 	cmpl   $0x0,0xb0(%esi)
  8007b6:	75 0f                	jne    8007c7 <file_get_block+0x3f>
// Returns -E_NO_DISK if no block could be allocated 
//    or if there was a failure in alloc_block
static int
ensure_block(unsigned *var) {
    if(!*var || block_is_free(*var)) {
        int v = alloc_block();
  8007b8:	e8 db fd ff ff       	call   800598 <alloc_block>
        if(v < 0) {
  8007bd:	85 c0                	test   %eax,%eax
  8007bf:	78 25                	js     8007e6 <file_get_block+0x5e>
            return -E_NO_DISK;
        } else {
            *var = v;
  8007c1:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
                //FS_DEBUG("allocated the extended block for file %s\n", f->f_name);
        } 
		if (v < 0 || !alloc) {
			return -E_NOT_FOUND;
		}
		ptr = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
  8007c7:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  8007cd:	89 04 24             	mov    %eax,(%esp)
  8007d0:	e8 77 fb ff ff       	call   80034c <diskaddr>
  8007d5:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 1)) < 0)
		return r;
	if (*ptr == 0) {
  8007d9:	8b 10                	mov    (%eax),%edx
		return -E_NOT_FOUND;
  8007db:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 1)) < 0)
		return r;
	if (*ptr == 0) {
  8007e0:	85 d2                	test   %edx,%edx
  8007e2:	75 09                	jne    8007ed <file_get_block+0x65>
  8007e4:	eb 19                	jmp    8007ff <file_get_block+0x77>
		if(alloc && f->f_indirect == 0){
                v = ensure_block(&f->f_indirect);
                //FS_DEBUG("allocated the extended block for file %s\n", f->f_name);
        } 
		if (v < 0 || !alloc) {
			return -E_NOT_FOUND;
  8007e6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8007eb:	eb 12                	jmp    8007ff <file_get_block+0x77>
	if ((r = file_block_walk(f, filebno, &ptr, 1)) < 0)
		return r;
	if (*ptr == 0) {
		return -E_NOT_FOUND;
	}
	*blk = diskaddr(*ptr);
  8007ed:	89 14 24             	mov    %edx,(%esp)
  8007f0:	e8 57 fb ff ff       	call   80034c <diskaddr>
  8007f5:	8b 55 10             	mov    0x10(%ebp),%edx
  8007f8:	89 02                	mov    %eax,(%edx)
	return 0;
  8007fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	5b                   	pop    %ebx
  800803:	5e                   	pop    %esi
  800804:	5d                   	pop    %ebp
  800805:	c3                   	ret    

00800806 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	57                   	push   %edi
  80080a:	56                   	push   %esi
  80080b:	53                   	push   %ebx
  80080c:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	e8 96 fc ff ff       	call   8004b0 <skip_slash>
  80081a:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
	f = &super->s_root;
  800820:	a1 08 90 80 00       	mov    0x809008,%eax
  800825:	83 c0 08             	add    $0x8,%eax
  800828:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  80082e:	c6 85 64 ff ff ff 00 	movb   $0x0,-0x9c(%ebp)

	if (pdir)
		*pdir = 0;
	*pf = 0;
  800835:	8b 45 0c             	mov    0xc(%ebp),%eax
  800838:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80083e:	e9 4a 01 00 00       	jmp    80098d <file_open+0x187>
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800843:	83 c6 01             	add    $0x1,%esi
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800846:	0f b6 06             	movzbl (%esi),%eax
  800849:	3c 2f                	cmp    $0x2f,%al
  80084b:	74 04                	je     800851 <file_open+0x4b>
  80084d:	84 c0                	test   %al,%al
  80084f:	75 f2                	jne    800843 <file_open+0x3d>
			path++;
		if (path - p >= MAXNAMELEN)
  800851:	89 f3                	mov    %esi,%ebx
  800853:	2b 9d 50 ff ff ff    	sub    -0xb0(%ebp),%ebx
  800859:	83 fb 7f             	cmp    $0x7f,%ebx
  80085c:	0f 8f 59 01 00 00    	jg     8009bb <file_open+0x1b5>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800862:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800866:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  80086c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800870:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  800876:	89 14 24             	mov    %edx,(%esp)
  800879:	e8 8e 0f 00 00       	call   80180c <memmove>
		name[path - p] = '\0';
  80087e:	c6 84 1d 64 ff ff ff 	movb   $0x0,-0x9c(%ebp,%ebx,1)
  800885:	00 
		path = skip_slash(path);
  800886:	89 f0                	mov    %esi,%eax
  800888:	e8 23 fc ff ff       	call   8004b0 <skip_slash>
  80088d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)

		if (dir->f_type != FTYPE_DIR)
  800893:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800899:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  8008a0:	0f 85 1c 01 00 00    	jne    8009c2 <file_open+0x1bc>
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  8008a6:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  8008ac:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8008b1:	74 24                	je     8008d7 <file_open+0xd1>
  8008b3:	c7 44 24 0c 39 32 80 	movl   $0x803239,0xc(%esp)
  8008ba:	00 
  8008bb:	c7 44 24 08 bd 30 80 	movl   $0x8030bd,0x8(%esp)
  8008c2:	00 
  8008c3:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  8008ca:	00 
  8008cb:	c7 04 24 8a 31 80 00 	movl   $0x80318a,(%esp)
  8008d2:	e8 31 06 00 00       	call   800f08 <_panic>
	nblock = dir->f_size / BLKSIZE;
  8008d7:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	0f 48 c2             	cmovs  %edx,%eax
  8008e2:	c1 f8 0c             	sar    $0xc,%eax
  8008e5:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	for (i = 0; i < nblock; i++) {
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	74 78                	je     800967 <file_open+0x161>
  8008ef:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
  8008f6:	00 00 00 
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8008f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8008fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800900:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  800906:	89 54 24 04          	mov    %edx,0x4(%esp)
  80090a:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800910:	89 04 24             	mov    %eax,(%esp)
  800913:	e8 70 fe ff ff       	call   800788 <file_get_block>
  800918:	85 c0                	test   %eax,%eax
  80091a:	78 46                	js     800962 <file_open+0x15c>
			return r;
		f = (struct File*) blk;
  80091c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80091f:	bb 00 00 00 00       	mov    $0x0,%ebx


// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
  800924:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  800927:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  80092d:	89 54 24 04          	mov    %edx,0x4(%esp)
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800931:	89 34 24             	mov    %esi,(%esp)
  800934:	e8 a2 0d 00 00       	call   8016db <strcmp>
  800939:	85 c0                	test   %eax,%eax
  80093b:	74 4a                	je     800987 <file_open+0x181>
  80093d:	81 c3 00 01 00 00    	add    $0x100,%ebx
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  800943:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800949:	75 d9                	jne    800924 <file_open+0x11e>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  80094b:	83 85 54 ff ff ff 01 	addl   $0x1,-0xac(%ebp)
  800952:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800958:	39 85 48 ff ff ff    	cmp    %eax,-0xb8(%ebp)
  80095e:	75 99                	jne    8008f9 <file_open+0xf3>
  800960:	eb 05                	jmp    800967 <file_open+0x161>

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800962:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800965:	75 60                	jne    8009c7 <file_open+0x1c1>
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800967:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  80096c:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800972:	80 3a 00             	cmpb   $0x0,(%edx)
  800975:	75 50                	jne    8009c7 <file_open+0x1c1>
				if (pdir)
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			}
			return r;
  800980:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800985:	eb 40                	jmp    8009c7 <file_open+0x1c1>
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800987:	89 b5 4c ff ff ff    	mov    %esi,-0xb4(%ebp)
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  80098d:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800993:	0f b6 02             	movzbl (%edx),%eax
  800996:	84 c0                	test   %al,%al
  800998:	74 0f                	je     8009a9 <file_open+0x1a3>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  80099a:	89 d6                	mov    %edx,%esi
  80099c:	3c 2f                	cmp    $0x2f,%al
  80099e:	0f 85 9f fe ff ff    	jne    800843 <file_open+0x3d>
  8009a4:	e9 a8 fe ff ff       	jmp    800851 <file_open+0x4b>
		}
	}

	if (pdir)
		*pdir = dir;
	*pf = f;
  8009a9:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  8009af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b2:	89 10                	mov    %edx,(%eax)
	return 0;
  8009b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b9:	eb 0c                	jmp    8009c7 <file_open+0x1c1>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
		if (path - p >= MAXNAMELEN)
			return -E_BAD_PATH;
  8009bb:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8009c0:	eb 05                	jmp    8009c7 <file_open+0x1c1>
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;
  8009c2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
	return walk_path(path, 0, pf, 0);
}
  8009c7:	81 c4 bc 00 00 00    	add    $0xbc,%esp
  8009cd:	5b                   	pop    %ebx
  8009ce:	5e                   	pop    %esi
  8009cf:	5f                   	pop    %edi
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	57                   	push   %edi
  8009d6:	56                   	push   %esi
  8009d7:	53                   	push   %ebx
  8009d8:	83 ec 3c             	sub    $0x3c,%esp
  8009db:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8009de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  8009ed:	b8 00 00 00 00       	mov    $0x0,%eax
{
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8009f2:	39 da                	cmp    %ebx,%edx
  8009f4:	0f 8e 83 00 00 00    	jle    800a7d <file_read+0xab>
		return 0;

	count = MIN(count, f->f_size - offset);
  8009fa:	29 da                	sub    %ebx,%edx
  8009fc:	39 ca                	cmp    %ecx,%edx
  8009fe:	0f 46 ca             	cmovbe %edx,%ecx
  800a01:	89 4d d0             	mov    %ecx,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800a04:	89 de                	mov    %ebx,%esi
  800a06:	01 d9                	add    %ebx,%ecx
  800a08:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a0b:	39 cb                	cmp    %ecx,%ebx
  800a0d:	73 6b                	jae    800a7a <file_read+0xa8>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800a0f:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800a12:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a16:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800a1c:	85 db                	test   %ebx,%ebx
  800a1e:	0f 49 c3             	cmovns %ebx,%eax
  800a21:	c1 f8 0c             	sar    $0xc,%eax
  800a24:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	89 04 24             	mov    %eax,(%esp)
  800a2e:	e8 55 fd ff ff       	call   800788 <file_get_block>
  800a33:	85 c0                	test   %eax,%eax
  800a35:	78 46                	js     800a7d <file_read+0xab>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800a37:	89 da                	mov    %ebx,%edx
  800a39:	c1 fa 1f             	sar    $0x1f,%edx
  800a3c:	c1 ea 14             	shr    $0x14,%edx
  800a3f:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800a42:	25 ff 0f 00 00       	and    $0xfff,%eax
  800a47:	29 d0                	sub    %edx,%eax
  800a49:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a4e:	29 c2                	sub    %eax,%edx
  800a50:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800a53:	29 f1                	sub    %esi,%ecx
  800a55:	89 ce                	mov    %ecx,%esi
  800a57:	39 ca                	cmp    %ecx,%edx
  800a59:	0f 46 f2             	cmovbe %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800a5c:	89 74 24 08          	mov    %esi,0x8(%esp)
  800a60:	03 45 e4             	add    -0x1c(%ebp),%eax
  800a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a67:	89 3c 24             	mov    %edi,(%esp)
  800a6a:	e8 9d 0d 00 00       	call   80180c <memmove>
		pos += bn;
  800a6f:	01 f3                	add    %esi,%ebx
		buf += bn;
  800a71:	01 f7                	add    %esi,%edi
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  800a73:	89 de                	mov    %ebx,%esi
  800a75:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
  800a78:	72 95                	jb     800a0f <file_read+0x3d>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  800a7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800a7d:	83 c4 3c             	add    $0x3c,%esp
  800a80:	5b                   	pop    %ebx
  800a81:	5e                   	pop    %esi
  800a82:	5f                   	pop    %edi
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    
	...

00800a90 <serve_flush>:


// Our read-only file system do nothing for flush
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
	return 0;
}
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  800a9d:	ba 40 40 80 00       	mov    $0x804040,%edx

void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
  800aa2:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  800aa7:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  800aac:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  800aae:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  800ab1:	81 c1 00 10 00 00    	add    $0x1000,%ecx
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  800ab7:	83 c0 01             	add    $0x1,%eax
  800aba:	83 c2 10             	add    $0x10,%edx
  800abd:	3d 00 04 00 00       	cmp    $0x400,%eax
  800ac2:	75 e8                	jne    800aac <serve_init+0x12>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	56                   	push   %esi
  800aca:	53                   	push   %ebx
  800acb:	83 ec 10             	sub    $0x10,%esp
  800ace:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  800ad1:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
}

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
  800ad6:	89 d8                	mov    %ebx,%eax
  800ad8:	c1 e0 04             	shl    $0x4,%eax
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
		switch (pageref(opentab[i].o_fd)) {
  800adb:	8b 80 4c 40 80 00    	mov    0x80404c(%eax),%eax
  800ae1:	89 04 24             	mov    %eax,(%esp)
  800ae4:	e8 0b 1d 00 00       	call   8027f4 <pageref>
  800ae9:	85 c0                	test   %eax,%eax
  800aeb:	74 07                	je     800af4 <openfile_alloc+0x2e>
  800aed:	83 f8 01             	cmp    $0x1,%eax
  800af0:	75 62                	jne    800b54 <openfile_alloc+0x8e>
  800af2:	eb 27                	jmp    800b1b <openfile_alloc+0x55>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  800af4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800afb:	00 
  800afc:	89 d8                	mov    %ebx,%eax
  800afe:	c1 e0 04             	shl    $0x4,%eax
  800b01:	8b 80 4c 40 80 00    	mov    0x80404c(%eax),%eax
  800b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b12:	e8 05 10 00 00       	call   801b1c <sys_page_alloc>
  800b17:	85 c0                	test   %eax,%eax
  800b19:	78 4d                	js     800b68 <openfile_alloc+0xa2>
				return r;
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  800b1b:	c1 e3 04             	shl    $0x4,%ebx
  800b1e:	8d 83 40 40 80 00    	lea    0x804040(%ebx),%eax
  800b24:	81 83 40 40 80 00 00 	addl   $0x400,0x804040(%ebx)
  800b2b:	04 00 00 
			*o = &opentab[i];
  800b2e:	89 06                	mov    %eax,(%esi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  800b30:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800b37:	00 
  800b38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800b3f:	00 
  800b40:	8b 83 4c 40 80 00    	mov    0x80404c(%ebx),%eax
  800b46:	89 04 24             	mov    %eax,(%esp)
  800b49:	e8 63 0c 00 00       	call   8017b1 <memset>
			return (*o)->o_fileid;
  800b4e:	8b 06                	mov    (%esi),%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	eb 14                	jmp    800b68 <openfile_alloc+0xa2>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  800b54:	83 c3 01             	add    $0x1,%ebx
  800b57:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  800b5d:	0f 85 73 ff ff ff    	jne    800ad6 <openfile_alloc+0x10>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  800b63:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800b68:	83 c4 10             	add    $0x10,%esp
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	83 ec 28             	sub    $0x28,%esp
  800b75:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b78:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b7b:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800b7e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  800b81:	89 fe                	mov    %edi,%esi
  800b83:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800b89:	c1 e6 04             	shl    $0x4,%esi
  800b8c:	8d 9e 40 40 80 00    	lea    0x804040(%esi),%ebx
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  800b92:	8b 86 4c 40 80 00    	mov    0x80404c(%esi),%eax
  800b98:	89 04 24             	mov    %eax,(%esp)
  800b9b:	e8 54 1c 00 00       	call   8027f4 <pageref>
  800ba0:	83 f8 01             	cmp    $0x1,%eax
  800ba3:	74 19                	je     800bbe <openfile_lookup+0x4f>
		return -E_INVAL;
  800ba5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  800baa:	39 be 40 40 80 00    	cmp    %edi,0x804040(%esi)
  800bb0:	75 11                	jne    800bc3 <openfile_lookup+0x54>
		return -E_INVAL;
	*po = o;
  800bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb5:	89 18                	mov    %ebx,(%eax)
	return 0;
  800bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbc:	eb 05                	jmp    800bc3 <openfile_lookup+0x54>
{
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
		return -E_INVAL;
  800bbe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	*po = o;
	return 0;
}
  800bc3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800bc6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bc9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bcc:	89 ec                	mov    %ebp,%esp
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    

00800bd0 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	53                   	push   %ebx
  800bd4:	83 ec 24             	sub    $0x24,%esp
  800bd7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  800bda:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bdd:	89 44 24 08          	mov    %eax,0x8(%esp)
  800be1:	8b 03                	mov    (%ebx),%eax
  800be3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	89 04 24             	mov    %eax,(%esp)
  800bed:	e8 7d ff ff ff       	call   800b6f <openfile_lookup>
  800bf2:	85 c0                	test   %eax,%eax
  800bf4:	78 3f                	js     800c35 <serve_stat+0x65>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  800bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf9:	8b 40 04             	mov    0x4(%eax),%eax
  800bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c00:	89 1c 24             	mov    %ebx,(%esp)
  800c03:	e8 13 0a 00 00       	call   80161b <strcpy>
	ret->ret_size = o->o_file->f_size;
  800c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c0b:	8b 50 04             	mov    0x4(%eax),%edx
  800c0e:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  800c14:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  800c1a:	8b 40 04             	mov    0x4(%eax),%eax
  800c1d:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800c24:	0f 94 c0             	sete   %al
  800c27:	0f b6 c0             	movzbl %al,%eax
  800c2a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800c30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c35:	83 c4 24             	add    $0x24,%esp
  800c38:	5b                   	pop    %ebx
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	53                   	push   %ebx
  800c3f:	83 ec 24             	sub    $0x24,%esp
  800c42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// so filling in ret will overwrite req.
	//
	struct OpenFile *o;
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  800c45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c48:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c4c:	8b 03                	mov    (%ebx),%eax
  800c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	89 04 24             	mov    %eax,(%esp)
  800c58:	e8 12 ff ff ff       	call   800b6f <openfile_lookup>
  800c5d:	85 c0                	test   %eax,%eax
  800c5f:	78 3d                	js     800c9e <serve_read+0x63>
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
  800c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c64:	8b 50 0c             	mov    0xc(%eax),%edx
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  800c67:	8b 52 04             	mov    0x4(%edx),%edx
  800c6a:	89 54 24 0c          	mov    %edx,0xc(%esp)
			   MIN(req->req_n, sizeof ret->ret_buf),
  800c6e:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  800c75:	ba 00 10 00 00       	mov    $0x1000,%edx
  800c7a:	0f 46 53 04          	cmovbe 0x4(%ebx),%edx
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  800c7e:	89 54 24 08          	mov    %edx,0x8(%esp)
  800c82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c86:	8b 40 04             	mov    0x4(%eax),%eax
  800c89:	89 04 24             	mov    %eax,(%esp)
  800c8c:	e8 41 fd ff ff       	call   8009d2 <file_read>
  800c91:	85 c0                	test   %eax,%eax
  800c93:	78 09                	js     800c9e <serve_read+0x63>
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
		return r;

	o->o_fd->fd_offset += r;
  800c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c98:	8b 52 0c             	mov    0xc(%edx),%edx
  800c9b:	01 42 04             	add    %eax,0x4(%edx)
	return r;
}
  800c9e:	83 c4 24             	add    $0x24,%esp
  800ca1:	5b                   	pop    %ebx
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	53                   	push   %ebx
  800ca8:	81 ec 24 04 00 00    	sub    $0x424,%esp
  800cae:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  800cb1:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  800cb8:	00 
  800cb9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800cbd:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800cc3:	89 04 24             	mov    %eax,(%esp)
  800cc6:	e8 41 0b 00 00       	call   80180c <memmove>
	path[MAXPATHLEN-1] = 0;
  800ccb:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  800ccf:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800cd5:	89 04 24             	mov    %eax,(%esp)
  800cd8:	e8 e9 fd ff ff       	call   800ac6 <openfile_alloc>
  800cdd:	85 c0                	test   %eax,%eax
  800cdf:	0f 88 80 00 00 00    	js     800d65 <serve_open+0xc1>
	fileid = r;

	if (req->req_omode != 0) {
		if (debug)
			cprintf("file_open omode 0x%x unsupported", req->req_omode);
		return -E_INVAL;
  800ce5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			cprintf("openfile_alloc failed: %e", r);
		return r;
	}
	fileid = r;

	if (req->req_omode != 0) {
  800cea:	83 bb 00 04 00 00 00 	cmpl   $0x0,0x400(%ebx)
  800cf1:	75 72                	jne    800d65 <serve_open+0xc1>
		if (debug)
			cprintf("file_open omode 0x%x unsupported", req->req_omode);
		return -E_INVAL;
	}

	if ((r = file_open(path, &f)) < 0) {
  800cf3:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  800cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cfd:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800d03:	89 04 24             	mov    %eax,(%esp)
  800d06:	e8 fb fa ff ff       	call   800806 <file_open>
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	78 56                	js     800d65 <serve_open+0xc1>
			cprintf("file_open failed: %e", r);
		return r;
	}

	// Save the file pointer
	o->o_file = f;
  800d0f:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  800d15:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  800d1b:	89 50 04             	mov    %edx,0x4(%eax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  800d1e:	8b 50 0c             	mov    0xc(%eax),%edx
  800d21:	8b 08                	mov    (%eax),%ecx
  800d23:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  800d26:	8b 50 0c             	mov    0xc(%eax),%edx
  800d29:	8b 8b 00 04 00 00    	mov    0x400(%ebx),%ecx
  800d2f:	83 e1 03             	and    $0x3,%ecx
  800d32:	89 4a 08             	mov    %ecx,0x8(%edx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  800d35:	8b 40 0c             	mov    0xc(%eax),%eax
  800d38:	8b 15 44 80 80 00    	mov    0x808044,%edx
  800d3e:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  800d40:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  800d46:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  800d4c:	89 50 08             	mov    %edx,0x8(%eax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  800d4f:	8b 50 0c             	mov    0xc(%eax),%edx
  800d52:	8b 45 10             	mov    0x10(%ebp),%eax
  800d55:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  800d57:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5a:	c7 00 07 04 00 00    	movl   $0x407,(%eax)

	return 0;
  800d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d65:	81 c4 24 04 00 00    	add    $0x424,%esp
  800d6b:	5b                   	pop    %ebx
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    

00800d6e <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 20             	sub    $0x20,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800d76:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800d79:	8d 75 f4             	lea    -0xc(%ebp),%esi
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  800d7c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800d83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d87:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d90:	89 34 24             	mov    %esi,(%esp)
  800d93:	e8 e8 10 00 00       	call   801e80 <ipc_recv>
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  800d98:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  800d9c:	75 15                	jne    800db3 <serve+0x45>
			cprintf("Invalid request from %08x: no argument page\n",
  800d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800da5:	c7 04 24 58 32 80 00 	movl   $0x803258,(%esp)
  800dac:	e8 52 02 00 00       	call   801003 <cprintf>
				whom);
			continue; // just leave it hanging...
  800db1:	eb c9                	jmp    800d7c <serve+0xe>
		}

		pg = NULL;
  800db3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  800dba:	83 f8 01             	cmp    $0x1,%eax
  800dbd:	75 21                	jne    800de0 <serve+0x72>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  800dbf:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800dc3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dca:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800dcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd6:	89 04 24             	mov    %eax,(%esp)
  800dd9:	e8 c6 fe ff ff       	call   800ca4 <serve_open>
  800dde:	eb 3f                	jmp    800e1f <serve+0xb1>
		} else if (req < NHANDLERS && handlers[req]) {
  800de0:	83 f8 06             	cmp    $0x6,%eax
  800de3:	77 1e                	ja     800e03 <serve+0x95>
  800de5:	8b 14 85 20 40 80 00 	mov    0x804020(,%eax,4),%edx
  800dec:	85 d2                	test   %edx,%edx
  800dee:	74 13                	je     800e03 <serve+0x95>
			r = handlers[req](whom, fsreq);
  800df0:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800df5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dfc:	89 04 24             	mov    %eax,(%esp)
  800dff:	ff d2                	call   *%edx
  800e01:	eb 1c                	jmp    800e1f <serve+0xb1>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  800e03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e06:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e0e:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  800e15:	e8 e9 01 00 00       	call   801003 <cprintf>
			r = -E_INVAL;
  800e1a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  800e1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e22:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e29:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e34:	89 04 24             	mov    %eax,(%esp)
  800e37:	e8 96 10 00 00       	call   801ed2 <ipc_send>
		sys_page_unmap(0, fsreq);
  800e3c:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800e41:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e4c:	e8 88 0d 00 00       	call   801bd9 <sys_page_unmap>
  800e51:	e9 26 ff ff ff       	jmp    800d7c <serve+0xe>

00800e56 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  800e5c:	c7 05 40 80 80 00 ab 	movl   $0x8032ab,0x808040
  800e63:	32 80 00 
	cprintf("FS is running\n");
  800e66:	c7 04 24 ae 32 80 00 	movl   $0x8032ae,(%esp)
  800e6d:	e8 91 01 00 00       	call   801003 <cprintf>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  800e72:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  800e77:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  800e7c:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  800e7e:	c7 04 24 bd 32 80 00 	movl   $0x8032bd,(%esp)
  800e85:	e8 79 01 00 00       	call   801003 <cprintf>

	serve_init();
  800e8a:	e8 0b fc ff ff       	call   800a9a <serve_init>
	fs_init();
  800e8f:	e8 98 f8 ff ff       	call   80072c <fs_init>
	serve();
  800e94:	e8 d5 fe ff ff       	call   800d6e <serve>
  800e99:	00 00                	add    %al,(%eax)
	...

00800e9c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 18             	sub    $0x18,%esp
  800ea2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800ea5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800ea8:	8b 75 08             	mov    0x8(%ebp),%esi
  800eab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800eae:	e8 09 0c 00 00       	call   801abc <sys_getenvid>
  800eb3:	25 ff 03 00 00       	and    $0x3ff,%eax
  800eb8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ebb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ec0:	a3 0c 90 80 00       	mov    %eax,0x80900c
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800ec5:	85 f6                	test   %esi,%esi
  800ec7:	7e 07                	jle    800ed0 <libmain+0x34>
		binaryname = argv[0];
  800ec9:	8b 03                	mov    (%ebx),%eax
  800ecb:	a3 40 80 80 00       	mov    %eax,0x808040

	// call user main routine
	umain(argc, argv);
  800ed0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ed4:	89 34 24             	mov    %esi,(%esp)
  800ed7:	e8 7a ff ff ff       	call   800e56 <umain>

	// exit gracefully
	exit();
  800edc:	e8 0b 00 00 00       	call   800eec <exit>
}
  800ee1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800ee4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800ee7:	89 ec                	mov    %ebp,%esp
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    
	...

00800eec <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800ef2:	e8 c7 12 00 00       	call   8021be <close_all>
	sys_env_destroy(0);
  800ef7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800efe:	e8 5c 0b 00 00       	call   801a5f <sys_env_destroy>
}
  800f03:	c9                   	leave  
  800f04:	c3                   	ret    
  800f05:	00 00                	add    %al,(%eax)
	...

00800f08 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800f10:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f13:	8b 1d 40 80 80 00    	mov    0x808040,%ebx
  800f19:	e8 9e 0b 00 00       	call   801abc <sys_getenvid>
  800f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f21:	89 54 24 10          	mov    %edx,0x10(%esp)
  800f25:	8b 55 08             	mov    0x8(%ebp),%edx
  800f28:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f2c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800f30:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f34:	c7 04 24 d8 32 80 00 	movl   $0x8032d8,(%esp)
  800f3b:	e8 c3 00 00 00       	call   801003 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f40:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f44:	8b 45 10             	mov    0x10(%ebp),%eax
  800f47:	89 04 24             	mov    %eax,(%esp)
  800f4a:	e8 53 00 00 00       	call   800fa2 <vcprintf>
	cprintf("\n");
  800f4f:	c7 04 24 ca 32 80 00 	movl   $0x8032ca,(%esp)
  800f56:	e8 a8 00 00 00       	call   801003 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f5b:	cc                   	int3   
  800f5c:	eb fd                	jmp    800f5b <_panic+0x53>
	...

00800f60 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	53                   	push   %ebx
  800f64:	83 ec 14             	sub    $0x14,%esp
  800f67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800f6a:	8b 03                	mov    (%ebx),%eax
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800f73:	83 c0 01             	add    $0x1,%eax
  800f76:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800f78:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f7d:	75 19                	jne    800f98 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800f7f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800f86:	00 
  800f87:	8d 43 08             	lea    0x8(%ebx),%eax
  800f8a:	89 04 24             	mov    %eax,(%esp)
  800f8d:	e8 6e 0a 00 00       	call   801a00 <sys_cputs>
		b->idx = 0;
  800f92:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800f98:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800f9c:	83 c4 14             	add    $0x14,%esp
  800f9f:	5b                   	pop    %ebx
  800fa0:	5d                   	pop    %ebp
  800fa1:	c3                   	ret    

00800fa2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800fab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800fb2:	00 00 00 
	b.cnt = 0;
  800fb5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800fbc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fcd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fd7:	c7 04 24 60 0f 80 00 	movl   $0x800f60,(%esp)
  800fde:	e8 97 01 00 00       	call   80117a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800fe3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fed:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800ff3:	89 04 24             	mov    %eax,(%esp)
  800ff6:	e8 05 0a 00 00       	call   801a00 <sys_cputs>

	return b.cnt;
}
  800ffb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801001:	c9                   	leave  
  801002:	c3                   	ret    

00801003 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801009:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80100c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	89 04 24             	mov    %eax,(%esp)
  801016:	e8 87 ff ff ff       	call   800fa2 <vcprintf>
	va_end(ap);

	return cnt;
}
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    
  80101d:	00 00                	add    %al,(%eax)
	...

00801020 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
  801026:	83 ec 3c             	sub    $0x3c,%esp
  801029:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80102c:	89 d7                	mov    %edx,%edi
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80103a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80103d:	8b 75 18             	mov    0x18(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801040:	b8 00 00 00 00       	mov    $0x0,%eax
  801045:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801048:	72 11                	jb     80105b <printnum+0x3b>
  80104a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80104d:	39 45 10             	cmp    %eax,0x10(%ebp)
  801050:	76 09                	jbe    80105b <printnum+0x3b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801052:	83 eb 01             	sub    $0x1,%ebx
  801055:	85 db                	test   %ebx,%ebx
  801057:	7f 51                	jg     8010aa <printnum+0x8a>
  801059:	eb 5e                	jmp    8010b9 <printnum+0x99>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80105b:	89 74 24 10          	mov    %esi,0x10(%esp)
  80105f:	83 eb 01             	sub    $0x1,%ebx
  801062:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801066:	8b 45 10             	mov    0x10(%ebp),%eax
  801069:	89 44 24 08          	mov    %eax,0x8(%esp)
  80106d:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  801071:	8b 74 24 0c          	mov    0xc(%esp),%esi
  801075:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80107c:	00 
  80107d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801080:	89 04 24             	mov    %eax,(%esp)
  801083:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801086:	89 44 24 04          	mov    %eax,0x4(%esp)
  80108a:	e8 31 1d 00 00       	call   802dc0 <__udivdi3>
  80108f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801093:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801097:	89 04 24             	mov    %eax,(%esp)
  80109a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80109e:	89 fa                	mov    %edi,%edx
  8010a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010a3:	e8 78 ff ff ff       	call   801020 <printnum>
  8010a8:	eb 0f                	jmp    8010b9 <printnum+0x99>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8010aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010ae:	89 34 24             	mov    %esi,(%esp)
  8010b1:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010b4:	83 eb 01             	sub    $0x1,%ebx
  8010b7:	75 f1                	jne    8010aa <printnum+0x8a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010b9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010bd:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8010c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8010cf:	00 
  8010d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8010d3:	89 04 24             	mov    %eax,(%esp)
  8010d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010dd:	e8 0e 1e 00 00       	call   802ef0 <__umoddi3>
  8010e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010e6:	0f be 80 fb 32 80 00 	movsbl 0x8032fb(%eax),%eax
  8010ed:	89 04 24             	mov    %eax,(%esp)
  8010f0:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8010f3:	83 c4 3c             	add    $0x3c,%esp
  8010f6:	5b                   	pop    %ebx
  8010f7:	5e                   	pop    %esi
  8010f8:	5f                   	pop    %edi
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    

008010fb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010fe:	83 fa 01             	cmp    $0x1,%edx
  801101:	7e 0e                	jle    801111 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801103:	8b 10                	mov    (%eax),%edx
  801105:	8d 4a 08             	lea    0x8(%edx),%ecx
  801108:	89 08                	mov    %ecx,(%eax)
  80110a:	8b 02                	mov    (%edx),%eax
  80110c:	8b 52 04             	mov    0x4(%edx),%edx
  80110f:	eb 22                	jmp    801133 <getuint+0x38>
	else if (lflag)
  801111:	85 d2                	test   %edx,%edx
  801113:	74 10                	je     801125 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801115:	8b 10                	mov    (%eax),%edx
  801117:	8d 4a 04             	lea    0x4(%edx),%ecx
  80111a:	89 08                	mov    %ecx,(%eax)
  80111c:	8b 02                	mov    (%edx),%eax
  80111e:	ba 00 00 00 00       	mov    $0x0,%edx
  801123:	eb 0e                	jmp    801133 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801125:	8b 10                	mov    (%eax),%edx
  801127:	8d 4a 04             	lea    0x4(%edx),%ecx
  80112a:	89 08                	mov    %ecx,(%eax)
  80112c:	8b 02                	mov    (%edx),%eax
  80112e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80113b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80113f:	8b 10                	mov    (%eax),%edx
  801141:	3b 50 04             	cmp    0x4(%eax),%edx
  801144:	73 0a                	jae    801150 <sprintputch+0x1b>
		*b->buf++ = ch;
  801146:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801149:	88 0a                	mov    %cl,(%edx)
  80114b:	83 c2 01             	add    $0x1,%edx
  80114e:	89 10                	mov    %edx,(%eax)
}
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    

00801152 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801158:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80115b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	89 44 24 08          	mov    %eax,0x8(%esp)
  801166:	8b 45 0c             	mov    0xc(%ebp),%eax
  801169:	89 44 24 04          	mov    %eax,0x4(%esp)
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	89 04 24             	mov    %eax,(%esp)
  801173:	e8 02 00 00 00       	call   80117a <vprintfmt>
	va_end(ap);
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	57                   	push   %edi
  80117e:	56                   	push   %esi
  80117f:	53                   	push   %ebx
  801180:	83 ec 4c             	sub    $0x4c,%esp
  801183:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801186:	8b 75 10             	mov    0x10(%ebp),%esi
  801189:	eb 12                	jmp    80119d <vprintfmt+0x23>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80118b:	85 c0                	test   %eax,%eax
  80118d:	0f 84 a9 03 00 00    	je     80153c <vprintfmt+0x3c2>
				return;
			putch(ch, putdat);
  801193:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801197:	89 04 24             	mov    %eax,(%esp)
  80119a:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80119d:	0f b6 06             	movzbl (%esi),%eax
  8011a0:	83 c6 01             	add    $0x1,%esi
  8011a3:	83 f8 25             	cmp    $0x25,%eax
  8011a6:	75 e3                	jne    80118b <vprintfmt+0x11>
  8011a8:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8011ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8011b3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  8011b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8011bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011c4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8011c7:	eb 2b                	jmp    8011f4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8011c9:	8b 75 e0             	mov    -0x20(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8011cc:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8011d0:	eb 22                	jmp    8011f4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8011d2:	8b 75 e0             	mov    -0x20(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011d5:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8011d9:	eb 19                	jmp    8011f4 <vprintfmt+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8011db:	8b 75 e0             	mov    -0x20(%ebp),%esi
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8011de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011e5:	eb 0d                	jmp    8011f4 <vprintfmt+0x7a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8011e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011ed:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8011f4:	0f b6 06             	movzbl (%esi),%eax
  8011f7:	0f b6 d0             	movzbl %al,%edx
  8011fa:	8d 7e 01             	lea    0x1(%esi),%edi
  8011fd:	89 7d e0             	mov    %edi,-0x20(%ebp)
  801200:	83 e8 23             	sub    $0x23,%eax
  801203:	3c 55                	cmp    $0x55,%al
  801205:	0f 87 0b 03 00 00    	ja     801516 <vprintfmt+0x39c>
  80120b:	0f b6 c0             	movzbl %al,%eax
  80120e:	ff 24 85 40 34 80 00 	jmp    *0x803440(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801215:	83 ea 30             	sub    $0x30,%edx
  801218:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				ch = *fmt;
  80121b:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80121f:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801222:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  801225:	83 fa 09             	cmp    $0x9,%edx
  801228:	77 4a                	ja     801274 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80122a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80122d:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  801230:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  801233:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
				ch = *fmt;
  801237:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80123a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80123d:	83 fa 09             	cmp    $0x9,%edx
  801240:	76 eb                	jbe    80122d <vprintfmt+0xb3>
  801242:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801245:	eb 2d                	jmp    801274 <vprintfmt+0xfa>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8d 50 04             	lea    0x4(%eax),%edx
  80124d:	89 55 14             	mov    %edx,0x14(%ebp)
  801250:	8b 00                	mov    (%eax),%eax
  801252:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801255:	8b 75 e0             	mov    -0x20(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801258:	eb 1a                	jmp    801274 <vprintfmt+0xfa>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80125a:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case '*':
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
  80125d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801261:	79 91                	jns    8011f4 <vprintfmt+0x7a>
  801263:	e9 73 ff ff ff       	jmp    8011db <vprintfmt+0x61>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801268:	8b 75 e0             	mov    -0x20(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80126b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801272:	eb 80                	jmp    8011f4 <vprintfmt+0x7a>

		process_precision:
			if (width < 0)
  801274:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801278:	0f 89 76 ff ff ff    	jns    8011f4 <vprintfmt+0x7a>
  80127e:	e9 64 ff ff ff       	jmp    8011e7 <vprintfmt+0x6d>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801283:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801286:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801289:	e9 66 ff ff ff       	jmp    8011f4 <vprintfmt+0x7a>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80128e:	8b 45 14             	mov    0x14(%ebp),%eax
  801291:	8d 50 04             	lea    0x4(%eax),%edx
  801294:	89 55 14             	mov    %edx,0x14(%ebp)
  801297:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80129b:	8b 00                	mov    (%eax),%eax
  80129d:	89 04 24             	mov    %eax,(%esp)
  8012a0:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012a3:	8b 75 e0             	mov    -0x20(%ebp),%esi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8012a6:	e9 f2 fe ff ff       	jmp    80119d <vprintfmt+0x23>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ae:	8d 50 04             	lea    0x4(%eax),%edx
  8012b1:	89 55 14             	mov    %edx,0x14(%ebp)
  8012b4:	8b 00                	mov    (%eax),%eax
  8012b6:	89 c2                	mov    %eax,%edx
  8012b8:	c1 fa 1f             	sar    $0x1f,%edx
  8012bb:	31 d0                	xor    %edx,%eax
  8012bd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012bf:	83 f8 0f             	cmp    $0xf,%eax
  8012c2:	7f 0b                	jg     8012cf <vprintfmt+0x155>
  8012c4:	8b 14 85 a0 35 80 00 	mov    0x8035a0(,%eax,4),%edx
  8012cb:	85 d2                	test   %edx,%edx
  8012cd:	75 23                	jne    8012f2 <vprintfmt+0x178>
				printfmt(putch, putdat, "error %d", err);
  8012cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012d3:	c7 44 24 08 13 33 80 	movl   $0x803313,0x8(%esp)
  8012da:	00 
  8012db:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012e2:	89 3c 24             	mov    %edi,(%esp)
  8012e5:	e8 68 fe ff ff       	call   801152 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012ea:	8b 75 e0             	mov    -0x20(%ebp),%esi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8012ed:	e9 ab fe ff ff       	jmp    80119d <vprintfmt+0x23>
			else
				printfmt(putch, putdat, "%s", p);
  8012f2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012f6:	c7 44 24 08 cf 30 80 	movl   $0x8030cf,0x8(%esp)
  8012fd:	00 
  8012fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801302:	8b 7d 08             	mov    0x8(%ebp),%edi
  801305:	89 3c 24             	mov    %edi,(%esp)
  801308:	e8 45 fe ff ff       	call   801152 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80130d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  801310:	e9 88 fe ff ff       	jmp    80119d <vprintfmt+0x23>
  801315:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80131b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80131e:	8b 45 14             	mov    0x14(%ebp),%eax
  801321:	8d 50 04             	lea    0x4(%eax),%edx
  801324:	89 55 14             	mov    %edx,0x14(%ebp)
  801327:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801329:	85 f6                	test   %esi,%esi
  80132b:	ba 0c 33 80 00       	mov    $0x80330c,%edx
  801330:	0f 44 f2             	cmove  %edx,%esi
			if (width > 0 && padc != '-')
  801333:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801337:	7e 06                	jle    80133f <vprintfmt+0x1c5>
  801339:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80133d:	75 10                	jne    80134f <vprintfmt+0x1d5>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80133f:	0f be 06             	movsbl (%esi),%eax
  801342:	83 c6 01             	add    $0x1,%esi
  801345:	85 c0                	test   %eax,%eax
  801347:	0f 85 86 00 00 00    	jne    8013d3 <vprintfmt+0x259>
  80134d:	eb 76                	jmp    8013c5 <vprintfmt+0x24b>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80134f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801353:	89 34 24             	mov    %esi,(%esp)
  801356:	e8 90 02 00 00       	call   8015eb <strnlen>
  80135b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80135e:	29 c2                	sub    %eax,%edx
  801360:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801363:	85 d2                	test   %edx,%edx
  801365:	7e d8                	jle    80133f <vprintfmt+0x1c5>
					putch(padc, putdat);
  801367:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  80136b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80136e:	89 d6                	mov    %edx,%esi
  801370:	89 7d d0             	mov    %edi,-0x30(%ebp)
  801373:	89 c7                	mov    %eax,%edi
  801375:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801379:	89 3c 24             	mov    %edi,(%esp)
  80137c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80137f:	83 ee 01             	sub    $0x1,%esi
  801382:	75 f1                	jne    801375 <vprintfmt+0x1fb>
  801384:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801387:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80138a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80138d:	eb b0                	jmp    80133f <vprintfmt+0x1c5>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80138f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801393:	74 18                	je     8013ad <vprintfmt+0x233>
  801395:	8d 50 e0             	lea    -0x20(%eax),%edx
  801398:	83 fa 5e             	cmp    $0x5e,%edx
  80139b:	76 10                	jbe    8013ad <vprintfmt+0x233>
					putch('?', putdat);
  80139d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013a1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8013a8:	ff 55 08             	call   *0x8(%ebp)
  8013ab:	eb 0a                	jmp    8013b7 <vprintfmt+0x23d>
				else
					putch(ch, putdat);
  8013ad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013b1:	89 04 24             	mov    %eax,(%esp)
  8013b4:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013b7:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8013bb:	0f be 06             	movsbl (%esi),%eax
  8013be:	83 c6 01             	add    $0x1,%esi
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	75 0e                	jne    8013d3 <vprintfmt+0x259>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013c5:	8b 75 e0             	mov    -0x20(%ebp),%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013cc:	7f 16                	jg     8013e4 <vprintfmt+0x26a>
  8013ce:	e9 ca fd ff ff       	jmp    80119d <vprintfmt+0x23>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013d3:	85 ff                	test   %edi,%edi
  8013d5:	78 b8                	js     80138f <vprintfmt+0x215>
  8013d7:	83 ef 01             	sub    $0x1,%edi
  8013da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8013e0:	79 ad                	jns    80138f <vprintfmt+0x215>
  8013e2:	eb e1                	jmp    8013c5 <vprintfmt+0x24b>
  8013e4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8013e7:	8b 7d 08             	mov    0x8(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8013ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013ee:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8013f5:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013f7:	83 ee 01             	sub    $0x1,%esi
  8013fa:	75 ee                	jne    8013ea <vprintfmt+0x270>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013fc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8013ff:	e9 99 fd ff ff       	jmp    80119d <vprintfmt+0x23>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801404:	83 f9 01             	cmp    $0x1,%ecx
  801407:	7e 10                	jle    801419 <vprintfmt+0x29f>
		return va_arg(*ap, long long);
  801409:	8b 45 14             	mov    0x14(%ebp),%eax
  80140c:	8d 50 08             	lea    0x8(%eax),%edx
  80140f:	89 55 14             	mov    %edx,0x14(%ebp)
  801412:	8b 30                	mov    (%eax),%esi
  801414:	8b 78 04             	mov    0x4(%eax),%edi
  801417:	eb 26                	jmp    80143f <vprintfmt+0x2c5>
	else if (lflag)
  801419:	85 c9                	test   %ecx,%ecx
  80141b:	74 12                	je     80142f <vprintfmt+0x2b5>
		return va_arg(*ap, long);
  80141d:	8b 45 14             	mov    0x14(%ebp),%eax
  801420:	8d 50 04             	lea    0x4(%eax),%edx
  801423:	89 55 14             	mov    %edx,0x14(%ebp)
  801426:	8b 30                	mov    (%eax),%esi
  801428:	89 f7                	mov    %esi,%edi
  80142a:	c1 ff 1f             	sar    $0x1f,%edi
  80142d:	eb 10                	jmp    80143f <vprintfmt+0x2c5>
	else
		return va_arg(*ap, int);
  80142f:	8b 45 14             	mov    0x14(%ebp),%eax
  801432:	8d 50 04             	lea    0x4(%eax),%edx
  801435:	89 55 14             	mov    %edx,0x14(%ebp)
  801438:	8b 30                	mov    (%eax),%esi
  80143a:	89 f7                	mov    %esi,%edi
  80143c:	c1 ff 1f             	sar    $0x1f,%edi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80143f:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801444:	85 ff                	test   %edi,%edi
  801446:	0f 89 8c 00 00 00    	jns    8014d8 <vprintfmt+0x35e>
				putch('-', putdat);
  80144c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801450:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801457:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80145a:	f7 de                	neg    %esi
  80145c:	83 d7 00             	adc    $0x0,%edi
  80145f:	f7 df                	neg    %edi
			}
			base = 10;
  801461:	b8 0a 00 00 00       	mov    $0xa,%eax
  801466:	eb 70                	jmp    8014d8 <vprintfmt+0x35e>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801468:	89 ca                	mov    %ecx,%edx
  80146a:	8d 45 14             	lea    0x14(%ebp),%eax
  80146d:	e8 89 fc ff ff       	call   8010fb <getuint>
  801472:	89 c6                	mov    %eax,%esi
  801474:	89 d7                	mov    %edx,%edi
			base = 10;
  801476:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  80147b:	eb 5b                	jmp    8014d8 <vprintfmt+0x35e>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80147d:	89 ca                	mov    %ecx,%edx
  80147f:	8d 45 14             	lea    0x14(%ebp),%eax
  801482:	e8 74 fc ff ff       	call   8010fb <getuint>
  801487:	89 c6                	mov    %eax,%esi
  801489:	89 d7                	mov    %edx,%edi
			base = 8;
  80148b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  801490:	eb 46                	jmp    8014d8 <vprintfmt+0x35e>

		// pointer
		case 'p':
			putch('0', putdat);
  801492:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801496:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80149d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8014a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014a4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8014ab:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8014ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b1:	8d 50 04             	lea    0x4(%eax),%edx
  8014b4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014b7:	8b 30                	mov    (%eax),%esi
  8014b9:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8014be:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8014c3:	eb 13                	jmp    8014d8 <vprintfmt+0x35e>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8014c5:	89 ca                	mov    %ecx,%edx
  8014c7:	8d 45 14             	lea    0x14(%ebp),%eax
  8014ca:	e8 2c fc ff ff       	call   8010fb <getuint>
  8014cf:	89 c6                	mov    %eax,%esi
  8014d1:	89 d7                	mov    %edx,%edi
			base = 16;
  8014d3:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8014d8:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  8014dc:	89 54 24 10          	mov    %edx,0x10(%esp)
  8014e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014e3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014eb:	89 34 24             	mov    %esi,(%esp)
  8014ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014f2:	89 da                	mov    %ebx,%edx
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	e8 24 fb ff ff       	call   801020 <printnum>
			break;
  8014fc:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8014ff:	e9 99 fc ff ff       	jmp    80119d <vprintfmt+0x23>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801504:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801508:	89 14 24             	mov    %edx,(%esp)
  80150b:	ff 55 08             	call   *0x8(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80150e:	8b 75 e0             	mov    -0x20(%ebp),%esi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  801511:	e9 87 fc ff ff       	jmp    80119d <vprintfmt+0x23>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801516:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80151a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801521:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801524:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  801528:	0f 84 6f fc ff ff    	je     80119d <vprintfmt+0x23>
  80152e:	83 ee 01             	sub    $0x1,%esi
  801531:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  801535:	75 f7                	jne    80152e <vprintfmt+0x3b4>
  801537:	e9 61 fc ff ff       	jmp    80119d <vprintfmt+0x23>
				/* do nothing */;
			break;
		}
	}
}
  80153c:	83 c4 4c             	add    $0x4c,%esp
  80153f:	5b                   	pop    %ebx
  801540:	5e                   	pop    %esi
  801541:	5f                   	pop    %edi
  801542:	5d                   	pop    %ebp
  801543:	c3                   	ret    

00801544 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	83 ec 28             	sub    $0x28,%esp
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801550:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801553:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801557:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80155a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801561:	85 c0                	test   %eax,%eax
  801563:	74 30                	je     801595 <vsnprintf+0x51>
  801565:	85 d2                	test   %edx,%edx
  801567:	7e 2c                	jle    801595 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801569:	8b 45 14             	mov    0x14(%ebp),%eax
  80156c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801570:	8b 45 10             	mov    0x10(%ebp),%eax
  801573:	89 44 24 08          	mov    %eax,0x8(%esp)
  801577:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80157a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157e:	c7 04 24 35 11 80 00 	movl   $0x801135,(%esp)
  801585:	e8 f0 fb ff ff       	call   80117a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80158a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	eb 05                	jmp    80159a <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801595:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015a2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8015a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	89 04 24             	mov    %eax,(%esp)
  8015bd:	e8 82 ff ff ff       	call   801544 <vsnprintf>
	va_end(ap);

	return rc;
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    
	...

008015d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015db:	80 3a 00             	cmpb   $0x0,(%edx)
  8015de:	74 09                	je     8015e9 <strlen+0x19>
		n++;
  8015e0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8015e7:	75 f7                	jne    8015e0 <strlen+0x10>
		n++;
	return n;
}
  8015e9:	5d                   	pop    %ebp
  8015ea:	c3                   	ret    

008015eb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	53                   	push   %ebx
  8015ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8015f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fa:	85 c9                	test   %ecx,%ecx
  8015fc:	74 1a                	je     801618 <strnlen+0x2d>
  8015fe:	80 3b 00             	cmpb   $0x0,(%ebx)
  801601:	74 15                	je     801618 <strnlen+0x2d>
  801603:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  801608:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80160a:	39 ca                	cmp    %ecx,%edx
  80160c:	74 0a                	je     801618 <strnlen+0x2d>
  80160e:	83 c2 01             	add    $0x1,%edx
  801611:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  801616:	75 f0                	jne    801608 <strnlen+0x1d>
		n++;
	return n;
}
  801618:	5b                   	pop    %ebx
  801619:	5d                   	pop    %ebp
  80161a:	c3                   	ret    

0080161b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	53                   	push   %ebx
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801625:	ba 00 00 00 00       	mov    $0x0,%edx
  80162a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80162e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801631:	83 c2 01             	add    $0x1,%edx
  801634:	84 c9                	test   %cl,%cl
  801636:	75 f2                	jne    80162a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801638:	5b                   	pop    %ebx
  801639:	5d                   	pop    %ebp
  80163a:	c3                   	ret    

0080163b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	53                   	push   %ebx
  80163f:	83 ec 08             	sub    $0x8,%esp
  801642:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801645:	89 1c 24             	mov    %ebx,(%esp)
  801648:	e8 83 ff ff ff       	call   8015d0 <strlen>
	strcpy(dst + len, src);
  80164d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801650:	89 54 24 04          	mov    %edx,0x4(%esp)
  801654:	01 d8                	add    %ebx,%eax
  801656:	89 04 24             	mov    %eax,(%esp)
  801659:	e8 bd ff ff ff       	call   80161b <strcpy>
	return dst;
}
  80165e:	89 d8                	mov    %ebx,%eax
  801660:	83 c4 08             	add    $0x8,%esp
  801663:	5b                   	pop    %ebx
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	56                   	push   %esi
  80166a:	53                   	push   %ebx
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801671:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801674:	85 f6                	test   %esi,%esi
  801676:	74 18                	je     801690 <strncpy+0x2a>
  801678:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  80167d:	0f b6 1a             	movzbl (%edx),%ebx
  801680:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801683:	80 3a 01             	cmpb   $0x1,(%edx)
  801686:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801689:	83 c1 01             	add    $0x1,%ecx
  80168c:	39 f1                	cmp    %esi,%ecx
  80168e:	75 ed                	jne    80167d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801690:	5b                   	pop    %ebx
  801691:	5e                   	pop    %esi
  801692:	5d                   	pop    %ebp
  801693:	c3                   	ret    

00801694 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	57                   	push   %edi
  801698:	56                   	push   %esi
  801699:	53                   	push   %ebx
  80169a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80169d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016a0:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8016a3:	89 f8                	mov    %edi,%eax
  8016a5:	85 f6                	test   %esi,%esi
  8016a7:	74 2b                	je     8016d4 <strlcpy+0x40>
		while (--size > 0 && *src != '\0')
  8016a9:	83 fe 01             	cmp    $0x1,%esi
  8016ac:	74 23                	je     8016d1 <strlcpy+0x3d>
  8016ae:	0f b6 0b             	movzbl (%ebx),%ecx
  8016b1:	84 c9                	test   %cl,%cl
  8016b3:	74 1c                	je     8016d1 <strlcpy+0x3d>
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  8016b5:	83 ee 02             	sub    $0x2,%esi
  8016b8:	ba 00 00 00 00       	mov    $0x0,%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8016bd:	88 08                	mov    %cl,(%eax)
  8016bf:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016c2:	39 f2                	cmp    %esi,%edx
  8016c4:	74 0b                	je     8016d1 <strlcpy+0x3d>
  8016c6:	83 c2 01             	add    $0x1,%edx
  8016c9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8016cd:	84 c9                	test   %cl,%cl
  8016cf:	75 ec                	jne    8016bd <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  8016d1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016d4:	29 f8                	sub    %edi,%eax
}
  8016d6:	5b                   	pop    %ebx
  8016d7:	5e                   	pop    %esi
  8016d8:	5f                   	pop    %edi
  8016d9:	5d                   	pop    %ebp
  8016da:	c3                   	ret    

008016db <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8016e4:	0f b6 01             	movzbl (%ecx),%eax
  8016e7:	84 c0                	test   %al,%al
  8016e9:	74 16                	je     801701 <strcmp+0x26>
  8016eb:	3a 02                	cmp    (%edx),%al
  8016ed:	75 12                	jne    801701 <strcmp+0x26>
		p++, q++;
  8016ef:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016f2:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
  8016f6:	84 c0                	test   %al,%al
  8016f8:	74 07                	je     801701 <strcmp+0x26>
  8016fa:	83 c1 01             	add    $0x1,%ecx
  8016fd:	3a 02                	cmp    (%edx),%al
  8016ff:	74 ee                	je     8016ef <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801701:	0f b6 c0             	movzbl %al,%eax
  801704:	0f b6 12             	movzbl (%edx),%edx
  801707:	29 d0                	sub    %edx,%eax
}
  801709:	5d                   	pop    %ebp
  80170a:	c3                   	ret    

0080170b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	53                   	push   %ebx
  80170f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801712:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801715:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801718:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80171d:	85 d2                	test   %edx,%edx
  80171f:	74 28                	je     801749 <strncmp+0x3e>
  801721:	0f b6 01             	movzbl (%ecx),%eax
  801724:	84 c0                	test   %al,%al
  801726:	74 24                	je     80174c <strncmp+0x41>
  801728:	3a 03                	cmp    (%ebx),%al
  80172a:	75 20                	jne    80174c <strncmp+0x41>
  80172c:	83 ea 01             	sub    $0x1,%edx
  80172f:	74 13                	je     801744 <strncmp+0x39>
		n--, p++, q++;
  801731:	83 c1 01             	add    $0x1,%ecx
  801734:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801737:	0f b6 01             	movzbl (%ecx),%eax
  80173a:	84 c0                	test   %al,%al
  80173c:	74 0e                	je     80174c <strncmp+0x41>
  80173e:	3a 03                	cmp    (%ebx),%al
  801740:	74 ea                	je     80172c <strncmp+0x21>
  801742:	eb 08                	jmp    80174c <strncmp+0x41>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801744:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801749:	5b                   	pop    %ebx
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80174c:	0f b6 01             	movzbl (%ecx),%eax
  80174f:	0f b6 13             	movzbl (%ebx),%edx
  801752:	29 d0                	sub    %edx,%eax
  801754:	eb f3                	jmp    801749 <strncmp+0x3e>

00801756 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801760:	0f b6 10             	movzbl (%eax),%edx
  801763:	84 d2                	test   %dl,%dl
  801765:	74 1c                	je     801783 <strchr+0x2d>
		if (*s == c)
  801767:	38 ca                	cmp    %cl,%dl
  801769:	75 09                	jne    801774 <strchr+0x1e>
  80176b:	eb 1b                	jmp    801788 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80176d:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
  801770:	38 ca                	cmp    %cl,%dl
  801772:	74 14                	je     801788 <strchr+0x32>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801774:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  801778:	84 d2                	test   %dl,%dl
  80177a:	75 f1                	jne    80176d <strchr+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80177c:	b8 00 00 00 00       	mov    $0x0,%eax
  801781:	eb 05                	jmp    801788 <strchr+0x32>
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    

0080178a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801794:	0f b6 10             	movzbl (%eax),%edx
  801797:	84 d2                	test   %dl,%dl
  801799:	74 14                	je     8017af <strfind+0x25>
		if (*s == c)
  80179b:	38 ca                	cmp    %cl,%dl
  80179d:	75 06                	jne    8017a5 <strfind+0x1b>
  80179f:	eb 0e                	jmp    8017af <strfind+0x25>
  8017a1:	38 ca                	cmp    %cl,%dl
  8017a3:	74 0a                	je     8017af <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017a5:	83 c0 01             	add    $0x1,%eax
  8017a8:	0f b6 10             	movzbl (%eax),%edx
  8017ab:	84 d2                	test   %dl,%dl
  8017ad:	75 f2                	jne    8017a1 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8017af:	5d                   	pop    %ebp
  8017b0:	c3                   	ret    

008017b1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 0c             	sub    $0xc,%esp
  8017b7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017ba:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017bd:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8017c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8017c9:	85 c9                	test   %ecx,%ecx
  8017cb:	74 30                	je     8017fd <memset+0x4c>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8017cd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8017d3:	75 25                	jne    8017fa <memset+0x49>
  8017d5:	f6 c1 03             	test   $0x3,%cl
  8017d8:	75 20                	jne    8017fa <memset+0x49>
		c &= 0xFF;
  8017da:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8017dd:	89 d3                	mov    %edx,%ebx
  8017df:	c1 e3 08             	shl    $0x8,%ebx
  8017e2:	89 d6                	mov    %edx,%esi
  8017e4:	c1 e6 18             	shl    $0x18,%esi
  8017e7:	89 d0                	mov    %edx,%eax
  8017e9:	c1 e0 10             	shl    $0x10,%eax
  8017ec:	09 f0                	or     %esi,%eax
  8017ee:	09 d0                	or     %edx,%eax
  8017f0:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8017f2:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8017f5:	fc                   	cld    
  8017f6:	f3 ab                	rep stos %eax,%es:(%edi)
  8017f8:	eb 03                	jmp    8017fd <memset+0x4c>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017fa:	fc                   	cld    
  8017fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8017fd:	89 f8                	mov    %edi,%eax
  8017ff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801802:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801805:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801808:	89 ec                	mov    %ebp,%esp
  80180a:	5d                   	pop    %ebp
  80180b:	c3                   	ret    

0080180c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801815:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80181e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801821:	39 c6                	cmp    %eax,%esi
  801823:	73 36                	jae    80185b <memmove+0x4f>
  801825:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801828:	39 d0                	cmp    %edx,%eax
  80182a:	73 2f                	jae    80185b <memmove+0x4f>
		s += n;
		d += n;
  80182c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80182f:	f6 c2 03             	test   $0x3,%dl
  801832:	75 1b                	jne    80184f <memmove+0x43>
  801834:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80183a:	75 13                	jne    80184f <memmove+0x43>
  80183c:	f6 c1 03             	test   $0x3,%cl
  80183f:	75 0e                	jne    80184f <memmove+0x43>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801841:	83 ef 04             	sub    $0x4,%edi
  801844:	8d 72 fc             	lea    -0x4(%edx),%esi
  801847:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80184a:	fd                   	std    
  80184b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80184d:	eb 09                	jmp    801858 <memmove+0x4c>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80184f:	83 ef 01             	sub    $0x1,%edi
  801852:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801855:	fd                   	std    
  801856:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801858:	fc                   	cld    
  801859:	eb 20                	jmp    80187b <memmove+0x6f>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80185b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801861:	75 13                	jne    801876 <memmove+0x6a>
  801863:	a8 03                	test   $0x3,%al
  801865:	75 0f                	jne    801876 <memmove+0x6a>
  801867:	f6 c1 03             	test   $0x3,%cl
  80186a:	75 0a                	jne    801876 <memmove+0x6a>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80186c:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80186f:	89 c7                	mov    %eax,%edi
  801871:	fc                   	cld    
  801872:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801874:	eb 05                	jmp    80187b <memmove+0x6f>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801876:	89 c7                	mov    %eax,%edi
  801878:	fc                   	cld    
  801879:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80187b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80187e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801881:	89 ec                	mov    %ebp,%esp
  801883:	5d                   	pop    %ebp
  801884:	c3                   	ret    

00801885 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80188b:	8b 45 10             	mov    0x10(%ebp),%eax
  80188e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801892:	8b 45 0c             	mov    0xc(%ebp),%eax
  801895:	89 44 24 04          	mov    %eax,0x4(%esp)
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	89 04 24             	mov    %eax,(%esp)
  80189f:	e8 68 ff ff ff       	call   80180c <memmove>
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	57                   	push   %edi
  8018aa:	56                   	push   %esi
  8018ab:	53                   	push   %ebx
  8018ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8018af:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018b2:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018b5:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018ba:	85 ff                	test   %edi,%edi
  8018bc:	74 37                	je     8018f5 <memcmp+0x4f>
		if (*s1 != *s2)
  8018be:	0f b6 03             	movzbl (%ebx),%eax
  8018c1:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018c4:	83 ef 01             	sub    $0x1,%edi
  8018c7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  8018cc:	38 c8                	cmp    %cl,%al
  8018ce:	74 1c                	je     8018ec <memcmp+0x46>
  8018d0:	eb 10                	jmp    8018e2 <memcmp+0x3c>
  8018d2:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  8018d7:	83 c2 01             	add    $0x1,%edx
  8018da:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  8018de:	38 c8                	cmp    %cl,%al
  8018e0:	74 0a                	je     8018ec <memcmp+0x46>
			return (int) *s1 - (int) *s2;
  8018e2:	0f b6 c0             	movzbl %al,%eax
  8018e5:	0f b6 c9             	movzbl %cl,%ecx
  8018e8:	29 c8                	sub    %ecx,%eax
  8018ea:	eb 09                	jmp    8018f5 <memcmp+0x4f>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018ec:	39 fa                	cmp    %edi,%edx
  8018ee:	75 e2                	jne    8018d2 <memcmp+0x2c>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f5:	5b                   	pop    %ebx
  8018f6:	5e                   	pop    %esi
  8018f7:	5f                   	pop    %edi
  8018f8:	5d                   	pop    %ebp
  8018f9:	c3                   	ret    

008018fa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801900:	89 c2                	mov    %eax,%edx
  801902:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801905:	39 d0                	cmp    %edx,%eax
  801907:	73 19                	jae    801922 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801909:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  80190d:	38 08                	cmp    %cl,(%eax)
  80190f:	75 06                	jne    801917 <memfind+0x1d>
  801911:	eb 0f                	jmp    801922 <memfind+0x28>
  801913:	38 08                	cmp    %cl,(%eax)
  801915:	74 0b                	je     801922 <memfind+0x28>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801917:	83 c0 01             	add    $0x1,%eax
  80191a:	39 d0                	cmp    %edx,%eax
  80191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801920:	75 f1                	jne    801913 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801922:	5d                   	pop    %ebp
  801923:	c3                   	ret    

00801924 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	57                   	push   %edi
  801928:	56                   	push   %esi
  801929:	53                   	push   %ebx
  80192a:	8b 55 08             	mov    0x8(%ebp),%edx
  80192d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801930:	0f b6 02             	movzbl (%edx),%eax
  801933:	3c 20                	cmp    $0x20,%al
  801935:	74 04                	je     80193b <strtol+0x17>
  801937:	3c 09                	cmp    $0x9,%al
  801939:	75 0e                	jne    801949 <strtol+0x25>
		s++;
  80193b:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80193e:	0f b6 02             	movzbl (%edx),%eax
  801941:	3c 20                	cmp    $0x20,%al
  801943:	74 f6                	je     80193b <strtol+0x17>
  801945:	3c 09                	cmp    $0x9,%al
  801947:	74 f2                	je     80193b <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  801949:	3c 2b                	cmp    $0x2b,%al
  80194b:	75 0a                	jne    801957 <strtol+0x33>
		s++;
  80194d:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801950:	bf 00 00 00 00       	mov    $0x0,%edi
  801955:	eb 10                	jmp    801967 <strtol+0x43>
  801957:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80195c:	3c 2d                	cmp    $0x2d,%al
  80195e:	75 07                	jne    801967 <strtol+0x43>
		s++, neg = 1;
  801960:	83 c2 01             	add    $0x1,%edx
  801963:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801967:	85 db                	test   %ebx,%ebx
  801969:	0f 94 c0             	sete   %al
  80196c:	74 05                	je     801973 <strtol+0x4f>
  80196e:	83 fb 10             	cmp    $0x10,%ebx
  801971:	75 15                	jne    801988 <strtol+0x64>
  801973:	80 3a 30             	cmpb   $0x30,(%edx)
  801976:	75 10                	jne    801988 <strtol+0x64>
  801978:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80197c:	75 0a                	jne    801988 <strtol+0x64>
		s += 2, base = 16;
  80197e:	83 c2 02             	add    $0x2,%edx
  801981:	bb 10 00 00 00       	mov    $0x10,%ebx
  801986:	eb 13                	jmp    80199b <strtol+0x77>
	else if (base == 0 && s[0] == '0')
  801988:	84 c0                	test   %al,%al
  80198a:	74 0f                	je     80199b <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80198c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801991:	80 3a 30             	cmpb   $0x30,(%edx)
  801994:	75 05                	jne    80199b <strtol+0x77>
		s++, base = 8;
  801996:	83 c2 01             	add    $0x1,%edx
  801999:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  80199b:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a0:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019a2:	0f b6 0a             	movzbl (%edx),%ecx
  8019a5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8019a8:	80 fb 09             	cmp    $0x9,%bl
  8019ab:	77 08                	ja     8019b5 <strtol+0x91>
			dig = *s - '0';
  8019ad:	0f be c9             	movsbl %cl,%ecx
  8019b0:	83 e9 30             	sub    $0x30,%ecx
  8019b3:	eb 1e                	jmp    8019d3 <strtol+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  8019b5:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  8019b8:	80 fb 19             	cmp    $0x19,%bl
  8019bb:	77 08                	ja     8019c5 <strtol+0xa1>
			dig = *s - 'a' + 10;
  8019bd:	0f be c9             	movsbl %cl,%ecx
  8019c0:	83 e9 57             	sub    $0x57,%ecx
  8019c3:	eb 0e                	jmp    8019d3 <strtol+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  8019c5:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  8019c8:	80 fb 19             	cmp    $0x19,%bl
  8019cb:	77 14                	ja     8019e1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  8019cd:	0f be c9             	movsbl %cl,%ecx
  8019d0:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8019d3:	39 f1                	cmp    %esi,%ecx
  8019d5:	7d 0e                	jge    8019e5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8019d7:	83 c2 01             	add    $0x1,%edx
  8019da:	0f af c6             	imul   %esi,%eax
  8019dd:	01 c8                	add    %ecx,%eax
		// we don't properly detect overflow!
	}
  8019df:	eb c1                	jmp    8019a2 <strtol+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  8019e1:	89 c1                	mov    %eax,%ecx
  8019e3:	eb 02                	jmp    8019e7 <strtol+0xc3>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8019e5:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019eb:	74 05                	je     8019f2 <strtol+0xce>
		*endptr = (char *) s;
  8019ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019f0:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  8019f2:	89 ca                	mov    %ecx,%edx
  8019f4:	f7 da                	neg    %edx
  8019f6:	85 ff                	test   %edi,%edi
  8019f8:	0f 45 c2             	cmovne %edx,%eax
}
  8019fb:	5b                   	pop    %ebx
  8019fc:	5e                   	pop    %esi
  8019fd:	5f                   	pop    %edi
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    

00801a00 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 0c             	sub    $0xc,%esp
  801a06:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a09:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a0c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a17:	8b 55 08             	mov    0x8(%ebp),%edx
  801a1a:	89 c3                	mov    %eax,%ebx
  801a1c:	89 c7                	mov    %eax,%edi
  801a1e:	89 c6                	mov    %eax,%esi
  801a20:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801a22:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a25:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a28:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a2b:	89 ec                	mov    %ebp,%esp
  801a2d:	5d                   	pop    %ebp
  801a2e:	c3                   	ret    

00801a2f <sys_cgetc>:

int
sys_cgetc(void)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 0c             	sub    $0xc,%esp
  801a35:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a38:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a3b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a43:	b8 01 00 00 00       	mov    $0x1,%eax
  801a48:	89 d1                	mov    %edx,%ecx
  801a4a:	89 d3                	mov    %edx,%ebx
  801a4c:	89 d7                	mov    %edx,%edi
  801a4e:	89 d6                	mov    %edx,%esi
  801a50:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801a52:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a55:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a58:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a5b:	89 ec                	mov    %ebp,%esp
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 38             	sub    $0x38,%esp
  801a65:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a68:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a6b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a73:	b8 03 00 00 00       	mov    $0x3,%eax
  801a78:	8b 55 08             	mov    0x8(%ebp),%edx
  801a7b:	89 cb                	mov    %ecx,%ebx
  801a7d:	89 cf                	mov    %ecx,%edi
  801a7f:	89 ce                	mov    %ecx,%esi
  801a81:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801a83:	85 c0                	test   %eax,%eax
  801a85:	7e 28                	jle    801aaf <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a87:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a8b:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801a92:	00 
  801a93:	c7 44 24 08 ff 35 80 	movl   $0x8035ff,0x8(%esp)
  801a9a:	00 
  801a9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801aa2:	00 
  801aa3:	c7 04 24 1c 36 80 00 	movl   $0x80361c,(%esp)
  801aaa:	e8 59 f4 ff ff       	call   800f08 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801aaf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ab2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ab5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ab8:	89 ec                	mov    %ebp,%esp
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    

00801abc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 0c             	sub    $0xc,%esp
  801ac2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ac5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ac8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801acb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad0:	b8 02 00 00 00       	mov    $0x2,%eax
  801ad5:	89 d1                	mov    %edx,%ecx
  801ad7:	89 d3                	mov    %edx,%ebx
  801ad9:	89 d7                	mov    %edx,%edi
  801adb:	89 d6                	mov    %edx,%esi
  801add:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801adf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ae2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ae5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ae8:	89 ec                	mov    %ebp,%esp
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <sys_yield>:

void
sys_yield(void)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 0c             	sub    $0xc,%esp
  801af2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801af5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801af8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801afb:	ba 00 00 00 00       	mov    $0x0,%edx
  801b00:	b8 0b 00 00 00       	mov    $0xb,%eax
  801b05:	89 d1                	mov    %edx,%ecx
  801b07:	89 d3                	mov    %edx,%ebx
  801b09:	89 d7                	mov    %edx,%edi
  801b0b:	89 d6                	mov    %edx,%esi
  801b0d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801b0f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b12:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b15:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b18:	89 ec                	mov    %ebp,%esp
  801b1a:	5d                   	pop    %ebp
  801b1b:	c3                   	ret    

00801b1c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 38             	sub    $0x38,%esp
  801b22:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b25:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b28:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b2b:	be 00 00 00 00       	mov    $0x0,%esi
  801b30:	b8 04 00 00 00       	mov    $0x4,%eax
  801b35:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b3b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b3e:	89 f7                	mov    %esi,%edi
  801b40:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801b42:	85 c0                	test   %eax,%eax
  801b44:	7e 28                	jle    801b6e <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b46:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b4a:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801b51:	00 
  801b52:	c7 44 24 08 ff 35 80 	movl   $0x8035ff,0x8(%esp)
  801b59:	00 
  801b5a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801b61:	00 
  801b62:	c7 04 24 1c 36 80 00 	movl   $0x80361c,(%esp)
  801b69:	e8 9a f3 ff ff       	call   800f08 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801b6e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b71:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b74:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b77:	89 ec                	mov    %ebp,%esp
  801b79:	5d                   	pop    %ebp
  801b7a:	c3                   	ret    

00801b7b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 38             	sub    $0x38,%esp
  801b81:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b84:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b87:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b8a:	b8 05 00 00 00       	mov    $0x5,%eax
  801b8f:	8b 75 18             	mov    0x18(%ebp),%esi
  801b92:	8b 7d 14             	mov    0x14(%ebp),%edi
  801b95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b9e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	7e 28                	jle    801bcc <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ba4:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ba8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801baf:	00 
  801bb0:	c7 44 24 08 ff 35 80 	movl   $0x8035ff,0x8(%esp)
  801bb7:	00 
  801bb8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801bbf:	00 
  801bc0:	c7 04 24 1c 36 80 00 	movl   $0x80361c,(%esp)
  801bc7:	e8 3c f3 ff ff       	call   800f08 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801bcc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801bcf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801bd2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801bd5:	89 ec                	mov    %ebp,%esp
  801bd7:	5d                   	pop    %ebp
  801bd8:	c3                   	ret    

00801bd9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 38             	sub    $0x38,%esp
  801bdf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801be2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801be5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801be8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bed:	b8 06 00 00 00       	mov    $0x6,%eax
  801bf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bf5:	8b 55 08             	mov    0x8(%ebp),%edx
  801bf8:	89 df                	mov    %ebx,%edi
  801bfa:	89 de                	mov    %ebx,%esi
  801bfc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	7e 28                	jle    801c2a <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c02:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c06:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801c0d:	00 
  801c0e:	c7 44 24 08 ff 35 80 	movl   $0x8035ff,0x8(%esp)
  801c15:	00 
  801c16:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801c1d:	00 
  801c1e:	c7 04 24 1c 36 80 00 	movl   $0x80361c,(%esp)
  801c25:	e8 de f2 ff ff       	call   800f08 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801c2a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c2d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c30:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c33:	89 ec                	mov    %ebp,%esp
  801c35:	5d                   	pop    %ebp
  801c36:	c3                   	ret    

00801c37 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 38             	sub    $0x38,%esp
  801c3d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801c40:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801c43:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c46:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c4b:	b8 08 00 00 00       	mov    $0x8,%eax
  801c50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c53:	8b 55 08             	mov    0x8(%ebp),%edx
  801c56:	89 df                	mov    %ebx,%edi
  801c58:	89 de                	mov    %ebx,%esi
  801c5a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	7e 28                	jle    801c88 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c60:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c64:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801c6b:	00 
  801c6c:	c7 44 24 08 ff 35 80 	movl   $0x8035ff,0x8(%esp)
  801c73:	00 
  801c74:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801c7b:	00 
  801c7c:	c7 04 24 1c 36 80 00 	movl   $0x80361c,(%esp)
  801c83:	e8 80 f2 ff ff       	call   800f08 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801c88:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c8b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c8e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c91:	89 ec                	mov    %ebp,%esp
  801c93:	5d                   	pop    %ebp
  801c94:	c3                   	ret    

00801c95 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 38             	sub    $0x38,%esp
  801c9b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801c9e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ca1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ca9:	b8 09 00 00 00       	mov    $0x9,%eax
  801cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb4:	89 df                	mov    %ebx,%edi
  801cb6:	89 de                	mov    %ebx,%esi
  801cb8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	7e 28                	jle    801ce6 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801cbe:	89 44 24 10          	mov    %eax,0x10(%esp)
  801cc2:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801cc9:	00 
  801cca:	c7 44 24 08 ff 35 80 	movl   $0x8035ff,0x8(%esp)
  801cd1:	00 
  801cd2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801cd9:	00 
  801cda:	c7 04 24 1c 36 80 00 	movl   $0x80361c,(%esp)
  801ce1:	e8 22 f2 ff ff       	call   800f08 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801ce6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ce9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801cec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801cef:	89 ec                	mov    %ebp,%esp
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 38             	sub    $0x38,%esp
  801cf9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801cfc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801cff:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d02:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d07:	b8 0a 00 00 00       	mov    $0xa,%eax
  801d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  801d12:	89 df                	mov    %ebx,%edi
  801d14:	89 de                	mov    %ebx,%esi
  801d16:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	7e 28                	jle    801d44 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801d1c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d20:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801d27:	00 
  801d28:	c7 44 24 08 ff 35 80 	movl   $0x8035ff,0x8(%esp)
  801d2f:	00 
  801d30:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801d37:	00 
  801d38:	c7 04 24 1c 36 80 00 	movl   $0x80361c,(%esp)
  801d3f:	e8 c4 f1 ff ff       	call   800f08 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801d44:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d47:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801d4a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801d4d:	89 ec                	mov    %ebp,%esp
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    

00801d51 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 0c             	sub    $0xc,%esp
  801d57:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801d5a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801d5d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d60:	be 00 00 00 00       	mov    $0x0,%esi
  801d65:	b8 0c 00 00 00       	mov    $0xc,%eax
  801d6a:	8b 7d 14             	mov    0x14(%ebp),%edi
  801d6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d73:	8b 55 08             	mov    0x8(%ebp),%edx
  801d76:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801d78:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d7b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801d7e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801d81:	89 ec                	mov    %ebp,%esp
  801d83:	5d                   	pop    %ebp
  801d84:	c3                   	ret    

00801d85 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 38             	sub    $0x38,%esp
  801d8b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801d8e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801d91:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d94:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d99:	b8 0d 00 00 00       	mov    $0xd,%eax
  801d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  801da1:	89 cb                	mov    %ecx,%ebx
  801da3:	89 cf                	mov    %ecx,%edi
  801da5:	89 ce                	mov    %ecx,%esi
  801da7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801da9:	85 c0                	test   %eax,%eax
  801dab:	7e 28                	jle    801dd5 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801dad:	89 44 24 10          	mov    %eax,0x10(%esp)
  801db1:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801db8:	00 
  801db9:	c7 44 24 08 ff 35 80 	movl   $0x8035ff,0x8(%esp)
  801dc0:	00 
  801dc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801dc8:	00 
  801dc9:	c7 04 24 1c 36 80 00 	movl   $0x80361c,(%esp)
  801dd0:	e8 33 f1 ff ff       	call   800f08 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801dd5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801dd8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ddb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801dde:	89 ec                	mov    %ebp,%esp
  801de0:	5d                   	pop    %ebp
  801de1:	c3                   	ret    
	...

00801de4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  801dea:	83 3d 10 90 80 00 00 	cmpl   $0x0,0x809010
  801df1:	75 54                	jne    801e47 <set_pgfault_handler+0x63>
		// First time through!
		// LAB 4: Your code here.
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE),PTE_U|PTE_P|PTE_W)) < 0)
  801df3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801dfa:	00 
  801dfb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801e02:	ee 
  801e03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e0a:	e8 0d fd ff ff       	call   801b1c <sys_page_alloc>
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	79 20                	jns    801e33 <set_pgfault_handler+0x4f>
			panic("set_pgfault_handler: %e", r);
  801e13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e17:	c7 44 24 08 2a 36 80 	movl   $0x80362a,0x8(%esp)
  801e1e:	00 
  801e1f:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801e26:	00 
  801e27:	c7 04 24 42 36 80 00 	movl   $0x803642,(%esp)
  801e2e:	e8 d5 f0 ff ff       	call   800f08 <_panic>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801e33:	c7 44 24 04 54 1e 80 	movl   $0x801e54,0x4(%esp)
  801e3a:	00 
  801e3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e42:	e8 ac fe ff ff       	call   801cf3 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	a3 10 90 80 00       	mov    %eax,0x809010
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    
  801e51:	00 00                	add    %al,(%eax)
	...

00801e54 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801e54:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801e55:	a1 10 90 80 00       	mov    0x809010,%eax
	call *%eax
  801e5a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801e5c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %eax
  801e5f:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  801e63:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  801e66:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl 0x28(%esp), %ebx
  801e6a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  801e6e:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801e70:	83 c4 08             	add    $0x8,%esp
	popal
  801e73:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801e74:	83 c4 04             	add    $0x4,%esp
	popfl
  801e77:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  801e78:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801e79:	c3                   	ret    
  801e7a:	00 00                	add    %al,(%eax)
  801e7c:	00 00                	add    %al,(%eax)
	...

00801e80 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	56                   	push   %esi
  801e84:	53                   	push   %ebx
  801e85:	83 ec 10             	sub    $0x10,%esp
  801e88:	8b 75 08             	mov    0x8(%ebp),%esi
  801e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	
	int32_t val;
	envid_t sender;
	int perm;
	if(!pg)
  801e91:	85 c0                	test   %eax,%eax
	pg = (void *) UTOP;
  801e93:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e98:	0f 44 c2             	cmove  %edx,%eax
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801e9b:	89 04 24             	mov    %eax,(%esp)
  801e9e:	e8 e2 fe ff ff       	call   801d85 <sys_ipc_recv>
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
		perm = 0;
  801ea3:	ba 00 00 00 00       	mov    $0x0,%edx
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
			//IPC_DEBUG("ipc_recv returned %e... dealing\n", val);
		sender = 0;
  801ea8:	b9 00 00 00 00       	mov    $0x0,%ecx
	envid_t sender;
	int perm;
	if(!pg)
	pg = (void *) UTOP;
	//IPC_DEBUG("making blocking call to ipc_recv\n");
	if((val = sys_ipc_recv(pg)) < 0){
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	78 0e                	js     801ebf <ipc_recv+0x3f>
		sender = 0;
		perm = 0;
	} 
	else{
			//IPC_DEBUG("ipc_recv returned %d!\n", val);
		sender = thisenv->env_ipc_from;
  801eb1:	a1 0c 90 80 00       	mov    0x80900c,%eax
  801eb6:	8b 48 74             	mov    0x74(%eax),%ecx
		perm = thisenv->env_ipc_perm;
  801eb9:	8b 50 78             	mov    0x78(%eax),%edx
		val = thisenv->env_ipc_value;
  801ebc:	8b 40 70             	mov    0x70(%eax),%eax
		//if(perm)
			// IPC_DEBUG("ipc_recv did map a page at %08x\n", pg);
	}
	if(from_env_store)
  801ebf:	85 f6                	test   %esi,%esi
  801ec1:	74 02                	je     801ec5 <ipc_recv+0x45>
		*from_env_store = sender;
  801ec3:	89 0e                	mov    %ecx,(%esi)
	if(perm_store)
  801ec5:	85 db                	test   %ebx,%ebx
  801ec7:	74 02                	je     801ecb <ipc_recv+0x4b>
		*perm_store = perm;
  801ec9:	89 13                	mov    %edx,(%ebx)
	return val;

}
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	5b                   	pop    %ebx
  801ecf:	5e                   	pop    %esi
  801ed0:	5d                   	pop    %ebp
  801ed1:	c3                   	ret    

00801ed2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	57                   	push   %edi
  801ed6:	56                   	push   %esi
  801ed7:	53                   	push   %ebx
  801ed8:	83 ec 1c             	sub    $0x1c,%esp
  801edb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ede:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ee1:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
  801ee4:	85 db                	test   %ebx,%ebx
  801ee6:	75 04                	jne    801eec <ipc_send+0x1a>
  801ee8:	85 f6                	test   %esi,%esi
  801eea:	75 15                	jne    801f01 <ipc_send+0x2f>
      perm = 0;
    } 
	else if (pg && !perm) {
  801eec:	85 db                	test   %ebx,%ebx
  801eee:	74 16                	je     801f06 <ipc_send+0x34>
  801ef0:	85 f6                	test   %esi,%esi
  801ef2:	0f 94 c0             	sete   %al
      pg = 0;
  801ef5:	84 c0                	test   %al,%al
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	0f 45 d8             	cmovne %eax,%ebx
  801eff:	eb 05                	jmp    801f06 <ipc_send+0x34>
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int err;
    if(!pg && perm) {
      perm = 0;
  801f01:	be 00 00 00 00       	mov    $0x0,%esi
    } 
	else if (pg && !perm) {
      pg = 0;
    }
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
  801f06:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f0a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f0e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f12:	8b 45 08             	mov    0x8(%ebp),%eax
  801f15:	89 04 24             	mov    %eax,(%esp)
  801f18:	e8 34 fe ff ff       	call   801d51 <sys_ipc_try_send>
    	if(err == -E_IPC_NOT_RECV){
  801f1d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f20:	75 07                	jne    801f29 <ipc_send+0x57>
           sys_yield();
  801f22:	e8 c5 fb ff ff       	call   801aec <sys_yield>
          return ;
        }
		else{
			panic("ipc_send\n");
		}
    }
  801f27:	eb dd                	jmp    801f06 <ipc_send+0x34>
    while(1){
    	err = sys_ipc_try_send(to_env, val, pg, perm);
    	if(err == -E_IPC_NOT_RECV){
           sys_yield();
        } 
		else if(!err){
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	90                   	nop
  801f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f30:	74 1c                	je     801f4e <ipc_send+0x7c>
          return ;
        }
		else{
			panic("ipc_send\n");
  801f32:	c7 44 24 08 50 36 80 	movl   $0x803650,0x8(%esp)
  801f39:	00 
  801f3a:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801f41:	00 
  801f42:	c7 04 24 5a 36 80 00 	movl   $0x80365a,(%esp)
  801f49:	e8 ba ef ff ff       	call   800f08 <_panic>
		}
    }
}
  801f4e:	83 c4 1c             	add    $0x1c,%esp
  801f51:	5b                   	pop    %ebx
  801f52:	5e                   	pop    %esi
  801f53:	5f                   	pop    %edi
  801f54:	5d                   	pop    %ebp
  801f55:	c3                   	ret    

00801f56 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801f5c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801f61:	39 c8                	cmp    %ecx,%eax
  801f63:	74 17                	je     801f7c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f65:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801f6a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f6d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f73:	8b 52 50             	mov    0x50(%edx),%edx
  801f76:	39 ca                	cmp    %ecx,%edx
  801f78:	75 14                	jne    801f8e <ipc_find_env+0x38>
  801f7a:	eb 05                	jmp    801f81 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f7c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801f81:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f84:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801f89:	8b 40 40             	mov    0x40(%eax),%eax
  801f8c:	eb 0e                	jmp    801f9c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f8e:	83 c0 01             	add    $0x1,%eax
  801f91:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f96:	75 d2                	jne    801f6a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801f98:	66 b8 00 00          	mov    $0x0,%ax
}
  801f9c:	5d                   	pop    %ebp
  801f9d:	c3                   	ret    
	...

00801fa0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	05 00 00 00 30       	add    $0x30000000,%eax
  801fab:	c1 e8 0c             	shr    $0xc,%eax
}
  801fae:	5d                   	pop    %ebp
  801faf:	c3                   	ret    

00801fb0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	89 04 24             	mov    %eax,(%esp)
  801fbc:	e8 df ff ff ff       	call   801fa0 <fd2num>
  801fc1:	05 20 00 0d 00       	add    $0xd0020,%eax
  801fc6:	c1 e0 0c             	shl    $0xc,%eax
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	53                   	push   %ebx
  801fcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801fd2:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801fd7:	a8 01                	test   $0x1,%al
  801fd9:	74 34                	je     80200f <fd_alloc+0x44>
  801fdb:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801fe0:	a8 01                	test   $0x1,%al
  801fe2:	74 32                	je     802016 <fd_alloc+0x4b>
  801fe4:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801fe9:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801feb:	89 c2                	mov    %eax,%edx
  801fed:	c1 ea 16             	shr    $0x16,%edx
  801ff0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801ff7:	f6 c2 01             	test   $0x1,%dl
  801ffa:	74 1f                	je     80201b <fd_alloc+0x50>
  801ffc:	89 c2                	mov    %eax,%edx
  801ffe:	c1 ea 0c             	shr    $0xc,%edx
  802001:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802008:	f6 c2 01             	test   $0x1,%dl
  80200b:	75 17                	jne    802024 <fd_alloc+0x59>
  80200d:	eb 0c                	jmp    80201b <fd_alloc+0x50>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  80200f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  802014:	eb 05                	jmp    80201b <fd_alloc+0x50>
  802016:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  80201b:	89 0b                	mov    %ecx,(%ebx)
			return 0;
  80201d:	b8 00 00 00 00       	mov    $0x0,%eax
  802022:	eb 17                	jmp    80203b <fd_alloc+0x70>
  802024:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802029:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80202e:	75 b9                	jne    801fe9 <fd_alloc+0x1e>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802030:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_MAX_OPEN;
  802036:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80203b:	5b                   	pop    %ebx
  80203c:	5d                   	pop    %ebp
  80203d:	c3                   	ret    

0080203e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	8b 55 08             	mov    0x8(%ebp),%edx
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802044:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802049:	83 fa 1f             	cmp    $0x1f,%edx
  80204c:	77 3f                	ja     80208d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80204e:	81 c2 00 00 0d 00    	add    $0xd0000,%edx
  802054:	c1 e2 0c             	shl    $0xc,%edx
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802057:	89 d0                	mov    %edx,%eax
  802059:	c1 e8 16             	shr    $0x16,%eax
  80205c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802063:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802068:	f6 c1 01             	test   $0x1,%cl
  80206b:	74 20                	je     80208d <fd_lookup+0x4f>
  80206d:	89 d0                	mov    %edx,%eax
  80206f:	c1 e8 0c             	shr    $0xc,%eax
  802072:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802079:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80207e:	f6 c1 01             	test   $0x1,%cl
  802081:	74 0a                	je     80208d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802083:	8b 45 0c             	mov    0xc(%ebp),%eax
  802086:	89 10                	mov    %edx,(%eax)
	return 0;
  802088:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208d:	5d                   	pop    %ebp
  80208e:	c3                   	ret    

0080208f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	53                   	push   %ebx
  802093:	83 ec 14             	sub    $0x14,%esp
  802096:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802099:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80209c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8020a1:	39 0d 44 80 80 00    	cmp    %ecx,0x808044
  8020a7:	75 17                	jne    8020c0 <dev_lookup+0x31>
  8020a9:	eb 07                	jmp    8020b2 <dev_lookup+0x23>
  8020ab:	39 0a                	cmp    %ecx,(%edx)
  8020ad:	75 11                	jne    8020c0 <dev_lookup+0x31>
  8020af:	90                   	nop
  8020b0:	eb 05                	jmp    8020b7 <dev_lookup+0x28>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020b2:	ba 44 80 80 00       	mov    $0x808044,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8020b7:	89 13                	mov    %edx,(%ebx)
			return 0;
  8020b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020be:	eb 35                	jmp    8020f5 <dev_lookup+0x66>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020c0:	83 c0 01             	add    $0x1,%eax
  8020c3:	8b 14 85 e4 36 80 00 	mov    0x8036e4(,%eax,4),%edx
  8020ca:	85 d2                	test   %edx,%edx
  8020cc:	75 dd                	jne    8020ab <dev_lookup+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8020ce:	a1 0c 90 80 00       	mov    0x80900c,%eax
  8020d3:	8b 40 48             	mov    0x48(%eax),%eax
  8020d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020de:	c7 04 24 64 36 80 00 	movl   $0x803664,(%esp)
  8020e5:	e8 19 ef ff ff       	call   801003 <cprintf>
	*dev = 0;
  8020ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8020f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020f5:	83 c4 14             	add    $0x14,%esp
  8020f8:	5b                   	pop    %ebx
  8020f9:	5d                   	pop    %ebp
  8020fa:	c3                   	ret    

008020fb <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 38             	sub    $0x38,%esp
  802101:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802104:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802107:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80210a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80210d:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802111:	89 3c 24             	mov    %edi,(%esp)
  802114:	e8 87 fe ff ff       	call   801fa0 <fd2num>
  802119:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80211c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802120:	89 04 24             	mov    %eax,(%esp)
  802123:	e8 16 ff ff ff       	call   80203e <fd_lookup>
  802128:	89 c3                	mov    %eax,%ebx
  80212a:	85 c0                	test   %eax,%eax
  80212c:	78 05                	js     802133 <fd_close+0x38>
	    || fd != fd2)
  80212e:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  802131:	74 0e                	je     802141 <fd_close+0x46>
		return (must_exist ? r : 0);
  802133:	89 f0                	mov    %esi,%eax
  802135:	84 c0                	test   %al,%al
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
  80213c:	0f 44 d8             	cmove  %eax,%ebx
  80213f:	eb 3d                	jmp    80217e <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802141:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802144:	89 44 24 04          	mov    %eax,0x4(%esp)
  802148:	8b 07                	mov    (%edi),%eax
  80214a:	89 04 24             	mov    %eax,(%esp)
  80214d:	e8 3d ff ff ff       	call   80208f <dev_lookup>
  802152:	89 c3                	mov    %eax,%ebx
  802154:	85 c0                	test   %eax,%eax
  802156:	78 16                	js     80216e <fd_close+0x73>
		if (dev->dev_close)
  802158:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80215b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80215e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  802163:	85 c0                	test   %eax,%eax
  802165:	74 07                	je     80216e <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  802167:	89 3c 24             	mov    %edi,(%esp)
  80216a:	ff d0                	call   *%eax
  80216c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80216e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802172:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802179:	e8 5b fa ff ff       	call   801bd9 <sys_page_unmap>
	return r;
}
  80217e:	89 d8                	mov    %ebx,%eax
  802180:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802183:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802186:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802189:	89 ec                	mov    %ebp,%esp
  80218b:	5d                   	pop    %ebp
  80218c:	c3                   	ret    

0080218d <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802193:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802196:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	89 04 24             	mov    %eax,(%esp)
  8021a0:	e8 99 fe ff ff       	call   80203e <fd_lookup>
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	78 13                	js     8021bc <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8021a9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021b0:	00 
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	89 04 24             	mov    %eax,(%esp)
  8021b7:	e8 3f ff ff ff       	call   8020fb <fd_close>
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <close_all>:

void
close_all(void)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	53                   	push   %ebx
  8021c2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021c5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8021ca:	89 1c 24             	mov    %ebx,(%esp)
  8021cd:	e8 bb ff ff ff       	call   80218d <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021d2:	83 c3 01             	add    $0x1,%ebx
  8021d5:	83 fb 20             	cmp    $0x20,%ebx
  8021d8:	75 f0                	jne    8021ca <close_all+0xc>
		close(i);
}
  8021da:	83 c4 14             	add    $0x14,%esp
  8021dd:	5b                   	pop    %ebx
  8021de:	5d                   	pop    %ebp
  8021df:	c3                   	ret    

008021e0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 58             	sub    $0x58,%esp
  8021e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8021e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8021ec:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8021ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8021f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	89 04 24             	mov    %eax,(%esp)
  8021ff:	e8 3a fe ff ff       	call   80203e <fd_lookup>
  802204:	89 c3                	mov    %eax,%ebx
  802206:	85 c0                	test   %eax,%eax
  802208:	0f 88 e1 00 00 00    	js     8022ef <dup+0x10f>
		return r;
	close(newfdnum);
  80220e:	89 3c 24             	mov    %edi,(%esp)
  802211:	e8 77 ff ff ff       	call   80218d <close>

	newfd = INDEX2FD(newfdnum);
  802216:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  80221c:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80221f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802222:	89 04 24             	mov    %eax,(%esp)
  802225:	e8 86 fd ff ff       	call   801fb0 <fd2data>
  80222a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80222c:	89 34 24             	mov    %esi,(%esp)
  80222f:	e8 7c fd ff ff       	call   801fb0 <fd2data>
  802234:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802237:	89 d8                	mov    %ebx,%eax
  802239:	c1 e8 16             	shr    $0x16,%eax
  80223c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802243:	a8 01                	test   $0x1,%al
  802245:	74 46                	je     80228d <dup+0xad>
  802247:	89 d8                	mov    %ebx,%eax
  802249:	c1 e8 0c             	shr    $0xc,%eax
  80224c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802253:	f6 c2 01             	test   $0x1,%dl
  802256:	74 35                	je     80228d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802258:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80225f:	25 07 0e 00 00       	and    $0xe07,%eax
  802264:	89 44 24 10          	mov    %eax,0x10(%esp)
  802268:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80226b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80226f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802276:	00 
  802277:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80227b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802282:	e8 f4 f8 ff ff       	call   801b7b <sys_page_map>
  802287:	89 c3                	mov    %eax,%ebx
  802289:	85 c0                	test   %eax,%eax
  80228b:	78 3b                	js     8022c8 <dup+0xe8>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80228d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802290:	89 c2                	mov    %eax,%edx
  802292:	c1 ea 0c             	shr    $0xc,%edx
  802295:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80229c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8022a2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8022a6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8022aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022b1:	00 
  8022b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022bd:	e8 b9 f8 ff ff       	call   801b7b <sys_page_map>
  8022c2:	89 c3                	mov    %eax,%ebx
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	79 25                	jns    8022ed <dup+0x10d>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8022c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d3:	e8 01 f9 ff ff       	call   801bd9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8022d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e6:	e8 ee f8 ff ff       	call   801bd9 <sys_page_unmap>
	return r;
  8022eb:	eb 02                	jmp    8022ef <dup+0x10f>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8022ed:	89 fb                	mov    %edi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8022ef:	89 d8                	mov    %ebx,%eax
  8022f1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8022f4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8022f7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8022fa:	89 ec                	mov    %ebp,%esp
  8022fc:	5d                   	pop    %ebp
  8022fd:	c3                   	ret    

008022fe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	53                   	push   %ebx
  802302:	83 ec 24             	sub    $0x24,%esp
  802305:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802308:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80230b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230f:	89 1c 24             	mov    %ebx,(%esp)
  802312:	e8 27 fd ff ff       	call   80203e <fd_lookup>
  802317:	85 c0                	test   %eax,%eax
  802319:	78 6d                	js     802388 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80231b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80231e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802325:	8b 00                	mov    (%eax),%eax
  802327:	89 04 24             	mov    %eax,(%esp)
  80232a:	e8 60 fd ff ff       	call   80208f <dev_lookup>
  80232f:	85 c0                	test   %eax,%eax
  802331:	78 55                	js     802388 <read+0x8a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802336:	8b 50 08             	mov    0x8(%eax),%edx
  802339:	83 e2 03             	and    $0x3,%edx
  80233c:	83 fa 01             	cmp    $0x1,%edx
  80233f:	75 23                	jne    802364 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802341:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802346:	8b 40 48             	mov    0x48(%eax),%eax
  802349:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80234d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802351:	c7 04 24 a8 36 80 00 	movl   $0x8036a8,(%esp)
  802358:	e8 a6 ec ff ff       	call   801003 <cprintf>
		return -E_INVAL;
  80235d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802362:	eb 24                	jmp    802388 <read+0x8a>
	}
	if (!dev->dev_read)
  802364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802367:	8b 52 08             	mov    0x8(%edx),%edx
  80236a:	85 d2                	test   %edx,%edx
  80236c:	74 15                	je     802383 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80236e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802371:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802375:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802378:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80237c:	89 04 24             	mov    %eax,(%esp)
  80237f:	ff d2                	call   *%edx
  802381:	eb 05                	jmp    802388 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  802383:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  802388:	83 c4 24             	add    $0x24,%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5d                   	pop    %ebp
  80238d:	c3                   	ret    

0080238e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	57                   	push   %edi
  802392:	56                   	push   %esi
  802393:	53                   	push   %ebx
  802394:	83 ec 1c             	sub    $0x1c,%esp
  802397:	8b 7d 08             	mov    0x8(%ebp),%edi
  80239a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80239d:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a2:	85 f6                	test   %esi,%esi
  8023a4:	74 30                	je     8023d6 <readn+0x48>
  8023a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023ab:	89 f2                	mov    %esi,%edx
  8023ad:	29 c2                	sub    %eax,%edx
  8023af:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023b3:	03 45 0c             	add    0xc(%ebp),%eax
  8023b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ba:	89 3c 24             	mov    %edi,(%esp)
  8023bd:	e8 3c ff ff ff       	call   8022fe <read>
		if (m < 0)
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	78 10                	js     8023d6 <readn+0x48>
			return m;
		if (m == 0)
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	74 0a                	je     8023d4 <readn+0x46>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023ca:	01 c3                	add    %eax,%ebx
  8023cc:	89 d8                	mov    %ebx,%eax
  8023ce:	39 f3                	cmp    %esi,%ebx
  8023d0:	72 d9                	jb     8023ab <readn+0x1d>
  8023d2:	eb 02                	jmp    8023d6 <readn+0x48>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
  8023d4:	89 d8                	mov    %ebx,%eax
			break;
	}
	return tot;
}
  8023d6:	83 c4 1c             	add    $0x1c,%esp
  8023d9:	5b                   	pop    %ebx
  8023da:	5e                   	pop    %esi
  8023db:	5f                   	pop    %edi
  8023dc:	5d                   	pop    %ebp
  8023dd:	c3                   	ret    

008023de <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	53                   	push   %ebx
  8023e2:	83 ec 24             	sub    $0x24,%esp
  8023e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ef:	89 1c 24             	mov    %ebx,(%esp)
  8023f2:	e8 47 fc ff ff       	call   80203e <fd_lookup>
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	78 68                	js     802463 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	89 04 24             	mov    %eax,(%esp)
  80240a:	e8 80 fc ff ff       	call   80208f <dev_lookup>
  80240f:	85 c0                	test   %eax,%eax
  802411:	78 50                	js     802463 <write+0x85>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802416:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80241a:	75 23                	jne    80243f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80241c:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802421:	8b 40 48             	mov    0x48(%eax),%eax
  802424:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802428:	89 44 24 04          	mov    %eax,0x4(%esp)
  80242c:	c7 04 24 c4 36 80 00 	movl   $0x8036c4,(%esp)
  802433:	e8 cb eb ff ff       	call   801003 <cprintf>
		return -E_INVAL;
  802438:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80243d:	eb 24                	jmp    802463 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80243f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802442:	8b 52 0c             	mov    0xc(%edx),%edx
  802445:	85 d2                	test   %edx,%edx
  802447:	74 15                	je     80245e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802449:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80244c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802453:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802457:	89 04 24             	mov    %eax,(%esp)
  80245a:	ff d2                	call   *%edx
  80245c:	eb 05                	jmp    802463 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80245e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  802463:	83 c4 24             	add    $0x24,%esp
  802466:	5b                   	pop    %ebx
  802467:	5d                   	pop    %ebp
  802468:	c3                   	ret    

00802469 <seek>:

int
seek(int fdnum, off_t offset)
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80246f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802472:	89 44 24 04          	mov    %eax,0x4(%esp)
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	89 04 24             	mov    %eax,(%esp)
  80247c:	e8 bd fb ff ff       	call   80203e <fd_lookup>
  802481:	85 c0                	test   %eax,%eax
  802483:	78 0e                	js     802493 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  802485:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80248b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80248e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
  802498:	53                   	push   %ebx
  802499:	83 ec 24             	sub    $0x24,%esp
  80249c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80249f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a6:	89 1c 24             	mov    %ebx,(%esp)
  8024a9:	e8 90 fb ff ff       	call   80203e <fd_lookup>
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	78 61                	js     802513 <ftruncate+0x7e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	89 04 24             	mov    %eax,(%esp)
  8024c1:	e8 c9 fb ff ff       	call   80208f <dev_lookup>
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	78 49                	js     802513 <ftruncate+0x7e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8024d1:	75 23                	jne    8024f6 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024d3:	a1 0c 90 80 00       	mov    0x80900c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024d8:	8b 40 48             	mov    0x48(%eax),%eax
  8024db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e3:	c7 04 24 84 36 80 00 	movl   $0x803684,(%esp)
  8024ea:	e8 14 eb ff ff       	call   801003 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8024ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024f4:	eb 1d                	jmp    802513 <ftruncate+0x7e>
	}
	if (!dev->dev_trunc)
  8024f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f9:	8b 52 18             	mov    0x18(%edx),%edx
  8024fc:	85 d2                	test   %edx,%edx
  8024fe:	74 0e                	je     80250e <ftruncate+0x79>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802500:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802503:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802507:	89 04 24             	mov    %eax,(%esp)
  80250a:	ff d2                	call   *%edx
  80250c:	eb 05                	jmp    802513 <ftruncate+0x7e>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80250e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  802513:	83 c4 24             	add    $0x24,%esp
  802516:	5b                   	pop    %ebx
  802517:	5d                   	pop    %ebp
  802518:	c3                   	ret    

00802519 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
  80251c:	53                   	push   %ebx
  80251d:	83 ec 24             	sub    $0x24,%esp
  802520:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802523:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802526:	89 44 24 04          	mov    %eax,0x4(%esp)
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	89 04 24             	mov    %eax,(%esp)
  802530:	e8 09 fb ff ff       	call   80203e <fd_lookup>
  802535:	85 c0                	test   %eax,%eax
  802537:	78 52                	js     80258b <fstat+0x72>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802539:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80253c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802543:	8b 00                	mov    (%eax),%eax
  802545:	89 04 24             	mov    %eax,(%esp)
  802548:	e8 42 fb ff ff       	call   80208f <dev_lookup>
  80254d:	85 c0                	test   %eax,%eax
  80254f:	78 3a                	js     80258b <fstat+0x72>
		return r;
	if (!dev->dev_stat)
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802558:	74 2c                	je     802586 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80255a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80255d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802564:	00 00 00 
	stat->st_isdir = 0;
  802567:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80256e:	00 00 00 
	stat->st_dev = dev;
  802571:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802577:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80257b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80257e:	89 14 24             	mov    %edx,(%esp)
  802581:	ff 50 14             	call   *0x14(%eax)
  802584:	eb 05                	jmp    80258b <fstat+0x72>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  802586:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80258b:	83 c4 24             	add    $0x24,%esp
  80258e:	5b                   	pop    %ebx
  80258f:	5d                   	pop    %ebp
  802590:	c3                   	ret    

00802591 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
  802594:	83 ec 18             	sub    $0x18,%esp
  802597:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80259a:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80259d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8025a4:	00 
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	89 04 24             	mov    %eax,(%esp)
  8025ab:	e8 bc 01 00 00       	call   80276c <open>
  8025b0:	89 c3                	mov    %eax,%ebx
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	78 1b                	js     8025d1 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8025b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025bd:	89 1c 24             	mov    %ebx,(%esp)
  8025c0:	e8 54 ff ff ff       	call   802519 <fstat>
  8025c5:	89 c6                	mov    %eax,%esi
	close(fd);
  8025c7:	89 1c 24             	mov    %ebx,(%esp)
  8025ca:	e8 be fb ff ff       	call   80218d <close>
	return r;
  8025cf:	89 f3                	mov    %esi,%ebx
}
  8025d1:	89 d8                	mov    %ebx,%eax
  8025d3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8025d6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8025d9:	89 ec                	mov    %ebp,%esp
  8025db:	5d                   	pop    %ebp
  8025dc:	c3                   	ret    
  8025dd:	00 00                	add    %al,(%eax)
	...

008025e0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	83 ec 18             	sub    $0x18,%esp
  8025e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8025e9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8025ec:	89 c3                	mov    %eax,%ebx
  8025ee:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8025f0:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  8025f7:	75 11                	jne    80260a <fsipc+0x2a>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  802600:	e8 51 f9 ff ff       	call   801f56 <ipc_find_env>
  802605:	a3 00 90 80 00       	mov    %eax,0x809000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80260a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802611:	00 
  802612:	c7 44 24 08 00 a0 80 	movl   $0x80a000,0x8(%esp)
  802619:	00 
  80261a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80261e:	a1 00 90 80 00       	mov    0x809000,%eax
  802623:	89 04 24             	mov    %eax,(%esp)
  802626:	e8 a7 f8 ff ff       	call   801ed2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80262b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802632:	00 
  802633:	89 74 24 04          	mov    %esi,0x4(%esp)
  802637:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80263e:	e8 3d f8 ff ff       	call   801e80 <ipc_recv>
}
  802643:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802646:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802649:	89 ec                	mov    %ebp,%esp
  80264b:	5d                   	pop    %ebp
  80264c:	c3                   	ret    

0080264d <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	53                   	push   %ebx
  802651:	83 ec 14             	sub    $0x14,%esp
  802654:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802657:	8b 45 08             	mov    0x8(%ebp),%eax
  80265a:	8b 40 0c             	mov    0xc(%eax),%eax
  80265d:	a3 00 a0 80 00       	mov    %eax,0x80a000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802662:	ba 00 00 00 00       	mov    $0x0,%edx
  802667:	b8 05 00 00 00       	mov    $0x5,%eax
  80266c:	e8 6f ff ff ff       	call   8025e0 <fsipc>
  802671:	85 c0                	test   %eax,%eax
  802673:	78 2b                	js     8026a0 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802675:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  80267c:	00 
  80267d:	89 1c 24             	mov    %ebx,(%esp)
  802680:	e8 96 ef ff ff       	call   80161b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802685:	a1 80 a0 80 00       	mov    0x80a080,%eax
  80268a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802690:	a1 84 a0 80 00       	mov    0x80a084,%eax
  802695:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80269b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a0:	83 c4 14             	add    $0x14,%esp
  8026a3:	5b                   	pop    %ebx
  8026a4:	5d                   	pop    %ebp
  8026a5:	c3                   	ret    

008026a6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b2:	a3 00 a0 80 00       	mov    %eax,0x80a000
	return fsipc(FSREQ_FLUSH, NULL);
  8026b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026bc:	b8 06 00 00 00       	mov    $0x6,%eax
  8026c1:	e8 1a ff ff ff       	call   8025e0 <fsipc>
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
  8026cb:	56                   	push   %esi
  8026cc:	53                   	push   %ebx
  8026cd:	83 ec 10             	sub    $0x10,%esp
  8026d0:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d9:	a3 00 a0 80 00       	mov    %eax,0x80a000
	fsipcbuf.read.req_n = n;
  8026de:	89 35 04 a0 80 00    	mov    %esi,0x80a004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8026e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e9:	b8 03 00 00 00       	mov    $0x3,%eax
  8026ee:	e8 ed fe ff ff       	call   8025e0 <fsipc>
  8026f3:	89 c3                	mov    %eax,%ebx
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	78 6a                	js     802763 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8026f9:	39 c6                	cmp    %eax,%esi
  8026fb:	73 24                	jae    802721 <devfile_read+0x59>
  8026fd:	c7 44 24 0c f4 36 80 	movl   $0x8036f4,0xc(%esp)
  802704:	00 
  802705:	c7 44 24 08 bd 30 80 	movl   $0x8030bd,0x8(%esp)
  80270c:	00 
  80270d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  802714:	00 
  802715:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  80271c:	e8 e7 e7 ff ff       	call   800f08 <_panic>
	assert(r <= PGSIZE);
  802721:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802726:	7e 24                	jle    80274c <devfile_read+0x84>
  802728:	c7 44 24 0c 06 37 80 	movl   $0x803706,0xc(%esp)
  80272f:	00 
  802730:	c7 44 24 08 bd 30 80 	movl   $0x8030bd,0x8(%esp)
  802737:	00 
  802738:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80273f:	00 
  802740:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  802747:	e8 bc e7 ff ff       	call   800f08 <_panic>
	memmove(buf, &fsipcbuf, r);
  80274c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802750:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  802757:	00 
  802758:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275b:	89 04 24             	mov    %eax,(%esp)
  80275e:	e8 a9 f0 ff ff       	call   80180c <memmove>
	return r;
}
  802763:	89 d8                	mov    %ebx,%eax
  802765:	83 c4 10             	add    $0x10,%esp
  802768:	5b                   	pop    %ebx
  802769:	5e                   	pop    %esi
  80276a:	5d                   	pop    %ebp
  80276b:	c3                   	ret    

0080276c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80276c:	55                   	push   %ebp
  80276d:	89 e5                	mov    %esp,%ebp
  80276f:	56                   	push   %esi
  802770:	53                   	push   %ebx
  802771:	83 ec 20             	sub    $0x20,%esp
  802774:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802777:	89 34 24             	mov    %esi,(%esp)
  80277a:	e8 51 ee ff ff       	call   8015d0 <strlen>
		return -E_BAD_PATH;
  80277f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802784:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802789:	7f 5e                	jg     8027e9 <open+0x7d>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80278b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80278e:	89 04 24             	mov    %eax,(%esp)
  802791:	e8 35 f8 ff ff       	call   801fcb <fd_alloc>
  802796:	89 c3                	mov    %eax,%ebx
  802798:	85 c0                	test   %eax,%eax
  80279a:	78 4d                	js     8027e9 <open+0x7d>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80279c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027a0:	c7 04 24 00 a0 80 00 	movl   $0x80a000,(%esp)
  8027a7:	e8 6f ee ff ff       	call   80161b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8027ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027af:	a3 00 a4 80 00       	mov    %eax,0x80a400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8027b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8027bc:	e8 1f fe ff ff       	call   8025e0 <fsipc>
  8027c1:	89 c3                	mov    %eax,%ebx
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	79 15                	jns    8027dc <open+0x70>
		fd_close(fd, 0);
  8027c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8027ce:	00 
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	89 04 24             	mov    %eax,(%esp)
  8027d5:	e8 21 f9 ff ff       	call   8020fb <fd_close>
		return r;
  8027da:	eb 0d                	jmp    8027e9 <open+0x7d>
	}

	return fd2num(fd);
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	89 04 24             	mov    %eax,(%esp)
  8027e2:	e8 b9 f7 ff ff       	call   801fa0 <fd2num>
  8027e7:	89 c3                	mov    %eax,%ebx
}
  8027e9:	89 d8                	mov    %ebx,%eax
  8027eb:	83 c4 20             	add    $0x20,%esp
  8027ee:	5b                   	pop    %ebx
  8027ef:	5e                   	pop    %esi
  8027f0:	5d                   	pop    %ebp
  8027f1:	c3                   	ret    
	...

008027f4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027fa:	89 d0                	mov    %edx,%eax
  8027fc:	c1 e8 16             	shr    $0x16,%eax
  8027ff:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802806:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80280b:	f6 c1 01             	test   $0x1,%cl
  80280e:	74 1d                	je     80282d <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802810:	c1 ea 0c             	shr    $0xc,%edx
  802813:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80281a:	f6 c2 01             	test   $0x1,%dl
  80281d:	74 0e                	je     80282d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80281f:	c1 ea 0c             	shr    $0xc,%edx
  802822:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802829:	ef 
  80282a:	0f b7 c0             	movzwl %ax,%eax
}
  80282d:	5d                   	pop    %ebp
  80282e:	c3                   	ret    
	...

00802830 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
  802833:	83 ec 18             	sub    $0x18,%esp
  802836:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802839:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80283c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	89 04 24             	mov    %eax,(%esp)
  802845:	e8 66 f7 ff ff       	call   801fb0 <fd2data>
  80284a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80284c:	c7 44 24 04 12 37 80 	movl   $0x803712,0x4(%esp)
  802853:	00 
  802854:	89 34 24             	mov    %esi,(%esp)
  802857:	e8 bf ed ff ff       	call   80161b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80285c:	8b 43 04             	mov    0x4(%ebx),%eax
  80285f:	2b 03                	sub    (%ebx),%eax
  802861:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802867:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80286e:	00 00 00 
	stat->st_dev = &devpipe;
  802871:	c7 86 88 00 00 00 60 	movl   $0x808060,0x88(%esi)
  802878:	80 80 00 
	return 0;
}
  80287b:	b8 00 00 00 00       	mov    $0x0,%eax
  802880:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802883:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802886:	89 ec                	mov    %ebp,%esp
  802888:	5d                   	pop    %ebp
  802889:	c3                   	ret    

0080288a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
  80288d:	53                   	push   %ebx
  80288e:	83 ec 14             	sub    $0x14,%esp
  802891:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802894:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802898:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80289f:	e8 35 f3 ff ff       	call   801bd9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8028a4:	89 1c 24             	mov    %ebx,(%esp)
  8028a7:	e8 04 f7 ff ff       	call   801fb0 <fd2data>
  8028ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028b7:	e8 1d f3 ff ff       	call   801bd9 <sys_page_unmap>
}
  8028bc:	83 c4 14             	add    $0x14,%esp
  8028bf:	5b                   	pop    %ebx
  8028c0:	5d                   	pop    %ebp
  8028c1:	c3                   	ret    

008028c2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
  8028c5:	57                   	push   %edi
  8028c6:	56                   	push   %esi
  8028c7:	53                   	push   %ebx
  8028c8:	83 ec 2c             	sub    $0x2c,%esp
  8028cb:	89 c7                	mov    %eax,%edi
  8028cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8028d0:	a1 0c 90 80 00       	mov    0x80900c,%eax
  8028d5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8028d8:	89 3c 24             	mov    %edi,(%esp)
  8028db:	e8 14 ff ff ff       	call   8027f4 <pageref>
  8028e0:	89 c6                	mov    %eax,%esi
  8028e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e5:	89 04 24             	mov    %eax,(%esp)
  8028e8:	e8 07 ff ff ff       	call   8027f4 <pageref>
  8028ed:	39 c6                	cmp    %eax,%esi
  8028ef:	0f 94 c0             	sete   %al
  8028f2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8028f5:	8b 15 0c 90 80 00    	mov    0x80900c,%edx
  8028fb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8028fe:	39 cb                	cmp    %ecx,%ebx
  802900:	75 08                	jne    80290a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  802902:	83 c4 2c             	add    $0x2c,%esp
  802905:	5b                   	pop    %ebx
  802906:	5e                   	pop    %esi
  802907:	5f                   	pop    %edi
  802908:	5d                   	pop    %ebp
  802909:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80290a:	83 f8 01             	cmp    $0x1,%eax
  80290d:	75 c1                	jne    8028d0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80290f:	8b 52 58             	mov    0x58(%edx),%edx
  802912:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802916:	89 54 24 08          	mov    %edx,0x8(%esp)
  80291a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80291e:	c7 04 24 19 37 80 00 	movl   $0x803719,(%esp)
  802925:	e8 d9 e6 ff ff       	call   801003 <cprintf>
  80292a:	eb a4                	jmp    8028d0 <_pipeisclosed+0xe>

0080292c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	57                   	push   %edi
  802930:	56                   	push   %esi
  802931:	53                   	push   %ebx
  802932:	83 ec 2c             	sub    $0x2c,%esp
  802935:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802938:	89 34 24             	mov    %esi,(%esp)
  80293b:	e8 70 f6 ff ff       	call   801fb0 <fd2data>
  802940:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802942:	bf 00 00 00 00       	mov    $0x0,%edi
  802947:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80294b:	75 50                	jne    80299d <devpipe_write+0x71>
  80294d:	eb 5c                	jmp    8029ab <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80294f:	89 da                	mov    %ebx,%edx
  802951:	89 f0                	mov    %esi,%eax
  802953:	e8 6a ff ff ff       	call   8028c2 <_pipeisclosed>
  802958:	85 c0                	test   %eax,%eax
  80295a:	75 53                	jne    8029af <devpipe_write+0x83>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80295c:	e8 8b f1 ff ff       	call   801aec <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802961:	8b 43 04             	mov    0x4(%ebx),%eax
  802964:	8b 13                	mov    (%ebx),%edx
  802966:	83 c2 20             	add    $0x20,%edx
  802969:	39 d0                	cmp    %edx,%eax
  80296b:	73 e2                	jae    80294f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80296d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802970:	0f b6 14 3a          	movzbl (%edx,%edi,1),%edx
  802974:	88 55 e7             	mov    %dl,-0x19(%ebp)
  802977:	89 c2                	mov    %eax,%edx
  802979:	c1 fa 1f             	sar    $0x1f,%edx
  80297c:	c1 ea 1b             	shr    $0x1b,%edx
  80297f:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802982:	83 e1 1f             	and    $0x1f,%ecx
  802985:	29 d1                	sub    %edx,%ecx
  802987:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80298b:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  80298f:	83 c0 01             	add    $0x1,%eax
  802992:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802995:	83 c7 01             	add    $0x1,%edi
  802998:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80299b:	74 0e                	je     8029ab <devpipe_write+0x7f>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80299d:	8b 43 04             	mov    0x4(%ebx),%eax
  8029a0:	8b 13                	mov    (%ebx),%edx
  8029a2:	83 c2 20             	add    $0x20,%edx
  8029a5:	39 d0                	cmp    %edx,%eax
  8029a7:	73 a6                	jae    80294f <devpipe_write+0x23>
  8029a9:	eb c2                	jmp    80296d <devpipe_write+0x41>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8029ab:	89 f8                	mov    %edi,%eax
  8029ad:	eb 05                	jmp    8029b4 <devpipe_write+0x88>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8029af:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8029b4:	83 c4 2c             	add    $0x2c,%esp
  8029b7:	5b                   	pop    %ebx
  8029b8:	5e                   	pop    %esi
  8029b9:	5f                   	pop    %edi
  8029ba:	5d                   	pop    %ebp
  8029bb:	c3                   	ret    

008029bc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8029bc:	55                   	push   %ebp
  8029bd:	89 e5                	mov    %esp,%ebp
  8029bf:	83 ec 28             	sub    $0x28,%esp
  8029c2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8029c5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8029c8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8029cb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8029ce:	89 3c 24             	mov    %edi,(%esp)
  8029d1:	e8 da f5 ff ff       	call   801fb0 <fd2data>
  8029d6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029d8:	be 00 00 00 00       	mov    $0x0,%esi
  8029dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029e1:	75 47                	jne    802a2a <devpipe_read+0x6e>
  8029e3:	eb 52                	jmp    802a37 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8029e5:	89 f0                	mov    %esi,%eax
  8029e7:	eb 5e                	jmp    802a47 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8029e9:	89 da                	mov    %ebx,%edx
  8029eb:	89 f8                	mov    %edi,%eax
  8029ed:	8d 76 00             	lea    0x0(%esi),%esi
  8029f0:	e8 cd fe ff ff       	call   8028c2 <_pipeisclosed>
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	75 49                	jne    802a42 <devpipe_read+0x86>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8029f9:	e8 ee f0 ff ff       	call   801aec <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8029fe:	8b 03                	mov    (%ebx),%eax
  802a00:	3b 43 04             	cmp    0x4(%ebx),%eax
  802a03:	74 e4                	je     8029e9 <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802a05:	89 c2                	mov    %eax,%edx
  802a07:	c1 fa 1f             	sar    $0x1f,%edx
  802a0a:	c1 ea 1b             	shr    $0x1b,%edx
  802a0d:	01 d0                	add    %edx,%eax
  802a0f:	83 e0 1f             	and    $0x1f,%eax
  802a12:	29 d0                	sub    %edx,%eax
  802a14:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a1c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802a1f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a22:	83 c6 01             	add    $0x1,%esi
  802a25:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a28:	74 0d                	je     802a37 <devpipe_read+0x7b>
		while (p->p_rpos == p->p_wpos) {
  802a2a:	8b 03                	mov    (%ebx),%eax
  802a2c:	3b 43 04             	cmp    0x4(%ebx),%eax
  802a2f:	75 d4                	jne    802a05 <devpipe_read+0x49>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802a31:	85 f6                	test   %esi,%esi
  802a33:	75 b0                	jne    8029e5 <devpipe_read+0x29>
  802a35:	eb b2                	jmp    8029e9 <devpipe_read+0x2d>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802a37:	89 f0                	mov    %esi,%eax
  802a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a40:	eb 05                	jmp    802a47 <devpipe_read+0x8b>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802a42:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802a47:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802a4a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802a4d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802a50:	89 ec                	mov    %ebp,%esp
  802a52:	5d                   	pop    %ebp
  802a53:	c3                   	ret    

00802a54 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
  802a57:	83 ec 48             	sub    $0x48,%esp
  802a5a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802a5d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a60:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802a63:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a66:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802a69:	89 04 24             	mov    %eax,(%esp)
  802a6c:	e8 5a f5 ff ff       	call   801fcb <fd_alloc>
  802a71:	89 c3                	mov    %eax,%ebx
  802a73:	85 c0                	test   %eax,%eax
  802a75:	0f 88 45 01 00 00    	js     802bc0 <pipe+0x16c>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a7b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a82:	00 
  802a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a86:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a91:	e8 86 f0 ff ff       	call   801b1c <sys_page_alloc>
  802a96:	89 c3                	mov    %eax,%ebx
  802a98:	85 c0                	test   %eax,%eax
  802a9a:	0f 88 20 01 00 00    	js     802bc0 <pipe+0x16c>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802aa0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802aa3:	89 04 24             	mov    %eax,(%esp)
  802aa6:	e8 20 f5 ff ff       	call   801fcb <fd_alloc>
  802aab:	89 c3                	mov    %eax,%ebx
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	0f 88 f8 00 00 00    	js     802bad <pipe+0x159>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ab5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802abc:	00 
  802abd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ac4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802acb:	e8 4c f0 ff ff       	call   801b1c <sys_page_alloc>
  802ad0:	89 c3                	mov    %eax,%ebx
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	0f 88 d3 00 00 00    	js     802bad <pipe+0x159>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802ada:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802add:	89 04 24             	mov    %eax,(%esp)
  802ae0:	e8 cb f4 ff ff       	call   801fb0 <fd2data>
  802ae5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ae7:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802aee:	00 
  802aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802afa:	e8 1d f0 ff ff       	call   801b1c <sys_page_alloc>
  802aff:	89 c3                	mov    %eax,%ebx
  802b01:	85 c0                	test   %eax,%eax
  802b03:	0f 88 91 00 00 00    	js     802b9a <pipe+0x146>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0c:	89 04 24             	mov    %eax,(%esp)
  802b0f:	e8 9c f4 ff ff       	call   801fb0 <fd2data>
  802b14:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802b1b:	00 
  802b1c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b20:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802b27:	00 
  802b28:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b33:	e8 43 f0 ff ff       	call   801b7b <sys_page_map>
  802b38:	89 c3                	mov    %eax,%ebx
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	78 4c                	js     802b8a <pipe+0x136>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802b3e:	8b 15 60 80 80 00    	mov    0x808060,%edx
  802b44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b47:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802b53:	8b 15 60 80 80 00    	mov    0x808060,%edx
  802b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802b5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b61:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6b:	89 04 24             	mov    %eax,(%esp)
  802b6e:	e8 2d f4 ff ff       	call   801fa0 <fd2num>
  802b73:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b78:	89 04 24             	mov    %eax,(%esp)
  802b7b:	e8 20 f4 ff ff       	call   801fa0 <fd2num>
  802b80:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802b83:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b88:	eb 36                	jmp    802bc0 <pipe+0x16c>

    err3:
	sys_page_unmap(0, va);
  802b8a:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b95:	e8 3f f0 ff ff       	call   801bd9 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802b9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ba1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ba8:	e8 2c f0 ff ff       	call   801bd9 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802bad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bb4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bbb:	e8 19 f0 ff ff       	call   801bd9 <sys_page_unmap>
    err:
	return r;
}
  802bc0:	89 d8                	mov    %ebx,%eax
  802bc2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802bc5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802bc8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802bcb:	89 ec                	mov    %ebp,%esp
  802bcd:	5d                   	pop    %ebp
  802bce:	c3                   	ret    

00802bcf <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802bcf:	55                   	push   %ebp
  802bd0:	89 e5                	mov    %esp,%ebp
  802bd2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	89 04 24             	mov    %eax,(%esp)
  802be2:	e8 57 f4 ff ff       	call   80203e <fd_lookup>
  802be7:	85 c0                	test   %eax,%eax
  802be9:	78 15                	js     802c00 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	89 04 24             	mov    %eax,(%esp)
  802bf1:	e8 ba f3 ff ff       	call   801fb0 <fd2data>
	return _pipeisclosed(fd, p);
  802bf6:	89 c2                	mov    %eax,%edx
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	e8 c2 fc ff ff       	call   8028c2 <_pipeisclosed>
}
  802c00:	c9                   	leave  
  802c01:	c3                   	ret    
	...

00802c10 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802c10:	55                   	push   %ebp
  802c11:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802c13:	b8 00 00 00 00       	mov    $0x0,%eax
  802c18:	5d                   	pop    %ebp
  802c19:	c3                   	ret    

00802c1a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802c1a:	55                   	push   %ebp
  802c1b:	89 e5                	mov    %esp,%ebp
  802c1d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802c20:	c7 44 24 04 31 37 80 	movl   $0x803731,0x4(%esp)
  802c27:	00 
  802c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c2b:	89 04 24             	mov    %eax,(%esp)
  802c2e:	e8 e8 e9 ff ff       	call   80161b <strcpy>
	return 0;
}
  802c33:	b8 00 00 00 00       	mov    $0x0,%eax
  802c38:	c9                   	leave  
  802c39:	c3                   	ret    

00802c3a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802c3a:	55                   	push   %ebp
  802c3b:	89 e5                	mov    %esp,%ebp
  802c3d:	57                   	push   %edi
  802c3e:	56                   	push   %esi
  802c3f:	53                   	push   %ebx
  802c40:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802c46:	be 00 00 00 00       	mov    $0x0,%esi
  802c4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802c4f:	74 43                	je     802c94 <devcons_write+0x5a>
  802c51:	b8 00 00 00 00       	mov    $0x0,%eax
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802c56:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802c5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802c5f:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802c61:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802c64:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802c69:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802c6c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c70:	03 45 0c             	add    0xc(%ebp),%eax
  802c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c77:	89 3c 24             	mov    %edi,(%esp)
  802c7a:	e8 8d eb ff ff       	call   80180c <memmove>
		sys_cputs(buf, m);
  802c7f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802c83:	89 3c 24             	mov    %edi,(%esp)
  802c86:	e8 75 ed ff ff       	call   801a00 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802c8b:	01 de                	add    %ebx,%esi
  802c8d:	89 f0                	mov    %esi,%eax
  802c8f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802c92:	72 c8                	jb     802c5c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802c94:	89 f0                	mov    %esi,%eax
  802c96:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802c9c:	5b                   	pop    %ebx
  802c9d:	5e                   	pop    %esi
  802c9e:	5f                   	pop    %edi
  802c9f:	5d                   	pop    %ebp
  802ca0:	c3                   	ret    

00802ca1 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802ca1:	55                   	push   %ebp
  802ca2:	89 e5                	mov    %esp,%ebp
  802ca4:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802ca7:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802cac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802cb0:	75 07                	jne    802cb9 <devcons_read+0x18>
  802cb2:	eb 31                	jmp    802ce5 <devcons_read+0x44>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802cb4:	e8 33 ee ff ff       	call   801aec <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cc0:	e8 6a ed ff ff       	call   801a2f <sys_cgetc>
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	74 eb                	je     802cb4 <devcons_read+0x13>
  802cc9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802ccb:	85 c0                	test   %eax,%eax
  802ccd:	78 16                	js     802ce5 <devcons_read+0x44>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802ccf:	83 f8 04             	cmp    $0x4,%eax
  802cd2:	74 0c                	je     802ce0 <devcons_read+0x3f>
		return 0;
	*(char*)vbuf = c;
  802cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd7:	88 10                	mov    %dl,(%eax)
	return 1;
  802cd9:	b8 01 00 00 00       	mov    $0x1,%eax
  802cde:	eb 05                	jmp    802ce5 <devcons_read+0x44>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802ce0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802ce5:	c9                   	leave  
  802ce6:	c3                   	ret    

00802ce7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802ce7:	55                   	push   %ebp
  802ce8:	89 e5                	mov    %esp,%ebp
  802cea:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802cf3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802cfa:	00 
  802cfb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802cfe:	89 04 24             	mov    %eax,(%esp)
  802d01:	e8 fa ec ff ff       	call   801a00 <sys_cputs>
}
  802d06:	c9                   	leave  
  802d07:	c3                   	ret    

00802d08 <getchar>:

int
getchar(void)
{
  802d08:	55                   	push   %ebp
  802d09:	89 e5                	mov    %esp,%ebp
  802d0b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802d0e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802d15:	00 
  802d16:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d24:	e8 d5 f5 ff ff       	call   8022fe <read>
	if (r < 0)
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	78 0f                	js     802d3c <getchar+0x34>
		return r;
	if (r < 1)
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	7e 06                	jle    802d37 <getchar+0x2f>
		return -E_EOF;
	return c;
  802d31:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802d35:	eb 05                	jmp    802d3c <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802d37:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802d3c:	c9                   	leave  
  802d3d:	c3                   	ret    

00802d3e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802d3e:	55                   	push   %ebp
  802d3f:	89 e5                	mov    %esp,%ebp
  802d41:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	89 04 24             	mov    %eax,(%esp)
  802d51:	e8 e8 f2 ff ff       	call   80203e <fd_lookup>
  802d56:	85 c0                	test   %eax,%eax
  802d58:	78 11                	js     802d6b <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 15 7c 80 80 00    	mov    0x80807c,%edx
  802d63:	39 10                	cmp    %edx,(%eax)
  802d65:	0f 94 c0             	sete   %al
  802d68:	0f b6 c0             	movzbl %al,%eax
}
  802d6b:	c9                   	leave  
  802d6c:	c3                   	ret    

00802d6d <opencons>:

int
opencons(void)
{
  802d6d:	55                   	push   %ebp
  802d6e:	89 e5                	mov    %esp,%ebp
  802d70:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802d73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d76:	89 04 24             	mov    %eax,(%esp)
  802d79:	e8 4d f2 ff ff       	call   801fcb <fd_alloc>
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	78 3c                	js     802dbe <opencons+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802d82:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d89:	00 
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d98:	e8 7f ed ff ff       	call   801b1c <sys_page_alloc>
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	78 1d                	js     802dbe <opencons+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802da1:	8b 15 7c 80 80 00    	mov    0x80807c,%edx
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802db6:	89 04 24             	mov    %eax,(%esp)
  802db9:	e8 e2 f1 ff ff       	call   801fa0 <fd2num>
}
  802dbe:	c9                   	leave  
  802dbf:	c3                   	ret    

00802dc0 <__udivdi3>:
  802dc0:	83 ec 1c             	sub    $0x1c,%esp
  802dc3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802dc7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  802dcb:	8b 44 24 20          	mov    0x20(%esp),%eax
  802dcf:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802dd3:	89 74 24 10          	mov    %esi,0x10(%esp)
  802dd7:	8b 74 24 24          	mov    0x24(%esp),%esi
  802ddb:	85 ff                	test   %edi,%edi
  802ddd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802de1:	89 44 24 08          	mov    %eax,0x8(%esp)
  802de5:	89 cd                	mov    %ecx,%ebp
  802de7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802deb:	75 33                	jne    802e20 <__udivdi3+0x60>
  802ded:	39 f1                	cmp    %esi,%ecx
  802def:	77 57                	ja     802e48 <__udivdi3+0x88>
  802df1:	85 c9                	test   %ecx,%ecx
  802df3:	75 0b                	jne    802e00 <__udivdi3+0x40>
  802df5:	b8 01 00 00 00       	mov    $0x1,%eax
  802dfa:	31 d2                	xor    %edx,%edx
  802dfc:	f7 f1                	div    %ecx
  802dfe:	89 c1                	mov    %eax,%ecx
  802e00:	89 f0                	mov    %esi,%eax
  802e02:	31 d2                	xor    %edx,%edx
  802e04:	f7 f1                	div    %ecx
  802e06:	89 c6                	mov    %eax,%esi
  802e08:	8b 44 24 04          	mov    0x4(%esp),%eax
  802e0c:	f7 f1                	div    %ecx
  802e0e:	89 f2                	mov    %esi,%edx
  802e10:	8b 74 24 10          	mov    0x10(%esp),%esi
  802e14:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802e18:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802e1c:	83 c4 1c             	add    $0x1c,%esp
  802e1f:	c3                   	ret    
  802e20:	31 d2                	xor    %edx,%edx
  802e22:	31 c0                	xor    %eax,%eax
  802e24:	39 f7                	cmp    %esi,%edi
  802e26:	77 e8                	ja     802e10 <__udivdi3+0x50>
  802e28:	0f bd cf             	bsr    %edi,%ecx
  802e2b:	83 f1 1f             	xor    $0x1f,%ecx
  802e2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e32:	75 2c                	jne    802e60 <__udivdi3+0xa0>
  802e34:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802e38:	76 04                	jbe    802e3e <__udivdi3+0x7e>
  802e3a:	39 f7                	cmp    %esi,%edi
  802e3c:	73 d2                	jae    802e10 <__udivdi3+0x50>
  802e3e:	31 d2                	xor    %edx,%edx
  802e40:	b8 01 00 00 00       	mov    $0x1,%eax
  802e45:	eb c9                	jmp    802e10 <__udivdi3+0x50>
  802e47:	90                   	nop
  802e48:	89 f2                	mov    %esi,%edx
  802e4a:	f7 f1                	div    %ecx
  802e4c:	31 d2                	xor    %edx,%edx
  802e4e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802e52:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802e56:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802e5a:	83 c4 1c             	add    $0x1c,%esp
  802e5d:	c3                   	ret    
  802e5e:	66 90                	xchg   %ax,%ax
  802e60:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e65:	b8 20 00 00 00       	mov    $0x20,%eax
  802e6a:	89 ea                	mov    %ebp,%edx
  802e6c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802e70:	d3 e7                	shl    %cl,%edi
  802e72:	89 c1                	mov    %eax,%ecx
  802e74:	d3 ea                	shr    %cl,%edx
  802e76:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e7b:	09 fa                	or     %edi,%edx
  802e7d:	89 f7                	mov    %esi,%edi
  802e7f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802e83:	89 f2                	mov    %esi,%edx
  802e85:	8b 74 24 08          	mov    0x8(%esp),%esi
  802e89:	d3 e5                	shl    %cl,%ebp
  802e8b:	89 c1                	mov    %eax,%ecx
  802e8d:	d3 ef                	shr    %cl,%edi
  802e8f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e94:	d3 e2                	shl    %cl,%edx
  802e96:	89 c1                	mov    %eax,%ecx
  802e98:	d3 ee                	shr    %cl,%esi
  802e9a:	09 d6                	or     %edx,%esi
  802e9c:	89 fa                	mov    %edi,%edx
  802e9e:	89 f0                	mov    %esi,%eax
  802ea0:	f7 74 24 0c          	divl   0xc(%esp)
  802ea4:	89 d7                	mov    %edx,%edi
  802ea6:	89 c6                	mov    %eax,%esi
  802ea8:	f7 e5                	mul    %ebp
  802eaa:	39 d7                	cmp    %edx,%edi
  802eac:	72 22                	jb     802ed0 <__udivdi3+0x110>
  802eae:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802eb2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802eb7:	d3 e5                	shl    %cl,%ebp
  802eb9:	39 c5                	cmp    %eax,%ebp
  802ebb:	73 04                	jae    802ec1 <__udivdi3+0x101>
  802ebd:	39 d7                	cmp    %edx,%edi
  802ebf:	74 0f                	je     802ed0 <__udivdi3+0x110>
  802ec1:	89 f0                	mov    %esi,%eax
  802ec3:	31 d2                	xor    %edx,%edx
  802ec5:	e9 46 ff ff ff       	jmp    802e10 <__udivdi3+0x50>
  802eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ed0:	8d 46 ff             	lea    -0x1(%esi),%eax
  802ed3:	31 d2                	xor    %edx,%edx
  802ed5:	8b 74 24 10          	mov    0x10(%esp),%esi
  802ed9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802edd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802ee1:	83 c4 1c             	add    $0x1c,%esp
  802ee4:	c3                   	ret    
	...

00802ef0 <__umoddi3>:
  802ef0:	83 ec 1c             	sub    $0x1c,%esp
  802ef3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802ef7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  802efb:	8b 44 24 20          	mov    0x20(%esp),%eax
  802eff:	89 74 24 10          	mov    %esi,0x10(%esp)
  802f03:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802f07:	8b 74 24 24          	mov    0x24(%esp),%esi
  802f0b:	85 ed                	test   %ebp,%ebp
  802f0d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802f11:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f15:	89 cf                	mov    %ecx,%edi
  802f17:	89 04 24             	mov    %eax,(%esp)
  802f1a:	89 f2                	mov    %esi,%edx
  802f1c:	75 1a                	jne    802f38 <__umoddi3+0x48>
  802f1e:	39 f1                	cmp    %esi,%ecx
  802f20:	76 4e                	jbe    802f70 <__umoddi3+0x80>
  802f22:	f7 f1                	div    %ecx
  802f24:	89 d0                	mov    %edx,%eax
  802f26:	31 d2                	xor    %edx,%edx
  802f28:	8b 74 24 10          	mov    0x10(%esp),%esi
  802f2c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802f30:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802f34:	83 c4 1c             	add    $0x1c,%esp
  802f37:	c3                   	ret    
  802f38:	39 f5                	cmp    %esi,%ebp
  802f3a:	77 54                	ja     802f90 <__umoddi3+0xa0>
  802f3c:	0f bd c5             	bsr    %ebp,%eax
  802f3f:	83 f0 1f             	xor    $0x1f,%eax
  802f42:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f46:	75 60                	jne    802fa8 <__umoddi3+0xb8>
  802f48:	3b 0c 24             	cmp    (%esp),%ecx
  802f4b:	0f 87 07 01 00 00    	ja     803058 <__umoddi3+0x168>
  802f51:	89 f2                	mov    %esi,%edx
  802f53:	8b 34 24             	mov    (%esp),%esi
  802f56:	29 ce                	sub    %ecx,%esi
  802f58:	19 ea                	sbb    %ebp,%edx
  802f5a:	89 34 24             	mov    %esi,(%esp)
  802f5d:	8b 04 24             	mov    (%esp),%eax
  802f60:	8b 74 24 10          	mov    0x10(%esp),%esi
  802f64:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802f68:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802f6c:	83 c4 1c             	add    $0x1c,%esp
  802f6f:	c3                   	ret    
  802f70:	85 c9                	test   %ecx,%ecx
  802f72:	75 0b                	jne    802f7f <__umoddi3+0x8f>
  802f74:	b8 01 00 00 00       	mov    $0x1,%eax
  802f79:	31 d2                	xor    %edx,%edx
  802f7b:	f7 f1                	div    %ecx
  802f7d:	89 c1                	mov    %eax,%ecx
  802f7f:	89 f0                	mov    %esi,%eax
  802f81:	31 d2                	xor    %edx,%edx
  802f83:	f7 f1                	div    %ecx
  802f85:	8b 04 24             	mov    (%esp),%eax
  802f88:	f7 f1                	div    %ecx
  802f8a:	eb 98                	jmp    802f24 <__umoddi3+0x34>
  802f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f90:	89 f2                	mov    %esi,%edx
  802f92:	8b 74 24 10          	mov    0x10(%esp),%esi
  802f96:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802f9a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802f9e:	83 c4 1c             	add    $0x1c,%esp
  802fa1:	c3                   	ret    
  802fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802fa8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802fad:	89 e8                	mov    %ebp,%eax
  802faf:	bd 20 00 00 00       	mov    $0x20,%ebp
  802fb4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802fb8:	89 fa                	mov    %edi,%edx
  802fba:	d3 e0                	shl    %cl,%eax
  802fbc:	89 e9                	mov    %ebp,%ecx
  802fbe:	d3 ea                	shr    %cl,%edx
  802fc0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802fc5:	09 c2                	or     %eax,%edx
  802fc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fcb:	89 14 24             	mov    %edx,(%esp)
  802fce:	89 f2                	mov    %esi,%edx
  802fd0:	d3 e7                	shl    %cl,%edi
  802fd2:	89 e9                	mov    %ebp,%ecx
  802fd4:	d3 ea                	shr    %cl,%edx
  802fd6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802fdb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802fdf:	d3 e6                	shl    %cl,%esi
  802fe1:	89 e9                	mov    %ebp,%ecx
  802fe3:	d3 e8                	shr    %cl,%eax
  802fe5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802fea:	09 f0                	or     %esi,%eax
  802fec:	8b 74 24 08          	mov    0x8(%esp),%esi
  802ff0:	f7 34 24             	divl   (%esp)
  802ff3:	d3 e6                	shl    %cl,%esi
  802ff5:	89 74 24 08          	mov    %esi,0x8(%esp)
  802ff9:	89 d6                	mov    %edx,%esi
  802ffb:	f7 e7                	mul    %edi
  802ffd:	39 d6                	cmp    %edx,%esi
  802fff:	89 c1                	mov    %eax,%ecx
  803001:	89 d7                	mov    %edx,%edi
  803003:	72 3f                	jb     803044 <__umoddi3+0x154>
  803005:	39 44 24 08          	cmp    %eax,0x8(%esp)
  803009:	72 35                	jb     803040 <__umoddi3+0x150>
  80300b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80300f:	29 c8                	sub    %ecx,%eax
  803011:	19 fe                	sbb    %edi,%esi
  803013:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803018:	89 f2                	mov    %esi,%edx
  80301a:	d3 e8                	shr    %cl,%eax
  80301c:	89 e9                	mov    %ebp,%ecx
  80301e:	d3 e2                	shl    %cl,%edx
  803020:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803025:	09 d0                	or     %edx,%eax
  803027:	89 f2                	mov    %esi,%edx
  803029:	d3 ea                	shr    %cl,%edx
  80302b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80302f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  803033:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  803037:	83 c4 1c             	add    $0x1c,%esp
  80303a:	c3                   	ret    
  80303b:	90                   	nop
  80303c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803040:	39 d6                	cmp    %edx,%esi
  803042:	75 c7                	jne    80300b <__umoddi3+0x11b>
  803044:	89 d7                	mov    %edx,%edi
  803046:	89 c1                	mov    %eax,%ecx
  803048:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80304c:	1b 3c 24             	sbb    (%esp),%edi
  80304f:	eb ba                	jmp    80300b <__umoddi3+0x11b>
  803051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803058:	39 f5                	cmp    %esi,%ebp
  80305a:	0f 82 f1 fe ff ff    	jb     802f51 <__umoddi3+0x61>
  803060:	e9 f8 fe ff ff       	jmp    802f5d <__umoddi3+0x6d>
