
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
		panic("bad block number %08x in diskaddr", blockno);
	return (char*) (DISKMAP + blockno * BLKSIZE);
}


// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
    return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
}

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
    return (uvpt[PGNUM(va)] & PTE_D) != 0;
}


// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
		panic("reading non-existent block %08x\n", blockno);

	// Allocate a page in the disk map region, read the contents
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//
	// LAB 5: you code here:
	addr = ROUNDDOWN(addr, PGSIZE);
	sys_page_alloc(0, addr, PTE_P | PTE_W |PTE_U);
	ide_read(blockno*BLKSECTS, addr, BLKSECTS);
}

// Flush the contents of the block containing VA out to disk if
// necessary, then clear the PTE_D bit using sys_page_map.
// If the block is not in the block cache or is not dirty, does
// nothing.
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
    addr             = (void *) ROUNDDOWN(addr, PGSIZE);
    uint32_t sectno  = ((uint32_t)addr - DISKMAP) / SECTSIZE;
    uint32_t blockno = (sectno / BLKSECTS);

    if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
        panic("flush_block of bad va %08x", addr);

    // LAB 5: Your code here.
    if(va_is_dirty(addr) && va_is_mapped(addr)) {
        ide_write(sectno, addr, BLKSECTS);
        sys_page_map(0, addr, 
                     0, addr,
                     (PTE_SYSCALL));
       // BC_DEBUG("Wrote block %08x, now mapped r/o\n", blockno);
    }
}

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
    cprintf("Starting..\n");
    struct Super backup;

    // back up super block
    memmove(&backup, diskaddr(1), sizeof(backup));
//    BC_DEBUG("Wrote superblock to disk ram block..\n");
//    BC_DEBUG("in memory magic number: %08x\n", ((struct Super*)diskaddr(1))->s_magic);

    // smash it
    strcpy(diskaddr(1), "OOPS!\n");
    flush_block(diskaddr(1));
    assert(va_is_mapped(diskaddr(1)));
    assert(!va_is_dirty(diskaddr(1)));
    cprintf("Smashed disk superblock..\n");

    // clear it out
    sys_page_unmap(0, diskaddr(1));
    assert(!va_is_mapped(diskaddr(1)));
    cprintf("Unmapped superblock va..\n");

    // read it back in
    assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
    cprintf("re-read superblock va..\n");

    // fix it
    memmove(diskaddr(1), &backup, sizeof(backup));
    assert(memcmp(diskaddr(1), &backup, sizeof(backup)) == 0);
    
    flush_block(diskaddr(1));

    assert(memcmp(diskaddr(1), &backup, sizeof(backup)) == 0);
//    BC_DEBUG("backup magic number   : %08x\n", backup.s_magic);
//    BC_DEBUG("in memory magic number: %08x\n", ((struct Super*)diskaddr(1))->s_magic);
//    BC_DEBUG("expected magic value  : %08x\n", FS_MAGIC);
    cprintf("Fixed superblock..\n");

    cprintf("block cache is good\n");
}



void
bc_init(void)
{
	struct Super super;
	set_pgfault_handler(bc_pgfault);

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
}

