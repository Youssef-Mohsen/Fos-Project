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
#define FOOTER(va) (uint32*)(((*HEADER(va)) & ~1) + (char*)va - 8)
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

     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

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


//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
   *HEADER(va) = totalSize;
   *FOOTER(va) = totalSize;
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
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32)); // casting to char because its 1 byte size
				set_block_data(va, size + 2 * sizeof(uint32), 1);

				if (LIST_PREV(blk)==NULL)
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
				}
				else if (LIST_NEXT(blk)==NULL)
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
				}
				LIST_REMOVE(&freeBlocksList, blk);
				set_block_data(new_block_va, remaining_size, 0);
	            }
	            else
	            {
	            	set_block_data(va, blk_size, 1);
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
		if (new_mem == (void *)-1) {
			return NULL; // Allocation failed
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
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
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

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
		void *va = (void *)blk;
		uint32 blk_size = get_block_size(va);
		if (blk_size>=size + 2 * sizeof(uint32))
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
			{
				if (best_blk_size > blk_size)
				{
					best_va = va;
					best_blk_size = blk_size;
				}
			}
			else
			{
				cprintf("288\n");
				cprintf("Size : %d\n",size);
				cprintf("Best Size : %d\n",blk_size);
				print_blocks_list(freeBlocksList);
				if (blk_size == size + 2 * sizeof(uint32)){
					cprintf("291\n");
					set_block_data(va, blk_size, 1);
					LIST_REMOVE(&freeBlocksList,blk);
					print_blocks_list(freeBlocksList);
					return va;
				}
				else //if (blk_size> size + 2 * sizeof(uint32))
				{
					if (best_blk_size > blk_size)
					{
						cprintf("299\n");
						internal = 1;
						best_va = va;
						best_blk_size = blk_size;
					}
				}
			}
		}

	}

	if (best_va !=NULL && internal ==0){
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
			set_block_data(new_block_va, remaining_size, 0);
			return best_va;
	}
	else if(internal == 1)
	{

		cprintf("291\n");
		set_block_data(best_va, best_blk_size, 1);
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
		print_blocks_list(freeBlocksList);
		return best_va;

	}
	cprintf("sbrk\n");
	uint32 required_size = size + 2 * sizeof(uint32);
	void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
	if (new_mem == (void *)-1) {
		return NULL; // Allocation failed
	}
	set_block_data(new_mem, required_size, 1);
	return new_mem;
}

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
	bool prev_is_free = 0, next_is_free = 0;
	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
		prev_is_free = 1;
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}


	if(prev_is_free && next_is_free)
	{
		//merge - 2 sides
		prev_block->prev_next_info.le_next = next_block->prev_next_info.le_next;
		LIST_NEXT( next_block )->prev_next_info.le_prev = prev_block;

		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);

		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
	{
		//merge - right side
		if(prev_block != NULL) prev_block->prev_next_info.le_next = va;
		LIST_NEXT( next_block )->prev_next_info.le_prev = va;

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
		set_block_data(va, new_block_size, 0);

		struct BlockElement *va_block = (struct BlockElement *)va;
		va_block->prev_next_info.le_next = next_block->prev_next_info.le_next;
		va_block->prev_next_info.le_prev = prev_block;

		if(prev_block != NULL) LIST_NEXT(prev_block) = va_block;
		else LIST_FIRST(&freeBlocksList) = va_block;
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
		//check if the block should be inserted at the BEGINNING of the list
		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
		else {
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}

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
		if(new_size != 0) return alloc_block_FF(new_size);
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
	uint32 newBloc_size = new_size + 8;
	//cur Block data
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;

	//next Block data
	void *next_cur_va = (void *)(va + curBLOCK_size);
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
			set_block_data(va, newBloc_size, 1);

			void *next_new_va = (void *)(FOOTER(va) + 2);
			set_block_data(next_new_va, next_new_size, 0);

			//still needed edit freeBlocklist
		}
		else
		{
			if(remaining_size>=16)
			{
				uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBloc_size, 1);
				void *next_new_va = (void *)(FOOTER(va) + 2);
				//insert new block to free_block_list
				//set_block_data(next_new_va, next_new_size, 0);
			}
		}
		return va;
	}

	else
	{
		if(is_free_block(next_cur_va))
		{
			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
			if(needed_size>nextBLOCK_size) goto new_alloc;
			uint32 remaining_size = nextBLOCK_size - needed_size;
			if(remaining_size < 16)
			{
				//remove from free_block_list, then
				set_block_data(va, cur_size + nextBLOCK_size+8, 1);
			}
			else
			{
				set_block_data(va, newBloc_size, 1);
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
	return alloc_block_FF(new_size); //new allocation
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
