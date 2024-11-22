
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
  800055:	68 60 42 80 00       	push   $0x804260
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
  8000a5:	68 90 42 80 00       	push   $0x804290
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
  8000d1:	e8 78 23 00 00       	call   80244e <sys_set_uheap_strategy>
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
  8000f6:	68 c9 42 80 00       	push   $0x8042c9
  8000fb:	6a 26                	push   $0x26
  8000fd:	68 e5 42 80 00       	push   $0x8042e5
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
  800123:	e8 73 1f 00 00       	call   80209b <sys_pf_calculate_allocated_pages>
  800128:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 20 1f 00 00       	call   802050 <sys_calculate_free_frames>
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
  80013d:	68 fc 42 80 00       	push   $0x8042fc
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
  8002ac:	68 54 43 80 00       	push   $0x804354
  8002b1:	6a 69                	push   $0x69
  8002b3:	68 e5 42 80 00       	push   $0x8042e5
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
  800328:	68 7c 43 80 00       	push   $0x80437c
  80032d:	e8 f4 09 00 00       	call   800d26 <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800335:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80033b:	83 e8 08             	sub    $0x8,%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	6a 01                	push   $0x1
  800343:	50                   	push   %eax
  800344:	e8 47 22 00 00       	call   802590 <alloc_block>
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
  800392:	68 a0 43 80 00       	push   $0x8043a0
  800397:	68 80 00 00 00       	push   $0x80
  80039c:	68 e5 42 80 00       	push   $0x8042e5
  8003a1:	e8 c3 06 00 00       	call   800a69 <_panic>
		}
	}

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 c8 43 80 00       	push   $0x8043c8
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
  800451:	68 10 44 80 00       	push   $0x804410
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
  80046e:	68 30 44 80 00       	push   $0x804430
  800473:	e8 ae 08 00 00       	call   800d26 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp

	uint32 testSizes[numOfFFTests] =
  80047b:	8d 85 2c ff ff ff    	lea    -0xd4(%ebp),%eax
  800481:	bb f4 47 80 00       	mov    $0x8047f4,%ebx
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
  8005a7:	68 8c 44 80 00       	push   $0x80448c
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
  80060a:	e8 4a 1f 00 00       	call   802559 <get_block_size>
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
  800627:	68 bc 44 80 00       	push   $0x8044bc
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
  800641:	68 88 45 80 00       	push   $0x804588
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
  800714:	68 d4 45 80 00       	push   $0x8045d4
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
  80074f:	68 00 46 80 00       	push   $0x804600
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
  800808:	68 34 46 80 00       	push   $0x804634
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
  800831:	68 98 46 80 00       	push   $0x804698
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
  8008a8:	68 b8 46 80 00       	push   $0x8046b8
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
  8008f7:	68 28 47 80 00       	push   $0x804728
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
  800914:	68 ac 47 80 00       	push   $0x8047ac
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
  800930:	e8 e4 18 00 00       	call   802219 <sys_getenvindex>
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
  80099e:	e8 fa 15 00 00       	call   801f9d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8009a3:	83 ec 0c             	sub    $0xc,%esp
  8009a6:	68 18 48 80 00       	push   $0x804818
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
  8009ce:	68 40 48 80 00       	push   $0x804840
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
  8009ff:	68 68 48 80 00       	push   $0x804868
  800a04:	e8 1d 03 00 00       	call   800d26 <cprintf>
  800a09:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a0c:	a1 20 60 80 00       	mov    0x806020,%eax
  800a11:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	50                   	push   %eax
  800a1b:	68 c0 48 80 00       	push   $0x8048c0
  800a20:	e8 01 03 00 00       	call   800d26 <cprintf>
  800a25:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	68 18 48 80 00       	push   $0x804818
  800a30:	e8 f1 02 00 00       	call   800d26 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800a38:	e8 7a 15 00 00       	call   801fb7 <sys_unlock_cons>
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
  800a50:	e8 90 17 00 00       	call   8021e5 <sys_destroy_env>
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
  800a61:	e8 e5 17 00 00       	call   80224b <sys_exit_env>
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
  800a8a:	68 d4 48 80 00       	push   $0x8048d4
  800a8f:	e8 92 02 00 00       	call   800d26 <cprintf>
  800a94:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a97:	a1 1c 60 80 00       	mov    0x80601c,%eax
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	ff 75 08             	pushl  0x8(%ebp)
  800aa2:	50                   	push   %eax
  800aa3:	68 d9 48 80 00       	push   $0x8048d9
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
  800ac7:	68 f5 48 80 00       	push   $0x8048f5
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
  800af6:	68 f8 48 80 00       	push   $0x8048f8
  800afb:	6a 26                	push   $0x26
  800afd:	68 44 49 80 00       	push   $0x804944
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
  800bcb:	68 50 49 80 00       	push   $0x804950
  800bd0:	6a 3a                	push   $0x3a
  800bd2:	68 44 49 80 00       	push   $0x804944
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
  800c3e:	68 a4 49 80 00       	push   $0x8049a4
  800c43:	6a 44                	push   $0x44
  800c45:	68 44 49 80 00       	push   $0x804944
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
  800c98:	e8 be 12 00 00       	call   801f5b <sys_cputs>
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
  800d0f:	e8 47 12 00 00       	call   801f5b <sys_cputs>
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
  800d59:	e8 3f 12 00 00       	call   801f9d <sys_lock_cons>
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
  800d79:	e8 39 12 00 00       	call   801fb7 <sys_unlock_cons>
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
  800dc3:	e8 2c 32 00 00       	call   803ff4 <__udivdi3>
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
  800e13:	e8 ec 32 00 00       	call   804104 <__umoddi3>
  800e18:	83 c4 10             	add    $0x10,%esp
  800e1b:	05 14 4c 80 00       	add    $0x804c14,%eax
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
  800f6e:	8b 04 85 38 4c 80 00 	mov    0x804c38(,%eax,4),%eax
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
  80104f:	8b 34 9d 80 4a 80 00 	mov    0x804a80(,%ebx,4),%esi
  801056:	85 f6                	test   %esi,%esi
  801058:	75 19                	jne    801073 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80105a:	53                   	push   %ebx
  80105b:	68 25 4c 80 00       	push   $0x804c25
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
  801074:	68 2e 4c 80 00       	push   $0x804c2e
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
  8010a1:	be 31 4c 80 00       	mov    $0x804c31,%esi
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
  801aac:	68 a8 4d 80 00       	push   $0x804da8
  801ab1:	68 3f 01 00 00       	push   $0x13f
  801ab6:	68 ca 4d 80 00       	push   $0x804dca
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
  801acc:	e8 35 0a 00 00       	call   802506 <sys_sbrk>
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
  801b47:	e8 3e 08 00 00       	call   80238a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	74 16                	je     801b66 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	e8 7e 0d 00 00       	call   8028d9 <alloc_block_FF>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b61:	e9 8a 01 00 00       	jmp    801cf0 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b66:	e8 50 08 00 00       	call   8023bb <sys_isUHeapPlacementStrategyBESTFIT>
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	0f 84 7d 01 00 00    	je     801cf0 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	e8 17 12 00 00       	call   802d95 <alloc_block_BF>
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
  801bc9:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
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
  801c16:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
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
  801c6d:	c7 04 85 60 a2 80 00 	movl   $0x1,0x80a260(,%eax,4)
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
  801ccf:	89 04 95 60 a2 88 00 	mov    %eax,0x88a260(,%edx,4)
		sys_allocate_user_mem(i, size);
  801cd6:	83 ec 08             	sub    $0x8,%esp
  801cd9:	ff 75 08             	pushl  0x8(%ebp)
  801cdc:	ff 75 f0             	pushl  -0x10(%ebp)
  801cdf:	e8 59 08 00 00       	call   80253d <sys_allocate_user_mem>
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
  801d27:	e8 2d 08 00 00       	call   802559 <get_block_size>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 60 1a 00 00       	call   80379d <free_block>
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
  801d72:	8b 04 85 60 a2 88 00 	mov    0x88a260(,%eax,4),%eax
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
  801daf:	c7 04 85 60 a2 80 00 	movl   $0x0,0x80a260(,%eax,4)
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
  801dcf:	e8 4d 07 00 00       	call   802521 <sys_free_user_mem>
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
  801ddd:	68 d8 4d 80 00       	push   $0x804dd8
  801de2:	68 84 00 00 00       	push   $0x84
  801de7:	68 02 4e 80 00       	push   $0x804e02
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
  801e03:	75 07                	jne    801e0c <smalloc+0x19>
  801e05:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0a:	eb 74                	jmp    801e80 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e12:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1f:	39 d0                	cmp    %edx,%eax
  801e21:	73 02                	jae    801e25 <smalloc+0x32>
  801e23:	89 d0                	mov    %edx,%eax
  801e25:	83 ec 0c             	sub    $0xc,%esp
  801e28:	50                   	push   %eax
  801e29:	e8 a8 fc ff ff       	call   801ad6 <malloc>
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e38:	75 07                	jne    801e41 <smalloc+0x4e>
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3f:	eb 3f                	jmp    801e80 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e41:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e45:	ff 75 ec             	pushl  -0x14(%ebp)
  801e48:	50                   	push   %eax
  801e49:	ff 75 0c             	pushl  0xc(%ebp)
  801e4c:	ff 75 08             	pushl  0x8(%ebp)
  801e4f:	e8 d4 02 00 00       	call   802128 <sys_createSharedObject>
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e5a:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e5e:	74 06                	je     801e66 <smalloc+0x73>
  801e60:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e64:	75 07                	jne    801e6d <smalloc+0x7a>
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6b:	eb 13                	jmp    801e80 <smalloc+0x8d>
	 cprintf("153\n");
  801e6d:	83 ec 0c             	sub    $0xc,%esp
  801e70:	68 0e 4e 80 00       	push   $0x804e0e
  801e75:	e8 ac ee ff ff       	call   800d26 <cprintf>
  801e7a:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e88:	83 ec 04             	sub    $0x4,%esp
  801e8b:	68 14 4e 80 00       	push   $0x804e14
  801e90:	68 a4 00 00 00       	push   $0xa4
  801e95:	68 02 4e 80 00       	push   $0x804e02
  801e9a:	e8 ca eb ff ff       	call   800a69 <_panic>

00801e9f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	68 38 4e 80 00       	push   $0x804e38
  801ead:	68 bc 00 00 00       	push   $0xbc
  801eb2:	68 02 4e 80 00       	push   $0x804e02
  801eb7:	e8 ad eb ff ff       	call   800a69 <_panic>

00801ebc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ec2:	83 ec 04             	sub    $0x4,%esp
  801ec5:	68 5c 4e 80 00       	push   $0x804e5c
  801eca:	68 d3 00 00 00       	push   $0xd3
  801ecf:	68 02 4e 80 00       	push   $0x804e02
  801ed4:	e8 90 eb ff ff       	call   800a69 <_panic>

00801ed9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	68 82 4e 80 00       	push   $0x804e82
  801ee7:	68 df 00 00 00       	push   $0xdf
  801eec:	68 02 4e 80 00       	push   $0x804e02
  801ef1:	e8 73 eb ff ff       	call   800a69 <_panic>

00801ef6 <shrink>:

}
void shrink(uint32 newSize)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801efc:	83 ec 04             	sub    $0x4,%esp
  801eff:	68 82 4e 80 00       	push   $0x804e82
  801f04:	68 e4 00 00 00       	push   $0xe4
  801f09:	68 02 4e 80 00       	push   $0x804e02
  801f0e:	e8 56 eb ff ff       	call   800a69 <_panic>

00801f13 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f19:	83 ec 04             	sub    $0x4,%esp
  801f1c:	68 82 4e 80 00       	push   $0x804e82
  801f21:	68 e9 00 00 00       	push   $0xe9
  801f26:	68 02 4e 80 00       	push   $0x804e02
  801f2b:	e8 39 eb ff ff       	call   800a69 <_panic>

00801f30 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	57                   	push   %edi
  801f34:	56                   	push   %esi
  801f35:	53                   	push   %ebx
  801f36:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f42:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f45:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f48:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f4b:	cd 30                	int    $0x30
  801f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5e                   	pop    %esi
  801f58:	5f                   	pop    %edi
  801f59:	5d                   	pop    %ebp
  801f5a:	c3                   	ret    

00801f5b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 04             	sub    $0x4,%esp
  801f61:	8b 45 10             	mov    0x10(%ebp),%eax
  801f64:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f67:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	52                   	push   %edx
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	50                   	push   %eax
  801f77:	6a 00                	push   $0x0
  801f79:	e8 b2 ff ff ff       	call   801f30 <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
}
  801f81:	90                   	nop
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 02                	push   $0x2
  801f93:	e8 98 ff ff ff       	call   801f30 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 03                	push   $0x3
  801fac:	e8 7f ff ff ff       	call   801f30 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	90                   	nop
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 04                	push   $0x4
  801fc6:	e8 65 ff ff ff       	call   801f30 <syscall>
  801fcb:	83 c4 18             	add    $0x18,%esp
}
  801fce:	90                   	nop
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	52                   	push   %edx
  801fe1:	50                   	push   %eax
  801fe2:	6a 08                	push   $0x8
  801fe4:	e8 47 ff ff ff       	call   801f30 <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	56                   	push   %esi
  801ff2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ff3:	8b 75 18             	mov    0x18(%ebp),%esi
  801ff6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ff9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	56                   	push   %esi
  802003:	53                   	push   %ebx
  802004:	51                   	push   %ecx
  802005:	52                   	push   %edx
  802006:	50                   	push   %eax
  802007:	6a 09                	push   $0x9
  802009:	e8 22 ff ff ff       	call   801f30 <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
}
  802011:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802014:	5b                   	pop    %ebx
  802015:	5e                   	pop    %esi
  802016:	5d                   	pop    %ebp
  802017:	c3                   	ret    

00802018 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80201b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	52                   	push   %edx
  802028:	50                   	push   %eax
  802029:	6a 0a                	push   $0xa
  80202b:	e8 00 ff ff ff       	call   801f30 <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	ff 75 0c             	pushl  0xc(%ebp)
  802041:	ff 75 08             	pushl  0x8(%ebp)
  802044:	6a 0b                	push   $0xb
  802046:	e8 e5 fe ff ff       	call   801f30 <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 0c                	push   $0xc
  80205f:	e8 cc fe ff ff       	call   801f30 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 0d                	push   $0xd
  802078:	e8 b3 fe ff ff       	call   801f30 <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 0e                	push   $0xe
  802091:	e8 9a fe ff ff       	call   801f30 <syscall>
  802096:	83 c4 18             	add    $0x18,%esp
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 0f                	push   $0xf
  8020aa:	e8 81 fe ff ff       	call   801f30 <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	ff 75 08             	pushl  0x8(%ebp)
  8020c2:	6a 10                	push   $0x10
  8020c4:	e8 67 fe ff ff       	call   801f30 <syscall>
  8020c9:	83 c4 18             	add    $0x18,%esp
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 11                	push   $0x11
  8020dd:	e8 4e fe ff ff       	call   801f30 <syscall>
  8020e2:	83 c4 18             	add    $0x18,%esp
}
  8020e5:	90                   	nop
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 04             	sub    $0x4,%esp
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020f4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	50                   	push   %eax
  802101:	6a 01                	push   $0x1
  802103:	e8 28 fe ff ff       	call   801f30 <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	90                   	nop
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 14                	push   $0x14
  80211d:	e8 0e fe ff ff       	call   801f30 <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	90                   	nop
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 04             	sub    $0x4,%esp
  80212e:	8b 45 10             	mov    0x10(%ebp),%eax
  802131:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802134:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802137:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	6a 00                	push   $0x0
  802140:	51                   	push   %ecx
  802141:	52                   	push   %edx
  802142:	ff 75 0c             	pushl  0xc(%ebp)
  802145:	50                   	push   %eax
  802146:	6a 15                	push   $0x15
  802148:	e8 e3 fd ff ff       	call   801f30 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802155:	8b 55 0c             	mov    0xc(%ebp),%edx
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	52                   	push   %edx
  802162:	50                   	push   %eax
  802163:	6a 16                	push   $0x16
  802165:	e8 c6 fd ff ff       	call   801f30 <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802172:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802175:	8b 55 0c             	mov    0xc(%ebp),%edx
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	51                   	push   %ecx
  802180:	52                   	push   %edx
  802181:	50                   	push   %eax
  802182:	6a 17                	push   $0x17
  802184:	e8 a7 fd ff ff       	call   801f30 <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802191:	8b 55 0c             	mov    0xc(%ebp),%edx
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	52                   	push   %edx
  80219e:	50                   	push   %eax
  80219f:	6a 18                	push   $0x18
  8021a1:	e8 8a fd ff ff       	call   801f30 <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	6a 00                	push   $0x0
  8021b3:	ff 75 14             	pushl  0x14(%ebp)
  8021b6:	ff 75 10             	pushl  0x10(%ebp)
  8021b9:	ff 75 0c             	pushl  0xc(%ebp)
  8021bc:	50                   	push   %eax
  8021bd:	6a 19                	push   $0x19
  8021bf:	e8 6c fd ff ff       	call   801f30 <syscall>
  8021c4:	83 c4 18             	add    $0x18,%esp
}
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	50                   	push   %eax
  8021d8:	6a 1a                	push   $0x1a
  8021da:	e8 51 fd ff ff       	call   801f30 <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
}
  8021e2:	90                   	nop
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	50                   	push   %eax
  8021f4:	6a 1b                	push   $0x1b
  8021f6:	e8 35 fd ff ff       	call   801f30 <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 05                	push   $0x5
  80220f:	e8 1c fd ff ff       	call   801f30 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 06                	push   $0x6
  802228:	e8 03 fd ff ff       	call   801f30 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 07                	push   $0x7
  802241:	e8 ea fc ff ff       	call   801f30 <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_exit_env>:


void sys_exit_env(void)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 1c                	push   $0x1c
  80225a:	e8 d1 fc ff ff       	call   801f30 <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	90                   	nop
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80226b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80226e:	8d 50 04             	lea    0x4(%eax),%edx
  802271:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	52                   	push   %edx
  80227b:	50                   	push   %eax
  80227c:	6a 1d                	push   $0x1d
  80227e:	e8 ad fc ff ff       	call   801f30 <syscall>
  802283:	83 c4 18             	add    $0x18,%esp
	return result;
  802286:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80228c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80228f:	89 01                	mov    %eax,(%ecx)
  802291:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	c9                   	leave  
  802298:	c2 04 00             	ret    $0x4

0080229b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	ff 75 10             	pushl  0x10(%ebp)
  8022a5:	ff 75 0c             	pushl  0xc(%ebp)
  8022a8:	ff 75 08             	pushl  0x8(%ebp)
  8022ab:	6a 13                	push   $0x13
  8022ad:	e8 7e fc ff ff       	call   801f30 <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b5:	90                   	nop
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 1e                	push   $0x1e
  8022c7:	e8 64 fc ff ff       	call   801f30 <syscall>
  8022cc:	83 c4 18             	add    $0x18,%esp
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022dd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	50                   	push   %eax
  8022ea:	6a 1f                	push   $0x1f
  8022ec:	e8 3f fc ff ff       	call   801f30 <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f4:	90                   	nop
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <rsttst>:
void rsttst()
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 21                	push   $0x21
  802306:	e8 25 fc ff ff       	call   801f30 <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
	return ;
  80230e:	90                   	nop
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	8b 45 14             	mov    0x14(%ebp),%eax
  80231a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80231d:	8b 55 18             	mov    0x18(%ebp),%edx
  802320:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802324:	52                   	push   %edx
  802325:	50                   	push   %eax
  802326:	ff 75 10             	pushl  0x10(%ebp)
  802329:	ff 75 0c             	pushl  0xc(%ebp)
  80232c:	ff 75 08             	pushl  0x8(%ebp)
  80232f:	6a 20                	push   $0x20
  802331:	e8 fa fb ff ff       	call   801f30 <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
	return ;
  802339:	90                   	nop
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <chktst>:
void chktst(uint32 n)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	ff 75 08             	pushl  0x8(%ebp)
  80234a:	6a 22                	push   $0x22
  80234c:	e8 df fb ff ff       	call   801f30 <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
	return ;
  802354:	90                   	nop
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <inctst>:

void inctst()
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 23                	push   $0x23
  802366:	e8 c5 fb ff ff       	call   801f30 <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
	return ;
  80236e:	90                   	nop
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <gettst>:
uint32 gettst()
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 24                	push   $0x24
  802380:	e8 ab fb ff ff       	call   801f30 <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 25                	push   $0x25
  80239c:	e8 8f fb ff ff       	call   801f30 <syscall>
  8023a1:	83 c4 18             	add    $0x18,%esp
  8023a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023a7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023ab:	75 07                	jne    8023b4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b2:	eb 05                	jmp    8023b9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 25                	push   $0x25
  8023cd:	e8 5e fb ff ff       	call   801f30 <syscall>
  8023d2:	83 c4 18             	add    $0x18,%esp
  8023d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023d8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023dc:	75 07                	jne    8023e5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	eb 05                	jmp    8023ea <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 25                	push   $0x25
  8023fe:	e8 2d fb ff ff       	call   801f30 <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
  802406:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802409:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80240d:	75 07                	jne    802416 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80240f:	b8 01 00 00 00       	mov    $0x1,%eax
  802414:	eb 05                	jmp    80241b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802416:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 25                	push   $0x25
  80242f:	e8 fc fa ff ff       	call   801f30 <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
  802437:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80243a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80243e:	75 07                	jne    802447 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802440:	b8 01 00 00 00       	mov    $0x1,%eax
  802445:	eb 05                	jmp    80244c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802447:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	ff 75 08             	pushl  0x8(%ebp)
  80245c:	6a 26                	push   $0x26
  80245e:	e8 cd fa ff ff       	call   801f30 <syscall>
  802463:	83 c4 18             	add    $0x18,%esp
	return ;
  802466:	90                   	nop
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    

00802469 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80246d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802470:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802473:	8b 55 0c             	mov    0xc(%ebp),%edx
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	6a 00                	push   $0x0
  80247b:	53                   	push   %ebx
  80247c:	51                   	push   %ecx
  80247d:	52                   	push   %edx
  80247e:	50                   	push   %eax
  80247f:	6a 27                	push   $0x27
  802481:	e8 aa fa ff ff       	call   801f30 <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802491:	8b 55 0c             	mov    0xc(%ebp),%edx
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	52                   	push   %edx
  80249e:	50                   	push   %eax
  80249f:	6a 28                	push   $0x28
  8024a1:	e8 8a fa ff ff       	call   801f30 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8024ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	6a 00                	push   $0x0
  8024b9:	51                   	push   %ecx
  8024ba:	ff 75 10             	pushl  0x10(%ebp)
  8024bd:	52                   	push   %edx
  8024be:	50                   	push   %eax
  8024bf:	6a 29                	push   $0x29
  8024c1:	e8 6a fa ff ff       	call   801f30 <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	ff 75 10             	pushl  0x10(%ebp)
  8024d5:	ff 75 0c             	pushl  0xc(%ebp)
  8024d8:	ff 75 08             	pushl  0x8(%ebp)
  8024db:	6a 12                	push   $0x12
  8024dd:	e8 4e fa ff ff       	call   801f30 <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e5:	90                   	nop
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8024eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	52                   	push   %edx
  8024f8:	50                   	push   %eax
  8024f9:	6a 2a                	push   $0x2a
  8024fb:	e8 30 fa ff ff       	call   801f30 <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
	return;
  802503:	90                   	nop
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	50                   	push   %eax
  802515:	6a 2b                	push   $0x2b
  802517:	e8 14 fa ff ff       	call   801f30 <syscall>
  80251c:	83 c4 18             	add    $0x18,%esp
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	ff 75 0c             	pushl  0xc(%ebp)
  80252d:	ff 75 08             	pushl  0x8(%ebp)
  802530:	6a 2c                	push   $0x2c
  802532:	e8 f9 f9 ff ff       	call   801f30 <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
	return;
  80253a:	90                   	nop
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	ff 75 0c             	pushl  0xc(%ebp)
  802549:	ff 75 08             	pushl  0x8(%ebp)
  80254c:	6a 2d                	push   $0x2d
  80254e:	e8 dd f9 ff ff       	call   801f30 <syscall>
  802553:	83 c4 18             	add    $0x18,%esp
	return;
  802556:	90                   	nop
}
  802557:	c9                   	leave  
  802558:	c3                   	ret    

00802559 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
  80255c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	83 e8 04             	sub    $0x4,%eax
  802565:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802568:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	83 e8 04             	sub    $0x4,%eax
  80257e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802581:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	83 e0 01             	and    $0x1,%eax
  802589:	85 c0                	test   %eax,%eax
  80258b:	0f 94 c0             	sete   %al
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802596:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80259d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a0:	83 f8 02             	cmp    $0x2,%eax
  8025a3:	74 2b                	je     8025d0 <alloc_block+0x40>
  8025a5:	83 f8 02             	cmp    $0x2,%eax
  8025a8:	7f 07                	jg     8025b1 <alloc_block+0x21>
  8025aa:	83 f8 01             	cmp    $0x1,%eax
  8025ad:	74 0e                	je     8025bd <alloc_block+0x2d>
  8025af:	eb 58                	jmp    802609 <alloc_block+0x79>
  8025b1:	83 f8 03             	cmp    $0x3,%eax
  8025b4:	74 2d                	je     8025e3 <alloc_block+0x53>
  8025b6:	83 f8 04             	cmp    $0x4,%eax
  8025b9:	74 3b                	je     8025f6 <alloc_block+0x66>
  8025bb:	eb 4c                	jmp    802609 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8025bd:	83 ec 0c             	sub    $0xc,%esp
  8025c0:	ff 75 08             	pushl  0x8(%ebp)
  8025c3:	e8 11 03 00 00       	call   8028d9 <alloc_block_FF>
  8025c8:	83 c4 10             	add    $0x10,%esp
  8025cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025ce:	eb 4a                	jmp    80261a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8025d0:	83 ec 0c             	sub    $0xc,%esp
  8025d3:	ff 75 08             	pushl  0x8(%ebp)
  8025d6:	e8 fa 19 00 00       	call   803fd5 <alloc_block_NF>
  8025db:	83 c4 10             	add    $0x10,%esp
  8025de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025e1:	eb 37                	jmp    80261a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	ff 75 08             	pushl  0x8(%ebp)
  8025e9:	e8 a7 07 00 00       	call   802d95 <alloc_block_BF>
  8025ee:	83 c4 10             	add    $0x10,%esp
  8025f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025f4:	eb 24                	jmp    80261a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8025f6:	83 ec 0c             	sub    $0xc,%esp
  8025f9:	ff 75 08             	pushl  0x8(%ebp)
  8025fc:	e8 b7 19 00 00       	call   803fb8 <alloc_block_WF>
  802601:	83 c4 10             	add    $0x10,%esp
  802604:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802607:	eb 11                	jmp    80261a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802609:	83 ec 0c             	sub    $0xc,%esp
  80260c:	68 94 4e 80 00       	push   $0x804e94
  802611:	e8 10 e7 ff ff       	call   800d26 <cprintf>
  802616:	83 c4 10             	add    $0x10,%esp
		break;
  802619:	90                   	nop
	}
	return va;
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
  802622:	53                   	push   %ebx
  802623:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802626:	83 ec 0c             	sub    $0xc,%esp
  802629:	68 b4 4e 80 00       	push   $0x804eb4
  80262e:	e8 f3 e6 ff ff       	call   800d26 <cprintf>
  802633:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802636:	83 ec 0c             	sub    $0xc,%esp
  802639:	68 df 4e 80 00       	push   $0x804edf
  80263e:	e8 e3 e6 ff ff       	call   800d26 <cprintf>
  802643:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264c:	eb 37                	jmp    802685 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80264e:	83 ec 0c             	sub    $0xc,%esp
  802651:	ff 75 f4             	pushl  -0xc(%ebp)
  802654:	e8 19 ff ff ff       	call   802572 <is_free_block>
  802659:	83 c4 10             	add    $0x10,%esp
  80265c:	0f be d8             	movsbl %al,%ebx
  80265f:	83 ec 0c             	sub    $0xc,%esp
  802662:	ff 75 f4             	pushl  -0xc(%ebp)
  802665:	e8 ef fe ff ff       	call   802559 <get_block_size>
  80266a:	83 c4 10             	add    $0x10,%esp
  80266d:	83 ec 04             	sub    $0x4,%esp
  802670:	53                   	push   %ebx
  802671:	50                   	push   %eax
  802672:	68 f7 4e 80 00       	push   $0x804ef7
  802677:	e8 aa e6 ff ff       	call   800d26 <cprintf>
  80267c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80267f:	8b 45 10             	mov    0x10(%ebp),%eax
  802682:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802689:	74 07                	je     802692 <print_blocks_list+0x73>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	eb 05                	jmp    802697 <print_blocks_list+0x78>
  802692:	b8 00 00 00 00       	mov    $0x0,%eax
  802697:	89 45 10             	mov    %eax,0x10(%ebp)
  80269a:	8b 45 10             	mov    0x10(%ebp),%eax
  80269d:	85 c0                	test   %eax,%eax
  80269f:	75 ad                	jne    80264e <print_blocks_list+0x2f>
  8026a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a5:	75 a7                	jne    80264e <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8026a7:	83 ec 0c             	sub    $0xc,%esp
  8026aa:	68 b4 4e 80 00       	push   $0x804eb4
  8026af:	e8 72 e6 ff ff       	call   800d26 <cprintf>
  8026b4:	83 c4 10             	add    $0x10,%esp

}
  8026b7:	90                   	nop
  8026b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
  8026c0:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8026c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c6:	83 e0 01             	and    $0x1,%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	74 03                	je     8026d0 <initialize_dynamic_allocator+0x13>
  8026cd:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8026d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026d4:	0f 84 c7 01 00 00    	je     8028a1 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8026da:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8026e1:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8026e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ea:	01 d0                	add    %edx,%eax
  8026ec:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8026f1:	0f 87 ad 01 00 00    	ja     8028a4 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	0f 89 a5 01 00 00    	jns    8028a7 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802702:	8b 55 08             	mov    0x8(%ebp),%edx
  802705:	8b 45 0c             	mov    0xc(%ebp),%eax
  802708:	01 d0                	add    %edx,%eax
  80270a:	83 e8 04             	sub    $0x4,%eax
  80270d:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  802712:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802719:	a1 44 60 80 00       	mov    0x806044,%eax
  80271e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802721:	e9 87 00 00 00       	jmp    8027ad <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802726:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272a:	75 14                	jne    802740 <initialize_dynamic_allocator+0x83>
  80272c:	83 ec 04             	sub    $0x4,%esp
  80272f:	68 0f 4f 80 00       	push   $0x804f0f
  802734:	6a 79                	push   $0x79
  802736:	68 2d 4f 80 00       	push   $0x804f2d
  80273b:	e8 29 e3 ff ff       	call   800a69 <_panic>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	85 c0                	test   %eax,%eax
  802747:	74 10                	je     802759 <initialize_dynamic_allocator+0x9c>
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802751:	8b 52 04             	mov    0x4(%edx),%edx
  802754:	89 50 04             	mov    %edx,0x4(%eax)
  802757:	eb 0b                	jmp    802764 <initialize_dynamic_allocator+0xa7>
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 40 04             	mov    0x4(%eax),%eax
  80275f:	a3 48 60 80 00       	mov    %eax,0x806048
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 40 04             	mov    0x4(%eax),%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	74 0f                	je     80277d <initialize_dynamic_allocator+0xc0>
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 40 04             	mov    0x4(%eax),%eax
  802774:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802777:	8b 12                	mov    (%edx),%edx
  802779:	89 10                	mov    %edx,(%eax)
  80277b:	eb 0a                	jmp    802787 <initialize_dynamic_allocator+0xca>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	a3 44 60 80 00       	mov    %eax,0x806044
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279a:	a1 50 60 80 00       	mov    0x806050,%eax
  80279f:	48                   	dec    %eax
  8027a0:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8027a5:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8027aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b1:	74 07                	je     8027ba <initialize_dynamic_allocator+0xfd>
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 00                	mov    (%eax),%eax
  8027b8:	eb 05                	jmp    8027bf <initialize_dynamic_allocator+0x102>
  8027ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bf:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8027c4:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	0f 85 55 ff ff ff    	jne    802726 <initialize_dynamic_allocator+0x69>
  8027d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d5:	0f 85 4b ff ff ff    	jne    802726 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8027db:	8b 45 08             	mov    0x8(%ebp),%eax
  8027de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8027e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8027ea:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  8027ef:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  8027f4:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8027f9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8027ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802802:	83 c0 08             	add    $0x8,%eax
  802805:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	83 c0 04             	add    $0x4,%eax
  80280e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802811:	83 ea 08             	sub    $0x8,%edx
  802814:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802816:	8b 55 0c             	mov    0xc(%ebp),%edx
  802819:	8b 45 08             	mov    0x8(%ebp),%eax
  80281c:	01 d0                	add    %edx,%eax
  80281e:	83 e8 08             	sub    $0x8,%eax
  802821:	8b 55 0c             	mov    0xc(%ebp),%edx
  802824:	83 ea 08             	sub    $0x8,%edx
  802827:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802829:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802832:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802835:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80283c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802840:	75 17                	jne    802859 <initialize_dynamic_allocator+0x19c>
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	68 48 4f 80 00       	push   $0x804f48
  80284a:	68 90 00 00 00       	push   $0x90
  80284f:	68 2d 4f 80 00       	push   $0x804f2d
  802854:	e8 10 e2 ff ff       	call   800a69 <_panic>
  802859:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80285f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802862:	89 10                	mov    %edx,(%eax)
  802864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 0d                	je     80287a <initialize_dynamic_allocator+0x1bd>
  80286d:	a1 44 60 80 00       	mov    0x806044,%eax
  802872:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802875:	89 50 04             	mov    %edx,0x4(%eax)
  802878:	eb 08                	jmp    802882 <initialize_dynamic_allocator+0x1c5>
  80287a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287d:	a3 48 60 80 00       	mov    %eax,0x806048
  802882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802885:	a3 44 60 80 00       	mov    %eax,0x806044
  80288a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802894:	a1 50 60 80 00       	mov    0x806050,%eax
  802899:	40                   	inc    %eax
  80289a:	a3 50 60 80 00       	mov    %eax,0x806050
  80289f:	eb 07                	jmp    8028a8 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8028a1:	90                   	nop
  8028a2:	eb 04                	jmp    8028a8 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8028a4:	90                   	nop
  8028a5:	eb 01                	jmp    8028a8 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8028a7:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    

008028aa <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8028aa:	55                   	push   %ebp
  8028ab:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8028ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8028b0:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028bc:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8028be:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c1:	83 e8 04             	sub    $0x4,%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	83 e0 fe             	and    $0xfffffffe,%eax
  8028c9:	8d 50 f8             	lea    -0x8(%eax),%edx
  8028cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cf:	01 c2                	add    %eax,%edx
  8028d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028d4:	89 02                	mov    %eax,(%edx)
}
  8028d6:	90                   	nop
  8028d7:	5d                   	pop    %ebp
  8028d8:	c3                   	ret    

008028d9 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
  8028dc:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	83 e0 01             	and    $0x1,%eax
  8028e5:	85 c0                	test   %eax,%eax
  8028e7:	74 03                	je     8028ec <alloc_block_FF+0x13>
  8028e9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028ec:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028f0:	77 07                	ja     8028f9 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028f2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028f9:	a1 24 60 80 00       	mov    0x806024,%eax
  8028fe:	85 c0                	test   %eax,%eax
  802900:	75 73                	jne    802975 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	83 c0 10             	add    $0x10,%eax
  802908:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80290b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802912:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802918:	01 d0                	add    %edx,%eax
  80291a:	48                   	dec    %eax
  80291b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80291e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802921:	ba 00 00 00 00       	mov    $0x0,%edx
  802926:	f7 75 ec             	divl   -0x14(%ebp)
  802929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292c:	29 d0                	sub    %edx,%eax
  80292e:	c1 e8 0c             	shr    $0xc,%eax
  802931:	83 ec 0c             	sub    $0xc,%esp
  802934:	50                   	push   %eax
  802935:	e8 86 f1 ff ff       	call   801ac0 <sbrk>
  80293a:	83 c4 10             	add    $0x10,%esp
  80293d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802940:	83 ec 0c             	sub    $0xc,%esp
  802943:	6a 00                	push   $0x0
  802945:	e8 76 f1 ff ff       	call   801ac0 <sbrk>
  80294a:	83 c4 10             	add    $0x10,%esp
  80294d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802950:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802953:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802956:	83 ec 08             	sub    $0x8,%esp
  802959:	50                   	push   %eax
  80295a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80295d:	e8 5b fd ff ff       	call   8026bd <initialize_dynamic_allocator>
  802962:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802965:	83 ec 0c             	sub    $0xc,%esp
  802968:	68 6b 4f 80 00       	push   $0x804f6b
  80296d:	e8 b4 e3 ff ff       	call   800d26 <cprintf>
  802972:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802975:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802979:	75 0a                	jne    802985 <alloc_block_FF+0xac>
	        return NULL;
  80297b:	b8 00 00 00 00       	mov    $0x0,%eax
  802980:	e9 0e 04 00 00       	jmp    802d93 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802985:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80298c:	a1 44 60 80 00       	mov    0x806044,%eax
  802991:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802994:	e9 f3 02 00 00       	jmp    802c8c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80299f:	83 ec 0c             	sub    $0xc,%esp
  8029a2:	ff 75 bc             	pushl  -0x44(%ebp)
  8029a5:	e8 af fb ff ff       	call   802559 <get_block_size>
  8029aa:	83 c4 10             	add    $0x10,%esp
  8029ad:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	83 c0 08             	add    $0x8,%eax
  8029b6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029b9:	0f 87 c5 02 00 00    	ja     802c84 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c2:	83 c0 18             	add    $0x18,%eax
  8029c5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029c8:	0f 87 19 02 00 00    	ja     802be7 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8029ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029d1:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d4:	83 e8 08             	sub    $0x8,%eax
  8029d7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	8d 50 08             	lea    0x8(%eax),%edx
  8029e0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029e3:	01 d0                	add    %edx,%eax
  8029e5:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	83 c0 08             	add    $0x8,%eax
  8029ee:	83 ec 04             	sub    $0x4,%esp
  8029f1:	6a 01                	push   $0x1
  8029f3:	50                   	push   %eax
  8029f4:	ff 75 bc             	pushl  -0x44(%ebp)
  8029f7:	e8 ae fe ff ff       	call   8028aa <set_block_data>
  8029fc:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 40 04             	mov    0x4(%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	75 68                	jne    802a71 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a09:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a0d:	75 17                	jne    802a26 <alloc_block_FF+0x14d>
  802a0f:	83 ec 04             	sub    $0x4,%esp
  802a12:	68 48 4f 80 00       	push   $0x804f48
  802a17:	68 d7 00 00 00       	push   $0xd7
  802a1c:	68 2d 4f 80 00       	push   $0x804f2d
  802a21:	e8 43 e0 ff ff       	call   800a69 <_panic>
  802a26:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802a2c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a2f:	89 10                	mov    %edx,(%eax)
  802a31:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a34:	8b 00                	mov    (%eax),%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 0d                	je     802a47 <alloc_block_FF+0x16e>
  802a3a:	a1 44 60 80 00       	mov    0x806044,%eax
  802a3f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a42:	89 50 04             	mov    %edx,0x4(%eax)
  802a45:	eb 08                	jmp    802a4f <alloc_block_FF+0x176>
  802a47:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a4a:	a3 48 60 80 00       	mov    %eax,0x806048
  802a4f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a52:	a3 44 60 80 00       	mov    %eax,0x806044
  802a57:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a61:	a1 50 60 80 00       	mov    0x806050,%eax
  802a66:	40                   	inc    %eax
  802a67:	a3 50 60 80 00       	mov    %eax,0x806050
  802a6c:	e9 dc 00 00 00       	jmp    802b4d <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 00                	mov    (%eax),%eax
  802a76:	85 c0                	test   %eax,%eax
  802a78:	75 65                	jne    802adf <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a7a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a7e:	75 17                	jne    802a97 <alloc_block_FF+0x1be>
  802a80:	83 ec 04             	sub    $0x4,%esp
  802a83:	68 7c 4f 80 00       	push   $0x804f7c
  802a88:	68 db 00 00 00       	push   $0xdb
  802a8d:	68 2d 4f 80 00       	push   $0x804f2d
  802a92:	e8 d2 df ff ff       	call   800a69 <_panic>
  802a97:	8b 15 48 60 80 00    	mov    0x806048,%edx
  802a9d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aa0:	89 50 04             	mov    %edx,0x4(%eax)
  802aa3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aa6:	8b 40 04             	mov    0x4(%eax),%eax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	74 0c                	je     802ab9 <alloc_block_FF+0x1e0>
  802aad:	a1 48 60 80 00       	mov    0x806048,%eax
  802ab2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ab5:	89 10                	mov    %edx,(%eax)
  802ab7:	eb 08                	jmp    802ac1 <alloc_block_FF+0x1e8>
  802ab9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802abc:	a3 44 60 80 00       	mov    %eax,0x806044
  802ac1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac4:	a3 48 60 80 00       	mov    %eax,0x806048
  802ac9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802acc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad2:	a1 50 60 80 00       	mov    0x806050,%eax
  802ad7:	40                   	inc    %eax
  802ad8:	a3 50 60 80 00       	mov    %eax,0x806050
  802add:	eb 6e                	jmp    802b4d <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802adf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae3:	74 06                	je     802aeb <alloc_block_FF+0x212>
  802ae5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ae9:	75 17                	jne    802b02 <alloc_block_FF+0x229>
  802aeb:	83 ec 04             	sub    $0x4,%esp
  802aee:	68 a0 4f 80 00       	push   $0x804fa0
  802af3:	68 df 00 00 00       	push   $0xdf
  802af8:	68 2d 4f 80 00       	push   $0x804f2d
  802afd:	e8 67 df ff ff       	call   800a69 <_panic>
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 10                	mov    (%eax),%edx
  802b07:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b0a:	89 10                	mov    %edx,(%eax)
  802b0c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	74 0b                	je     802b20 <alloc_block_FF+0x247>
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	8b 00                	mov    (%eax),%eax
  802b1a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b1d:	89 50 04             	mov    %edx,0x4(%eax)
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b26:	89 10                	mov    %edx,(%eax)
  802b28:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2e:	89 50 04             	mov    %edx,0x4(%eax)
  802b31:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	75 08                	jne    802b42 <alloc_block_FF+0x269>
  802b3a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b3d:	a3 48 60 80 00       	mov    %eax,0x806048
  802b42:	a1 50 60 80 00       	mov    0x806050,%eax
  802b47:	40                   	inc    %eax
  802b48:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802b4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b51:	75 17                	jne    802b6a <alloc_block_FF+0x291>
  802b53:	83 ec 04             	sub    $0x4,%esp
  802b56:	68 0f 4f 80 00       	push   $0x804f0f
  802b5b:	68 e1 00 00 00       	push   $0xe1
  802b60:	68 2d 4f 80 00       	push   $0x804f2d
  802b65:	e8 ff de ff ff       	call   800a69 <_panic>
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 00                	mov    (%eax),%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	74 10                	je     802b83 <alloc_block_FF+0x2aa>
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 00                	mov    (%eax),%eax
  802b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7b:	8b 52 04             	mov    0x4(%edx),%edx
  802b7e:	89 50 04             	mov    %edx,0x4(%eax)
  802b81:	eb 0b                	jmp    802b8e <alloc_block_FF+0x2b5>
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 40 04             	mov    0x4(%eax),%eax
  802b89:	a3 48 60 80 00       	mov    %eax,0x806048
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	8b 40 04             	mov    0x4(%eax),%eax
  802b94:	85 c0                	test   %eax,%eax
  802b96:	74 0f                	je     802ba7 <alloc_block_FF+0x2ce>
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 40 04             	mov    0x4(%eax),%eax
  802b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba1:	8b 12                	mov    (%edx),%edx
  802ba3:	89 10                	mov    %edx,(%eax)
  802ba5:	eb 0a                	jmp    802bb1 <alloc_block_FF+0x2d8>
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	a3 44 60 80 00       	mov    %eax,0x806044
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc4:	a1 50 60 80 00       	mov    0x806050,%eax
  802bc9:	48                   	dec    %eax
  802bca:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	6a 00                	push   $0x0
  802bd4:	ff 75 b4             	pushl  -0x4c(%ebp)
  802bd7:	ff 75 b0             	pushl  -0x50(%ebp)
  802bda:	e8 cb fc ff ff       	call   8028aa <set_block_data>
  802bdf:	83 c4 10             	add    $0x10,%esp
  802be2:	e9 95 00 00 00       	jmp    802c7c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802be7:	83 ec 04             	sub    $0x4,%esp
  802bea:	6a 01                	push   $0x1
  802bec:	ff 75 b8             	pushl  -0x48(%ebp)
  802bef:	ff 75 bc             	pushl  -0x44(%ebp)
  802bf2:	e8 b3 fc ff ff       	call   8028aa <set_block_data>
  802bf7:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802bfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfe:	75 17                	jne    802c17 <alloc_block_FF+0x33e>
  802c00:	83 ec 04             	sub    $0x4,%esp
  802c03:	68 0f 4f 80 00       	push   $0x804f0f
  802c08:	68 e8 00 00 00       	push   $0xe8
  802c0d:	68 2d 4f 80 00       	push   $0x804f2d
  802c12:	e8 52 de ff ff       	call   800a69 <_panic>
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 00                	mov    (%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	74 10                	je     802c30 <alloc_block_FF+0x357>
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 00                	mov    (%eax),%eax
  802c25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c28:	8b 52 04             	mov    0x4(%edx),%edx
  802c2b:	89 50 04             	mov    %edx,0x4(%eax)
  802c2e:	eb 0b                	jmp    802c3b <alloc_block_FF+0x362>
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 40 04             	mov    0x4(%eax),%eax
  802c36:	a3 48 60 80 00       	mov    %eax,0x806048
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 40 04             	mov    0x4(%eax),%eax
  802c41:	85 c0                	test   %eax,%eax
  802c43:	74 0f                	je     802c54 <alloc_block_FF+0x37b>
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 40 04             	mov    0x4(%eax),%eax
  802c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4e:	8b 12                	mov    (%edx),%edx
  802c50:	89 10                	mov    %edx,(%eax)
  802c52:	eb 0a                	jmp    802c5e <alloc_block_FF+0x385>
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	a3 44 60 80 00       	mov    %eax,0x806044
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c71:	a1 50 60 80 00       	mov    0x806050,%eax
  802c76:	48                   	dec    %eax
  802c77:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  802c7c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c7f:	e9 0f 01 00 00       	jmp    802d93 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c84:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c90:	74 07                	je     802c99 <alloc_block_FF+0x3c0>
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 00                	mov    (%eax),%eax
  802c97:	eb 05                	jmp    802c9e <alloc_block_FF+0x3c5>
  802c99:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9e:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802ca3:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	0f 85 e9 fc ff ff    	jne    802999 <alloc_block_FF+0xc0>
  802cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb4:	0f 85 df fc ff ff    	jne    802999 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	83 c0 08             	add    $0x8,%eax
  802cc0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cc3:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802cca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ccd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cd0:	01 d0                	add    %edx,%eax
  802cd2:	48                   	dec    %eax
  802cd3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802cd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cd9:	ba 00 00 00 00       	mov    $0x0,%edx
  802cde:	f7 75 d8             	divl   -0x28(%ebp)
  802ce1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ce4:	29 d0                	sub    %edx,%eax
  802ce6:	c1 e8 0c             	shr    $0xc,%eax
  802ce9:	83 ec 0c             	sub    $0xc,%esp
  802cec:	50                   	push   %eax
  802ced:	e8 ce ed ff ff       	call   801ac0 <sbrk>
  802cf2:	83 c4 10             	add    $0x10,%esp
  802cf5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802cf8:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802cfc:	75 0a                	jne    802d08 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  802d03:	e9 8b 00 00 00       	jmp    802d93 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d08:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d0f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d12:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d15:	01 d0                	add    %edx,%eax
  802d17:	48                   	dec    %eax
  802d18:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d1b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d1e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d23:	f7 75 cc             	divl   -0x34(%ebp)
  802d26:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d29:	29 d0                	sub    %edx,%eax
  802d2b:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d31:	01 d0                	add    %edx,%eax
  802d33:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  802d38:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802d3d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d43:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d4d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d50:	01 d0                	add    %edx,%eax
  802d52:	48                   	dec    %eax
  802d53:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d56:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d59:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5e:	f7 75 c4             	divl   -0x3c(%ebp)
  802d61:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d64:	29 d0                	sub    %edx,%eax
  802d66:	83 ec 04             	sub    $0x4,%esp
  802d69:	6a 01                	push   $0x1
  802d6b:	50                   	push   %eax
  802d6c:	ff 75 d0             	pushl  -0x30(%ebp)
  802d6f:	e8 36 fb ff ff       	call   8028aa <set_block_data>
  802d74:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d77:	83 ec 0c             	sub    $0xc,%esp
  802d7a:	ff 75 d0             	pushl  -0x30(%ebp)
  802d7d:	e8 1b 0a 00 00       	call   80379d <free_block>
  802d82:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802d85:	83 ec 0c             	sub    $0xc,%esp
  802d88:	ff 75 08             	pushl  0x8(%ebp)
  802d8b:	e8 49 fb ff ff       	call   8028d9 <alloc_block_FF>
  802d90:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802d93:	c9                   	leave  
  802d94:	c3                   	ret    

00802d95 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802d95:	55                   	push   %ebp
  802d96:	89 e5                	mov    %esp,%ebp
  802d98:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	83 e0 01             	and    $0x1,%eax
  802da1:	85 c0                	test   %eax,%eax
  802da3:	74 03                	je     802da8 <alloc_block_BF+0x13>
  802da5:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802da8:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802dac:	77 07                	ja     802db5 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802dae:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802db5:	a1 24 60 80 00       	mov    0x806024,%eax
  802dba:	85 c0                	test   %eax,%eax
  802dbc:	75 73                	jne    802e31 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	83 c0 10             	add    $0x10,%eax
  802dc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802dc7:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802dce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd4:	01 d0                	add    %edx,%eax
  802dd6:	48                   	dec    %eax
  802dd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802dda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ddd:	ba 00 00 00 00       	mov    $0x0,%edx
  802de2:	f7 75 e0             	divl   -0x20(%ebp)
  802de5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de8:	29 d0                	sub    %edx,%eax
  802dea:	c1 e8 0c             	shr    $0xc,%eax
  802ded:	83 ec 0c             	sub    $0xc,%esp
  802df0:	50                   	push   %eax
  802df1:	e8 ca ec ff ff       	call   801ac0 <sbrk>
  802df6:	83 c4 10             	add    $0x10,%esp
  802df9:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802dfc:	83 ec 0c             	sub    $0xc,%esp
  802dff:	6a 00                	push   $0x0
  802e01:	e8 ba ec ff ff       	call   801ac0 <sbrk>
  802e06:	83 c4 10             	add    $0x10,%esp
  802e09:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e0f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e12:	83 ec 08             	sub    $0x8,%esp
  802e15:	50                   	push   %eax
  802e16:	ff 75 d8             	pushl  -0x28(%ebp)
  802e19:	e8 9f f8 ff ff       	call   8026bd <initialize_dynamic_allocator>
  802e1e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e21:	83 ec 0c             	sub    $0xc,%esp
  802e24:	68 6b 4f 80 00       	push   $0x804f6b
  802e29:	e8 f8 de ff ff       	call   800d26 <cprintf>
  802e2e:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802e38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802e3f:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802e46:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802e4d:	a1 44 60 80 00       	mov    0x806044,%eax
  802e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e55:	e9 1d 01 00 00       	jmp    802f77 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e60:	83 ec 0c             	sub    $0xc,%esp
  802e63:	ff 75 a8             	pushl  -0x58(%ebp)
  802e66:	e8 ee f6 ff ff       	call   802559 <get_block_size>
  802e6b:	83 c4 10             	add    $0x10,%esp
  802e6e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	83 c0 08             	add    $0x8,%eax
  802e77:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e7a:	0f 87 ef 00 00 00    	ja     802f6f <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	83 c0 18             	add    $0x18,%eax
  802e86:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e89:	77 1d                	ja     802ea8 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e91:	0f 86 d8 00 00 00    	jbe    802f6f <alloc_block_BF+0x1da>
				{
					best_va = va;
  802e97:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802e9d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ea0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ea3:	e9 c7 00 00 00       	jmp    802f6f <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	83 c0 08             	add    $0x8,%eax
  802eae:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eb1:	0f 85 9d 00 00 00    	jne    802f54 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802eb7:	83 ec 04             	sub    $0x4,%esp
  802eba:	6a 01                	push   $0x1
  802ebc:	ff 75 a4             	pushl  -0x5c(%ebp)
  802ebf:	ff 75 a8             	pushl  -0x58(%ebp)
  802ec2:	e8 e3 f9 ff ff       	call   8028aa <set_block_data>
  802ec7:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ece:	75 17                	jne    802ee7 <alloc_block_BF+0x152>
  802ed0:	83 ec 04             	sub    $0x4,%esp
  802ed3:	68 0f 4f 80 00       	push   $0x804f0f
  802ed8:	68 2c 01 00 00       	push   $0x12c
  802edd:	68 2d 4f 80 00       	push   $0x804f2d
  802ee2:	e8 82 db ff ff       	call   800a69 <_panic>
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 00                	mov    (%eax),%eax
  802eec:	85 c0                	test   %eax,%eax
  802eee:	74 10                	je     802f00 <alloc_block_BF+0x16b>
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 00                	mov    (%eax),%eax
  802ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef8:	8b 52 04             	mov    0x4(%edx),%edx
  802efb:	89 50 04             	mov    %edx,0x4(%eax)
  802efe:	eb 0b                	jmp    802f0b <alloc_block_BF+0x176>
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 40 04             	mov    0x4(%eax),%eax
  802f06:	a3 48 60 80 00       	mov    %eax,0x806048
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 40 04             	mov    0x4(%eax),%eax
  802f11:	85 c0                	test   %eax,%eax
  802f13:	74 0f                	je     802f24 <alloc_block_BF+0x18f>
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 40 04             	mov    0x4(%eax),%eax
  802f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1e:	8b 12                	mov    (%edx),%edx
  802f20:	89 10                	mov    %edx,(%eax)
  802f22:	eb 0a                	jmp    802f2e <alloc_block_BF+0x199>
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	a3 44 60 80 00       	mov    %eax,0x806044
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f41:	a1 50 60 80 00       	mov    0x806050,%eax
  802f46:	48                   	dec    %eax
  802f47:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  802f4c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f4f:	e9 24 04 00 00       	jmp    803378 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f57:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f5a:	76 13                	jbe    802f6f <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f5c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f63:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f66:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f69:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f6c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802f6f:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7b:	74 07                	je     802f84 <alloc_block_BF+0x1ef>
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	eb 05                	jmp    802f89 <alloc_block_BF+0x1f4>
  802f84:	b8 00 00 00 00       	mov    $0x0,%eax
  802f89:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802f8e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	0f 85 bf fe ff ff    	jne    802e5a <alloc_block_BF+0xc5>
  802f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9f:	0f 85 b5 fe ff ff    	jne    802e5a <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802fa5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fa9:	0f 84 26 02 00 00    	je     8031d5 <alloc_block_BF+0x440>
  802faf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fb3:	0f 85 1c 02 00 00    	jne    8031d5 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802fb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbc:	2b 45 08             	sub    0x8(%ebp),%eax
  802fbf:	83 e8 08             	sub    $0x8,%eax
  802fc2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	8d 50 08             	lea    0x8(%eax),%edx
  802fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fce:	01 d0                	add    %edx,%eax
  802fd0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	83 c0 08             	add    $0x8,%eax
  802fd9:	83 ec 04             	sub    $0x4,%esp
  802fdc:	6a 01                	push   $0x1
  802fde:	50                   	push   %eax
  802fdf:	ff 75 f0             	pushl  -0x10(%ebp)
  802fe2:	e8 c3 f8 ff ff       	call   8028aa <set_block_data>
  802fe7:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fed:	8b 40 04             	mov    0x4(%eax),%eax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	75 68                	jne    80305c <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ff4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ff8:	75 17                	jne    803011 <alloc_block_BF+0x27c>
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	68 48 4f 80 00       	push   $0x804f48
  803002:	68 45 01 00 00       	push   $0x145
  803007:	68 2d 4f 80 00       	push   $0x804f2d
  80300c:	e8 58 da ff ff       	call   800a69 <_panic>
  803011:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803017:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	74 0d                	je     803032 <alloc_block_BF+0x29d>
  803025:	a1 44 60 80 00       	mov    0x806044,%eax
  80302a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80302d:	89 50 04             	mov    %edx,0x4(%eax)
  803030:	eb 08                	jmp    80303a <alloc_block_BF+0x2a5>
  803032:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803035:	a3 48 60 80 00       	mov    %eax,0x806048
  80303a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80303d:	a3 44 60 80 00       	mov    %eax,0x806044
  803042:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803045:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304c:	a1 50 60 80 00       	mov    0x806050,%eax
  803051:	40                   	inc    %eax
  803052:	a3 50 60 80 00       	mov    %eax,0x806050
  803057:	e9 dc 00 00 00       	jmp    803138 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80305c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	85 c0                	test   %eax,%eax
  803063:	75 65                	jne    8030ca <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803065:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803069:	75 17                	jne    803082 <alloc_block_BF+0x2ed>
  80306b:	83 ec 04             	sub    $0x4,%esp
  80306e:	68 7c 4f 80 00       	push   $0x804f7c
  803073:	68 4a 01 00 00       	push   $0x14a
  803078:	68 2d 4f 80 00       	push   $0x804f2d
  80307d:	e8 e7 d9 ff ff       	call   800a69 <_panic>
  803082:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803088:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80308b:	89 50 04             	mov    %edx,0x4(%eax)
  80308e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803091:	8b 40 04             	mov    0x4(%eax),%eax
  803094:	85 c0                	test   %eax,%eax
  803096:	74 0c                	je     8030a4 <alloc_block_BF+0x30f>
  803098:	a1 48 60 80 00       	mov    0x806048,%eax
  80309d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030a0:	89 10                	mov    %edx,(%eax)
  8030a2:	eb 08                	jmp    8030ac <alloc_block_BF+0x317>
  8030a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a7:	a3 44 60 80 00       	mov    %eax,0x806044
  8030ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030af:	a3 48 60 80 00       	mov    %eax,0x806048
  8030b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030bd:	a1 50 60 80 00       	mov    0x806050,%eax
  8030c2:	40                   	inc    %eax
  8030c3:	a3 50 60 80 00       	mov    %eax,0x806050
  8030c8:	eb 6e                	jmp    803138 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8030ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ce:	74 06                	je     8030d6 <alloc_block_BF+0x341>
  8030d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030d4:	75 17                	jne    8030ed <alloc_block_BF+0x358>
  8030d6:	83 ec 04             	sub    $0x4,%esp
  8030d9:	68 a0 4f 80 00       	push   $0x804fa0
  8030de:	68 4f 01 00 00       	push   $0x14f
  8030e3:	68 2d 4f 80 00       	push   $0x804f2d
  8030e8:	e8 7c d9 ff ff       	call   800a69 <_panic>
  8030ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f0:	8b 10                	mov    (%eax),%edx
  8030f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f5:	89 10                	mov    %edx,(%eax)
  8030f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	85 c0                	test   %eax,%eax
  8030fe:	74 0b                	je     80310b <alloc_block_BF+0x376>
  803100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803108:	89 50 04             	mov    %edx,0x4(%eax)
  80310b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803111:	89 10                	mov    %edx,(%eax)
  803113:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803116:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803119:	89 50 04             	mov    %edx,0x4(%eax)
  80311c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	75 08                	jne    80312d <alloc_block_BF+0x398>
  803125:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803128:	a3 48 60 80 00       	mov    %eax,0x806048
  80312d:	a1 50 60 80 00       	mov    0x806050,%eax
  803132:	40                   	inc    %eax
  803133:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803138:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80313c:	75 17                	jne    803155 <alloc_block_BF+0x3c0>
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	68 0f 4f 80 00       	push   $0x804f0f
  803146:	68 51 01 00 00       	push   $0x151
  80314b:	68 2d 4f 80 00       	push   $0x804f2d
  803150:	e8 14 d9 ff ff       	call   800a69 <_panic>
  803155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	85 c0                	test   %eax,%eax
  80315c:	74 10                	je     80316e <alloc_block_BF+0x3d9>
  80315e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803166:	8b 52 04             	mov    0x4(%edx),%edx
  803169:	89 50 04             	mov    %edx,0x4(%eax)
  80316c:	eb 0b                	jmp    803179 <alloc_block_BF+0x3e4>
  80316e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803171:	8b 40 04             	mov    0x4(%eax),%eax
  803174:	a3 48 60 80 00       	mov    %eax,0x806048
  803179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317c:	8b 40 04             	mov    0x4(%eax),%eax
  80317f:	85 c0                	test   %eax,%eax
  803181:	74 0f                	je     803192 <alloc_block_BF+0x3fd>
  803183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803186:	8b 40 04             	mov    0x4(%eax),%eax
  803189:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80318c:	8b 12                	mov    (%edx),%edx
  80318e:	89 10                	mov    %edx,(%eax)
  803190:	eb 0a                	jmp    80319c <alloc_block_BF+0x407>
  803192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	a3 44 60 80 00       	mov    %eax,0x806044
  80319c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031af:	a1 50 60 80 00       	mov    0x806050,%eax
  8031b4:	48                   	dec    %eax
  8031b5:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  8031ba:	83 ec 04             	sub    $0x4,%esp
  8031bd:	6a 00                	push   $0x0
  8031bf:	ff 75 d0             	pushl  -0x30(%ebp)
  8031c2:	ff 75 cc             	pushl  -0x34(%ebp)
  8031c5:	e8 e0 f6 ff ff       	call   8028aa <set_block_data>
  8031ca:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8031cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d0:	e9 a3 01 00 00       	jmp    803378 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8031d5:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8031d9:	0f 85 9d 00 00 00    	jne    80327c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8031df:	83 ec 04             	sub    $0x4,%esp
  8031e2:	6a 01                	push   $0x1
  8031e4:	ff 75 ec             	pushl  -0x14(%ebp)
  8031e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ea:	e8 bb f6 ff ff       	call   8028aa <set_block_data>
  8031ef:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8031f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031f6:	75 17                	jne    80320f <alloc_block_BF+0x47a>
  8031f8:	83 ec 04             	sub    $0x4,%esp
  8031fb:	68 0f 4f 80 00       	push   $0x804f0f
  803200:	68 58 01 00 00       	push   $0x158
  803205:	68 2d 4f 80 00       	push   $0x804f2d
  80320a:	e8 5a d8 ff ff       	call   800a69 <_panic>
  80320f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803212:	8b 00                	mov    (%eax),%eax
  803214:	85 c0                	test   %eax,%eax
  803216:	74 10                	je     803228 <alloc_block_BF+0x493>
  803218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321b:	8b 00                	mov    (%eax),%eax
  80321d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803220:	8b 52 04             	mov    0x4(%edx),%edx
  803223:	89 50 04             	mov    %edx,0x4(%eax)
  803226:	eb 0b                	jmp    803233 <alloc_block_BF+0x49e>
  803228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322b:	8b 40 04             	mov    0x4(%eax),%eax
  80322e:	a3 48 60 80 00       	mov    %eax,0x806048
  803233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803236:	8b 40 04             	mov    0x4(%eax),%eax
  803239:	85 c0                	test   %eax,%eax
  80323b:	74 0f                	je     80324c <alloc_block_BF+0x4b7>
  80323d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803240:	8b 40 04             	mov    0x4(%eax),%eax
  803243:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803246:	8b 12                	mov    (%edx),%edx
  803248:	89 10                	mov    %edx,(%eax)
  80324a:	eb 0a                	jmp    803256 <alloc_block_BF+0x4c1>
  80324c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324f:	8b 00                	mov    (%eax),%eax
  803251:	a3 44 60 80 00       	mov    %eax,0x806044
  803256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80325f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803262:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803269:	a1 50 60 80 00       	mov    0x806050,%eax
  80326e:	48                   	dec    %eax
  80326f:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  803274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803277:	e9 fc 00 00 00       	jmp    803378 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80327c:	8b 45 08             	mov    0x8(%ebp),%eax
  80327f:	83 c0 08             	add    $0x8,%eax
  803282:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803285:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80328c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80328f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803292:	01 d0                	add    %edx,%eax
  803294:	48                   	dec    %eax
  803295:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803298:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80329b:	ba 00 00 00 00       	mov    $0x0,%edx
  8032a0:	f7 75 c4             	divl   -0x3c(%ebp)
  8032a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032a6:	29 d0                	sub    %edx,%eax
  8032a8:	c1 e8 0c             	shr    $0xc,%eax
  8032ab:	83 ec 0c             	sub    $0xc,%esp
  8032ae:	50                   	push   %eax
  8032af:	e8 0c e8 ff ff       	call   801ac0 <sbrk>
  8032b4:	83 c4 10             	add    $0x10,%esp
  8032b7:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8032ba:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8032be:	75 0a                	jne    8032ca <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8032c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c5:	e9 ae 00 00 00       	jmp    803378 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8032ca:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8032d1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032d4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8032d7:	01 d0                	add    %edx,%eax
  8032d9:	48                   	dec    %eax
  8032da:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8032dd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8032e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8032e5:	f7 75 b8             	divl   -0x48(%ebp)
  8032e8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8032eb:	29 d0                	sub    %edx,%eax
  8032ed:	8d 50 fc             	lea    -0x4(%eax),%edx
  8032f0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8032f3:	01 d0                	add    %edx,%eax
  8032f5:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  8032fa:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8032ff:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803305:	83 ec 0c             	sub    $0xc,%esp
  803308:	68 d4 4f 80 00       	push   $0x804fd4
  80330d:	e8 14 da ff ff       	call   800d26 <cprintf>
  803312:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803315:	83 ec 08             	sub    $0x8,%esp
  803318:	ff 75 bc             	pushl  -0x44(%ebp)
  80331b:	68 d9 4f 80 00       	push   $0x804fd9
  803320:	e8 01 da ff ff       	call   800d26 <cprintf>
  803325:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803328:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80332f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803332:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803335:	01 d0                	add    %edx,%eax
  803337:	48                   	dec    %eax
  803338:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80333b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80333e:	ba 00 00 00 00       	mov    $0x0,%edx
  803343:	f7 75 b0             	divl   -0x50(%ebp)
  803346:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803349:	29 d0                	sub    %edx,%eax
  80334b:	83 ec 04             	sub    $0x4,%esp
  80334e:	6a 01                	push   $0x1
  803350:	50                   	push   %eax
  803351:	ff 75 bc             	pushl  -0x44(%ebp)
  803354:	e8 51 f5 ff ff       	call   8028aa <set_block_data>
  803359:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80335c:	83 ec 0c             	sub    $0xc,%esp
  80335f:	ff 75 bc             	pushl  -0x44(%ebp)
  803362:	e8 36 04 00 00       	call   80379d <free_block>
  803367:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80336a:	83 ec 0c             	sub    $0xc,%esp
  80336d:	ff 75 08             	pushl  0x8(%ebp)
  803370:	e8 20 fa ff ff       	call   802d95 <alloc_block_BF>
  803375:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803378:	c9                   	leave  
  803379:	c3                   	ret    

0080337a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80337a:	55                   	push   %ebp
  80337b:	89 e5                	mov    %esp,%ebp
  80337d:	53                   	push   %ebx
  80337e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803381:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803388:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80338f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803393:	74 1e                	je     8033b3 <merging+0x39>
  803395:	ff 75 08             	pushl  0x8(%ebp)
  803398:	e8 bc f1 ff ff       	call   802559 <get_block_size>
  80339d:	83 c4 04             	add    $0x4,%esp
  8033a0:	89 c2                	mov    %eax,%edx
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	01 d0                	add    %edx,%eax
  8033a7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8033aa:	75 07                	jne    8033b3 <merging+0x39>
		prev_is_free = 1;
  8033ac:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8033b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033b7:	74 1e                	je     8033d7 <merging+0x5d>
  8033b9:	ff 75 10             	pushl  0x10(%ebp)
  8033bc:	e8 98 f1 ff ff       	call   802559 <get_block_size>
  8033c1:	83 c4 04             	add    $0x4,%esp
  8033c4:	89 c2                	mov    %eax,%edx
  8033c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8033c9:	01 d0                	add    %edx,%eax
  8033cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033ce:	75 07                	jne    8033d7 <merging+0x5d>
		next_is_free = 1;
  8033d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8033d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033db:	0f 84 cc 00 00 00    	je     8034ad <merging+0x133>
  8033e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033e5:	0f 84 c2 00 00 00    	je     8034ad <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8033eb:	ff 75 08             	pushl  0x8(%ebp)
  8033ee:	e8 66 f1 ff ff       	call   802559 <get_block_size>
  8033f3:	83 c4 04             	add    $0x4,%esp
  8033f6:	89 c3                	mov    %eax,%ebx
  8033f8:	ff 75 10             	pushl  0x10(%ebp)
  8033fb:	e8 59 f1 ff ff       	call   802559 <get_block_size>
  803400:	83 c4 04             	add    $0x4,%esp
  803403:	01 c3                	add    %eax,%ebx
  803405:	ff 75 0c             	pushl  0xc(%ebp)
  803408:	e8 4c f1 ff ff       	call   802559 <get_block_size>
  80340d:	83 c4 04             	add    $0x4,%esp
  803410:	01 d8                	add    %ebx,%eax
  803412:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803415:	6a 00                	push   $0x0
  803417:	ff 75 ec             	pushl  -0x14(%ebp)
  80341a:	ff 75 08             	pushl  0x8(%ebp)
  80341d:	e8 88 f4 ff ff       	call   8028aa <set_block_data>
  803422:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803425:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803429:	75 17                	jne    803442 <merging+0xc8>
  80342b:	83 ec 04             	sub    $0x4,%esp
  80342e:	68 0f 4f 80 00       	push   $0x804f0f
  803433:	68 7d 01 00 00       	push   $0x17d
  803438:	68 2d 4f 80 00       	push   $0x804f2d
  80343d:	e8 27 d6 ff ff       	call   800a69 <_panic>
  803442:	8b 45 0c             	mov    0xc(%ebp),%eax
  803445:	8b 00                	mov    (%eax),%eax
  803447:	85 c0                	test   %eax,%eax
  803449:	74 10                	je     80345b <merging+0xe1>
  80344b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344e:	8b 00                	mov    (%eax),%eax
  803450:	8b 55 0c             	mov    0xc(%ebp),%edx
  803453:	8b 52 04             	mov    0x4(%edx),%edx
  803456:	89 50 04             	mov    %edx,0x4(%eax)
  803459:	eb 0b                	jmp    803466 <merging+0xec>
  80345b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80345e:	8b 40 04             	mov    0x4(%eax),%eax
  803461:	a3 48 60 80 00       	mov    %eax,0x806048
  803466:	8b 45 0c             	mov    0xc(%ebp),%eax
  803469:	8b 40 04             	mov    0x4(%eax),%eax
  80346c:	85 c0                	test   %eax,%eax
  80346e:	74 0f                	je     80347f <merging+0x105>
  803470:	8b 45 0c             	mov    0xc(%ebp),%eax
  803473:	8b 40 04             	mov    0x4(%eax),%eax
  803476:	8b 55 0c             	mov    0xc(%ebp),%edx
  803479:	8b 12                	mov    (%edx),%edx
  80347b:	89 10                	mov    %edx,(%eax)
  80347d:	eb 0a                	jmp    803489 <merging+0x10f>
  80347f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	a3 44 60 80 00       	mov    %eax,0x806044
  803489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803492:	8b 45 0c             	mov    0xc(%ebp),%eax
  803495:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349c:	a1 50 60 80 00       	mov    0x806050,%eax
  8034a1:	48                   	dec    %eax
  8034a2:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8034a7:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034a8:	e9 ea 02 00 00       	jmp    803797 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8034ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b1:	74 3b                	je     8034ee <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8034b3:	83 ec 0c             	sub    $0xc,%esp
  8034b6:	ff 75 08             	pushl  0x8(%ebp)
  8034b9:	e8 9b f0 ff ff       	call   802559 <get_block_size>
  8034be:	83 c4 10             	add    $0x10,%esp
  8034c1:	89 c3                	mov    %eax,%ebx
  8034c3:	83 ec 0c             	sub    $0xc,%esp
  8034c6:	ff 75 10             	pushl  0x10(%ebp)
  8034c9:	e8 8b f0 ff ff       	call   802559 <get_block_size>
  8034ce:	83 c4 10             	add    $0x10,%esp
  8034d1:	01 d8                	add    %ebx,%eax
  8034d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034d6:	83 ec 04             	sub    $0x4,%esp
  8034d9:	6a 00                	push   $0x0
  8034db:	ff 75 e8             	pushl  -0x18(%ebp)
  8034de:	ff 75 08             	pushl  0x8(%ebp)
  8034e1:	e8 c4 f3 ff ff       	call   8028aa <set_block_data>
  8034e6:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034e9:	e9 a9 02 00 00       	jmp    803797 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8034ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034f2:	0f 84 2d 01 00 00    	je     803625 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8034f8:	83 ec 0c             	sub    $0xc,%esp
  8034fb:	ff 75 10             	pushl  0x10(%ebp)
  8034fe:	e8 56 f0 ff ff       	call   802559 <get_block_size>
  803503:	83 c4 10             	add    $0x10,%esp
  803506:	89 c3                	mov    %eax,%ebx
  803508:	83 ec 0c             	sub    $0xc,%esp
  80350b:	ff 75 0c             	pushl  0xc(%ebp)
  80350e:	e8 46 f0 ff ff       	call   802559 <get_block_size>
  803513:	83 c4 10             	add    $0x10,%esp
  803516:	01 d8                	add    %ebx,%eax
  803518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80351b:	83 ec 04             	sub    $0x4,%esp
  80351e:	6a 00                	push   $0x0
  803520:	ff 75 e4             	pushl  -0x1c(%ebp)
  803523:	ff 75 10             	pushl  0x10(%ebp)
  803526:	e8 7f f3 ff ff       	call   8028aa <set_block_data>
  80352b:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80352e:	8b 45 10             	mov    0x10(%ebp),%eax
  803531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803534:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803538:	74 06                	je     803540 <merging+0x1c6>
  80353a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80353e:	75 17                	jne    803557 <merging+0x1dd>
  803540:	83 ec 04             	sub    $0x4,%esp
  803543:	68 e8 4f 80 00       	push   $0x804fe8
  803548:	68 8d 01 00 00       	push   $0x18d
  80354d:	68 2d 4f 80 00       	push   $0x804f2d
  803552:	e8 12 d5 ff ff       	call   800a69 <_panic>
  803557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355a:	8b 50 04             	mov    0x4(%eax),%edx
  80355d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803560:	89 50 04             	mov    %edx,0x4(%eax)
  803563:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803566:	8b 55 0c             	mov    0xc(%ebp),%edx
  803569:	89 10                	mov    %edx,(%eax)
  80356b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356e:	8b 40 04             	mov    0x4(%eax),%eax
  803571:	85 c0                	test   %eax,%eax
  803573:	74 0d                	je     803582 <merging+0x208>
  803575:	8b 45 0c             	mov    0xc(%ebp),%eax
  803578:	8b 40 04             	mov    0x4(%eax),%eax
  80357b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80357e:	89 10                	mov    %edx,(%eax)
  803580:	eb 08                	jmp    80358a <merging+0x210>
  803582:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803585:	a3 44 60 80 00       	mov    %eax,0x806044
  80358a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803590:	89 50 04             	mov    %edx,0x4(%eax)
  803593:	a1 50 60 80 00       	mov    0x806050,%eax
  803598:	40                   	inc    %eax
  803599:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  80359e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035a2:	75 17                	jne    8035bb <merging+0x241>
  8035a4:	83 ec 04             	sub    $0x4,%esp
  8035a7:	68 0f 4f 80 00       	push   $0x804f0f
  8035ac:	68 8e 01 00 00       	push   $0x18e
  8035b1:	68 2d 4f 80 00       	push   $0x804f2d
  8035b6:	e8 ae d4 ff ff       	call   800a69 <_panic>
  8035bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035be:	8b 00                	mov    (%eax),%eax
  8035c0:	85 c0                	test   %eax,%eax
  8035c2:	74 10                	je     8035d4 <merging+0x25a>
  8035c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c7:	8b 00                	mov    (%eax),%eax
  8035c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035cc:	8b 52 04             	mov    0x4(%edx),%edx
  8035cf:	89 50 04             	mov    %edx,0x4(%eax)
  8035d2:	eb 0b                	jmp    8035df <merging+0x265>
  8035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d7:	8b 40 04             	mov    0x4(%eax),%eax
  8035da:	a3 48 60 80 00       	mov    %eax,0x806048
  8035df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e2:	8b 40 04             	mov    0x4(%eax),%eax
  8035e5:	85 c0                	test   %eax,%eax
  8035e7:	74 0f                	je     8035f8 <merging+0x27e>
  8035e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ec:	8b 40 04             	mov    0x4(%eax),%eax
  8035ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f2:	8b 12                	mov    (%edx),%edx
  8035f4:	89 10                	mov    %edx,(%eax)
  8035f6:	eb 0a                	jmp    803602 <merging+0x288>
  8035f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fb:	8b 00                	mov    (%eax),%eax
  8035fd:	a3 44 60 80 00       	mov    %eax,0x806044
  803602:	8b 45 0c             	mov    0xc(%ebp),%eax
  803605:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80360b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803615:	a1 50 60 80 00       	mov    0x806050,%eax
  80361a:	48                   	dec    %eax
  80361b:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803620:	e9 72 01 00 00       	jmp    803797 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803625:	8b 45 10             	mov    0x10(%ebp),%eax
  803628:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80362b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80362f:	74 79                	je     8036aa <merging+0x330>
  803631:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803635:	74 73                	je     8036aa <merging+0x330>
  803637:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80363b:	74 06                	je     803643 <merging+0x2c9>
  80363d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803641:	75 17                	jne    80365a <merging+0x2e0>
  803643:	83 ec 04             	sub    $0x4,%esp
  803646:	68 a0 4f 80 00       	push   $0x804fa0
  80364b:	68 94 01 00 00       	push   $0x194
  803650:	68 2d 4f 80 00       	push   $0x804f2d
  803655:	e8 0f d4 ff ff       	call   800a69 <_panic>
  80365a:	8b 45 08             	mov    0x8(%ebp),%eax
  80365d:	8b 10                	mov    (%eax),%edx
  80365f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803662:	89 10                	mov    %edx,(%eax)
  803664:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	85 c0                	test   %eax,%eax
  80366b:	74 0b                	je     803678 <merging+0x2fe>
  80366d:	8b 45 08             	mov    0x8(%ebp),%eax
  803670:	8b 00                	mov    (%eax),%eax
  803672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803675:	89 50 04             	mov    %edx,0x4(%eax)
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80367e:	89 10                	mov    %edx,(%eax)
  803680:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803683:	8b 55 08             	mov    0x8(%ebp),%edx
  803686:	89 50 04             	mov    %edx,0x4(%eax)
  803689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80368c:	8b 00                	mov    (%eax),%eax
  80368e:	85 c0                	test   %eax,%eax
  803690:	75 08                	jne    80369a <merging+0x320>
  803692:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803695:	a3 48 60 80 00       	mov    %eax,0x806048
  80369a:	a1 50 60 80 00       	mov    0x806050,%eax
  80369f:	40                   	inc    %eax
  8036a0:	a3 50 60 80 00       	mov    %eax,0x806050
  8036a5:	e9 ce 00 00 00       	jmp    803778 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8036aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ae:	74 65                	je     803715 <merging+0x39b>
  8036b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036b4:	75 17                	jne    8036cd <merging+0x353>
  8036b6:	83 ec 04             	sub    $0x4,%esp
  8036b9:	68 7c 4f 80 00       	push   $0x804f7c
  8036be:	68 95 01 00 00       	push   $0x195
  8036c3:	68 2d 4f 80 00       	push   $0x804f2d
  8036c8:	e8 9c d3 ff ff       	call   800a69 <_panic>
  8036cd:	8b 15 48 60 80 00    	mov    0x806048,%edx
  8036d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036d6:	89 50 04             	mov    %edx,0x4(%eax)
  8036d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036dc:	8b 40 04             	mov    0x4(%eax),%eax
  8036df:	85 c0                	test   %eax,%eax
  8036e1:	74 0c                	je     8036ef <merging+0x375>
  8036e3:	a1 48 60 80 00       	mov    0x806048,%eax
  8036e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036eb:	89 10                	mov    %edx,(%eax)
  8036ed:	eb 08                	jmp    8036f7 <merging+0x37d>
  8036ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f2:	a3 44 60 80 00       	mov    %eax,0x806044
  8036f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fa:	a3 48 60 80 00       	mov    %eax,0x806048
  8036ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803702:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803708:	a1 50 60 80 00       	mov    0x806050,%eax
  80370d:	40                   	inc    %eax
  80370e:	a3 50 60 80 00       	mov    %eax,0x806050
  803713:	eb 63                	jmp    803778 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803715:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803719:	75 17                	jne    803732 <merging+0x3b8>
  80371b:	83 ec 04             	sub    $0x4,%esp
  80371e:	68 48 4f 80 00       	push   $0x804f48
  803723:	68 98 01 00 00       	push   $0x198
  803728:	68 2d 4f 80 00       	push   $0x804f2d
  80372d:	e8 37 d3 ff ff       	call   800a69 <_panic>
  803732:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803738:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80373b:	89 10                	mov    %edx,(%eax)
  80373d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803740:	8b 00                	mov    (%eax),%eax
  803742:	85 c0                	test   %eax,%eax
  803744:	74 0d                	je     803753 <merging+0x3d9>
  803746:	a1 44 60 80 00       	mov    0x806044,%eax
  80374b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80374e:	89 50 04             	mov    %edx,0x4(%eax)
  803751:	eb 08                	jmp    80375b <merging+0x3e1>
  803753:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803756:	a3 48 60 80 00       	mov    %eax,0x806048
  80375b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80375e:	a3 44 60 80 00       	mov    %eax,0x806044
  803763:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803766:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80376d:	a1 50 60 80 00       	mov    0x806050,%eax
  803772:	40                   	inc    %eax
  803773:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  803778:	83 ec 0c             	sub    $0xc,%esp
  80377b:	ff 75 10             	pushl  0x10(%ebp)
  80377e:	e8 d6 ed ff ff       	call   802559 <get_block_size>
  803783:	83 c4 10             	add    $0x10,%esp
  803786:	83 ec 04             	sub    $0x4,%esp
  803789:	6a 00                	push   $0x0
  80378b:	50                   	push   %eax
  80378c:	ff 75 10             	pushl  0x10(%ebp)
  80378f:	e8 16 f1 ff ff       	call   8028aa <set_block_data>
  803794:	83 c4 10             	add    $0x10,%esp
	}
}
  803797:	90                   	nop
  803798:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80379b:	c9                   	leave  
  80379c:	c3                   	ret    

0080379d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80379d:	55                   	push   %ebp
  80379e:	89 e5                	mov    %esp,%ebp
  8037a0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8037a3:	a1 44 60 80 00       	mov    0x806044,%eax
  8037a8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8037ab:	a1 48 60 80 00       	mov    0x806048,%eax
  8037b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037b3:	73 1b                	jae    8037d0 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8037b5:	a1 48 60 80 00       	mov    0x806048,%eax
  8037ba:	83 ec 04             	sub    $0x4,%esp
  8037bd:	ff 75 08             	pushl  0x8(%ebp)
  8037c0:	6a 00                	push   $0x0
  8037c2:	50                   	push   %eax
  8037c3:	e8 b2 fb ff ff       	call   80337a <merging>
  8037c8:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037cb:	e9 8b 00 00 00       	jmp    80385b <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8037d0:	a1 44 60 80 00       	mov    0x806044,%eax
  8037d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d8:	76 18                	jbe    8037f2 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8037da:	a1 44 60 80 00       	mov    0x806044,%eax
  8037df:	83 ec 04             	sub    $0x4,%esp
  8037e2:	ff 75 08             	pushl  0x8(%ebp)
  8037e5:	50                   	push   %eax
  8037e6:	6a 00                	push   $0x0
  8037e8:	e8 8d fb ff ff       	call   80337a <merging>
  8037ed:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037f0:	eb 69                	jmp    80385b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037f2:	a1 44 60 80 00       	mov    0x806044,%eax
  8037f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037fa:	eb 39                	jmp    803835 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8037fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  803802:	73 29                	jae    80382d <free_block+0x90>
  803804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803807:	8b 00                	mov    (%eax),%eax
  803809:	3b 45 08             	cmp    0x8(%ebp),%eax
  80380c:	76 1f                	jbe    80382d <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80380e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803811:	8b 00                	mov    (%eax),%eax
  803813:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803816:	83 ec 04             	sub    $0x4,%esp
  803819:	ff 75 08             	pushl  0x8(%ebp)
  80381c:	ff 75 f0             	pushl  -0x10(%ebp)
  80381f:	ff 75 f4             	pushl  -0xc(%ebp)
  803822:	e8 53 fb ff ff       	call   80337a <merging>
  803827:	83 c4 10             	add    $0x10,%esp
			break;
  80382a:	90                   	nop
		}
	}
}
  80382b:	eb 2e                	jmp    80385b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80382d:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803832:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803839:	74 07                	je     803842 <free_block+0xa5>
  80383b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383e:	8b 00                	mov    (%eax),%eax
  803840:	eb 05                	jmp    803847 <free_block+0xaa>
  803842:	b8 00 00 00 00       	mov    $0x0,%eax
  803847:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80384c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803851:	85 c0                	test   %eax,%eax
  803853:	75 a7                	jne    8037fc <free_block+0x5f>
  803855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803859:	75 a1                	jne    8037fc <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80385b:	90                   	nop
  80385c:	c9                   	leave  
  80385d:	c3                   	ret    

0080385e <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80385e:	55                   	push   %ebp
  80385f:	89 e5                	mov    %esp,%ebp
  803861:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803864:	ff 75 08             	pushl  0x8(%ebp)
  803867:	e8 ed ec ff ff       	call   802559 <get_block_size>
  80386c:	83 c4 04             	add    $0x4,%esp
  80386f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803872:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803879:	eb 17                	jmp    803892 <copy_data+0x34>
  80387b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80387e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803881:	01 c2                	add    %eax,%edx
  803883:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803886:	8b 45 08             	mov    0x8(%ebp),%eax
  803889:	01 c8                	add    %ecx,%eax
  80388b:	8a 00                	mov    (%eax),%al
  80388d:	88 02                	mov    %al,(%edx)
  80388f:	ff 45 fc             	incl   -0x4(%ebp)
  803892:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803895:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803898:	72 e1                	jb     80387b <copy_data+0x1d>
}
  80389a:	90                   	nop
  80389b:	c9                   	leave  
  80389c:	c3                   	ret    

0080389d <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80389d:	55                   	push   %ebp
  80389e:	89 e5                	mov    %esp,%ebp
  8038a0:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8038a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038a7:	75 23                	jne    8038cc <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8038a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038ad:	74 13                	je     8038c2 <realloc_block_FF+0x25>
  8038af:	83 ec 0c             	sub    $0xc,%esp
  8038b2:	ff 75 0c             	pushl  0xc(%ebp)
  8038b5:	e8 1f f0 ff ff       	call   8028d9 <alloc_block_FF>
  8038ba:	83 c4 10             	add    $0x10,%esp
  8038bd:	e9 f4 06 00 00       	jmp    803fb6 <realloc_block_FF+0x719>
		return NULL;
  8038c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c7:	e9 ea 06 00 00       	jmp    803fb6 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8038cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038d0:	75 18                	jne    8038ea <realloc_block_FF+0x4d>
	{
		free_block(va);
  8038d2:	83 ec 0c             	sub    $0xc,%esp
  8038d5:	ff 75 08             	pushl  0x8(%ebp)
  8038d8:	e8 c0 fe ff ff       	call   80379d <free_block>
  8038dd:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8038e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e5:	e9 cc 06 00 00       	jmp    803fb6 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8038ea:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8038ee:	77 07                	ja     8038f7 <realloc_block_FF+0x5a>
  8038f0:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8038f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038fa:	83 e0 01             	and    $0x1,%eax
  8038fd:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803900:	8b 45 0c             	mov    0xc(%ebp),%eax
  803903:	83 c0 08             	add    $0x8,%eax
  803906:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803909:	83 ec 0c             	sub    $0xc,%esp
  80390c:	ff 75 08             	pushl  0x8(%ebp)
  80390f:	e8 45 ec ff ff       	call   802559 <get_block_size>
  803914:	83 c4 10             	add    $0x10,%esp
  803917:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80391a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80391d:	83 e8 08             	sub    $0x8,%eax
  803920:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803923:	8b 45 08             	mov    0x8(%ebp),%eax
  803926:	83 e8 04             	sub    $0x4,%eax
  803929:	8b 00                	mov    (%eax),%eax
  80392b:	83 e0 fe             	and    $0xfffffffe,%eax
  80392e:	89 c2                	mov    %eax,%edx
  803930:	8b 45 08             	mov    0x8(%ebp),%eax
  803933:	01 d0                	add    %edx,%eax
  803935:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803938:	83 ec 0c             	sub    $0xc,%esp
  80393b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80393e:	e8 16 ec ff ff       	call   802559 <get_block_size>
  803943:	83 c4 10             	add    $0x10,%esp
  803946:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803949:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80394c:	83 e8 08             	sub    $0x8,%eax
  80394f:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803952:	8b 45 0c             	mov    0xc(%ebp),%eax
  803955:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803958:	75 08                	jne    803962 <realloc_block_FF+0xc5>
	{
		 return va;
  80395a:	8b 45 08             	mov    0x8(%ebp),%eax
  80395d:	e9 54 06 00 00       	jmp    803fb6 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803962:	8b 45 0c             	mov    0xc(%ebp),%eax
  803965:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803968:	0f 83 e5 03 00 00    	jae    803d53 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80396e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803971:	2b 45 0c             	sub    0xc(%ebp),%eax
  803974:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803977:	83 ec 0c             	sub    $0xc,%esp
  80397a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80397d:	e8 f0 eb ff ff       	call   802572 <is_free_block>
  803982:	83 c4 10             	add    $0x10,%esp
  803985:	84 c0                	test   %al,%al
  803987:	0f 84 3b 01 00 00    	je     803ac8 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80398d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803990:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803993:	01 d0                	add    %edx,%eax
  803995:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803998:	83 ec 04             	sub    $0x4,%esp
  80399b:	6a 01                	push   $0x1
  80399d:	ff 75 f0             	pushl  -0x10(%ebp)
  8039a0:	ff 75 08             	pushl  0x8(%ebp)
  8039a3:	e8 02 ef ff ff       	call   8028aa <set_block_data>
  8039a8:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8039ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ae:	83 e8 04             	sub    $0x4,%eax
  8039b1:	8b 00                	mov    (%eax),%eax
  8039b3:	83 e0 fe             	and    $0xfffffffe,%eax
  8039b6:	89 c2                	mov    %eax,%edx
  8039b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bb:	01 d0                	add    %edx,%eax
  8039bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8039c0:	83 ec 04             	sub    $0x4,%esp
  8039c3:	6a 00                	push   $0x0
  8039c5:	ff 75 cc             	pushl  -0x34(%ebp)
  8039c8:	ff 75 c8             	pushl  -0x38(%ebp)
  8039cb:	e8 da ee ff ff       	call   8028aa <set_block_data>
  8039d0:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039d7:	74 06                	je     8039df <realloc_block_FF+0x142>
  8039d9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8039dd:	75 17                	jne    8039f6 <realloc_block_FF+0x159>
  8039df:	83 ec 04             	sub    $0x4,%esp
  8039e2:	68 a0 4f 80 00       	push   $0x804fa0
  8039e7:	68 f6 01 00 00       	push   $0x1f6
  8039ec:	68 2d 4f 80 00       	push   $0x804f2d
  8039f1:	e8 73 d0 ff ff       	call   800a69 <_panic>
  8039f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f9:	8b 10                	mov    (%eax),%edx
  8039fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039fe:	89 10                	mov    %edx,(%eax)
  803a00:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a03:	8b 00                	mov    (%eax),%eax
  803a05:	85 c0                	test   %eax,%eax
  803a07:	74 0b                	je     803a14 <realloc_block_FF+0x177>
  803a09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a0c:	8b 00                	mov    (%eax),%eax
  803a0e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a11:	89 50 04             	mov    %edx,0x4(%eax)
  803a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a17:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a1a:	89 10                	mov    %edx,(%eax)
  803a1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a22:	89 50 04             	mov    %edx,0x4(%eax)
  803a25:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a28:	8b 00                	mov    (%eax),%eax
  803a2a:	85 c0                	test   %eax,%eax
  803a2c:	75 08                	jne    803a36 <realloc_block_FF+0x199>
  803a2e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a31:	a3 48 60 80 00       	mov    %eax,0x806048
  803a36:	a1 50 60 80 00       	mov    0x806050,%eax
  803a3b:	40                   	inc    %eax
  803a3c:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a45:	75 17                	jne    803a5e <realloc_block_FF+0x1c1>
  803a47:	83 ec 04             	sub    $0x4,%esp
  803a4a:	68 0f 4f 80 00       	push   $0x804f0f
  803a4f:	68 f7 01 00 00       	push   $0x1f7
  803a54:	68 2d 4f 80 00       	push   $0x804f2d
  803a59:	e8 0b d0 ff ff       	call   800a69 <_panic>
  803a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a61:	8b 00                	mov    (%eax),%eax
  803a63:	85 c0                	test   %eax,%eax
  803a65:	74 10                	je     803a77 <realloc_block_FF+0x1da>
  803a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6a:	8b 00                	mov    (%eax),%eax
  803a6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a6f:	8b 52 04             	mov    0x4(%edx),%edx
  803a72:	89 50 04             	mov    %edx,0x4(%eax)
  803a75:	eb 0b                	jmp    803a82 <realloc_block_FF+0x1e5>
  803a77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7a:	8b 40 04             	mov    0x4(%eax),%eax
  803a7d:	a3 48 60 80 00       	mov    %eax,0x806048
  803a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a85:	8b 40 04             	mov    0x4(%eax),%eax
  803a88:	85 c0                	test   %eax,%eax
  803a8a:	74 0f                	je     803a9b <realloc_block_FF+0x1fe>
  803a8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8f:	8b 40 04             	mov    0x4(%eax),%eax
  803a92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a95:	8b 12                	mov    (%edx),%edx
  803a97:	89 10                	mov    %edx,(%eax)
  803a99:	eb 0a                	jmp    803aa5 <realloc_block_FF+0x208>
  803a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9e:	8b 00                	mov    (%eax),%eax
  803aa0:	a3 44 60 80 00       	mov    %eax,0x806044
  803aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ab8:	a1 50 60 80 00       	mov    0x806050,%eax
  803abd:	48                   	dec    %eax
  803abe:	a3 50 60 80 00       	mov    %eax,0x806050
  803ac3:	e9 83 02 00 00       	jmp    803d4b <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803ac8:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803acc:	0f 86 69 02 00 00    	jbe    803d3b <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803ad2:	83 ec 04             	sub    $0x4,%esp
  803ad5:	6a 01                	push   $0x1
  803ad7:	ff 75 f0             	pushl  -0x10(%ebp)
  803ada:	ff 75 08             	pushl  0x8(%ebp)
  803add:	e8 c8 ed ff ff       	call   8028aa <set_block_data>
  803ae2:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae8:	83 e8 04             	sub    $0x4,%eax
  803aeb:	8b 00                	mov    (%eax),%eax
  803aed:	83 e0 fe             	and    $0xfffffffe,%eax
  803af0:	89 c2                	mov    %eax,%edx
  803af2:	8b 45 08             	mov    0x8(%ebp),%eax
  803af5:	01 d0                	add    %edx,%eax
  803af7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803afa:	a1 50 60 80 00       	mov    0x806050,%eax
  803aff:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b02:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b06:	75 68                	jne    803b70 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b08:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b0c:	75 17                	jne    803b25 <realloc_block_FF+0x288>
  803b0e:	83 ec 04             	sub    $0x4,%esp
  803b11:	68 48 4f 80 00       	push   $0x804f48
  803b16:	68 06 02 00 00       	push   $0x206
  803b1b:	68 2d 4f 80 00       	push   $0x804f2d
  803b20:	e8 44 cf ff ff       	call   800a69 <_panic>
  803b25:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803b2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b2e:	89 10                	mov    %edx,(%eax)
  803b30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b33:	8b 00                	mov    (%eax),%eax
  803b35:	85 c0                	test   %eax,%eax
  803b37:	74 0d                	je     803b46 <realloc_block_FF+0x2a9>
  803b39:	a1 44 60 80 00       	mov    0x806044,%eax
  803b3e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b41:	89 50 04             	mov    %edx,0x4(%eax)
  803b44:	eb 08                	jmp    803b4e <realloc_block_FF+0x2b1>
  803b46:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b49:	a3 48 60 80 00       	mov    %eax,0x806048
  803b4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b51:	a3 44 60 80 00       	mov    %eax,0x806044
  803b56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b60:	a1 50 60 80 00       	mov    0x806050,%eax
  803b65:	40                   	inc    %eax
  803b66:	a3 50 60 80 00       	mov    %eax,0x806050
  803b6b:	e9 b0 01 00 00       	jmp    803d20 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b70:	a1 44 60 80 00       	mov    0x806044,%eax
  803b75:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b78:	76 68                	jbe    803be2 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b7a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b7e:	75 17                	jne    803b97 <realloc_block_FF+0x2fa>
  803b80:	83 ec 04             	sub    $0x4,%esp
  803b83:	68 48 4f 80 00       	push   $0x804f48
  803b88:	68 0b 02 00 00       	push   $0x20b
  803b8d:	68 2d 4f 80 00       	push   $0x804f2d
  803b92:	e8 d2 ce ff ff       	call   800a69 <_panic>
  803b97:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803b9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba0:	89 10                	mov    %edx,(%eax)
  803ba2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba5:	8b 00                	mov    (%eax),%eax
  803ba7:	85 c0                	test   %eax,%eax
  803ba9:	74 0d                	je     803bb8 <realloc_block_FF+0x31b>
  803bab:	a1 44 60 80 00       	mov    0x806044,%eax
  803bb0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bb3:	89 50 04             	mov    %edx,0x4(%eax)
  803bb6:	eb 08                	jmp    803bc0 <realloc_block_FF+0x323>
  803bb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bbb:	a3 48 60 80 00       	mov    %eax,0x806048
  803bc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc3:	a3 44 60 80 00       	mov    %eax,0x806044
  803bc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bd2:	a1 50 60 80 00       	mov    0x806050,%eax
  803bd7:	40                   	inc    %eax
  803bd8:	a3 50 60 80 00       	mov    %eax,0x806050
  803bdd:	e9 3e 01 00 00       	jmp    803d20 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803be2:	a1 44 60 80 00       	mov    0x806044,%eax
  803be7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bea:	73 68                	jae    803c54 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803bec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bf0:	75 17                	jne    803c09 <realloc_block_FF+0x36c>
  803bf2:	83 ec 04             	sub    $0x4,%esp
  803bf5:	68 7c 4f 80 00       	push   $0x804f7c
  803bfa:	68 10 02 00 00       	push   $0x210
  803bff:	68 2d 4f 80 00       	push   $0x804f2d
  803c04:	e8 60 ce ff ff       	call   800a69 <_panic>
  803c09:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803c0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c12:	89 50 04             	mov    %edx,0x4(%eax)
  803c15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c18:	8b 40 04             	mov    0x4(%eax),%eax
  803c1b:	85 c0                	test   %eax,%eax
  803c1d:	74 0c                	je     803c2b <realloc_block_FF+0x38e>
  803c1f:	a1 48 60 80 00       	mov    0x806048,%eax
  803c24:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c27:	89 10                	mov    %edx,(%eax)
  803c29:	eb 08                	jmp    803c33 <realloc_block_FF+0x396>
  803c2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2e:	a3 44 60 80 00       	mov    %eax,0x806044
  803c33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c36:	a3 48 60 80 00       	mov    %eax,0x806048
  803c3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c44:	a1 50 60 80 00       	mov    0x806050,%eax
  803c49:	40                   	inc    %eax
  803c4a:	a3 50 60 80 00       	mov    %eax,0x806050
  803c4f:	e9 cc 00 00 00       	jmp    803d20 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c5b:	a1 44 60 80 00       	mov    0x806044,%eax
  803c60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c63:	e9 8a 00 00 00       	jmp    803cf2 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c6e:	73 7a                	jae    803cea <realloc_block_FF+0x44d>
  803c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c73:	8b 00                	mov    (%eax),%eax
  803c75:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c78:	73 70                	jae    803cea <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c7e:	74 06                	je     803c86 <realloc_block_FF+0x3e9>
  803c80:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c84:	75 17                	jne    803c9d <realloc_block_FF+0x400>
  803c86:	83 ec 04             	sub    $0x4,%esp
  803c89:	68 a0 4f 80 00       	push   $0x804fa0
  803c8e:	68 1a 02 00 00       	push   $0x21a
  803c93:	68 2d 4f 80 00       	push   $0x804f2d
  803c98:	e8 cc cd ff ff       	call   800a69 <_panic>
  803c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca0:	8b 10                	mov    (%eax),%edx
  803ca2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca5:	89 10                	mov    %edx,(%eax)
  803ca7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803caa:	8b 00                	mov    (%eax),%eax
  803cac:	85 c0                	test   %eax,%eax
  803cae:	74 0b                	je     803cbb <realloc_block_FF+0x41e>
  803cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb3:	8b 00                	mov    (%eax),%eax
  803cb5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cb8:	89 50 04             	mov    %edx,0x4(%eax)
  803cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cc1:	89 10                	mov    %edx,(%eax)
  803cc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cc9:	89 50 04             	mov    %edx,0x4(%eax)
  803ccc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ccf:	8b 00                	mov    (%eax),%eax
  803cd1:	85 c0                	test   %eax,%eax
  803cd3:	75 08                	jne    803cdd <realloc_block_FF+0x440>
  803cd5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cd8:	a3 48 60 80 00       	mov    %eax,0x806048
  803cdd:	a1 50 60 80 00       	mov    0x806050,%eax
  803ce2:	40                   	inc    %eax
  803ce3:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  803ce8:	eb 36                	jmp    803d20 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803cea:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cf6:	74 07                	je     803cff <realloc_block_FF+0x462>
  803cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfb:	8b 00                	mov    (%eax),%eax
  803cfd:	eb 05                	jmp    803d04 <realloc_block_FF+0x467>
  803cff:	b8 00 00 00 00       	mov    $0x0,%eax
  803d04:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803d09:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803d0e:	85 c0                	test   %eax,%eax
  803d10:	0f 85 52 ff ff ff    	jne    803c68 <realloc_block_FF+0x3cb>
  803d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d1a:	0f 85 48 ff ff ff    	jne    803c68 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d20:	83 ec 04             	sub    $0x4,%esp
  803d23:	6a 00                	push   $0x0
  803d25:	ff 75 d8             	pushl  -0x28(%ebp)
  803d28:	ff 75 d4             	pushl  -0x2c(%ebp)
  803d2b:	e8 7a eb ff ff       	call   8028aa <set_block_data>
  803d30:	83 c4 10             	add    $0x10,%esp
				return va;
  803d33:	8b 45 08             	mov    0x8(%ebp),%eax
  803d36:	e9 7b 02 00 00       	jmp    803fb6 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803d3b:	83 ec 0c             	sub    $0xc,%esp
  803d3e:	68 1d 50 80 00       	push   $0x80501d
  803d43:	e8 de cf ff ff       	call   800d26 <cprintf>
  803d48:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4e:	e9 63 02 00 00       	jmp    803fb6 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d56:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d59:	0f 86 4d 02 00 00    	jbe    803fac <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803d5f:	83 ec 0c             	sub    $0xc,%esp
  803d62:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d65:	e8 08 e8 ff ff       	call   802572 <is_free_block>
  803d6a:	83 c4 10             	add    $0x10,%esp
  803d6d:	84 c0                	test   %al,%al
  803d6f:	0f 84 37 02 00 00    	je     803fac <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d78:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d7b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d7e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d81:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d84:	76 38                	jbe    803dbe <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803d86:	83 ec 0c             	sub    $0xc,%esp
  803d89:	ff 75 08             	pushl  0x8(%ebp)
  803d8c:	e8 0c fa ff ff       	call   80379d <free_block>
  803d91:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d94:	83 ec 0c             	sub    $0xc,%esp
  803d97:	ff 75 0c             	pushl  0xc(%ebp)
  803d9a:	e8 3a eb ff ff       	call   8028d9 <alloc_block_FF>
  803d9f:	83 c4 10             	add    $0x10,%esp
  803da2:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803da5:	83 ec 08             	sub    $0x8,%esp
  803da8:	ff 75 c0             	pushl  -0x40(%ebp)
  803dab:	ff 75 08             	pushl  0x8(%ebp)
  803dae:	e8 ab fa ff ff       	call   80385e <copy_data>
  803db3:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803db6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803db9:	e9 f8 01 00 00       	jmp    803fb6 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803dbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dc1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803dc4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803dc7:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803dcb:	0f 87 a0 00 00 00    	ja     803e71 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803dd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dd5:	75 17                	jne    803dee <realloc_block_FF+0x551>
  803dd7:	83 ec 04             	sub    $0x4,%esp
  803dda:	68 0f 4f 80 00       	push   $0x804f0f
  803ddf:	68 38 02 00 00       	push   $0x238
  803de4:	68 2d 4f 80 00       	push   $0x804f2d
  803de9:	e8 7b cc ff ff       	call   800a69 <_panic>
  803dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df1:	8b 00                	mov    (%eax),%eax
  803df3:	85 c0                	test   %eax,%eax
  803df5:	74 10                	je     803e07 <realloc_block_FF+0x56a>
  803df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dfa:	8b 00                	mov    (%eax),%eax
  803dfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dff:	8b 52 04             	mov    0x4(%edx),%edx
  803e02:	89 50 04             	mov    %edx,0x4(%eax)
  803e05:	eb 0b                	jmp    803e12 <realloc_block_FF+0x575>
  803e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e0a:	8b 40 04             	mov    0x4(%eax),%eax
  803e0d:	a3 48 60 80 00       	mov    %eax,0x806048
  803e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e15:	8b 40 04             	mov    0x4(%eax),%eax
  803e18:	85 c0                	test   %eax,%eax
  803e1a:	74 0f                	je     803e2b <realloc_block_FF+0x58e>
  803e1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e1f:	8b 40 04             	mov    0x4(%eax),%eax
  803e22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e25:	8b 12                	mov    (%edx),%edx
  803e27:	89 10                	mov    %edx,(%eax)
  803e29:	eb 0a                	jmp    803e35 <realloc_block_FF+0x598>
  803e2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2e:	8b 00                	mov    (%eax),%eax
  803e30:	a3 44 60 80 00       	mov    %eax,0x806044
  803e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e48:	a1 50 60 80 00       	mov    0x806050,%eax
  803e4d:	48                   	dec    %eax
  803e4e:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e59:	01 d0                	add    %edx,%eax
  803e5b:	83 ec 04             	sub    $0x4,%esp
  803e5e:	6a 01                	push   $0x1
  803e60:	50                   	push   %eax
  803e61:	ff 75 08             	pushl  0x8(%ebp)
  803e64:	e8 41 ea ff ff       	call   8028aa <set_block_data>
  803e69:	83 c4 10             	add    $0x10,%esp
  803e6c:	e9 36 01 00 00       	jmp    803fa7 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e71:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e74:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e77:	01 d0                	add    %edx,%eax
  803e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e7c:	83 ec 04             	sub    $0x4,%esp
  803e7f:	6a 01                	push   $0x1
  803e81:	ff 75 f0             	pushl  -0x10(%ebp)
  803e84:	ff 75 08             	pushl  0x8(%ebp)
  803e87:	e8 1e ea ff ff       	call   8028aa <set_block_data>
  803e8c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e92:	83 e8 04             	sub    $0x4,%eax
  803e95:	8b 00                	mov    (%eax),%eax
  803e97:	83 e0 fe             	and    $0xfffffffe,%eax
  803e9a:	89 c2                	mov    %eax,%edx
  803e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9f:	01 d0                	add    %edx,%eax
  803ea1:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ea4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ea8:	74 06                	je     803eb0 <realloc_block_FF+0x613>
  803eaa:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803eae:	75 17                	jne    803ec7 <realloc_block_FF+0x62a>
  803eb0:	83 ec 04             	sub    $0x4,%esp
  803eb3:	68 a0 4f 80 00       	push   $0x804fa0
  803eb8:	68 44 02 00 00       	push   $0x244
  803ebd:	68 2d 4f 80 00       	push   $0x804f2d
  803ec2:	e8 a2 cb ff ff       	call   800a69 <_panic>
  803ec7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eca:	8b 10                	mov    (%eax),%edx
  803ecc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ecf:	89 10                	mov    %edx,(%eax)
  803ed1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ed4:	8b 00                	mov    (%eax),%eax
  803ed6:	85 c0                	test   %eax,%eax
  803ed8:	74 0b                	je     803ee5 <realloc_block_FF+0x648>
  803eda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803edd:	8b 00                	mov    (%eax),%eax
  803edf:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ee2:	89 50 04             	mov    %edx,0x4(%eax)
  803ee5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee8:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803eeb:	89 10                	mov    %edx,(%eax)
  803eed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ef0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ef3:	89 50 04             	mov    %edx,0x4(%eax)
  803ef6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ef9:	8b 00                	mov    (%eax),%eax
  803efb:	85 c0                	test   %eax,%eax
  803efd:	75 08                	jne    803f07 <realloc_block_FF+0x66a>
  803eff:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f02:	a3 48 60 80 00       	mov    %eax,0x806048
  803f07:	a1 50 60 80 00       	mov    0x806050,%eax
  803f0c:	40                   	inc    %eax
  803f0d:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f16:	75 17                	jne    803f2f <realloc_block_FF+0x692>
  803f18:	83 ec 04             	sub    $0x4,%esp
  803f1b:	68 0f 4f 80 00       	push   $0x804f0f
  803f20:	68 45 02 00 00       	push   $0x245
  803f25:	68 2d 4f 80 00       	push   $0x804f2d
  803f2a:	e8 3a cb ff ff       	call   800a69 <_panic>
  803f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f32:	8b 00                	mov    (%eax),%eax
  803f34:	85 c0                	test   %eax,%eax
  803f36:	74 10                	je     803f48 <realloc_block_FF+0x6ab>
  803f38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f3b:	8b 00                	mov    (%eax),%eax
  803f3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f40:	8b 52 04             	mov    0x4(%edx),%edx
  803f43:	89 50 04             	mov    %edx,0x4(%eax)
  803f46:	eb 0b                	jmp    803f53 <realloc_block_FF+0x6b6>
  803f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f4b:	8b 40 04             	mov    0x4(%eax),%eax
  803f4e:	a3 48 60 80 00       	mov    %eax,0x806048
  803f53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f56:	8b 40 04             	mov    0x4(%eax),%eax
  803f59:	85 c0                	test   %eax,%eax
  803f5b:	74 0f                	je     803f6c <realloc_block_FF+0x6cf>
  803f5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f60:	8b 40 04             	mov    0x4(%eax),%eax
  803f63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f66:	8b 12                	mov    (%edx),%edx
  803f68:	89 10                	mov    %edx,(%eax)
  803f6a:	eb 0a                	jmp    803f76 <realloc_block_FF+0x6d9>
  803f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f6f:	8b 00                	mov    (%eax),%eax
  803f71:	a3 44 60 80 00       	mov    %eax,0x806044
  803f76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f89:	a1 50 60 80 00       	mov    0x806050,%eax
  803f8e:	48                   	dec    %eax
  803f8f:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  803f94:	83 ec 04             	sub    $0x4,%esp
  803f97:	6a 00                	push   $0x0
  803f99:	ff 75 bc             	pushl  -0x44(%ebp)
  803f9c:	ff 75 b8             	pushl  -0x48(%ebp)
  803f9f:	e8 06 e9 ff ff       	call   8028aa <set_block_data>
  803fa4:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  803faa:	eb 0a                	jmp    803fb6 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803fac:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803fb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803fb6:	c9                   	leave  
  803fb7:	c3                   	ret    

00803fb8 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803fb8:	55                   	push   %ebp
  803fb9:	89 e5                	mov    %esp,%ebp
  803fbb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803fbe:	83 ec 04             	sub    $0x4,%esp
  803fc1:	68 24 50 80 00       	push   $0x805024
  803fc6:	68 58 02 00 00       	push   $0x258
  803fcb:	68 2d 4f 80 00       	push   $0x804f2d
  803fd0:	e8 94 ca ff ff       	call   800a69 <_panic>

00803fd5 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803fd5:	55                   	push   %ebp
  803fd6:	89 e5                	mov    %esp,%ebp
  803fd8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803fdb:	83 ec 04             	sub    $0x4,%esp
  803fde:	68 4c 50 80 00       	push   $0x80504c
  803fe3:	68 61 02 00 00       	push   $0x261
  803fe8:	68 2d 4f 80 00       	push   $0x804f2d
  803fed:	e8 77 ca ff ff       	call   800a69 <_panic>
  803ff2:	66 90                	xchg   %ax,%ax

00803ff4 <__udivdi3>:
  803ff4:	55                   	push   %ebp
  803ff5:	57                   	push   %edi
  803ff6:	56                   	push   %esi
  803ff7:	53                   	push   %ebx
  803ff8:	83 ec 1c             	sub    $0x1c,%esp
  803ffb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803fff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804003:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804007:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80400b:	89 ca                	mov    %ecx,%edx
  80400d:	89 f8                	mov    %edi,%eax
  80400f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804013:	85 f6                	test   %esi,%esi
  804015:	75 2d                	jne    804044 <__udivdi3+0x50>
  804017:	39 cf                	cmp    %ecx,%edi
  804019:	77 65                	ja     804080 <__udivdi3+0x8c>
  80401b:	89 fd                	mov    %edi,%ebp
  80401d:	85 ff                	test   %edi,%edi
  80401f:	75 0b                	jne    80402c <__udivdi3+0x38>
  804021:	b8 01 00 00 00       	mov    $0x1,%eax
  804026:	31 d2                	xor    %edx,%edx
  804028:	f7 f7                	div    %edi
  80402a:	89 c5                	mov    %eax,%ebp
  80402c:	31 d2                	xor    %edx,%edx
  80402e:	89 c8                	mov    %ecx,%eax
  804030:	f7 f5                	div    %ebp
  804032:	89 c1                	mov    %eax,%ecx
  804034:	89 d8                	mov    %ebx,%eax
  804036:	f7 f5                	div    %ebp
  804038:	89 cf                	mov    %ecx,%edi
  80403a:	89 fa                	mov    %edi,%edx
  80403c:	83 c4 1c             	add    $0x1c,%esp
  80403f:	5b                   	pop    %ebx
  804040:	5e                   	pop    %esi
  804041:	5f                   	pop    %edi
  804042:	5d                   	pop    %ebp
  804043:	c3                   	ret    
  804044:	39 ce                	cmp    %ecx,%esi
  804046:	77 28                	ja     804070 <__udivdi3+0x7c>
  804048:	0f bd fe             	bsr    %esi,%edi
  80404b:	83 f7 1f             	xor    $0x1f,%edi
  80404e:	75 40                	jne    804090 <__udivdi3+0x9c>
  804050:	39 ce                	cmp    %ecx,%esi
  804052:	72 0a                	jb     80405e <__udivdi3+0x6a>
  804054:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804058:	0f 87 9e 00 00 00    	ja     8040fc <__udivdi3+0x108>
  80405e:	b8 01 00 00 00       	mov    $0x1,%eax
  804063:	89 fa                	mov    %edi,%edx
  804065:	83 c4 1c             	add    $0x1c,%esp
  804068:	5b                   	pop    %ebx
  804069:	5e                   	pop    %esi
  80406a:	5f                   	pop    %edi
  80406b:	5d                   	pop    %ebp
  80406c:	c3                   	ret    
  80406d:	8d 76 00             	lea    0x0(%esi),%esi
  804070:	31 ff                	xor    %edi,%edi
  804072:	31 c0                	xor    %eax,%eax
  804074:	89 fa                	mov    %edi,%edx
  804076:	83 c4 1c             	add    $0x1c,%esp
  804079:	5b                   	pop    %ebx
  80407a:	5e                   	pop    %esi
  80407b:	5f                   	pop    %edi
  80407c:	5d                   	pop    %ebp
  80407d:	c3                   	ret    
  80407e:	66 90                	xchg   %ax,%ax
  804080:	89 d8                	mov    %ebx,%eax
  804082:	f7 f7                	div    %edi
  804084:	31 ff                	xor    %edi,%edi
  804086:	89 fa                	mov    %edi,%edx
  804088:	83 c4 1c             	add    $0x1c,%esp
  80408b:	5b                   	pop    %ebx
  80408c:	5e                   	pop    %esi
  80408d:	5f                   	pop    %edi
  80408e:	5d                   	pop    %ebp
  80408f:	c3                   	ret    
  804090:	bd 20 00 00 00       	mov    $0x20,%ebp
  804095:	89 eb                	mov    %ebp,%ebx
  804097:	29 fb                	sub    %edi,%ebx
  804099:	89 f9                	mov    %edi,%ecx
  80409b:	d3 e6                	shl    %cl,%esi
  80409d:	89 c5                	mov    %eax,%ebp
  80409f:	88 d9                	mov    %bl,%cl
  8040a1:	d3 ed                	shr    %cl,%ebp
  8040a3:	89 e9                	mov    %ebp,%ecx
  8040a5:	09 f1                	or     %esi,%ecx
  8040a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040ab:	89 f9                	mov    %edi,%ecx
  8040ad:	d3 e0                	shl    %cl,%eax
  8040af:	89 c5                	mov    %eax,%ebp
  8040b1:	89 d6                	mov    %edx,%esi
  8040b3:	88 d9                	mov    %bl,%cl
  8040b5:	d3 ee                	shr    %cl,%esi
  8040b7:	89 f9                	mov    %edi,%ecx
  8040b9:	d3 e2                	shl    %cl,%edx
  8040bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040bf:	88 d9                	mov    %bl,%cl
  8040c1:	d3 e8                	shr    %cl,%eax
  8040c3:	09 c2                	or     %eax,%edx
  8040c5:	89 d0                	mov    %edx,%eax
  8040c7:	89 f2                	mov    %esi,%edx
  8040c9:	f7 74 24 0c          	divl   0xc(%esp)
  8040cd:	89 d6                	mov    %edx,%esi
  8040cf:	89 c3                	mov    %eax,%ebx
  8040d1:	f7 e5                	mul    %ebp
  8040d3:	39 d6                	cmp    %edx,%esi
  8040d5:	72 19                	jb     8040f0 <__udivdi3+0xfc>
  8040d7:	74 0b                	je     8040e4 <__udivdi3+0xf0>
  8040d9:	89 d8                	mov    %ebx,%eax
  8040db:	31 ff                	xor    %edi,%edi
  8040dd:	e9 58 ff ff ff       	jmp    80403a <__udivdi3+0x46>
  8040e2:	66 90                	xchg   %ax,%ax
  8040e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040e8:	89 f9                	mov    %edi,%ecx
  8040ea:	d3 e2                	shl    %cl,%edx
  8040ec:	39 c2                	cmp    %eax,%edx
  8040ee:	73 e9                	jae    8040d9 <__udivdi3+0xe5>
  8040f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040f3:	31 ff                	xor    %edi,%edi
  8040f5:	e9 40 ff ff ff       	jmp    80403a <__udivdi3+0x46>
  8040fa:	66 90                	xchg   %ax,%ax
  8040fc:	31 c0                	xor    %eax,%eax
  8040fe:	e9 37 ff ff ff       	jmp    80403a <__udivdi3+0x46>
  804103:	90                   	nop

00804104 <__umoddi3>:
  804104:	55                   	push   %ebp
  804105:	57                   	push   %edi
  804106:	56                   	push   %esi
  804107:	53                   	push   %ebx
  804108:	83 ec 1c             	sub    $0x1c,%esp
  80410b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80410f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804113:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804117:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80411b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80411f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804123:	89 f3                	mov    %esi,%ebx
  804125:	89 fa                	mov    %edi,%edx
  804127:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80412b:	89 34 24             	mov    %esi,(%esp)
  80412e:	85 c0                	test   %eax,%eax
  804130:	75 1a                	jne    80414c <__umoddi3+0x48>
  804132:	39 f7                	cmp    %esi,%edi
  804134:	0f 86 a2 00 00 00    	jbe    8041dc <__umoddi3+0xd8>
  80413a:	89 c8                	mov    %ecx,%eax
  80413c:	89 f2                	mov    %esi,%edx
  80413e:	f7 f7                	div    %edi
  804140:	89 d0                	mov    %edx,%eax
  804142:	31 d2                	xor    %edx,%edx
  804144:	83 c4 1c             	add    $0x1c,%esp
  804147:	5b                   	pop    %ebx
  804148:	5e                   	pop    %esi
  804149:	5f                   	pop    %edi
  80414a:	5d                   	pop    %ebp
  80414b:	c3                   	ret    
  80414c:	39 f0                	cmp    %esi,%eax
  80414e:	0f 87 ac 00 00 00    	ja     804200 <__umoddi3+0xfc>
  804154:	0f bd e8             	bsr    %eax,%ebp
  804157:	83 f5 1f             	xor    $0x1f,%ebp
  80415a:	0f 84 ac 00 00 00    	je     80420c <__umoddi3+0x108>
  804160:	bf 20 00 00 00       	mov    $0x20,%edi
  804165:	29 ef                	sub    %ebp,%edi
  804167:	89 fe                	mov    %edi,%esi
  804169:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80416d:	89 e9                	mov    %ebp,%ecx
  80416f:	d3 e0                	shl    %cl,%eax
  804171:	89 d7                	mov    %edx,%edi
  804173:	89 f1                	mov    %esi,%ecx
  804175:	d3 ef                	shr    %cl,%edi
  804177:	09 c7                	or     %eax,%edi
  804179:	89 e9                	mov    %ebp,%ecx
  80417b:	d3 e2                	shl    %cl,%edx
  80417d:	89 14 24             	mov    %edx,(%esp)
  804180:	89 d8                	mov    %ebx,%eax
  804182:	d3 e0                	shl    %cl,%eax
  804184:	89 c2                	mov    %eax,%edx
  804186:	8b 44 24 08          	mov    0x8(%esp),%eax
  80418a:	d3 e0                	shl    %cl,%eax
  80418c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804190:	8b 44 24 08          	mov    0x8(%esp),%eax
  804194:	89 f1                	mov    %esi,%ecx
  804196:	d3 e8                	shr    %cl,%eax
  804198:	09 d0                	or     %edx,%eax
  80419a:	d3 eb                	shr    %cl,%ebx
  80419c:	89 da                	mov    %ebx,%edx
  80419e:	f7 f7                	div    %edi
  8041a0:	89 d3                	mov    %edx,%ebx
  8041a2:	f7 24 24             	mull   (%esp)
  8041a5:	89 c6                	mov    %eax,%esi
  8041a7:	89 d1                	mov    %edx,%ecx
  8041a9:	39 d3                	cmp    %edx,%ebx
  8041ab:	0f 82 87 00 00 00    	jb     804238 <__umoddi3+0x134>
  8041b1:	0f 84 91 00 00 00    	je     804248 <__umoddi3+0x144>
  8041b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041bb:	29 f2                	sub    %esi,%edx
  8041bd:	19 cb                	sbb    %ecx,%ebx
  8041bf:	89 d8                	mov    %ebx,%eax
  8041c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041c5:	d3 e0                	shl    %cl,%eax
  8041c7:	89 e9                	mov    %ebp,%ecx
  8041c9:	d3 ea                	shr    %cl,%edx
  8041cb:	09 d0                	or     %edx,%eax
  8041cd:	89 e9                	mov    %ebp,%ecx
  8041cf:	d3 eb                	shr    %cl,%ebx
  8041d1:	89 da                	mov    %ebx,%edx
  8041d3:	83 c4 1c             	add    $0x1c,%esp
  8041d6:	5b                   	pop    %ebx
  8041d7:	5e                   	pop    %esi
  8041d8:	5f                   	pop    %edi
  8041d9:	5d                   	pop    %ebp
  8041da:	c3                   	ret    
  8041db:	90                   	nop
  8041dc:	89 fd                	mov    %edi,%ebp
  8041de:	85 ff                	test   %edi,%edi
  8041e0:	75 0b                	jne    8041ed <__umoddi3+0xe9>
  8041e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8041e7:	31 d2                	xor    %edx,%edx
  8041e9:	f7 f7                	div    %edi
  8041eb:	89 c5                	mov    %eax,%ebp
  8041ed:	89 f0                	mov    %esi,%eax
  8041ef:	31 d2                	xor    %edx,%edx
  8041f1:	f7 f5                	div    %ebp
  8041f3:	89 c8                	mov    %ecx,%eax
  8041f5:	f7 f5                	div    %ebp
  8041f7:	89 d0                	mov    %edx,%eax
  8041f9:	e9 44 ff ff ff       	jmp    804142 <__umoddi3+0x3e>
  8041fe:	66 90                	xchg   %ax,%ax
  804200:	89 c8                	mov    %ecx,%eax
  804202:	89 f2                	mov    %esi,%edx
  804204:	83 c4 1c             	add    $0x1c,%esp
  804207:	5b                   	pop    %ebx
  804208:	5e                   	pop    %esi
  804209:	5f                   	pop    %edi
  80420a:	5d                   	pop    %ebp
  80420b:	c3                   	ret    
  80420c:	3b 04 24             	cmp    (%esp),%eax
  80420f:	72 06                	jb     804217 <__umoddi3+0x113>
  804211:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804215:	77 0f                	ja     804226 <__umoddi3+0x122>
  804217:	89 f2                	mov    %esi,%edx
  804219:	29 f9                	sub    %edi,%ecx
  80421b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80421f:	89 14 24             	mov    %edx,(%esp)
  804222:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804226:	8b 44 24 04          	mov    0x4(%esp),%eax
  80422a:	8b 14 24             	mov    (%esp),%edx
  80422d:	83 c4 1c             	add    $0x1c,%esp
  804230:	5b                   	pop    %ebx
  804231:	5e                   	pop    %esi
  804232:	5f                   	pop    %edi
  804233:	5d                   	pop    %ebp
  804234:	c3                   	ret    
  804235:	8d 76 00             	lea    0x0(%esi),%esi
  804238:	2b 04 24             	sub    (%esp),%eax
  80423b:	19 fa                	sbb    %edi,%edx
  80423d:	89 d1                	mov    %edx,%ecx
  80423f:	89 c6                	mov    %eax,%esi
  804241:	e9 71 ff ff ff       	jmp    8041b7 <__umoddi3+0xb3>
  804246:	66 90                	xchg   %ax,%ax
  804248:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80424c:	72 ea                	jb     804238 <__umoddi3+0x134>
  80424e:	89 d9                	mov    %ebx,%ecx
  804250:	e9 62 ff ff ff       	jmp    8041b7 <__umoddi3+0xb3>
