
#include <inc/lib.h>
#define UHEAP_PAGE_INDEX(va) (va - myEnv->heap_hard_limit - PAGE_SIZE) / PAGE_SIZE
// #define MAX(a, b) (int)(b > a) * b + (int)(a > b) * a + (int)(a == b)(a)

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void *sbrk(int increment)
{
	return (void *)sys_sbrk(increment);
}
uint32 no_pages_marked[NUM_OF_UHEAP_PAGES];
bool isPageMarked[NUM_OF_UHEAP_PAGES];
int32 ids[NUM_OF_UHEAP_PAGES];

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
/*bool isPageMarked(uint32* ptr_page_directory,const uint32 virtual_address)
{
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void *malloc(uint32 size)
{
	//==============================================================
	// DON'T CHANGE THIS CODE========================================
	if (size == 0)
		return NULL;
	//==============================================================
	// TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	//	panic("malloc() is not implemented yet...!!");
	//	return NULL;
	// Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	// to check the current strategy
	uint32 num_pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE), PAGE_SIZE) / PAGE_SIZE;
	void *ptr = NULL;
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
		{
			
			ptr = alloc_block_FF(size);
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
			ptr = alloc_block_BF(size);
	}
	else if (num_pages < max_no_of_pages - 1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
				{
					if (j >= (uint32)USER_HEAP_MAX)
						return NULL;
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
					{
						
						i = j;
						goto sayed;
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for (int k = 0; k < num_pages; k++)
				{
					isPageMarked[UHEAP_PAGE_INDEX((k * PAGE_SIZE) + i)] = 1;
				}
				

			}
		sayed:
			if (ok)
				break;
			i += (uint32)PAGE_SIZE;
		}

		if (!ok)
			return NULL;
		ptr = (void *)i;
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
		sys_allocate_user_mem(i, size);
		
	}
	else
	{
		return NULL;
	}
	return ptr;
}

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void *va)
{
	// TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	//  Write your code here, remove the panic and write your code
	//	panic("free() is not implemented yet...!!");
	// what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if ((uint32)va < myEnv->heap_hard_limit)
	{
		size = get_block_size(va);
		free_block(va);
	}
	else if ((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX)
	{
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for (int k = 0; k < no_of_pages; k++)
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void *smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	//==============================================================
	// DON'T CHANGE THIS CODE========================================
	if (size == 0)
		return NULL;
	//==============================================================
	// TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
	if(ptr == NULL) return NULL;
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
	 return ptr;
}

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void *sget(int32 ownerEnvID, char *sharedVarName)
{
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
	void * ptr = malloc(MAX(size,PAGE_SIZE));
	if(ptr == NULL) return NULL;
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
	return ptr;
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//=================================
// FREE SHARED VARIABLE:
//=================================
//	This function frees the shared variable at the given virtual_address
//	To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//	from main memory then switch back to the user again.
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void *virtual_address)
{
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
    int ret = sys_freeSharedObject(id,virtual_address);
}

//=================================
// REALLOC USER SPACE:
//=================================
//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to malloc().
//	A call with new_size = zero is equivalent to free().

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
	return NULL;
}

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
	panic("Not Implemented");
}
void shrink(uint32 newSize)
{
	panic("Not Implemented");
}
void freeHeap(void *virtual_address)
{
	panic("Not Implemented");
}
