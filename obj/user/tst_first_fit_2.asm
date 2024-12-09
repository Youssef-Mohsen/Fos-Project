
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
  800055:	68 a0 43 80 00       	push   $0x8043a0
  80005a:	e8 c7 0c 00 00       	call   800d26 <cprintf>
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
  8000a5:	68 d0 43 80 00       	push   $0x8043d0
  8000aa:	e8 77 0c 00 00       	call   800d26 <cprintf>
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
  8000d1:	e8 3b 24 00 00       	call   802511 <sys_set_uheap_strategy>
  8000d6:	83 c4 10             	add    $0x10,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  8000d9:	a1 20 60 80 00       	mov    0x806020,%eax
  8000de:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  8000e4:	a1 20 60 80 00       	mov    0x806020,%eax
  8000e9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000ef:	39 c2                	cmp    %eax,%edx
  8000f1:	72 14                	jb     800107 <_main+0x47>
			panic("Please increase the WS size");
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	68 09 44 80 00       	push   $0x804409
  8000fb:	6a 26                	push   $0x26
  8000fd:	68 25 44 80 00       	push   $0x804425
  800102:	e8 62 09 00 00       	call   800a69 <_panic>
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
  800123:	e8 36 20 00 00       	call   80215e <sys_pf_calculate_allocated_pages>
  800128:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 e3 1f 00 00       	call   802113 <sys_calculate_free_frames>
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
  80013d:	68 3c 44 80 00       	push   $0x80443c
  800142:	e8 df 0b 00 00       	call   800d26 <cprintf>
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
  800173:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
  80017a:	83 e8 08             	sub    $0x8,%eax
  80017d:	89 45 a8             	mov    %eax,-0x58(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	ff 75 a8             	pushl  -0x58(%ebp)
  800186:	e8 4b 19 00 00       	call   801ad6 <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 c2                	mov    %eax,%edx
  800190:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800193:	89 14 85 60 60 80 00 	mov    %edx,0x806060(,%eax,4)
  80019a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80019d:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  8001a4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  8001a7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001aa:	d1 e8                	shr    %eax
  8001ac:	89 c2                	mov    %eax,%edx
  8001ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001b1:	01 c2                	add    %eax,%edx
  8001b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b6:	89 14 85 60 8c 80 00 	mov    %edx,0x808c60(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  8001bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001c0:	8d 50 fe             	lea    -0x2(%eax),%edx
  8001c3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001c6:	01 c2                	add    %eax,%edx
  8001c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cb:	89 14 85 60 76 80 00 	mov    %edx,0x807660(,%eax,4)
				//Check returned va
				expectedVA = (curVA + sizeOfMetaData/2);
  8001d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001d5:	83 c0 04             	add    $0x4,%eax
  8001d8:	89 45 a0             	mov    %eax,-0x60(%ebp)
				expectedSize = allocSizes[i];
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
  8001e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
				curTotalSize += allocSizes[i] ;
  8001e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001eb:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
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
  800275:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
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
  8002ac:	68 94 44 80 00       	push   $0x804494
  8002b1:	6a 69                	push   $0x69
  8002b3:	68 25 44 80 00       	push   $0x804425
  8002b8:	e8 ac 07 00 00       	call   800a69 <_panic>
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
  800328:	68 bc 44 80 00       	push   $0x8044bc
  80032d:	e8 f4 09 00 00       	call   800d26 <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800335:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80033b:	83 e8 08             	sub    $0x8,%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	6a 01                	push   $0x1
  800343:	50                   	push   %eax
  800344:	e8 a6 23 00 00       	call   8026ef <alloc_block>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	89 c2                	mov    %eax,%edx
  80034e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800351:	89 14 85 60 60 80 00 	mov    %edx,0x806060(,%eax,4)
  800358:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80035b:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
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
  800392:	68 e0 44 80 00       	push   $0x8044e0
  800397:	68 80 00 00 00       	push   $0x80
  80039c:	68 25 44 80 00       	push   $0x804425
  8003a1:	e8 c3 06 00 00       	call   800a69 <_panic>
		}
	}

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 08 45 80 00       	push   $0x804508
  8003ae:	e8 73 09 00 00       	call   800d26 <cprintf>
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
  8003df:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  8003e6:	83 ec 0c             	sub    $0xc,%esp
  8003e9:	50                   	push   %eax
  8003ea:	e8 06 19 00 00       	call   801cf5 <free>
  8003ef:	83 c4 10             	add    $0x10,%esp
			if (check_block(startVAs[i*allocCntPerSize], startVAs[i*allocCntPerSize], allocSizes[i], 0) == 0)
  8003f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003f5:	8b 0c 85 00 60 80 00 	mov    0x806000(,%eax,4),%ecx
  8003fc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003ff:	89 d0                	mov    %edx,%eax
  800401:	c1 e0 02             	shl    $0x2,%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	01 d0                	add    %edx,%eax
  80040f:	c1 e0 03             	shl    $0x3,%eax
  800412:	8b 14 85 60 60 80 00 	mov    0x806060(,%eax,4),%edx
  800419:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80041c:	89 d8                	mov    %ebx,%eax
  80041e:	c1 e0 02             	shl    $0x2,%eax
  800421:	01 d8                	add    %ebx,%eax
  800423:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  80042a:	01 d8                	add    %ebx,%eax
  80042c:	c1 e0 03             	shl    $0x3,%eax
  80042f:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
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
  800451:	68 50 45 80 00       	push   $0x804550
  800456:	e8 cb 08 00 00       	call   800d26 <cprintf>
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
  80046e:	68 70 45 80 00       	push   $0x804570
  800473:	e8 ae 08 00 00       	call   800d26 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp

	uint32 testSizes[numOfFFTests] =
  80047b:	8d 85 2c ff ff ff    	lea    -0xd4(%ebp),%eax
  800481:	bb 34 49 80 00       	mov    $0x804934,%ebx
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
  80049d:	a1 00 60 80 00       	mov    0x806000,%eax
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
  8004b2:	a1 60 60 80 00       	mov    0x806060,%eax
  8004b7:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	uint32 startOf4thFreeBlock = (uint32)startVAs[3*allocCntPerSize];
  8004bd:	a1 c0 69 80 00       	mov    0x8069c0,%eax
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
  80051d:	e8 b4 15 00 00       	call   801ad6 <malloc>
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
  8005a7:	68 cc 45 80 00       	push   $0x8045cc
  8005ac:	e8 75 07 00 00       	call   800d26 <cprintf>
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
  80060a:	e8 a9 20 00 00       	call   8026b8 <get_block_size>
  80060f:	83 c4 10             	add    $0x10,%esp
  800612:	89 c2                	mov    %eax,%edx
  800614:	a1 00 60 80 00       	mov    0x806000,%eax
  800619:	39 c2                	cmp    %eax,%edx
  80061b:	74 17                	je     800634 <_main+0x574>
		{
			is_correct = 0;
  80061d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_ff_2 #2.3: WRONG FF ALLOC - make sure if the remaining free space doesn’t fit a dynamic allocator block, then this area should be added to the allocated area and counted as internal fragmentation\n");
  800624:	83 ec 0c             	sub    $0xc,%esp
  800627:	68 fc 45 80 00       	push   $0x8045fc
  80062c:	e8 f5 06 00 00       	call   800d26 <cprintf>
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
  800641:	68 c8 46 80 00       	push   $0x8046c8
  800646:	e8 db 06 00 00       	call   800d26 <cprintf>
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
  80069c:	e8 35 14 00 00       	call   801ad6 <malloc>
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
  800714:	68 14 47 80 00       	push   $0x804714
  800719:	e8 08 06 00 00       	call   800d26 <cprintf>
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
  80074f:	68 40 47 80 00       	push   $0x804740
  800754:	e8 cd 05 00 00       	call   800d26 <cprintf>
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
  800808:	68 74 47 80 00       	push   $0x804774
  80080d:	e8 14 05 00 00       	call   800d26 <cprintf>
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
  800831:	68 d8 47 80 00       	push   $0x8047d8
  800836:	e8 eb 04 00 00       	call   800d26 <cprintf>
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
  800852:	e8 7f 12 00 00       	call   801ad6 <malloc>
  800857:	83 c4 10             	add    $0x10,%esp
  80085a:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//Fill the remaining area
		uint32 numOfRem2KBAllocs = ((USER_HEAP_START + DYN_ALLOC_MAX_SIZE - (uint32)sbrk(0)) / PAGE_SIZE) * 2;
  80085d:	83 ec 0c             	sub    $0xc,%esp
  800860:	6a 00                	push   $0x0
  800862:	e8 59 12 00 00       	call   801ac0 <sbrk>
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
  80088d:	e8 44 12 00 00       	call   801ad6 <malloc>
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
  8008a8:	68 f8 47 80 00       	push   $0x8047f8
  8008ad:	e8 74 04 00 00       	call   800d26 <cprintf>
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
  8008cb:	e8 06 12 00 00       	call   801ad6 <malloc>
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		va = malloc(actualSize);
  8008d6:	83 ec 0c             	sub    $0xc,%esp
  8008d9:	ff 75 a8             	pushl  -0x58(%ebp)
  8008dc:	e8 f5 11 00 00       	call   801ad6 <malloc>
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
  8008f7:	68 68 48 80 00       	push   $0x804868
  8008fc:	e8 25 04 00 00       	call   800d26 <cprintf>
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
  800914:	68 ec 48 80 00       	push   $0x8048ec
  800919:	e8 08 04 00 00       	call   800d26 <cprintf>
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
  800930:	e8 a7 19 00 00       	call   8022dc <sys_getenvindex>
  800935:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800938:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80093b:	89 d0                	mov    %edx,%eax
  80093d:	c1 e0 03             	shl    $0x3,%eax
  800940:	01 d0                	add    %edx,%eax
  800942:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800949:	01 c8                	add    %ecx,%eax
  80094b:	01 c0                	add    %eax,%eax
  80094d:	01 d0                	add    %edx,%eax
  80094f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800956:	01 c8                	add    %ecx,%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80095f:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800964:	a1 20 60 80 00       	mov    0x806020,%eax
  800969:	8a 40 20             	mov    0x20(%eax),%al
  80096c:	84 c0                	test   %al,%al
  80096e:	74 0d                	je     80097d <libmain+0x53>
		binaryname = myEnv->prog_name;
  800970:	a1 20 60 80 00       	mov    0x806020,%eax
  800975:	83 c0 20             	add    $0x20,%eax
  800978:	a3 1c 60 80 00       	mov    %eax,0x80601c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80097d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800981:	7e 0a                	jle    80098d <libmain+0x63>
		binaryname = argv[0];
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	a3 1c 60 80 00       	mov    %eax,0x80601c

	// call user main routine
	_main(argc, argv);
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	ff 75 0c             	pushl  0xc(%ebp)
  800993:	ff 75 08             	pushl  0x8(%ebp)
  800996:	e8 25 f7 ff ff       	call   8000c0 <_main>
  80099b:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80099e:	e8 bd 16 00 00       	call   802060 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8009a3:	83 ec 0c             	sub    $0xc,%esp
  8009a6:	68 58 49 80 00       	push   $0x804958
  8009ab:	e8 76 03 00 00       	call   800d26 <cprintf>
  8009b0:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009b3:	a1 20 60 80 00       	mov    0x806020,%eax
  8009b8:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8009be:	a1 20 60 80 00       	mov    0x806020,%eax
  8009c3:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8009c9:	83 ec 04             	sub    $0x4,%esp
  8009cc:	52                   	push   %edx
  8009cd:	50                   	push   %eax
  8009ce:	68 80 49 80 00       	push   $0x804980
  8009d3:	e8 4e 03 00 00       	call   800d26 <cprintf>
  8009d8:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8009db:	a1 20 60 80 00       	mov    0x806020,%eax
  8009e0:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8009e6:	a1 20 60 80 00       	mov    0x806020,%eax
  8009eb:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8009f1:	a1 20 60 80 00       	mov    0x806020,%eax
  8009f6:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8009fc:	51                   	push   %ecx
  8009fd:	52                   	push   %edx
  8009fe:	50                   	push   %eax
  8009ff:	68 a8 49 80 00       	push   $0x8049a8
  800a04:	e8 1d 03 00 00       	call   800d26 <cprintf>
  800a09:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a0c:	a1 20 60 80 00       	mov    0x806020,%eax
  800a11:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	50                   	push   %eax
  800a1b:	68 00 4a 80 00       	push   $0x804a00
  800a20:	e8 01 03 00 00       	call   800d26 <cprintf>
  800a25:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	68 58 49 80 00       	push   $0x804958
  800a30:	e8 f1 02 00 00       	call   800d26 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800a38:	e8 3d 16 00 00       	call   80207a <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800a3d:	e8 19 00 00 00       	call   800a5b <exit>
}
  800a42:	90                   	nop
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    

00800a45 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a4b:	83 ec 0c             	sub    $0xc,%esp
  800a4e:	6a 00                	push   $0x0
  800a50:	e8 53 18 00 00       	call   8022a8 <sys_destroy_env>
  800a55:	83 c4 10             	add    $0x10,%esp
}
  800a58:	90                   	nop
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    

00800a5b <exit>:

void
exit(void)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a61:	e8 a8 18 00 00       	call   80230e <sys_exit_env>
}
  800a66:	90                   	nop
  800a67:	c9                   	leave  
  800a68:	c3                   	ret    

00800a69 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a6f:	8d 45 10             	lea    0x10(%ebp),%eax
  800a72:	83 c0 04             	add    $0x4,%eax
  800a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a78:	a1 54 a2 80 00       	mov    0x80a254,%eax
  800a7d:	85 c0                	test   %eax,%eax
  800a7f:	74 16                	je     800a97 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a81:	a1 54 a2 80 00       	mov    0x80a254,%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	50                   	push   %eax
  800a8a:	68 14 4a 80 00       	push   $0x804a14
  800a8f:	e8 92 02 00 00       	call   800d26 <cprintf>
  800a94:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a97:	a1 1c 60 80 00       	mov    0x80601c,%eax
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	ff 75 08             	pushl  0x8(%ebp)
  800aa2:	50                   	push   %eax
  800aa3:	68 19 4a 80 00       	push   $0x804a19
  800aa8:	e8 79 02 00 00       	call   800d26 <cprintf>
  800aad:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	50                   	push   %eax
  800aba:	e8 fc 01 00 00       	call   800cbb <vcprintf>
  800abf:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	6a 00                	push   $0x0
  800ac7:	68 35 4a 80 00       	push   $0x804a35
  800acc:	e8 ea 01 00 00       	call   800cbb <vcprintf>
  800ad1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800ad4:	e8 82 ff ff ff       	call   800a5b <exit>

	// should not return here
	while (1) ;
  800ad9:	eb fe                	jmp    800ad9 <_panic+0x70>

00800adb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800ae1:	a1 20 60 80 00       	mov    0x806020,%eax
  800ae6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aef:	39 c2                	cmp    %eax,%edx
  800af1:	74 14                	je     800b07 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800af3:	83 ec 04             	sub    $0x4,%esp
  800af6:	68 38 4a 80 00       	push   $0x804a38
  800afb:	6a 26                	push   $0x26
  800afd:	68 84 4a 80 00       	push   $0x804a84
  800b02:	e8 62 ff ff ff       	call   800a69 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b15:	e9 c5 00 00 00       	jmp    800bdf <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	01 d0                	add    %edx,%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	85 c0                	test   %eax,%eax
  800b2d:	75 08                	jne    800b37 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800b2f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b32:	e9 a5 00 00 00       	jmp    800bdc <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800b37:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b3e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b45:	eb 69                	jmp    800bb0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b47:	a1 20 60 80 00       	mov    0x806020,%eax
  800b4c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800b52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b55:	89 d0                	mov    %edx,%eax
  800b57:	01 c0                	add    %eax,%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	c1 e0 03             	shl    $0x3,%eax
  800b5e:	01 c8                	add    %ecx,%eax
  800b60:	8a 40 04             	mov    0x4(%eax),%al
  800b63:	84 c0                	test   %al,%al
  800b65:	75 46                	jne    800bad <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b67:	a1 20 60 80 00       	mov    0x806020,%eax
  800b6c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800b72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b75:	89 d0                	mov    %edx,%eax
  800b77:	01 c0                	add    %eax,%eax
  800b79:	01 d0                	add    %edx,%eax
  800b7b:	c1 e0 03             	shl    $0x3,%eax
  800b7e:	01 c8                	add    %ecx,%eax
  800b80:	8b 00                	mov    (%eax),%eax
  800b82:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b85:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b8d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b92:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	01 c8                	add    %ecx,%eax
  800b9e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ba0:	39 c2                	cmp    %eax,%edx
  800ba2:	75 09                	jne    800bad <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800ba4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bab:	eb 15                	jmp    800bc2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bad:	ff 45 e8             	incl   -0x18(%ebp)
  800bb0:	a1 20 60 80 00       	mov    0x806020,%eax
  800bb5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800bbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800bbe:	39 c2                	cmp    %eax,%edx
  800bc0:	77 85                	ja     800b47 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800bc2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800bc6:	75 14                	jne    800bdc <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800bc8:	83 ec 04             	sub    $0x4,%esp
  800bcb:	68 90 4a 80 00       	push   $0x804a90
  800bd0:	6a 3a                	push   $0x3a
  800bd2:	68 84 4a 80 00       	push   $0x804a84
  800bd7:	e8 8d fe ff ff       	call   800a69 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800bdc:	ff 45 f0             	incl   -0x10(%ebp)
  800bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800be5:	0f 8c 2f ff ff ff    	jl     800b1a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800beb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bf9:	eb 26                	jmp    800c21 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bfb:	a1 20 60 80 00       	mov    0x806020,%eax
  800c00:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800c06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c09:	89 d0                	mov    %edx,%eax
  800c0b:	01 c0                	add    %eax,%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	c1 e0 03             	shl    $0x3,%eax
  800c12:	01 c8                	add    %ecx,%eax
  800c14:	8a 40 04             	mov    0x4(%eax),%al
  800c17:	3c 01                	cmp    $0x1,%al
  800c19:	75 03                	jne    800c1e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800c1b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c1e:	ff 45 e0             	incl   -0x20(%ebp)
  800c21:	a1 20 60 80 00       	mov    0x806020,%eax
  800c26:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800c2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c2f:	39 c2                	cmp    %eax,%edx
  800c31:	77 c8                	ja     800bfb <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c36:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c39:	74 14                	je     800c4f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800c3b:	83 ec 04             	sub    $0x4,%esp
  800c3e:	68 e4 4a 80 00       	push   $0x804ae4
  800c43:	6a 44                	push   $0x44
  800c45:	68 84 4a 80 00       	push   $0x804a84
  800c4a:	e8 1a fe ff ff       	call   800a69 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c4f:	90                   	nop
  800c50:	c9                   	leave  
  800c51:	c3                   	ret    

00800c52 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5b:	8b 00                	mov    (%eax),%eax
  800c5d:	8d 48 01             	lea    0x1(%eax),%ecx
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c63:	89 0a                	mov    %ecx,(%edx)
  800c65:	8b 55 08             	mov    0x8(%ebp),%edx
  800c68:	88 d1                	mov    %dl,%cl
  800c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c74:	8b 00                	mov    (%eax),%eax
  800c76:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c7b:	75 2c                	jne    800ca9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c7d:	a0 40 60 80 00       	mov    0x806040,%al
  800c82:	0f b6 c0             	movzbl %al,%eax
  800c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c88:	8b 12                	mov    (%edx),%edx
  800c8a:	89 d1                	mov    %edx,%ecx
  800c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8f:	83 c2 08             	add    $0x8,%edx
  800c92:	83 ec 04             	sub    $0x4,%esp
  800c95:	50                   	push   %eax
  800c96:	51                   	push   %ecx
  800c97:	52                   	push   %edx
  800c98:	e8 81 13 00 00       	call   80201e <sys_cputs>
  800c9d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8b 40 04             	mov    0x4(%eax),%eax
  800caf:	8d 50 01             	lea    0x1(%eax),%edx
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cb8:	90                   	nop
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800cc4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ccb:	00 00 00 
	b.cnt = 0;
  800cce:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800cd5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800cd8:	ff 75 0c             	pushl  0xc(%ebp)
  800cdb:	ff 75 08             	pushl  0x8(%ebp)
  800cde:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ce4:	50                   	push   %eax
  800ce5:	68 52 0c 80 00       	push   $0x800c52
  800cea:	e8 11 02 00 00       	call   800f00 <vprintfmt>
  800cef:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800cf2:	a0 40 60 80 00       	mov    0x806040,%al
  800cf7:	0f b6 c0             	movzbl %al,%eax
  800cfa:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d00:	83 ec 04             	sub    $0x4,%esp
  800d03:	50                   	push   %eax
  800d04:	52                   	push   %edx
  800d05:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d0b:	83 c0 08             	add    $0x8,%eax
  800d0e:	50                   	push   %eax
  800d0f:	e8 0a 13 00 00       	call   80201e <sys_cputs>
  800d14:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d17:	c6 05 40 60 80 00 00 	movb   $0x0,0x806040
	return b.cnt;
  800d1e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d2c:	c6 05 40 60 80 00 01 	movb   $0x1,0x806040
	va_start(ap, fmt);
  800d33:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	83 ec 08             	sub    $0x8,%esp
  800d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d42:	50                   	push   %eax
  800d43:	e8 73 ff ff ff       	call   800cbb <vcprintf>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800d59:	e8 02 13 00 00       	call   802060 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d5e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	83 ec 08             	sub    $0x8,%esp
  800d6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6d:	50                   	push   %eax
  800d6e:	e8 48 ff ff ff       	call   800cbb <vcprintf>
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d79:	e8 fc 12 00 00       	call   80207a <sys_unlock_cons>
	return cnt;
  800d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d81:	c9                   	leave  
  800d82:	c3                   	ret    

00800d83 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	53                   	push   %ebx
  800d87:	83 ec 14             	sub    $0x14,%esp
  800d8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d90:	8b 45 14             	mov    0x14(%ebp),%eax
  800d93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d96:	8b 45 18             	mov    0x18(%ebp),%eax
  800d99:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800da1:	77 55                	ja     800df8 <printnum+0x75>
  800da3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800da6:	72 05                	jb     800dad <printnum+0x2a>
  800da8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dab:	77 4b                	ja     800df8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800dad:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800db0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800db3:	8b 45 18             	mov    0x18(%ebp),%eax
  800db6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbb:	52                   	push   %edx
  800dbc:	50                   	push   %eax
  800dbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc0:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc3:	e8 58 33 00 00       	call   804120 <__udivdi3>
  800dc8:	83 c4 10             	add    $0x10,%esp
  800dcb:	83 ec 04             	sub    $0x4,%esp
  800dce:	ff 75 20             	pushl  0x20(%ebp)
  800dd1:	53                   	push   %ebx
  800dd2:	ff 75 18             	pushl  0x18(%ebp)
  800dd5:	52                   	push   %edx
  800dd6:	50                   	push   %eax
  800dd7:	ff 75 0c             	pushl  0xc(%ebp)
  800dda:	ff 75 08             	pushl  0x8(%ebp)
  800ddd:	e8 a1 ff ff ff       	call   800d83 <printnum>
  800de2:	83 c4 20             	add    $0x20,%esp
  800de5:	eb 1a                	jmp    800e01 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	ff 75 20             	pushl  0x20(%ebp)
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	ff d0                	call   *%eax
  800df5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800df8:	ff 4d 1c             	decl   0x1c(%ebp)
  800dfb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800dff:	7f e6                	jg     800de7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e01:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0f:	53                   	push   %ebx
  800e10:	51                   	push   %ecx
  800e11:	52                   	push   %edx
  800e12:	50                   	push   %eax
  800e13:	e8 18 34 00 00       	call   804230 <__umoddi3>
  800e18:	83 c4 10             	add    $0x10,%esp
  800e1b:	05 54 4d 80 00       	add    $0x804d54,%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	0f be c0             	movsbl %al,%eax
  800e25:	83 ec 08             	sub    $0x8,%esp
  800e28:	ff 75 0c             	pushl  0xc(%ebp)
  800e2b:	50                   	push   %eax
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	ff d0                	call   *%eax
  800e31:	83 c4 10             	add    $0x10,%esp
}
  800e34:	90                   	nop
  800e35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e3d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e41:	7e 1c                	jle    800e5f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	8b 00                	mov    (%eax),%eax
  800e48:	8d 50 08             	lea    0x8(%eax),%edx
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	89 10                	mov    %edx,(%eax)
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8b 00                	mov    (%eax),%eax
  800e55:	83 e8 08             	sub    $0x8,%eax
  800e58:	8b 50 04             	mov    0x4(%eax),%edx
  800e5b:	8b 00                	mov    (%eax),%eax
  800e5d:	eb 40                	jmp    800e9f <getuint+0x65>
	else if (lflag)
  800e5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e63:	74 1e                	je     800e83 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8b 00                	mov    (%eax),%eax
  800e6a:	8d 50 04             	lea    0x4(%eax),%edx
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 10                	mov    %edx,(%eax)
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8b 00                	mov    (%eax),%eax
  800e77:	83 e8 04             	sub    $0x4,%eax
  800e7a:	8b 00                	mov    (%eax),%eax
  800e7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e81:	eb 1c                	jmp    800e9f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8b 00                	mov    (%eax),%eax
  800e88:	8d 50 04             	lea    0x4(%eax),%edx
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	89 10                	mov    %edx,(%eax)
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8b 00                	mov    (%eax),%eax
  800e95:	83 e8 04             	sub    $0x4,%eax
  800e98:	8b 00                	mov    (%eax),%eax
  800e9a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ea4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ea8:	7e 1c                	jle    800ec6 <getint+0x25>
		return va_arg(*ap, long long);
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8b 00                	mov    (%eax),%eax
  800eaf:	8d 50 08             	lea    0x8(%eax),%edx
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	89 10                	mov    %edx,(%eax)
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8b 00                	mov    (%eax),%eax
  800ebc:	83 e8 08             	sub    $0x8,%eax
  800ebf:	8b 50 04             	mov    0x4(%eax),%edx
  800ec2:	8b 00                	mov    (%eax),%eax
  800ec4:	eb 38                	jmp    800efe <getint+0x5d>
	else if (lflag)
  800ec6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eca:	74 1a                	je     800ee6 <getint+0x45>
		return va_arg(*ap, long);
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8b 00                	mov    (%eax),%eax
  800ed1:	8d 50 04             	lea    0x4(%eax),%edx
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	89 10                	mov    %edx,(%eax)
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8b 00                	mov    (%eax),%eax
  800ede:	83 e8 04             	sub    $0x4,%eax
  800ee1:	8b 00                	mov    (%eax),%eax
  800ee3:	99                   	cltd   
  800ee4:	eb 18                	jmp    800efe <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8b 00                	mov    (%eax),%eax
  800eeb:	8d 50 04             	lea    0x4(%eax),%edx
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	89 10                	mov    %edx,(%eax)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8b 00                	mov    (%eax),%eax
  800ef8:	83 e8 04             	sub    $0x4,%eax
  800efb:	8b 00                	mov    (%eax),%eax
  800efd:	99                   	cltd   
}
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	56                   	push   %esi
  800f04:	53                   	push   %ebx
  800f05:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f08:	eb 17                	jmp    800f21 <vprintfmt+0x21>
			if (ch == '\0')
  800f0a:	85 db                	test   %ebx,%ebx
  800f0c:	0f 84 c1 03 00 00    	je     8012d3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800f12:	83 ec 08             	sub    $0x8,%esp
  800f15:	ff 75 0c             	pushl  0xc(%ebp)
  800f18:	53                   	push   %ebx
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	ff d0                	call   *%eax
  800f1e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	8d 50 01             	lea    0x1(%eax),%edx
  800f27:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 d8             	movzbl %al,%ebx
  800f2f:	83 fb 25             	cmp    $0x25,%ebx
  800f32:	75 d6                	jne    800f0a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f34:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f38:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f3f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f46:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f4d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	8d 50 01             	lea    0x1(%eax),%edx
  800f5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	0f b6 d8             	movzbl %al,%ebx
  800f62:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f65:	83 f8 5b             	cmp    $0x5b,%eax
  800f68:	0f 87 3d 03 00 00    	ja     8012ab <vprintfmt+0x3ab>
  800f6e:	8b 04 85 78 4d 80 00 	mov    0x804d78(,%eax,4),%eax
  800f75:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f77:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f7b:	eb d7                	jmp    800f54 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f7d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f81:	eb d1                	jmp    800f54 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f83:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f8d:	89 d0                	mov    %edx,%eax
  800f8f:	c1 e0 02             	shl    $0x2,%eax
  800f92:	01 d0                	add    %edx,%eax
  800f94:	01 c0                	add    %eax,%eax
  800f96:	01 d8                	add    %ebx,%eax
  800f98:	83 e8 30             	sub    $0x30,%eax
  800f9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fa6:	83 fb 2f             	cmp    $0x2f,%ebx
  800fa9:	7e 3e                	jle    800fe9 <vprintfmt+0xe9>
  800fab:	83 fb 39             	cmp    $0x39,%ebx
  800fae:	7f 39                	jg     800fe9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fb0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fb3:	eb d5                	jmp    800f8a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800fb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb8:	83 c0 04             	add    $0x4,%eax
  800fbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800fbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc1:	83 e8 04             	sub    $0x4,%eax
  800fc4:	8b 00                	mov    (%eax),%eax
  800fc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800fc9:	eb 1f                	jmp    800fea <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800fcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fcf:	79 83                	jns    800f54 <vprintfmt+0x54>
				width = 0;
  800fd1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800fd8:	e9 77 ff ff ff       	jmp    800f54 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fdd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800fe4:	e9 6b ff ff ff       	jmp    800f54 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fe9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fee:	0f 89 60 ff ff ff    	jns    800f54 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ff4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ff7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ffa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801001:	e9 4e ff ff ff       	jmp    800f54 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801006:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801009:	e9 46 ff ff ff       	jmp    800f54 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80100e:	8b 45 14             	mov    0x14(%ebp),%eax
  801011:	83 c0 04             	add    $0x4,%eax
  801014:	89 45 14             	mov    %eax,0x14(%ebp)
  801017:	8b 45 14             	mov    0x14(%ebp),%eax
  80101a:	83 e8 04             	sub    $0x4,%eax
  80101d:	8b 00                	mov    (%eax),%eax
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	50                   	push   %eax
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	ff d0                	call   *%eax
  80102b:	83 c4 10             	add    $0x10,%esp
			break;
  80102e:	e9 9b 02 00 00       	jmp    8012ce <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801033:	8b 45 14             	mov    0x14(%ebp),%eax
  801036:	83 c0 04             	add    $0x4,%eax
  801039:	89 45 14             	mov    %eax,0x14(%ebp)
  80103c:	8b 45 14             	mov    0x14(%ebp),%eax
  80103f:	83 e8 04             	sub    $0x4,%eax
  801042:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801044:	85 db                	test   %ebx,%ebx
  801046:	79 02                	jns    80104a <vprintfmt+0x14a>
				err = -err;
  801048:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80104a:	83 fb 64             	cmp    $0x64,%ebx
  80104d:	7f 0b                	jg     80105a <vprintfmt+0x15a>
  80104f:	8b 34 9d c0 4b 80 00 	mov    0x804bc0(,%ebx,4),%esi
  801056:	85 f6                	test   %esi,%esi
  801058:	75 19                	jne    801073 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80105a:	53                   	push   %ebx
  80105b:	68 65 4d 80 00       	push   $0x804d65
  801060:	ff 75 0c             	pushl  0xc(%ebp)
  801063:	ff 75 08             	pushl  0x8(%ebp)
  801066:	e8 70 02 00 00       	call   8012db <printfmt>
  80106b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80106e:	e9 5b 02 00 00       	jmp    8012ce <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801073:	56                   	push   %esi
  801074:	68 6e 4d 80 00       	push   $0x804d6e
  801079:	ff 75 0c             	pushl  0xc(%ebp)
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 57 02 00 00       	call   8012db <printfmt>
  801084:	83 c4 10             	add    $0x10,%esp
			break;
  801087:	e9 42 02 00 00       	jmp    8012ce <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	83 c0 04             	add    $0x4,%eax
  801092:	89 45 14             	mov    %eax,0x14(%ebp)
  801095:	8b 45 14             	mov    0x14(%ebp),%eax
  801098:	83 e8 04             	sub    $0x4,%eax
  80109b:	8b 30                	mov    (%eax),%esi
  80109d:	85 f6                	test   %esi,%esi
  80109f:	75 05                	jne    8010a6 <vprintfmt+0x1a6>
				p = "(null)";
  8010a1:	be 71 4d 80 00       	mov    $0x804d71,%esi
			if (width > 0 && padc != '-')
  8010a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010aa:	7e 6d                	jle    801119 <vprintfmt+0x219>
  8010ac:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010b0:	74 67                	je     801119 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b5:	83 ec 08             	sub    $0x8,%esp
  8010b8:	50                   	push   %eax
  8010b9:	56                   	push   %esi
  8010ba:	e8 1e 03 00 00       	call   8013dd <strnlen>
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8010c5:	eb 16                	jmp    8010dd <vprintfmt+0x1dd>
					putch(padc, putdat);
  8010c7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8010cb:	83 ec 08             	sub    $0x8,%esp
  8010ce:	ff 75 0c             	pushl  0xc(%ebp)
  8010d1:	50                   	push   %eax
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	ff d0                	call   *%eax
  8010d7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8010da:	ff 4d e4             	decl   -0x1c(%ebp)
  8010dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010e1:	7f e4                	jg     8010c7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010e3:	eb 34                	jmp    801119 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010e9:	74 1c                	je     801107 <vprintfmt+0x207>
  8010eb:	83 fb 1f             	cmp    $0x1f,%ebx
  8010ee:	7e 05                	jle    8010f5 <vprintfmt+0x1f5>
  8010f0:	83 fb 7e             	cmp    $0x7e,%ebx
  8010f3:	7e 12                	jle    801107 <vprintfmt+0x207>
					putch('?', putdat);
  8010f5:	83 ec 08             	sub    $0x8,%esp
  8010f8:	ff 75 0c             	pushl  0xc(%ebp)
  8010fb:	6a 3f                	push   $0x3f
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	ff d0                	call   *%eax
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	eb 0f                	jmp    801116 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801107:	83 ec 08             	sub    $0x8,%esp
  80110a:	ff 75 0c             	pushl  0xc(%ebp)
  80110d:	53                   	push   %ebx
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	ff d0                	call   *%eax
  801113:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801116:	ff 4d e4             	decl   -0x1c(%ebp)
  801119:	89 f0                	mov    %esi,%eax
  80111b:	8d 70 01             	lea    0x1(%eax),%esi
  80111e:	8a 00                	mov    (%eax),%al
  801120:	0f be d8             	movsbl %al,%ebx
  801123:	85 db                	test   %ebx,%ebx
  801125:	74 24                	je     80114b <vprintfmt+0x24b>
  801127:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80112b:	78 b8                	js     8010e5 <vprintfmt+0x1e5>
  80112d:	ff 4d e0             	decl   -0x20(%ebp)
  801130:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801134:	79 af                	jns    8010e5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801136:	eb 13                	jmp    80114b <vprintfmt+0x24b>
				putch(' ', putdat);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 0c             	pushl  0xc(%ebp)
  80113e:	6a 20                	push   $0x20
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	ff d0                	call   *%eax
  801145:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801148:	ff 4d e4             	decl   -0x1c(%ebp)
  80114b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80114f:	7f e7                	jg     801138 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801151:	e9 78 01 00 00       	jmp    8012ce <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801156:	83 ec 08             	sub    $0x8,%esp
  801159:	ff 75 e8             	pushl  -0x18(%ebp)
  80115c:	8d 45 14             	lea    0x14(%ebp),%eax
  80115f:	50                   	push   %eax
  801160:	e8 3c fd ff ff       	call   800ea1 <getint>
  801165:	83 c4 10             	add    $0x10,%esp
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80116e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801174:	85 d2                	test   %edx,%edx
  801176:	79 23                	jns    80119b <vprintfmt+0x29b>
				putch('-', putdat);
  801178:	83 ec 08             	sub    $0x8,%esp
  80117b:	ff 75 0c             	pushl  0xc(%ebp)
  80117e:	6a 2d                	push   $0x2d
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	ff d0                	call   *%eax
  801185:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80118e:	f7 d8                	neg    %eax
  801190:	83 d2 00             	adc    $0x0,%edx
  801193:	f7 da                	neg    %edx
  801195:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801198:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80119b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011a2:	e9 bc 00 00 00       	jmp    801263 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011a7:	83 ec 08             	sub    $0x8,%esp
  8011aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8011ad:	8d 45 14             	lea    0x14(%ebp),%eax
  8011b0:	50                   	push   %eax
  8011b1:	e8 84 fc ff ff       	call   800e3a <getuint>
  8011b6:	83 c4 10             	add    $0x10,%esp
  8011b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8011bf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011c6:	e9 98 00 00 00       	jmp    801263 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8011cb:	83 ec 08             	sub    $0x8,%esp
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	6a 58                	push   $0x58
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	ff d0                	call   *%eax
  8011d8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	ff 75 0c             	pushl  0xc(%ebp)
  8011e1:	6a 58                	push   $0x58
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	ff d0                	call   *%eax
  8011e8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011eb:	83 ec 08             	sub    $0x8,%esp
  8011ee:	ff 75 0c             	pushl  0xc(%ebp)
  8011f1:	6a 58                	push   $0x58
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	ff d0                	call   *%eax
  8011f8:	83 c4 10             	add    $0x10,%esp
			break;
  8011fb:	e9 ce 00 00 00       	jmp    8012ce <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801200:	83 ec 08             	sub    $0x8,%esp
  801203:	ff 75 0c             	pushl  0xc(%ebp)
  801206:	6a 30                	push   $0x30
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	ff d0                	call   *%eax
  80120d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801210:	83 ec 08             	sub    $0x8,%esp
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	6a 78                	push   $0x78
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	ff d0                	call   *%eax
  80121d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801220:	8b 45 14             	mov    0x14(%ebp),%eax
  801223:	83 c0 04             	add    $0x4,%eax
  801226:	89 45 14             	mov    %eax,0x14(%ebp)
  801229:	8b 45 14             	mov    0x14(%ebp),%eax
  80122c:	83 e8 04             	sub    $0x4,%eax
  80122f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801231:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801234:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80123b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801242:	eb 1f                	jmp    801263 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801244:	83 ec 08             	sub    $0x8,%esp
  801247:	ff 75 e8             	pushl  -0x18(%ebp)
  80124a:	8d 45 14             	lea    0x14(%ebp),%eax
  80124d:	50                   	push   %eax
  80124e:	e8 e7 fb ff ff       	call   800e3a <getuint>
  801253:	83 c4 10             	add    $0x10,%esp
  801256:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801259:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80125c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801263:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80126a:	83 ec 04             	sub    $0x4,%esp
  80126d:	52                   	push   %edx
  80126e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801271:	50                   	push   %eax
  801272:	ff 75 f4             	pushl  -0xc(%ebp)
  801275:	ff 75 f0             	pushl  -0x10(%ebp)
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	ff 75 08             	pushl  0x8(%ebp)
  80127e:	e8 00 fb ff ff       	call   800d83 <printnum>
  801283:	83 c4 20             	add    $0x20,%esp
			break;
  801286:	eb 46                	jmp    8012ce <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801288:	83 ec 08             	sub    $0x8,%esp
  80128b:	ff 75 0c             	pushl  0xc(%ebp)
  80128e:	53                   	push   %ebx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	ff d0                	call   *%eax
  801294:	83 c4 10             	add    $0x10,%esp
			break;
  801297:	eb 35                	jmp    8012ce <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801299:	c6 05 40 60 80 00 00 	movb   $0x0,0x806040
			break;
  8012a0:	eb 2c                	jmp    8012ce <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8012a2:	c6 05 40 60 80 00 01 	movb   $0x1,0x806040
			break;
  8012a9:	eb 23                	jmp    8012ce <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012ab:	83 ec 08             	sub    $0x8,%esp
  8012ae:	ff 75 0c             	pushl  0xc(%ebp)
  8012b1:	6a 25                	push   $0x25
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	ff d0                	call   *%eax
  8012b8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012bb:	ff 4d 10             	decl   0x10(%ebp)
  8012be:	eb 03                	jmp    8012c3 <vprintfmt+0x3c3>
  8012c0:	ff 4d 10             	decl   0x10(%ebp)
  8012c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c6:	48                   	dec    %eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 25                	cmp    $0x25,%al
  8012cb:	75 f3                	jne    8012c0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8012cd:	90                   	nop
		}
	}
  8012ce:	e9 35 fc ff ff       	jmp    800f08 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8012d3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8012d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d7:	5b                   	pop    %ebx
  8012d8:	5e                   	pop    %esi
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012e1:	8d 45 10             	lea    0x10(%ebp),%eax
  8012e4:	83 c0 04             	add    $0x4,%eax
  8012e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8012f0:	50                   	push   %eax
  8012f1:	ff 75 0c             	pushl  0xc(%ebp)
  8012f4:	ff 75 08             	pushl  0x8(%ebp)
  8012f7:	e8 04 fc ff ff       	call   800f00 <vprintfmt>
  8012fc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012ff:	90                   	nop
  801300:	c9                   	leave  
  801301:	c3                   	ret    

00801302 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801305:	8b 45 0c             	mov    0xc(%ebp),%eax
  801308:	8b 40 08             	mov    0x8(%eax),%eax
  80130b:	8d 50 01             	lea    0x1(%eax),%edx
  80130e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801311:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	8b 10                	mov    (%eax),%edx
  801319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131c:	8b 40 04             	mov    0x4(%eax),%eax
  80131f:	39 c2                	cmp    %eax,%edx
  801321:	73 12                	jae    801335 <sprintputch+0x33>
		*b->buf++ = ch;
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	8b 00                	mov    (%eax),%eax
  801328:	8d 48 01             	lea    0x1(%eax),%ecx
  80132b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132e:	89 0a                	mov    %ecx,(%edx)
  801330:	8b 55 08             	mov    0x8(%ebp),%edx
  801333:	88 10                	mov    %dl,(%eax)
}
  801335:	90                   	nop
  801336:	5d                   	pop    %ebp
  801337:	c3                   	ret    

00801338 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	8d 50 ff             	lea    -0x1(%eax),%edx
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	01 d0                	add    %edx,%eax
  80134f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801352:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801359:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80135d:	74 06                	je     801365 <vsnprintf+0x2d>
  80135f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801363:	7f 07                	jg     80136c <vsnprintf+0x34>
		return -E_INVAL;
  801365:	b8 03 00 00 00       	mov    $0x3,%eax
  80136a:	eb 20                	jmp    80138c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80136c:	ff 75 14             	pushl  0x14(%ebp)
  80136f:	ff 75 10             	pushl  0x10(%ebp)
  801372:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801375:	50                   	push   %eax
  801376:	68 02 13 80 00       	push   $0x801302
  80137b:	e8 80 fb ff ff       	call   800f00 <vprintfmt>
  801380:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801383:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801386:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801389:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801394:	8d 45 10             	lea    0x10(%ebp),%eax
  801397:	83 c0 04             	add    $0x4,%eax
  80139a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80139d:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a3:	50                   	push   %eax
  8013a4:	ff 75 0c             	pushl  0xc(%ebp)
  8013a7:	ff 75 08             	pushl  0x8(%ebp)
  8013aa:	e8 89 ff ff ff       	call   801338 <vsnprintf>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013c7:	eb 06                	jmp    8013cf <strlen+0x15>
		n++;
  8013c9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013cc:	ff 45 08             	incl   0x8(%ebp)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	84 c0                	test   %al,%al
  8013d6:	75 f1                	jne    8013c9 <strlen+0xf>
		n++;
	return n;
  8013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ea:	eb 09                	jmp    8013f5 <strnlen+0x18>
		n++;
  8013ec:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013ef:	ff 45 08             	incl   0x8(%ebp)
  8013f2:	ff 4d 0c             	decl   0xc(%ebp)
  8013f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013f9:	74 09                	je     801404 <strnlen+0x27>
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	84 c0                	test   %al,%al
  801402:	75 e8                	jne    8013ec <strnlen+0xf>
		n++;
	return n;
  801404:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801415:	90                   	nop
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8d 50 01             	lea    0x1(%eax),%edx
  80141c:	89 55 08             	mov    %edx,0x8(%ebp)
  80141f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801422:	8d 4a 01             	lea    0x1(%edx),%ecx
  801425:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801428:	8a 12                	mov    (%edx),%dl
  80142a:	88 10                	mov    %dl,(%eax)
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	84 c0                	test   %al,%al
  801430:	75 e4                	jne    801416 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801432:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144a:	eb 1f                	jmp    80146b <strncpy+0x34>
		*dst++ = *src;
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	8d 50 01             	lea    0x1(%eax),%edx
  801452:	89 55 08             	mov    %edx,0x8(%ebp)
  801455:	8b 55 0c             	mov    0xc(%ebp),%edx
  801458:	8a 12                	mov    (%edx),%dl
  80145a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	84 c0                	test   %al,%al
  801463:	74 03                	je     801468 <strncpy+0x31>
			src++;
  801465:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801468:	ff 45 fc             	incl   -0x4(%ebp)
  80146b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801471:	72 d9                	jb     80144c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801473:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801484:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801488:	74 30                	je     8014ba <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80148a:	eb 16                	jmp    8014a2 <strlcpy+0x2a>
			*dst++ = *src++;
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8d 50 01             	lea    0x1(%eax),%edx
  801492:	89 55 08             	mov    %edx,0x8(%ebp)
  801495:	8b 55 0c             	mov    0xc(%ebp),%edx
  801498:	8d 4a 01             	lea    0x1(%edx),%ecx
  80149b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80149e:	8a 12                	mov    (%edx),%dl
  8014a0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014a2:	ff 4d 10             	decl   0x10(%ebp)
  8014a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a9:	74 09                	je     8014b4 <strlcpy+0x3c>
  8014ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	84 c0                	test   %al,%al
  8014b2:	75 d8                	jne    80148c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c0:	29 c2                	sub    %eax,%edx
  8014c2:	89 d0                	mov    %edx,%eax
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014c9:	eb 06                	jmp    8014d1 <strcmp+0xb>
		p++, q++;
  8014cb:	ff 45 08             	incl   0x8(%ebp)
  8014ce:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	84 c0                	test   %al,%al
  8014d8:	74 0e                	je     8014e8 <strcmp+0x22>
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 10                	mov    (%eax),%dl
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	38 c2                	cmp    %al,%dl
  8014e6:	74 e3                	je     8014cb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	0f b6 d0             	movzbl %al,%edx
  8014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	0f b6 c0             	movzbl %al,%eax
  8014f8:	29 c2                	sub    %eax,%edx
  8014fa:	89 d0                	mov    %edx,%eax
}
  8014fc:	5d                   	pop    %ebp
  8014fd:	c3                   	ret    

008014fe <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801501:	eb 09                	jmp    80150c <strncmp+0xe>
		n--, p++, q++;
  801503:	ff 4d 10             	decl   0x10(%ebp)
  801506:	ff 45 08             	incl   0x8(%ebp)
  801509:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80150c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801510:	74 17                	je     801529 <strncmp+0x2b>
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	84 c0                	test   %al,%al
  801519:	74 0e                	je     801529 <strncmp+0x2b>
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 10                	mov    (%eax),%dl
  801520:	8b 45 0c             	mov    0xc(%ebp),%eax
  801523:	8a 00                	mov    (%eax),%al
  801525:	38 c2                	cmp    %al,%dl
  801527:	74 da                	je     801503 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801529:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152d:	75 07                	jne    801536 <strncmp+0x38>
		return 0;
  80152f:	b8 00 00 00 00       	mov    $0x0,%eax
  801534:	eb 14                	jmp    80154a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	0f b6 d0             	movzbl %al,%edx
  80153e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801541:	8a 00                	mov    (%eax),%al
  801543:	0f b6 c0             	movzbl %al,%eax
  801546:	29 c2                	sub    %eax,%edx
  801548:	89 d0                	mov    %edx,%eax
}
  80154a:	5d                   	pop    %ebp
  80154b:	c3                   	ret    

0080154c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	83 ec 04             	sub    $0x4,%esp
  801552:	8b 45 0c             	mov    0xc(%ebp),%eax
  801555:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801558:	eb 12                	jmp    80156c <strchr+0x20>
		if (*s == c)
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801562:	75 05                	jne    801569 <strchr+0x1d>
			return (char *) s;
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	eb 11                	jmp    80157a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801569:	ff 45 08             	incl   0x8(%ebp)
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	8a 00                	mov    (%eax),%al
  801571:	84 c0                	test   %al,%al
  801573:	75 e5                	jne    80155a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801575:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	83 ec 04             	sub    $0x4,%esp
  801582:	8b 45 0c             	mov    0xc(%ebp),%eax
  801585:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801588:	eb 0d                	jmp    801597 <strfind+0x1b>
		if (*s == c)
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8a 00                	mov    (%eax),%al
  80158f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801592:	74 0e                	je     8015a2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801594:	ff 45 08             	incl   0x8(%ebp)
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	84 c0                	test   %al,%al
  80159e:	75 ea                	jne    80158a <strfind+0xe>
  8015a0:	eb 01                	jmp    8015a3 <strfind+0x27>
		if (*s == c)
			break;
  8015a2:	90                   	nop
	return (char *) s;
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015ba:	eb 0e                	jmp    8015ca <memset+0x22>
		*p++ = c;
  8015bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015bf:	8d 50 01             	lea    0x1(%eax),%edx
  8015c2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015ca:	ff 4d f8             	decl   -0x8(%ebp)
  8015cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015d1:	79 e9                	jns    8015bc <memset+0x14>
		*p++ = c;

	return v;
  8015d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015ea:	eb 16                	jmp    801602 <memcpy+0x2a>
		*d++ = *s++;
  8015ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ef:	8d 50 01             	lea    0x1(%eax),%edx
  8015f2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015fb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015fe:	8a 12                	mov    (%edx),%dl
  801600:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801602:	8b 45 10             	mov    0x10(%ebp),%eax
  801605:	8d 50 ff             	lea    -0x1(%eax),%edx
  801608:	89 55 10             	mov    %edx,0x10(%ebp)
  80160b:	85 c0                	test   %eax,%eax
  80160d:	75 dd                	jne    8015ec <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80161a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801626:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801629:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80162c:	73 50                	jae    80167e <memmove+0x6a>
  80162e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801631:	8b 45 10             	mov    0x10(%ebp),%eax
  801634:	01 d0                	add    %edx,%eax
  801636:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801639:	76 43                	jbe    80167e <memmove+0x6a>
		s += n;
  80163b:	8b 45 10             	mov    0x10(%ebp),%eax
  80163e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801647:	eb 10                	jmp    801659 <memmove+0x45>
			*--d = *--s;
  801649:	ff 4d f8             	decl   -0x8(%ebp)
  80164c:	ff 4d fc             	decl   -0x4(%ebp)
  80164f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801652:	8a 10                	mov    (%eax),%dl
  801654:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801657:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80165f:	89 55 10             	mov    %edx,0x10(%ebp)
  801662:	85 c0                	test   %eax,%eax
  801664:	75 e3                	jne    801649 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801666:	eb 23                	jmp    80168b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801668:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166b:	8d 50 01             	lea    0x1(%eax),%edx
  80166e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801671:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801674:	8d 4a 01             	lea    0x1(%edx),%ecx
  801677:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80167a:	8a 12                	mov    (%edx),%dl
  80167c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80167e:	8b 45 10             	mov    0x10(%ebp),%eax
  801681:	8d 50 ff             	lea    -0x1(%eax),%edx
  801684:	89 55 10             	mov    %edx,0x10(%ebp)
  801687:	85 c0                	test   %eax,%eax
  801689:	75 dd                	jne    801668 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80169c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016a2:	eb 2a                	jmp    8016ce <memcmp+0x3e>
		if (*s1 != *s2)
  8016a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a7:	8a 10                	mov    (%eax),%dl
  8016a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ac:	8a 00                	mov    (%eax),%al
  8016ae:	38 c2                	cmp    %al,%dl
  8016b0:	74 16                	je     8016c8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	0f b6 d0             	movzbl %al,%edx
  8016ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bd:	8a 00                	mov    (%eax),%al
  8016bf:	0f b6 c0             	movzbl %al,%eax
  8016c2:	29 c2                	sub    %eax,%edx
  8016c4:	89 d0                	mov    %edx,%eax
  8016c6:	eb 18                	jmp    8016e0 <memcmp+0x50>
		s1++, s2++;
  8016c8:	ff 45 fc             	incl   -0x4(%ebp)
  8016cb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	75 c9                	jne    8016a4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ee:	01 d0                	add    %edx,%eax
  8016f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016f3:	eb 15                	jmp    80170a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	0f b6 d0             	movzbl %al,%edx
  8016fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801700:	0f b6 c0             	movzbl %al,%eax
  801703:	39 c2                	cmp    %eax,%edx
  801705:	74 0d                	je     801714 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801707:	ff 45 08             	incl   0x8(%ebp)
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801710:	72 e3                	jb     8016f5 <memfind+0x13>
  801712:	eb 01                	jmp    801715 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801714:	90                   	nop
	return (void *) s;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801720:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801727:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80172e:	eb 03                	jmp    801733 <strtol+0x19>
		s++;
  801730:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8a 00                	mov    (%eax),%al
  801738:	3c 20                	cmp    $0x20,%al
  80173a:	74 f4                	je     801730 <strtol+0x16>
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	8a 00                	mov    (%eax),%al
  801741:	3c 09                	cmp    $0x9,%al
  801743:	74 eb                	je     801730 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	8a 00                	mov    (%eax),%al
  80174a:	3c 2b                	cmp    $0x2b,%al
  80174c:	75 05                	jne    801753 <strtol+0x39>
		s++;
  80174e:	ff 45 08             	incl   0x8(%ebp)
  801751:	eb 13                	jmp    801766 <strtol+0x4c>
	else if (*s == '-')
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	8a 00                	mov    (%eax),%al
  801758:	3c 2d                	cmp    $0x2d,%al
  80175a:	75 0a                	jne    801766 <strtol+0x4c>
		s++, neg = 1;
  80175c:	ff 45 08             	incl   0x8(%ebp)
  80175f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801766:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80176a:	74 06                	je     801772 <strtol+0x58>
  80176c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801770:	75 20                	jne    801792 <strtol+0x78>
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	3c 30                	cmp    $0x30,%al
  801779:	75 17                	jne    801792 <strtol+0x78>
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	40                   	inc    %eax
  80177f:	8a 00                	mov    (%eax),%al
  801781:	3c 78                	cmp    $0x78,%al
  801783:	75 0d                	jne    801792 <strtol+0x78>
		s += 2, base = 16;
  801785:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801789:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801790:	eb 28                	jmp    8017ba <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801792:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801796:	75 15                	jne    8017ad <strtol+0x93>
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	8a 00                	mov    (%eax),%al
  80179d:	3c 30                	cmp    $0x30,%al
  80179f:	75 0c                	jne    8017ad <strtol+0x93>
		s++, base = 8;
  8017a1:	ff 45 08             	incl   0x8(%ebp)
  8017a4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017ab:	eb 0d                	jmp    8017ba <strtol+0xa0>
	else if (base == 0)
  8017ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b1:	75 07                	jne    8017ba <strtol+0xa0>
		base = 10;
  8017b3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8a 00                	mov    (%eax),%al
  8017bf:	3c 2f                	cmp    $0x2f,%al
  8017c1:	7e 19                	jle    8017dc <strtol+0xc2>
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	8a 00                	mov    (%eax),%al
  8017c8:	3c 39                	cmp    $0x39,%al
  8017ca:	7f 10                	jg     8017dc <strtol+0xc2>
			dig = *s - '0';
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	8a 00                	mov    (%eax),%al
  8017d1:	0f be c0             	movsbl %al,%eax
  8017d4:	83 e8 30             	sub    $0x30,%eax
  8017d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017da:	eb 42                	jmp    80181e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	8a 00                	mov    (%eax),%al
  8017e1:	3c 60                	cmp    $0x60,%al
  8017e3:	7e 19                	jle    8017fe <strtol+0xe4>
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	8a 00                	mov    (%eax),%al
  8017ea:	3c 7a                	cmp    $0x7a,%al
  8017ec:	7f 10                	jg     8017fe <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	8a 00                	mov    (%eax),%al
  8017f3:	0f be c0             	movsbl %al,%eax
  8017f6:	83 e8 57             	sub    $0x57,%eax
  8017f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017fc:	eb 20                	jmp    80181e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	3c 40                	cmp    $0x40,%al
  801805:	7e 39                	jle    801840 <strtol+0x126>
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8a 00                	mov    (%eax),%al
  80180c:	3c 5a                	cmp    $0x5a,%al
  80180e:	7f 30                	jg     801840 <strtol+0x126>
			dig = *s - 'A' + 10;
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	8a 00                	mov    (%eax),%al
  801815:	0f be c0             	movsbl %al,%eax
  801818:	83 e8 37             	sub    $0x37,%eax
  80181b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80181e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801821:	3b 45 10             	cmp    0x10(%ebp),%eax
  801824:	7d 19                	jge    80183f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801826:	ff 45 08             	incl   0x8(%ebp)
  801829:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801830:	89 c2                	mov    %eax,%edx
  801832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801835:	01 d0                	add    %edx,%eax
  801837:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80183a:	e9 7b ff ff ff       	jmp    8017ba <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80183f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801840:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801844:	74 08                	je     80184e <strtol+0x134>
		*endptr = (char *) s;
  801846:	8b 45 0c             	mov    0xc(%ebp),%eax
  801849:	8b 55 08             	mov    0x8(%ebp),%edx
  80184c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80184e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801852:	74 07                	je     80185b <strtol+0x141>
  801854:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801857:	f7 d8                	neg    %eax
  801859:	eb 03                	jmp    80185e <strtol+0x144>
  80185b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <ltostr>:

void
ltostr(long value, char *str)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801866:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80186d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801874:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801878:	79 13                	jns    80188d <ltostr+0x2d>
	{
		neg = 1;
  80187a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801881:	8b 45 0c             	mov    0xc(%ebp),%eax
  801884:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801887:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80188a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801895:	99                   	cltd   
  801896:	f7 f9                	idiv   %ecx
  801898:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	8d 50 01             	lea    0x1(%eax),%edx
  8018a1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018a4:	89 c2                	mov    %eax,%edx
  8018a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a9:	01 d0                	add    %edx,%eax
  8018ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018ae:	83 c2 30             	add    $0x30,%edx
  8018b1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018bb:	f7 e9                	imul   %ecx
  8018bd:	c1 fa 02             	sar    $0x2,%edx
  8018c0:	89 c8                	mov    %ecx,%eax
  8018c2:	c1 f8 1f             	sar    $0x1f,%eax
  8018c5:	29 c2                	sub    %eax,%edx
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d0:	75 bb                	jne    80188d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018dc:	48                   	dec    %eax
  8018dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018e4:	74 3d                	je     801923 <ltostr+0xc3>
		start = 1 ;
  8018e6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018ed:	eb 34                	jmp    801923 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f5:	01 d0                	add    %edx,%eax
  8018f7:	8a 00                	mov    (%eax),%al
  8018f9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	01 c2                	add    %eax,%edx
  801904:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190a:	01 c8                	add    %ecx,%eax
  80190c:	8a 00                	mov    (%eax),%al
  80190e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801910:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801913:	8b 45 0c             	mov    0xc(%ebp),%eax
  801916:	01 c2                	add    %eax,%edx
  801918:	8a 45 eb             	mov    -0x15(%ebp),%al
  80191b:	88 02                	mov    %al,(%edx)
		start++ ;
  80191d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801920:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801926:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801929:	7c c4                	jl     8018ef <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80192b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	01 d0                	add    %edx,%eax
  801933:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801936:	90                   	nop
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80193f:	ff 75 08             	pushl  0x8(%ebp)
  801942:	e8 73 fa ff ff       	call   8013ba <strlen>
  801947:	83 c4 04             	add    $0x4,%esp
  80194a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	e8 65 fa ff ff       	call   8013ba <strlen>
  801955:	83 c4 04             	add    $0x4,%esp
  801958:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80195b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801962:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801969:	eb 17                	jmp    801982 <strcconcat+0x49>
		final[s] = str1[s] ;
  80196b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80196e:	8b 45 10             	mov    0x10(%ebp),%eax
  801971:	01 c2                	add    %eax,%edx
  801973:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	01 c8                	add    %ecx,%eax
  80197b:	8a 00                	mov    (%eax),%al
  80197d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80197f:	ff 45 fc             	incl   -0x4(%ebp)
  801982:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801985:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801988:	7c e1                	jl     80196b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80198a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801991:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801998:	eb 1f                	jmp    8019b9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80199a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80199d:	8d 50 01             	lea    0x1(%eax),%edx
  8019a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019a3:	89 c2                	mov    %eax,%edx
  8019a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a8:	01 c2                	add    %eax,%edx
  8019aa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b0:	01 c8                	add    %ecx,%eax
  8019b2:	8a 00                	mov    (%eax),%al
  8019b4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019b6:	ff 45 f8             	incl   -0x8(%ebp)
  8019b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019bf:	7c d9                	jl     80199a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c7:	01 d0                	add    %edx,%eax
  8019c9:	c6 00 00             	movb   $0x0,(%eax)
}
  8019cc:	90                   	nop
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019db:	8b 45 14             	mov    0x14(%ebp),%eax
  8019de:	8b 00                	mov    (%eax),%eax
  8019e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ea:	01 d0                	add    %edx,%eax
  8019ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019f2:	eb 0c                	jmp    801a00 <strsplit+0x31>
			*string++ = 0;
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	8d 50 01             	lea    0x1(%eax),%edx
  8019fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8019fd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	8a 00                	mov    (%eax),%al
  801a05:	84 c0                	test   %al,%al
  801a07:	74 18                	je     801a21 <strsplit+0x52>
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	8a 00                	mov    (%eax),%al
  801a0e:	0f be c0             	movsbl %al,%eax
  801a11:	50                   	push   %eax
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	e8 32 fb ff ff       	call   80154c <strchr>
  801a1a:	83 c4 08             	add    $0x8,%esp
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	75 d3                	jne    8019f4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	84 c0                	test   %al,%al
  801a28:	74 5a                	je     801a84 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2d:	8b 00                	mov    (%eax),%eax
  801a2f:	83 f8 0f             	cmp    $0xf,%eax
  801a32:	75 07                	jne    801a3b <strsplit+0x6c>
		{
			return 0;
  801a34:	b8 00 00 00 00       	mov    $0x0,%eax
  801a39:	eb 66                	jmp    801aa1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3e:	8b 00                	mov    (%eax),%eax
  801a40:	8d 48 01             	lea    0x1(%eax),%ecx
  801a43:	8b 55 14             	mov    0x14(%ebp),%edx
  801a46:	89 0a                	mov    %ecx,(%edx)
  801a48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a52:	01 c2                	add    %eax,%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a59:	eb 03                	jmp    801a5e <strsplit+0x8f>
			string++;
  801a5b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	8a 00                	mov    (%eax),%al
  801a63:	84 c0                	test   %al,%al
  801a65:	74 8b                	je     8019f2 <strsplit+0x23>
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8a 00                	mov    (%eax),%al
  801a6c:	0f be c0             	movsbl %al,%eax
  801a6f:	50                   	push   %eax
  801a70:	ff 75 0c             	pushl  0xc(%ebp)
  801a73:	e8 d4 fa ff ff       	call   80154c <strchr>
  801a78:	83 c4 08             	add    $0x8,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	74 dc                	je     801a5b <strsplit+0x8c>
			string++;
	}
  801a7f:	e9 6e ff ff ff       	jmp    8019f2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a84:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a85:	8b 45 14             	mov    0x14(%ebp),%eax
  801a88:	8b 00                	mov    (%eax),%eax
  801a8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a91:	8b 45 10             	mov    0x10(%ebp),%eax
  801a94:	01 d0                	add    %edx,%eax
  801a96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a9c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	68 e8 4e 80 00       	push   $0x804ee8
  801ab1:	68 3f 01 00 00       	push   $0x13f
  801ab6:	68 0a 4f 80 00       	push   $0x804f0a
  801abb:	e8 a9 ef ff ff       	call   800a69 <_panic>

00801ac0 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801ac6:	83 ec 0c             	sub    $0xc,%esp
  801ac9:	ff 75 08             	pushl  0x8(%ebp)
  801acc:	e8 f8 0a 00 00       	call   8025c9 <sys_sbrk>
  801ad1:	83 c4 10             	add    $0x10,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801adc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ae0:	75 0a                	jne    801aec <malloc+0x16>
  801ae2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae7:	e9 07 02 00 00       	jmp    801cf3 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801aec:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801af3:	8b 55 08             	mov    0x8(%ebp),%edx
  801af6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801af9:	01 d0                	add    %edx,%eax
  801afb:	48                   	dec    %eax
  801afc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b02:	ba 00 00 00 00       	mov    $0x0,%edx
  801b07:	f7 75 dc             	divl   -0x24(%ebp)
  801b0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b0d:	29 d0                	sub    %edx,%eax
  801b0f:	c1 e8 0c             	shr    $0xc,%eax
  801b12:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801b15:	a1 20 60 80 00       	mov    0x806020,%eax
  801b1a:	8b 40 78             	mov    0x78(%eax),%eax
  801b1d:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801b22:	29 c2                	sub    %eax,%edx
  801b24:	89 d0                	mov    %edx,%eax
  801b26:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b31:	c1 e8 0c             	shr    $0xc,%eax
  801b34:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801b37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801b3e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801b45:	77 42                	ja     801b89 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b47:	e8 01 09 00 00       	call   80244d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	74 16                	je     801b66 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	e8 dd 0e 00 00       	call   802a38 <alloc_block_FF>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b61:	e9 8a 01 00 00       	jmp    801cf0 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b66:	e8 13 09 00 00       	call   80247e <sys_isUHeapPlacementStrategyBESTFIT>
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	0f 84 7d 01 00 00    	je     801cf0 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	e8 76 13 00 00       	call   802ef4 <alloc_block_BF>
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b84:	e9 67 01 00 00       	jmp    801cf0 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801b89:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b8c:	48                   	dec    %eax
  801b8d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b90:	0f 86 53 01 00 00    	jbe    801ce9 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801b96:	a1 20 60 80 00       	mov    0x806020,%eax
  801b9b:	8b 40 78             	mov    0x78(%eax),%eax
  801b9e:	05 00 10 00 00       	add    $0x1000,%eax
  801ba3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801ba6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801bad:	e9 de 00 00 00       	jmp    801c90 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801bb2:	a1 20 60 80 00       	mov    0x806020,%eax
  801bb7:	8b 40 78             	mov    0x78(%eax),%eax
  801bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bbd:	29 c2                	sub    %eax,%edx
  801bbf:	89 d0                	mov    %edx,%eax
  801bc1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bc6:	c1 e8 0c             	shr    $0xc,%eax
  801bc9:	8b 04 85 60 a2 88 00 	mov    0x88a260(,%eax,4),%eax
  801bd0:	85 c0                	test   %eax,%eax
  801bd2:	0f 85 ab 00 00 00    	jne    801c83 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdb:	05 00 10 00 00       	add    $0x1000,%eax
  801be0:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801be3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  801bea:	eb 47                	jmp    801c33 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801bec:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801bf3:	76 0a                	jbe    801bff <malloc+0x129>
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfa:	e9 f4 00 00 00       	jmp    801cf3 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801bff:	a1 20 60 80 00       	mov    0x806020,%eax
  801c04:	8b 40 78             	mov    0x78(%eax),%eax
  801c07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c0a:	29 c2                	sub    %eax,%edx
  801c0c:	89 d0                	mov    %edx,%eax
  801c0e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c13:	c1 e8 0c             	shr    $0xc,%eax
  801c16:	8b 04 85 60 a2 88 00 	mov    0x88a260(,%eax,4),%eax
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	74 08                	je     801c29 <malloc+0x153>
					{
						
						i = j;
  801c21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801c27:	eb 5a                	jmp    801c83 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801c29:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801c30:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801c33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c36:	48                   	dec    %eax
  801c37:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c3a:	77 b0                	ja     801bec <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801c3c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801c43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c4a:	eb 2f                	jmp    801c7b <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801c4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c4f:	c1 e0 0c             	shl    $0xc,%eax
  801c52:	89 c2                	mov    %eax,%edx
  801c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c57:	01 c2                	add    %eax,%edx
  801c59:	a1 20 60 80 00       	mov    0x806020,%eax
  801c5e:	8b 40 78             	mov    0x78(%eax),%eax
  801c61:	29 c2                	sub    %eax,%edx
  801c63:	89 d0                	mov    %edx,%eax
  801c65:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c6a:	c1 e8 0c             	shr    $0xc,%eax
  801c6d:	c7 04 85 60 a2 88 00 	movl   $0x1,0x88a260(,%eax,4)
  801c74:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801c78:	ff 45 e0             	incl   -0x20(%ebp)
  801c7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c7e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c81:	72 c9                	jb     801c4c <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  801c83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c87:	75 16                	jne    801c9f <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801c89:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801c90:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801c97:	0f 86 15 ff ff ff    	jbe    801bb2 <malloc+0xdc>
  801c9d:	eb 01                	jmp    801ca0 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801c9f:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801ca0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ca4:	75 07                	jne    801cad <malloc+0x1d7>
  801ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cab:	eb 46                	jmp    801cf3 <malloc+0x21d>
		ptr = (void*)i;
  801cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801cb3:	a1 20 60 80 00       	mov    0x806020,%eax
  801cb8:	8b 40 78             	mov    0x78(%eax),%eax
  801cbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cbe:	29 c2                	sub    %eax,%edx
  801cc0:	89 d0                	mov    %edx,%eax
  801cc2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cc7:	c1 e8 0c             	shr    $0xc,%eax
  801cca:	89 c2                	mov    %eax,%edx
  801ccc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ccf:	89 04 95 60 a2 90 00 	mov    %eax,0x90a260(,%edx,4)
		sys_allocate_user_mem(i, size);
  801cd6:	83 ec 08             	sub    $0x8,%esp
  801cd9:	ff 75 08             	pushl  0x8(%ebp)
  801cdc:	ff 75 f0             	pushl  -0x10(%ebp)
  801cdf:	e8 1c 09 00 00       	call   802600 <sys_allocate_user_mem>
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	eb 07                	jmp    801cf0 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  801ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cee:	eb 03                	jmp    801cf3 <malloc+0x21d>
	}
	return ptr;
  801cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801cfb:	a1 20 60 80 00       	mov    0x806020,%eax
  801d00:	8b 40 78             	mov    0x78(%eax),%eax
  801d03:	05 00 10 00 00       	add    $0x1000,%eax
  801d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801d0b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801d12:	a1 20 60 80 00       	mov    0x806020,%eax
  801d17:	8b 50 78             	mov    0x78(%eax),%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	39 c2                	cmp    %eax,%edx
  801d1f:	76 24                	jbe    801d45 <free+0x50>
		size = get_block_size(va);
  801d21:	83 ec 0c             	sub    $0xc,%esp
  801d24:	ff 75 08             	pushl  0x8(%ebp)
  801d27:	e8 8c 09 00 00       	call   8026b8 <get_block_size>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 9c 1b 00 00       	call   8038d9 <free_block>
  801d3d:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801d40:	e9 ac 00 00 00       	jmp    801df1 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d4b:	0f 82 89 00 00 00    	jb     801dda <free+0xe5>
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801d59:	77 7f                	ja     801dda <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  801d5e:	a1 20 60 80 00       	mov    0x806020,%eax
  801d63:	8b 40 78             	mov    0x78(%eax),%eax
  801d66:	29 c2                	sub    %eax,%edx
  801d68:	89 d0                	mov    %edx,%eax
  801d6a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d6f:	c1 e8 0c             	shr    $0xc,%eax
  801d72:	8b 04 85 60 a2 90 00 	mov    0x90a260(,%eax,4),%eax
  801d79:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d7f:	c1 e0 0c             	shl    $0xc,%eax
  801d82:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801d85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d8c:	eb 42                	jmp    801dd0 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d91:	c1 e0 0c             	shl    $0xc,%eax
  801d94:	89 c2                	mov    %eax,%edx
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	01 c2                	add    %eax,%edx
  801d9b:	a1 20 60 80 00       	mov    0x806020,%eax
  801da0:	8b 40 78             	mov    0x78(%eax),%eax
  801da3:	29 c2                	sub    %eax,%edx
  801da5:	89 d0                	mov    %edx,%eax
  801da7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dac:	c1 e8 0c             	shr    $0xc,%eax
  801daf:	c7 04 85 60 a2 88 00 	movl   $0x0,0x88a260(,%eax,4)
  801db6:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801dba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	83 ec 08             	sub    $0x8,%esp
  801dc3:	52                   	push   %edx
  801dc4:	50                   	push   %eax
  801dc5:	e8 1a 08 00 00       	call   8025e4 <sys_free_user_mem>
  801dca:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801dcd:	ff 45 f4             	incl   -0xc(%ebp)
  801dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801dd6:	72 b6                	jb     801d8e <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801dd8:	eb 17                	jmp    801df1 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801dda:	83 ec 04             	sub    $0x4,%esp
  801ddd:	68 18 4f 80 00       	push   $0x804f18
  801de2:	68 87 00 00 00       	push   $0x87
  801de7:	68 42 4f 80 00       	push   $0x804f42
  801dec:	e8 78 ec ff ff       	call   800a69 <_panic>
	}
}
  801df1:	90                   	nop
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 28             	sub    $0x28,%esp
  801dfa:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfd:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801e00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e04:	75 0a                	jne    801e10 <smalloc+0x1c>
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0b:	e9 87 00 00 00       	jmp    801e97 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e16:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e23:	39 d0                	cmp    %edx,%eax
  801e25:	73 02                	jae    801e29 <smalloc+0x35>
  801e27:	89 d0                	mov    %edx,%eax
  801e29:	83 ec 0c             	sub    $0xc,%esp
  801e2c:	50                   	push   %eax
  801e2d:	e8 a4 fc ff ff       	call   801ad6 <malloc>
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e38:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e3c:	75 07                	jne    801e45 <smalloc+0x51>
  801e3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e43:	eb 52                	jmp    801e97 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e45:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e49:	ff 75 ec             	pushl  -0x14(%ebp)
  801e4c:	50                   	push   %eax
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	ff 75 08             	pushl  0x8(%ebp)
  801e53:	e8 93 03 00 00       	call   8021eb <sys_createSharedObject>
  801e58:	83 c4 10             	add    $0x10,%esp
  801e5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e5e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e62:	74 06                	je     801e6a <smalloc+0x76>
  801e64:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e68:	75 07                	jne    801e71 <smalloc+0x7d>
  801e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6f:	eb 26                	jmp    801e97 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801e71:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e74:	a1 20 60 80 00       	mov    0x806020,%eax
  801e79:	8b 40 78             	mov    0x78(%eax),%eax
  801e7c:	29 c2                	sub    %eax,%edx
  801e7e:	89 d0                	mov    %edx,%eax
  801e80:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e85:	c1 e8 0c             	shr    $0xc,%eax
  801e88:	89 c2                	mov    %eax,%edx
  801e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e8d:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	 return ptr;
  801e94:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e9f:	83 ec 08             	sub    $0x8,%esp
  801ea2:	ff 75 0c             	pushl  0xc(%ebp)
  801ea5:	ff 75 08             	pushl  0x8(%ebp)
  801ea8:	e8 68 03 00 00       	call   802215 <sys_getSizeOfSharedObject>
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801eb3:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801eb7:	75 07                	jne    801ec0 <sget+0x27>
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebe:	eb 7f                	jmp    801f3f <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ec6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ecd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed3:	39 d0                	cmp    %edx,%eax
  801ed5:	73 02                	jae    801ed9 <sget+0x40>
  801ed7:	89 d0                	mov    %edx,%eax
  801ed9:	83 ec 0c             	sub    $0xc,%esp
  801edc:	50                   	push   %eax
  801edd:	e8 f4 fb ff ff       	call   801ad6 <malloc>
  801ee2:	83 c4 10             	add    $0x10,%esp
  801ee5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801ee8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801eec:	75 07                	jne    801ef5 <sget+0x5c>
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef3:	eb 4a                	jmp    801f3f <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801ef5:	83 ec 04             	sub    $0x4,%esp
  801ef8:	ff 75 e8             	pushl  -0x18(%ebp)
  801efb:	ff 75 0c             	pushl  0xc(%ebp)
  801efe:	ff 75 08             	pushl  0x8(%ebp)
  801f01:	e8 2c 03 00 00       	call   802232 <sys_getSharedObject>
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801f0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f0f:	a1 20 60 80 00       	mov    0x806020,%eax
  801f14:	8b 40 78             	mov    0x78(%eax),%eax
  801f17:	29 c2                	sub    %eax,%edx
  801f19:	89 d0                	mov    %edx,%eax
  801f1b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f20:	c1 e8 0c             	shr    $0xc,%eax
  801f23:	89 c2                	mov    %eax,%edx
  801f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f28:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801f2f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f33:	75 07                	jne    801f3c <sget+0xa3>
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3a:	eb 03                	jmp    801f3f <sget+0xa6>
	return ptr;
  801f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801f47:	8b 55 08             	mov    0x8(%ebp),%edx
  801f4a:	a1 20 60 80 00       	mov    0x806020,%eax
  801f4f:	8b 40 78             	mov    0x78(%eax),%eax
  801f52:	29 c2                	sub    %eax,%edx
  801f54:	89 d0                	mov    %edx,%eax
  801f56:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f5b:	c1 e8 0c             	shr    $0xc,%eax
  801f5e:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
  801f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801f68:	83 ec 08             	sub    $0x8,%esp
  801f6b:	ff 75 08             	pushl  0x8(%ebp)
  801f6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f71:	e8 db 02 00 00       	call   802251 <sys_freeSharedObject>
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801f7c:	90                   	nop
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f85:	83 ec 04             	sub    $0x4,%esp
  801f88:	68 50 4f 80 00       	push   $0x804f50
  801f8d:	68 e4 00 00 00       	push   $0xe4
  801f92:	68 42 4f 80 00       	push   $0x804f42
  801f97:	e8 cd ea ff ff       	call   800a69 <_panic>

00801f9c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	68 76 4f 80 00       	push   $0x804f76
  801faa:	68 f0 00 00 00       	push   $0xf0
  801faf:	68 42 4f 80 00       	push   $0x804f42
  801fb4:	e8 b0 ea ff ff       	call   800a69 <_panic>

00801fb9 <shrink>:

}
void shrink(uint32 newSize)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fbf:	83 ec 04             	sub    $0x4,%esp
  801fc2:	68 76 4f 80 00       	push   $0x804f76
  801fc7:	68 f5 00 00 00       	push   $0xf5
  801fcc:	68 42 4f 80 00       	push   $0x804f42
  801fd1:	e8 93 ea ff ff       	call   800a69 <_panic>

00801fd6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fdc:	83 ec 04             	sub    $0x4,%esp
  801fdf:	68 76 4f 80 00       	push   $0x804f76
  801fe4:	68 fa 00 00 00       	push   $0xfa
  801fe9:	68 42 4f 80 00       	push   $0x804f42
  801fee:	e8 76 ea ff ff       	call   800a69 <_panic>

00801ff3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	57                   	push   %edi
  801ff7:	56                   	push   %esi
  801ff8:	53                   	push   %ebx
  801ff9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802002:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802005:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802008:	8b 7d 18             	mov    0x18(%ebp),%edi
  80200b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80200e:	cd 30                	int    $0x30
  802010:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802013:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802016:	83 c4 10             	add    $0x10,%esp
  802019:	5b                   	pop    %ebx
  80201a:	5e                   	pop    %esi
  80201b:	5f                   	pop    %edi
  80201c:	5d                   	pop    %ebp
  80201d:	c3                   	ret    

0080201e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 04             	sub    $0x4,%esp
  802024:	8b 45 10             	mov    0x10(%ebp),%eax
  802027:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80202a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	52                   	push   %edx
  802036:	ff 75 0c             	pushl  0xc(%ebp)
  802039:	50                   	push   %eax
  80203a:	6a 00                	push   $0x0
  80203c:	e8 b2 ff ff ff       	call   801ff3 <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
}
  802044:	90                   	nop
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_cgetc>:

int
sys_cgetc(void)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 02                	push   $0x2
  802056:	e8 98 ff ff ff       	call   801ff3 <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 03                	push   $0x3
  80206f:	e8 7f ff ff ff       	call   801ff3 <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	90                   	nop
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 04                	push   $0x4
  802089:	e8 65 ff ff ff       	call   801ff3 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
}
  802091:	90                   	nop
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802097:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	52                   	push   %edx
  8020a4:	50                   	push   %eax
  8020a5:	6a 08                	push   $0x8
  8020a7:	e8 47 ff ff ff       	call   801ff3 <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	56                   	push   %esi
  8020b5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020b6:	8b 75 18             	mov    0x18(%ebp),%esi
  8020b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	56                   	push   %esi
  8020c6:	53                   	push   %ebx
  8020c7:	51                   	push   %ecx
  8020c8:	52                   	push   %edx
  8020c9:	50                   	push   %eax
  8020ca:	6a 09                	push   $0x9
  8020cc:	e8 22 ff ff ff       	call   801ff3 <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d7:	5b                   	pop    %ebx
  8020d8:	5e                   	pop    %esi
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    

008020db <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	52                   	push   %edx
  8020eb:	50                   	push   %eax
  8020ec:	6a 0a                	push   $0xa
  8020ee:	e8 00 ff ff ff       	call   801ff3 <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	ff 75 0c             	pushl  0xc(%ebp)
  802104:	ff 75 08             	pushl  0x8(%ebp)
  802107:	6a 0b                	push   $0xb
  802109:	e8 e5 fe ff ff       	call   801ff3 <syscall>
  80210e:	83 c4 18             	add    $0x18,%esp
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 0c                	push   $0xc
  802122:	e8 cc fe ff ff       	call   801ff3 <syscall>
  802127:	83 c4 18             	add    $0x18,%esp
}
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 0d                	push   $0xd
  80213b:	e8 b3 fe ff ff       	call   801ff3 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 0e                	push   $0xe
  802154:	e8 9a fe ff ff       	call   801ff3 <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 0f                	push   $0xf
  80216d:	e8 81 fe ff ff       	call   801ff3 <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	ff 75 08             	pushl  0x8(%ebp)
  802185:	6a 10                	push   $0x10
  802187:	e8 67 fe ff ff       	call   801ff3 <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 11                	push   $0x11
  8021a0:	e8 4e fe ff ff       	call   801ff3 <syscall>
  8021a5:	83 c4 18             	add    $0x18,%esp
}
  8021a8:	90                   	nop
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_cputc>:

void
sys_cputc(const char c)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021b7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	50                   	push   %eax
  8021c4:	6a 01                	push   $0x1
  8021c6:	e8 28 fe ff ff       	call   801ff3 <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
}
  8021ce:	90                   	nop
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 14                	push   $0x14
  8021e0:	e8 0e fe ff ff       	call   801ff3 <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
}
  8021e8:	90                   	nop
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 04             	sub    $0x4,%esp
  8021f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021f7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021fa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	6a 00                	push   $0x0
  802203:	51                   	push   %ecx
  802204:	52                   	push   %edx
  802205:	ff 75 0c             	pushl  0xc(%ebp)
  802208:	50                   	push   %eax
  802209:	6a 15                	push   $0x15
  80220b:	e8 e3 fd ff ff       	call   801ff3 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802218:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	52                   	push   %edx
  802225:	50                   	push   %eax
  802226:	6a 16                	push   $0x16
  802228:	e8 c6 fd ff ff       	call   801ff3 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802235:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	51                   	push   %ecx
  802243:	52                   	push   %edx
  802244:	50                   	push   %eax
  802245:	6a 17                	push   $0x17
  802247:	e8 a7 fd ff ff       	call   801ff3 <syscall>
  80224c:	83 c4 18             	add    $0x18,%esp
}
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802254:	8b 55 0c             	mov    0xc(%ebp),%edx
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	52                   	push   %edx
  802261:	50                   	push   %eax
  802262:	6a 18                	push   $0x18
  802264:	e8 8a fd ff ff       	call   801ff3 <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	6a 00                	push   $0x0
  802276:	ff 75 14             	pushl  0x14(%ebp)
  802279:	ff 75 10             	pushl  0x10(%ebp)
  80227c:	ff 75 0c             	pushl  0xc(%ebp)
  80227f:	50                   	push   %eax
  802280:	6a 19                	push   $0x19
  802282:	e8 6c fd ff ff       	call   801ff3 <syscall>
  802287:	83 c4 18             	add    $0x18,%esp
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	50                   	push   %eax
  80229b:	6a 1a                	push   $0x1a
  80229d:	e8 51 fd ff ff       	call   801ff3 <syscall>
  8022a2:	83 c4 18             	add    $0x18,%esp
}
  8022a5:	90                   	nop
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	50                   	push   %eax
  8022b7:	6a 1b                	push   $0x1b
  8022b9:	e8 35 fd ff ff       	call   801ff3 <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 05                	push   $0x5
  8022d2:	e8 1c fd ff ff       	call   801ff3 <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 06                	push   $0x6
  8022eb:	e8 03 fd ff ff       	call   801ff3 <syscall>
  8022f0:	83 c4 18             	add    $0x18,%esp
}
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 07                	push   $0x7
  802304:	e8 ea fc ff ff       	call   801ff3 <syscall>
  802309:	83 c4 18             	add    $0x18,%esp
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <sys_exit_env>:


void sys_exit_env(void)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 1c                	push   $0x1c
  80231d:	e8 d1 fc ff ff       	call   801ff3 <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
}
  802325:	90                   	nop
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80232e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802331:	8d 50 04             	lea    0x4(%eax),%edx
  802334:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	52                   	push   %edx
  80233e:	50                   	push   %eax
  80233f:	6a 1d                	push   $0x1d
  802341:	e8 ad fc ff ff       	call   801ff3 <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
	return result;
  802349:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80234c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80234f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802352:	89 01                	mov    %eax,(%ecx)
  802354:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	c9                   	leave  
  80235b:	c2 04 00             	ret    $0x4

0080235e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	ff 75 10             	pushl  0x10(%ebp)
  802368:	ff 75 0c             	pushl  0xc(%ebp)
  80236b:	ff 75 08             	pushl  0x8(%ebp)
  80236e:	6a 13                	push   $0x13
  802370:	e8 7e fc ff ff       	call   801ff3 <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
	return ;
  802378:	90                   	nop
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <sys_rcr2>:
uint32 sys_rcr2()
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 1e                	push   $0x1e
  80238a:	e8 64 fc ff ff       	call   801ff3 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	83 ec 04             	sub    $0x4,%esp
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023a0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	50                   	push   %eax
  8023ad:	6a 1f                	push   $0x1f
  8023af:	e8 3f fc ff ff       	call   801ff3 <syscall>
  8023b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b7:	90                   	nop
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <rsttst>:
void rsttst()
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 21                	push   $0x21
  8023c9:	e8 25 fc ff ff       	call   801ff3 <syscall>
  8023ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d1:	90                   	nop
}
  8023d2:	c9                   	leave  
  8023d3:	c3                   	ret    

008023d4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	8b 45 14             	mov    0x14(%ebp),%eax
  8023dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023e0:	8b 55 18             	mov    0x18(%ebp),%edx
  8023e3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023e7:	52                   	push   %edx
  8023e8:	50                   	push   %eax
  8023e9:	ff 75 10             	pushl  0x10(%ebp)
  8023ec:	ff 75 0c             	pushl  0xc(%ebp)
  8023ef:	ff 75 08             	pushl  0x8(%ebp)
  8023f2:	6a 20                	push   $0x20
  8023f4:	e8 fa fb ff ff       	call   801ff3 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8023fc:	90                   	nop
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <chktst>:
void chktst(uint32 n)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	ff 75 08             	pushl  0x8(%ebp)
  80240d:	6a 22                	push   $0x22
  80240f:	e8 df fb ff ff       	call   801ff3 <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
	return ;
  802417:	90                   	nop
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <inctst>:

void inctst()
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 23                	push   $0x23
  802429:	e8 c5 fb ff ff       	call   801ff3 <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
	return ;
  802431:	90                   	nop
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <gettst>:
uint32 gettst()
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 24                	push   $0x24
  802443:	e8 ab fb ff ff       	call   801ff3 <syscall>
  802448:	83 c4 18             	add    $0x18,%esp
}
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
  802450:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 25                	push   $0x25
  80245f:	e8 8f fb ff ff       	call   801ff3 <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
  802467:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80246a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80246e:	75 07                	jne    802477 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802470:	b8 01 00 00 00       	mov    $0x1,%eax
  802475:	eb 05                	jmp    80247c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 25                	push   $0x25
  802490:	e8 5e fb ff ff       	call   801ff3 <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
  802498:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80249b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80249f:	75 07                	jne    8024a8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a6:	eb 05                	jmp    8024ad <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
  8024b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 25                	push   $0x25
  8024c1:	e8 2d fb ff ff       	call   801ff3 <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
  8024c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024cc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024d0:	75 07                	jne    8024d9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d7:	eb 05                	jmp    8024de <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 25                	push   $0x25
  8024f2:	e8 fc fa ff ff       	call   801ff3 <syscall>
  8024f7:	83 c4 18             	add    $0x18,%esp
  8024fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024fd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802501:	75 07                	jne    80250a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802503:	b8 01 00 00 00       	mov    $0x1,%eax
  802508:	eb 05                	jmp    80250f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80250a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	ff 75 08             	pushl  0x8(%ebp)
  80251f:	6a 26                	push   $0x26
  802521:	e8 cd fa ff ff       	call   801ff3 <syscall>
  802526:	83 c4 18             	add    $0x18,%esp
	return ;
  802529:	90                   	nop
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802530:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802533:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802536:	8b 55 0c             	mov    0xc(%ebp),%edx
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	6a 00                	push   $0x0
  80253e:	53                   	push   %ebx
  80253f:	51                   	push   %ecx
  802540:	52                   	push   %edx
  802541:	50                   	push   %eax
  802542:	6a 27                	push   $0x27
  802544:	e8 aa fa ff ff       	call   801ff3 <syscall>
  802549:	83 c4 18             	add    $0x18,%esp
}
  80254c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802554:	8b 55 0c             	mov    0xc(%ebp),%edx
  802557:	8b 45 08             	mov    0x8(%ebp),%eax
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	52                   	push   %edx
  802561:	50                   	push   %eax
  802562:	6a 28                	push   $0x28
  802564:	e8 8a fa ff ff       	call   801ff3 <syscall>
  802569:	83 c4 18             	add    $0x18,%esp
}
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802571:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802574:	8b 55 0c             	mov    0xc(%ebp),%edx
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	6a 00                	push   $0x0
  80257c:	51                   	push   %ecx
  80257d:	ff 75 10             	pushl  0x10(%ebp)
  802580:	52                   	push   %edx
  802581:	50                   	push   %eax
  802582:	6a 29                	push   $0x29
  802584:	e8 6a fa ff ff       	call   801ff3 <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
}
  80258c:	c9                   	leave  
  80258d:	c3                   	ret    

0080258e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	ff 75 10             	pushl  0x10(%ebp)
  802598:	ff 75 0c             	pushl  0xc(%ebp)
  80259b:	ff 75 08             	pushl  0x8(%ebp)
  80259e:	6a 12                	push   $0x12
  8025a0:	e8 4e fa ff ff       	call   801ff3 <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a8:	90                   	nop
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8025ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	52                   	push   %edx
  8025bb:	50                   	push   %eax
  8025bc:	6a 2a                	push   $0x2a
  8025be:	e8 30 fa ff ff       	call   801ff3 <syscall>
  8025c3:	83 c4 18             	add    $0x18,%esp
	return;
  8025c6:	90                   	nop
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8025cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	50                   	push   %eax
  8025d8:	6a 2b                	push   $0x2b
  8025da:	e8 14 fa ff ff       	call   801ff3 <syscall>
  8025df:	83 c4 18             	add    $0x18,%esp
}
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	ff 75 0c             	pushl  0xc(%ebp)
  8025f0:	ff 75 08             	pushl  0x8(%ebp)
  8025f3:	6a 2c                	push   $0x2c
  8025f5:	e8 f9 f9 ff ff       	call   801ff3 <syscall>
  8025fa:	83 c4 18             	add    $0x18,%esp
	return;
  8025fd:	90                   	nop
}
  8025fe:	c9                   	leave  
  8025ff:	c3                   	ret    

00802600 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	ff 75 0c             	pushl  0xc(%ebp)
  80260c:	ff 75 08             	pushl  0x8(%ebp)
  80260f:	6a 2d                	push   $0x2d
  802611:	e8 dd f9 ff ff       	call   801ff3 <syscall>
  802616:	83 c4 18             	add    $0x18,%esp
	return;
  802619:	90                   	nop
}
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 2e                	push   $0x2e
  80262e:	e8 c0 f9 ff ff       	call   801ff3 <syscall>
  802633:	83 c4 18             	add    $0x18,%esp
  802636:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802639:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  802641:	8b 45 08             	mov    0x8(%ebp),%eax
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	50                   	push   %eax
  80264d:	6a 2f                	push   $0x2f
  80264f:	e8 9f f9 ff ff       	call   801ff3 <syscall>
  802654:	83 c4 18             	add    $0x18,%esp
	return;
  802657:	90                   	nop
}
  802658:	c9                   	leave  
  802659:	c3                   	ret    

0080265a <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  80265d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	52                   	push   %edx
  80266a:	50                   	push   %eax
  80266b:	6a 30                	push   $0x30
  80266d:	e8 81 f9 ff ff       	call   801ff3 <syscall>
  802672:	83 c4 18             	add    $0x18,%esp
	return;
  802675:	90                   	nop
}
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  80267e:	8b 45 08             	mov    0x8(%ebp),%eax
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	50                   	push   %eax
  80268a:	6a 31                	push   $0x31
  80268c:	e8 62 f9 ff ff       	call   801ff3 <syscall>
  802691:	83 c4 18             	add    $0x18,%esp
  802694:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802697:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80269a:	c9                   	leave  
  80269b:	c3                   	ret    

0080269c <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  80269f:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	50                   	push   %eax
  8026ab:	6a 32                	push   $0x32
  8026ad:	e8 41 f9 ff ff       	call   801ff3 <syscall>
  8026b2:	83 c4 18             	add    $0x18,%esp
	return;
  8026b5:	90                   	nop
}
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

008026b8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
  8026bb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8026be:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c1:	83 e8 04             	sub    $0x4,%eax
  8026c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8026c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
  8026d4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8026d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026da:	83 e8 04             	sub    $0x4,%eax
  8026dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8026e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026e3:	8b 00                	mov    (%eax),%eax
  8026e5:	83 e0 01             	and    $0x1,%eax
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	0f 94 c0             	sete   %al
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
  8026f2:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8026f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8026fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ff:	83 f8 02             	cmp    $0x2,%eax
  802702:	74 2b                	je     80272f <alloc_block+0x40>
  802704:	83 f8 02             	cmp    $0x2,%eax
  802707:	7f 07                	jg     802710 <alloc_block+0x21>
  802709:	83 f8 01             	cmp    $0x1,%eax
  80270c:	74 0e                	je     80271c <alloc_block+0x2d>
  80270e:	eb 58                	jmp    802768 <alloc_block+0x79>
  802710:	83 f8 03             	cmp    $0x3,%eax
  802713:	74 2d                	je     802742 <alloc_block+0x53>
  802715:	83 f8 04             	cmp    $0x4,%eax
  802718:	74 3b                	je     802755 <alloc_block+0x66>
  80271a:	eb 4c                	jmp    802768 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80271c:	83 ec 0c             	sub    $0xc,%esp
  80271f:	ff 75 08             	pushl  0x8(%ebp)
  802722:	e8 11 03 00 00       	call   802a38 <alloc_block_FF>
  802727:	83 c4 10             	add    $0x10,%esp
  80272a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80272d:	eb 4a                	jmp    802779 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80272f:	83 ec 0c             	sub    $0xc,%esp
  802732:	ff 75 08             	pushl  0x8(%ebp)
  802735:	e8 c7 19 00 00       	call   804101 <alloc_block_NF>
  80273a:	83 c4 10             	add    $0x10,%esp
  80273d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802740:	eb 37                	jmp    802779 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802742:	83 ec 0c             	sub    $0xc,%esp
  802745:	ff 75 08             	pushl  0x8(%ebp)
  802748:	e8 a7 07 00 00       	call   802ef4 <alloc_block_BF>
  80274d:	83 c4 10             	add    $0x10,%esp
  802750:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802753:	eb 24                	jmp    802779 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802755:	83 ec 0c             	sub    $0xc,%esp
  802758:	ff 75 08             	pushl  0x8(%ebp)
  80275b:	e8 84 19 00 00       	call   8040e4 <alloc_block_WF>
  802760:	83 c4 10             	add    $0x10,%esp
  802763:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802766:	eb 11                	jmp    802779 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802768:	83 ec 0c             	sub    $0xc,%esp
  80276b:	68 88 4f 80 00       	push   $0x804f88
  802770:	e8 b1 e5 ff ff       	call   800d26 <cprintf>
  802775:	83 c4 10             	add    $0x10,%esp
		break;
  802778:	90                   	nop
	}
	return va;
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80277c:	c9                   	leave  
  80277d:	c3                   	ret    

0080277e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
  802781:	53                   	push   %ebx
  802782:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802785:	83 ec 0c             	sub    $0xc,%esp
  802788:	68 a8 4f 80 00       	push   $0x804fa8
  80278d:	e8 94 e5 ff ff       	call   800d26 <cprintf>
  802792:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802795:	83 ec 0c             	sub    $0xc,%esp
  802798:	68 d3 4f 80 00       	push   $0x804fd3
  80279d:	e8 84 e5 ff ff       	call   800d26 <cprintf>
  8027a2:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8027a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ab:	eb 37                	jmp    8027e4 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8027ad:	83 ec 0c             	sub    $0xc,%esp
  8027b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8027b3:	e8 19 ff ff ff       	call   8026d1 <is_free_block>
  8027b8:	83 c4 10             	add    $0x10,%esp
  8027bb:	0f be d8             	movsbl %al,%ebx
  8027be:	83 ec 0c             	sub    $0xc,%esp
  8027c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8027c4:	e8 ef fe ff ff       	call   8026b8 <get_block_size>
  8027c9:	83 c4 10             	add    $0x10,%esp
  8027cc:	83 ec 04             	sub    $0x4,%esp
  8027cf:	53                   	push   %ebx
  8027d0:	50                   	push   %eax
  8027d1:	68 eb 4f 80 00       	push   $0x804feb
  8027d6:	e8 4b e5 ff ff       	call   800d26 <cprintf>
  8027db:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8027de:	8b 45 10             	mov    0x10(%ebp),%eax
  8027e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e8:	74 07                	je     8027f1 <print_blocks_list+0x73>
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	eb 05                	jmp    8027f6 <print_blocks_list+0x78>
  8027f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f6:	89 45 10             	mov    %eax,0x10(%ebp)
  8027f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	75 ad                	jne    8027ad <print_blocks_list+0x2f>
  802800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802804:	75 a7                	jne    8027ad <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802806:	83 ec 0c             	sub    $0xc,%esp
  802809:	68 a8 4f 80 00       	push   $0x804fa8
  80280e:	e8 13 e5 ff ff       	call   800d26 <cprintf>
  802813:	83 c4 10             	add    $0x10,%esp

}
  802816:	90                   	nop
  802817:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80281a:	c9                   	leave  
  80281b:	c3                   	ret    

0080281c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80281c:	55                   	push   %ebp
  80281d:	89 e5                	mov    %esp,%ebp
  80281f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802822:	8b 45 0c             	mov    0xc(%ebp),%eax
  802825:	83 e0 01             	and    $0x1,%eax
  802828:	85 c0                	test   %eax,%eax
  80282a:	74 03                	je     80282f <initialize_dynamic_allocator+0x13>
  80282c:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80282f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802833:	0f 84 c7 01 00 00    	je     802a00 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802839:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802840:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802843:	8b 55 08             	mov    0x8(%ebp),%edx
  802846:	8b 45 0c             	mov    0xc(%ebp),%eax
  802849:	01 d0                	add    %edx,%eax
  80284b:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802850:	0f 87 ad 01 00 00    	ja     802a03 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	85 c0                	test   %eax,%eax
  80285b:	0f 89 a5 01 00 00    	jns    802a06 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802861:	8b 55 08             	mov    0x8(%ebp),%edx
  802864:	8b 45 0c             	mov    0xc(%ebp),%eax
  802867:	01 d0                	add    %edx,%eax
  802869:	83 e8 04             	sub    $0x4,%eax
  80286c:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  802871:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802878:	a1 44 60 80 00       	mov    0x806044,%eax
  80287d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802880:	e9 87 00 00 00       	jmp    80290c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802889:	75 14                	jne    80289f <initialize_dynamic_allocator+0x83>
  80288b:	83 ec 04             	sub    $0x4,%esp
  80288e:	68 03 50 80 00       	push   $0x805003
  802893:	6a 79                	push   $0x79
  802895:	68 21 50 80 00       	push   $0x805021
  80289a:	e8 ca e1 ff ff       	call   800a69 <_panic>
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	74 10                	je     8028b8 <initialize_dynamic_allocator+0x9c>
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b0:	8b 52 04             	mov    0x4(%edx),%edx
  8028b3:	89 50 04             	mov    %edx,0x4(%eax)
  8028b6:	eb 0b                	jmp    8028c3 <initialize_dynamic_allocator+0xa7>
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	a3 48 60 80 00       	mov    %eax,0x806048
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	74 0f                	je     8028dc <initialize_dynamic_allocator+0xc0>
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 40 04             	mov    0x4(%eax),%eax
  8028d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d6:	8b 12                	mov    (%edx),%edx
  8028d8:	89 10                	mov    %edx,(%eax)
  8028da:	eb 0a                	jmp    8028e6 <initialize_dynamic_allocator+0xca>
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	a3 44 60 80 00       	mov    %eax,0x806044
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f9:	a1 50 60 80 00       	mov    0x806050,%eax
  8028fe:	48                   	dec    %eax
  8028ff:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802904:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802909:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802910:	74 07                	je     802919 <initialize_dynamic_allocator+0xfd>
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	eb 05                	jmp    80291e <initialize_dynamic_allocator+0x102>
  802919:	b8 00 00 00 00       	mov    $0x0,%eax
  80291e:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802923:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802928:	85 c0                	test   %eax,%eax
  80292a:	0f 85 55 ff ff ff    	jne    802885 <initialize_dynamic_allocator+0x69>
  802930:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802934:	0f 85 4b ff ff ff    	jne    802885 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802943:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802949:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  80294e:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  802953:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802958:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	83 c0 08             	add    $0x8,%eax
  802964:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	83 c0 04             	add    $0x4,%eax
  80296d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802970:	83 ea 08             	sub    $0x8,%edx
  802973:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802975:	8b 55 0c             	mov    0xc(%ebp),%edx
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	01 d0                	add    %edx,%eax
  80297d:	83 e8 08             	sub    $0x8,%eax
  802980:	8b 55 0c             	mov    0xc(%ebp),%edx
  802983:	83 ea 08             	sub    $0x8,%edx
  802986:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802988:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802991:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802994:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80299b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80299f:	75 17                	jne    8029b8 <initialize_dynamic_allocator+0x19c>
  8029a1:	83 ec 04             	sub    $0x4,%esp
  8029a4:	68 3c 50 80 00       	push   $0x80503c
  8029a9:	68 90 00 00 00       	push   $0x90
  8029ae:	68 21 50 80 00       	push   $0x805021
  8029b3:	e8 b1 e0 ff ff       	call   800a69 <_panic>
  8029b8:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8029be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c1:	89 10                	mov    %edx,(%eax)
  8029c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c6:	8b 00                	mov    (%eax),%eax
  8029c8:	85 c0                	test   %eax,%eax
  8029ca:	74 0d                	je     8029d9 <initialize_dynamic_allocator+0x1bd>
  8029cc:	a1 44 60 80 00       	mov    0x806044,%eax
  8029d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d4:	89 50 04             	mov    %edx,0x4(%eax)
  8029d7:	eb 08                	jmp    8029e1 <initialize_dynamic_allocator+0x1c5>
  8029d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dc:	a3 48 60 80 00       	mov    %eax,0x806048
  8029e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e4:	a3 44 60 80 00       	mov    %eax,0x806044
  8029e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f3:	a1 50 60 80 00       	mov    0x806050,%eax
  8029f8:	40                   	inc    %eax
  8029f9:	a3 50 60 80 00       	mov    %eax,0x806050
  8029fe:	eb 07                	jmp    802a07 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802a00:	90                   	nop
  802a01:	eb 04                	jmp    802a07 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802a03:	90                   	nop
  802a04:	eb 01                	jmp    802a07 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a06:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a07:	c9                   	leave  
  802a08:	c3                   	ret    

00802a09 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a09:	55                   	push   %ebp
  802a0a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  802a0f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a1b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	83 e8 04             	sub    $0x4,%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	83 e0 fe             	and    $0xfffffffe,%eax
  802a28:	8d 50 f8             	lea    -0x8(%eax),%edx
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	01 c2                	add    %eax,%edx
  802a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a33:	89 02                	mov    %eax,(%edx)
}
  802a35:	90                   	nop
  802a36:	5d                   	pop    %ebp
  802a37:	c3                   	ret    

00802a38 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802a38:	55                   	push   %ebp
  802a39:	89 e5                	mov    %esp,%ebp
  802a3b:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	83 e0 01             	and    $0x1,%eax
  802a44:	85 c0                	test   %eax,%eax
  802a46:	74 03                	je     802a4b <alloc_block_FF+0x13>
  802a48:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a4b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a4f:	77 07                	ja     802a58 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a51:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a58:	a1 24 60 80 00       	mov    0x806024,%eax
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	75 73                	jne    802ad4 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	83 c0 10             	add    $0x10,%eax
  802a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a6a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a77:	01 d0                	add    %edx,%eax
  802a79:	48                   	dec    %eax
  802a7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a80:	ba 00 00 00 00       	mov    $0x0,%edx
  802a85:	f7 75 ec             	divl   -0x14(%ebp)
  802a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8b:	29 d0                	sub    %edx,%eax
  802a8d:	c1 e8 0c             	shr    $0xc,%eax
  802a90:	83 ec 0c             	sub    $0xc,%esp
  802a93:	50                   	push   %eax
  802a94:	e8 27 f0 ff ff       	call   801ac0 <sbrk>
  802a99:	83 c4 10             	add    $0x10,%esp
  802a9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a9f:	83 ec 0c             	sub    $0xc,%esp
  802aa2:	6a 00                	push   $0x0
  802aa4:	e8 17 f0 ff ff       	call   801ac0 <sbrk>
  802aa9:	83 c4 10             	add    $0x10,%esp
  802aac:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802aaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802ab5:	83 ec 08             	sub    $0x8,%esp
  802ab8:	50                   	push   %eax
  802ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
  802abc:	e8 5b fd ff ff       	call   80281c <initialize_dynamic_allocator>
  802ac1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ac4:	83 ec 0c             	sub    $0xc,%esp
  802ac7:	68 5f 50 80 00       	push   $0x80505f
  802acc:	e8 55 e2 ff ff       	call   800d26 <cprintf>
  802ad1:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802ad4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad8:	75 0a                	jne    802ae4 <alloc_block_FF+0xac>
	        return NULL;
  802ada:	b8 00 00 00 00       	mov    $0x0,%eax
  802adf:	e9 0e 04 00 00       	jmp    802ef2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802ae4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802aeb:	a1 44 60 80 00       	mov    0x806044,%eax
  802af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af3:	e9 f3 02 00 00       	jmp    802deb <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802afe:	83 ec 0c             	sub    $0xc,%esp
  802b01:	ff 75 bc             	pushl  -0x44(%ebp)
  802b04:	e8 af fb ff ff       	call   8026b8 <get_block_size>
  802b09:	83 c4 10             	add    $0x10,%esp
  802b0c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b12:	83 c0 08             	add    $0x8,%eax
  802b15:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b18:	0f 87 c5 02 00 00    	ja     802de3 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	83 c0 18             	add    $0x18,%eax
  802b24:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b27:	0f 87 19 02 00 00    	ja     802d46 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802b2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b30:	2b 45 08             	sub    0x8(%ebp),%eax
  802b33:	83 e8 08             	sub    $0x8,%eax
  802b36:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	8d 50 08             	lea    0x8(%eax),%edx
  802b3f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b42:	01 d0                	add    %edx,%eax
  802b44:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	83 c0 08             	add    $0x8,%eax
  802b4d:	83 ec 04             	sub    $0x4,%esp
  802b50:	6a 01                	push   $0x1
  802b52:	50                   	push   %eax
  802b53:	ff 75 bc             	pushl  -0x44(%ebp)
  802b56:	e8 ae fe ff ff       	call   802a09 <set_block_data>
  802b5b:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 40 04             	mov    0x4(%eax),%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	75 68                	jne    802bd0 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b68:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b6c:	75 17                	jne    802b85 <alloc_block_FF+0x14d>
  802b6e:	83 ec 04             	sub    $0x4,%esp
  802b71:	68 3c 50 80 00       	push   $0x80503c
  802b76:	68 d7 00 00 00       	push   $0xd7
  802b7b:	68 21 50 80 00       	push   $0x805021
  802b80:	e8 e4 de ff ff       	call   800a69 <_panic>
  802b85:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802b8b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b8e:	89 10                	mov    %edx,(%eax)
  802b90:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	74 0d                	je     802ba6 <alloc_block_FF+0x16e>
  802b99:	a1 44 60 80 00       	mov    0x806044,%eax
  802b9e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ba1:	89 50 04             	mov    %edx,0x4(%eax)
  802ba4:	eb 08                	jmp    802bae <alloc_block_FF+0x176>
  802ba6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba9:	a3 48 60 80 00       	mov    %eax,0x806048
  802bae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bb1:	a3 44 60 80 00       	mov    %eax,0x806044
  802bb6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc0:	a1 50 60 80 00       	mov    0x806050,%eax
  802bc5:	40                   	inc    %eax
  802bc6:	a3 50 60 80 00       	mov    %eax,0x806050
  802bcb:	e9 dc 00 00 00       	jmp    802cac <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	75 65                	jne    802c3e <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bd9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bdd:	75 17                	jne    802bf6 <alloc_block_FF+0x1be>
  802bdf:	83 ec 04             	sub    $0x4,%esp
  802be2:	68 70 50 80 00       	push   $0x805070
  802be7:	68 db 00 00 00       	push   $0xdb
  802bec:	68 21 50 80 00       	push   $0x805021
  802bf1:	e8 73 de ff ff       	call   800a69 <_panic>
  802bf6:	8b 15 48 60 80 00    	mov    0x806048,%edx
  802bfc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bff:	89 50 04             	mov    %edx,0x4(%eax)
  802c02:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c05:	8b 40 04             	mov    0x4(%eax),%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	74 0c                	je     802c18 <alloc_block_FF+0x1e0>
  802c0c:	a1 48 60 80 00       	mov    0x806048,%eax
  802c11:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c14:	89 10                	mov    %edx,(%eax)
  802c16:	eb 08                	jmp    802c20 <alloc_block_FF+0x1e8>
  802c18:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c1b:	a3 44 60 80 00       	mov    %eax,0x806044
  802c20:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c23:	a3 48 60 80 00       	mov    %eax,0x806048
  802c28:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c31:	a1 50 60 80 00       	mov    0x806050,%eax
  802c36:	40                   	inc    %eax
  802c37:	a3 50 60 80 00       	mov    %eax,0x806050
  802c3c:	eb 6e                	jmp    802cac <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c42:	74 06                	je     802c4a <alloc_block_FF+0x212>
  802c44:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c48:	75 17                	jne    802c61 <alloc_block_FF+0x229>
  802c4a:	83 ec 04             	sub    $0x4,%esp
  802c4d:	68 94 50 80 00       	push   $0x805094
  802c52:	68 df 00 00 00       	push   $0xdf
  802c57:	68 21 50 80 00       	push   $0x805021
  802c5c:	e8 08 de ff ff       	call   800a69 <_panic>
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	8b 10                	mov    (%eax),%edx
  802c66:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c69:	89 10                	mov    %edx,(%eax)
  802c6b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	85 c0                	test   %eax,%eax
  802c72:	74 0b                	je     802c7f <alloc_block_FF+0x247>
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c7c:	89 50 04             	mov    %edx,0x4(%eax)
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c85:	89 10                	mov    %edx,(%eax)
  802c87:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8d:	89 50 04             	mov    %edx,0x4(%eax)
  802c90:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	85 c0                	test   %eax,%eax
  802c97:	75 08                	jne    802ca1 <alloc_block_FF+0x269>
  802c99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c9c:	a3 48 60 80 00       	mov    %eax,0x806048
  802ca1:	a1 50 60 80 00       	mov    0x806050,%eax
  802ca6:	40                   	inc    %eax
  802ca7:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802cac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb0:	75 17                	jne    802cc9 <alloc_block_FF+0x291>
  802cb2:	83 ec 04             	sub    $0x4,%esp
  802cb5:	68 03 50 80 00       	push   $0x805003
  802cba:	68 e1 00 00 00       	push   $0xe1
  802cbf:	68 21 50 80 00       	push   $0x805021
  802cc4:	e8 a0 dd ff ff       	call   800a69 <_panic>
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	8b 00                	mov    (%eax),%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	74 10                	je     802ce2 <alloc_block_FF+0x2aa>
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cda:	8b 52 04             	mov    0x4(%edx),%edx
  802cdd:	89 50 04             	mov    %edx,0x4(%eax)
  802ce0:	eb 0b                	jmp    802ced <alloc_block_FF+0x2b5>
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 40 04             	mov    0x4(%eax),%eax
  802ce8:	a3 48 60 80 00       	mov    %eax,0x806048
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	74 0f                	je     802d06 <alloc_block_FF+0x2ce>
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	8b 40 04             	mov    0x4(%eax),%eax
  802cfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d00:	8b 12                	mov    (%edx),%edx
  802d02:	89 10                	mov    %edx,(%eax)
  802d04:	eb 0a                	jmp    802d10 <alloc_block_FF+0x2d8>
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 00                	mov    (%eax),%eax
  802d0b:	a3 44 60 80 00       	mov    %eax,0x806044
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d23:	a1 50 60 80 00       	mov    0x806050,%eax
  802d28:	48                   	dec    %eax
  802d29:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  802d2e:	83 ec 04             	sub    $0x4,%esp
  802d31:	6a 00                	push   $0x0
  802d33:	ff 75 b4             	pushl  -0x4c(%ebp)
  802d36:	ff 75 b0             	pushl  -0x50(%ebp)
  802d39:	e8 cb fc ff ff       	call   802a09 <set_block_data>
  802d3e:	83 c4 10             	add    $0x10,%esp
  802d41:	e9 95 00 00 00       	jmp    802ddb <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802d46:	83 ec 04             	sub    $0x4,%esp
  802d49:	6a 01                	push   $0x1
  802d4b:	ff 75 b8             	pushl  -0x48(%ebp)
  802d4e:	ff 75 bc             	pushl  -0x44(%ebp)
  802d51:	e8 b3 fc ff ff       	call   802a09 <set_block_data>
  802d56:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802d59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5d:	75 17                	jne    802d76 <alloc_block_FF+0x33e>
  802d5f:	83 ec 04             	sub    $0x4,%esp
  802d62:	68 03 50 80 00       	push   $0x805003
  802d67:	68 e8 00 00 00       	push   $0xe8
  802d6c:	68 21 50 80 00       	push   $0x805021
  802d71:	e8 f3 dc ff ff       	call   800a69 <_panic>
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	85 c0                	test   %eax,%eax
  802d7d:	74 10                	je     802d8f <alloc_block_FF+0x357>
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d87:	8b 52 04             	mov    0x4(%edx),%edx
  802d8a:	89 50 04             	mov    %edx,0x4(%eax)
  802d8d:	eb 0b                	jmp    802d9a <alloc_block_FF+0x362>
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	8b 40 04             	mov    0x4(%eax),%eax
  802d95:	a3 48 60 80 00       	mov    %eax,0x806048
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 40 04             	mov    0x4(%eax),%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	74 0f                	je     802db3 <alloc_block_FF+0x37b>
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 40 04             	mov    0x4(%eax),%eax
  802daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dad:	8b 12                	mov    (%edx),%edx
  802daf:	89 10                	mov    %edx,(%eax)
  802db1:	eb 0a                	jmp    802dbd <alloc_block_FF+0x385>
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	a3 44 60 80 00       	mov    %eax,0x806044
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd0:	a1 50 60 80 00       	mov    0x806050,%eax
  802dd5:	48                   	dec    %eax
  802dd6:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  802ddb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dde:	e9 0f 01 00 00       	jmp    802ef2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802de3:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802deb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802def:	74 07                	je     802df8 <alloc_block_FF+0x3c0>
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 00                	mov    (%eax),%eax
  802df6:	eb 05                	jmp    802dfd <alloc_block_FF+0x3c5>
  802df8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfd:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802e02:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	0f 85 e9 fc ff ff    	jne    802af8 <alloc_block_FF+0xc0>
  802e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e13:	0f 85 df fc ff ff    	jne    802af8 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	83 c0 08             	add    $0x8,%eax
  802e1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e22:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e29:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e2f:	01 d0                	add    %edx,%eax
  802e31:	48                   	dec    %eax
  802e32:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e38:	ba 00 00 00 00       	mov    $0x0,%edx
  802e3d:	f7 75 d8             	divl   -0x28(%ebp)
  802e40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e43:	29 d0                	sub    %edx,%eax
  802e45:	c1 e8 0c             	shr    $0xc,%eax
  802e48:	83 ec 0c             	sub    $0xc,%esp
  802e4b:	50                   	push   %eax
  802e4c:	e8 6f ec ff ff       	call   801ac0 <sbrk>
  802e51:	83 c4 10             	add    $0x10,%esp
  802e54:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802e57:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802e5b:	75 0a                	jne    802e67 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e62:	e9 8b 00 00 00       	jmp    802ef2 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e67:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802e6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e71:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e74:	01 d0                	add    %edx,%eax
  802e76:	48                   	dec    %eax
  802e77:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802e7a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e7d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e82:	f7 75 cc             	divl   -0x34(%ebp)
  802e85:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e88:	29 d0                	sub    %edx,%eax
  802e8a:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e90:	01 d0                	add    %edx,%eax
  802e92:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  802e97:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802e9c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ea2:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ea9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802eaf:	01 d0                	add    %edx,%eax
  802eb1:	48                   	dec    %eax
  802eb2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802eb5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802eb8:	ba 00 00 00 00       	mov    $0x0,%edx
  802ebd:	f7 75 c4             	divl   -0x3c(%ebp)
  802ec0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ec3:	29 d0                	sub    %edx,%eax
  802ec5:	83 ec 04             	sub    $0x4,%esp
  802ec8:	6a 01                	push   $0x1
  802eca:	50                   	push   %eax
  802ecb:	ff 75 d0             	pushl  -0x30(%ebp)
  802ece:	e8 36 fb ff ff       	call   802a09 <set_block_data>
  802ed3:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802ed6:	83 ec 0c             	sub    $0xc,%esp
  802ed9:	ff 75 d0             	pushl  -0x30(%ebp)
  802edc:	e8 f8 09 00 00       	call   8038d9 <free_block>
  802ee1:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802ee4:	83 ec 0c             	sub    $0xc,%esp
  802ee7:	ff 75 08             	pushl  0x8(%ebp)
  802eea:	e8 49 fb ff ff       	call   802a38 <alloc_block_FF>
  802eef:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802ef2:	c9                   	leave  
  802ef3:	c3                   	ret    

00802ef4 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802ef4:	55                   	push   %ebp
  802ef5:	89 e5                	mov    %esp,%ebp
  802ef7:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	83 e0 01             	and    $0x1,%eax
  802f00:	85 c0                	test   %eax,%eax
  802f02:	74 03                	je     802f07 <alloc_block_BF+0x13>
  802f04:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f07:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f0b:	77 07                	ja     802f14 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f0d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f14:	a1 24 60 80 00       	mov    0x806024,%eax
  802f19:	85 c0                	test   %eax,%eax
  802f1b:	75 73                	jne    802f90 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	83 c0 10             	add    $0x10,%eax
  802f23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f26:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802f2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f33:	01 d0                	add    %edx,%eax
  802f35:	48                   	dec    %eax
  802f36:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3c:	ba 00 00 00 00       	mov    $0x0,%edx
  802f41:	f7 75 e0             	divl   -0x20(%ebp)
  802f44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f47:	29 d0                	sub    %edx,%eax
  802f49:	c1 e8 0c             	shr    $0xc,%eax
  802f4c:	83 ec 0c             	sub    $0xc,%esp
  802f4f:	50                   	push   %eax
  802f50:	e8 6b eb ff ff       	call   801ac0 <sbrk>
  802f55:	83 c4 10             	add    $0x10,%esp
  802f58:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802f5b:	83 ec 0c             	sub    $0xc,%esp
  802f5e:	6a 00                	push   $0x0
  802f60:	e8 5b eb ff ff       	call   801ac0 <sbrk>
  802f65:	83 c4 10             	add    $0x10,%esp
  802f68:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802f6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f6e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802f71:	83 ec 08             	sub    $0x8,%esp
  802f74:	50                   	push   %eax
  802f75:	ff 75 d8             	pushl  -0x28(%ebp)
  802f78:	e8 9f f8 ff ff       	call   80281c <initialize_dynamic_allocator>
  802f7d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802f80:	83 ec 0c             	sub    $0xc,%esp
  802f83:	68 5f 50 80 00       	push   $0x80505f
  802f88:	e8 99 dd ff ff       	call   800d26 <cprintf>
  802f8d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802f90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802f97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802f9e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802fa5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802fac:	a1 44 60 80 00       	mov    0x806044,%eax
  802fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb4:	e9 1d 01 00 00       	jmp    8030d6 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802fbf:	83 ec 0c             	sub    $0xc,%esp
  802fc2:	ff 75 a8             	pushl  -0x58(%ebp)
  802fc5:	e8 ee f6 ff ff       	call   8026b8 <get_block_size>
  802fca:	83 c4 10             	add    $0x10,%esp
  802fcd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	83 c0 08             	add    $0x8,%eax
  802fd6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fd9:	0f 87 ef 00 00 00    	ja     8030ce <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	83 c0 18             	add    $0x18,%eax
  802fe5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fe8:	77 1d                	ja     803007 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fed:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ff0:	0f 86 d8 00 00 00    	jbe    8030ce <alloc_block_BF+0x1da>
				{
					best_va = va;
  802ff6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ff9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802ffc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802fff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803002:	e9 c7 00 00 00       	jmp    8030ce <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	83 c0 08             	add    $0x8,%eax
  80300d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803010:	0f 85 9d 00 00 00    	jne    8030b3 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803016:	83 ec 04             	sub    $0x4,%esp
  803019:	6a 01                	push   $0x1
  80301b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80301e:	ff 75 a8             	pushl  -0x58(%ebp)
  803021:	e8 e3 f9 ff ff       	call   802a09 <set_block_data>
  803026:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803029:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302d:	75 17                	jne    803046 <alloc_block_BF+0x152>
  80302f:	83 ec 04             	sub    $0x4,%esp
  803032:	68 03 50 80 00       	push   $0x805003
  803037:	68 2c 01 00 00       	push   $0x12c
  80303c:	68 21 50 80 00       	push   $0x805021
  803041:	e8 23 da ff ff       	call   800a69 <_panic>
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	8b 00                	mov    (%eax),%eax
  80304b:	85 c0                	test   %eax,%eax
  80304d:	74 10                	je     80305f <alloc_block_BF+0x16b>
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	8b 00                	mov    (%eax),%eax
  803054:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803057:	8b 52 04             	mov    0x4(%edx),%edx
  80305a:	89 50 04             	mov    %edx,0x4(%eax)
  80305d:	eb 0b                	jmp    80306a <alloc_block_BF+0x176>
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	8b 40 04             	mov    0x4(%eax),%eax
  803065:	a3 48 60 80 00       	mov    %eax,0x806048
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 40 04             	mov    0x4(%eax),%eax
  803070:	85 c0                	test   %eax,%eax
  803072:	74 0f                	je     803083 <alloc_block_BF+0x18f>
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	8b 40 04             	mov    0x4(%eax),%eax
  80307a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80307d:	8b 12                	mov    (%edx),%edx
  80307f:	89 10                	mov    %edx,(%eax)
  803081:	eb 0a                	jmp    80308d <alloc_block_BF+0x199>
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	a3 44 60 80 00       	mov    %eax,0x806044
  80308d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803090:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a0:	a1 50 60 80 00       	mov    0x806050,%eax
  8030a5:	48                   	dec    %eax
  8030a6:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  8030ab:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030ae:	e9 01 04 00 00       	jmp    8034b4 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030b9:	76 13                	jbe    8030ce <alloc_block_BF+0x1da>
					{
						internal = 1;
  8030bb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8030c2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8030c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8030cb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8030ce:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8030d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030da:	74 07                	je     8030e3 <alloc_block_BF+0x1ef>
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	8b 00                	mov    (%eax),%eax
  8030e1:	eb 05                	jmp    8030e8 <alloc_block_BF+0x1f4>
  8030e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e8:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8030ed:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8030f2:	85 c0                	test   %eax,%eax
  8030f4:	0f 85 bf fe ff ff    	jne    802fb9 <alloc_block_BF+0xc5>
  8030fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030fe:	0f 85 b5 fe ff ff    	jne    802fb9 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803104:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803108:	0f 84 26 02 00 00    	je     803334 <alloc_block_BF+0x440>
  80310e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803112:	0f 85 1c 02 00 00    	jne    803334 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803118:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311b:	2b 45 08             	sub    0x8(%ebp),%eax
  80311e:	83 e8 08             	sub    $0x8,%eax
  803121:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	8d 50 08             	lea    0x8(%eax),%edx
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	01 d0                	add    %edx,%eax
  80312f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	83 c0 08             	add    $0x8,%eax
  803138:	83 ec 04             	sub    $0x4,%esp
  80313b:	6a 01                	push   $0x1
  80313d:	50                   	push   %eax
  80313e:	ff 75 f0             	pushl  -0x10(%ebp)
  803141:	e8 c3 f8 ff ff       	call   802a09 <set_block_data>
  803146:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	8b 40 04             	mov    0x4(%eax),%eax
  80314f:	85 c0                	test   %eax,%eax
  803151:	75 68                	jne    8031bb <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803153:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803157:	75 17                	jne    803170 <alloc_block_BF+0x27c>
  803159:	83 ec 04             	sub    $0x4,%esp
  80315c:	68 3c 50 80 00       	push   $0x80503c
  803161:	68 45 01 00 00       	push   $0x145
  803166:	68 21 50 80 00       	push   $0x805021
  80316b:	e8 f9 d8 ff ff       	call   800a69 <_panic>
  803170:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803176:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803179:	89 10                	mov    %edx,(%eax)
  80317b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80317e:	8b 00                	mov    (%eax),%eax
  803180:	85 c0                	test   %eax,%eax
  803182:	74 0d                	je     803191 <alloc_block_BF+0x29d>
  803184:	a1 44 60 80 00       	mov    0x806044,%eax
  803189:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80318c:	89 50 04             	mov    %edx,0x4(%eax)
  80318f:	eb 08                	jmp    803199 <alloc_block_BF+0x2a5>
  803191:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803194:	a3 48 60 80 00       	mov    %eax,0x806048
  803199:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80319c:	a3 44 60 80 00       	mov    %eax,0x806044
  8031a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ab:	a1 50 60 80 00       	mov    0x806050,%eax
  8031b0:	40                   	inc    %eax
  8031b1:	a3 50 60 80 00       	mov    %eax,0x806050
  8031b6:	e9 dc 00 00 00       	jmp    803297 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8031bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031be:	8b 00                	mov    (%eax),%eax
  8031c0:	85 c0                	test   %eax,%eax
  8031c2:	75 65                	jne    803229 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031c4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031c8:	75 17                	jne    8031e1 <alloc_block_BF+0x2ed>
  8031ca:	83 ec 04             	sub    $0x4,%esp
  8031cd:	68 70 50 80 00       	push   $0x805070
  8031d2:	68 4a 01 00 00       	push   $0x14a
  8031d7:	68 21 50 80 00       	push   $0x805021
  8031dc:	e8 88 d8 ff ff       	call   800a69 <_panic>
  8031e1:	8b 15 48 60 80 00    	mov    0x806048,%edx
  8031e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ea:	89 50 04             	mov    %edx,0x4(%eax)
  8031ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f0:	8b 40 04             	mov    0x4(%eax),%eax
  8031f3:	85 c0                	test   %eax,%eax
  8031f5:	74 0c                	je     803203 <alloc_block_BF+0x30f>
  8031f7:	a1 48 60 80 00       	mov    0x806048,%eax
  8031fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	eb 08                	jmp    80320b <alloc_block_BF+0x317>
  803203:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803206:	a3 44 60 80 00       	mov    %eax,0x806044
  80320b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80320e:	a3 48 60 80 00       	mov    %eax,0x806048
  803213:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803216:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321c:	a1 50 60 80 00       	mov    0x806050,%eax
  803221:	40                   	inc    %eax
  803222:	a3 50 60 80 00       	mov    %eax,0x806050
  803227:	eb 6e                	jmp    803297 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803229:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80322d:	74 06                	je     803235 <alloc_block_BF+0x341>
  80322f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803233:	75 17                	jne    80324c <alloc_block_BF+0x358>
  803235:	83 ec 04             	sub    $0x4,%esp
  803238:	68 94 50 80 00       	push   $0x805094
  80323d:	68 4f 01 00 00       	push   $0x14f
  803242:	68 21 50 80 00       	push   $0x805021
  803247:	e8 1d d8 ff ff       	call   800a69 <_panic>
  80324c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324f:	8b 10                	mov    (%eax),%edx
  803251:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803254:	89 10                	mov    %edx,(%eax)
  803256:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	74 0b                	je     80326a <alloc_block_BF+0x376>
  80325f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803267:	89 50 04             	mov    %edx,0x4(%eax)
  80326a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803270:	89 10                	mov    %edx,(%eax)
  803272:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803275:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803278:	89 50 04             	mov    %edx,0x4(%eax)
  80327b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80327e:	8b 00                	mov    (%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	75 08                	jne    80328c <alloc_block_BF+0x398>
  803284:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803287:	a3 48 60 80 00       	mov    %eax,0x806048
  80328c:	a1 50 60 80 00       	mov    0x806050,%eax
  803291:	40                   	inc    %eax
  803292:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803297:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80329b:	75 17                	jne    8032b4 <alloc_block_BF+0x3c0>
  80329d:	83 ec 04             	sub    $0x4,%esp
  8032a0:	68 03 50 80 00       	push   $0x805003
  8032a5:	68 51 01 00 00       	push   $0x151
  8032aa:	68 21 50 80 00       	push   $0x805021
  8032af:	e8 b5 d7 ff ff       	call   800a69 <_panic>
  8032b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	85 c0                	test   %eax,%eax
  8032bb:	74 10                	je     8032cd <alloc_block_BF+0x3d9>
  8032bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c5:	8b 52 04             	mov    0x4(%edx),%edx
  8032c8:	89 50 04             	mov    %edx,0x4(%eax)
  8032cb:	eb 0b                	jmp    8032d8 <alloc_block_BF+0x3e4>
  8032cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d0:	8b 40 04             	mov    0x4(%eax),%eax
  8032d3:	a3 48 60 80 00       	mov    %eax,0x806048
  8032d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032db:	8b 40 04             	mov    0x4(%eax),%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	74 0f                	je     8032f1 <alloc_block_BF+0x3fd>
  8032e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e5:	8b 40 04             	mov    0x4(%eax),%eax
  8032e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032eb:	8b 12                	mov    (%edx),%edx
  8032ed:	89 10                	mov    %edx,(%eax)
  8032ef:	eb 0a                	jmp    8032fb <alloc_block_BF+0x407>
  8032f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	a3 44 60 80 00       	mov    %eax,0x806044
  8032fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803307:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330e:	a1 50 60 80 00       	mov    0x806050,%eax
  803313:	48                   	dec    %eax
  803314:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  803319:	83 ec 04             	sub    $0x4,%esp
  80331c:	6a 00                	push   $0x0
  80331e:	ff 75 d0             	pushl  -0x30(%ebp)
  803321:	ff 75 cc             	pushl  -0x34(%ebp)
  803324:	e8 e0 f6 ff ff       	call   802a09 <set_block_data>
  803329:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80332c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332f:	e9 80 01 00 00       	jmp    8034b4 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  803334:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803338:	0f 85 9d 00 00 00    	jne    8033db <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80333e:	83 ec 04             	sub    $0x4,%esp
  803341:	6a 01                	push   $0x1
  803343:	ff 75 ec             	pushl  -0x14(%ebp)
  803346:	ff 75 f0             	pushl  -0x10(%ebp)
  803349:	e8 bb f6 ff ff       	call   802a09 <set_block_data>
  80334e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803351:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803355:	75 17                	jne    80336e <alloc_block_BF+0x47a>
  803357:	83 ec 04             	sub    $0x4,%esp
  80335a:	68 03 50 80 00       	push   $0x805003
  80335f:	68 58 01 00 00       	push   $0x158
  803364:	68 21 50 80 00       	push   $0x805021
  803369:	e8 fb d6 ff ff       	call   800a69 <_panic>
  80336e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803371:	8b 00                	mov    (%eax),%eax
  803373:	85 c0                	test   %eax,%eax
  803375:	74 10                	je     803387 <alloc_block_BF+0x493>
  803377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80337f:	8b 52 04             	mov    0x4(%edx),%edx
  803382:	89 50 04             	mov    %edx,0x4(%eax)
  803385:	eb 0b                	jmp    803392 <alloc_block_BF+0x49e>
  803387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338a:	8b 40 04             	mov    0x4(%eax),%eax
  80338d:	a3 48 60 80 00       	mov    %eax,0x806048
  803392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803395:	8b 40 04             	mov    0x4(%eax),%eax
  803398:	85 c0                	test   %eax,%eax
  80339a:	74 0f                	je     8033ab <alloc_block_BF+0x4b7>
  80339c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339f:	8b 40 04             	mov    0x4(%eax),%eax
  8033a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033a5:	8b 12                	mov    (%edx),%edx
  8033a7:	89 10                	mov    %edx,(%eax)
  8033a9:	eb 0a                	jmp    8033b5 <alloc_block_BF+0x4c1>
  8033ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ae:	8b 00                	mov    (%eax),%eax
  8033b0:	a3 44 60 80 00       	mov    %eax,0x806044
  8033b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c8:	a1 50 60 80 00       	mov    0x806050,%eax
  8033cd:	48                   	dec    %eax
  8033ce:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  8033d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d6:	e9 d9 00 00 00       	jmp    8034b4 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8033db:	8b 45 08             	mov    0x8(%ebp),%eax
  8033de:	83 c0 08             	add    $0x8,%eax
  8033e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8033e4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8033eb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8033f1:	01 d0                	add    %edx,%eax
  8033f3:	48                   	dec    %eax
  8033f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8033f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8033ff:	f7 75 c4             	divl   -0x3c(%ebp)
  803402:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803405:	29 d0                	sub    %edx,%eax
  803407:	c1 e8 0c             	shr    $0xc,%eax
  80340a:	83 ec 0c             	sub    $0xc,%esp
  80340d:	50                   	push   %eax
  80340e:	e8 ad e6 ff ff       	call   801ac0 <sbrk>
  803413:	83 c4 10             	add    $0x10,%esp
  803416:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803419:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80341d:	75 0a                	jne    803429 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80341f:	b8 00 00 00 00       	mov    $0x0,%eax
  803424:	e9 8b 00 00 00       	jmp    8034b4 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803429:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803430:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803433:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803436:	01 d0                	add    %edx,%eax
  803438:	48                   	dec    %eax
  803439:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80343c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80343f:	ba 00 00 00 00       	mov    $0x0,%edx
  803444:	f7 75 b8             	divl   -0x48(%ebp)
  803447:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80344a:	29 d0                	sub    %edx,%eax
  80344c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80344f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803452:	01 d0                	add    %edx,%eax
  803454:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  803459:	a1 48 a2 80 00       	mov    0x80a248,%eax
  80345e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803464:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80346b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80346e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803471:	01 d0                	add    %edx,%eax
  803473:	48                   	dec    %eax
  803474:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803477:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80347a:	ba 00 00 00 00       	mov    $0x0,%edx
  80347f:	f7 75 b0             	divl   -0x50(%ebp)
  803482:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803485:	29 d0                	sub    %edx,%eax
  803487:	83 ec 04             	sub    $0x4,%esp
  80348a:	6a 01                	push   $0x1
  80348c:	50                   	push   %eax
  80348d:	ff 75 bc             	pushl  -0x44(%ebp)
  803490:	e8 74 f5 ff ff       	call   802a09 <set_block_data>
  803495:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803498:	83 ec 0c             	sub    $0xc,%esp
  80349b:	ff 75 bc             	pushl  -0x44(%ebp)
  80349e:	e8 36 04 00 00       	call   8038d9 <free_block>
  8034a3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8034a6:	83 ec 0c             	sub    $0xc,%esp
  8034a9:	ff 75 08             	pushl  0x8(%ebp)
  8034ac:	e8 43 fa ff ff       	call   802ef4 <alloc_block_BF>
  8034b1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8034b4:	c9                   	leave  
  8034b5:	c3                   	ret    

008034b6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8034b6:	55                   	push   %ebp
  8034b7:	89 e5                	mov    %esp,%ebp
  8034b9:	53                   	push   %ebx
  8034ba:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8034bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8034cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034cf:	74 1e                	je     8034ef <merging+0x39>
  8034d1:	ff 75 08             	pushl  0x8(%ebp)
  8034d4:	e8 df f1 ff ff       	call   8026b8 <get_block_size>
  8034d9:	83 c4 04             	add    $0x4,%esp
  8034dc:	89 c2                	mov    %eax,%edx
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	01 d0                	add    %edx,%eax
  8034e3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8034e6:	75 07                	jne    8034ef <merging+0x39>
		prev_is_free = 1;
  8034e8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8034ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034f3:	74 1e                	je     803513 <merging+0x5d>
  8034f5:	ff 75 10             	pushl  0x10(%ebp)
  8034f8:	e8 bb f1 ff ff       	call   8026b8 <get_block_size>
  8034fd:	83 c4 04             	add    $0x4,%esp
  803500:	89 c2                	mov    %eax,%edx
  803502:	8b 45 10             	mov    0x10(%ebp),%eax
  803505:	01 d0                	add    %edx,%eax
  803507:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80350a:	75 07                	jne    803513 <merging+0x5d>
		next_is_free = 1;
  80350c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803517:	0f 84 cc 00 00 00    	je     8035e9 <merging+0x133>
  80351d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803521:	0f 84 c2 00 00 00    	je     8035e9 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803527:	ff 75 08             	pushl  0x8(%ebp)
  80352a:	e8 89 f1 ff ff       	call   8026b8 <get_block_size>
  80352f:	83 c4 04             	add    $0x4,%esp
  803532:	89 c3                	mov    %eax,%ebx
  803534:	ff 75 10             	pushl  0x10(%ebp)
  803537:	e8 7c f1 ff ff       	call   8026b8 <get_block_size>
  80353c:	83 c4 04             	add    $0x4,%esp
  80353f:	01 c3                	add    %eax,%ebx
  803541:	ff 75 0c             	pushl  0xc(%ebp)
  803544:	e8 6f f1 ff ff       	call   8026b8 <get_block_size>
  803549:	83 c4 04             	add    $0x4,%esp
  80354c:	01 d8                	add    %ebx,%eax
  80354e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803551:	6a 00                	push   $0x0
  803553:	ff 75 ec             	pushl  -0x14(%ebp)
  803556:	ff 75 08             	pushl  0x8(%ebp)
  803559:	e8 ab f4 ff ff       	call   802a09 <set_block_data>
  80355e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803561:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803565:	75 17                	jne    80357e <merging+0xc8>
  803567:	83 ec 04             	sub    $0x4,%esp
  80356a:	68 03 50 80 00       	push   $0x805003
  80356f:	68 7d 01 00 00       	push   $0x17d
  803574:	68 21 50 80 00       	push   $0x805021
  803579:	e8 eb d4 ff ff       	call   800a69 <_panic>
  80357e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803581:	8b 00                	mov    (%eax),%eax
  803583:	85 c0                	test   %eax,%eax
  803585:	74 10                	je     803597 <merging+0xe1>
  803587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358a:	8b 00                	mov    (%eax),%eax
  80358c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80358f:	8b 52 04             	mov    0x4(%edx),%edx
  803592:	89 50 04             	mov    %edx,0x4(%eax)
  803595:	eb 0b                	jmp    8035a2 <merging+0xec>
  803597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80359a:	8b 40 04             	mov    0x4(%eax),%eax
  80359d:	a3 48 60 80 00       	mov    %eax,0x806048
  8035a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a5:	8b 40 04             	mov    0x4(%eax),%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	74 0f                	je     8035bb <merging+0x105>
  8035ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035af:	8b 40 04             	mov    0x4(%eax),%eax
  8035b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035b5:	8b 12                	mov    (%edx),%edx
  8035b7:	89 10                	mov    %edx,(%eax)
  8035b9:	eb 0a                	jmp    8035c5 <merging+0x10f>
  8035bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035be:	8b 00                	mov    (%eax),%eax
  8035c0:	a3 44 60 80 00       	mov    %eax,0x806044
  8035c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d8:	a1 50 60 80 00       	mov    0x806050,%eax
  8035dd:	48                   	dec    %eax
  8035de:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8035e3:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035e4:	e9 ea 02 00 00       	jmp    8038d3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8035e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ed:	74 3b                	je     80362a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8035ef:	83 ec 0c             	sub    $0xc,%esp
  8035f2:	ff 75 08             	pushl  0x8(%ebp)
  8035f5:	e8 be f0 ff ff       	call   8026b8 <get_block_size>
  8035fa:	83 c4 10             	add    $0x10,%esp
  8035fd:	89 c3                	mov    %eax,%ebx
  8035ff:	83 ec 0c             	sub    $0xc,%esp
  803602:	ff 75 10             	pushl  0x10(%ebp)
  803605:	e8 ae f0 ff ff       	call   8026b8 <get_block_size>
  80360a:	83 c4 10             	add    $0x10,%esp
  80360d:	01 d8                	add    %ebx,%eax
  80360f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803612:	83 ec 04             	sub    $0x4,%esp
  803615:	6a 00                	push   $0x0
  803617:	ff 75 e8             	pushl  -0x18(%ebp)
  80361a:	ff 75 08             	pushl  0x8(%ebp)
  80361d:	e8 e7 f3 ff ff       	call   802a09 <set_block_data>
  803622:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803625:	e9 a9 02 00 00       	jmp    8038d3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80362a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80362e:	0f 84 2d 01 00 00    	je     803761 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803634:	83 ec 0c             	sub    $0xc,%esp
  803637:	ff 75 10             	pushl  0x10(%ebp)
  80363a:	e8 79 f0 ff ff       	call   8026b8 <get_block_size>
  80363f:	83 c4 10             	add    $0x10,%esp
  803642:	89 c3                	mov    %eax,%ebx
  803644:	83 ec 0c             	sub    $0xc,%esp
  803647:	ff 75 0c             	pushl  0xc(%ebp)
  80364a:	e8 69 f0 ff ff       	call   8026b8 <get_block_size>
  80364f:	83 c4 10             	add    $0x10,%esp
  803652:	01 d8                	add    %ebx,%eax
  803654:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803657:	83 ec 04             	sub    $0x4,%esp
  80365a:	6a 00                	push   $0x0
  80365c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80365f:	ff 75 10             	pushl  0x10(%ebp)
  803662:	e8 a2 f3 ff ff       	call   802a09 <set_block_data>
  803667:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80366a:	8b 45 10             	mov    0x10(%ebp),%eax
  80366d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803670:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803674:	74 06                	je     80367c <merging+0x1c6>
  803676:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80367a:	75 17                	jne    803693 <merging+0x1dd>
  80367c:	83 ec 04             	sub    $0x4,%esp
  80367f:	68 c8 50 80 00       	push   $0x8050c8
  803684:	68 8d 01 00 00       	push   $0x18d
  803689:	68 21 50 80 00       	push   $0x805021
  80368e:	e8 d6 d3 ff ff       	call   800a69 <_panic>
  803693:	8b 45 0c             	mov    0xc(%ebp),%eax
  803696:	8b 50 04             	mov    0x4(%eax),%edx
  803699:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80369c:	89 50 04             	mov    %edx,0x4(%eax)
  80369f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036a5:	89 10                	mov    %edx,(%eax)
  8036a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036aa:	8b 40 04             	mov    0x4(%eax),%eax
  8036ad:	85 c0                	test   %eax,%eax
  8036af:	74 0d                	je     8036be <merging+0x208>
  8036b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b4:	8b 40 04             	mov    0x4(%eax),%eax
  8036b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036ba:	89 10                	mov    %edx,(%eax)
  8036bc:	eb 08                	jmp    8036c6 <merging+0x210>
  8036be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036c1:	a3 44 60 80 00       	mov    %eax,0x806044
  8036c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036cc:	89 50 04             	mov    %edx,0x4(%eax)
  8036cf:	a1 50 60 80 00       	mov    0x806050,%eax
  8036d4:	40                   	inc    %eax
  8036d5:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  8036da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036de:	75 17                	jne    8036f7 <merging+0x241>
  8036e0:	83 ec 04             	sub    $0x4,%esp
  8036e3:	68 03 50 80 00       	push   $0x805003
  8036e8:	68 8e 01 00 00       	push   $0x18e
  8036ed:	68 21 50 80 00       	push   $0x805021
  8036f2:	e8 72 d3 ff ff       	call   800a69 <_panic>
  8036f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036fa:	8b 00                	mov    (%eax),%eax
  8036fc:	85 c0                	test   %eax,%eax
  8036fe:	74 10                	je     803710 <merging+0x25a>
  803700:	8b 45 0c             	mov    0xc(%ebp),%eax
  803703:	8b 00                	mov    (%eax),%eax
  803705:	8b 55 0c             	mov    0xc(%ebp),%edx
  803708:	8b 52 04             	mov    0x4(%edx),%edx
  80370b:	89 50 04             	mov    %edx,0x4(%eax)
  80370e:	eb 0b                	jmp    80371b <merging+0x265>
  803710:	8b 45 0c             	mov    0xc(%ebp),%eax
  803713:	8b 40 04             	mov    0x4(%eax),%eax
  803716:	a3 48 60 80 00       	mov    %eax,0x806048
  80371b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371e:	8b 40 04             	mov    0x4(%eax),%eax
  803721:	85 c0                	test   %eax,%eax
  803723:	74 0f                	je     803734 <merging+0x27e>
  803725:	8b 45 0c             	mov    0xc(%ebp),%eax
  803728:	8b 40 04             	mov    0x4(%eax),%eax
  80372b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80372e:	8b 12                	mov    (%edx),%edx
  803730:	89 10                	mov    %edx,(%eax)
  803732:	eb 0a                	jmp    80373e <merging+0x288>
  803734:	8b 45 0c             	mov    0xc(%ebp),%eax
  803737:	8b 00                	mov    (%eax),%eax
  803739:	a3 44 60 80 00       	mov    %eax,0x806044
  80373e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803741:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803751:	a1 50 60 80 00       	mov    0x806050,%eax
  803756:	48                   	dec    %eax
  803757:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80375c:	e9 72 01 00 00       	jmp    8038d3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803761:	8b 45 10             	mov    0x10(%ebp),%eax
  803764:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803767:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80376b:	74 79                	je     8037e6 <merging+0x330>
  80376d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803771:	74 73                	je     8037e6 <merging+0x330>
  803773:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803777:	74 06                	je     80377f <merging+0x2c9>
  803779:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80377d:	75 17                	jne    803796 <merging+0x2e0>
  80377f:	83 ec 04             	sub    $0x4,%esp
  803782:	68 94 50 80 00       	push   $0x805094
  803787:	68 94 01 00 00       	push   $0x194
  80378c:	68 21 50 80 00       	push   $0x805021
  803791:	e8 d3 d2 ff ff       	call   800a69 <_panic>
  803796:	8b 45 08             	mov    0x8(%ebp),%eax
  803799:	8b 10                	mov    (%eax),%edx
  80379b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80379e:	89 10                	mov    %edx,(%eax)
  8037a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037a3:	8b 00                	mov    (%eax),%eax
  8037a5:	85 c0                	test   %eax,%eax
  8037a7:	74 0b                	je     8037b4 <merging+0x2fe>
  8037a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ac:	8b 00                	mov    (%eax),%eax
  8037ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037b1:	89 50 04             	mov    %edx,0x4(%eax)
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037ba:	89 10                	mov    %edx,(%eax)
  8037bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c2:	89 50 04             	mov    %edx,0x4(%eax)
  8037c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c8:	8b 00                	mov    (%eax),%eax
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	75 08                	jne    8037d6 <merging+0x320>
  8037ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d1:	a3 48 60 80 00       	mov    %eax,0x806048
  8037d6:	a1 50 60 80 00       	mov    0x806050,%eax
  8037db:	40                   	inc    %eax
  8037dc:	a3 50 60 80 00       	mov    %eax,0x806050
  8037e1:	e9 ce 00 00 00       	jmp    8038b4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8037e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ea:	74 65                	je     803851 <merging+0x39b>
  8037ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037f0:	75 17                	jne    803809 <merging+0x353>
  8037f2:	83 ec 04             	sub    $0x4,%esp
  8037f5:	68 70 50 80 00       	push   $0x805070
  8037fa:	68 95 01 00 00       	push   $0x195
  8037ff:	68 21 50 80 00       	push   $0x805021
  803804:	e8 60 d2 ff ff       	call   800a69 <_panic>
  803809:	8b 15 48 60 80 00    	mov    0x806048,%edx
  80380f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803812:	89 50 04             	mov    %edx,0x4(%eax)
  803815:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803818:	8b 40 04             	mov    0x4(%eax),%eax
  80381b:	85 c0                	test   %eax,%eax
  80381d:	74 0c                	je     80382b <merging+0x375>
  80381f:	a1 48 60 80 00       	mov    0x806048,%eax
  803824:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803827:	89 10                	mov    %edx,(%eax)
  803829:	eb 08                	jmp    803833 <merging+0x37d>
  80382b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80382e:	a3 44 60 80 00       	mov    %eax,0x806044
  803833:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803836:	a3 48 60 80 00       	mov    %eax,0x806048
  80383b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80383e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803844:	a1 50 60 80 00       	mov    0x806050,%eax
  803849:	40                   	inc    %eax
  80384a:	a3 50 60 80 00       	mov    %eax,0x806050
  80384f:	eb 63                	jmp    8038b4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803851:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803855:	75 17                	jne    80386e <merging+0x3b8>
  803857:	83 ec 04             	sub    $0x4,%esp
  80385a:	68 3c 50 80 00       	push   $0x80503c
  80385f:	68 98 01 00 00       	push   $0x198
  803864:	68 21 50 80 00       	push   $0x805021
  803869:	e8 fb d1 ff ff       	call   800a69 <_panic>
  80386e:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803874:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803877:	89 10                	mov    %edx,(%eax)
  803879:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80387c:	8b 00                	mov    (%eax),%eax
  80387e:	85 c0                	test   %eax,%eax
  803880:	74 0d                	je     80388f <merging+0x3d9>
  803882:	a1 44 60 80 00       	mov    0x806044,%eax
  803887:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80388a:	89 50 04             	mov    %edx,0x4(%eax)
  80388d:	eb 08                	jmp    803897 <merging+0x3e1>
  80388f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803892:	a3 48 60 80 00       	mov    %eax,0x806048
  803897:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80389a:	a3 44 60 80 00       	mov    %eax,0x806044
  80389f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a9:	a1 50 60 80 00       	mov    0x806050,%eax
  8038ae:	40                   	inc    %eax
  8038af:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  8038b4:	83 ec 0c             	sub    $0xc,%esp
  8038b7:	ff 75 10             	pushl  0x10(%ebp)
  8038ba:	e8 f9 ed ff ff       	call   8026b8 <get_block_size>
  8038bf:	83 c4 10             	add    $0x10,%esp
  8038c2:	83 ec 04             	sub    $0x4,%esp
  8038c5:	6a 00                	push   $0x0
  8038c7:	50                   	push   %eax
  8038c8:	ff 75 10             	pushl  0x10(%ebp)
  8038cb:	e8 39 f1 ff ff       	call   802a09 <set_block_data>
  8038d0:	83 c4 10             	add    $0x10,%esp
	}
}
  8038d3:	90                   	nop
  8038d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038d7:	c9                   	leave  
  8038d8:	c3                   	ret    

008038d9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8038d9:	55                   	push   %ebp
  8038da:	89 e5                	mov    %esp,%ebp
  8038dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8038df:	a1 44 60 80 00       	mov    0x806044,%eax
  8038e4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8038e7:	a1 48 60 80 00       	mov    0x806048,%eax
  8038ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038ef:	73 1b                	jae    80390c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8038f1:	a1 48 60 80 00       	mov    0x806048,%eax
  8038f6:	83 ec 04             	sub    $0x4,%esp
  8038f9:	ff 75 08             	pushl  0x8(%ebp)
  8038fc:	6a 00                	push   $0x0
  8038fe:	50                   	push   %eax
  8038ff:	e8 b2 fb ff ff       	call   8034b6 <merging>
  803904:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803907:	e9 8b 00 00 00       	jmp    803997 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80390c:	a1 44 60 80 00       	mov    0x806044,%eax
  803911:	3b 45 08             	cmp    0x8(%ebp),%eax
  803914:	76 18                	jbe    80392e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803916:	a1 44 60 80 00       	mov    0x806044,%eax
  80391b:	83 ec 04             	sub    $0x4,%esp
  80391e:	ff 75 08             	pushl  0x8(%ebp)
  803921:	50                   	push   %eax
  803922:	6a 00                	push   $0x0
  803924:	e8 8d fb ff ff       	call   8034b6 <merging>
  803929:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80392c:	eb 69                	jmp    803997 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80392e:	a1 44 60 80 00       	mov    0x806044,%eax
  803933:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803936:	eb 39                	jmp    803971 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80393e:	73 29                	jae    803969 <free_block+0x90>
  803940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803943:	8b 00                	mov    (%eax),%eax
  803945:	3b 45 08             	cmp    0x8(%ebp),%eax
  803948:	76 1f                	jbe    803969 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80394a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394d:	8b 00                	mov    (%eax),%eax
  80394f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803952:	83 ec 04             	sub    $0x4,%esp
  803955:	ff 75 08             	pushl  0x8(%ebp)
  803958:	ff 75 f0             	pushl  -0x10(%ebp)
  80395b:	ff 75 f4             	pushl  -0xc(%ebp)
  80395e:	e8 53 fb ff ff       	call   8034b6 <merging>
  803963:	83 c4 10             	add    $0x10,%esp
			break;
  803966:	90                   	nop
		}
	}
}
  803967:	eb 2e                	jmp    803997 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803969:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80396e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803971:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803975:	74 07                	je     80397e <free_block+0xa5>
  803977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397a:	8b 00                	mov    (%eax),%eax
  80397c:	eb 05                	jmp    803983 <free_block+0xaa>
  80397e:	b8 00 00 00 00       	mov    $0x0,%eax
  803983:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803988:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80398d:	85 c0                	test   %eax,%eax
  80398f:	75 a7                	jne    803938 <free_block+0x5f>
  803991:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803995:	75 a1                	jne    803938 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803997:	90                   	nop
  803998:	c9                   	leave  
  803999:	c3                   	ret    

0080399a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80399a:	55                   	push   %ebp
  80399b:	89 e5                	mov    %esp,%ebp
  80399d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8039a0:	ff 75 08             	pushl  0x8(%ebp)
  8039a3:	e8 10 ed ff ff       	call   8026b8 <get_block_size>
  8039a8:	83 c4 04             	add    $0x4,%esp
  8039ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8039ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8039b5:	eb 17                	jmp    8039ce <copy_data+0x34>
  8039b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8039ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039bd:	01 c2                	add    %eax,%edx
  8039bf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8039c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c5:	01 c8                	add    %ecx,%eax
  8039c7:	8a 00                	mov    (%eax),%al
  8039c9:	88 02                	mov    %al,(%edx)
  8039cb:	ff 45 fc             	incl   -0x4(%ebp)
  8039ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8039d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8039d4:	72 e1                	jb     8039b7 <copy_data+0x1d>
}
  8039d6:	90                   	nop
  8039d7:	c9                   	leave  
  8039d8:	c3                   	ret    

008039d9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8039d9:	55                   	push   %ebp
  8039da:	89 e5                	mov    %esp,%ebp
  8039dc:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8039df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039e3:	75 23                	jne    803a08 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8039e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039e9:	74 13                	je     8039fe <realloc_block_FF+0x25>
  8039eb:	83 ec 0c             	sub    $0xc,%esp
  8039ee:	ff 75 0c             	pushl  0xc(%ebp)
  8039f1:	e8 42 f0 ff ff       	call   802a38 <alloc_block_FF>
  8039f6:	83 c4 10             	add    $0x10,%esp
  8039f9:	e9 e4 06 00 00       	jmp    8040e2 <realloc_block_FF+0x709>
		return NULL;
  8039fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803a03:	e9 da 06 00 00       	jmp    8040e2 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803a08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a0c:	75 18                	jne    803a26 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803a0e:	83 ec 0c             	sub    $0xc,%esp
  803a11:	ff 75 08             	pushl  0x8(%ebp)
  803a14:	e8 c0 fe ff ff       	call   8038d9 <free_block>
  803a19:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a21:	e9 bc 06 00 00       	jmp    8040e2 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803a26:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803a2a:	77 07                	ja     803a33 <realloc_block_FF+0x5a>
  803a2c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a36:	83 e0 01             	and    $0x1,%eax
  803a39:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a3f:	83 c0 08             	add    $0x8,%eax
  803a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803a45:	83 ec 0c             	sub    $0xc,%esp
  803a48:	ff 75 08             	pushl  0x8(%ebp)
  803a4b:	e8 68 ec ff ff       	call   8026b8 <get_block_size>
  803a50:	83 c4 10             	add    $0x10,%esp
  803a53:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a59:	83 e8 08             	sub    $0x8,%eax
  803a5c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a62:	83 e8 04             	sub    $0x4,%eax
  803a65:	8b 00                	mov    (%eax),%eax
  803a67:	83 e0 fe             	and    $0xfffffffe,%eax
  803a6a:	89 c2                	mov    %eax,%edx
  803a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6f:	01 d0                	add    %edx,%eax
  803a71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803a74:	83 ec 0c             	sub    $0xc,%esp
  803a77:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a7a:	e8 39 ec ff ff       	call   8026b8 <get_block_size>
  803a7f:	83 c4 10             	add    $0x10,%esp
  803a82:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a88:	83 e8 08             	sub    $0x8,%eax
  803a8b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a91:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a94:	75 08                	jne    803a9e <realloc_block_FF+0xc5>
	{
		 return va;
  803a96:	8b 45 08             	mov    0x8(%ebp),%eax
  803a99:	e9 44 06 00 00       	jmp    8040e2 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803aa4:	0f 83 d5 03 00 00    	jae    803e7f <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803aaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aad:	2b 45 0c             	sub    0xc(%ebp),%eax
  803ab0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803ab3:	83 ec 0c             	sub    $0xc,%esp
  803ab6:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ab9:	e8 13 ec ff ff       	call   8026d1 <is_free_block>
  803abe:	83 c4 10             	add    $0x10,%esp
  803ac1:	84 c0                	test   %al,%al
  803ac3:	0f 84 3b 01 00 00    	je     803c04 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803ac9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803acc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803acf:	01 d0                	add    %edx,%eax
  803ad1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803ad4:	83 ec 04             	sub    $0x4,%esp
  803ad7:	6a 01                	push   $0x1
  803ad9:	ff 75 f0             	pushl  -0x10(%ebp)
  803adc:	ff 75 08             	pushl  0x8(%ebp)
  803adf:	e8 25 ef ff ff       	call   802a09 <set_block_data>
  803ae4:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aea:	83 e8 04             	sub    $0x4,%eax
  803aed:	8b 00                	mov    (%eax),%eax
  803aef:	83 e0 fe             	and    $0xfffffffe,%eax
  803af2:	89 c2                	mov    %eax,%edx
  803af4:	8b 45 08             	mov    0x8(%ebp),%eax
  803af7:	01 d0                	add    %edx,%eax
  803af9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803afc:	83 ec 04             	sub    $0x4,%esp
  803aff:	6a 00                	push   $0x0
  803b01:	ff 75 cc             	pushl  -0x34(%ebp)
  803b04:	ff 75 c8             	pushl  -0x38(%ebp)
  803b07:	e8 fd ee ff ff       	call   802a09 <set_block_data>
  803b0c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b13:	74 06                	je     803b1b <realloc_block_FF+0x142>
  803b15:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b19:	75 17                	jne    803b32 <realloc_block_FF+0x159>
  803b1b:	83 ec 04             	sub    $0x4,%esp
  803b1e:	68 94 50 80 00       	push   $0x805094
  803b23:	68 f6 01 00 00       	push   $0x1f6
  803b28:	68 21 50 80 00       	push   $0x805021
  803b2d:	e8 37 cf ff ff       	call   800a69 <_panic>
  803b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b35:	8b 10                	mov    (%eax),%edx
  803b37:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b3a:	89 10                	mov    %edx,(%eax)
  803b3c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b3f:	8b 00                	mov    (%eax),%eax
  803b41:	85 c0                	test   %eax,%eax
  803b43:	74 0b                	je     803b50 <realloc_block_FF+0x177>
  803b45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b48:	8b 00                	mov    (%eax),%eax
  803b4a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b4d:	89 50 04             	mov    %edx,0x4(%eax)
  803b50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b53:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b56:	89 10                	mov    %edx,(%eax)
  803b58:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b5e:	89 50 04             	mov    %edx,0x4(%eax)
  803b61:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b64:	8b 00                	mov    (%eax),%eax
  803b66:	85 c0                	test   %eax,%eax
  803b68:	75 08                	jne    803b72 <realloc_block_FF+0x199>
  803b6a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b6d:	a3 48 60 80 00       	mov    %eax,0x806048
  803b72:	a1 50 60 80 00       	mov    0x806050,%eax
  803b77:	40                   	inc    %eax
  803b78:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803b7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b81:	75 17                	jne    803b9a <realloc_block_FF+0x1c1>
  803b83:	83 ec 04             	sub    $0x4,%esp
  803b86:	68 03 50 80 00       	push   $0x805003
  803b8b:	68 f7 01 00 00       	push   $0x1f7
  803b90:	68 21 50 80 00       	push   $0x805021
  803b95:	e8 cf ce ff ff       	call   800a69 <_panic>
  803b9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b9d:	8b 00                	mov    (%eax),%eax
  803b9f:	85 c0                	test   %eax,%eax
  803ba1:	74 10                	je     803bb3 <realloc_block_FF+0x1da>
  803ba3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba6:	8b 00                	mov    (%eax),%eax
  803ba8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bab:	8b 52 04             	mov    0x4(%edx),%edx
  803bae:	89 50 04             	mov    %edx,0x4(%eax)
  803bb1:	eb 0b                	jmp    803bbe <realloc_block_FF+0x1e5>
  803bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb6:	8b 40 04             	mov    0x4(%eax),%eax
  803bb9:	a3 48 60 80 00       	mov    %eax,0x806048
  803bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc1:	8b 40 04             	mov    0x4(%eax),%eax
  803bc4:	85 c0                	test   %eax,%eax
  803bc6:	74 0f                	je     803bd7 <realloc_block_FF+0x1fe>
  803bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bcb:	8b 40 04             	mov    0x4(%eax),%eax
  803bce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bd1:	8b 12                	mov    (%edx),%edx
  803bd3:	89 10                	mov    %edx,(%eax)
  803bd5:	eb 0a                	jmp    803be1 <realloc_block_FF+0x208>
  803bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bda:	8b 00                	mov    (%eax),%eax
  803bdc:	a3 44 60 80 00       	mov    %eax,0x806044
  803be1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bf4:	a1 50 60 80 00       	mov    0x806050,%eax
  803bf9:	48                   	dec    %eax
  803bfa:	a3 50 60 80 00       	mov    %eax,0x806050
  803bff:	e9 73 02 00 00       	jmp    803e77 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803c04:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803c08:	0f 86 69 02 00 00    	jbe    803e77 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803c0e:	83 ec 04             	sub    $0x4,%esp
  803c11:	6a 01                	push   $0x1
  803c13:	ff 75 f0             	pushl  -0x10(%ebp)
  803c16:	ff 75 08             	pushl  0x8(%ebp)
  803c19:	e8 eb ed ff ff       	call   802a09 <set_block_data>
  803c1e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c21:	8b 45 08             	mov    0x8(%ebp),%eax
  803c24:	83 e8 04             	sub    $0x4,%eax
  803c27:	8b 00                	mov    (%eax),%eax
  803c29:	83 e0 fe             	and    $0xfffffffe,%eax
  803c2c:	89 c2                	mov    %eax,%edx
  803c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c31:	01 d0                	add    %edx,%eax
  803c33:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803c36:	a1 50 60 80 00       	mov    0x806050,%eax
  803c3b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803c3e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c42:	75 68                	jne    803cac <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c44:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c48:	75 17                	jne    803c61 <realloc_block_FF+0x288>
  803c4a:	83 ec 04             	sub    $0x4,%esp
  803c4d:	68 3c 50 80 00       	push   $0x80503c
  803c52:	68 06 02 00 00       	push   $0x206
  803c57:	68 21 50 80 00       	push   $0x805021
  803c5c:	e8 08 ce ff ff       	call   800a69 <_panic>
  803c61:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803c67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c6a:	89 10                	mov    %edx,(%eax)
  803c6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c6f:	8b 00                	mov    (%eax),%eax
  803c71:	85 c0                	test   %eax,%eax
  803c73:	74 0d                	je     803c82 <realloc_block_FF+0x2a9>
  803c75:	a1 44 60 80 00       	mov    0x806044,%eax
  803c7a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c7d:	89 50 04             	mov    %edx,0x4(%eax)
  803c80:	eb 08                	jmp    803c8a <realloc_block_FF+0x2b1>
  803c82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c85:	a3 48 60 80 00       	mov    %eax,0x806048
  803c8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c8d:	a3 44 60 80 00       	mov    %eax,0x806044
  803c92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c9c:	a1 50 60 80 00       	mov    0x806050,%eax
  803ca1:	40                   	inc    %eax
  803ca2:	a3 50 60 80 00       	mov    %eax,0x806050
  803ca7:	e9 b0 01 00 00       	jmp    803e5c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803cac:	a1 44 60 80 00       	mov    0x806044,%eax
  803cb1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803cb4:	76 68                	jbe    803d1e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803cb6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cba:	75 17                	jne    803cd3 <realloc_block_FF+0x2fa>
  803cbc:	83 ec 04             	sub    $0x4,%esp
  803cbf:	68 3c 50 80 00       	push   $0x80503c
  803cc4:	68 0b 02 00 00       	push   $0x20b
  803cc9:	68 21 50 80 00       	push   $0x805021
  803cce:	e8 96 cd ff ff       	call   800a69 <_panic>
  803cd3:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803cd9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cdc:	89 10                	mov    %edx,(%eax)
  803cde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce1:	8b 00                	mov    (%eax),%eax
  803ce3:	85 c0                	test   %eax,%eax
  803ce5:	74 0d                	je     803cf4 <realloc_block_FF+0x31b>
  803ce7:	a1 44 60 80 00       	mov    0x806044,%eax
  803cec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cef:	89 50 04             	mov    %edx,0x4(%eax)
  803cf2:	eb 08                	jmp    803cfc <realloc_block_FF+0x323>
  803cf4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf7:	a3 48 60 80 00       	mov    %eax,0x806048
  803cfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cff:	a3 44 60 80 00       	mov    %eax,0x806044
  803d04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d0e:	a1 50 60 80 00       	mov    0x806050,%eax
  803d13:	40                   	inc    %eax
  803d14:	a3 50 60 80 00       	mov    %eax,0x806050
  803d19:	e9 3e 01 00 00       	jmp    803e5c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803d1e:	a1 44 60 80 00       	mov    0x806044,%eax
  803d23:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d26:	73 68                	jae    803d90 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d28:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d2c:	75 17                	jne    803d45 <realloc_block_FF+0x36c>
  803d2e:	83 ec 04             	sub    $0x4,%esp
  803d31:	68 70 50 80 00       	push   $0x805070
  803d36:	68 10 02 00 00       	push   $0x210
  803d3b:	68 21 50 80 00       	push   $0x805021
  803d40:	e8 24 cd ff ff       	call   800a69 <_panic>
  803d45:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803d4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d4e:	89 50 04             	mov    %edx,0x4(%eax)
  803d51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d54:	8b 40 04             	mov    0x4(%eax),%eax
  803d57:	85 c0                	test   %eax,%eax
  803d59:	74 0c                	je     803d67 <realloc_block_FF+0x38e>
  803d5b:	a1 48 60 80 00       	mov    0x806048,%eax
  803d60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d63:	89 10                	mov    %edx,(%eax)
  803d65:	eb 08                	jmp    803d6f <realloc_block_FF+0x396>
  803d67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d6a:	a3 44 60 80 00       	mov    %eax,0x806044
  803d6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d72:	a3 48 60 80 00       	mov    %eax,0x806048
  803d77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d80:	a1 50 60 80 00       	mov    0x806050,%eax
  803d85:	40                   	inc    %eax
  803d86:	a3 50 60 80 00       	mov    %eax,0x806050
  803d8b:	e9 cc 00 00 00       	jmp    803e5c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803d90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803d97:	a1 44 60 80 00       	mov    0x806044,%eax
  803d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d9f:	e9 8a 00 00 00       	jmp    803e2e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803daa:	73 7a                	jae    803e26 <realloc_block_FF+0x44d>
  803dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803daf:	8b 00                	mov    (%eax),%eax
  803db1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803db4:	73 70                	jae    803e26 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dba:	74 06                	je     803dc2 <realloc_block_FF+0x3e9>
  803dbc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803dc0:	75 17                	jne    803dd9 <realloc_block_FF+0x400>
  803dc2:	83 ec 04             	sub    $0x4,%esp
  803dc5:	68 94 50 80 00       	push   $0x805094
  803dca:	68 1a 02 00 00       	push   $0x21a
  803dcf:	68 21 50 80 00       	push   $0x805021
  803dd4:	e8 90 cc ff ff       	call   800a69 <_panic>
  803dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ddc:	8b 10                	mov    (%eax),%edx
  803dde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de1:	89 10                	mov    %edx,(%eax)
  803de3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de6:	8b 00                	mov    (%eax),%eax
  803de8:	85 c0                	test   %eax,%eax
  803dea:	74 0b                	je     803df7 <realloc_block_FF+0x41e>
  803dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803def:	8b 00                	mov    (%eax),%eax
  803df1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803df4:	89 50 04             	mov    %edx,0x4(%eax)
  803df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dfd:	89 10                	mov    %edx,(%eax)
  803dff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e05:	89 50 04             	mov    %edx,0x4(%eax)
  803e08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e0b:	8b 00                	mov    (%eax),%eax
  803e0d:	85 c0                	test   %eax,%eax
  803e0f:	75 08                	jne    803e19 <realloc_block_FF+0x440>
  803e11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e14:	a3 48 60 80 00       	mov    %eax,0x806048
  803e19:	a1 50 60 80 00       	mov    0x806050,%eax
  803e1e:	40                   	inc    %eax
  803e1f:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  803e24:	eb 36                	jmp    803e5c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803e26:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e32:	74 07                	je     803e3b <realloc_block_FF+0x462>
  803e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e37:	8b 00                	mov    (%eax),%eax
  803e39:	eb 05                	jmp    803e40 <realloc_block_FF+0x467>
  803e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e40:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803e45:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803e4a:	85 c0                	test   %eax,%eax
  803e4c:	0f 85 52 ff ff ff    	jne    803da4 <realloc_block_FF+0x3cb>
  803e52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e56:	0f 85 48 ff ff ff    	jne    803da4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803e5c:	83 ec 04             	sub    $0x4,%esp
  803e5f:	6a 00                	push   $0x0
  803e61:	ff 75 d8             	pushl  -0x28(%ebp)
  803e64:	ff 75 d4             	pushl  -0x2c(%ebp)
  803e67:	e8 9d eb ff ff       	call   802a09 <set_block_data>
  803e6c:	83 c4 10             	add    $0x10,%esp
				return va;
  803e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e72:	e9 6b 02 00 00       	jmp    8040e2 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803e77:	8b 45 08             	mov    0x8(%ebp),%eax
  803e7a:	e9 63 02 00 00       	jmp    8040e2 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e82:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e85:	0f 86 4d 02 00 00    	jbe    8040d8 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803e8b:	83 ec 0c             	sub    $0xc,%esp
  803e8e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e91:	e8 3b e8 ff ff       	call   8026d1 <is_free_block>
  803e96:	83 c4 10             	add    $0x10,%esp
  803e99:	84 c0                	test   %al,%al
  803e9b:	0f 84 37 02 00 00    	je     8040d8 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ea4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803ea7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803eaa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803ead:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803eb0:	76 38                	jbe    803eea <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803eb2:	83 ec 0c             	sub    $0xc,%esp
  803eb5:	ff 75 0c             	pushl  0xc(%ebp)
  803eb8:	e8 7b eb ff ff       	call   802a38 <alloc_block_FF>
  803ebd:	83 c4 10             	add    $0x10,%esp
  803ec0:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803ec3:	83 ec 08             	sub    $0x8,%esp
  803ec6:	ff 75 c0             	pushl  -0x40(%ebp)
  803ec9:	ff 75 08             	pushl  0x8(%ebp)
  803ecc:	e8 c9 fa ff ff       	call   80399a <copy_data>
  803ed1:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803ed4:	83 ec 0c             	sub    $0xc,%esp
  803ed7:	ff 75 08             	pushl  0x8(%ebp)
  803eda:	e8 fa f9 ff ff       	call   8038d9 <free_block>
  803edf:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803ee2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803ee5:	e9 f8 01 00 00       	jmp    8040e2 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803eea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803eed:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803ef0:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803ef3:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803ef7:	0f 87 a0 00 00 00    	ja     803f9d <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803efd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f01:	75 17                	jne    803f1a <realloc_block_FF+0x541>
  803f03:	83 ec 04             	sub    $0x4,%esp
  803f06:	68 03 50 80 00       	push   $0x805003
  803f0b:	68 38 02 00 00       	push   $0x238
  803f10:	68 21 50 80 00       	push   $0x805021
  803f15:	e8 4f cb ff ff       	call   800a69 <_panic>
  803f1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1d:	8b 00                	mov    (%eax),%eax
  803f1f:	85 c0                	test   %eax,%eax
  803f21:	74 10                	je     803f33 <realloc_block_FF+0x55a>
  803f23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f26:	8b 00                	mov    (%eax),%eax
  803f28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f2b:	8b 52 04             	mov    0x4(%edx),%edx
  803f2e:	89 50 04             	mov    %edx,0x4(%eax)
  803f31:	eb 0b                	jmp    803f3e <realloc_block_FF+0x565>
  803f33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f36:	8b 40 04             	mov    0x4(%eax),%eax
  803f39:	a3 48 60 80 00       	mov    %eax,0x806048
  803f3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f41:	8b 40 04             	mov    0x4(%eax),%eax
  803f44:	85 c0                	test   %eax,%eax
  803f46:	74 0f                	je     803f57 <realloc_block_FF+0x57e>
  803f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f4b:	8b 40 04             	mov    0x4(%eax),%eax
  803f4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f51:	8b 12                	mov    (%edx),%edx
  803f53:	89 10                	mov    %edx,(%eax)
  803f55:	eb 0a                	jmp    803f61 <realloc_block_FF+0x588>
  803f57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5a:	8b 00                	mov    (%eax),%eax
  803f5c:	a3 44 60 80 00       	mov    %eax,0x806044
  803f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f74:	a1 50 60 80 00       	mov    0x806050,%eax
  803f79:	48                   	dec    %eax
  803f7a:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803f7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f85:	01 d0                	add    %edx,%eax
  803f87:	83 ec 04             	sub    $0x4,%esp
  803f8a:	6a 01                	push   $0x1
  803f8c:	50                   	push   %eax
  803f8d:	ff 75 08             	pushl  0x8(%ebp)
  803f90:	e8 74 ea ff ff       	call   802a09 <set_block_data>
  803f95:	83 c4 10             	add    $0x10,%esp
  803f98:	e9 36 01 00 00       	jmp    8040d3 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803f9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fa0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803fa3:	01 d0                	add    %edx,%eax
  803fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803fa8:	83 ec 04             	sub    $0x4,%esp
  803fab:	6a 01                	push   $0x1
  803fad:	ff 75 f0             	pushl  -0x10(%ebp)
  803fb0:	ff 75 08             	pushl  0x8(%ebp)
  803fb3:	e8 51 ea ff ff       	call   802a09 <set_block_data>
  803fb8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fbe:	83 e8 04             	sub    $0x4,%eax
  803fc1:	8b 00                	mov    (%eax),%eax
  803fc3:	83 e0 fe             	and    $0xfffffffe,%eax
  803fc6:	89 c2                	mov    %eax,%edx
  803fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803fcb:	01 d0                	add    %edx,%eax
  803fcd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803fd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fd4:	74 06                	je     803fdc <realloc_block_FF+0x603>
  803fd6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803fda:	75 17                	jne    803ff3 <realloc_block_FF+0x61a>
  803fdc:	83 ec 04             	sub    $0x4,%esp
  803fdf:	68 94 50 80 00       	push   $0x805094
  803fe4:	68 44 02 00 00       	push   $0x244
  803fe9:	68 21 50 80 00       	push   $0x805021
  803fee:	e8 76 ca ff ff       	call   800a69 <_panic>
  803ff3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff6:	8b 10                	mov    (%eax),%edx
  803ff8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ffb:	89 10                	mov    %edx,(%eax)
  803ffd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804000:	8b 00                	mov    (%eax),%eax
  804002:	85 c0                	test   %eax,%eax
  804004:	74 0b                	je     804011 <realloc_block_FF+0x638>
  804006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804009:	8b 00                	mov    (%eax),%eax
  80400b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80400e:	89 50 04             	mov    %edx,0x4(%eax)
  804011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804014:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804017:	89 10                	mov    %edx,(%eax)
  804019:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80401c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80401f:	89 50 04             	mov    %edx,0x4(%eax)
  804022:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804025:	8b 00                	mov    (%eax),%eax
  804027:	85 c0                	test   %eax,%eax
  804029:	75 08                	jne    804033 <realloc_block_FF+0x65a>
  80402b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80402e:	a3 48 60 80 00       	mov    %eax,0x806048
  804033:	a1 50 60 80 00       	mov    0x806050,%eax
  804038:	40                   	inc    %eax
  804039:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80403e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804042:	75 17                	jne    80405b <realloc_block_FF+0x682>
  804044:	83 ec 04             	sub    $0x4,%esp
  804047:	68 03 50 80 00       	push   $0x805003
  80404c:	68 45 02 00 00       	push   $0x245
  804051:	68 21 50 80 00       	push   $0x805021
  804056:	e8 0e ca ff ff       	call   800a69 <_panic>
  80405b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80405e:	8b 00                	mov    (%eax),%eax
  804060:	85 c0                	test   %eax,%eax
  804062:	74 10                	je     804074 <realloc_block_FF+0x69b>
  804064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804067:	8b 00                	mov    (%eax),%eax
  804069:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80406c:	8b 52 04             	mov    0x4(%edx),%edx
  80406f:	89 50 04             	mov    %edx,0x4(%eax)
  804072:	eb 0b                	jmp    80407f <realloc_block_FF+0x6a6>
  804074:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804077:	8b 40 04             	mov    0x4(%eax),%eax
  80407a:	a3 48 60 80 00       	mov    %eax,0x806048
  80407f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804082:	8b 40 04             	mov    0x4(%eax),%eax
  804085:	85 c0                	test   %eax,%eax
  804087:	74 0f                	je     804098 <realloc_block_FF+0x6bf>
  804089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80408c:	8b 40 04             	mov    0x4(%eax),%eax
  80408f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804092:	8b 12                	mov    (%edx),%edx
  804094:	89 10                	mov    %edx,(%eax)
  804096:	eb 0a                	jmp    8040a2 <realloc_block_FF+0x6c9>
  804098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80409b:	8b 00                	mov    (%eax),%eax
  80409d:	a3 44 60 80 00       	mov    %eax,0x806044
  8040a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040b5:	a1 50 60 80 00       	mov    0x806050,%eax
  8040ba:	48                   	dec    %eax
  8040bb:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  8040c0:	83 ec 04             	sub    $0x4,%esp
  8040c3:	6a 00                	push   $0x0
  8040c5:	ff 75 bc             	pushl  -0x44(%ebp)
  8040c8:	ff 75 b8             	pushl  -0x48(%ebp)
  8040cb:	e8 39 e9 ff ff       	call   802a09 <set_block_data>
  8040d0:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8040d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d6:	eb 0a                	jmp    8040e2 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8040d8:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8040df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8040e2:	c9                   	leave  
  8040e3:	c3                   	ret    

008040e4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8040e4:	55                   	push   %ebp
  8040e5:	89 e5                	mov    %esp,%ebp
  8040e7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8040ea:	83 ec 04             	sub    $0x4,%esp
  8040ed:	68 00 51 80 00       	push   $0x805100
  8040f2:	68 58 02 00 00       	push   $0x258
  8040f7:	68 21 50 80 00       	push   $0x805021
  8040fc:	e8 68 c9 ff ff       	call   800a69 <_panic>

00804101 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804101:	55                   	push   %ebp
  804102:	89 e5                	mov    %esp,%ebp
  804104:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804107:	83 ec 04             	sub    $0x4,%esp
  80410a:	68 28 51 80 00       	push   $0x805128
  80410f:	68 61 02 00 00       	push   $0x261
  804114:	68 21 50 80 00       	push   $0x805021
  804119:	e8 4b c9 ff ff       	call   800a69 <_panic>
  80411e:	66 90                	xchg   %ax,%ax

00804120 <__udivdi3>:
  804120:	55                   	push   %ebp
  804121:	57                   	push   %edi
  804122:	56                   	push   %esi
  804123:	53                   	push   %ebx
  804124:	83 ec 1c             	sub    $0x1c,%esp
  804127:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80412b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80412f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804133:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804137:	89 ca                	mov    %ecx,%edx
  804139:	89 f8                	mov    %edi,%eax
  80413b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80413f:	85 f6                	test   %esi,%esi
  804141:	75 2d                	jne    804170 <__udivdi3+0x50>
  804143:	39 cf                	cmp    %ecx,%edi
  804145:	77 65                	ja     8041ac <__udivdi3+0x8c>
  804147:	89 fd                	mov    %edi,%ebp
  804149:	85 ff                	test   %edi,%edi
  80414b:	75 0b                	jne    804158 <__udivdi3+0x38>
  80414d:	b8 01 00 00 00       	mov    $0x1,%eax
  804152:	31 d2                	xor    %edx,%edx
  804154:	f7 f7                	div    %edi
  804156:	89 c5                	mov    %eax,%ebp
  804158:	31 d2                	xor    %edx,%edx
  80415a:	89 c8                	mov    %ecx,%eax
  80415c:	f7 f5                	div    %ebp
  80415e:	89 c1                	mov    %eax,%ecx
  804160:	89 d8                	mov    %ebx,%eax
  804162:	f7 f5                	div    %ebp
  804164:	89 cf                	mov    %ecx,%edi
  804166:	89 fa                	mov    %edi,%edx
  804168:	83 c4 1c             	add    $0x1c,%esp
  80416b:	5b                   	pop    %ebx
  80416c:	5e                   	pop    %esi
  80416d:	5f                   	pop    %edi
  80416e:	5d                   	pop    %ebp
  80416f:	c3                   	ret    
  804170:	39 ce                	cmp    %ecx,%esi
  804172:	77 28                	ja     80419c <__udivdi3+0x7c>
  804174:	0f bd fe             	bsr    %esi,%edi
  804177:	83 f7 1f             	xor    $0x1f,%edi
  80417a:	75 40                	jne    8041bc <__udivdi3+0x9c>
  80417c:	39 ce                	cmp    %ecx,%esi
  80417e:	72 0a                	jb     80418a <__udivdi3+0x6a>
  804180:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804184:	0f 87 9e 00 00 00    	ja     804228 <__udivdi3+0x108>
  80418a:	b8 01 00 00 00       	mov    $0x1,%eax
  80418f:	89 fa                	mov    %edi,%edx
  804191:	83 c4 1c             	add    $0x1c,%esp
  804194:	5b                   	pop    %ebx
  804195:	5e                   	pop    %esi
  804196:	5f                   	pop    %edi
  804197:	5d                   	pop    %ebp
  804198:	c3                   	ret    
  804199:	8d 76 00             	lea    0x0(%esi),%esi
  80419c:	31 ff                	xor    %edi,%edi
  80419e:	31 c0                	xor    %eax,%eax
  8041a0:	89 fa                	mov    %edi,%edx
  8041a2:	83 c4 1c             	add    $0x1c,%esp
  8041a5:	5b                   	pop    %ebx
  8041a6:	5e                   	pop    %esi
  8041a7:	5f                   	pop    %edi
  8041a8:	5d                   	pop    %ebp
  8041a9:	c3                   	ret    
  8041aa:	66 90                	xchg   %ax,%ax
  8041ac:	89 d8                	mov    %ebx,%eax
  8041ae:	f7 f7                	div    %edi
  8041b0:	31 ff                	xor    %edi,%edi
  8041b2:	89 fa                	mov    %edi,%edx
  8041b4:	83 c4 1c             	add    $0x1c,%esp
  8041b7:	5b                   	pop    %ebx
  8041b8:	5e                   	pop    %esi
  8041b9:	5f                   	pop    %edi
  8041ba:	5d                   	pop    %ebp
  8041bb:	c3                   	ret    
  8041bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8041c1:	89 eb                	mov    %ebp,%ebx
  8041c3:	29 fb                	sub    %edi,%ebx
  8041c5:	89 f9                	mov    %edi,%ecx
  8041c7:	d3 e6                	shl    %cl,%esi
  8041c9:	89 c5                	mov    %eax,%ebp
  8041cb:	88 d9                	mov    %bl,%cl
  8041cd:	d3 ed                	shr    %cl,%ebp
  8041cf:	89 e9                	mov    %ebp,%ecx
  8041d1:	09 f1                	or     %esi,%ecx
  8041d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8041d7:	89 f9                	mov    %edi,%ecx
  8041d9:	d3 e0                	shl    %cl,%eax
  8041db:	89 c5                	mov    %eax,%ebp
  8041dd:	89 d6                	mov    %edx,%esi
  8041df:	88 d9                	mov    %bl,%cl
  8041e1:	d3 ee                	shr    %cl,%esi
  8041e3:	89 f9                	mov    %edi,%ecx
  8041e5:	d3 e2                	shl    %cl,%edx
  8041e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041eb:	88 d9                	mov    %bl,%cl
  8041ed:	d3 e8                	shr    %cl,%eax
  8041ef:	09 c2                	or     %eax,%edx
  8041f1:	89 d0                	mov    %edx,%eax
  8041f3:	89 f2                	mov    %esi,%edx
  8041f5:	f7 74 24 0c          	divl   0xc(%esp)
  8041f9:	89 d6                	mov    %edx,%esi
  8041fb:	89 c3                	mov    %eax,%ebx
  8041fd:	f7 e5                	mul    %ebp
  8041ff:	39 d6                	cmp    %edx,%esi
  804201:	72 19                	jb     80421c <__udivdi3+0xfc>
  804203:	74 0b                	je     804210 <__udivdi3+0xf0>
  804205:	89 d8                	mov    %ebx,%eax
  804207:	31 ff                	xor    %edi,%edi
  804209:	e9 58 ff ff ff       	jmp    804166 <__udivdi3+0x46>
  80420e:	66 90                	xchg   %ax,%ax
  804210:	8b 54 24 08          	mov    0x8(%esp),%edx
  804214:	89 f9                	mov    %edi,%ecx
  804216:	d3 e2                	shl    %cl,%edx
  804218:	39 c2                	cmp    %eax,%edx
  80421a:	73 e9                	jae    804205 <__udivdi3+0xe5>
  80421c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80421f:	31 ff                	xor    %edi,%edi
  804221:	e9 40 ff ff ff       	jmp    804166 <__udivdi3+0x46>
  804226:	66 90                	xchg   %ax,%ax
  804228:	31 c0                	xor    %eax,%eax
  80422a:	e9 37 ff ff ff       	jmp    804166 <__udivdi3+0x46>
  80422f:	90                   	nop

00804230 <__umoddi3>:
  804230:	55                   	push   %ebp
  804231:	57                   	push   %edi
  804232:	56                   	push   %esi
  804233:	53                   	push   %ebx
  804234:	83 ec 1c             	sub    $0x1c,%esp
  804237:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80423b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80423f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804243:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804247:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80424b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80424f:	89 f3                	mov    %esi,%ebx
  804251:	89 fa                	mov    %edi,%edx
  804253:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804257:	89 34 24             	mov    %esi,(%esp)
  80425a:	85 c0                	test   %eax,%eax
  80425c:	75 1a                	jne    804278 <__umoddi3+0x48>
  80425e:	39 f7                	cmp    %esi,%edi
  804260:	0f 86 a2 00 00 00    	jbe    804308 <__umoddi3+0xd8>
  804266:	89 c8                	mov    %ecx,%eax
  804268:	89 f2                	mov    %esi,%edx
  80426a:	f7 f7                	div    %edi
  80426c:	89 d0                	mov    %edx,%eax
  80426e:	31 d2                	xor    %edx,%edx
  804270:	83 c4 1c             	add    $0x1c,%esp
  804273:	5b                   	pop    %ebx
  804274:	5e                   	pop    %esi
  804275:	5f                   	pop    %edi
  804276:	5d                   	pop    %ebp
  804277:	c3                   	ret    
  804278:	39 f0                	cmp    %esi,%eax
  80427a:	0f 87 ac 00 00 00    	ja     80432c <__umoddi3+0xfc>
  804280:	0f bd e8             	bsr    %eax,%ebp
  804283:	83 f5 1f             	xor    $0x1f,%ebp
  804286:	0f 84 ac 00 00 00    	je     804338 <__umoddi3+0x108>
  80428c:	bf 20 00 00 00       	mov    $0x20,%edi
  804291:	29 ef                	sub    %ebp,%edi
  804293:	89 fe                	mov    %edi,%esi
  804295:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804299:	89 e9                	mov    %ebp,%ecx
  80429b:	d3 e0                	shl    %cl,%eax
  80429d:	89 d7                	mov    %edx,%edi
  80429f:	89 f1                	mov    %esi,%ecx
  8042a1:	d3 ef                	shr    %cl,%edi
  8042a3:	09 c7                	or     %eax,%edi
  8042a5:	89 e9                	mov    %ebp,%ecx
  8042a7:	d3 e2                	shl    %cl,%edx
  8042a9:	89 14 24             	mov    %edx,(%esp)
  8042ac:	89 d8                	mov    %ebx,%eax
  8042ae:	d3 e0                	shl    %cl,%eax
  8042b0:	89 c2                	mov    %eax,%edx
  8042b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042b6:	d3 e0                	shl    %cl,%eax
  8042b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042c0:	89 f1                	mov    %esi,%ecx
  8042c2:	d3 e8                	shr    %cl,%eax
  8042c4:	09 d0                	or     %edx,%eax
  8042c6:	d3 eb                	shr    %cl,%ebx
  8042c8:	89 da                	mov    %ebx,%edx
  8042ca:	f7 f7                	div    %edi
  8042cc:	89 d3                	mov    %edx,%ebx
  8042ce:	f7 24 24             	mull   (%esp)
  8042d1:	89 c6                	mov    %eax,%esi
  8042d3:	89 d1                	mov    %edx,%ecx
  8042d5:	39 d3                	cmp    %edx,%ebx
  8042d7:	0f 82 87 00 00 00    	jb     804364 <__umoddi3+0x134>
  8042dd:	0f 84 91 00 00 00    	je     804374 <__umoddi3+0x144>
  8042e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8042e7:	29 f2                	sub    %esi,%edx
  8042e9:	19 cb                	sbb    %ecx,%ebx
  8042eb:	89 d8                	mov    %ebx,%eax
  8042ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042f1:	d3 e0                	shl    %cl,%eax
  8042f3:	89 e9                	mov    %ebp,%ecx
  8042f5:	d3 ea                	shr    %cl,%edx
  8042f7:	09 d0                	or     %edx,%eax
  8042f9:	89 e9                	mov    %ebp,%ecx
  8042fb:	d3 eb                	shr    %cl,%ebx
  8042fd:	89 da                	mov    %ebx,%edx
  8042ff:	83 c4 1c             	add    $0x1c,%esp
  804302:	5b                   	pop    %ebx
  804303:	5e                   	pop    %esi
  804304:	5f                   	pop    %edi
  804305:	5d                   	pop    %ebp
  804306:	c3                   	ret    
  804307:	90                   	nop
  804308:	89 fd                	mov    %edi,%ebp
  80430a:	85 ff                	test   %edi,%edi
  80430c:	75 0b                	jne    804319 <__umoddi3+0xe9>
  80430e:	b8 01 00 00 00       	mov    $0x1,%eax
  804313:	31 d2                	xor    %edx,%edx
  804315:	f7 f7                	div    %edi
  804317:	89 c5                	mov    %eax,%ebp
  804319:	89 f0                	mov    %esi,%eax
  80431b:	31 d2                	xor    %edx,%edx
  80431d:	f7 f5                	div    %ebp
  80431f:	89 c8                	mov    %ecx,%eax
  804321:	f7 f5                	div    %ebp
  804323:	89 d0                	mov    %edx,%eax
  804325:	e9 44 ff ff ff       	jmp    80426e <__umoddi3+0x3e>
  80432a:	66 90                	xchg   %ax,%ax
  80432c:	89 c8                	mov    %ecx,%eax
  80432e:	89 f2                	mov    %esi,%edx
  804330:	83 c4 1c             	add    $0x1c,%esp
  804333:	5b                   	pop    %ebx
  804334:	5e                   	pop    %esi
  804335:	5f                   	pop    %edi
  804336:	5d                   	pop    %ebp
  804337:	c3                   	ret    
  804338:	3b 04 24             	cmp    (%esp),%eax
  80433b:	72 06                	jb     804343 <__umoddi3+0x113>
  80433d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804341:	77 0f                	ja     804352 <__umoddi3+0x122>
  804343:	89 f2                	mov    %esi,%edx
  804345:	29 f9                	sub    %edi,%ecx
  804347:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80434b:	89 14 24             	mov    %edx,(%esp)
  80434e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804352:	8b 44 24 04          	mov    0x4(%esp),%eax
  804356:	8b 14 24             	mov    (%esp),%edx
  804359:	83 c4 1c             	add    $0x1c,%esp
  80435c:	5b                   	pop    %ebx
  80435d:	5e                   	pop    %esi
  80435e:	5f                   	pop    %edi
  80435f:	5d                   	pop    %ebp
  804360:	c3                   	ret    
  804361:	8d 76 00             	lea    0x0(%esi),%esi
  804364:	2b 04 24             	sub    (%esp),%eax
  804367:	19 fa                	sbb    %edi,%edx
  804369:	89 d1                	mov    %edx,%ecx
  80436b:	89 c6                	mov    %eax,%esi
  80436d:	e9 71 ff ff ff       	jmp    8042e3 <__umoddi3+0xb3>
  804372:	66 90                	xchg   %ax,%ax
  804374:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804378:	72 ea                	jb     804364 <__umoddi3+0x134>
  80437a:	89 d9                	mov    %ebx,%ecx
  80437c:	e9 62 ff ff ff       	jmp    8042e3 <__umoddi3+0xb3>
