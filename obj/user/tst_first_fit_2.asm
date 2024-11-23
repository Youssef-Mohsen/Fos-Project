
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
  800055:	68 20 43 80 00       	push   $0x804320
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
  8000a5:	68 50 43 80 00       	push   $0x804350
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
  8000d1:	e8 2a 24 00 00       	call   802500 <sys_set_uheap_strategy>
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
  8000f6:	68 89 43 80 00       	push   $0x804389
  8000fb:	6a 26                	push   $0x26
  8000fd:	68 a5 43 80 00       	push   $0x8043a5
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
  800123:	e8 25 20 00 00       	call   80214d <sys_pf_calculate_allocated_pages>
  800128:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 d2 1f 00 00       	call   802102 <sys_calculate_free_frames>
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
  80013d:	68 bc 43 80 00       	push   $0x8043bc
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
  8002ac:	68 14 44 80 00       	push   $0x804414
  8002b1:	6a 69                	push   $0x69
  8002b3:	68 a5 43 80 00       	push   $0x8043a5
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
  800328:	68 3c 44 80 00       	push   $0x80443c
  80032d:	e8 f4 09 00 00       	call   800d26 <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800335:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80033b:	83 e8 08             	sub    $0x8,%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	6a 01                	push   $0x1
  800343:	50                   	push   %eax
  800344:	e8 f9 22 00 00       	call   802642 <alloc_block>
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
  800392:	68 60 44 80 00       	push   $0x804460
  800397:	68 80 00 00 00       	push   $0x80
  80039c:	68 a5 43 80 00       	push   $0x8043a5
  8003a1:	e8 c3 06 00 00       	call   800a69 <_panic>
		}
	}

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 88 44 80 00       	push   $0x804488
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
  800451:	68 d0 44 80 00       	push   $0x8044d0
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
  80046e:	68 f0 44 80 00       	push   $0x8044f0
  800473:	e8 ae 08 00 00       	call   800d26 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp

	uint32 testSizes[numOfFFTests] =
  80047b:	8d 85 2c ff ff ff    	lea    -0xd4(%ebp),%eax
  800481:	bb b4 48 80 00       	mov    $0x8048b4,%ebx
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
  8005a7:	68 4c 45 80 00       	push   $0x80454c
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
  80060a:	e8 fc 1f 00 00       	call   80260b <get_block_size>
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
  800627:	68 7c 45 80 00       	push   $0x80457c
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
  800641:	68 48 46 80 00       	push   $0x804648
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
  800714:	68 94 46 80 00       	push   $0x804694
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
  80074f:	68 c0 46 80 00       	push   $0x8046c0
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
  800808:	68 f4 46 80 00       	push   $0x8046f4
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
  800831:	68 58 47 80 00       	push   $0x804758
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
  8008a8:	68 78 47 80 00       	push   $0x804778
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
  8008f7:	68 e8 47 80 00       	push   $0x8047e8
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
  800914:	68 6c 48 80 00       	push   $0x80486c
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
  800930:	e8 96 19 00 00       	call   8022cb <sys_getenvindex>
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
  80099e:	e8 ac 16 00 00       	call   80204f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8009a3:	83 ec 0c             	sub    $0xc,%esp
  8009a6:	68 d8 48 80 00       	push   $0x8048d8
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
  8009ce:	68 00 49 80 00       	push   $0x804900
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
  8009ff:	68 28 49 80 00       	push   $0x804928
  800a04:	e8 1d 03 00 00       	call   800d26 <cprintf>
  800a09:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a0c:	a1 20 60 80 00       	mov    0x806020,%eax
  800a11:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	50                   	push   %eax
  800a1b:	68 80 49 80 00       	push   $0x804980
  800a20:	e8 01 03 00 00       	call   800d26 <cprintf>
  800a25:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	68 d8 48 80 00       	push   $0x8048d8
  800a30:	e8 f1 02 00 00       	call   800d26 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800a38:	e8 2c 16 00 00       	call   802069 <sys_unlock_cons>
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
  800a50:	e8 42 18 00 00       	call   802297 <sys_destroy_env>
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
  800a61:	e8 97 18 00 00       	call   8022fd <sys_exit_env>
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
  800a8a:	68 94 49 80 00       	push   $0x804994
  800a8f:	e8 92 02 00 00       	call   800d26 <cprintf>
  800a94:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a97:	a1 1c 60 80 00       	mov    0x80601c,%eax
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	ff 75 08             	pushl  0x8(%ebp)
  800aa2:	50                   	push   %eax
  800aa3:	68 99 49 80 00       	push   $0x804999
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
  800ac7:	68 b5 49 80 00       	push   $0x8049b5
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
  800af6:	68 b8 49 80 00       	push   $0x8049b8
  800afb:	6a 26                	push   $0x26
  800afd:	68 04 4a 80 00       	push   $0x804a04
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
  800bcb:	68 10 4a 80 00       	push   $0x804a10
  800bd0:	6a 3a                	push   $0x3a
  800bd2:	68 04 4a 80 00       	push   $0x804a04
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
  800c3e:	68 64 4a 80 00       	push   $0x804a64
  800c43:	6a 44                	push   $0x44
  800c45:	68 04 4a 80 00       	push   $0x804a04
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
  800c98:	e8 70 13 00 00       	call   80200d <sys_cputs>
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
  800d0f:	e8 f9 12 00 00       	call   80200d <sys_cputs>
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
  800d59:	e8 f1 12 00 00       	call   80204f <sys_lock_cons>
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
  800d79:	e8 eb 12 00 00       	call   802069 <sys_unlock_cons>
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
  800dc3:	e8 dc 32 00 00       	call   8040a4 <__udivdi3>
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
  800e13:	e8 9c 33 00 00       	call   8041b4 <__umoddi3>
  800e18:	83 c4 10             	add    $0x10,%esp
  800e1b:	05 d4 4c 80 00       	add    $0x804cd4,%eax
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
  800f6e:	8b 04 85 f8 4c 80 00 	mov    0x804cf8(,%eax,4),%eax
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
  80104f:	8b 34 9d 40 4b 80 00 	mov    0x804b40(,%ebx,4),%esi
  801056:	85 f6                	test   %esi,%esi
  801058:	75 19                	jne    801073 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80105a:	53                   	push   %ebx
  80105b:	68 e5 4c 80 00       	push   $0x804ce5
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
  801074:	68 ee 4c 80 00       	push   $0x804cee
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
  8010a1:	be f1 4c 80 00       	mov    $0x804cf1,%esi
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
  801aac:	68 68 4e 80 00       	push   $0x804e68
  801ab1:	68 3f 01 00 00       	push   $0x13f
  801ab6:	68 8a 4e 80 00       	push   $0x804e8a
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
  801acc:	e8 e7 0a 00 00       	call   8025b8 <sys_sbrk>
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
  801b47:	e8 f0 08 00 00       	call   80243c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	74 16                	je     801b66 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	e8 30 0e 00 00       	call   80298b <alloc_block_FF>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b61:	e9 8a 01 00 00       	jmp    801cf0 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b66:	e8 02 09 00 00       	call   80246d <sys_isUHeapPlacementStrategyBESTFIT>
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	0f 84 7d 01 00 00    	je     801cf0 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	e8 c9 12 00 00       	call   802e47 <alloc_block_BF>
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
  801cdf:	e8 0b 09 00 00       	call   8025ef <sys_allocate_user_mem>
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
  801d27:	e8 df 08 00 00       	call   80260b <get_block_size>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 12 1b 00 00       	call   80384f <free_block>
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
  801dcf:	e8 ff 07 00 00       	call   8025d3 <sys_free_user_mem>
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
  801ddd:	68 98 4e 80 00       	push   $0x804e98
  801de2:	68 85 00 00 00       	push   $0x85
  801de7:	68 c2 4e 80 00       	push   $0x804ec2
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
  801e52:	e8 83 03 00 00       	call   8021da <sys_createSharedObject>
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
  801e76:	68 ce 4e 80 00       	push   $0x804ece
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
  801eba:	e8 45 03 00 00       	call   802204 <sys_getSizeOfSharedObject>
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801ec5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801ec9:	75 07                	jne    801ed2 <sget+0x27>
  801ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed0:	eb 5c                	jmp    801f2e <sget+0x83>
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
  801f05:	eb 27                	jmp    801f2e <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	ff 75 e8             	pushl  -0x18(%ebp)
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	ff 75 08             	pushl  0x8(%ebp)
  801f13:	e8 09 03 00 00       	call   802221 <sys_getSharedObject>
  801f18:	83 c4 10             	add    $0x10,%esp
  801f1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801f1e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f22:	75 07                	jne    801f2b <sget+0x80>
  801f24:	b8 00 00 00 00       	mov    $0x0,%eax
  801f29:	eb 03                	jmp    801f2e <sget+0x83>
	return ptr;
  801f2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801f36:	8b 55 08             	mov    0x8(%ebp),%edx
  801f39:	a1 20 60 80 00       	mov    0x806020,%eax
  801f3e:	8b 40 78             	mov    0x78(%eax),%eax
  801f41:	29 c2                	sub    %eax,%edx
  801f43:	89 d0                	mov    %edx,%eax
  801f45:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f4a:	c1 e8 0c             	shr    $0xc,%eax
  801f4d:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
  801f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801f57:	83 ec 08             	sub    $0x8,%esp
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f60:	e8 db 02 00 00       	call   802240 <sys_freeSharedObject>
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801f6b:	90                   	nop
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	68 e0 4e 80 00       	push   $0x804ee0
  801f7c:	68 dd 00 00 00       	push   $0xdd
  801f81:	68 c2 4e 80 00       	push   $0x804ec2
  801f86:	e8 de ea ff ff       	call   800a69 <_panic>

00801f8b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	68 06 4f 80 00       	push   $0x804f06
  801f99:	68 e9 00 00 00       	push   $0xe9
  801f9e:	68 c2 4e 80 00       	push   $0x804ec2
  801fa3:	e8 c1 ea ff ff       	call   800a69 <_panic>

00801fa8 <shrink>:

}
void shrink(uint32 newSize)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fae:	83 ec 04             	sub    $0x4,%esp
  801fb1:	68 06 4f 80 00       	push   $0x804f06
  801fb6:	68 ee 00 00 00       	push   $0xee
  801fbb:	68 c2 4e 80 00       	push   $0x804ec2
  801fc0:	e8 a4 ea ff ff       	call   800a69 <_panic>

00801fc5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fcb:	83 ec 04             	sub    $0x4,%esp
  801fce:	68 06 4f 80 00       	push   $0x804f06
  801fd3:	68 f3 00 00 00       	push   $0xf3
  801fd8:	68 c2 4e 80 00       	push   $0x804ec2
  801fdd:	e8 87 ea ff ff       	call   800a69 <_panic>

00801fe2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	57                   	push   %edi
  801fe6:	56                   	push   %esi
  801fe7:	53                   	push   %ebx
  801fe8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ff4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ff7:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ffa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ffd:	cd 30                	int    $0x30
  801fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802002:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802005:	83 c4 10             	add    $0x10,%esp
  802008:	5b                   	pop    %ebx
  802009:	5e                   	pop    %esi
  80200a:	5f                   	pop    %edi
  80200b:	5d                   	pop    %ebp
  80200c:	c3                   	ret    

0080200d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 04             	sub    $0x4,%esp
  802013:	8b 45 10             	mov    0x10(%ebp),%eax
  802016:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802019:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	52                   	push   %edx
  802025:	ff 75 0c             	pushl  0xc(%ebp)
  802028:	50                   	push   %eax
  802029:	6a 00                	push   $0x0
  80202b:	e8 b2 ff ff ff       	call   801fe2 <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
}
  802033:	90                   	nop
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_cgetc>:

int
sys_cgetc(void)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 02                	push   $0x2
  802045:	e8 98 ff ff ff       	call   801fe2 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 03                	push   $0x3
  80205e:	e8 7f ff ff ff       	call   801fe2 <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
}
  802066:	90                   	nop
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 04                	push   $0x4
  802078:	e8 65 ff ff ff       	call   801fe2 <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
}
  802080:	90                   	nop
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802086:	8b 55 0c             	mov    0xc(%ebp),%edx
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	52                   	push   %edx
  802093:	50                   	push   %eax
  802094:	6a 08                	push   $0x8
  802096:	e8 47 ff ff ff       	call   801fe2 <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	56                   	push   %esi
  8020a4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020a5:	8b 75 18             	mov    0x18(%ebp),%esi
  8020a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	56                   	push   %esi
  8020b5:	53                   	push   %ebx
  8020b6:	51                   	push   %ecx
  8020b7:	52                   	push   %edx
  8020b8:	50                   	push   %eax
  8020b9:	6a 09                	push   $0x9
  8020bb:	e8 22 ff ff ff       	call   801fe2 <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
}
  8020c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c6:	5b                   	pop    %ebx
  8020c7:	5e                   	pop    %esi
  8020c8:	5d                   	pop    %ebp
  8020c9:	c3                   	ret    

008020ca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	52                   	push   %edx
  8020da:	50                   	push   %eax
  8020db:	6a 0a                	push   $0xa
  8020dd:	e8 00 ff ff ff       	call   801fe2 <syscall>
  8020e2:	83 c4 18             	add    $0x18,%esp
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	ff 75 0c             	pushl  0xc(%ebp)
  8020f3:	ff 75 08             	pushl  0x8(%ebp)
  8020f6:	6a 0b                	push   $0xb
  8020f8:	e8 e5 fe ff ff       	call   801fe2 <syscall>
  8020fd:	83 c4 18             	add    $0x18,%esp
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 0c                	push   $0xc
  802111:	e8 cc fe ff ff       	call   801fe2 <syscall>
  802116:	83 c4 18             	add    $0x18,%esp
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 0d                	push   $0xd
  80212a:	e8 b3 fe ff ff       	call   801fe2 <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 0e                	push   $0xe
  802143:	e8 9a fe ff ff       	call   801fe2 <syscall>
  802148:	83 c4 18             	add    $0x18,%esp
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 0f                	push   $0xf
  80215c:	e8 81 fe ff ff       	call   801fe2 <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	ff 75 08             	pushl  0x8(%ebp)
  802174:	6a 10                	push   $0x10
  802176:	e8 67 fe ff ff       	call   801fe2 <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 11                	push   $0x11
  80218f:	e8 4e fe ff ff       	call   801fe2 <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
}
  802197:	90                   	nop
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_cputc>:

void
sys_cputc(const char c)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	83 ec 04             	sub    $0x4,%esp
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	50                   	push   %eax
  8021b3:	6a 01                	push   $0x1
  8021b5:	e8 28 fe ff ff       	call   801fe2 <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	90                   	nop
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 14                	push   $0x14
  8021cf:	e8 0e fe ff ff       	call   801fe2 <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
}
  8021d7:	90                   	nop
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	83 ec 04             	sub    $0x4,%esp
  8021e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021e6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021e9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	6a 00                	push   $0x0
  8021f2:	51                   	push   %ecx
  8021f3:	52                   	push   %edx
  8021f4:	ff 75 0c             	pushl  0xc(%ebp)
  8021f7:	50                   	push   %eax
  8021f8:	6a 15                	push   $0x15
  8021fa:	e8 e3 fd ff ff       	call   801fe2 <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802207:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	52                   	push   %edx
  802214:	50                   	push   %eax
  802215:	6a 16                	push   $0x16
  802217:	e8 c6 fd ff ff       	call   801fe2 <syscall>
  80221c:	83 c4 18             	add    $0x18,%esp
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802224:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802227:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	51                   	push   %ecx
  802232:	52                   	push   %edx
  802233:	50                   	push   %eax
  802234:	6a 17                	push   $0x17
  802236:	e8 a7 fd ff ff       	call   801fe2 <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802243:	8b 55 0c             	mov    0xc(%ebp),%edx
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	52                   	push   %edx
  802250:	50                   	push   %eax
  802251:	6a 18                	push   $0x18
  802253:	e8 8a fd ff ff       	call   801fe2 <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	6a 00                	push   $0x0
  802265:	ff 75 14             	pushl  0x14(%ebp)
  802268:	ff 75 10             	pushl  0x10(%ebp)
  80226b:	ff 75 0c             	pushl  0xc(%ebp)
  80226e:	50                   	push   %eax
  80226f:	6a 19                	push   $0x19
  802271:	e8 6c fd ff ff       	call   801fe2 <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	50                   	push   %eax
  80228a:	6a 1a                	push   $0x1a
  80228c:	e8 51 fd ff ff       	call   801fe2 <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
}
  802294:	90                   	nop
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	50                   	push   %eax
  8022a6:	6a 1b                	push   $0x1b
  8022a8:	e8 35 fd ff ff       	call   801fe2 <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 05                	push   $0x5
  8022c1:	e8 1c fd ff ff       	call   801fe2 <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 06                	push   $0x6
  8022da:	e8 03 fd ff ff       	call   801fe2 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 07                	push   $0x7
  8022f3:	e8 ea fc ff ff       	call   801fe2 <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_exit_env>:


void sys_exit_env(void)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 1c                	push   $0x1c
  80230c:	e8 d1 fc ff ff       	call   801fe2 <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	90                   	nop
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
  80231a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80231d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802320:	8d 50 04             	lea    0x4(%eax),%edx
  802323:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	52                   	push   %edx
  80232d:	50                   	push   %eax
  80232e:	6a 1d                	push   $0x1d
  802330:	e8 ad fc ff ff       	call   801fe2 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
	return result;
  802338:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80233b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80233e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802341:	89 01                	mov    %eax,(%ecx)
  802343:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	c9                   	leave  
  80234a:	c2 04 00             	ret    $0x4

0080234d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	ff 75 10             	pushl  0x10(%ebp)
  802357:	ff 75 0c             	pushl  0xc(%ebp)
  80235a:	ff 75 08             	pushl  0x8(%ebp)
  80235d:	6a 13                	push   $0x13
  80235f:	e8 7e fc ff ff       	call   801fe2 <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
	return ;
  802367:	90                   	nop
}
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <sys_rcr2>:
uint32 sys_rcr2()
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 1e                	push   $0x1e
  802379:	e8 64 fc ff ff       	call   801fe2 <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80238f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	50                   	push   %eax
  80239c:	6a 1f                	push   $0x1f
  80239e:	e8 3f fc ff ff       	call   801fe2 <syscall>
  8023a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a6:	90                   	nop
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <rsttst>:
void rsttst()
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 21                	push   $0x21
  8023b8:	e8 25 fc ff ff       	call   801fe2 <syscall>
  8023bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c0:	90                   	nop
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
  8023c6:	83 ec 04             	sub    $0x4,%esp
  8023c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8023cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023cf:	8b 55 18             	mov    0x18(%ebp),%edx
  8023d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023d6:	52                   	push   %edx
  8023d7:	50                   	push   %eax
  8023d8:	ff 75 10             	pushl  0x10(%ebp)
  8023db:	ff 75 0c             	pushl  0xc(%ebp)
  8023de:	ff 75 08             	pushl  0x8(%ebp)
  8023e1:	6a 20                	push   $0x20
  8023e3:	e8 fa fb ff ff       	call   801fe2 <syscall>
  8023e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023eb:	90                   	nop
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <chktst>:
void chktst(uint32 n)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	ff 75 08             	pushl  0x8(%ebp)
  8023fc:	6a 22                	push   $0x22
  8023fe:	e8 df fb ff ff       	call   801fe2 <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
	return ;
  802406:	90                   	nop
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <inctst>:

void inctst()
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 23                	push   $0x23
  802418:	e8 c5 fb ff ff       	call   801fe2 <syscall>
  80241d:	83 c4 18             	add    $0x18,%esp
	return ;
  802420:	90                   	nop
}
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <gettst>:
uint32 gettst()
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 24                	push   $0x24
  802432:	e8 ab fb ff ff       	call   801fe2 <syscall>
  802437:	83 c4 18             	add    $0x18,%esp
}
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 25                	push   $0x25
  80244e:	e8 8f fb ff ff       	call   801fe2 <syscall>
  802453:	83 c4 18             	add    $0x18,%esp
  802456:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802459:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80245d:	75 07                	jne    802466 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80245f:	b8 01 00 00 00       	mov    $0x1,%eax
  802464:	eb 05                	jmp    80246b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246b:	c9                   	leave  
  80246c:	c3                   	ret    

0080246d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
  802470:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 25                	push   $0x25
  80247f:	e8 5e fb ff ff       	call   801fe2 <syscall>
  802484:	83 c4 18             	add    $0x18,%esp
  802487:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80248a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80248e:	75 07                	jne    802497 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802490:	b8 01 00 00 00       	mov    $0x1,%eax
  802495:	eb 05                	jmp    80249c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802497:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 25                	push   $0x25
  8024b0:	e8 2d fb ff ff       	call   801fe2 <syscall>
  8024b5:	83 c4 18             	add    $0x18,%esp
  8024b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024bb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024bf:	75 07                	jne    8024c8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c6:	eb 05                	jmp    8024cd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
  8024d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 25                	push   $0x25
  8024e1:	e8 fc fa ff ff       	call   801fe2 <syscall>
  8024e6:	83 c4 18             	add    $0x18,%esp
  8024e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024ec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024f0:	75 07                	jne    8024f9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f7:	eb 05                	jmp    8024fe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	ff 75 08             	pushl  0x8(%ebp)
  80250e:	6a 26                	push   $0x26
  802510:	e8 cd fa ff ff       	call   801fe2 <syscall>
  802515:	83 c4 18             	add    $0x18,%esp
	return ;
  802518:	90                   	nop
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80251f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802522:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802525:	8b 55 0c             	mov    0xc(%ebp),%edx
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	6a 00                	push   $0x0
  80252d:	53                   	push   %ebx
  80252e:	51                   	push   %ecx
  80252f:	52                   	push   %edx
  802530:	50                   	push   %eax
  802531:	6a 27                	push   $0x27
  802533:	e8 aa fa ff ff       	call   801fe2 <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
}
  80253b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802543:	8b 55 0c             	mov    0xc(%ebp),%edx
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	52                   	push   %edx
  802550:	50                   	push   %eax
  802551:	6a 28                	push   $0x28
  802553:	e8 8a fa ff ff       	call   801fe2 <syscall>
  802558:	83 c4 18             	add    $0x18,%esp
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802560:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802563:	8b 55 0c             	mov    0xc(%ebp),%edx
  802566:	8b 45 08             	mov    0x8(%ebp),%eax
  802569:	6a 00                	push   $0x0
  80256b:	51                   	push   %ecx
  80256c:	ff 75 10             	pushl  0x10(%ebp)
  80256f:	52                   	push   %edx
  802570:	50                   	push   %eax
  802571:	6a 29                	push   $0x29
  802573:	e8 6a fa ff ff       	call   801fe2 <syscall>
  802578:	83 c4 18             	add    $0x18,%esp
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	ff 75 10             	pushl  0x10(%ebp)
  802587:	ff 75 0c             	pushl  0xc(%ebp)
  80258a:	ff 75 08             	pushl  0x8(%ebp)
  80258d:	6a 12                	push   $0x12
  80258f:	e8 4e fa ff ff       	call   801fe2 <syscall>
  802594:	83 c4 18             	add    $0x18,%esp
	return ;
  802597:	90                   	nop
}
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80259d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	52                   	push   %edx
  8025aa:	50                   	push   %eax
  8025ab:	6a 2a                	push   $0x2a
  8025ad:	e8 30 fa ff ff       	call   801fe2 <syscall>
  8025b2:	83 c4 18             	add    $0x18,%esp
	return;
  8025b5:	90                   	nop
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	50                   	push   %eax
  8025c7:	6a 2b                	push   $0x2b
  8025c9:	e8 14 fa ff ff       	call   801fe2 <syscall>
  8025ce:	83 c4 18             	add    $0x18,%esp
}
  8025d1:	c9                   	leave  
  8025d2:	c3                   	ret    

008025d3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8025d3:	55                   	push   %ebp
  8025d4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	ff 75 0c             	pushl  0xc(%ebp)
  8025df:	ff 75 08             	pushl  0x8(%ebp)
  8025e2:	6a 2c                	push   $0x2c
  8025e4:	e8 f9 f9 ff ff       	call   801fe2 <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
	return;
  8025ec:	90                   	nop
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	ff 75 0c             	pushl  0xc(%ebp)
  8025fb:	ff 75 08             	pushl  0x8(%ebp)
  8025fe:	6a 2d                	push   $0x2d
  802600:	e8 dd f9 ff ff       	call   801fe2 <syscall>
  802605:	83 c4 18             	add    $0x18,%esp
	return;
  802608:	90                   	nop
}
  802609:	c9                   	leave  
  80260a:	c3                   	ret    

0080260b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
  80260e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802611:	8b 45 08             	mov    0x8(%ebp),%eax
  802614:	83 e8 04             	sub    $0x4,%eax
  802617:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80261a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
  802627:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80262a:	8b 45 08             	mov    0x8(%ebp),%eax
  80262d:	83 e8 04             	sub    $0x4,%eax
  802630:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802633:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802636:	8b 00                	mov    (%eax),%eax
  802638:	83 e0 01             	and    $0x1,%eax
  80263b:	85 c0                	test   %eax,%eax
  80263d:	0f 94 c0             	sete   %al
}
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
  802645:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802648:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80264f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802652:	83 f8 02             	cmp    $0x2,%eax
  802655:	74 2b                	je     802682 <alloc_block+0x40>
  802657:	83 f8 02             	cmp    $0x2,%eax
  80265a:	7f 07                	jg     802663 <alloc_block+0x21>
  80265c:	83 f8 01             	cmp    $0x1,%eax
  80265f:	74 0e                	je     80266f <alloc_block+0x2d>
  802661:	eb 58                	jmp    8026bb <alloc_block+0x79>
  802663:	83 f8 03             	cmp    $0x3,%eax
  802666:	74 2d                	je     802695 <alloc_block+0x53>
  802668:	83 f8 04             	cmp    $0x4,%eax
  80266b:	74 3b                	je     8026a8 <alloc_block+0x66>
  80266d:	eb 4c                	jmp    8026bb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80266f:	83 ec 0c             	sub    $0xc,%esp
  802672:	ff 75 08             	pushl  0x8(%ebp)
  802675:	e8 11 03 00 00       	call   80298b <alloc_block_FF>
  80267a:	83 c4 10             	add    $0x10,%esp
  80267d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802680:	eb 4a                	jmp    8026cc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802682:	83 ec 0c             	sub    $0xc,%esp
  802685:	ff 75 08             	pushl  0x8(%ebp)
  802688:	e8 fa 19 00 00       	call   804087 <alloc_block_NF>
  80268d:	83 c4 10             	add    $0x10,%esp
  802690:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802693:	eb 37                	jmp    8026cc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802695:	83 ec 0c             	sub    $0xc,%esp
  802698:	ff 75 08             	pushl  0x8(%ebp)
  80269b:	e8 a7 07 00 00       	call   802e47 <alloc_block_BF>
  8026a0:	83 c4 10             	add    $0x10,%esp
  8026a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026a6:	eb 24                	jmp    8026cc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8026a8:	83 ec 0c             	sub    $0xc,%esp
  8026ab:	ff 75 08             	pushl  0x8(%ebp)
  8026ae:	e8 b7 19 00 00       	call   80406a <alloc_block_WF>
  8026b3:	83 c4 10             	add    $0x10,%esp
  8026b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026b9:	eb 11                	jmp    8026cc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8026bb:	83 ec 0c             	sub    $0xc,%esp
  8026be:	68 18 4f 80 00       	push   $0x804f18
  8026c3:	e8 5e e6 ff ff       	call   800d26 <cprintf>
  8026c8:	83 c4 10             	add    $0x10,%esp
		break;
  8026cb:	90                   	nop
	}
	return va;
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
  8026d4:	53                   	push   %ebx
  8026d5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8026d8:	83 ec 0c             	sub    $0xc,%esp
  8026db:	68 38 4f 80 00       	push   $0x804f38
  8026e0:	e8 41 e6 ff ff       	call   800d26 <cprintf>
  8026e5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	68 63 4f 80 00       	push   $0x804f63
  8026f0:	e8 31 e6 ff ff       	call   800d26 <cprintf>
  8026f5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fe:	eb 37                	jmp    802737 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802700:	83 ec 0c             	sub    $0xc,%esp
  802703:	ff 75 f4             	pushl  -0xc(%ebp)
  802706:	e8 19 ff ff ff       	call   802624 <is_free_block>
  80270b:	83 c4 10             	add    $0x10,%esp
  80270e:	0f be d8             	movsbl %al,%ebx
  802711:	83 ec 0c             	sub    $0xc,%esp
  802714:	ff 75 f4             	pushl  -0xc(%ebp)
  802717:	e8 ef fe ff ff       	call   80260b <get_block_size>
  80271c:	83 c4 10             	add    $0x10,%esp
  80271f:	83 ec 04             	sub    $0x4,%esp
  802722:	53                   	push   %ebx
  802723:	50                   	push   %eax
  802724:	68 7b 4f 80 00       	push   $0x804f7b
  802729:	e8 f8 e5 ff ff       	call   800d26 <cprintf>
  80272e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802731:	8b 45 10             	mov    0x10(%ebp),%eax
  802734:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273b:	74 07                	je     802744 <print_blocks_list+0x73>
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	eb 05                	jmp    802749 <print_blocks_list+0x78>
  802744:	b8 00 00 00 00       	mov    $0x0,%eax
  802749:	89 45 10             	mov    %eax,0x10(%ebp)
  80274c:	8b 45 10             	mov    0x10(%ebp),%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	75 ad                	jne    802700 <print_blocks_list+0x2f>
  802753:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802757:	75 a7                	jne    802700 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802759:	83 ec 0c             	sub    $0xc,%esp
  80275c:	68 38 4f 80 00       	push   $0x804f38
  802761:	e8 c0 e5 ff ff       	call   800d26 <cprintf>
  802766:	83 c4 10             	add    $0x10,%esp

}
  802769:	90                   	nop
  80276a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80276d:	c9                   	leave  
  80276e:	c3                   	ret    

0080276f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802775:	8b 45 0c             	mov    0xc(%ebp),%eax
  802778:	83 e0 01             	and    $0x1,%eax
  80277b:	85 c0                	test   %eax,%eax
  80277d:	74 03                	je     802782 <initialize_dynamic_allocator+0x13>
  80277f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802782:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802786:	0f 84 c7 01 00 00    	je     802953 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80278c:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802793:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802796:	8b 55 08             	mov    0x8(%ebp),%edx
  802799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279c:	01 d0                	add    %edx,%eax
  80279e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8027a3:	0f 87 ad 01 00 00    	ja     802956 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	0f 89 a5 01 00 00    	jns    802959 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8027b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ba:	01 d0                	add    %edx,%eax
  8027bc:	83 e8 04             	sub    $0x4,%eax
  8027bf:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  8027c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8027cb:	a1 44 60 80 00       	mov    0x806044,%eax
  8027d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d3:	e9 87 00 00 00       	jmp    80285f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8027d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027dc:	75 14                	jne    8027f2 <initialize_dynamic_allocator+0x83>
  8027de:	83 ec 04             	sub    $0x4,%esp
  8027e1:	68 93 4f 80 00       	push   $0x804f93
  8027e6:	6a 79                	push   $0x79
  8027e8:	68 b1 4f 80 00       	push   $0x804fb1
  8027ed:	e8 77 e2 ff ff       	call   800a69 <_panic>
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	74 10                	je     80280b <initialize_dynamic_allocator+0x9c>
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 00                	mov    (%eax),%eax
  802800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802803:	8b 52 04             	mov    0x4(%edx),%edx
  802806:	89 50 04             	mov    %edx,0x4(%eax)
  802809:	eb 0b                	jmp    802816 <initialize_dynamic_allocator+0xa7>
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 40 04             	mov    0x4(%eax),%eax
  802811:	a3 48 60 80 00       	mov    %eax,0x806048
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 40 04             	mov    0x4(%eax),%eax
  80281c:	85 c0                	test   %eax,%eax
  80281e:	74 0f                	je     80282f <initialize_dynamic_allocator+0xc0>
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 40 04             	mov    0x4(%eax),%eax
  802826:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802829:	8b 12                	mov    (%edx),%edx
  80282b:	89 10                	mov    %edx,(%eax)
  80282d:	eb 0a                	jmp    802839 <initialize_dynamic_allocator+0xca>
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 00                	mov    (%eax),%eax
  802834:	a3 44 60 80 00       	mov    %eax,0x806044
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80284c:	a1 50 60 80 00       	mov    0x806050,%eax
  802851:	48                   	dec    %eax
  802852:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802857:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80285c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802863:	74 07                	je     80286c <initialize_dynamic_allocator+0xfd>
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	eb 05                	jmp    802871 <initialize_dynamic_allocator+0x102>
  80286c:	b8 00 00 00 00       	mov    $0x0,%eax
  802871:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802876:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	0f 85 55 ff ff ff    	jne    8027d8 <initialize_dynamic_allocator+0x69>
  802883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802887:	0f 85 4b ff ff ff    	jne    8027d8 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802896:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80289c:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  8028a1:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  8028a6:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8028ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	83 c0 08             	add    $0x8,%eax
  8028b7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	83 c0 04             	add    $0x4,%eax
  8028c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c3:	83 ea 08             	sub    $0x8,%edx
  8028c6:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8028c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ce:	01 d0                	add    %edx,%eax
  8028d0:	83 e8 08             	sub    $0x8,%eax
  8028d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d6:	83 ea 08             	sub    $0x8,%edx
  8028d9:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8028db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8028e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8028ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028f2:	75 17                	jne    80290b <initialize_dynamic_allocator+0x19c>
  8028f4:	83 ec 04             	sub    $0x4,%esp
  8028f7:	68 cc 4f 80 00       	push   $0x804fcc
  8028fc:	68 90 00 00 00       	push   $0x90
  802901:	68 b1 4f 80 00       	push   $0x804fb1
  802906:	e8 5e e1 ff ff       	call   800a69 <_panic>
  80290b:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802911:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802914:	89 10                	mov    %edx,(%eax)
  802916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	85 c0                	test   %eax,%eax
  80291d:	74 0d                	je     80292c <initialize_dynamic_allocator+0x1bd>
  80291f:	a1 44 60 80 00       	mov    0x806044,%eax
  802924:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802927:	89 50 04             	mov    %edx,0x4(%eax)
  80292a:	eb 08                	jmp    802934 <initialize_dynamic_allocator+0x1c5>
  80292c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292f:	a3 48 60 80 00       	mov    %eax,0x806048
  802934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802937:	a3 44 60 80 00       	mov    %eax,0x806044
  80293c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802946:	a1 50 60 80 00       	mov    0x806050,%eax
  80294b:	40                   	inc    %eax
  80294c:	a3 50 60 80 00       	mov    %eax,0x806050
  802951:	eb 07                	jmp    80295a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802953:	90                   	nop
  802954:	eb 04                	jmp    80295a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802956:	90                   	nop
  802957:	eb 01                	jmp    80295a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802959:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80295a:	c9                   	leave  
  80295b:	c3                   	ret    

0080295c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80295c:	55                   	push   %ebp
  80295d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80295f:	8b 45 10             	mov    0x10(%ebp),%eax
  802962:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	8d 50 fc             	lea    -0x4(%eax),%edx
  80296b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80296e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	83 e8 04             	sub    $0x4,%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	83 e0 fe             	and    $0xfffffffe,%eax
  80297b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80297e:	8b 45 08             	mov    0x8(%ebp),%eax
  802981:	01 c2                	add    %eax,%edx
  802983:	8b 45 0c             	mov    0xc(%ebp),%eax
  802986:	89 02                	mov    %eax,(%edx)
}
  802988:	90                   	nop
  802989:	5d                   	pop    %ebp
  80298a:	c3                   	ret    

0080298b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
  80298e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	83 e0 01             	and    $0x1,%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	74 03                	je     80299e <alloc_block_FF+0x13>
  80299b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80299e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8029a2:	77 07                	ja     8029ab <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8029a4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8029ab:	a1 24 60 80 00       	mov    0x806024,%eax
  8029b0:	85 c0                	test   %eax,%eax
  8029b2:	75 73                	jne    802a27 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	83 c0 10             	add    $0x10,%eax
  8029ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8029bd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8029c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ca:	01 d0                	add    %edx,%eax
  8029cc:	48                   	dec    %eax
  8029cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8029d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8029d8:	f7 75 ec             	divl   -0x14(%ebp)
  8029db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029de:	29 d0                	sub    %edx,%eax
  8029e0:	c1 e8 0c             	shr    $0xc,%eax
  8029e3:	83 ec 0c             	sub    $0xc,%esp
  8029e6:	50                   	push   %eax
  8029e7:	e8 d4 f0 ff ff       	call   801ac0 <sbrk>
  8029ec:	83 c4 10             	add    $0x10,%esp
  8029ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029f2:	83 ec 0c             	sub    $0xc,%esp
  8029f5:	6a 00                	push   $0x0
  8029f7:	e8 c4 f0 ff ff       	call   801ac0 <sbrk>
  8029fc:	83 c4 10             	add    $0x10,%esp
  8029ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a05:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a08:	83 ec 08             	sub    $0x8,%esp
  802a0b:	50                   	push   %eax
  802a0c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a0f:	e8 5b fd ff ff       	call   80276f <initialize_dynamic_allocator>
  802a14:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802a17:	83 ec 0c             	sub    $0xc,%esp
  802a1a:	68 ef 4f 80 00       	push   $0x804fef
  802a1f:	e8 02 e3 ff ff       	call   800d26 <cprintf>
  802a24:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802a27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2b:	75 0a                	jne    802a37 <alloc_block_FF+0xac>
	        return NULL;
  802a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a32:	e9 0e 04 00 00       	jmp    802e45 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a3e:	a1 44 60 80 00       	mov    0x806044,%eax
  802a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a46:	e9 f3 02 00 00       	jmp    802d3e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802a51:	83 ec 0c             	sub    $0xc,%esp
  802a54:	ff 75 bc             	pushl  -0x44(%ebp)
  802a57:	e8 af fb ff ff       	call   80260b <get_block_size>
  802a5c:	83 c4 10             	add    $0x10,%esp
  802a5f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802a62:	8b 45 08             	mov    0x8(%ebp),%eax
  802a65:	83 c0 08             	add    $0x8,%eax
  802a68:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a6b:	0f 87 c5 02 00 00    	ja     802d36 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	83 c0 18             	add    $0x18,%eax
  802a77:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a7a:	0f 87 19 02 00 00    	ja     802c99 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802a80:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a83:	2b 45 08             	sub    0x8(%ebp),%eax
  802a86:	83 e8 08             	sub    $0x8,%eax
  802a89:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8f:	8d 50 08             	lea    0x8(%eax),%edx
  802a92:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a95:	01 d0                	add    %edx,%eax
  802a97:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	83 c0 08             	add    $0x8,%eax
  802aa0:	83 ec 04             	sub    $0x4,%esp
  802aa3:	6a 01                	push   $0x1
  802aa5:	50                   	push   %eax
  802aa6:	ff 75 bc             	pushl  -0x44(%ebp)
  802aa9:	e8 ae fe ff ff       	call   80295c <set_block_data>
  802aae:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 40 04             	mov    0x4(%eax),%eax
  802ab7:	85 c0                	test   %eax,%eax
  802ab9:	75 68                	jne    802b23 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802abb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802abf:	75 17                	jne    802ad8 <alloc_block_FF+0x14d>
  802ac1:	83 ec 04             	sub    $0x4,%esp
  802ac4:	68 cc 4f 80 00       	push   $0x804fcc
  802ac9:	68 d7 00 00 00       	push   $0xd7
  802ace:	68 b1 4f 80 00       	push   $0x804fb1
  802ad3:	e8 91 df ff ff       	call   800a69 <_panic>
  802ad8:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802ade:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae1:	89 10                	mov    %edx,(%eax)
  802ae3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae6:	8b 00                	mov    (%eax),%eax
  802ae8:	85 c0                	test   %eax,%eax
  802aea:	74 0d                	je     802af9 <alloc_block_FF+0x16e>
  802aec:	a1 44 60 80 00       	mov    0x806044,%eax
  802af1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802af4:	89 50 04             	mov    %edx,0x4(%eax)
  802af7:	eb 08                	jmp    802b01 <alloc_block_FF+0x176>
  802af9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802afc:	a3 48 60 80 00       	mov    %eax,0x806048
  802b01:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b04:	a3 44 60 80 00       	mov    %eax,0x806044
  802b09:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b13:	a1 50 60 80 00       	mov    0x806050,%eax
  802b18:	40                   	inc    %eax
  802b19:	a3 50 60 80 00       	mov    %eax,0x806050
  802b1e:	e9 dc 00 00 00       	jmp    802bff <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 00                	mov    (%eax),%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	75 65                	jne    802b91 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b2c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b30:	75 17                	jne    802b49 <alloc_block_FF+0x1be>
  802b32:	83 ec 04             	sub    $0x4,%esp
  802b35:	68 00 50 80 00       	push   $0x805000
  802b3a:	68 db 00 00 00       	push   $0xdb
  802b3f:	68 b1 4f 80 00       	push   $0x804fb1
  802b44:	e8 20 df ff ff       	call   800a69 <_panic>
  802b49:	8b 15 48 60 80 00    	mov    0x806048,%edx
  802b4f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b52:	89 50 04             	mov    %edx,0x4(%eax)
  802b55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	74 0c                	je     802b6b <alloc_block_FF+0x1e0>
  802b5f:	a1 48 60 80 00       	mov    0x806048,%eax
  802b64:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b67:	89 10                	mov    %edx,(%eax)
  802b69:	eb 08                	jmp    802b73 <alloc_block_FF+0x1e8>
  802b6b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b6e:	a3 44 60 80 00       	mov    %eax,0x806044
  802b73:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b76:	a3 48 60 80 00       	mov    %eax,0x806048
  802b7b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b84:	a1 50 60 80 00       	mov    0x806050,%eax
  802b89:	40                   	inc    %eax
  802b8a:	a3 50 60 80 00       	mov    %eax,0x806050
  802b8f:	eb 6e                	jmp    802bff <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b95:	74 06                	je     802b9d <alloc_block_FF+0x212>
  802b97:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b9b:	75 17                	jne    802bb4 <alloc_block_FF+0x229>
  802b9d:	83 ec 04             	sub    $0x4,%esp
  802ba0:	68 24 50 80 00       	push   $0x805024
  802ba5:	68 df 00 00 00       	push   $0xdf
  802baa:	68 b1 4f 80 00       	push   $0x804fb1
  802baf:	e8 b5 de ff ff       	call   800a69 <_panic>
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 10                	mov    (%eax),%edx
  802bb9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bbc:	89 10                	mov    %edx,(%eax)
  802bbe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	74 0b                	je     802bd2 <alloc_block_FF+0x247>
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 00                	mov    (%eax),%eax
  802bcc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bcf:	89 50 04             	mov    %edx,0x4(%eax)
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bd8:	89 10                	mov    %edx,(%eax)
  802bda:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be0:	89 50 04             	mov    %edx,0x4(%eax)
  802be3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	85 c0                	test   %eax,%eax
  802bea:	75 08                	jne    802bf4 <alloc_block_FF+0x269>
  802bec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bef:	a3 48 60 80 00       	mov    %eax,0x806048
  802bf4:	a1 50 60 80 00       	mov    0x806050,%eax
  802bf9:	40                   	inc    %eax
  802bfa:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802bff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c03:	75 17                	jne    802c1c <alloc_block_FF+0x291>
  802c05:	83 ec 04             	sub    $0x4,%esp
  802c08:	68 93 4f 80 00       	push   $0x804f93
  802c0d:	68 e1 00 00 00       	push   $0xe1
  802c12:	68 b1 4f 80 00       	push   $0x804fb1
  802c17:	e8 4d de ff ff       	call   800a69 <_panic>
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 00                	mov    (%eax),%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	74 10                	je     802c35 <alloc_block_FF+0x2aa>
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2d:	8b 52 04             	mov    0x4(%edx),%edx
  802c30:	89 50 04             	mov    %edx,0x4(%eax)
  802c33:	eb 0b                	jmp    802c40 <alloc_block_FF+0x2b5>
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 40 04             	mov    0x4(%eax),%eax
  802c3b:	a3 48 60 80 00       	mov    %eax,0x806048
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 04             	mov    0x4(%eax),%eax
  802c46:	85 c0                	test   %eax,%eax
  802c48:	74 0f                	je     802c59 <alloc_block_FF+0x2ce>
  802c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4d:	8b 40 04             	mov    0x4(%eax),%eax
  802c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c53:	8b 12                	mov    (%edx),%edx
  802c55:	89 10                	mov    %edx,(%eax)
  802c57:	eb 0a                	jmp    802c63 <alloc_block_FF+0x2d8>
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 00                	mov    (%eax),%eax
  802c5e:	a3 44 60 80 00       	mov    %eax,0x806044
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c76:	a1 50 60 80 00       	mov    0x806050,%eax
  802c7b:	48                   	dec    %eax
  802c7c:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  802c81:	83 ec 04             	sub    $0x4,%esp
  802c84:	6a 00                	push   $0x0
  802c86:	ff 75 b4             	pushl  -0x4c(%ebp)
  802c89:	ff 75 b0             	pushl  -0x50(%ebp)
  802c8c:	e8 cb fc ff ff       	call   80295c <set_block_data>
  802c91:	83 c4 10             	add    $0x10,%esp
  802c94:	e9 95 00 00 00       	jmp    802d2e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c99:	83 ec 04             	sub    $0x4,%esp
  802c9c:	6a 01                	push   $0x1
  802c9e:	ff 75 b8             	pushl  -0x48(%ebp)
  802ca1:	ff 75 bc             	pushl  -0x44(%ebp)
  802ca4:	e8 b3 fc ff ff       	call   80295c <set_block_data>
  802ca9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802cac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb0:	75 17                	jne    802cc9 <alloc_block_FF+0x33e>
  802cb2:	83 ec 04             	sub    $0x4,%esp
  802cb5:	68 93 4f 80 00       	push   $0x804f93
  802cba:	68 e8 00 00 00       	push   $0xe8
  802cbf:	68 b1 4f 80 00       	push   $0x804fb1
  802cc4:	e8 a0 dd ff ff       	call   800a69 <_panic>
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	8b 00                	mov    (%eax),%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	74 10                	je     802ce2 <alloc_block_FF+0x357>
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cda:	8b 52 04             	mov    0x4(%edx),%edx
  802cdd:	89 50 04             	mov    %edx,0x4(%eax)
  802ce0:	eb 0b                	jmp    802ced <alloc_block_FF+0x362>
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 40 04             	mov    0x4(%eax),%eax
  802ce8:	a3 48 60 80 00       	mov    %eax,0x806048
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	74 0f                	je     802d06 <alloc_block_FF+0x37b>
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	8b 40 04             	mov    0x4(%eax),%eax
  802cfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d00:	8b 12                	mov    (%edx),%edx
  802d02:	89 10                	mov    %edx,(%eax)
  802d04:	eb 0a                	jmp    802d10 <alloc_block_FF+0x385>
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
	            }
	            return va;
  802d2e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d31:	e9 0f 01 00 00       	jmp    802e45 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d36:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d42:	74 07                	je     802d4b <alloc_block_FF+0x3c0>
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	8b 00                	mov    (%eax),%eax
  802d49:	eb 05                	jmp    802d50 <alloc_block_FF+0x3c5>
  802d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d50:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802d55:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	0f 85 e9 fc ff ff    	jne    802a4b <alloc_block_FF+0xc0>
  802d62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d66:	0f 85 df fc ff ff    	jne    802a4b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	83 c0 08             	add    $0x8,%eax
  802d72:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d75:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d82:	01 d0                	add    %edx,%eax
  802d84:	48                   	dec    %eax
  802d85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d8b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d90:	f7 75 d8             	divl   -0x28(%ebp)
  802d93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d96:	29 d0                	sub    %edx,%eax
  802d98:	c1 e8 0c             	shr    $0xc,%eax
  802d9b:	83 ec 0c             	sub    $0xc,%esp
  802d9e:	50                   	push   %eax
  802d9f:	e8 1c ed ff ff       	call   801ac0 <sbrk>
  802da4:	83 c4 10             	add    $0x10,%esp
  802da7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802daa:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802dae:	75 0a                	jne    802dba <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802db0:	b8 00 00 00 00       	mov    $0x0,%eax
  802db5:	e9 8b 00 00 00       	jmp    802e45 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802dba:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802dc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dc7:	01 d0                	add    %edx,%eax
  802dc9:	48                   	dec    %eax
  802dca:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802dcd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd5:	f7 75 cc             	divl   -0x34(%ebp)
  802dd8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ddb:	29 d0                	sub    %edx,%eax
  802ddd:	8d 50 fc             	lea    -0x4(%eax),%edx
  802de0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802de3:	01 d0                	add    %edx,%eax
  802de5:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  802dea:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802def:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802df5:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802dfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e02:	01 d0                	add    %edx,%eax
  802e04:	48                   	dec    %eax
  802e05:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e08:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e0b:	ba 00 00 00 00       	mov    $0x0,%edx
  802e10:	f7 75 c4             	divl   -0x3c(%ebp)
  802e13:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e16:	29 d0                	sub    %edx,%eax
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	6a 01                	push   $0x1
  802e1d:	50                   	push   %eax
  802e1e:	ff 75 d0             	pushl  -0x30(%ebp)
  802e21:	e8 36 fb ff ff       	call   80295c <set_block_data>
  802e26:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802e29:	83 ec 0c             	sub    $0xc,%esp
  802e2c:	ff 75 d0             	pushl  -0x30(%ebp)
  802e2f:	e8 1b 0a 00 00       	call   80384f <free_block>
  802e34:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802e37:	83 ec 0c             	sub    $0xc,%esp
  802e3a:	ff 75 08             	pushl  0x8(%ebp)
  802e3d:	e8 49 fb ff ff       	call   80298b <alloc_block_FF>
  802e42:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e45:	c9                   	leave  
  802e46:	c3                   	ret    

00802e47 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e47:	55                   	push   %ebp
  802e48:	89 e5                	mov    %esp,%ebp
  802e4a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	83 e0 01             	and    $0x1,%eax
  802e53:	85 c0                	test   %eax,%eax
  802e55:	74 03                	je     802e5a <alloc_block_BF+0x13>
  802e57:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e5a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e5e:	77 07                	ja     802e67 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e60:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e67:	a1 24 60 80 00       	mov    0x806024,%eax
  802e6c:	85 c0                	test   %eax,%eax
  802e6e:	75 73                	jne    802ee3 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	83 c0 10             	add    $0x10,%eax
  802e76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e79:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802e80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e86:	01 d0                	add    %edx,%eax
  802e88:	48                   	dec    %eax
  802e89:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e8f:	ba 00 00 00 00       	mov    $0x0,%edx
  802e94:	f7 75 e0             	divl   -0x20(%ebp)
  802e97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9a:	29 d0                	sub    %edx,%eax
  802e9c:	c1 e8 0c             	shr    $0xc,%eax
  802e9f:	83 ec 0c             	sub    $0xc,%esp
  802ea2:	50                   	push   %eax
  802ea3:	e8 18 ec ff ff       	call   801ac0 <sbrk>
  802ea8:	83 c4 10             	add    $0x10,%esp
  802eab:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802eae:	83 ec 0c             	sub    $0xc,%esp
  802eb1:	6a 00                	push   $0x0
  802eb3:	e8 08 ec ff ff       	call   801ac0 <sbrk>
  802eb8:	83 c4 10             	add    $0x10,%esp
  802ebb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ebe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ec1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802ec4:	83 ec 08             	sub    $0x8,%esp
  802ec7:	50                   	push   %eax
  802ec8:	ff 75 d8             	pushl  -0x28(%ebp)
  802ecb:	e8 9f f8 ff ff       	call   80276f <initialize_dynamic_allocator>
  802ed0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ed3:	83 ec 0c             	sub    $0xc,%esp
  802ed6:	68 ef 4f 80 00       	push   $0x804fef
  802edb:	e8 46 de ff ff       	call   800d26 <cprintf>
  802ee0:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802ee3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802eea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ef1:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802ef8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802eff:	a1 44 60 80 00       	mov    0x806044,%eax
  802f04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f07:	e9 1d 01 00 00       	jmp    803029 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802f12:	83 ec 0c             	sub    $0xc,%esp
  802f15:	ff 75 a8             	pushl  -0x58(%ebp)
  802f18:	e8 ee f6 ff ff       	call   80260b <get_block_size>
  802f1d:	83 c4 10             	add    $0x10,%esp
  802f20:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	83 c0 08             	add    $0x8,%eax
  802f29:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f2c:	0f 87 ef 00 00 00    	ja     803021 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	83 c0 18             	add    $0x18,%eax
  802f38:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f3b:	77 1d                	ja     802f5a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f40:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f43:	0f 86 d8 00 00 00    	jbe    803021 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802f49:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802f4f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f55:	e9 c7 00 00 00       	jmp    803021 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	83 c0 08             	add    $0x8,%eax
  802f60:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f63:	0f 85 9d 00 00 00    	jne    803006 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802f69:	83 ec 04             	sub    $0x4,%esp
  802f6c:	6a 01                	push   $0x1
  802f6e:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f71:	ff 75 a8             	pushl  -0x58(%ebp)
  802f74:	e8 e3 f9 ff ff       	call   80295c <set_block_data>
  802f79:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802f7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f80:	75 17                	jne    802f99 <alloc_block_BF+0x152>
  802f82:	83 ec 04             	sub    $0x4,%esp
  802f85:	68 93 4f 80 00       	push   $0x804f93
  802f8a:	68 2c 01 00 00       	push   $0x12c
  802f8f:	68 b1 4f 80 00       	push   $0x804fb1
  802f94:	e8 d0 da ff ff       	call   800a69 <_panic>
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	8b 00                	mov    (%eax),%eax
  802f9e:	85 c0                	test   %eax,%eax
  802fa0:	74 10                	je     802fb2 <alloc_block_BF+0x16b>
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 00                	mov    (%eax),%eax
  802fa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802faa:	8b 52 04             	mov    0x4(%edx),%edx
  802fad:	89 50 04             	mov    %edx,0x4(%eax)
  802fb0:	eb 0b                	jmp    802fbd <alloc_block_BF+0x176>
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 40 04             	mov    0x4(%eax),%eax
  802fb8:	a3 48 60 80 00       	mov    %eax,0x806048
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 40 04             	mov    0x4(%eax),%eax
  802fc3:	85 c0                	test   %eax,%eax
  802fc5:	74 0f                	je     802fd6 <alloc_block_BF+0x18f>
  802fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fca:	8b 40 04             	mov    0x4(%eax),%eax
  802fcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fd0:	8b 12                	mov    (%edx),%edx
  802fd2:	89 10                	mov    %edx,(%eax)
  802fd4:	eb 0a                	jmp    802fe0 <alloc_block_BF+0x199>
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	8b 00                	mov    (%eax),%eax
  802fdb:	a3 44 60 80 00       	mov    %eax,0x806044
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff3:	a1 50 60 80 00       	mov    0x806050,%eax
  802ff8:	48                   	dec    %eax
  802ff9:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  802ffe:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803001:	e9 24 04 00 00       	jmp    80342a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803006:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803009:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80300c:	76 13                	jbe    803021 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80300e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803015:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803018:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80301b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80301e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803021:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803026:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803029:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302d:	74 07                	je     803036 <alloc_block_BF+0x1ef>
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	8b 00                	mov    (%eax),%eax
  803034:	eb 05                	jmp    80303b <alloc_block_BF+0x1f4>
  803036:	b8 00 00 00 00       	mov    $0x0,%eax
  80303b:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803040:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	0f 85 bf fe ff ff    	jne    802f0c <alloc_block_BF+0xc5>
  80304d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803051:	0f 85 b5 fe ff ff    	jne    802f0c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803057:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80305b:	0f 84 26 02 00 00    	je     803287 <alloc_block_BF+0x440>
  803061:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803065:	0f 85 1c 02 00 00    	jne    803287 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80306b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306e:	2b 45 08             	sub    0x8(%ebp),%eax
  803071:	83 e8 08             	sub    $0x8,%eax
  803074:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	8d 50 08             	lea    0x8(%eax),%edx
  80307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803080:	01 d0                	add    %edx,%eax
  803082:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	83 c0 08             	add    $0x8,%eax
  80308b:	83 ec 04             	sub    $0x4,%esp
  80308e:	6a 01                	push   $0x1
  803090:	50                   	push   %eax
  803091:	ff 75 f0             	pushl  -0x10(%ebp)
  803094:	e8 c3 f8 ff ff       	call   80295c <set_block_data>
  803099:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80309c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309f:	8b 40 04             	mov    0x4(%eax),%eax
  8030a2:	85 c0                	test   %eax,%eax
  8030a4:	75 68                	jne    80310e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030aa:	75 17                	jne    8030c3 <alloc_block_BF+0x27c>
  8030ac:	83 ec 04             	sub    $0x4,%esp
  8030af:	68 cc 4f 80 00       	push   $0x804fcc
  8030b4:	68 45 01 00 00       	push   $0x145
  8030b9:	68 b1 4f 80 00       	push   $0x804fb1
  8030be:	e8 a6 d9 ff ff       	call   800a69 <_panic>
  8030c3:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8030c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030cc:	89 10                	mov    %edx,(%eax)
  8030ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d1:	8b 00                	mov    (%eax),%eax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	74 0d                	je     8030e4 <alloc_block_BF+0x29d>
  8030d7:	a1 44 60 80 00       	mov    0x806044,%eax
  8030dc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030df:	89 50 04             	mov    %edx,0x4(%eax)
  8030e2:	eb 08                	jmp    8030ec <alloc_block_BF+0x2a5>
  8030e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030e7:	a3 48 60 80 00       	mov    %eax,0x806048
  8030ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ef:	a3 44 60 80 00       	mov    %eax,0x806044
  8030f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030fe:	a1 50 60 80 00       	mov    0x806050,%eax
  803103:	40                   	inc    %eax
  803104:	a3 50 60 80 00       	mov    %eax,0x806050
  803109:	e9 dc 00 00 00       	jmp    8031ea <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80310e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803111:	8b 00                	mov    (%eax),%eax
  803113:	85 c0                	test   %eax,%eax
  803115:	75 65                	jne    80317c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803117:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80311b:	75 17                	jne    803134 <alloc_block_BF+0x2ed>
  80311d:	83 ec 04             	sub    $0x4,%esp
  803120:	68 00 50 80 00       	push   $0x805000
  803125:	68 4a 01 00 00       	push   $0x14a
  80312a:	68 b1 4f 80 00       	push   $0x804fb1
  80312f:	e8 35 d9 ff ff       	call   800a69 <_panic>
  803134:	8b 15 48 60 80 00    	mov    0x806048,%edx
  80313a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80313d:	89 50 04             	mov    %edx,0x4(%eax)
  803140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803143:	8b 40 04             	mov    0x4(%eax),%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	74 0c                	je     803156 <alloc_block_BF+0x30f>
  80314a:	a1 48 60 80 00       	mov    0x806048,%eax
  80314f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803152:	89 10                	mov    %edx,(%eax)
  803154:	eb 08                	jmp    80315e <alloc_block_BF+0x317>
  803156:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803159:	a3 44 60 80 00       	mov    %eax,0x806044
  80315e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803161:	a3 48 60 80 00       	mov    %eax,0x806048
  803166:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316f:	a1 50 60 80 00       	mov    0x806050,%eax
  803174:	40                   	inc    %eax
  803175:	a3 50 60 80 00       	mov    %eax,0x806050
  80317a:	eb 6e                	jmp    8031ea <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80317c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803180:	74 06                	je     803188 <alloc_block_BF+0x341>
  803182:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803186:	75 17                	jne    80319f <alloc_block_BF+0x358>
  803188:	83 ec 04             	sub    $0x4,%esp
  80318b:	68 24 50 80 00       	push   $0x805024
  803190:	68 4f 01 00 00       	push   $0x14f
  803195:	68 b1 4f 80 00       	push   $0x804fb1
  80319a:	e8 ca d8 ff ff       	call   800a69 <_panic>
  80319f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a2:	8b 10                	mov    (%eax),%edx
  8031a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031a7:	89 10                	mov    %edx,(%eax)
  8031a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 0b                	je     8031bd <alloc_block_BF+0x376>
  8031b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031ba:	89 50 04             	mov    %edx,0x4(%eax)
  8031bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031c3:	89 10                	mov    %edx,(%eax)
  8031c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031cb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	75 08                	jne    8031df <alloc_block_BF+0x398>
  8031d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031da:	a3 48 60 80 00       	mov    %eax,0x806048
  8031df:	a1 50 60 80 00       	mov    0x806050,%eax
  8031e4:	40                   	inc    %eax
  8031e5:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8031ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031ee:	75 17                	jne    803207 <alloc_block_BF+0x3c0>
  8031f0:	83 ec 04             	sub    $0x4,%esp
  8031f3:	68 93 4f 80 00       	push   $0x804f93
  8031f8:	68 51 01 00 00       	push   $0x151
  8031fd:	68 b1 4f 80 00       	push   $0x804fb1
  803202:	e8 62 d8 ff ff       	call   800a69 <_panic>
  803207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	85 c0                	test   %eax,%eax
  80320e:	74 10                	je     803220 <alloc_block_BF+0x3d9>
  803210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803218:	8b 52 04             	mov    0x4(%edx),%edx
  80321b:	89 50 04             	mov    %edx,0x4(%eax)
  80321e:	eb 0b                	jmp    80322b <alloc_block_BF+0x3e4>
  803220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803223:	8b 40 04             	mov    0x4(%eax),%eax
  803226:	a3 48 60 80 00       	mov    %eax,0x806048
  80322b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322e:	8b 40 04             	mov    0x4(%eax),%eax
  803231:	85 c0                	test   %eax,%eax
  803233:	74 0f                	je     803244 <alloc_block_BF+0x3fd>
  803235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803238:	8b 40 04             	mov    0x4(%eax),%eax
  80323b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80323e:	8b 12                	mov    (%edx),%edx
  803240:	89 10                	mov    %edx,(%eax)
  803242:	eb 0a                	jmp    80324e <alloc_block_BF+0x407>
  803244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	a3 44 60 80 00       	mov    %eax,0x806044
  80324e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803257:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803261:	a1 50 60 80 00       	mov    0x806050,%eax
  803266:	48                   	dec    %eax
  803267:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  80326c:	83 ec 04             	sub    $0x4,%esp
  80326f:	6a 00                	push   $0x0
  803271:	ff 75 d0             	pushl  -0x30(%ebp)
  803274:	ff 75 cc             	pushl  -0x34(%ebp)
  803277:	e8 e0 f6 ff ff       	call   80295c <set_block_data>
  80327c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80327f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803282:	e9 a3 01 00 00       	jmp    80342a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803287:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80328b:	0f 85 9d 00 00 00    	jne    80332e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803291:	83 ec 04             	sub    $0x4,%esp
  803294:	6a 01                	push   $0x1
  803296:	ff 75 ec             	pushl  -0x14(%ebp)
  803299:	ff 75 f0             	pushl  -0x10(%ebp)
  80329c:	e8 bb f6 ff ff       	call   80295c <set_block_data>
  8032a1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8032a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032a8:	75 17                	jne    8032c1 <alloc_block_BF+0x47a>
  8032aa:	83 ec 04             	sub    $0x4,%esp
  8032ad:	68 93 4f 80 00       	push   $0x804f93
  8032b2:	68 58 01 00 00       	push   $0x158
  8032b7:	68 b1 4f 80 00       	push   $0x804fb1
  8032bc:	e8 a8 d7 ff ff       	call   800a69 <_panic>
  8032c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c4:	8b 00                	mov    (%eax),%eax
  8032c6:	85 c0                	test   %eax,%eax
  8032c8:	74 10                	je     8032da <alloc_block_BF+0x493>
  8032ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cd:	8b 00                	mov    (%eax),%eax
  8032cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032d2:	8b 52 04             	mov    0x4(%edx),%edx
  8032d5:	89 50 04             	mov    %edx,0x4(%eax)
  8032d8:	eb 0b                	jmp    8032e5 <alloc_block_BF+0x49e>
  8032da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032dd:	8b 40 04             	mov    0x4(%eax),%eax
  8032e0:	a3 48 60 80 00       	mov    %eax,0x806048
  8032e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e8:	8b 40 04             	mov    0x4(%eax),%eax
  8032eb:	85 c0                	test   %eax,%eax
  8032ed:	74 0f                	je     8032fe <alloc_block_BF+0x4b7>
  8032ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f2:	8b 40 04             	mov    0x4(%eax),%eax
  8032f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032f8:	8b 12                	mov    (%edx),%edx
  8032fa:	89 10                	mov    %edx,(%eax)
  8032fc:	eb 0a                	jmp    803308 <alloc_block_BF+0x4c1>
  8032fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803301:	8b 00                	mov    (%eax),%eax
  803303:	a3 44 60 80 00       	mov    %eax,0x806044
  803308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803314:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331b:	a1 50 60 80 00       	mov    0x806050,%eax
  803320:	48                   	dec    %eax
  803321:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  803326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803329:	e9 fc 00 00 00       	jmp    80342a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	83 c0 08             	add    $0x8,%eax
  803334:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803337:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80333e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803341:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803344:	01 d0                	add    %edx,%eax
  803346:	48                   	dec    %eax
  803347:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80334a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80334d:	ba 00 00 00 00       	mov    $0x0,%edx
  803352:	f7 75 c4             	divl   -0x3c(%ebp)
  803355:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803358:	29 d0                	sub    %edx,%eax
  80335a:	c1 e8 0c             	shr    $0xc,%eax
  80335d:	83 ec 0c             	sub    $0xc,%esp
  803360:	50                   	push   %eax
  803361:	e8 5a e7 ff ff       	call   801ac0 <sbrk>
  803366:	83 c4 10             	add    $0x10,%esp
  803369:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80336c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803370:	75 0a                	jne    80337c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803372:	b8 00 00 00 00       	mov    $0x0,%eax
  803377:	e9 ae 00 00 00       	jmp    80342a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80337c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803383:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803386:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803389:	01 d0                	add    %edx,%eax
  80338b:	48                   	dec    %eax
  80338c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80338f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803392:	ba 00 00 00 00       	mov    $0x0,%edx
  803397:	f7 75 b8             	divl   -0x48(%ebp)
  80339a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80339d:	29 d0                	sub    %edx,%eax
  80339f:	8d 50 fc             	lea    -0x4(%eax),%edx
  8033a2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8033a5:	01 d0                	add    %edx,%eax
  8033a7:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  8033ac:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8033b1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8033b7:	83 ec 0c             	sub    $0xc,%esp
  8033ba:	68 58 50 80 00       	push   $0x805058
  8033bf:	e8 62 d9 ff ff       	call   800d26 <cprintf>
  8033c4:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8033c7:	83 ec 08             	sub    $0x8,%esp
  8033ca:	ff 75 bc             	pushl  -0x44(%ebp)
  8033cd:	68 5d 50 80 00       	push   $0x80505d
  8033d2:	e8 4f d9 ff ff       	call   800d26 <cprintf>
  8033d7:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8033da:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8033e1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033e7:	01 d0                	add    %edx,%eax
  8033e9:	48                   	dec    %eax
  8033ea:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8033ed:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8033f5:	f7 75 b0             	divl   -0x50(%ebp)
  8033f8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033fb:	29 d0                	sub    %edx,%eax
  8033fd:	83 ec 04             	sub    $0x4,%esp
  803400:	6a 01                	push   $0x1
  803402:	50                   	push   %eax
  803403:	ff 75 bc             	pushl  -0x44(%ebp)
  803406:	e8 51 f5 ff ff       	call   80295c <set_block_data>
  80340b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80340e:	83 ec 0c             	sub    $0xc,%esp
  803411:	ff 75 bc             	pushl  -0x44(%ebp)
  803414:	e8 36 04 00 00       	call   80384f <free_block>
  803419:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80341c:	83 ec 0c             	sub    $0xc,%esp
  80341f:	ff 75 08             	pushl  0x8(%ebp)
  803422:	e8 20 fa ff ff       	call   802e47 <alloc_block_BF>
  803427:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80342a:	c9                   	leave  
  80342b:	c3                   	ret    

0080342c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80342c:	55                   	push   %ebp
  80342d:	89 e5                	mov    %esp,%ebp
  80342f:	53                   	push   %ebx
  803430:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803433:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80343a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803441:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803445:	74 1e                	je     803465 <merging+0x39>
  803447:	ff 75 08             	pushl  0x8(%ebp)
  80344a:	e8 bc f1 ff ff       	call   80260b <get_block_size>
  80344f:	83 c4 04             	add    $0x4,%esp
  803452:	89 c2                	mov    %eax,%edx
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	01 d0                	add    %edx,%eax
  803459:	3b 45 10             	cmp    0x10(%ebp),%eax
  80345c:	75 07                	jne    803465 <merging+0x39>
		prev_is_free = 1;
  80345e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803465:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803469:	74 1e                	je     803489 <merging+0x5d>
  80346b:	ff 75 10             	pushl  0x10(%ebp)
  80346e:	e8 98 f1 ff ff       	call   80260b <get_block_size>
  803473:	83 c4 04             	add    $0x4,%esp
  803476:	89 c2                	mov    %eax,%edx
  803478:	8b 45 10             	mov    0x10(%ebp),%eax
  80347b:	01 d0                	add    %edx,%eax
  80347d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803480:	75 07                	jne    803489 <merging+0x5d>
		next_is_free = 1;
  803482:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348d:	0f 84 cc 00 00 00    	je     80355f <merging+0x133>
  803493:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803497:	0f 84 c2 00 00 00    	je     80355f <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80349d:	ff 75 08             	pushl  0x8(%ebp)
  8034a0:	e8 66 f1 ff ff       	call   80260b <get_block_size>
  8034a5:	83 c4 04             	add    $0x4,%esp
  8034a8:	89 c3                	mov    %eax,%ebx
  8034aa:	ff 75 10             	pushl  0x10(%ebp)
  8034ad:	e8 59 f1 ff ff       	call   80260b <get_block_size>
  8034b2:	83 c4 04             	add    $0x4,%esp
  8034b5:	01 c3                	add    %eax,%ebx
  8034b7:	ff 75 0c             	pushl  0xc(%ebp)
  8034ba:	e8 4c f1 ff ff       	call   80260b <get_block_size>
  8034bf:	83 c4 04             	add    $0x4,%esp
  8034c2:	01 d8                	add    %ebx,%eax
  8034c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034c7:	6a 00                	push   $0x0
  8034c9:	ff 75 ec             	pushl  -0x14(%ebp)
  8034cc:	ff 75 08             	pushl  0x8(%ebp)
  8034cf:	e8 88 f4 ff ff       	call   80295c <set_block_data>
  8034d4:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8034d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034db:	75 17                	jne    8034f4 <merging+0xc8>
  8034dd:	83 ec 04             	sub    $0x4,%esp
  8034e0:	68 93 4f 80 00       	push   $0x804f93
  8034e5:	68 7d 01 00 00       	push   $0x17d
  8034ea:	68 b1 4f 80 00       	push   $0x804fb1
  8034ef:	e8 75 d5 ff ff       	call   800a69 <_panic>
  8034f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f7:	8b 00                	mov    (%eax),%eax
  8034f9:	85 c0                	test   %eax,%eax
  8034fb:	74 10                	je     80350d <merging+0xe1>
  8034fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803500:	8b 00                	mov    (%eax),%eax
  803502:	8b 55 0c             	mov    0xc(%ebp),%edx
  803505:	8b 52 04             	mov    0x4(%edx),%edx
  803508:	89 50 04             	mov    %edx,0x4(%eax)
  80350b:	eb 0b                	jmp    803518 <merging+0xec>
  80350d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803510:	8b 40 04             	mov    0x4(%eax),%eax
  803513:	a3 48 60 80 00       	mov    %eax,0x806048
  803518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351b:	8b 40 04             	mov    0x4(%eax),%eax
  80351e:	85 c0                	test   %eax,%eax
  803520:	74 0f                	je     803531 <merging+0x105>
  803522:	8b 45 0c             	mov    0xc(%ebp),%eax
  803525:	8b 40 04             	mov    0x4(%eax),%eax
  803528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80352b:	8b 12                	mov    (%edx),%edx
  80352d:	89 10                	mov    %edx,(%eax)
  80352f:	eb 0a                	jmp    80353b <merging+0x10f>
  803531:	8b 45 0c             	mov    0xc(%ebp),%eax
  803534:	8b 00                	mov    (%eax),%eax
  803536:	a3 44 60 80 00       	mov    %eax,0x806044
  80353b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80353e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803544:	8b 45 0c             	mov    0xc(%ebp),%eax
  803547:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354e:	a1 50 60 80 00       	mov    0x806050,%eax
  803553:	48                   	dec    %eax
  803554:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803559:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80355a:	e9 ea 02 00 00       	jmp    803849 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80355f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803563:	74 3b                	je     8035a0 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803565:	83 ec 0c             	sub    $0xc,%esp
  803568:	ff 75 08             	pushl  0x8(%ebp)
  80356b:	e8 9b f0 ff ff       	call   80260b <get_block_size>
  803570:	83 c4 10             	add    $0x10,%esp
  803573:	89 c3                	mov    %eax,%ebx
  803575:	83 ec 0c             	sub    $0xc,%esp
  803578:	ff 75 10             	pushl  0x10(%ebp)
  80357b:	e8 8b f0 ff ff       	call   80260b <get_block_size>
  803580:	83 c4 10             	add    $0x10,%esp
  803583:	01 d8                	add    %ebx,%eax
  803585:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803588:	83 ec 04             	sub    $0x4,%esp
  80358b:	6a 00                	push   $0x0
  80358d:	ff 75 e8             	pushl  -0x18(%ebp)
  803590:	ff 75 08             	pushl  0x8(%ebp)
  803593:	e8 c4 f3 ff ff       	call   80295c <set_block_data>
  803598:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80359b:	e9 a9 02 00 00       	jmp    803849 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8035a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035a4:	0f 84 2d 01 00 00    	je     8036d7 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8035aa:	83 ec 0c             	sub    $0xc,%esp
  8035ad:	ff 75 10             	pushl  0x10(%ebp)
  8035b0:	e8 56 f0 ff ff       	call   80260b <get_block_size>
  8035b5:	83 c4 10             	add    $0x10,%esp
  8035b8:	89 c3                	mov    %eax,%ebx
  8035ba:	83 ec 0c             	sub    $0xc,%esp
  8035bd:	ff 75 0c             	pushl  0xc(%ebp)
  8035c0:	e8 46 f0 ff ff       	call   80260b <get_block_size>
  8035c5:	83 c4 10             	add    $0x10,%esp
  8035c8:	01 d8                	add    %ebx,%eax
  8035ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8035cd:	83 ec 04             	sub    $0x4,%esp
  8035d0:	6a 00                	push   $0x0
  8035d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035d5:	ff 75 10             	pushl  0x10(%ebp)
  8035d8:	e8 7f f3 ff ff       	call   80295c <set_block_data>
  8035dd:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8035e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8035e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8035e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035ea:	74 06                	je     8035f2 <merging+0x1c6>
  8035ec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035f0:	75 17                	jne    803609 <merging+0x1dd>
  8035f2:	83 ec 04             	sub    $0x4,%esp
  8035f5:	68 6c 50 80 00       	push   $0x80506c
  8035fa:	68 8d 01 00 00       	push   $0x18d
  8035ff:	68 b1 4f 80 00       	push   $0x804fb1
  803604:	e8 60 d4 ff ff       	call   800a69 <_panic>
  803609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360c:	8b 50 04             	mov    0x4(%eax),%edx
  80360f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803612:	89 50 04             	mov    %edx,0x4(%eax)
  803615:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803618:	8b 55 0c             	mov    0xc(%ebp),%edx
  80361b:	89 10                	mov    %edx,(%eax)
  80361d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803620:	8b 40 04             	mov    0x4(%eax),%eax
  803623:	85 c0                	test   %eax,%eax
  803625:	74 0d                	je     803634 <merging+0x208>
  803627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362a:	8b 40 04             	mov    0x4(%eax),%eax
  80362d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803630:	89 10                	mov    %edx,(%eax)
  803632:	eb 08                	jmp    80363c <merging+0x210>
  803634:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803637:	a3 44 60 80 00       	mov    %eax,0x806044
  80363c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80363f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803642:	89 50 04             	mov    %edx,0x4(%eax)
  803645:	a1 50 60 80 00       	mov    0x806050,%eax
  80364a:	40                   	inc    %eax
  80364b:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  803650:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803654:	75 17                	jne    80366d <merging+0x241>
  803656:	83 ec 04             	sub    $0x4,%esp
  803659:	68 93 4f 80 00       	push   $0x804f93
  80365e:	68 8e 01 00 00       	push   $0x18e
  803663:	68 b1 4f 80 00       	push   $0x804fb1
  803668:	e8 fc d3 ff ff       	call   800a69 <_panic>
  80366d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803670:	8b 00                	mov    (%eax),%eax
  803672:	85 c0                	test   %eax,%eax
  803674:	74 10                	je     803686 <merging+0x25a>
  803676:	8b 45 0c             	mov    0xc(%ebp),%eax
  803679:	8b 00                	mov    (%eax),%eax
  80367b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80367e:	8b 52 04             	mov    0x4(%edx),%edx
  803681:	89 50 04             	mov    %edx,0x4(%eax)
  803684:	eb 0b                	jmp    803691 <merging+0x265>
  803686:	8b 45 0c             	mov    0xc(%ebp),%eax
  803689:	8b 40 04             	mov    0x4(%eax),%eax
  80368c:	a3 48 60 80 00       	mov    %eax,0x806048
  803691:	8b 45 0c             	mov    0xc(%ebp),%eax
  803694:	8b 40 04             	mov    0x4(%eax),%eax
  803697:	85 c0                	test   %eax,%eax
  803699:	74 0f                	je     8036aa <merging+0x27e>
  80369b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369e:	8b 40 04             	mov    0x4(%eax),%eax
  8036a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036a4:	8b 12                	mov    (%edx),%edx
  8036a6:	89 10                	mov    %edx,(%eax)
  8036a8:	eb 0a                	jmp    8036b4 <merging+0x288>
  8036aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	a3 44 60 80 00       	mov    %eax,0x806044
  8036b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c7:	a1 50 60 80 00       	mov    0x806050,%eax
  8036cc:	48                   	dec    %eax
  8036cd:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036d2:	e9 72 01 00 00       	jmp    803849 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8036d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8036da:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8036dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e1:	74 79                	je     80375c <merging+0x330>
  8036e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036e7:	74 73                	je     80375c <merging+0x330>
  8036e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ed:	74 06                	je     8036f5 <merging+0x2c9>
  8036ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036f3:	75 17                	jne    80370c <merging+0x2e0>
  8036f5:	83 ec 04             	sub    $0x4,%esp
  8036f8:	68 24 50 80 00       	push   $0x805024
  8036fd:	68 94 01 00 00       	push   $0x194
  803702:	68 b1 4f 80 00       	push   $0x804fb1
  803707:	e8 5d d3 ff ff       	call   800a69 <_panic>
  80370c:	8b 45 08             	mov    0x8(%ebp),%eax
  80370f:	8b 10                	mov    (%eax),%edx
  803711:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803714:	89 10                	mov    %edx,(%eax)
  803716:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803719:	8b 00                	mov    (%eax),%eax
  80371b:	85 c0                	test   %eax,%eax
  80371d:	74 0b                	je     80372a <merging+0x2fe>
  80371f:	8b 45 08             	mov    0x8(%ebp),%eax
  803722:	8b 00                	mov    (%eax),%eax
  803724:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803727:	89 50 04             	mov    %edx,0x4(%eax)
  80372a:	8b 45 08             	mov    0x8(%ebp),%eax
  80372d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803730:	89 10                	mov    %edx,(%eax)
  803732:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803735:	8b 55 08             	mov    0x8(%ebp),%edx
  803738:	89 50 04             	mov    %edx,0x4(%eax)
  80373b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80373e:	8b 00                	mov    (%eax),%eax
  803740:	85 c0                	test   %eax,%eax
  803742:	75 08                	jne    80374c <merging+0x320>
  803744:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803747:	a3 48 60 80 00       	mov    %eax,0x806048
  80374c:	a1 50 60 80 00       	mov    0x806050,%eax
  803751:	40                   	inc    %eax
  803752:	a3 50 60 80 00       	mov    %eax,0x806050
  803757:	e9 ce 00 00 00       	jmp    80382a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80375c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803760:	74 65                	je     8037c7 <merging+0x39b>
  803762:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803766:	75 17                	jne    80377f <merging+0x353>
  803768:	83 ec 04             	sub    $0x4,%esp
  80376b:	68 00 50 80 00       	push   $0x805000
  803770:	68 95 01 00 00       	push   $0x195
  803775:	68 b1 4f 80 00       	push   $0x804fb1
  80377a:	e8 ea d2 ff ff       	call   800a69 <_panic>
  80377f:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803785:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803788:	89 50 04             	mov    %edx,0x4(%eax)
  80378b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378e:	8b 40 04             	mov    0x4(%eax),%eax
  803791:	85 c0                	test   %eax,%eax
  803793:	74 0c                	je     8037a1 <merging+0x375>
  803795:	a1 48 60 80 00       	mov    0x806048,%eax
  80379a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80379d:	89 10                	mov    %edx,(%eax)
  80379f:	eb 08                	jmp    8037a9 <merging+0x37d>
  8037a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037a4:	a3 44 60 80 00       	mov    %eax,0x806044
  8037a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ac:	a3 48 60 80 00       	mov    %eax,0x806048
  8037b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037ba:	a1 50 60 80 00       	mov    0x806050,%eax
  8037bf:	40                   	inc    %eax
  8037c0:	a3 50 60 80 00       	mov    %eax,0x806050
  8037c5:	eb 63                	jmp    80382a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8037c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037cb:	75 17                	jne    8037e4 <merging+0x3b8>
  8037cd:	83 ec 04             	sub    $0x4,%esp
  8037d0:	68 cc 4f 80 00       	push   $0x804fcc
  8037d5:	68 98 01 00 00       	push   $0x198
  8037da:	68 b1 4f 80 00       	push   $0x804fb1
  8037df:	e8 85 d2 ff ff       	call   800a69 <_panic>
  8037e4:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8037ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ed:	89 10                	mov    %edx,(%eax)
  8037ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f2:	8b 00                	mov    (%eax),%eax
  8037f4:	85 c0                	test   %eax,%eax
  8037f6:	74 0d                	je     803805 <merging+0x3d9>
  8037f8:	a1 44 60 80 00       	mov    0x806044,%eax
  8037fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803800:	89 50 04             	mov    %edx,0x4(%eax)
  803803:	eb 08                	jmp    80380d <merging+0x3e1>
  803805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803808:	a3 48 60 80 00       	mov    %eax,0x806048
  80380d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803810:	a3 44 60 80 00       	mov    %eax,0x806044
  803815:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803818:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80381f:	a1 50 60 80 00       	mov    0x806050,%eax
  803824:	40                   	inc    %eax
  803825:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  80382a:	83 ec 0c             	sub    $0xc,%esp
  80382d:	ff 75 10             	pushl  0x10(%ebp)
  803830:	e8 d6 ed ff ff       	call   80260b <get_block_size>
  803835:	83 c4 10             	add    $0x10,%esp
  803838:	83 ec 04             	sub    $0x4,%esp
  80383b:	6a 00                	push   $0x0
  80383d:	50                   	push   %eax
  80383e:	ff 75 10             	pushl  0x10(%ebp)
  803841:	e8 16 f1 ff ff       	call   80295c <set_block_data>
  803846:	83 c4 10             	add    $0x10,%esp
	}
}
  803849:	90                   	nop
  80384a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80384d:	c9                   	leave  
  80384e:	c3                   	ret    

0080384f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80384f:	55                   	push   %ebp
  803850:	89 e5                	mov    %esp,%ebp
  803852:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803855:	a1 44 60 80 00       	mov    0x806044,%eax
  80385a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80385d:	a1 48 60 80 00       	mov    0x806048,%eax
  803862:	3b 45 08             	cmp    0x8(%ebp),%eax
  803865:	73 1b                	jae    803882 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803867:	a1 48 60 80 00       	mov    0x806048,%eax
  80386c:	83 ec 04             	sub    $0x4,%esp
  80386f:	ff 75 08             	pushl  0x8(%ebp)
  803872:	6a 00                	push   $0x0
  803874:	50                   	push   %eax
  803875:	e8 b2 fb ff ff       	call   80342c <merging>
  80387a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80387d:	e9 8b 00 00 00       	jmp    80390d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803882:	a1 44 60 80 00       	mov    0x806044,%eax
  803887:	3b 45 08             	cmp    0x8(%ebp),%eax
  80388a:	76 18                	jbe    8038a4 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80388c:	a1 44 60 80 00       	mov    0x806044,%eax
  803891:	83 ec 04             	sub    $0x4,%esp
  803894:	ff 75 08             	pushl  0x8(%ebp)
  803897:	50                   	push   %eax
  803898:	6a 00                	push   $0x0
  80389a:	e8 8d fb ff ff       	call   80342c <merging>
  80389f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038a2:	eb 69                	jmp    80390d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038a4:	a1 44 60 80 00       	mov    0x806044,%eax
  8038a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038ac:	eb 39                	jmp    8038e7 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8038ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038b4:	73 29                	jae    8038df <free_block+0x90>
  8038b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b9:	8b 00                	mov    (%eax),%eax
  8038bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038be:	76 1f                	jbe    8038df <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8038c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c3:	8b 00                	mov    (%eax),%eax
  8038c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8038c8:	83 ec 04             	sub    $0x4,%esp
  8038cb:	ff 75 08             	pushl  0x8(%ebp)
  8038ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8038d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8038d4:	e8 53 fb ff ff       	call   80342c <merging>
  8038d9:	83 c4 10             	add    $0x10,%esp
			break;
  8038dc:	90                   	nop
		}
	}
}
  8038dd:	eb 2e                	jmp    80390d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038df:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8038e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038eb:	74 07                	je     8038f4 <free_block+0xa5>
  8038ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f0:	8b 00                	mov    (%eax),%eax
  8038f2:	eb 05                	jmp    8038f9 <free_block+0xaa>
  8038f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038f9:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8038fe:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803903:	85 c0                	test   %eax,%eax
  803905:	75 a7                	jne    8038ae <free_block+0x5f>
  803907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80390b:	75 a1                	jne    8038ae <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80390d:	90                   	nop
  80390e:	c9                   	leave  
  80390f:	c3                   	ret    

00803910 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803910:	55                   	push   %ebp
  803911:	89 e5                	mov    %esp,%ebp
  803913:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803916:	ff 75 08             	pushl  0x8(%ebp)
  803919:	e8 ed ec ff ff       	call   80260b <get_block_size>
  80391e:	83 c4 04             	add    $0x4,%esp
  803921:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80392b:	eb 17                	jmp    803944 <copy_data+0x34>
  80392d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803930:	8b 45 0c             	mov    0xc(%ebp),%eax
  803933:	01 c2                	add    %eax,%edx
  803935:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803938:	8b 45 08             	mov    0x8(%ebp),%eax
  80393b:	01 c8                	add    %ecx,%eax
  80393d:	8a 00                	mov    (%eax),%al
  80393f:	88 02                	mov    %al,(%edx)
  803941:	ff 45 fc             	incl   -0x4(%ebp)
  803944:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803947:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80394a:	72 e1                	jb     80392d <copy_data+0x1d>
}
  80394c:	90                   	nop
  80394d:	c9                   	leave  
  80394e:	c3                   	ret    

0080394f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80394f:	55                   	push   %ebp
  803950:	89 e5                	mov    %esp,%ebp
  803952:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803955:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803959:	75 23                	jne    80397e <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80395b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80395f:	74 13                	je     803974 <realloc_block_FF+0x25>
  803961:	83 ec 0c             	sub    $0xc,%esp
  803964:	ff 75 0c             	pushl  0xc(%ebp)
  803967:	e8 1f f0 ff ff       	call   80298b <alloc_block_FF>
  80396c:	83 c4 10             	add    $0x10,%esp
  80396f:	e9 f4 06 00 00       	jmp    804068 <realloc_block_FF+0x719>
		return NULL;
  803974:	b8 00 00 00 00       	mov    $0x0,%eax
  803979:	e9 ea 06 00 00       	jmp    804068 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80397e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803982:	75 18                	jne    80399c <realloc_block_FF+0x4d>
	{
		free_block(va);
  803984:	83 ec 0c             	sub    $0xc,%esp
  803987:	ff 75 08             	pushl  0x8(%ebp)
  80398a:	e8 c0 fe ff ff       	call   80384f <free_block>
  80398f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803992:	b8 00 00 00 00       	mov    $0x0,%eax
  803997:	e9 cc 06 00 00       	jmp    804068 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80399c:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8039a0:	77 07                	ja     8039a9 <realloc_block_FF+0x5a>
  8039a2:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8039a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ac:	83 e0 01             	and    $0x1,%eax
  8039af:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8039b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039b5:	83 c0 08             	add    $0x8,%eax
  8039b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8039bb:	83 ec 0c             	sub    $0xc,%esp
  8039be:	ff 75 08             	pushl  0x8(%ebp)
  8039c1:	e8 45 ec ff ff       	call   80260b <get_block_size>
  8039c6:	83 c4 10             	add    $0x10,%esp
  8039c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039cf:	83 e8 08             	sub    $0x8,%eax
  8039d2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8039d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d8:	83 e8 04             	sub    $0x4,%eax
  8039db:	8b 00                	mov    (%eax),%eax
  8039dd:	83 e0 fe             	and    $0xfffffffe,%eax
  8039e0:	89 c2                	mov    %eax,%edx
  8039e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e5:	01 d0                	add    %edx,%eax
  8039e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8039ea:	83 ec 0c             	sub    $0xc,%esp
  8039ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039f0:	e8 16 ec ff ff       	call   80260b <get_block_size>
  8039f5:	83 c4 10             	add    $0x10,%esp
  8039f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039fe:	83 e8 08             	sub    $0x8,%eax
  803a01:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a07:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a0a:	75 08                	jne    803a14 <realloc_block_FF+0xc5>
	{
		 return va;
  803a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0f:	e9 54 06 00 00       	jmp    804068 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a17:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a1a:	0f 83 e5 03 00 00    	jae    803e05 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a23:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a26:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803a29:	83 ec 0c             	sub    $0xc,%esp
  803a2c:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a2f:	e8 f0 eb ff ff       	call   802624 <is_free_block>
  803a34:	83 c4 10             	add    $0x10,%esp
  803a37:	84 c0                	test   %al,%al
  803a39:	0f 84 3b 01 00 00    	je     803b7a <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a42:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a45:	01 d0                	add    %edx,%eax
  803a47:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a4a:	83 ec 04             	sub    $0x4,%esp
  803a4d:	6a 01                	push   $0x1
  803a4f:	ff 75 f0             	pushl  -0x10(%ebp)
  803a52:	ff 75 08             	pushl  0x8(%ebp)
  803a55:	e8 02 ef ff ff       	call   80295c <set_block_data>
  803a5a:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a60:	83 e8 04             	sub    $0x4,%eax
  803a63:	8b 00                	mov    (%eax),%eax
  803a65:	83 e0 fe             	and    $0xfffffffe,%eax
  803a68:	89 c2                	mov    %eax,%edx
  803a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6d:	01 d0                	add    %edx,%eax
  803a6f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803a72:	83 ec 04             	sub    $0x4,%esp
  803a75:	6a 00                	push   $0x0
  803a77:	ff 75 cc             	pushl  -0x34(%ebp)
  803a7a:	ff 75 c8             	pushl  -0x38(%ebp)
  803a7d:	e8 da ee ff ff       	call   80295c <set_block_data>
  803a82:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a89:	74 06                	je     803a91 <realloc_block_FF+0x142>
  803a8b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a8f:	75 17                	jne    803aa8 <realloc_block_FF+0x159>
  803a91:	83 ec 04             	sub    $0x4,%esp
  803a94:	68 24 50 80 00       	push   $0x805024
  803a99:	68 f6 01 00 00       	push   $0x1f6
  803a9e:	68 b1 4f 80 00       	push   $0x804fb1
  803aa3:	e8 c1 cf ff ff       	call   800a69 <_panic>
  803aa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aab:	8b 10                	mov    (%eax),%edx
  803aad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ab0:	89 10                	mov    %edx,(%eax)
  803ab2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ab5:	8b 00                	mov    (%eax),%eax
  803ab7:	85 c0                	test   %eax,%eax
  803ab9:	74 0b                	je     803ac6 <realloc_block_FF+0x177>
  803abb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abe:	8b 00                	mov    (%eax),%eax
  803ac0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ac3:	89 50 04             	mov    %edx,0x4(%eax)
  803ac6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803acc:	89 10                	mov    %edx,(%eax)
  803ace:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad4:	89 50 04             	mov    %edx,0x4(%eax)
  803ad7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ada:	8b 00                	mov    (%eax),%eax
  803adc:	85 c0                	test   %eax,%eax
  803ade:	75 08                	jne    803ae8 <realloc_block_FF+0x199>
  803ae0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ae3:	a3 48 60 80 00       	mov    %eax,0x806048
  803ae8:	a1 50 60 80 00       	mov    0x806050,%eax
  803aed:	40                   	inc    %eax
  803aee:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803af3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803af7:	75 17                	jne    803b10 <realloc_block_FF+0x1c1>
  803af9:	83 ec 04             	sub    $0x4,%esp
  803afc:	68 93 4f 80 00       	push   $0x804f93
  803b01:	68 f7 01 00 00       	push   $0x1f7
  803b06:	68 b1 4f 80 00       	push   $0x804fb1
  803b0b:	e8 59 cf ff ff       	call   800a69 <_panic>
  803b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b13:	8b 00                	mov    (%eax),%eax
  803b15:	85 c0                	test   %eax,%eax
  803b17:	74 10                	je     803b29 <realloc_block_FF+0x1da>
  803b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1c:	8b 00                	mov    (%eax),%eax
  803b1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b21:	8b 52 04             	mov    0x4(%edx),%edx
  803b24:	89 50 04             	mov    %edx,0x4(%eax)
  803b27:	eb 0b                	jmp    803b34 <realloc_block_FF+0x1e5>
  803b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b2c:	8b 40 04             	mov    0x4(%eax),%eax
  803b2f:	a3 48 60 80 00       	mov    %eax,0x806048
  803b34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b37:	8b 40 04             	mov    0x4(%eax),%eax
  803b3a:	85 c0                	test   %eax,%eax
  803b3c:	74 0f                	je     803b4d <realloc_block_FF+0x1fe>
  803b3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b41:	8b 40 04             	mov    0x4(%eax),%eax
  803b44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b47:	8b 12                	mov    (%edx),%edx
  803b49:	89 10                	mov    %edx,(%eax)
  803b4b:	eb 0a                	jmp    803b57 <realloc_block_FF+0x208>
  803b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b50:	8b 00                	mov    (%eax),%eax
  803b52:	a3 44 60 80 00       	mov    %eax,0x806044
  803b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b6a:	a1 50 60 80 00       	mov    0x806050,%eax
  803b6f:	48                   	dec    %eax
  803b70:	a3 50 60 80 00       	mov    %eax,0x806050
  803b75:	e9 83 02 00 00       	jmp    803dfd <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803b7a:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803b7e:	0f 86 69 02 00 00    	jbe    803ded <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803b84:	83 ec 04             	sub    $0x4,%esp
  803b87:	6a 01                	push   $0x1
  803b89:	ff 75 f0             	pushl  -0x10(%ebp)
  803b8c:	ff 75 08             	pushl  0x8(%ebp)
  803b8f:	e8 c8 ed ff ff       	call   80295c <set_block_data>
  803b94:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b97:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9a:	83 e8 04             	sub    $0x4,%eax
  803b9d:	8b 00                	mov    (%eax),%eax
  803b9f:	83 e0 fe             	and    $0xfffffffe,%eax
  803ba2:	89 c2                	mov    %eax,%edx
  803ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba7:	01 d0                	add    %edx,%eax
  803ba9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803bac:	a1 50 60 80 00       	mov    0x806050,%eax
  803bb1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803bb4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803bb8:	75 68                	jne    803c22 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803bba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bbe:	75 17                	jne    803bd7 <realloc_block_FF+0x288>
  803bc0:	83 ec 04             	sub    $0x4,%esp
  803bc3:	68 cc 4f 80 00       	push   $0x804fcc
  803bc8:	68 06 02 00 00       	push   $0x206
  803bcd:	68 b1 4f 80 00       	push   $0x804fb1
  803bd2:	e8 92 ce ff ff       	call   800a69 <_panic>
  803bd7:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803bdd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be0:	89 10                	mov    %edx,(%eax)
  803be2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be5:	8b 00                	mov    (%eax),%eax
  803be7:	85 c0                	test   %eax,%eax
  803be9:	74 0d                	je     803bf8 <realloc_block_FF+0x2a9>
  803beb:	a1 44 60 80 00       	mov    0x806044,%eax
  803bf0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bf3:	89 50 04             	mov    %edx,0x4(%eax)
  803bf6:	eb 08                	jmp    803c00 <realloc_block_FF+0x2b1>
  803bf8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bfb:	a3 48 60 80 00       	mov    %eax,0x806048
  803c00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c03:	a3 44 60 80 00       	mov    %eax,0x806044
  803c08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c12:	a1 50 60 80 00       	mov    0x806050,%eax
  803c17:	40                   	inc    %eax
  803c18:	a3 50 60 80 00       	mov    %eax,0x806050
  803c1d:	e9 b0 01 00 00       	jmp    803dd2 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803c22:	a1 44 60 80 00       	mov    0x806044,%eax
  803c27:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c2a:	76 68                	jbe    803c94 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c2c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c30:	75 17                	jne    803c49 <realloc_block_FF+0x2fa>
  803c32:	83 ec 04             	sub    $0x4,%esp
  803c35:	68 cc 4f 80 00       	push   $0x804fcc
  803c3a:	68 0b 02 00 00       	push   $0x20b
  803c3f:	68 b1 4f 80 00       	push   $0x804fb1
  803c44:	e8 20 ce ff ff       	call   800a69 <_panic>
  803c49:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803c4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c52:	89 10                	mov    %edx,(%eax)
  803c54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c57:	8b 00                	mov    (%eax),%eax
  803c59:	85 c0                	test   %eax,%eax
  803c5b:	74 0d                	je     803c6a <realloc_block_FF+0x31b>
  803c5d:	a1 44 60 80 00       	mov    0x806044,%eax
  803c62:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c65:	89 50 04             	mov    %edx,0x4(%eax)
  803c68:	eb 08                	jmp    803c72 <realloc_block_FF+0x323>
  803c6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c6d:	a3 48 60 80 00       	mov    %eax,0x806048
  803c72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c75:	a3 44 60 80 00       	mov    %eax,0x806044
  803c7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c84:	a1 50 60 80 00       	mov    0x806050,%eax
  803c89:	40                   	inc    %eax
  803c8a:	a3 50 60 80 00       	mov    %eax,0x806050
  803c8f:	e9 3e 01 00 00       	jmp    803dd2 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c94:	a1 44 60 80 00       	mov    0x806044,%eax
  803c99:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c9c:	73 68                	jae    803d06 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c9e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ca2:	75 17                	jne    803cbb <realloc_block_FF+0x36c>
  803ca4:	83 ec 04             	sub    $0x4,%esp
  803ca7:	68 00 50 80 00       	push   $0x805000
  803cac:	68 10 02 00 00       	push   $0x210
  803cb1:	68 b1 4f 80 00       	push   $0x804fb1
  803cb6:	e8 ae cd ff ff       	call   800a69 <_panic>
  803cbb:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803cc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc4:	89 50 04             	mov    %edx,0x4(%eax)
  803cc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cca:	8b 40 04             	mov    0x4(%eax),%eax
  803ccd:	85 c0                	test   %eax,%eax
  803ccf:	74 0c                	je     803cdd <realloc_block_FF+0x38e>
  803cd1:	a1 48 60 80 00       	mov    0x806048,%eax
  803cd6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cd9:	89 10                	mov    %edx,(%eax)
  803cdb:	eb 08                	jmp    803ce5 <realloc_block_FF+0x396>
  803cdd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce0:	a3 44 60 80 00       	mov    %eax,0x806044
  803ce5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce8:	a3 48 60 80 00       	mov    %eax,0x806048
  803ced:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cf6:	a1 50 60 80 00       	mov    0x806050,%eax
  803cfb:	40                   	inc    %eax
  803cfc:	a3 50 60 80 00       	mov    %eax,0x806050
  803d01:	e9 cc 00 00 00       	jmp    803dd2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803d06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803d0d:	a1 44 60 80 00       	mov    0x806044,%eax
  803d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d15:	e9 8a 00 00 00       	jmp    803da4 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d20:	73 7a                	jae    803d9c <realloc_block_FF+0x44d>
  803d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d25:	8b 00                	mov    (%eax),%eax
  803d27:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d2a:	73 70                	jae    803d9c <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803d2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d30:	74 06                	je     803d38 <realloc_block_FF+0x3e9>
  803d32:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d36:	75 17                	jne    803d4f <realloc_block_FF+0x400>
  803d38:	83 ec 04             	sub    $0x4,%esp
  803d3b:	68 24 50 80 00       	push   $0x805024
  803d40:	68 1a 02 00 00       	push   $0x21a
  803d45:	68 b1 4f 80 00       	push   $0x804fb1
  803d4a:	e8 1a cd ff ff       	call   800a69 <_panic>
  803d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d52:	8b 10                	mov    (%eax),%edx
  803d54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d57:	89 10                	mov    %edx,(%eax)
  803d59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d5c:	8b 00                	mov    (%eax),%eax
  803d5e:	85 c0                	test   %eax,%eax
  803d60:	74 0b                	je     803d6d <realloc_block_FF+0x41e>
  803d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d65:	8b 00                	mov    (%eax),%eax
  803d67:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d6a:	89 50 04             	mov    %edx,0x4(%eax)
  803d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d70:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d73:	89 10                	mov    %edx,(%eax)
  803d75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d7b:	89 50 04             	mov    %edx,0x4(%eax)
  803d7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d81:	8b 00                	mov    (%eax),%eax
  803d83:	85 c0                	test   %eax,%eax
  803d85:	75 08                	jne    803d8f <realloc_block_FF+0x440>
  803d87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d8a:	a3 48 60 80 00       	mov    %eax,0x806048
  803d8f:	a1 50 60 80 00       	mov    0x806050,%eax
  803d94:	40                   	inc    %eax
  803d95:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  803d9a:	eb 36                	jmp    803dd2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d9c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803da4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803da8:	74 07                	je     803db1 <realloc_block_FF+0x462>
  803daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dad:	8b 00                	mov    (%eax),%eax
  803daf:	eb 05                	jmp    803db6 <realloc_block_FF+0x467>
  803db1:	b8 00 00 00 00       	mov    $0x0,%eax
  803db6:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803dbb:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803dc0:	85 c0                	test   %eax,%eax
  803dc2:	0f 85 52 ff ff ff    	jne    803d1a <realloc_block_FF+0x3cb>
  803dc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dcc:	0f 85 48 ff ff ff    	jne    803d1a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803dd2:	83 ec 04             	sub    $0x4,%esp
  803dd5:	6a 00                	push   $0x0
  803dd7:	ff 75 d8             	pushl  -0x28(%ebp)
  803dda:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ddd:	e8 7a eb ff ff       	call   80295c <set_block_data>
  803de2:	83 c4 10             	add    $0x10,%esp
				return va;
  803de5:	8b 45 08             	mov    0x8(%ebp),%eax
  803de8:	e9 7b 02 00 00       	jmp    804068 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803ded:	83 ec 0c             	sub    $0xc,%esp
  803df0:	68 a1 50 80 00       	push   $0x8050a1
  803df5:	e8 2c cf ff ff       	call   800d26 <cprintf>
  803dfa:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803e00:	e9 63 02 00 00       	jmp    804068 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e08:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e0b:	0f 86 4d 02 00 00    	jbe    80405e <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803e11:	83 ec 0c             	sub    $0xc,%esp
  803e14:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e17:	e8 08 e8 ff ff       	call   802624 <is_free_block>
  803e1c:	83 c4 10             	add    $0x10,%esp
  803e1f:	84 c0                	test   %al,%al
  803e21:	0f 84 37 02 00 00    	je     80405e <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e2a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e2d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803e30:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e33:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e36:	76 38                	jbe    803e70 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803e38:	83 ec 0c             	sub    $0xc,%esp
  803e3b:	ff 75 08             	pushl  0x8(%ebp)
  803e3e:	e8 0c fa ff ff       	call   80384f <free_block>
  803e43:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e46:	83 ec 0c             	sub    $0xc,%esp
  803e49:	ff 75 0c             	pushl  0xc(%ebp)
  803e4c:	e8 3a eb ff ff       	call   80298b <alloc_block_FF>
  803e51:	83 c4 10             	add    $0x10,%esp
  803e54:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803e57:	83 ec 08             	sub    $0x8,%esp
  803e5a:	ff 75 c0             	pushl  -0x40(%ebp)
  803e5d:	ff 75 08             	pushl  0x8(%ebp)
  803e60:	e8 ab fa ff ff       	call   803910 <copy_data>
  803e65:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803e68:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e6b:	e9 f8 01 00 00       	jmp    804068 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803e70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e73:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803e76:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803e79:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803e7d:	0f 87 a0 00 00 00    	ja     803f23 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803e83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e87:	75 17                	jne    803ea0 <realloc_block_FF+0x551>
  803e89:	83 ec 04             	sub    $0x4,%esp
  803e8c:	68 93 4f 80 00       	push   $0x804f93
  803e91:	68 38 02 00 00       	push   $0x238
  803e96:	68 b1 4f 80 00       	push   $0x804fb1
  803e9b:	e8 c9 cb ff ff       	call   800a69 <_panic>
  803ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea3:	8b 00                	mov    (%eax),%eax
  803ea5:	85 c0                	test   %eax,%eax
  803ea7:	74 10                	je     803eb9 <realloc_block_FF+0x56a>
  803ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eac:	8b 00                	mov    (%eax),%eax
  803eae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803eb1:	8b 52 04             	mov    0x4(%edx),%edx
  803eb4:	89 50 04             	mov    %edx,0x4(%eax)
  803eb7:	eb 0b                	jmp    803ec4 <realloc_block_FF+0x575>
  803eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ebc:	8b 40 04             	mov    0x4(%eax),%eax
  803ebf:	a3 48 60 80 00       	mov    %eax,0x806048
  803ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec7:	8b 40 04             	mov    0x4(%eax),%eax
  803eca:	85 c0                	test   %eax,%eax
  803ecc:	74 0f                	je     803edd <realloc_block_FF+0x58e>
  803ece:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed1:	8b 40 04             	mov    0x4(%eax),%eax
  803ed4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ed7:	8b 12                	mov    (%edx),%edx
  803ed9:	89 10                	mov    %edx,(%eax)
  803edb:	eb 0a                	jmp    803ee7 <realloc_block_FF+0x598>
  803edd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee0:	8b 00                	mov    (%eax),%eax
  803ee2:	a3 44 60 80 00       	mov    %eax,0x806044
  803ee7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803efa:	a1 50 60 80 00       	mov    0x806050,%eax
  803eff:	48                   	dec    %eax
  803f00:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803f05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f0b:	01 d0                	add    %edx,%eax
  803f0d:	83 ec 04             	sub    $0x4,%esp
  803f10:	6a 01                	push   $0x1
  803f12:	50                   	push   %eax
  803f13:	ff 75 08             	pushl  0x8(%ebp)
  803f16:	e8 41 ea ff ff       	call   80295c <set_block_data>
  803f1b:	83 c4 10             	add    $0x10,%esp
  803f1e:	e9 36 01 00 00       	jmp    804059 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803f23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f29:	01 d0                	add    %edx,%eax
  803f2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803f2e:	83 ec 04             	sub    $0x4,%esp
  803f31:	6a 01                	push   $0x1
  803f33:	ff 75 f0             	pushl  -0x10(%ebp)
  803f36:	ff 75 08             	pushl  0x8(%ebp)
  803f39:	e8 1e ea ff ff       	call   80295c <set_block_data>
  803f3e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f41:	8b 45 08             	mov    0x8(%ebp),%eax
  803f44:	83 e8 04             	sub    $0x4,%eax
  803f47:	8b 00                	mov    (%eax),%eax
  803f49:	83 e0 fe             	and    $0xfffffffe,%eax
  803f4c:	89 c2                	mov    %eax,%edx
  803f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803f51:	01 d0                	add    %edx,%eax
  803f53:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f5a:	74 06                	je     803f62 <realloc_block_FF+0x613>
  803f5c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803f60:	75 17                	jne    803f79 <realloc_block_FF+0x62a>
  803f62:	83 ec 04             	sub    $0x4,%esp
  803f65:	68 24 50 80 00       	push   $0x805024
  803f6a:	68 44 02 00 00       	push   $0x244
  803f6f:	68 b1 4f 80 00       	push   $0x804fb1
  803f74:	e8 f0 ca ff ff       	call   800a69 <_panic>
  803f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f7c:	8b 10                	mov    (%eax),%edx
  803f7e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f81:	89 10                	mov    %edx,(%eax)
  803f83:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f86:	8b 00                	mov    (%eax),%eax
  803f88:	85 c0                	test   %eax,%eax
  803f8a:	74 0b                	je     803f97 <realloc_block_FF+0x648>
  803f8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8f:	8b 00                	mov    (%eax),%eax
  803f91:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f94:	89 50 04             	mov    %edx,0x4(%eax)
  803f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f9d:	89 10                	mov    %edx,(%eax)
  803f9f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fa2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fa5:	89 50 04             	mov    %edx,0x4(%eax)
  803fa8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fab:	8b 00                	mov    (%eax),%eax
  803fad:	85 c0                	test   %eax,%eax
  803faf:	75 08                	jne    803fb9 <realloc_block_FF+0x66a>
  803fb1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fb4:	a3 48 60 80 00       	mov    %eax,0x806048
  803fb9:	a1 50 60 80 00       	mov    0x806050,%eax
  803fbe:	40                   	inc    %eax
  803fbf:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803fc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fc8:	75 17                	jne    803fe1 <realloc_block_FF+0x692>
  803fca:	83 ec 04             	sub    $0x4,%esp
  803fcd:	68 93 4f 80 00       	push   $0x804f93
  803fd2:	68 45 02 00 00       	push   $0x245
  803fd7:	68 b1 4f 80 00       	push   $0x804fb1
  803fdc:	e8 88 ca ff ff       	call   800a69 <_panic>
  803fe1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe4:	8b 00                	mov    (%eax),%eax
  803fe6:	85 c0                	test   %eax,%eax
  803fe8:	74 10                	je     803ffa <realloc_block_FF+0x6ab>
  803fea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fed:	8b 00                	mov    (%eax),%eax
  803fef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ff2:	8b 52 04             	mov    0x4(%edx),%edx
  803ff5:	89 50 04             	mov    %edx,0x4(%eax)
  803ff8:	eb 0b                	jmp    804005 <realloc_block_FF+0x6b6>
  803ffa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ffd:	8b 40 04             	mov    0x4(%eax),%eax
  804000:	a3 48 60 80 00       	mov    %eax,0x806048
  804005:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804008:	8b 40 04             	mov    0x4(%eax),%eax
  80400b:	85 c0                	test   %eax,%eax
  80400d:	74 0f                	je     80401e <realloc_block_FF+0x6cf>
  80400f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804012:	8b 40 04             	mov    0x4(%eax),%eax
  804015:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804018:	8b 12                	mov    (%edx),%edx
  80401a:	89 10                	mov    %edx,(%eax)
  80401c:	eb 0a                	jmp    804028 <realloc_block_FF+0x6d9>
  80401e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804021:	8b 00                	mov    (%eax),%eax
  804023:	a3 44 60 80 00       	mov    %eax,0x806044
  804028:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80402b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804031:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804034:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80403b:	a1 50 60 80 00       	mov    0x806050,%eax
  804040:	48                   	dec    %eax
  804041:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  804046:	83 ec 04             	sub    $0x4,%esp
  804049:	6a 00                	push   $0x0
  80404b:	ff 75 bc             	pushl  -0x44(%ebp)
  80404e:	ff 75 b8             	pushl  -0x48(%ebp)
  804051:	e8 06 e9 ff ff       	call   80295c <set_block_data>
  804056:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804059:	8b 45 08             	mov    0x8(%ebp),%eax
  80405c:	eb 0a                	jmp    804068 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80405e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804065:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804068:	c9                   	leave  
  804069:	c3                   	ret    

0080406a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80406a:	55                   	push   %ebp
  80406b:	89 e5                	mov    %esp,%ebp
  80406d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804070:	83 ec 04             	sub    $0x4,%esp
  804073:	68 a8 50 80 00       	push   $0x8050a8
  804078:	68 58 02 00 00       	push   $0x258
  80407d:	68 b1 4f 80 00       	push   $0x804fb1
  804082:	e8 e2 c9 ff ff       	call   800a69 <_panic>

00804087 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804087:	55                   	push   %ebp
  804088:	89 e5                	mov    %esp,%ebp
  80408a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80408d:	83 ec 04             	sub    $0x4,%esp
  804090:	68 d0 50 80 00       	push   $0x8050d0
  804095:	68 61 02 00 00       	push   $0x261
  80409a:	68 b1 4f 80 00       	push   $0x804fb1
  80409f:	e8 c5 c9 ff ff       	call   800a69 <_panic>

008040a4 <__udivdi3>:
  8040a4:	55                   	push   %ebp
  8040a5:	57                   	push   %edi
  8040a6:	56                   	push   %esi
  8040a7:	53                   	push   %ebx
  8040a8:	83 ec 1c             	sub    $0x1c,%esp
  8040ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040bb:	89 ca                	mov    %ecx,%edx
  8040bd:	89 f8                	mov    %edi,%eax
  8040bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040c3:	85 f6                	test   %esi,%esi
  8040c5:	75 2d                	jne    8040f4 <__udivdi3+0x50>
  8040c7:	39 cf                	cmp    %ecx,%edi
  8040c9:	77 65                	ja     804130 <__udivdi3+0x8c>
  8040cb:	89 fd                	mov    %edi,%ebp
  8040cd:	85 ff                	test   %edi,%edi
  8040cf:	75 0b                	jne    8040dc <__udivdi3+0x38>
  8040d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8040d6:	31 d2                	xor    %edx,%edx
  8040d8:	f7 f7                	div    %edi
  8040da:	89 c5                	mov    %eax,%ebp
  8040dc:	31 d2                	xor    %edx,%edx
  8040de:	89 c8                	mov    %ecx,%eax
  8040e0:	f7 f5                	div    %ebp
  8040e2:	89 c1                	mov    %eax,%ecx
  8040e4:	89 d8                	mov    %ebx,%eax
  8040e6:	f7 f5                	div    %ebp
  8040e8:	89 cf                	mov    %ecx,%edi
  8040ea:	89 fa                	mov    %edi,%edx
  8040ec:	83 c4 1c             	add    $0x1c,%esp
  8040ef:	5b                   	pop    %ebx
  8040f0:	5e                   	pop    %esi
  8040f1:	5f                   	pop    %edi
  8040f2:	5d                   	pop    %ebp
  8040f3:	c3                   	ret    
  8040f4:	39 ce                	cmp    %ecx,%esi
  8040f6:	77 28                	ja     804120 <__udivdi3+0x7c>
  8040f8:	0f bd fe             	bsr    %esi,%edi
  8040fb:	83 f7 1f             	xor    $0x1f,%edi
  8040fe:	75 40                	jne    804140 <__udivdi3+0x9c>
  804100:	39 ce                	cmp    %ecx,%esi
  804102:	72 0a                	jb     80410e <__udivdi3+0x6a>
  804104:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804108:	0f 87 9e 00 00 00    	ja     8041ac <__udivdi3+0x108>
  80410e:	b8 01 00 00 00       	mov    $0x1,%eax
  804113:	89 fa                	mov    %edi,%edx
  804115:	83 c4 1c             	add    $0x1c,%esp
  804118:	5b                   	pop    %ebx
  804119:	5e                   	pop    %esi
  80411a:	5f                   	pop    %edi
  80411b:	5d                   	pop    %ebp
  80411c:	c3                   	ret    
  80411d:	8d 76 00             	lea    0x0(%esi),%esi
  804120:	31 ff                	xor    %edi,%edi
  804122:	31 c0                	xor    %eax,%eax
  804124:	89 fa                	mov    %edi,%edx
  804126:	83 c4 1c             	add    $0x1c,%esp
  804129:	5b                   	pop    %ebx
  80412a:	5e                   	pop    %esi
  80412b:	5f                   	pop    %edi
  80412c:	5d                   	pop    %ebp
  80412d:	c3                   	ret    
  80412e:	66 90                	xchg   %ax,%ax
  804130:	89 d8                	mov    %ebx,%eax
  804132:	f7 f7                	div    %edi
  804134:	31 ff                	xor    %edi,%edi
  804136:	89 fa                	mov    %edi,%edx
  804138:	83 c4 1c             	add    $0x1c,%esp
  80413b:	5b                   	pop    %ebx
  80413c:	5e                   	pop    %esi
  80413d:	5f                   	pop    %edi
  80413e:	5d                   	pop    %ebp
  80413f:	c3                   	ret    
  804140:	bd 20 00 00 00       	mov    $0x20,%ebp
  804145:	89 eb                	mov    %ebp,%ebx
  804147:	29 fb                	sub    %edi,%ebx
  804149:	89 f9                	mov    %edi,%ecx
  80414b:	d3 e6                	shl    %cl,%esi
  80414d:	89 c5                	mov    %eax,%ebp
  80414f:	88 d9                	mov    %bl,%cl
  804151:	d3 ed                	shr    %cl,%ebp
  804153:	89 e9                	mov    %ebp,%ecx
  804155:	09 f1                	or     %esi,%ecx
  804157:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80415b:	89 f9                	mov    %edi,%ecx
  80415d:	d3 e0                	shl    %cl,%eax
  80415f:	89 c5                	mov    %eax,%ebp
  804161:	89 d6                	mov    %edx,%esi
  804163:	88 d9                	mov    %bl,%cl
  804165:	d3 ee                	shr    %cl,%esi
  804167:	89 f9                	mov    %edi,%ecx
  804169:	d3 e2                	shl    %cl,%edx
  80416b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80416f:	88 d9                	mov    %bl,%cl
  804171:	d3 e8                	shr    %cl,%eax
  804173:	09 c2                	or     %eax,%edx
  804175:	89 d0                	mov    %edx,%eax
  804177:	89 f2                	mov    %esi,%edx
  804179:	f7 74 24 0c          	divl   0xc(%esp)
  80417d:	89 d6                	mov    %edx,%esi
  80417f:	89 c3                	mov    %eax,%ebx
  804181:	f7 e5                	mul    %ebp
  804183:	39 d6                	cmp    %edx,%esi
  804185:	72 19                	jb     8041a0 <__udivdi3+0xfc>
  804187:	74 0b                	je     804194 <__udivdi3+0xf0>
  804189:	89 d8                	mov    %ebx,%eax
  80418b:	31 ff                	xor    %edi,%edi
  80418d:	e9 58 ff ff ff       	jmp    8040ea <__udivdi3+0x46>
  804192:	66 90                	xchg   %ax,%ax
  804194:	8b 54 24 08          	mov    0x8(%esp),%edx
  804198:	89 f9                	mov    %edi,%ecx
  80419a:	d3 e2                	shl    %cl,%edx
  80419c:	39 c2                	cmp    %eax,%edx
  80419e:	73 e9                	jae    804189 <__udivdi3+0xe5>
  8041a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041a3:	31 ff                	xor    %edi,%edi
  8041a5:	e9 40 ff ff ff       	jmp    8040ea <__udivdi3+0x46>
  8041aa:	66 90                	xchg   %ax,%ax
  8041ac:	31 c0                	xor    %eax,%eax
  8041ae:	e9 37 ff ff ff       	jmp    8040ea <__udivdi3+0x46>
  8041b3:	90                   	nop

008041b4 <__umoddi3>:
  8041b4:	55                   	push   %ebp
  8041b5:	57                   	push   %edi
  8041b6:	56                   	push   %esi
  8041b7:	53                   	push   %ebx
  8041b8:	83 ec 1c             	sub    $0x1c,%esp
  8041bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8041d3:	89 f3                	mov    %esi,%ebx
  8041d5:	89 fa                	mov    %edi,%edx
  8041d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041db:	89 34 24             	mov    %esi,(%esp)
  8041de:	85 c0                	test   %eax,%eax
  8041e0:	75 1a                	jne    8041fc <__umoddi3+0x48>
  8041e2:	39 f7                	cmp    %esi,%edi
  8041e4:	0f 86 a2 00 00 00    	jbe    80428c <__umoddi3+0xd8>
  8041ea:	89 c8                	mov    %ecx,%eax
  8041ec:	89 f2                	mov    %esi,%edx
  8041ee:	f7 f7                	div    %edi
  8041f0:	89 d0                	mov    %edx,%eax
  8041f2:	31 d2                	xor    %edx,%edx
  8041f4:	83 c4 1c             	add    $0x1c,%esp
  8041f7:	5b                   	pop    %ebx
  8041f8:	5e                   	pop    %esi
  8041f9:	5f                   	pop    %edi
  8041fa:	5d                   	pop    %ebp
  8041fb:	c3                   	ret    
  8041fc:	39 f0                	cmp    %esi,%eax
  8041fe:	0f 87 ac 00 00 00    	ja     8042b0 <__umoddi3+0xfc>
  804204:	0f bd e8             	bsr    %eax,%ebp
  804207:	83 f5 1f             	xor    $0x1f,%ebp
  80420a:	0f 84 ac 00 00 00    	je     8042bc <__umoddi3+0x108>
  804210:	bf 20 00 00 00       	mov    $0x20,%edi
  804215:	29 ef                	sub    %ebp,%edi
  804217:	89 fe                	mov    %edi,%esi
  804219:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80421d:	89 e9                	mov    %ebp,%ecx
  80421f:	d3 e0                	shl    %cl,%eax
  804221:	89 d7                	mov    %edx,%edi
  804223:	89 f1                	mov    %esi,%ecx
  804225:	d3 ef                	shr    %cl,%edi
  804227:	09 c7                	or     %eax,%edi
  804229:	89 e9                	mov    %ebp,%ecx
  80422b:	d3 e2                	shl    %cl,%edx
  80422d:	89 14 24             	mov    %edx,(%esp)
  804230:	89 d8                	mov    %ebx,%eax
  804232:	d3 e0                	shl    %cl,%eax
  804234:	89 c2                	mov    %eax,%edx
  804236:	8b 44 24 08          	mov    0x8(%esp),%eax
  80423a:	d3 e0                	shl    %cl,%eax
  80423c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804240:	8b 44 24 08          	mov    0x8(%esp),%eax
  804244:	89 f1                	mov    %esi,%ecx
  804246:	d3 e8                	shr    %cl,%eax
  804248:	09 d0                	or     %edx,%eax
  80424a:	d3 eb                	shr    %cl,%ebx
  80424c:	89 da                	mov    %ebx,%edx
  80424e:	f7 f7                	div    %edi
  804250:	89 d3                	mov    %edx,%ebx
  804252:	f7 24 24             	mull   (%esp)
  804255:	89 c6                	mov    %eax,%esi
  804257:	89 d1                	mov    %edx,%ecx
  804259:	39 d3                	cmp    %edx,%ebx
  80425b:	0f 82 87 00 00 00    	jb     8042e8 <__umoddi3+0x134>
  804261:	0f 84 91 00 00 00    	je     8042f8 <__umoddi3+0x144>
  804267:	8b 54 24 04          	mov    0x4(%esp),%edx
  80426b:	29 f2                	sub    %esi,%edx
  80426d:	19 cb                	sbb    %ecx,%ebx
  80426f:	89 d8                	mov    %ebx,%eax
  804271:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804275:	d3 e0                	shl    %cl,%eax
  804277:	89 e9                	mov    %ebp,%ecx
  804279:	d3 ea                	shr    %cl,%edx
  80427b:	09 d0                	or     %edx,%eax
  80427d:	89 e9                	mov    %ebp,%ecx
  80427f:	d3 eb                	shr    %cl,%ebx
  804281:	89 da                	mov    %ebx,%edx
  804283:	83 c4 1c             	add    $0x1c,%esp
  804286:	5b                   	pop    %ebx
  804287:	5e                   	pop    %esi
  804288:	5f                   	pop    %edi
  804289:	5d                   	pop    %ebp
  80428a:	c3                   	ret    
  80428b:	90                   	nop
  80428c:	89 fd                	mov    %edi,%ebp
  80428e:	85 ff                	test   %edi,%edi
  804290:	75 0b                	jne    80429d <__umoddi3+0xe9>
  804292:	b8 01 00 00 00       	mov    $0x1,%eax
  804297:	31 d2                	xor    %edx,%edx
  804299:	f7 f7                	div    %edi
  80429b:	89 c5                	mov    %eax,%ebp
  80429d:	89 f0                	mov    %esi,%eax
  80429f:	31 d2                	xor    %edx,%edx
  8042a1:	f7 f5                	div    %ebp
  8042a3:	89 c8                	mov    %ecx,%eax
  8042a5:	f7 f5                	div    %ebp
  8042a7:	89 d0                	mov    %edx,%eax
  8042a9:	e9 44 ff ff ff       	jmp    8041f2 <__umoddi3+0x3e>
  8042ae:	66 90                	xchg   %ax,%ax
  8042b0:	89 c8                	mov    %ecx,%eax
  8042b2:	89 f2                	mov    %esi,%edx
  8042b4:	83 c4 1c             	add    $0x1c,%esp
  8042b7:	5b                   	pop    %ebx
  8042b8:	5e                   	pop    %esi
  8042b9:	5f                   	pop    %edi
  8042ba:	5d                   	pop    %ebp
  8042bb:	c3                   	ret    
  8042bc:	3b 04 24             	cmp    (%esp),%eax
  8042bf:	72 06                	jb     8042c7 <__umoddi3+0x113>
  8042c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042c5:	77 0f                	ja     8042d6 <__umoddi3+0x122>
  8042c7:	89 f2                	mov    %esi,%edx
  8042c9:	29 f9                	sub    %edi,%ecx
  8042cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042cf:	89 14 24             	mov    %edx,(%esp)
  8042d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8042da:	8b 14 24             	mov    (%esp),%edx
  8042dd:	83 c4 1c             	add    $0x1c,%esp
  8042e0:	5b                   	pop    %ebx
  8042e1:	5e                   	pop    %esi
  8042e2:	5f                   	pop    %edi
  8042e3:	5d                   	pop    %ebp
  8042e4:	c3                   	ret    
  8042e5:	8d 76 00             	lea    0x0(%esi),%esi
  8042e8:	2b 04 24             	sub    (%esp),%eax
  8042eb:	19 fa                	sbb    %edi,%edx
  8042ed:	89 d1                	mov    %edx,%ecx
  8042ef:	89 c6                	mov    %eax,%esi
  8042f1:	e9 71 ff ff ff       	jmp    804267 <__umoddi3+0xb3>
  8042f6:	66 90                	xchg   %ax,%ax
  8042f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042fc:	72 ea                	jb     8042e8 <__umoddi3+0x134>
  8042fe:	89 d9                	mov    %ebx,%ecx
  804300:	e9 62 ff ff ff       	jmp    804267 <__umoddi3+0xb3>
