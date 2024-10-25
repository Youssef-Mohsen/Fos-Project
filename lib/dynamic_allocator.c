/*
 * dynamic_allocator.c
 *
 *  Created on: Sep 21, 2023
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"

/*header/footer FOR BLOCKS ONLY (NOT THE HEAP'S ONES)*/
#define HEADER(va) (uint32*)((char*)va - 4)
#define FOOTER(va) (uint32*)((*HEADER(va)) & !1 + va - 8)

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
	return (*curBlkMetaData) & ~(0x1);
}

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
	return (~(*curBlkMetaData) & 0x1) ;
}

//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
	void *va = NULL;
	switch (ALLOC_STRATEGY)
	{
	case DA_FF:
		va = alloc_block_FF(size);
		break;
	case DA_NF:
		va = alloc_block_NF(size);
		break;
	case DA_BF:
		va = alloc_block_BF(size);
		break;
	case DA_WF:
		va = alloc_block_WF(size);
		break;
	default:
		cprintf("Invalid allocation strategy\n");
		break;
	}
	return va;
}

//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");

}
//
////********************************************************************************//
////********************************************************************************//

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

bool is_initialized = 0;
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
            is_initialized = 1;
        }
        //==================================================================================
        //==================================================================================

        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
    if(daStart < KERNEL_HEAP_START)
        return;


    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
    beg_block->info = 1;

    // Create the END Block
    struct Block_Start_End* end_block = (struct Block_Start_End*) (daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End));
    end_block->info = 1;

    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
int counter=0;
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...


   /*struct BlockElement *block = (struct BlockElement *)(va);
   block->header = (struct Block_Start_End *)(va - sizeof(struct Block_Start_End));
   block->footer = (struct Block_Start_End *)(va + totalSize - 2*sizeof(struct Block_Start_End));*/
   if(isAllocated)
   {
	   //if already allocated and he wants it to be allocated
	   if(~(totalSize&1)) goto sayed;

	   /*block->header->info = totalSize;
	   block->footer->info = totalSize;*/

	   //Allocated flag = TRUE
	   totalSize++;

   }

   //Assigning size to Header/Footer
   sayed:
   *HEADER(va) = totalSize;
   *FOOTER(va, totalSize) = totalSize;

}



//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
		if (!is_initialized)
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
			uint32 da_break = (uint32)sbrk(0);
			initialize_dynamic_allocator(da_start, da_break - da_start);
			cprintf("Initialized \n");
		}
	}
	//==================================================================================
	//==================================================================================

	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...
	 if (size == 0) {
	        return NULL;
	    }

	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
	        void *va = (void *)blk;
	        uint32 blk_size = get_block_size(va);
	        if (blk_size >= size + 2 * sizeof(uint32)) {
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32)) {
	                uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
	                void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32)); // casting to char because its 1 byte size

	                // Refactoring the next block's previous pointer
	                LIST_PREV(LIST_NEXT(blk)) = (struct BlockElement *)new_block_va;
	                //LIST_NEXT(blk)->prev_next_info.le_prev = new_block_va;
	                // Refactoring the previous block's next pointer
	                LIST_NEXT(LIST_PREV(blk)) = (struct BlockElement *)new_block_va;
	                //LIST_PREV(blk)->prev_next_info.le_next = new_block_va;
	                set_block_data(va, size + 2 * sizeof(uint32), 1);

	                set_block_data(new_block_va, remaining_size, 0);
	            } else {
	            	// Refactoring the next block's previous pointer
	            	LIST_PREV(LIST_NEXT(blk)) = LIST_PREV(blk);

	            	// Refactoring the previous block's next pointer
	            	LIST_NEXT(LIST_PREV(blk)) = LIST_NEXT(blk);

	                set_block_data(va, blk_size, 1);
	            }
	            return va;
	        }
	    }

	    uint32 required_size = size + 2 * sizeof(uint32);
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
	    if (new_mem == (void *)-1) {
	        return NULL;
	    }
	    set_block_data(new_mem, required_size, 1);
	    return new_mem;

}
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...

}

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("free_block is not implemented yet");
	//Your Code is Here...
}

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	/*any address or size saved in header or footer are in single Bytes*/


	if(va == NULL)
	{
		if(new_size != 0) return alloc_block_ff(new_size);
		return NULL;
	}

	if(new_size == 0)
	{
		free_block(va);
		return NULL;
	}


	new_size = ROUNDUP(new_size, 8);
	//uint32 new_new_size = new_size + new_size%2);
	new_size += (new_size%2);

	//cur Block data
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;

	//next Block data
	void *next_cur_va = (void *)(FOOTER(va) + 2);
	uint32 nextBLOCK_size = get_block_size(next_cur_va)/*&is_free_block(next_block_va)*/; //=0 if not free
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;


	//if the user needs the same size he owns
	if(new_size == cur_size) return va;


	if(new_size < cur_size)
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
		if(is_free_block(next_cur_va))
		{
			uint32 next_new_size = next_cur_size + remaining_size;
			set_block_data(va, new_size, 1);
			void *next_new_va = (void *)(FOOTER(va) + 2);
			set_block_data(next_new_va, next_new_size, 0);
		}
		else
		{
			if(remaining_size>=16)
			{
				uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, new_size, 1);
				void *next_new_va = (void *)(FOOTER(va) + 2);
				//insert new block to free_block_list
				set_block_data(next_new_va, next_new_size, 0);
			}
			//else return va;
		}
		return va;
	}

	if(new_size > cur_size)
	{
		if(is_free_block(next_cur_va))
		{
			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
			if(needed_size>nextBLOCK_size) goto new_alloc;
			uint32 remaining_size = nextBLOCK_size - needed_size;
			if(remaining_size < 16)
			{
				//remove from free_block_list, then
				set_block_data(va, cur_size + nextBLOCK_size, 1);
			}
			else
			{
				set_block_data(va, new_size, 1);
				void *next_new_va = (void *)(FOOTER(va) + 2);
				//update free_block_list
				set_block_data(next_new_va, remaining_size, 0);
			}
			return va;
		}
		//else goto new_alloc;
	}

	new_alloc:
	free_block(va); //set it free
	return alloc_block_ff(new_size); //new allocation


}

/*********************************************************************************************/
/*********************************************************************************************/
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
	panic("alloc_block_WF is not implemented yet");
	return NULL;
}

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
	panic("alloc_block_NF is not implemented yet");
	return NULL;
}
