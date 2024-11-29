
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
  800055:	68 20 44 80 00       	push   $0x804420
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
  8000a5:	68 50 44 80 00       	push   $0x804450
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
  8000d1:	e8 28 25 00 00       	call   8025fe <sys_set_uheap_strategy>
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
  8000f6:	68 89 44 80 00       	push   $0x804489
  8000fb:	6a 26                	push   $0x26
  8000fd:	68 a5 44 80 00       	push   $0x8044a5
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
  800123:	e8 23 21 00 00       	call   80224b <sys_pf_calculate_allocated_pages>
  800128:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 d0 20 00 00       	call   802200 <sys_calculate_free_frames>
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
  80013d:	68 bc 44 80 00       	push   $0x8044bc
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
  8002ac:	68 14 45 80 00       	push   $0x804514
  8002b1:	6a 69                	push   $0x69
  8002b3:	68 a5 44 80 00       	push   $0x8044a5
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
  800328:	68 3c 45 80 00       	push   $0x80453c
  80032d:	e8 f4 09 00 00       	call   800d26 <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800335:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80033b:	83 e8 08             	sub    $0x8,%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	6a 01                	push   $0x1
  800343:	50                   	push   %eax
  800344:	e8 f7 23 00 00       	call   802740 <alloc_block>
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
  800392:	68 60 45 80 00       	push   $0x804560
  800397:	68 80 00 00 00       	push   $0x80
  80039c:	68 a5 44 80 00       	push   $0x8044a5
  8003a1:	e8 c3 06 00 00       	call   800a69 <_panic>
		}
	}

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 88 45 80 00       	push   $0x804588
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
  800451:	68 d0 45 80 00       	push   $0x8045d0
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
  80046e:	68 f0 45 80 00       	push   $0x8045f0
  800473:	e8 ae 08 00 00       	call   800d26 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp

	uint32 testSizes[numOfFFTests] =
  80047b:	8d 85 2c ff ff ff    	lea    -0xd4(%ebp),%eax
  800481:	bb b4 49 80 00       	mov    $0x8049b4,%ebx
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
  8005a7:	68 4c 46 80 00       	push   $0x80464c
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
  80060a:	e8 fa 20 00 00       	call   802709 <get_block_size>
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
  800627:	68 7c 46 80 00       	push   $0x80467c
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
  800641:	68 48 47 80 00       	push   $0x804748
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
  800714:	68 94 47 80 00       	push   $0x804794
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
  80074f:	68 c0 47 80 00       	push   $0x8047c0
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
  800808:	68 f4 47 80 00       	push   $0x8047f4
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
  800831:	68 58 48 80 00       	push   $0x804858
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
  8008a8:	68 78 48 80 00       	push   $0x804878
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
  8008f7:	68 e8 48 80 00       	push   $0x8048e8
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
  800914:	68 6c 49 80 00       	push   $0x80496c
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
  800930:	e8 94 1a 00 00       	call   8023c9 <sys_getenvindex>
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
  80099e:	e8 aa 17 00 00       	call   80214d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8009a3:	83 ec 0c             	sub    $0xc,%esp
  8009a6:	68 d8 49 80 00       	push   $0x8049d8
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
  8009ce:	68 00 4a 80 00       	push   $0x804a00
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
  8009ff:	68 28 4a 80 00       	push   $0x804a28
  800a04:	e8 1d 03 00 00       	call   800d26 <cprintf>
  800a09:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a0c:	a1 20 60 80 00       	mov    0x806020,%eax
  800a11:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	50                   	push   %eax
  800a1b:	68 80 4a 80 00       	push   $0x804a80
  800a20:	e8 01 03 00 00       	call   800d26 <cprintf>
  800a25:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	68 d8 49 80 00       	push   $0x8049d8
  800a30:	e8 f1 02 00 00       	call   800d26 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800a38:	e8 2a 17 00 00       	call   802167 <sys_unlock_cons>
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
  800a50:	e8 40 19 00 00       	call   802395 <sys_destroy_env>
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
  800a61:	e8 95 19 00 00       	call   8023fb <sys_exit_env>
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
  800a8a:	68 94 4a 80 00       	push   $0x804a94
  800a8f:	e8 92 02 00 00       	call   800d26 <cprintf>
  800a94:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a97:	a1 1c 60 80 00       	mov    0x80601c,%eax
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	ff 75 08             	pushl  0x8(%ebp)
  800aa2:	50                   	push   %eax
  800aa3:	68 99 4a 80 00       	push   $0x804a99
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
  800ac7:	68 b5 4a 80 00       	push   $0x804ab5
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
  800af6:	68 b8 4a 80 00       	push   $0x804ab8
  800afb:	6a 26                	push   $0x26
  800afd:	68 04 4b 80 00       	push   $0x804b04
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
  800bcb:	68 10 4b 80 00       	push   $0x804b10
  800bd0:	6a 3a                	push   $0x3a
  800bd2:	68 04 4b 80 00       	push   $0x804b04
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
  800c3e:	68 64 4b 80 00       	push   $0x804b64
  800c43:	6a 44                	push   $0x44
  800c45:	68 04 4b 80 00       	push   $0x804b04
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
  800c98:	e8 6e 14 00 00       	call   80210b <sys_cputs>
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
  800d0f:	e8 f7 13 00 00       	call   80210b <sys_cputs>
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
  800d59:	e8 ef 13 00 00       	call   80214d <sys_lock_cons>
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
  800d79:	e8 e9 13 00 00       	call   802167 <sys_unlock_cons>
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
  800dc3:	e8 dc 33 00 00       	call   8041a4 <__udivdi3>
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
  800e13:	e8 9c 34 00 00       	call   8042b4 <__umoddi3>
  800e18:	83 c4 10             	add    $0x10,%esp
  800e1b:	05 d4 4d 80 00       	add    $0x804dd4,%eax
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
  800f6e:	8b 04 85 f8 4d 80 00 	mov    0x804df8(,%eax,4),%eax
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
  80104f:	8b 34 9d 40 4c 80 00 	mov    0x804c40(,%ebx,4),%esi
  801056:	85 f6                	test   %esi,%esi
  801058:	75 19                	jne    801073 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80105a:	53                   	push   %ebx
  80105b:	68 e5 4d 80 00       	push   $0x804de5
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
  801074:	68 ee 4d 80 00       	push   $0x804dee
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
  8010a1:	be f1 4d 80 00       	mov    $0x804df1,%esi
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
  801aac:	68 68 4f 80 00       	push   $0x804f68
  801ab1:	68 3f 01 00 00       	push   $0x13f
  801ab6:	68 8a 4f 80 00       	push   $0x804f8a
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
  801acc:	e8 e5 0b 00 00       	call   8026b6 <sys_sbrk>
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
  801b47:	e8 ee 09 00 00       	call   80253a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	74 16                	je     801b66 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	e8 2e 0f 00 00       	call   802a89 <alloc_block_FF>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b61:	e9 8a 01 00 00       	jmp    801cf0 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b66:	e8 00 0a 00 00       	call   80256b <sys_isUHeapPlacementStrategyBESTFIT>
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	0f 84 7d 01 00 00    	je     801cf0 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	e8 c7 13 00 00       	call   802f45 <alloc_block_BF>
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
  801bc9:	8b 04 85 60 e2 08 01 	mov    0x108e260(,%eax,4),%eax
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
  801c16:	8b 04 85 60 e2 08 01 	mov    0x108e260(,%eax,4),%eax
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
  801c6d:	c7 04 85 60 e2 08 01 	movl   $0x1,0x108e260(,%eax,4)
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
  801ccf:	89 04 95 60 e2 10 01 	mov    %eax,0x110e260(,%edx,4)
		sys_allocate_user_mem(i, size);
  801cd6:	83 ec 08             	sub    $0x8,%esp
  801cd9:	ff 75 08             	pushl  0x8(%ebp)
  801cdc:	ff 75 f0             	pushl  -0x10(%ebp)
  801cdf:	e8 09 0a 00 00       	call   8026ed <sys_allocate_user_mem>
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
  801d27:	e8 dd 09 00 00       	call   802709 <get_block_size>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 10 1c 00 00       	call   80394d <free_block>
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
  801d72:	8b 04 85 60 e2 10 01 	mov    0x110e260(,%eax,4),%eax
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
  801daf:	c7 04 85 60 e2 08 01 	movl   $0x0,0x108e260(,%eax,4)
  801db6:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801dba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	83 ec 08             	sub    $0x8,%esp
  801dc3:	52                   	push   %edx
  801dc4:	50                   	push   %eax
  801dc5:	e8 07 09 00 00       	call   8026d1 <sys_free_user_mem>
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
  801ddd:	68 98 4f 80 00       	push   $0x804f98
  801de2:	68 88 00 00 00       	push   $0x88
  801de7:	68 c2 4f 80 00       	push   $0x804fc2
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
  801e0b:	e9 ec 00 00 00       	jmp    801efc <smalloc+0x108>
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
  801e3c:	75 0a                	jne    801e48 <smalloc+0x54>
  801e3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e43:	e9 b4 00 00 00       	jmp    801efc <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e48:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e4c:	ff 75 ec             	pushl  -0x14(%ebp)
  801e4f:	50                   	push   %eax
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	ff 75 08             	pushl  0x8(%ebp)
  801e56:	e8 7d 04 00 00       	call   8022d8 <sys_createSharedObject>
  801e5b:	83 c4 10             	add    $0x10,%esp
  801e5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e61:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e65:	74 06                	je     801e6d <smalloc+0x79>
  801e67:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e6b:	75 0a                	jne    801e77 <smalloc+0x83>
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e72:	e9 85 00 00 00       	jmp    801efc <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801e77:	83 ec 08             	sub    $0x8,%esp
  801e7a:	ff 75 ec             	pushl  -0x14(%ebp)
  801e7d:	68 ce 4f 80 00       	push   $0x804fce
  801e82:	e8 9f ee ff ff       	call   800d26 <cprintf>
  801e87:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801e8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e8d:	a1 20 60 80 00       	mov    0x806020,%eax
  801e92:	8b 40 78             	mov    0x78(%eax),%eax
  801e95:	29 c2                	sub    %eax,%edx
  801e97:	89 d0                	mov    %edx,%eax
  801e99:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e9e:	c1 e8 0c             	shr    $0xc,%eax
  801ea1:	8b 15 24 60 80 00    	mov    0x806024,%edx
  801ea7:	42                   	inc    %edx
  801ea8:	89 15 24 60 80 00    	mov    %edx,0x806024
  801eae:	8b 15 24 60 80 00    	mov    0x806024,%edx
  801eb4:	89 14 85 60 e2 00 01 	mov    %edx,0x100e260(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ebe:	a1 20 60 80 00       	mov    0x806020,%eax
  801ec3:	8b 40 78             	mov    0x78(%eax),%eax
  801ec6:	29 c2                	sub    %eax,%edx
  801ec8:	89 d0                	mov    %edx,%eax
  801eca:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ecf:	c1 e8 0c             	shr    $0xc,%eax
  801ed2:	8b 0c 85 60 e2 00 01 	mov    0x100e260(,%eax,4),%ecx
  801ed9:	a1 20 60 80 00       	mov    0x806020,%eax
  801ede:	8b 50 10             	mov    0x10(%eax),%edx
  801ee1:	89 c8                	mov    %ecx,%eax
  801ee3:	c1 e0 02             	shl    $0x2,%eax
  801ee6:	89 c1                	mov    %eax,%ecx
  801ee8:	c1 e1 09             	shl    $0x9,%ecx
  801eeb:	01 c8                	add    %ecx,%eax
  801eed:	01 c2                	add    %eax,%edx
  801eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ef2:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	 return ptr;
  801ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f04:	83 ec 08             	sub    $0x8,%esp
  801f07:	ff 75 0c             	pushl  0xc(%ebp)
  801f0a:	ff 75 08             	pushl  0x8(%ebp)
  801f0d:	e8 f0 03 00 00       	call   802302 <sys_getSizeOfSharedObject>
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801f18:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f1c:	75 0a                	jne    801f28 <sget+0x2a>
  801f1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f23:	e9 e7 00 00 00       	jmp    80200f <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f2e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f35:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3b:	39 d0                	cmp    %edx,%eax
  801f3d:	73 02                	jae    801f41 <sget+0x43>
  801f3f:	89 d0                	mov    %edx,%eax
  801f41:	83 ec 0c             	sub    $0xc,%esp
  801f44:	50                   	push   %eax
  801f45:	e8 8c fb ff ff       	call   801ad6 <malloc>
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801f50:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f54:	75 0a                	jne    801f60 <sget+0x62>
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5b:	e9 af 00 00 00       	jmp    80200f <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f60:	83 ec 04             	sub    $0x4,%esp
  801f63:	ff 75 e8             	pushl  -0x18(%ebp)
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	e8 ae 03 00 00       	call   80231f <sys_getSharedObject>
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801f77:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f7a:	a1 20 60 80 00       	mov    0x806020,%eax
  801f7f:	8b 40 78             	mov    0x78(%eax),%eax
  801f82:	29 c2                	sub    %eax,%edx
  801f84:	89 d0                	mov    %edx,%eax
  801f86:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f8b:	c1 e8 0c             	shr    $0xc,%eax
  801f8e:	8b 15 24 60 80 00    	mov    0x806024,%edx
  801f94:	42                   	inc    %edx
  801f95:	89 15 24 60 80 00    	mov    %edx,0x806024
  801f9b:	8b 15 24 60 80 00    	mov    0x806024,%edx
  801fa1:	89 14 85 60 e2 00 01 	mov    %edx,0x100e260(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801fa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fab:	a1 20 60 80 00       	mov    0x806020,%eax
  801fb0:	8b 40 78             	mov    0x78(%eax),%eax
  801fb3:	29 c2                	sub    %eax,%edx
  801fb5:	89 d0                	mov    %edx,%eax
  801fb7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fbc:	c1 e8 0c             	shr    $0xc,%eax
  801fbf:	8b 0c 85 60 e2 00 01 	mov    0x100e260(,%eax,4),%ecx
  801fc6:	a1 20 60 80 00       	mov    0x806020,%eax
  801fcb:	8b 50 10             	mov    0x10(%eax),%edx
  801fce:	89 c8                	mov    %ecx,%eax
  801fd0:	c1 e0 02             	shl    $0x2,%eax
  801fd3:	89 c1                	mov    %eax,%ecx
  801fd5:	c1 e1 09             	shl    $0x9,%ecx
  801fd8:	01 c8                	add    %ecx,%eax
  801fda:	01 c2                	add    %eax,%edx
  801fdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fdf:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801fe6:	a1 20 60 80 00       	mov    0x806020,%eax
  801feb:	8b 40 10             	mov    0x10(%eax),%eax
  801fee:	83 ec 08             	sub    $0x8,%esp
  801ff1:	50                   	push   %eax
  801ff2:	68 dd 4f 80 00       	push   $0x804fdd
  801ff7:	e8 2a ed ff ff       	call   800d26 <cprintf>
  801ffc:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801fff:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802003:	75 07                	jne    80200c <sget+0x10e>
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
  80200a:	eb 03                	jmp    80200f <sget+0x111>
	return ptr;
  80200c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  802017:	8b 55 08             	mov    0x8(%ebp),%edx
  80201a:	a1 20 60 80 00       	mov    0x806020,%eax
  80201f:	8b 40 78             	mov    0x78(%eax),%eax
  802022:	29 c2                	sub    %eax,%edx
  802024:	89 d0                	mov    %edx,%eax
  802026:	2d 00 10 00 00       	sub    $0x1000,%eax
  80202b:	c1 e8 0c             	shr    $0xc,%eax
  80202e:	8b 0c 85 60 e2 00 01 	mov    0x100e260(,%eax,4),%ecx
  802035:	a1 20 60 80 00       	mov    0x806020,%eax
  80203a:	8b 50 10             	mov    0x10(%eax),%edx
  80203d:	89 c8                	mov    %ecx,%eax
  80203f:	c1 e0 02             	shl    $0x2,%eax
  802042:	89 c1                	mov    %eax,%ecx
  802044:	c1 e1 09             	shl    $0x9,%ecx
  802047:	01 c8                	add    %ecx,%eax
  802049:	01 d0                	add    %edx,%eax
  80204b:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
  802052:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802055:	83 ec 08             	sub    $0x8,%esp
  802058:	ff 75 08             	pushl  0x8(%ebp)
  80205b:	ff 75 f4             	pushl  -0xc(%ebp)
  80205e:	e8 db 02 00 00       	call   80233e <sys_freeSharedObject>
  802063:	83 c4 10             	add    $0x10,%esp
  802066:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802069:	90                   	nop
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802072:	83 ec 04             	sub    $0x4,%esp
  802075:	68 ec 4f 80 00       	push   $0x804fec
  80207a:	68 e5 00 00 00       	push   $0xe5
  80207f:	68 c2 4f 80 00       	push   $0x804fc2
  802084:	e8 e0 e9 ff ff       	call   800a69 <_panic>

00802089 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80208f:	83 ec 04             	sub    $0x4,%esp
  802092:	68 12 50 80 00       	push   $0x805012
  802097:	68 f1 00 00 00       	push   $0xf1
  80209c:	68 c2 4f 80 00       	push   $0x804fc2
  8020a1:	e8 c3 e9 ff ff       	call   800a69 <_panic>

008020a6 <shrink>:

}
void shrink(uint32 newSize)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020ac:	83 ec 04             	sub    $0x4,%esp
  8020af:	68 12 50 80 00       	push   $0x805012
  8020b4:	68 f6 00 00 00       	push   $0xf6
  8020b9:	68 c2 4f 80 00       	push   $0x804fc2
  8020be:	e8 a6 e9 ff ff       	call   800a69 <_panic>

008020c3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	68 12 50 80 00       	push   $0x805012
  8020d1:	68 fb 00 00 00       	push   $0xfb
  8020d6:	68 c2 4f 80 00       	push   $0x804fc2
  8020db:	e8 89 e9 ff ff       	call   800a69 <_panic>

008020e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	57                   	push   %edi
  8020e4:	56                   	push   %esi
  8020e5:	53                   	push   %ebx
  8020e6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020f5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020f8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020fb:	cd 30                	int    $0x30
  8020fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802100:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	5b                   	pop    %ebx
  802107:	5e                   	pop    %esi
  802108:	5f                   	pop    %edi
  802109:	5d                   	pop    %ebp
  80210a:	c3                   	ret    

0080210b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 04             	sub    $0x4,%esp
  802111:	8b 45 10             	mov    0x10(%ebp),%eax
  802114:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802117:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	52                   	push   %edx
  802123:	ff 75 0c             	pushl  0xc(%ebp)
  802126:	50                   	push   %eax
  802127:	6a 00                	push   $0x0
  802129:	e8 b2 ff ff ff       	call   8020e0 <syscall>
  80212e:	83 c4 18             	add    $0x18,%esp
}
  802131:	90                   	nop
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <sys_cgetc>:

int
sys_cgetc(void)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 02                	push   $0x2
  802143:	e8 98 ff ff ff       	call   8020e0 <syscall>
  802148:	83 c4 18             	add    $0x18,%esp
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 03                	push   $0x3
  80215c:	e8 7f ff ff ff       	call   8020e0 <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
}
  802164:	90                   	nop
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 04                	push   $0x4
  802176:	e8 65 ff ff ff       	call   8020e0 <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	90                   	nop
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802184:	8b 55 0c             	mov    0xc(%ebp),%edx
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	52                   	push   %edx
  802191:	50                   	push   %eax
  802192:	6a 08                	push   $0x8
  802194:	e8 47 ff ff ff       	call   8020e0 <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	56                   	push   %esi
  8021a2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8021a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
  8021b4:	51                   	push   %ecx
  8021b5:	52                   	push   %edx
  8021b6:	50                   	push   %eax
  8021b7:	6a 09                	push   $0x9
  8021b9:	e8 22 ff ff ff       	call   8020e0 <syscall>
  8021be:	83 c4 18             	add    $0x18,%esp
}
  8021c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c4:	5b                   	pop    %ebx
  8021c5:	5e                   	pop    %esi
  8021c6:	5d                   	pop    %ebp
  8021c7:	c3                   	ret    

008021c8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	52                   	push   %edx
  8021d8:	50                   	push   %eax
  8021d9:	6a 0a                	push   $0xa
  8021db:	e8 00 ff ff ff       	call   8020e0 <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	ff 75 0c             	pushl  0xc(%ebp)
  8021f1:	ff 75 08             	pushl  0x8(%ebp)
  8021f4:	6a 0b                	push   $0xb
  8021f6:	e8 e5 fe ff ff       	call   8020e0 <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 0c                	push   $0xc
  80220f:	e8 cc fe ff ff       	call   8020e0 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 0d                	push   $0xd
  802228:	e8 b3 fe ff ff       	call   8020e0 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 0e                	push   $0xe
  802241:	e8 9a fe ff ff       	call   8020e0 <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 0f                	push   $0xf
  80225a:	e8 81 fe ff ff       	call   8020e0 <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	ff 75 08             	pushl  0x8(%ebp)
  802272:	6a 10                	push   $0x10
  802274:	e8 67 fe ff ff       	call   8020e0 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 11                	push   $0x11
  80228d:	e8 4e fe ff ff       	call   8020e0 <syscall>
  802292:	83 c4 18             	add    $0x18,%esp
}
  802295:	90                   	nop
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <sys_cputc>:

void
sys_cputc(const char c)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	83 ec 04             	sub    $0x4,%esp
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022a4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	50                   	push   %eax
  8022b1:	6a 01                	push   $0x1
  8022b3:	e8 28 fe ff ff       	call   8020e0 <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
}
  8022bb:	90                   	nop
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 14                	push   $0x14
  8022cd:	e8 0e fe ff ff       	call   8020e0 <syscall>
  8022d2:	83 c4 18             	add    $0x18,%esp
}
  8022d5:	90                   	nop
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022e4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	6a 00                	push   $0x0
  8022f0:	51                   	push   %ecx
  8022f1:	52                   	push   %edx
  8022f2:	ff 75 0c             	pushl  0xc(%ebp)
  8022f5:	50                   	push   %eax
  8022f6:	6a 15                	push   $0x15
  8022f8:	e8 e3 fd ff ff       	call   8020e0 <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802305:	8b 55 0c             	mov    0xc(%ebp),%edx
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	52                   	push   %edx
  802312:	50                   	push   %eax
  802313:	6a 16                	push   $0x16
  802315:	e8 c6 fd ff ff       	call   8020e0 <syscall>
  80231a:	83 c4 18             	add    $0x18,%esp
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802322:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802325:	8b 55 0c             	mov    0xc(%ebp),%edx
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	51                   	push   %ecx
  802330:	52                   	push   %edx
  802331:	50                   	push   %eax
  802332:	6a 17                	push   $0x17
  802334:	e8 a7 fd ff ff       	call   8020e0 <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802341:	8b 55 0c             	mov    0xc(%ebp),%edx
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	52                   	push   %edx
  80234e:	50                   	push   %eax
  80234f:	6a 18                	push   $0x18
  802351:	e8 8a fd ff ff       	call   8020e0 <syscall>
  802356:	83 c4 18             	add    $0x18,%esp
}
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	6a 00                	push   $0x0
  802363:	ff 75 14             	pushl  0x14(%ebp)
  802366:	ff 75 10             	pushl  0x10(%ebp)
  802369:	ff 75 0c             	pushl  0xc(%ebp)
  80236c:	50                   	push   %eax
  80236d:	6a 19                	push   $0x19
  80236f:	e8 6c fd ff ff       	call   8020e0 <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	50                   	push   %eax
  802388:	6a 1a                	push   $0x1a
  80238a:	e8 51 fd ff ff       	call   8020e0 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
}
  802392:	90                   	nop
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	50                   	push   %eax
  8023a4:	6a 1b                	push   $0x1b
  8023a6:	e8 35 fd ff ff       	call   8020e0 <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 05                	push   $0x5
  8023bf:	e8 1c fd ff ff       	call   8020e0 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 06                	push   $0x6
  8023d8:	e8 03 fd ff ff       	call   8020e0 <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 07                	push   $0x7
  8023f1:	e8 ea fc ff ff       	call   8020e0 <syscall>
  8023f6:	83 c4 18             	add    $0x18,%esp
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <sys_exit_env>:


void sys_exit_env(void)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 1c                	push   $0x1c
  80240a:	e8 d1 fc ff ff       	call   8020e0 <syscall>
  80240f:	83 c4 18             	add    $0x18,%esp
}
  802412:	90                   	nop
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80241b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80241e:	8d 50 04             	lea    0x4(%eax),%edx
  802421:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	52                   	push   %edx
  80242b:	50                   	push   %eax
  80242c:	6a 1d                	push   $0x1d
  80242e:	e8 ad fc ff ff       	call   8020e0 <syscall>
  802433:	83 c4 18             	add    $0x18,%esp
	return result;
  802436:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802439:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80243c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80243f:	89 01                	mov    %eax,(%ecx)
  802441:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	c9                   	leave  
  802448:	c2 04 00             	ret    $0x4

0080244b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	ff 75 10             	pushl  0x10(%ebp)
  802455:	ff 75 0c             	pushl  0xc(%ebp)
  802458:	ff 75 08             	pushl  0x8(%ebp)
  80245b:	6a 13                	push   $0x13
  80245d:	e8 7e fc ff ff       	call   8020e0 <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
	return ;
  802465:	90                   	nop
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <sys_rcr2>:
uint32 sys_rcr2()
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 1e                	push   $0x1e
  802477:	e8 64 fc ff ff       	call   8020e0 <syscall>
  80247c:	83 c4 18             	add    $0x18,%esp
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 04             	sub    $0x4,%esp
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80248d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	50                   	push   %eax
  80249a:	6a 1f                	push   $0x1f
  80249c:	e8 3f fc ff ff       	call   8020e0 <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a4:	90                   	nop
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <rsttst>:
void rsttst()
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 21                	push   $0x21
  8024b6:	e8 25 fc ff ff       	call   8020e0 <syscall>
  8024bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8024be:	90                   	nop
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	83 ec 04             	sub    $0x4,%esp
  8024c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024cd:	8b 55 18             	mov    0x18(%ebp),%edx
  8024d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024d4:	52                   	push   %edx
  8024d5:	50                   	push   %eax
  8024d6:	ff 75 10             	pushl  0x10(%ebp)
  8024d9:	ff 75 0c             	pushl  0xc(%ebp)
  8024dc:	ff 75 08             	pushl  0x8(%ebp)
  8024df:	6a 20                	push   $0x20
  8024e1:	e8 fa fb ff ff       	call   8020e0 <syscall>
  8024e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e9:	90                   	nop
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <chktst>:
void chktst(uint32 n)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	ff 75 08             	pushl  0x8(%ebp)
  8024fa:	6a 22                	push   $0x22
  8024fc:	e8 df fb ff ff       	call   8020e0 <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
	return ;
  802504:	90                   	nop
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <inctst>:

void inctst()
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 23                	push   $0x23
  802516:	e8 c5 fb ff ff       	call   8020e0 <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
	return ;
  80251e:	90                   	nop
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <gettst>:
uint32 gettst()
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 24                	push   $0x24
  802530:	e8 ab fb ff ff       	call   8020e0 <syscall>
  802535:	83 c4 18             	add    $0x18,%esp
}
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 25                	push   $0x25
  80254c:	e8 8f fb ff ff       	call   8020e0 <syscall>
  802551:	83 c4 18             	add    $0x18,%esp
  802554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802557:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80255b:	75 07                	jne    802564 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80255d:	b8 01 00 00 00       	mov    $0x1,%eax
  802562:	eb 05                	jmp    802569 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802564:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 25                	push   $0x25
  80257d:	e8 5e fb ff ff       	call   8020e0 <syscall>
  802582:	83 c4 18             	add    $0x18,%esp
  802585:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802588:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80258c:	75 07                	jne    802595 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80258e:	b8 01 00 00 00       	mov    $0x1,%eax
  802593:	eb 05                	jmp    80259a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802595:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259a:	c9                   	leave  
  80259b:	c3                   	ret    

0080259c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
  80259f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 25                	push   $0x25
  8025ae:	e8 2d fb ff ff       	call   8020e0 <syscall>
  8025b3:	83 c4 18             	add    $0x18,%esp
  8025b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025b9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025bd:	75 07                	jne    8025c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c4:	eb 05                	jmp    8025cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
  8025d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 25                	push   $0x25
  8025df:	e8 fc fa ff ff       	call   8020e0 <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
  8025e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025ea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025ee:	75 07                	jne    8025f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f5:	eb 05                	jmp    8025fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	ff 75 08             	pushl  0x8(%ebp)
  80260c:	6a 26                	push   $0x26
  80260e:	e8 cd fa ff ff       	call   8020e0 <syscall>
  802613:	83 c4 18             	add    $0x18,%esp
	return ;
  802616:	90                   	nop
}
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
  80261c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80261d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802620:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802623:	8b 55 0c             	mov    0xc(%ebp),%edx
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	6a 00                	push   $0x0
  80262b:	53                   	push   %ebx
  80262c:	51                   	push   %ecx
  80262d:	52                   	push   %edx
  80262e:	50                   	push   %eax
  80262f:	6a 27                	push   $0x27
  802631:	e8 aa fa ff ff       	call   8020e0 <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
}
  802639:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802641:	8b 55 0c             	mov    0xc(%ebp),%edx
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	52                   	push   %edx
  80264e:	50                   	push   %eax
  80264f:	6a 28                	push   $0x28
  802651:	e8 8a fa ff ff       	call   8020e0 <syscall>
  802656:	83 c4 18             	add    $0x18,%esp
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80265e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802661:	8b 55 0c             	mov    0xc(%ebp),%edx
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	6a 00                	push   $0x0
  802669:	51                   	push   %ecx
  80266a:	ff 75 10             	pushl  0x10(%ebp)
  80266d:	52                   	push   %edx
  80266e:	50                   	push   %eax
  80266f:	6a 29                	push   $0x29
  802671:	e8 6a fa ff ff       	call   8020e0 <syscall>
  802676:	83 c4 18             	add    $0x18,%esp
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	ff 75 10             	pushl  0x10(%ebp)
  802685:	ff 75 0c             	pushl  0xc(%ebp)
  802688:	ff 75 08             	pushl  0x8(%ebp)
  80268b:	6a 12                	push   $0x12
  80268d:	e8 4e fa ff ff       	call   8020e0 <syscall>
  802692:	83 c4 18             	add    $0x18,%esp
	return ;
  802695:	90                   	nop
}
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80269b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	52                   	push   %edx
  8026a8:	50                   	push   %eax
  8026a9:	6a 2a                	push   $0x2a
  8026ab:	e8 30 fa ff ff       	call   8020e0 <syscall>
  8026b0:	83 c4 18             	add    $0x18,%esp
	return;
  8026b3:	90                   	nop
}
  8026b4:	c9                   	leave  
  8026b5:	c3                   	ret    

008026b6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	50                   	push   %eax
  8026c5:	6a 2b                	push   $0x2b
  8026c7:	e8 14 fa ff ff       	call   8020e0 <syscall>
  8026cc:	83 c4 18             	add    $0x18,%esp
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	ff 75 0c             	pushl  0xc(%ebp)
  8026dd:	ff 75 08             	pushl  0x8(%ebp)
  8026e0:	6a 2c                	push   $0x2c
  8026e2:	e8 f9 f9 ff ff       	call   8020e0 <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
	return;
  8026ea:	90                   	nop
}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	ff 75 0c             	pushl  0xc(%ebp)
  8026f9:	ff 75 08             	pushl  0x8(%ebp)
  8026fc:	6a 2d                	push   $0x2d
  8026fe:	e8 dd f9 ff ff       	call   8020e0 <syscall>
  802703:	83 c4 18             	add    $0x18,%esp
	return;
  802706:	90                   	nop
}
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	83 e8 04             	sub    $0x4,%eax
  802715:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802718:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802728:	8b 45 08             	mov    0x8(%ebp),%eax
  80272b:	83 e8 04             	sub    $0x4,%eax
  80272e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802731:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802734:	8b 00                	mov    (%eax),%eax
  802736:	83 e0 01             	and    $0x1,%eax
  802739:	85 c0                	test   %eax,%eax
  80273b:	0f 94 c0             	sete   %al
}
  80273e:	c9                   	leave  
  80273f:	c3                   	ret    

00802740 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802740:	55                   	push   %ebp
  802741:	89 e5                	mov    %esp,%ebp
  802743:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802746:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80274d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802750:	83 f8 02             	cmp    $0x2,%eax
  802753:	74 2b                	je     802780 <alloc_block+0x40>
  802755:	83 f8 02             	cmp    $0x2,%eax
  802758:	7f 07                	jg     802761 <alloc_block+0x21>
  80275a:	83 f8 01             	cmp    $0x1,%eax
  80275d:	74 0e                	je     80276d <alloc_block+0x2d>
  80275f:	eb 58                	jmp    8027b9 <alloc_block+0x79>
  802761:	83 f8 03             	cmp    $0x3,%eax
  802764:	74 2d                	je     802793 <alloc_block+0x53>
  802766:	83 f8 04             	cmp    $0x4,%eax
  802769:	74 3b                	je     8027a6 <alloc_block+0x66>
  80276b:	eb 4c                	jmp    8027b9 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80276d:	83 ec 0c             	sub    $0xc,%esp
  802770:	ff 75 08             	pushl  0x8(%ebp)
  802773:	e8 11 03 00 00       	call   802a89 <alloc_block_FF>
  802778:	83 c4 10             	add    $0x10,%esp
  80277b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80277e:	eb 4a                	jmp    8027ca <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802780:	83 ec 0c             	sub    $0xc,%esp
  802783:	ff 75 08             	pushl  0x8(%ebp)
  802786:	e8 fa 19 00 00       	call   804185 <alloc_block_NF>
  80278b:	83 c4 10             	add    $0x10,%esp
  80278e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802791:	eb 37                	jmp    8027ca <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802793:	83 ec 0c             	sub    $0xc,%esp
  802796:	ff 75 08             	pushl  0x8(%ebp)
  802799:	e8 a7 07 00 00       	call   802f45 <alloc_block_BF>
  80279e:	83 c4 10             	add    $0x10,%esp
  8027a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027a4:	eb 24                	jmp    8027ca <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027a6:	83 ec 0c             	sub    $0xc,%esp
  8027a9:	ff 75 08             	pushl  0x8(%ebp)
  8027ac:	e8 b7 19 00 00       	call   804168 <alloc_block_WF>
  8027b1:	83 c4 10             	add    $0x10,%esp
  8027b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027b7:	eb 11                	jmp    8027ca <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8027b9:	83 ec 0c             	sub    $0xc,%esp
  8027bc:	68 24 50 80 00       	push   $0x805024
  8027c1:	e8 60 e5 ff ff       	call   800d26 <cprintf>
  8027c6:	83 c4 10             	add    $0x10,%esp
		break;
  8027c9:	90                   	nop
	}
	return va;
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027cd:	c9                   	leave  
  8027ce:	c3                   	ret    

008027cf <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027cf:	55                   	push   %ebp
  8027d0:	89 e5                	mov    %esp,%ebp
  8027d2:	53                   	push   %ebx
  8027d3:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8027d6:	83 ec 0c             	sub    $0xc,%esp
  8027d9:	68 44 50 80 00       	push   $0x805044
  8027de:	e8 43 e5 ff ff       	call   800d26 <cprintf>
  8027e3:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8027e6:	83 ec 0c             	sub    $0xc,%esp
  8027e9:	68 6f 50 80 00       	push   $0x80506f
  8027ee:	e8 33 e5 ff ff       	call   800d26 <cprintf>
  8027f3:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fc:	eb 37                	jmp    802835 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8027fe:	83 ec 0c             	sub    $0xc,%esp
  802801:	ff 75 f4             	pushl  -0xc(%ebp)
  802804:	e8 19 ff ff ff       	call   802722 <is_free_block>
  802809:	83 c4 10             	add    $0x10,%esp
  80280c:	0f be d8             	movsbl %al,%ebx
  80280f:	83 ec 0c             	sub    $0xc,%esp
  802812:	ff 75 f4             	pushl  -0xc(%ebp)
  802815:	e8 ef fe ff ff       	call   802709 <get_block_size>
  80281a:	83 c4 10             	add    $0x10,%esp
  80281d:	83 ec 04             	sub    $0x4,%esp
  802820:	53                   	push   %ebx
  802821:	50                   	push   %eax
  802822:	68 87 50 80 00       	push   $0x805087
  802827:	e8 fa e4 ff ff       	call   800d26 <cprintf>
  80282c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80282f:	8b 45 10             	mov    0x10(%ebp),%eax
  802832:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802839:	74 07                	je     802842 <print_blocks_list+0x73>
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 00                	mov    (%eax),%eax
  802840:	eb 05                	jmp    802847 <print_blocks_list+0x78>
  802842:	b8 00 00 00 00       	mov    $0x0,%eax
  802847:	89 45 10             	mov    %eax,0x10(%ebp)
  80284a:	8b 45 10             	mov    0x10(%ebp),%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	75 ad                	jne    8027fe <print_blocks_list+0x2f>
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	75 a7                	jne    8027fe <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802857:	83 ec 0c             	sub    $0xc,%esp
  80285a:	68 44 50 80 00       	push   $0x805044
  80285f:	e8 c2 e4 ff ff       	call   800d26 <cprintf>
  802864:	83 c4 10             	add    $0x10,%esp

}
  802867:	90                   	nop
  802868:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80286b:	c9                   	leave  
  80286c:	c3                   	ret    

0080286d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80286d:	55                   	push   %ebp
  80286e:	89 e5                	mov    %esp,%ebp
  802870:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802873:	8b 45 0c             	mov    0xc(%ebp),%eax
  802876:	83 e0 01             	and    $0x1,%eax
  802879:	85 c0                	test   %eax,%eax
  80287b:	74 03                	je     802880 <initialize_dynamic_allocator+0x13>
  80287d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802880:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802884:	0f 84 c7 01 00 00    	je     802a51 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80288a:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  802891:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802894:	8b 55 08             	mov    0x8(%ebp),%edx
  802897:	8b 45 0c             	mov    0xc(%ebp),%eax
  80289a:	01 d0                	add    %edx,%eax
  80289c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8028a1:	0f 87 ad 01 00 00    	ja     802a54 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8028a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	0f 89 a5 01 00 00    	jns    802a57 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8028b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b8:	01 d0                	add    %edx,%eax
  8028ba:	83 e8 04             	sub    $0x4,%eax
  8028bd:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  8028c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8028c9:	a1 44 60 80 00       	mov    0x806044,%eax
  8028ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d1:	e9 87 00 00 00       	jmp    80295d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8028d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028da:	75 14                	jne    8028f0 <initialize_dynamic_allocator+0x83>
  8028dc:	83 ec 04             	sub    $0x4,%esp
  8028df:	68 9f 50 80 00       	push   $0x80509f
  8028e4:	6a 79                	push   $0x79
  8028e6:	68 bd 50 80 00       	push   $0x8050bd
  8028eb:	e8 79 e1 ff ff       	call   800a69 <_panic>
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 10                	je     802909 <initialize_dynamic_allocator+0x9c>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802901:	8b 52 04             	mov    0x4(%edx),%edx
  802904:	89 50 04             	mov    %edx,0x4(%eax)
  802907:	eb 0b                	jmp    802914 <initialize_dynamic_allocator+0xa7>
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 40 04             	mov    0x4(%eax),%eax
  80290f:	a3 48 60 80 00       	mov    %eax,0x806048
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 40 04             	mov    0x4(%eax),%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	74 0f                	je     80292d <initialize_dynamic_allocator+0xc0>
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802927:	8b 12                	mov    (%edx),%edx
  802929:	89 10                	mov    %edx,(%eax)
  80292b:	eb 0a                	jmp    802937 <initialize_dynamic_allocator+0xca>
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 00                	mov    (%eax),%eax
  802932:	a3 44 60 80 00       	mov    %eax,0x806044
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294a:	a1 50 60 80 00       	mov    0x806050,%eax
  80294f:	48                   	dec    %eax
  802950:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802955:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80295a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802961:	74 07                	je     80296a <initialize_dynamic_allocator+0xfd>
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	eb 05                	jmp    80296f <initialize_dynamic_allocator+0x102>
  80296a:	b8 00 00 00 00       	mov    $0x0,%eax
  80296f:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802974:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	0f 85 55 ff ff ff    	jne    8028d6 <initialize_dynamic_allocator+0x69>
  802981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802985:	0f 85 4b ff ff ff    	jne    8028d6 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802994:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80299a:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  80299f:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  8029a4:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8029a9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	83 c0 08             	add    $0x8,%eax
  8029b5:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	83 c0 04             	add    $0x4,%eax
  8029be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c1:	83 ea 08             	sub    $0x8,%edx
  8029c4:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	01 d0                	add    %edx,%eax
  8029ce:	83 e8 08             	sub    $0x8,%eax
  8029d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d4:	83 ea 08             	sub    $0x8,%edx
  8029d7:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8029d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8029ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029f0:	75 17                	jne    802a09 <initialize_dynamic_allocator+0x19c>
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	68 d8 50 80 00       	push   $0x8050d8
  8029fa:	68 90 00 00 00       	push   $0x90
  8029ff:	68 bd 50 80 00       	push   $0x8050bd
  802a04:	e8 60 e0 ff ff       	call   800a69 <_panic>
  802a09:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a12:	89 10                	mov    %edx,(%eax)
  802a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	74 0d                	je     802a2a <initialize_dynamic_allocator+0x1bd>
  802a1d:	a1 44 60 80 00       	mov    0x806044,%eax
  802a22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a25:	89 50 04             	mov    %edx,0x4(%eax)
  802a28:	eb 08                	jmp    802a32 <initialize_dynamic_allocator+0x1c5>
  802a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2d:	a3 48 60 80 00       	mov    %eax,0x806048
  802a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a35:	a3 44 60 80 00       	mov    %eax,0x806044
  802a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a44:	a1 50 60 80 00       	mov    0x806050,%eax
  802a49:	40                   	inc    %eax
  802a4a:	a3 50 60 80 00       	mov    %eax,0x806050
  802a4f:	eb 07                	jmp    802a58 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802a51:	90                   	nop
  802a52:	eb 04                	jmp    802a58 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802a54:	90                   	nop
  802a55:	eb 01                	jmp    802a58 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a57:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a58:	c9                   	leave  
  802a59:	c3                   	ret    

00802a5a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a5a:	55                   	push   %ebp
  802a5b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a5d:	8b 45 10             	mov    0x10(%ebp),%eax
  802a60:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a6c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	83 e8 04             	sub    $0x4,%eax
  802a74:	8b 00                	mov    (%eax),%eax
  802a76:	83 e0 fe             	and    $0xfffffffe,%eax
  802a79:	8d 50 f8             	lea    -0x8(%eax),%edx
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	01 c2                	add    %eax,%edx
  802a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a84:	89 02                	mov    %eax,(%edx)
}
  802a86:	90                   	nop
  802a87:	5d                   	pop    %ebp
  802a88:	c3                   	ret    

00802a89 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
  802a8c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	83 e0 01             	and    $0x1,%eax
  802a95:	85 c0                	test   %eax,%eax
  802a97:	74 03                	je     802a9c <alloc_block_FF+0x13>
  802a99:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a9c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802aa0:	77 07                	ja     802aa9 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802aa2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802aa9:	a1 28 60 80 00       	mov    0x806028,%eax
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	75 73                	jne    802b25 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	83 c0 10             	add    $0x10,%eax
  802ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802abb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802ac2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac8:	01 d0                	add    %edx,%eax
  802aca:	48                   	dec    %eax
  802acb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad6:	f7 75 ec             	divl   -0x14(%ebp)
  802ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802adc:	29 d0                	sub    %edx,%eax
  802ade:	c1 e8 0c             	shr    $0xc,%eax
  802ae1:	83 ec 0c             	sub    $0xc,%esp
  802ae4:	50                   	push   %eax
  802ae5:	e8 d6 ef ff ff       	call   801ac0 <sbrk>
  802aea:	83 c4 10             	add    $0x10,%esp
  802aed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802af0:	83 ec 0c             	sub    $0xc,%esp
  802af3:	6a 00                	push   $0x0
  802af5:	e8 c6 ef ff ff       	call   801ac0 <sbrk>
  802afa:	83 c4 10             	add    $0x10,%esp
  802afd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b03:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802b06:	83 ec 08             	sub    $0x8,%esp
  802b09:	50                   	push   %eax
  802b0a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b0d:	e8 5b fd ff ff       	call   80286d <initialize_dynamic_allocator>
  802b12:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b15:	83 ec 0c             	sub    $0xc,%esp
  802b18:	68 fb 50 80 00       	push   $0x8050fb
  802b1d:	e8 04 e2 ff ff       	call   800d26 <cprintf>
  802b22:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802b25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b29:	75 0a                	jne    802b35 <alloc_block_FF+0xac>
	        return NULL;
  802b2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b30:	e9 0e 04 00 00       	jmp    802f43 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802b35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b3c:	a1 44 60 80 00       	mov    0x806044,%eax
  802b41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b44:	e9 f3 02 00 00       	jmp    802e3c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802b4f:	83 ec 0c             	sub    $0xc,%esp
  802b52:	ff 75 bc             	pushl  -0x44(%ebp)
  802b55:	e8 af fb ff ff       	call   802709 <get_block_size>
  802b5a:	83 c4 10             	add    $0x10,%esp
  802b5d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	83 c0 08             	add    $0x8,%eax
  802b66:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b69:	0f 87 c5 02 00 00    	ja     802e34 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	83 c0 18             	add    $0x18,%eax
  802b75:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b78:	0f 87 19 02 00 00    	ja     802d97 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802b7e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b81:	2b 45 08             	sub    0x8(%ebp),%eax
  802b84:	83 e8 08             	sub    $0x8,%eax
  802b87:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	8d 50 08             	lea    0x8(%eax),%edx
  802b90:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b93:	01 d0                	add    %edx,%eax
  802b95:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	83 c0 08             	add    $0x8,%eax
  802b9e:	83 ec 04             	sub    $0x4,%esp
  802ba1:	6a 01                	push   $0x1
  802ba3:	50                   	push   %eax
  802ba4:	ff 75 bc             	pushl  -0x44(%ebp)
  802ba7:	e8 ae fe ff ff       	call   802a5a <set_block_data>
  802bac:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 40 04             	mov    0x4(%eax),%eax
  802bb5:	85 c0                	test   %eax,%eax
  802bb7:	75 68                	jne    802c21 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bb9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bbd:	75 17                	jne    802bd6 <alloc_block_FF+0x14d>
  802bbf:	83 ec 04             	sub    $0x4,%esp
  802bc2:	68 d8 50 80 00       	push   $0x8050d8
  802bc7:	68 d7 00 00 00       	push   $0xd7
  802bcc:	68 bd 50 80 00       	push   $0x8050bd
  802bd1:	e8 93 de ff ff       	call   800a69 <_panic>
  802bd6:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802bdc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bdf:	89 10                	mov    %edx,(%eax)
  802be1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be4:	8b 00                	mov    (%eax),%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	74 0d                	je     802bf7 <alloc_block_FF+0x16e>
  802bea:	a1 44 60 80 00       	mov    0x806044,%eax
  802bef:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bf2:	89 50 04             	mov    %edx,0x4(%eax)
  802bf5:	eb 08                	jmp    802bff <alloc_block_FF+0x176>
  802bf7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bfa:	a3 48 60 80 00       	mov    %eax,0x806048
  802bff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c02:	a3 44 60 80 00       	mov    %eax,0x806044
  802c07:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c11:	a1 50 60 80 00       	mov    0x806050,%eax
  802c16:	40                   	inc    %eax
  802c17:	a3 50 60 80 00       	mov    %eax,0x806050
  802c1c:	e9 dc 00 00 00       	jmp    802cfd <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	75 65                	jne    802c8f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c2a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c2e:	75 17                	jne    802c47 <alloc_block_FF+0x1be>
  802c30:	83 ec 04             	sub    $0x4,%esp
  802c33:	68 0c 51 80 00       	push   $0x80510c
  802c38:	68 db 00 00 00       	push   $0xdb
  802c3d:	68 bd 50 80 00       	push   $0x8050bd
  802c42:	e8 22 de ff ff       	call   800a69 <_panic>
  802c47:	8b 15 48 60 80 00    	mov    0x806048,%edx
  802c4d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c50:	89 50 04             	mov    %edx,0x4(%eax)
  802c53:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c56:	8b 40 04             	mov    0x4(%eax),%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	74 0c                	je     802c69 <alloc_block_FF+0x1e0>
  802c5d:	a1 48 60 80 00       	mov    0x806048,%eax
  802c62:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c65:	89 10                	mov    %edx,(%eax)
  802c67:	eb 08                	jmp    802c71 <alloc_block_FF+0x1e8>
  802c69:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c6c:	a3 44 60 80 00       	mov    %eax,0x806044
  802c71:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c74:	a3 48 60 80 00       	mov    %eax,0x806048
  802c79:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c82:	a1 50 60 80 00       	mov    0x806050,%eax
  802c87:	40                   	inc    %eax
  802c88:	a3 50 60 80 00       	mov    %eax,0x806050
  802c8d:	eb 6e                	jmp    802cfd <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802c8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c93:	74 06                	je     802c9b <alloc_block_FF+0x212>
  802c95:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c99:	75 17                	jne    802cb2 <alloc_block_FF+0x229>
  802c9b:	83 ec 04             	sub    $0x4,%esp
  802c9e:	68 30 51 80 00       	push   $0x805130
  802ca3:	68 df 00 00 00       	push   $0xdf
  802ca8:	68 bd 50 80 00       	push   $0x8050bd
  802cad:	e8 b7 dd ff ff       	call   800a69 <_panic>
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 10                	mov    (%eax),%edx
  802cb7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cba:	89 10                	mov    %edx,(%eax)
  802cbc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	85 c0                	test   %eax,%eax
  802cc3:	74 0b                	je     802cd0 <alloc_block_FF+0x247>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ccd:	89 50 04             	mov    %edx,0x4(%eax)
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cd6:	89 10                	mov    %edx,(%eax)
  802cd8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cde:	89 50 04             	mov    %edx,0x4(%eax)
  802ce1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	75 08                	jne    802cf2 <alloc_block_FF+0x269>
  802cea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ced:	a3 48 60 80 00       	mov    %eax,0x806048
  802cf2:	a1 50 60 80 00       	mov    0x806050,%eax
  802cf7:	40                   	inc    %eax
  802cf8:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802cfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d01:	75 17                	jne    802d1a <alloc_block_FF+0x291>
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	68 9f 50 80 00       	push   $0x80509f
  802d0b:	68 e1 00 00 00       	push   $0xe1
  802d10:	68 bd 50 80 00       	push   $0x8050bd
  802d15:	e8 4f dd ff ff       	call   800a69 <_panic>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 10                	je     802d33 <alloc_block_FF+0x2aa>
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2b:	8b 52 04             	mov    0x4(%edx),%edx
  802d2e:	89 50 04             	mov    %edx,0x4(%eax)
  802d31:	eb 0b                	jmp    802d3e <alloc_block_FF+0x2b5>
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	a3 48 60 80 00       	mov    %eax,0x806048
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	74 0f                	je     802d57 <alloc_block_FF+0x2ce>
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d51:	8b 12                	mov    (%edx),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	eb 0a                	jmp    802d61 <alloc_block_FF+0x2d8>
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	a3 44 60 80 00       	mov    %eax,0x806044
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d74:	a1 50 60 80 00       	mov    0x806050,%eax
  802d79:	48                   	dec    %eax
  802d7a:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  802d7f:	83 ec 04             	sub    $0x4,%esp
  802d82:	6a 00                	push   $0x0
  802d84:	ff 75 b4             	pushl  -0x4c(%ebp)
  802d87:	ff 75 b0             	pushl  -0x50(%ebp)
  802d8a:	e8 cb fc ff ff       	call   802a5a <set_block_data>
  802d8f:	83 c4 10             	add    $0x10,%esp
  802d92:	e9 95 00 00 00       	jmp    802e2c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802d97:	83 ec 04             	sub    $0x4,%esp
  802d9a:	6a 01                	push   $0x1
  802d9c:	ff 75 b8             	pushl  -0x48(%ebp)
  802d9f:	ff 75 bc             	pushl  -0x44(%ebp)
  802da2:	e8 b3 fc ff ff       	call   802a5a <set_block_data>
  802da7:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802daa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dae:	75 17                	jne    802dc7 <alloc_block_FF+0x33e>
  802db0:	83 ec 04             	sub    $0x4,%esp
  802db3:	68 9f 50 80 00       	push   $0x80509f
  802db8:	68 e8 00 00 00       	push   $0xe8
  802dbd:	68 bd 50 80 00       	push   $0x8050bd
  802dc2:	e8 a2 dc ff ff       	call   800a69 <_panic>
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 00                	mov    (%eax),%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	74 10                	je     802de0 <alloc_block_FF+0x357>
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd8:	8b 52 04             	mov    0x4(%edx),%edx
  802ddb:	89 50 04             	mov    %edx,0x4(%eax)
  802dde:	eb 0b                	jmp    802deb <alloc_block_FF+0x362>
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	8b 40 04             	mov    0x4(%eax),%eax
  802de6:	a3 48 60 80 00       	mov    %eax,0x806048
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	8b 40 04             	mov    0x4(%eax),%eax
  802df1:	85 c0                	test   %eax,%eax
  802df3:	74 0f                	je     802e04 <alloc_block_FF+0x37b>
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	8b 40 04             	mov    0x4(%eax),%eax
  802dfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dfe:	8b 12                	mov    (%edx),%edx
  802e00:	89 10                	mov    %edx,(%eax)
  802e02:	eb 0a                	jmp    802e0e <alloc_block_FF+0x385>
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	8b 00                	mov    (%eax),%eax
  802e09:	a3 44 60 80 00       	mov    %eax,0x806044
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e21:	a1 50 60 80 00       	mov    0x806050,%eax
  802e26:	48                   	dec    %eax
  802e27:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  802e2c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e2f:	e9 0f 01 00 00       	jmp    802f43 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802e34:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e40:	74 07                	je     802e49 <alloc_block_FF+0x3c0>
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 00                	mov    (%eax),%eax
  802e47:	eb 05                	jmp    802e4e <alloc_block_FF+0x3c5>
  802e49:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4e:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802e53:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802e58:	85 c0                	test   %eax,%eax
  802e5a:	0f 85 e9 fc ff ff    	jne    802b49 <alloc_block_FF+0xc0>
  802e60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e64:	0f 85 df fc ff ff    	jne    802b49 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	83 c0 08             	add    $0x8,%eax
  802e70:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e73:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e7a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e80:	01 d0                	add    %edx,%eax
  802e82:	48                   	dec    %eax
  802e83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e89:	ba 00 00 00 00       	mov    $0x0,%edx
  802e8e:	f7 75 d8             	divl   -0x28(%ebp)
  802e91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e94:	29 d0                	sub    %edx,%eax
  802e96:	c1 e8 0c             	shr    $0xc,%eax
  802e99:	83 ec 0c             	sub    $0xc,%esp
  802e9c:	50                   	push   %eax
  802e9d:	e8 1e ec ff ff       	call   801ac0 <sbrk>
  802ea2:	83 c4 10             	add    $0x10,%esp
  802ea5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802ea8:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802eac:	75 0a                	jne    802eb8 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802eae:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb3:	e9 8b 00 00 00       	jmp    802f43 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802eb8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ebf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ec2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ec5:	01 d0                	add    %edx,%eax
  802ec7:	48                   	dec    %eax
  802ec8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802ecb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ece:	ba 00 00 00 00       	mov    $0x0,%edx
  802ed3:	f7 75 cc             	divl   -0x34(%ebp)
  802ed6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ed9:	29 d0                	sub    %edx,%eax
  802edb:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ede:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ee1:	01 d0                	add    %edx,%eax
  802ee3:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  802ee8:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802eed:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ef3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802efa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802efd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f00:	01 d0                	add    %edx,%eax
  802f02:	48                   	dec    %eax
  802f03:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f06:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f09:	ba 00 00 00 00       	mov    $0x0,%edx
  802f0e:	f7 75 c4             	divl   -0x3c(%ebp)
  802f11:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f14:	29 d0                	sub    %edx,%eax
  802f16:	83 ec 04             	sub    $0x4,%esp
  802f19:	6a 01                	push   $0x1
  802f1b:	50                   	push   %eax
  802f1c:	ff 75 d0             	pushl  -0x30(%ebp)
  802f1f:	e8 36 fb ff ff       	call   802a5a <set_block_data>
  802f24:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802f27:	83 ec 0c             	sub    $0xc,%esp
  802f2a:	ff 75 d0             	pushl  -0x30(%ebp)
  802f2d:	e8 1b 0a 00 00       	call   80394d <free_block>
  802f32:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802f35:	83 ec 0c             	sub    $0xc,%esp
  802f38:	ff 75 08             	pushl  0x8(%ebp)
  802f3b:	e8 49 fb ff ff       	call   802a89 <alloc_block_FF>
  802f40:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802f43:	c9                   	leave  
  802f44:	c3                   	ret    

00802f45 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802f45:	55                   	push   %ebp
  802f46:	89 e5                	mov    %esp,%ebp
  802f48:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	83 e0 01             	and    $0x1,%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 03                	je     802f58 <alloc_block_BF+0x13>
  802f55:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f58:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f5c:	77 07                	ja     802f65 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f5e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f65:	a1 28 60 80 00       	mov    0x806028,%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	75 73                	jne    802fe1 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	83 c0 10             	add    $0x10,%eax
  802f74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f77:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802f7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f84:	01 d0                	add    %edx,%eax
  802f86:	48                   	dec    %eax
  802f87:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8d:	ba 00 00 00 00       	mov    $0x0,%edx
  802f92:	f7 75 e0             	divl   -0x20(%ebp)
  802f95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f98:	29 d0                	sub    %edx,%eax
  802f9a:	c1 e8 0c             	shr    $0xc,%eax
  802f9d:	83 ec 0c             	sub    $0xc,%esp
  802fa0:	50                   	push   %eax
  802fa1:	e8 1a eb ff ff       	call   801ac0 <sbrk>
  802fa6:	83 c4 10             	add    $0x10,%esp
  802fa9:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802fac:	83 ec 0c             	sub    $0xc,%esp
  802faf:	6a 00                	push   $0x0
  802fb1:	e8 0a eb ff ff       	call   801ac0 <sbrk>
  802fb6:	83 c4 10             	add    $0x10,%esp
  802fb9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802fbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fbf:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802fc2:	83 ec 08             	sub    $0x8,%esp
  802fc5:	50                   	push   %eax
  802fc6:	ff 75 d8             	pushl  -0x28(%ebp)
  802fc9:	e8 9f f8 ff ff       	call   80286d <initialize_dynamic_allocator>
  802fce:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802fd1:	83 ec 0c             	sub    $0xc,%esp
  802fd4:	68 fb 50 80 00       	push   $0x8050fb
  802fd9:	e8 48 dd ff ff       	call   800d26 <cprintf>
  802fde:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802fe1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802fe8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802fef:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802ff6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802ffd:	a1 44 60 80 00       	mov    0x806044,%eax
  803002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803005:	e9 1d 01 00 00       	jmp    803127 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803010:	83 ec 0c             	sub    $0xc,%esp
  803013:	ff 75 a8             	pushl  -0x58(%ebp)
  803016:	e8 ee f6 ff ff       	call   802709 <get_block_size>
  80301b:	83 c4 10             	add    $0x10,%esp
  80301e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	83 c0 08             	add    $0x8,%eax
  803027:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80302a:	0f 87 ef 00 00 00    	ja     80311f <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	83 c0 18             	add    $0x18,%eax
  803036:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803039:	77 1d                	ja     803058 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80303b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803041:	0f 86 d8 00 00 00    	jbe    80311f <alloc_block_BF+0x1da>
				{
					best_va = va;
  803047:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80304a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80304d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803050:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803053:	e9 c7 00 00 00       	jmp    80311f <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	83 c0 08             	add    $0x8,%eax
  80305e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803061:	0f 85 9d 00 00 00    	jne    803104 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803067:	83 ec 04             	sub    $0x4,%esp
  80306a:	6a 01                	push   $0x1
  80306c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80306f:	ff 75 a8             	pushl  -0x58(%ebp)
  803072:	e8 e3 f9 ff ff       	call   802a5a <set_block_data>
  803077:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80307a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307e:	75 17                	jne    803097 <alloc_block_BF+0x152>
  803080:	83 ec 04             	sub    $0x4,%esp
  803083:	68 9f 50 80 00       	push   $0x80509f
  803088:	68 2c 01 00 00       	push   $0x12c
  80308d:	68 bd 50 80 00       	push   $0x8050bd
  803092:	e8 d2 d9 ff ff       	call   800a69 <_panic>
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	74 10                	je     8030b0 <alloc_block_BF+0x16b>
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a8:	8b 52 04             	mov    0x4(%edx),%edx
  8030ab:	89 50 04             	mov    %edx,0x4(%eax)
  8030ae:	eb 0b                	jmp    8030bb <alloc_block_BF+0x176>
  8030b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b3:	8b 40 04             	mov    0x4(%eax),%eax
  8030b6:	a3 48 60 80 00       	mov    %eax,0x806048
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	8b 40 04             	mov    0x4(%eax),%eax
  8030c1:	85 c0                	test   %eax,%eax
  8030c3:	74 0f                	je     8030d4 <alloc_block_BF+0x18f>
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 40 04             	mov    0x4(%eax),%eax
  8030cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ce:	8b 12                	mov    (%edx),%edx
  8030d0:	89 10                	mov    %edx,(%eax)
  8030d2:	eb 0a                	jmp    8030de <alloc_block_BF+0x199>
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	a3 44 60 80 00       	mov    %eax,0x806044
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f1:	a1 50 60 80 00       	mov    0x806050,%eax
  8030f6:	48                   	dec    %eax
  8030f7:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  8030fc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030ff:	e9 24 04 00 00       	jmp    803528 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803104:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803107:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80310a:	76 13                	jbe    80311f <alloc_block_BF+0x1da>
					{
						internal = 1;
  80310c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803113:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803116:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803119:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80311c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80311f:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803124:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803127:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312b:	74 07                	je     803134 <alloc_block_BF+0x1ef>
  80312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803130:	8b 00                	mov    (%eax),%eax
  803132:	eb 05                	jmp    803139 <alloc_block_BF+0x1f4>
  803134:	b8 00 00 00 00       	mov    $0x0,%eax
  803139:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80313e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803143:	85 c0                	test   %eax,%eax
  803145:	0f 85 bf fe ff ff    	jne    80300a <alloc_block_BF+0xc5>
  80314b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314f:	0f 85 b5 fe ff ff    	jne    80300a <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803155:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803159:	0f 84 26 02 00 00    	je     803385 <alloc_block_BF+0x440>
  80315f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803163:	0f 85 1c 02 00 00    	jne    803385 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803169:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316c:	2b 45 08             	sub    0x8(%ebp),%eax
  80316f:	83 e8 08             	sub    $0x8,%eax
  803172:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	8d 50 08             	lea    0x8(%eax),%edx
  80317b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317e:	01 d0                	add    %edx,%eax
  803180:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	83 c0 08             	add    $0x8,%eax
  803189:	83 ec 04             	sub    $0x4,%esp
  80318c:	6a 01                	push   $0x1
  80318e:	50                   	push   %eax
  80318f:	ff 75 f0             	pushl  -0x10(%ebp)
  803192:	e8 c3 f8 ff ff       	call   802a5a <set_block_data>
  803197:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319d:	8b 40 04             	mov    0x4(%eax),%eax
  8031a0:	85 c0                	test   %eax,%eax
  8031a2:	75 68                	jne    80320c <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031a8:	75 17                	jne    8031c1 <alloc_block_BF+0x27c>
  8031aa:	83 ec 04             	sub    $0x4,%esp
  8031ad:	68 d8 50 80 00       	push   $0x8050d8
  8031b2:	68 45 01 00 00       	push   $0x145
  8031b7:	68 bd 50 80 00       	push   $0x8050bd
  8031bc:	e8 a8 d8 ff ff       	call   800a69 <_panic>
  8031c1:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8031c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ca:	89 10                	mov    %edx,(%eax)
  8031cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	85 c0                	test   %eax,%eax
  8031d3:	74 0d                	je     8031e2 <alloc_block_BF+0x29d>
  8031d5:	a1 44 60 80 00       	mov    0x806044,%eax
  8031da:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031dd:	89 50 04             	mov    %edx,0x4(%eax)
  8031e0:	eb 08                	jmp    8031ea <alloc_block_BF+0x2a5>
  8031e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031e5:	a3 48 60 80 00       	mov    %eax,0x806048
  8031ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ed:	a3 44 60 80 00       	mov    %eax,0x806044
  8031f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fc:	a1 50 60 80 00       	mov    0x806050,%eax
  803201:	40                   	inc    %eax
  803202:	a3 50 60 80 00       	mov    %eax,0x806050
  803207:	e9 dc 00 00 00       	jmp    8032e8 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80320c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320f:	8b 00                	mov    (%eax),%eax
  803211:	85 c0                	test   %eax,%eax
  803213:	75 65                	jne    80327a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803215:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803219:	75 17                	jne    803232 <alloc_block_BF+0x2ed>
  80321b:	83 ec 04             	sub    $0x4,%esp
  80321e:	68 0c 51 80 00       	push   $0x80510c
  803223:	68 4a 01 00 00       	push   $0x14a
  803228:	68 bd 50 80 00       	push   $0x8050bd
  80322d:	e8 37 d8 ff ff       	call   800a69 <_panic>
  803232:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803238:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80323b:	89 50 04             	mov    %edx,0x4(%eax)
  80323e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803241:	8b 40 04             	mov    0x4(%eax),%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	74 0c                	je     803254 <alloc_block_BF+0x30f>
  803248:	a1 48 60 80 00       	mov    0x806048,%eax
  80324d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803250:	89 10                	mov    %edx,(%eax)
  803252:	eb 08                	jmp    80325c <alloc_block_BF+0x317>
  803254:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803257:	a3 44 60 80 00       	mov    %eax,0x806044
  80325c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80325f:	a3 48 60 80 00       	mov    %eax,0x806048
  803264:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803267:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326d:	a1 50 60 80 00       	mov    0x806050,%eax
  803272:	40                   	inc    %eax
  803273:	a3 50 60 80 00       	mov    %eax,0x806050
  803278:	eb 6e                	jmp    8032e8 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80327a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80327e:	74 06                	je     803286 <alloc_block_BF+0x341>
  803280:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803284:	75 17                	jne    80329d <alloc_block_BF+0x358>
  803286:	83 ec 04             	sub    $0x4,%esp
  803289:	68 30 51 80 00       	push   $0x805130
  80328e:	68 4f 01 00 00       	push   $0x14f
  803293:	68 bd 50 80 00       	push   $0x8050bd
  803298:	e8 cc d7 ff ff       	call   800a69 <_panic>
  80329d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a0:	8b 10                	mov    (%eax),%edx
  8032a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032a5:	89 10                	mov    %edx,(%eax)
  8032a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032aa:	8b 00                	mov    (%eax),%eax
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	74 0b                	je     8032bb <alloc_block_BF+0x376>
  8032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032b8:	89 50 04             	mov    %edx,0x4(%eax)
  8032bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032be:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032c1:	89 10                	mov    %edx,(%eax)
  8032c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c9:	89 50 04             	mov    %edx,0x4(%eax)
  8032cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032cf:	8b 00                	mov    (%eax),%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	75 08                	jne    8032dd <alloc_block_BF+0x398>
  8032d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032d8:	a3 48 60 80 00       	mov    %eax,0x806048
  8032dd:	a1 50 60 80 00       	mov    0x806050,%eax
  8032e2:	40                   	inc    %eax
  8032e3:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8032e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032ec:	75 17                	jne    803305 <alloc_block_BF+0x3c0>
  8032ee:	83 ec 04             	sub    $0x4,%esp
  8032f1:	68 9f 50 80 00       	push   $0x80509f
  8032f6:	68 51 01 00 00       	push   $0x151
  8032fb:	68 bd 50 80 00       	push   $0x8050bd
  803300:	e8 64 d7 ff ff       	call   800a69 <_panic>
  803305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803308:	8b 00                	mov    (%eax),%eax
  80330a:	85 c0                	test   %eax,%eax
  80330c:	74 10                	je     80331e <alloc_block_BF+0x3d9>
  80330e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803316:	8b 52 04             	mov    0x4(%edx),%edx
  803319:	89 50 04             	mov    %edx,0x4(%eax)
  80331c:	eb 0b                	jmp    803329 <alloc_block_BF+0x3e4>
  80331e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803321:	8b 40 04             	mov    0x4(%eax),%eax
  803324:	a3 48 60 80 00       	mov    %eax,0x806048
  803329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332c:	8b 40 04             	mov    0x4(%eax),%eax
  80332f:	85 c0                	test   %eax,%eax
  803331:	74 0f                	je     803342 <alloc_block_BF+0x3fd>
  803333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803336:	8b 40 04             	mov    0x4(%eax),%eax
  803339:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80333c:	8b 12                	mov    (%edx),%edx
  80333e:	89 10                	mov    %edx,(%eax)
  803340:	eb 0a                	jmp    80334c <alloc_block_BF+0x407>
  803342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	a3 44 60 80 00       	mov    %eax,0x806044
  80334c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803358:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335f:	a1 50 60 80 00       	mov    0x806050,%eax
  803364:	48                   	dec    %eax
  803365:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  80336a:	83 ec 04             	sub    $0x4,%esp
  80336d:	6a 00                	push   $0x0
  80336f:	ff 75 d0             	pushl  -0x30(%ebp)
  803372:	ff 75 cc             	pushl  -0x34(%ebp)
  803375:	e8 e0 f6 ff ff       	call   802a5a <set_block_data>
  80337a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80337d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803380:	e9 a3 01 00 00       	jmp    803528 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803385:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803389:	0f 85 9d 00 00 00    	jne    80342c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80338f:	83 ec 04             	sub    $0x4,%esp
  803392:	6a 01                	push   $0x1
  803394:	ff 75 ec             	pushl  -0x14(%ebp)
  803397:	ff 75 f0             	pushl  -0x10(%ebp)
  80339a:	e8 bb f6 ff ff       	call   802a5a <set_block_data>
  80339f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8033a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033a6:	75 17                	jne    8033bf <alloc_block_BF+0x47a>
  8033a8:	83 ec 04             	sub    $0x4,%esp
  8033ab:	68 9f 50 80 00       	push   $0x80509f
  8033b0:	68 58 01 00 00       	push   $0x158
  8033b5:	68 bd 50 80 00       	push   $0x8050bd
  8033ba:	e8 aa d6 ff ff       	call   800a69 <_panic>
  8033bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c2:	8b 00                	mov    (%eax),%eax
  8033c4:	85 c0                	test   %eax,%eax
  8033c6:	74 10                	je     8033d8 <alloc_block_BF+0x493>
  8033c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cb:	8b 00                	mov    (%eax),%eax
  8033cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033d0:	8b 52 04             	mov    0x4(%edx),%edx
  8033d3:	89 50 04             	mov    %edx,0x4(%eax)
  8033d6:	eb 0b                	jmp    8033e3 <alloc_block_BF+0x49e>
  8033d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033db:	8b 40 04             	mov    0x4(%eax),%eax
  8033de:	a3 48 60 80 00       	mov    %eax,0x806048
  8033e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e6:	8b 40 04             	mov    0x4(%eax),%eax
  8033e9:	85 c0                	test   %eax,%eax
  8033eb:	74 0f                	je     8033fc <alloc_block_BF+0x4b7>
  8033ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f0:	8b 40 04             	mov    0x4(%eax),%eax
  8033f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f6:	8b 12                	mov    (%edx),%edx
  8033f8:	89 10                	mov    %edx,(%eax)
  8033fa:	eb 0a                	jmp    803406 <alloc_block_BF+0x4c1>
  8033fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ff:	8b 00                	mov    (%eax),%eax
  803401:	a3 44 60 80 00       	mov    %eax,0x806044
  803406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80340f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803412:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803419:	a1 50 60 80 00       	mov    0x806050,%eax
  80341e:	48                   	dec    %eax
  80341f:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  803424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803427:	e9 fc 00 00 00       	jmp    803528 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	83 c0 08             	add    $0x8,%eax
  803432:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803435:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80343c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80343f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803442:	01 d0                	add    %edx,%eax
  803444:	48                   	dec    %eax
  803445:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803448:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80344b:	ba 00 00 00 00       	mov    $0x0,%edx
  803450:	f7 75 c4             	divl   -0x3c(%ebp)
  803453:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803456:	29 d0                	sub    %edx,%eax
  803458:	c1 e8 0c             	shr    $0xc,%eax
  80345b:	83 ec 0c             	sub    $0xc,%esp
  80345e:	50                   	push   %eax
  80345f:	e8 5c e6 ff ff       	call   801ac0 <sbrk>
  803464:	83 c4 10             	add    $0x10,%esp
  803467:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80346a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80346e:	75 0a                	jne    80347a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803470:	b8 00 00 00 00       	mov    $0x0,%eax
  803475:	e9 ae 00 00 00       	jmp    803528 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80347a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803481:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803484:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803487:	01 d0                	add    %edx,%eax
  803489:	48                   	dec    %eax
  80348a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80348d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803490:	ba 00 00 00 00       	mov    $0x0,%edx
  803495:	f7 75 b8             	divl   -0x48(%ebp)
  803498:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80349b:	29 d0                	sub    %edx,%eax
  80349d:	8d 50 fc             	lea    -0x4(%eax),%edx
  8034a0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8034a3:	01 d0                	add    %edx,%eax
  8034a5:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  8034aa:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8034af:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8034b5:	83 ec 0c             	sub    $0xc,%esp
  8034b8:	68 64 51 80 00       	push   $0x805164
  8034bd:	e8 64 d8 ff ff       	call   800d26 <cprintf>
  8034c2:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8034c5:	83 ec 08             	sub    $0x8,%esp
  8034c8:	ff 75 bc             	pushl  -0x44(%ebp)
  8034cb:	68 69 51 80 00       	push   $0x805169
  8034d0:	e8 51 d8 ff ff       	call   800d26 <cprintf>
  8034d5:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8034d8:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8034df:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8034e5:	01 d0                	add    %edx,%eax
  8034e7:	48                   	dec    %eax
  8034e8:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8034eb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8034f3:	f7 75 b0             	divl   -0x50(%ebp)
  8034f6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034f9:	29 d0                	sub    %edx,%eax
  8034fb:	83 ec 04             	sub    $0x4,%esp
  8034fe:	6a 01                	push   $0x1
  803500:	50                   	push   %eax
  803501:	ff 75 bc             	pushl  -0x44(%ebp)
  803504:	e8 51 f5 ff ff       	call   802a5a <set_block_data>
  803509:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80350c:	83 ec 0c             	sub    $0xc,%esp
  80350f:	ff 75 bc             	pushl  -0x44(%ebp)
  803512:	e8 36 04 00 00       	call   80394d <free_block>
  803517:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80351a:	83 ec 0c             	sub    $0xc,%esp
  80351d:	ff 75 08             	pushl  0x8(%ebp)
  803520:	e8 20 fa ff ff       	call   802f45 <alloc_block_BF>
  803525:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803528:	c9                   	leave  
  803529:	c3                   	ret    

0080352a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80352a:	55                   	push   %ebp
  80352b:	89 e5                	mov    %esp,%ebp
  80352d:	53                   	push   %ebx
  80352e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803531:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803538:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80353f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803543:	74 1e                	je     803563 <merging+0x39>
  803545:	ff 75 08             	pushl  0x8(%ebp)
  803548:	e8 bc f1 ff ff       	call   802709 <get_block_size>
  80354d:	83 c4 04             	add    $0x4,%esp
  803550:	89 c2                	mov    %eax,%edx
  803552:	8b 45 08             	mov    0x8(%ebp),%eax
  803555:	01 d0                	add    %edx,%eax
  803557:	3b 45 10             	cmp    0x10(%ebp),%eax
  80355a:	75 07                	jne    803563 <merging+0x39>
		prev_is_free = 1;
  80355c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803563:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803567:	74 1e                	je     803587 <merging+0x5d>
  803569:	ff 75 10             	pushl  0x10(%ebp)
  80356c:	e8 98 f1 ff ff       	call   802709 <get_block_size>
  803571:	83 c4 04             	add    $0x4,%esp
  803574:	89 c2                	mov    %eax,%edx
  803576:	8b 45 10             	mov    0x10(%ebp),%eax
  803579:	01 d0                	add    %edx,%eax
  80357b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80357e:	75 07                	jne    803587 <merging+0x5d>
		next_is_free = 1;
  803580:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80358b:	0f 84 cc 00 00 00    	je     80365d <merging+0x133>
  803591:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803595:	0f 84 c2 00 00 00    	je     80365d <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80359b:	ff 75 08             	pushl  0x8(%ebp)
  80359e:	e8 66 f1 ff ff       	call   802709 <get_block_size>
  8035a3:	83 c4 04             	add    $0x4,%esp
  8035a6:	89 c3                	mov    %eax,%ebx
  8035a8:	ff 75 10             	pushl  0x10(%ebp)
  8035ab:	e8 59 f1 ff ff       	call   802709 <get_block_size>
  8035b0:	83 c4 04             	add    $0x4,%esp
  8035b3:	01 c3                	add    %eax,%ebx
  8035b5:	ff 75 0c             	pushl  0xc(%ebp)
  8035b8:	e8 4c f1 ff ff       	call   802709 <get_block_size>
  8035bd:	83 c4 04             	add    $0x4,%esp
  8035c0:	01 d8                	add    %ebx,%eax
  8035c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035c5:	6a 00                	push   $0x0
  8035c7:	ff 75 ec             	pushl  -0x14(%ebp)
  8035ca:	ff 75 08             	pushl  0x8(%ebp)
  8035cd:	e8 88 f4 ff ff       	call   802a5a <set_block_data>
  8035d2:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8035d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035d9:	75 17                	jne    8035f2 <merging+0xc8>
  8035db:	83 ec 04             	sub    $0x4,%esp
  8035de:	68 9f 50 80 00       	push   $0x80509f
  8035e3:	68 7d 01 00 00       	push   $0x17d
  8035e8:	68 bd 50 80 00       	push   $0x8050bd
  8035ed:	e8 77 d4 ff ff       	call   800a69 <_panic>
  8035f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f5:	8b 00                	mov    (%eax),%eax
  8035f7:	85 c0                	test   %eax,%eax
  8035f9:	74 10                	je     80360b <merging+0xe1>
  8035fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fe:	8b 00                	mov    (%eax),%eax
  803600:	8b 55 0c             	mov    0xc(%ebp),%edx
  803603:	8b 52 04             	mov    0x4(%edx),%edx
  803606:	89 50 04             	mov    %edx,0x4(%eax)
  803609:	eb 0b                	jmp    803616 <merging+0xec>
  80360b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360e:	8b 40 04             	mov    0x4(%eax),%eax
  803611:	a3 48 60 80 00       	mov    %eax,0x806048
  803616:	8b 45 0c             	mov    0xc(%ebp),%eax
  803619:	8b 40 04             	mov    0x4(%eax),%eax
  80361c:	85 c0                	test   %eax,%eax
  80361e:	74 0f                	je     80362f <merging+0x105>
  803620:	8b 45 0c             	mov    0xc(%ebp),%eax
  803623:	8b 40 04             	mov    0x4(%eax),%eax
  803626:	8b 55 0c             	mov    0xc(%ebp),%edx
  803629:	8b 12                	mov    (%edx),%edx
  80362b:	89 10                	mov    %edx,(%eax)
  80362d:	eb 0a                	jmp    803639 <merging+0x10f>
  80362f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803632:	8b 00                	mov    (%eax),%eax
  803634:	a3 44 60 80 00       	mov    %eax,0x806044
  803639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80363c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803642:	8b 45 0c             	mov    0xc(%ebp),%eax
  803645:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364c:	a1 50 60 80 00       	mov    0x806050,%eax
  803651:	48                   	dec    %eax
  803652:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803657:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803658:	e9 ea 02 00 00       	jmp    803947 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80365d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803661:	74 3b                	je     80369e <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803663:	83 ec 0c             	sub    $0xc,%esp
  803666:	ff 75 08             	pushl  0x8(%ebp)
  803669:	e8 9b f0 ff ff       	call   802709 <get_block_size>
  80366e:	83 c4 10             	add    $0x10,%esp
  803671:	89 c3                	mov    %eax,%ebx
  803673:	83 ec 0c             	sub    $0xc,%esp
  803676:	ff 75 10             	pushl  0x10(%ebp)
  803679:	e8 8b f0 ff ff       	call   802709 <get_block_size>
  80367e:	83 c4 10             	add    $0x10,%esp
  803681:	01 d8                	add    %ebx,%eax
  803683:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803686:	83 ec 04             	sub    $0x4,%esp
  803689:	6a 00                	push   $0x0
  80368b:	ff 75 e8             	pushl  -0x18(%ebp)
  80368e:	ff 75 08             	pushl  0x8(%ebp)
  803691:	e8 c4 f3 ff ff       	call   802a5a <set_block_data>
  803696:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803699:	e9 a9 02 00 00       	jmp    803947 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80369e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036a2:	0f 84 2d 01 00 00    	je     8037d5 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8036a8:	83 ec 0c             	sub    $0xc,%esp
  8036ab:	ff 75 10             	pushl  0x10(%ebp)
  8036ae:	e8 56 f0 ff ff       	call   802709 <get_block_size>
  8036b3:	83 c4 10             	add    $0x10,%esp
  8036b6:	89 c3                	mov    %eax,%ebx
  8036b8:	83 ec 0c             	sub    $0xc,%esp
  8036bb:	ff 75 0c             	pushl  0xc(%ebp)
  8036be:	e8 46 f0 ff ff       	call   802709 <get_block_size>
  8036c3:	83 c4 10             	add    $0x10,%esp
  8036c6:	01 d8                	add    %ebx,%eax
  8036c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8036cb:	83 ec 04             	sub    $0x4,%esp
  8036ce:	6a 00                	push   $0x0
  8036d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036d3:	ff 75 10             	pushl  0x10(%ebp)
  8036d6:	e8 7f f3 ff ff       	call   802a5a <set_block_data>
  8036db:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8036de:	8b 45 10             	mov    0x10(%ebp),%eax
  8036e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8036e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036e8:	74 06                	je     8036f0 <merging+0x1c6>
  8036ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8036ee:	75 17                	jne    803707 <merging+0x1dd>
  8036f0:	83 ec 04             	sub    $0x4,%esp
  8036f3:	68 78 51 80 00       	push   $0x805178
  8036f8:	68 8d 01 00 00       	push   $0x18d
  8036fd:	68 bd 50 80 00       	push   $0x8050bd
  803702:	e8 62 d3 ff ff       	call   800a69 <_panic>
  803707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370a:	8b 50 04             	mov    0x4(%eax),%edx
  80370d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803710:	89 50 04             	mov    %edx,0x4(%eax)
  803713:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803716:	8b 55 0c             	mov    0xc(%ebp),%edx
  803719:	89 10                	mov    %edx,(%eax)
  80371b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371e:	8b 40 04             	mov    0x4(%eax),%eax
  803721:	85 c0                	test   %eax,%eax
  803723:	74 0d                	je     803732 <merging+0x208>
  803725:	8b 45 0c             	mov    0xc(%ebp),%eax
  803728:	8b 40 04             	mov    0x4(%eax),%eax
  80372b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80372e:	89 10                	mov    %edx,(%eax)
  803730:	eb 08                	jmp    80373a <merging+0x210>
  803732:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803735:	a3 44 60 80 00       	mov    %eax,0x806044
  80373a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803740:	89 50 04             	mov    %edx,0x4(%eax)
  803743:	a1 50 60 80 00       	mov    0x806050,%eax
  803748:	40                   	inc    %eax
  803749:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  80374e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803752:	75 17                	jne    80376b <merging+0x241>
  803754:	83 ec 04             	sub    $0x4,%esp
  803757:	68 9f 50 80 00       	push   $0x80509f
  80375c:	68 8e 01 00 00       	push   $0x18e
  803761:	68 bd 50 80 00       	push   $0x8050bd
  803766:	e8 fe d2 ff ff       	call   800a69 <_panic>
  80376b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80376e:	8b 00                	mov    (%eax),%eax
  803770:	85 c0                	test   %eax,%eax
  803772:	74 10                	je     803784 <merging+0x25a>
  803774:	8b 45 0c             	mov    0xc(%ebp),%eax
  803777:	8b 00                	mov    (%eax),%eax
  803779:	8b 55 0c             	mov    0xc(%ebp),%edx
  80377c:	8b 52 04             	mov    0x4(%edx),%edx
  80377f:	89 50 04             	mov    %edx,0x4(%eax)
  803782:	eb 0b                	jmp    80378f <merging+0x265>
  803784:	8b 45 0c             	mov    0xc(%ebp),%eax
  803787:	8b 40 04             	mov    0x4(%eax),%eax
  80378a:	a3 48 60 80 00       	mov    %eax,0x806048
  80378f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803792:	8b 40 04             	mov    0x4(%eax),%eax
  803795:	85 c0                	test   %eax,%eax
  803797:	74 0f                	je     8037a8 <merging+0x27e>
  803799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80379c:	8b 40 04             	mov    0x4(%eax),%eax
  80379f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037a2:	8b 12                	mov    (%edx),%edx
  8037a4:	89 10                	mov    %edx,(%eax)
  8037a6:	eb 0a                	jmp    8037b2 <merging+0x288>
  8037a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ab:	8b 00                	mov    (%eax),%eax
  8037ad:	a3 44 60 80 00       	mov    %eax,0x806044
  8037b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c5:	a1 50 60 80 00       	mov    0x806050,%eax
  8037ca:	48                   	dec    %eax
  8037cb:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037d0:	e9 72 01 00 00       	jmp    803947 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8037d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8037d8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8037db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037df:	74 79                	je     80385a <merging+0x330>
  8037e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037e5:	74 73                	je     80385a <merging+0x330>
  8037e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037eb:	74 06                	je     8037f3 <merging+0x2c9>
  8037ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037f1:	75 17                	jne    80380a <merging+0x2e0>
  8037f3:	83 ec 04             	sub    $0x4,%esp
  8037f6:	68 30 51 80 00       	push   $0x805130
  8037fb:	68 94 01 00 00       	push   $0x194
  803800:	68 bd 50 80 00       	push   $0x8050bd
  803805:	e8 5f d2 ff ff       	call   800a69 <_panic>
  80380a:	8b 45 08             	mov    0x8(%ebp),%eax
  80380d:	8b 10                	mov    (%eax),%edx
  80380f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803812:	89 10                	mov    %edx,(%eax)
  803814:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803817:	8b 00                	mov    (%eax),%eax
  803819:	85 c0                	test   %eax,%eax
  80381b:	74 0b                	je     803828 <merging+0x2fe>
  80381d:	8b 45 08             	mov    0x8(%ebp),%eax
  803820:	8b 00                	mov    (%eax),%eax
  803822:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803825:	89 50 04             	mov    %edx,0x4(%eax)
  803828:	8b 45 08             	mov    0x8(%ebp),%eax
  80382b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80382e:	89 10                	mov    %edx,(%eax)
  803830:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803833:	8b 55 08             	mov    0x8(%ebp),%edx
  803836:	89 50 04             	mov    %edx,0x4(%eax)
  803839:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80383c:	8b 00                	mov    (%eax),%eax
  80383e:	85 c0                	test   %eax,%eax
  803840:	75 08                	jne    80384a <merging+0x320>
  803842:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803845:	a3 48 60 80 00       	mov    %eax,0x806048
  80384a:	a1 50 60 80 00       	mov    0x806050,%eax
  80384f:	40                   	inc    %eax
  803850:	a3 50 60 80 00       	mov    %eax,0x806050
  803855:	e9 ce 00 00 00       	jmp    803928 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80385a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80385e:	74 65                	je     8038c5 <merging+0x39b>
  803860:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803864:	75 17                	jne    80387d <merging+0x353>
  803866:	83 ec 04             	sub    $0x4,%esp
  803869:	68 0c 51 80 00       	push   $0x80510c
  80386e:	68 95 01 00 00       	push   $0x195
  803873:	68 bd 50 80 00       	push   $0x8050bd
  803878:	e8 ec d1 ff ff       	call   800a69 <_panic>
  80387d:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803883:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803886:	89 50 04             	mov    %edx,0x4(%eax)
  803889:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80388c:	8b 40 04             	mov    0x4(%eax),%eax
  80388f:	85 c0                	test   %eax,%eax
  803891:	74 0c                	je     80389f <merging+0x375>
  803893:	a1 48 60 80 00       	mov    0x806048,%eax
  803898:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80389b:	89 10                	mov    %edx,(%eax)
  80389d:	eb 08                	jmp    8038a7 <merging+0x37d>
  80389f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a2:	a3 44 60 80 00       	mov    %eax,0x806044
  8038a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038aa:	a3 48 60 80 00       	mov    %eax,0x806048
  8038af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b8:	a1 50 60 80 00       	mov    0x806050,%eax
  8038bd:	40                   	inc    %eax
  8038be:	a3 50 60 80 00       	mov    %eax,0x806050
  8038c3:	eb 63                	jmp    803928 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8038c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038c9:	75 17                	jne    8038e2 <merging+0x3b8>
  8038cb:	83 ec 04             	sub    $0x4,%esp
  8038ce:	68 d8 50 80 00       	push   $0x8050d8
  8038d3:	68 98 01 00 00       	push   $0x198
  8038d8:	68 bd 50 80 00       	push   $0x8050bd
  8038dd:	e8 87 d1 ff ff       	call   800a69 <_panic>
  8038e2:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8038e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038eb:	89 10                	mov    %edx,(%eax)
  8038ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f0:	8b 00                	mov    (%eax),%eax
  8038f2:	85 c0                	test   %eax,%eax
  8038f4:	74 0d                	je     803903 <merging+0x3d9>
  8038f6:	a1 44 60 80 00       	mov    0x806044,%eax
  8038fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038fe:	89 50 04             	mov    %edx,0x4(%eax)
  803901:	eb 08                	jmp    80390b <merging+0x3e1>
  803903:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803906:	a3 48 60 80 00       	mov    %eax,0x806048
  80390b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80390e:	a3 44 60 80 00       	mov    %eax,0x806044
  803913:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803916:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80391d:	a1 50 60 80 00       	mov    0x806050,%eax
  803922:	40                   	inc    %eax
  803923:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  803928:	83 ec 0c             	sub    $0xc,%esp
  80392b:	ff 75 10             	pushl  0x10(%ebp)
  80392e:	e8 d6 ed ff ff       	call   802709 <get_block_size>
  803933:	83 c4 10             	add    $0x10,%esp
  803936:	83 ec 04             	sub    $0x4,%esp
  803939:	6a 00                	push   $0x0
  80393b:	50                   	push   %eax
  80393c:	ff 75 10             	pushl  0x10(%ebp)
  80393f:	e8 16 f1 ff ff       	call   802a5a <set_block_data>
  803944:	83 c4 10             	add    $0x10,%esp
	}
}
  803947:	90                   	nop
  803948:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80394b:	c9                   	leave  
  80394c:	c3                   	ret    

0080394d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80394d:	55                   	push   %ebp
  80394e:	89 e5                	mov    %esp,%ebp
  803950:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803953:	a1 44 60 80 00       	mov    0x806044,%eax
  803958:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80395b:	a1 48 60 80 00       	mov    0x806048,%eax
  803960:	3b 45 08             	cmp    0x8(%ebp),%eax
  803963:	73 1b                	jae    803980 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803965:	a1 48 60 80 00       	mov    0x806048,%eax
  80396a:	83 ec 04             	sub    $0x4,%esp
  80396d:	ff 75 08             	pushl  0x8(%ebp)
  803970:	6a 00                	push   $0x0
  803972:	50                   	push   %eax
  803973:	e8 b2 fb ff ff       	call   80352a <merging>
  803978:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80397b:	e9 8b 00 00 00       	jmp    803a0b <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803980:	a1 44 60 80 00       	mov    0x806044,%eax
  803985:	3b 45 08             	cmp    0x8(%ebp),%eax
  803988:	76 18                	jbe    8039a2 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80398a:	a1 44 60 80 00       	mov    0x806044,%eax
  80398f:	83 ec 04             	sub    $0x4,%esp
  803992:	ff 75 08             	pushl  0x8(%ebp)
  803995:	50                   	push   %eax
  803996:	6a 00                	push   $0x0
  803998:	e8 8d fb ff ff       	call   80352a <merging>
  80399d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039a0:	eb 69                	jmp    803a0b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8039a2:	a1 44 60 80 00       	mov    0x806044,%eax
  8039a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039aa:	eb 39                	jmp    8039e5 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8039ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039b2:	73 29                	jae    8039dd <free_block+0x90>
  8039b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b7:	8b 00                	mov    (%eax),%eax
  8039b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039bc:	76 1f                	jbe    8039dd <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8039be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c1:	8b 00                	mov    (%eax),%eax
  8039c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8039c6:	83 ec 04             	sub    $0x4,%esp
  8039c9:	ff 75 08             	pushl  0x8(%ebp)
  8039cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8039cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8039d2:	e8 53 fb ff ff       	call   80352a <merging>
  8039d7:	83 c4 10             	add    $0x10,%esp
			break;
  8039da:	90                   	nop
		}
	}
}
  8039db:	eb 2e                	jmp    803a0b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8039dd:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8039e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039e9:	74 07                	je     8039f2 <free_block+0xa5>
  8039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ee:	8b 00                	mov    (%eax),%eax
  8039f0:	eb 05                	jmp    8039f7 <free_block+0xaa>
  8039f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f7:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8039fc:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803a01:	85 c0                	test   %eax,%eax
  803a03:	75 a7                	jne    8039ac <free_block+0x5f>
  803a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a09:	75 a1                	jne    8039ac <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a0b:	90                   	nop
  803a0c:	c9                   	leave  
  803a0d:	c3                   	ret    

00803a0e <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803a0e:	55                   	push   %ebp
  803a0f:	89 e5                	mov    %esp,%ebp
  803a11:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803a14:	ff 75 08             	pushl  0x8(%ebp)
  803a17:	e8 ed ec ff ff       	call   802709 <get_block_size>
  803a1c:	83 c4 04             	add    $0x4,%esp
  803a1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803a22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803a29:	eb 17                	jmp    803a42 <copy_data+0x34>
  803a2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a31:	01 c2                	add    %eax,%edx
  803a33:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803a36:	8b 45 08             	mov    0x8(%ebp),%eax
  803a39:	01 c8                	add    %ecx,%eax
  803a3b:	8a 00                	mov    (%eax),%al
  803a3d:	88 02                	mov    %al,(%edx)
  803a3f:	ff 45 fc             	incl   -0x4(%ebp)
  803a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a45:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803a48:	72 e1                	jb     803a2b <copy_data+0x1d>
}
  803a4a:	90                   	nop
  803a4b:	c9                   	leave  
  803a4c:	c3                   	ret    

00803a4d <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803a4d:	55                   	push   %ebp
  803a4e:	89 e5                	mov    %esp,%ebp
  803a50:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803a53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a57:	75 23                	jne    803a7c <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803a59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a5d:	74 13                	je     803a72 <realloc_block_FF+0x25>
  803a5f:	83 ec 0c             	sub    $0xc,%esp
  803a62:	ff 75 0c             	pushl  0xc(%ebp)
  803a65:	e8 1f f0 ff ff       	call   802a89 <alloc_block_FF>
  803a6a:	83 c4 10             	add    $0x10,%esp
  803a6d:	e9 f4 06 00 00       	jmp    804166 <realloc_block_FF+0x719>
		return NULL;
  803a72:	b8 00 00 00 00       	mov    $0x0,%eax
  803a77:	e9 ea 06 00 00       	jmp    804166 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803a7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a80:	75 18                	jne    803a9a <realloc_block_FF+0x4d>
	{
		free_block(va);
  803a82:	83 ec 0c             	sub    $0xc,%esp
  803a85:	ff 75 08             	pushl  0x8(%ebp)
  803a88:	e8 c0 fe ff ff       	call   80394d <free_block>
  803a8d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a90:	b8 00 00 00 00       	mov    $0x0,%eax
  803a95:	e9 cc 06 00 00       	jmp    804166 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803a9a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803a9e:	77 07                	ja     803aa7 <realloc_block_FF+0x5a>
  803aa0:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aaa:	83 e0 01             	and    $0x1,%eax
  803aad:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ab3:	83 c0 08             	add    $0x8,%eax
  803ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803ab9:	83 ec 0c             	sub    $0xc,%esp
  803abc:	ff 75 08             	pushl  0x8(%ebp)
  803abf:	e8 45 ec ff ff       	call   802709 <get_block_size>
  803ac4:	83 c4 10             	add    $0x10,%esp
  803ac7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803acd:	83 e8 08             	sub    $0x8,%eax
  803ad0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad6:	83 e8 04             	sub    $0x4,%eax
  803ad9:	8b 00                	mov    (%eax),%eax
  803adb:	83 e0 fe             	and    $0xfffffffe,%eax
  803ade:	89 c2                	mov    %eax,%edx
  803ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae3:	01 d0                	add    %edx,%eax
  803ae5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803ae8:	83 ec 0c             	sub    $0xc,%esp
  803aeb:	ff 75 e4             	pushl  -0x1c(%ebp)
  803aee:	e8 16 ec ff ff       	call   802709 <get_block_size>
  803af3:	83 c4 10             	add    $0x10,%esp
  803af6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803af9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803afc:	83 e8 08             	sub    $0x8,%eax
  803aff:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b05:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b08:	75 08                	jne    803b12 <realloc_block_FF+0xc5>
	{
		 return va;
  803b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0d:	e9 54 06 00 00       	jmp    804166 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b15:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b18:	0f 83 e5 03 00 00    	jae    803f03 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803b1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b21:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b24:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803b27:	83 ec 0c             	sub    $0xc,%esp
  803b2a:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b2d:	e8 f0 eb ff ff       	call   802722 <is_free_block>
  803b32:	83 c4 10             	add    $0x10,%esp
  803b35:	84 c0                	test   %al,%al
  803b37:	0f 84 3b 01 00 00    	je     803c78 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803b3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b40:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b43:	01 d0                	add    %edx,%eax
  803b45:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803b48:	83 ec 04             	sub    $0x4,%esp
  803b4b:	6a 01                	push   $0x1
  803b4d:	ff 75 f0             	pushl  -0x10(%ebp)
  803b50:	ff 75 08             	pushl  0x8(%ebp)
  803b53:	e8 02 ef ff ff       	call   802a5a <set_block_data>
  803b58:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5e:	83 e8 04             	sub    $0x4,%eax
  803b61:	8b 00                	mov    (%eax),%eax
  803b63:	83 e0 fe             	and    $0xfffffffe,%eax
  803b66:	89 c2                	mov    %eax,%edx
  803b68:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6b:	01 d0                	add    %edx,%eax
  803b6d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803b70:	83 ec 04             	sub    $0x4,%esp
  803b73:	6a 00                	push   $0x0
  803b75:	ff 75 cc             	pushl  -0x34(%ebp)
  803b78:	ff 75 c8             	pushl  -0x38(%ebp)
  803b7b:	e8 da ee ff ff       	call   802a5a <set_block_data>
  803b80:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b87:	74 06                	je     803b8f <realloc_block_FF+0x142>
  803b89:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b8d:	75 17                	jne    803ba6 <realloc_block_FF+0x159>
  803b8f:	83 ec 04             	sub    $0x4,%esp
  803b92:	68 30 51 80 00       	push   $0x805130
  803b97:	68 f6 01 00 00       	push   $0x1f6
  803b9c:	68 bd 50 80 00       	push   $0x8050bd
  803ba1:	e8 c3 ce ff ff       	call   800a69 <_panic>
  803ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba9:	8b 10                	mov    (%eax),%edx
  803bab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bae:	89 10                	mov    %edx,(%eax)
  803bb0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bb3:	8b 00                	mov    (%eax),%eax
  803bb5:	85 c0                	test   %eax,%eax
  803bb7:	74 0b                	je     803bc4 <realloc_block_FF+0x177>
  803bb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bbc:	8b 00                	mov    (%eax),%eax
  803bbe:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bc1:	89 50 04             	mov    %edx,0x4(%eax)
  803bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bca:	89 10                	mov    %edx,(%eax)
  803bcc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bcf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bd2:	89 50 04             	mov    %edx,0x4(%eax)
  803bd5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bd8:	8b 00                	mov    (%eax),%eax
  803bda:	85 c0                	test   %eax,%eax
  803bdc:	75 08                	jne    803be6 <realloc_block_FF+0x199>
  803bde:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803be1:	a3 48 60 80 00       	mov    %eax,0x806048
  803be6:	a1 50 60 80 00       	mov    0x806050,%eax
  803beb:	40                   	inc    %eax
  803bec:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803bf1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bf5:	75 17                	jne    803c0e <realloc_block_FF+0x1c1>
  803bf7:	83 ec 04             	sub    $0x4,%esp
  803bfa:	68 9f 50 80 00       	push   $0x80509f
  803bff:	68 f7 01 00 00       	push   $0x1f7
  803c04:	68 bd 50 80 00       	push   $0x8050bd
  803c09:	e8 5b ce ff ff       	call   800a69 <_panic>
  803c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c11:	8b 00                	mov    (%eax),%eax
  803c13:	85 c0                	test   %eax,%eax
  803c15:	74 10                	je     803c27 <realloc_block_FF+0x1da>
  803c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1a:	8b 00                	mov    (%eax),%eax
  803c1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c1f:	8b 52 04             	mov    0x4(%edx),%edx
  803c22:	89 50 04             	mov    %edx,0x4(%eax)
  803c25:	eb 0b                	jmp    803c32 <realloc_block_FF+0x1e5>
  803c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2a:	8b 40 04             	mov    0x4(%eax),%eax
  803c2d:	a3 48 60 80 00       	mov    %eax,0x806048
  803c32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c35:	8b 40 04             	mov    0x4(%eax),%eax
  803c38:	85 c0                	test   %eax,%eax
  803c3a:	74 0f                	je     803c4b <realloc_block_FF+0x1fe>
  803c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3f:	8b 40 04             	mov    0x4(%eax),%eax
  803c42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c45:	8b 12                	mov    (%edx),%edx
  803c47:	89 10                	mov    %edx,(%eax)
  803c49:	eb 0a                	jmp    803c55 <realloc_block_FF+0x208>
  803c4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4e:	8b 00                	mov    (%eax),%eax
  803c50:	a3 44 60 80 00       	mov    %eax,0x806044
  803c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c68:	a1 50 60 80 00       	mov    0x806050,%eax
  803c6d:	48                   	dec    %eax
  803c6e:	a3 50 60 80 00       	mov    %eax,0x806050
  803c73:	e9 83 02 00 00       	jmp    803efb <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803c78:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803c7c:	0f 86 69 02 00 00    	jbe    803eeb <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803c82:	83 ec 04             	sub    $0x4,%esp
  803c85:	6a 01                	push   $0x1
  803c87:	ff 75 f0             	pushl  -0x10(%ebp)
  803c8a:	ff 75 08             	pushl  0x8(%ebp)
  803c8d:	e8 c8 ed ff ff       	call   802a5a <set_block_data>
  803c92:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c95:	8b 45 08             	mov    0x8(%ebp),%eax
  803c98:	83 e8 04             	sub    $0x4,%eax
  803c9b:	8b 00                	mov    (%eax),%eax
  803c9d:	83 e0 fe             	and    $0xfffffffe,%eax
  803ca0:	89 c2                	mov    %eax,%edx
  803ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca5:	01 d0                	add    %edx,%eax
  803ca7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803caa:	a1 50 60 80 00       	mov    0x806050,%eax
  803caf:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803cb2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803cb6:	75 68                	jne    803d20 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803cb8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cbc:	75 17                	jne    803cd5 <realloc_block_FF+0x288>
  803cbe:	83 ec 04             	sub    $0x4,%esp
  803cc1:	68 d8 50 80 00       	push   $0x8050d8
  803cc6:	68 06 02 00 00       	push   $0x206
  803ccb:	68 bd 50 80 00       	push   $0x8050bd
  803cd0:	e8 94 cd ff ff       	call   800a69 <_panic>
  803cd5:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803cdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cde:	89 10                	mov    %edx,(%eax)
  803ce0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce3:	8b 00                	mov    (%eax),%eax
  803ce5:	85 c0                	test   %eax,%eax
  803ce7:	74 0d                	je     803cf6 <realloc_block_FF+0x2a9>
  803ce9:	a1 44 60 80 00       	mov    0x806044,%eax
  803cee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cf1:	89 50 04             	mov    %edx,0x4(%eax)
  803cf4:	eb 08                	jmp    803cfe <realloc_block_FF+0x2b1>
  803cf6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf9:	a3 48 60 80 00       	mov    %eax,0x806048
  803cfe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d01:	a3 44 60 80 00       	mov    %eax,0x806044
  803d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d10:	a1 50 60 80 00       	mov    0x806050,%eax
  803d15:	40                   	inc    %eax
  803d16:	a3 50 60 80 00       	mov    %eax,0x806050
  803d1b:	e9 b0 01 00 00       	jmp    803ed0 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803d20:	a1 44 60 80 00       	mov    0x806044,%eax
  803d25:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d28:	76 68                	jbe    803d92 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d2a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d2e:	75 17                	jne    803d47 <realloc_block_FF+0x2fa>
  803d30:	83 ec 04             	sub    $0x4,%esp
  803d33:	68 d8 50 80 00       	push   $0x8050d8
  803d38:	68 0b 02 00 00       	push   $0x20b
  803d3d:	68 bd 50 80 00       	push   $0x8050bd
  803d42:	e8 22 cd ff ff       	call   800a69 <_panic>
  803d47:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803d4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d50:	89 10                	mov    %edx,(%eax)
  803d52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d55:	8b 00                	mov    (%eax),%eax
  803d57:	85 c0                	test   %eax,%eax
  803d59:	74 0d                	je     803d68 <realloc_block_FF+0x31b>
  803d5b:	a1 44 60 80 00       	mov    0x806044,%eax
  803d60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d63:	89 50 04             	mov    %edx,0x4(%eax)
  803d66:	eb 08                	jmp    803d70 <realloc_block_FF+0x323>
  803d68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d6b:	a3 48 60 80 00       	mov    %eax,0x806048
  803d70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d73:	a3 44 60 80 00       	mov    %eax,0x806044
  803d78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d82:	a1 50 60 80 00       	mov    0x806050,%eax
  803d87:	40                   	inc    %eax
  803d88:	a3 50 60 80 00       	mov    %eax,0x806050
  803d8d:	e9 3e 01 00 00       	jmp    803ed0 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803d92:	a1 44 60 80 00       	mov    0x806044,%eax
  803d97:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d9a:	73 68                	jae    803e04 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d9c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803da0:	75 17                	jne    803db9 <realloc_block_FF+0x36c>
  803da2:	83 ec 04             	sub    $0x4,%esp
  803da5:	68 0c 51 80 00       	push   $0x80510c
  803daa:	68 10 02 00 00       	push   $0x210
  803daf:	68 bd 50 80 00       	push   $0x8050bd
  803db4:	e8 b0 cc ff ff       	call   800a69 <_panic>
  803db9:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803dbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc2:	89 50 04             	mov    %edx,0x4(%eax)
  803dc5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc8:	8b 40 04             	mov    0x4(%eax),%eax
  803dcb:	85 c0                	test   %eax,%eax
  803dcd:	74 0c                	je     803ddb <realloc_block_FF+0x38e>
  803dcf:	a1 48 60 80 00       	mov    0x806048,%eax
  803dd4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dd7:	89 10                	mov    %edx,(%eax)
  803dd9:	eb 08                	jmp    803de3 <realloc_block_FF+0x396>
  803ddb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dde:	a3 44 60 80 00       	mov    %eax,0x806044
  803de3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de6:	a3 48 60 80 00       	mov    %eax,0x806048
  803deb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803df4:	a1 50 60 80 00       	mov    0x806050,%eax
  803df9:	40                   	inc    %eax
  803dfa:	a3 50 60 80 00       	mov    %eax,0x806050
  803dff:	e9 cc 00 00 00       	jmp    803ed0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803e04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803e0b:	a1 44 60 80 00       	mov    0x806044,%eax
  803e10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e13:	e9 8a 00 00 00       	jmp    803ea2 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e1e:	73 7a                	jae    803e9a <realloc_block_FF+0x44d>
  803e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e23:	8b 00                	mov    (%eax),%eax
  803e25:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e28:	73 70                	jae    803e9a <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803e2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e2e:	74 06                	je     803e36 <realloc_block_FF+0x3e9>
  803e30:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e34:	75 17                	jne    803e4d <realloc_block_FF+0x400>
  803e36:	83 ec 04             	sub    $0x4,%esp
  803e39:	68 30 51 80 00       	push   $0x805130
  803e3e:	68 1a 02 00 00       	push   $0x21a
  803e43:	68 bd 50 80 00       	push   $0x8050bd
  803e48:	e8 1c cc ff ff       	call   800a69 <_panic>
  803e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e50:	8b 10                	mov    (%eax),%edx
  803e52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e55:	89 10                	mov    %edx,(%eax)
  803e57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e5a:	8b 00                	mov    (%eax),%eax
  803e5c:	85 c0                	test   %eax,%eax
  803e5e:	74 0b                	je     803e6b <realloc_block_FF+0x41e>
  803e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e63:	8b 00                	mov    (%eax),%eax
  803e65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e68:	89 50 04             	mov    %edx,0x4(%eax)
  803e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e6e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e71:	89 10                	mov    %edx,(%eax)
  803e73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e79:	89 50 04             	mov    %edx,0x4(%eax)
  803e7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e7f:	8b 00                	mov    (%eax),%eax
  803e81:	85 c0                	test   %eax,%eax
  803e83:	75 08                	jne    803e8d <realloc_block_FF+0x440>
  803e85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e88:	a3 48 60 80 00       	mov    %eax,0x806048
  803e8d:	a1 50 60 80 00       	mov    0x806050,%eax
  803e92:	40                   	inc    %eax
  803e93:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  803e98:	eb 36                	jmp    803ed0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803e9a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ea2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ea6:	74 07                	je     803eaf <realloc_block_FF+0x462>
  803ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eab:	8b 00                	mov    (%eax),%eax
  803ead:	eb 05                	jmp    803eb4 <realloc_block_FF+0x467>
  803eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb4:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803eb9:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803ebe:	85 c0                	test   %eax,%eax
  803ec0:	0f 85 52 ff ff ff    	jne    803e18 <realloc_block_FF+0x3cb>
  803ec6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eca:	0f 85 48 ff ff ff    	jne    803e18 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803ed0:	83 ec 04             	sub    $0x4,%esp
  803ed3:	6a 00                	push   $0x0
  803ed5:	ff 75 d8             	pushl  -0x28(%ebp)
  803ed8:	ff 75 d4             	pushl  -0x2c(%ebp)
  803edb:	e8 7a eb ff ff       	call   802a5a <set_block_data>
  803ee0:	83 c4 10             	add    $0x10,%esp
				return va;
  803ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee6:	e9 7b 02 00 00       	jmp    804166 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803eeb:	83 ec 0c             	sub    $0xc,%esp
  803eee:	68 ad 51 80 00       	push   $0x8051ad
  803ef3:	e8 2e ce ff ff       	call   800d26 <cprintf>
  803ef8:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803efb:	8b 45 08             	mov    0x8(%ebp),%eax
  803efe:	e9 63 02 00 00       	jmp    804166 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f06:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f09:	0f 86 4d 02 00 00    	jbe    80415c <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803f0f:	83 ec 0c             	sub    $0xc,%esp
  803f12:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f15:	e8 08 e8 ff ff       	call   802722 <is_free_block>
  803f1a:	83 c4 10             	add    $0x10,%esp
  803f1d:	84 c0                	test   %al,%al
  803f1f:	0f 84 37 02 00 00    	je     80415c <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f28:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803f2b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803f2e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f31:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803f34:	76 38                	jbe    803f6e <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803f36:	83 ec 0c             	sub    $0xc,%esp
  803f39:	ff 75 08             	pushl  0x8(%ebp)
  803f3c:	e8 0c fa ff ff       	call   80394d <free_block>
  803f41:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803f44:	83 ec 0c             	sub    $0xc,%esp
  803f47:	ff 75 0c             	pushl  0xc(%ebp)
  803f4a:	e8 3a eb ff ff       	call   802a89 <alloc_block_FF>
  803f4f:	83 c4 10             	add    $0x10,%esp
  803f52:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803f55:	83 ec 08             	sub    $0x8,%esp
  803f58:	ff 75 c0             	pushl  -0x40(%ebp)
  803f5b:	ff 75 08             	pushl  0x8(%ebp)
  803f5e:	e8 ab fa ff ff       	call   803a0e <copy_data>
  803f63:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803f66:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f69:	e9 f8 01 00 00       	jmp    804166 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803f6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f71:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803f74:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803f77:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803f7b:	0f 87 a0 00 00 00    	ja     804021 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803f81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f85:	75 17                	jne    803f9e <realloc_block_FF+0x551>
  803f87:	83 ec 04             	sub    $0x4,%esp
  803f8a:	68 9f 50 80 00       	push   $0x80509f
  803f8f:	68 38 02 00 00       	push   $0x238
  803f94:	68 bd 50 80 00       	push   $0x8050bd
  803f99:	e8 cb ca ff ff       	call   800a69 <_panic>
  803f9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa1:	8b 00                	mov    (%eax),%eax
  803fa3:	85 c0                	test   %eax,%eax
  803fa5:	74 10                	je     803fb7 <realloc_block_FF+0x56a>
  803fa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803faa:	8b 00                	mov    (%eax),%eax
  803fac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803faf:	8b 52 04             	mov    0x4(%edx),%edx
  803fb2:	89 50 04             	mov    %edx,0x4(%eax)
  803fb5:	eb 0b                	jmp    803fc2 <realloc_block_FF+0x575>
  803fb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fba:	8b 40 04             	mov    0x4(%eax),%eax
  803fbd:	a3 48 60 80 00       	mov    %eax,0x806048
  803fc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc5:	8b 40 04             	mov    0x4(%eax),%eax
  803fc8:	85 c0                	test   %eax,%eax
  803fca:	74 0f                	je     803fdb <realloc_block_FF+0x58e>
  803fcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fcf:	8b 40 04             	mov    0x4(%eax),%eax
  803fd2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fd5:	8b 12                	mov    (%edx),%edx
  803fd7:	89 10                	mov    %edx,(%eax)
  803fd9:	eb 0a                	jmp    803fe5 <realloc_block_FF+0x598>
  803fdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fde:	8b 00                	mov    (%eax),%eax
  803fe0:	a3 44 60 80 00       	mov    %eax,0x806044
  803fe5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ff8:	a1 50 60 80 00       	mov    0x806050,%eax
  803ffd:	48                   	dec    %eax
  803ffe:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804003:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804006:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804009:	01 d0                	add    %edx,%eax
  80400b:	83 ec 04             	sub    $0x4,%esp
  80400e:	6a 01                	push   $0x1
  804010:	50                   	push   %eax
  804011:	ff 75 08             	pushl  0x8(%ebp)
  804014:	e8 41 ea ff ff       	call   802a5a <set_block_data>
  804019:	83 c4 10             	add    $0x10,%esp
  80401c:	e9 36 01 00 00       	jmp    804157 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804021:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804024:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804027:	01 d0                	add    %edx,%eax
  804029:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80402c:	83 ec 04             	sub    $0x4,%esp
  80402f:	6a 01                	push   $0x1
  804031:	ff 75 f0             	pushl  -0x10(%ebp)
  804034:	ff 75 08             	pushl  0x8(%ebp)
  804037:	e8 1e ea ff ff       	call   802a5a <set_block_data>
  80403c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80403f:	8b 45 08             	mov    0x8(%ebp),%eax
  804042:	83 e8 04             	sub    $0x4,%eax
  804045:	8b 00                	mov    (%eax),%eax
  804047:	83 e0 fe             	and    $0xfffffffe,%eax
  80404a:	89 c2                	mov    %eax,%edx
  80404c:	8b 45 08             	mov    0x8(%ebp),%eax
  80404f:	01 d0                	add    %edx,%eax
  804051:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804054:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804058:	74 06                	je     804060 <realloc_block_FF+0x613>
  80405a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80405e:	75 17                	jne    804077 <realloc_block_FF+0x62a>
  804060:	83 ec 04             	sub    $0x4,%esp
  804063:	68 30 51 80 00       	push   $0x805130
  804068:	68 44 02 00 00       	push   $0x244
  80406d:	68 bd 50 80 00       	push   $0x8050bd
  804072:	e8 f2 c9 ff ff       	call   800a69 <_panic>
  804077:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80407a:	8b 10                	mov    (%eax),%edx
  80407c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80407f:	89 10                	mov    %edx,(%eax)
  804081:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804084:	8b 00                	mov    (%eax),%eax
  804086:	85 c0                	test   %eax,%eax
  804088:	74 0b                	je     804095 <realloc_block_FF+0x648>
  80408a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80408d:	8b 00                	mov    (%eax),%eax
  80408f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804092:	89 50 04             	mov    %edx,0x4(%eax)
  804095:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804098:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80409b:	89 10                	mov    %edx,(%eax)
  80409d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040a3:	89 50 04             	mov    %edx,0x4(%eax)
  8040a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040a9:	8b 00                	mov    (%eax),%eax
  8040ab:	85 c0                	test   %eax,%eax
  8040ad:	75 08                	jne    8040b7 <realloc_block_FF+0x66a>
  8040af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040b2:	a3 48 60 80 00       	mov    %eax,0x806048
  8040b7:	a1 50 60 80 00       	mov    0x806050,%eax
  8040bc:	40                   	inc    %eax
  8040bd:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8040c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040c6:	75 17                	jne    8040df <realloc_block_FF+0x692>
  8040c8:	83 ec 04             	sub    $0x4,%esp
  8040cb:	68 9f 50 80 00       	push   $0x80509f
  8040d0:	68 45 02 00 00       	push   $0x245
  8040d5:	68 bd 50 80 00       	push   $0x8050bd
  8040da:	e8 8a c9 ff ff       	call   800a69 <_panic>
  8040df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e2:	8b 00                	mov    (%eax),%eax
  8040e4:	85 c0                	test   %eax,%eax
  8040e6:	74 10                	je     8040f8 <realloc_block_FF+0x6ab>
  8040e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040eb:	8b 00                	mov    (%eax),%eax
  8040ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040f0:	8b 52 04             	mov    0x4(%edx),%edx
  8040f3:	89 50 04             	mov    %edx,0x4(%eax)
  8040f6:	eb 0b                	jmp    804103 <realloc_block_FF+0x6b6>
  8040f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040fb:	8b 40 04             	mov    0x4(%eax),%eax
  8040fe:	a3 48 60 80 00       	mov    %eax,0x806048
  804103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804106:	8b 40 04             	mov    0x4(%eax),%eax
  804109:	85 c0                	test   %eax,%eax
  80410b:	74 0f                	je     80411c <realloc_block_FF+0x6cf>
  80410d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804110:	8b 40 04             	mov    0x4(%eax),%eax
  804113:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804116:	8b 12                	mov    (%edx),%edx
  804118:	89 10                	mov    %edx,(%eax)
  80411a:	eb 0a                	jmp    804126 <realloc_block_FF+0x6d9>
  80411c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80411f:	8b 00                	mov    (%eax),%eax
  804121:	a3 44 60 80 00       	mov    %eax,0x806044
  804126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80412f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804132:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804139:	a1 50 60 80 00       	mov    0x806050,%eax
  80413e:	48                   	dec    %eax
  80413f:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  804144:	83 ec 04             	sub    $0x4,%esp
  804147:	6a 00                	push   $0x0
  804149:	ff 75 bc             	pushl  -0x44(%ebp)
  80414c:	ff 75 b8             	pushl  -0x48(%ebp)
  80414f:	e8 06 e9 ff ff       	call   802a5a <set_block_data>
  804154:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804157:	8b 45 08             	mov    0x8(%ebp),%eax
  80415a:	eb 0a                	jmp    804166 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80415c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804163:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804166:	c9                   	leave  
  804167:	c3                   	ret    

00804168 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804168:	55                   	push   %ebp
  804169:	89 e5                	mov    %esp,%ebp
  80416b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80416e:	83 ec 04             	sub    $0x4,%esp
  804171:	68 b4 51 80 00       	push   $0x8051b4
  804176:	68 58 02 00 00       	push   $0x258
  80417b:	68 bd 50 80 00       	push   $0x8050bd
  804180:	e8 e4 c8 ff ff       	call   800a69 <_panic>

00804185 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804185:	55                   	push   %ebp
  804186:	89 e5                	mov    %esp,%ebp
  804188:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80418b:	83 ec 04             	sub    $0x4,%esp
  80418e:	68 dc 51 80 00       	push   $0x8051dc
  804193:	68 61 02 00 00       	push   $0x261
  804198:	68 bd 50 80 00       	push   $0x8050bd
  80419d:	e8 c7 c8 ff ff       	call   800a69 <_panic>
  8041a2:	66 90                	xchg   %ax,%ax

008041a4 <__udivdi3>:
  8041a4:	55                   	push   %ebp
  8041a5:	57                   	push   %edi
  8041a6:	56                   	push   %esi
  8041a7:	53                   	push   %ebx
  8041a8:	83 ec 1c             	sub    $0x1c,%esp
  8041ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8041af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8041b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8041bb:	89 ca                	mov    %ecx,%edx
  8041bd:	89 f8                	mov    %edi,%eax
  8041bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8041c3:	85 f6                	test   %esi,%esi
  8041c5:	75 2d                	jne    8041f4 <__udivdi3+0x50>
  8041c7:	39 cf                	cmp    %ecx,%edi
  8041c9:	77 65                	ja     804230 <__udivdi3+0x8c>
  8041cb:	89 fd                	mov    %edi,%ebp
  8041cd:	85 ff                	test   %edi,%edi
  8041cf:	75 0b                	jne    8041dc <__udivdi3+0x38>
  8041d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8041d6:	31 d2                	xor    %edx,%edx
  8041d8:	f7 f7                	div    %edi
  8041da:	89 c5                	mov    %eax,%ebp
  8041dc:	31 d2                	xor    %edx,%edx
  8041de:	89 c8                	mov    %ecx,%eax
  8041e0:	f7 f5                	div    %ebp
  8041e2:	89 c1                	mov    %eax,%ecx
  8041e4:	89 d8                	mov    %ebx,%eax
  8041e6:	f7 f5                	div    %ebp
  8041e8:	89 cf                	mov    %ecx,%edi
  8041ea:	89 fa                	mov    %edi,%edx
  8041ec:	83 c4 1c             	add    $0x1c,%esp
  8041ef:	5b                   	pop    %ebx
  8041f0:	5e                   	pop    %esi
  8041f1:	5f                   	pop    %edi
  8041f2:	5d                   	pop    %ebp
  8041f3:	c3                   	ret    
  8041f4:	39 ce                	cmp    %ecx,%esi
  8041f6:	77 28                	ja     804220 <__udivdi3+0x7c>
  8041f8:	0f bd fe             	bsr    %esi,%edi
  8041fb:	83 f7 1f             	xor    $0x1f,%edi
  8041fe:	75 40                	jne    804240 <__udivdi3+0x9c>
  804200:	39 ce                	cmp    %ecx,%esi
  804202:	72 0a                	jb     80420e <__udivdi3+0x6a>
  804204:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804208:	0f 87 9e 00 00 00    	ja     8042ac <__udivdi3+0x108>
  80420e:	b8 01 00 00 00       	mov    $0x1,%eax
  804213:	89 fa                	mov    %edi,%edx
  804215:	83 c4 1c             	add    $0x1c,%esp
  804218:	5b                   	pop    %ebx
  804219:	5e                   	pop    %esi
  80421a:	5f                   	pop    %edi
  80421b:	5d                   	pop    %ebp
  80421c:	c3                   	ret    
  80421d:	8d 76 00             	lea    0x0(%esi),%esi
  804220:	31 ff                	xor    %edi,%edi
  804222:	31 c0                	xor    %eax,%eax
  804224:	89 fa                	mov    %edi,%edx
  804226:	83 c4 1c             	add    $0x1c,%esp
  804229:	5b                   	pop    %ebx
  80422a:	5e                   	pop    %esi
  80422b:	5f                   	pop    %edi
  80422c:	5d                   	pop    %ebp
  80422d:	c3                   	ret    
  80422e:	66 90                	xchg   %ax,%ax
  804230:	89 d8                	mov    %ebx,%eax
  804232:	f7 f7                	div    %edi
  804234:	31 ff                	xor    %edi,%edi
  804236:	89 fa                	mov    %edi,%edx
  804238:	83 c4 1c             	add    $0x1c,%esp
  80423b:	5b                   	pop    %ebx
  80423c:	5e                   	pop    %esi
  80423d:	5f                   	pop    %edi
  80423e:	5d                   	pop    %ebp
  80423f:	c3                   	ret    
  804240:	bd 20 00 00 00       	mov    $0x20,%ebp
  804245:	89 eb                	mov    %ebp,%ebx
  804247:	29 fb                	sub    %edi,%ebx
  804249:	89 f9                	mov    %edi,%ecx
  80424b:	d3 e6                	shl    %cl,%esi
  80424d:	89 c5                	mov    %eax,%ebp
  80424f:	88 d9                	mov    %bl,%cl
  804251:	d3 ed                	shr    %cl,%ebp
  804253:	89 e9                	mov    %ebp,%ecx
  804255:	09 f1                	or     %esi,%ecx
  804257:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80425b:	89 f9                	mov    %edi,%ecx
  80425d:	d3 e0                	shl    %cl,%eax
  80425f:	89 c5                	mov    %eax,%ebp
  804261:	89 d6                	mov    %edx,%esi
  804263:	88 d9                	mov    %bl,%cl
  804265:	d3 ee                	shr    %cl,%esi
  804267:	89 f9                	mov    %edi,%ecx
  804269:	d3 e2                	shl    %cl,%edx
  80426b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80426f:	88 d9                	mov    %bl,%cl
  804271:	d3 e8                	shr    %cl,%eax
  804273:	09 c2                	or     %eax,%edx
  804275:	89 d0                	mov    %edx,%eax
  804277:	89 f2                	mov    %esi,%edx
  804279:	f7 74 24 0c          	divl   0xc(%esp)
  80427d:	89 d6                	mov    %edx,%esi
  80427f:	89 c3                	mov    %eax,%ebx
  804281:	f7 e5                	mul    %ebp
  804283:	39 d6                	cmp    %edx,%esi
  804285:	72 19                	jb     8042a0 <__udivdi3+0xfc>
  804287:	74 0b                	je     804294 <__udivdi3+0xf0>
  804289:	89 d8                	mov    %ebx,%eax
  80428b:	31 ff                	xor    %edi,%edi
  80428d:	e9 58 ff ff ff       	jmp    8041ea <__udivdi3+0x46>
  804292:	66 90                	xchg   %ax,%ax
  804294:	8b 54 24 08          	mov    0x8(%esp),%edx
  804298:	89 f9                	mov    %edi,%ecx
  80429a:	d3 e2                	shl    %cl,%edx
  80429c:	39 c2                	cmp    %eax,%edx
  80429e:	73 e9                	jae    804289 <__udivdi3+0xe5>
  8042a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8042a3:	31 ff                	xor    %edi,%edi
  8042a5:	e9 40 ff ff ff       	jmp    8041ea <__udivdi3+0x46>
  8042aa:	66 90                	xchg   %ax,%ax
  8042ac:	31 c0                	xor    %eax,%eax
  8042ae:	e9 37 ff ff ff       	jmp    8041ea <__udivdi3+0x46>
  8042b3:	90                   	nop

008042b4 <__umoddi3>:
  8042b4:	55                   	push   %ebp
  8042b5:	57                   	push   %edi
  8042b6:	56                   	push   %esi
  8042b7:	53                   	push   %ebx
  8042b8:	83 ec 1c             	sub    $0x1c,%esp
  8042bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8042bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8042c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8042cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8042d3:	89 f3                	mov    %esi,%ebx
  8042d5:	89 fa                	mov    %edi,%edx
  8042d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042db:	89 34 24             	mov    %esi,(%esp)
  8042de:	85 c0                	test   %eax,%eax
  8042e0:	75 1a                	jne    8042fc <__umoddi3+0x48>
  8042e2:	39 f7                	cmp    %esi,%edi
  8042e4:	0f 86 a2 00 00 00    	jbe    80438c <__umoddi3+0xd8>
  8042ea:	89 c8                	mov    %ecx,%eax
  8042ec:	89 f2                	mov    %esi,%edx
  8042ee:	f7 f7                	div    %edi
  8042f0:	89 d0                	mov    %edx,%eax
  8042f2:	31 d2                	xor    %edx,%edx
  8042f4:	83 c4 1c             	add    $0x1c,%esp
  8042f7:	5b                   	pop    %ebx
  8042f8:	5e                   	pop    %esi
  8042f9:	5f                   	pop    %edi
  8042fa:	5d                   	pop    %ebp
  8042fb:	c3                   	ret    
  8042fc:	39 f0                	cmp    %esi,%eax
  8042fe:	0f 87 ac 00 00 00    	ja     8043b0 <__umoddi3+0xfc>
  804304:	0f bd e8             	bsr    %eax,%ebp
  804307:	83 f5 1f             	xor    $0x1f,%ebp
  80430a:	0f 84 ac 00 00 00    	je     8043bc <__umoddi3+0x108>
  804310:	bf 20 00 00 00       	mov    $0x20,%edi
  804315:	29 ef                	sub    %ebp,%edi
  804317:	89 fe                	mov    %edi,%esi
  804319:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80431d:	89 e9                	mov    %ebp,%ecx
  80431f:	d3 e0                	shl    %cl,%eax
  804321:	89 d7                	mov    %edx,%edi
  804323:	89 f1                	mov    %esi,%ecx
  804325:	d3 ef                	shr    %cl,%edi
  804327:	09 c7                	or     %eax,%edi
  804329:	89 e9                	mov    %ebp,%ecx
  80432b:	d3 e2                	shl    %cl,%edx
  80432d:	89 14 24             	mov    %edx,(%esp)
  804330:	89 d8                	mov    %ebx,%eax
  804332:	d3 e0                	shl    %cl,%eax
  804334:	89 c2                	mov    %eax,%edx
  804336:	8b 44 24 08          	mov    0x8(%esp),%eax
  80433a:	d3 e0                	shl    %cl,%eax
  80433c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804340:	8b 44 24 08          	mov    0x8(%esp),%eax
  804344:	89 f1                	mov    %esi,%ecx
  804346:	d3 e8                	shr    %cl,%eax
  804348:	09 d0                	or     %edx,%eax
  80434a:	d3 eb                	shr    %cl,%ebx
  80434c:	89 da                	mov    %ebx,%edx
  80434e:	f7 f7                	div    %edi
  804350:	89 d3                	mov    %edx,%ebx
  804352:	f7 24 24             	mull   (%esp)
  804355:	89 c6                	mov    %eax,%esi
  804357:	89 d1                	mov    %edx,%ecx
  804359:	39 d3                	cmp    %edx,%ebx
  80435b:	0f 82 87 00 00 00    	jb     8043e8 <__umoddi3+0x134>
  804361:	0f 84 91 00 00 00    	je     8043f8 <__umoddi3+0x144>
  804367:	8b 54 24 04          	mov    0x4(%esp),%edx
  80436b:	29 f2                	sub    %esi,%edx
  80436d:	19 cb                	sbb    %ecx,%ebx
  80436f:	89 d8                	mov    %ebx,%eax
  804371:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804375:	d3 e0                	shl    %cl,%eax
  804377:	89 e9                	mov    %ebp,%ecx
  804379:	d3 ea                	shr    %cl,%edx
  80437b:	09 d0                	or     %edx,%eax
  80437d:	89 e9                	mov    %ebp,%ecx
  80437f:	d3 eb                	shr    %cl,%ebx
  804381:	89 da                	mov    %ebx,%edx
  804383:	83 c4 1c             	add    $0x1c,%esp
  804386:	5b                   	pop    %ebx
  804387:	5e                   	pop    %esi
  804388:	5f                   	pop    %edi
  804389:	5d                   	pop    %ebp
  80438a:	c3                   	ret    
  80438b:	90                   	nop
  80438c:	89 fd                	mov    %edi,%ebp
  80438e:	85 ff                	test   %edi,%edi
  804390:	75 0b                	jne    80439d <__umoddi3+0xe9>
  804392:	b8 01 00 00 00       	mov    $0x1,%eax
  804397:	31 d2                	xor    %edx,%edx
  804399:	f7 f7                	div    %edi
  80439b:	89 c5                	mov    %eax,%ebp
  80439d:	89 f0                	mov    %esi,%eax
  80439f:	31 d2                	xor    %edx,%edx
  8043a1:	f7 f5                	div    %ebp
  8043a3:	89 c8                	mov    %ecx,%eax
  8043a5:	f7 f5                	div    %ebp
  8043a7:	89 d0                	mov    %edx,%eax
  8043a9:	e9 44 ff ff ff       	jmp    8042f2 <__umoddi3+0x3e>
  8043ae:	66 90                	xchg   %ax,%ax
  8043b0:	89 c8                	mov    %ecx,%eax
  8043b2:	89 f2                	mov    %esi,%edx
  8043b4:	83 c4 1c             	add    $0x1c,%esp
  8043b7:	5b                   	pop    %ebx
  8043b8:	5e                   	pop    %esi
  8043b9:	5f                   	pop    %edi
  8043ba:	5d                   	pop    %ebp
  8043bb:	c3                   	ret    
  8043bc:	3b 04 24             	cmp    (%esp),%eax
  8043bf:	72 06                	jb     8043c7 <__umoddi3+0x113>
  8043c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8043c5:	77 0f                	ja     8043d6 <__umoddi3+0x122>
  8043c7:	89 f2                	mov    %esi,%edx
  8043c9:	29 f9                	sub    %edi,%ecx
  8043cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8043cf:	89 14 24             	mov    %edx,(%esp)
  8043d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8043da:	8b 14 24             	mov    (%esp),%edx
  8043dd:	83 c4 1c             	add    $0x1c,%esp
  8043e0:	5b                   	pop    %ebx
  8043e1:	5e                   	pop    %esi
  8043e2:	5f                   	pop    %edi
  8043e3:	5d                   	pop    %ebp
  8043e4:	c3                   	ret    
  8043e5:	8d 76 00             	lea    0x0(%esi),%esi
  8043e8:	2b 04 24             	sub    (%esp),%eax
  8043eb:	19 fa                	sbb    %edi,%edx
  8043ed:	89 d1                	mov    %edx,%ecx
  8043ef:	89 c6                	mov    %eax,%esi
  8043f1:	e9 71 ff ff ff       	jmp    804367 <__umoddi3+0xb3>
  8043f6:	66 90                	xchg   %ax,%ax
  8043f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8043fc:	72 ea                	jb     8043e8 <__umoddi3+0x134>
  8043fe:	89 d9                	mov    %ebx,%ecx
  804400:	e9 62 ff ff ff       	jmp    804367 <__umoddi3+0xb3>
