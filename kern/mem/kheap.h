#ifndef FOS_KERN_KHEAP_H_
#define FOS_KERN_KHEAP_H_

#ifndef FOS_KERNEL
# error "This is a FOS kernel header; user programs should not #include it"
#endif

#include <inc/types.h>
#include <inc/queue.h>


/*2017*/
uint32 _KHeapPlacementStrategy;
//Values for user heap placement strategy
#define KHP_PLACE_CONTALLOC 0x0
#define KHP_PLACE_FIRSTFIT 	0x1
#define KHP_PLACE_BESTFIT 	0x2
#define KHP_PLACE_NEXTFIT 	0x3
#define KHP_PLACE_WORSTFIT 	0x4

static inline void setKHeapPlacementStrategyCONTALLOC(){_KHeapPlacementStrategy = KHP_PLACE_CONTALLOC;}
static inline void setKHeapPlacementStrategyFIRSTFIT(){_KHeapPlacementStrategy = KHP_PLACE_FIRSTFIT;}
static inline void setKHeapPlacementStrategyBESTFIT(){_KHeapPlacementStrategy = KHP_PLACE_BESTFIT;}
static inline void setKHeapPlacementStrategyNEXTFIT(){_KHeapPlacementStrategy = KHP_PLACE_NEXTFIT;}
static inline void setKHeapPlacementStrategyWORSTFIT(){_KHeapPlacementStrategy = KHP_PLACE_WORSTFIT;}

static inline uint8 isKHeapPlacementStrategyCONTALLOC(){if(_KHeapPlacementStrategy == KHP_PLACE_CONTALLOC) return 1; return 0;}
static inline uint8 isKHeapPlacementStrategyFIRSTFIT(){if(_KHeapPlacementStrategy == KHP_PLACE_FIRSTFIT) return 1; return 0;}
static inline uint8 isKHeapPlacementStrategyBESTFIT(){if(_KHeapPlacementStrategy == KHP_PLACE_BESTFIT) return 1; return 0;}
static inline uint8 isKHeapPlacementStrategyNEXTFIT(){if(_KHeapPlacementStrategy == KHP_PLACE_NEXTFIT) return 1; return 0;}
static inline uint8 isKHeapPlacementStrategyWORSTFIT(){if(_KHeapPlacementStrategy == KHP_PLACE_WORSTFIT) return 1; return 0;}

//***********************************

void* kmalloc(unsigned int size);
void kfree(void* virtual_address);
void *krealloc(void *virtual_address, unsigned int new_size);

unsigned int kheap_virtual_address(unsigned int physical_address);
unsigned int kheap_physical_address(unsigned int virtual_address);

int numOfKheapVACalls ;


//TODO: [PROJECT'24.MS2 - #01] [1] KERNEL HEAP - add suitable code here
#include "memory_manager.h"

uint32 start;
uint32 hard_limit;
uint32 brk;

bool isPageAllocated(uint32 *ptr_page_directory, const uint32 virtual_address)
{
    uint32 * page_table;
    if(get_page_table(ptr_page_directory, virtual_address, page_table) == TABLE_NOT_EXIST)
    {
        return 0;
    }
    else
    {
        uint32 page_directory_entry = ptr_page_directory[PDX(virtual_address)];
        if ((page_directory_entry & PERM_PRESENT) != PERM_PRESENT)
            return 0;
        else
            return 1;
    }
}

// // LIST_HEAD(FrameInfo_List, FrameInfo);
// LIST_HEAD(PageCluster_List, PageCluster);

// //typedef LIST_ENTRY(FrameInfo) Page_LIST_entry_t;
// typedef LIST_ENTRY(FrameInfo) Page_LIST_entry_t;

// struct PageCluster {
// 	/* free list link */
// 	Page_LIST_entry_t prev_next_info;

// 	// references is the count of pointers (usually in page table entries)
// 	// to this page, for frames allocated using allocate_frame.
// 	// frames allocated at boot time using memory_manager.c's
// 	// boot_allocate_space do not have valid reference count fields.
// 	uint16 references;

// 	struct Env *proc;
// 	uint32 bufferedVA;
// 	unsigned char isBuffered;
// };

#endif // FOS_KERN_KHEAP_H_
