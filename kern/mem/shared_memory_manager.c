#include <inc/memlayout.h>
#include "shared_memory_manager.h"

#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/queue.h>
#include <inc/environment_definitions.h>

#include <kern/proc/user_environment.h>
#include <kern/trap/syscall.h>
#include "kheap.h"
#include "memory_manager.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct Share* get_share(int32 ownerID, char* name);

//===========================
// [1] INITIALIZE SHARES:
//===========================
//Initialize the list and the corresponding lock
void sharing_init()
{
#if USE_KHEAP
	LIST_INIT(&AllShares.shares_list) ;
	init_spinlock(&AllShares.shareslock, "shares lock");
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

//==============================
// [2] Get Size of Share Object:
//==============================
int getSizeOfSharedObject(int32 ownerID, char* shareName)
{
	//[PROJECT'24.MS2] DONE
	// This function should return the size of the given shared object
	// RETURN:
	//	a) If found, return size of shared object
	//	b) Else, return E_SHARED_MEM_NOT_EXISTS
	//
	struct Share* ptr_share = get_share(ownerID, shareName);
	if (ptr_share == NULL)
		return E_SHARED_MEM_NOT_EXISTS;
	else
		return ptr_share->size;

	return 0;
}

//===========================================================


//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
//===========================
// [1] Create frames_storage:
//===========================
// Create the frames_storage and initialize it by 0
inline struct FrameInfo** create_frames_storage(int numOfFrames)
{
	//TODO: [PROJECT'24.MS2 - #16] [4] SHARED MEMORY - create_frames_storage()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_frames_storage is not implemented yet");
	//Your Code is Here...
	if (LIST_SIZE(&MemFrameLists.free_frame_list) < numOfFrames)
	{
		return NULL;
	}
	struct FrameInfo** frames_storage = (struct FrameInfo**) kmalloc(numOfFrames * sizeof(struct FrameInfo*));
	if (frames_storage==NULL) return NULL;
	return frames_storage;
}

//=====================================
// [2] Alloc & Initialize Share Object:
//=====================================
//Allocates a new shared object and initialize its member
//It dynamically creates the "framesStorage"
//Return: allocatedObject (pointer to struct Share) passed by reference
struct Share* create_share(int32 ownerID, char* shareName, uint32 size, uint8 isWritable)
{
	//TODO: [PROJECT'24.MS2 - #16] [4] SHARED MEMORY - create_share()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_share is not implemented yet");
	//Your Code is Here...
	uint32 numOfFrames = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
	struct Share* created_share = kmalloc(sizeof(struct Share*));

	created_share->references=1;
	created_share->ID=(int32)((int)created_share & 0x7FFFFFFF); //mask
	created_share->framesStorage = create_frames_storage(numOfFrames);
	created_share->ownerID=ownerID;

	strncpy(created_share->name, shareName,sizeof(created_share->name) - 1);

	created_share->size=size;
	created_share->isWritable=isWritable;



	if(created_share==NULL || created_share->framesStorage==NULL)
	{
		kfree((void*)created_share);
		return NULL;
	}
	return created_share;

}

//=============================
// [3] Search for Share Object:
//=============================
//Search for the given shared object in the "shares_list"
//Return:
//	a) if found: ptr to Share object
//	b) else: NULL
struct Share* get_share(int32 ownerID, char* name)
{
	//TODO: [PROJECT'24.MS2 - #17] [4] SHARED MEMORY - get_share()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_share is not implemented yet");
	//Your Code is Here...
	struct Share* founded = NULL;
	LIST_FOREACH(founded, &AllShares.shares_list) {
		if(founded->ownerID == ownerID && strcmp(founded->name, name) == 0)
		{
			return founded;
		}
	}
	return NULL;
}

//=========================
// [4] Create Share Object:
//=========================
int createSharedObject(int32 ownerID, char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
	//TODO: [PROJECT'24.MS2 - #19] [4] SHARED MEMORY [KERNEL SIDE] - createSharedObject()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("createSharedObject is not implemented yet");
	//Your Code is Here...

	struct Env* myenv = get_cpu_proc(); //The calling environment
	struct Share* existed = get_share(ownerID,shareName);
	if(existed != NULL) return E_SHARED_MEM_EXISTS;
	struct Share* created_share = create_share(ownerID,  shareName,  size,  isWritable);
	if(created_share == NULL) return E_NO_SHARE;
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;

	for (int k = 0; k < num_pages; k++)
	{
		struct FrameInfo *ptr_frame_info;
		int ret = allocate_frame(&ptr_frame_info);
		if (ret != E_NO_MEM)
		{
			map_frame(myenv->env_page_directory, ptr_frame_info, (uint32)(virtual_address + (k * PAGE_SIZE)),isWritable*PERM_WRITEABLE);
			created_share->framesStorage[k] = ptr_frame_info;
		}
		else
		{
			panic("No Memory");
			return E_NO_SHARE;
		}
	}
	acquire_spinlock(&AllShares.shareslock);
	LIST_INSERT_TAIL(&AllShares.shares_list,created_share);
	release_spinlock(&AllShares.shareslock);

	return created_share->ID;
}


//======================
// [5] Get Share Object:
//======================
int getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
	//TODO: [PROJECT'24.MS2 - #21] [4] SHARED MEMORY [KERNEL SIDE] - getSharedObject()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("getSharedObject is not implemented yet");
	//Your Code is Here...

	struct Env* myenv = get_cpu_proc(); //The calling environment
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//==========================
// [B1] Delete Share Object:
//==========================
//delete the given shared object from the "shares_list"
//it should free its framesStorage and the share object itself
void free_share(struct Share* ptrShare)
{
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [KERNEL SIDE] - free_share()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("free_share is not implemented yet");
	//Your Code is Here...

}
//========================
// [B2] Free Share Object:
//========================
int freeSharedObject(int32 sharedObjectID, void *startVA)
{
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [KERNEL SIDE] - freeSharedObject()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("freeSharedObject is not implemented yet");
	//Your Code is Here...

}
