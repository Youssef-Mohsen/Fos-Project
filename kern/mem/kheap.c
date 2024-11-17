#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"



//Initialize the dynamic allocator of kernel heap with the given start address, size & limit
//All pages in the given range should be allocated
//Remember: call the initialize_dynamic_allocator(..) to complete the initialization
//Return:
//	On success: 0
//	Otherwise (if no memory OR initial size exceed the given limit): PANIC
int initialize_kheap_dynamic_allocator(uint32 daStart, uint32 initSizeToAllocate, uint32 daLimit)
{
	//TODO: [PROJECT'24.MS2 - #01] [1] KERNEL HEAP - initialize_kheap_dynamic_allocator
	// Write your code here, remove the panic and write your code
	//panic("initialize_kheap_dynamic_allocator() is not implemented yet...!!");
	start = daStart;
	hard_limit = daLimit;
	brk = daStart + initSizeToAllocate;

	if(brk > daLimit) panic("exceeds Limit");

	 struct FrameInfo * start_block_area = (struct FrameInfo*) KERNEL_HEAP_START;
	 struct FrameInfo * end_block_area = (struct FrameInfo*) daLimit;

	 /*struct FrameInfo * start_page_area = (struct FrameInfo*) (daLimit + PAGE_SIZE);
	 struct FrameInfo * end_page_area = (struct FrameInfo*) KERNEL_HEAP_MAX;*/

	 uint32 page_area_size = initSizeToAllocate;
	 uint32 no_pages = page_area_size / (uint32)PAGE_SIZE;


	 for(int i=0;i<no_pages;i++)
	 {
		 struct FrameInfo * ptr_frame;
		int ret = allocate_frame(&ptr_frame);
		if(ret != E_NO_MEM)
		{
			map_frame(ptr_page_directory,ptr_frame,(uint32)start_block_area+i*PAGE_SIZE,PERM_USER|PERM_WRITEABLE);
		}
		else
		{
			panic("No Memory");
		}

	 }
	initialize_dynamic_allocator(daStart,initSizeToAllocate);

	return 0;
}

void* sbrk(int numOfPages)
{
	/* numOfPages > 0: move the segment break of the kernel to increase the size of its heap by the given numOfPages,
	 * 				you should allocate pages and map them into the kernel virtual address space,
	 * 				and returns the address of the previous break (i.e. the beginning of newly mapped memory).
	 * numOfPages = 0: just return the current position of the segment break
	 *
	 * NOTES:
	 * 	1) Allocating additional pages for a kernel dynamic allocator will fail if the free frames are exhausted
	 * 		or the break exceed the limit of the dynamic allocator. If sbrk fails, return -1
	 */

	//MS2: COMMENT THIS LINE BEFORE START CODING==========
	//return (void*)-1 ;
	//====================================================

	//TODO: [PROJECT'24.MS2 - #02] [1] KERNEL HEAP - sbrk
	// Write your code here, remove the panic and write your code
	//panic("sbrk() is not implemented yet...!!");
	if(numOfPages > 0)
	{
		uint32 size = numOfPages * PAGE_SIZE;
		uint32 prev_brk=brk;

		if(brk+size > hard_limit) return (void *)-1;

		for(int i=0;i<numOfPages;i++)
		{
			struct FrameInfo * ptr_frame;
			int ret = allocate_frame(&ptr_frame);
			if(ret != E_NO_MEM)
			{
				map_frame(ptr_page_directory,ptr_frame,prev_brk+i*PAGE_SIZE,PERM_USER|PERM_WRITEABLE);
			}
			else
			{
				return (void *)-1;
			}
		}
		brk += size;
		return (void *)prev_brk;

	}
	else if(numOfPages == 0)
	{
		return (void *) brk;
	}

	//panic("can't be negative");
	return (void *)-1;
}

//TODO: [PROJECT'24.MS2 - BONUS#2] [1] KERNEL HEAP - Fast Page Allocator

bool isPageAllocated(uint32 *ptr_page_directory, const uint32 virtual_address)
{

	uint32 page_permissions = pt_get_page_permissions(ptr_page_directory, virtual_address);
	//cprintf("page_permissions : %d \n",page_permissions & PERM_PRESENT);
	if ((page_permissions & PERM_PRESENT) == PERM_PRESENT)
    {
    	return 1;
    }
    return 0;

}


void *kmalloc(unsigned int size)
{
	// TODO: [PROJECT'24.MS2 - #03] [1] KERNEL HEAP - kmalloc
	//  Write your code here, remove the panic and write your code
	//kpanic_into_prompt("kmalloc() is not implemented yet...!!");
	// use "isKHeapPlacementStrategyFIRSTFIT() ..." functions to check the current strategy

	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
	uint32 max_no_of_pages = ROUNDUP((uint32)KERNEL_HEAP_MAX - hard_limit + (uint32)PAGE_SIZE ,PAGE_SIZE) / PAGE_SIZE;

	void *ptr = NULL;
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
	{
		if (isKHeapPlacementStrategyFIRSTFIT())
			return alloc_block_FF(size);
		else if (isKHeapPlacementStrategyBESTFIT())
			return alloc_block_BF(size);
	}
	else if(num_pages < max_no_of_pages - 1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		// required pages?
		uint32 no_of_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;

		uint32 i = hard_limit + (uint32)PAGE_SIZE; // start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)KERNEL_HEAP_MAX)
		{
			if (!isPageAllocated(ptr_page_directory, i)) // page not allocated?
			{
				uint32 j = i + (uint32)PAGE_SIZE; // <-- changed, was j = i + 1
				uint32 cnt = 0;
				while(cnt < no_of_pages - 1)
				{
					if(j >= (uint32)KERNEL_HEAP_MAX) return NULL;
					if (isPageAllocated(ptr_page_directory, j))
					{

						i = j;
						goto sayed;
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
			}
			sayed:
			if(ok)
			{
				break;
			}
			i += (uint32)PAGE_SIZE; // <-- changed, was i++
		}

		if(!ok) return NULL;
		for (int k = 0; k < no_of_pages; k++)
		{
			struct FrameInfo *ptr_frame_info;
			int ret = allocate_frame(&ptr_frame_info);
			//map_frame(ptr_page_directory, ptr_frame_info, i + k * 1024, PERM_USER|PERM_WRITEABLE); REPLACED BY
			if (ret != E_NO_MEM)
			{
				map_frame(ptr_page_directory, ptr_frame_info, i + k * PAGE_SIZE, PERM_PRESENT | PERM_WRITEABLE); // a3raf el page mnen

			}
			else
			{
				panic("No Memory");
			}
		}
		ptr = (void*)i;

	}
	else
	{

		return NULL;
	}
	return ptr;
}

void kfree(void *va)
{
    // TODO: [PROJECT'24.MS2 - #04] [1] KERNEL HEAP - kfree
    //  Write your code here, remove the panic and write your code
//    panic("kfree() is not implemented yet...!!");

    // you need to get the size of the given allocation using its address
    // refer to the project presentation and documentation for details
    uint32 pageA_start = hard_limit + 4096;
    if((uint32)va < hard_limit){
        free_block(va);
    }else if((uint32)va >= pageA_start && (uint32)va < KERNEL_HEAP_MAX){
        void* ptr_page_table = NULL;
        struct FrameInfo *ptr_frame_info = get_frame_info(ptr_page_directory, (uint32)va, ptr_page_table);
        unmap_frame(ptr_page_directory, (uint32)va);
        if(ptr_frame_info->references == 0){
            free_frame(ptr_frame_info);
        }
    }else{
        panic("kfree: The virtual Address is invalid");
    }

}

unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT'24.MS2 - #05] [1] KERNEL HEAP - kheap_physical_address
	// Write your code here, remove the panic and write your code
	//panic("kheap_physical_address() is not implemented yet...!!");

	//return the physical address corresponding to given virtual_address
	//refer to the project presentation and documentation for details

	//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================
	uint32 * ptr_page_table;
	struct FrameInfo * frame_va = get_frame_info(ptr_page_directory,virtual_address,&ptr_page_table);
	return to_physical_address(frame_va);

}

unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//TODO: [PROJECT'24.MS2 - #06] [1] KERNEL HEAP - kheap_virtual_address
	// Write your code here, remove the panic and write your code
	//panic("kheap_virtual_address() is not implemented yet...!!");

	struct FrameInfo * frame_va = to_frame_info(physical_address);

	return physical_address - KERNEL_BASE;

	//return the virtual address corresponding to given physical_address
	//refer to the project presentation and documentation for details

	//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================
}
//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, if moved to another loc: the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT'24.MS2 - BONUS#1] [1] KERNEL HEAP - krealloc
	// Write your code here, remove the panic and write your code
	return NULL;
	panic("krealloc() is not implemented yet...!!");
}
