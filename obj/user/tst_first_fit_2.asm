
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
  800055:	68 c0 42 80 00       	push   $0x8042c0
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
  8000a5:	68 f0 42 80 00       	push   $0x8042f0
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
  8000d1:	e8 e0 23 00 00       	call   8024b6 <sys_set_uheap_strategy>
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
  8000f6:	68 29 43 80 00       	push   $0x804329
  8000fb:	6a 26                	push   $0x26
  8000fd:	68 45 43 80 00       	push   $0x804345
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
  800123:	e8 db 1f 00 00       	call   802103 <sys_pf_calculate_allocated_pages>
  800128:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 88 1f 00 00       	call   8020b8 <sys_calculate_free_frames>
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
  80013d:	68 5c 43 80 00       	push   $0x80435c
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
  8002ac:	68 b4 43 80 00       	push   $0x8043b4
  8002b1:	6a 69                	push   $0x69
  8002b3:	68 45 43 80 00       	push   $0x804345
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
  800328:	68 dc 43 80 00       	push   $0x8043dc
  80032d:	e8 f4 09 00 00       	call   800d26 <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800335:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80033b:	83 e8 08             	sub    $0x8,%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	6a 01                	push   $0x1
  800343:	50                   	push   %eax
  800344:	e8 af 22 00 00       	call   8025f8 <alloc_block>
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
  800392:	68 00 44 80 00       	push   $0x804400
  800397:	68 80 00 00 00       	push   $0x80
  80039c:	68 45 43 80 00       	push   $0x804345
  8003a1:	e8 c3 06 00 00       	call   800a69 <_panic>
		}
	}

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 28 44 80 00       	push   $0x804428
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
  800451:	68 70 44 80 00       	push   $0x804470
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
  80046e:	68 90 44 80 00       	push   $0x804490
  800473:	e8 ae 08 00 00       	call   800d26 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp

	uint32 testSizes[numOfFFTests] =
  80047b:	8d 85 2c ff ff ff    	lea    -0xd4(%ebp),%eax
  800481:	bb 54 48 80 00       	mov    $0x804854,%ebx
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
  8005a7:	68 ec 44 80 00       	push   $0x8044ec
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
  80060a:	e8 b2 1f 00 00       	call   8025c1 <get_block_size>
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
  800627:	68 1c 45 80 00       	push   $0x80451c
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
  800641:	68 e8 45 80 00       	push   $0x8045e8
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
  800714:	68 34 46 80 00       	push   $0x804634
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
  80074f:	68 60 46 80 00       	push   $0x804660
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
  800808:	68 94 46 80 00       	push   $0x804694
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
  800831:	68 f8 46 80 00       	push   $0x8046f8
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
  8008a8:	68 18 47 80 00       	push   $0x804718
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
  8008f7:	68 88 47 80 00       	push   $0x804788
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
  800914:	68 0c 48 80 00       	push   $0x80480c
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
  800930:	e8 4c 19 00 00       	call   802281 <sys_getenvindex>
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
  80099e:	e8 62 16 00 00       	call   802005 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8009a3:	83 ec 0c             	sub    $0xc,%esp
  8009a6:	68 78 48 80 00       	push   $0x804878
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
  8009ce:	68 a0 48 80 00       	push   $0x8048a0
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
  8009ff:	68 c8 48 80 00       	push   $0x8048c8
  800a04:	e8 1d 03 00 00       	call   800d26 <cprintf>
  800a09:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a0c:	a1 20 60 80 00       	mov    0x806020,%eax
  800a11:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	50                   	push   %eax
  800a1b:	68 20 49 80 00       	push   $0x804920
  800a20:	e8 01 03 00 00       	call   800d26 <cprintf>
  800a25:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	68 78 48 80 00       	push   $0x804878
  800a30:	e8 f1 02 00 00       	call   800d26 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800a38:	e8 e2 15 00 00       	call   80201f <sys_unlock_cons>
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
  800a50:	e8 f8 17 00 00       	call   80224d <sys_destroy_env>
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
  800a61:	e8 4d 18 00 00       	call   8022b3 <sys_exit_env>
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
  800a8a:	68 34 49 80 00       	push   $0x804934
  800a8f:	e8 92 02 00 00       	call   800d26 <cprintf>
  800a94:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a97:	a1 1c 60 80 00       	mov    0x80601c,%eax
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	ff 75 08             	pushl  0x8(%ebp)
  800aa2:	50                   	push   %eax
  800aa3:	68 39 49 80 00       	push   $0x804939
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
  800ac7:	68 55 49 80 00       	push   $0x804955
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
  800af6:	68 58 49 80 00       	push   $0x804958
  800afb:	6a 26                	push   $0x26
  800afd:	68 a4 49 80 00       	push   $0x8049a4
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
  800bcb:	68 b0 49 80 00       	push   $0x8049b0
  800bd0:	6a 3a                	push   $0x3a
  800bd2:	68 a4 49 80 00       	push   $0x8049a4
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
  800c3e:	68 04 4a 80 00       	push   $0x804a04
  800c43:	6a 44                	push   $0x44
  800c45:	68 a4 49 80 00       	push   $0x8049a4
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
  800c98:	e8 26 13 00 00       	call   801fc3 <sys_cputs>
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
  800d0f:	e8 af 12 00 00       	call   801fc3 <sys_cputs>
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
  800d59:	e8 a7 12 00 00       	call   802005 <sys_lock_cons>
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
  800d79:	e8 a1 12 00 00       	call   80201f <sys_unlock_cons>
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
  800dc3:	e8 94 32 00 00       	call   80405c <__udivdi3>
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
  800e13:	e8 54 33 00 00       	call   80416c <__umoddi3>
  800e18:	83 c4 10             	add    $0x10,%esp
  800e1b:	05 74 4c 80 00       	add    $0x804c74,%eax
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
  800f6e:	8b 04 85 98 4c 80 00 	mov    0x804c98(,%eax,4),%eax
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
  80104f:	8b 34 9d e0 4a 80 00 	mov    0x804ae0(,%ebx,4),%esi
  801056:	85 f6                	test   %esi,%esi
  801058:	75 19                	jne    801073 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80105a:	53                   	push   %ebx
  80105b:	68 85 4c 80 00       	push   $0x804c85
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
  801074:	68 8e 4c 80 00       	push   $0x804c8e
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
  8010a1:	be 91 4c 80 00       	mov    $0x804c91,%esi
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
  801aac:	68 08 4e 80 00       	push   $0x804e08
  801ab1:	68 3f 01 00 00       	push   $0x13f
  801ab6:	68 2a 4e 80 00       	push   $0x804e2a
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
  801acc:	e8 9d 0a 00 00       	call   80256e <sys_sbrk>
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
  801b47:	e8 a6 08 00 00       	call   8023f2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	74 16                	je     801b66 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	e8 e6 0d 00 00       	call   802941 <alloc_block_FF>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b61:	e9 8a 01 00 00       	jmp    801cf0 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b66:	e8 b8 08 00 00       	call   802423 <sys_isUHeapPlacementStrategyBESTFIT>
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	0f 84 7d 01 00 00    	je     801cf0 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	e8 7f 12 00 00       	call   802dfd <alloc_block_BF>
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
  801cdf:	e8 c1 08 00 00       	call   8025a5 <sys_allocate_user_mem>
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
  801d27:	e8 95 08 00 00       	call   8025c1 <get_block_size>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 c8 1a 00 00       	call   803805 <free_block>
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
  801dcf:	e8 b5 07 00 00       	call   802589 <sys_free_user_mem>
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
  801ddd:	68 38 4e 80 00       	push   $0x804e38
  801de2:	68 84 00 00 00       	push   $0x84
  801de7:	68 62 4e 80 00       	push   $0x804e62
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
  801e4f:	e8 3c 03 00 00       	call   802190 <sys_createSharedObject>
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
  801e70:	68 6e 4e 80 00       	push   $0x804e6e
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
  801e85:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e88:	83 ec 08             	sub    $0x8,%esp
  801e8b:	ff 75 0c             	pushl  0xc(%ebp)
  801e8e:	ff 75 08             	pushl  0x8(%ebp)
  801e91:	e8 24 03 00 00       	call   8021ba <sys_getSizeOfSharedObject>
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801e9c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801ea0:	75 07                	jne    801ea9 <sget+0x27>
  801ea2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea7:	eb 5c                	jmp    801f05 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eaf:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801eb6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebc:	39 d0                	cmp    %edx,%eax
  801ebe:	7d 02                	jge    801ec2 <sget+0x40>
  801ec0:	89 d0                	mov    %edx,%eax
  801ec2:	83 ec 0c             	sub    $0xc,%esp
  801ec5:	50                   	push   %eax
  801ec6:	e8 0b fc ff ff       	call   801ad6 <malloc>
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801ed1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ed5:	75 07                	jne    801ede <sget+0x5c>
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  801edc:	eb 27                	jmp    801f05 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801ede:	83 ec 04             	sub    $0x4,%esp
  801ee1:	ff 75 e8             	pushl  -0x18(%ebp)
  801ee4:	ff 75 0c             	pushl  0xc(%ebp)
  801ee7:	ff 75 08             	pushl  0x8(%ebp)
  801eea:	e8 e8 02 00 00       	call   8021d7 <sys_getSharedObject>
  801eef:	83 c4 10             	add    $0x10,%esp
  801ef2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801ef5:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801ef9:	75 07                	jne    801f02 <sget+0x80>
  801efb:	b8 00 00 00 00       	mov    $0x0,%eax
  801f00:	eb 03                	jmp    801f05 <sget+0x83>
	return ptr;
  801f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f0d:	83 ec 04             	sub    $0x4,%esp
  801f10:	68 74 4e 80 00       	push   $0x804e74
  801f15:	68 c2 00 00 00       	push   $0xc2
  801f1a:	68 62 4e 80 00       	push   $0x804e62
  801f1f:	e8 45 eb ff ff       	call   800a69 <_panic>

00801f24 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f2a:	83 ec 04             	sub    $0x4,%esp
  801f2d:	68 98 4e 80 00       	push   $0x804e98
  801f32:	68 d9 00 00 00       	push   $0xd9
  801f37:	68 62 4e 80 00       	push   $0x804e62
  801f3c:	e8 28 eb ff ff       	call   800a69 <_panic>

00801f41 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f47:	83 ec 04             	sub    $0x4,%esp
  801f4a:	68 be 4e 80 00       	push   $0x804ebe
  801f4f:	68 e5 00 00 00       	push   $0xe5
  801f54:	68 62 4e 80 00       	push   $0x804e62
  801f59:	e8 0b eb ff ff       	call   800a69 <_panic>

00801f5e <shrink>:

}
void shrink(uint32 newSize)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	68 be 4e 80 00       	push   $0x804ebe
  801f6c:	68 ea 00 00 00       	push   $0xea
  801f71:	68 62 4e 80 00       	push   $0x804e62
  801f76:	e8 ee ea ff ff       	call   800a69 <_panic>

00801f7b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f81:	83 ec 04             	sub    $0x4,%esp
  801f84:	68 be 4e 80 00       	push   $0x804ebe
  801f89:	68 ef 00 00 00       	push   $0xef
  801f8e:	68 62 4e 80 00       	push   $0x804e62
  801f93:	e8 d1 ea ff ff       	call   800a69 <_panic>

00801f98 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	57                   	push   %edi
  801f9c:	56                   	push   %esi
  801f9d:	53                   	push   %ebx
  801f9e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801faa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fad:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fb0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fb3:	cd 30                	int    $0x30
  801fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	5b                   	pop    %ebx
  801fbf:	5e                   	pop    %esi
  801fc0:	5f                   	pop    %edi
  801fc1:	5d                   	pop    %ebp
  801fc2:	c3                   	ret    

00801fc3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fcf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	52                   	push   %edx
  801fdb:	ff 75 0c             	pushl  0xc(%ebp)
  801fde:	50                   	push   %eax
  801fdf:	6a 00                	push   $0x0
  801fe1:	e8 b2 ff ff ff       	call   801f98 <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
}
  801fe9:	90                   	nop
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_cgetc>:

int
sys_cgetc(void)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 02                	push   $0x2
  801ffb:	e8 98 ff ff ff       	call   801f98 <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 03                	push   $0x3
  802014:	e8 7f ff ff ff       	call   801f98 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	90                   	nop
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 04                	push   $0x4
  80202e:	e8 65 ff ff ff       	call   801f98 <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
}
  802036:	90                   	nop
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80203c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	52                   	push   %edx
  802049:	50                   	push   %eax
  80204a:	6a 08                	push   $0x8
  80204c:	e8 47 ff ff ff       	call   801f98 <syscall>
  802051:	83 c4 18             	add    $0x18,%esp
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	56                   	push   %esi
  80205a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80205b:	8b 75 18             	mov    0x18(%ebp),%esi
  80205e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802061:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802064:	8b 55 0c             	mov    0xc(%ebp),%edx
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	56                   	push   %esi
  80206b:	53                   	push   %ebx
  80206c:	51                   	push   %ecx
  80206d:	52                   	push   %edx
  80206e:	50                   	push   %eax
  80206f:	6a 09                	push   $0x9
  802071:	e8 22 ff ff ff       	call   801f98 <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
}
  802079:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80207c:	5b                   	pop    %ebx
  80207d:	5e                   	pop    %esi
  80207e:	5d                   	pop    %ebp
  80207f:	c3                   	ret    

00802080 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802083:	8b 55 0c             	mov    0xc(%ebp),%edx
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	52                   	push   %edx
  802090:	50                   	push   %eax
  802091:	6a 0a                	push   $0xa
  802093:	e8 00 ff ff ff       	call   801f98 <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	ff 75 08             	pushl  0x8(%ebp)
  8020ac:	6a 0b                	push   $0xb
  8020ae:	e8 e5 fe ff ff       	call   801f98 <syscall>
  8020b3:	83 c4 18             	add    $0x18,%esp
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 0c                	push   $0xc
  8020c7:	e8 cc fe ff ff       	call   801f98 <syscall>
  8020cc:	83 c4 18             	add    $0x18,%esp
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 0d                	push   $0xd
  8020e0:	e8 b3 fe ff ff       	call   801f98 <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 0e                	push   $0xe
  8020f9:	e8 9a fe ff ff       	call   801f98 <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 0f                	push   $0xf
  802112:	e8 81 fe ff ff       	call   801f98 <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	ff 75 08             	pushl  0x8(%ebp)
  80212a:	6a 10                	push   $0x10
  80212c:	e8 67 fe ff ff       	call   801f98 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 11                	push   $0x11
  802145:	e8 4e fe ff ff       	call   801f98 <syscall>
  80214a:	83 c4 18             	add    $0x18,%esp
}
  80214d:	90                   	nop
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <sys_cputc>:

void
sys_cputc(const char c)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 04             	sub    $0x4,%esp
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80215c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	50                   	push   %eax
  802169:	6a 01                	push   $0x1
  80216b:	e8 28 fe ff ff       	call   801f98 <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
}
  802173:	90                   	nop
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 14                	push   $0x14
  802185:	e8 0e fe ff ff       	call   801f98 <syscall>
  80218a:	83 c4 18             	add    $0x18,%esp
}
  80218d:	90                   	nop
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 04             	sub    $0x4,%esp
  802196:	8b 45 10             	mov    0x10(%ebp),%eax
  802199:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80219c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80219f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	6a 00                	push   $0x0
  8021a8:	51                   	push   %ecx
  8021a9:	52                   	push   %edx
  8021aa:	ff 75 0c             	pushl  0xc(%ebp)
  8021ad:	50                   	push   %eax
  8021ae:	6a 15                	push   $0x15
  8021b0:	e8 e3 fd ff ff       	call   801f98 <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	52                   	push   %edx
  8021ca:	50                   	push   %eax
  8021cb:	6a 16                	push   $0x16
  8021cd:	e8 c6 fd ff ff       	call   801f98 <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	51                   	push   %ecx
  8021e8:	52                   	push   %edx
  8021e9:	50                   	push   %eax
  8021ea:	6a 17                	push   $0x17
  8021ec:	e8 a7 fd ff ff       	call   801f98 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	52                   	push   %edx
  802206:	50                   	push   %eax
  802207:	6a 18                	push   $0x18
  802209:	e8 8a fd ff ff       	call   801f98 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	6a 00                	push   $0x0
  80221b:	ff 75 14             	pushl  0x14(%ebp)
  80221e:	ff 75 10             	pushl  0x10(%ebp)
  802221:	ff 75 0c             	pushl  0xc(%ebp)
  802224:	50                   	push   %eax
  802225:	6a 19                	push   $0x19
  802227:	e8 6c fd ff ff       	call   801f98 <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	50                   	push   %eax
  802240:	6a 1a                	push   $0x1a
  802242:	e8 51 fd ff ff       	call   801f98 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	90                   	nop
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	50                   	push   %eax
  80225c:	6a 1b                	push   $0x1b
  80225e:	e8 35 fd ff ff       	call   801f98 <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 05                	push   $0x5
  802277:	e8 1c fd ff ff       	call   801f98 <syscall>
  80227c:	83 c4 18             	add    $0x18,%esp
}
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 06                	push   $0x6
  802290:	e8 03 fd ff ff       	call   801f98 <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 07                	push   $0x7
  8022a9:	e8 ea fc ff ff       	call   801f98 <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_exit_env>:


void sys_exit_env(void)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 1c                	push   $0x1c
  8022c2:	e8 d1 fc ff ff       	call   801f98 <syscall>
  8022c7:	83 c4 18             	add    $0x18,%esp
}
  8022ca:	90                   	nop
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
  8022d0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022d3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022d6:	8d 50 04             	lea    0x4(%eax),%edx
  8022d9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	52                   	push   %edx
  8022e3:	50                   	push   %eax
  8022e4:	6a 1d                	push   $0x1d
  8022e6:	e8 ad fc ff ff       	call   801f98 <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
	return result;
  8022ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022f7:	89 01                	mov    %eax,(%ecx)
  8022f9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	c9                   	leave  
  802300:	c2 04 00             	ret    $0x4

00802303 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	ff 75 10             	pushl  0x10(%ebp)
  80230d:	ff 75 0c             	pushl  0xc(%ebp)
  802310:	ff 75 08             	pushl  0x8(%ebp)
  802313:	6a 13                	push   $0x13
  802315:	e8 7e fc ff ff       	call   801f98 <syscall>
  80231a:	83 c4 18             	add    $0x18,%esp
	return ;
  80231d:	90                   	nop
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <sys_rcr2>:
uint32 sys_rcr2()
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 1e                	push   $0x1e
  80232f:	e8 64 fc ff ff       	call   801f98 <syscall>
  802334:	83 c4 18             	add    $0x18,%esp
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	83 ec 04             	sub    $0x4,%esp
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802345:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	50                   	push   %eax
  802352:	6a 1f                	push   $0x1f
  802354:	e8 3f fc ff ff       	call   801f98 <syscall>
  802359:	83 c4 18             	add    $0x18,%esp
	return ;
  80235c:	90                   	nop
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <rsttst>:
void rsttst()
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 21                	push   $0x21
  80236e:	e8 25 fc ff ff       	call   801f98 <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
	return ;
  802376:	90                   	nop
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 04             	sub    $0x4,%esp
  80237f:	8b 45 14             	mov    0x14(%ebp),%eax
  802382:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802385:	8b 55 18             	mov    0x18(%ebp),%edx
  802388:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80238c:	52                   	push   %edx
  80238d:	50                   	push   %eax
  80238e:	ff 75 10             	pushl  0x10(%ebp)
  802391:	ff 75 0c             	pushl  0xc(%ebp)
  802394:	ff 75 08             	pushl  0x8(%ebp)
  802397:	6a 20                	push   $0x20
  802399:	e8 fa fb ff ff       	call   801f98 <syscall>
  80239e:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a1:	90                   	nop
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <chktst>:
void chktst(uint32 n)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	ff 75 08             	pushl  0x8(%ebp)
  8023b2:	6a 22                	push   $0x22
  8023b4:	e8 df fb ff ff       	call   801f98 <syscall>
  8023b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8023bc:	90                   	nop
}
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <inctst>:

void inctst()
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 23                	push   $0x23
  8023ce:	e8 c5 fb ff ff       	call   801f98 <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d6:	90                   	nop
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <gettst>:
uint32 gettst()
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 24                	push   $0x24
  8023e8:	e8 ab fb ff ff       	call   801f98 <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 25                	push   $0x25
  802404:	e8 8f fb ff ff       	call   801f98 <syscall>
  802409:	83 c4 18             	add    $0x18,%esp
  80240c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80240f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802413:	75 07                	jne    80241c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802415:	b8 01 00 00 00       	mov    $0x1,%eax
  80241a:	eb 05                	jmp    802421 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80241c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 25                	push   $0x25
  802435:	e8 5e fb ff ff       	call   801f98 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
  80243d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802440:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802444:	75 07                	jne    80244d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802446:	b8 01 00 00 00       	mov    $0x1,%eax
  80244b:	eb 05                	jmp    802452 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
  802457:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 25                	push   $0x25
  802466:	e8 2d fb ff ff       	call   801f98 <syscall>
  80246b:	83 c4 18             	add    $0x18,%esp
  80246e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802471:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802475:	75 07                	jne    80247e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802477:	b8 01 00 00 00       	mov    $0x1,%eax
  80247c:	eb 05                	jmp    802483 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80247e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 25                	push   $0x25
  802497:	e8 fc fa ff ff       	call   801f98 <syscall>
  80249c:	83 c4 18             	add    $0x18,%esp
  80249f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024a2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024a6:	75 07                	jne    8024af <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ad:	eb 05                	jmp    8024b4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	ff 75 08             	pushl  0x8(%ebp)
  8024c4:	6a 26                	push   $0x26
  8024c6:	e8 cd fa ff ff       	call   801f98 <syscall>
  8024cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ce:	90                   	nop
}
  8024cf:	c9                   	leave  
  8024d0:	c3                   	ret    

008024d1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	6a 00                	push   $0x0
  8024e3:	53                   	push   %ebx
  8024e4:	51                   	push   %ecx
  8024e5:	52                   	push   %edx
  8024e6:	50                   	push   %eax
  8024e7:	6a 27                	push   $0x27
  8024e9:	e8 aa fa ff ff       	call   801f98 <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
}
  8024f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	52                   	push   %edx
  802506:	50                   	push   %eax
  802507:	6a 28                	push   $0x28
  802509:	e8 8a fa ff ff       	call   801f98 <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802516:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802519:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251c:	8b 45 08             	mov    0x8(%ebp),%eax
  80251f:	6a 00                	push   $0x0
  802521:	51                   	push   %ecx
  802522:	ff 75 10             	pushl  0x10(%ebp)
  802525:	52                   	push   %edx
  802526:	50                   	push   %eax
  802527:	6a 29                	push   $0x29
  802529:	e8 6a fa ff ff       	call   801f98 <syscall>
  80252e:	83 c4 18             	add    $0x18,%esp
}
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	ff 75 10             	pushl  0x10(%ebp)
  80253d:	ff 75 0c             	pushl  0xc(%ebp)
  802540:	ff 75 08             	pushl  0x8(%ebp)
  802543:	6a 12                	push   $0x12
  802545:	e8 4e fa ff ff       	call   801f98 <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
	return ;
  80254d:	90                   	nop
}
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802553:	8b 55 0c             	mov    0xc(%ebp),%edx
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	52                   	push   %edx
  802560:	50                   	push   %eax
  802561:	6a 2a                	push   $0x2a
  802563:	e8 30 fa ff ff       	call   801f98 <syscall>
  802568:	83 c4 18             	add    $0x18,%esp
	return;
  80256b:	90                   	nop
}
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802571:	8b 45 08             	mov    0x8(%ebp),%eax
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	50                   	push   %eax
  80257d:	6a 2b                	push   $0x2b
  80257f:	e8 14 fa ff ff       	call   801f98 <syscall>
  802584:	83 c4 18             	add    $0x18,%esp
}
  802587:	c9                   	leave  
  802588:	c3                   	ret    

00802589 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	ff 75 0c             	pushl  0xc(%ebp)
  802595:	ff 75 08             	pushl  0x8(%ebp)
  802598:	6a 2c                	push   $0x2c
  80259a:	e8 f9 f9 ff ff       	call   801f98 <syscall>
  80259f:	83 c4 18             	add    $0x18,%esp
	return;
  8025a2:	90                   	nop
}
  8025a3:	c9                   	leave  
  8025a4:	c3                   	ret    

008025a5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	ff 75 0c             	pushl  0xc(%ebp)
  8025b1:	ff 75 08             	pushl  0x8(%ebp)
  8025b4:	6a 2d                	push   $0x2d
  8025b6:	e8 dd f9 ff ff       	call   801f98 <syscall>
  8025bb:	83 c4 18             	add    $0x18,%esp
	return;
  8025be:	90                   	nop
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
  8025c4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	83 e8 04             	sub    $0x4,%eax
  8025cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8025d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	83 e8 04             	sub    $0x4,%eax
  8025e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8025e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ec:	8b 00                	mov    (%eax),%eax
  8025ee:	83 e0 01             	and    $0x1,%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	0f 94 c0             	sete   %al
}
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    

008025f8 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802605:	8b 45 0c             	mov    0xc(%ebp),%eax
  802608:	83 f8 02             	cmp    $0x2,%eax
  80260b:	74 2b                	je     802638 <alloc_block+0x40>
  80260d:	83 f8 02             	cmp    $0x2,%eax
  802610:	7f 07                	jg     802619 <alloc_block+0x21>
  802612:	83 f8 01             	cmp    $0x1,%eax
  802615:	74 0e                	je     802625 <alloc_block+0x2d>
  802617:	eb 58                	jmp    802671 <alloc_block+0x79>
  802619:	83 f8 03             	cmp    $0x3,%eax
  80261c:	74 2d                	je     80264b <alloc_block+0x53>
  80261e:	83 f8 04             	cmp    $0x4,%eax
  802621:	74 3b                	je     80265e <alloc_block+0x66>
  802623:	eb 4c                	jmp    802671 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802625:	83 ec 0c             	sub    $0xc,%esp
  802628:	ff 75 08             	pushl  0x8(%ebp)
  80262b:	e8 11 03 00 00       	call   802941 <alloc_block_FF>
  802630:	83 c4 10             	add    $0x10,%esp
  802633:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802636:	eb 4a                	jmp    802682 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802638:	83 ec 0c             	sub    $0xc,%esp
  80263b:	ff 75 08             	pushl  0x8(%ebp)
  80263e:	e8 fa 19 00 00       	call   80403d <alloc_block_NF>
  802643:	83 c4 10             	add    $0x10,%esp
  802646:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802649:	eb 37                	jmp    802682 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80264b:	83 ec 0c             	sub    $0xc,%esp
  80264e:	ff 75 08             	pushl  0x8(%ebp)
  802651:	e8 a7 07 00 00       	call   802dfd <alloc_block_BF>
  802656:	83 c4 10             	add    $0x10,%esp
  802659:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80265c:	eb 24                	jmp    802682 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80265e:	83 ec 0c             	sub    $0xc,%esp
  802661:	ff 75 08             	pushl  0x8(%ebp)
  802664:	e8 b7 19 00 00       	call   804020 <alloc_block_WF>
  802669:	83 c4 10             	add    $0x10,%esp
  80266c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80266f:	eb 11                	jmp    802682 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802671:	83 ec 0c             	sub    $0xc,%esp
  802674:	68 d0 4e 80 00       	push   $0x804ed0
  802679:	e8 a8 e6 ff ff       	call   800d26 <cprintf>
  80267e:	83 c4 10             	add    $0x10,%esp
		break;
  802681:	90                   	nop
	}
	return va;
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	53                   	push   %ebx
  80268b:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80268e:	83 ec 0c             	sub    $0xc,%esp
  802691:	68 f0 4e 80 00       	push   $0x804ef0
  802696:	e8 8b e6 ff ff       	call   800d26 <cprintf>
  80269b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80269e:	83 ec 0c             	sub    $0xc,%esp
  8026a1:	68 1b 4f 80 00       	push   $0x804f1b
  8026a6:	e8 7b e6 ff ff       	call   800d26 <cprintf>
  8026ab:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b4:	eb 37                	jmp    8026ed <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8026b6:	83 ec 0c             	sub    $0xc,%esp
  8026b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8026bc:	e8 19 ff ff ff       	call   8025da <is_free_block>
  8026c1:	83 c4 10             	add    $0x10,%esp
  8026c4:	0f be d8             	movsbl %al,%ebx
  8026c7:	83 ec 0c             	sub    $0xc,%esp
  8026ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8026cd:	e8 ef fe ff ff       	call   8025c1 <get_block_size>
  8026d2:	83 c4 10             	add    $0x10,%esp
  8026d5:	83 ec 04             	sub    $0x4,%esp
  8026d8:	53                   	push   %ebx
  8026d9:	50                   	push   %eax
  8026da:	68 33 4f 80 00       	push   $0x804f33
  8026df:	e8 42 e6 ff ff       	call   800d26 <cprintf>
  8026e4:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f1:	74 07                	je     8026fa <print_blocks_list+0x73>
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	8b 00                	mov    (%eax),%eax
  8026f8:	eb 05                	jmp    8026ff <print_blocks_list+0x78>
  8026fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ff:	89 45 10             	mov    %eax,0x10(%ebp)
  802702:	8b 45 10             	mov    0x10(%ebp),%eax
  802705:	85 c0                	test   %eax,%eax
  802707:	75 ad                	jne    8026b6 <print_blocks_list+0x2f>
  802709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270d:	75 a7                	jne    8026b6 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80270f:	83 ec 0c             	sub    $0xc,%esp
  802712:	68 f0 4e 80 00       	push   $0x804ef0
  802717:	e8 0a e6 ff ff       	call   800d26 <cprintf>
  80271c:	83 c4 10             	add    $0x10,%esp

}
  80271f:	90                   	nop
  802720:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802723:	c9                   	leave  
  802724:	c3                   	ret    

00802725 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
  802728:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80272b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272e:	83 e0 01             	and    $0x1,%eax
  802731:	85 c0                	test   %eax,%eax
  802733:	74 03                	je     802738 <initialize_dynamic_allocator+0x13>
  802735:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802738:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80273c:	0f 84 c7 01 00 00    	je     802909 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802742:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802749:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80274c:	8b 55 08             	mov    0x8(%ebp),%edx
  80274f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802752:	01 d0                	add    %edx,%eax
  802754:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802759:	0f 87 ad 01 00 00    	ja     80290c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80275f:	8b 45 08             	mov    0x8(%ebp),%eax
  802762:	85 c0                	test   %eax,%eax
  802764:	0f 89 a5 01 00 00    	jns    80290f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80276a:	8b 55 08             	mov    0x8(%ebp),%edx
  80276d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802770:	01 d0                	add    %edx,%eax
  802772:	83 e8 04             	sub    $0x4,%eax
  802775:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  80277a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802781:	a1 44 60 80 00       	mov    0x806044,%eax
  802786:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802789:	e9 87 00 00 00       	jmp    802815 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80278e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802792:	75 14                	jne    8027a8 <initialize_dynamic_allocator+0x83>
  802794:	83 ec 04             	sub    $0x4,%esp
  802797:	68 4b 4f 80 00       	push   $0x804f4b
  80279c:	6a 79                	push   $0x79
  80279e:	68 69 4f 80 00       	push   $0x804f69
  8027a3:	e8 c1 e2 ff ff       	call   800a69 <_panic>
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	74 10                	je     8027c1 <initialize_dynamic_allocator+0x9c>
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b9:	8b 52 04             	mov    0x4(%edx),%edx
  8027bc:	89 50 04             	mov    %edx,0x4(%eax)
  8027bf:	eb 0b                	jmp    8027cc <initialize_dynamic_allocator+0xa7>
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	a3 48 60 80 00       	mov    %eax,0x806048
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 40 04             	mov    0x4(%eax),%eax
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	74 0f                	je     8027e5 <initialize_dynamic_allocator+0xc0>
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 04             	mov    0x4(%eax),%eax
  8027dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027df:	8b 12                	mov    (%edx),%edx
  8027e1:	89 10                	mov    %edx,(%eax)
  8027e3:	eb 0a                	jmp    8027ef <initialize_dynamic_allocator+0xca>
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	a3 44 60 80 00       	mov    %eax,0x806044
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802802:	a1 50 60 80 00       	mov    0x806050,%eax
  802807:	48                   	dec    %eax
  802808:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80280d:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802819:	74 07                	je     802822 <initialize_dynamic_allocator+0xfd>
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	eb 05                	jmp    802827 <initialize_dynamic_allocator+0x102>
  802822:	b8 00 00 00 00       	mov    $0x0,%eax
  802827:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80282c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	0f 85 55 ff ff ff    	jne    80278e <initialize_dynamic_allocator+0x69>
  802839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283d:	0f 85 4b ff ff ff    	jne    80278e <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802852:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  802857:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  80285c:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802861:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	83 c0 08             	add    $0x8,%eax
  80286d:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	83 c0 04             	add    $0x4,%eax
  802876:	8b 55 0c             	mov    0xc(%ebp),%edx
  802879:	83 ea 08             	sub    $0x8,%edx
  80287c:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80287e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802881:	8b 45 08             	mov    0x8(%ebp),%eax
  802884:	01 d0                	add    %edx,%eax
  802886:	83 e8 08             	sub    $0x8,%eax
  802889:	8b 55 0c             	mov    0xc(%ebp),%edx
  80288c:	83 ea 08             	sub    $0x8,%edx
  80288f:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80289a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8028a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028a8:	75 17                	jne    8028c1 <initialize_dynamic_allocator+0x19c>
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	68 84 4f 80 00       	push   $0x804f84
  8028b2:	68 90 00 00 00       	push   $0x90
  8028b7:	68 69 4f 80 00       	push   $0x804f69
  8028bc:	e8 a8 e1 ff ff       	call   800a69 <_panic>
  8028c1:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8028c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ca:	89 10                	mov    %edx,(%eax)
  8028cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cf:	8b 00                	mov    (%eax),%eax
  8028d1:	85 c0                	test   %eax,%eax
  8028d3:	74 0d                	je     8028e2 <initialize_dynamic_allocator+0x1bd>
  8028d5:	a1 44 60 80 00       	mov    0x806044,%eax
  8028da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028dd:	89 50 04             	mov    %edx,0x4(%eax)
  8028e0:	eb 08                	jmp    8028ea <initialize_dynamic_allocator+0x1c5>
  8028e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e5:	a3 48 60 80 00       	mov    %eax,0x806048
  8028ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ed:	a3 44 60 80 00       	mov    %eax,0x806044
  8028f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fc:	a1 50 60 80 00       	mov    0x806050,%eax
  802901:	40                   	inc    %eax
  802902:	a3 50 60 80 00       	mov    %eax,0x806050
  802907:	eb 07                	jmp    802910 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802909:	90                   	nop
  80290a:	eb 04                	jmp    802910 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80290c:	90                   	nop
  80290d:	eb 01                	jmp    802910 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80290f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802910:	c9                   	leave  
  802911:	c3                   	ret    

00802912 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802912:	55                   	push   %ebp
  802913:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802915:	8b 45 10             	mov    0x10(%ebp),%eax
  802918:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802921:	8b 45 0c             	mov    0xc(%ebp),%eax
  802924:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	83 e8 04             	sub    $0x4,%eax
  80292c:	8b 00                	mov    (%eax),%eax
  80292e:	83 e0 fe             	and    $0xfffffffe,%eax
  802931:	8d 50 f8             	lea    -0x8(%eax),%edx
  802934:	8b 45 08             	mov    0x8(%ebp),%eax
  802937:	01 c2                	add    %eax,%edx
  802939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80293c:	89 02                	mov    %eax,(%edx)
}
  80293e:	90                   	nop
  80293f:	5d                   	pop    %ebp
  802940:	c3                   	ret    

00802941 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802941:	55                   	push   %ebp
  802942:	89 e5                	mov    %esp,%ebp
  802944:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	83 e0 01             	and    $0x1,%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	74 03                	je     802954 <alloc_block_FF+0x13>
  802951:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802954:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802958:	77 07                	ja     802961 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80295a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802961:	a1 24 60 80 00       	mov    0x806024,%eax
  802966:	85 c0                	test   %eax,%eax
  802968:	75 73                	jne    8029dd <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	83 c0 10             	add    $0x10,%eax
  802970:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802973:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80297a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802980:	01 d0                	add    %edx,%eax
  802982:	48                   	dec    %eax
  802983:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802986:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802989:	ba 00 00 00 00       	mov    $0x0,%edx
  80298e:	f7 75 ec             	divl   -0x14(%ebp)
  802991:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802994:	29 d0                	sub    %edx,%eax
  802996:	c1 e8 0c             	shr    $0xc,%eax
  802999:	83 ec 0c             	sub    $0xc,%esp
  80299c:	50                   	push   %eax
  80299d:	e8 1e f1 ff ff       	call   801ac0 <sbrk>
  8029a2:	83 c4 10             	add    $0x10,%esp
  8029a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029a8:	83 ec 0c             	sub    $0xc,%esp
  8029ab:	6a 00                	push   $0x0
  8029ad:	e8 0e f1 ff ff       	call   801ac0 <sbrk>
  8029b2:	83 c4 10             	add    $0x10,%esp
  8029b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029bb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8029be:	83 ec 08             	sub    $0x8,%esp
  8029c1:	50                   	push   %eax
  8029c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029c5:	e8 5b fd ff ff       	call   802725 <initialize_dynamic_allocator>
  8029ca:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029cd:	83 ec 0c             	sub    $0xc,%esp
  8029d0:	68 a7 4f 80 00       	push   $0x804fa7
  8029d5:	e8 4c e3 ff ff       	call   800d26 <cprintf>
  8029da:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8029dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e1:	75 0a                	jne    8029ed <alloc_block_FF+0xac>
	        return NULL;
  8029e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e8:	e9 0e 04 00 00       	jmp    802dfb <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8029ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8029f4:	a1 44 60 80 00       	mov    0x806044,%eax
  8029f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fc:	e9 f3 02 00 00       	jmp    802cf4 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802a07:	83 ec 0c             	sub    $0xc,%esp
  802a0a:	ff 75 bc             	pushl  -0x44(%ebp)
  802a0d:	e8 af fb ff ff       	call   8025c1 <get_block_size>
  802a12:	83 c4 10             	add    $0x10,%esp
  802a15:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	83 c0 08             	add    $0x8,%eax
  802a1e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a21:	0f 87 c5 02 00 00    	ja     802cec <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	83 c0 18             	add    $0x18,%eax
  802a2d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a30:	0f 87 19 02 00 00    	ja     802c4f <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802a36:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a39:	2b 45 08             	sub    0x8(%ebp),%eax
  802a3c:	83 e8 08             	sub    $0x8,%eax
  802a3f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	8d 50 08             	lea    0x8(%eax),%edx
  802a48:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a4b:	01 d0                	add    %edx,%eax
  802a4d:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a50:	8b 45 08             	mov    0x8(%ebp),%eax
  802a53:	83 c0 08             	add    $0x8,%eax
  802a56:	83 ec 04             	sub    $0x4,%esp
  802a59:	6a 01                	push   $0x1
  802a5b:	50                   	push   %eax
  802a5c:	ff 75 bc             	pushl  -0x44(%ebp)
  802a5f:	e8 ae fe ff ff       	call   802912 <set_block_data>
  802a64:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 40 04             	mov    0x4(%eax),%eax
  802a6d:	85 c0                	test   %eax,%eax
  802a6f:	75 68                	jne    802ad9 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a71:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a75:	75 17                	jne    802a8e <alloc_block_FF+0x14d>
  802a77:	83 ec 04             	sub    $0x4,%esp
  802a7a:	68 84 4f 80 00       	push   $0x804f84
  802a7f:	68 d7 00 00 00       	push   $0xd7
  802a84:	68 69 4f 80 00       	push   $0x804f69
  802a89:	e8 db df ff ff       	call   800a69 <_panic>
  802a8e:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802a94:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a97:	89 10                	mov    %edx,(%eax)
  802a99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a9c:	8b 00                	mov    (%eax),%eax
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	74 0d                	je     802aaf <alloc_block_FF+0x16e>
  802aa2:	a1 44 60 80 00       	mov    0x806044,%eax
  802aa7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802aaa:	89 50 04             	mov    %edx,0x4(%eax)
  802aad:	eb 08                	jmp    802ab7 <alloc_block_FF+0x176>
  802aaf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ab2:	a3 48 60 80 00       	mov    %eax,0x806048
  802ab7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aba:	a3 44 60 80 00       	mov    %eax,0x806044
  802abf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac9:	a1 50 60 80 00       	mov    0x806050,%eax
  802ace:	40                   	inc    %eax
  802acf:	a3 50 60 80 00       	mov    %eax,0x806050
  802ad4:	e9 dc 00 00 00       	jmp    802bb5 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	75 65                	jne    802b47 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ae2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ae6:	75 17                	jne    802aff <alloc_block_FF+0x1be>
  802ae8:	83 ec 04             	sub    $0x4,%esp
  802aeb:	68 b8 4f 80 00       	push   $0x804fb8
  802af0:	68 db 00 00 00       	push   $0xdb
  802af5:	68 69 4f 80 00       	push   $0x804f69
  802afa:	e8 6a df ff ff       	call   800a69 <_panic>
  802aff:	8b 15 48 60 80 00    	mov    0x806048,%edx
  802b05:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b08:	89 50 04             	mov    %edx,0x4(%eax)
  802b0b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b0e:	8b 40 04             	mov    0x4(%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	74 0c                	je     802b21 <alloc_block_FF+0x1e0>
  802b15:	a1 48 60 80 00       	mov    0x806048,%eax
  802b1a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b1d:	89 10                	mov    %edx,(%eax)
  802b1f:	eb 08                	jmp    802b29 <alloc_block_FF+0x1e8>
  802b21:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b24:	a3 44 60 80 00       	mov    %eax,0x806044
  802b29:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b2c:	a3 48 60 80 00       	mov    %eax,0x806048
  802b31:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3a:	a1 50 60 80 00       	mov    0x806050,%eax
  802b3f:	40                   	inc    %eax
  802b40:	a3 50 60 80 00       	mov    %eax,0x806050
  802b45:	eb 6e                	jmp    802bb5 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4b:	74 06                	je     802b53 <alloc_block_FF+0x212>
  802b4d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b51:	75 17                	jne    802b6a <alloc_block_FF+0x229>
  802b53:	83 ec 04             	sub    $0x4,%esp
  802b56:	68 dc 4f 80 00       	push   $0x804fdc
  802b5b:	68 df 00 00 00       	push   $0xdf
  802b60:	68 69 4f 80 00       	push   $0x804f69
  802b65:	e8 ff de ff ff       	call   800a69 <_panic>
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 10                	mov    (%eax),%edx
  802b6f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b72:	89 10                	mov    %edx,(%eax)
  802b74:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	74 0b                	je     802b88 <alloc_block_FF+0x247>
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 00                	mov    (%eax),%eax
  802b82:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b85:	89 50 04             	mov    %edx,0x4(%eax)
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b8e:	89 10                	mov    %edx,(%eax)
  802b90:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b96:	89 50 04             	mov    %edx,0x4(%eax)
  802b99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b9c:	8b 00                	mov    (%eax),%eax
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	75 08                	jne    802baa <alloc_block_FF+0x269>
  802ba2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba5:	a3 48 60 80 00       	mov    %eax,0x806048
  802baa:	a1 50 60 80 00       	mov    0x806050,%eax
  802baf:	40                   	inc    %eax
  802bb0:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802bb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb9:	75 17                	jne    802bd2 <alloc_block_FF+0x291>
  802bbb:	83 ec 04             	sub    $0x4,%esp
  802bbe:	68 4b 4f 80 00       	push   $0x804f4b
  802bc3:	68 e1 00 00 00       	push   $0xe1
  802bc8:	68 69 4f 80 00       	push   $0x804f69
  802bcd:	e8 97 de ff ff       	call   800a69 <_panic>
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	74 10                	je     802beb <alloc_block_FF+0x2aa>
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 00                	mov    (%eax),%eax
  802be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be3:	8b 52 04             	mov    0x4(%edx),%edx
  802be6:	89 50 04             	mov    %edx,0x4(%eax)
  802be9:	eb 0b                	jmp    802bf6 <alloc_block_FF+0x2b5>
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 40 04             	mov    0x4(%eax),%eax
  802bf1:	a3 48 60 80 00       	mov    %eax,0x806048
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 40 04             	mov    0x4(%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 0f                	je     802c0f <alloc_block_FF+0x2ce>
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c09:	8b 12                	mov    (%edx),%edx
  802c0b:	89 10                	mov    %edx,(%eax)
  802c0d:	eb 0a                	jmp    802c19 <alloc_block_FF+0x2d8>
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 00                	mov    (%eax),%eax
  802c14:	a3 44 60 80 00       	mov    %eax,0x806044
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2c:	a1 50 60 80 00       	mov    0x806050,%eax
  802c31:	48                   	dec    %eax
  802c32:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  802c37:	83 ec 04             	sub    $0x4,%esp
  802c3a:	6a 00                	push   $0x0
  802c3c:	ff 75 b4             	pushl  -0x4c(%ebp)
  802c3f:	ff 75 b0             	pushl  -0x50(%ebp)
  802c42:	e8 cb fc ff ff       	call   802912 <set_block_data>
  802c47:	83 c4 10             	add    $0x10,%esp
  802c4a:	e9 95 00 00 00       	jmp    802ce4 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c4f:	83 ec 04             	sub    $0x4,%esp
  802c52:	6a 01                	push   $0x1
  802c54:	ff 75 b8             	pushl  -0x48(%ebp)
  802c57:	ff 75 bc             	pushl  -0x44(%ebp)
  802c5a:	e8 b3 fc ff ff       	call   802912 <set_block_data>
  802c5f:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c66:	75 17                	jne    802c7f <alloc_block_FF+0x33e>
  802c68:	83 ec 04             	sub    $0x4,%esp
  802c6b:	68 4b 4f 80 00       	push   $0x804f4b
  802c70:	68 e8 00 00 00       	push   $0xe8
  802c75:	68 69 4f 80 00       	push   $0x804f69
  802c7a:	e8 ea dd ff ff       	call   800a69 <_panic>
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 00                	mov    (%eax),%eax
  802c84:	85 c0                	test   %eax,%eax
  802c86:	74 10                	je     802c98 <alloc_block_FF+0x357>
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c90:	8b 52 04             	mov    0x4(%edx),%edx
  802c93:	89 50 04             	mov    %edx,0x4(%eax)
  802c96:	eb 0b                	jmp    802ca3 <alloc_block_FF+0x362>
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 40 04             	mov    0x4(%eax),%eax
  802c9e:	a3 48 60 80 00       	mov    %eax,0x806048
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 40 04             	mov    0x4(%eax),%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	74 0f                	je     802cbc <alloc_block_FF+0x37b>
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 40 04             	mov    0x4(%eax),%eax
  802cb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb6:	8b 12                	mov    (%edx),%edx
  802cb8:	89 10                	mov    %edx,(%eax)
  802cba:	eb 0a                	jmp    802cc6 <alloc_block_FF+0x385>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	a3 44 60 80 00       	mov    %eax,0x806044
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd9:	a1 50 60 80 00       	mov    0x806050,%eax
  802cde:	48                   	dec    %eax
  802cdf:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  802ce4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ce7:	e9 0f 01 00 00       	jmp    802dfb <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802cec:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf8:	74 07                	je     802d01 <alloc_block_FF+0x3c0>
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	8b 00                	mov    (%eax),%eax
  802cff:	eb 05                	jmp    802d06 <alloc_block_FF+0x3c5>
  802d01:	b8 00 00 00 00       	mov    $0x0,%eax
  802d06:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802d0b:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	0f 85 e9 fc ff ff    	jne    802a01 <alloc_block_FF+0xc0>
  802d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1c:	0f 85 df fc ff ff    	jne    802a01 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	83 c0 08             	add    $0x8,%eax
  802d28:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d2b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d32:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d35:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d38:	01 d0                	add    %edx,%eax
  802d3a:	48                   	dec    %eax
  802d3b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d41:	ba 00 00 00 00       	mov    $0x0,%edx
  802d46:	f7 75 d8             	divl   -0x28(%ebp)
  802d49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d4c:	29 d0                	sub    %edx,%eax
  802d4e:	c1 e8 0c             	shr    $0xc,%eax
  802d51:	83 ec 0c             	sub    $0xc,%esp
  802d54:	50                   	push   %eax
  802d55:	e8 66 ed ff ff       	call   801ac0 <sbrk>
  802d5a:	83 c4 10             	add    $0x10,%esp
  802d5d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d60:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d64:	75 0a                	jne    802d70 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d66:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6b:	e9 8b 00 00 00       	jmp    802dfb <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d70:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d77:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d7d:	01 d0                	add    %edx,%eax
  802d7f:	48                   	dec    %eax
  802d80:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d83:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d86:	ba 00 00 00 00       	mov    $0x0,%edx
  802d8b:	f7 75 cc             	divl   -0x34(%ebp)
  802d8e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d91:	29 d0                	sub    %edx,%eax
  802d93:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d96:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d99:	01 d0                	add    %edx,%eax
  802d9b:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  802da0:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802da5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802dab:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802db2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802db5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802db8:	01 d0                	add    %edx,%eax
  802dba:	48                   	dec    %eax
  802dbb:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802dbe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dc1:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc6:	f7 75 c4             	divl   -0x3c(%ebp)
  802dc9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dcc:	29 d0                	sub    %edx,%eax
  802dce:	83 ec 04             	sub    $0x4,%esp
  802dd1:	6a 01                	push   $0x1
  802dd3:	50                   	push   %eax
  802dd4:	ff 75 d0             	pushl  -0x30(%ebp)
  802dd7:	e8 36 fb ff ff       	call   802912 <set_block_data>
  802ddc:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802ddf:	83 ec 0c             	sub    $0xc,%esp
  802de2:	ff 75 d0             	pushl  -0x30(%ebp)
  802de5:	e8 1b 0a 00 00       	call   803805 <free_block>
  802dea:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802ded:	83 ec 0c             	sub    $0xc,%esp
  802df0:	ff 75 08             	pushl  0x8(%ebp)
  802df3:	e8 49 fb ff ff       	call   802941 <alloc_block_FF>
  802df8:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802dfb:	c9                   	leave  
  802dfc:	c3                   	ret    

00802dfd <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802dfd:	55                   	push   %ebp
  802dfe:	89 e5                	mov    %esp,%ebp
  802e00:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	83 e0 01             	and    $0x1,%eax
  802e09:	85 c0                	test   %eax,%eax
  802e0b:	74 03                	je     802e10 <alloc_block_BF+0x13>
  802e0d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e10:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e14:	77 07                	ja     802e1d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e16:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e1d:	a1 24 60 80 00       	mov    0x806024,%eax
  802e22:	85 c0                	test   %eax,%eax
  802e24:	75 73                	jne    802e99 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	83 c0 10             	add    $0x10,%eax
  802e2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e2f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802e36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3c:	01 d0                	add    %edx,%eax
  802e3e:	48                   	dec    %eax
  802e3f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e45:	ba 00 00 00 00       	mov    $0x0,%edx
  802e4a:	f7 75 e0             	divl   -0x20(%ebp)
  802e4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e50:	29 d0                	sub    %edx,%eax
  802e52:	c1 e8 0c             	shr    $0xc,%eax
  802e55:	83 ec 0c             	sub    $0xc,%esp
  802e58:	50                   	push   %eax
  802e59:	e8 62 ec ff ff       	call   801ac0 <sbrk>
  802e5e:	83 c4 10             	add    $0x10,%esp
  802e61:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e64:	83 ec 0c             	sub    $0xc,%esp
  802e67:	6a 00                	push   $0x0
  802e69:	e8 52 ec ff ff       	call   801ac0 <sbrk>
  802e6e:	83 c4 10             	add    $0x10,%esp
  802e71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e77:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e7a:	83 ec 08             	sub    $0x8,%esp
  802e7d:	50                   	push   %eax
  802e7e:	ff 75 d8             	pushl  -0x28(%ebp)
  802e81:	e8 9f f8 ff ff       	call   802725 <initialize_dynamic_allocator>
  802e86:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e89:	83 ec 0c             	sub    $0xc,%esp
  802e8c:	68 a7 4f 80 00       	push   $0x804fa7
  802e91:	e8 90 de ff ff       	call   800d26 <cprintf>
  802e96:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802e99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ea0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ea7:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802eae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802eb5:	a1 44 60 80 00       	mov    0x806044,%eax
  802eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebd:	e9 1d 01 00 00       	jmp    802fdf <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802ec8:	83 ec 0c             	sub    $0xc,%esp
  802ecb:	ff 75 a8             	pushl  -0x58(%ebp)
  802ece:	e8 ee f6 ff ff       	call   8025c1 <get_block_size>
  802ed3:	83 c4 10             	add    $0x10,%esp
  802ed6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	83 c0 08             	add    $0x8,%eax
  802edf:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ee2:	0f 87 ef 00 00 00    	ja     802fd7 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	83 c0 18             	add    $0x18,%eax
  802eee:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ef1:	77 1d                	ja     802f10 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ef9:	0f 86 d8 00 00 00    	jbe    802fd7 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802eff:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802f05:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f08:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f0b:	e9 c7 00 00 00       	jmp    802fd7 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802f10:	8b 45 08             	mov    0x8(%ebp),%eax
  802f13:	83 c0 08             	add    $0x8,%eax
  802f16:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f19:	0f 85 9d 00 00 00    	jne    802fbc <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802f1f:	83 ec 04             	sub    $0x4,%esp
  802f22:	6a 01                	push   $0x1
  802f24:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f27:	ff 75 a8             	pushl  -0x58(%ebp)
  802f2a:	e8 e3 f9 ff ff       	call   802912 <set_block_data>
  802f2f:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f36:	75 17                	jne    802f4f <alloc_block_BF+0x152>
  802f38:	83 ec 04             	sub    $0x4,%esp
  802f3b:	68 4b 4f 80 00       	push   $0x804f4b
  802f40:	68 2c 01 00 00       	push   $0x12c
  802f45:	68 69 4f 80 00       	push   $0x804f69
  802f4a:	e8 1a db ff ff       	call   800a69 <_panic>
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	8b 00                	mov    (%eax),%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	74 10                	je     802f68 <alloc_block_BF+0x16b>
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f60:	8b 52 04             	mov    0x4(%edx),%edx
  802f63:	89 50 04             	mov    %edx,0x4(%eax)
  802f66:	eb 0b                	jmp    802f73 <alloc_block_BF+0x176>
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	8b 40 04             	mov    0x4(%eax),%eax
  802f6e:	a3 48 60 80 00       	mov    %eax,0x806048
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 40 04             	mov    0x4(%eax),%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	74 0f                	je     802f8c <alloc_block_BF+0x18f>
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 40 04             	mov    0x4(%eax),%eax
  802f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f86:	8b 12                	mov    (%edx),%edx
  802f88:	89 10                	mov    %edx,(%eax)
  802f8a:	eb 0a                	jmp    802f96 <alloc_block_BF+0x199>
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	8b 00                	mov    (%eax),%eax
  802f91:	a3 44 60 80 00       	mov    %eax,0x806044
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa9:	a1 50 60 80 00       	mov    0x806050,%eax
  802fae:	48                   	dec    %eax
  802faf:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  802fb4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fb7:	e9 24 04 00 00       	jmp    8033e0 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbf:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fc2:	76 13                	jbe    802fd7 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802fc4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802fcb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802fd1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802fd4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802fd7:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe3:	74 07                	je     802fec <alloc_block_BF+0x1ef>
  802fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	eb 05                	jmp    802ff1 <alloc_block_BF+0x1f4>
  802fec:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff1:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802ff6:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	0f 85 bf fe ff ff    	jne    802ec2 <alloc_block_BF+0xc5>
  803003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803007:	0f 85 b5 fe ff ff    	jne    802ec2 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80300d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803011:	0f 84 26 02 00 00    	je     80323d <alloc_block_BF+0x440>
  803017:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80301b:	0f 85 1c 02 00 00    	jne    80323d <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803021:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803024:	2b 45 08             	sub    0x8(%ebp),%eax
  803027:	83 e8 08             	sub    $0x8,%eax
  80302a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	8d 50 08             	lea    0x8(%eax),%edx
  803033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803036:	01 d0                	add    %edx,%eax
  803038:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	83 c0 08             	add    $0x8,%eax
  803041:	83 ec 04             	sub    $0x4,%esp
  803044:	6a 01                	push   $0x1
  803046:	50                   	push   %eax
  803047:	ff 75 f0             	pushl  -0x10(%ebp)
  80304a:	e8 c3 f8 ff ff       	call   802912 <set_block_data>
  80304f:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803055:	8b 40 04             	mov    0x4(%eax),%eax
  803058:	85 c0                	test   %eax,%eax
  80305a:	75 68                	jne    8030c4 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80305c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803060:	75 17                	jne    803079 <alloc_block_BF+0x27c>
  803062:	83 ec 04             	sub    $0x4,%esp
  803065:	68 84 4f 80 00       	push   $0x804f84
  80306a:	68 45 01 00 00       	push   $0x145
  80306f:	68 69 4f 80 00       	push   $0x804f69
  803074:	e8 f0 d9 ff ff       	call   800a69 <_panic>
  803079:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80307f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803082:	89 10                	mov    %edx,(%eax)
  803084:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	85 c0                	test   %eax,%eax
  80308b:	74 0d                	je     80309a <alloc_block_BF+0x29d>
  80308d:	a1 44 60 80 00       	mov    0x806044,%eax
  803092:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803095:	89 50 04             	mov    %edx,0x4(%eax)
  803098:	eb 08                	jmp    8030a2 <alloc_block_BF+0x2a5>
  80309a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80309d:	a3 48 60 80 00       	mov    %eax,0x806048
  8030a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a5:	a3 44 60 80 00       	mov    %eax,0x806044
  8030aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b4:	a1 50 60 80 00       	mov    0x806050,%eax
  8030b9:	40                   	inc    %eax
  8030ba:	a3 50 60 80 00       	mov    %eax,0x806050
  8030bf:	e9 dc 00 00 00       	jmp    8031a0 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8030c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c7:	8b 00                	mov    (%eax),%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	75 65                	jne    803132 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030cd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030d1:	75 17                	jne    8030ea <alloc_block_BF+0x2ed>
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	68 b8 4f 80 00       	push   $0x804fb8
  8030db:	68 4a 01 00 00       	push   $0x14a
  8030e0:	68 69 4f 80 00       	push   $0x804f69
  8030e5:	e8 7f d9 ff ff       	call   800a69 <_panic>
  8030ea:	8b 15 48 60 80 00    	mov    0x806048,%edx
  8030f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f3:	89 50 04             	mov    %edx,0x4(%eax)
  8030f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f9:	8b 40 04             	mov    0x4(%eax),%eax
  8030fc:	85 c0                	test   %eax,%eax
  8030fe:	74 0c                	je     80310c <alloc_block_BF+0x30f>
  803100:	a1 48 60 80 00       	mov    0x806048,%eax
  803105:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803108:	89 10                	mov    %edx,(%eax)
  80310a:	eb 08                	jmp    803114 <alloc_block_BF+0x317>
  80310c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80310f:	a3 44 60 80 00       	mov    %eax,0x806044
  803114:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803117:	a3 48 60 80 00       	mov    %eax,0x806048
  80311c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80311f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803125:	a1 50 60 80 00       	mov    0x806050,%eax
  80312a:	40                   	inc    %eax
  80312b:	a3 50 60 80 00       	mov    %eax,0x806050
  803130:	eb 6e                	jmp    8031a0 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803132:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803136:	74 06                	je     80313e <alloc_block_BF+0x341>
  803138:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80313c:	75 17                	jne    803155 <alloc_block_BF+0x358>
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	68 dc 4f 80 00       	push   $0x804fdc
  803146:	68 4f 01 00 00       	push   $0x14f
  80314b:	68 69 4f 80 00       	push   $0x804f69
  803150:	e8 14 d9 ff ff       	call   800a69 <_panic>
  803155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803158:	8b 10                	mov    (%eax),%edx
  80315a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80315d:	89 10                	mov    %edx,(%eax)
  80315f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803162:	8b 00                	mov    (%eax),%eax
  803164:	85 c0                	test   %eax,%eax
  803166:	74 0b                	je     803173 <alloc_block_BF+0x376>
  803168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316b:	8b 00                	mov    (%eax),%eax
  80316d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803170:	89 50 04             	mov    %edx,0x4(%eax)
  803173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803176:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803179:	89 10                	mov    %edx,(%eax)
  80317b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80317e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803181:	89 50 04             	mov    %edx,0x4(%eax)
  803184:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	85 c0                	test   %eax,%eax
  80318b:	75 08                	jne    803195 <alloc_block_BF+0x398>
  80318d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803190:	a3 48 60 80 00       	mov    %eax,0x806048
  803195:	a1 50 60 80 00       	mov    0x806050,%eax
  80319a:	40                   	inc    %eax
  80319b:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8031a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031a4:	75 17                	jne    8031bd <alloc_block_BF+0x3c0>
  8031a6:	83 ec 04             	sub    $0x4,%esp
  8031a9:	68 4b 4f 80 00       	push   $0x804f4b
  8031ae:	68 51 01 00 00       	push   $0x151
  8031b3:	68 69 4f 80 00       	push   $0x804f69
  8031b8:	e8 ac d8 ff ff       	call   800a69 <_panic>
  8031bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c0:	8b 00                	mov    (%eax),%eax
  8031c2:	85 c0                	test   %eax,%eax
  8031c4:	74 10                	je     8031d6 <alloc_block_BF+0x3d9>
  8031c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c9:	8b 00                	mov    (%eax),%eax
  8031cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ce:	8b 52 04             	mov    0x4(%edx),%edx
  8031d1:	89 50 04             	mov    %edx,0x4(%eax)
  8031d4:	eb 0b                	jmp    8031e1 <alloc_block_BF+0x3e4>
  8031d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d9:	8b 40 04             	mov    0x4(%eax),%eax
  8031dc:	a3 48 60 80 00       	mov    %eax,0x806048
  8031e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e4:	8b 40 04             	mov    0x4(%eax),%eax
  8031e7:	85 c0                	test   %eax,%eax
  8031e9:	74 0f                	je     8031fa <alloc_block_BF+0x3fd>
  8031eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ee:	8b 40 04             	mov    0x4(%eax),%eax
  8031f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f4:	8b 12                	mov    (%edx),%edx
  8031f6:	89 10                	mov    %edx,(%eax)
  8031f8:	eb 0a                	jmp    803204 <alloc_block_BF+0x407>
  8031fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fd:	8b 00                	mov    (%eax),%eax
  8031ff:	a3 44 60 80 00       	mov    %eax,0x806044
  803204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803207:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80320d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803210:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803217:	a1 50 60 80 00       	mov    0x806050,%eax
  80321c:	48                   	dec    %eax
  80321d:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  803222:	83 ec 04             	sub    $0x4,%esp
  803225:	6a 00                	push   $0x0
  803227:	ff 75 d0             	pushl  -0x30(%ebp)
  80322a:	ff 75 cc             	pushl  -0x34(%ebp)
  80322d:	e8 e0 f6 ff ff       	call   802912 <set_block_data>
  803232:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803238:	e9 a3 01 00 00       	jmp    8033e0 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80323d:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803241:	0f 85 9d 00 00 00    	jne    8032e4 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803247:	83 ec 04             	sub    $0x4,%esp
  80324a:	6a 01                	push   $0x1
  80324c:	ff 75 ec             	pushl  -0x14(%ebp)
  80324f:	ff 75 f0             	pushl  -0x10(%ebp)
  803252:	e8 bb f6 ff ff       	call   802912 <set_block_data>
  803257:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80325a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80325e:	75 17                	jne    803277 <alloc_block_BF+0x47a>
  803260:	83 ec 04             	sub    $0x4,%esp
  803263:	68 4b 4f 80 00       	push   $0x804f4b
  803268:	68 58 01 00 00       	push   $0x158
  80326d:	68 69 4f 80 00       	push   $0x804f69
  803272:	e8 f2 d7 ff ff       	call   800a69 <_panic>
  803277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	74 10                	je     803290 <alloc_block_BF+0x493>
  803280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803283:	8b 00                	mov    (%eax),%eax
  803285:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803288:	8b 52 04             	mov    0x4(%edx),%edx
  80328b:	89 50 04             	mov    %edx,0x4(%eax)
  80328e:	eb 0b                	jmp    80329b <alloc_block_BF+0x49e>
  803290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803293:	8b 40 04             	mov    0x4(%eax),%eax
  803296:	a3 48 60 80 00       	mov    %eax,0x806048
  80329b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329e:	8b 40 04             	mov    0x4(%eax),%eax
  8032a1:	85 c0                	test   %eax,%eax
  8032a3:	74 0f                	je     8032b4 <alloc_block_BF+0x4b7>
  8032a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a8:	8b 40 04             	mov    0x4(%eax),%eax
  8032ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ae:	8b 12                	mov    (%edx),%edx
  8032b0:	89 10                	mov    %edx,(%eax)
  8032b2:	eb 0a                	jmp    8032be <alloc_block_BF+0x4c1>
  8032b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	a3 44 60 80 00       	mov    %eax,0x806044
  8032be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d1:	a1 50 60 80 00       	mov    0x806050,%eax
  8032d6:	48                   	dec    %eax
  8032d7:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  8032dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032df:	e9 fc 00 00 00       	jmp    8033e0 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	83 c0 08             	add    $0x8,%eax
  8032ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8032ed:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8032f4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8032fa:	01 d0                	add    %edx,%eax
  8032fc:	48                   	dec    %eax
  8032fd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803300:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803303:	ba 00 00 00 00       	mov    $0x0,%edx
  803308:	f7 75 c4             	divl   -0x3c(%ebp)
  80330b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80330e:	29 d0                	sub    %edx,%eax
  803310:	c1 e8 0c             	shr    $0xc,%eax
  803313:	83 ec 0c             	sub    $0xc,%esp
  803316:	50                   	push   %eax
  803317:	e8 a4 e7 ff ff       	call   801ac0 <sbrk>
  80331c:	83 c4 10             	add    $0x10,%esp
  80331f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803322:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803326:	75 0a                	jne    803332 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803328:	b8 00 00 00 00       	mov    $0x0,%eax
  80332d:	e9 ae 00 00 00       	jmp    8033e0 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803332:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803339:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80333c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80333f:	01 d0                	add    %edx,%eax
  803341:	48                   	dec    %eax
  803342:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803345:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803348:	ba 00 00 00 00       	mov    $0x0,%edx
  80334d:	f7 75 b8             	divl   -0x48(%ebp)
  803350:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803353:	29 d0                	sub    %edx,%eax
  803355:	8d 50 fc             	lea    -0x4(%eax),%edx
  803358:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80335b:	01 d0                	add    %edx,%eax
  80335d:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  803362:	a1 48 a2 80 00       	mov    0x80a248,%eax
  803367:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80336d:	83 ec 0c             	sub    $0xc,%esp
  803370:	68 10 50 80 00       	push   $0x805010
  803375:	e8 ac d9 ff ff       	call   800d26 <cprintf>
  80337a:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80337d:	83 ec 08             	sub    $0x8,%esp
  803380:	ff 75 bc             	pushl  -0x44(%ebp)
  803383:	68 15 50 80 00       	push   $0x805015
  803388:	e8 99 d9 ff ff       	call   800d26 <cprintf>
  80338d:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803390:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803397:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80339a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80339d:	01 d0                	add    %edx,%eax
  80339f:	48                   	dec    %eax
  8033a0:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8033a3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8033ab:	f7 75 b0             	divl   -0x50(%ebp)
  8033ae:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033b1:	29 d0                	sub    %edx,%eax
  8033b3:	83 ec 04             	sub    $0x4,%esp
  8033b6:	6a 01                	push   $0x1
  8033b8:	50                   	push   %eax
  8033b9:	ff 75 bc             	pushl  -0x44(%ebp)
  8033bc:	e8 51 f5 ff ff       	call   802912 <set_block_data>
  8033c1:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8033c4:	83 ec 0c             	sub    $0xc,%esp
  8033c7:	ff 75 bc             	pushl  -0x44(%ebp)
  8033ca:	e8 36 04 00 00       	call   803805 <free_block>
  8033cf:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8033d2:	83 ec 0c             	sub    $0xc,%esp
  8033d5:	ff 75 08             	pushl  0x8(%ebp)
  8033d8:	e8 20 fa ff ff       	call   802dfd <alloc_block_BF>
  8033dd:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8033e0:	c9                   	leave  
  8033e1:	c3                   	ret    

008033e2 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8033e2:	55                   	push   %ebp
  8033e3:	89 e5                	mov    %esp,%ebp
  8033e5:	53                   	push   %ebx
  8033e6:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8033e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8033f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033fb:	74 1e                	je     80341b <merging+0x39>
  8033fd:	ff 75 08             	pushl  0x8(%ebp)
  803400:	e8 bc f1 ff ff       	call   8025c1 <get_block_size>
  803405:	83 c4 04             	add    $0x4,%esp
  803408:	89 c2                	mov    %eax,%edx
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	01 d0                	add    %edx,%eax
  80340f:	3b 45 10             	cmp    0x10(%ebp),%eax
  803412:	75 07                	jne    80341b <merging+0x39>
		prev_is_free = 1;
  803414:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80341b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80341f:	74 1e                	je     80343f <merging+0x5d>
  803421:	ff 75 10             	pushl  0x10(%ebp)
  803424:	e8 98 f1 ff ff       	call   8025c1 <get_block_size>
  803429:	83 c4 04             	add    $0x4,%esp
  80342c:	89 c2                	mov    %eax,%edx
  80342e:	8b 45 10             	mov    0x10(%ebp),%eax
  803431:	01 d0                	add    %edx,%eax
  803433:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803436:	75 07                	jne    80343f <merging+0x5d>
		next_is_free = 1;
  803438:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80343f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803443:	0f 84 cc 00 00 00    	je     803515 <merging+0x133>
  803449:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80344d:	0f 84 c2 00 00 00    	je     803515 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803453:	ff 75 08             	pushl  0x8(%ebp)
  803456:	e8 66 f1 ff ff       	call   8025c1 <get_block_size>
  80345b:	83 c4 04             	add    $0x4,%esp
  80345e:	89 c3                	mov    %eax,%ebx
  803460:	ff 75 10             	pushl  0x10(%ebp)
  803463:	e8 59 f1 ff ff       	call   8025c1 <get_block_size>
  803468:	83 c4 04             	add    $0x4,%esp
  80346b:	01 c3                	add    %eax,%ebx
  80346d:	ff 75 0c             	pushl  0xc(%ebp)
  803470:	e8 4c f1 ff ff       	call   8025c1 <get_block_size>
  803475:	83 c4 04             	add    $0x4,%esp
  803478:	01 d8                	add    %ebx,%eax
  80347a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80347d:	6a 00                	push   $0x0
  80347f:	ff 75 ec             	pushl  -0x14(%ebp)
  803482:	ff 75 08             	pushl  0x8(%ebp)
  803485:	e8 88 f4 ff ff       	call   802912 <set_block_data>
  80348a:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80348d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803491:	75 17                	jne    8034aa <merging+0xc8>
  803493:	83 ec 04             	sub    $0x4,%esp
  803496:	68 4b 4f 80 00       	push   $0x804f4b
  80349b:	68 7d 01 00 00       	push   $0x17d
  8034a0:	68 69 4f 80 00       	push   $0x804f69
  8034a5:	e8 bf d5 ff ff       	call   800a69 <_panic>
  8034aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	85 c0                	test   %eax,%eax
  8034b1:	74 10                	je     8034c3 <merging+0xe1>
  8034b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b6:	8b 00                	mov    (%eax),%eax
  8034b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034bb:	8b 52 04             	mov    0x4(%edx),%edx
  8034be:	89 50 04             	mov    %edx,0x4(%eax)
  8034c1:	eb 0b                	jmp    8034ce <merging+0xec>
  8034c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c6:	8b 40 04             	mov    0x4(%eax),%eax
  8034c9:	a3 48 60 80 00       	mov    %eax,0x806048
  8034ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d1:	8b 40 04             	mov    0x4(%eax),%eax
  8034d4:	85 c0                	test   %eax,%eax
  8034d6:	74 0f                	je     8034e7 <merging+0x105>
  8034d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034db:	8b 40 04             	mov    0x4(%eax),%eax
  8034de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034e1:	8b 12                	mov    (%edx),%edx
  8034e3:	89 10                	mov    %edx,(%eax)
  8034e5:	eb 0a                	jmp    8034f1 <merging+0x10f>
  8034e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	a3 44 60 80 00       	mov    %eax,0x806044
  8034f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803504:	a1 50 60 80 00       	mov    0x806050,%eax
  803509:	48                   	dec    %eax
  80350a:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80350f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803510:	e9 ea 02 00 00       	jmp    8037ff <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803519:	74 3b                	je     803556 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80351b:	83 ec 0c             	sub    $0xc,%esp
  80351e:	ff 75 08             	pushl  0x8(%ebp)
  803521:	e8 9b f0 ff ff       	call   8025c1 <get_block_size>
  803526:	83 c4 10             	add    $0x10,%esp
  803529:	89 c3                	mov    %eax,%ebx
  80352b:	83 ec 0c             	sub    $0xc,%esp
  80352e:	ff 75 10             	pushl  0x10(%ebp)
  803531:	e8 8b f0 ff ff       	call   8025c1 <get_block_size>
  803536:	83 c4 10             	add    $0x10,%esp
  803539:	01 d8                	add    %ebx,%eax
  80353b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80353e:	83 ec 04             	sub    $0x4,%esp
  803541:	6a 00                	push   $0x0
  803543:	ff 75 e8             	pushl  -0x18(%ebp)
  803546:	ff 75 08             	pushl  0x8(%ebp)
  803549:	e8 c4 f3 ff ff       	call   802912 <set_block_data>
  80354e:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803551:	e9 a9 02 00 00       	jmp    8037ff <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803556:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80355a:	0f 84 2d 01 00 00    	je     80368d <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803560:	83 ec 0c             	sub    $0xc,%esp
  803563:	ff 75 10             	pushl  0x10(%ebp)
  803566:	e8 56 f0 ff ff       	call   8025c1 <get_block_size>
  80356b:	83 c4 10             	add    $0x10,%esp
  80356e:	89 c3                	mov    %eax,%ebx
  803570:	83 ec 0c             	sub    $0xc,%esp
  803573:	ff 75 0c             	pushl  0xc(%ebp)
  803576:	e8 46 f0 ff ff       	call   8025c1 <get_block_size>
  80357b:	83 c4 10             	add    $0x10,%esp
  80357e:	01 d8                	add    %ebx,%eax
  803580:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803583:	83 ec 04             	sub    $0x4,%esp
  803586:	6a 00                	push   $0x0
  803588:	ff 75 e4             	pushl  -0x1c(%ebp)
  80358b:	ff 75 10             	pushl  0x10(%ebp)
  80358e:	e8 7f f3 ff ff       	call   802912 <set_block_data>
  803593:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803596:	8b 45 10             	mov    0x10(%ebp),%eax
  803599:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80359c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035a0:	74 06                	je     8035a8 <merging+0x1c6>
  8035a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035a6:	75 17                	jne    8035bf <merging+0x1dd>
  8035a8:	83 ec 04             	sub    $0x4,%esp
  8035ab:	68 24 50 80 00       	push   $0x805024
  8035b0:	68 8d 01 00 00       	push   $0x18d
  8035b5:	68 69 4f 80 00       	push   $0x804f69
  8035ba:	e8 aa d4 ff ff       	call   800a69 <_panic>
  8035bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c2:	8b 50 04             	mov    0x4(%eax),%edx
  8035c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035c8:	89 50 04             	mov    %edx,0x4(%eax)
  8035cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035d1:	89 10                	mov    %edx,(%eax)
  8035d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d6:	8b 40 04             	mov    0x4(%eax),%eax
  8035d9:	85 c0                	test   %eax,%eax
  8035db:	74 0d                	je     8035ea <merging+0x208>
  8035dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e0:	8b 40 04             	mov    0x4(%eax),%eax
  8035e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035e6:	89 10                	mov    %edx,(%eax)
  8035e8:	eb 08                	jmp    8035f2 <merging+0x210>
  8035ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ed:	a3 44 60 80 00       	mov    %eax,0x806044
  8035f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035f8:	89 50 04             	mov    %edx,0x4(%eax)
  8035fb:	a1 50 60 80 00       	mov    0x806050,%eax
  803600:	40                   	inc    %eax
  803601:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  803606:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80360a:	75 17                	jne    803623 <merging+0x241>
  80360c:	83 ec 04             	sub    $0x4,%esp
  80360f:	68 4b 4f 80 00       	push   $0x804f4b
  803614:	68 8e 01 00 00       	push   $0x18e
  803619:	68 69 4f 80 00       	push   $0x804f69
  80361e:	e8 46 d4 ff ff       	call   800a69 <_panic>
  803623:	8b 45 0c             	mov    0xc(%ebp),%eax
  803626:	8b 00                	mov    (%eax),%eax
  803628:	85 c0                	test   %eax,%eax
  80362a:	74 10                	je     80363c <merging+0x25a>
  80362c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362f:	8b 00                	mov    (%eax),%eax
  803631:	8b 55 0c             	mov    0xc(%ebp),%edx
  803634:	8b 52 04             	mov    0x4(%edx),%edx
  803637:	89 50 04             	mov    %edx,0x4(%eax)
  80363a:	eb 0b                	jmp    803647 <merging+0x265>
  80363c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80363f:	8b 40 04             	mov    0x4(%eax),%eax
  803642:	a3 48 60 80 00       	mov    %eax,0x806048
  803647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364a:	8b 40 04             	mov    0x4(%eax),%eax
  80364d:	85 c0                	test   %eax,%eax
  80364f:	74 0f                	je     803660 <merging+0x27e>
  803651:	8b 45 0c             	mov    0xc(%ebp),%eax
  803654:	8b 40 04             	mov    0x4(%eax),%eax
  803657:	8b 55 0c             	mov    0xc(%ebp),%edx
  80365a:	8b 12                	mov    (%edx),%edx
  80365c:	89 10                	mov    %edx,(%eax)
  80365e:	eb 0a                	jmp    80366a <merging+0x288>
  803660:	8b 45 0c             	mov    0xc(%ebp),%eax
  803663:	8b 00                	mov    (%eax),%eax
  803665:	a3 44 60 80 00       	mov    %eax,0x806044
  80366a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803673:	8b 45 0c             	mov    0xc(%ebp),%eax
  803676:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80367d:	a1 50 60 80 00       	mov    0x806050,%eax
  803682:	48                   	dec    %eax
  803683:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803688:	e9 72 01 00 00       	jmp    8037ff <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80368d:	8b 45 10             	mov    0x10(%ebp),%eax
  803690:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803693:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803697:	74 79                	je     803712 <merging+0x330>
  803699:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80369d:	74 73                	je     803712 <merging+0x330>
  80369f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036a3:	74 06                	je     8036ab <merging+0x2c9>
  8036a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036a9:	75 17                	jne    8036c2 <merging+0x2e0>
  8036ab:	83 ec 04             	sub    $0x4,%esp
  8036ae:	68 dc 4f 80 00       	push   $0x804fdc
  8036b3:	68 94 01 00 00       	push   $0x194
  8036b8:	68 69 4f 80 00       	push   $0x804f69
  8036bd:	e8 a7 d3 ff ff       	call   800a69 <_panic>
  8036c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c5:	8b 10                	mov    (%eax),%edx
  8036c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ca:	89 10                	mov    %edx,(%eax)
  8036cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036cf:	8b 00                	mov    (%eax),%eax
  8036d1:	85 c0                	test   %eax,%eax
  8036d3:	74 0b                	je     8036e0 <merging+0x2fe>
  8036d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d8:	8b 00                	mov    (%eax),%eax
  8036da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036dd:	89 50 04             	mov    %edx,0x4(%eax)
  8036e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036e6:	89 10                	mov    %edx,(%eax)
  8036e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ee:	89 50 04             	mov    %edx,0x4(%eax)
  8036f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f4:	8b 00                	mov    (%eax),%eax
  8036f6:	85 c0                	test   %eax,%eax
  8036f8:	75 08                	jne    803702 <merging+0x320>
  8036fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fd:	a3 48 60 80 00       	mov    %eax,0x806048
  803702:	a1 50 60 80 00       	mov    0x806050,%eax
  803707:	40                   	inc    %eax
  803708:	a3 50 60 80 00       	mov    %eax,0x806050
  80370d:	e9 ce 00 00 00       	jmp    8037e0 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803712:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803716:	74 65                	je     80377d <merging+0x39b>
  803718:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80371c:	75 17                	jne    803735 <merging+0x353>
  80371e:	83 ec 04             	sub    $0x4,%esp
  803721:	68 b8 4f 80 00       	push   $0x804fb8
  803726:	68 95 01 00 00       	push   $0x195
  80372b:	68 69 4f 80 00       	push   $0x804f69
  803730:	e8 34 d3 ff ff       	call   800a69 <_panic>
  803735:	8b 15 48 60 80 00    	mov    0x806048,%edx
  80373b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80373e:	89 50 04             	mov    %edx,0x4(%eax)
  803741:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803744:	8b 40 04             	mov    0x4(%eax),%eax
  803747:	85 c0                	test   %eax,%eax
  803749:	74 0c                	je     803757 <merging+0x375>
  80374b:	a1 48 60 80 00       	mov    0x806048,%eax
  803750:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803753:	89 10                	mov    %edx,(%eax)
  803755:	eb 08                	jmp    80375f <merging+0x37d>
  803757:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80375a:	a3 44 60 80 00       	mov    %eax,0x806044
  80375f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803762:	a3 48 60 80 00       	mov    %eax,0x806048
  803767:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803770:	a1 50 60 80 00       	mov    0x806050,%eax
  803775:	40                   	inc    %eax
  803776:	a3 50 60 80 00       	mov    %eax,0x806050
  80377b:	eb 63                	jmp    8037e0 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80377d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803781:	75 17                	jne    80379a <merging+0x3b8>
  803783:	83 ec 04             	sub    $0x4,%esp
  803786:	68 84 4f 80 00       	push   $0x804f84
  80378b:	68 98 01 00 00       	push   $0x198
  803790:	68 69 4f 80 00       	push   $0x804f69
  803795:	e8 cf d2 ff ff       	call   800a69 <_panic>
  80379a:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8037a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037a3:	89 10                	mov    %edx,(%eax)
  8037a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037a8:	8b 00                	mov    (%eax),%eax
  8037aa:	85 c0                	test   %eax,%eax
  8037ac:	74 0d                	je     8037bb <merging+0x3d9>
  8037ae:	a1 44 60 80 00       	mov    0x806044,%eax
  8037b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037b6:	89 50 04             	mov    %edx,0x4(%eax)
  8037b9:	eb 08                	jmp    8037c3 <merging+0x3e1>
  8037bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037be:	a3 48 60 80 00       	mov    %eax,0x806048
  8037c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c6:	a3 44 60 80 00       	mov    %eax,0x806044
  8037cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d5:	a1 50 60 80 00       	mov    0x806050,%eax
  8037da:	40                   	inc    %eax
  8037db:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  8037e0:	83 ec 0c             	sub    $0xc,%esp
  8037e3:	ff 75 10             	pushl  0x10(%ebp)
  8037e6:	e8 d6 ed ff ff       	call   8025c1 <get_block_size>
  8037eb:	83 c4 10             	add    $0x10,%esp
  8037ee:	83 ec 04             	sub    $0x4,%esp
  8037f1:	6a 00                	push   $0x0
  8037f3:	50                   	push   %eax
  8037f4:	ff 75 10             	pushl  0x10(%ebp)
  8037f7:	e8 16 f1 ff ff       	call   802912 <set_block_data>
  8037fc:	83 c4 10             	add    $0x10,%esp
	}
}
  8037ff:	90                   	nop
  803800:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803803:	c9                   	leave  
  803804:	c3                   	ret    

00803805 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803805:	55                   	push   %ebp
  803806:	89 e5                	mov    %esp,%ebp
  803808:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80380b:	a1 44 60 80 00       	mov    0x806044,%eax
  803810:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803813:	a1 48 60 80 00       	mov    0x806048,%eax
  803818:	3b 45 08             	cmp    0x8(%ebp),%eax
  80381b:	73 1b                	jae    803838 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80381d:	a1 48 60 80 00       	mov    0x806048,%eax
  803822:	83 ec 04             	sub    $0x4,%esp
  803825:	ff 75 08             	pushl  0x8(%ebp)
  803828:	6a 00                	push   $0x0
  80382a:	50                   	push   %eax
  80382b:	e8 b2 fb ff ff       	call   8033e2 <merging>
  803830:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803833:	e9 8b 00 00 00       	jmp    8038c3 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803838:	a1 44 60 80 00       	mov    0x806044,%eax
  80383d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803840:	76 18                	jbe    80385a <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803842:	a1 44 60 80 00       	mov    0x806044,%eax
  803847:	83 ec 04             	sub    $0x4,%esp
  80384a:	ff 75 08             	pushl  0x8(%ebp)
  80384d:	50                   	push   %eax
  80384e:	6a 00                	push   $0x0
  803850:	e8 8d fb ff ff       	call   8033e2 <merging>
  803855:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803858:	eb 69                	jmp    8038c3 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80385a:	a1 44 60 80 00       	mov    0x806044,%eax
  80385f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803862:	eb 39                	jmp    80389d <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803867:	3b 45 08             	cmp    0x8(%ebp),%eax
  80386a:	73 29                	jae    803895 <free_block+0x90>
  80386c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386f:	8b 00                	mov    (%eax),%eax
  803871:	3b 45 08             	cmp    0x8(%ebp),%eax
  803874:	76 1f                	jbe    803895 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803879:	8b 00                	mov    (%eax),%eax
  80387b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80387e:	83 ec 04             	sub    $0x4,%esp
  803881:	ff 75 08             	pushl  0x8(%ebp)
  803884:	ff 75 f0             	pushl  -0x10(%ebp)
  803887:	ff 75 f4             	pushl  -0xc(%ebp)
  80388a:	e8 53 fb ff ff       	call   8033e2 <merging>
  80388f:	83 c4 10             	add    $0x10,%esp
			break;
  803892:	90                   	nop
		}
	}
}
  803893:	eb 2e                	jmp    8038c3 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803895:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80389a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80389d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038a1:	74 07                	je     8038aa <free_block+0xa5>
  8038a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a6:	8b 00                	mov    (%eax),%eax
  8038a8:	eb 05                	jmp    8038af <free_block+0xaa>
  8038aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8038af:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8038b4:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8038b9:	85 c0                	test   %eax,%eax
  8038bb:	75 a7                	jne    803864 <free_block+0x5f>
  8038bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038c1:	75 a1                	jne    803864 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038c3:	90                   	nop
  8038c4:	c9                   	leave  
  8038c5:	c3                   	ret    

008038c6 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8038c6:	55                   	push   %ebp
  8038c7:	89 e5                	mov    %esp,%ebp
  8038c9:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8038cc:	ff 75 08             	pushl  0x8(%ebp)
  8038cf:	e8 ed ec ff ff       	call   8025c1 <get_block_size>
  8038d4:	83 c4 04             	add    $0x4,%esp
  8038d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8038da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8038e1:	eb 17                	jmp    8038fa <copy_data+0x34>
  8038e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8038e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e9:	01 c2                	add    %eax,%edx
  8038eb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8038ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f1:	01 c8                	add    %ecx,%eax
  8038f3:	8a 00                	mov    (%eax),%al
  8038f5:	88 02                	mov    %al,(%edx)
  8038f7:	ff 45 fc             	incl   -0x4(%ebp)
  8038fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803900:	72 e1                	jb     8038e3 <copy_data+0x1d>
}
  803902:	90                   	nop
  803903:	c9                   	leave  
  803904:	c3                   	ret    

00803905 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803905:	55                   	push   %ebp
  803906:	89 e5                	mov    %esp,%ebp
  803908:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80390b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80390f:	75 23                	jne    803934 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803911:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803915:	74 13                	je     80392a <realloc_block_FF+0x25>
  803917:	83 ec 0c             	sub    $0xc,%esp
  80391a:	ff 75 0c             	pushl  0xc(%ebp)
  80391d:	e8 1f f0 ff ff       	call   802941 <alloc_block_FF>
  803922:	83 c4 10             	add    $0x10,%esp
  803925:	e9 f4 06 00 00       	jmp    80401e <realloc_block_FF+0x719>
		return NULL;
  80392a:	b8 00 00 00 00       	mov    $0x0,%eax
  80392f:	e9 ea 06 00 00       	jmp    80401e <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803934:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803938:	75 18                	jne    803952 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80393a:	83 ec 0c             	sub    $0xc,%esp
  80393d:	ff 75 08             	pushl  0x8(%ebp)
  803940:	e8 c0 fe ff ff       	call   803805 <free_block>
  803945:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803948:	b8 00 00 00 00       	mov    $0x0,%eax
  80394d:	e9 cc 06 00 00       	jmp    80401e <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803952:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803956:	77 07                	ja     80395f <realloc_block_FF+0x5a>
  803958:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80395f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803962:	83 e0 01             	and    $0x1,%eax
  803965:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80396b:	83 c0 08             	add    $0x8,%eax
  80396e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803971:	83 ec 0c             	sub    $0xc,%esp
  803974:	ff 75 08             	pushl  0x8(%ebp)
  803977:	e8 45 ec ff ff       	call   8025c1 <get_block_size>
  80397c:	83 c4 10             	add    $0x10,%esp
  80397f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803982:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803985:	83 e8 08             	sub    $0x8,%eax
  803988:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80398b:	8b 45 08             	mov    0x8(%ebp),%eax
  80398e:	83 e8 04             	sub    $0x4,%eax
  803991:	8b 00                	mov    (%eax),%eax
  803993:	83 e0 fe             	and    $0xfffffffe,%eax
  803996:	89 c2                	mov    %eax,%edx
  803998:	8b 45 08             	mov    0x8(%ebp),%eax
  80399b:	01 d0                	add    %edx,%eax
  80399d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8039a0:	83 ec 0c             	sub    $0xc,%esp
  8039a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039a6:	e8 16 ec ff ff       	call   8025c1 <get_block_size>
  8039ab:	83 c4 10             	add    $0x10,%esp
  8039ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039b4:	83 e8 08             	sub    $0x8,%eax
  8039b7:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8039ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039bd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039c0:	75 08                	jne    8039ca <realloc_block_FF+0xc5>
	{
		 return va;
  8039c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c5:	e9 54 06 00 00       	jmp    80401e <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8039ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039cd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039d0:	0f 83 e5 03 00 00    	jae    803dbb <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8039d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d9:	2b 45 0c             	sub    0xc(%ebp),%eax
  8039dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8039df:	83 ec 0c             	sub    $0xc,%esp
  8039e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039e5:	e8 f0 eb ff ff       	call   8025da <is_free_block>
  8039ea:	83 c4 10             	add    $0x10,%esp
  8039ed:	84 c0                	test   %al,%al
  8039ef:	0f 84 3b 01 00 00    	je     803b30 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8039f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039fb:	01 d0                	add    %edx,%eax
  8039fd:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a00:	83 ec 04             	sub    $0x4,%esp
  803a03:	6a 01                	push   $0x1
  803a05:	ff 75 f0             	pushl  -0x10(%ebp)
  803a08:	ff 75 08             	pushl  0x8(%ebp)
  803a0b:	e8 02 ef ff ff       	call   802912 <set_block_data>
  803a10:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803a13:	8b 45 08             	mov    0x8(%ebp),%eax
  803a16:	83 e8 04             	sub    $0x4,%eax
  803a19:	8b 00                	mov    (%eax),%eax
  803a1b:	83 e0 fe             	and    $0xfffffffe,%eax
  803a1e:	89 c2                	mov    %eax,%edx
  803a20:	8b 45 08             	mov    0x8(%ebp),%eax
  803a23:	01 d0                	add    %edx,%eax
  803a25:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803a28:	83 ec 04             	sub    $0x4,%esp
  803a2b:	6a 00                	push   $0x0
  803a2d:	ff 75 cc             	pushl  -0x34(%ebp)
  803a30:	ff 75 c8             	pushl  -0x38(%ebp)
  803a33:	e8 da ee ff ff       	call   802912 <set_block_data>
  803a38:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a3f:	74 06                	je     803a47 <realloc_block_FF+0x142>
  803a41:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a45:	75 17                	jne    803a5e <realloc_block_FF+0x159>
  803a47:	83 ec 04             	sub    $0x4,%esp
  803a4a:	68 dc 4f 80 00       	push   $0x804fdc
  803a4f:	68 f6 01 00 00       	push   $0x1f6
  803a54:	68 69 4f 80 00       	push   $0x804f69
  803a59:	e8 0b d0 ff ff       	call   800a69 <_panic>
  803a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a61:	8b 10                	mov    (%eax),%edx
  803a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a66:	89 10                	mov    %edx,(%eax)
  803a68:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a6b:	8b 00                	mov    (%eax),%eax
  803a6d:	85 c0                	test   %eax,%eax
  803a6f:	74 0b                	je     803a7c <realloc_block_FF+0x177>
  803a71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a74:	8b 00                	mov    (%eax),%eax
  803a76:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a79:	89 50 04             	mov    %edx,0x4(%eax)
  803a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a82:	89 10                	mov    %edx,(%eax)
  803a84:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a8a:	89 50 04             	mov    %edx,0x4(%eax)
  803a8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a90:	8b 00                	mov    (%eax),%eax
  803a92:	85 c0                	test   %eax,%eax
  803a94:	75 08                	jne    803a9e <realloc_block_FF+0x199>
  803a96:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a99:	a3 48 60 80 00       	mov    %eax,0x806048
  803a9e:	a1 50 60 80 00       	mov    0x806050,%eax
  803aa3:	40                   	inc    %eax
  803aa4:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803aa9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803aad:	75 17                	jne    803ac6 <realloc_block_FF+0x1c1>
  803aaf:	83 ec 04             	sub    $0x4,%esp
  803ab2:	68 4b 4f 80 00       	push   $0x804f4b
  803ab7:	68 f7 01 00 00       	push   $0x1f7
  803abc:	68 69 4f 80 00       	push   $0x804f69
  803ac1:	e8 a3 cf ff ff       	call   800a69 <_panic>
  803ac6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac9:	8b 00                	mov    (%eax),%eax
  803acb:	85 c0                	test   %eax,%eax
  803acd:	74 10                	je     803adf <realloc_block_FF+0x1da>
  803acf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad2:	8b 00                	mov    (%eax),%eax
  803ad4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad7:	8b 52 04             	mov    0x4(%edx),%edx
  803ada:	89 50 04             	mov    %edx,0x4(%eax)
  803add:	eb 0b                	jmp    803aea <realloc_block_FF+0x1e5>
  803adf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae2:	8b 40 04             	mov    0x4(%eax),%eax
  803ae5:	a3 48 60 80 00       	mov    %eax,0x806048
  803aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aed:	8b 40 04             	mov    0x4(%eax),%eax
  803af0:	85 c0                	test   %eax,%eax
  803af2:	74 0f                	je     803b03 <realloc_block_FF+0x1fe>
  803af4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af7:	8b 40 04             	mov    0x4(%eax),%eax
  803afa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803afd:	8b 12                	mov    (%edx),%edx
  803aff:	89 10                	mov    %edx,(%eax)
  803b01:	eb 0a                	jmp    803b0d <realloc_block_FF+0x208>
  803b03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b06:	8b 00                	mov    (%eax),%eax
  803b08:	a3 44 60 80 00       	mov    %eax,0x806044
  803b0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b20:	a1 50 60 80 00       	mov    0x806050,%eax
  803b25:	48                   	dec    %eax
  803b26:	a3 50 60 80 00       	mov    %eax,0x806050
  803b2b:	e9 83 02 00 00       	jmp    803db3 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803b30:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803b34:	0f 86 69 02 00 00    	jbe    803da3 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803b3a:	83 ec 04             	sub    $0x4,%esp
  803b3d:	6a 01                	push   $0x1
  803b3f:	ff 75 f0             	pushl  -0x10(%ebp)
  803b42:	ff 75 08             	pushl  0x8(%ebp)
  803b45:	e8 c8 ed ff ff       	call   802912 <set_block_data>
  803b4a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b50:	83 e8 04             	sub    $0x4,%eax
  803b53:	8b 00                	mov    (%eax),%eax
  803b55:	83 e0 fe             	and    $0xfffffffe,%eax
  803b58:	89 c2                	mov    %eax,%edx
  803b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5d:	01 d0                	add    %edx,%eax
  803b5f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803b62:	a1 50 60 80 00       	mov    0x806050,%eax
  803b67:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b6a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b6e:	75 68                	jne    803bd8 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b70:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b74:	75 17                	jne    803b8d <realloc_block_FF+0x288>
  803b76:	83 ec 04             	sub    $0x4,%esp
  803b79:	68 84 4f 80 00       	push   $0x804f84
  803b7e:	68 06 02 00 00       	push   $0x206
  803b83:	68 69 4f 80 00       	push   $0x804f69
  803b88:	e8 dc ce ff ff       	call   800a69 <_panic>
  803b8d:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803b93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b96:	89 10                	mov    %edx,(%eax)
  803b98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b9b:	8b 00                	mov    (%eax),%eax
  803b9d:	85 c0                	test   %eax,%eax
  803b9f:	74 0d                	je     803bae <realloc_block_FF+0x2a9>
  803ba1:	a1 44 60 80 00       	mov    0x806044,%eax
  803ba6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ba9:	89 50 04             	mov    %edx,0x4(%eax)
  803bac:	eb 08                	jmp    803bb6 <realloc_block_FF+0x2b1>
  803bae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb1:	a3 48 60 80 00       	mov    %eax,0x806048
  803bb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb9:	a3 44 60 80 00       	mov    %eax,0x806044
  803bbe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bc8:	a1 50 60 80 00       	mov    0x806050,%eax
  803bcd:	40                   	inc    %eax
  803bce:	a3 50 60 80 00       	mov    %eax,0x806050
  803bd3:	e9 b0 01 00 00       	jmp    803d88 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803bd8:	a1 44 60 80 00       	mov    0x806044,%eax
  803bdd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803be0:	76 68                	jbe    803c4a <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803be2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803be6:	75 17                	jne    803bff <realloc_block_FF+0x2fa>
  803be8:	83 ec 04             	sub    $0x4,%esp
  803beb:	68 84 4f 80 00       	push   $0x804f84
  803bf0:	68 0b 02 00 00       	push   $0x20b
  803bf5:	68 69 4f 80 00       	push   $0x804f69
  803bfa:	e8 6a ce ff ff       	call   800a69 <_panic>
  803bff:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803c05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c08:	89 10                	mov    %edx,(%eax)
  803c0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c0d:	8b 00                	mov    (%eax),%eax
  803c0f:	85 c0                	test   %eax,%eax
  803c11:	74 0d                	je     803c20 <realloc_block_FF+0x31b>
  803c13:	a1 44 60 80 00       	mov    0x806044,%eax
  803c18:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c1b:	89 50 04             	mov    %edx,0x4(%eax)
  803c1e:	eb 08                	jmp    803c28 <realloc_block_FF+0x323>
  803c20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c23:	a3 48 60 80 00       	mov    %eax,0x806048
  803c28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2b:	a3 44 60 80 00       	mov    %eax,0x806044
  803c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c3a:	a1 50 60 80 00       	mov    0x806050,%eax
  803c3f:	40                   	inc    %eax
  803c40:	a3 50 60 80 00       	mov    %eax,0x806050
  803c45:	e9 3e 01 00 00       	jmp    803d88 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c4a:	a1 44 60 80 00       	mov    0x806044,%eax
  803c4f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c52:	73 68                	jae    803cbc <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c54:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c58:	75 17                	jne    803c71 <realloc_block_FF+0x36c>
  803c5a:	83 ec 04             	sub    $0x4,%esp
  803c5d:	68 b8 4f 80 00       	push   $0x804fb8
  803c62:	68 10 02 00 00       	push   $0x210
  803c67:	68 69 4f 80 00       	push   $0x804f69
  803c6c:	e8 f8 cd ff ff       	call   800a69 <_panic>
  803c71:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803c77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c7a:	89 50 04             	mov    %edx,0x4(%eax)
  803c7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c80:	8b 40 04             	mov    0x4(%eax),%eax
  803c83:	85 c0                	test   %eax,%eax
  803c85:	74 0c                	je     803c93 <realloc_block_FF+0x38e>
  803c87:	a1 48 60 80 00       	mov    0x806048,%eax
  803c8c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c8f:	89 10                	mov    %edx,(%eax)
  803c91:	eb 08                	jmp    803c9b <realloc_block_FF+0x396>
  803c93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c96:	a3 44 60 80 00       	mov    %eax,0x806044
  803c9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c9e:	a3 48 60 80 00       	mov    %eax,0x806048
  803ca3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cac:	a1 50 60 80 00       	mov    0x806050,%eax
  803cb1:	40                   	inc    %eax
  803cb2:	a3 50 60 80 00       	mov    %eax,0x806050
  803cb7:	e9 cc 00 00 00       	jmp    803d88 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803cbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803cc3:	a1 44 60 80 00       	mov    0x806044,%eax
  803cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ccb:	e9 8a 00 00 00       	jmp    803d5a <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803cd6:	73 7a                	jae    803d52 <realloc_block_FF+0x44d>
  803cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdb:	8b 00                	mov    (%eax),%eax
  803cdd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ce0:	73 70                	jae    803d52 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803ce2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ce6:	74 06                	je     803cee <realloc_block_FF+0x3e9>
  803ce8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cec:	75 17                	jne    803d05 <realloc_block_FF+0x400>
  803cee:	83 ec 04             	sub    $0x4,%esp
  803cf1:	68 dc 4f 80 00       	push   $0x804fdc
  803cf6:	68 1a 02 00 00       	push   $0x21a
  803cfb:	68 69 4f 80 00       	push   $0x804f69
  803d00:	e8 64 cd ff ff       	call   800a69 <_panic>
  803d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d08:	8b 10                	mov    (%eax),%edx
  803d0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d0d:	89 10                	mov    %edx,(%eax)
  803d0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d12:	8b 00                	mov    (%eax),%eax
  803d14:	85 c0                	test   %eax,%eax
  803d16:	74 0b                	je     803d23 <realloc_block_FF+0x41e>
  803d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1b:	8b 00                	mov    (%eax),%eax
  803d1d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d20:	89 50 04             	mov    %edx,0x4(%eax)
  803d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d26:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d29:	89 10                	mov    %edx,(%eax)
  803d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d31:	89 50 04             	mov    %edx,0x4(%eax)
  803d34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d37:	8b 00                	mov    (%eax),%eax
  803d39:	85 c0                	test   %eax,%eax
  803d3b:	75 08                	jne    803d45 <realloc_block_FF+0x440>
  803d3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d40:	a3 48 60 80 00       	mov    %eax,0x806048
  803d45:	a1 50 60 80 00       	mov    0x806050,%eax
  803d4a:	40                   	inc    %eax
  803d4b:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  803d50:	eb 36                	jmp    803d88 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d52:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d5e:	74 07                	je     803d67 <realloc_block_FF+0x462>
  803d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d63:	8b 00                	mov    (%eax),%eax
  803d65:	eb 05                	jmp    803d6c <realloc_block_FF+0x467>
  803d67:	b8 00 00 00 00       	mov    $0x0,%eax
  803d6c:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803d71:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803d76:	85 c0                	test   %eax,%eax
  803d78:	0f 85 52 ff ff ff    	jne    803cd0 <realloc_block_FF+0x3cb>
  803d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d82:	0f 85 48 ff ff ff    	jne    803cd0 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d88:	83 ec 04             	sub    $0x4,%esp
  803d8b:	6a 00                	push   $0x0
  803d8d:	ff 75 d8             	pushl  -0x28(%ebp)
  803d90:	ff 75 d4             	pushl  -0x2c(%ebp)
  803d93:	e8 7a eb ff ff       	call   802912 <set_block_data>
  803d98:	83 c4 10             	add    $0x10,%esp
				return va;
  803d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9e:	e9 7b 02 00 00       	jmp    80401e <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803da3:	83 ec 0c             	sub    $0xc,%esp
  803da6:	68 59 50 80 00       	push   $0x805059
  803dab:	e8 76 cf ff ff       	call   800d26 <cprintf>
  803db0:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803db3:	8b 45 08             	mov    0x8(%ebp),%eax
  803db6:	e9 63 02 00 00       	jmp    80401e <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dbe:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803dc1:	0f 86 4d 02 00 00    	jbe    804014 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803dc7:	83 ec 0c             	sub    $0xc,%esp
  803dca:	ff 75 e4             	pushl  -0x1c(%ebp)
  803dcd:	e8 08 e8 ff ff       	call   8025da <is_free_block>
  803dd2:	83 c4 10             	add    $0x10,%esp
  803dd5:	84 c0                	test   %al,%al
  803dd7:	0f 84 37 02 00 00    	je     804014 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803de0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803de3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803de6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803de9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803dec:	76 38                	jbe    803e26 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803dee:	83 ec 0c             	sub    $0xc,%esp
  803df1:	ff 75 08             	pushl  0x8(%ebp)
  803df4:	e8 0c fa ff ff       	call   803805 <free_block>
  803df9:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803dfc:	83 ec 0c             	sub    $0xc,%esp
  803dff:	ff 75 0c             	pushl  0xc(%ebp)
  803e02:	e8 3a eb ff ff       	call   802941 <alloc_block_FF>
  803e07:	83 c4 10             	add    $0x10,%esp
  803e0a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803e0d:	83 ec 08             	sub    $0x8,%esp
  803e10:	ff 75 c0             	pushl  -0x40(%ebp)
  803e13:	ff 75 08             	pushl  0x8(%ebp)
  803e16:	e8 ab fa ff ff       	call   8038c6 <copy_data>
  803e1b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803e1e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e21:	e9 f8 01 00 00       	jmp    80401e <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803e26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e29:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803e2c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803e2f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803e33:	0f 87 a0 00 00 00    	ja     803ed9 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803e39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e3d:	75 17                	jne    803e56 <realloc_block_FF+0x551>
  803e3f:	83 ec 04             	sub    $0x4,%esp
  803e42:	68 4b 4f 80 00       	push   $0x804f4b
  803e47:	68 38 02 00 00       	push   $0x238
  803e4c:	68 69 4f 80 00       	push   $0x804f69
  803e51:	e8 13 cc ff ff       	call   800a69 <_panic>
  803e56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e59:	8b 00                	mov    (%eax),%eax
  803e5b:	85 c0                	test   %eax,%eax
  803e5d:	74 10                	je     803e6f <realloc_block_FF+0x56a>
  803e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e62:	8b 00                	mov    (%eax),%eax
  803e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e67:	8b 52 04             	mov    0x4(%edx),%edx
  803e6a:	89 50 04             	mov    %edx,0x4(%eax)
  803e6d:	eb 0b                	jmp    803e7a <realloc_block_FF+0x575>
  803e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e72:	8b 40 04             	mov    0x4(%eax),%eax
  803e75:	a3 48 60 80 00       	mov    %eax,0x806048
  803e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e7d:	8b 40 04             	mov    0x4(%eax),%eax
  803e80:	85 c0                	test   %eax,%eax
  803e82:	74 0f                	je     803e93 <realloc_block_FF+0x58e>
  803e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e87:	8b 40 04             	mov    0x4(%eax),%eax
  803e8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e8d:	8b 12                	mov    (%edx),%edx
  803e8f:	89 10                	mov    %edx,(%eax)
  803e91:	eb 0a                	jmp    803e9d <realloc_block_FF+0x598>
  803e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e96:	8b 00                	mov    (%eax),%eax
  803e98:	a3 44 60 80 00       	mov    %eax,0x806044
  803e9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eb0:	a1 50 60 80 00       	mov    0x806050,%eax
  803eb5:	48                   	dec    %eax
  803eb6:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ebe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ec1:	01 d0                	add    %edx,%eax
  803ec3:	83 ec 04             	sub    $0x4,%esp
  803ec6:	6a 01                	push   $0x1
  803ec8:	50                   	push   %eax
  803ec9:	ff 75 08             	pushl  0x8(%ebp)
  803ecc:	e8 41 ea ff ff       	call   802912 <set_block_data>
  803ed1:	83 c4 10             	add    $0x10,%esp
  803ed4:	e9 36 01 00 00       	jmp    80400f <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803ed9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803edc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803edf:	01 d0                	add    %edx,%eax
  803ee1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803ee4:	83 ec 04             	sub    $0x4,%esp
  803ee7:	6a 01                	push   $0x1
  803ee9:	ff 75 f0             	pushl  -0x10(%ebp)
  803eec:	ff 75 08             	pushl  0x8(%ebp)
  803eef:	e8 1e ea ff ff       	call   802912 <set_block_data>
  803ef4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  803efa:	83 e8 04             	sub    $0x4,%eax
  803efd:	8b 00                	mov    (%eax),%eax
  803eff:	83 e0 fe             	and    $0xfffffffe,%eax
  803f02:	89 c2                	mov    %eax,%edx
  803f04:	8b 45 08             	mov    0x8(%ebp),%eax
  803f07:	01 d0                	add    %edx,%eax
  803f09:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f10:	74 06                	je     803f18 <realloc_block_FF+0x613>
  803f12:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803f16:	75 17                	jne    803f2f <realloc_block_FF+0x62a>
  803f18:	83 ec 04             	sub    $0x4,%esp
  803f1b:	68 dc 4f 80 00       	push   $0x804fdc
  803f20:	68 44 02 00 00       	push   $0x244
  803f25:	68 69 4f 80 00       	push   $0x804f69
  803f2a:	e8 3a cb ff ff       	call   800a69 <_panic>
  803f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f32:	8b 10                	mov    (%eax),%edx
  803f34:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f37:	89 10                	mov    %edx,(%eax)
  803f39:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f3c:	8b 00                	mov    (%eax),%eax
  803f3e:	85 c0                	test   %eax,%eax
  803f40:	74 0b                	je     803f4d <realloc_block_FF+0x648>
  803f42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f45:	8b 00                	mov    (%eax),%eax
  803f47:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f4a:	89 50 04             	mov    %edx,0x4(%eax)
  803f4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f50:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f53:	89 10                	mov    %edx,(%eax)
  803f55:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f5b:	89 50 04             	mov    %edx,0x4(%eax)
  803f5e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f61:	8b 00                	mov    (%eax),%eax
  803f63:	85 c0                	test   %eax,%eax
  803f65:	75 08                	jne    803f6f <realloc_block_FF+0x66a>
  803f67:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f6a:	a3 48 60 80 00       	mov    %eax,0x806048
  803f6f:	a1 50 60 80 00       	mov    0x806050,%eax
  803f74:	40                   	inc    %eax
  803f75:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f7e:	75 17                	jne    803f97 <realloc_block_FF+0x692>
  803f80:	83 ec 04             	sub    $0x4,%esp
  803f83:	68 4b 4f 80 00       	push   $0x804f4b
  803f88:	68 45 02 00 00       	push   $0x245
  803f8d:	68 69 4f 80 00       	push   $0x804f69
  803f92:	e8 d2 ca ff ff       	call   800a69 <_panic>
  803f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9a:	8b 00                	mov    (%eax),%eax
  803f9c:	85 c0                	test   %eax,%eax
  803f9e:	74 10                	je     803fb0 <realloc_block_FF+0x6ab>
  803fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa3:	8b 00                	mov    (%eax),%eax
  803fa5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fa8:	8b 52 04             	mov    0x4(%edx),%edx
  803fab:	89 50 04             	mov    %edx,0x4(%eax)
  803fae:	eb 0b                	jmp    803fbb <realloc_block_FF+0x6b6>
  803fb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb3:	8b 40 04             	mov    0x4(%eax),%eax
  803fb6:	a3 48 60 80 00       	mov    %eax,0x806048
  803fbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fbe:	8b 40 04             	mov    0x4(%eax),%eax
  803fc1:	85 c0                	test   %eax,%eax
  803fc3:	74 0f                	je     803fd4 <realloc_block_FF+0x6cf>
  803fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc8:	8b 40 04             	mov    0x4(%eax),%eax
  803fcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fce:	8b 12                	mov    (%edx),%edx
  803fd0:	89 10                	mov    %edx,(%eax)
  803fd2:	eb 0a                	jmp    803fde <realloc_block_FF+0x6d9>
  803fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd7:	8b 00                	mov    (%eax),%eax
  803fd9:	a3 44 60 80 00       	mov    %eax,0x806044
  803fde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fe7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ff1:	a1 50 60 80 00       	mov    0x806050,%eax
  803ff6:	48                   	dec    %eax
  803ff7:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  803ffc:	83 ec 04             	sub    $0x4,%esp
  803fff:	6a 00                	push   $0x0
  804001:	ff 75 bc             	pushl  -0x44(%ebp)
  804004:	ff 75 b8             	pushl  -0x48(%ebp)
  804007:	e8 06 e9 ff ff       	call   802912 <set_block_data>
  80400c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80400f:	8b 45 08             	mov    0x8(%ebp),%eax
  804012:	eb 0a                	jmp    80401e <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804014:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80401b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80401e:	c9                   	leave  
  80401f:	c3                   	ret    

00804020 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804020:	55                   	push   %ebp
  804021:	89 e5                	mov    %esp,%ebp
  804023:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804026:	83 ec 04             	sub    $0x4,%esp
  804029:	68 60 50 80 00       	push   $0x805060
  80402e:	68 58 02 00 00       	push   $0x258
  804033:	68 69 4f 80 00       	push   $0x804f69
  804038:	e8 2c ca ff ff       	call   800a69 <_panic>

0080403d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80403d:	55                   	push   %ebp
  80403e:	89 e5                	mov    %esp,%ebp
  804040:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804043:	83 ec 04             	sub    $0x4,%esp
  804046:	68 88 50 80 00       	push   $0x805088
  80404b:	68 61 02 00 00       	push   $0x261
  804050:	68 69 4f 80 00       	push   $0x804f69
  804055:	e8 0f ca ff ff       	call   800a69 <_panic>
  80405a:	66 90                	xchg   %ax,%ax

0080405c <__udivdi3>:
  80405c:	55                   	push   %ebp
  80405d:	57                   	push   %edi
  80405e:	56                   	push   %esi
  80405f:	53                   	push   %ebx
  804060:	83 ec 1c             	sub    $0x1c,%esp
  804063:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804067:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80406b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80406f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804073:	89 ca                	mov    %ecx,%edx
  804075:	89 f8                	mov    %edi,%eax
  804077:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80407b:	85 f6                	test   %esi,%esi
  80407d:	75 2d                	jne    8040ac <__udivdi3+0x50>
  80407f:	39 cf                	cmp    %ecx,%edi
  804081:	77 65                	ja     8040e8 <__udivdi3+0x8c>
  804083:	89 fd                	mov    %edi,%ebp
  804085:	85 ff                	test   %edi,%edi
  804087:	75 0b                	jne    804094 <__udivdi3+0x38>
  804089:	b8 01 00 00 00       	mov    $0x1,%eax
  80408e:	31 d2                	xor    %edx,%edx
  804090:	f7 f7                	div    %edi
  804092:	89 c5                	mov    %eax,%ebp
  804094:	31 d2                	xor    %edx,%edx
  804096:	89 c8                	mov    %ecx,%eax
  804098:	f7 f5                	div    %ebp
  80409a:	89 c1                	mov    %eax,%ecx
  80409c:	89 d8                	mov    %ebx,%eax
  80409e:	f7 f5                	div    %ebp
  8040a0:	89 cf                	mov    %ecx,%edi
  8040a2:	89 fa                	mov    %edi,%edx
  8040a4:	83 c4 1c             	add    $0x1c,%esp
  8040a7:	5b                   	pop    %ebx
  8040a8:	5e                   	pop    %esi
  8040a9:	5f                   	pop    %edi
  8040aa:	5d                   	pop    %ebp
  8040ab:	c3                   	ret    
  8040ac:	39 ce                	cmp    %ecx,%esi
  8040ae:	77 28                	ja     8040d8 <__udivdi3+0x7c>
  8040b0:	0f bd fe             	bsr    %esi,%edi
  8040b3:	83 f7 1f             	xor    $0x1f,%edi
  8040b6:	75 40                	jne    8040f8 <__udivdi3+0x9c>
  8040b8:	39 ce                	cmp    %ecx,%esi
  8040ba:	72 0a                	jb     8040c6 <__udivdi3+0x6a>
  8040bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040c0:	0f 87 9e 00 00 00    	ja     804164 <__udivdi3+0x108>
  8040c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8040cb:	89 fa                	mov    %edi,%edx
  8040cd:	83 c4 1c             	add    $0x1c,%esp
  8040d0:	5b                   	pop    %ebx
  8040d1:	5e                   	pop    %esi
  8040d2:	5f                   	pop    %edi
  8040d3:	5d                   	pop    %ebp
  8040d4:	c3                   	ret    
  8040d5:	8d 76 00             	lea    0x0(%esi),%esi
  8040d8:	31 ff                	xor    %edi,%edi
  8040da:	31 c0                	xor    %eax,%eax
  8040dc:	89 fa                	mov    %edi,%edx
  8040de:	83 c4 1c             	add    $0x1c,%esp
  8040e1:	5b                   	pop    %ebx
  8040e2:	5e                   	pop    %esi
  8040e3:	5f                   	pop    %edi
  8040e4:	5d                   	pop    %ebp
  8040e5:	c3                   	ret    
  8040e6:	66 90                	xchg   %ax,%ax
  8040e8:	89 d8                	mov    %ebx,%eax
  8040ea:	f7 f7                	div    %edi
  8040ec:	31 ff                	xor    %edi,%edi
  8040ee:	89 fa                	mov    %edi,%edx
  8040f0:	83 c4 1c             	add    $0x1c,%esp
  8040f3:	5b                   	pop    %ebx
  8040f4:	5e                   	pop    %esi
  8040f5:	5f                   	pop    %edi
  8040f6:	5d                   	pop    %ebp
  8040f7:	c3                   	ret    
  8040f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040fd:	89 eb                	mov    %ebp,%ebx
  8040ff:	29 fb                	sub    %edi,%ebx
  804101:	89 f9                	mov    %edi,%ecx
  804103:	d3 e6                	shl    %cl,%esi
  804105:	89 c5                	mov    %eax,%ebp
  804107:	88 d9                	mov    %bl,%cl
  804109:	d3 ed                	shr    %cl,%ebp
  80410b:	89 e9                	mov    %ebp,%ecx
  80410d:	09 f1                	or     %esi,%ecx
  80410f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804113:	89 f9                	mov    %edi,%ecx
  804115:	d3 e0                	shl    %cl,%eax
  804117:	89 c5                	mov    %eax,%ebp
  804119:	89 d6                	mov    %edx,%esi
  80411b:	88 d9                	mov    %bl,%cl
  80411d:	d3 ee                	shr    %cl,%esi
  80411f:	89 f9                	mov    %edi,%ecx
  804121:	d3 e2                	shl    %cl,%edx
  804123:	8b 44 24 08          	mov    0x8(%esp),%eax
  804127:	88 d9                	mov    %bl,%cl
  804129:	d3 e8                	shr    %cl,%eax
  80412b:	09 c2                	or     %eax,%edx
  80412d:	89 d0                	mov    %edx,%eax
  80412f:	89 f2                	mov    %esi,%edx
  804131:	f7 74 24 0c          	divl   0xc(%esp)
  804135:	89 d6                	mov    %edx,%esi
  804137:	89 c3                	mov    %eax,%ebx
  804139:	f7 e5                	mul    %ebp
  80413b:	39 d6                	cmp    %edx,%esi
  80413d:	72 19                	jb     804158 <__udivdi3+0xfc>
  80413f:	74 0b                	je     80414c <__udivdi3+0xf0>
  804141:	89 d8                	mov    %ebx,%eax
  804143:	31 ff                	xor    %edi,%edi
  804145:	e9 58 ff ff ff       	jmp    8040a2 <__udivdi3+0x46>
  80414a:	66 90                	xchg   %ax,%ax
  80414c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804150:	89 f9                	mov    %edi,%ecx
  804152:	d3 e2                	shl    %cl,%edx
  804154:	39 c2                	cmp    %eax,%edx
  804156:	73 e9                	jae    804141 <__udivdi3+0xe5>
  804158:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80415b:	31 ff                	xor    %edi,%edi
  80415d:	e9 40 ff ff ff       	jmp    8040a2 <__udivdi3+0x46>
  804162:	66 90                	xchg   %ax,%ax
  804164:	31 c0                	xor    %eax,%eax
  804166:	e9 37 ff ff ff       	jmp    8040a2 <__udivdi3+0x46>
  80416b:	90                   	nop

0080416c <__umoddi3>:
  80416c:	55                   	push   %ebp
  80416d:	57                   	push   %edi
  80416e:	56                   	push   %esi
  80416f:	53                   	push   %ebx
  804170:	83 ec 1c             	sub    $0x1c,%esp
  804173:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804177:	8b 74 24 34          	mov    0x34(%esp),%esi
  80417b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80417f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804183:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804187:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80418b:	89 f3                	mov    %esi,%ebx
  80418d:	89 fa                	mov    %edi,%edx
  80418f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804193:	89 34 24             	mov    %esi,(%esp)
  804196:	85 c0                	test   %eax,%eax
  804198:	75 1a                	jne    8041b4 <__umoddi3+0x48>
  80419a:	39 f7                	cmp    %esi,%edi
  80419c:	0f 86 a2 00 00 00    	jbe    804244 <__umoddi3+0xd8>
  8041a2:	89 c8                	mov    %ecx,%eax
  8041a4:	89 f2                	mov    %esi,%edx
  8041a6:	f7 f7                	div    %edi
  8041a8:	89 d0                	mov    %edx,%eax
  8041aa:	31 d2                	xor    %edx,%edx
  8041ac:	83 c4 1c             	add    $0x1c,%esp
  8041af:	5b                   	pop    %ebx
  8041b0:	5e                   	pop    %esi
  8041b1:	5f                   	pop    %edi
  8041b2:	5d                   	pop    %ebp
  8041b3:	c3                   	ret    
  8041b4:	39 f0                	cmp    %esi,%eax
  8041b6:	0f 87 ac 00 00 00    	ja     804268 <__umoddi3+0xfc>
  8041bc:	0f bd e8             	bsr    %eax,%ebp
  8041bf:	83 f5 1f             	xor    $0x1f,%ebp
  8041c2:	0f 84 ac 00 00 00    	je     804274 <__umoddi3+0x108>
  8041c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8041cd:	29 ef                	sub    %ebp,%edi
  8041cf:	89 fe                	mov    %edi,%esi
  8041d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041d5:	89 e9                	mov    %ebp,%ecx
  8041d7:	d3 e0                	shl    %cl,%eax
  8041d9:	89 d7                	mov    %edx,%edi
  8041db:	89 f1                	mov    %esi,%ecx
  8041dd:	d3 ef                	shr    %cl,%edi
  8041df:	09 c7                	or     %eax,%edi
  8041e1:	89 e9                	mov    %ebp,%ecx
  8041e3:	d3 e2                	shl    %cl,%edx
  8041e5:	89 14 24             	mov    %edx,(%esp)
  8041e8:	89 d8                	mov    %ebx,%eax
  8041ea:	d3 e0                	shl    %cl,%eax
  8041ec:	89 c2                	mov    %eax,%edx
  8041ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041f2:	d3 e0                	shl    %cl,%eax
  8041f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041fc:	89 f1                	mov    %esi,%ecx
  8041fe:	d3 e8                	shr    %cl,%eax
  804200:	09 d0                	or     %edx,%eax
  804202:	d3 eb                	shr    %cl,%ebx
  804204:	89 da                	mov    %ebx,%edx
  804206:	f7 f7                	div    %edi
  804208:	89 d3                	mov    %edx,%ebx
  80420a:	f7 24 24             	mull   (%esp)
  80420d:	89 c6                	mov    %eax,%esi
  80420f:	89 d1                	mov    %edx,%ecx
  804211:	39 d3                	cmp    %edx,%ebx
  804213:	0f 82 87 00 00 00    	jb     8042a0 <__umoddi3+0x134>
  804219:	0f 84 91 00 00 00    	je     8042b0 <__umoddi3+0x144>
  80421f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804223:	29 f2                	sub    %esi,%edx
  804225:	19 cb                	sbb    %ecx,%ebx
  804227:	89 d8                	mov    %ebx,%eax
  804229:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80422d:	d3 e0                	shl    %cl,%eax
  80422f:	89 e9                	mov    %ebp,%ecx
  804231:	d3 ea                	shr    %cl,%edx
  804233:	09 d0                	or     %edx,%eax
  804235:	89 e9                	mov    %ebp,%ecx
  804237:	d3 eb                	shr    %cl,%ebx
  804239:	89 da                	mov    %ebx,%edx
  80423b:	83 c4 1c             	add    $0x1c,%esp
  80423e:	5b                   	pop    %ebx
  80423f:	5e                   	pop    %esi
  804240:	5f                   	pop    %edi
  804241:	5d                   	pop    %ebp
  804242:	c3                   	ret    
  804243:	90                   	nop
  804244:	89 fd                	mov    %edi,%ebp
  804246:	85 ff                	test   %edi,%edi
  804248:	75 0b                	jne    804255 <__umoddi3+0xe9>
  80424a:	b8 01 00 00 00       	mov    $0x1,%eax
  80424f:	31 d2                	xor    %edx,%edx
  804251:	f7 f7                	div    %edi
  804253:	89 c5                	mov    %eax,%ebp
  804255:	89 f0                	mov    %esi,%eax
  804257:	31 d2                	xor    %edx,%edx
  804259:	f7 f5                	div    %ebp
  80425b:	89 c8                	mov    %ecx,%eax
  80425d:	f7 f5                	div    %ebp
  80425f:	89 d0                	mov    %edx,%eax
  804261:	e9 44 ff ff ff       	jmp    8041aa <__umoddi3+0x3e>
  804266:	66 90                	xchg   %ax,%ax
  804268:	89 c8                	mov    %ecx,%eax
  80426a:	89 f2                	mov    %esi,%edx
  80426c:	83 c4 1c             	add    $0x1c,%esp
  80426f:	5b                   	pop    %ebx
  804270:	5e                   	pop    %esi
  804271:	5f                   	pop    %edi
  804272:	5d                   	pop    %ebp
  804273:	c3                   	ret    
  804274:	3b 04 24             	cmp    (%esp),%eax
  804277:	72 06                	jb     80427f <__umoddi3+0x113>
  804279:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80427d:	77 0f                	ja     80428e <__umoddi3+0x122>
  80427f:	89 f2                	mov    %esi,%edx
  804281:	29 f9                	sub    %edi,%ecx
  804283:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804287:	89 14 24             	mov    %edx,(%esp)
  80428a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80428e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804292:	8b 14 24             	mov    (%esp),%edx
  804295:	83 c4 1c             	add    $0x1c,%esp
  804298:	5b                   	pop    %ebx
  804299:	5e                   	pop    %esi
  80429a:	5f                   	pop    %edi
  80429b:	5d                   	pop    %ebp
  80429c:	c3                   	ret    
  80429d:	8d 76 00             	lea    0x0(%esi),%esi
  8042a0:	2b 04 24             	sub    (%esp),%eax
  8042a3:	19 fa                	sbb    %edi,%edx
  8042a5:	89 d1                	mov    %edx,%ecx
  8042a7:	89 c6                	mov    %eax,%esi
  8042a9:	e9 71 ff ff ff       	jmp    80421f <__umoddi3+0xb3>
  8042ae:	66 90                	xchg   %ax,%ax
  8042b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042b4:	72 ea                	jb     8042a0 <__umoddi3+0x134>
  8042b6:	89 d9                	mov    %ebx,%ecx
  8042b8:	e9 62 ff ff ff       	jmp    80421f <__umoddi3+0xb3>
