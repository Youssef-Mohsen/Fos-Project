
obj/user/tst_first_fit_2:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 f4 08 00 00       	call   80092a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <check_block>:
#define USER_TST_UTILITIES_H_
#include <inc/types.h>
#include <inc/stdio.h>

int check_block(void* va, void* expectedVA, uint32 expectedSize, uint8 expectedFlag)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
  80003e:	8b 45 14             	mov    0x14(%ebp),%eax
  800041:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//Check returned va
	if(va != expectedVA)
  800044:	8b 45 08             	mov    0x8(%ebp),%eax
  800047:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80004a:	74 1d                	je     800069 <check_block+0x31>
	{
		cprintf("wrong block address. Expected %x, Actual %x\n", expectedVA, va);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	ff 75 08             	pushl  0x8(%ebp)
  800052:	ff 75 0c             	pushl  0xc(%ebp)
  800055:	68 40 3f 80 00       	push   $0x803f40
  80005a:	e8 bf 0c 00 00       	call   800d1e <cprintf>
  80005f:	83 c4 10             	add    $0x10,%esp
		return 0;
  800062:	b8 00 00 00 00       	mov    $0x0,%eax
  800067:	eb 55                	jmp    8000be <check_block+0x86>
	}
	//Check header & footer
	uint32 header = *((uint32*)va-1);
  800069:	8b 45 08             	mov    0x8(%ebp),%eax
  80006c:	8b 40 fc             	mov    -0x4(%eax),%eax
  80006f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 footer = *((uint32*)(va + expectedSize - 8));
  800072:	8b 45 10             	mov    0x10(%ebp),%eax
  800075:	8d 50 f8             	lea    -0x8(%eax),%edx
  800078:	8b 45 08             	mov    0x8(%ebp),%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	8b 00                	mov    (%eax),%eax
  80007f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 expectedData = expectedSize | expectedFlag ;
  800082:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  800086:	0b 45 10             	or     0x10(%ebp),%eax
  800089:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(header != expectedData || footer != expectedData)
  80008c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80008f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800092:	75 08                	jne    80009c <check_block+0x64>
  800094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800097:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80009a:	74 1d                	je     8000b9 <check_block+0x81>
	{
		cprintf("wrong header/footer data. Expected %d, Actual H:%d F:%d\n", expectedData, header, footer);
  80009c:	ff 75 f0             	pushl  -0x10(%ebp)
  80009f:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a5:	68 70 3f 80 00       	push   $0x803f70
  8000aa:	e8 6f 0c 00 00       	call   800d1e <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		return 0;
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	eb 05                	jmp    8000be <check_block+0x86>
	}
	return 1;
  8000b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <_main>:
short* startVAs[numOfAllocs*allocCntPerSize+1] ;
short* midVAs[numOfAllocs*allocCntPerSize+1] ;
short* endVAs[numOfAllocs*allocCntPerSize+1] ;

void _main(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
  8000c6:	81 ec ec 00 00 00    	sub    $0xec,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL DYNAMIC ALLOCATOR sbrk()
	 * (e.g. DURING THE DYNAMIC CREATION OF WS ELEMENT in FH).
	 *********************************************************/
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	6a 01                	push   $0x1
  8000d1:	e8 2a 20 00 00       	call   802100 <sys_set_uheap_strategy>
  8000d6:	83 c4 10             	add    $0x10,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  8000d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8000de:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  8000e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e9:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000ef:	39 c2                	cmp    %eax,%edx
  8000f1:	72 14                	jb     800107 <_main+0x47>
			panic("Please increase the WS size");
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	68 a9 3f 80 00       	push   $0x803fa9
  8000fb:	6a 26                	push   $0x26
  8000fd:	68 c5 3f 80 00       	push   $0x803fc5
  800102:	e8 5a 09 00 00       	call   800a61 <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	/*=================================================*/

	int eval = 0;
  800107:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	bool is_correct = 1;
  80010e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	int targetAllocatedSpace = 3*Mega;
  800115:	c7 45 b4 00 00 30 00 	movl   $0x300000,-0x4c(%ebp)

	void * va ;
	int idx = 0;
  80011c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800123:	e8 25 1c 00 00       	call   801d4d <sys_pf_calculate_allocated_pages>
  800128:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 d2 1b 00 00       	call   801d02 <sys_calculate_free_frames>
  800130:	89 45 ac             	mov    %eax,-0x54(%ebp)
	uint32 actualSize, block_size, blockIndex;
	int8 block_status;
	void* expectedVA;
	uint32 expectedSize, curTotalSize,roundedTotalSize ;

	void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
  800133:	c7 45 d0 04 00 00 80 	movl   $0x80000004,-0x30(%ebp)
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 dc 3f 80 00       	push   $0x803fdc
  800142:	e8 d7 0b 00 00       	call   800d1e <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80014a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		curTotalSize = sizeof(int);
  800151:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  800158:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80015f:	e9 6f 01 00 00       	jmp    8002d3 <_main+0x213>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  800164:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80016b:	e9 53 01 00 00       	jmp    8002c3 <_main+0x203>
			{
				actualSize = allocSizes[i] - sizeOfMetaData;
  800170:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800173:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  80017a:	83 e8 08             	sub    $0x8,%eax
  80017d:	89 45 a8             	mov    %eax,-0x58(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	ff 75 a8             	pushl  -0x58(%ebp)
  800186:	e8 43 19 00 00       	call   801ace <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 c2                	mov    %eax,%edx
  800190:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800193:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
  80019a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80019d:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8001a4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  8001a7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001aa:	d1 e8                	shr    %eax
  8001ac:	89 c2                	mov    %eax,%edx
  8001ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001b1:	01 c2                	add    %eax,%edx
  8001b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b6:	89 14 85 60 7c 80 00 	mov    %edx,0x807c60(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  8001bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001c0:	8d 50 fe             	lea    -0x2(%eax),%edx
  8001c3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001c6:	01 c2                	add    %eax,%edx
  8001c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cb:	89 14 85 60 66 80 00 	mov    %edx,0x806660(,%eax,4)
				//Check returned va
				expectedVA = (curVA + sizeOfMetaData/2);
  8001d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001d5:	83 c0 04             	add    $0x4,%eax
  8001d8:	89 45 a0             	mov    %eax,-0x60(%ebp)
				expectedSize = allocSizes[i];
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8001e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
				curTotalSize += allocSizes[i] ;
  8001e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001eb:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8001f2:	01 45 d4             	add    %eax,-0x2c(%ebp)
				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA & curTotalSize to skip this area
				roundedTotalSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8001f5:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  8001fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8001ff:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	48                   	dec    %eax
  800205:	89 45 98             	mov    %eax,-0x68(%ebp)
  800208:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020b:	ba 00 00 00 00       	mov    $0x0,%edx
  800210:	f7 75 9c             	divl   -0x64(%ebp)
  800213:	8b 45 98             	mov    -0x68(%ebp),%eax
  800216:	29 d0                	sub    %edx,%eax
  800218:	89 45 94             	mov    %eax,-0x6c(%ebp)
				int diff = (roundedTotalSize - curTotalSize) ;
  80021b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80021e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800221:	89 45 90             	mov    %eax,-0x70(%ebp)
				if (diff > 0 && diff < (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData))
  800224:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  800228:	7e 48                	jle    800272 <_main+0x1b2>
  80022a:	83 7d 90 0f          	cmpl   $0xf,-0x70(%ebp)
  80022e:	7f 42                	jg     800272 <_main+0x1b2>
				{
//					cprintf("%~\n FRAGMENTATION: curVA = %x diff = %d\n", curVA, diff);
//					cprintf("%~\n Allocated block @ %x with size = %d\n", va, get_block_size(va));

					curVA = ROUNDUP(curVA, PAGE_SIZE)- sizeof(int) /*next alloc will start at END Block (after sbrk)*/;
  800230:	c7 45 8c 00 10 00 00 	movl   $0x1000,-0x74(%ebp)
  800237:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80023a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80023d:	01 d0                	add    %edx,%eax
  80023f:	48                   	dec    %eax
  800240:	89 45 88             	mov    %eax,-0x78(%ebp)
  800243:	8b 45 88             	mov    -0x78(%ebp),%eax
  800246:	ba 00 00 00 00       	mov    $0x0,%edx
  80024b:	f7 75 8c             	divl   -0x74(%ebp)
  80024e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800251:	29 d0                	sub    %edx,%eax
  800253:	83 e8 04             	sub    $0x4,%eax
  800256:	89 45 d0             	mov    %eax,-0x30(%ebp)
					curTotalSize = roundedTotalSize - sizeof(int) /*exclude END Block*/;
  800259:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80025c:	83 e8 04             	sub    $0x4,%eax
  80025f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					expectedSize += diff - sizeof(int) /*exclude END Block*/;
  800262:	8b 55 90             	mov    -0x70(%ebp),%edx
  800265:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800268:	01 d0                	add    %edx,%eax
  80026a:	83 e8 04             	sub    $0x4,%eax
  80026d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800270:	eb 0d                	jmp    80027f <_main+0x1bf>
				}
				else
				{
					curVA += allocSizes[i] ;
  800272:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800275:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  80027c:	01 45 d0             	add    %eax,-0x30(%ebp)
				}
				//============================================================
				if (is_correct)
  80027f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800283:	74 38                	je     8002bd <_main+0x1fd>
				{
					if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800285:	6a 01                	push   $0x1
  800287:	ff 75 d8             	pushl  -0x28(%ebp)
  80028a:	ff 75 a0             	pushl  -0x60(%ebp)
  80028d:	ff 75 a4             	pushl  -0x5c(%ebp)
  800290:	e8 a3 fd ff ff       	call   800038 <check_block>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	85 c0                	test   %eax,%eax
  80029a:	75 21                	jne    8002bd <_main+0x1fd>
					{
						if (is_correct)
  80029c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002a0:	74 1b                	je     8002bd <_main+0x1fd>
						{
							is_correct = 0;
  8002a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
							panic("alloc_block_xx #PRQ.%d: WRONG ALLOC\n", idx);
  8002a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ac:	68 34 40 80 00       	push   $0x804034
  8002b1:	6a 69                	push   $0x69
  8002b3:	68 c5 3f 80 00       	push   $0x803fc5
  8002b8:	e8 a4 07 00 00       	call   800a61 <_panic>
						}
					}
				}
				idx++;
  8002bd:	ff 45 dc             	incl   -0x24(%ebp)
	{
		is_correct = 1;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8002c0:	ff 45 c8             	incl   -0x38(%ebp)
  8002c3:	81 7d c8 c7 00 00 00 	cmpl   $0xc7,-0x38(%ebp)
  8002ca:	0f 8e a0 fe ff ff    	jle    800170 <_main+0xb0>
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
	{
		is_correct = 1;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
  8002d0:	ff 45 cc             	incl   -0x34(%ebp)
  8002d3:	83 7d cc 06          	cmpl   $0x6,-0x34(%ebp)
  8002d7:	0f 8e 87 fe ff ff    	jle    800164 <_main+0xa4>
			//if (is_correct == 0)
			//break;
		}
	}
	/* Fill the remaining space at the end of the DA*/
	roundedTotalSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8002dd:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  8002e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8002e7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	48                   	dec    %eax
  8002ed:	89 45 80             	mov    %eax,-0x80(%ebp)
  8002f0:	8b 45 80             	mov    -0x80(%ebp),%eax
  8002f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f8:	f7 75 84             	divl   -0x7c(%ebp)
  8002fb:	8b 45 80             	mov    -0x80(%ebp),%eax
  8002fe:	29 d0                	sub    %edx,%eax
  800300:	89 45 94             	mov    %eax,-0x6c(%ebp)
	uint32 remainSize = (roundedTotalSize - curTotalSize) - sizeof(int) /*END block*/;
  800303:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800306:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800309:	83 e8 04             	sub    $0x4,%eax
  80030c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	if (remainSize >= (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData))
  800312:	83 bd 7c ff ff ff 0f 	cmpl   $0xf,-0x84(%ebp)
  800319:	0f 86 87 00 00 00    	jbe    8003a6 <_main+0x2e6>
	{
		cprintf("Filling the remaining size of %d\n\n", remainSize);
  80031f:	83 ec 08             	sub    $0x8,%esp
  800322:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  800328:	68 5c 40 80 00       	push   $0x80405c
  80032d:	e8 ec 09 00 00       	call   800d1e <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800335:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80033b:	83 e8 08             	sub    $0x8,%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	6a 01                	push   $0x1
  800343:	50                   	push   %eax
  800344:	e8 f9 1e 00 00       	call   802242 <alloc_block>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	89 c2                	mov    %eax,%edx
  80034e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800351:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
  800358:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80035b:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  800362:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		//Check returned va
		expectedVA = curVA + sizeOfMetaData/2;
  800365:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800368:	83 c0 04             	add    $0x4,%eax
  80036b:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (check_block(va, expectedVA, remainSize, 1) == 0)
  80036e:	6a 01                	push   $0x1
  800370:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  800376:	ff 75 a0             	pushl  -0x60(%ebp)
  800379:	ff 75 a4             	pushl  -0x5c(%ebp)
  80037c:	e8 b7 fc ff ff       	call   800038 <check_block>
  800381:	83 c4 10             	add    $0x10,%esp
  800384:	85 c0                	test   %eax,%eax
  800386:	75 1e                	jne    8003a6 <_main+0x2e6>
		{
			is_correct = 0;
  800388:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			panic("alloc_block_xx #PRQ.oo: WRONG ALLOC\n", idx);
  80038f:	ff 75 dc             	pushl  -0x24(%ebp)
  800392:	68 80 40 80 00       	push   $0x804080
  800397:	68 80 00 00 00       	push   $0x80
  80039c:	68 c5 3f 80 00       	push   $0x803fc5
  8003a1:	e8 bb 06 00 00       	call   800a61 <_panic>
		}
	}

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 a8 40 80 00       	push   $0x8040a8
  8003ae:	e8 6b 09 00 00       	call   800d1e <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003b6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  8003bd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  8003c4:	e9 98 00 00 00       	jmp    800461 <_main+0x3a1>
		{
			free(startVAs[i*allocCntPerSize]);
  8003c9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003cc:	89 d0                	mov    %edx,%eax
  8003ce:	c1 e0 02             	shl    $0x2,%eax
  8003d1:	01 d0                	add    %edx,%eax
  8003d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003da:	01 d0                	add    %edx,%eax
  8003dc:	c1 e0 03             	shl    $0x3,%eax
  8003df:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8003e6:	83 ec 0c             	sub    $0xc,%esp
  8003e9:	50                   	push   %eax
  8003ea:	e8 08 17 00 00       	call   801af7 <free>
  8003ef:	83 c4 10             	add    $0x10,%esp
			if (check_block(startVAs[i*allocCntPerSize], startVAs[i*allocCntPerSize], allocSizes[i], 0) == 0)
  8003f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003f5:	8b 0c 85 00 50 80 00 	mov    0x805000(,%eax,4),%ecx
  8003fc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003ff:	89 d0                	mov    %edx,%eax
  800401:	c1 e0 02             	shl    $0x2,%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	01 d0                	add    %edx,%eax
  80040f:	c1 e0 03             	shl    $0x3,%eax
  800412:	8b 14 85 60 50 80 00 	mov    0x805060(,%eax,4),%edx
  800419:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80041c:	89 d8                	mov    %ebx,%eax
  80041e:	c1 e0 02             	shl    $0x2,%eax
  800421:	01 d8                	add    %ebx,%eax
  800423:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  80042a:	01 d8                	add    %ebx,%eax
  80042c:	c1 e0 03             	shl    $0x3,%eax
  80042f:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  800436:	6a 00                	push   $0x0
  800438:	51                   	push   %ecx
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	e8 f8 fb ff ff       	call   800038 <check_block>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	85 c0                	test   %eax,%eax
  800445:	75 17                	jne    80045e <_main+0x39e>
			{
				is_correct = 0;
  800447:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_ff_2 #1.1: WRONG FREE!\n");
  80044e:	83 ec 0c             	sub    $0xc,%esp
  800451:	68 f0 40 80 00       	push   $0x8040f0
  800456:	e8 c3 08 00 00       	call   800d1e <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
	{
		is_correct = 1;
		for (int i = 0; i < numOfAllocs; ++i)
  80045e:	ff 45 c4             	incl   -0x3c(%ebp)
  800461:	83 7d c4 06          	cmpl   $0x6,-0x3c(%ebp)
  800465:	0f 8e 5e ff ff ff    	jle    8003c9 <_main+0x309>
	short* tstMidVAs[numOfFFTests+1] ;
	short* tstEndVAs[numOfFFTests+1] ;

	//====================================================================//
	/*FF ALLOC Scenario 2: Try to allocate blocks with sizes smaller than existing free blocks*/
	cprintf("2: Try to allocate set of blocks with different sizes smaller than existing free blocks\n\n") ;
  80046b:	83 ec 0c             	sub    $0xc,%esp
  80046e:	68 10 41 80 00       	push   $0x804110
  800473:	e8 a6 08 00 00       	call   800d1e <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp

	uint32 testSizes[numOfFFTests] =
  80047b:	8d 85 2c ff ff ff    	lea    -0xd4(%ebp),%eax
  800481:	bb d4 44 80 00       	mov    $0x8044d4,%ebx
  800486:	ba 03 00 00 00       	mov    $0x3,%edx
  80048b:	89 c7                	mov    %eax,%edi
  80048d:	89 de                	mov    %ebx,%esi
  80048f:	89 d1                	mov    %edx,%ecx
  800491:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	{
			kilo/4,								//expected to be allocated in 4th free block
			8*sizeof(char) + sizeOfMetaData, 	//expected to be allocated in 1st free block
			kilo/8,								//expected to be allocated in remaining of 4th free block
	} ;
	uint32 expectedSizes[numOfFFTests] =
  800493:	c7 85 20 ff ff ff 00 	movl   $0x100,-0xe0(%ebp)
  80049a:	01 00 00 
	{
			kilo/4,					//expected to be allocated in 4th free block
			allocSizes[0], 			//INTERNAL FRAGMENTATION CASE in 1st Block
  80049d:	a1 00 50 80 00       	mov    0x805000,%eax
	{
			kilo/4,								//expected to be allocated in 4th free block
			8*sizeof(char) + sizeOfMetaData, 	//expected to be allocated in 1st free block
			kilo/8,								//expected to be allocated in remaining of 4th free block
	} ;
	uint32 expectedSizes[numOfFFTests] =
  8004a2:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  8004a8:	c7 85 28 ff ff ff 80 	movl   $0x80,-0xd8(%ebp)
  8004af:	00 00 00 
	{
			kilo/4,					//expected to be allocated in 4th free block
			allocSizes[0], 			//INTERNAL FRAGMENTATION CASE in 1st Block
			kilo/8,					//expected to be allocated in remaining of 4th free block
	} ;
	uint32 startOf1stFreeBlock = (uint32)startVAs[0*allocCntPerSize];
  8004b2:	a1 60 50 80 00       	mov    0x805060,%eax
  8004b7:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	uint32 startOf4thFreeBlock = (uint32)startVAs[3*allocCntPerSize];
  8004bd:	a1 c0 59 80 00       	mov    0x8059c0,%eax
  8004c2:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

	{
		is_correct = 1;
  8004c8:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		uint32 expectedVAs[numOfFFTests] =
  8004cf:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8004d5:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  8004db:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004e1:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
  8004e7:	8b 95 2c ff ff ff    	mov    -0xd4(%ebp),%edx
  8004ed:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8004f3:	01 d0                	add    %edx,%eax
	uint32 startOf4thFreeBlock = (uint32)startVAs[3*allocCntPerSize];

	{
		is_correct = 1;

		uint32 expectedVAs[numOfFFTests] =
  8004f5:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
		};
		for (int i = 0; i < numOfFFTests; ++i)
  8004fb:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800502:	e9 ef 00 00 00       	jmp    8005f6 <_main+0x536>
		{
			actualSize = testSizes[i] - sizeOfMetaData;
  800507:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80050a:	8b 84 85 2c ff ff ff 	mov    -0xd4(%ebp,%eax,4),%eax
  800511:	83 e8 08             	sub    $0x8,%eax
  800514:	89 45 a8             	mov    %eax,-0x58(%ebp)
			va = tstStartVAs[i] = malloc(actualSize);
  800517:	83 ec 0c             	sub    $0xc,%esp
  80051a:	ff 75 a8             	pushl  -0x58(%ebp)
  80051d:	e8 ac 15 00 00       	call   801ace <malloc>
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	89 c2                	mov    %eax,%edx
  800527:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052a:	89 94 85 58 ff ff ff 	mov    %edx,-0xa8(%ebp,%eax,4)
  800531:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800534:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  80053b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			tstMidVAs[i] = va + actualSize/2 ;
  80053e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800541:	d1 e8                	shr    %eax
  800543:	89 c2                	mov    %eax,%edx
  800545:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800548:	01 c2                	add    %eax,%edx
  80054a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80054d:	89 94 85 48 ff ff ff 	mov    %edx,-0xb8(%ebp,%eax,4)
			tstEndVAs[i] = va + actualSize - sizeof(short);
  800554:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800557:	8d 50 fe             	lea    -0x2(%eax),%edx
  80055a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80055d:	01 c2                	add    %eax,%edx
  80055f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800562:	89 94 85 38 ff ff ff 	mov    %edx,-0xc8(%ebp,%eax,4)
			//Check returned va
			if (check_block(tstStartVAs[i], (void*) expectedVAs[i], expectedSizes[i], 1) == 0)
  800569:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80056c:	8b 94 85 20 ff ff ff 	mov    -0xe0(%ebp,%eax,4),%edx
  800573:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800576:	8b 84 85 14 ff ff ff 	mov    -0xec(%ebp,%eax,4),%eax
  80057d:	89 c1                	mov    %eax,%ecx
  80057f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800582:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  800589:	6a 01                	push   $0x1
  80058b:	52                   	push   %edx
  80058c:	51                   	push   %ecx
  80058d:	50                   	push   %eax
  80058e:	e8 a5 fa ff ff       	call   800038 <check_block>
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	85 c0                	test   %eax,%eax
  800598:	75 1a                	jne    8005b4 <_main+0x4f4>
			{
				is_correct = 0;
  80059a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_ff_2 #2.%d: WRONG ALLOCATE AFTER FREE!\n", i);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	ff 75 c0             	pushl  -0x40(%ebp)
  8005a7:	68 6c 41 80 00       	push   $0x80416c
  8005ac:	e8 6d 07 00 00       	call   800d1e <cprintf>
  8005b1:	83 c4 10             	add    $0x10,%esp
			}
			*(tstStartVAs[i]) = 353 + i;
  8005b4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005b7:	8b 94 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%edx
  8005be:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005c1:	05 61 01 00 00       	add    $0x161,%eax
  8005c6:	66 89 02             	mov    %ax,(%edx)
			*(tstMidVAs[i]) = 353 + i;
  8005c9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005cc:	8b 94 85 48 ff ff ff 	mov    -0xb8(%ebp,%eax,4),%edx
  8005d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005d6:	05 61 01 00 00       	add    $0x161,%eax
  8005db:	66 89 02             	mov    %ax,(%edx)
			*(tstEndVAs[i]) = 353 + i;
  8005de:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e1:	8b 94 85 38 ff ff ff 	mov    -0xc8(%ebp,%eax,4),%edx
  8005e8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005eb:	05 61 01 00 00       	add    $0x161,%eax
  8005f0:	66 89 02             	mov    %ax,(%edx)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
		};
		for (int i = 0; i < numOfFFTests; ++i)
  8005f3:	ff 45 c0             	incl   -0x40(%ebp)
  8005f6:	83 7d c0 02          	cmpl   $0x2,-0x40(%ebp)
  8005fa:	0f 8e 07 ff ff ff    	jle    800507 <_main+0x447>
			*(tstStartVAs[i]) = 353 + i;
			*(tstMidVAs[i]) = 353 + i;
			*(tstEndVAs[i]) = 353 + i;
		}
		//Check stored sizes
		if(get_block_size(tstStartVAs[1]) != allocSizes[0])
  800600:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800606:	83 ec 0c             	sub    $0xc,%esp
  800609:	50                   	push   %eax
  80060a:	e8 fc 1b 00 00       	call   80220b <get_block_size>
  80060f:	83 c4 10             	add    $0x10,%esp
  800612:	89 c2                	mov    %eax,%edx
  800614:	a1 00 50 80 00       	mov    0x805000,%eax
  800619:	39 c2                	cmp    %eax,%edx
  80061b:	74 17                	je     800634 <_main+0x574>
		{
			is_correct = 0;
  80061d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_ff_2 #2.3: WRONG FF ALLOC - make sure if the remaining free space doesn’t fit a dynamic allocator block, then this area should be added to the allocated area and counted as internal fragmentation\n");
  800624:	83 ec 0c             	sub    $0xc,%esp
  800627:	68 9c 41 80 00       	push   $0x80419c
  80062c:	e8 ed 06 00 00       	call   800d1e <cprintf>
  800631:	83 c4 10             	add    $0x10,%esp
			//break;
		}
		if (is_correct)
  800634:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800638:	74 04                	je     80063e <_main+0x57e>
		{
			eval += 30;
  80063a:	83 45 e4 1e          	addl   $0x1e,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*FF ALLOC Scenario 3: Try to allocate a block with a size equal to the size of the first existing free block*/
	cprintf("3: Try to allocate a block with equal to the first existing free block\n\n") ;
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	68 68 42 80 00       	push   $0x804268
  800646:	e8 d3 06 00 00       	call   800d1e <cprintf>
  80064b:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80064e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		actualSize = kilo/8 - sizeOfMetaData; 	//expected to be allocated in remaining of 4th free block
  800655:	c7 45 a8 78 00 00 00 	movl   $0x78,-0x58(%ebp)
		expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  80065c:	c7 85 70 ff ff ff 02 	movl   $0x2,-0x90(%ebp)
  800663:	00 00 00 
  800666:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800669:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	83 c0 07             	add    $0x7,%eax
  800674:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80067a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800680:	ba 00 00 00 00       	mov    $0x0,%edx
  800685:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  80068b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800691:	29 d0                	sub    %edx,%eax
  800693:	89 45 d8             	mov    %eax,-0x28(%ebp)
		va = tstStartVAs[numOfFFTests] = malloc(actualSize);
  800696:	83 ec 0c             	sub    $0xc,%esp
  800699:	ff 75 a8             	pushl  -0x58(%ebp)
  80069c:	e8 2d 14 00 00       	call   801ace <malloc>
  8006a1:	83 c4 10             	add    $0x10,%esp
  8006a4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  8006aa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006b0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		tstMidVAs[numOfFFTests] = va + actualSize/2 ;
  8006b3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8006b6:	d1 e8                	shr    %eax
  8006b8:	89 c2                	mov    %eax,%edx
  8006ba:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		tstEndVAs[numOfFFTests] = va + actualSize - sizeof(short);
  8006c5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8006c8:	8d 50 fe             	lea    -0x2(%eax),%edx
  8006cb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8006ce:	01 d0                	add    %edx,%eax
  8006d0:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		//Check returned va
		expectedVA = (void*)(startOf4thFreeBlock + testSizes[0] + testSizes[2]) ;
  8006d6:	8b 95 2c ff ff ff    	mov    -0xd4(%ebp),%edx
  8006dc:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e2:	01 c2                	add    %eax,%edx
  8006e4:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  8006ea:	01 d0                	add    %edx,%eax
  8006ec:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (check_block(tstStartVAs[numOfFFTests], expectedVA, expectedSize, 1) == 0)
  8006ef:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006f5:	6a 01                	push   $0x1
  8006f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fa:	ff 75 a0             	pushl  -0x60(%ebp)
  8006fd:	50                   	push   %eax
  8006fe:	e8 35 f9 ff ff       	call   800038 <check_block>
  800703:	83 c4 10             	add    $0x10,%esp
  800706:	85 c0                	test   %eax,%eax
  800708:	75 17                	jne    800721 <_main+0x661>
		{
			is_correct = 0;
  80070a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_ff_2 #3: WRONG ALLOCATE AFTER FREE!\n");
  800711:	83 ec 0c             	sub    $0xc,%esp
  800714:	68 b4 42 80 00       	push   $0x8042b4
  800719:	e8 00 06 00 00       	call   800d1e <cprintf>
  80071e:	83 c4 10             	add    $0x10,%esp
		}
		*(tstStartVAs[numOfFFTests]) = 353 + numOfFFTests;
  800721:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800727:	66 c7 00 64 01       	movw   $0x164,(%eax)
		*(tstMidVAs[numOfFFTests]) = 353 + numOfFFTests;
  80072c:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800732:	66 c7 00 64 01       	movw   $0x164,(%eax)
		*(tstEndVAs[numOfFFTests]) = 353 + numOfFFTests;
  800737:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80073d:	66 c7 00 64 01       	movw   $0x164,(%eax)

		if (is_correct)
  800742:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800746:	74 04                	je     80074c <_main+0x68c>
		{
			eval += 30;
  800748:	83 45 e4 1e          	addl   $0x1e,-0x1c(%ebp)
		}
	}
	//====================================================================//
	/*FF ALLOC Scenario 4: Check stored data inside each allocated block*/
	cprintf("4: Check stored data inside each allocated block\n\n") ;
  80074c:	83 ec 0c             	sub    $0xc,%esp
  80074f:	68 e0 42 80 00       	push   $0x8042e0
  800754:	e8 c5 05 00 00       	call   800d1e <cprintf>
  800759:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80075c:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		for (int i = 0; i <= numOfFFTests; ++i)
  800763:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  80076a:	e9 ab 00 00 00       	jmp    80081a <_main+0x75a>
		{
			//cprintf("startVA = %x, mid = %x, last = %x\n", tstStartVAs[i], tstMidVAs[i], tstEndVAs[i]);
			if (*(tstStartVAs[i]) != (353+i) || *(tstMidVAs[i]) != (353+i) || *(tstEndVAs[i]) != (353+i) )
  80076f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800772:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  800779:	66 8b 00             	mov    (%eax),%ax
  80077c:	98                   	cwtl   
  80077d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800780:	81 c2 61 01 00 00    	add    $0x161,%edx
  800786:	39 d0                	cmp    %edx,%eax
  800788:	75 36                	jne    8007c0 <_main+0x700>
  80078a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80078d:	8b 84 85 48 ff ff ff 	mov    -0xb8(%ebp,%eax,4),%eax
  800794:	66 8b 00             	mov    (%eax),%ax
  800797:	98                   	cwtl   
  800798:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80079b:	81 c2 61 01 00 00    	add    $0x161,%edx
  8007a1:	39 d0                	cmp    %edx,%eax
  8007a3:	75 1b                	jne    8007c0 <_main+0x700>
  8007a5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8007a8:	8b 84 85 38 ff ff ff 	mov    -0xc8(%ebp,%eax,4),%eax
  8007af:	66 8b 00             	mov    (%eax),%ax
  8007b2:	98                   	cwtl   
  8007b3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8007b6:	81 c2 61 01 00 00    	add    $0x161,%edx
  8007bc:	39 d0                	cmp    %edx,%eax
  8007be:	74 57                	je     800817 <_main+0x757>
			{
				is_correct = 0;
  8007c0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("malloc #4.%d: WRONG! content of the block is not correct. Expected=%d, val1=%d, val2=%d, val3=%d\n",i, (353+i), *(tstStartVAs[i]), *(tstMidVAs[i]), *(tstEndVAs[i]));
  8007c7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8007ca:	8b 84 85 38 ff ff ff 	mov    -0xc8(%ebp,%eax,4),%eax
  8007d1:	66 8b 00             	mov    (%eax),%ax
  8007d4:	0f bf c8             	movswl %ax,%ecx
  8007d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8007da:	8b 84 85 48 ff ff ff 	mov    -0xb8(%ebp,%eax,4),%eax
  8007e1:	66 8b 00             	mov    (%eax),%ax
  8007e4:	0f bf d0             	movswl %ax,%edx
  8007e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8007ea:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  8007f1:	66 8b 00             	mov    (%eax),%ax
  8007f4:	98                   	cwtl   
  8007f5:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8007f8:	81 c3 61 01 00 00    	add    $0x161,%ebx
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	51                   	push   %ecx
  800802:	52                   	push   %edx
  800803:	50                   	push   %eax
  800804:	53                   	push   %ebx
  800805:	ff 75 bc             	pushl  -0x44(%ebp)
  800808:	68 14 43 80 00       	push   $0x804314
  80080d:	e8 0c 05 00 00       	call   800d1e <cprintf>
  800812:	83 c4 20             	add    $0x20,%esp
				break;
  800815:	eb 0d                	jmp    800824 <_main+0x764>
	/*FF ALLOC Scenario 4: Check stored data inside each allocated block*/
	cprintf("4: Check stored data inside each allocated block\n\n") ;
	{
		is_correct = 1;

		for (int i = 0; i <= numOfFFTests; ++i)
  800817:	ff 45 bc             	incl   -0x44(%ebp)
  80081a:	83 7d bc 03          	cmpl   $0x3,-0x44(%ebp)
  80081e:	0f 8e 4b ff ff ff    	jle    80076f <_main+0x6af>
				cprintf("malloc #4.%d: WRONG! content of the block is not correct. Expected=%d, val1=%d, val2=%d, val3=%d\n",i, (353+i), *(tstStartVAs[i]), *(tstMidVAs[i]), *(tstEndVAs[i]));
				break;
			}
		}

		if (is_correct)
  800824:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800828:	74 04                	je     80082e <_main+0x76e>
		{
			eval += 20;
  80082a:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*FF ALLOC Scenario 5: Test a Non-Granted Request */
	cprintf("5: Test a Non-Granted Request\n\n") ;
  80082e:	83 ec 0c             	sub    $0xc,%esp
  800831:	68 78 43 80 00       	push   $0x804378
  800836:	e8 e3 04 00 00       	call   800d1e <cprintf>
  80083b:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80083e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		actualSize = 2*kilo - sizeOfMetaData;
  800845:	c7 45 a8 f8 07 00 00 	movl   $0x7f8,-0x58(%ebp)

		//Fill the 7th free block
		va = malloc(actualSize);
  80084c:	83 ec 0c             	sub    $0xc,%esp
  80084f:	ff 75 a8             	pushl  -0x58(%ebp)
  800852:	e8 77 12 00 00       	call   801ace <malloc>
  800857:	83 c4 10             	add    $0x10,%esp
  80085a:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//Fill the remaining area
		uint32 numOfRem2KBAllocs = ((USER_HEAP_START + DYN_ALLOC_MAX_SIZE - (uint32)sbrk(0)) / PAGE_SIZE) * 2;
  80085d:	83 ec 0c             	sub    $0xc,%esp
  800860:	6a 00                	push   $0x0
  800862:	e8 51 12 00 00       	call   801ab8 <sbrk>
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	ba 00 00 00 82       	mov    $0x82000000,%edx
  80086f:	29 c2                	sub    %eax,%edx
  800871:	89 d0                	mov    %edx,%eax
  800873:	c1 e8 0c             	shr    $0xc,%eax
  800876:	01 c0                	add    %eax,%eax
  800878:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		for (int i = 0; i < numOfRem2KBAllocs; ++i)
  80087e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800885:	eb 33                	jmp    8008ba <_main+0x7fa>
		{
			va = malloc(actualSize);
  800887:	83 ec 0c             	sub    $0xc,%esp
  80088a:	ff 75 a8             	pushl  -0x58(%ebp)
  80088d:	e8 3c 12 00 00       	call   801ace <malloc>
  800892:	83 c4 10             	add    $0x10,%esp
  800895:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if(va == NULL)
  800898:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  80089c:	75 19                	jne    8008b7 <_main+0x7f7>
			{
				is_correct = 0;
  80089e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("malloc() #5.%d: WRONG FF ALLOC - alloc_block_FF return NULL address while it's expected to return correct one.\n");
  8008a5:	83 ec 0c             	sub    $0xc,%esp
  8008a8:	68 98 43 80 00       	push   $0x804398
  8008ad:	e8 6c 04 00 00       	call   800d1e <cprintf>
  8008b2:	83 c4 10             	add    $0x10,%esp
				break;
  8008b5:	eb 0e                	jmp    8008c5 <_main+0x805>
		//Fill the 7th free block
		va = malloc(actualSize);

		//Fill the remaining area
		uint32 numOfRem2KBAllocs = ((USER_HEAP_START + DYN_ALLOC_MAX_SIZE - (uint32)sbrk(0)) / PAGE_SIZE) * 2;
		for (int i = 0; i < numOfRem2KBAllocs; ++i)
  8008b7:	ff 45 b8             	incl   -0x48(%ebp)
  8008ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8008bd:	3b 85 68 ff ff ff    	cmp    -0x98(%ebp),%eax
  8008c3:	72 c2                	jb     800887 <_main+0x7c7>
				break;
			}
		}

		//Test two more allocs
		va = malloc(actualSize);
  8008c5:	83 ec 0c             	sub    $0xc,%esp
  8008c8:	ff 75 a8             	pushl  -0x58(%ebp)
  8008cb:	e8 fe 11 00 00       	call   801ace <malloc>
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		va = malloc(actualSize);
  8008d6:	83 ec 0c             	sub    $0xc,%esp
  8008d9:	ff 75 a8             	pushl  -0x58(%ebp)
  8008dc:	e8 ed 11 00 00       	call   801ace <malloc>
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		if(va != NULL)
  8008e7:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  8008eb:	74 17                	je     800904 <_main+0x844>
		{
			is_correct = 0;
  8008ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("malloc() #6: WRONG FF ALLOC - alloc_block_FF return an address while it's expected to return NULL since it reaches the hard limit.\n");
  8008f4:	83 ec 0c             	sub    $0xc,%esp
  8008f7:	68 08 44 80 00       	push   $0x804408
  8008fc:	e8 1d 04 00 00       	call   800d1e <cprintf>
  800901:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800904:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800908:	74 04                	je     80090e <_main+0x84e>
		{
			eval += 20;
  80090a:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
		}
	}
	cprintf("test FIRST FIT (2) [DYNAMIC ALLOCATOR] is finished. Evaluation = %d%\n", eval);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 e4             	pushl  -0x1c(%ebp)
  800914:	68 8c 44 80 00       	push   $0x80448c
  800919:	e8 00 04 00 00       	call   800d1e <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp

	return;
  800921:	90                   	nop
}
  800922:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800925:	5b                   	pop    %ebx
  800926:	5e                   	pop    %esi
  800927:	5f                   	pop    %edi
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800930:	e8 96 15 00 00       	call   801ecb <sys_getenvindex>
  800935:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800938:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80093b:	89 d0                	mov    %edx,%eax
  80093d:	c1 e0 02             	shl    $0x2,%eax
  800940:	01 d0                	add    %edx,%eax
  800942:	01 c0                	add    %eax,%eax
  800944:	01 d0                	add    %edx,%eax
  800946:	c1 e0 02             	shl    $0x2,%eax
  800949:	01 d0                	add    %edx,%eax
  80094b:	01 c0                	add    %eax,%eax
  80094d:	01 d0                	add    %edx,%eax
  80094f:	c1 e0 04             	shl    $0x4,%eax
  800952:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800957:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80095c:	a1 20 50 80 00       	mov    0x805020,%eax
  800961:	8a 40 20             	mov    0x20(%eax),%al
  800964:	84 c0                	test   %al,%al
  800966:	74 0d                	je     800975 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800968:	a1 20 50 80 00       	mov    0x805020,%eax
  80096d:	83 c0 20             	add    $0x20,%eax
  800970:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800975:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800979:	7e 0a                	jle    800985 <libmain+0x5b>
		binaryname = argv[0];
  80097b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	_main(argc, argv);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	ff 75 08             	pushl  0x8(%ebp)
  80098e:	e8 2d f7 ff ff       	call   8000c0 <_main>
  800993:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800996:	e8 b4 12 00 00       	call   801c4f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80099b:	83 ec 0c             	sub    $0xc,%esp
  80099e:	68 f8 44 80 00       	push   $0x8044f8
  8009a3:	e8 76 03 00 00       	call   800d1e <cprintf>
  8009a8:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b0:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8009b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8009bb:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8009c1:	83 ec 04             	sub    $0x4,%esp
  8009c4:	52                   	push   %edx
  8009c5:	50                   	push   %eax
  8009c6:	68 20 45 80 00       	push   $0x804520
  8009cb:	e8 4e 03 00 00       	call   800d1e <cprintf>
  8009d0:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8009d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8009d8:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8009de:	a1 20 50 80 00       	mov    0x805020,%eax
  8009e3:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8009e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8009ee:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8009f4:	51                   	push   %ecx
  8009f5:	52                   	push   %edx
  8009f6:	50                   	push   %eax
  8009f7:	68 48 45 80 00       	push   $0x804548
  8009fc:	e8 1d 03 00 00       	call   800d1e <cprintf>
  800a01:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a04:	a1 20 50 80 00       	mov    0x805020,%eax
  800a09:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	50                   	push   %eax
  800a13:	68 a0 45 80 00       	push   $0x8045a0
  800a18:	e8 01 03 00 00       	call   800d1e <cprintf>
  800a1d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800a20:	83 ec 0c             	sub    $0xc,%esp
  800a23:	68 f8 44 80 00       	push   $0x8044f8
  800a28:	e8 f1 02 00 00       	call   800d1e <cprintf>
  800a2d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800a30:	e8 34 12 00 00       	call   801c69 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800a35:	e8 19 00 00 00       	call   800a53 <exit>
}
  800a3a:	90                   	nop
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a43:	83 ec 0c             	sub    $0xc,%esp
  800a46:	6a 00                	push   $0x0
  800a48:	e8 4a 14 00 00       	call   801e97 <sys_destroy_env>
  800a4d:	83 c4 10             	add    $0x10,%esp
}
  800a50:	90                   	nop
  800a51:	c9                   	leave  
  800a52:	c3                   	ret    

00800a53 <exit>:

void
exit(void)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a59:	e8 9f 14 00 00       	call   801efd <sys_exit_env>
}
  800a5e:	90                   	nop
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a67:	8d 45 10             	lea    0x10(%ebp),%eax
  800a6a:	83 c0 04             	add    $0x4,%eax
  800a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a70:	a1 54 92 80 00       	mov    0x809254,%eax
  800a75:	85 c0                	test   %eax,%eax
  800a77:	74 16                	je     800a8f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a79:	a1 54 92 80 00       	mov    0x809254,%eax
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	50                   	push   %eax
  800a82:	68 b4 45 80 00       	push   $0x8045b4
  800a87:	e8 92 02 00 00       	call   800d1e <cprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a8f:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	ff 75 08             	pushl  0x8(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	68 b9 45 80 00       	push   $0x8045b9
  800aa0:	e8 79 02 00 00       	call   800d1e <cprintf>
  800aa5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800aa8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab1:	50                   	push   %eax
  800ab2:	e8 fc 01 00 00       	call   800cb3 <vcprintf>
  800ab7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	6a 00                	push   $0x0
  800abf:	68 d5 45 80 00       	push   $0x8045d5
  800ac4:	e8 ea 01 00 00       	call   800cb3 <vcprintf>
  800ac9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800acc:	e8 82 ff ff ff       	call   800a53 <exit>

	// should not return here
	while (1) ;
  800ad1:	eb fe                	jmp    800ad1 <_panic+0x70>

00800ad3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800ad9:	a1 20 50 80 00       	mov    0x805020,%eax
  800ade:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae7:	39 c2                	cmp    %eax,%edx
  800ae9:	74 14                	je     800aff <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800aeb:	83 ec 04             	sub    $0x4,%esp
  800aee:	68 d8 45 80 00       	push   $0x8045d8
  800af3:	6a 26                	push   $0x26
  800af5:	68 24 46 80 00       	push   $0x804624
  800afa:	e8 62 ff ff ff       	call   800a61 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b06:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b0d:	e9 c5 00 00 00       	jmp    800bd7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	01 d0                	add    %edx,%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	85 c0                	test   %eax,%eax
  800b25:	75 08                	jne    800b2f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800b27:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b2a:	e9 a5 00 00 00       	jmp    800bd4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800b2f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b36:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b3d:	eb 69                	jmp    800ba8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800b44:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800b4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b4d:	89 d0                	mov    %edx,%eax
  800b4f:	01 c0                	add    %eax,%eax
  800b51:	01 d0                	add    %edx,%eax
  800b53:	c1 e0 03             	shl    $0x3,%eax
  800b56:	01 c8                	add    %ecx,%eax
  800b58:	8a 40 04             	mov    0x4(%eax),%al
  800b5b:	84 c0                	test   %al,%al
  800b5d:	75 46                	jne    800ba5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b5f:	a1 20 50 80 00       	mov    0x805020,%eax
  800b64:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800b6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b6d:	89 d0                	mov    %edx,%eax
  800b6f:	01 c0                	add    %eax,%eax
  800b71:	01 d0                	add    %edx,%eax
  800b73:	c1 e0 03             	shl    $0x3,%eax
  800b76:	01 c8                	add    %ecx,%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b85:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b8a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	01 c8                	add    %ecx,%eax
  800b96:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b98:	39 c2                	cmp    %eax,%edx
  800b9a:	75 09                	jne    800ba5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800b9c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ba3:	eb 15                	jmp    800bba <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ba5:	ff 45 e8             	incl   -0x18(%ebp)
  800ba8:	a1 20 50 80 00       	mov    0x805020,%eax
  800bad:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800bb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800bb6:	39 c2                	cmp    %eax,%edx
  800bb8:	77 85                	ja     800b3f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800bba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800bbe:	75 14                	jne    800bd4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800bc0:	83 ec 04             	sub    $0x4,%esp
  800bc3:	68 30 46 80 00       	push   $0x804630
  800bc8:	6a 3a                	push   $0x3a
  800bca:	68 24 46 80 00       	push   $0x804624
  800bcf:	e8 8d fe ff ff       	call   800a61 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800bd4:	ff 45 f0             	incl   -0x10(%ebp)
  800bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bda:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800bdd:	0f 8c 2f ff ff ff    	jl     800b12 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800be3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bf1:	eb 26                	jmp    800c19 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bf3:	a1 20 50 80 00       	mov    0x805020,%eax
  800bf8:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800bfe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c01:	89 d0                	mov    %edx,%eax
  800c03:	01 c0                	add    %eax,%eax
  800c05:	01 d0                	add    %edx,%eax
  800c07:	c1 e0 03             	shl    $0x3,%eax
  800c0a:	01 c8                	add    %ecx,%eax
  800c0c:	8a 40 04             	mov    0x4(%eax),%al
  800c0f:	3c 01                	cmp    $0x1,%al
  800c11:	75 03                	jne    800c16 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800c13:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c16:	ff 45 e0             	incl   -0x20(%ebp)
  800c19:	a1 20 50 80 00       	mov    0x805020,%eax
  800c1e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800c24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c27:	39 c2                	cmp    %eax,%edx
  800c29:	77 c8                	ja     800bf3 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c31:	74 14                	je     800c47 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800c33:	83 ec 04             	sub    $0x4,%esp
  800c36:	68 84 46 80 00       	push   $0x804684
  800c3b:	6a 44                	push   $0x44
  800c3d:	68 24 46 80 00       	push   $0x804624
  800c42:	e8 1a fe ff ff       	call   800a61 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c47:	90                   	nop
  800c48:	c9                   	leave  
  800c49:	c3                   	ret    

00800c4a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8b 00                	mov    (%eax),%eax
  800c55:	8d 48 01             	lea    0x1(%eax),%ecx
  800c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5b:	89 0a                	mov    %ecx,(%edx)
  800c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c60:	88 d1                	mov    %dl,%cl
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6c:	8b 00                	mov    (%eax),%eax
  800c6e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c73:	75 2c                	jne    800ca1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c75:	a0 40 50 80 00       	mov    0x805040,%al
  800c7a:	0f b6 c0             	movzbl %al,%eax
  800c7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c80:	8b 12                	mov    (%edx),%edx
  800c82:	89 d1                	mov    %edx,%ecx
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	83 c2 08             	add    $0x8,%edx
  800c8a:	83 ec 04             	sub    $0x4,%esp
  800c8d:	50                   	push   %eax
  800c8e:	51                   	push   %ecx
  800c8f:	52                   	push   %edx
  800c90:	e8 78 0f 00 00       	call   801c0d <sys_cputs>
  800c95:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca4:	8b 40 04             	mov    0x4(%eax),%eax
  800ca7:	8d 50 01             	lea    0x1(%eax),%edx
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cb0:	90                   	nop
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800cbc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800cc3:	00 00 00 
	b.cnt = 0;
  800cc6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ccd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800cd0:	ff 75 0c             	pushl  0xc(%ebp)
  800cd3:	ff 75 08             	pushl  0x8(%ebp)
  800cd6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cdc:	50                   	push   %eax
  800cdd:	68 4a 0c 80 00       	push   $0x800c4a
  800ce2:	e8 11 02 00 00       	call   800ef8 <vprintfmt>
  800ce7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800cea:	a0 40 50 80 00       	mov    0x805040,%al
  800cef:	0f b6 c0             	movzbl %al,%eax
  800cf2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800cf8:	83 ec 04             	sub    $0x4,%esp
  800cfb:	50                   	push   %eax
  800cfc:	52                   	push   %edx
  800cfd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d03:	83 c0 08             	add    $0x8,%eax
  800d06:	50                   	push   %eax
  800d07:	e8 01 0f 00 00       	call   801c0d <sys_cputs>
  800d0c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d0f:	c6 05 40 50 80 00 00 	movb   $0x0,0x805040
	return b.cnt;
  800d16:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d1c:	c9                   	leave  
  800d1d:	c3                   	ret    

00800d1e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d24:	c6 05 40 50 80 00 01 	movb   $0x1,0x805040
	va_start(ap, fmt);
  800d2b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	83 ec 08             	sub    $0x8,%esp
  800d37:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3a:	50                   	push   %eax
  800d3b:	e8 73 ff ff ff       	call   800cb3 <vcprintf>
  800d40:	83 c4 10             	add    $0x10,%esp
  800d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d49:	c9                   	leave  
  800d4a:	c3                   	ret    

00800d4b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800d51:	e8 f9 0e 00 00       	call   801c4f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d56:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	83 ec 08             	sub    $0x8,%esp
  800d62:	ff 75 f4             	pushl  -0xc(%ebp)
  800d65:	50                   	push   %eax
  800d66:	e8 48 ff ff ff       	call   800cb3 <vcprintf>
  800d6b:	83 c4 10             	add    $0x10,%esp
  800d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d71:	e8 f3 0e 00 00       	call   801c69 <sys_unlock_cons>
	return cnt;
  800d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d79:	c9                   	leave  
  800d7a:	c3                   	ret    

00800d7b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	53                   	push   %ebx
  800d7f:	83 ec 14             	sub    $0x14,%esp
  800d82:	8b 45 10             	mov    0x10(%ebp),%eax
  800d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d88:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d8e:	8b 45 18             	mov    0x18(%ebp),%eax
  800d91:	ba 00 00 00 00       	mov    $0x0,%edx
  800d96:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d99:	77 55                	ja     800df0 <printnum+0x75>
  800d9b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d9e:	72 05                	jb     800da5 <printnum+0x2a>
  800da0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800da3:	77 4b                	ja     800df0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800da5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800da8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800dab:	8b 45 18             	mov    0x18(%ebp),%eax
  800dae:	ba 00 00 00 00       	mov    $0x0,%edx
  800db3:	52                   	push   %edx
  800db4:	50                   	push   %eax
  800db5:	ff 75 f4             	pushl  -0xc(%ebp)
  800db8:	ff 75 f0             	pushl  -0x10(%ebp)
  800dbb:	e8 10 2f 00 00       	call   803cd0 <__udivdi3>
  800dc0:	83 c4 10             	add    $0x10,%esp
  800dc3:	83 ec 04             	sub    $0x4,%esp
  800dc6:	ff 75 20             	pushl  0x20(%ebp)
  800dc9:	53                   	push   %ebx
  800dca:	ff 75 18             	pushl  0x18(%ebp)
  800dcd:	52                   	push   %edx
  800dce:	50                   	push   %eax
  800dcf:	ff 75 0c             	pushl  0xc(%ebp)
  800dd2:	ff 75 08             	pushl  0x8(%ebp)
  800dd5:	e8 a1 ff ff ff       	call   800d7b <printnum>
  800dda:	83 c4 20             	add    $0x20,%esp
  800ddd:	eb 1a                	jmp    800df9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ddf:	83 ec 08             	sub    $0x8,%esp
  800de2:	ff 75 0c             	pushl  0xc(%ebp)
  800de5:	ff 75 20             	pushl  0x20(%ebp)
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	ff d0                	call   *%eax
  800ded:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800df0:	ff 4d 1c             	decl   0x1c(%ebp)
  800df3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800df7:	7f e6                	jg     800ddf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800df9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e07:	53                   	push   %ebx
  800e08:	51                   	push   %ecx
  800e09:	52                   	push   %edx
  800e0a:	50                   	push   %eax
  800e0b:	e8 d0 2f 00 00       	call   803de0 <__umoddi3>
  800e10:	83 c4 10             	add    $0x10,%esp
  800e13:	05 f4 48 80 00       	add    $0x8048f4,%eax
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	0f be c0             	movsbl %al,%eax
  800e1d:	83 ec 08             	sub    $0x8,%esp
  800e20:	ff 75 0c             	pushl  0xc(%ebp)
  800e23:	50                   	push   %eax
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	ff d0                	call   *%eax
  800e29:	83 c4 10             	add    $0x10,%esp
}
  800e2c:	90                   	nop
  800e2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e35:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e39:	7e 1c                	jle    800e57 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8b 00                	mov    (%eax),%eax
  800e40:	8d 50 08             	lea    0x8(%eax),%edx
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	89 10                	mov    %edx,(%eax)
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8b 00                	mov    (%eax),%eax
  800e4d:	83 e8 08             	sub    $0x8,%eax
  800e50:	8b 50 04             	mov    0x4(%eax),%edx
  800e53:	8b 00                	mov    (%eax),%eax
  800e55:	eb 40                	jmp    800e97 <getuint+0x65>
	else if (lflag)
  800e57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5b:	74 1e                	je     800e7b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8b 00                	mov    (%eax),%eax
  800e62:	8d 50 04             	lea    0x4(%eax),%edx
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	89 10                	mov    %edx,(%eax)
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8b 00                	mov    (%eax),%eax
  800e6f:	83 e8 04             	sub    $0x4,%eax
  800e72:	8b 00                	mov    (%eax),%eax
  800e74:	ba 00 00 00 00       	mov    $0x0,%edx
  800e79:	eb 1c                	jmp    800e97 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8b 00                	mov    (%eax),%eax
  800e80:	8d 50 04             	lea    0x4(%eax),%edx
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 10                	mov    %edx,(%eax)
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8b 00                	mov    (%eax),%eax
  800e8d:	83 e8 04             	sub    $0x4,%eax
  800e90:	8b 00                	mov    (%eax),%eax
  800e92:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e9c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ea0:	7e 1c                	jle    800ebe <getint+0x25>
		return va_arg(*ap, long long);
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8b 00                	mov    (%eax),%eax
  800ea7:	8d 50 08             	lea    0x8(%eax),%edx
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	89 10                	mov    %edx,(%eax)
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8b 00                	mov    (%eax),%eax
  800eb4:	83 e8 08             	sub    $0x8,%eax
  800eb7:	8b 50 04             	mov    0x4(%eax),%edx
  800eba:	8b 00                	mov    (%eax),%eax
  800ebc:	eb 38                	jmp    800ef6 <getint+0x5d>
	else if (lflag)
  800ebe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec2:	74 1a                	je     800ede <getint+0x45>
		return va_arg(*ap, long);
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8b 00                	mov    (%eax),%eax
  800ec9:	8d 50 04             	lea    0x4(%eax),%edx
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	89 10                	mov    %edx,(%eax)
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8b 00                	mov    (%eax),%eax
  800ed6:	83 e8 04             	sub    $0x4,%eax
  800ed9:	8b 00                	mov    (%eax),%eax
  800edb:	99                   	cltd   
  800edc:	eb 18                	jmp    800ef6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8b 00                	mov    (%eax),%eax
  800ee3:	8d 50 04             	lea    0x4(%eax),%edx
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	89 10                	mov    %edx,(%eax)
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8b 00                	mov    (%eax),%eax
  800ef0:	83 e8 04             	sub    $0x4,%eax
  800ef3:	8b 00                	mov    (%eax),%eax
  800ef5:	99                   	cltd   
}
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	56                   	push   %esi
  800efc:	53                   	push   %ebx
  800efd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f00:	eb 17                	jmp    800f19 <vprintfmt+0x21>
			if (ch == '\0')
  800f02:	85 db                	test   %ebx,%ebx
  800f04:	0f 84 c1 03 00 00    	je     8012cb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	53                   	push   %ebx
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	ff d0                	call   *%eax
  800f16:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	8d 50 01             	lea    0x1(%eax),%edx
  800f1f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 d8             	movzbl %al,%ebx
  800f27:	83 fb 25             	cmp    $0x25,%ebx
  800f2a:	75 d6                	jne    800f02 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f2c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f30:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f37:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f3e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f45:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4f:	8d 50 01             	lea    0x1(%eax),%edx
  800f52:	89 55 10             	mov    %edx,0x10(%ebp)
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	0f b6 d8             	movzbl %al,%ebx
  800f5a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f5d:	83 f8 5b             	cmp    $0x5b,%eax
  800f60:	0f 87 3d 03 00 00    	ja     8012a3 <vprintfmt+0x3ab>
  800f66:	8b 04 85 18 49 80 00 	mov    0x804918(,%eax,4),%eax
  800f6d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f6f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f73:	eb d7                	jmp    800f4c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f75:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f79:	eb d1                	jmp    800f4c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f7b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f82:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f85:	89 d0                	mov    %edx,%eax
  800f87:	c1 e0 02             	shl    $0x2,%eax
  800f8a:	01 d0                	add    %edx,%eax
  800f8c:	01 c0                	add    %eax,%eax
  800f8e:	01 d8                	add    %ebx,%eax
  800f90:	83 e8 30             	sub    $0x30,%eax
  800f93:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f96:	8b 45 10             	mov    0x10(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f9e:	83 fb 2f             	cmp    $0x2f,%ebx
  800fa1:	7e 3e                	jle    800fe1 <vprintfmt+0xe9>
  800fa3:	83 fb 39             	cmp    $0x39,%ebx
  800fa6:	7f 39                	jg     800fe1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fa8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fab:	eb d5                	jmp    800f82 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800fad:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb0:	83 c0 04             	add    $0x4,%eax
  800fb3:	89 45 14             	mov    %eax,0x14(%ebp)
  800fb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb9:	83 e8 04             	sub    $0x4,%eax
  800fbc:	8b 00                	mov    (%eax),%eax
  800fbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800fc1:	eb 1f                	jmp    800fe2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800fc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fc7:	79 83                	jns    800f4c <vprintfmt+0x54>
				width = 0;
  800fc9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800fd0:	e9 77 ff ff ff       	jmp    800f4c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fd5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800fdc:	e9 6b ff ff ff       	jmp    800f4c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fe1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fe2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe6:	0f 89 60 ff ff ff    	jns    800f4c <vprintfmt+0x54>
				width = precision, precision = -1;
  800fec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ff2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ff9:	e9 4e ff ff ff       	jmp    800f4c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ffe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801001:	e9 46 ff ff ff       	jmp    800f4c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801006:	8b 45 14             	mov    0x14(%ebp),%eax
  801009:	83 c0 04             	add    $0x4,%eax
  80100c:	89 45 14             	mov    %eax,0x14(%ebp)
  80100f:	8b 45 14             	mov    0x14(%ebp),%eax
  801012:	83 e8 04             	sub    $0x4,%eax
  801015:	8b 00                	mov    (%eax),%eax
  801017:	83 ec 08             	sub    $0x8,%esp
  80101a:	ff 75 0c             	pushl  0xc(%ebp)
  80101d:	50                   	push   %eax
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	ff d0                	call   *%eax
  801023:	83 c4 10             	add    $0x10,%esp
			break;
  801026:	e9 9b 02 00 00       	jmp    8012c6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80102b:	8b 45 14             	mov    0x14(%ebp),%eax
  80102e:	83 c0 04             	add    $0x4,%eax
  801031:	89 45 14             	mov    %eax,0x14(%ebp)
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	83 e8 04             	sub    $0x4,%eax
  80103a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80103c:	85 db                	test   %ebx,%ebx
  80103e:	79 02                	jns    801042 <vprintfmt+0x14a>
				err = -err;
  801040:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801042:	83 fb 64             	cmp    $0x64,%ebx
  801045:	7f 0b                	jg     801052 <vprintfmt+0x15a>
  801047:	8b 34 9d 60 47 80 00 	mov    0x804760(,%ebx,4),%esi
  80104e:	85 f6                	test   %esi,%esi
  801050:	75 19                	jne    80106b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801052:	53                   	push   %ebx
  801053:	68 05 49 80 00       	push   $0x804905
  801058:	ff 75 0c             	pushl  0xc(%ebp)
  80105b:	ff 75 08             	pushl  0x8(%ebp)
  80105e:	e8 70 02 00 00       	call   8012d3 <printfmt>
  801063:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801066:	e9 5b 02 00 00       	jmp    8012c6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80106b:	56                   	push   %esi
  80106c:	68 0e 49 80 00       	push   $0x80490e
  801071:	ff 75 0c             	pushl  0xc(%ebp)
  801074:	ff 75 08             	pushl  0x8(%ebp)
  801077:	e8 57 02 00 00       	call   8012d3 <printfmt>
  80107c:	83 c4 10             	add    $0x10,%esp
			break;
  80107f:	e9 42 02 00 00       	jmp    8012c6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801084:	8b 45 14             	mov    0x14(%ebp),%eax
  801087:	83 c0 04             	add    $0x4,%eax
  80108a:	89 45 14             	mov    %eax,0x14(%ebp)
  80108d:	8b 45 14             	mov    0x14(%ebp),%eax
  801090:	83 e8 04             	sub    $0x4,%eax
  801093:	8b 30                	mov    (%eax),%esi
  801095:	85 f6                	test   %esi,%esi
  801097:	75 05                	jne    80109e <vprintfmt+0x1a6>
				p = "(null)";
  801099:	be 11 49 80 00       	mov    $0x804911,%esi
			if (width > 0 && padc != '-')
  80109e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010a2:	7e 6d                	jle    801111 <vprintfmt+0x219>
  8010a4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010a8:	74 67                	je     801111 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010ad:	83 ec 08             	sub    $0x8,%esp
  8010b0:	50                   	push   %eax
  8010b1:	56                   	push   %esi
  8010b2:	e8 1e 03 00 00       	call   8013d5 <strnlen>
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8010bd:	eb 16                	jmp    8010d5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8010bf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8010c3:	83 ec 08             	sub    $0x8,%esp
  8010c6:	ff 75 0c             	pushl  0xc(%ebp)
  8010c9:	50                   	push   %eax
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	ff d0                	call   *%eax
  8010cf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8010d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8010d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010d9:	7f e4                	jg     8010bf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010db:	eb 34                	jmp    801111 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010e1:	74 1c                	je     8010ff <vprintfmt+0x207>
  8010e3:	83 fb 1f             	cmp    $0x1f,%ebx
  8010e6:	7e 05                	jle    8010ed <vprintfmt+0x1f5>
  8010e8:	83 fb 7e             	cmp    $0x7e,%ebx
  8010eb:	7e 12                	jle    8010ff <vprintfmt+0x207>
					putch('?', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 3f                	push   $0x3f
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
  8010fd:	eb 0f                	jmp    80110e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010ff:	83 ec 08             	sub    $0x8,%esp
  801102:	ff 75 0c             	pushl  0xc(%ebp)
  801105:	53                   	push   %ebx
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	ff d0                	call   *%eax
  80110b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80110e:	ff 4d e4             	decl   -0x1c(%ebp)
  801111:	89 f0                	mov    %esi,%eax
  801113:	8d 70 01             	lea    0x1(%eax),%esi
  801116:	8a 00                	mov    (%eax),%al
  801118:	0f be d8             	movsbl %al,%ebx
  80111b:	85 db                	test   %ebx,%ebx
  80111d:	74 24                	je     801143 <vprintfmt+0x24b>
  80111f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801123:	78 b8                	js     8010dd <vprintfmt+0x1e5>
  801125:	ff 4d e0             	decl   -0x20(%ebp)
  801128:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80112c:	79 af                	jns    8010dd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80112e:	eb 13                	jmp    801143 <vprintfmt+0x24b>
				putch(' ', putdat);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	6a 20                	push   $0x20
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	ff d0                	call   *%eax
  80113d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801140:	ff 4d e4             	decl   -0x1c(%ebp)
  801143:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801147:	7f e7                	jg     801130 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801149:	e9 78 01 00 00       	jmp    8012c6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80114e:	83 ec 08             	sub    $0x8,%esp
  801151:	ff 75 e8             	pushl  -0x18(%ebp)
  801154:	8d 45 14             	lea    0x14(%ebp),%eax
  801157:	50                   	push   %eax
  801158:	e8 3c fd ff ff       	call   800e99 <getint>
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801163:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801169:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116c:	85 d2                	test   %edx,%edx
  80116e:	79 23                	jns    801193 <vprintfmt+0x29b>
				putch('-', putdat);
  801170:	83 ec 08             	sub    $0x8,%esp
  801173:	ff 75 0c             	pushl  0xc(%ebp)
  801176:	6a 2d                	push   $0x2d
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	ff d0                	call   *%eax
  80117d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801183:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801186:	f7 d8                	neg    %eax
  801188:	83 d2 00             	adc    $0x0,%edx
  80118b:	f7 da                	neg    %edx
  80118d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801190:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801193:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80119a:	e9 bc 00 00 00       	jmp    80125b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80119f:	83 ec 08             	sub    $0x8,%esp
  8011a2:	ff 75 e8             	pushl  -0x18(%ebp)
  8011a5:	8d 45 14             	lea    0x14(%ebp),%eax
  8011a8:	50                   	push   %eax
  8011a9:	e8 84 fc ff ff       	call   800e32 <getuint>
  8011ae:	83 c4 10             	add    $0x10,%esp
  8011b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8011b7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011be:	e9 98 00 00 00       	jmp    80125b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	ff 75 0c             	pushl  0xc(%ebp)
  8011c9:	6a 58                	push   $0x58
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	ff d0                	call   *%eax
  8011d0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011d3:	83 ec 08             	sub    $0x8,%esp
  8011d6:	ff 75 0c             	pushl  0xc(%ebp)
  8011d9:	6a 58                	push   $0x58
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	ff d0                	call   *%eax
  8011e0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011e3:	83 ec 08             	sub    $0x8,%esp
  8011e6:	ff 75 0c             	pushl  0xc(%ebp)
  8011e9:	6a 58                	push   $0x58
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	ff d0                	call   *%eax
  8011f0:	83 c4 10             	add    $0x10,%esp
			break;
  8011f3:	e9 ce 00 00 00       	jmp    8012c6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8011f8:	83 ec 08             	sub    $0x8,%esp
  8011fb:	ff 75 0c             	pushl  0xc(%ebp)
  8011fe:	6a 30                	push   $0x30
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	ff d0                	call   *%eax
  801205:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801208:	83 ec 08             	sub    $0x8,%esp
  80120b:	ff 75 0c             	pushl  0xc(%ebp)
  80120e:	6a 78                	push   $0x78
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	ff d0                	call   *%eax
  801215:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801218:	8b 45 14             	mov    0x14(%ebp),%eax
  80121b:	83 c0 04             	add    $0x4,%eax
  80121e:	89 45 14             	mov    %eax,0x14(%ebp)
  801221:	8b 45 14             	mov    0x14(%ebp),%eax
  801224:	83 e8 04             	sub    $0x4,%eax
  801227:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801229:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80122c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801233:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80123a:	eb 1f                	jmp    80125b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	ff 75 e8             	pushl  -0x18(%ebp)
  801242:	8d 45 14             	lea    0x14(%ebp),%eax
  801245:	50                   	push   %eax
  801246:	e8 e7 fb ff ff       	call   800e32 <getuint>
  80124b:	83 c4 10             	add    $0x10,%esp
  80124e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801251:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801254:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80125b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80125f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801262:	83 ec 04             	sub    $0x4,%esp
  801265:	52                   	push   %edx
  801266:	ff 75 e4             	pushl  -0x1c(%ebp)
  801269:	50                   	push   %eax
  80126a:	ff 75 f4             	pushl  -0xc(%ebp)
  80126d:	ff 75 f0             	pushl  -0x10(%ebp)
  801270:	ff 75 0c             	pushl  0xc(%ebp)
  801273:	ff 75 08             	pushl  0x8(%ebp)
  801276:	e8 00 fb ff ff       	call   800d7b <printnum>
  80127b:	83 c4 20             	add    $0x20,%esp
			break;
  80127e:	eb 46                	jmp    8012c6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801280:	83 ec 08             	sub    $0x8,%esp
  801283:	ff 75 0c             	pushl  0xc(%ebp)
  801286:	53                   	push   %ebx
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	ff d0                	call   *%eax
  80128c:	83 c4 10             	add    $0x10,%esp
			break;
  80128f:	eb 35                	jmp    8012c6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801291:	c6 05 40 50 80 00 00 	movb   $0x0,0x805040
			break;
  801298:	eb 2c                	jmp    8012c6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80129a:	c6 05 40 50 80 00 01 	movb   $0x1,0x805040
			break;
  8012a1:	eb 23                	jmp    8012c6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012a3:	83 ec 08             	sub    $0x8,%esp
  8012a6:	ff 75 0c             	pushl  0xc(%ebp)
  8012a9:	6a 25                	push   $0x25
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	ff d0                	call   *%eax
  8012b0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012b3:	ff 4d 10             	decl   0x10(%ebp)
  8012b6:	eb 03                	jmp    8012bb <vprintfmt+0x3c3>
  8012b8:	ff 4d 10             	decl   0x10(%ebp)
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	48                   	dec    %eax
  8012bf:	8a 00                	mov    (%eax),%al
  8012c1:	3c 25                	cmp    $0x25,%al
  8012c3:	75 f3                	jne    8012b8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8012c5:	90                   	nop
		}
	}
  8012c6:	e9 35 fc ff ff       	jmp    800f00 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8012cb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8012cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012cf:	5b                   	pop    %ebx
  8012d0:	5e                   	pop    %esi
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012d9:	8d 45 10             	lea    0x10(%ebp),%eax
  8012dc:	83 c0 04             	add    $0x4,%eax
  8012df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e8:	50                   	push   %eax
  8012e9:	ff 75 0c             	pushl  0xc(%ebp)
  8012ec:	ff 75 08             	pushl  0x8(%ebp)
  8012ef:	e8 04 fc ff ff       	call   800ef8 <vprintfmt>
  8012f4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012f7:	90                   	nop
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801300:	8b 40 08             	mov    0x8(%eax),%eax
  801303:	8d 50 01             	lea    0x1(%eax),%edx
  801306:	8b 45 0c             	mov    0xc(%ebp),%eax
  801309:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	8b 10                	mov    (%eax),%edx
  801311:	8b 45 0c             	mov    0xc(%ebp),%eax
  801314:	8b 40 04             	mov    0x4(%eax),%eax
  801317:	39 c2                	cmp    %eax,%edx
  801319:	73 12                	jae    80132d <sprintputch+0x33>
		*b->buf++ = ch;
  80131b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131e:	8b 00                	mov    (%eax),%eax
  801320:	8d 48 01             	lea    0x1(%eax),%ecx
  801323:	8b 55 0c             	mov    0xc(%ebp),%edx
  801326:	89 0a                	mov    %ecx,(%edx)
  801328:	8b 55 08             	mov    0x8(%ebp),%edx
  80132b:	88 10                	mov    %dl,(%eax)
}
  80132d:	90                   	nop
  80132e:	5d                   	pop    %ebp
  80132f:	c3                   	ret    

00801330 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	01 d0                	add    %edx,%eax
  801347:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80134a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801355:	74 06                	je     80135d <vsnprintf+0x2d>
  801357:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80135b:	7f 07                	jg     801364 <vsnprintf+0x34>
		return -E_INVAL;
  80135d:	b8 03 00 00 00       	mov    $0x3,%eax
  801362:	eb 20                	jmp    801384 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801364:	ff 75 14             	pushl  0x14(%ebp)
  801367:	ff 75 10             	pushl  0x10(%ebp)
  80136a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80136d:	50                   	push   %eax
  80136e:	68 fa 12 80 00       	push   $0x8012fa
  801373:	e8 80 fb ff ff       	call   800ef8 <vprintfmt>
  801378:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80137b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80137e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801381:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80138c:	8d 45 10             	lea    0x10(%ebp),%eax
  80138f:	83 c0 04             	add    $0x4,%eax
  801392:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	ff 75 f4             	pushl  -0xc(%ebp)
  80139b:	50                   	push   %eax
  80139c:	ff 75 0c             	pushl  0xc(%ebp)
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	e8 89 ff ff ff       	call   801330 <vsnprintf>
  8013a7:	83 c4 10             	add    $0x10,%esp
  8013aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013bf:	eb 06                	jmp    8013c7 <strlen+0x15>
		n++;
  8013c1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013c4:	ff 45 08             	incl   0x8(%ebp)
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	84 c0                	test   %al,%al
  8013ce:	75 f1                	jne    8013c1 <strlen+0xf>
		n++;
	return n;
  8013d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e2:	eb 09                	jmp    8013ed <strnlen+0x18>
		n++;
  8013e4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013e7:	ff 45 08             	incl   0x8(%ebp)
  8013ea:	ff 4d 0c             	decl   0xc(%ebp)
  8013ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013f1:	74 09                	je     8013fc <strnlen+0x27>
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	84 c0                	test   %al,%al
  8013fa:	75 e8                	jne    8013e4 <strnlen+0xf>
		n++;
	return n;
  8013fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80140d:	90                   	nop
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8d 50 01             	lea    0x1(%eax),%edx
  801414:	89 55 08             	mov    %edx,0x8(%ebp)
  801417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80141d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801420:	8a 12                	mov    (%edx),%dl
  801422:	88 10                	mov    %dl,(%eax)
  801424:	8a 00                	mov    (%eax),%al
  801426:	84 c0                	test   %al,%al
  801428:	75 e4                	jne    80140e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80142a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80143b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801442:	eb 1f                	jmp    801463 <strncpy+0x34>
		*dst++ = *src;
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8d 50 01             	lea    0x1(%eax),%edx
  80144a:	89 55 08             	mov    %edx,0x8(%ebp)
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	8a 12                	mov    (%edx),%dl
  801452:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	84 c0                	test   %al,%al
  80145b:	74 03                	je     801460 <strncpy+0x31>
			src++;
  80145d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801460:	ff 45 fc             	incl   -0x4(%ebp)
  801463:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801466:	3b 45 10             	cmp    0x10(%ebp),%eax
  801469:	72 d9                	jb     801444 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80146b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80147c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801480:	74 30                	je     8014b2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801482:	eb 16                	jmp    80149a <strlcpy+0x2a>
			*dst++ = *src++;
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	8d 50 01             	lea    0x1(%eax),%edx
  80148a:	89 55 08             	mov    %edx,0x8(%ebp)
  80148d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801490:	8d 4a 01             	lea    0x1(%edx),%ecx
  801493:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801496:	8a 12                	mov    (%edx),%dl
  801498:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80149a:	ff 4d 10             	decl   0x10(%ebp)
  80149d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a1:	74 09                	je     8014ac <strlcpy+0x3c>
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	84 c0                	test   %al,%al
  8014aa:	75 d8                	jne    801484 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b8:	29 c2                	sub    %eax,%edx
  8014ba:	89 d0                	mov    %edx,%eax
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014c1:	eb 06                	jmp    8014c9 <strcmp+0xb>
		p++, q++;
  8014c3:	ff 45 08             	incl   0x8(%ebp)
  8014c6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	8a 00                	mov    (%eax),%al
  8014ce:	84 c0                	test   %al,%al
  8014d0:	74 0e                	je     8014e0 <strcmp+0x22>
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	8a 10                	mov    (%eax),%dl
  8014d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	38 c2                	cmp    %al,%dl
  8014de:	74 e3                	je     8014c3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	0f b6 d0             	movzbl %al,%edx
  8014e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	0f b6 c0             	movzbl %al,%eax
  8014f0:	29 c2                	sub    %eax,%edx
  8014f2:	89 d0                	mov    %edx,%eax
}
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    

008014f6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014f9:	eb 09                	jmp    801504 <strncmp+0xe>
		n--, p++, q++;
  8014fb:	ff 4d 10             	decl   0x10(%ebp)
  8014fe:	ff 45 08             	incl   0x8(%ebp)
  801501:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801504:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801508:	74 17                	je     801521 <strncmp+0x2b>
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	8a 00                	mov    (%eax),%al
  80150f:	84 c0                	test   %al,%al
  801511:	74 0e                	je     801521 <strncmp+0x2b>
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8a 10                	mov    (%eax),%dl
  801518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	38 c2                	cmp    %al,%dl
  80151f:	74 da                	je     8014fb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801521:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801525:	75 07                	jne    80152e <strncmp+0x38>
		return 0;
  801527:	b8 00 00 00 00       	mov    $0x0,%eax
  80152c:	eb 14                	jmp    801542 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	0f b6 d0             	movzbl %al,%edx
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	0f b6 c0             	movzbl %al,%eax
  80153e:	29 c2                	sub    %eax,%edx
  801540:	89 d0                	mov    %edx,%eax
}
  801542:	5d                   	pop    %ebp
  801543:	c3                   	ret    

00801544 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	83 ec 04             	sub    $0x4,%esp
  80154a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801550:	eb 12                	jmp    801564 <strchr+0x20>
		if (*s == c)
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	8a 00                	mov    (%eax),%al
  801557:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80155a:	75 05                	jne    801561 <strchr+0x1d>
			return (char *) s;
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	eb 11                	jmp    801572 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801561:	ff 45 08             	incl   0x8(%ebp)
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	84 c0                	test   %al,%al
  80156b:	75 e5                	jne    801552 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80156d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 04             	sub    $0x4,%esp
  80157a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801580:	eb 0d                	jmp    80158f <strfind+0x1b>
		if (*s == c)
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8a 00                	mov    (%eax),%al
  801587:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80158a:	74 0e                	je     80159a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80158c:	ff 45 08             	incl   0x8(%ebp)
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	84 c0                	test   %al,%al
  801596:	75 ea                	jne    801582 <strfind+0xe>
  801598:	eb 01                	jmp    80159b <strfind+0x27>
		if (*s == c)
			break;
  80159a:	90                   	nop
	return (char *) s;
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8015af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015b2:	eb 0e                	jmp    8015c2 <memset+0x22>
		*p++ = c;
  8015b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b7:	8d 50 01             	lea    0x1(%eax),%edx
  8015ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015c2:	ff 4d f8             	decl   -0x8(%ebp)
  8015c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015c9:	79 e9                	jns    8015b4 <memset+0x14>
		*p++ = c;

	return v;
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015e2:	eb 16                	jmp    8015fa <memcpy+0x2a>
		*d++ = *s++;
  8015e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e7:	8d 50 01             	lea    0x1(%eax),%edx
  8015ea:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015f3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015f6:	8a 12                	mov    (%edx),%dl
  8015f8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801600:	89 55 10             	mov    %edx,0x10(%ebp)
  801603:	85 c0                	test   %eax,%eax
  801605:	75 dd                	jne    8015e4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801612:	8b 45 0c             	mov    0xc(%ebp),%eax
  801615:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80161e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801621:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801624:	73 50                	jae    801676 <memmove+0x6a>
  801626:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801629:	8b 45 10             	mov    0x10(%ebp),%eax
  80162c:	01 d0                	add    %edx,%eax
  80162e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801631:	76 43                	jbe    801676 <memmove+0x6a>
		s += n;
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801639:	8b 45 10             	mov    0x10(%ebp),%eax
  80163c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80163f:	eb 10                	jmp    801651 <memmove+0x45>
			*--d = *--s;
  801641:	ff 4d f8             	decl   -0x8(%ebp)
  801644:	ff 4d fc             	decl   -0x4(%ebp)
  801647:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164a:	8a 10                	mov    (%eax),%dl
  80164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	8d 50 ff             	lea    -0x1(%eax),%edx
  801657:	89 55 10             	mov    %edx,0x10(%ebp)
  80165a:	85 c0                	test   %eax,%eax
  80165c:	75 e3                	jne    801641 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80165e:	eb 23                	jmp    801683 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801660:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801663:	8d 50 01             	lea    0x1(%eax),%edx
  801666:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801669:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80166c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80166f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801672:	8a 12                	mov    (%edx),%dl
  801674:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801676:	8b 45 10             	mov    0x10(%ebp),%eax
  801679:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167c:	89 55 10             	mov    %edx,0x10(%ebp)
  80167f:	85 c0                	test   %eax,%eax
  801681:	75 dd                	jne    801660 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801694:	8b 45 0c             	mov    0xc(%ebp),%eax
  801697:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80169a:	eb 2a                	jmp    8016c6 <memcmp+0x3e>
		if (*s1 != *s2)
  80169c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169f:	8a 10                	mov    (%eax),%dl
  8016a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a4:	8a 00                	mov    (%eax),%al
  8016a6:	38 c2                	cmp    %al,%dl
  8016a8:	74 16                	je     8016c0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ad:	8a 00                	mov    (%eax),%al
  8016af:	0f b6 d0             	movzbl %al,%edx
  8016b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	0f b6 c0             	movzbl %al,%eax
  8016ba:	29 c2                	sub    %eax,%edx
  8016bc:	89 d0                	mov    %edx,%eax
  8016be:	eb 18                	jmp    8016d8 <memcmp+0x50>
		s1++, s2++;
  8016c0:	ff 45 fc             	incl   -0x4(%ebp)
  8016c3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	75 c9                	jne    80169c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e6:	01 d0                	add    %edx,%eax
  8016e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016eb:	eb 15                	jmp    801702 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8a 00                	mov    (%eax),%al
  8016f2:	0f b6 d0             	movzbl %al,%edx
  8016f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f8:	0f b6 c0             	movzbl %al,%eax
  8016fb:	39 c2                	cmp    %eax,%edx
  8016fd:	74 0d                	je     80170c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016ff:	ff 45 08             	incl   0x8(%ebp)
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801708:	72 e3                	jb     8016ed <memfind+0x13>
  80170a:	eb 01                	jmp    80170d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80170c:	90                   	nop
	return (void *) s;
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801718:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80171f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801726:	eb 03                	jmp    80172b <strtol+0x19>
		s++;
  801728:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8a 00                	mov    (%eax),%al
  801730:	3c 20                	cmp    $0x20,%al
  801732:	74 f4                	je     801728 <strtol+0x16>
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	8a 00                	mov    (%eax),%al
  801739:	3c 09                	cmp    $0x9,%al
  80173b:	74 eb                	je     801728 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	3c 2b                	cmp    $0x2b,%al
  801744:	75 05                	jne    80174b <strtol+0x39>
		s++;
  801746:	ff 45 08             	incl   0x8(%ebp)
  801749:	eb 13                	jmp    80175e <strtol+0x4c>
	else if (*s == '-')
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8a 00                	mov    (%eax),%al
  801750:	3c 2d                	cmp    $0x2d,%al
  801752:	75 0a                	jne    80175e <strtol+0x4c>
		s++, neg = 1;
  801754:	ff 45 08             	incl   0x8(%ebp)
  801757:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80175e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801762:	74 06                	je     80176a <strtol+0x58>
  801764:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801768:	75 20                	jne    80178a <strtol+0x78>
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	3c 30                	cmp    $0x30,%al
  801771:	75 17                	jne    80178a <strtol+0x78>
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	40                   	inc    %eax
  801777:	8a 00                	mov    (%eax),%al
  801779:	3c 78                	cmp    $0x78,%al
  80177b:	75 0d                	jne    80178a <strtol+0x78>
		s += 2, base = 16;
  80177d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801781:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801788:	eb 28                	jmp    8017b2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80178a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80178e:	75 15                	jne    8017a5 <strtol+0x93>
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	8a 00                	mov    (%eax),%al
  801795:	3c 30                	cmp    $0x30,%al
  801797:	75 0c                	jne    8017a5 <strtol+0x93>
		s++, base = 8;
  801799:	ff 45 08             	incl   0x8(%ebp)
  80179c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017a3:	eb 0d                	jmp    8017b2 <strtol+0xa0>
	else if (base == 0)
  8017a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017a9:	75 07                	jne    8017b2 <strtol+0xa0>
		base = 10;
  8017ab:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	8a 00                	mov    (%eax),%al
  8017b7:	3c 2f                	cmp    $0x2f,%al
  8017b9:	7e 19                	jle    8017d4 <strtol+0xc2>
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	3c 39                	cmp    $0x39,%al
  8017c2:	7f 10                	jg     8017d4 <strtol+0xc2>
			dig = *s - '0';
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	0f be c0             	movsbl %al,%eax
  8017cc:	83 e8 30             	sub    $0x30,%eax
  8017cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d2:	eb 42                	jmp    801816 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	3c 60                	cmp    $0x60,%al
  8017db:	7e 19                	jle    8017f6 <strtol+0xe4>
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	8a 00                	mov    (%eax),%al
  8017e2:	3c 7a                	cmp    $0x7a,%al
  8017e4:	7f 10                	jg     8017f6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	8a 00                	mov    (%eax),%al
  8017eb:	0f be c0             	movsbl %al,%eax
  8017ee:	83 e8 57             	sub    $0x57,%eax
  8017f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f4:	eb 20                	jmp    801816 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	8a 00                	mov    (%eax),%al
  8017fb:	3c 40                	cmp    $0x40,%al
  8017fd:	7e 39                	jle    801838 <strtol+0x126>
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	3c 5a                	cmp    $0x5a,%al
  801806:	7f 30                	jg     801838 <strtol+0x126>
			dig = *s - 'A' + 10;
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	8a 00                	mov    (%eax),%al
  80180d:	0f be c0             	movsbl %al,%eax
  801810:	83 e8 37             	sub    $0x37,%eax
  801813:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801819:	3b 45 10             	cmp    0x10(%ebp),%eax
  80181c:	7d 19                	jge    801837 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80181e:	ff 45 08             	incl   0x8(%ebp)
  801821:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801824:	0f af 45 10          	imul   0x10(%ebp),%eax
  801828:	89 c2                	mov    %eax,%edx
  80182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182d:	01 d0                	add    %edx,%eax
  80182f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801832:	e9 7b ff ff ff       	jmp    8017b2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801837:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801838:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80183c:	74 08                	je     801846 <strtol+0x134>
		*endptr = (char *) s;
  80183e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801841:	8b 55 08             	mov    0x8(%ebp),%edx
  801844:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801846:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80184a:	74 07                	je     801853 <strtol+0x141>
  80184c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184f:	f7 d8                	neg    %eax
  801851:	eb 03                	jmp    801856 <strtol+0x144>
  801853:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <ltostr>:

void
ltostr(long value, char *str)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80185e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801865:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80186c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801870:	79 13                	jns    801885 <ltostr+0x2d>
	{
		neg = 1;
  801872:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80187f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801882:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80188d:	99                   	cltd   
  80188e:	f7 f9                	idiv   %ecx
  801890:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801893:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801896:	8d 50 01             	lea    0x1(%eax),%edx
  801899:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80189c:	89 c2                	mov    %eax,%edx
  80189e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a1:	01 d0                	add    %edx,%eax
  8018a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018a6:	83 c2 30             	add    $0x30,%edx
  8018a9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ae:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018b3:	f7 e9                	imul   %ecx
  8018b5:	c1 fa 02             	sar    $0x2,%edx
  8018b8:	89 c8                	mov    %ecx,%eax
  8018ba:	c1 f8 1f             	sar    $0x1f,%eax
  8018bd:	29 c2                	sub    %eax,%edx
  8018bf:	89 d0                	mov    %edx,%eax
  8018c1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018c8:	75 bb                	jne    801885 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d4:	48                   	dec    %eax
  8018d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018dc:	74 3d                	je     80191b <ltostr+0xc3>
		start = 1 ;
  8018de:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018e5:	eb 34                	jmp    80191b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ed:	01 d0                	add    %edx,%eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fa:	01 c2                	add    %eax,%edx
  8018fc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	01 c8                	add    %ecx,%eax
  801904:	8a 00                	mov    (%eax),%al
  801906:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801908:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80190b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190e:	01 c2                	add    %eax,%edx
  801910:	8a 45 eb             	mov    -0x15(%ebp),%al
  801913:	88 02                	mov    %al,(%edx)
		start++ ;
  801915:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801918:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801921:	7c c4                	jl     8018e7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801923:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801926:	8b 45 0c             	mov    0xc(%ebp),%eax
  801929:	01 d0                	add    %edx,%eax
  80192b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80192e:	90                   	nop
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	e8 73 fa ff ff       	call   8013b2 <strlen>
  80193f:	83 c4 04             	add    $0x4,%esp
  801942:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	e8 65 fa ff ff       	call   8013b2 <strlen>
  80194d:	83 c4 04             	add    $0x4,%esp
  801950:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801953:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80195a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801961:	eb 17                	jmp    80197a <strcconcat+0x49>
		final[s] = str1[s] ;
  801963:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801966:	8b 45 10             	mov    0x10(%ebp),%eax
  801969:	01 c2                	add    %eax,%edx
  80196b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	01 c8                	add    %ecx,%eax
  801973:	8a 00                	mov    (%eax),%al
  801975:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801977:	ff 45 fc             	incl   -0x4(%ebp)
  80197a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801980:	7c e1                	jl     801963 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801982:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801989:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801990:	eb 1f                	jmp    8019b1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801992:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801995:	8d 50 01             	lea    0x1(%eax),%edx
  801998:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80199b:	89 c2                	mov    %eax,%edx
  80199d:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a0:	01 c2                	add    %eax,%edx
  8019a2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	01 c8                	add    %ecx,%eax
  8019aa:	8a 00                	mov    (%eax),%al
  8019ac:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019ae:	ff 45 f8             	incl   -0x8(%ebp)
  8019b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019b7:	7c d9                	jl     801992 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bf:	01 d0                	add    %edx,%eax
  8019c1:	c6 00 00             	movb   $0x0,(%eax)
}
  8019c4:	90                   	nop
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d6:	8b 00                	mov    (%eax),%eax
  8019d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019df:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e2:	01 d0                	add    %edx,%eax
  8019e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019ea:	eb 0c                	jmp    8019f8 <strsplit+0x31>
			*string++ = 0;
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	8d 50 01             	lea    0x1(%eax),%edx
  8019f2:	89 55 08             	mov    %edx,0x8(%ebp)
  8019f5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	8a 00                	mov    (%eax),%al
  8019fd:	84 c0                	test   %al,%al
  8019ff:	74 18                	je     801a19 <strsplit+0x52>
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	0f be c0             	movsbl %al,%eax
  801a09:	50                   	push   %eax
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	e8 32 fb ff ff       	call   801544 <strchr>
  801a12:	83 c4 08             	add    $0x8,%esp
  801a15:	85 c0                	test   %eax,%eax
  801a17:	75 d3                	jne    8019ec <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	8a 00                	mov    (%eax),%al
  801a1e:	84 c0                	test   %al,%al
  801a20:	74 5a                	je     801a7c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	8b 00                	mov    (%eax),%eax
  801a27:	83 f8 0f             	cmp    $0xf,%eax
  801a2a:	75 07                	jne    801a33 <strsplit+0x6c>
		{
			return 0;
  801a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a31:	eb 66                	jmp    801a99 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a33:	8b 45 14             	mov    0x14(%ebp),%eax
  801a36:	8b 00                	mov    (%eax),%eax
  801a38:	8d 48 01             	lea    0x1(%eax),%ecx
  801a3b:	8b 55 14             	mov    0x14(%ebp),%edx
  801a3e:	89 0a                	mov    %ecx,(%edx)
  801a40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	01 c2                	add    %eax,%edx
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a51:	eb 03                	jmp    801a56 <strsplit+0x8f>
			string++;
  801a53:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	8a 00                	mov    (%eax),%al
  801a5b:	84 c0                	test   %al,%al
  801a5d:	74 8b                	je     8019ea <strsplit+0x23>
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	0f be c0             	movsbl %al,%eax
  801a67:	50                   	push   %eax
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	e8 d4 fa ff ff       	call   801544 <strchr>
  801a70:	83 c4 08             	add    $0x8,%esp
  801a73:	85 c0                	test   %eax,%eax
  801a75:	74 dc                	je     801a53 <strsplit+0x8c>
			string++;
	}
  801a77:	e9 6e ff ff ff       	jmp    8019ea <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a7c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a94:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801aa1:	83 ec 04             	sub    $0x4,%esp
  801aa4:	68 88 4a 80 00       	push   $0x804a88
  801aa9:	68 3f 01 00 00       	push   $0x13f
  801aae:	68 aa 4a 80 00       	push   $0x804aaa
  801ab3:	e8 a9 ef ff ff       	call   800a61 <_panic>

00801ab8 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801abe:	83 ec 0c             	sub    $0xc,%esp
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	e8 ef 06 00 00       	call   8021b8 <sys_sbrk>
  801ac9:	83 c4 10             	add    $0x10,%esp
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801ad4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ad8:	75 07                	jne    801ae1 <malloc+0x13>
  801ada:	b8 00 00 00 00       	mov    $0x0,%eax
  801adf:	eb 14                	jmp    801af5 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	68 b8 4a 80 00       	push   $0x804ab8
  801ae9:	6a 1b                	push   $0x1b
  801aeb:	68 dd 4a 80 00       	push   $0x804add
  801af0:	e8 6c ef ff ff       	call   800a61 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	68 ec 4a 80 00       	push   $0x804aec
  801b05:	6a 29                	push   $0x29
  801b07:	68 dd 4a 80 00       	push   $0x804add
  801b0c:	e8 50 ef ff ff       	call   800a61 <_panic>

00801b11 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 18             	sub    $0x18,%esp
  801b17:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b21:	75 07                	jne    801b2a <smalloc+0x19>
  801b23:	b8 00 00 00 00       	mov    $0x0,%eax
  801b28:	eb 14                	jmp    801b3e <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	68 10 4b 80 00       	push   $0x804b10
  801b32:	6a 38                	push   $0x38
  801b34:	68 dd 4a 80 00       	push   $0x804add
  801b39:	e8 23 ef ff ff       	call   800a61 <_panic>
	return NULL;
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b46:	83 ec 04             	sub    $0x4,%esp
  801b49:	68 38 4b 80 00       	push   $0x804b38
  801b4e:	6a 43                	push   $0x43
  801b50:	68 dd 4a 80 00       	push   $0x804add
  801b55:	e8 07 ef ff ff       	call   800a61 <_panic>

00801b5a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	68 5c 4b 80 00       	push   $0x804b5c
  801b68:	6a 5b                	push   $0x5b
  801b6a:	68 dd 4a 80 00       	push   $0x804add
  801b6f:	e8 ed ee ff ff       	call   800a61 <_panic>

00801b74 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b7a:	83 ec 04             	sub    $0x4,%esp
  801b7d:	68 80 4b 80 00       	push   $0x804b80
  801b82:	6a 72                	push   $0x72
  801b84:	68 dd 4a 80 00       	push   $0x804add
  801b89:	e8 d3 ee ff ff       	call   800a61 <_panic>

00801b8e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b94:	83 ec 04             	sub    $0x4,%esp
  801b97:	68 a6 4b 80 00       	push   $0x804ba6
  801b9c:	6a 7e                	push   $0x7e
  801b9e:	68 dd 4a 80 00       	push   $0x804add
  801ba3:	e8 b9 ee ff ff       	call   800a61 <_panic>

00801ba8 <shrink>:

}
void shrink(uint32 newSize)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bae:	83 ec 04             	sub    $0x4,%esp
  801bb1:	68 a6 4b 80 00       	push   $0x804ba6
  801bb6:	68 83 00 00 00       	push   $0x83
  801bbb:	68 dd 4a 80 00       	push   $0x804add
  801bc0:	e8 9c ee ff ff       	call   800a61 <_panic>

00801bc5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bcb:	83 ec 04             	sub    $0x4,%esp
  801bce:	68 a6 4b 80 00       	push   $0x804ba6
  801bd3:	68 88 00 00 00       	push   $0x88
  801bd8:	68 dd 4a 80 00       	push   $0x804add
  801bdd:	e8 7f ee ff ff       	call   800a61 <_panic>

00801be2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	57                   	push   %edi
  801be6:	56                   	push   %esi
  801be7:	53                   	push   %ebx
  801be8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bf7:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bfa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bfd:	cd 30                	int    $0x30
  801bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	5b                   	pop    %ebx
  801c09:	5e                   	pop    %esi
  801c0a:	5f                   	pop    %edi
  801c0b:	5d                   	pop    %ebp
  801c0c:	c3                   	ret    

00801c0d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 04             	sub    $0x4,%esp
  801c13:	8b 45 10             	mov    0x10(%ebp),%eax
  801c16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c19:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	52                   	push   %edx
  801c25:	ff 75 0c             	pushl  0xc(%ebp)
  801c28:	50                   	push   %eax
  801c29:	6a 00                	push   $0x0
  801c2b:	e8 b2 ff ff ff       	call   801be2 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	90                   	nop
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 02                	push   $0x2
  801c45:	e8 98 ff ff ff       	call   801be2 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 03                	push   $0x3
  801c5e:	e8 7f ff ff ff       	call   801be2 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	90                   	nop
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 04                	push   $0x4
  801c78:	e8 65 ff ff ff       	call   801be2 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	90                   	nop
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	52                   	push   %edx
  801c93:	50                   	push   %eax
  801c94:	6a 08                	push   $0x8
  801c96:	e8 47 ff ff ff       	call   801be2 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ca5:	8b 75 18             	mov    0x18(%ebp),%esi
  801ca8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	56                   	push   %esi
  801cb5:	53                   	push   %ebx
  801cb6:	51                   	push   %ecx
  801cb7:	52                   	push   %edx
  801cb8:	50                   	push   %eax
  801cb9:	6a 09                	push   $0x9
  801cbb:	e8 22 ff ff ff       	call   801be2 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc6:	5b                   	pop    %ebx
  801cc7:	5e                   	pop    %esi
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    

00801cca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	52                   	push   %edx
  801cda:	50                   	push   %eax
  801cdb:	6a 0a                	push   $0xa
  801cdd:	e8 00 ff ff ff       	call   801be2 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	ff 75 0c             	pushl  0xc(%ebp)
  801cf3:	ff 75 08             	pushl  0x8(%ebp)
  801cf6:	6a 0b                	push   $0xb
  801cf8:	e8 e5 fe ff ff       	call   801be2 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 0c                	push   $0xc
  801d11:	e8 cc fe ff ff       	call   801be2 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 0d                	push   $0xd
  801d2a:	e8 b3 fe ff ff       	call   801be2 <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 0e                	push   $0xe
  801d43:	e8 9a fe ff ff       	call   801be2 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 0f                	push   $0xf
  801d5c:	e8 81 fe ff ff       	call   801be2 <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	ff 75 08             	pushl  0x8(%ebp)
  801d74:	6a 10                	push   $0x10
  801d76:	e8 67 fe ff ff       	call   801be2 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 11                	push   $0x11
  801d8f:	e8 4e fe ff ff       	call   801be2 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	90                   	nop
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_cputc>:

void
sys_cputc(const char c)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 04             	sub    $0x4,%esp
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801da6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	50                   	push   %eax
  801db3:	6a 01                	push   $0x1
  801db5:	e8 28 fe ff ff       	call   801be2 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	90                   	nop
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 14                	push   $0x14
  801dcf:	e8 0e fe ff ff       	call   801be2 <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
}
  801dd7:	90                   	nop
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 04             	sub    $0x4,%esp
  801de0:	8b 45 10             	mov    0x10(%ebp),%eax
  801de3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801de6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801de9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	51                   	push   %ecx
  801df3:	52                   	push   %edx
  801df4:	ff 75 0c             	pushl  0xc(%ebp)
  801df7:	50                   	push   %eax
  801df8:	6a 15                	push   $0x15
  801dfa:	e8 e3 fd ff ff       	call   801be2 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	52                   	push   %edx
  801e14:	50                   	push   %eax
  801e15:	6a 16                	push   $0x16
  801e17:	e8 c6 fd ff ff       	call   801be2 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	51                   	push   %ecx
  801e32:	52                   	push   %edx
  801e33:	50                   	push   %eax
  801e34:	6a 17                	push   $0x17
  801e36:	e8 a7 fd ff ff       	call   801be2 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	52                   	push   %edx
  801e50:	50                   	push   %eax
  801e51:	6a 18                	push   $0x18
  801e53:	e8 8a fd ff ff       	call   801be2 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	6a 00                	push   $0x0
  801e65:	ff 75 14             	pushl  0x14(%ebp)
  801e68:	ff 75 10             	pushl  0x10(%ebp)
  801e6b:	ff 75 0c             	pushl  0xc(%ebp)
  801e6e:	50                   	push   %eax
  801e6f:	6a 19                	push   $0x19
  801e71:	e8 6c fd ff ff       	call   801be2 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sys_run_env>:

void sys_run_env(int32 envId)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	50                   	push   %eax
  801e8a:	6a 1a                	push   $0x1a
  801e8c:	e8 51 fd ff ff       	call   801be2 <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
}
  801e94:	90                   	nop
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	50                   	push   %eax
  801ea6:	6a 1b                	push   $0x1b
  801ea8:	e8 35 fd ff ff       	call   801be2 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 05                	push   $0x5
  801ec1:	e8 1c fd ff ff       	call   801be2 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 06                	push   $0x6
  801eda:	e8 03 fd ff ff       	call   801be2 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 07                	push   $0x7
  801ef3:	e8 ea fc ff ff       	call   801be2 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_exit_env>:


void sys_exit_env(void)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 1c                	push   $0x1c
  801f0c:	e8 d1 fc ff ff       	call   801be2 <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
}
  801f14:	90                   	nop
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f20:	8d 50 04             	lea    0x4(%eax),%edx
  801f23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	52                   	push   %edx
  801f2d:	50                   	push   %eax
  801f2e:	6a 1d                	push   $0x1d
  801f30:	e8 ad fc ff ff       	call   801be2 <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
	return result;
  801f38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f41:	89 01                	mov    %eax,(%ecx)
  801f43:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	c9                   	leave  
  801f4a:	c2 04 00             	ret    $0x4

00801f4d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	ff 75 10             	pushl  0x10(%ebp)
  801f57:	ff 75 0c             	pushl  0xc(%ebp)
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	6a 13                	push   $0x13
  801f5f:	e8 7e fc ff ff       	call   801be2 <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
	return ;
  801f67:	90                   	nop
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_rcr2>:
uint32 sys_rcr2()
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 1e                	push   $0x1e
  801f79:	e8 64 fc ff ff       	call   801be2 <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f8f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	50                   	push   %eax
  801f9c:	6a 1f                	push   $0x1f
  801f9e:	e8 3f fc ff ff       	call   801be2 <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa6:	90                   	nop
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <rsttst>:
void rsttst()
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 21                	push   $0x21
  801fb8:	e8 25 fc ff ff       	call   801be2 <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc0:	90                   	nop
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801fcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fcf:	8b 55 18             	mov    0x18(%ebp),%edx
  801fd2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fd6:	52                   	push   %edx
  801fd7:	50                   	push   %eax
  801fd8:	ff 75 10             	pushl  0x10(%ebp)
  801fdb:	ff 75 0c             	pushl  0xc(%ebp)
  801fde:	ff 75 08             	pushl  0x8(%ebp)
  801fe1:	6a 20                	push   $0x20
  801fe3:	e8 fa fb ff ff       	call   801be2 <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
	return ;
  801feb:	90                   	nop
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <chktst>:
void chktst(uint32 n)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	ff 75 08             	pushl  0x8(%ebp)
  801ffc:	6a 22                	push   $0x22
  801ffe:	e8 df fb ff ff       	call   801be2 <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
	return ;
  802006:	90                   	nop
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <inctst>:

void inctst()
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 23                	push   $0x23
  802018:	e8 c5 fb ff ff       	call   801be2 <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
	return ;
  802020:	90                   	nop
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <gettst>:
uint32 gettst()
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 24                	push   $0x24
  802032:	e8 ab fb ff ff       	call   801be2 <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 25                	push   $0x25
  80204e:	e8 8f fb ff ff       	call   801be2 <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
  802056:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802059:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80205d:	75 07                	jne    802066 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80205f:	b8 01 00 00 00       	mov    $0x1,%eax
  802064:	eb 05                	jmp    80206b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802066:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 25                	push   $0x25
  80207f:	e8 5e fb ff ff       	call   801be2 <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
  802087:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80208a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80208e:	75 07                	jne    802097 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802090:	b8 01 00 00 00       	mov    $0x1,%eax
  802095:	eb 05                	jmp    80209c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 25                	push   $0x25
  8020b0:	e8 2d fb ff ff       	call   801be2 <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
  8020b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020bb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020bf:	75 07                	jne    8020c8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c6:	eb 05                	jmp    8020cd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 25                	push   $0x25
  8020e1:	e8 fc fa ff ff       	call   801be2 <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
  8020e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020ec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020f0:	75 07                	jne    8020f9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f7:	eb 05                	jmp    8020fe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	ff 75 08             	pushl  0x8(%ebp)
  80210e:	6a 26                	push   $0x26
  802110:	e8 cd fa ff ff       	call   801be2 <syscall>
  802115:	83 c4 18             	add    $0x18,%esp
	return ;
  802118:	90                   	nop
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80211f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802122:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802125:	8b 55 0c             	mov    0xc(%ebp),%edx
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	6a 00                	push   $0x0
  80212d:	53                   	push   %ebx
  80212e:	51                   	push   %ecx
  80212f:	52                   	push   %edx
  802130:	50                   	push   %eax
  802131:	6a 27                	push   $0x27
  802133:	e8 aa fa ff ff       	call   801be2 <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
}
  80213b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802143:	8b 55 0c             	mov    0xc(%ebp),%edx
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	52                   	push   %edx
  802150:	50                   	push   %eax
  802151:	6a 28                	push   $0x28
  802153:	e8 8a fa ff ff       	call   801be2 <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802160:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802163:	8b 55 0c             	mov    0xc(%ebp),%edx
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	6a 00                	push   $0x0
  80216b:	51                   	push   %ecx
  80216c:	ff 75 10             	pushl  0x10(%ebp)
  80216f:	52                   	push   %edx
  802170:	50                   	push   %eax
  802171:	6a 29                	push   $0x29
  802173:	e8 6a fa ff ff       	call   801be2 <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	ff 75 10             	pushl  0x10(%ebp)
  802187:	ff 75 0c             	pushl  0xc(%ebp)
  80218a:	ff 75 08             	pushl  0x8(%ebp)
  80218d:	6a 12                	push   $0x12
  80218f:	e8 4e fa ff ff       	call   801be2 <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
	return ;
  802197:	90                   	nop
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80219d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	52                   	push   %edx
  8021aa:	50                   	push   %eax
  8021ab:	6a 2a                	push   $0x2a
  8021ad:	e8 30 fa ff ff       	call   801be2 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
	return;
  8021b5:	90                   	nop
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	50                   	push   %eax
  8021c7:	6a 2b                	push   $0x2b
  8021c9:	e8 14 fa ff ff       	call   801be2 <syscall>
  8021ce:	83 c4 18             	add    $0x18,%esp
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	ff 75 0c             	pushl  0xc(%ebp)
  8021df:	ff 75 08             	pushl  0x8(%ebp)
  8021e2:	6a 2c                	push   $0x2c
  8021e4:	e8 f9 f9 ff ff       	call   801be2 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
	return;
  8021ec:	90                   	nop
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	ff 75 0c             	pushl  0xc(%ebp)
  8021fb:	ff 75 08             	pushl  0x8(%ebp)
  8021fe:	6a 2d                	push   $0x2d
  802200:	e8 dd f9 ff ff       	call   801be2 <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
	return;
  802208:	90                   	nop
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	83 e8 04             	sub    $0x4,%eax
  802217:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80221a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80221d:	8b 00                	mov    (%eax),%eax
  80221f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	83 e8 04             	sub    $0x4,%eax
  802230:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802233:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802236:	8b 00                	mov    (%eax),%eax
  802238:	83 e0 01             	and    $0x1,%eax
  80223b:	85 c0                	test   %eax,%eax
  80223d:	0f 94 c0             	sete   %al
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802248:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80224f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802252:	83 f8 02             	cmp    $0x2,%eax
  802255:	74 2b                	je     802282 <alloc_block+0x40>
  802257:	83 f8 02             	cmp    $0x2,%eax
  80225a:	7f 07                	jg     802263 <alloc_block+0x21>
  80225c:	83 f8 01             	cmp    $0x1,%eax
  80225f:	74 0e                	je     80226f <alloc_block+0x2d>
  802261:	eb 58                	jmp    8022bb <alloc_block+0x79>
  802263:	83 f8 03             	cmp    $0x3,%eax
  802266:	74 2d                	je     802295 <alloc_block+0x53>
  802268:	83 f8 04             	cmp    $0x4,%eax
  80226b:	74 3b                	je     8022a8 <alloc_block+0x66>
  80226d:	eb 4c                	jmp    8022bb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80226f:	83 ec 0c             	sub    $0xc,%esp
  802272:	ff 75 08             	pushl  0x8(%ebp)
  802275:	e8 3d 03 00 00       	call   8025b7 <alloc_block_FF>
  80227a:	83 c4 10             	add    $0x10,%esp
  80227d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802280:	eb 4a                	jmp    8022cc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802282:	83 ec 0c             	sub    $0xc,%esp
  802285:	ff 75 08             	pushl  0x8(%ebp)
  802288:	e8 26 1a 00 00       	call   803cb3 <alloc_block_NF>
  80228d:	83 c4 10             	add    $0x10,%esp
  802290:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802293:	eb 37                	jmp    8022cc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802295:	83 ec 0c             	sub    $0xc,%esp
  802298:	ff 75 08             	pushl  0x8(%ebp)
  80229b:	e8 d3 07 00 00       	call   802a73 <alloc_block_BF>
  8022a0:	83 c4 10             	add    $0x10,%esp
  8022a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022a6:	eb 24                	jmp    8022cc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8022a8:	83 ec 0c             	sub    $0xc,%esp
  8022ab:	ff 75 08             	pushl  0x8(%ebp)
  8022ae:	e8 e3 19 00 00       	call   803c96 <alloc_block_WF>
  8022b3:	83 c4 10             	add    $0x10,%esp
  8022b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022b9:	eb 11                	jmp    8022cc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8022bb:	83 ec 0c             	sub    $0xc,%esp
  8022be:	68 b8 4b 80 00       	push   $0x804bb8
  8022c3:	e8 56 ea ff ff       	call   800d1e <cprintf>
  8022c8:	83 c4 10             	add    $0x10,%esp
		break;
  8022cb:	90                   	nop
	}
	return va;
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	53                   	push   %ebx
  8022d5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8022d8:	83 ec 0c             	sub    $0xc,%esp
  8022db:	68 d8 4b 80 00       	push   $0x804bd8
  8022e0:	e8 39 ea ff ff       	call   800d1e <cprintf>
  8022e5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8022e8:	83 ec 0c             	sub    $0xc,%esp
  8022eb:	68 03 4c 80 00       	push   $0x804c03
  8022f0:	e8 29 ea ff ff       	call   800d1e <cprintf>
  8022f5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fe:	eb 37                	jmp    802337 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802300:	83 ec 0c             	sub    $0xc,%esp
  802303:	ff 75 f4             	pushl  -0xc(%ebp)
  802306:	e8 19 ff ff ff       	call   802224 <is_free_block>
  80230b:	83 c4 10             	add    $0x10,%esp
  80230e:	0f be d8             	movsbl %al,%ebx
  802311:	83 ec 0c             	sub    $0xc,%esp
  802314:	ff 75 f4             	pushl  -0xc(%ebp)
  802317:	e8 ef fe ff ff       	call   80220b <get_block_size>
  80231c:	83 c4 10             	add    $0x10,%esp
  80231f:	83 ec 04             	sub    $0x4,%esp
  802322:	53                   	push   %ebx
  802323:	50                   	push   %eax
  802324:	68 1b 4c 80 00       	push   $0x804c1b
  802329:	e8 f0 e9 ff ff       	call   800d1e <cprintf>
  80232e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802331:	8b 45 10             	mov    0x10(%ebp),%eax
  802334:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802337:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233b:	74 07                	je     802344 <print_blocks_list+0x73>
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 00                	mov    (%eax),%eax
  802342:	eb 05                	jmp    802349 <print_blocks_list+0x78>
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
  802349:	89 45 10             	mov    %eax,0x10(%ebp)
  80234c:	8b 45 10             	mov    0x10(%ebp),%eax
  80234f:	85 c0                	test   %eax,%eax
  802351:	75 ad                	jne    802300 <print_blocks_list+0x2f>
  802353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802357:	75 a7                	jne    802300 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802359:	83 ec 0c             	sub    $0xc,%esp
  80235c:	68 d8 4b 80 00       	push   $0x804bd8
  802361:	e8 b8 e9 ff ff       	call   800d1e <cprintf>
  802366:	83 c4 10             	add    $0x10,%esp

}
  802369:	90                   	nop
  80236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
  802372:	57                   	push   %edi
  802373:	56                   	push   %esi
  802374:	53                   	push   %ebx
  802375:	83 ec 1c             	sub    $0x1c,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237b:	83 e0 01             	and    $0x1,%eax
  80237e:	85 c0                	test   %eax,%eax
  802380:	74 03                	je     802385 <initialize_dynamic_allocator+0x16>
  802382:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802385:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802389:	0f 84 ea 01 00 00    	je     802579 <initialize_dynamic_allocator+0x20a>
                return ;
            is_initialized = 1;
  80238f:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802396:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802399:	8b 55 08             	mov    0x8(%ebp),%edx
  80239c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239f:	01 d0                	add    %edx,%eax
  8023a1:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8023a6:	0f 87 d0 01 00 00    	ja     80257c <initialize_dynamic_allocator+0x20d>
        return;
    if(daStart < KERNEL_HEAP_START)
  8023ac:	81 7d 08 ff ff ff f5 	cmpl   $0xf5ffffff,0x8(%ebp)
  8023b3:	0f 86 c6 01 00 00    	jbe    80257f <initialize_dynamic_allocator+0x210>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8023b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023bf:	01 d0                	add    %edx,%eax
  8023c1:	83 e8 04             	sub    $0x4,%eax
  8023c4:	a3 4c 92 80 00       	mov    %eax,0x80924c
     struct BlockElement * element = NULL;
  8023c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8023d0:	a1 44 50 80 00       	mov    0x805044,%eax
  8023d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023d8:	e9 87 00 00 00       	jmp    802464 <initialize_dynamic_allocator+0xf5>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8023dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023e1:	75 14                	jne    8023f7 <initialize_dynamic_allocator+0x88>
  8023e3:	83 ec 04             	sub    $0x4,%esp
  8023e6:	68 33 4c 80 00       	push   $0x804c33
  8023eb:	6a 79                	push   $0x79
  8023ed:	68 51 4c 80 00       	push   $0x804c51
  8023f2:	e8 6a e6 ff ff       	call   800a61 <_panic>
  8023f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	85 c0                	test   %eax,%eax
  8023fe:	74 10                	je     802410 <initialize_dynamic_allocator+0xa1>
  802400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802403:	8b 00                	mov    (%eax),%eax
  802405:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802408:	8b 52 04             	mov    0x4(%edx),%edx
  80240b:	89 50 04             	mov    %edx,0x4(%eax)
  80240e:	eb 0b                	jmp    80241b <initialize_dynamic_allocator+0xac>
  802410:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802413:	8b 40 04             	mov    0x4(%eax),%eax
  802416:	a3 48 50 80 00       	mov    %eax,0x805048
  80241b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	85 c0                	test   %eax,%eax
  802423:	74 0f                	je     802434 <initialize_dynamic_allocator+0xc5>
  802425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802428:	8b 40 04             	mov    0x4(%eax),%eax
  80242b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80242e:	8b 12                	mov    (%edx),%edx
  802430:	89 10                	mov    %edx,(%eax)
  802432:	eb 0a                	jmp    80243e <initialize_dynamic_allocator+0xcf>
  802434:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802437:	8b 00                	mov    (%eax),%eax
  802439:	a3 44 50 80 00       	mov    %eax,0x805044
  80243e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80244a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802451:	a1 50 50 80 00       	mov    0x805050,%eax
  802456:	48                   	dec    %eax
  802457:	a3 50 50 80 00       	mov    %eax,0x805050
        return;
    if(daStart < KERNEL_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80245c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802461:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802464:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802468:	74 07                	je     802471 <initialize_dynamic_allocator+0x102>
  80246a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	eb 05                	jmp    802476 <initialize_dynamic_allocator+0x107>
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
  802476:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80247b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802480:	85 c0                	test   %eax,%eax
  802482:	0f 85 55 ff ff ff    	jne    8023dd <initialize_dynamic_allocator+0x6e>
  802488:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80248c:	0f 85 4b ff ff ff    	jne    8023dd <initialize_dynamic_allocator+0x6e>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	89 45 e0             	mov    %eax,-0x20(%ebp)
    beg_block->info = 1;
  802498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80249b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8024a1:	a1 4c 92 80 00       	mov    0x80924c,%eax
  8024a6:	a3 48 92 80 00       	mov    %eax,0x809248
    end_block->info = 1;
  8024ab:	a1 48 92 80 00       	mov    0x809248,%eax
  8024b0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	83 c0 08             	add    $0x8,%eax
  8024bc:	89 45 dc             	mov    %eax,-0x24(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	83 c0 04             	add    $0x4,%eax
  8024c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c8:	83 ea 08             	sub    $0x8,%edx
  8024cb:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8024cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d3:	01 d0                	add    %edx,%eax
  8024d5:	83 e8 08             	sub    $0x8,%eax
  8024d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024db:	83 ea 08             	sub    $0x8,%edx
  8024de:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8024e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8024e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8024f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8024f7:	75 17                	jne    802510 <initialize_dynamic_allocator+0x1a1>
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	68 6c 4c 80 00       	push   $0x804c6c
  802501:	68 90 00 00 00       	push   $0x90
  802506:	68 51 4c 80 00       	push   $0x804c51
  80250b:	e8 51 e5 ff ff       	call   800a61 <_panic>
  802510:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802516:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802519:	89 10                	mov    %edx,(%eax)
  80251b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80251e:	8b 00                	mov    (%eax),%eax
  802520:	85 c0                	test   %eax,%eax
  802522:	74 0d                	je     802531 <initialize_dynamic_allocator+0x1c2>
  802524:	a1 44 50 80 00       	mov    0x805044,%eax
  802529:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80252c:	89 50 04             	mov    %edx,0x4(%eax)
  80252f:	eb 08                	jmp    802539 <initialize_dynamic_allocator+0x1ca>
  802531:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802534:	a3 48 50 80 00       	mov    %eax,0x805048
  802539:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80253c:	a3 44 50 80 00       	mov    %eax,0x805044
  802541:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802544:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80254b:	a1 50 50 80 00       	mov    0x805050,%eax
  802550:	40                   	inc    %eax
  802551:	a3 50 50 80 00       	mov    %eax,0x805050
    print_blocks_list(freeBlocksList);
  802556:	83 ec 10             	sub    $0x10,%esp
  802559:	89 e0                	mov    %esp,%eax
  80255b:	89 c2                	mov    %eax,%edx
  80255d:	bb 44 50 80 00       	mov    $0x805044,%ebx
  802562:	b8 04 00 00 00       	mov    $0x4,%eax
  802567:	89 d7                	mov    %edx,%edi
  802569:	89 de                	mov    %ebx,%esi
  80256b:	89 c1                	mov    %eax,%ecx
  80256d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80256f:	e8 5d fd ff ff       	call   8022d1 <print_blocks_list>
  802574:	83 c4 10             	add    $0x10,%esp
  802577:	eb 07                	jmp    802580 <initialize_dynamic_allocator+0x211>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802579:	90                   	nop
  80257a:	eb 04                	jmp    802580 <initialize_dynamic_allocator+0x211>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80257c:	90                   	nop
  80257d:	eb 01                	jmp    802580 <initialize_dynamic_allocator+0x211>
    if(daStart < KERNEL_HEAP_START)
        return;
  80257f:	90                   	nop
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
    print_blocks_list(freeBlocksList);
}
  802580:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802583:	5b                   	pop    %ebx
  802584:	5e                   	pop    %esi
  802585:	5f                   	pop    %edi
  802586:	5d                   	pop    %ebp
  802587:	c3                   	ret    

00802588 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80258b:	8b 45 10             	mov    0x10(%ebp),%eax
  80258e:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	8d 50 fc             	lea    -0x4(%eax),%edx
  802597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259a:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	83 e8 04             	sub    $0x4,%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	83 e0 fe             	and    $0xfffffffe,%eax
  8025a7:	8d 50 f8             	lea    -0x8(%eax),%edx
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	01 c2                	add    %eax,%edx
  8025af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b2:	89 02                	mov    %eax,(%edx)
}
  8025b4:	90                   	nop
  8025b5:	5d                   	pop    %ebp
  8025b6:	c3                   	ret    

008025b7 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
  8025ba:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	83 e0 01             	and    $0x1,%eax
  8025c3:	85 c0                	test   %eax,%eax
  8025c5:	74 03                	je     8025ca <alloc_block_FF+0x13>
  8025c7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025ca:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025ce:	77 07                	ja     8025d7 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025d0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025d7:	a1 24 50 80 00       	mov    0x805024,%eax
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	75 73                	jne    802653 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	83 c0 10             	add    $0x10,%eax
  8025e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8025e9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8025f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f6:	01 d0                	add    %edx,%eax
  8025f8:	48                   	dec    %eax
  8025f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8025fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802604:	f7 75 ec             	divl   -0x14(%ebp)
  802607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260a:	29 d0                	sub    %edx,%eax
  80260c:	c1 e8 0c             	shr    $0xc,%eax
  80260f:	83 ec 0c             	sub    $0xc,%esp
  802612:	50                   	push   %eax
  802613:	e8 a0 f4 ff ff       	call   801ab8 <sbrk>
  802618:	83 c4 10             	add    $0x10,%esp
  80261b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80261e:	83 ec 0c             	sub    $0xc,%esp
  802621:	6a 00                	push   $0x0
  802623:	e8 90 f4 ff ff       	call   801ab8 <sbrk>
  802628:	83 c4 10             	add    $0x10,%esp
  80262b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80262e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802631:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802634:	83 ec 08             	sub    $0x8,%esp
  802637:	50                   	push   %eax
  802638:	ff 75 e4             	pushl  -0x1c(%ebp)
  80263b:	e8 2f fd ff ff       	call   80236f <initialize_dynamic_allocator>
  802640:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802643:	83 ec 0c             	sub    $0xc,%esp
  802646:	68 8f 4c 80 00       	push   $0x804c8f
  80264b:	e8 ce e6 ff ff       	call   800d1e <cprintf>
  802650:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802653:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802657:	75 0a                	jne    802663 <alloc_block_FF+0xac>
	        return NULL;
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
  80265e:	e9 0e 04 00 00       	jmp    802a71 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802663:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80266a:	a1 44 50 80 00       	mov    0x805044,%eax
  80266f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802672:	e9 f3 02 00 00       	jmp    80296a <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80267d:	83 ec 0c             	sub    $0xc,%esp
  802680:	ff 75 bc             	pushl  -0x44(%ebp)
  802683:	e8 83 fb ff ff       	call   80220b <get_block_size>
  802688:	83 c4 10             	add    $0x10,%esp
  80268b:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	83 c0 08             	add    $0x8,%eax
  802694:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802697:	0f 87 c5 02 00 00    	ja     802962 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	83 c0 18             	add    $0x18,%eax
  8026a3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8026a6:	0f 87 19 02 00 00    	ja     8028c5 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8026ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026af:	2b 45 08             	sub    0x8(%ebp),%eax
  8026b2:	83 e8 08             	sub    $0x8,%eax
  8026b5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	8d 50 08             	lea    0x8(%eax),%edx
  8026be:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026c1:	01 d0                	add    %edx,%eax
  8026c3:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	83 c0 08             	add    $0x8,%eax
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	6a 01                	push   $0x1
  8026d1:	50                   	push   %eax
  8026d2:	ff 75 bc             	pushl  -0x44(%ebp)
  8026d5:	e8 ae fe ff ff       	call   802588 <set_block_data>
  8026da:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 04             	mov    0x4(%eax),%eax
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	75 68                	jne    80274f <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026e7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026eb:	75 17                	jne    802704 <alloc_block_FF+0x14d>
  8026ed:	83 ec 04             	sub    $0x4,%esp
  8026f0:	68 6c 4c 80 00       	push   $0x804c6c
  8026f5:	68 d8 00 00 00       	push   $0xd8
  8026fa:	68 51 4c 80 00       	push   $0x804c51
  8026ff:	e8 5d e3 ff ff       	call   800a61 <_panic>
  802704:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80270a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80270d:	89 10                	mov    %edx,(%eax)
  80270f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	85 c0                	test   %eax,%eax
  802716:	74 0d                	je     802725 <alloc_block_FF+0x16e>
  802718:	a1 44 50 80 00       	mov    0x805044,%eax
  80271d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802720:	89 50 04             	mov    %edx,0x4(%eax)
  802723:	eb 08                	jmp    80272d <alloc_block_FF+0x176>
  802725:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802728:	a3 48 50 80 00       	mov    %eax,0x805048
  80272d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802730:	a3 44 50 80 00       	mov    %eax,0x805044
  802735:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802738:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273f:	a1 50 50 80 00       	mov    0x805050,%eax
  802744:	40                   	inc    %eax
  802745:	a3 50 50 80 00       	mov    %eax,0x805050
  80274a:	e9 dc 00 00 00       	jmp    80282b <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	85 c0                	test   %eax,%eax
  802756:	75 65                	jne    8027bd <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802758:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80275c:	75 17                	jne    802775 <alloc_block_FF+0x1be>
  80275e:	83 ec 04             	sub    $0x4,%esp
  802761:	68 a0 4c 80 00       	push   $0x804ca0
  802766:	68 dc 00 00 00       	push   $0xdc
  80276b:	68 51 4c 80 00       	push   $0x804c51
  802770:	e8 ec e2 ff ff       	call   800a61 <_panic>
  802775:	8b 15 48 50 80 00    	mov    0x805048,%edx
  80277b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80277e:	89 50 04             	mov    %edx,0x4(%eax)
  802781:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802784:	8b 40 04             	mov    0x4(%eax),%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	74 0c                	je     802797 <alloc_block_FF+0x1e0>
  80278b:	a1 48 50 80 00       	mov    0x805048,%eax
  802790:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802793:	89 10                	mov    %edx,(%eax)
  802795:	eb 08                	jmp    80279f <alloc_block_FF+0x1e8>
  802797:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80279a:	a3 44 50 80 00       	mov    %eax,0x805044
  80279f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027a2:	a3 48 50 80 00       	mov    %eax,0x805048
  8027a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8027b5:	40                   	inc    %eax
  8027b6:	a3 50 50 80 00       	mov    %eax,0x805050
  8027bb:	eb 6e                	jmp    80282b <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8027bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c1:	74 06                	je     8027c9 <alloc_block_FF+0x212>
  8027c3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8027c7:	75 17                	jne    8027e0 <alloc_block_FF+0x229>
  8027c9:	83 ec 04             	sub    $0x4,%esp
  8027cc:	68 c4 4c 80 00       	push   $0x804cc4
  8027d1:	68 e0 00 00 00       	push   $0xe0
  8027d6:	68 51 4c 80 00       	push   $0x804c51
  8027db:	e8 81 e2 ff ff       	call   800a61 <_panic>
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 10                	mov    (%eax),%edx
  8027e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027e8:	89 10                	mov    %edx,(%eax)
  8027ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	74 0b                	je     8027fe <alloc_block_FF+0x247>
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 00                	mov    (%eax),%eax
  8027f8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027fb:	89 50 04             	mov    %edx,0x4(%eax)
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802804:	89 10                	mov    %edx,(%eax)
  802806:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802809:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280c:	89 50 04             	mov    %edx,0x4(%eax)
  80280f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	75 08                	jne    802820 <alloc_block_FF+0x269>
  802818:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80281b:	a3 48 50 80 00       	mov    %eax,0x805048
  802820:	a1 50 50 80 00       	mov    0x805050,%eax
  802825:	40                   	inc    %eax
  802826:	a3 50 50 80 00       	mov    %eax,0x805050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80282b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282f:	75 17                	jne    802848 <alloc_block_FF+0x291>
  802831:	83 ec 04             	sub    $0x4,%esp
  802834:	68 33 4c 80 00       	push   $0x804c33
  802839:	68 e2 00 00 00       	push   $0xe2
  80283e:	68 51 4c 80 00       	push   $0x804c51
  802843:	e8 19 e2 ff ff       	call   800a61 <_panic>
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	74 10                	je     802861 <alloc_block_FF+0x2aa>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802859:	8b 52 04             	mov    0x4(%edx),%edx
  80285c:	89 50 04             	mov    %edx,0x4(%eax)
  80285f:	eb 0b                	jmp    80286c <alloc_block_FF+0x2b5>
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 40 04             	mov    0x4(%eax),%eax
  802867:	a3 48 50 80 00       	mov    %eax,0x805048
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 40 04             	mov    0x4(%eax),%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	74 0f                	je     802885 <alloc_block_FF+0x2ce>
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 40 04             	mov    0x4(%eax),%eax
  80287c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287f:	8b 12                	mov    (%edx),%edx
  802881:	89 10                	mov    %edx,(%eax)
  802883:	eb 0a                	jmp    80288f <alloc_block_FF+0x2d8>
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	a3 44 50 80 00       	mov    %eax,0x805044
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a2:	a1 50 50 80 00       	mov    0x805050,%eax
  8028a7:	48                   	dec    %eax
  8028a8:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(new_block_va, remaining_size, 0);
  8028ad:	83 ec 04             	sub    $0x4,%esp
  8028b0:	6a 00                	push   $0x0
  8028b2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8028b5:	ff 75 b0             	pushl  -0x50(%ebp)
  8028b8:	e8 cb fc ff ff       	call   802588 <set_block_data>
  8028bd:	83 c4 10             	add    $0x10,%esp
  8028c0:	e9 95 00 00 00       	jmp    80295a <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8028c5:	83 ec 04             	sub    $0x4,%esp
  8028c8:	6a 01                	push   $0x1
  8028ca:	ff 75 b8             	pushl  -0x48(%ebp)
  8028cd:	ff 75 bc             	pushl  -0x44(%ebp)
  8028d0:	e8 b3 fc ff ff       	call   802588 <set_block_data>
  8028d5:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8028d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028dc:	75 17                	jne    8028f5 <alloc_block_FF+0x33e>
  8028de:	83 ec 04             	sub    $0x4,%esp
  8028e1:	68 33 4c 80 00       	push   $0x804c33
  8028e6:	68 e9 00 00 00       	push   $0xe9
  8028eb:	68 51 4c 80 00       	push   $0x804c51
  8028f0:	e8 6c e1 ff ff       	call   800a61 <_panic>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 10                	je     80290e <alloc_block_FF+0x357>
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802906:	8b 52 04             	mov    0x4(%edx),%edx
  802909:	89 50 04             	mov    %edx,0x4(%eax)
  80290c:	eb 0b                	jmp    802919 <alloc_block_FF+0x362>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 40 04             	mov    0x4(%eax),%eax
  802914:	a3 48 50 80 00       	mov    %eax,0x805048
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 0f                	je     802932 <alloc_block_FF+0x37b>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 40 04             	mov    0x4(%eax),%eax
  802929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292c:	8b 12                	mov    (%edx),%edx
  80292e:	89 10                	mov    %edx,(%eax)
  802930:	eb 0a                	jmp    80293c <alloc_block_FF+0x385>
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 00                	mov    (%eax),%eax
  802937:	a3 44 50 80 00       	mov    %eax,0x805044
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294f:	a1 50 50 80 00       	mov    0x805050,%eax
  802954:	48                   	dec    %eax
  802955:	a3 50 50 80 00       	mov    %eax,0x805050
	            }
	            return va;
  80295a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80295d:	e9 0f 01 00 00       	jmp    802a71 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802962:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802967:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296e:	74 07                	je     802977 <alloc_block_FF+0x3c0>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	eb 05                	jmp    80297c <alloc_block_FF+0x3c5>
  802977:	b8 00 00 00 00       	mov    $0x0,%eax
  80297c:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802981:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	0f 85 e9 fc ff ff    	jne    802677 <alloc_block_FF+0xc0>
  80298e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802992:	0f 85 df fc ff ff    	jne    802677 <alloc_block_FF+0xc0>
	            }
	            return va;
	        }
	    }

	    uint32 required_size = size + 2 * sizeof(uint32);
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	83 c0 08             	add    $0x8,%eax
  80299e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8029a1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8029a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ae:	01 d0                	add    %edx,%eax
  8029b0:	48                   	dec    %eax
  8029b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8029b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029bc:	f7 75 d8             	divl   -0x28(%ebp)
  8029bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029c2:	29 d0                	sub    %edx,%eax
  8029c4:	c1 e8 0c             	shr    $0xc,%eax
  8029c7:	83 ec 0c             	sub    $0xc,%esp
  8029ca:	50                   	push   %eax
  8029cb:	e8 e8 f0 ff ff       	call   801ab8 <sbrk>
  8029d0:	83 c4 10             	add    $0x10,%esp
  8029d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8029d6:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8029da:	75 0a                	jne    8029e6 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8029dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e1:	e9 8b 00 00 00       	jmp    802a71 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8029e6:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8029ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f3:	01 d0                	add    %edx,%eax
  8029f5:	48                   	dec    %eax
  8029f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8029f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802a01:	f7 75 cc             	divl   -0x34(%ebp)
  802a04:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a07:	29 d0                	sub    %edx,%eax
  802a09:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a0f:	01 d0                	add    %edx,%eax
  802a11:	a3 48 92 80 00       	mov    %eax,0x809248
			end_block->info = 1;
  802a16:	a1 48 92 80 00       	mov    0x809248,%eax
  802a1b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a21:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802a28:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a2b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a2e:	01 d0                	add    %edx,%eax
  802a30:	48                   	dec    %eax
  802a31:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802a34:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a37:	ba 00 00 00 00       	mov    $0x0,%edx
  802a3c:	f7 75 c4             	divl   -0x3c(%ebp)
  802a3f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a42:	29 d0                	sub    %edx,%eax
  802a44:	83 ec 04             	sub    $0x4,%esp
  802a47:	6a 01                	push   $0x1
  802a49:	50                   	push   %eax
  802a4a:	ff 75 d0             	pushl  -0x30(%ebp)
  802a4d:	e8 36 fb ff ff       	call   802588 <set_block_data>
  802a52:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802a55:	83 ec 0c             	sub    $0xc,%esp
  802a58:	ff 75 d0             	pushl  -0x30(%ebp)
  802a5b:	e8 1b 0a 00 00       	call   80347b <free_block>
  802a60:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802a63:	83 ec 0c             	sub    $0xc,%esp
  802a66:	ff 75 08             	pushl  0x8(%ebp)
  802a69:	e8 49 fb ff ff       	call   8025b7 <alloc_block_FF>
  802a6e:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802a71:	c9                   	leave  
  802a72:	c3                   	ret    

00802a73 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
  802a76:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a79:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7c:	83 e0 01             	and    $0x1,%eax
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	74 03                	je     802a86 <alloc_block_BF+0x13>
  802a83:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a86:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a8a:	77 07                	ja     802a93 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a8c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a93:	a1 24 50 80 00       	mov    0x805024,%eax
  802a98:	85 c0                	test   %eax,%eax
  802a9a:	75 73                	jne    802b0f <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	83 c0 10             	add    $0x10,%eax
  802aa2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802aa5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802aac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802aaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab2:	01 d0                	add    %edx,%eax
  802ab4:	48                   	dec    %eax
  802ab5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ab8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802abb:	ba 00 00 00 00       	mov    $0x0,%edx
  802ac0:	f7 75 e0             	divl   -0x20(%ebp)
  802ac3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ac6:	29 d0                	sub    %edx,%eax
  802ac8:	c1 e8 0c             	shr    $0xc,%eax
  802acb:	83 ec 0c             	sub    $0xc,%esp
  802ace:	50                   	push   %eax
  802acf:	e8 e4 ef ff ff       	call   801ab8 <sbrk>
  802ad4:	83 c4 10             	add    $0x10,%esp
  802ad7:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802ada:	83 ec 0c             	sub    $0xc,%esp
  802add:	6a 00                	push   $0x0
  802adf:	e8 d4 ef ff ff       	call   801ab8 <sbrk>
  802ae4:	83 c4 10             	add    $0x10,%esp
  802ae7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802aea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aed:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802af0:	83 ec 08             	sub    $0x8,%esp
  802af3:	50                   	push   %eax
  802af4:	ff 75 d8             	pushl  -0x28(%ebp)
  802af7:	e8 73 f8 ff ff       	call   80236f <initialize_dynamic_allocator>
  802afc:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802aff:	83 ec 0c             	sub    $0xc,%esp
  802b02:	68 8f 4c 80 00       	push   $0x804c8f
  802b07:	e8 12 e2 ff ff       	call   800d1e <cprintf>
  802b0c:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802b0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802b16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802b1d:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802b24:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802b2b:	a1 44 50 80 00       	mov    0x805044,%eax
  802b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b33:	e9 1d 01 00 00       	jmp    802c55 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802b3e:	83 ec 0c             	sub    $0xc,%esp
  802b41:	ff 75 a8             	pushl  -0x58(%ebp)
  802b44:	e8 c2 f6 ff ff       	call   80220b <get_block_size>
  802b49:	83 c4 10             	add    $0x10,%esp
  802b4c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	83 c0 08             	add    $0x8,%eax
  802b55:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b58:	0f 87 ef 00 00 00    	ja     802c4d <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	83 c0 18             	add    $0x18,%eax
  802b64:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b67:	77 1d                	ja     802b86 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b6f:	0f 86 d8 00 00 00    	jbe    802c4d <alloc_block_BF+0x1da>
				{
					best_va = va;
  802b75:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802b7b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b81:	e9 c7 00 00 00       	jmp    802c4d <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	83 c0 08             	add    $0x8,%eax
  802b8c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b8f:	0f 85 9d 00 00 00    	jne    802c32 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802b95:	83 ec 04             	sub    $0x4,%esp
  802b98:	6a 01                	push   $0x1
  802b9a:	ff 75 a4             	pushl  -0x5c(%ebp)
  802b9d:	ff 75 a8             	pushl  -0x58(%ebp)
  802ba0:	e8 e3 f9 ff ff       	call   802588 <set_block_data>
  802ba5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802ba8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bac:	75 17                	jne    802bc5 <alloc_block_BF+0x152>
  802bae:	83 ec 04             	sub    $0x4,%esp
  802bb1:	68 33 4c 80 00       	push   $0x804c33
  802bb6:	68 2e 01 00 00       	push   $0x12e
  802bbb:	68 51 4c 80 00       	push   $0x804c51
  802bc0:	e8 9c de ff ff       	call   800a61 <_panic>
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	74 10                	je     802bde <alloc_block_BF+0x16b>
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd6:	8b 52 04             	mov    0x4(%edx),%edx
  802bd9:	89 50 04             	mov    %edx,0x4(%eax)
  802bdc:	eb 0b                	jmp    802be9 <alloc_block_BF+0x176>
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	8b 40 04             	mov    0x4(%eax),%eax
  802be4:	a3 48 50 80 00       	mov    %eax,0x805048
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 40 04             	mov    0x4(%eax),%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	74 0f                	je     802c02 <alloc_block_BF+0x18f>
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 40 04             	mov    0x4(%eax),%eax
  802bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfc:	8b 12                	mov    (%edx),%edx
  802bfe:	89 10                	mov    %edx,(%eax)
  802c00:	eb 0a                	jmp    802c0c <alloc_block_BF+0x199>
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 00                	mov    (%eax),%eax
  802c07:	a3 44 50 80 00       	mov    %eax,0x805044
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1f:	a1 50 50 80 00       	mov    0x805050,%eax
  802c24:	48                   	dec    %eax
  802c25:	a3 50 50 80 00       	mov    %eax,0x805050
					return va;
  802c2a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c2d:	e9 24 04 00 00       	jmp    803056 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c35:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c38:	76 13                	jbe    802c4d <alloc_block_BF+0x1da>
					{
						internal = 1;
  802c3a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802c41:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802c47:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802c4a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802c4d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c59:	74 07                	je     802c62 <alloc_block_BF+0x1ef>
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	eb 05                	jmp    802c67 <alloc_block_BF+0x1f4>
  802c62:	b8 00 00 00 00       	mov    $0x0,%eax
  802c67:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c6c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	0f 85 bf fe ff ff    	jne    802b38 <alloc_block_BF+0xc5>
  802c79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7d:	0f 85 b5 fe ff ff    	jne    802b38 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802c83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c87:	0f 84 26 02 00 00    	je     802eb3 <alloc_block_BF+0x440>
  802c8d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c91:	0f 85 1c 02 00 00    	jne    802eb3 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9a:	2b 45 08             	sub    0x8(%ebp),%eax
  802c9d:	83 e8 08             	sub    $0x8,%eax
  802ca0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8d 50 08             	lea    0x8(%eax),%edx
  802ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cac:	01 d0                	add    %edx,%eax
  802cae:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	83 c0 08             	add    $0x8,%eax
  802cb7:	83 ec 04             	sub    $0x4,%esp
  802cba:	6a 01                	push   $0x1
  802cbc:	50                   	push   %eax
  802cbd:	ff 75 f0             	pushl  -0x10(%ebp)
  802cc0:	e8 c3 f8 ff ff       	call   802588 <set_block_data>
  802cc5:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccb:	8b 40 04             	mov    0x4(%eax),%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	75 68                	jne    802d3a <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802cd2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802cd6:	75 17                	jne    802cef <alloc_block_BF+0x27c>
  802cd8:	83 ec 04             	sub    $0x4,%esp
  802cdb:	68 6c 4c 80 00       	push   $0x804c6c
  802ce0:	68 47 01 00 00       	push   $0x147
  802ce5:	68 51 4c 80 00       	push   $0x804c51
  802cea:	e8 72 dd ff ff       	call   800a61 <_panic>
  802cef:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802cf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf8:	89 10                	mov    %edx,(%eax)
  802cfa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cfd:	8b 00                	mov    (%eax),%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	74 0d                	je     802d10 <alloc_block_BF+0x29d>
  802d03:	a1 44 50 80 00       	mov    0x805044,%eax
  802d08:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d0b:	89 50 04             	mov    %edx,0x4(%eax)
  802d0e:	eb 08                	jmp    802d18 <alloc_block_BF+0x2a5>
  802d10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d13:	a3 48 50 80 00       	mov    %eax,0x805048
  802d18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d1b:	a3 44 50 80 00       	mov    %eax,0x805044
  802d20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2a:	a1 50 50 80 00       	mov    0x805050,%eax
  802d2f:	40                   	inc    %eax
  802d30:	a3 50 50 80 00       	mov    %eax,0x805050
  802d35:	e9 dc 00 00 00       	jmp    802e16 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	75 65                	jne    802da8 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d43:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d47:	75 17                	jne    802d60 <alloc_block_BF+0x2ed>
  802d49:	83 ec 04             	sub    $0x4,%esp
  802d4c:	68 a0 4c 80 00       	push   $0x804ca0
  802d51:	68 4c 01 00 00       	push   $0x14c
  802d56:	68 51 4c 80 00       	push   $0x804c51
  802d5b:	e8 01 dd ff ff       	call   800a61 <_panic>
  802d60:	8b 15 48 50 80 00    	mov    0x805048,%edx
  802d66:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d69:	89 50 04             	mov    %edx,0x4(%eax)
  802d6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d6f:	8b 40 04             	mov    0x4(%eax),%eax
  802d72:	85 c0                	test   %eax,%eax
  802d74:	74 0c                	je     802d82 <alloc_block_BF+0x30f>
  802d76:	a1 48 50 80 00       	mov    0x805048,%eax
  802d7b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	eb 08                	jmp    802d8a <alloc_block_BF+0x317>
  802d82:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d85:	a3 44 50 80 00       	mov    %eax,0x805044
  802d8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d8d:	a3 48 50 80 00       	mov    %eax,0x805048
  802d92:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9b:	a1 50 50 80 00       	mov    0x805050,%eax
  802da0:	40                   	inc    %eax
  802da1:	a3 50 50 80 00       	mov    %eax,0x805050
  802da6:	eb 6e                	jmp    802e16 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802da8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dac:	74 06                	je     802db4 <alloc_block_BF+0x341>
  802dae:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802db2:	75 17                	jne    802dcb <alloc_block_BF+0x358>
  802db4:	83 ec 04             	sub    $0x4,%esp
  802db7:	68 c4 4c 80 00       	push   $0x804cc4
  802dbc:	68 51 01 00 00       	push   $0x151
  802dc1:	68 51 4c 80 00       	push   $0x804c51
  802dc6:	e8 96 dc ff ff       	call   800a61 <_panic>
  802dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dce:	8b 10                	mov    (%eax),%edx
  802dd0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dd3:	89 10                	mov    %edx,(%eax)
  802dd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	74 0b                	je     802de9 <alloc_block_BF+0x376>
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802de6:	89 50 04             	mov    %edx,0x4(%eax)
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802def:	89 10                	mov    %edx,(%eax)
  802df1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802df4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df7:	89 50 04             	mov    %edx,0x4(%eax)
  802dfa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dfd:	8b 00                	mov    (%eax),%eax
  802dff:	85 c0                	test   %eax,%eax
  802e01:	75 08                	jne    802e0b <alloc_block_BF+0x398>
  802e03:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e06:	a3 48 50 80 00       	mov    %eax,0x805048
  802e0b:	a1 50 50 80 00       	mov    0x805050,%eax
  802e10:	40                   	inc    %eax
  802e11:	a3 50 50 80 00       	mov    %eax,0x805050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802e16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1a:	75 17                	jne    802e33 <alloc_block_BF+0x3c0>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 33 4c 80 00       	push   $0x804c33
  802e24:	68 53 01 00 00       	push   $0x153
  802e29:	68 51 4c 80 00       	push   $0x804c51
  802e2e:	e8 2e dc ff ff       	call   800a61 <_panic>
  802e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	85 c0                	test   %eax,%eax
  802e3a:	74 10                	je     802e4c <alloc_block_BF+0x3d9>
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e44:	8b 52 04             	mov    0x4(%edx),%edx
  802e47:	89 50 04             	mov    %edx,0x4(%eax)
  802e4a:	eb 0b                	jmp    802e57 <alloc_block_BF+0x3e4>
  802e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	a3 48 50 80 00       	mov    %eax,0x805048
  802e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0f                	je     802e70 <alloc_block_BF+0x3fd>
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e6a:	8b 12                	mov    (%edx),%edx
  802e6c:	89 10                	mov    %edx,(%eax)
  802e6e:	eb 0a                	jmp    802e7a <alloc_block_BF+0x407>
  802e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	a3 44 50 80 00       	mov    %eax,0x805044
  802e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8d:	a1 50 50 80 00       	mov    0x805050,%eax
  802e92:	48                   	dec    %eax
  802e93:	a3 50 50 80 00       	mov    %eax,0x805050
			set_block_data(new_block_va, remaining_size, 0);
  802e98:	83 ec 04             	sub    $0x4,%esp
  802e9b:	6a 00                	push   $0x0
  802e9d:	ff 75 d0             	pushl  -0x30(%ebp)
  802ea0:	ff 75 cc             	pushl  -0x34(%ebp)
  802ea3:	e8 e0 f6 ff ff       	call   802588 <set_block_data>
  802ea8:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eae:	e9 a3 01 00 00       	jmp    803056 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802eb3:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802eb7:	0f 85 9d 00 00 00    	jne    802f5a <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	6a 01                	push   $0x1
  802ec2:	ff 75 ec             	pushl  -0x14(%ebp)
  802ec5:	ff 75 f0             	pushl  -0x10(%ebp)
  802ec8:	e8 bb f6 ff ff       	call   802588 <set_block_data>
  802ecd:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802ed0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed4:	75 17                	jne    802eed <alloc_block_BF+0x47a>
  802ed6:	83 ec 04             	sub    $0x4,%esp
  802ed9:	68 33 4c 80 00       	push   $0x804c33
  802ede:	68 5a 01 00 00       	push   $0x15a
  802ee3:	68 51 4c 80 00       	push   $0x804c51
  802ee8:	e8 74 db ff ff       	call   800a61 <_panic>
  802eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	74 10                	je     802f06 <alloc_block_BF+0x493>
  802ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef9:	8b 00                	mov    (%eax),%eax
  802efb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802efe:	8b 52 04             	mov    0x4(%edx),%edx
  802f01:	89 50 04             	mov    %edx,0x4(%eax)
  802f04:	eb 0b                	jmp    802f11 <alloc_block_BF+0x49e>
  802f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f09:	8b 40 04             	mov    0x4(%eax),%eax
  802f0c:	a3 48 50 80 00       	mov    %eax,0x805048
  802f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f14:	8b 40 04             	mov    0x4(%eax),%eax
  802f17:	85 c0                	test   %eax,%eax
  802f19:	74 0f                	je     802f2a <alloc_block_BF+0x4b7>
  802f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1e:	8b 40 04             	mov    0x4(%eax),%eax
  802f21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f24:	8b 12                	mov    (%edx),%edx
  802f26:	89 10                	mov    %edx,(%eax)
  802f28:	eb 0a                	jmp    802f34 <alloc_block_BF+0x4c1>
  802f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	a3 44 50 80 00       	mov    %eax,0x805044
  802f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f47:	a1 50 50 80 00       	mov    0x805050,%eax
  802f4c:	48                   	dec    %eax
  802f4d:	a3 50 50 80 00       	mov    %eax,0x805050
		return best_va;
  802f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f55:	e9 fc 00 00 00       	jmp    803056 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	83 c0 08             	add    $0x8,%eax
  802f60:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f63:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f6a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f6d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f70:	01 d0                	add    %edx,%eax
  802f72:	48                   	dec    %eax
  802f73:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f79:	ba 00 00 00 00       	mov    $0x0,%edx
  802f7e:	f7 75 c4             	divl   -0x3c(%ebp)
  802f81:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f84:	29 d0                	sub    %edx,%eax
  802f86:	c1 e8 0c             	shr    $0xc,%eax
  802f89:	83 ec 0c             	sub    $0xc,%esp
  802f8c:	50                   	push   %eax
  802f8d:	e8 26 eb ff ff       	call   801ab8 <sbrk>
  802f92:	83 c4 10             	add    $0x10,%esp
  802f95:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802f98:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802f9c:	75 0a                	jne    802fa8 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa3:	e9 ae 00 00 00       	jmp    803056 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802fa8:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802faf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802fb2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802fb5:	01 d0                	add    %edx,%eax
  802fb7:	48                   	dec    %eax
  802fb8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802fbb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fbe:	ba 00 00 00 00       	mov    $0x0,%edx
  802fc3:	f7 75 b8             	divl   -0x48(%ebp)
  802fc6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fc9:	29 d0                	sub    %edx,%eax
  802fcb:	8d 50 fc             	lea    -0x4(%eax),%edx
  802fce:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802fd1:	01 d0                	add    %edx,%eax
  802fd3:	a3 48 92 80 00       	mov    %eax,0x809248
				end_block->info = 1;
  802fd8:	a1 48 92 80 00       	mov    0x809248,%eax
  802fdd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802fe3:	83 ec 0c             	sub    $0xc,%esp
  802fe6:	68 f8 4c 80 00       	push   $0x804cf8
  802feb:	e8 2e dd ff ff       	call   800d1e <cprintf>
  802ff0:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802ff3:	83 ec 08             	sub    $0x8,%esp
  802ff6:	ff 75 bc             	pushl  -0x44(%ebp)
  802ff9:	68 fd 4c 80 00       	push   $0x804cfd
  802ffe:	e8 1b dd ff ff       	call   800d1e <cprintf>
  803003:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803006:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80300d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803010:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803013:	01 d0                	add    %edx,%eax
  803015:	48                   	dec    %eax
  803016:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803019:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80301c:	ba 00 00 00 00       	mov    $0x0,%edx
  803021:	f7 75 b0             	divl   -0x50(%ebp)
  803024:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803027:	29 d0                	sub    %edx,%eax
  803029:	83 ec 04             	sub    $0x4,%esp
  80302c:	6a 01                	push   $0x1
  80302e:	50                   	push   %eax
  80302f:	ff 75 bc             	pushl  -0x44(%ebp)
  803032:	e8 51 f5 ff ff       	call   802588 <set_block_data>
  803037:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80303a:	83 ec 0c             	sub    $0xc,%esp
  80303d:	ff 75 bc             	pushl  -0x44(%ebp)
  803040:	e8 36 04 00 00       	call   80347b <free_block>
  803045:	83 c4 10             	add    $0x10,%esp
			return alloc_block_FF(size);
  803048:	83 ec 0c             	sub    $0xc,%esp
  80304b:	ff 75 08             	pushl  0x8(%ebp)
  80304e:	e8 64 f5 ff ff       	call   8025b7 <alloc_block_FF>
  803053:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803056:	c9                   	leave  
  803057:	c3                   	ret    

00803058 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803058:	55                   	push   %ebp
  803059:	89 e5                	mov    %esp,%ebp
  80305b:	53                   	push   %ebx
  80305c:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80305f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803066:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80306d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803071:	74 1e                	je     803091 <merging+0x39>
  803073:	ff 75 08             	pushl  0x8(%ebp)
  803076:	e8 90 f1 ff ff       	call   80220b <get_block_size>
  80307b:	83 c4 04             	add    $0x4,%esp
  80307e:	89 c2                	mov    %eax,%edx
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	01 d0                	add    %edx,%eax
  803085:	3b 45 10             	cmp    0x10(%ebp),%eax
  803088:	75 07                	jne    803091 <merging+0x39>
		prev_is_free = 1;
  80308a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803091:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803095:	74 1e                	je     8030b5 <merging+0x5d>
  803097:	ff 75 10             	pushl  0x10(%ebp)
  80309a:	e8 6c f1 ff ff       	call   80220b <get_block_size>
  80309f:	83 c4 04             	add    $0x4,%esp
  8030a2:	89 c2                	mov    %eax,%edx
  8030a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8030a7:	01 d0                	add    %edx,%eax
  8030a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030ac:	75 07                	jne    8030b5 <merging+0x5d>
		next_is_free = 1;
  8030ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8030b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b9:	0f 84 cc 00 00 00    	je     80318b <merging+0x133>
  8030bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030c3:	0f 84 c2 00 00 00    	je     80318b <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8030c9:	ff 75 08             	pushl  0x8(%ebp)
  8030cc:	e8 3a f1 ff ff       	call   80220b <get_block_size>
  8030d1:	83 c4 04             	add    $0x4,%esp
  8030d4:	89 c3                	mov    %eax,%ebx
  8030d6:	ff 75 10             	pushl  0x10(%ebp)
  8030d9:	e8 2d f1 ff ff       	call   80220b <get_block_size>
  8030de:	83 c4 04             	add    $0x4,%esp
  8030e1:	01 c3                	add    %eax,%ebx
  8030e3:	ff 75 0c             	pushl  0xc(%ebp)
  8030e6:	e8 20 f1 ff ff       	call   80220b <get_block_size>
  8030eb:	83 c4 04             	add    $0x4,%esp
  8030ee:	01 d8                	add    %ebx,%eax
  8030f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8030f3:	6a 00                	push   $0x0
  8030f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8030f8:	ff 75 08             	pushl  0x8(%ebp)
  8030fb:	e8 88 f4 ff ff       	call   802588 <set_block_data>
  803100:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803103:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803107:	75 17                	jne    803120 <merging+0xc8>
  803109:	83 ec 04             	sub    $0x4,%esp
  80310c:	68 33 4c 80 00       	push   $0x804c33
  803111:	68 7f 01 00 00       	push   $0x17f
  803116:	68 51 4c 80 00       	push   $0x804c51
  80311b:	e8 41 d9 ff ff       	call   800a61 <_panic>
  803120:	8b 45 0c             	mov    0xc(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	85 c0                	test   %eax,%eax
  803127:	74 10                	je     803139 <merging+0xe1>
  803129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80312c:	8b 00                	mov    (%eax),%eax
  80312e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803131:	8b 52 04             	mov    0x4(%edx),%edx
  803134:	89 50 04             	mov    %edx,0x4(%eax)
  803137:	eb 0b                	jmp    803144 <merging+0xec>
  803139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313c:	8b 40 04             	mov    0x4(%eax),%eax
  80313f:	a3 48 50 80 00       	mov    %eax,0x805048
  803144:	8b 45 0c             	mov    0xc(%ebp),%eax
  803147:	8b 40 04             	mov    0x4(%eax),%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	74 0f                	je     80315d <merging+0x105>
  80314e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803151:	8b 40 04             	mov    0x4(%eax),%eax
  803154:	8b 55 0c             	mov    0xc(%ebp),%edx
  803157:	8b 12                	mov    (%edx),%edx
  803159:	89 10                	mov    %edx,(%eax)
  80315b:	eb 0a                	jmp    803167 <merging+0x10f>
  80315d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	a3 44 50 80 00       	mov    %eax,0x805044
  803167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803170:	8b 45 0c             	mov    0xc(%ebp),%eax
  803173:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317a:	a1 50 50 80 00       	mov    0x805050,%eax
  80317f:	48                   	dec    %eax
  803180:	a3 50 50 80 00       	mov    %eax,0x805050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803185:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803186:	e9 ea 02 00 00       	jmp    803475 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80318b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80318f:	74 3b                	je     8031cc <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803191:	83 ec 0c             	sub    $0xc,%esp
  803194:	ff 75 08             	pushl  0x8(%ebp)
  803197:	e8 6f f0 ff ff       	call   80220b <get_block_size>
  80319c:	83 c4 10             	add    $0x10,%esp
  80319f:	89 c3                	mov    %eax,%ebx
  8031a1:	83 ec 0c             	sub    $0xc,%esp
  8031a4:	ff 75 10             	pushl  0x10(%ebp)
  8031a7:	e8 5f f0 ff ff       	call   80220b <get_block_size>
  8031ac:	83 c4 10             	add    $0x10,%esp
  8031af:	01 d8                	add    %ebx,%eax
  8031b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8031b4:	83 ec 04             	sub    $0x4,%esp
  8031b7:	6a 00                	push   $0x0
  8031b9:	ff 75 e8             	pushl  -0x18(%ebp)
  8031bc:	ff 75 08             	pushl  0x8(%ebp)
  8031bf:	e8 c4 f3 ff ff       	call   802588 <set_block_data>
  8031c4:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031c7:	e9 a9 02 00 00       	jmp    803475 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8031cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d0:	0f 84 2d 01 00 00    	je     803303 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8031d6:	83 ec 0c             	sub    $0xc,%esp
  8031d9:	ff 75 10             	pushl  0x10(%ebp)
  8031dc:	e8 2a f0 ff ff       	call   80220b <get_block_size>
  8031e1:	83 c4 10             	add    $0x10,%esp
  8031e4:	89 c3                	mov    %eax,%ebx
  8031e6:	83 ec 0c             	sub    $0xc,%esp
  8031e9:	ff 75 0c             	pushl  0xc(%ebp)
  8031ec:	e8 1a f0 ff ff       	call   80220b <get_block_size>
  8031f1:	83 c4 10             	add    $0x10,%esp
  8031f4:	01 d8                	add    %ebx,%eax
  8031f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	6a 00                	push   $0x0
  8031fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  803201:	ff 75 10             	pushl  0x10(%ebp)
  803204:	e8 7f f3 ff ff       	call   802588 <set_block_data>
  803209:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80320c:	8b 45 10             	mov    0x10(%ebp),%eax
  80320f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803212:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803216:	74 06                	je     80321e <merging+0x1c6>
  803218:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80321c:	75 17                	jne    803235 <merging+0x1dd>
  80321e:	83 ec 04             	sub    $0x4,%esp
  803221:	68 0c 4d 80 00       	push   $0x804d0c
  803226:	68 8f 01 00 00       	push   $0x18f
  80322b:	68 51 4c 80 00       	push   $0x804c51
  803230:	e8 2c d8 ff ff       	call   800a61 <_panic>
  803235:	8b 45 0c             	mov    0xc(%ebp),%eax
  803238:	8b 50 04             	mov    0x4(%eax),%edx
  80323b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80323e:	89 50 04             	mov    %edx,0x4(%eax)
  803241:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803244:	8b 55 0c             	mov    0xc(%ebp),%edx
  803247:	89 10                	mov    %edx,(%eax)
  803249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80324c:	8b 40 04             	mov    0x4(%eax),%eax
  80324f:	85 c0                	test   %eax,%eax
  803251:	74 0d                	je     803260 <merging+0x208>
  803253:	8b 45 0c             	mov    0xc(%ebp),%eax
  803256:	8b 40 04             	mov    0x4(%eax),%eax
  803259:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80325c:	89 10                	mov    %edx,(%eax)
  80325e:	eb 08                	jmp    803268 <merging+0x210>
  803260:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803263:	a3 44 50 80 00       	mov    %eax,0x805044
  803268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80326b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80326e:	89 50 04             	mov    %edx,0x4(%eax)
  803271:	a1 50 50 80 00       	mov    0x805050,%eax
  803276:	40                   	inc    %eax
  803277:	a3 50 50 80 00       	mov    %eax,0x805050
		LIST_REMOVE(&freeBlocksList, next_block);
  80327c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803280:	75 17                	jne    803299 <merging+0x241>
  803282:	83 ec 04             	sub    $0x4,%esp
  803285:	68 33 4c 80 00       	push   $0x804c33
  80328a:	68 90 01 00 00       	push   $0x190
  80328f:	68 51 4c 80 00       	push   $0x804c51
  803294:	e8 c8 d7 ff ff       	call   800a61 <_panic>
  803299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329c:	8b 00                	mov    (%eax),%eax
  80329e:	85 c0                	test   %eax,%eax
  8032a0:	74 10                	je     8032b2 <merging+0x25a>
  8032a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a5:	8b 00                	mov    (%eax),%eax
  8032a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032aa:	8b 52 04             	mov    0x4(%edx),%edx
  8032ad:	89 50 04             	mov    %edx,0x4(%eax)
  8032b0:	eb 0b                	jmp    8032bd <merging+0x265>
  8032b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b5:	8b 40 04             	mov    0x4(%eax),%eax
  8032b8:	a3 48 50 80 00       	mov    %eax,0x805048
  8032bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c0:	8b 40 04             	mov    0x4(%eax),%eax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	74 0f                	je     8032d6 <merging+0x27e>
  8032c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ca:	8b 40 04             	mov    0x4(%eax),%eax
  8032cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032d0:	8b 12                	mov    (%edx),%edx
  8032d2:	89 10                	mov    %edx,(%eax)
  8032d4:	eb 0a                	jmp    8032e0 <merging+0x288>
  8032d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d9:	8b 00                	mov    (%eax),%eax
  8032db:	a3 44 50 80 00       	mov    %eax,0x805044
  8032e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f3:	a1 50 50 80 00       	mov    0x805050,%eax
  8032f8:	48                   	dec    %eax
  8032f9:	a3 50 50 80 00       	mov    %eax,0x805050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032fe:	e9 72 01 00 00       	jmp    803475 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803303:	8b 45 10             	mov    0x10(%ebp),%eax
  803306:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803309:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80330d:	74 79                	je     803388 <merging+0x330>
  80330f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803313:	74 73                	je     803388 <merging+0x330>
  803315:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803319:	74 06                	je     803321 <merging+0x2c9>
  80331b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80331f:	75 17                	jne    803338 <merging+0x2e0>
  803321:	83 ec 04             	sub    $0x4,%esp
  803324:	68 c4 4c 80 00       	push   $0x804cc4
  803329:	68 96 01 00 00       	push   $0x196
  80332e:	68 51 4c 80 00       	push   $0x804c51
  803333:	e8 29 d7 ff ff       	call   800a61 <_panic>
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	8b 10                	mov    (%eax),%edx
  80333d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803340:	89 10                	mov    %edx,(%eax)
  803342:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	85 c0                	test   %eax,%eax
  803349:	74 0b                	je     803356 <merging+0x2fe>
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803353:	89 50 04             	mov    %edx,0x4(%eax)
  803356:	8b 45 08             	mov    0x8(%ebp),%eax
  803359:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80335c:	89 10                	mov    %edx,(%eax)
  80335e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803361:	8b 55 08             	mov    0x8(%ebp),%edx
  803364:	89 50 04             	mov    %edx,0x4(%eax)
  803367:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	75 08                	jne    803378 <merging+0x320>
  803370:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803373:	a3 48 50 80 00       	mov    %eax,0x805048
  803378:	a1 50 50 80 00       	mov    0x805050,%eax
  80337d:	40                   	inc    %eax
  80337e:	a3 50 50 80 00       	mov    %eax,0x805050
  803383:	e9 ce 00 00 00       	jmp    803456 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803388:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80338c:	74 65                	je     8033f3 <merging+0x39b>
  80338e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803392:	75 17                	jne    8033ab <merging+0x353>
  803394:	83 ec 04             	sub    $0x4,%esp
  803397:	68 a0 4c 80 00       	push   $0x804ca0
  80339c:	68 97 01 00 00       	push   $0x197
  8033a1:	68 51 4c 80 00       	push   $0x804c51
  8033a6:	e8 b6 d6 ff ff       	call   800a61 <_panic>
  8033ab:	8b 15 48 50 80 00    	mov    0x805048,%edx
  8033b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033b4:	89 50 04             	mov    %edx,0x4(%eax)
  8033b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ba:	8b 40 04             	mov    0x4(%eax),%eax
  8033bd:	85 c0                	test   %eax,%eax
  8033bf:	74 0c                	je     8033cd <merging+0x375>
  8033c1:	a1 48 50 80 00       	mov    0x805048,%eax
  8033c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033c9:	89 10                	mov    %edx,(%eax)
  8033cb:	eb 08                	jmp    8033d5 <merging+0x37d>
  8033cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033d0:	a3 44 50 80 00       	mov    %eax,0x805044
  8033d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033d8:	a3 48 50 80 00       	mov    %eax,0x805048
  8033dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e6:	a1 50 50 80 00       	mov    0x805050,%eax
  8033eb:	40                   	inc    %eax
  8033ec:	a3 50 50 80 00       	mov    %eax,0x805050
  8033f1:	eb 63                	jmp    803456 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8033f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033f7:	75 17                	jne    803410 <merging+0x3b8>
  8033f9:	83 ec 04             	sub    $0x4,%esp
  8033fc:	68 6c 4c 80 00       	push   $0x804c6c
  803401:	68 9a 01 00 00       	push   $0x19a
  803406:	68 51 4c 80 00       	push   $0x804c51
  80340b:	e8 51 d6 ff ff       	call   800a61 <_panic>
  803410:	8b 15 44 50 80 00    	mov    0x805044,%edx
  803416:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803419:	89 10                	mov    %edx,(%eax)
  80341b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80341e:	8b 00                	mov    (%eax),%eax
  803420:	85 c0                	test   %eax,%eax
  803422:	74 0d                	je     803431 <merging+0x3d9>
  803424:	a1 44 50 80 00       	mov    0x805044,%eax
  803429:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80342c:	89 50 04             	mov    %edx,0x4(%eax)
  80342f:	eb 08                	jmp    803439 <merging+0x3e1>
  803431:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803434:	a3 48 50 80 00       	mov    %eax,0x805048
  803439:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80343c:	a3 44 50 80 00       	mov    %eax,0x805044
  803441:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803444:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344b:	a1 50 50 80 00       	mov    0x805050,%eax
  803450:	40                   	inc    %eax
  803451:	a3 50 50 80 00       	mov    %eax,0x805050
		}
		set_block_data(va, get_block_size(va), 0);
  803456:	83 ec 0c             	sub    $0xc,%esp
  803459:	ff 75 10             	pushl  0x10(%ebp)
  80345c:	e8 aa ed ff ff       	call   80220b <get_block_size>
  803461:	83 c4 10             	add    $0x10,%esp
  803464:	83 ec 04             	sub    $0x4,%esp
  803467:	6a 00                	push   $0x0
  803469:	50                   	push   %eax
  80346a:	ff 75 10             	pushl  0x10(%ebp)
  80346d:	e8 16 f1 ff ff       	call   802588 <set_block_data>
  803472:	83 c4 10             	add    $0x10,%esp
	}
}
  803475:	90                   	nop
  803476:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803479:	c9                   	leave  
  80347a:	c3                   	ret    

0080347b <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80347b:	55                   	push   %ebp
  80347c:	89 e5                	mov    %esp,%ebp
  80347e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803481:	a1 44 50 80 00       	mov    0x805044,%eax
  803486:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803489:	a1 48 50 80 00       	mov    0x805048,%eax
  80348e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803491:	73 1b                	jae    8034ae <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803493:	a1 48 50 80 00       	mov    0x805048,%eax
  803498:	83 ec 04             	sub    $0x4,%esp
  80349b:	ff 75 08             	pushl  0x8(%ebp)
  80349e:	6a 00                	push   $0x0
  8034a0:	50                   	push   %eax
  8034a1:	e8 b2 fb ff ff       	call   803058 <merging>
  8034a6:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8034a9:	e9 8b 00 00 00       	jmp    803539 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8034ae:	a1 44 50 80 00       	mov    0x805044,%eax
  8034b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034b6:	76 18                	jbe    8034d0 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8034b8:	a1 44 50 80 00       	mov    0x805044,%eax
  8034bd:	83 ec 04             	sub    $0x4,%esp
  8034c0:	ff 75 08             	pushl  0x8(%ebp)
  8034c3:	50                   	push   %eax
  8034c4:	6a 00                	push   $0x0
  8034c6:	e8 8d fb ff ff       	call   803058 <merging>
  8034cb:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8034ce:	eb 69                	jmp    803539 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8034d0:	a1 44 50 80 00       	mov    0x805044,%eax
  8034d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034d8:	eb 39                	jmp    803513 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8034da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034e0:	73 29                	jae    80350b <free_block+0x90>
  8034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e5:	8b 00                	mov    (%eax),%eax
  8034e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034ea:	76 1f                	jbe    80350b <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8034ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ef:	8b 00                	mov    (%eax),%eax
  8034f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8034f4:	83 ec 04             	sub    $0x4,%esp
  8034f7:	ff 75 08             	pushl  0x8(%ebp)
  8034fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8034fd:	ff 75 f4             	pushl  -0xc(%ebp)
  803500:	e8 53 fb ff ff       	call   803058 <merging>
  803505:	83 c4 10             	add    $0x10,%esp
			break;
  803508:	90                   	nop
		}
	}
}
  803509:	eb 2e                	jmp    803539 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80350b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803517:	74 07                	je     803520 <free_block+0xa5>
  803519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351c:	8b 00                	mov    (%eax),%eax
  80351e:	eb 05                	jmp    803525 <free_block+0xaa>
  803520:	b8 00 00 00 00       	mov    $0x0,%eax
  803525:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80352a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80352f:	85 c0                	test   %eax,%eax
  803531:	75 a7                	jne    8034da <free_block+0x5f>
  803533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803537:	75 a1                	jne    8034da <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803539:	90                   	nop
  80353a:	c9                   	leave  
  80353b:	c3                   	ret    

0080353c <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80353c:	55                   	push   %ebp
  80353d:	89 e5                	mov    %esp,%ebp
  80353f:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803542:	ff 75 08             	pushl  0x8(%ebp)
  803545:	e8 c1 ec ff ff       	call   80220b <get_block_size>
  80354a:	83 c4 04             	add    $0x4,%esp
  80354d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803550:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803557:	eb 17                	jmp    803570 <copy_data+0x34>
  803559:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80355c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355f:	01 c2                	add    %eax,%edx
  803561:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803564:	8b 45 08             	mov    0x8(%ebp),%eax
  803567:	01 c8                	add    %ecx,%eax
  803569:	8a 00                	mov    (%eax),%al
  80356b:	88 02                	mov    %al,(%edx)
  80356d:	ff 45 fc             	incl   -0x4(%ebp)
  803570:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803573:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803576:	72 e1                	jb     803559 <copy_data+0x1d>
}
  803578:	90                   	nop
  803579:	c9                   	leave  
  80357a:	c3                   	ret    

0080357b <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80357b:	55                   	push   %ebp
  80357c:	89 e5                	mov    %esp,%ebp
  80357e:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803581:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803585:	75 23                	jne    8035aa <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803587:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80358b:	74 13                	je     8035a0 <realloc_block_FF+0x25>
  80358d:	83 ec 0c             	sub    $0xc,%esp
  803590:	ff 75 0c             	pushl  0xc(%ebp)
  803593:	e8 1f f0 ff ff       	call   8025b7 <alloc_block_FF>
  803598:	83 c4 10             	add    $0x10,%esp
  80359b:	e9 f4 06 00 00       	jmp    803c94 <realloc_block_FF+0x719>
		return NULL;
  8035a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a5:	e9 ea 06 00 00       	jmp    803c94 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8035aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035ae:	75 18                	jne    8035c8 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8035b0:	83 ec 0c             	sub    $0xc,%esp
  8035b3:	ff 75 08             	pushl  0x8(%ebp)
  8035b6:	e8 c0 fe ff ff       	call   80347b <free_block>
  8035bb:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8035be:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c3:	e9 cc 06 00 00       	jmp    803c94 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8035c8:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8035cc:	77 07                	ja     8035d5 <realloc_block_FF+0x5a>
  8035ce:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8035d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d8:	83 e0 01             	and    $0x1,%eax
  8035db:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8035de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e1:	83 c0 08             	add    $0x8,%eax
  8035e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8035e7:	83 ec 0c             	sub    $0xc,%esp
  8035ea:	ff 75 08             	pushl  0x8(%ebp)
  8035ed:	e8 19 ec ff ff       	call   80220b <get_block_size>
  8035f2:	83 c4 10             	add    $0x10,%esp
  8035f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8035f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fb:	83 e8 08             	sub    $0x8,%eax
  8035fe:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	83 e8 04             	sub    $0x4,%eax
  803607:	8b 00                	mov    (%eax),%eax
  803609:	83 e0 fe             	and    $0xfffffffe,%eax
  80360c:	89 c2                	mov    %eax,%edx
  80360e:	8b 45 08             	mov    0x8(%ebp),%eax
  803611:	01 d0                	add    %edx,%eax
  803613:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803616:	83 ec 0c             	sub    $0xc,%esp
  803619:	ff 75 e4             	pushl  -0x1c(%ebp)
  80361c:	e8 ea eb ff ff       	call   80220b <get_block_size>
  803621:	83 c4 10             	add    $0x10,%esp
  803624:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80362a:	83 e8 08             	sub    $0x8,%eax
  80362d:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803630:	8b 45 0c             	mov    0xc(%ebp),%eax
  803633:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803636:	75 08                	jne    803640 <realloc_block_FF+0xc5>
	{
		 return va;
  803638:	8b 45 08             	mov    0x8(%ebp),%eax
  80363b:	e9 54 06 00 00       	jmp    803c94 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803640:	8b 45 0c             	mov    0xc(%ebp),%eax
  803643:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803646:	0f 83 e5 03 00 00    	jae    803a31 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80364c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364f:	2b 45 0c             	sub    0xc(%ebp),%eax
  803652:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803655:	83 ec 0c             	sub    $0xc,%esp
  803658:	ff 75 e4             	pushl  -0x1c(%ebp)
  80365b:	e8 c4 eb ff ff       	call   802224 <is_free_block>
  803660:	83 c4 10             	add    $0x10,%esp
  803663:	84 c0                	test   %al,%al
  803665:	0f 84 3b 01 00 00    	je     8037a6 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80366b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80366e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803671:	01 d0                	add    %edx,%eax
  803673:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803676:	83 ec 04             	sub    $0x4,%esp
  803679:	6a 01                	push   $0x1
  80367b:	ff 75 f0             	pushl  -0x10(%ebp)
  80367e:	ff 75 08             	pushl  0x8(%ebp)
  803681:	e8 02 ef ff ff       	call   802588 <set_block_data>
  803686:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803689:	8b 45 08             	mov    0x8(%ebp),%eax
  80368c:	83 e8 04             	sub    $0x4,%eax
  80368f:	8b 00                	mov    (%eax),%eax
  803691:	83 e0 fe             	and    $0xfffffffe,%eax
  803694:	89 c2                	mov    %eax,%edx
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	01 d0                	add    %edx,%eax
  80369b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80369e:	83 ec 04             	sub    $0x4,%esp
  8036a1:	6a 00                	push   $0x0
  8036a3:	ff 75 cc             	pushl  -0x34(%ebp)
  8036a6:	ff 75 c8             	pushl  -0x38(%ebp)
  8036a9:	e8 da ee ff ff       	call   802588 <set_block_data>
  8036ae:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036b5:	74 06                	je     8036bd <realloc_block_FF+0x142>
  8036b7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8036bb:	75 17                	jne    8036d4 <realloc_block_FF+0x159>
  8036bd:	83 ec 04             	sub    $0x4,%esp
  8036c0:	68 c4 4c 80 00       	push   $0x804cc4
  8036c5:	68 f8 01 00 00       	push   $0x1f8
  8036ca:	68 51 4c 80 00       	push   $0x804c51
  8036cf:	e8 8d d3 ff ff       	call   800a61 <_panic>
  8036d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d7:	8b 10                	mov    (%eax),%edx
  8036d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036dc:	89 10                	mov    %edx,(%eax)
  8036de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036e1:	8b 00                	mov    (%eax),%eax
  8036e3:	85 c0                	test   %eax,%eax
  8036e5:	74 0b                	je     8036f2 <realloc_block_FF+0x177>
  8036e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ea:	8b 00                	mov    (%eax),%eax
  8036ec:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8036ef:	89 50 04             	mov    %edx,0x4(%eax)
  8036f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8036f8:	89 10                	mov    %edx,(%eax)
  8036fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803700:	89 50 04             	mov    %edx,0x4(%eax)
  803703:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803706:	8b 00                	mov    (%eax),%eax
  803708:	85 c0                	test   %eax,%eax
  80370a:	75 08                	jne    803714 <realloc_block_FF+0x199>
  80370c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80370f:	a3 48 50 80 00       	mov    %eax,0x805048
  803714:	a1 50 50 80 00       	mov    0x805050,%eax
  803719:	40                   	inc    %eax
  80371a:	a3 50 50 80 00       	mov    %eax,0x805050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80371f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803723:	75 17                	jne    80373c <realloc_block_FF+0x1c1>
  803725:	83 ec 04             	sub    $0x4,%esp
  803728:	68 33 4c 80 00       	push   $0x804c33
  80372d:	68 f9 01 00 00       	push   $0x1f9
  803732:	68 51 4c 80 00       	push   $0x804c51
  803737:	e8 25 d3 ff ff       	call   800a61 <_panic>
  80373c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373f:	8b 00                	mov    (%eax),%eax
  803741:	85 c0                	test   %eax,%eax
  803743:	74 10                	je     803755 <realloc_block_FF+0x1da>
  803745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803748:	8b 00                	mov    (%eax),%eax
  80374a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80374d:	8b 52 04             	mov    0x4(%edx),%edx
  803750:	89 50 04             	mov    %edx,0x4(%eax)
  803753:	eb 0b                	jmp    803760 <realloc_block_FF+0x1e5>
  803755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803758:	8b 40 04             	mov    0x4(%eax),%eax
  80375b:	a3 48 50 80 00       	mov    %eax,0x805048
  803760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803763:	8b 40 04             	mov    0x4(%eax),%eax
  803766:	85 c0                	test   %eax,%eax
  803768:	74 0f                	je     803779 <realloc_block_FF+0x1fe>
  80376a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376d:	8b 40 04             	mov    0x4(%eax),%eax
  803770:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803773:	8b 12                	mov    (%edx),%edx
  803775:	89 10                	mov    %edx,(%eax)
  803777:	eb 0a                	jmp    803783 <realloc_block_FF+0x208>
  803779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377c:	8b 00                	mov    (%eax),%eax
  80377e:	a3 44 50 80 00       	mov    %eax,0x805044
  803783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803786:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803796:	a1 50 50 80 00       	mov    0x805050,%eax
  80379b:	48                   	dec    %eax
  80379c:	a3 50 50 80 00       	mov    %eax,0x805050
  8037a1:	e9 83 02 00 00       	jmp    803a29 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8037a6:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8037aa:	0f 86 69 02 00 00    	jbe    803a19 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8037b0:	83 ec 04             	sub    $0x4,%esp
  8037b3:	6a 01                	push   $0x1
  8037b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8037b8:	ff 75 08             	pushl  0x8(%ebp)
  8037bb:	e8 c8 ed ff ff       	call   802588 <set_block_data>
  8037c0:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c6:	83 e8 04             	sub    $0x4,%eax
  8037c9:	8b 00                	mov    (%eax),%eax
  8037cb:	83 e0 fe             	and    $0xfffffffe,%eax
  8037ce:	89 c2                	mov    %eax,%edx
  8037d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d3:	01 d0                	add    %edx,%eax
  8037d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8037d8:	a1 50 50 80 00       	mov    0x805050,%eax
  8037dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8037e0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8037e4:	75 68                	jne    80384e <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8037e6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037ea:	75 17                	jne    803803 <realloc_block_FF+0x288>
  8037ec:	83 ec 04             	sub    $0x4,%esp
  8037ef:	68 6c 4c 80 00       	push   $0x804c6c
  8037f4:	68 08 02 00 00       	push   $0x208
  8037f9:	68 51 4c 80 00       	push   $0x804c51
  8037fe:	e8 5e d2 ff ff       	call   800a61 <_panic>
  803803:	8b 15 44 50 80 00    	mov    0x805044,%edx
  803809:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80380c:	89 10                	mov    %edx,(%eax)
  80380e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803811:	8b 00                	mov    (%eax),%eax
  803813:	85 c0                	test   %eax,%eax
  803815:	74 0d                	je     803824 <realloc_block_FF+0x2a9>
  803817:	a1 44 50 80 00       	mov    0x805044,%eax
  80381c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80381f:	89 50 04             	mov    %edx,0x4(%eax)
  803822:	eb 08                	jmp    80382c <realloc_block_FF+0x2b1>
  803824:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803827:	a3 48 50 80 00       	mov    %eax,0x805048
  80382c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80382f:	a3 44 50 80 00       	mov    %eax,0x805044
  803834:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803837:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383e:	a1 50 50 80 00       	mov    0x805050,%eax
  803843:	40                   	inc    %eax
  803844:	a3 50 50 80 00       	mov    %eax,0x805050
  803849:	e9 b0 01 00 00       	jmp    8039fe <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80384e:	a1 44 50 80 00       	mov    0x805044,%eax
  803853:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803856:	76 68                	jbe    8038c0 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803858:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80385c:	75 17                	jne    803875 <realloc_block_FF+0x2fa>
  80385e:	83 ec 04             	sub    $0x4,%esp
  803861:	68 6c 4c 80 00       	push   $0x804c6c
  803866:	68 0d 02 00 00       	push   $0x20d
  80386b:	68 51 4c 80 00       	push   $0x804c51
  803870:	e8 ec d1 ff ff       	call   800a61 <_panic>
  803875:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80387b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80387e:	89 10                	mov    %edx,(%eax)
  803880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803883:	8b 00                	mov    (%eax),%eax
  803885:	85 c0                	test   %eax,%eax
  803887:	74 0d                	je     803896 <realloc_block_FF+0x31b>
  803889:	a1 44 50 80 00       	mov    0x805044,%eax
  80388e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803891:	89 50 04             	mov    %edx,0x4(%eax)
  803894:	eb 08                	jmp    80389e <realloc_block_FF+0x323>
  803896:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803899:	a3 48 50 80 00       	mov    %eax,0x805048
  80389e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a1:	a3 44 50 80 00       	mov    %eax,0x805044
  8038a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8038b5:	40                   	inc    %eax
  8038b6:	a3 50 50 80 00       	mov    %eax,0x805050
  8038bb:	e9 3e 01 00 00       	jmp    8039fe <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8038c0:	a1 44 50 80 00       	mov    0x805044,%eax
  8038c5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8038c8:	73 68                	jae    803932 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8038ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038ce:	75 17                	jne    8038e7 <realloc_block_FF+0x36c>
  8038d0:	83 ec 04             	sub    $0x4,%esp
  8038d3:	68 a0 4c 80 00       	push   $0x804ca0
  8038d8:	68 12 02 00 00       	push   $0x212
  8038dd:	68 51 4c 80 00       	push   $0x804c51
  8038e2:	e8 7a d1 ff ff       	call   800a61 <_panic>
  8038e7:	8b 15 48 50 80 00    	mov    0x805048,%edx
  8038ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038f0:	89 50 04             	mov    %edx,0x4(%eax)
  8038f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038f6:	8b 40 04             	mov    0x4(%eax),%eax
  8038f9:	85 c0                	test   %eax,%eax
  8038fb:	74 0c                	je     803909 <realloc_block_FF+0x38e>
  8038fd:	a1 48 50 80 00       	mov    0x805048,%eax
  803902:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803905:	89 10                	mov    %edx,(%eax)
  803907:	eb 08                	jmp    803911 <realloc_block_FF+0x396>
  803909:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80390c:	a3 44 50 80 00       	mov    %eax,0x805044
  803911:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803914:	a3 48 50 80 00       	mov    %eax,0x805048
  803919:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80391c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803922:	a1 50 50 80 00       	mov    0x805050,%eax
  803927:	40                   	inc    %eax
  803928:	a3 50 50 80 00       	mov    %eax,0x805050
  80392d:	e9 cc 00 00 00       	jmp    8039fe <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803932:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803939:	a1 44 50 80 00       	mov    0x805044,%eax
  80393e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803941:	e9 8a 00 00 00       	jmp    8039d0 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803949:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80394c:	73 7a                	jae    8039c8 <realloc_block_FF+0x44d>
  80394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803951:	8b 00                	mov    (%eax),%eax
  803953:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803956:	73 70                	jae    8039c8 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80395c:	74 06                	je     803964 <realloc_block_FF+0x3e9>
  80395e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803962:	75 17                	jne    80397b <realloc_block_FF+0x400>
  803964:	83 ec 04             	sub    $0x4,%esp
  803967:	68 c4 4c 80 00       	push   $0x804cc4
  80396c:	68 1c 02 00 00       	push   $0x21c
  803971:	68 51 4c 80 00       	push   $0x804c51
  803976:	e8 e6 d0 ff ff       	call   800a61 <_panic>
  80397b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397e:	8b 10                	mov    (%eax),%edx
  803980:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803983:	89 10                	mov    %edx,(%eax)
  803985:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803988:	8b 00                	mov    (%eax),%eax
  80398a:	85 c0                	test   %eax,%eax
  80398c:	74 0b                	je     803999 <realloc_block_FF+0x41e>
  80398e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803991:	8b 00                	mov    (%eax),%eax
  803993:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803996:	89 50 04             	mov    %edx,0x4(%eax)
  803999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80399f:	89 10                	mov    %edx,(%eax)
  8039a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039a7:	89 50 04             	mov    %edx,0x4(%eax)
  8039aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ad:	8b 00                	mov    (%eax),%eax
  8039af:	85 c0                	test   %eax,%eax
  8039b1:	75 08                	jne    8039bb <realloc_block_FF+0x440>
  8039b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039b6:	a3 48 50 80 00       	mov    %eax,0x805048
  8039bb:	a1 50 50 80 00       	mov    0x805050,%eax
  8039c0:	40                   	inc    %eax
  8039c1:	a3 50 50 80 00       	mov    %eax,0x805050
							break;
  8039c6:	eb 36                	jmp    8039fe <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8039c8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8039cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039d4:	74 07                	je     8039dd <realloc_block_FF+0x462>
  8039d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d9:	8b 00                	mov    (%eax),%eax
  8039db:	eb 05                	jmp    8039e2 <realloc_block_FF+0x467>
  8039dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e2:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8039e7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8039ec:	85 c0                	test   %eax,%eax
  8039ee:	0f 85 52 ff ff ff    	jne    803946 <realloc_block_FF+0x3cb>
  8039f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039f8:	0f 85 48 ff ff ff    	jne    803946 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8039fe:	83 ec 04             	sub    $0x4,%esp
  803a01:	6a 00                	push   $0x0
  803a03:	ff 75 d8             	pushl  -0x28(%ebp)
  803a06:	ff 75 d4             	pushl  -0x2c(%ebp)
  803a09:	e8 7a eb ff ff       	call   802588 <set_block_data>
  803a0e:	83 c4 10             	add    $0x10,%esp
				return va;
  803a11:	8b 45 08             	mov    0x8(%ebp),%eax
  803a14:	e9 7b 02 00 00       	jmp    803c94 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803a19:	83 ec 0c             	sub    $0xc,%esp
  803a1c:	68 41 4d 80 00       	push   $0x804d41
  803a21:	e8 f8 d2 ff ff       	call   800d1e <cprintf>
  803a26:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803a29:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2c:	e9 63 02 00 00       	jmp    803c94 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a34:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a37:	0f 86 4d 02 00 00    	jbe    803c8a <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803a3d:	83 ec 0c             	sub    $0xc,%esp
  803a40:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a43:	e8 dc e7 ff ff       	call   802224 <is_free_block>
  803a48:	83 c4 10             	add    $0x10,%esp
  803a4b:	84 c0                	test   %al,%al
  803a4d:	0f 84 37 02 00 00    	je     803c8a <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a56:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803a59:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803a5c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a5f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803a62:	76 38                	jbe    803a9c <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803a64:	83 ec 0c             	sub    $0xc,%esp
  803a67:	ff 75 08             	pushl  0x8(%ebp)
  803a6a:	e8 0c fa ff ff       	call   80347b <free_block>
  803a6f:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803a72:	83 ec 0c             	sub    $0xc,%esp
  803a75:	ff 75 0c             	pushl  0xc(%ebp)
  803a78:	e8 3a eb ff ff       	call   8025b7 <alloc_block_FF>
  803a7d:	83 c4 10             	add    $0x10,%esp
  803a80:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803a83:	83 ec 08             	sub    $0x8,%esp
  803a86:	ff 75 c0             	pushl  -0x40(%ebp)
  803a89:	ff 75 08             	pushl  0x8(%ebp)
  803a8c:	e8 ab fa ff ff       	call   80353c <copy_data>
  803a91:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803a94:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a97:	e9 f8 01 00 00       	jmp    803c94 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a9f:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803aa2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803aa5:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803aa9:	0f 87 a0 00 00 00    	ja     803b4f <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803aaf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ab3:	75 17                	jne    803acc <realloc_block_FF+0x551>
  803ab5:	83 ec 04             	sub    $0x4,%esp
  803ab8:	68 33 4c 80 00       	push   $0x804c33
  803abd:	68 3a 02 00 00       	push   $0x23a
  803ac2:	68 51 4c 80 00       	push   $0x804c51
  803ac7:	e8 95 cf ff ff       	call   800a61 <_panic>
  803acc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acf:	8b 00                	mov    (%eax),%eax
  803ad1:	85 c0                	test   %eax,%eax
  803ad3:	74 10                	je     803ae5 <realloc_block_FF+0x56a>
  803ad5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad8:	8b 00                	mov    (%eax),%eax
  803ada:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803add:	8b 52 04             	mov    0x4(%edx),%edx
  803ae0:	89 50 04             	mov    %edx,0x4(%eax)
  803ae3:	eb 0b                	jmp    803af0 <realloc_block_FF+0x575>
  803ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae8:	8b 40 04             	mov    0x4(%eax),%eax
  803aeb:	a3 48 50 80 00       	mov    %eax,0x805048
  803af0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af3:	8b 40 04             	mov    0x4(%eax),%eax
  803af6:	85 c0                	test   %eax,%eax
  803af8:	74 0f                	je     803b09 <realloc_block_FF+0x58e>
  803afa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afd:	8b 40 04             	mov    0x4(%eax),%eax
  803b00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b03:	8b 12                	mov    (%edx),%edx
  803b05:	89 10                	mov    %edx,(%eax)
  803b07:	eb 0a                	jmp    803b13 <realloc_block_FF+0x598>
  803b09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0c:	8b 00                	mov    (%eax),%eax
  803b0e:	a3 44 50 80 00       	mov    %eax,0x805044
  803b13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b26:	a1 50 50 80 00       	mov    0x805050,%eax
  803b2b:	48                   	dec    %eax
  803b2c:	a3 50 50 80 00       	mov    %eax,0x805050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803b31:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b37:	01 d0                	add    %edx,%eax
  803b39:	83 ec 04             	sub    $0x4,%esp
  803b3c:	6a 01                	push   $0x1
  803b3e:	50                   	push   %eax
  803b3f:	ff 75 08             	pushl  0x8(%ebp)
  803b42:	e8 41 ea ff ff       	call   802588 <set_block_data>
  803b47:	83 c4 10             	add    $0x10,%esp
  803b4a:	e9 36 01 00 00       	jmp    803c85 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b52:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b55:	01 d0                	add    %edx,%eax
  803b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803b5a:	83 ec 04             	sub    $0x4,%esp
  803b5d:	6a 01                	push   $0x1
  803b5f:	ff 75 f0             	pushl  -0x10(%ebp)
  803b62:	ff 75 08             	pushl  0x8(%ebp)
  803b65:	e8 1e ea ff ff       	call   802588 <set_block_data>
  803b6a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b70:	83 e8 04             	sub    $0x4,%eax
  803b73:	8b 00                	mov    (%eax),%eax
  803b75:	83 e0 fe             	and    $0xfffffffe,%eax
  803b78:	89 c2                	mov    %eax,%edx
  803b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7d:	01 d0                	add    %edx,%eax
  803b7f:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b86:	74 06                	je     803b8e <realloc_block_FF+0x613>
  803b88:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803b8c:	75 17                	jne    803ba5 <realloc_block_FF+0x62a>
  803b8e:	83 ec 04             	sub    $0x4,%esp
  803b91:	68 c4 4c 80 00       	push   $0x804cc4
  803b96:	68 46 02 00 00       	push   $0x246
  803b9b:	68 51 4c 80 00       	push   $0x804c51
  803ba0:	e8 bc ce ff ff       	call   800a61 <_panic>
  803ba5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba8:	8b 10                	mov    (%eax),%edx
  803baa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bad:	89 10                	mov    %edx,(%eax)
  803baf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bb2:	8b 00                	mov    (%eax),%eax
  803bb4:	85 c0                	test   %eax,%eax
  803bb6:	74 0b                	je     803bc3 <realloc_block_FF+0x648>
  803bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bbb:	8b 00                	mov    (%eax),%eax
  803bbd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803bc0:	89 50 04             	mov    %edx,0x4(%eax)
  803bc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803bc9:	89 10                	mov    %edx,(%eax)
  803bcb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bd1:	89 50 04             	mov    %edx,0x4(%eax)
  803bd4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bd7:	8b 00                	mov    (%eax),%eax
  803bd9:	85 c0                	test   %eax,%eax
  803bdb:	75 08                	jne    803be5 <realloc_block_FF+0x66a>
  803bdd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803be0:	a3 48 50 80 00       	mov    %eax,0x805048
  803be5:	a1 50 50 80 00       	mov    0x805050,%eax
  803bea:	40                   	inc    %eax
  803beb:	a3 50 50 80 00       	mov    %eax,0x805050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803bf0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bf4:	75 17                	jne    803c0d <realloc_block_FF+0x692>
  803bf6:	83 ec 04             	sub    $0x4,%esp
  803bf9:	68 33 4c 80 00       	push   $0x804c33
  803bfe:	68 47 02 00 00       	push   $0x247
  803c03:	68 51 4c 80 00       	push   $0x804c51
  803c08:	e8 54 ce ff ff       	call   800a61 <_panic>
  803c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c10:	8b 00                	mov    (%eax),%eax
  803c12:	85 c0                	test   %eax,%eax
  803c14:	74 10                	je     803c26 <realloc_block_FF+0x6ab>
  803c16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c19:	8b 00                	mov    (%eax),%eax
  803c1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c1e:	8b 52 04             	mov    0x4(%edx),%edx
  803c21:	89 50 04             	mov    %edx,0x4(%eax)
  803c24:	eb 0b                	jmp    803c31 <realloc_block_FF+0x6b6>
  803c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c29:	8b 40 04             	mov    0x4(%eax),%eax
  803c2c:	a3 48 50 80 00       	mov    %eax,0x805048
  803c31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c34:	8b 40 04             	mov    0x4(%eax),%eax
  803c37:	85 c0                	test   %eax,%eax
  803c39:	74 0f                	je     803c4a <realloc_block_FF+0x6cf>
  803c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3e:	8b 40 04             	mov    0x4(%eax),%eax
  803c41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c44:	8b 12                	mov    (%edx),%edx
  803c46:	89 10                	mov    %edx,(%eax)
  803c48:	eb 0a                	jmp    803c54 <realloc_block_FF+0x6d9>
  803c4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4d:	8b 00                	mov    (%eax),%eax
  803c4f:	a3 44 50 80 00       	mov    %eax,0x805044
  803c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c67:	a1 50 50 80 00       	mov    0x805050,%eax
  803c6c:	48                   	dec    %eax
  803c6d:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(next_new_va, remaining_size, 0);
  803c72:	83 ec 04             	sub    $0x4,%esp
  803c75:	6a 00                	push   $0x0
  803c77:	ff 75 bc             	pushl  -0x44(%ebp)
  803c7a:	ff 75 b8             	pushl  -0x48(%ebp)
  803c7d:	e8 06 e9 ff ff       	call   802588 <set_block_data>
  803c82:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803c85:	8b 45 08             	mov    0x8(%ebp),%eax
  803c88:	eb 0a                	jmp    803c94 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803c8a:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803c91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803c94:	c9                   	leave  
  803c95:	c3                   	ret    

00803c96 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803c96:	55                   	push   %ebp
  803c97:	89 e5                	mov    %esp,%ebp
  803c99:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803c9c:	83 ec 04             	sub    $0x4,%esp
  803c9f:	68 48 4d 80 00       	push   $0x804d48
  803ca4:	68 5a 02 00 00       	push   $0x25a
  803ca9:	68 51 4c 80 00       	push   $0x804c51
  803cae:	e8 ae cd ff ff       	call   800a61 <_panic>

00803cb3 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803cb3:	55                   	push   %ebp
  803cb4:	89 e5                	mov    %esp,%ebp
  803cb6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803cb9:	83 ec 04             	sub    $0x4,%esp
  803cbc:	68 70 4d 80 00       	push   $0x804d70
  803cc1:	68 63 02 00 00       	push   $0x263
  803cc6:	68 51 4c 80 00       	push   $0x804c51
  803ccb:	e8 91 cd ff ff       	call   800a61 <_panic>

00803cd0 <__udivdi3>:
  803cd0:	55                   	push   %ebp
  803cd1:	57                   	push   %edi
  803cd2:	56                   	push   %esi
  803cd3:	53                   	push   %ebx
  803cd4:	83 ec 1c             	sub    $0x1c,%esp
  803cd7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cdb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ce3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ce7:	89 ca                	mov    %ecx,%edx
  803ce9:	89 f8                	mov    %edi,%eax
  803ceb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803cef:	85 f6                	test   %esi,%esi
  803cf1:	75 2d                	jne    803d20 <__udivdi3+0x50>
  803cf3:	39 cf                	cmp    %ecx,%edi
  803cf5:	77 65                	ja     803d5c <__udivdi3+0x8c>
  803cf7:	89 fd                	mov    %edi,%ebp
  803cf9:	85 ff                	test   %edi,%edi
  803cfb:	75 0b                	jne    803d08 <__udivdi3+0x38>
  803cfd:	b8 01 00 00 00       	mov    $0x1,%eax
  803d02:	31 d2                	xor    %edx,%edx
  803d04:	f7 f7                	div    %edi
  803d06:	89 c5                	mov    %eax,%ebp
  803d08:	31 d2                	xor    %edx,%edx
  803d0a:	89 c8                	mov    %ecx,%eax
  803d0c:	f7 f5                	div    %ebp
  803d0e:	89 c1                	mov    %eax,%ecx
  803d10:	89 d8                	mov    %ebx,%eax
  803d12:	f7 f5                	div    %ebp
  803d14:	89 cf                	mov    %ecx,%edi
  803d16:	89 fa                	mov    %edi,%edx
  803d18:	83 c4 1c             	add    $0x1c,%esp
  803d1b:	5b                   	pop    %ebx
  803d1c:	5e                   	pop    %esi
  803d1d:	5f                   	pop    %edi
  803d1e:	5d                   	pop    %ebp
  803d1f:	c3                   	ret    
  803d20:	39 ce                	cmp    %ecx,%esi
  803d22:	77 28                	ja     803d4c <__udivdi3+0x7c>
  803d24:	0f bd fe             	bsr    %esi,%edi
  803d27:	83 f7 1f             	xor    $0x1f,%edi
  803d2a:	75 40                	jne    803d6c <__udivdi3+0x9c>
  803d2c:	39 ce                	cmp    %ecx,%esi
  803d2e:	72 0a                	jb     803d3a <__udivdi3+0x6a>
  803d30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d34:	0f 87 9e 00 00 00    	ja     803dd8 <__udivdi3+0x108>
  803d3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d3f:	89 fa                	mov    %edi,%edx
  803d41:	83 c4 1c             	add    $0x1c,%esp
  803d44:	5b                   	pop    %ebx
  803d45:	5e                   	pop    %esi
  803d46:	5f                   	pop    %edi
  803d47:	5d                   	pop    %ebp
  803d48:	c3                   	ret    
  803d49:	8d 76 00             	lea    0x0(%esi),%esi
  803d4c:	31 ff                	xor    %edi,%edi
  803d4e:	31 c0                	xor    %eax,%eax
  803d50:	89 fa                	mov    %edi,%edx
  803d52:	83 c4 1c             	add    $0x1c,%esp
  803d55:	5b                   	pop    %ebx
  803d56:	5e                   	pop    %esi
  803d57:	5f                   	pop    %edi
  803d58:	5d                   	pop    %ebp
  803d59:	c3                   	ret    
  803d5a:	66 90                	xchg   %ax,%ax
  803d5c:	89 d8                	mov    %ebx,%eax
  803d5e:	f7 f7                	div    %edi
  803d60:	31 ff                	xor    %edi,%edi
  803d62:	89 fa                	mov    %edi,%edx
  803d64:	83 c4 1c             	add    $0x1c,%esp
  803d67:	5b                   	pop    %ebx
  803d68:	5e                   	pop    %esi
  803d69:	5f                   	pop    %edi
  803d6a:	5d                   	pop    %ebp
  803d6b:	c3                   	ret    
  803d6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d71:	89 eb                	mov    %ebp,%ebx
  803d73:	29 fb                	sub    %edi,%ebx
  803d75:	89 f9                	mov    %edi,%ecx
  803d77:	d3 e6                	shl    %cl,%esi
  803d79:	89 c5                	mov    %eax,%ebp
  803d7b:	88 d9                	mov    %bl,%cl
  803d7d:	d3 ed                	shr    %cl,%ebp
  803d7f:	89 e9                	mov    %ebp,%ecx
  803d81:	09 f1                	or     %esi,%ecx
  803d83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d87:	89 f9                	mov    %edi,%ecx
  803d89:	d3 e0                	shl    %cl,%eax
  803d8b:	89 c5                	mov    %eax,%ebp
  803d8d:	89 d6                	mov    %edx,%esi
  803d8f:	88 d9                	mov    %bl,%cl
  803d91:	d3 ee                	shr    %cl,%esi
  803d93:	89 f9                	mov    %edi,%ecx
  803d95:	d3 e2                	shl    %cl,%edx
  803d97:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d9b:	88 d9                	mov    %bl,%cl
  803d9d:	d3 e8                	shr    %cl,%eax
  803d9f:	09 c2                	or     %eax,%edx
  803da1:	89 d0                	mov    %edx,%eax
  803da3:	89 f2                	mov    %esi,%edx
  803da5:	f7 74 24 0c          	divl   0xc(%esp)
  803da9:	89 d6                	mov    %edx,%esi
  803dab:	89 c3                	mov    %eax,%ebx
  803dad:	f7 e5                	mul    %ebp
  803daf:	39 d6                	cmp    %edx,%esi
  803db1:	72 19                	jb     803dcc <__udivdi3+0xfc>
  803db3:	74 0b                	je     803dc0 <__udivdi3+0xf0>
  803db5:	89 d8                	mov    %ebx,%eax
  803db7:	31 ff                	xor    %edi,%edi
  803db9:	e9 58 ff ff ff       	jmp    803d16 <__udivdi3+0x46>
  803dbe:	66 90                	xchg   %ax,%ax
  803dc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803dc4:	89 f9                	mov    %edi,%ecx
  803dc6:	d3 e2                	shl    %cl,%edx
  803dc8:	39 c2                	cmp    %eax,%edx
  803dca:	73 e9                	jae    803db5 <__udivdi3+0xe5>
  803dcc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803dcf:	31 ff                	xor    %edi,%edi
  803dd1:	e9 40 ff ff ff       	jmp    803d16 <__udivdi3+0x46>
  803dd6:	66 90                	xchg   %ax,%ax
  803dd8:	31 c0                	xor    %eax,%eax
  803dda:	e9 37 ff ff ff       	jmp    803d16 <__udivdi3+0x46>
  803ddf:	90                   	nop

00803de0 <__umoddi3>:
  803de0:	55                   	push   %ebp
  803de1:	57                   	push   %edi
  803de2:	56                   	push   %esi
  803de3:	53                   	push   %ebx
  803de4:	83 ec 1c             	sub    $0x1c,%esp
  803de7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803deb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803def:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803df3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803df7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dff:	89 f3                	mov    %esi,%ebx
  803e01:	89 fa                	mov    %edi,%edx
  803e03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e07:	89 34 24             	mov    %esi,(%esp)
  803e0a:	85 c0                	test   %eax,%eax
  803e0c:	75 1a                	jne    803e28 <__umoddi3+0x48>
  803e0e:	39 f7                	cmp    %esi,%edi
  803e10:	0f 86 a2 00 00 00    	jbe    803eb8 <__umoddi3+0xd8>
  803e16:	89 c8                	mov    %ecx,%eax
  803e18:	89 f2                	mov    %esi,%edx
  803e1a:	f7 f7                	div    %edi
  803e1c:	89 d0                	mov    %edx,%eax
  803e1e:	31 d2                	xor    %edx,%edx
  803e20:	83 c4 1c             	add    $0x1c,%esp
  803e23:	5b                   	pop    %ebx
  803e24:	5e                   	pop    %esi
  803e25:	5f                   	pop    %edi
  803e26:	5d                   	pop    %ebp
  803e27:	c3                   	ret    
  803e28:	39 f0                	cmp    %esi,%eax
  803e2a:	0f 87 ac 00 00 00    	ja     803edc <__umoddi3+0xfc>
  803e30:	0f bd e8             	bsr    %eax,%ebp
  803e33:	83 f5 1f             	xor    $0x1f,%ebp
  803e36:	0f 84 ac 00 00 00    	je     803ee8 <__umoddi3+0x108>
  803e3c:	bf 20 00 00 00       	mov    $0x20,%edi
  803e41:	29 ef                	sub    %ebp,%edi
  803e43:	89 fe                	mov    %edi,%esi
  803e45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e49:	89 e9                	mov    %ebp,%ecx
  803e4b:	d3 e0                	shl    %cl,%eax
  803e4d:	89 d7                	mov    %edx,%edi
  803e4f:	89 f1                	mov    %esi,%ecx
  803e51:	d3 ef                	shr    %cl,%edi
  803e53:	09 c7                	or     %eax,%edi
  803e55:	89 e9                	mov    %ebp,%ecx
  803e57:	d3 e2                	shl    %cl,%edx
  803e59:	89 14 24             	mov    %edx,(%esp)
  803e5c:	89 d8                	mov    %ebx,%eax
  803e5e:	d3 e0                	shl    %cl,%eax
  803e60:	89 c2                	mov    %eax,%edx
  803e62:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e66:	d3 e0                	shl    %cl,%eax
  803e68:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e70:	89 f1                	mov    %esi,%ecx
  803e72:	d3 e8                	shr    %cl,%eax
  803e74:	09 d0                	or     %edx,%eax
  803e76:	d3 eb                	shr    %cl,%ebx
  803e78:	89 da                	mov    %ebx,%edx
  803e7a:	f7 f7                	div    %edi
  803e7c:	89 d3                	mov    %edx,%ebx
  803e7e:	f7 24 24             	mull   (%esp)
  803e81:	89 c6                	mov    %eax,%esi
  803e83:	89 d1                	mov    %edx,%ecx
  803e85:	39 d3                	cmp    %edx,%ebx
  803e87:	0f 82 87 00 00 00    	jb     803f14 <__umoddi3+0x134>
  803e8d:	0f 84 91 00 00 00    	je     803f24 <__umoddi3+0x144>
  803e93:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e97:	29 f2                	sub    %esi,%edx
  803e99:	19 cb                	sbb    %ecx,%ebx
  803e9b:	89 d8                	mov    %ebx,%eax
  803e9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ea1:	d3 e0                	shl    %cl,%eax
  803ea3:	89 e9                	mov    %ebp,%ecx
  803ea5:	d3 ea                	shr    %cl,%edx
  803ea7:	09 d0                	or     %edx,%eax
  803ea9:	89 e9                	mov    %ebp,%ecx
  803eab:	d3 eb                	shr    %cl,%ebx
  803ead:	89 da                	mov    %ebx,%edx
  803eaf:	83 c4 1c             	add    $0x1c,%esp
  803eb2:	5b                   	pop    %ebx
  803eb3:	5e                   	pop    %esi
  803eb4:	5f                   	pop    %edi
  803eb5:	5d                   	pop    %ebp
  803eb6:	c3                   	ret    
  803eb7:	90                   	nop
  803eb8:	89 fd                	mov    %edi,%ebp
  803eba:	85 ff                	test   %edi,%edi
  803ebc:	75 0b                	jne    803ec9 <__umoddi3+0xe9>
  803ebe:	b8 01 00 00 00       	mov    $0x1,%eax
  803ec3:	31 d2                	xor    %edx,%edx
  803ec5:	f7 f7                	div    %edi
  803ec7:	89 c5                	mov    %eax,%ebp
  803ec9:	89 f0                	mov    %esi,%eax
  803ecb:	31 d2                	xor    %edx,%edx
  803ecd:	f7 f5                	div    %ebp
  803ecf:	89 c8                	mov    %ecx,%eax
  803ed1:	f7 f5                	div    %ebp
  803ed3:	89 d0                	mov    %edx,%eax
  803ed5:	e9 44 ff ff ff       	jmp    803e1e <__umoddi3+0x3e>
  803eda:	66 90                	xchg   %ax,%ax
  803edc:	89 c8                	mov    %ecx,%eax
  803ede:	89 f2                	mov    %esi,%edx
  803ee0:	83 c4 1c             	add    $0x1c,%esp
  803ee3:	5b                   	pop    %ebx
  803ee4:	5e                   	pop    %esi
  803ee5:	5f                   	pop    %edi
  803ee6:	5d                   	pop    %ebp
  803ee7:	c3                   	ret    
  803ee8:	3b 04 24             	cmp    (%esp),%eax
  803eeb:	72 06                	jb     803ef3 <__umoddi3+0x113>
  803eed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ef1:	77 0f                	ja     803f02 <__umoddi3+0x122>
  803ef3:	89 f2                	mov    %esi,%edx
  803ef5:	29 f9                	sub    %edi,%ecx
  803ef7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803efb:	89 14 24             	mov    %edx,(%esp)
  803efe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f02:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f06:	8b 14 24             	mov    (%esp),%edx
  803f09:	83 c4 1c             	add    $0x1c,%esp
  803f0c:	5b                   	pop    %ebx
  803f0d:	5e                   	pop    %esi
  803f0e:	5f                   	pop    %edi
  803f0f:	5d                   	pop    %ebp
  803f10:	c3                   	ret    
  803f11:	8d 76 00             	lea    0x0(%esi),%esi
  803f14:	2b 04 24             	sub    (%esp),%eax
  803f17:	19 fa                	sbb    %edi,%edx
  803f19:	89 d1                	mov    %edx,%ecx
  803f1b:	89 c6                	mov    %eax,%esi
  803f1d:	e9 71 ff ff ff       	jmp    803e93 <__umoddi3+0xb3>
  803f22:	66 90                	xchg   %ax,%ax
  803f24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f28:	72 ea                	jb     803f14 <__umoddi3+0x134>
  803f2a:	89 d9                	mov    %ebx,%ecx
  803f2c:	e9 62 ff ff ff       	jmp    803e93 <__umoddi3+0xb3>
