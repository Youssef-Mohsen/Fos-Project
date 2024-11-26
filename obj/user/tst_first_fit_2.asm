
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
  800055:	68 40 43 80 00       	push   $0x804340
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
  8000a5:	68 70 43 80 00       	push   $0x804370
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
  8000d1:	e8 4d 24 00 00       	call   802523 <sys_set_uheap_strategy>
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
  8000f6:	68 a9 43 80 00       	push   $0x8043a9
  8000fb:	6a 26                	push   $0x26
  8000fd:	68 c5 43 80 00       	push   $0x8043c5
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
  800123:	e8 48 20 00 00       	call   802170 <sys_pf_calculate_allocated_pages>
  800128:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 f5 1f 00 00       	call   802125 <sys_calculate_free_frames>
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
  80013d:	68 dc 43 80 00       	push   $0x8043dc
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
  8002ac:	68 34 44 80 00       	push   $0x804434
  8002b1:	6a 69                	push   $0x69
  8002b3:	68 c5 43 80 00       	push   $0x8043c5
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
  800328:	68 5c 44 80 00       	push   $0x80445c
  80032d:	e8 f4 09 00 00       	call   800d26 <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800335:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80033b:	83 e8 08             	sub    $0x8,%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	6a 01                	push   $0x1
  800343:	50                   	push   %eax
  800344:	e8 1c 23 00 00       	call   802665 <alloc_block>
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
  800392:	68 80 44 80 00       	push   $0x804480
  800397:	68 80 00 00 00       	push   $0x80
  80039c:	68 c5 43 80 00       	push   $0x8043c5
  8003a1:	e8 c3 06 00 00       	call   800a69 <_panic>
		}
	}

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 a8 44 80 00       	push   $0x8044a8
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
  800451:	68 f0 44 80 00       	push   $0x8044f0
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
  80046e:	68 10 45 80 00       	push   $0x804510
  800473:	e8 ae 08 00 00       	call   800d26 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp

	uint32 testSizes[numOfFFTests] =
  80047b:	8d 85 2c ff ff ff    	lea    -0xd4(%ebp),%eax
  800481:	bb d4 48 80 00       	mov    $0x8048d4,%ebx
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
  8005a7:	68 6c 45 80 00       	push   $0x80456c
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
  80060a:	e8 1f 20 00 00       	call   80262e <get_block_size>
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
  800627:	68 9c 45 80 00       	push   $0x80459c
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
  800641:	68 68 46 80 00       	push   $0x804668
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
  800714:	68 b4 46 80 00       	push   $0x8046b4
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
  80074f:	68 e0 46 80 00       	push   $0x8046e0
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
  800808:	68 14 47 80 00       	push   $0x804714
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
  800831:	68 78 47 80 00       	push   $0x804778
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
  8008a8:	68 98 47 80 00       	push   $0x804798
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
  8008f7:	68 08 48 80 00       	push   $0x804808
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
  800914:	68 8c 48 80 00       	push   $0x80488c
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
  800930:	e8 b9 19 00 00       	call   8022ee <sys_getenvindex>
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
  80099e:	e8 cf 16 00 00       	call   802072 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8009a3:	83 ec 0c             	sub    $0xc,%esp
  8009a6:	68 f8 48 80 00       	push   $0x8048f8
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
  8009ce:	68 20 49 80 00       	push   $0x804920
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
  8009ff:	68 48 49 80 00       	push   $0x804948
  800a04:	e8 1d 03 00 00       	call   800d26 <cprintf>
  800a09:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a0c:	a1 20 60 80 00       	mov    0x806020,%eax
  800a11:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	50                   	push   %eax
  800a1b:	68 a0 49 80 00       	push   $0x8049a0
  800a20:	e8 01 03 00 00       	call   800d26 <cprintf>
  800a25:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	68 f8 48 80 00       	push   $0x8048f8
  800a30:	e8 f1 02 00 00       	call   800d26 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800a38:	e8 4f 16 00 00       	call   80208c <sys_unlock_cons>
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
  800a50:	e8 65 18 00 00       	call   8022ba <sys_destroy_env>
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
  800a61:	e8 ba 18 00 00       	call   802320 <sys_exit_env>
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
  800a8a:	68 b4 49 80 00       	push   $0x8049b4
  800a8f:	e8 92 02 00 00       	call   800d26 <cprintf>
  800a94:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a97:	a1 1c 60 80 00       	mov    0x80601c,%eax
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	ff 75 08             	pushl  0x8(%ebp)
  800aa2:	50                   	push   %eax
  800aa3:	68 b9 49 80 00       	push   $0x8049b9
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
  800ac7:	68 d5 49 80 00       	push   $0x8049d5
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
  800af6:	68 d8 49 80 00       	push   $0x8049d8
  800afb:	6a 26                	push   $0x26
  800afd:	68 24 4a 80 00       	push   $0x804a24
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
  800bcb:	68 30 4a 80 00       	push   $0x804a30
  800bd0:	6a 3a                	push   $0x3a
  800bd2:	68 24 4a 80 00       	push   $0x804a24
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
  800c3e:	68 84 4a 80 00       	push   $0x804a84
  800c43:	6a 44                	push   $0x44
  800c45:	68 24 4a 80 00       	push   $0x804a24
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
  800c98:	e8 93 13 00 00       	call   802030 <sys_cputs>
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
  800d0f:	e8 1c 13 00 00       	call   802030 <sys_cputs>
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
  800d59:	e8 14 13 00 00       	call   802072 <sys_lock_cons>
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
  800d79:	e8 0e 13 00 00       	call   80208c <sys_unlock_cons>
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
  800dc3:	e8 00 33 00 00       	call   8040c8 <__udivdi3>
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
  800e13:	e8 c0 33 00 00       	call   8041d8 <__umoddi3>
  800e18:	83 c4 10             	add    $0x10,%esp
  800e1b:	05 f4 4c 80 00       	add    $0x804cf4,%eax
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
  800f6e:	8b 04 85 18 4d 80 00 	mov    0x804d18(,%eax,4),%eax
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
  80104f:	8b 34 9d 60 4b 80 00 	mov    0x804b60(,%ebx,4),%esi
  801056:	85 f6                	test   %esi,%esi
  801058:	75 19                	jne    801073 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80105a:	53                   	push   %ebx
  80105b:	68 05 4d 80 00       	push   $0x804d05
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
  801074:	68 0e 4d 80 00       	push   $0x804d0e
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
  8010a1:	be 11 4d 80 00       	mov    $0x804d11,%esi
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
  801aac:	68 88 4e 80 00       	push   $0x804e88
  801ab1:	68 3f 01 00 00       	push   $0x13f
  801ab6:	68 aa 4e 80 00       	push   $0x804eaa
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
  801acc:	e8 0a 0b 00 00       	call   8025db <sys_sbrk>
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
  801b47:	e8 13 09 00 00       	call   80245f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	74 16                	je     801b66 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	e8 53 0e 00 00       	call   8029ae <alloc_block_FF>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b61:	e9 8a 01 00 00       	jmp    801cf0 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b66:	e8 25 09 00 00       	call   802490 <sys_isUHeapPlacementStrategyBESTFIT>
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	0f 84 7d 01 00 00    	je     801cf0 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	e8 ec 12 00 00       	call   802e6a <alloc_block_BF>
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
		//cprintf("52\n");
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
			//cprintf("57\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdb:	05 00 10 00 00       	add    $0x1000,%eax
  801be0:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801be3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
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
						//cprintf("71\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
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
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801c83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c87:	75 16                	jne    801c9f <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801c89:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801c90:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801c97:	0f 86 15 ff ff ff    	jbe    801bb2 <malloc+0xdc>
  801c9d:	eb 01                	jmp    801ca0 <malloc+0x1ca>
				}
				//cprintf("79\n");

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
  801cdf:	e8 2e 09 00 00       	call   802612 <sys_allocate_user_mem>
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	eb 07                	jmp    801cf0 <malloc+0x21a>
		//cprintf("91\n");
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
  801d27:	e8 02 09 00 00       	call   80262e <get_block_size>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 35 1b 00 00       	call   803872 <free_block>
  801d3d:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  801d8c:	eb 2f                	jmp    801dbd <free+0xc8>
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
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801dba:	ff 45 f4             	incl   -0xc(%ebp)
  801dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801dc3:	72 c9                	jb     801d8e <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	83 ec 08             	sub    $0x8,%esp
  801dcb:	ff 75 ec             	pushl  -0x14(%ebp)
  801dce:	50                   	push   %eax
  801dcf:	e8 22 08 00 00       	call   8025f6 <sys_free_user_mem>
  801dd4:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801dd7:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801dd8:	eb 17                	jmp    801df1 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801dda:	83 ec 04             	sub    $0x4,%esp
  801ddd:	68 b8 4e 80 00       	push   $0x804eb8
  801de2:	68 85 00 00 00       	push   $0x85
  801de7:	68 e2 4e 80 00       	push   $0x804ee2
  801dec:	e8 78 ec ff ff       	call   800a69 <_panic>
	}
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 28             	sub    $0x28,%esp
  801df9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfc:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801dff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e03:	75 0a                	jne    801e0f <smalloc+0x1c>
  801e05:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0a:	e9 9a 00 00 00       	jmp    801ea9 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e15:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e22:	39 d0                	cmp    %edx,%eax
  801e24:	73 02                	jae    801e28 <smalloc+0x35>
  801e26:	89 d0                	mov    %edx,%eax
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	50                   	push   %eax
  801e2c:	e8 a5 fc ff ff       	call   801ad6 <malloc>
  801e31:	83 c4 10             	add    $0x10,%esp
  801e34:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e3b:	75 07                	jne    801e44 <smalloc+0x51>
  801e3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e42:	eb 65                	jmp    801ea9 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e44:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e48:	ff 75 ec             	pushl  -0x14(%ebp)
  801e4b:	50                   	push   %eax
  801e4c:	ff 75 0c             	pushl  0xc(%ebp)
  801e4f:	ff 75 08             	pushl  0x8(%ebp)
  801e52:	e8 a6 03 00 00       	call   8021fd <sys_createSharedObject>
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e5d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e61:	74 06                	je     801e69 <smalloc+0x76>
  801e63:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e67:	75 07                	jne    801e70 <smalloc+0x7d>
  801e69:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6e:	eb 39                	jmp    801ea9 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801e70:	83 ec 08             	sub    $0x8,%esp
  801e73:	ff 75 ec             	pushl  -0x14(%ebp)
  801e76:	68 ee 4e 80 00       	push   $0x804eee
  801e7b:	e8 a6 ee ff ff       	call   800d26 <cprintf>
  801e80:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801e83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e86:	a1 20 60 80 00       	mov    0x806020,%eax
  801e8b:	8b 40 78             	mov    0x78(%eax),%eax
  801e8e:	29 c2                	sub    %eax,%edx
  801e90:	89 d0                	mov    %edx,%eax
  801e92:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e97:	c1 e8 0c             	shr    $0xc,%eax
  801e9a:	89 c2                	mov    %eax,%edx
  801e9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e9f:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	 return ptr;
  801ea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801eb1:	83 ec 08             	sub    $0x8,%esp
  801eb4:	ff 75 0c             	pushl  0xc(%ebp)
  801eb7:	ff 75 08             	pushl  0x8(%ebp)
  801eba:	e8 68 03 00 00       	call   802227 <sys_getSizeOfSharedObject>
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801ec5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801ec9:	75 07                	jne    801ed2 <sget+0x27>
  801ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed0:	eb 7f                	jmp    801f51 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ed8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801edf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee5:	39 d0                	cmp    %edx,%eax
  801ee7:	7d 02                	jge    801eeb <sget+0x40>
  801ee9:	89 d0                	mov    %edx,%eax
  801eeb:	83 ec 0c             	sub    $0xc,%esp
  801eee:	50                   	push   %eax
  801eef:	e8 e2 fb ff ff       	call   801ad6 <malloc>
  801ef4:	83 c4 10             	add    $0x10,%esp
  801ef7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801efa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801efe:	75 07                	jne    801f07 <sget+0x5c>
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
  801f05:	eb 4a                	jmp    801f51 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	ff 75 e8             	pushl  -0x18(%ebp)
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	ff 75 08             	pushl  0x8(%ebp)
  801f13:	e8 2c 03 00 00       	call   802244 <sys_getSharedObject>
  801f18:	83 c4 10             	add    $0x10,%esp
  801f1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801f1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f21:	a1 20 60 80 00       	mov    0x806020,%eax
  801f26:	8b 40 78             	mov    0x78(%eax),%eax
  801f29:	29 c2                	sub    %eax,%edx
  801f2b:	89 d0                	mov    %edx,%eax
  801f2d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f32:	c1 e8 0c             	shr    $0xc,%eax
  801f35:	89 c2                	mov    %eax,%edx
  801f37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f3a:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801f41:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f45:	75 07                	jne    801f4e <sget+0xa3>
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4c:	eb 03                	jmp    801f51 <sget+0xa6>
	return ptr;
  801f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801f59:	8b 55 08             	mov    0x8(%ebp),%edx
  801f5c:	a1 20 60 80 00       	mov    0x806020,%eax
  801f61:	8b 40 78             	mov    0x78(%eax),%eax
  801f64:	29 c2                	sub    %eax,%edx
  801f66:	89 d0                	mov    %edx,%eax
  801f68:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f6d:	c1 e8 0c             	shr    $0xc,%eax
  801f70:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
  801f77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801f7a:	83 ec 08             	sub    $0x8,%esp
  801f7d:	ff 75 08             	pushl  0x8(%ebp)
  801f80:	ff 75 f4             	pushl  -0xc(%ebp)
  801f83:	e8 db 02 00 00       	call   802263 <sys_freeSharedObject>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801f8e:	90                   	nop
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f97:	83 ec 04             	sub    $0x4,%esp
  801f9a:	68 00 4f 80 00       	push   $0x804f00
  801f9f:	68 de 00 00 00       	push   $0xde
  801fa4:	68 e2 4e 80 00       	push   $0x804ee2
  801fa9:	e8 bb ea ff ff       	call   800a69 <_panic>

00801fae <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fb4:	83 ec 04             	sub    $0x4,%esp
  801fb7:	68 26 4f 80 00       	push   $0x804f26
  801fbc:	68 ea 00 00 00       	push   $0xea
  801fc1:	68 e2 4e 80 00       	push   $0x804ee2
  801fc6:	e8 9e ea ff ff       	call   800a69 <_panic>

00801fcb <shrink>:

}
void shrink(uint32 newSize)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	68 26 4f 80 00       	push   $0x804f26
  801fd9:	68 ef 00 00 00       	push   $0xef
  801fde:	68 e2 4e 80 00       	push   $0x804ee2
  801fe3:	e8 81 ea ff ff       	call   800a69 <_panic>

00801fe8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fee:	83 ec 04             	sub    $0x4,%esp
  801ff1:	68 26 4f 80 00       	push   $0x804f26
  801ff6:	68 f4 00 00 00       	push   $0xf4
  801ffb:	68 e2 4e 80 00       	push   $0x804ee2
  802000:	e8 64 ea ff ff       	call   800a69 <_panic>

00802005 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	57                   	push   %edi
  802009:	56                   	push   %esi
  80200a:	53                   	push   %ebx
  80200b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	8b 55 0c             	mov    0xc(%ebp),%edx
  802014:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802017:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80201a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80201d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802020:	cd 30                	int    $0x30
  802022:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802025:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	5b                   	pop    %ebx
  80202c:	5e                   	pop    %esi
  80202d:	5f                   	pop    %edi
  80202e:	5d                   	pop    %ebp
  80202f:	c3                   	ret    

00802030 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 04             	sub    $0x4,%esp
  802036:	8b 45 10             	mov    0x10(%ebp),%eax
  802039:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80203c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	52                   	push   %edx
  802048:	ff 75 0c             	pushl  0xc(%ebp)
  80204b:	50                   	push   %eax
  80204c:	6a 00                	push   $0x0
  80204e:	e8 b2 ff ff ff       	call   802005 <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	90                   	nop
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_cgetc>:

int
sys_cgetc(void)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 02                	push   $0x2
  802068:	e8 98 ff ff ff       	call   802005 <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 03                	push   $0x3
  802081:	e8 7f ff ff ff       	call   802005 <syscall>
  802086:	83 c4 18             	add    $0x18,%esp
}
  802089:	90                   	nop
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 04                	push   $0x4
  80209b:	e8 65 ff ff ff       	call   802005 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	90                   	nop
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	52                   	push   %edx
  8020b6:	50                   	push   %eax
  8020b7:	6a 08                	push   $0x8
  8020b9:	e8 47 ff ff ff       	call   802005 <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	56                   	push   %esi
  8020c7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020c8:	8b 75 18             	mov    0x18(%ebp),%esi
  8020cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	56                   	push   %esi
  8020d8:	53                   	push   %ebx
  8020d9:	51                   	push   %ecx
  8020da:	52                   	push   %edx
  8020db:	50                   	push   %eax
  8020dc:	6a 09                	push   $0x9
  8020de:	e8 22 ff ff ff       	call   802005 <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
}
  8020e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e9:	5b                   	pop    %ebx
  8020ea:	5e                   	pop    %esi
  8020eb:	5d                   	pop    %ebp
  8020ec:	c3                   	ret    

008020ed <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	52                   	push   %edx
  8020fd:	50                   	push   %eax
  8020fe:	6a 0a                	push   $0xa
  802100:	e8 00 ff ff ff       	call   802005 <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	ff 75 0c             	pushl  0xc(%ebp)
  802116:	ff 75 08             	pushl  0x8(%ebp)
  802119:	6a 0b                	push   $0xb
  80211b:	e8 e5 fe ff ff       	call   802005 <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 0c                	push   $0xc
  802134:	e8 cc fe ff ff       	call   802005 <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 0d                	push   $0xd
  80214d:	e8 b3 fe ff ff       	call   802005 <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 0e                	push   $0xe
  802166:	e8 9a fe ff ff       	call   802005 <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 0f                	push   $0xf
  80217f:	e8 81 fe ff ff       	call   802005 <syscall>
  802184:	83 c4 18             	add    $0x18,%esp
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	ff 75 08             	pushl  0x8(%ebp)
  802197:	6a 10                	push   $0x10
  802199:	e8 67 fe ff ff       	call   802005 <syscall>
  80219e:	83 c4 18             	add    $0x18,%esp
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 11                	push   $0x11
  8021b2:	e8 4e fe ff ff       	call   802005 <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
}
  8021ba:	90                   	nop
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <sys_cputc>:

void
sys_cputc(const char c)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 04             	sub    $0x4,%esp
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021c9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	50                   	push   %eax
  8021d6:	6a 01                	push   $0x1
  8021d8:	e8 28 fe ff ff       	call   802005 <syscall>
  8021dd:	83 c4 18             	add    $0x18,%esp
}
  8021e0:	90                   	nop
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 14                	push   $0x14
  8021f2:	e8 0e fe ff ff       	call   802005 <syscall>
  8021f7:	83 c4 18             	add    $0x18,%esp
}
  8021fa:	90                   	nop
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 04             	sub    $0x4,%esp
  802203:	8b 45 10             	mov    0x10(%ebp),%eax
  802206:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802209:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80220c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	6a 00                	push   $0x0
  802215:	51                   	push   %ecx
  802216:	52                   	push   %edx
  802217:	ff 75 0c             	pushl  0xc(%ebp)
  80221a:	50                   	push   %eax
  80221b:	6a 15                	push   $0x15
  80221d:	e8 e3 fd ff ff       	call   802005 <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80222a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	52                   	push   %edx
  802237:	50                   	push   %eax
  802238:	6a 16                	push   $0x16
  80223a:	e8 c6 fd ff ff       	call   802005 <syscall>
  80223f:	83 c4 18             	add    $0x18,%esp
}
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802247:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80224a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	51                   	push   %ecx
  802255:	52                   	push   %edx
  802256:	50                   	push   %eax
  802257:	6a 17                	push   $0x17
  802259:	e8 a7 fd ff ff       	call   802005 <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802266:	8b 55 0c             	mov    0xc(%ebp),%edx
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	52                   	push   %edx
  802273:	50                   	push   %eax
  802274:	6a 18                	push   $0x18
  802276:	e8 8a fd ff ff       	call   802005 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	6a 00                	push   $0x0
  802288:	ff 75 14             	pushl  0x14(%ebp)
  80228b:	ff 75 10             	pushl  0x10(%ebp)
  80228e:	ff 75 0c             	pushl  0xc(%ebp)
  802291:	50                   	push   %eax
  802292:	6a 19                	push   $0x19
  802294:	e8 6c fd ff ff       	call   802005 <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	50                   	push   %eax
  8022ad:	6a 1a                	push   $0x1a
  8022af:	e8 51 fd ff ff       	call   802005 <syscall>
  8022b4:	83 c4 18             	add    $0x18,%esp
}
  8022b7:	90                   	nop
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	50                   	push   %eax
  8022c9:	6a 1b                	push   $0x1b
  8022cb:	e8 35 fd ff ff       	call   802005 <syscall>
  8022d0:	83 c4 18             	add    $0x18,%esp
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 05                	push   $0x5
  8022e4:	e8 1c fd ff ff       	call   802005 <syscall>
  8022e9:	83 c4 18             	add    $0x18,%esp
}
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 06                	push   $0x6
  8022fd:	e8 03 fd ff ff       	call   802005 <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 07                	push   $0x7
  802316:	e8 ea fc ff ff       	call   802005 <syscall>
  80231b:	83 c4 18             	add    $0x18,%esp
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <sys_exit_env>:


void sys_exit_env(void)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 1c                	push   $0x1c
  80232f:	e8 d1 fc ff ff       	call   802005 <syscall>
  802334:	83 c4 18             	add    $0x18,%esp
}
  802337:	90                   	nop
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
  80233d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802340:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802343:	8d 50 04             	lea    0x4(%eax),%edx
  802346:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	52                   	push   %edx
  802350:	50                   	push   %eax
  802351:	6a 1d                	push   $0x1d
  802353:	e8 ad fc ff ff       	call   802005 <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
	return result;
  80235b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80235e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802361:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802364:	89 01                	mov    %eax,(%ecx)
  802366:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	c9                   	leave  
  80236d:	c2 04 00             	ret    $0x4

00802370 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	ff 75 10             	pushl  0x10(%ebp)
  80237a:	ff 75 0c             	pushl  0xc(%ebp)
  80237d:	ff 75 08             	pushl  0x8(%ebp)
  802380:	6a 13                	push   $0x13
  802382:	e8 7e fc ff ff       	call   802005 <syscall>
  802387:	83 c4 18             	add    $0x18,%esp
	return ;
  80238a:	90                   	nop
}
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <sys_rcr2>:
uint32 sys_rcr2()
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 1e                	push   $0x1e
  80239c:	e8 64 fc ff ff       	call   802005 <syscall>
  8023a1:	83 c4 18             	add    $0x18,%esp
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023b2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	50                   	push   %eax
  8023bf:	6a 1f                	push   $0x1f
  8023c1:	e8 3f fc ff ff       	call   802005 <syscall>
  8023c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c9:	90                   	nop
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <rsttst>:
void rsttst()
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 21                	push   $0x21
  8023db:	e8 25 fc ff ff       	call   802005 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e3:	90                   	nop
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	83 ec 04             	sub    $0x4,%esp
  8023ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023f2:	8b 55 18             	mov    0x18(%ebp),%edx
  8023f5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023f9:	52                   	push   %edx
  8023fa:	50                   	push   %eax
  8023fb:	ff 75 10             	pushl  0x10(%ebp)
  8023fe:	ff 75 0c             	pushl  0xc(%ebp)
  802401:	ff 75 08             	pushl  0x8(%ebp)
  802404:	6a 20                	push   $0x20
  802406:	e8 fa fb ff ff       	call   802005 <syscall>
  80240b:	83 c4 18             	add    $0x18,%esp
	return ;
  80240e:	90                   	nop
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <chktst>:
void chktst(uint32 n)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	ff 75 08             	pushl  0x8(%ebp)
  80241f:	6a 22                	push   $0x22
  802421:	e8 df fb ff ff       	call   802005 <syscall>
  802426:	83 c4 18             	add    $0x18,%esp
	return ;
  802429:	90                   	nop
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <inctst>:

void inctst()
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 23                	push   $0x23
  80243b:	e8 c5 fb ff ff       	call   802005 <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
	return ;
  802443:	90                   	nop
}
  802444:	c9                   	leave  
  802445:	c3                   	ret    

00802446 <gettst>:
uint32 gettst()
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 24                	push   $0x24
  802455:	e8 ab fb ff ff       	call   802005 <syscall>
  80245a:	83 c4 18             	add    $0x18,%esp
}
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 25                	push   $0x25
  802471:	e8 8f fb ff ff       	call   802005 <syscall>
  802476:	83 c4 18             	add    $0x18,%esp
  802479:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80247c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802480:	75 07                	jne    802489 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802482:	b8 01 00 00 00       	mov    $0x1,%eax
  802487:	eb 05                	jmp    80248e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802489:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
  802493:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 25                	push   $0x25
  8024a2:	e8 5e fb ff ff       	call   802005 <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
  8024aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024ad:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024b1:	75 07                	jne    8024ba <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b8:	eb 05                	jmp    8024bf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 25                	push   $0x25
  8024d3:	e8 2d fb ff ff       	call   802005 <syscall>
  8024d8:	83 c4 18             	add    $0x18,%esp
  8024db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024de:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024e2:	75 07                	jne    8024eb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e9:	eb 05                	jmp    8024f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
  8024f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 25                	push   $0x25
  802504:	e8 fc fa ff ff       	call   802005 <syscall>
  802509:	83 c4 18             	add    $0x18,%esp
  80250c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80250f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802513:	75 07                	jne    80251c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802515:	b8 01 00 00 00       	mov    $0x1,%eax
  80251a:	eb 05                	jmp    802521 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80251c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	ff 75 08             	pushl  0x8(%ebp)
  802531:	6a 26                	push   $0x26
  802533:	e8 cd fa ff ff       	call   802005 <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
	return ;
  80253b:	90                   	nop
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802542:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802545:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	6a 00                	push   $0x0
  802550:	53                   	push   %ebx
  802551:	51                   	push   %ecx
  802552:	52                   	push   %edx
  802553:	50                   	push   %eax
  802554:	6a 27                	push   $0x27
  802556:	e8 aa fa ff ff       	call   802005 <syscall>
  80255b:	83 c4 18             	add    $0x18,%esp
}
  80255e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802566:	8b 55 0c             	mov    0xc(%ebp),%edx
  802569:	8b 45 08             	mov    0x8(%ebp),%eax
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	52                   	push   %edx
  802573:	50                   	push   %eax
  802574:	6a 28                	push   $0x28
  802576:	e8 8a fa ff ff       	call   802005 <syscall>
  80257b:	83 c4 18             	add    $0x18,%esp
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802583:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802586:	8b 55 0c             	mov    0xc(%ebp),%edx
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	6a 00                	push   $0x0
  80258e:	51                   	push   %ecx
  80258f:	ff 75 10             	pushl  0x10(%ebp)
  802592:	52                   	push   %edx
  802593:	50                   	push   %eax
  802594:	6a 29                	push   $0x29
  802596:	e8 6a fa ff ff       	call   802005 <syscall>
  80259b:	83 c4 18             	add    $0x18,%esp
}
  80259e:	c9                   	leave  
  80259f:	c3                   	ret    

008025a0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	ff 75 10             	pushl  0x10(%ebp)
  8025aa:	ff 75 0c             	pushl  0xc(%ebp)
  8025ad:	ff 75 08             	pushl  0x8(%ebp)
  8025b0:	6a 12                	push   $0x12
  8025b2:	e8 4e fa ff ff       	call   802005 <syscall>
  8025b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ba:	90                   	nop
}
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    

008025bd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8025c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	52                   	push   %edx
  8025cd:	50                   	push   %eax
  8025ce:	6a 2a                	push   $0x2a
  8025d0:	e8 30 fa ff ff       	call   802005 <syscall>
  8025d5:	83 c4 18             	add    $0x18,%esp
	return;
  8025d8:	90                   	nop
}
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    

008025db <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	50                   	push   %eax
  8025ea:	6a 2b                	push   $0x2b
  8025ec:	e8 14 fa ff ff       	call   802005 <syscall>
  8025f1:	83 c4 18             	add    $0x18,%esp
}
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	ff 75 0c             	pushl  0xc(%ebp)
  802602:	ff 75 08             	pushl  0x8(%ebp)
  802605:	6a 2c                	push   $0x2c
  802607:	e8 f9 f9 ff ff       	call   802005 <syscall>
  80260c:	83 c4 18             	add    $0x18,%esp
	return;
  80260f:	90                   	nop
}
  802610:	c9                   	leave  
  802611:	c3                   	ret    

00802612 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	ff 75 0c             	pushl  0xc(%ebp)
  80261e:	ff 75 08             	pushl  0x8(%ebp)
  802621:	6a 2d                	push   $0x2d
  802623:	e8 dd f9 ff ff       	call   802005 <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
	return;
  80262b:	90                   	nop
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802634:	8b 45 08             	mov    0x8(%ebp),%eax
  802637:	83 e8 04             	sub    $0x4,%eax
  80263a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80263d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802640:	8b 00                	mov    (%eax),%eax
  802642:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802645:	c9                   	leave  
  802646:	c3                   	ret    

00802647 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802647:	55                   	push   %ebp
  802648:	89 e5                	mov    %esp,%ebp
  80264a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80264d:	8b 45 08             	mov    0x8(%ebp),%eax
  802650:	83 e8 04             	sub    $0x4,%eax
  802653:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802656:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	83 e0 01             	and    $0x1,%eax
  80265e:	85 c0                	test   %eax,%eax
  802660:	0f 94 c0             	sete   %al
}
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80266b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802672:	8b 45 0c             	mov    0xc(%ebp),%eax
  802675:	83 f8 02             	cmp    $0x2,%eax
  802678:	74 2b                	je     8026a5 <alloc_block+0x40>
  80267a:	83 f8 02             	cmp    $0x2,%eax
  80267d:	7f 07                	jg     802686 <alloc_block+0x21>
  80267f:	83 f8 01             	cmp    $0x1,%eax
  802682:	74 0e                	je     802692 <alloc_block+0x2d>
  802684:	eb 58                	jmp    8026de <alloc_block+0x79>
  802686:	83 f8 03             	cmp    $0x3,%eax
  802689:	74 2d                	je     8026b8 <alloc_block+0x53>
  80268b:	83 f8 04             	cmp    $0x4,%eax
  80268e:	74 3b                	je     8026cb <alloc_block+0x66>
  802690:	eb 4c                	jmp    8026de <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802692:	83 ec 0c             	sub    $0xc,%esp
  802695:	ff 75 08             	pushl  0x8(%ebp)
  802698:	e8 11 03 00 00       	call   8029ae <alloc_block_FF>
  80269d:	83 c4 10             	add    $0x10,%esp
  8026a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026a3:	eb 4a                	jmp    8026ef <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8026a5:	83 ec 0c             	sub    $0xc,%esp
  8026a8:	ff 75 08             	pushl  0x8(%ebp)
  8026ab:	e8 fa 19 00 00       	call   8040aa <alloc_block_NF>
  8026b0:	83 c4 10             	add    $0x10,%esp
  8026b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026b6:	eb 37                	jmp    8026ef <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8026b8:	83 ec 0c             	sub    $0xc,%esp
  8026bb:	ff 75 08             	pushl  0x8(%ebp)
  8026be:	e8 a7 07 00 00       	call   802e6a <alloc_block_BF>
  8026c3:	83 c4 10             	add    $0x10,%esp
  8026c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026c9:	eb 24                	jmp    8026ef <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8026cb:	83 ec 0c             	sub    $0xc,%esp
  8026ce:	ff 75 08             	pushl  0x8(%ebp)
  8026d1:	e8 b7 19 00 00       	call   80408d <alloc_block_WF>
  8026d6:	83 c4 10             	add    $0x10,%esp
  8026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026dc:	eb 11                	jmp    8026ef <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8026de:	83 ec 0c             	sub    $0xc,%esp
  8026e1:	68 38 4f 80 00       	push   $0x804f38
  8026e6:	e8 3b e6 ff ff       	call   800d26 <cprintf>
  8026eb:	83 c4 10             	add    $0x10,%esp
		break;
  8026ee:	90                   	nop
	}
	return va;
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8026f2:	c9                   	leave  
  8026f3:	c3                   	ret    

008026f4 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
  8026f7:	53                   	push   %ebx
  8026f8:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8026fb:	83 ec 0c             	sub    $0xc,%esp
  8026fe:	68 58 4f 80 00       	push   $0x804f58
  802703:	e8 1e e6 ff ff       	call   800d26 <cprintf>
  802708:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80270b:	83 ec 0c             	sub    $0xc,%esp
  80270e:	68 83 4f 80 00       	push   $0x804f83
  802713:	e8 0e e6 ff ff       	call   800d26 <cprintf>
  802718:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802721:	eb 37                	jmp    80275a <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802723:	83 ec 0c             	sub    $0xc,%esp
  802726:	ff 75 f4             	pushl  -0xc(%ebp)
  802729:	e8 19 ff ff ff       	call   802647 <is_free_block>
  80272e:	83 c4 10             	add    $0x10,%esp
  802731:	0f be d8             	movsbl %al,%ebx
  802734:	83 ec 0c             	sub    $0xc,%esp
  802737:	ff 75 f4             	pushl  -0xc(%ebp)
  80273a:	e8 ef fe ff ff       	call   80262e <get_block_size>
  80273f:	83 c4 10             	add    $0x10,%esp
  802742:	83 ec 04             	sub    $0x4,%esp
  802745:	53                   	push   %ebx
  802746:	50                   	push   %eax
  802747:	68 9b 4f 80 00       	push   $0x804f9b
  80274c:	e8 d5 e5 ff ff       	call   800d26 <cprintf>
  802751:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802754:	8b 45 10             	mov    0x10(%ebp),%eax
  802757:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275e:	74 07                	je     802767 <print_blocks_list+0x73>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	eb 05                	jmp    80276c <print_blocks_list+0x78>
  802767:	b8 00 00 00 00       	mov    $0x0,%eax
  80276c:	89 45 10             	mov    %eax,0x10(%ebp)
  80276f:	8b 45 10             	mov    0x10(%ebp),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	75 ad                	jne    802723 <print_blocks_list+0x2f>
  802776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277a:	75 a7                	jne    802723 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80277c:	83 ec 0c             	sub    $0xc,%esp
  80277f:	68 58 4f 80 00       	push   $0x804f58
  802784:	e8 9d e5 ff ff       	call   800d26 <cprintf>
  802789:	83 c4 10             	add    $0x10,%esp

}
  80278c:	90                   	nop
  80278d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802790:	c9                   	leave  
  802791:	c3                   	ret    

00802792 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802792:	55                   	push   %ebp
  802793:	89 e5                	mov    %esp,%ebp
  802795:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279b:	83 e0 01             	and    $0x1,%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	74 03                	je     8027a5 <initialize_dynamic_allocator+0x13>
  8027a2:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8027a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027a9:	0f 84 c7 01 00 00    	je     802976 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8027af:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8027b6:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8027b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027bf:	01 d0                	add    %edx,%eax
  8027c1:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8027c6:	0f 87 ad 01 00 00    	ja     802979 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	0f 89 a5 01 00 00    	jns    80297c <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8027d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027dd:	01 d0                	add    %edx,%eax
  8027df:	83 e8 04             	sub    $0x4,%eax
  8027e2:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  8027e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8027ee:	a1 44 60 80 00       	mov    0x806044,%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	e9 87 00 00 00       	jmp    802882 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8027fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ff:	75 14                	jne    802815 <initialize_dynamic_allocator+0x83>
  802801:	83 ec 04             	sub    $0x4,%esp
  802804:	68 b3 4f 80 00       	push   $0x804fb3
  802809:	6a 79                	push   $0x79
  80280b:	68 d1 4f 80 00       	push   $0x804fd1
  802810:	e8 54 e2 ff ff       	call   800a69 <_panic>
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 10                	je     80282e <initialize_dynamic_allocator+0x9c>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802826:	8b 52 04             	mov    0x4(%edx),%edx
  802829:	89 50 04             	mov    %edx,0x4(%eax)
  80282c:	eb 0b                	jmp    802839 <initialize_dynamic_allocator+0xa7>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	a3 48 60 80 00       	mov    %eax,0x806048
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	74 0f                	je     802852 <initialize_dynamic_allocator+0xc0>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284c:	8b 12                	mov    (%edx),%edx
  80284e:	89 10                	mov    %edx,(%eax)
  802850:	eb 0a                	jmp    80285c <initialize_dynamic_allocator+0xca>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	a3 44 60 80 00       	mov    %eax,0x806044
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286f:	a1 50 60 80 00       	mov    0x806050,%eax
  802874:	48                   	dec    %eax
  802875:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80287a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80287f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802882:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802886:	74 07                	je     80288f <initialize_dynamic_allocator+0xfd>
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	eb 05                	jmp    802894 <initialize_dynamic_allocator+0x102>
  80288f:	b8 00 00 00 00       	mov    $0x0,%eax
  802894:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802899:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	0f 85 55 ff ff ff    	jne    8027fb <initialize_dynamic_allocator+0x69>
  8028a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028aa:	0f 85 4b ff ff ff    	jne    8027fb <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8028bf:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  8028c4:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  8028c9:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8028ce:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	83 c0 08             	add    $0x8,%eax
  8028da:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	83 c0 04             	add    $0x4,%eax
  8028e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e6:	83 ea 08             	sub    $0x8,%edx
  8028e9:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8028eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f1:	01 d0                	add    %edx,%eax
  8028f3:	83 e8 08             	sub    $0x8,%eax
  8028f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f9:	83 ea 08             	sub    $0x8,%edx
  8028fc:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8028fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802901:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802907:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802911:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802915:	75 17                	jne    80292e <initialize_dynamic_allocator+0x19c>
  802917:	83 ec 04             	sub    $0x4,%esp
  80291a:	68 ec 4f 80 00       	push   $0x804fec
  80291f:	68 90 00 00 00       	push   $0x90
  802924:	68 d1 4f 80 00       	push   $0x804fd1
  802929:	e8 3b e1 ff ff       	call   800a69 <_panic>
  80292e:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802937:	89 10                	mov    %edx,(%eax)
  802939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	85 c0                	test   %eax,%eax
  802940:	74 0d                	je     80294f <initialize_dynamic_allocator+0x1bd>
  802942:	a1 44 60 80 00       	mov    0x806044,%eax
  802947:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80294a:	89 50 04             	mov    %edx,0x4(%eax)
  80294d:	eb 08                	jmp    802957 <initialize_dynamic_allocator+0x1c5>
  80294f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802952:	a3 48 60 80 00       	mov    %eax,0x806048
  802957:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295a:	a3 44 60 80 00       	mov    %eax,0x806044
  80295f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802962:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802969:	a1 50 60 80 00       	mov    0x806050,%eax
  80296e:	40                   	inc    %eax
  80296f:	a3 50 60 80 00       	mov    %eax,0x806050
  802974:	eb 07                	jmp    80297d <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802976:	90                   	nop
  802977:	eb 04                	jmp    80297d <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802979:	90                   	nop
  80297a:	eb 01                	jmp    80297d <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80297c:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80297d:	c9                   	leave  
  80297e:	c3                   	ret    

0080297f <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80297f:	55                   	push   %ebp
  802980:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802982:	8b 45 10             	mov    0x10(%ebp),%eax
  802985:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
  80298b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80298e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802991:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	83 e8 04             	sub    $0x4,%eax
  802999:	8b 00                	mov    (%eax),%eax
  80299b:	83 e0 fe             	and    $0xfffffffe,%eax
  80299e:	8d 50 f8             	lea    -0x8(%eax),%edx
  8029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a4:	01 c2                	add    %eax,%edx
  8029a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029a9:	89 02                	mov    %eax,(%edx)
}
  8029ab:	90                   	nop
  8029ac:	5d                   	pop    %ebp
  8029ad:	c3                   	ret    

008029ae <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
  8029b1:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	83 e0 01             	and    $0x1,%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	74 03                	je     8029c1 <alloc_block_FF+0x13>
  8029be:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8029c1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8029c5:	77 07                	ja     8029ce <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8029c7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8029ce:	a1 24 60 80 00       	mov    0x806024,%eax
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	75 73                	jne    802a4a <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	83 c0 10             	add    $0x10,%eax
  8029dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8029e0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8029e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ed:	01 d0                	add    %edx,%eax
  8029ef:	48                   	dec    %eax
  8029f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8029f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8029fb:	f7 75 ec             	divl   -0x14(%ebp)
  8029fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a01:	29 d0                	sub    %edx,%eax
  802a03:	c1 e8 0c             	shr    $0xc,%eax
  802a06:	83 ec 0c             	sub    $0xc,%esp
  802a09:	50                   	push   %eax
  802a0a:	e8 b1 f0 ff ff       	call   801ac0 <sbrk>
  802a0f:	83 c4 10             	add    $0x10,%esp
  802a12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a15:	83 ec 0c             	sub    $0xc,%esp
  802a18:	6a 00                	push   $0x0
  802a1a:	e8 a1 f0 ff ff       	call   801ac0 <sbrk>
  802a1f:	83 c4 10             	add    $0x10,%esp
  802a22:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a28:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a2b:	83 ec 08             	sub    $0x8,%esp
  802a2e:	50                   	push   %eax
  802a2f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a32:	e8 5b fd ff ff       	call   802792 <initialize_dynamic_allocator>
  802a37:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802a3a:	83 ec 0c             	sub    $0xc,%esp
  802a3d:	68 0f 50 80 00       	push   $0x80500f
  802a42:	e8 df e2 ff ff       	call   800d26 <cprintf>
  802a47:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802a4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a4e:	75 0a                	jne    802a5a <alloc_block_FF+0xac>
	        return NULL;
  802a50:	b8 00 00 00 00       	mov    $0x0,%eax
  802a55:	e9 0e 04 00 00       	jmp    802e68 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802a5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a61:	a1 44 60 80 00       	mov    0x806044,%eax
  802a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a69:	e9 f3 02 00 00       	jmp    802d61 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802a74:	83 ec 0c             	sub    $0xc,%esp
  802a77:	ff 75 bc             	pushl  -0x44(%ebp)
  802a7a:	e8 af fb ff ff       	call   80262e <get_block_size>
  802a7f:	83 c4 10             	add    $0x10,%esp
  802a82:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	83 c0 08             	add    $0x8,%eax
  802a8b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a8e:	0f 87 c5 02 00 00    	ja     802d59 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	83 c0 18             	add    $0x18,%eax
  802a9a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a9d:	0f 87 19 02 00 00    	ja     802cbc <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802aa3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802aa6:	2b 45 08             	sub    0x8(%ebp),%eax
  802aa9:	83 e8 08             	sub    $0x8,%eax
  802aac:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	8d 50 08             	lea    0x8(%eax),%edx
  802ab5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ab8:	01 d0                	add    %edx,%eax
  802aba:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	83 c0 08             	add    $0x8,%eax
  802ac3:	83 ec 04             	sub    $0x4,%esp
  802ac6:	6a 01                	push   $0x1
  802ac8:	50                   	push   %eax
  802ac9:	ff 75 bc             	pushl  -0x44(%ebp)
  802acc:	e8 ae fe ff ff       	call   80297f <set_block_data>
  802ad1:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 40 04             	mov    0x4(%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	75 68                	jne    802b46 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ade:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ae2:	75 17                	jne    802afb <alloc_block_FF+0x14d>
  802ae4:	83 ec 04             	sub    $0x4,%esp
  802ae7:	68 ec 4f 80 00       	push   $0x804fec
  802aec:	68 d7 00 00 00       	push   $0xd7
  802af1:	68 d1 4f 80 00       	push   $0x804fd1
  802af6:	e8 6e df ff ff       	call   800a69 <_panic>
  802afb:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802b01:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b04:	89 10                	mov    %edx,(%eax)
  802b06:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b09:	8b 00                	mov    (%eax),%eax
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	74 0d                	je     802b1c <alloc_block_FF+0x16e>
  802b0f:	a1 44 60 80 00       	mov    0x806044,%eax
  802b14:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b17:	89 50 04             	mov    %edx,0x4(%eax)
  802b1a:	eb 08                	jmp    802b24 <alloc_block_FF+0x176>
  802b1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b1f:	a3 48 60 80 00       	mov    %eax,0x806048
  802b24:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b27:	a3 44 60 80 00       	mov    %eax,0x806044
  802b2c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b36:	a1 50 60 80 00       	mov    0x806050,%eax
  802b3b:	40                   	inc    %eax
  802b3c:	a3 50 60 80 00       	mov    %eax,0x806050
  802b41:	e9 dc 00 00 00       	jmp    802c22 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	75 65                	jne    802bb4 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b4f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b53:	75 17                	jne    802b6c <alloc_block_FF+0x1be>
  802b55:	83 ec 04             	sub    $0x4,%esp
  802b58:	68 20 50 80 00       	push   $0x805020
  802b5d:	68 db 00 00 00       	push   $0xdb
  802b62:	68 d1 4f 80 00       	push   $0x804fd1
  802b67:	e8 fd de ff ff       	call   800a69 <_panic>
  802b6c:	8b 15 48 60 80 00    	mov    0x806048,%edx
  802b72:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b75:	89 50 04             	mov    %edx,0x4(%eax)
  802b78:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b7b:	8b 40 04             	mov    0x4(%eax),%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	74 0c                	je     802b8e <alloc_block_FF+0x1e0>
  802b82:	a1 48 60 80 00       	mov    0x806048,%eax
  802b87:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b8a:	89 10                	mov    %edx,(%eax)
  802b8c:	eb 08                	jmp    802b96 <alloc_block_FF+0x1e8>
  802b8e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b91:	a3 44 60 80 00       	mov    %eax,0x806044
  802b96:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b99:	a3 48 60 80 00       	mov    %eax,0x806048
  802b9e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba7:	a1 50 60 80 00       	mov    0x806050,%eax
  802bac:	40                   	inc    %eax
  802bad:	a3 50 60 80 00       	mov    %eax,0x806050
  802bb2:	eb 6e                	jmp    802c22 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802bb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb8:	74 06                	je     802bc0 <alloc_block_FF+0x212>
  802bba:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bbe:	75 17                	jne    802bd7 <alloc_block_FF+0x229>
  802bc0:	83 ec 04             	sub    $0x4,%esp
  802bc3:	68 44 50 80 00       	push   $0x805044
  802bc8:	68 df 00 00 00       	push   $0xdf
  802bcd:	68 d1 4f 80 00       	push   $0x804fd1
  802bd2:	e8 92 de ff ff       	call   800a69 <_panic>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 10                	mov    (%eax),%edx
  802bdc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bdf:	89 10                	mov    %edx,(%eax)
  802be1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be4:	8b 00                	mov    (%eax),%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	74 0b                	je     802bf5 <alloc_block_FF+0x247>
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 00                	mov    (%eax),%eax
  802bef:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bf2:	89 50 04             	mov    %edx,0x4(%eax)
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bfb:	89 10                	mov    %edx,(%eax)
  802bfd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c03:	89 50 04             	mov    %edx,0x4(%eax)
  802c06:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	75 08                	jne    802c17 <alloc_block_FF+0x269>
  802c0f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c12:	a3 48 60 80 00       	mov    %eax,0x806048
  802c17:	a1 50 60 80 00       	mov    0x806050,%eax
  802c1c:	40                   	inc    %eax
  802c1d:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c26:	75 17                	jne    802c3f <alloc_block_FF+0x291>
  802c28:	83 ec 04             	sub    $0x4,%esp
  802c2b:	68 b3 4f 80 00       	push   $0x804fb3
  802c30:	68 e1 00 00 00       	push   $0xe1
  802c35:	68 d1 4f 80 00       	push   $0x804fd1
  802c3a:	e8 2a de ff ff       	call   800a69 <_panic>
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	85 c0                	test   %eax,%eax
  802c46:	74 10                	je     802c58 <alloc_block_FF+0x2aa>
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c50:	8b 52 04             	mov    0x4(%edx),%edx
  802c53:	89 50 04             	mov    %edx,0x4(%eax)
  802c56:	eb 0b                	jmp    802c63 <alloc_block_FF+0x2b5>
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	a3 48 60 80 00       	mov    %eax,0x806048
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	85 c0                	test   %eax,%eax
  802c6b:	74 0f                	je     802c7c <alloc_block_FF+0x2ce>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c76:	8b 12                	mov    (%edx),%edx
  802c78:	89 10                	mov    %edx,(%eax)
  802c7a:	eb 0a                	jmp    802c86 <alloc_block_FF+0x2d8>
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 00                	mov    (%eax),%eax
  802c81:	a3 44 60 80 00       	mov    %eax,0x806044
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c99:	a1 50 60 80 00       	mov    0x806050,%eax
  802c9e:	48                   	dec    %eax
  802c9f:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  802ca4:	83 ec 04             	sub    $0x4,%esp
  802ca7:	6a 00                	push   $0x0
  802ca9:	ff 75 b4             	pushl  -0x4c(%ebp)
  802cac:	ff 75 b0             	pushl  -0x50(%ebp)
  802caf:	e8 cb fc ff ff       	call   80297f <set_block_data>
  802cb4:	83 c4 10             	add    $0x10,%esp
  802cb7:	e9 95 00 00 00       	jmp    802d51 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802cbc:	83 ec 04             	sub    $0x4,%esp
  802cbf:	6a 01                	push   $0x1
  802cc1:	ff 75 b8             	pushl  -0x48(%ebp)
  802cc4:	ff 75 bc             	pushl  -0x44(%ebp)
  802cc7:	e8 b3 fc ff ff       	call   80297f <set_block_data>
  802ccc:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd3:	75 17                	jne    802cec <alloc_block_FF+0x33e>
  802cd5:	83 ec 04             	sub    $0x4,%esp
  802cd8:	68 b3 4f 80 00       	push   $0x804fb3
  802cdd:	68 e8 00 00 00       	push   $0xe8
  802ce2:	68 d1 4f 80 00       	push   $0x804fd1
  802ce7:	e8 7d dd ff ff       	call   800a69 <_panic>
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	74 10                	je     802d05 <alloc_block_FF+0x357>
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfd:	8b 52 04             	mov    0x4(%edx),%edx
  802d00:	89 50 04             	mov    %edx,0x4(%eax)
  802d03:	eb 0b                	jmp    802d10 <alloc_block_FF+0x362>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	a3 48 60 80 00       	mov    %eax,0x806048
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 0f                	je     802d29 <alloc_block_FF+0x37b>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 40 04             	mov    0x4(%eax),%eax
  802d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d23:	8b 12                	mov    (%edx),%edx
  802d25:	89 10                	mov    %edx,(%eax)
  802d27:	eb 0a                	jmp    802d33 <alloc_block_FF+0x385>
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	a3 44 60 80 00       	mov    %eax,0x806044
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d46:	a1 50 60 80 00       	mov    0x806050,%eax
  802d4b:	48                   	dec    %eax
  802d4c:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  802d51:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d54:	e9 0f 01 00 00       	jmp    802e68 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d59:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d65:	74 07                	je     802d6e <alloc_block_FF+0x3c0>
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 00                	mov    (%eax),%eax
  802d6c:	eb 05                	jmp    802d73 <alloc_block_FF+0x3c5>
  802d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d73:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802d78:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	0f 85 e9 fc ff ff    	jne    802a6e <alloc_block_FF+0xc0>
  802d85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d89:	0f 85 df fc ff ff    	jne    802a6e <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d92:	83 c0 08             	add    $0x8,%eax
  802d95:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d98:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802da2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802da5:	01 d0                	add    %edx,%eax
  802da7:	48                   	dec    %eax
  802da8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802dab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dae:	ba 00 00 00 00       	mov    $0x0,%edx
  802db3:	f7 75 d8             	divl   -0x28(%ebp)
  802db6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802db9:	29 d0                	sub    %edx,%eax
  802dbb:	c1 e8 0c             	shr    $0xc,%eax
  802dbe:	83 ec 0c             	sub    $0xc,%esp
  802dc1:	50                   	push   %eax
  802dc2:	e8 f9 ec ff ff       	call   801ac0 <sbrk>
  802dc7:	83 c4 10             	add    $0x10,%esp
  802dca:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802dcd:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802dd1:	75 0a                	jne    802ddd <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd8:	e9 8b 00 00 00       	jmp    802e68 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ddd:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802de4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802de7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dea:	01 d0                	add    %edx,%eax
  802dec:	48                   	dec    %eax
  802ded:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802df0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802df3:	ba 00 00 00 00       	mov    $0x0,%edx
  802df8:	f7 75 cc             	divl   -0x34(%ebp)
  802dfb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802dfe:	29 d0                	sub    %edx,%eax
  802e00:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e03:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e06:	01 d0                	add    %edx,%eax
  802e08:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  802e0d:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802e12:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e18:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e22:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e25:	01 d0                	add    %edx,%eax
  802e27:	48                   	dec    %eax
  802e28:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e2b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e2e:	ba 00 00 00 00       	mov    $0x0,%edx
  802e33:	f7 75 c4             	divl   -0x3c(%ebp)
  802e36:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e39:	29 d0                	sub    %edx,%eax
  802e3b:	83 ec 04             	sub    $0x4,%esp
  802e3e:	6a 01                	push   $0x1
  802e40:	50                   	push   %eax
  802e41:	ff 75 d0             	pushl  -0x30(%ebp)
  802e44:	e8 36 fb ff ff       	call   80297f <set_block_data>
  802e49:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802e4c:	83 ec 0c             	sub    $0xc,%esp
  802e4f:	ff 75 d0             	pushl  -0x30(%ebp)
  802e52:	e8 1b 0a 00 00       	call   803872 <free_block>
  802e57:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802e5a:	83 ec 0c             	sub    $0xc,%esp
  802e5d:	ff 75 08             	pushl  0x8(%ebp)
  802e60:	e8 49 fb ff ff       	call   8029ae <alloc_block_FF>
  802e65:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e68:	c9                   	leave  
  802e69:	c3                   	ret    

00802e6a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e6a:	55                   	push   %ebp
  802e6b:	89 e5                	mov    %esp,%ebp
  802e6d:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	83 e0 01             	and    $0x1,%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	74 03                	je     802e7d <alloc_block_BF+0x13>
  802e7a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e7d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e81:	77 07                	ja     802e8a <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e83:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e8a:	a1 24 60 80 00       	mov    0x806024,%eax
  802e8f:	85 c0                	test   %eax,%eax
  802e91:	75 73                	jne    802f06 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	83 c0 10             	add    $0x10,%eax
  802e99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e9c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802ea3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ea6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea9:	01 d0                	add    %edx,%eax
  802eab:	48                   	dec    %eax
  802eac:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802eaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb2:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb7:	f7 75 e0             	divl   -0x20(%ebp)
  802eba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ebd:	29 d0                	sub    %edx,%eax
  802ebf:	c1 e8 0c             	shr    $0xc,%eax
  802ec2:	83 ec 0c             	sub    $0xc,%esp
  802ec5:	50                   	push   %eax
  802ec6:	e8 f5 eb ff ff       	call   801ac0 <sbrk>
  802ecb:	83 c4 10             	add    $0x10,%esp
  802ece:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802ed1:	83 ec 0c             	sub    $0xc,%esp
  802ed4:	6a 00                	push   $0x0
  802ed6:	e8 e5 eb ff ff       	call   801ac0 <sbrk>
  802edb:	83 c4 10             	add    $0x10,%esp
  802ede:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ee1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ee4:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802ee7:	83 ec 08             	sub    $0x8,%esp
  802eea:	50                   	push   %eax
  802eeb:	ff 75 d8             	pushl  -0x28(%ebp)
  802eee:	e8 9f f8 ff ff       	call   802792 <initialize_dynamic_allocator>
  802ef3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ef6:	83 ec 0c             	sub    $0xc,%esp
  802ef9:	68 0f 50 80 00       	push   $0x80500f
  802efe:	e8 23 de ff ff       	call   800d26 <cprintf>
  802f03:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802f06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802f0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802f14:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802f1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802f22:	a1 44 60 80 00       	mov    0x806044,%eax
  802f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2a:	e9 1d 01 00 00       	jmp    80304c <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802f35:	83 ec 0c             	sub    $0xc,%esp
  802f38:	ff 75 a8             	pushl  -0x58(%ebp)
  802f3b:	e8 ee f6 ff ff       	call   80262e <get_block_size>
  802f40:	83 c4 10             	add    $0x10,%esp
  802f43:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	83 c0 08             	add    $0x8,%eax
  802f4c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f4f:	0f 87 ef 00 00 00    	ja     803044 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	83 c0 18             	add    $0x18,%eax
  802f5b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f5e:	77 1d                	ja     802f7d <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f63:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f66:	0f 86 d8 00 00 00    	jbe    803044 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802f6c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802f72:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f78:	e9 c7 00 00 00       	jmp    803044 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	83 c0 08             	add    $0x8,%eax
  802f83:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f86:	0f 85 9d 00 00 00    	jne    803029 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802f8c:	83 ec 04             	sub    $0x4,%esp
  802f8f:	6a 01                	push   $0x1
  802f91:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f94:	ff 75 a8             	pushl  -0x58(%ebp)
  802f97:	e8 e3 f9 ff ff       	call   80297f <set_block_data>
  802f9c:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802f9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa3:	75 17                	jne    802fbc <alloc_block_BF+0x152>
  802fa5:	83 ec 04             	sub    $0x4,%esp
  802fa8:	68 b3 4f 80 00       	push   $0x804fb3
  802fad:	68 2c 01 00 00       	push   $0x12c
  802fb2:	68 d1 4f 80 00       	push   $0x804fd1
  802fb7:	e8 ad da ff ff       	call   800a69 <_panic>
  802fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbf:	8b 00                	mov    (%eax),%eax
  802fc1:	85 c0                	test   %eax,%eax
  802fc3:	74 10                	je     802fd5 <alloc_block_BF+0x16b>
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	8b 00                	mov    (%eax),%eax
  802fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fcd:	8b 52 04             	mov    0x4(%edx),%edx
  802fd0:	89 50 04             	mov    %edx,0x4(%eax)
  802fd3:	eb 0b                	jmp    802fe0 <alloc_block_BF+0x176>
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	8b 40 04             	mov    0x4(%eax),%eax
  802fdb:	a3 48 60 80 00       	mov    %eax,0x806048
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 40 04             	mov    0x4(%eax),%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	74 0f                	je     802ff9 <alloc_block_BF+0x18f>
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	8b 40 04             	mov    0x4(%eax),%eax
  802ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff3:	8b 12                	mov    (%edx),%edx
  802ff5:	89 10                	mov    %edx,(%eax)
  802ff7:	eb 0a                	jmp    803003 <alloc_block_BF+0x199>
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	a3 44 60 80 00       	mov    %eax,0x806044
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803016:	a1 50 60 80 00       	mov    0x806050,%eax
  80301b:	48                   	dec    %eax
  80301c:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  803021:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803024:	e9 24 04 00 00       	jmp    80344d <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80302f:	76 13                	jbe    803044 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803031:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803038:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80303b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80303e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803041:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803044:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803049:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803050:	74 07                	je     803059 <alloc_block_BF+0x1ef>
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	eb 05                	jmp    80305e <alloc_block_BF+0x1f4>
  803059:	b8 00 00 00 00       	mov    $0x0,%eax
  80305e:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803063:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	0f 85 bf fe ff ff    	jne    802f2f <alloc_block_BF+0xc5>
  803070:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803074:	0f 85 b5 fe ff ff    	jne    802f2f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80307a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80307e:	0f 84 26 02 00 00    	je     8032aa <alloc_block_BF+0x440>
  803084:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803088:	0f 85 1c 02 00 00    	jne    8032aa <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80308e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803091:	2b 45 08             	sub    0x8(%ebp),%eax
  803094:	83 e8 08             	sub    $0x8,%eax
  803097:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	8d 50 08             	lea    0x8(%eax),%edx
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	01 d0                	add    %edx,%eax
  8030a5:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	83 c0 08             	add    $0x8,%eax
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	6a 01                	push   $0x1
  8030b3:	50                   	push   %eax
  8030b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8030b7:	e8 c3 f8 ff ff       	call   80297f <set_block_data>
  8030bc:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8030bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c2:	8b 40 04             	mov    0x4(%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	75 68                	jne    803131 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030cd:	75 17                	jne    8030e6 <alloc_block_BF+0x27c>
  8030cf:	83 ec 04             	sub    $0x4,%esp
  8030d2:	68 ec 4f 80 00       	push   $0x804fec
  8030d7:	68 45 01 00 00       	push   $0x145
  8030dc:	68 d1 4f 80 00       	push   $0x804fd1
  8030e1:	e8 83 d9 ff ff       	call   800a69 <_panic>
  8030e6:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8030ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ef:	89 10                	mov    %edx,(%eax)
  8030f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f4:	8b 00                	mov    (%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 0d                	je     803107 <alloc_block_BF+0x29d>
  8030fa:	a1 44 60 80 00       	mov    0x806044,%eax
  8030ff:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803102:	89 50 04             	mov    %edx,0x4(%eax)
  803105:	eb 08                	jmp    80310f <alloc_block_BF+0x2a5>
  803107:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80310a:	a3 48 60 80 00       	mov    %eax,0x806048
  80310f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803112:	a3 44 60 80 00       	mov    %eax,0x806044
  803117:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80311a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803121:	a1 50 60 80 00       	mov    0x806050,%eax
  803126:	40                   	inc    %eax
  803127:	a3 50 60 80 00       	mov    %eax,0x806050
  80312c:	e9 dc 00 00 00       	jmp    80320d <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	85 c0                	test   %eax,%eax
  803138:	75 65                	jne    80319f <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80313a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80313e:	75 17                	jne    803157 <alloc_block_BF+0x2ed>
  803140:	83 ec 04             	sub    $0x4,%esp
  803143:	68 20 50 80 00       	push   $0x805020
  803148:	68 4a 01 00 00       	push   $0x14a
  80314d:	68 d1 4f 80 00       	push   $0x804fd1
  803152:	e8 12 d9 ff ff       	call   800a69 <_panic>
  803157:	8b 15 48 60 80 00    	mov    0x806048,%edx
  80315d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803160:	89 50 04             	mov    %edx,0x4(%eax)
  803163:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803166:	8b 40 04             	mov    0x4(%eax),%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	74 0c                	je     803179 <alloc_block_BF+0x30f>
  80316d:	a1 48 60 80 00       	mov    0x806048,%eax
  803172:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803175:	89 10                	mov    %edx,(%eax)
  803177:	eb 08                	jmp    803181 <alloc_block_BF+0x317>
  803179:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80317c:	a3 44 60 80 00       	mov    %eax,0x806044
  803181:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803184:	a3 48 60 80 00       	mov    %eax,0x806048
  803189:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80318c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803192:	a1 50 60 80 00       	mov    0x806050,%eax
  803197:	40                   	inc    %eax
  803198:	a3 50 60 80 00       	mov    %eax,0x806050
  80319d:	eb 6e                	jmp    80320d <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80319f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031a3:	74 06                	je     8031ab <alloc_block_BF+0x341>
  8031a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031a9:	75 17                	jne    8031c2 <alloc_block_BF+0x358>
  8031ab:	83 ec 04             	sub    $0x4,%esp
  8031ae:	68 44 50 80 00       	push   $0x805044
  8031b3:	68 4f 01 00 00       	push   $0x14f
  8031b8:	68 d1 4f 80 00       	push   $0x804fd1
  8031bd:	e8 a7 d8 ff ff       	call   800a69 <_panic>
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	8b 10                	mov    (%eax),%edx
  8031c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ca:	89 10                	mov    %edx,(%eax)
  8031cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	85 c0                	test   %eax,%eax
  8031d3:	74 0b                	je     8031e0 <alloc_block_BF+0x376>
  8031d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d8:	8b 00                	mov    (%eax),%eax
  8031da:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031dd:	89 50 04             	mov    %edx,0x4(%eax)
  8031e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031e6:	89 10                	mov    %edx,(%eax)
  8031e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ee:	89 50 04             	mov    %edx,0x4(%eax)
  8031f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f4:	8b 00                	mov    (%eax),%eax
  8031f6:	85 c0                	test   %eax,%eax
  8031f8:	75 08                	jne    803202 <alloc_block_BF+0x398>
  8031fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031fd:	a3 48 60 80 00       	mov    %eax,0x806048
  803202:	a1 50 60 80 00       	mov    0x806050,%eax
  803207:	40                   	inc    %eax
  803208:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80320d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803211:	75 17                	jne    80322a <alloc_block_BF+0x3c0>
  803213:	83 ec 04             	sub    $0x4,%esp
  803216:	68 b3 4f 80 00       	push   $0x804fb3
  80321b:	68 51 01 00 00       	push   $0x151
  803220:	68 d1 4f 80 00       	push   $0x804fd1
  803225:	e8 3f d8 ff ff       	call   800a69 <_panic>
  80322a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	85 c0                	test   %eax,%eax
  803231:	74 10                	je     803243 <alloc_block_BF+0x3d9>
  803233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80323b:	8b 52 04             	mov    0x4(%edx),%edx
  80323e:	89 50 04             	mov    %edx,0x4(%eax)
  803241:	eb 0b                	jmp    80324e <alloc_block_BF+0x3e4>
  803243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803246:	8b 40 04             	mov    0x4(%eax),%eax
  803249:	a3 48 60 80 00       	mov    %eax,0x806048
  80324e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803251:	8b 40 04             	mov    0x4(%eax),%eax
  803254:	85 c0                	test   %eax,%eax
  803256:	74 0f                	je     803267 <alloc_block_BF+0x3fd>
  803258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325b:	8b 40 04             	mov    0x4(%eax),%eax
  80325e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803261:	8b 12                	mov    (%edx),%edx
  803263:	89 10                	mov    %edx,(%eax)
  803265:	eb 0a                	jmp    803271 <alloc_block_BF+0x407>
  803267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326a:	8b 00                	mov    (%eax),%eax
  80326c:	a3 44 60 80 00       	mov    %eax,0x806044
  803271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803274:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803284:	a1 50 60 80 00       	mov    0x806050,%eax
  803289:	48                   	dec    %eax
  80328a:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  80328f:	83 ec 04             	sub    $0x4,%esp
  803292:	6a 00                	push   $0x0
  803294:	ff 75 d0             	pushl  -0x30(%ebp)
  803297:	ff 75 cc             	pushl  -0x34(%ebp)
  80329a:	e8 e0 f6 ff ff       	call   80297f <set_block_data>
  80329f:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8032a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a5:	e9 a3 01 00 00       	jmp    80344d <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8032aa:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8032ae:	0f 85 9d 00 00 00    	jne    803351 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8032b4:	83 ec 04             	sub    $0x4,%esp
  8032b7:	6a 01                	push   $0x1
  8032b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8032bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8032bf:	e8 bb f6 ff ff       	call   80297f <set_block_data>
  8032c4:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8032c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032cb:	75 17                	jne    8032e4 <alloc_block_BF+0x47a>
  8032cd:	83 ec 04             	sub    $0x4,%esp
  8032d0:	68 b3 4f 80 00       	push   $0x804fb3
  8032d5:	68 58 01 00 00       	push   $0x158
  8032da:	68 d1 4f 80 00       	push   $0x804fd1
  8032df:	e8 85 d7 ff ff       	call   800a69 <_panic>
  8032e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	74 10                	je     8032fd <alloc_block_BF+0x493>
  8032ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032f5:	8b 52 04             	mov    0x4(%edx),%edx
  8032f8:	89 50 04             	mov    %edx,0x4(%eax)
  8032fb:	eb 0b                	jmp    803308 <alloc_block_BF+0x49e>
  8032fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803300:	8b 40 04             	mov    0x4(%eax),%eax
  803303:	a3 48 60 80 00       	mov    %eax,0x806048
  803308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330b:	8b 40 04             	mov    0x4(%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	74 0f                	je     803321 <alloc_block_BF+0x4b7>
  803312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803315:	8b 40 04             	mov    0x4(%eax),%eax
  803318:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80331b:	8b 12                	mov    (%edx),%edx
  80331d:	89 10                	mov    %edx,(%eax)
  80331f:	eb 0a                	jmp    80332b <alloc_block_BF+0x4c1>
  803321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803324:	8b 00                	mov    (%eax),%eax
  803326:	a3 44 60 80 00       	mov    %eax,0x806044
  80332b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803334:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803337:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333e:	a1 50 60 80 00       	mov    0x806050,%eax
  803343:	48                   	dec    %eax
  803344:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  803349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334c:	e9 fc 00 00 00       	jmp    80344d <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	83 c0 08             	add    $0x8,%eax
  803357:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80335a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803361:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803364:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803367:	01 d0                	add    %edx,%eax
  803369:	48                   	dec    %eax
  80336a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80336d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803370:	ba 00 00 00 00       	mov    $0x0,%edx
  803375:	f7 75 c4             	divl   -0x3c(%ebp)
  803378:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80337b:	29 d0                	sub    %edx,%eax
  80337d:	c1 e8 0c             	shr    $0xc,%eax
  803380:	83 ec 0c             	sub    $0xc,%esp
  803383:	50                   	push   %eax
  803384:	e8 37 e7 ff ff       	call   801ac0 <sbrk>
  803389:	83 c4 10             	add    $0x10,%esp
  80338c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80338f:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803393:	75 0a                	jne    80339f <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803395:	b8 00 00 00 00       	mov    $0x0,%eax
  80339a:	e9 ae 00 00 00       	jmp    80344d <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80339f:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8033a6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8033ac:	01 d0                	add    %edx,%eax
  8033ae:	48                   	dec    %eax
  8033af:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8033b2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8033ba:	f7 75 b8             	divl   -0x48(%ebp)
  8033bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033c0:	29 d0                	sub    %edx,%eax
  8033c2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8033c5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8033c8:	01 d0                	add    %edx,%eax
  8033ca:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  8033cf:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8033d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8033da:	83 ec 0c             	sub    $0xc,%esp
  8033dd:	68 78 50 80 00       	push   $0x805078
  8033e2:	e8 3f d9 ff ff       	call   800d26 <cprintf>
  8033e7:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8033ea:	83 ec 08             	sub    $0x8,%esp
  8033ed:	ff 75 bc             	pushl  -0x44(%ebp)
  8033f0:	68 7d 50 80 00       	push   $0x80507d
  8033f5:	e8 2c d9 ff ff       	call   800d26 <cprintf>
  8033fa:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8033fd:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803404:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803407:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80340a:	01 d0                	add    %edx,%eax
  80340c:	48                   	dec    %eax
  80340d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803410:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803413:	ba 00 00 00 00       	mov    $0x0,%edx
  803418:	f7 75 b0             	divl   -0x50(%ebp)
  80341b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80341e:	29 d0                	sub    %edx,%eax
  803420:	83 ec 04             	sub    $0x4,%esp
  803423:	6a 01                	push   $0x1
  803425:	50                   	push   %eax
  803426:	ff 75 bc             	pushl  -0x44(%ebp)
  803429:	e8 51 f5 ff ff       	call   80297f <set_block_data>
  80342e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803431:	83 ec 0c             	sub    $0xc,%esp
  803434:	ff 75 bc             	pushl  -0x44(%ebp)
  803437:	e8 36 04 00 00       	call   803872 <free_block>
  80343c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80343f:	83 ec 0c             	sub    $0xc,%esp
  803442:	ff 75 08             	pushl  0x8(%ebp)
  803445:	e8 20 fa ff ff       	call   802e6a <alloc_block_BF>
  80344a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80344d:	c9                   	leave  
  80344e:	c3                   	ret    

0080344f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80344f:	55                   	push   %ebp
  803450:	89 e5                	mov    %esp,%ebp
  803452:	53                   	push   %ebx
  803453:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803456:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80345d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803464:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803468:	74 1e                	je     803488 <merging+0x39>
  80346a:	ff 75 08             	pushl  0x8(%ebp)
  80346d:	e8 bc f1 ff ff       	call   80262e <get_block_size>
  803472:	83 c4 04             	add    $0x4,%esp
  803475:	89 c2                	mov    %eax,%edx
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	01 d0                	add    %edx,%eax
  80347c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80347f:	75 07                	jne    803488 <merging+0x39>
		prev_is_free = 1;
  803481:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803488:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80348c:	74 1e                	je     8034ac <merging+0x5d>
  80348e:	ff 75 10             	pushl  0x10(%ebp)
  803491:	e8 98 f1 ff ff       	call   80262e <get_block_size>
  803496:	83 c4 04             	add    $0x4,%esp
  803499:	89 c2                	mov    %eax,%edx
  80349b:	8b 45 10             	mov    0x10(%ebp),%eax
  80349e:	01 d0                	add    %edx,%eax
  8034a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034a3:	75 07                	jne    8034ac <merging+0x5d>
		next_is_free = 1;
  8034a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8034ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b0:	0f 84 cc 00 00 00    	je     803582 <merging+0x133>
  8034b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034ba:	0f 84 c2 00 00 00    	je     803582 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8034c0:	ff 75 08             	pushl  0x8(%ebp)
  8034c3:	e8 66 f1 ff ff       	call   80262e <get_block_size>
  8034c8:	83 c4 04             	add    $0x4,%esp
  8034cb:	89 c3                	mov    %eax,%ebx
  8034cd:	ff 75 10             	pushl  0x10(%ebp)
  8034d0:	e8 59 f1 ff ff       	call   80262e <get_block_size>
  8034d5:	83 c4 04             	add    $0x4,%esp
  8034d8:	01 c3                	add    %eax,%ebx
  8034da:	ff 75 0c             	pushl  0xc(%ebp)
  8034dd:	e8 4c f1 ff ff       	call   80262e <get_block_size>
  8034e2:	83 c4 04             	add    $0x4,%esp
  8034e5:	01 d8                	add    %ebx,%eax
  8034e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034ea:	6a 00                	push   $0x0
  8034ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8034ef:	ff 75 08             	pushl  0x8(%ebp)
  8034f2:	e8 88 f4 ff ff       	call   80297f <set_block_data>
  8034f7:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8034fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034fe:	75 17                	jne    803517 <merging+0xc8>
  803500:	83 ec 04             	sub    $0x4,%esp
  803503:	68 b3 4f 80 00       	push   $0x804fb3
  803508:	68 7d 01 00 00       	push   $0x17d
  80350d:	68 d1 4f 80 00       	push   $0x804fd1
  803512:	e8 52 d5 ff ff       	call   800a69 <_panic>
  803517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351a:	8b 00                	mov    (%eax),%eax
  80351c:	85 c0                	test   %eax,%eax
  80351e:	74 10                	je     803530 <merging+0xe1>
  803520:	8b 45 0c             	mov    0xc(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	8b 55 0c             	mov    0xc(%ebp),%edx
  803528:	8b 52 04             	mov    0x4(%edx),%edx
  80352b:	89 50 04             	mov    %edx,0x4(%eax)
  80352e:	eb 0b                	jmp    80353b <merging+0xec>
  803530:	8b 45 0c             	mov    0xc(%ebp),%eax
  803533:	8b 40 04             	mov    0x4(%eax),%eax
  803536:	a3 48 60 80 00       	mov    %eax,0x806048
  80353b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80353e:	8b 40 04             	mov    0x4(%eax),%eax
  803541:	85 c0                	test   %eax,%eax
  803543:	74 0f                	je     803554 <merging+0x105>
  803545:	8b 45 0c             	mov    0xc(%ebp),%eax
  803548:	8b 40 04             	mov    0x4(%eax),%eax
  80354b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80354e:	8b 12                	mov    (%edx),%edx
  803550:	89 10                	mov    %edx,(%eax)
  803552:	eb 0a                	jmp    80355e <merging+0x10f>
  803554:	8b 45 0c             	mov    0xc(%ebp),%eax
  803557:	8b 00                	mov    (%eax),%eax
  803559:	a3 44 60 80 00       	mov    %eax,0x806044
  80355e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803561:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803571:	a1 50 60 80 00       	mov    0x806050,%eax
  803576:	48                   	dec    %eax
  803577:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80357c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80357d:	e9 ea 02 00 00       	jmp    80386c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803582:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803586:	74 3b                	je     8035c3 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803588:	83 ec 0c             	sub    $0xc,%esp
  80358b:	ff 75 08             	pushl  0x8(%ebp)
  80358e:	e8 9b f0 ff ff       	call   80262e <get_block_size>
  803593:	83 c4 10             	add    $0x10,%esp
  803596:	89 c3                	mov    %eax,%ebx
  803598:	83 ec 0c             	sub    $0xc,%esp
  80359b:	ff 75 10             	pushl  0x10(%ebp)
  80359e:	e8 8b f0 ff ff       	call   80262e <get_block_size>
  8035a3:	83 c4 10             	add    $0x10,%esp
  8035a6:	01 d8                	add    %ebx,%eax
  8035a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035ab:	83 ec 04             	sub    $0x4,%esp
  8035ae:	6a 00                	push   $0x0
  8035b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8035b3:	ff 75 08             	pushl  0x8(%ebp)
  8035b6:	e8 c4 f3 ff ff       	call   80297f <set_block_data>
  8035bb:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035be:	e9 a9 02 00 00       	jmp    80386c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8035c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035c7:	0f 84 2d 01 00 00    	je     8036fa <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8035cd:	83 ec 0c             	sub    $0xc,%esp
  8035d0:	ff 75 10             	pushl  0x10(%ebp)
  8035d3:	e8 56 f0 ff ff       	call   80262e <get_block_size>
  8035d8:	83 c4 10             	add    $0x10,%esp
  8035db:	89 c3                	mov    %eax,%ebx
  8035dd:	83 ec 0c             	sub    $0xc,%esp
  8035e0:	ff 75 0c             	pushl  0xc(%ebp)
  8035e3:	e8 46 f0 ff ff       	call   80262e <get_block_size>
  8035e8:	83 c4 10             	add    $0x10,%esp
  8035eb:	01 d8                	add    %ebx,%eax
  8035ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8035f0:	83 ec 04             	sub    $0x4,%esp
  8035f3:	6a 00                	push   $0x0
  8035f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035f8:	ff 75 10             	pushl  0x10(%ebp)
  8035fb:	e8 7f f3 ff ff       	call   80297f <set_block_data>
  803600:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803603:	8b 45 10             	mov    0x10(%ebp),%eax
  803606:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803609:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80360d:	74 06                	je     803615 <merging+0x1c6>
  80360f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803613:	75 17                	jne    80362c <merging+0x1dd>
  803615:	83 ec 04             	sub    $0x4,%esp
  803618:	68 8c 50 80 00       	push   $0x80508c
  80361d:	68 8d 01 00 00       	push   $0x18d
  803622:	68 d1 4f 80 00       	push   $0x804fd1
  803627:	e8 3d d4 ff ff       	call   800a69 <_panic>
  80362c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362f:	8b 50 04             	mov    0x4(%eax),%edx
  803632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803635:	89 50 04             	mov    %edx,0x4(%eax)
  803638:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80363b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80363e:	89 10                	mov    %edx,(%eax)
  803640:	8b 45 0c             	mov    0xc(%ebp),%eax
  803643:	8b 40 04             	mov    0x4(%eax),%eax
  803646:	85 c0                	test   %eax,%eax
  803648:	74 0d                	je     803657 <merging+0x208>
  80364a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364d:	8b 40 04             	mov    0x4(%eax),%eax
  803650:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803653:	89 10                	mov    %edx,(%eax)
  803655:	eb 08                	jmp    80365f <merging+0x210>
  803657:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80365a:	a3 44 60 80 00       	mov    %eax,0x806044
  80365f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803662:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803665:	89 50 04             	mov    %edx,0x4(%eax)
  803668:	a1 50 60 80 00       	mov    0x806050,%eax
  80366d:	40                   	inc    %eax
  80366e:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  803673:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803677:	75 17                	jne    803690 <merging+0x241>
  803679:	83 ec 04             	sub    $0x4,%esp
  80367c:	68 b3 4f 80 00       	push   $0x804fb3
  803681:	68 8e 01 00 00       	push   $0x18e
  803686:	68 d1 4f 80 00       	push   $0x804fd1
  80368b:	e8 d9 d3 ff ff       	call   800a69 <_panic>
  803690:	8b 45 0c             	mov    0xc(%ebp),%eax
  803693:	8b 00                	mov    (%eax),%eax
  803695:	85 c0                	test   %eax,%eax
  803697:	74 10                	je     8036a9 <merging+0x25a>
  803699:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036a1:	8b 52 04             	mov    0x4(%edx),%edx
  8036a4:	89 50 04             	mov    %edx,0x4(%eax)
  8036a7:	eb 0b                	jmp    8036b4 <merging+0x265>
  8036a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ac:	8b 40 04             	mov    0x4(%eax),%eax
  8036af:	a3 48 60 80 00       	mov    %eax,0x806048
  8036b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b7:	8b 40 04             	mov    0x4(%eax),%eax
  8036ba:	85 c0                	test   %eax,%eax
  8036bc:	74 0f                	je     8036cd <merging+0x27e>
  8036be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c1:	8b 40 04             	mov    0x4(%eax),%eax
  8036c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036c7:	8b 12                	mov    (%edx),%edx
  8036c9:	89 10                	mov    %edx,(%eax)
  8036cb:	eb 0a                	jmp    8036d7 <merging+0x288>
  8036cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d0:	8b 00                	mov    (%eax),%eax
  8036d2:	a3 44 60 80 00       	mov    %eax,0x806044
  8036d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ea:	a1 50 60 80 00       	mov    0x806050,%eax
  8036ef:	48                   	dec    %eax
  8036f0:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036f5:	e9 72 01 00 00       	jmp    80386c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8036fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8036fd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803700:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803704:	74 79                	je     80377f <merging+0x330>
  803706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80370a:	74 73                	je     80377f <merging+0x330>
  80370c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803710:	74 06                	je     803718 <merging+0x2c9>
  803712:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803716:	75 17                	jne    80372f <merging+0x2e0>
  803718:	83 ec 04             	sub    $0x4,%esp
  80371b:	68 44 50 80 00       	push   $0x805044
  803720:	68 94 01 00 00       	push   $0x194
  803725:	68 d1 4f 80 00       	push   $0x804fd1
  80372a:	e8 3a d3 ff ff       	call   800a69 <_panic>
  80372f:	8b 45 08             	mov    0x8(%ebp),%eax
  803732:	8b 10                	mov    (%eax),%edx
  803734:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803737:	89 10                	mov    %edx,(%eax)
  803739:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80373c:	8b 00                	mov    (%eax),%eax
  80373e:	85 c0                	test   %eax,%eax
  803740:	74 0b                	je     80374d <merging+0x2fe>
  803742:	8b 45 08             	mov    0x8(%ebp),%eax
  803745:	8b 00                	mov    (%eax),%eax
  803747:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80374a:	89 50 04             	mov    %edx,0x4(%eax)
  80374d:	8b 45 08             	mov    0x8(%ebp),%eax
  803750:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803753:	89 10                	mov    %edx,(%eax)
  803755:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803758:	8b 55 08             	mov    0x8(%ebp),%edx
  80375b:	89 50 04             	mov    %edx,0x4(%eax)
  80375e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803761:	8b 00                	mov    (%eax),%eax
  803763:	85 c0                	test   %eax,%eax
  803765:	75 08                	jne    80376f <merging+0x320>
  803767:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376a:	a3 48 60 80 00       	mov    %eax,0x806048
  80376f:	a1 50 60 80 00       	mov    0x806050,%eax
  803774:	40                   	inc    %eax
  803775:	a3 50 60 80 00       	mov    %eax,0x806050
  80377a:	e9 ce 00 00 00       	jmp    80384d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80377f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803783:	74 65                	je     8037ea <merging+0x39b>
  803785:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803789:	75 17                	jne    8037a2 <merging+0x353>
  80378b:	83 ec 04             	sub    $0x4,%esp
  80378e:	68 20 50 80 00       	push   $0x805020
  803793:	68 95 01 00 00       	push   $0x195
  803798:	68 d1 4f 80 00       	push   $0x804fd1
  80379d:	e8 c7 d2 ff ff       	call   800a69 <_panic>
  8037a2:	8b 15 48 60 80 00    	mov    0x806048,%edx
  8037a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ab:	89 50 04             	mov    %edx,0x4(%eax)
  8037ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037b1:	8b 40 04             	mov    0x4(%eax),%eax
  8037b4:	85 c0                	test   %eax,%eax
  8037b6:	74 0c                	je     8037c4 <merging+0x375>
  8037b8:	a1 48 60 80 00       	mov    0x806048,%eax
  8037bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037c0:	89 10                	mov    %edx,(%eax)
  8037c2:	eb 08                	jmp    8037cc <merging+0x37d>
  8037c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c7:	a3 44 60 80 00       	mov    %eax,0x806044
  8037cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037cf:	a3 48 60 80 00       	mov    %eax,0x806048
  8037d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037dd:	a1 50 60 80 00       	mov    0x806050,%eax
  8037e2:	40                   	inc    %eax
  8037e3:	a3 50 60 80 00       	mov    %eax,0x806050
  8037e8:	eb 63                	jmp    80384d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8037ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037ee:	75 17                	jne    803807 <merging+0x3b8>
  8037f0:	83 ec 04             	sub    $0x4,%esp
  8037f3:	68 ec 4f 80 00       	push   $0x804fec
  8037f8:	68 98 01 00 00       	push   $0x198
  8037fd:	68 d1 4f 80 00       	push   $0x804fd1
  803802:	e8 62 d2 ff ff       	call   800a69 <_panic>
  803807:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80380d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803810:	89 10                	mov    %edx,(%eax)
  803812:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803815:	8b 00                	mov    (%eax),%eax
  803817:	85 c0                	test   %eax,%eax
  803819:	74 0d                	je     803828 <merging+0x3d9>
  80381b:	a1 44 60 80 00       	mov    0x806044,%eax
  803820:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803823:	89 50 04             	mov    %edx,0x4(%eax)
  803826:	eb 08                	jmp    803830 <merging+0x3e1>
  803828:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80382b:	a3 48 60 80 00       	mov    %eax,0x806048
  803830:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803833:	a3 44 60 80 00       	mov    %eax,0x806044
  803838:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80383b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803842:	a1 50 60 80 00       	mov    0x806050,%eax
  803847:	40                   	inc    %eax
  803848:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  80384d:	83 ec 0c             	sub    $0xc,%esp
  803850:	ff 75 10             	pushl  0x10(%ebp)
  803853:	e8 d6 ed ff ff       	call   80262e <get_block_size>
  803858:	83 c4 10             	add    $0x10,%esp
  80385b:	83 ec 04             	sub    $0x4,%esp
  80385e:	6a 00                	push   $0x0
  803860:	50                   	push   %eax
  803861:	ff 75 10             	pushl  0x10(%ebp)
  803864:	e8 16 f1 ff ff       	call   80297f <set_block_data>
  803869:	83 c4 10             	add    $0x10,%esp
	}
}
  80386c:	90                   	nop
  80386d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803870:	c9                   	leave  
  803871:	c3                   	ret    

00803872 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803872:	55                   	push   %ebp
  803873:	89 e5                	mov    %esp,%ebp
  803875:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803878:	a1 44 60 80 00       	mov    0x806044,%eax
  80387d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803880:	a1 48 60 80 00       	mov    0x806048,%eax
  803885:	3b 45 08             	cmp    0x8(%ebp),%eax
  803888:	73 1b                	jae    8038a5 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80388a:	a1 48 60 80 00       	mov    0x806048,%eax
  80388f:	83 ec 04             	sub    $0x4,%esp
  803892:	ff 75 08             	pushl  0x8(%ebp)
  803895:	6a 00                	push   $0x0
  803897:	50                   	push   %eax
  803898:	e8 b2 fb ff ff       	call   80344f <merging>
  80389d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038a0:	e9 8b 00 00 00       	jmp    803930 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8038a5:	a1 44 60 80 00       	mov    0x806044,%eax
  8038aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038ad:	76 18                	jbe    8038c7 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8038af:	a1 44 60 80 00       	mov    0x806044,%eax
  8038b4:	83 ec 04             	sub    $0x4,%esp
  8038b7:	ff 75 08             	pushl  0x8(%ebp)
  8038ba:	50                   	push   %eax
  8038bb:	6a 00                	push   $0x0
  8038bd:	e8 8d fb ff ff       	call   80344f <merging>
  8038c2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038c5:	eb 69                	jmp    803930 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038c7:	a1 44 60 80 00       	mov    0x806044,%eax
  8038cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038cf:	eb 39                	jmp    80390a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8038d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038d7:	73 29                	jae    803902 <free_block+0x90>
  8038d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038dc:	8b 00                	mov    (%eax),%eax
  8038de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038e1:	76 1f                	jbe    803902 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8038e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e6:	8b 00                	mov    (%eax),%eax
  8038e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8038eb:	83 ec 04             	sub    $0x4,%esp
  8038ee:	ff 75 08             	pushl  0x8(%ebp)
  8038f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8038f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8038f7:	e8 53 fb ff ff       	call   80344f <merging>
  8038fc:	83 c4 10             	add    $0x10,%esp
			break;
  8038ff:	90                   	nop
		}
	}
}
  803900:	eb 2e                	jmp    803930 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803902:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803907:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80390a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80390e:	74 07                	je     803917 <free_block+0xa5>
  803910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803913:	8b 00                	mov    (%eax),%eax
  803915:	eb 05                	jmp    80391c <free_block+0xaa>
  803917:	b8 00 00 00 00       	mov    $0x0,%eax
  80391c:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803921:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803926:	85 c0                	test   %eax,%eax
  803928:	75 a7                	jne    8038d1 <free_block+0x5f>
  80392a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80392e:	75 a1                	jne    8038d1 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803930:	90                   	nop
  803931:	c9                   	leave  
  803932:	c3                   	ret    

00803933 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803933:	55                   	push   %ebp
  803934:	89 e5                	mov    %esp,%ebp
  803936:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803939:	ff 75 08             	pushl  0x8(%ebp)
  80393c:	e8 ed ec ff ff       	call   80262e <get_block_size>
  803941:	83 c4 04             	add    $0x4,%esp
  803944:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803947:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80394e:	eb 17                	jmp    803967 <copy_data+0x34>
  803950:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803953:	8b 45 0c             	mov    0xc(%ebp),%eax
  803956:	01 c2                	add    %eax,%edx
  803958:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80395b:	8b 45 08             	mov    0x8(%ebp),%eax
  80395e:	01 c8                	add    %ecx,%eax
  803960:	8a 00                	mov    (%eax),%al
  803962:	88 02                	mov    %al,(%edx)
  803964:	ff 45 fc             	incl   -0x4(%ebp)
  803967:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80396a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80396d:	72 e1                	jb     803950 <copy_data+0x1d>
}
  80396f:	90                   	nop
  803970:	c9                   	leave  
  803971:	c3                   	ret    

00803972 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803972:	55                   	push   %ebp
  803973:	89 e5                	mov    %esp,%ebp
  803975:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803978:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80397c:	75 23                	jne    8039a1 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80397e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803982:	74 13                	je     803997 <realloc_block_FF+0x25>
  803984:	83 ec 0c             	sub    $0xc,%esp
  803987:	ff 75 0c             	pushl  0xc(%ebp)
  80398a:	e8 1f f0 ff ff       	call   8029ae <alloc_block_FF>
  80398f:	83 c4 10             	add    $0x10,%esp
  803992:	e9 f4 06 00 00       	jmp    80408b <realloc_block_FF+0x719>
		return NULL;
  803997:	b8 00 00 00 00       	mov    $0x0,%eax
  80399c:	e9 ea 06 00 00       	jmp    80408b <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8039a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039a5:	75 18                	jne    8039bf <realloc_block_FF+0x4d>
	{
		free_block(va);
  8039a7:	83 ec 0c             	sub    $0xc,%esp
  8039aa:	ff 75 08             	pushl  0x8(%ebp)
  8039ad:	e8 c0 fe ff ff       	call   803872 <free_block>
  8039b2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8039b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ba:	e9 cc 06 00 00       	jmp    80408b <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8039bf:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8039c3:	77 07                	ja     8039cc <realloc_block_FF+0x5a>
  8039c5:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8039cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039cf:	83 e0 01             	and    $0x1,%eax
  8039d2:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8039d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039d8:	83 c0 08             	add    $0x8,%eax
  8039db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8039de:	83 ec 0c             	sub    $0xc,%esp
  8039e1:	ff 75 08             	pushl  0x8(%ebp)
  8039e4:	e8 45 ec ff ff       	call   80262e <get_block_size>
  8039e9:	83 c4 10             	add    $0x10,%esp
  8039ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039f2:	83 e8 08             	sub    $0x8,%eax
  8039f5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8039f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fb:	83 e8 04             	sub    $0x4,%eax
  8039fe:	8b 00                	mov    (%eax),%eax
  803a00:	83 e0 fe             	and    $0xfffffffe,%eax
  803a03:	89 c2                	mov    %eax,%edx
  803a05:	8b 45 08             	mov    0x8(%ebp),%eax
  803a08:	01 d0                	add    %edx,%eax
  803a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803a0d:	83 ec 0c             	sub    $0xc,%esp
  803a10:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a13:	e8 16 ec ff ff       	call   80262e <get_block_size>
  803a18:	83 c4 10             	add    $0x10,%esp
  803a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a21:	83 e8 08             	sub    $0x8,%eax
  803a24:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a2a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a2d:	75 08                	jne    803a37 <realloc_block_FF+0xc5>
	{
		 return va;
  803a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a32:	e9 54 06 00 00       	jmp    80408b <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a3a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a3d:	0f 83 e5 03 00 00    	jae    803e28 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803a43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a46:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a49:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803a4c:	83 ec 0c             	sub    $0xc,%esp
  803a4f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a52:	e8 f0 eb ff ff       	call   802647 <is_free_block>
  803a57:	83 c4 10             	add    $0x10,%esp
  803a5a:	84 c0                	test   %al,%al
  803a5c:	0f 84 3b 01 00 00    	je     803b9d <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a65:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a68:	01 d0                	add    %edx,%eax
  803a6a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a6d:	83 ec 04             	sub    $0x4,%esp
  803a70:	6a 01                	push   $0x1
  803a72:	ff 75 f0             	pushl  -0x10(%ebp)
  803a75:	ff 75 08             	pushl  0x8(%ebp)
  803a78:	e8 02 ef ff ff       	call   80297f <set_block_data>
  803a7d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803a80:	8b 45 08             	mov    0x8(%ebp),%eax
  803a83:	83 e8 04             	sub    $0x4,%eax
  803a86:	8b 00                	mov    (%eax),%eax
  803a88:	83 e0 fe             	and    $0xfffffffe,%eax
  803a8b:	89 c2                	mov    %eax,%edx
  803a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a90:	01 d0                	add    %edx,%eax
  803a92:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803a95:	83 ec 04             	sub    $0x4,%esp
  803a98:	6a 00                	push   $0x0
  803a9a:	ff 75 cc             	pushl  -0x34(%ebp)
  803a9d:	ff 75 c8             	pushl  -0x38(%ebp)
  803aa0:	e8 da ee ff ff       	call   80297f <set_block_data>
  803aa5:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803aac:	74 06                	je     803ab4 <realloc_block_FF+0x142>
  803aae:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803ab2:	75 17                	jne    803acb <realloc_block_FF+0x159>
  803ab4:	83 ec 04             	sub    $0x4,%esp
  803ab7:	68 44 50 80 00       	push   $0x805044
  803abc:	68 f6 01 00 00       	push   $0x1f6
  803ac1:	68 d1 4f 80 00       	push   $0x804fd1
  803ac6:	e8 9e cf ff ff       	call   800a69 <_panic>
  803acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ace:	8b 10                	mov    (%eax),%edx
  803ad0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ad3:	89 10                	mov    %edx,(%eax)
  803ad5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ad8:	8b 00                	mov    (%eax),%eax
  803ada:	85 c0                	test   %eax,%eax
  803adc:	74 0b                	je     803ae9 <realloc_block_FF+0x177>
  803ade:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae1:	8b 00                	mov    (%eax),%eax
  803ae3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ae6:	89 50 04             	mov    %edx,0x4(%eax)
  803ae9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aec:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803aef:	89 10                	mov    %edx,(%eax)
  803af1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803af4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803af7:	89 50 04             	mov    %edx,0x4(%eax)
  803afa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803afd:	8b 00                	mov    (%eax),%eax
  803aff:	85 c0                	test   %eax,%eax
  803b01:	75 08                	jne    803b0b <realloc_block_FF+0x199>
  803b03:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b06:	a3 48 60 80 00       	mov    %eax,0x806048
  803b0b:	a1 50 60 80 00       	mov    0x806050,%eax
  803b10:	40                   	inc    %eax
  803b11:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803b16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b1a:	75 17                	jne    803b33 <realloc_block_FF+0x1c1>
  803b1c:	83 ec 04             	sub    $0x4,%esp
  803b1f:	68 b3 4f 80 00       	push   $0x804fb3
  803b24:	68 f7 01 00 00       	push   $0x1f7
  803b29:	68 d1 4f 80 00       	push   $0x804fd1
  803b2e:	e8 36 cf ff ff       	call   800a69 <_panic>
  803b33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b36:	8b 00                	mov    (%eax),%eax
  803b38:	85 c0                	test   %eax,%eax
  803b3a:	74 10                	je     803b4c <realloc_block_FF+0x1da>
  803b3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b3f:	8b 00                	mov    (%eax),%eax
  803b41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b44:	8b 52 04             	mov    0x4(%edx),%edx
  803b47:	89 50 04             	mov    %edx,0x4(%eax)
  803b4a:	eb 0b                	jmp    803b57 <realloc_block_FF+0x1e5>
  803b4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b4f:	8b 40 04             	mov    0x4(%eax),%eax
  803b52:	a3 48 60 80 00       	mov    %eax,0x806048
  803b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5a:	8b 40 04             	mov    0x4(%eax),%eax
  803b5d:	85 c0                	test   %eax,%eax
  803b5f:	74 0f                	je     803b70 <realloc_block_FF+0x1fe>
  803b61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b64:	8b 40 04             	mov    0x4(%eax),%eax
  803b67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b6a:	8b 12                	mov    (%edx),%edx
  803b6c:	89 10                	mov    %edx,(%eax)
  803b6e:	eb 0a                	jmp    803b7a <realloc_block_FF+0x208>
  803b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b73:	8b 00                	mov    (%eax),%eax
  803b75:	a3 44 60 80 00       	mov    %eax,0x806044
  803b7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b8d:	a1 50 60 80 00       	mov    0x806050,%eax
  803b92:	48                   	dec    %eax
  803b93:	a3 50 60 80 00       	mov    %eax,0x806050
  803b98:	e9 83 02 00 00       	jmp    803e20 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803b9d:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803ba1:	0f 86 69 02 00 00    	jbe    803e10 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803ba7:	83 ec 04             	sub    $0x4,%esp
  803baa:	6a 01                	push   $0x1
  803bac:	ff 75 f0             	pushl  -0x10(%ebp)
  803baf:	ff 75 08             	pushl  0x8(%ebp)
  803bb2:	e8 c8 ed ff ff       	call   80297f <set_block_data>
  803bb7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803bba:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbd:	83 e8 04             	sub    $0x4,%eax
  803bc0:	8b 00                	mov    (%eax),%eax
  803bc2:	83 e0 fe             	and    $0xfffffffe,%eax
  803bc5:	89 c2                	mov    %eax,%edx
  803bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bca:	01 d0                	add    %edx,%eax
  803bcc:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803bcf:	a1 50 60 80 00       	mov    0x806050,%eax
  803bd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803bd7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803bdb:	75 68                	jne    803c45 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803bdd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803be1:	75 17                	jne    803bfa <realloc_block_FF+0x288>
  803be3:	83 ec 04             	sub    $0x4,%esp
  803be6:	68 ec 4f 80 00       	push   $0x804fec
  803beb:	68 06 02 00 00       	push   $0x206
  803bf0:	68 d1 4f 80 00       	push   $0x804fd1
  803bf5:	e8 6f ce ff ff       	call   800a69 <_panic>
  803bfa:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803c00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c03:	89 10                	mov    %edx,(%eax)
  803c05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c08:	8b 00                	mov    (%eax),%eax
  803c0a:	85 c0                	test   %eax,%eax
  803c0c:	74 0d                	je     803c1b <realloc_block_FF+0x2a9>
  803c0e:	a1 44 60 80 00       	mov    0x806044,%eax
  803c13:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c16:	89 50 04             	mov    %edx,0x4(%eax)
  803c19:	eb 08                	jmp    803c23 <realloc_block_FF+0x2b1>
  803c1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c1e:	a3 48 60 80 00       	mov    %eax,0x806048
  803c23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c26:	a3 44 60 80 00       	mov    %eax,0x806044
  803c2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c35:	a1 50 60 80 00       	mov    0x806050,%eax
  803c3a:	40                   	inc    %eax
  803c3b:	a3 50 60 80 00       	mov    %eax,0x806050
  803c40:	e9 b0 01 00 00       	jmp    803df5 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803c45:	a1 44 60 80 00       	mov    0x806044,%eax
  803c4a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c4d:	76 68                	jbe    803cb7 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c4f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c53:	75 17                	jne    803c6c <realloc_block_FF+0x2fa>
  803c55:	83 ec 04             	sub    $0x4,%esp
  803c58:	68 ec 4f 80 00       	push   $0x804fec
  803c5d:	68 0b 02 00 00       	push   $0x20b
  803c62:	68 d1 4f 80 00       	push   $0x804fd1
  803c67:	e8 fd cd ff ff       	call   800a69 <_panic>
  803c6c:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803c72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c75:	89 10                	mov    %edx,(%eax)
  803c77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c7a:	8b 00                	mov    (%eax),%eax
  803c7c:	85 c0                	test   %eax,%eax
  803c7e:	74 0d                	je     803c8d <realloc_block_FF+0x31b>
  803c80:	a1 44 60 80 00       	mov    0x806044,%eax
  803c85:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c88:	89 50 04             	mov    %edx,0x4(%eax)
  803c8b:	eb 08                	jmp    803c95 <realloc_block_FF+0x323>
  803c8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c90:	a3 48 60 80 00       	mov    %eax,0x806048
  803c95:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c98:	a3 44 60 80 00       	mov    %eax,0x806044
  803c9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ca7:	a1 50 60 80 00       	mov    0x806050,%eax
  803cac:	40                   	inc    %eax
  803cad:	a3 50 60 80 00       	mov    %eax,0x806050
  803cb2:	e9 3e 01 00 00       	jmp    803df5 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803cb7:	a1 44 60 80 00       	mov    0x806044,%eax
  803cbc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803cbf:	73 68                	jae    803d29 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803cc1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cc5:	75 17                	jne    803cde <realloc_block_FF+0x36c>
  803cc7:	83 ec 04             	sub    $0x4,%esp
  803cca:	68 20 50 80 00       	push   $0x805020
  803ccf:	68 10 02 00 00       	push   $0x210
  803cd4:	68 d1 4f 80 00       	push   $0x804fd1
  803cd9:	e8 8b cd ff ff       	call   800a69 <_panic>
  803cde:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803ce4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce7:	89 50 04             	mov    %edx,0x4(%eax)
  803cea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ced:	8b 40 04             	mov    0x4(%eax),%eax
  803cf0:	85 c0                	test   %eax,%eax
  803cf2:	74 0c                	je     803d00 <realloc_block_FF+0x38e>
  803cf4:	a1 48 60 80 00       	mov    0x806048,%eax
  803cf9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cfc:	89 10                	mov    %edx,(%eax)
  803cfe:	eb 08                	jmp    803d08 <realloc_block_FF+0x396>
  803d00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d03:	a3 44 60 80 00       	mov    %eax,0x806044
  803d08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d0b:	a3 48 60 80 00       	mov    %eax,0x806048
  803d10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d19:	a1 50 60 80 00       	mov    0x806050,%eax
  803d1e:	40                   	inc    %eax
  803d1f:	a3 50 60 80 00       	mov    %eax,0x806050
  803d24:	e9 cc 00 00 00       	jmp    803df5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803d29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803d30:	a1 44 60 80 00       	mov    0x806044,%eax
  803d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d38:	e9 8a 00 00 00       	jmp    803dc7 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d40:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d43:	73 7a                	jae    803dbf <realloc_block_FF+0x44d>
  803d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d48:	8b 00                	mov    (%eax),%eax
  803d4a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d4d:	73 70                	jae    803dbf <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803d4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d53:	74 06                	je     803d5b <realloc_block_FF+0x3e9>
  803d55:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d59:	75 17                	jne    803d72 <realloc_block_FF+0x400>
  803d5b:	83 ec 04             	sub    $0x4,%esp
  803d5e:	68 44 50 80 00       	push   $0x805044
  803d63:	68 1a 02 00 00       	push   $0x21a
  803d68:	68 d1 4f 80 00       	push   $0x804fd1
  803d6d:	e8 f7 cc ff ff       	call   800a69 <_panic>
  803d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d75:	8b 10                	mov    (%eax),%edx
  803d77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d7a:	89 10                	mov    %edx,(%eax)
  803d7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d7f:	8b 00                	mov    (%eax),%eax
  803d81:	85 c0                	test   %eax,%eax
  803d83:	74 0b                	je     803d90 <realloc_block_FF+0x41e>
  803d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d88:	8b 00                	mov    (%eax),%eax
  803d8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d8d:	89 50 04             	mov    %edx,0x4(%eax)
  803d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d93:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d96:	89 10                	mov    %edx,(%eax)
  803d98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d9e:	89 50 04             	mov    %edx,0x4(%eax)
  803da1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da4:	8b 00                	mov    (%eax),%eax
  803da6:	85 c0                	test   %eax,%eax
  803da8:	75 08                	jne    803db2 <realloc_block_FF+0x440>
  803daa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dad:	a3 48 60 80 00       	mov    %eax,0x806048
  803db2:	a1 50 60 80 00       	mov    0x806050,%eax
  803db7:	40                   	inc    %eax
  803db8:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  803dbd:	eb 36                	jmp    803df5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803dbf:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dcb:	74 07                	je     803dd4 <realloc_block_FF+0x462>
  803dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd0:	8b 00                	mov    (%eax),%eax
  803dd2:	eb 05                	jmp    803dd9 <realloc_block_FF+0x467>
  803dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd9:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803dde:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803de3:	85 c0                	test   %eax,%eax
  803de5:	0f 85 52 ff ff ff    	jne    803d3d <realloc_block_FF+0x3cb>
  803deb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803def:	0f 85 48 ff ff ff    	jne    803d3d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803df5:	83 ec 04             	sub    $0x4,%esp
  803df8:	6a 00                	push   $0x0
  803dfa:	ff 75 d8             	pushl  -0x28(%ebp)
  803dfd:	ff 75 d4             	pushl  -0x2c(%ebp)
  803e00:	e8 7a eb ff ff       	call   80297f <set_block_data>
  803e05:	83 c4 10             	add    $0x10,%esp
				return va;
  803e08:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0b:	e9 7b 02 00 00       	jmp    80408b <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803e10:	83 ec 0c             	sub    $0xc,%esp
  803e13:	68 c1 50 80 00       	push   $0x8050c1
  803e18:	e8 09 cf ff ff       	call   800d26 <cprintf>
  803e1d:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803e20:	8b 45 08             	mov    0x8(%ebp),%eax
  803e23:	e9 63 02 00 00       	jmp    80408b <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e2b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e2e:	0f 86 4d 02 00 00    	jbe    804081 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803e34:	83 ec 0c             	sub    $0xc,%esp
  803e37:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e3a:	e8 08 e8 ff ff       	call   802647 <is_free_block>
  803e3f:	83 c4 10             	add    $0x10,%esp
  803e42:	84 c0                	test   %al,%al
  803e44:	0f 84 37 02 00 00    	je     804081 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e4d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e50:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803e53:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e56:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e59:	76 38                	jbe    803e93 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803e5b:	83 ec 0c             	sub    $0xc,%esp
  803e5e:	ff 75 08             	pushl  0x8(%ebp)
  803e61:	e8 0c fa ff ff       	call   803872 <free_block>
  803e66:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e69:	83 ec 0c             	sub    $0xc,%esp
  803e6c:	ff 75 0c             	pushl  0xc(%ebp)
  803e6f:	e8 3a eb ff ff       	call   8029ae <alloc_block_FF>
  803e74:	83 c4 10             	add    $0x10,%esp
  803e77:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803e7a:	83 ec 08             	sub    $0x8,%esp
  803e7d:	ff 75 c0             	pushl  -0x40(%ebp)
  803e80:	ff 75 08             	pushl  0x8(%ebp)
  803e83:	e8 ab fa ff ff       	call   803933 <copy_data>
  803e88:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803e8b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e8e:	e9 f8 01 00 00       	jmp    80408b <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803e93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e96:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803e99:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803e9c:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803ea0:	0f 87 a0 00 00 00    	ja     803f46 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803ea6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803eaa:	75 17                	jne    803ec3 <realloc_block_FF+0x551>
  803eac:	83 ec 04             	sub    $0x4,%esp
  803eaf:	68 b3 4f 80 00       	push   $0x804fb3
  803eb4:	68 38 02 00 00       	push   $0x238
  803eb9:	68 d1 4f 80 00       	push   $0x804fd1
  803ebe:	e8 a6 cb ff ff       	call   800a69 <_panic>
  803ec3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec6:	8b 00                	mov    (%eax),%eax
  803ec8:	85 c0                	test   %eax,%eax
  803eca:	74 10                	je     803edc <realloc_block_FF+0x56a>
  803ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ecf:	8b 00                	mov    (%eax),%eax
  803ed1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ed4:	8b 52 04             	mov    0x4(%edx),%edx
  803ed7:	89 50 04             	mov    %edx,0x4(%eax)
  803eda:	eb 0b                	jmp    803ee7 <realloc_block_FF+0x575>
  803edc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803edf:	8b 40 04             	mov    0x4(%eax),%eax
  803ee2:	a3 48 60 80 00       	mov    %eax,0x806048
  803ee7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eea:	8b 40 04             	mov    0x4(%eax),%eax
  803eed:	85 c0                	test   %eax,%eax
  803eef:	74 0f                	je     803f00 <realloc_block_FF+0x58e>
  803ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef4:	8b 40 04             	mov    0x4(%eax),%eax
  803ef7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803efa:	8b 12                	mov    (%edx),%edx
  803efc:	89 10                	mov    %edx,(%eax)
  803efe:	eb 0a                	jmp    803f0a <realloc_block_FF+0x598>
  803f00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f03:	8b 00                	mov    (%eax),%eax
  803f05:	a3 44 60 80 00       	mov    %eax,0x806044
  803f0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f1d:	a1 50 60 80 00       	mov    0x806050,%eax
  803f22:	48                   	dec    %eax
  803f23:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803f28:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f2e:	01 d0                	add    %edx,%eax
  803f30:	83 ec 04             	sub    $0x4,%esp
  803f33:	6a 01                	push   $0x1
  803f35:	50                   	push   %eax
  803f36:	ff 75 08             	pushl  0x8(%ebp)
  803f39:	e8 41 ea ff ff       	call   80297f <set_block_data>
  803f3e:	83 c4 10             	add    $0x10,%esp
  803f41:	e9 36 01 00 00       	jmp    80407c <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803f46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f4c:	01 d0                	add    %edx,%eax
  803f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803f51:	83 ec 04             	sub    $0x4,%esp
  803f54:	6a 01                	push   $0x1
  803f56:	ff 75 f0             	pushl  -0x10(%ebp)
  803f59:	ff 75 08             	pushl  0x8(%ebp)
  803f5c:	e8 1e ea ff ff       	call   80297f <set_block_data>
  803f61:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f64:	8b 45 08             	mov    0x8(%ebp),%eax
  803f67:	83 e8 04             	sub    $0x4,%eax
  803f6a:	8b 00                	mov    (%eax),%eax
  803f6c:	83 e0 fe             	and    $0xfffffffe,%eax
  803f6f:	89 c2                	mov    %eax,%edx
  803f71:	8b 45 08             	mov    0x8(%ebp),%eax
  803f74:	01 d0                	add    %edx,%eax
  803f76:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f7d:	74 06                	je     803f85 <realloc_block_FF+0x613>
  803f7f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803f83:	75 17                	jne    803f9c <realloc_block_FF+0x62a>
  803f85:	83 ec 04             	sub    $0x4,%esp
  803f88:	68 44 50 80 00       	push   $0x805044
  803f8d:	68 44 02 00 00       	push   $0x244
  803f92:	68 d1 4f 80 00       	push   $0x804fd1
  803f97:	e8 cd ca ff ff       	call   800a69 <_panic>
  803f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9f:	8b 10                	mov    (%eax),%edx
  803fa1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fa4:	89 10                	mov    %edx,(%eax)
  803fa6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fa9:	8b 00                	mov    (%eax),%eax
  803fab:	85 c0                	test   %eax,%eax
  803fad:	74 0b                	je     803fba <realloc_block_FF+0x648>
  803faf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb2:	8b 00                	mov    (%eax),%eax
  803fb4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803fb7:	89 50 04             	mov    %edx,0x4(%eax)
  803fba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fbd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803fc0:	89 10                	mov    %edx,(%eax)
  803fc2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fc5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fc8:	89 50 04             	mov    %edx,0x4(%eax)
  803fcb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fce:	8b 00                	mov    (%eax),%eax
  803fd0:	85 c0                	test   %eax,%eax
  803fd2:	75 08                	jne    803fdc <realloc_block_FF+0x66a>
  803fd4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fd7:	a3 48 60 80 00       	mov    %eax,0x806048
  803fdc:	a1 50 60 80 00       	mov    0x806050,%eax
  803fe1:	40                   	inc    %eax
  803fe2:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803fe7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803feb:	75 17                	jne    804004 <realloc_block_FF+0x692>
  803fed:	83 ec 04             	sub    $0x4,%esp
  803ff0:	68 b3 4f 80 00       	push   $0x804fb3
  803ff5:	68 45 02 00 00       	push   $0x245
  803ffa:	68 d1 4f 80 00       	push   $0x804fd1
  803fff:	e8 65 ca ff ff       	call   800a69 <_panic>
  804004:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804007:	8b 00                	mov    (%eax),%eax
  804009:	85 c0                	test   %eax,%eax
  80400b:	74 10                	je     80401d <realloc_block_FF+0x6ab>
  80400d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804010:	8b 00                	mov    (%eax),%eax
  804012:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804015:	8b 52 04             	mov    0x4(%edx),%edx
  804018:	89 50 04             	mov    %edx,0x4(%eax)
  80401b:	eb 0b                	jmp    804028 <realloc_block_FF+0x6b6>
  80401d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804020:	8b 40 04             	mov    0x4(%eax),%eax
  804023:	a3 48 60 80 00       	mov    %eax,0x806048
  804028:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80402b:	8b 40 04             	mov    0x4(%eax),%eax
  80402e:	85 c0                	test   %eax,%eax
  804030:	74 0f                	je     804041 <realloc_block_FF+0x6cf>
  804032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804035:	8b 40 04             	mov    0x4(%eax),%eax
  804038:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80403b:	8b 12                	mov    (%edx),%edx
  80403d:	89 10                	mov    %edx,(%eax)
  80403f:	eb 0a                	jmp    80404b <realloc_block_FF+0x6d9>
  804041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804044:	8b 00                	mov    (%eax),%eax
  804046:	a3 44 60 80 00       	mov    %eax,0x806044
  80404b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80404e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804057:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80405e:	a1 50 60 80 00       	mov    0x806050,%eax
  804063:	48                   	dec    %eax
  804064:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  804069:	83 ec 04             	sub    $0x4,%esp
  80406c:	6a 00                	push   $0x0
  80406e:	ff 75 bc             	pushl  -0x44(%ebp)
  804071:	ff 75 b8             	pushl  -0x48(%ebp)
  804074:	e8 06 e9 ff ff       	call   80297f <set_block_data>
  804079:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80407c:	8b 45 08             	mov    0x8(%ebp),%eax
  80407f:	eb 0a                	jmp    80408b <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804081:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804088:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80408b:	c9                   	leave  
  80408c:	c3                   	ret    

0080408d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80408d:	55                   	push   %ebp
  80408e:	89 e5                	mov    %esp,%ebp
  804090:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804093:	83 ec 04             	sub    $0x4,%esp
  804096:	68 c8 50 80 00       	push   $0x8050c8
  80409b:	68 58 02 00 00       	push   $0x258
  8040a0:	68 d1 4f 80 00       	push   $0x804fd1
  8040a5:	e8 bf c9 ff ff       	call   800a69 <_panic>

008040aa <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8040aa:	55                   	push   %ebp
  8040ab:	89 e5                	mov    %esp,%ebp
  8040ad:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8040b0:	83 ec 04             	sub    $0x4,%esp
  8040b3:	68 f0 50 80 00       	push   $0x8050f0
  8040b8:	68 61 02 00 00       	push   $0x261
  8040bd:	68 d1 4f 80 00       	push   $0x804fd1
  8040c2:	e8 a2 c9 ff ff       	call   800a69 <_panic>
  8040c7:	90                   	nop

008040c8 <__udivdi3>:
  8040c8:	55                   	push   %ebp
  8040c9:	57                   	push   %edi
  8040ca:	56                   	push   %esi
  8040cb:	53                   	push   %ebx
  8040cc:	83 ec 1c             	sub    $0x1c,%esp
  8040cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040df:	89 ca                	mov    %ecx,%edx
  8040e1:	89 f8                	mov    %edi,%eax
  8040e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040e7:	85 f6                	test   %esi,%esi
  8040e9:	75 2d                	jne    804118 <__udivdi3+0x50>
  8040eb:	39 cf                	cmp    %ecx,%edi
  8040ed:	77 65                	ja     804154 <__udivdi3+0x8c>
  8040ef:	89 fd                	mov    %edi,%ebp
  8040f1:	85 ff                	test   %edi,%edi
  8040f3:	75 0b                	jne    804100 <__udivdi3+0x38>
  8040f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8040fa:	31 d2                	xor    %edx,%edx
  8040fc:	f7 f7                	div    %edi
  8040fe:	89 c5                	mov    %eax,%ebp
  804100:	31 d2                	xor    %edx,%edx
  804102:	89 c8                	mov    %ecx,%eax
  804104:	f7 f5                	div    %ebp
  804106:	89 c1                	mov    %eax,%ecx
  804108:	89 d8                	mov    %ebx,%eax
  80410a:	f7 f5                	div    %ebp
  80410c:	89 cf                	mov    %ecx,%edi
  80410e:	89 fa                	mov    %edi,%edx
  804110:	83 c4 1c             	add    $0x1c,%esp
  804113:	5b                   	pop    %ebx
  804114:	5e                   	pop    %esi
  804115:	5f                   	pop    %edi
  804116:	5d                   	pop    %ebp
  804117:	c3                   	ret    
  804118:	39 ce                	cmp    %ecx,%esi
  80411a:	77 28                	ja     804144 <__udivdi3+0x7c>
  80411c:	0f bd fe             	bsr    %esi,%edi
  80411f:	83 f7 1f             	xor    $0x1f,%edi
  804122:	75 40                	jne    804164 <__udivdi3+0x9c>
  804124:	39 ce                	cmp    %ecx,%esi
  804126:	72 0a                	jb     804132 <__udivdi3+0x6a>
  804128:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80412c:	0f 87 9e 00 00 00    	ja     8041d0 <__udivdi3+0x108>
  804132:	b8 01 00 00 00       	mov    $0x1,%eax
  804137:	89 fa                	mov    %edi,%edx
  804139:	83 c4 1c             	add    $0x1c,%esp
  80413c:	5b                   	pop    %ebx
  80413d:	5e                   	pop    %esi
  80413e:	5f                   	pop    %edi
  80413f:	5d                   	pop    %ebp
  804140:	c3                   	ret    
  804141:	8d 76 00             	lea    0x0(%esi),%esi
  804144:	31 ff                	xor    %edi,%edi
  804146:	31 c0                	xor    %eax,%eax
  804148:	89 fa                	mov    %edi,%edx
  80414a:	83 c4 1c             	add    $0x1c,%esp
  80414d:	5b                   	pop    %ebx
  80414e:	5e                   	pop    %esi
  80414f:	5f                   	pop    %edi
  804150:	5d                   	pop    %ebp
  804151:	c3                   	ret    
  804152:	66 90                	xchg   %ax,%ax
  804154:	89 d8                	mov    %ebx,%eax
  804156:	f7 f7                	div    %edi
  804158:	31 ff                	xor    %edi,%edi
  80415a:	89 fa                	mov    %edi,%edx
  80415c:	83 c4 1c             	add    $0x1c,%esp
  80415f:	5b                   	pop    %ebx
  804160:	5e                   	pop    %esi
  804161:	5f                   	pop    %edi
  804162:	5d                   	pop    %ebp
  804163:	c3                   	ret    
  804164:	bd 20 00 00 00       	mov    $0x20,%ebp
  804169:	89 eb                	mov    %ebp,%ebx
  80416b:	29 fb                	sub    %edi,%ebx
  80416d:	89 f9                	mov    %edi,%ecx
  80416f:	d3 e6                	shl    %cl,%esi
  804171:	89 c5                	mov    %eax,%ebp
  804173:	88 d9                	mov    %bl,%cl
  804175:	d3 ed                	shr    %cl,%ebp
  804177:	89 e9                	mov    %ebp,%ecx
  804179:	09 f1                	or     %esi,%ecx
  80417b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80417f:	89 f9                	mov    %edi,%ecx
  804181:	d3 e0                	shl    %cl,%eax
  804183:	89 c5                	mov    %eax,%ebp
  804185:	89 d6                	mov    %edx,%esi
  804187:	88 d9                	mov    %bl,%cl
  804189:	d3 ee                	shr    %cl,%esi
  80418b:	89 f9                	mov    %edi,%ecx
  80418d:	d3 e2                	shl    %cl,%edx
  80418f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804193:	88 d9                	mov    %bl,%cl
  804195:	d3 e8                	shr    %cl,%eax
  804197:	09 c2                	or     %eax,%edx
  804199:	89 d0                	mov    %edx,%eax
  80419b:	89 f2                	mov    %esi,%edx
  80419d:	f7 74 24 0c          	divl   0xc(%esp)
  8041a1:	89 d6                	mov    %edx,%esi
  8041a3:	89 c3                	mov    %eax,%ebx
  8041a5:	f7 e5                	mul    %ebp
  8041a7:	39 d6                	cmp    %edx,%esi
  8041a9:	72 19                	jb     8041c4 <__udivdi3+0xfc>
  8041ab:	74 0b                	je     8041b8 <__udivdi3+0xf0>
  8041ad:	89 d8                	mov    %ebx,%eax
  8041af:	31 ff                	xor    %edi,%edi
  8041b1:	e9 58 ff ff ff       	jmp    80410e <__udivdi3+0x46>
  8041b6:	66 90                	xchg   %ax,%ax
  8041b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041bc:	89 f9                	mov    %edi,%ecx
  8041be:	d3 e2                	shl    %cl,%edx
  8041c0:	39 c2                	cmp    %eax,%edx
  8041c2:	73 e9                	jae    8041ad <__udivdi3+0xe5>
  8041c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041c7:	31 ff                	xor    %edi,%edi
  8041c9:	e9 40 ff ff ff       	jmp    80410e <__udivdi3+0x46>
  8041ce:	66 90                	xchg   %ax,%ax
  8041d0:	31 c0                	xor    %eax,%eax
  8041d2:	e9 37 ff ff ff       	jmp    80410e <__udivdi3+0x46>
  8041d7:	90                   	nop

008041d8 <__umoddi3>:
  8041d8:	55                   	push   %ebp
  8041d9:	57                   	push   %edi
  8041da:	56                   	push   %esi
  8041db:	53                   	push   %ebx
  8041dc:	83 ec 1c             	sub    $0x1c,%esp
  8041df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8041f7:	89 f3                	mov    %esi,%ebx
  8041f9:	89 fa                	mov    %edi,%edx
  8041fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041ff:	89 34 24             	mov    %esi,(%esp)
  804202:	85 c0                	test   %eax,%eax
  804204:	75 1a                	jne    804220 <__umoddi3+0x48>
  804206:	39 f7                	cmp    %esi,%edi
  804208:	0f 86 a2 00 00 00    	jbe    8042b0 <__umoddi3+0xd8>
  80420e:	89 c8                	mov    %ecx,%eax
  804210:	89 f2                	mov    %esi,%edx
  804212:	f7 f7                	div    %edi
  804214:	89 d0                	mov    %edx,%eax
  804216:	31 d2                	xor    %edx,%edx
  804218:	83 c4 1c             	add    $0x1c,%esp
  80421b:	5b                   	pop    %ebx
  80421c:	5e                   	pop    %esi
  80421d:	5f                   	pop    %edi
  80421e:	5d                   	pop    %ebp
  80421f:	c3                   	ret    
  804220:	39 f0                	cmp    %esi,%eax
  804222:	0f 87 ac 00 00 00    	ja     8042d4 <__umoddi3+0xfc>
  804228:	0f bd e8             	bsr    %eax,%ebp
  80422b:	83 f5 1f             	xor    $0x1f,%ebp
  80422e:	0f 84 ac 00 00 00    	je     8042e0 <__umoddi3+0x108>
  804234:	bf 20 00 00 00       	mov    $0x20,%edi
  804239:	29 ef                	sub    %ebp,%edi
  80423b:	89 fe                	mov    %edi,%esi
  80423d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804241:	89 e9                	mov    %ebp,%ecx
  804243:	d3 e0                	shl    %cl,%eax
  804245:	89 d7                	mov    %edx,%edi
  804247:	89 f1                	mov    %esi,%ecx
  804249:	d3 ef                	shr    %cl,%edi
  80424b:	09 c7                	or     %eax,%edi
  80424d:	89 e9                	mov    %ebp,%ecx
  80424f:	d3 e2                	shl    %cl,%edx
  804251:	89 14 24             	mov    %edx,(%esp)
  804254:	89 d8                	mov    %ebx,%eax
  804256:	d3 e0                	shl    %cl,%eax
  804258:	89 c2                	mov    %eax,%edx
  80425a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80425e:	d3 e0                	shl    %cl,%eax
  804260:	89 44 24 04          	mov    %eax,0x4(%esp)
  804264:	8b 44 24 08          	mov    0x8(%esp),%eax
  804268:	89 f1                	mov    %esi,%ecx
  80426a:	d3 e8                	shr    %cl,%eax
  80426c:	09 d0                	or     %edx,%eax
  80426e:	d3 eb                	shr    %cl,%ebx
  804270:	89 da                	mov    %ebx,%edx
  804272:	f7 f7                	div    %edi
  804274:	89 d3                	mov    %edx,%ebx
  804276:	f7 24 24             	mull   (%esp)
  804279:	89 c6                	mov    %eax,%esi
  80427b:	89 d1                	mov    %edx,%ecx
  80427d:	39 d3                	cmp    %edx,%ebx
  80427f:	0f 82 87 00 00 00    	jb     80430c <__umoddi3+0x134>
  804285:	0f 84 91 00 00 00    	je     80431c <__umoddi3+0x144>
  80428b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80428f:	29 f2                	sub    %esi,%edx
  804291:	19 cb                	sbb    %ecx,%ebx
  804293:	89 d8                	mov    %ebx,%eax
  804295:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804299:	d3 e0                	shl    %cl,%eax
  80429b:	89 e9                	mov    %ebp,%ecx
  80429d:	d3 ea                	shr    %cl,%edx
  80429f:	09 d0                	or     %edx,%eax
  8042a1:	89 e9                	mov    %ebp,%ecx
  8042a3:	d3 eb                	shr    %cl,%ebx
  8042a5:	89 da                	mov    %ebx,%edx
  8042a7:	83 c4 1c             	add    $0x1c,%esp
  8042aa:	5b                   	pop    %ebx
  8042ab:	5e                   	pop    %esi
  8042ac:	5f                   	pop    %edi
  8042ad:	5d                   	pop    %ebp
  8042ae:	c3                   	ret    
  8042af:	90                   	nop
  8042b0:	89 fd                	mov    %edi,%ebp
  8042b2:	85 ff                	test   %edi,%edi
  8042b4:	75 0b                	jne    8042c1 <__umoddi3+0xe9>
  8042b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8042bb:	31 d2                	xor    %edx,%edx
  8042bd:	f7 f7                	div    %edi
  8042bf:	89 c5                	mov    %eax,%ebp
  8042c1:	89 f0                	mov    %esi,%eax
  8042c3:	31 d2                	xor    %edx,%edx
  8042c5:	f7 f5                	div    %ebp
  8042c7:	89 c8                	mov    %ecx,%eax
  8042c9:	f7 f5                	div    %ebp
  8042cb:	89 d0                	mov    %edx,%eax
  8042cd:	e9 44 ff ff ff       	jmp    804216 <__umoddi3+0x3e>
  8042d2:	66 90                	xchg   %ax,%ax
  8042d4:	89 c8                	mov    %ecx,%eax
  8042d6:	89 f2                	mov    %esi,%edx
  8042d8:	83 c4 1c             	add    $0x1c,%esp
  8042db:	5b                   	pop    %ebx
  8042dc:	5e                   	pop    %esi
  8042dd:	5f                   	pop    %edi
  8042de:	5d                   	pop    %ebp
  8042df:	c3                   	ret    
  8042e0:	3b 04 24             	cmp    (%esp),%eax
  8042e3:	72 06                	jb     8042eb <__umoddi3+0x113>
  8042e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042e9:	77 0f                	ja     8042fa <__umoddi3+0x122>
  8042eb:	89 f2                	mov    %esi,%edx
  8042ed:	29 f9                	sub    %edi,%ecx
  8042ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042f3:	89 14 24             	mov    %edx,(%esp)
  8042f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8042fe:	8b 14 24             	mov    (%esp),%edx
  804301:	83 c4 1c             	add    $0x1c,%esp
  804304:	5b                   	pop    %ebx
  804305:	5e                   	pop    %esi
  804306:	5f                   	pop    %edi
  804307:	5d                   	pop    %ebp
  804308:	c3                   	ret    
  804309:	8d 76 00             	lea    0x0(%esi),%esi
  80430c:	2b 04 24             	sub    (%esp),%eax
  80430f:	19 fa                	sbb    %edi,%edx
  804311:	89 d1                	mov    %edx,%ecx
  804313:	89 c6                	mov    %eax,%esi
  804315:	e9 71 ff ff ff       	jmp    80428b <__umoddi3+0xb3>
  80431a:	66 90                	xchg   %ax,%ax
  80431c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804320:	72 ea                	jb     80430c <__umoddi3+0x134>
  804322:	89 d9                	mov    %ebx,%ecx
  804324:	e9 62 ff ff ff       	jmp    80428b <__umoddi3+0xb3>
